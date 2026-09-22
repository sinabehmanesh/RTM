#!/usr/bin/env sh
set -eu

MIN_GIT_VERSION="2.20.0"
MIN_GO_VERSION="1.22.5"

INSTALL_ROOT="${RTM_INSTALL_DIR:-$HOME/.local/share/rtm}"
SOURCE_DIR="$INSTALL_ROOT/source"
BIN_DIR="${RTM_BIN_DIR:-$HOME/.local/bin}"
BINARY="$BIN_DIR/rtm"
TEMP_BINARY="$BIN_DIR/.rtm-update-$$"

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Error: '$1' is required but was not found in PATH." >&2
        exit 1
    fi
}

normalize_version() {
    printf '%s\n' "$1" | sed -n 's/^\([0-9][0-9]*\(\.[0-9][0-9]*\)\{0,2\}\).*/\1/p'
}

version_at_least() {
    current=$(normalize_version "$1")
    required=$(normalize_version "$2")

    [ -n "$current" ] || return 1
    [ -n "$required" ] || return 1

    old_ifs=$IFS
    IFS=.
    set -- $current
    current_major=${1:-0}
    current_minor=${2:-0}
    current_patch=${3:-0}

    set -- $required
    required_major=${1:-0}
    required_minor=${2:-0}
    required_patch=${3:-0}
    IFS=$old_ifs

    if [ "$current_major" -gt "$required_major" ]; then
        return 0
    fi
    if [ "$current_major" -lt "$required_major" ]; then
        return 1
    fi
    if [ "$current_minor" -gt "$required_minor" ]; then
        return 0
    fi
    if [ "$current_minor" -lt "$required_minor" ]; then
        return 1
    fi
    [ "$current_patch" -ge "$required_patch" ]
}

cleanup() {
    rm -f "$TEMP_BINARY"
}
trap cleanup 0 1 2 15

require_command git
require_command go

GIT_VERSION=$(git --version | sed 's/^git version //')
GO_VERSION=$(go version | sed -n 's/^go version go\([^ ]*\).*/\1/p')

if ! version_at_least "$GIT_VERSION" "$MIN_GIT_VERSION"; then
    echo "Error: Git $MIN_GIT_VERSION or newer is required. Found Git $GIT_VERSION." >&2
    exit 1
fi

if ! version_at_least "$GO_VERSION" "$MIN_GO_VERSION"; then
    echo "Error: Go $MIN_GO_VERSION or newer is required. Found Go $GO_VERSION." >&2
    exit 1
fi

if [ ! -d "$SOURCE_DIR/.git" ]; then
    echo "Error: RTM installation was not found at $SOURCE_DIR." >&2
    echo "Run the RTM installer first, then run the updater again." >&2
    exit 1
fi

mkdir -p "$BIN_DIR"

echo "Updating RTM source..."
git -C "$SOURCE_DIR" fetch --depth 1 origin main
git -C "$SOURCE_DIR" checkout -B main origin/main

echo "Building latest RTM..."
(
    cd "$SOURCE_DIR"
    go build -o "$TEMP_BINARY" .
)
chmod +x "$TEMP_BINARY"
mv "$TEMP_BINARY" "$BINARY"

echo "RTM updated: $BINARY"
