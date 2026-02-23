# Minimal Regression Checklist

Run this checklist after every code change.

1. Build or package step succeeds.
2. Minimal runtime smoke step succeeds.
3. One critical interface check succeeds.
4. At least one host-to-target and target-to-host connectivity check succeeds if networking exists.
5. Evidence is archived under `evidence/logs/<timestamp>/`.
6. `governance/state/TASKBOARD_MASTER.md` is updated with evidence paths.

If any item fails, do not declare PASS.
