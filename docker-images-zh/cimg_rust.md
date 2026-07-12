---
image: cimg/rust
description: "CircleCI Rust便捷Docker镜像，为CircleCI平台提供Rust开发环境，支持Rust项目的持续集成构建与测试任务。"
source: https://xuanyuan.cloud/zh/r/cimg/rust
canonical: https://xuanyuan.cloud/zh/r/cimg/rust
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cimg/rust" title="cimg/rust Docker 镜像中文简介、标签列表与拉取命令">cimg/rust 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CircleCI Rust 便捷 Docker 镜像

<div align="center">
	<p>
		<img alt="CircleCI 标志" src="https://raw.github.com/CircleCI-Public/cimg-rust/main/img/circle-circleci.svg?sanitize=true" width="75" />
		<img alt="Docker 标志" src="https://raw.github.com/CircleCI-Public/cimg-rust/main/img/circle-docker.svg?sanitize=true" width="75" />
		<img alt="Rust 标志" src="https://raw.github.com/CircleCI-Public/cimg-rust/main/img/circle-rust.svg?sanitize=true" width="75" />
	</p>
	<h3>专注于持续集成的 Rust Docker 镜像，专为 CircleCI 环境设计</h3>
</div>

[![CircleCI 构建状态](https://circleci.com/gh/CircleCI-Public/cimg-rust.svg?style=shield)](https://circleci.com/gh/CircleCI-Public/cimg-rust) [![软件许可证](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-rust/main/LICENSE) [![Docker 拉取次数](https://img.shields.io/docker/pulls/cimg/rust)](https://hub.docker.com/r/cimg/rust) [![CircleCI 社区](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/circleci-images) [![代码仓库](https://img.shields.io/badge/github-README-brightgreen)](https://github.com/CircleCI-Public/cimg-rust)


## 镜像概述和主要用途

`cimg/rust` 是由 CircleCI 构建的 Docker 镜像，专为持续集成（CI）构建场景设计。该镜像旨在替代旧版 CircleCI Rust 镜像 `circleci/rust`，每个标签均包含完整的 Rust 版本、工具链（如 `rustfmt`）以及在 CircleCI 环境中成功完成构建所需的二进制文件和工具。


## 核心功能和特性

- **完整 Rust 工具链**：包含 `rustc`、`cargo`、`rustfmt`、`clippy` 等全套 Rust 开发工具。
- **多变体支持**：提供标准版、Node.js 集成版和浏览器测试版，满足不同构建需求。
- **灵活标签方案**：支持精确版本（如 `1.45.0`）和自动更新的次要版本（如 `1.45`），并可附加变体标识。
- **CircleCI 环境优化**：预安装必要依赖，确保与 CircleCI 执行器无缝兼容，减少构建配置复杂度。


## 使用场景和适用范围

- **标准 Rust 项目 CI/CD**：适用于纯 Rust 项目的持续集成流程，包括代码检查、编译、测试等环节。
- **Node.js 协同场景**：需结合 Node.js 工具链的 Rust 项目（如前端 Rust 工具、WebAssembly 构建流程）。
- **浏览器测试场景**：需在浏览器环境中验证的 Rust 应用（如 WebAssembly 前端应用的端到端测试）。


## 详细使用方法和配置说明

### 快速入门

该镜像可与 CircleCI `docker` 执行器配合使用。以下是基础配置示例：

```yaml
jobs:
  build:
    docker:
      - image: cimg/rust:1.45.0  # 指定 Rust 版本
    steps:
      - checkout  # 拉取代码
      - run: cargo --version  # 验证 Rust 环境
      - run: cargo build  # 执行构建
      - run: cargo test  # 执行测试
```


### 变体使用

#### Node.js 变体

包含 Node.js 环境，适用于需 Node.js 协同的场景。通过在标签后附加 `-node` 使用：

```yaml
jobs:
  build:
    docker:
      - image: cimg/rust:1.45-node  # Node.js 变体
    steps:
      - checkout
      - run: cargo --version  # 验证 Rust
      - run: node --version   # 验证 Node.js
      - run: cargo build      # 构建 Rust 项目
      - run: npm run build    # 执行 Node.js 构建步骤
```

#### Browsers 变体

包含 Node.js、Java、Selenium 及浏览器依赖，需配合 [CircleCI Browser Tools orb](https://circleci.com/developer/orbs/orb/circleci/browser-tools) 使用，适用于浏览器测试场景。通过在标签后附加 `-browsers` 使用：

```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1  # 引入浏览器工具 orb
jobs:
  build:
    docker:
      - image: cimg/rust:1.45-browsers  # 浏览器变体
    steps:
      - browser-tools/install-browser-tools  # 安装 Chrome/Firefox
      - checkout
      - run: cargo --version
      - run: node --version
      - run: java --version
      - run: google-chrome --version  # 验证浏览器安装
      - run: cargo test --features browser  # 执行浏览器测试
```


### 标签方案详解

标签格式：`cimg/rust:<rust-version>[-variant]`

- `<rust-version>`：Rust 版本，支持：
  - 完整语义化版本（如 `1.45.0`）：固定指向特定补丁版本。
  - 次要版本（如 `1.45`）：自动指向该次要版本的最新补丁（如 `1.45.0` 发布后会更新为 `1.45.1`）。
- `[-variant]`：可选变体标识，支持 `node`（Node.js 环境）和 `browsers`（浏览器测试环境）。

**标签示例**：
- `cimg/rust:1.45.0`：Rust 1.45.0 标准版
- `cimg/rust:1.45`：Rust 1.45.x 最新补丁版
- `cimg/rust:1.45-node`：Rust 1.45.x + Node.js 环境
- `cimg/rust:1.45-browsers`：Rust 1.45.x + 浏览器测试环境


## 开发与贡献

### 本地构建与测试

如需本地构建镜像，需满足以下依赖：
- Linux/macOS 系统
- Bash 4+
- Docker Engine 19.03+

#### 克隆仓库

```bash
# 社区用户（需先 Fork 仓库）
git clone --recurse-submodules <你的 Fork 仓库 URL>
cd cimg-rust
git submodule update --recursive  # 初始化子模块

# 维护者（直接克隆）
git clone --recurse-submodules git@github.com:CircleCI-Public/cimg-rust.git
```

#### 生成 Dockerfile

使用 `gen-dockerfiles.sh` 脚本生成指定版本的 Dockerfile：

```bash
./shared/gen-dockerfiles.sh 1.45.0  # 生成 Rust 1.45.0 的 Dockerfile
# 生成路径：./1.45/Dockerfile
```

#### 本地构建与运行

```bash
cd 1.45  # 进入版本目录
docker build -t test/rust:1.45.0 .  # 构建镜像
docker run -it docker.xuanyuan.run/test/rust:1.45.0 bash # 启动容器验证
```


### 贡献指南

- **提交 Issue**：用于报告 Bug 或请求新功能，详情请参考 [Issue 模板](https://github.com/CircleCI-Public/cimg-rust/issues)。
- **提交 PR**：建议先通过 Issue 讨论大的改动，确保符合项目方向。小修复可直接提交 PR。
- **注意事项**：
  - 工具链变更需确保兼容性，避免影响现有用户构建。
  - 子模块（`./shared`）的修改需通过其 [独立仓库](https://github.com/CircleCI-Public/cimg-shared) 提交，再更新本仓库子模块引用。


## 额外资源

- [CircleCI 官方文档](https://circleci.com/docs/)：CircleCI 配置与使用指南。
- [CircleCI 配置参考](https://circleci.com/docs/2.0/configuration-reference/)：`.circleci/config.yml` 语法详解。
- [Docker 官方文档](https://docs.docker.com/)：Docker 基础与高级用法。
- [Rust 官方文档](https://www.rust-lang.org/learn)：Rust 语言及工具链使用指南。


## 许可证

本仓库采用 MIT 许可证，详情参见 [LICENSE](https://raw.githubusercontent.com/CircleCI-Public/cimg-rust/main/LICENSE)。
