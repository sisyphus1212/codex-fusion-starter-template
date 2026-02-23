# Governance Layer (Reusable)

This folder provides a reusable engineering-governance abstraction that can be applied to Python, C/C++, Rust, or mixed projects.

It intentionally separates governance into three layers:

1. Governance Core: stable process contracts and mandatory artifacts.
2. Project Profile: project-specific parameters in `PROJECT_PROFILE.yaml`.
3. Domain Adapter: project-specific commands implemented in `governance/scripts/*.commands`.

## Core Guarantees

- Every change follows the same phase gate: P0 baseline, P1 triage, P2 minimal fix, P3 regression and evidence.
- Every step produces evidence under `evidence/`.
- Every session can resume from `governance/state/` files.
- Every report follows a fixed structure for consistency.

## Files You Should Customize First

1. `governance/PROJECT_PROFILE.yaml`
2. `governance/scripts/baseline.commands`
3. `governance/scripts/min_regression.commands`
4. `governance/state/TASKBOARD_MASTER.md`

## Recommended Startup Commands

```bash
cp governance/scripts/baseline.commands.example governance/scripts/baseline.commands
cp governance/scripts/min_regression.commands.example governance/scripts/min_regression.commands

# Fill your own commands.
$EDITOR governance/scripts/baseline.commands
$EDITOR governance/scripts/min_regression.commands

# Execute governance gates.
./governance/scripts/run_baseline.sh
./governance/scripts/run_min_regression.sh
```
