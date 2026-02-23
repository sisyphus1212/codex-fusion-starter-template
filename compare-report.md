# 两模板工程对比与融合总结

## 对比结论（量化）

- 模板 A（`codex-template`）: 54 文件
- 模板 B（`codex-openai-codex-starter-template`）: 37 文件
- 交集: 1 文件（仅 `AGENTS.md`）
- 融合并集: 92 文件（含 3 个 AGENTS 处理文件）

## 模板 A 优缺点（openai-agents-python 抽取）

优点：
- 覆盖 Codex 在 Python Agents SDK 里的完整运行时扩展实现与测试。
- 包含本地技能体系（`.agents/skills/**`）与 PR/release 协作流程。
- 对 SDK 内集成场景（`src/agents/extensions/experimental/codex/**`）非常完整。

不足：
- 缺少上游 Codex CLI 的配置中枢文件（`config.schema.json`、exec policy 示例、monorepo 构建配置）。
- 作为独立工程模板时，缺少部分基础依赖文件（pyproject/lock/build 基座）。

## 模板 B 优缺点（openai/codex 抽取）

优点：
- 覆盖 Codex CLI 的核心配置体系：`~/.codex/config.toml` 文档、schema、策略样例。
- 覆盖 GitHub Codex Action 自动化（issue label/deduplicate）和 `.github/codex/*` 提示配置。
- 覆盖 Rust + Node + Bazel 的 monorepo 构建入口与开发容器配置。

不足：
- 不含 Python Agents SDK 侧的 Codex 运行时封装实现和测试样例。
- 本地协作技能体系（`.agents/skills/**`）较少，不利于通用代码代理流水线复用。

## 融合策略（取长补短）

融合模板采取并集策略：

1. 保留模板 A 的 SDK 运行时 + 测试 + 技能体系。
2. 保留模板 B 的 config schema + exec policy + monorepo 构建配置 + Codex Action 自动化。
3. 对唯一冲突的 `AGENTS.md` 使用三文件策略（融合入口 + 两份原文）。

## 融合后适配建议

- 如果你是 Python 为主：先用 `src/agents/extensions/experimental/codex/**` + `.agents/skills/**`。
- 如果你是 CLI/系统工程为主：先用 `codex-rs/core/config.schema.json` + `codex-rs/Cargo.toml` + `.github/codex/**`。
- 如果是混合仓：保留两套并按子目录划分 owner（Python owner / Rust owner）。
