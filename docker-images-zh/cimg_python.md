---
image: cimg/python
description: "CircleCI提供的`cimg/python`是专为持续集成构建设计的Docker镜像，包含完整Python版本（通过pyenv），预装pip、pipenv和poetry，适用于CircleCI环境，旨在取代旧版`circleci/python`镜像。"
source: https://xuanyuan.cloud/zh/r/cimg/python
canonical: https://xuanyuan.cloud/zh/r/cimg/python
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cimg/python" title="cimg/python Docker 镜像中文简介、标签列表与拉取命令">cimg/python — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/cimg/python" title="cimg/python Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/cimg/python</a>

# CircleCI 便捷镜像 => Python

一个专注于持续集成的Python Docker镜像，专为在CircleCI上运行而构建。

[![CircleCI构建状态](https://circleci.com/gh/CircleCI-Public/cimg-python.svg?style=shield)](https://circleci.com/gh/CircleCI-Public/cimg-python) [![软件许可证](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-python/master/LICENSE) [![Docker拉取次数](https://img.shields.io/docker/pulls/cimg/python)](https://hub.docker.com/r/cimg/python) [![CircleCI社区](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/circleci-images) [![仓库](https://img.shields.io/badge/github-README-brightgreen)](https://github.com/CircleCI-Public/cimg-python)

此镜像旨在取代旧版CircleCI Python镜像`circleci/python`。

`cimg/python`是由CircleCI创建的Docker镜像，专为持续集成构建而设计。每个标签都通过pyenv包含完整的Python版本。预装了pip、pipenv和poetry，以及在CircleCI环境中成功完成构建所需的任何二进制文件和工具。

## 目录

- [开始使用](#开始使用)
- [镜像工作原理](#镜像工作原理)
- [开发](#开发)
- [贡献](#贡献)
- [额外资源](#额外资源)
- [许可证](#许可证)

## 开始使用

此镜像可与CircleCI `docker`执行器一起使用。例如：

```yaml
jobs:
  build:
    docker:
      - image: cimg/python:3.8
    steps:
      - checkout
      - run: python --version
```

在上面的示例中，CircleCI Python Docker镜像用作主容器。更具体地说，使用了标签`3.8`，这意味着Python的版本将是Python v3.8。现在可以在此作业的步骤中使用Python。

## 镜像工作原理

此镜像包含Python编程语言以及pip、pipenv和poetry。解释器通过pyenv提供，允许您在构建过程中更改Python版本。

### 变体

变体镜像通常包含相同的基础软件，但有一些额外的修改。

#### Node.js

Node.js变体与Python镜像相同，但还安装了Node.js。可以通过在现有`cimg/python`标签末尾添加`-node`来使用Node.js变体。

```yaml
jobs:
  build:
    docker:
      - image: cimg/python:3.7-node
    steps:
      - checkout
      - run: python --version
      - run: node --version
```

#### 浏览器

浏览器变体与Python镜像相同，但通过apt预安装了Node.js、Java、Selenium和浏览器依赖项。可以通过在现有`cimg/python`标签末尾添加`-browser`来使用浏览器变体。浏览器变体旨在与[CircleCI浏览器工具orb](https://circleci.com/developer/orbs/orb/circleci/browser-tools)配合使用。您可以使用orb在构建中安装特定版本的Google Chrome和/或Firefox。该镜像包含使用浏览器及其驱动程序所需的所有支持工具。

```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1

jobs:
  build:
    docker:
      - image: cimg/python:3.7-browsers
    steps:
      - browser-tools/install-browser-tools
      - checkout
      - run: |
          python --version
          node --version
          java --version
          google-chrome --version
```

### 标签方案

此镜像具有以下标签方案：

```
cimg/python:<python-version>[-variant]
```

`<python-version>` - 要使用的Python版本。可以是完整的SemVer点版本（如`3.8.1`）或仅次要版本（如`3.8`）。如果使用次要版本标签，它将自动指向Python项目发布的未来补丁更新。例如，标签`3.8`现在指向Python v3.8.5，但当下一个版本发布时，它将指向Python v3.8.6。

`[-variant]` - 如果可用，可以选择使用变体标签。例如，可以像这样使用Node.js变体：`cimg/python:3.7-node`。

## 开发

可以使用此仓库在本地构建和运行镜像。这有以下要求：

- Linux本地机器（已测试Ubuntu）或macOS
- 现代版本的Bash（v4+）
- 现代版本的Docker Engine（v19.03+）

### 社区用户克隆（对本仓库没有写权限）

在GitHub上fork此仓库。获取克隆URL时，您需要在克隆命令中添加`--recurse-submodules`以填充此仓库中包含的Git子模块。它看起来像这样：

```bash
git clone --recurse-submodules <我的克隆URL>
```

如果您错过了此步骤并已克隆，可以运行`git submodule update --recursive`来填充子模块。然后您可以选择将此仓库添加为自己仓库的上游：

```bash
git remote add upstream https://github.com/CircleCI-Public/cimg-python.git
```

### 维护者克隆（您对本仓库有写权限）

使用以下命令克隆项目以填充子模块：

```bash
git clone --recurse-submodules git@github.com:CircleCI-Public/cimg-python.git
```

### 生成Dockerfiles

可以使用`gen-dockerfiles.sh`脚本为特定Python版本生成Dockerfiles。例如，要为Python v3.7.7生成Dockerfile，您可以从仓库根目录运行以下命令：

```bash
./shared/gen-dockerfiles.sh 3.7.7
```

生成的Dockerfile将位于`./3.7/Dockefile`。要在本地构建此镜像并试用，您可以运行以下命令：

```bash
cd 3.7
docker build -t test/python:3.7.7 .
docker run -it test/python:3.7.7 bash
```

### 构建Dockerfiles

要像此仓库一样在本地构建Docker镜像，您需要运行`build-images.sh`脚本：

```bash
./build-images.sh
```

这需要在首先生成Dockerfiles之后运行。发布CircleCI的正式镜像时，此脚本是从CircleCI管道运行的，而不是在本地运行。

### 提交拉取请求

确保版本化Dockerfiles和`build-images.sh`的所有更改都已还原，只留下`Dockerfile.template`作为修改后的文件。在测试上述部分时，这些文件会被修改。特定版本将在镜像发布时包含在内。

### 发布官方镜像（仅维护者）

各个脚本（如上所述）可用于为镜像创建正确的文件，然后添加到新的git分支、提交等。包含一个发布脚本以使此过程更容易。要为此镜像进行正确的发布，让我们使用假的Python版本v99.9.9，您可以从仓库根目录运行以下命令：

```bash
./shared/release.sh 99.9.9
```

这将自动创建一个新的Git分支，生成Dockerfile(s)，暂存更改，提交它们，并将它们推送到GitHub。提交消息将以字符串`[release]`结尾。CircleCI使用此字符串来知道何时将镜像推送到Docker Hub。之后需要做的就是：

- 等待CircleCI上的构建通过
- 审查PR
- 合并PR

然后主分支构建将发布版本。

### 合并更改

更改如何合并到此镜像取决于它们的来源。

**构建脚本** - `./shared`子模块中的更改在其[自己的仓库](https://github.com/CircleCI-Public/cimg-shared)中发生。要使这些更改影响此镜像，需要更新子模块。通常像这样：

```bash
cd shared
git pull
cd ..
git add shared
git commit -m "更新子模块以修复foo。"
```

**父镜像** - 按照设计，当父镜像发生更改时，它们不会出现在现有Python镜像中。这有助于"确定性"并防止破坏客户构建。新的Python镜像将自动获取更改。

如果您*确实*想将父镜像的更改发布到Python镜像中，则必须像构建新镜像一样构建特定的镜像版本。这将创建一个新的Dockerfile，一旦发布，就是一个新的镜像。

**Python特定更改** - 编辑此仓库中的`Dockerfile.template`文件是专门修改Python镜像的方法。不要忘记，要在本地查看任何这些更改，需要再次运行`gen-dockerfiles.sh`脚本（见上文）。

## 贡献

我们鼓励对此仓库提出[问题](https://github.com/CircleCI-Public/cimg-python/issues)和[拉取请求](https://github.com/CircleCI-Public/cimg-python/pulls)，但是，为了珍惜您的时间，请注意以下几点：

1. 我们不会在此镜像中包含所有内容。为了在Python镜像中添加工具，它必须是维护良好的，并且对大量Python开发者有用。添加的每个工具都会使所有用户的镜像变大且变慢，因此彻底检查镜像中的内容将使每个人受益。
2. 欢迎PR。如果您有一个可能需要大量时间才能完成的PR，最好先打开一个问题进行讨论，以确保值得投入时间。
3. 问题应该是报告错误或请求在此镜像中添加/删除工具。有关镜像的帮助，请访问[CircleCI Discuss](https://discuss.circleci.com/c/ecosystem/circleci-images)。

## 额外资源

[CircleCI文档](https://circleci.com/docs/) - 官方CircleCI文档网站。
[CircleCI配置参考](https://circleci.com/docs/2.0/configuration-reference/#section=configuration) - 来自CircleCI文档，配置参考页面是我们最有用的页面之一。它将列出`.circleci/config.yml`中支持的所有键和值。
[Docker文档](https://docs.docker.com/) - 对于简单项目，这不是必需的，但如果您想深入学习Docker，这是一个很好的资源。

## 许可证

此仓库根据MIT许可证授权。许可证可以在[此处](./LICENSE)找到。
