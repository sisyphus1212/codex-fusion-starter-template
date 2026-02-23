# TASK_SPLIT_RULES

Split tasks using this sequence:

1. P0 Baseline Recovery.
2. P1 Root-Cause Classification.
3. P2 Minimal Fix Implementation.
4. P3 Regression and Evidence Capture.

## Split Heuristics

1. One failing symptom chain per task.
2. One ownership boundary per task (module/subsystem).
3. One validation target per task.

## Exit Criteria per Subtask

A subtask can be closed only when:

1. The expected observable behavior is verified.
2. The evidence path is recorded in `TASKBOARD_MASTER`.
3. Remaining risk is documented.
