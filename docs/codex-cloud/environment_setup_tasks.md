# Codex Cloud Environment Setup Playbook

The instructions below expand the high-level task list into the precise steps required to bring the **ComfyUI LoRA Manager** repository online inside an OpenAI Codex Cloud workspace.

---

## 0. Launch the Workspace

1. Create a new Codex Cloud workspace (or reset an existing one) using the `codex-universal` image.
2. Select Python **3.10** or **3.11** in the runtime dropdown. (All scripts below default to `python3`, which resolves to one of these versions inside `codex-universal`.)
3. Enable outbound network access during initialization so that pip can download dependencies.
4. (Optional) Add a startup command that runs the setup script described below if you want the workspace to self-bootstrap on every reset.

---

## 1. Clone the Repository

From the workspace terminal:

```bash
cd /workspace
rm -rf ComfyUI-Lora-Manager  # start clean when resetting the workspace
git clone https://github.com/willmiao/ComfyUI-Lora-Manager.git
cd ComfyUI-Lora-Manager
```

If you need to pin a specific branch or commit, add `--branch <name>` or `git checkout <commit>` after cloning.

---

## 2. Run the Automated Bootstrap Script

The repository now includes `scripts/codex_cloud_setup.sh`, which encapsulates all required environment preparation steps (pip tooling upgrades, dependency installation, developer utilities, and the default configuration file).

```bash
./scripts/codex_cloud_setup.sh
```

### What the script does
- Upgrades `pip`, `setuptools`, and `wheel` for reliable installs.
- Installs the application dependencies from `requirements.txt`.
- Installs the developer tooling Codex frequently uses (`pytest`, `black`, and `ruff`).
- Copies `settings.json.example` to `settings.json` if the latter does not exist yet.

### Customizing the Python interpreter
If the workspace exposes multiple Python interpreters, run the script with:

```bash
PYTHON_BIN=python3.10 ./scripts/codex_cloud_setup.sh
```

The environment summary printed at the end confirms which interpreter was used and whether `settings.json` is in place.

---

## 3. Review and Edit `settings.json`

`settings.json` controls filesystem paths and optional API keys. After running the setup script:

1. Open the file: `code settings.json` (or use the Codex Cloud editor).
2. Update the placeholder model directories if the workspace has mounted model storage.
3. If you plan to exercise the CivitAI integration, add the API key you want the agent to use. Avoid hard-coding secrets into commits; instead, export them as environment variables (see below).

To persist sensitive values across terminals, append them to `~/.bashrc` and reload the shell:

```bash
echo 'export CIVITAI_API_KEY="<your key>"' >> ~/.bashrc
source ~/.bashrc
```

---

## 4. (Optional) Prime Caches for Faster Iteration

Codex Cloud workspaces are ephemeral, so caching pip downloads can save time:

```bash
mkdir -p ~/.cache/pip
```

`pip` will automatically reuse this directory on subsequent runs of the setup script.

---

## 5. Verify the Installation

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

---

## 7. Day-to-Day Maintenance

- Re-run `./scripts/codex_cloud_setup.sh` whenever `requirements.txt` changes.
- Execute `./scripts/codex_cloud_run_checks.sh` before handing the workspace to Codex to ensure locale tests still pass and the server imports cleanly.
- Use `black`/`ruff` (installed by the setup script) for formatting and linting when the task requires it:
  ```bash
  ruff check .
  black .
  ```
- Keep environment variables in `~/.bashrc` so the agent inherits them on new shells.

---

## 8. Troubleshooting Tips

| Symptom | Resolution |
| --- | --- |
| `pytest` fails with `ImportError while importing test module '/workspace/ComfyUI-Lora-Manager/__init__.py'` | Prefer `python test_i18n.py` (already handled by `codex_cloud_run_checks.sh`). The repository’s layout confuses pytest’s package discovery when invoked directly. |
| `ModuleNotFoundError` for dependencies | Re-run `./scripts/codex_cloud_setup.sh` or check that `PYTHON_BIN` points to Python 3.10/3.11. |
| Warnings about missing LoRA/checkpoint folders when running `standalone.py` | Populate the relevant paths in `settings.json` if your workflow needs real model directories; otherwise these warnings are expected in a clean workspace. |
| Need to test against a different branch | `git fetch origin && git checkout <branch>` followed by `./scripts/codex_cloud_setup.sh` ensures dependencies align with the new checkout. |

With these steps the Codex agent inherits a fully prepared development environment and a repeatable checklist for validation.
