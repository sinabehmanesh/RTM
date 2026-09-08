#!/usr/bin/env sh
set -eu

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

require_command git
require_command go

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
