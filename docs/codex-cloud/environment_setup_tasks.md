# Codex Cloud Environment Setup Tasks

This document outlines the tasks required to prepare an OpenAI Codex Cloud environment so the Codex agent can work effectively on the **ComfyUI LoRA Manager** repository.

## 1. Establish the Baseline Environment
- **Container image**: Use the default `codex-universal` image so the agent has Python, Node, Git, and common build tools pre-installed.
- **Runtime versions**: Pin Python to 3.10 or 3.11 (both are supported by `codex-universal`) to match the repository's tooling expectations.
- **Network access**: Enable internet access during setup to install Python dependencies. Runtime network access can remain disabled unless tasks require calling external APIs.

## 2. Fetch Repository Source
- Configure the environment to clone `willmiao/ComfyUI-Lora-Manager` at the desired branch or commit.
- Ensure submodules (none in this repo) are handled if added in the future.

## 3. Prepare Configuration Files
- Copy `settings.json.example` to `settings.json` when workflows need to read configuration. Update folder paths or API keys only if a task depends on real data; otherwise keep placeholder values to avoid exposing secrets.
- Persist any environment variables by appending them to `~/.bashrc` if the agent will need them across sessions (e.g., `CIVITAI_API_KEY`).

## 4. Implement the Setup Script
Create a setup script executed before the agent session:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Ensure modern packaging tools
python -m pip install --upgrade pip setuptools wheel

# Install runtime dependencies
python -m pip install -r requirements.txt

# Install extra developer utilities
python -m pip install pytest
```

- Add additional packages (e.g., `ruff`, `black`, or `pyright`) if linting/static analysis will be delegated to Codex.
- If the agent needs editable installs, append `python -m pip install -e .`.

## 5. Define Maintenance Commands
- Provide a maintenance script or AGENTS.md instructions so the agent routinely runs:
  - `pytest` (or `python -m pytest test_i18n.py`) to validate locale consistency.
  - `python standalone.py --help` or a smoke test command if the standalone server must start.
- Document how to start the web UI locally: `python standalone.py --host 0.0.0.0 --port 8188`.

## 6. Validate the Environment
- After setup, execute the test suite to confirm dependencies installed correctly: `pytest`.
- Optionally run `python test_i18n.py` for a more verbose locale report when debugging translations.
- Verify static assets load by ensuring the `static/` and `templates/` directories are present (no build step required).

## 7. Optional Enhancements
- Install formatting/linting tools used by contributors (e.g., `ruff`, `black`) to keep code style consistent.
- Add a smoke-test script that starts `standalone.py` in the background and hits `http://localhost:8188/loras` using `curl` to ensure the server boots.
- Configure caching (e.g., pip cache) if repeated runs require faster dependency installs.

## 8. Document Environment Expectations
- Record all commands and environment specifics in repository docs (e.g., AGENTS.md) so future Codex tasks follow the same workflow.
- Note any long-running commands or services the agent should avoid unless explicitly required.
