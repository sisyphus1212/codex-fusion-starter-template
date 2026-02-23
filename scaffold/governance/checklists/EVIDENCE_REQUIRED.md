# Evidence Requirements

For every debugging or fix cycle, archive the following:

1. Primary runtime log.
2. Reproduction command transcript.
3. Validation command transcript.
4. Classification note (Build/Runtime/Interface/etc.).
5. Summary file with pass/fail status.

Recommended path layout:

- `evidence/logs/<YYYYMMDDTHHMMSSZ>/summary.txt`
- `evidence/logs/<YYYYMMDDTHHMMSSZ>/step-*.log`
- `evidence/checkpoints/<ticket-or-task-id>.md`
