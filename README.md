# Codex 融合启动模板（Fusion）

这个模板融合了两套来源：

- `codex-template`（偏 Python Agents SDK + Codex 工具运行时集成）
- `codex-openai-codex-starter-template`（偏 Codex CLI 配置体系 + Rust/Node/Bazel monorepo）

目标：取长补短，形成一个同时覆盖“Codex 运行时集成 + Codex 配置中枢 + AI 协作自动化”的工程启动模板。

## 目录

- `source_paths.txt`：融合后文件清单（含来源说明）。
- `scaffold/`：融合后的工程骨架。
- `scaffold/governance/`：可复用工程治理抽象层（Core/Profile/Adapter/State）。
- `USAGE.md`：完整使用说明（落地步骤、裁剪策略、CI 配置）。
- `compare-report.md`：两模板优缺点对比 + 融合策略。
- `manifest.json`：融合模板元数据。
- `gap-report.md`：缺漏检查结果。
- `scripts/check_template_gaps.sh`：检查脚本。

## 快速使用

```bash
bash codex-fusion-starter-template/scripts/check_template_gaps.sh
```

检查后按 `gap-report.md` 补齐依赖即可。

## 治理抽象增强

模板新增了跨项目可复用治理层 `scaffold/governance/`，把工程治理拆成三层：

- Governance Core：固定流程契约、状态文件、证据规则、输出模板。
- Project Profile：`governance/PROJECT_PROFILE.yaml` 参数化项目约束。
- Domain Adapter：`governance/scripts/*.commands` 放项目命令，不改治理框架。

## AGENTS 冲突处理

两来源都含 `AGENTS.md`。融合模板已处理为：

- `scaffold/AGENTS.md`：融合入口说明。
- `scaffold/AGENTS.openai-agents-python.md`：来源 A 原文。
- `scaffold/AGENTS.openai-codex.md`：来源 B 原文。
