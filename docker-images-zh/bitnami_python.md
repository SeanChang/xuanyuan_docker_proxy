---
image: bitnami/python
description: "Bitnami 提供的 Python 安全镜像，基于 Photon Linux 构建，具备加固安全、漏洞管理及合规支持等特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/python
canonical: https://xuanyuan.cloud/zh/r/bitnami/python
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/python" title="bitnami/python Docker 镜像中文简介、标签列表与拉取命令">bitnami/python — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/python" title="bitnami/python Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/python</a>

# Bitnami Python 镜像

## 什么是 Python？

> Python 是一种编程语言，可让您快速工作并更有效地集成系统。

[Python 概览](https://www.python.org/)
商标声明：本软件列表由 Bitnami 打包。产品中提及的相关商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

## 概览

```console
docker run -it --name python bitnami/python
```

这是由 Bitnami 构建和维护的经过加固、CVE 数量极少的镜像。Bitnami 安全镜像（BSI）基于云优化、安全加固的企业级操作系统 [Photon Linux](https://vmware.github.io/photon/) 构建。选择 BSI 镜像的理由：
- 流行开源软件的加固安全镜像，漏洞数量接近零
- 漏洞分类与优先级划分，包含 VEX 声明、KEV 和 EPSS 评分
- 专注合规性，支持 FIPS、STIG 和离线部署选项，包括安全物料清单（SBOM）
- 通过 in-toto 实现软件供应链来源证明
- 为业界最受欢迎的 Helm 图表提供一流支持

每个镜像均附带有价值的安全元数据。您可以在 [我们的公共目录](https://app-catalog.vmware.com/bitnami/apps) 中查看元数据。注意：部分数据仅对 [BSI 商业订阅用户](https://bitnami.com/) 开放。

如果您正在寻找我们基于 Debian Linux 的上一代镜像，请参阅 Bitnami Legacy 仓库。

## 支持的标签及对应的 `Dockerfile` 链接

了解更多关于 Bitnami 标签策略以及滚动标签与不可变标签之间的区别，请参阅 [我们的文档页面](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)。

您可以通过查看分支文件夹中的 `tags-info.yaml` 文件（即 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）了解不同标签之间的对应关系。

通过关注 [bitnami/containers GitHub 仓库](https://github.com/bitnami/containers) 订阅项目更新。

### 弃用说明（2022-01-21）

`prod` 标签已被移除；今后将仅发布常规容器镜像。

### 弃用说明（2020-08-18）

`prod` 标签的格式约定已更改：
- `BRANCH-debian-10-prod` 现在标记为 `BRANCH-prod-debian-10`
- `VERSION-debian-10-rX-prod` 现在标记为 `VERSION-prod-debian-10-rX`
- `latest-prod` 已弃用

## 获取本镜像

获取 Bitnami Python 镜像的推荐方式是从 [Docker Hub 仓库](https://hub.docker.com/r/bitnami/python) 拉取预构建镜像。

```console
docker pull bitnami/python:latest
```

如需使用特定版本，您可以拉取带版本号的标签。您可以在 Docker Hub 仓库中查看 [可用版本列表](https://hub.docker.com/r/bitnami/python/tags/)。

```console
docker pull bitnami/python:[TAG]
```

如果您愿意，也可以通过克隆仓库、进入包含 Dockerfile 的目录并执行 `docker build` 命令来自行构建镜像。请记得将以下示例命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 路径占位符替换为正确的值。

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```

## 进入 REPL

默认情况下，运行此镜像将使您进入 Python REPL，您可以在其中交互式地测试和尝试 Python 功能。

```console
docker run -it --name python bitnami/python
```

## 配置

### 运行 Python 脚本

Python 镜像的默认工作目录为 `/app`。您可以将主机上包含 Python 脚本的文件夹挂载到此目录，然后使用 `python` 命令正常运行脚本。

```console
docker run -it --name python -v /path/to/app:/app bitnami/python \
  python script.py
```

### 运行带有依赖包的 Python 应用

如果您的 Python 应用有定义依赖的 `requirements.txt` 文件，您可以在运行应用前安装依赖。

```console
docker run --rm -v /path/to/app:/app bitnami/python pip install -r requirements.txt
docker run -it --name python -v /path/to/app:/app bitnami/python python script.py
```

或使用 Docker Compose：

```yaml
python:
  image: bitnami/python:latest
  command: "sh -c 'pip install -r requirements.txt && python script.py'"
  volumes:
    - .:/app
```

**延伸阅读：**

- [python 文档](https://www.python.org/doc/)
- [pip 文档](https://pip.pypa.io/en/stable/)

## 维护

### 升级镜像

Bitnami 会在 upstream 发布 Python 更新（包括安全补丁）后尽快提供更新版本。建议您按照以下步骤升级容器。

#### 步骤 1：获取更新后的镜像

```console
docker pull bitnami/python:latest
```

如果使用 Docker Compose，请将 `image` 属性的值更新为 `bitnami/python:latest`。

#### 步骤 2：移除当前运行的容器

```console
docker rm -v python
```

或使用 Docker Compose：

```console
docker-compose rm -v python
```

#### 步骤 3：运行新镜像

使用新镜像重新创建容器。

```console
docker run --name python bitnami/python:latest
```

或使用 Docker Compose：

```console
docker-compose up python
```

## 使用 `docker-compose.yaml`

请注意，此文件未经内部测试。因此，我们建议仅将其用于开发或测试目的。

如果您在 `docker-compose.yaml` 文件中发现任何问题，请随时报告，或按照我们的 [贡献指南](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md) 提交修复。

## 贡献

我们欢迎您为此 Docker 镜像做出贡献。您可以通过创建 [issue](https://github.com/bitnami/containers/issues) 请求新功能，或提交 [pull request](https://github.com/bitnami/containers/pulls) 贡献代码。

## 问题反馈

如果您在运行此容器时遇到问题，可以提交 [issue](https://github.com/bitnami/containers/issues/new/choose)。为了让我们提供更好的支持，请务必填写 issue 模板。

## 许可证

版权所有 &copy; 2025 Broadcom。"Broadcom" 一词指 Broadcom Inc. 及其子公司。

根据 Apache 许可证 2.0 版（"许可证"）授权；除非遵守许可证，否则您不得使用此文件。您可以在以下位置获取许可证副本：

<http://www.apache.org/licenses/LICENSE-2.0>

除非适用法律要求或书面同意，否则根据许可证分发的软件按"原样"分发，不附带任何明示或暗示的担保或条件。有关许可证下权限和限制的具体语言，请参阅许可证。
