# 可持续迭代功能列表

> 最近更新：`2026-02-23`  
> 生命周期：`planned` / `in_progress` / `active` / `deprecated`  
> 优先级：`P0` / `P1` / `P2`

## 已实现功能（条目式）

### 分类导航（结构化总览）

1. 模板基线与协作规范（条目：1-4）
   目标：明确模板来源、规则继承与执行计划写法，先统一协作语义再做开发。

2. 治理流程闭环（条目：5-12）
   目标：覆盖 P0-P3、任务拆解、恢复机制、证据与回归、状态汇报，形成可恢复的执行闭环。

3. Issue / PR 治理自动化（条目：13-16）
   目标：让问题分流、去重、PR 标注和触发控制自动化，减少人工治理成本。

4. 发布治理自动化（条目：17-19）
   目标：把 release PR、里程碑匹配、changelog 生成串成标准发布流水线。

5. Codex 资产与能力底座（条目：20、23-25）
   目标：沉淀提示词/评审策略、运行时参考实现、配置 schema 与协作技能库。

6. 模板完整性与缺口治理（条目：21-22）
   目标：持续检查结构完整性并显式管理“最小可运行”缺口。

1. 双源融合模板
   文件：`README.md:3`，`manifest.json:4`
   作用：融合 Python Agents 侧和 Codex CLI/Rust 侧能力，作为统一启动模板。
   关键点：保留来源元数据与文件统计，方便追溯（`manifest.json:17`）。
   生命周期：`active`
   优先级：`P0`

2. 分层 AGENTS 规则
   文件：`scaffold/AGENTS.md:8`，`scaffold/src/agents/AGENTS.md:1`，`scaffold/codex-rs/AGENTS.md:1`，`scaffold/codex-cli/AGENTS.md:1`
   作用：根规则 + 子目录规则叠加，降低多技术栈规则冲突。
   关键点：规则优先级已定义（根规则 -> 最近子目录规则 -> 更严格约束，`scaffold/AGENTS.md:19`）。
   生命周期：`active`
   优先级：`P0`

3. 上游 AGENTS 双参考保留
   文件：`scaffold/AGENTS.openai-agents-python.md:1`，`scaffold/AGENTS.openai-codex.md:1`
   作用：保留两套上游规范原文，便于按技术栈回溯规则来源。
   关键点：根 AGENTS 作为融合入口，双参考作为“可追溯原文基线”。
   生命周期：`active`
   优先级：`P1`

4. ExecPlan 执行计划规范
   文件：`scaffold/PLANS.md:1`
   作用：定义多步骤任务的“可执行、可恢复、可验证”计划写法。
   关键点：强制维护 Progress/Decision/Outcomes 等活文档区块（`scaffold/PLANS.md:37`）。
   生命周期：`active`
   优先级：`P0`

5. 治理三层抽象
   文件：`scaffold/governance/README.md:5`，`scaffold/governance/PROJECT_PROFILE.yaml:1`
   作用：把治理拆成 Core / Profile / Adapter，提升跨项目复用性。
   关键点：流程、边界、证据策略参数化（`scaffold/governance/PROJECT_PROFILE.yaml:6`）。
   生命周期：`active`
   优先级：`P0`

6. P0-P3 流程门禁
   文件：`scaffold/governance/PROJECT_PROFILE.yaml:13`
   作用：统一基线恢复、分类、最小修复、回归沉淀四阶段流程。
   关键点：每阶段有 `exit_criteria`，可用于执行判定（`scaffold/governance/PROJECT_PROFILE.yaml:17`）。
   生命周期：`active`
   优先级：`P0`

7. 任务拆解规范（非自动）
   文件：`scaffold/governance/state/TASK_SPLIT_RULES.md:1`，`scaffold/governance/state/TASKBOARD_MASTER.md:1`
   作用：定义“如何拆分任务、如何记录进度真值”的统一规范。
   关键点：当前是规范驱动（manual/spec-driven），不是自动拆解引擎（`scaffold/governance/state/TASK_SPLIT_RULES.md:3`）。
   生命周期：`active`
   优先级：`P0`

8. 中断恢复机制
   文件：`scaffold/governance/state/TASKBOARD_MASTER.md:1`，`scaffold/governance/state/RECOVERY_RUNBOOK.md:1`
   作用：保证任务中断后可按状态文件恢复推进。
   关键点：恢复步骤固定，包含 baseline/min-regression 重跑（`scaffold/governance/state/RECOVERY_RUNBOOK.md:5`）。
   生命周期：`active`
   优先级：`P0`

