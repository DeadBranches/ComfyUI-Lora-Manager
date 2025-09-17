# Features
## Verify the Installation

Run the bundled verification script to ensure the agent can execute the project’s regression checks:

```bash
./scripts/codex_cloud_run_checks.sh
```

This script performs two actions:

1. Executes `python test_i18n.py`, which validates locale files and prints a summary of unused keys. Using the direct Python invocation avoids `pytest`'s package discovery issues with the repository’s flat layout.
2. Captures `python standalone.py --help` output (stored at `/tmp/codex_cloud_standalone_help.txt`) to confirm the standalone server starts without raising import errors. Expect warnings about missing model directories when running in a pristine workspace.

If either step fails, re-run the setup script and address the reported error before continuing.

---

## 6. Launch the Standalone Server (When Needed)

To run the application locally inside the workspace:

```bash
python standalone.py --host 0.0.0.0 --port 8188
```

Forward port **8188** in Codex Cloud and visit `http://localhost:8188/loras` from your browser. Stop the server with `Ctrl+C` when done.
