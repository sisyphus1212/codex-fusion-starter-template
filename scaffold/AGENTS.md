# AGENTS Guide (Fusion Template)

This fusion template combines two upstream agent-guidance styles:

- `AGENTS.openai-agents-python.md`: workflow focused on Python Agents SDK development.
- `AGENTS.openai-codex.md`: workflow focused on Rust Codex monorepo and TUI conventions.

## Hierarchical AGENTS layout (recommended)

Use a root file plus subdirectory files so multi-stack repos can apply local rules without conflict.

Current examples in this template:

- `AGENTS.md` (this file): repository-wide baseline rules.
- `src/agents/AGENTS.md`: Python Agents SDK subtree rules.
- `codex-rs/AGENTS.md`: Rust Codex subtree rules.
- `codex-cli/AGENTS.md`: Node/launcher subtree rules.

Resolution order:

1. Root `AGENTS.md`.
2. Nearest path-matching child `AGENTS.md`.
3. If two rules conflict, use the stricter safety rule and CI-required checks.

## How to use

1. Keep this file as the top-level entry point.
2. If your project is Python Agents SDK heavy, prioritize `AGENTS.openai-agents-python.md`.
3. If your project is Rust Codex CLI/monorepo heavy, prioritize `AGENTS.openai-codex.md`.
4. For mixed projects, use hierarchical AGENTS and keep local rules close to the code they govern.

## Governance abstraction layer

In addition to AGENTS files, this template provides reusable governance artifacts under `governance/`.

1. Update `governance/PROJECT_PROFILE.yaml` with project scope and verification policy.
2. Track progress in `governance/state/TASKBOARD_MASTER.md`.
3. Resume interrupted work using `governance/state/RECOVERY_RUNBOOK.md`.
4. Split work using `governance/state/TASK_SPLIT_RULES.md`.
5. Keep reports consistent with `governance/templates/STATUS_REPORT.md`.

## Conflict resolution

- Prefer safety constraints from both upstream AGENTS files.
- Prefer toolchain/test commands that match the submodule you are editing.
- If two rules conflict, follow repository-local policies and CI-required checks first.