9. 分支与提交安全策略
   文件：`scaffold/governance/state/BRANCH_AND_COMMIT_POLICY.md:1`
   作用：统一分支命名、提交粒度、历史修改安全边界。
   关键点：显式约束“不可重写无关历史、不可回滚非本人改动”（`scaffold/governance/state/BRANCH_AND_COMMIT_POLICY.md:17`）。
   生命周期：`active`
   优先级：`P0`

10. 证据沉淀与最小回归执行器
    文件：`scaffold/governance/scripts/run_baseline.sh:1`，`scaffold/governance/scripts/run_min_regression.sh:1`，`scaffold/governance/scripts/baseline.commands.example:1`，`scaffold/governance/scripts/min_regression.commands.example:1`
    作用：执行命令清单并自动输出带时间戳的 evidence 日志。
    关键点：每步命令写入 `step-*.log`，并输出 summary 结果（`scaffold/governance/scripts/run_baseline.sh:29`，`scaffold/governance/scripts/run_min_regression.sh:29`）。
    生命周期：`active`
    优先级：`P0`

11. 治理检查清单（证据 + 回归）
    文件：`scaffold/governance/checklists/EVIDENCE_REQUIRED.md:1`，`scaffold/governance/checklists/MIN_REGRESSION.md:1`
    作用：把“必须保留哪些证据、最小回归必须做什么”固定成清单。
    关键点：证据目录结构和最小回归过门条件被显式标准化（`scaffold/governance/checklists/EVIDENCE_REQUIRED.md:13`，`scaffold/governance/checklists/MIN_REGRESSION.md:5`）。
    生命周期：`active`
    优先级：`P0`

12. 固定状态汇报模板
    文件：`scaffold/governance/templates/STATUS_REPORT.md:1`
    作用：统一每轮 debug/fix 的现象、根因、变更、复现、结果输出格式。
    关键点：强制写 Evidence Path 和 PASS/FAIL 结论（`scaffold/governance/templates/STATUS_REPORT.md:24`）。
    生命周期：`active`
    优先级：`P0`

13. Issue 自动打标
    文件：`scaffold/.github/workflows/issue-labeler.yml:1`
    作用：Issue 新建后，调用 Codex 判断标签并自动写回。
    关键点：有输出 schema 约束避免乱格式（`scaffold/.github/workflows/issue-labeler.yml:86`），后续步骤执行加标签（`scaffold/.github/workflows/issue-labeler.yml:101`）。
    生命周期：`active`
    优先级：`P1`

14. Issue 自动去重
    文件：`scaffold/.github/workflows/issue-deduplicator.yml:1`
    作用：Issue 新建后先对比全部历史，再对比 open issues（fallback），输出可能重复项评论。
    关键点：两阶段推理入口在 `scaffold/.github/workflows/issue-deduplicator.yml:89` 和 `scaffold/.github/workflows/issue-deduplicator.yml:174`，评论输出在 `scaffold/.github/workflows/issue-deduplicator.yml:304`。
    生命周期：`active`
    优先级：`P1`

15. PR 自动标注
    文件：`scaffold/.github/workflows/pr-labels.yml:1`
    作用：PR 打开/更新后，先收集 diff，再调用 Codex 自动打标签并写回。
    关键点：支持 `workflow_dispatch` 手动指定 PR（`scaffold/.github/workflows/pr-labels.yml:10`），并配置 `drop-sudo + read-only sandbox`（`scaffold/.github/workflows/pr-labels.yml:108`）。
    生命周期：`active`
    优先级：`P1`

16. Workflow 变量化触发控制（去硬编码）
    文件：`scaffold/.github/workflows/issue-labeler.yml:15`，`scaffold/.github/workflows/issue-deduplicator.yml:15`，`USAGE.md:192`
    作用：通过仓库变量控制 workflow 作用仓库和触发标签，避免模板硬编码。
    关键点：支持 `CODEX_WORKFLOW_TARGET_REPOSITORY`、`CODEX_ISSUE_LABELER_TRIGGER_LABEL`、`CODEX_ISSUE_DEDUP_TRIGGER_LABEL`（`USAGE.md:196`）。
    生命周期：`active`
    优先级：`P1`

17. Release PR 自动化
    文件：`scaffold/.github/workflows/release-pr.yml:1`，`scaffold/.github/workflows/release-pr-update.yml:1`
    作用：自动创建/更新 release PR，并接入 Codex release review。
    关键点：更新流只允许单个活跃 release PR，并使用并发组避免重复执行（`scaffold/.github/workflows/release-pr-update.yml:8`，`scaffold/.github/workflows/release-pr-update.yml:30`）。
    生命周期：`active`
    优先级：`P1`

