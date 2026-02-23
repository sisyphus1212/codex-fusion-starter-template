#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_LIST="${ROOT_DIR}/source_paths.txt"
SCAFFOLD_DIR="${ROOT_DIR}/scaffold"
REPORT_FILE="${ROOT_DIR}/gap-report.md"

missing_structural=()
while IFS= read -r rel; do
  if [ -z "${rel}" ] || [ "${rel#\#}" != "${rel}" ]; then
    continue
  fi
  if [ ! -f "${SCAFFOLD_DIR}/${rel}" ]; then
    missing_structural+=("${rel}")
  fi
done < "${SOURCE_LIST}"

# Fusion recommended additions: make it runnable as both Python SDK integration and Codex monorepo starter.
recommended_dependencies=(
  # Python side
  "pyproject.toml"
  "uv.lock"
  "Makefile"
  # Codex monorepo side
  "pnpm-lock.yaml"
  "MODULE.bazel.lock"
  "codex-rs/Cargo.lock"
  "codex-cli/bin/codex.js"
  # Shared CI side
  ".github/workflows/ci.yml"
  ".github/workflows/rust-ci.yml"
  ".github/workflows/rust-release.yml"
  ".github/workflows/rust-release-prepare.yml"
  ".github/actions/linux-code-sign/action.yml"
  ".github/actions/macos-code-sign/action.yml"
  ".github/actions/windows-code-sign/action.yml"
  ".github/scripts/install-musl-build-tools.sh"
)
missing_recommended=()
for rel in "${recommended_dependencies[@]}"; do
  if [ ! -f "${SCAFFOLD_DIR}/${rel}" ]; then
    missing_recommended+=("${rel}")
  fi
done

checks=()

# Check AGENTS conflict handling files exist.
for f in "AGENTS.md" "AGENTS.openai-agents-python.md" "AGENTS.openai-codex.md"; do
  if [ ! -f "${SCAFFOLD_DIR}/${f}" ]; then
    checks+=("missing ${f}")
  fi
done

# Check Codex schema JSON parse.
schema_path="${SCAFFOLD_DIR}/codex-rs/core/config.schema.json"
if [ -f "${schema_path}" ]; then
  if ! python3 - <<'PY' "${schema_path}" >/dev/null 2>&1; then
import json
import pathlib
import sys
json.loads(pathlib.Path(sys.argv[1]).read_text())
PY
    checks+=("invalid JSON: codex-rs/core/config.schema.json")
  fi
else
  checks+=("missing codex-rs/core/config.schema.json")
fi

# Check Python codex runtime module presence.
for f in \
  "src/agents/extensions/experimental/codex/codex.py" \
  "src/agents/extensions/experimental/codex/codex_tool.py" \
  "tests/extensions/experiemental/codex/test_codex_tool.py"
do
  if [ ! -f "${SCAFFOLD_DIR}/${f}" ]; then
    checks+=("missing ${f}")
  fi
done

# Check Codex Action workflows are still wired.
for wf in \
  ".github/workflows/issue-labeler.yml" \
  ".github/workflows/issue-deduplicator.yml"
do
  full="${SCAFFOLD_DIR}/${wf}"
  if [ -f "${full}" ]; then
    if ! rg -q 'openai/codex-action' "${full}"; then
      checks+=("${wf} missing openai/codex-action")
    fi
  else
    checks+=("missing ${wf}")
  fi
done

{
  echo "# Codex 融合模板缺漏检查报告"
  echo
  echo "- 检查时间(UTC): $(date -u '+%Y-%m-%d %H:%M:%SZ')"
  echo "- 模板根目录: codex-fusion-starter-template/scaffold"
  echo "- 对比清单: codex-fusion-starter-template/source_paths.txt"
  echo

  echo "## 1) 抽取结构完整性"
  if [ ${#missing_structural[@]} -eq 0 ]; then
    echo "- 结果: 无缺失（92/92 文件齐全）。"
  else
    echo "- 结果: 发现 ${#missing_structural[@]} 个缺失文件。"
    for rel in "${missing_structural[@]}"; do
      echo "- 缺失: ${rel}"
    done
  fi
  echo

  echo "## 2) 推荐补齐项（可运行增强）"
  if [ ${#missing_recommended[@]} -eq 0 ]; then
    echo "- 结果: 推荐依赖已覆盖。"
  else
    echo "- 结果: 发现 ${#missing_recommended[@]} 个推荐缺项。"
    for rel in "${missing_recommended[@]}"; do
      echo "- 推荐补齐: ${rel}"
    done
  fi
  echo

  echo "## 3) 关键融合能力检查"
  if [ ${#checks[@]} -eq 0 ]; then
    echo "- 结果: 融合关键能力完整（AGENTS 双来源 + Python Codex runtime + Codex schema + Codex Action）。"
  else
    for item in "${checks[@]}"; do
      echo "- 问题: ${item}"
    done
  fi
} > "${REPORT_FILE}"

echo "Generated ${REPORT_FILE}"
