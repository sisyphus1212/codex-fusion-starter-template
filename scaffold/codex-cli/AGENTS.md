# AGENTS for `codex-cli` (Example)

Scope: this file applies to changes under `codex-cli/**`.

Inheritance: always apply repository root `AGENTS.md` first, then this file.

## Local rules

1. Keep package metadata and launcher behavior aligned with target platforms.
2. Treat binary resolution paths (`vendor/<target>/...`) as compatibility-sensitive.
3. If install/link flow changes, validate at least one command-path scenario end to end.
4. Keep workflow prompts/output schemas compatible when CLI output contracts are used in automation.

## Delivery checklist

- Document affected platform/target assumptions.
- Include a minimal install/link/execute verification note.