18. 发布里程碑自动选择
    文件：`scaffold/.github/scripts/select-release-milestone.py:1`，`scaffold/.github/workflows/release-pr.yml:147`
    作用：按版本号自动匹配 milestone，并在 PR 创建/更新时自动带上。
    关键点：脚本是 best-effort，找不到 milestone 时返回空串且不阻塞发布流程（`scaffold/.github/scripts/select-release-milestone.py:4`）。
    生命周期：`active`
    优先级：`P1`

19. 发布时自动生成/更新 CHANGELOG
    文件：`scaffold/.github/workflows/release-pr.yml:86`，`scaffold/.github/workflows/release-pr-update.yml:71`，`scaffold/cliff.toml:1`
    作用：发布分支创建和 main 同步时，自动生成或刷新 `CHANGELOG.md`。
    关键点：基于 `git cliff` 按目标版本标签出 changelog（`scaffold/.github/workflows/release-pr.yml:91`）。
    生命周期：`active`
    优先级：`P1`

20. Codex CI 提示词与评审提示库
    文件：`scaffold/.github/codex/prompts/pr-labels.md:1`，`scaffold/.github/codex/prompts/release-review.md:1`，`scaffold/.github/codex/labels/codex-review.md:1`，`scaffold/.github/codex/labels/codex-rust-review.md:1`，`scaffold/.github/codex/labels/codex-triage.md:1`，`scaffold/.github/codex/labels/codex-attempt.md:1`，`scaffold/.github/codex/home/config.toml:1`
    作用：沉淀 PR 标注、发布审查、Issue/PR 评审等提示词资产，支持治理自动化复用。
    关键点：提示词与 workflow 解耦，便于独立迭代标签策略和评审规则。
    生命周期：`active`
    优先级：`P1`

21. 模板完整性检查
    文件：`scripts/check_template_gaps.sh:1`，`gap-report.md:1`
    作用：检查结构完整性、关键能力和推荐补齐项。
    关键点：已覆盖分层 AGENTS 与 release helper 脚本检查（`scripts/check_template_gaps.sh:52`，`scripts/check_template_gaps.sh:91`）。
    生命周期：`active`
    优先级：`P0`

22. 最小可运行依赖缺口基线
    文件：`gap-report.md:10`
    作用：持续暴露模板从“结构完整”到“最小可运行”之间的依赖缺口。
    关键点：当前报告列出 15 个推荐缺项，作为补齐基线（`gap-report.md:11`）。
    生命周期：`active`
    优先级：`P0`

23. Python Codex runtime 参考实现
    文件：`scaffold/src/agents/extensions/experimental/codex/`，`scaffold/tests/extensions/experiemental/codex/`，`scaffold/docs/ref/extensions/experimental/codex/`
    作用：给出 runtime 模块、测试和文档参考，实现可复用的集成样板。
    关键点：代码、文档、测试三件套齐备（各目录已存在）。
    生命周期：`active`
    优先级：`P1`

24. Codex-rs 配置中枢参考
    文件：`scaffold/codex-rs/core/config.schema.json:1`，`scaffold/codex-rs/core/src/config/schema.md:1`
    作用：提供 Codex 配置 schema 及说明，便于 CLI/引擎定制。
    关键点：schema 与文档配套存在，可作为配置中枢起点。
    生命周期：`active`
    优先级：`P1`

25. 协作技能集合
    文件：`scaffold/.agents/skills/final-release-review/SKILL.md:1`
    作用：内置代码验证、文档同步、发布审查等技能样例。
    关键点：技能目录结构完整，可按项目裁剪使用。
    生命周期：`active`
    优先级：`P1`

## 维护规则（保证可持续）

1. 新增能力时：新增一个功能条目，必须填写 `文件/作用/关键点/生命周期/优先级`。  
2. 修改能力时：同步更新对应条目，不删除历史条目。  
3. 废弃能力时：将 `生命周期` 改为 `deprecated`，并写明替代方案。  
4. 每次发版前：执行 `scripts/check_template_gaps.sh`，并刷新 `gap-report.md`。  
5. 每次治理文件变更后：同步更新 `feature-matrix.md` 对应条目。  

## 条目模板

1. <功能名称>
   文件：`<path:line>`
   作用：<一句话描述解决的问题>
   关键点：<约束、输入输出、风控点>
   生命周期：`planned|in_progress|active|deprecated`
   优先级：`P0|P1|P2`
