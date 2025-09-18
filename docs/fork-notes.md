# DeadBranches Fork Notes

This document captures the divergence between the DeadBranches fork of **ComfyUI LoRA Manager** and the upstream repository maintained by [@willmiao](https://github.com/willmiao/ComfyUI-Lora-Manager). It exists to prevent future confusion when discussing issues, workflows, or release processes.

## Why this fork exists
- Track and prototype UI/UX improvements that may not be suitable for the upstream project.
- Experiment with alternative workflows without affecting users of the upstream release.
- Provide a staging ground for DeadBranches-specific features before they are stabilized.

## Common sources of confusion
1. **Issue and pull request links** – GitHub issue numbers restart per repository. Always prefix references with the owner/repo (for example, `DeadBranches/ComfyUI-Lora-Manager#12`) so discussions stay anchored to this fork.
2. **Registry publishing workflow** – The upstream project publishes to the Comfy Registry, but this fork does not. The workflow file is retained for reference yet intentionally disabled. Treat it as documentation rather than an active pipeline.
3. **Project metadata** – The upstream `pyproject.toml` advertised registry metadata. In this fork the metadata only records dependencies; registry-specific fields have been removed to avoid implying the fork is published.
4. **Documentation links** – Historical Markdown content linked directly to the upstream repository for screenshots and downloads. Using relative paths keeps documentation self-contained and avoids implying assets live in the upstream project.

## Maintenance guidelines
- When creating or triaging issues, link to commits in this repository and mention the fork explicitly in summaries if there is any overlap with upstream work.
- Keep documentation changes synchronized with this fork’s UI/UX direction. Reference upstream docs only when explicitly comparing behaviour.
- If registry publishing ever becomes relevant, document the required changes in this file before re-enabling the workflow so the intent remains clear.

For contributors who need the production-ready version, direct them to the upstream project at [willmiao/ComfyUI-Lora-Manager](https://github.com/willmiao/ComfyUI-Lora-Manager).
