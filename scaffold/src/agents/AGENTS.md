# AGENTS for `src/agents` (Example)

Scope: this file applies to changes under `src/agents/**`.

Inheritance: always apply repository root `AGENTS.md` first, then this file.

## Local rules

1. Prefer backward-compatible changes for exported runtime interfaces.
2. If you change files under `src/agents/extensions/experimental/codex/`, also update:
   - `tests/extensions/experiemental/codex/*`
   - `docs/ref/extensions/experimental/codex/*`
3. Keep streaming and non-streaming behavior aligned when you touch runner/runtime flow.
4. Run the Python verification chain that exists in the target project (format, lint, type-check, tests).

## Delivery checklist

- State user-visible behavior change in the PR summary.
- Include minimal regression commands and results.
