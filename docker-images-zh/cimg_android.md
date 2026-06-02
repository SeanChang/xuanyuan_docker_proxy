<!-- xuanyuan-docker-images-zh
image: cimg/android
source: https://xuanyuan.cloud/zh/r/cimg/android
canonical: https://xuanyuan.cloud/zh/r/cimg/android
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [cimg/android — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/cimg/android "cimg/android Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/cimg/android

# CircleCI 便捷镜像 => Android

专注于持续集成的 Android Docker 镜像，旨在 CircleCI 上运行

[![CircleCI Build Status](https://circleci.com/gh/CircleCI-Public/cimg-android.svg?style=shield)](https://circleci.com/gh/CircleCI-Public/cimg-android) [![Software License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-android/main/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/cimg/android)](https://hub.docker.com/r/cimg/android) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/circleci-images) [![Repository](https://img.shields.io/badge/github-README-brightgreen)](https://github.com/CircleCI-Public/cimg-android)

此镜像旨在取代旧版 CircleCI Android 镜像 `circleci/android`。

`cimg/android` 是由 CircleCI 创建的 Docker 镜像，专为持续集成构建设计。每个标签包含 Android 环境和工具链，包括多个 API SDK、命令行工具、构建工具、Ant、Gradle、Google Cloud SDK 等。

## 目录

- [快速开始](#快速开始)
- [镜像工作原理](#镜像工作原理)
- [开发](#开发)
- [贡献](#贡献)
- [补充资源](#补充资源)
- [许可证](#许可证)

## 快速开始

此镜像可与 CircleCI 的 `docker` 执行器配合使用。例如：

```yaml
jobs:
  build:
    docker:
      - image: cimg/android:2021.08.1
    steps:
      - checkout
      - run: ./gradlew androidDependencies
      - run: ./gradlew lint test
```

上述示例中，CircleCI Android Docker 镜像用作主容器，具体使用标签 `2021.08.1`（即 2021 年 8 月的镜像快照）。您可在此作业步骤中构建和测试 Android 项目。

## 镜像工作原理

此镜像包含 Android SDK 和 CLI 工具。

### 变体

变体镜像通常包含相同的基础软件，但有少量额外修改。

#### NDK - 原生开发工具包

NDK 变体与基础 Android 镜像相同，但已安装 Android NDK（特定稳定且长期支持版本）。可通过在现有 `cimg/android` 标签末尾添加 `-ndk` 来使用 NDK 变体。

```yaml
jobs:
  build:
    docker:
      - image: cimg/android:2021.08.1-ndk
    steps:
      - checkout
```

#### Node.js

Node.js 变体与基础 Android 镜像相同，但额外安装了 Node.js。可通过在现有 `cimg/android` 标签末尾添加 `-node` 来使用 Node.js 变体。

```yaml
jobs:
  build:
    docker:
      - image: cimg/android:2021.08.1-node
    steps:
      - checkout
      - run: node --version
```

#### 浏览器

浏览器变体与基础 Android 镜像相同，但通过 apt 预安装了 Node.js、Java、Selenium 和浏览器依赖项。可通过在现有 `cimg/android` 标签末尾添加 `-browsers` 来使用浏览器变体。此变体旨在与 [CircleCI Browser Tools orb](https://circleci.com/developer/orbs/orb/circleci/browser-tools) 配合使用，可通过该 orb 在构建中安装特定版本的 Google Chrome 和/或 Firefox。该镜像包含使用浏览器及其驱动程序所需的所有支持工具。

```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1
jobs:
  build:
    docker:
      - image: cimg/android:2021.08.1-browsers
    steps:
      - browser-tools/install-browser-tools
      - checkout
      - run: |
          node --version
          java --version
          google-chrome --version
```

### 标签方案

此镜像采用以下标签方案：

```
cimg/android:<tag>[-variant]
```

`<tag>` - 镜像快照版本，可在 [开发者中心](https://circleci.com/developer/images/image/cimg/android) 查看可用标签和预安装软件列表。

`[-variant]` - 可选的变体标签，可用变体见上文[变体](#变体)部分。

## 开发

可通过本仓库在本地构建和运行镜像。需满足以下要求：

- Linux（已测试 Ubuntu）或 macOS 本地机器
- 新版 Bash（v4+）
- 新版 Docker Engine（v19.03+）

### 社区用户克隆（无仓库写入权限）

在 GitHub 上 Fork 本仓库。获取克隆 URL 后，需在克隆命令中添加 `--recurse-submodules` 以填充仓库中包含的 Git 子模块。命令如下：

```bash
git clone --recurse-submodules <我的克隆 URL>
```

如果已克隆但遗漏此步骤，可运行 `git submodule update --recursive` 填充子模块。还可选择将本仓库添加为上游仓库：

```bash
git remote add upstream https://github.com/CircleCI-Public/cimg-android.git
```

### 维护者克隆（有仓库写入权限）

使用以下命令克隆项目以填充子模块：

```bash
git clone --recurse-submodules git@github.com:CircleCI-Public/cimg-android.git
```

### 生成 Dockerfile

可使用 `gen-dockerfiles.sh` 脚本生成此镜像的 Dockerfile。例如，从仓库根目录运行：

```bash
./shared/gen-dockerfiles.sh 2021.07.1
```

生成的 Dockerfile 将位于 `./2021.07/Dockerfile`。要在本地构建此镜像并试用，可运行：

```bash
cd 2021.07
docker build -t test/android:2021.07.1 .
docker run -it test/android:2021.07.1 bash
```

### 构建 Dockerfile

要像本仓库一样在本地构建 Docker 镜像，需运行 `build-images.sh` 脚本：

```bash
./build-images.sh
```

需先生成 Dockerfile 后运行此命令。发布 CircleCI 正式镜像时，此脚本从 CircleCI 流水线运行，而非本地。

### 发布正式镜像（仅限维护者）

可使用上述单个脚本创建镜像的正确文件，然后添加到新 Git 分支、提交等。包含发布脚本以简化此过程。要为此镜像进行正式发布（以假标签 2021.07.1 为例），需从仓库根目录运行：

```bash
./shared/release.sh 2021.07.1
```

这将自动创建新 Git 分支、生成 Dockerfile、暂存更改、提交并推送到 GitHub。提交消息以字符串 `[release]` 结尾，CircleCI 通过此字符串识别何时将镜像推送到 Docker Hub。之后需：等待 CircleCI 构建通过、审核 PR、合并 PR。主分支构建随后将发布版本。

### 变更合并

变更如何合并到此镜像取决于其来源。

**构建脚本** - `./shared` 子模块内的更改在其[自身仓库](https://github.com/CircleCI-Public/cimg-shared)中进行。要使这些更改影响此镜像，需更新子模块。通常命令如下：

```bash
cd shared
git pull
cd ..
git add shared
git commit -m "更新子模块以修复 foo 问题。"
```

**父镜像** - 设计上，父镜像变更不会出现在现有 Android 镜像中，以确保“确定性”并防止破坏用户构建。新 Android 镜像将自动包含这些变更。

如果确实需要将父镜像变更发布到 Android 镜像中，需将特定镜像版本作为新镜像构建，这将创建新 Dockerfile，发布后成为新镜像。

**Android 特定变更** - 编辑本仓库中的 `Dockerfile.template` 文件将专门修改 Android 镜像。注意，要在本地查看这些变更，需重新运行 `gen-dockerfiles.sh` 脚本（见上文）。

## 贡献

我们鼓励针对本仓库提交[问题](https://github.com/CircleCI-Public/cimg-android/issues)和[拉取请求](https://github.com/CircleCI-Public/cimg-android/pulls)。为尊重您的时间，请注意以下事项：

1. 不会随意向此镜像添加工具。要将工具添加到 Android 镜像，需为大量 Android 开发者所使用且维护良好。每个添加的工具都会增大镜像体积，降低所有用户的速度，因此对镜像内容持审慎态度将有益于所有人。
2. 欢迎提交 PR。如果 PR 可能需要大量时间，请先打开 issue 讨论，确保值得投入时间。
3. issues 应用于报告错误或请求添加/移除镜像中的工具。有关镜像使用帮助，请访问 [CircleCI Discuss](https://discuss.circleci.com/c/ecosystem/circleci-images)。

## 补充资源

[CircleCI 文档](https://circleci.com/docs/) - CircleCI 官方文档网站。

[CircleCI 配置参考](https://circleci.com/docs/2.0/configuration-reference/#section=configuration) - 来自 CircleCI 文档，配置参考页面是最实用的页面之一，列出了 `.circleci/config.yml` 支持的所有键和值。

[Docker 文档](https://docs.docker.com/) - 简单项目可能无需此资源，但如需深入学习 Docker，这是极佳资源。

## 许可证

本仓库采用 MIT 许可证授权。许可证详见[此处](./LICENSE)。
