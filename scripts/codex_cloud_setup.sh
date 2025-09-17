#!/usr/bin/env bash
set -euo pipefail

# Allow callers to override the Python interpreter, defaulting to python3
PYTHON_BIN="${PYTHON_BIN:-python3}"

# Resolve repository root relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

# Ensure Python packaging tools are up to date
"${PYTHON_BIN}" -m pip install --upgrade pip setuptools wheel

# Install runtime dependencies declared in requirements.txt
"${PYTHON_BIN}" -m pip install --upgrade -r requirements.txt

# Install developer tooling that Codex frequently relies on
"${PYTHON_BIN}" -m pip install --upgrade pytest black ruff

# Provide a default settings.json if one does not already exist
if [[ ! -f settings.json && -f settings.json.example ]]; then
    cp settings.json.example settings.json
fi

cat <<SCRIPT_SUMMARY
Codex Cloud environment bootstrap complete.
- Python interpreter: ${PYTHON_BIN}
- Dependencies installed from requirements.txt
- Developer tools available: pytest, black, ruff
- settings.json present: $(if [[ -f settings.json ]]; then echo "yes"; else echo "no"; fi)
SCRIPT_SUMMARY
