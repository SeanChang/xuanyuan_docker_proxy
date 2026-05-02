# Docker 部署 Hermes Agent 完整指南（Windows / Linux 通用）

![Docker 部署 Hermes Agent 完整指南（Windows / Linux 通用）](https://img.xuanyuan.dev/docker/blog/docker-hermes-agent.png)

*分类: OpenClaw,AI,Hermes,hermes-agent,部署教程 | 标签: OpenClaw,AI,Hermes,hermes-agent,部署教程 | 发布时间: 2026-04-20 07:46:03*

> Hermes Agent 是 Nous Research 推出的 AI 自主智能体（AI Autonomous Agent），能轻松执行各类复杂任务，比如自动编写代码、执行终端命令、操作浏览器、规划并完成任务，以及进行文件读写和脚本生成，是开发、运维和研究的得力助手。

Hermes Agent 是 Nous Research 推出的 AI 自主智能体（AI Autonomous Agent），能轻松执行各类复杂任务，比如自动编写代码、执行终端命令、操作浏览器、规划并完成任务，以及进行文件读写和脚本生成，是开发、运维和研究的得力助手。

本文将详细介绍如何通过 Docker 快速部署 Hermes Agent，部署前先为大家提供 Docker 一键安装与镜像加速方案，适配绝大多数场景，新手也能轻松上手。

# 一、Docker 一键安装与镜像加速（推荐方案）

本方案支持 🧪 测试环境和 🏭 生产环境（需提前审计），提供的 Linux Docker \&amp; Docker Compose 一键安装配置脚本，可适配 13 种主流 Linux 发行版（含国产系统），能一键完成 Docker、Docker Compose 的安装，以及轩辕镜像加速配置，全程无需手动操作，极大提升部署效率。

## 1\. 执行命令

### 🧪 测试环境（快速体验，仅限非生产场景）

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### 🏭 生产环境（推荐，安全优先）

```bash
# 1. 下载脚本到本地
wget https://xuanyuan.cloud/docker.sh -O docker-install.sh

# 2. （可选）审计脚本源码（建议企业环境必做）
less docker-install.sh  # 或使用vim、cat查看脚本内容

# 3. 执行脚本
bash docker-install.sh
```

## 2\. 安全强制提示

⚠️ 请注意：curl \| bash / wget \| bash 这种直接执行远程脚本的方式，仅建议用于测试、个人学习或非核心环境，生产环境严禁直接使用；

⚠️ 金融、政务、内网等敏感环境，必须先将脚本下载到本地，进行全面的安全审计，确认无恶意代码后，再执行安装操作。

# 二、准备环境

完成 Docker 安装后，需确认环境已满足以下条件：

- 已安装 Docker（Linux 系统通过上述一键脚本安装即可）；

- Windows / Mac 系统需安装 Docker Desktop。

验证 Docker 是否正常运行，执行以下命令：

```bash
docker version
```

若能正常显示 Docker 版本信息，说明环境准备就绪。

# 三、拉取 Hermes Agent 镜像

使用以下命令拉取 Hermes Agent 最新镜像，通过轩辕镜像加速，拉取速度更快、更稳定：

```bash
docker pull docker.xuanyuan.run/nousresearch/hermes-agent:latest
```

拉取成功后，会显示类似如下输出，说明镜像拉取完成：

```bash
Status: Downloaded newer image
docker.xuanyuan.run/nousresearch/hermes-agent:latest
```

# 四、创建数据目录

Hermes Agent 运行过程中，需要持久化存储配置文件、会话数据等，因此需提前创建一个本地目录，用于挂载到容器中，避免容器删除后数据丢失。

## Linux / Mac 系统

```bash
mkdir -p ~/.hermes
```

## Windows 系统（PowerShell 中执行）

```powershell
mkdir C:\Users\用户名\hermes
```

说明：将命令中的“用户名”替换为你自己的 Windows 用户名即可。该目录主要用于存储以下内容：

- config\.yaml（核心配置文件）

- \.env（环境变量配置文件）

- sessions（会话数据）

- logs（运行日志）

- memories（Agent 记忆数据）

# 五、初始化 Hermes Agent

首次运行 Hermes Agent 时，需要执行初始化向导，配置核心参数（如模型提供商、API Key 等），步骤简单，跟着提示操作即可。

## Linux / Mac 系统

```bash
docker run -it --rm \
-v ~/.hermes:/opt/data \
docker.xuanyuan.run/nousresearch/hermes-agent:latest setup
```

## Windows 系统（PowerShell 中执行）

```powershell
docker run -it --rm `
-v C:\Users\用户名\hermes:/opt/data `
docker.xuanyuan.run/nousresearch/hermes-agent:latest setup
```

说明：同样需将“用户名”替换为你自己的 Windows 用户名，执行命令后，会进入初始化向导界面。

# 六、初始化配置说明

初始化向导主要包含 3 个核心步骤，下面为大家详细说明，新手可直接参考推荐选项操作：

## 1\. 选择初始化方式

向导会提供多种初始化方式，推荐选择以下选项，适合快速启动，无需配置复杂参数：

```bash
Quick setup — provider, model & messaging
```

该模式仅配置模型提供商、模型版本和消息相关的核心参数，上手速度最快，适合首次体验和本地测试。

## 2\. 选择模型 Provider

Hermes Agent 支持多种主流模型服务，大家可根据自己的需求和拥有的 API Key 选择，常见选项包括：

- OpenAI

- Anthropic

- DeepSeek

- xAI

- Alibaba Cloud（阿里云）

- Google

选择对应 Provider 后，按照提示填写该平台的 API Key 即可（API Key 需提前在对应平台申请）。

## 3\. 是否连接消息平台

Hermes Agent 支持接入 Telegram、Discord 等聊天平台，方便通过聊天工具操作 Agent。如果只是在本地测试，不打算接入外部聊天平台，建议选择：

```bash
Skip — set up later
```

后续如果需要接入消息平台，可通过后续的管理命令重新配置。

# 七、初始化完成

按照向导完成所有配置后，会看到以下提示，说明初始化成功：

```bash
✓ Setup Complete!
```

初始化生成的配置文件，会自动存储在容器的 `/opt/data` 目录下，由于我们之前配置了本地目录挂载，实际对应本地的：

- Linux / Mac：`\~/\.hermes` 目录

- Windows：`C:\\Users\\用户名\\hermes` 目录

后续如果需要修改配置，直接编辑本地目录下的 config\.yaml 和 \.env 文件即可。

# 八、启动 Hermes Agent

初始化完成后，执行以下命令，即可启动 Hermes Agent 并进入 CLI 交互模式，开始使用 Agent 完成各类任务。

```bash
docker run -it --rm \
-v ~/.hermes:/opt/data \
docker.xuanyuan.run/nousresearch/hermes-agent:latest
```

启动成功后，会看到以下提示，说明已进入交互模式：

```bash
Welcome to Hermes Agent!
Type your message or /help for commands
```

此时输入任意指令，即可与 Hermes Agent 交互，比如输入“hello”测试对话，或输入任务指令让 Agent 执行。

![Docker 部署 Hermes Agent](https://img.xuanyuan.dev/docker/blog/docker-hermes-agent.png)

# 九、常用命令

为大家整理了 Hermes Agent 最常用的几个命令，方便日常使用：

- 查看帮助（了解所有可用命令）：`/help`

- 测试对话：`hello`

- 生成代码示例（如监控 CPU 使用率的 Python 脚本）：`create a python script that monitors cpu usage`

- 生成 Docker Compose 配置（如 WordPress \+ MySQL）：`write a docker\-compose for wordpress and mysql`

# 十、Hermes Agent 能力概览

Hermes Agent 内置多种实用工具能力，能满足不同场景的需求，核心能力包括：

- Browser Automation（浏览器自动化：自动操作网页、爬取数据等）

- Terminal Commands（终端命令执行：直接执行系统命令，完成运维任务）

- Task Planning（任务规划：拆分复杂任务，逐步执行并完成）

- File Operations（文件读写：创建、编辑、删除本地文件）

- Code Execution（代码执行：运行各类编程语言代码，验证效果）

除此之外，Hermes Agent 还支持扩展能力，比如网页搜索、图像识别、图像生成、GitHub 相关操作等，这些扩展功能可通过以下命令配置：

```bash
hermes setup tools
```

# 十一、常用管理命令

如果后续需要修改配置、检查系统状态，可使用以下管理命令，无需重新初始化：

- 重新运行配置向导（修改所有配置）：`hermes setup`

- 修改模型配置（更换模型 Provider 或 API Key）：`hermes setup model`

- 配置消息网关（后续接入 Telegram、Discord 等）：`hermes setup gateway`

- 检查系统状态（排查运行异常）：`hermes doctor`

# 总结

通过 Docker 部署 Hermes Agent 非常简单，全程只需三个核心步骤，新手也能快速上手：

1. 拉取 Hermes Agent 镜像（通过轩辕镜像加速，速度更快）；

2. 运行初始化向导，配置核心参数（模型、API Key 等）；

3. 启动 Agent，进入交互模式，开始使用。

Hermes Agent 特别适合以下场景：

- AI 自动化任务（替代重复手动操作）；

- 开发辅助（自动生成代码、调试脚本）；

- DevOps 自动化（执行运维命令、部署服务）；

- 研究与实验环境（快速验证 AI 任务执行效果）。

如果需要在生产环境部署，也可以结合 Docker Compose 或 Kubernetes 进行扩展，实现更稳定、可扩展的部署架构。

> （注：文档部分内容可能由 AI 生成）


