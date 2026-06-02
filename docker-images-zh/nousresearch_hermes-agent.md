<!-- xuanyuan-docker-images-zh
image: nousresearch/hermes-agent
source: https://xuanyuan.cloud/zh/r/nousresearch/hermes-agent
canonical: https://xuanyuan.cloud/zh/r/nousresearch/hermes-agent
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [nousresearch/hermes-agent — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/nousresearch/hermes-agent "nousresearch/hermes-agent Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/nousresearch/hermes-agent

# Hermes Agent

**许可证：MIT** · 由 **Nous Research** 构建。

## 它是什么

Hermes Agent 是 Nous Research 推出的**自改进（self-improving）AI 智能体**。按官方表述，它是**唯一内置学习闭环（learning loop）**的智能体：能从实际经历中**创建技能（skills）**，并在持续使用中**改进**这些技能；会**主动推动自己**把知识持久化下来；能**检索自己过去的对话**；并在多次会话之间**不断加深对你是什么样的人、有何习惯与偏好的模型**。

你可以把它跑在 **约 5 美元级别的 VPS**、**GPU 集群**，或**闲置时成本接近为零**的无服务器基础设施上。它**不必绑在你的笔记本上**——例如智能体在云端 VM 上执行任务时，你仍可通过 **Telegram** 与它对话。

## 模型与供应商（避免锁定）

可使用多种后端与模型，例如：**Nous Portal**、**OpenRouter**（200+ 模型）、**z.ai / GLM**、**Kimi / Moonshot**、**MiniMax**、**OpenAI**，或**你自己的 API 端点**。通过 `hermes model` 切换提供方与模型——**无需改代码**，也**不会被单一厂商绑死**。

## 主要能力（与英文 README 对应）

- **真正的终端界面**：完整 **TUI**，支持多行编辑、斜杠命令自动补全、会话历史、**中断并改向（interrupt-and-redirect）**、工具输出**流式**展示。
- **出现在你常用的沟通工具里**：**Telegram、Discord、Slack、WhatsApp、Signal** 以及 **CLI**，可由**单一 gateway 进程**统一接入；支持**语音备忘录转写**、**跨平台会话连续性**。
- **闭环学习**：智能体策展的记忆并带有**周期性提醒（nudges）**；复杂任务后可**自主创建技能**；技能在运行中**自我改进**；结合 **FTS5** 会话搜索与 **LLM 摘要**做跨会话回忆；**Honcho** 辩证式用户建模；兼容 **agentskills.io** 开放标准。
- **定时自动化**：内置 **cron** 调度，可将结果投递到任意已接入平台；日报、夜间备份、周审计等可用**自然语言**配置，**无人值守**运行。
- **委派与并行**：可生成**隔离的子智能体（subagents）**并行推进工作流；可编写 **Python 脚本经 RPC 调用工具**，把多步流水线压缩为**几乎不消耗上下文轮次成本**的交互。
- **随处运行（不限于笔记本）**：六种终端后端——**本机、Docker、SSH、Daytona、Singularity、Modal**。其中 **Daytona** 与 **Modal** 提供类似无服务器的持久化：环境在空闲时**休眠**、按需唤醒，**会话之间成本极低**。
- **面向研究**：支持批量轨迹生成、**Atropos** RL 环境、轨迹压缩等，用于训练下一代**工具调用（tool-calling）**模型。

## 安装与系统要求

官方一键安装：

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

支持 **Linux、macOS、WSL2**；**Android** 可通过 **Termux**（需参考官方 Termux 指南）。在 Termux 上会安装精简的 `.[termux]` 额外依赖，因为完整 `.[all]` 会拉取与 Android **不兼容的语音相关依赖**。

**Windows：不支持原生 Windows**，请安装 **WSL2** 后在 WSL 中执行上述命令。

安装后：

```bash
source ~/.bashrc    # 或 source ~/.zshrc
hermes              # 开始对话
```

## 常用命令（Getting Started）

- `hermes`：交互式 CLI（终端里开始对话）
- `hermes model`：选择 LLM 提供方与模型
- `hermes tools`：配置启用的工具
- `hermes config set`：逐项写入配置
- `hermes gateway`：启动消息网关（Telegram、Discord 等）
- `hermes setup`：完整配置向导（一次性配好）
- `hermes claw migrate`：从 **OpenClaw** 迁移（若你原本使用 OpenClaw）
- `hermes update` / `hermes doctor`：更新与自检

## CLI 与消息渠道（两种入口）

一种是用 `hermes` 打开终端 UI；另一种是运行 **gateway**，然后在 **Telegram、Discord、Slack、WhatsApp、Signal 或 Email** 里与同一智能体对话。进入会话后，许多**斜杠命令**在两种界面间是共用的（例如 `/new`、`/reset`、`/model`、`/personality`、`/retry`、`/undo`、`/compress`、`/usage`、`/insights`、`/skills`、`/stop` 等；完整列表见官方 CLI 与 Messaging Gateway 文档）。

## 文档

全部文档位于：**https://hermes-agent.nousresearch.com/docs**  
涵盖快速上手、CLI、配置、消息网关、安全、工具与工具集、技能系统、记忆、MCP、cron、上下文文件、架构、贡献指南、环境变量、CLI 参考等。

## 从 OpenClaw 迁移

首次 `hermes setup` 可自动检测 `~/.openclaw` 并提示迁移；也可随时使用 `hermes claw migrate`（支持 `--dry-run`、`--preset user-data`、`--overwrite` 等）。可导入人设（如 SOUL.md）、记忆条目、用户技能、命令审批白名单、各消息平台配置与工作目录、经白名单的 API 密钥、TTS 资源、工作区说明（如 AGENTS.md）等。详情见 `hermes claw migrate --help` 或官方迁移说明。

## 参与贡献

欢迎贡献。可克隆官方仓库，使用 **uv** 创建 Python 3.11 虚拟环境并安装 `.[all,dev]` 后运行测试；若参与 RL 相关开发，可初始化 **tinker-atropos** 子模块并按文档安装。

---

**Docker 镜像**的具体运行方式、compose 与环境变量等，另见官方用户文档中的 Docker 说明：  
https://hermes-agent.nousresearch.com/docs/user-guide/docker
