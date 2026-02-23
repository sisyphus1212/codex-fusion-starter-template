# RECOVERY_RUNBOOK

Use this document to resume work after interruption.

## Resume Procedure

1. Read `governance/state/TASKBOARD_MASTER.md`.
2. Locate latest evidence folder under `evidence/logs/`.
3. Re-run baseline:
   - `./governance/scripts/run_baseline.sh`
4. Re-run minimal regression if code was modified:
   - `./governance/scripts/run_min_regression.sh`
5. Continue from the first unchecked task in the taskboard.

## Stop Conditions

Pause and request user intervention when:

- Required environment is unavailable.
- Permission or credential constraints block progress.
- A step requires writing outside approved scope.
