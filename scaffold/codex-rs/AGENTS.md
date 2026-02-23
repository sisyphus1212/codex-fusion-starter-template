# AGENTS for `codex-rs` (Example)

Scope: this file applies to changes under `codex-rs/**`.

Inheritance: always apply repository root `AGENTS.md` first, then this file.

## Local rules

1. Keep changes scoped by crate and run formatting for Rust changes.
2. Run tests for the changed crate first; run broader tests only when shared crates are touched.
3. If config schema-related types change, regenerate/update:
   - `codex-rs/core/config.schema.json`
4. If Rust dependencies change, keep related lockfiles in sync for the selected build workflow.
5. Update docs when behavior or public interfaces change.

## Delivery checklist

- Report changed crates and validation commands.
- Include schema/lockfile updates in the same PR when applicable.
