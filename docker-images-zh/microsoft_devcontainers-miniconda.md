---
image: microsoft/devcontainers-miniconda
description: "支持dev container规范的Miniconda开发容器镜像，用于Python 3应用开发，可自动安装environment.yml中的依赖和Python扩展。"
source: https://xuanyuan.cloud/zh/r/microsoft/devcontainers-miniconda
canonical: https://xuanyuan.cloud/zh/r/microsoft/devcontainers-miniconda
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/microsoft/devcontainers-miniconda" title="microsoft/devcontainers-miniconda Docker 镜像中文简介、标签列表与拉取命令">microsoft/devcontainers-miniconda 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Miniconda (Python 3)## 概述在Python 3中开发Miniconda应用。从environment.yml文件安装依赖项并包含Python扩展。

| 元数据 | 值 |  
|----------|-------|
| *类别* | 核心、语言 |
| *镜像类型* | Dockerfile |
| *已发布镜像* | mcr.microsoft.com/devcontainers/miniconda:3 |
| *已发布镜像架构* | x86-64 |
| *容器主机操作系统支持* | Linux、macOS、Windows |
| *容器操作系统* | Debian |
| *支持语言、平台* | Python、Anaconda、Miniconda |

有关已发布镜像内容的信息，请参见**[历史记录](https://github.com/devcontainers/images/tree/main/src/miniconda/history)**。

## 使用本镜像### 配置您可以通过在`.devcontainer/devcontainer.json`中使用`image`属性，或在您自己的`Dockerfile`中将`FROM`语句更新为以下内容，直接引用预构建版本的`.devcontainer/Dockerfile`。本仓库中包含一个示例`Dockerfile`。

- `mcr.microsoft.com/devcontainers/miniconda`（或`miniconda:3`）

有关更多详情，请参阅[本指南](https://containers.dev/guide/dockerfile)。

您可以通过引用每个镜像的[语义化版本](https://semver.org/)来决定更新频率。例如：

- `mcr.microsoft.com/devcontainers/miniconda:1-3`
- `mcr.microsoft.com/devcontainers/miniconda:1.0-3`
- `mcr.microsoft.com/devcontainers/miniconda:1.0.0-3`

有关每个版本内容的信息，请参见[历史记录](https://github.com/devcontainers/images/tree/main/src/miniconda/history)，[完整标签列表请参见此处](https://mcr.microsoft.com/v2/devcontainers/miniconda/tags/list)。

或者，您可以使用[.devcontainer](https://github.com/devcontainers/images/tree/main/src/miniconda/.devcontainer)的内容来完全自定义容器内容，或为镜像不支持的容器主机架构构建。

### 使用Conda本开发容器及其关联镜像包含[`conda`包管理器](https://aka.ms/vscode-remote/conda/about)。使用Conda安装的其他包将从Anaconda或您配置的其他仓库下载。要在此容器中重新配置Conda以访问替代仓库，请参见[此处的Conda频道配置信息](https://aka.ms/vscode-remote/conda/channel-setup)。

访问Anaconda仓库受[Anaconda服务条款](https://aka.ms/vscode-remote/conda/terms)约束，部分组织可能需要从Anaconda获取商业许可。**但是**，当此开发容器或其关联镜像与GitHub Codespaces或GitHub Actions一起使用时，**所有用户均被允许**通过该服务使用Anaconda仓库，包括通常被Anaconda要求为商业活动获取付费许可的组织。请注意，第三方包的许可可能由其发布者决定，可能影响您的知识产权，使用风险自负。


#### 使用forwardPorts属性默认情况下，Flask等框架仅在容器内监听localhost。因此，建议使用`forwardPorts`属性（v0.98.0+可用）使这些端口在本地可用。

```json
"forwardPorts": [5000]
```

`appPort`属性[发布](https://docs.docker.com/config/containers/container-networking/#published-ports)而非转发端口，因此应用需要监听`*`或`0.0.0.0`才能从外部访问。这与某些Python框架的默认设置冲突，但幸运的是`forwardPorts`属性没有此限制。


#### 安装Node.js由于用于Python后端的JavaScript前端Web客户端代码通常需要使用基于Node.js的工具构建，您可以通过在`devcontainer.json`中添加以下内容，使用[Node功能](https://github.com/devcontainers/features/tree/main/src/node)安装任何版本的Node：

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "latest"
    }
  }
}
```

#### 使用不同的Conda频道本镜像基于`ContinuumIO/miniconda3` Docker镜像，基础环境中包含conda及其依赖项（*从conda默认频道安装*）。不建议在一个环境中从不同频道安装包，因为可能导致冲突。当需要从其他频道（如`conda-forge`）安装包时，更好的方法是创建新的conda环境。

#### 安装或更新Python工具此容器使用[pipx](https://pipxproject.github.io/pipx/)安装所有Python开发工具，以避免影响全局Python环境。您可以使用此工具在隔离环境中添加其他工具。例如：

```bash
pipx install prospector
```

请注意，如果您更改了默认Python版本，需要运行一些命令来更新工具和`pipx`。详情如下。

#### 安装不同版本的Python如Anaconda[用户FAQ](https://docs.anaconda.com/anaconda/user-guide/faq)中所述，您可以通过从终端运行以下命令安装与镜像中不同版本的Python：

```bash
conda install python=3.6
pip install --no-cache-dir pipx
pipx uninstall pipx
pipx reinstall-all
```

或在Dockerfile中：

```Dockerfile
RUN conda install -y python=3.6 \
    && pip install --no-cache-dir pipx \
    && pipx uninstall pipx \
    && pipx reinstall-all
```

有关更多信息，请参见[pipx文档](https://pipxproject.github.io/pipx/docs/)。

### [可选] 将environment.yml内容添加到镜像为方便起见，构建容器时，此镜像会自动安装父文件夹中`environment.yml`文件的依赖项。您可以通过修改Dockerfile中的以下行来更改此行为：

```Dockerfile
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp
```

## 支持dev container规范镜像在[devcontainers/images](https://github.com/devcontainers/images)仓库中维护。您可以浏览每个镜像并提交issue或功能请求。

## 许可版权所有 (c) Microsoft Corporation。保留所有权利。

根据MIT许可证授权。详见[LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)
