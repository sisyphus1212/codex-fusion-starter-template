# codex-fusion-starter-template 使用说明

本文档说明如何把 `codex-fusion-starter-template` 用作新项目启动模板，并按项目类型进行裁剪。

## 1. 模板定位

这个模板是“工程治理 + Codex 协作 + 配置体系”的融合骨架，核心能力包括：

- Python Agents SDK 侧 Codex 运行时集成参考（`scaffold/src/agents/extensions/experimental/codex/`）。
- Codex CLI 侧配置中枢参考（`scaffold/codex-rs/core/config.schema.json`、`scaffold/docs/config.md`）。
- AI 协作流程规范（`scaffold/AGENTS.md`、`scaffold/PLANS.md`、`scaffold/.agents/skills/`）。
- GitHub Codex Action 自动化样例（`scaffold/.github/codex/`、`scaffold/.github/workflows/issue-*.yml`）。

说明：它不是完整可运行成品仓库，需要根据你的技术栈补齐依赖文件。

## 2. 快速开始

### 2.1 复制模板骨架

在你的目标项目目录执行（示例）：

```bash
mkdir -p /path/to/your-project
cp -R /root/openai-agents-python/codex-fusion-starter-template/scaffold/. /path/to/your-project/
```

### 2.2 初始化仓库

```bash
cd /path/to/your-project
git init
git checkout -b feat/bootstrap-codex-fusion
```

### 2.3 先跑模板检查

在模板源仓库中可先查看参考报告：

```bash
bash /root/openai-agents-python/codex-fusion-starter-template/scripts/check_template_gaps.sh
cat /root/openai-agents-python/codex-fusion-starter-template/gap-report.md
```

在你的目标仓库中建议复刻同类检查脚本，并按结果补齐依赖。

## 3. 按项目类型裁剪

### 3.1 Python Agents SDK 项目（推荐保留）

- `scaffold/src/agents/`
- `scaffold/tests/extensions/experiemental/codex/`
- `scaffold/examples/tools/codex.py`
- `scaffold/.agents/skills/`
- `scaffold/docs/ref/extensions/experimental/codex/`

可移除（若不用 Rust/Node/Bazel）：

- `scaffold/codex-rs/`
- `scaffold/codex-cli/`
- `scaffold/.bazelrc`、`scaffold/BUILD.bazel`、`scaffold/MODULE.bazel`
- `scaffold/package.json`、`scaffold/pnpm-workspace.yaml`

### 3.2 Rust Codex CLI/monorepo 项目（推荐保留）

- `scaffold/codex-rs/`
- `scaffold/codex-cli/`
- `scaffold/.github/codex/`
- `scaffold/.github/workflows/issue-labeler.yml`
- `scaffold/.github/workflows/issue-deduplicator.yml`
- `scaffold/.devcontainer/`

可移除（若不用 Python Agents SDK）：

- `scaffold/src/agents/`
- `scaffold/tests/extensions/experiemental/codex/`
- `scaffold/examples/tools/codex.py`

### 3.3 混合项目（建议）

- 同时保留两套，并通过子目录 owner 管理。
- Python 改动走 Python 检查链；Rust 改动走 Rust/Bazel 检查链。
- 统一以 `scaffold/AGENTS.md` 为入口，按子模块选择规则集。

## 4. 语言适配说明（C/C++/Python）

这套模板可以用于 C/C++/Python 项目，但定位是“工程治理与协作模板”，不是某一语言的完整开箱框架。

- Python Agents SDK 项目：适配度高，可直接复用 `scaffold/src/agents/` 与对应测试/文档。
- 普通 Python 项目（Web/API/数据脚本）：可复用 AGENTS、skills、CI 思路，但建议删除 `src/agents/extensions/experimental/codex/` 这类 SDK 专属代码。
- C/C++ 项目：可复用协作规则与自动化流程，但必须替换构建链（例如 CMake/Make、clang-format、clang-tidy、ctest、sanitizer）。

结论：可以用来开发多语言项目，但要先裁剪，再补齐语言对应基础设施。

## 5. codex-cli / codex-rs / Agents SDK 关系

三者关系如下：

```text
[手动开发]
你 -> codex 命令 -> codex-cli(启动壳) -> codex-rs(核心引擎)

[应用自动化]
你的 Python 应用 -> Agents SDK -> codex_tool -> 调起 codex CLI -> codex-rs
```

- `codex-rs`：核心能力实现（配置、执行、策略、会话、TUI/CLI 核心逻辑）。
- `codex-cli`：命令入口和分发层（负责定位并启动对应平台二进制）。
- `Agents SDK`：应用编排层（把 Codex 当成一个工具接入自动化流程）。

## 6. 项目开发选型建议

