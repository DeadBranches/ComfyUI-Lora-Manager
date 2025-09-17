#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python3}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

"${PYTHON_BIN}" test_i18n.py
"${PYTHON_BIN}" standalone.py --help >/tmp/codex_cloud_standalone_help.txt

echo "Codex Cloud verification complete."
echo "- test_i18n.py -> passed"
echo "- standalone.py --help output recorded at /tmp/codex_cloud_standalone_help.txt"
