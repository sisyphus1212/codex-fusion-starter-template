#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMMANDS_FILE="${ROOT_DIR}/governance/scripts/baseline.commands"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
OUT_DIR="${ROOT_DIR}/evidence/logs/${TS}/baseline"
SUMMARY_FILE="${OUT_DIR}/summary.txt"

mkdir -p "${OUT_DIR}"

if [ ! -f "${COMMANDS_FILE}" ]; then
  echo "Missing ${COMMANDS_FILE}." | tee -a "${SUMMARY_FILE}"
  echo "Create it from baseline.commands.example before running baseline." | tee -a "${SUMMARY_FILE}"
  exit 2
fi

step=0
status=0
while IFS= read -r line || [ -n "${line}" ]; do
  cmd="${line%%#*}"
  cmd="${cmd#${cmd%%[![:space:]]*}}"
  cmd="${cmd%${cmd##*[![:space:]]}}"
  if [ -z "${cmd}" ]; then
    continue
  fi

  step=$((step + 1))
  step_log="${OUT_DIR}/step-${step}.log"
  echo "[STEP ${step}] ${cmd}" | tee -a "${SUMMARY_FILE}"
  if bash -lc "${cmd}" >"${step_log}" 2>&1; then
    echo "[STEP ${step}] PASS" | tee -a "${SUMMARY_FILE}"
  else
    echo "[STEP ${step}] FAIL" | tee -a "${SUMMARY_FILE}"
    status=1
    break
  fi
done < "${COMMANDS_FILE}"

if [ ${step} -eq 0 ]; then
  echo "No executable command found in ${COMMANDS_FILE}." | tee -a "${SUMMARY_FILE}"
  exit 2
fi

if [ ${status} -eq 0 ]; then
  echo "BASELINE=PASS" | tee -a "${SUMMARY_FILE}"
else
  echo "BASELINE=FAIL" | tee -a "${SUMMARY_FILE}"
fi

echo "Evidence: ${OUT_DIR}"
exit ${status}
