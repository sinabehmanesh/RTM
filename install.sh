#!/usr/bin/env sh
set -eu

MIN_GIT_VERSION="2.20.0"
MIN_GO_VERSION="1.22.5"

REPO_URL="${RTM_REPO_URL:-https://github.com/sinabehmanesh/RTM.git}"
INSTALL_ROOT="${RTM_INSTALL_DIR:-$HOME/.local/share/rtm}"
SOURCE_DIR="$INSTALL_ROOT/source"
BIN_DIR="${RTM_BIN_DIR:-$HOME/.local/bin}"
BINARY="$BIN_DIR/rtm"

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

require_command git
require_command go

GIT_VERSION=$(git --version | sed 's/^git version //')
GO_VERSION=$(go version | sed -n 's/^go version go\([^ ]*\).*/\1/p')

if ! version_at_least "$GIT_VERSION" "$MIN_GIT_VERSION"; then
    echo "Error: Git $MIN_GIT_VERSION or newer is required. Found Git $GIT_VERSION." >&2
    echo "Install or update Git, then run this installer again." >&2
    exit 1
fi

if ! version_at_least "$GO_VERSION" "$MIN_GO_VERSION"; then
    echo "Error: Go $MIN_GO_VERSION or newer is required. Found Go $GO_VERSION." >&2
    echo "Install or update Go, then run this installer again." >&2
    exit 1
fi

echo "Git $GIT_VERSION detected."
echo "Go $GO_VERSION detected."

mkdir -p "$INSTALL_ROOT" "$BIN_DIR"

if [ -d "$SOURCE_DIR/.git" ]; then
    echo "Updating RTM source..."
    git -C "$SOURCE_DIR" fetch --depth 1 origin main
    git -C "$SOURCE_DIR" checkout -B main origin/main
elif [ -e "$SOURCE_DIR" ]; then
    echo "Error: $SOURCE_DIR exists but is not an RTM git checkout." >&2
    exit 1
else
    echo "Cloning RTM..."
    git clone --depth 1 --branch main "$REPO_URL" "$SOURCE_DIR"
fi

echo "Building RTM..."
(
    cd "$SOURCE_DIR"
    go build -o "$BINARY" .
)
chmod +x "$BINARY"

case ":$PATH:" in
    *":$BIN_DIR:"*)
        ;;
    *)
        shell_name=$(basename "${SHELL:-sh}")
        case "$shell_name" in
            bash) profile="$HOME/.bashrc" ;;
            zsh) profile="$HOME/.zshrc" ;;
            *) profile="$HOME/.profile" ;;
        esac

        touch "$profile"
        if ! grep -F "$BIN_DIR" "$profile" >/dev/null 2>&1; then
            printf '\n# RTM\nexport PATH="%s:$PATH"\n' "$BIN_DIR" >> "$profile"
        fi

        echo "Added $BIN_DIR to PATH in $profile"
        echo "Open a new terminal or run: . $profile"
        ;;
esac

echo "RTM installed: $BINARY"
