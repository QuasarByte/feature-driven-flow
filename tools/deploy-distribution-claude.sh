#!/usr/bin/env sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec pwsh -NoProfile -File "$SCRIPT_DIR/deploy-distribution-claude.ps1" "$@"