- 你自己手工开发代码：优先用 `codex` 命令（CLI）。
- 你在做平台能力（自动修复、自动评审、多工具编排）：用 `Agents SDK + codex_tool`。
- 你要做系统级定制（策略、沙箱、配置 schema、执行引擎）：保留并修改 `codex-rs`。

推荐路径：先用 CLI 提升开发效率，流程稳定后再把高频动作迁移到 `codex_tool` 自动化。

## 7. 修改 codex-rs 后如何让 codex 生效

有两种常用方式：

### 7.1 开发态（最快）

直接运行你本地编译的 Rust 二进制，不经过 npm 打包：

```bash
cd codex-rs
cargo build --bin codex
./target/debug/codex --version
```

### 7.2 命令态（保持敲 `codex`）

思路是把你编译出的二进制放到 `codex-cli` 期望的 `vendor/<target>/codex/` 路径，再 link 本地 CLI 包。

Linux x64 示例：

```bash
# 1) 编译 codex-rs
cd codex-rs
rustup target add x86_64-unknown-linux-musl
cargo build --release --target x86_64-unknown-linux-musl --bin codex

# 2) 放到 codex-cli 的 vendor 路径
cd ../codex-cli
mkdir -p vendor/x86_64-unknown-linux-musl/codex
cp ../codex-rs/target/x86_64-unknown-linux-musl/release/codex \
  vendor/x86_64-unknown-linux-musl/codex/codex
chmod +x vendor/x86_64-unknown-linux-musl/codex/codex

# 3) 链接本地命令
pnpm link --global

# 4) 验证
hash -r
which codex
codex --version
```

说明：不同平台的 target triple 不同，需要替换路径和目标架构。

## 8. AGENTS 使用规则

融合模板里的 AGENTS 文件有三份：

- `scaffold/AGENTS.md`：融合入口（先读这个）。
- `scaffold/AGENTS.openai-agents-python.md`：Python 侧规范。
- `scaffold/AGENTS.openai-codex.md`：Rust/Codex CLI 侧规范。

执行原则：

1. 改哪个子模块就优先用对应 AGENTS。
2. 同时跨模块改动时，两份都遵守。
3. 规则冲突时，从严处理并以 CI 必需项优先。

## 9. CI 与密钥配置

如果启用 Codex Action 工作流，需要在仓库 Secrets 配置 API Key（名称以 workflow 为准）：

- 常见：`CODEX_OPENAI_API_KEY` 或 `PROD_OPENAI_API_KEY`。

建议先在测试仓库验证：

1. 手动触发 `issue-labeler` / `issue-deduplicator`。
2. 检查输出 schema 是否符合 workflow 预期。
3. 再开启自动触发事件。

## 10. 推荐补齐项（最小可运行）

按 `gap-report.md`，建议优先补齐：

- Python 侧：`pyproject.toml`、`uv.lock`、`Makefile`
- Rust/Node/Bazel 侧：`pnpm-lock.yaml`、`MODULE.bazel.lock`、`codex-rs/Cargo.lock`、`codex-cli/bin/codex.js`
- CI 侧：`.github/workflows/ci.yml`、`.github/workflows/rust-ci.yml`、`.github/actions/*`、`.github/scripts/install-musl-build-tools.sh`

## 11. 典型落地流程

1. 复制 `scaffold/` 到新仓库。
2. 删除不需要的技术栈目录。
3. 补齐依赖锁文件和 CI 缺项。
4. 选定 AGENTS 主规则并更新项目描述。
5. 跑一次本地检查链（format/lint/test）。
6. 提交首个 bootstrap PR。

## 12. 常见问题

### Q1: 为什么看起来文件很多？

这是融合模板，目标是覆盖多场景。正常做法是“先删后补”，而不是全保留。

### Q2: `AGENTS.md` 应该只留一份吗？

可以。若你项目已确定单一技术栈，可删掉另一份并精简入口文件。

### Q3: 能直接生产可用吗？

不建议直接生产。请先补齐 `gap-report.md` 列出的必需依赖，再做一次 CI 试跑。

### Q4: 这套模板能直接用于任何 Python 项目吗？

不能直接原样使用。它对“Agents SDK + Codex 集成”最友好；普通 Python 项目需要裁剪后使用。

### Q5: 做项目开发该优先用哪个？

手工开发优先 `codex` CLI；产品自动化优先 `Agents SDK + codex_tool`；系统级能力定制保留并修改 `codex-rs`。

## 13. 关联文档

- 总览：`codex-fusion-starter-template/README.md`
- 融合对比：`codex-fusion-starter-template/compare-report.md`
- 模板清单：`codex-fusion-starter-template/source_paths.txt`
- 缺漏报告：`codex-fusion-starter-template/gap-report.md`
