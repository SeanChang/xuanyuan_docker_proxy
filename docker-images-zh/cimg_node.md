---
image: cimg/node
description: "CircleCI Node.js Docker便捷镜像是为Node.js项目提供的预配置Docker镜像，旨在简化CI/CD流程中的环境设置，方便开发者快速集成和部署应用。"
source: https://xuanyuan.cloud/zh/r/cimg/node
canonical: https://xuanyuan.cloud/zh/r/cimg/node
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cimg/node" title="cimg/node Docker 镜像中文简介、标签列表与拉取命令">cimg/node 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# cimg/node Docker镜像文档

## 镜像概述和主要用途

`cimg/node` 是由CircleCI构建的Docker镜像，专为持续集成（CI）环境设计，用于替代旧版 `circleci/node` 镜像。该镜像包含特定版本的Node.js、`npm`、`yarn v1` 以及在CircleCI环境中成功执行构建所需的二进制文件和工具，适用于Node.js项目的持续集成构建流程。


## 核心功能与特性

### 预装组件
- Node.js运行时环境
- 包管理器：`npm`（随Node.js内置）和`yarn v1`
- 基础构建工具（如`git`、`curl`等）

### 镜像变体
提供针对特定场景优化的变体：

#### 浏览器变体（-browsers）
在基础镜像上扩展，预装Java、Selenium及浏览器依赖（通过apt安装），用于需要浏览器环境的测试场景（如前端自动化测试）。需配合 [CircleCI Browser Tools orb](https://circleci.com/developer/orbs/orb/circleci/browser-tools) 使用，以安装Chrome/Firefox浏览器及其驱动。

### 灵活的标签方案
支持多种标签格式，满足不同版本控制需求：
- 完整语义化版本（如 `15.0.1`）
- 次要版本（如 `12.6`，自动指向最新补丁版本）
- 版本别名（`current` 指向最新稳定版，`lts` 指向最新LTS版）
- 变体标签（在基础标签后添加 `-browsers`，如 `15.0.1-browsers`）


## 使用场景和适用范围

### 适用场景
- Node.js项目的持续集成构建（如代码检查、单元测试、打包等）
- 需要浏览器环境的前端自动化测试（如使用Selenium的E2E测试）
- 依赖Java或浏览器工具的Node.js应用构建流程

### 适用范围
- CircleCI平台（推荐使用 `docker` 执行器）
- 需标准化Node.js环境的CI/CD流程
- 对构建环境稳定性和一致性有要求的团队


## 使用方法和配置说明

### 快速开始

在CircleCI配置文件（`.circleci/config.yml`）中，通过 `docker` 执行器指定镜像：

```yaml
jobs:
  build:
    docker:
      - image: cimg/node:15.0.1  # 指定Node.js版本
    steps:
      - checkout  # 拉取代码
      - run: node --version  # 验证Node.js版本
      - run: npm --version   # 验证npm版本
      - run: yarn --version  # 验证yarn版本
```

### 浏览器变体使用示例

浏览器变体需配合 `browser-tools` orb安装浏览器：

```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1.0  # 引入浏览器工具orb

jobs:
  e2e-test:
    docker:
      - image: cimg/node:15.0.1-browsers  # 使用浏览器变体镜像
    steps:
      - browser-tools/install-browser-tools  # 安装Chrome/Firefox
      - checkout
      - run:
          name: 验证环境
          command: |
            node --version
            java --version  # 浏览器变体预装Java
            google-chrome --version  # 验证Chrome安装
```

### 标签方案详解

#### 基础标签格式
```text
cimg/node:<node-version>
```

- `<node-version>`：Node.js版本，支持以下格式：
  - **完整语义化版本**：如 `10.16.3`（精确指向v10.16.3）
  - **次要版本**：如 `12.6`（自动指向最新补丁版，如12.6.0→12.6.1）
  - **版本别名**：`current`（最新稳定版）或 `lts`（最新LTS版）

#### 变体标签
- 浏览器变体：在基础标签后添加 `-browsers`，如 `15.0.1-browsers`


## 开发指南

### 本地构建与测试

#### 环境要求
- Linux（推荐Ubuntu）或macOS
- Bash 4+
- Docker Engine 19.03+

#### 克隆仓库
```bash
# 社区用户（需先Fork仓库）
git clone --recurse-submodules <你的Fork仓库URL>
cd cimg-node
git submodule update --recursive  # 初始化子模块

# 维护者
git clone --recurse-submodules git@github.com:CircleCI-Public/cimg-node.git
```

#### 生成Dockerfile
使用脚本生成指定版本的Dockerfile：
```bash
./shared/gen-dockerfiles.sh 12.16.3=lts  # 生成Node.js 12.16.3（LTS）的Dockerfile
```
生成的Dockerfile位于 `./12.16/Dockerfile`。

#### 本地构建镜像
```bash
cd 12.16
docker build -t test/node:12.16.3 .  # 构建测试镜像
docker run -it test/node:12.16.3 bash  # 运行镜像验证
```

### 发布流程（维护者用）
使用发布脚本创建新版本分支并推送：
```bash
./shared/release.sh 9.99=alias  # 其中"alias"为"current"或"lts"
```
脚本会自动生成Dockerfile、创建分支、提交并推送。提交信息含 `[release]` 标识，触发CircleCI推送镜像至Docker Hub。


## 贡献指南

- **问题反馈**：通过 [GitHub Issues](https://github.com/CircleCI-Public/cimg-node/issues) 提交bug或功能建议。
- **代码贡献**：提交PR前请确保：
  - 本地测试通过
  - 遵循现有代码风格
  - 重大变更需先通过Issue讨论
- **子模块更新**：构建脚本位于 `./shared` 子模块（独立仓库 [cimg-shared](https://github.com/CircleCI-Public/cimg-shared)），更新需同步子模块：
  ```bash
  cd shared && git pull && cd .. && git add shared && git commit -m "更新子模块"
  ```


## 附加资源

- [CircleCI官方文档](https://circleci.com/docs/)
- [CircleCI配置参考](https://circleci.com/docs/2.0/configuration-reference/)
- [Docker官方文档](https://docs.docker.com/)
- [browser-tools orb文档](https://circleci.com/developer/orbs/orb/circleci/browser-tools)


## 许可证

本仓库采用MIT许可证，详见 [LICENSE](https://raw.githubusercontent.com/CircleCI-Public/cimg-node/master/LICENSE)。
