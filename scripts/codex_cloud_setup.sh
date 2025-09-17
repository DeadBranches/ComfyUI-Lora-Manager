#!/usr/bin/env bash
set -euo pipefail

# Allow callers to override the Python interpreter, defaulting to python3
PYTHON_BIN="${PYTHON_BIN:-python3}"
INSTALL_DEV_TOOLS="${INSTALL_DEV_TOOLS:-1}"

log() {
    printf '[codex-setup] %s\n' "$1"
}

die() {
    printf 'Error: %s\n' "$1" >&2
    exit 1
}

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
    die "Python interpreter '$PYTHON_BIN' is not available. Set PYTHON_BIN to a valid interpreter (e.g. python3.11)."
fi

PYTHON_VERSION="$($PYTHON_BIN -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
PYTHON_MAJOR_MINOR="$($PYTHON_BIN -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")')"
case "$PYTHON_MAJOR_MINOR" in
    3.10|3.11) ;;
    *)
        die "Python $PYTHON_VERSION detected. Codex Cloud setup expects Python 3.10 or 3.11. Set PYTHON_BIN accordingly."
        ;;
esac

# Resolve repository root relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

PIP_CMD=("${PYTHON_BIN}" -m pip)

log "Upgrading pip tooling"
"${PIP_CMD[@]}" install --upgrade pip setuptools wheel

if [[ -f requirements.txt ]]; then
    log "Installing application dependencies from requirements.txt"
    "${PIP_CMD[@]}" install --upgrade --requirement requirements.txt
else
    log "requirements.txt not found; skipping runtime dependency installation"
fi

if [[ "${INSTALL_DEV_TOOLS}" != "0" ]]; then
    log "Installing developer utilities (pytest, black, ruff)"
    "${PIP_CMD[@]}" install --upgrade pytest black ruff
else
    log "Skipping developer utility installation (INSTALL_DEV_TOOLS=${INSTALL_DEV_TOOLS})"
fi

if [[ ! -f settings.json && -f settings.json.example ]]; then
    log "Provisioning default settings.json from template"
    cp settings.json.example settings.json
fi

SETTINGS_STATUS="missing"
if [[ -f settings.json ]]; then
    SETTINGS_STATUS="present"
fi

cat <<SCRIPT_SUMMARY
Codex Cloud environment bootstrap complete.
- Python interpreter: ${PYTHON_BIN} (${PYTHON_VERSION})
- Dependencies installed from requirements.txt: $(if [[ -f requirements.txt ]]; then echo "yes"; else echo "no"; fi)
- Developer tools installed: $(if [[ "${INSTALL_DEV_TOOLS}" != "0" ]]; then echo "yes"; else echo "no"; fi)
- settings.json status: ${SETTINGS_STATUS}
SCRIPT_SUMMARY
