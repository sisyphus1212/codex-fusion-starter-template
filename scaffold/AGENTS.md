# AGENTS Guide (Fusion Template)

This fusion template combines two upstream agent-guidance styles:

- `AGENTS.openai-agents-python.md`: workflow focused on Python Agents SDK development.
- `AGENTS.openai-codex.md`: workflow focused on Rust Codex monorepo and TUI conventions.

## How to use

1. Keep this file as the top-level entry point.
2. If your project is Python Agents SDK heavy, prioritize `AGENTS.openai-agents-python.md`.
3. If your project is Rust Codex CLI/monorepo heavy, prioritize `AGENTS.openai-codex.md`.
4. For mixed projects, apply both and resolve conflicts with the stricter rule.

## Conflict resolution

- Prefer safety constraints from both files.
- Prefer toolchain/test commands that match the submodule you are editing.
- If two rules conflict, follow repository-local policies and CI-required checks first.
