---
image: library/opensuse
description: "已弃用；openSUSE项目当前提供的镜像请查看opensuse/leap和opensuse/tumbleweed。"
source: https://xuanyuan.cloud/zh/r/library/opensuse
canonical: https://xuanyuan.cloud/zh/r/library/opensuse
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/opensuse" title="library/opensuse Docker 镜像中文简介、标签列表与拉取命令">library/opensuse 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# openSUSE Docker镜像文档

## 镜像概述和主要用途

本项目曾包含openSUSE发行版的稳定版本Docker镜像。**注意：此镜像已被弃用**。

### 弃用通知

这些镜像已被移除，建议使用由[openSUSE项目](https://www.opensuse.org/)发布团队提供和维护的[`opensuse/leap`](https://hub.docker.com/r/opensuse/leap)和[`opensuse/tumbleweed`](https://hub.docker.com/r/opensuse/tumbleweed)镜像。

不支持版本的镜像归档可在[`opensuse/archive`](https://hub.docker.com/r/opensuse/archive)找到。

## 核心功能和特性

- 基于openSUSE发行版的稳定版本构建
- 最小化的包选择以减少镜像体积
- 包含标准openSUSE软件仓库配置

## 快速参考

- **维护者**：[SUSE容器团队](https://github.com/openSUSE/docker-containers-build)
- **获取帮助**：[Docker社区论坛](https://forums.docker.com/)、[Docker社区Slack](https://dockr.ly/slack)或[Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)
- **提交问题**：[https://github.com/openSUSE/docker-containers-build/issues](https://github.com/openSUSE/docker-containers-build/issues)
- **支持架构**：无
- **镜像工件详情**：[repo-info仓库的`repos/opensuse/`目录](https://github.com/docker-library/repo-info/blob/master/repos/opensuse)（包含镜像元数据、传输大小等）
- **镜像更新**：[official-images仓库的`library/opensuse`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fopensuse)
- **描述来源**：[docs仓库的`opensuse/`目录](https://github.com/docker-library/docs/tree/master/opensuse)

## 命名约定

每个镜像都使用发行版编号（如"13.1"）和代码名称（如"Bottle"）进行标记。最新的稳定版本始终可通过"latest"标签获取。

## 构建信息

这些镜像使用[KIWI](https://github.com/openSUSE/kiwi)生成。其源文件可在[此仓库](https://github.com/openSUSE/docker-containers)中找到。

## 仓库和包

为减少镜像占用空间，包选择保持最小化。但镜像已包含以下仓库：

- OSS
- OSS Updates
- Non-OSS
- Non-OSS Updates

## 许可证

查看此镜像中包含的软件的[许可证信息](https://en.opensuse.org/openSUSE:License)。请注意，安装的各个软件包可能有其自己的许可证，您也必须遵守。许可证信息可通过内置的包管理器获取。

与所有Docker镜像一样，这些镜像可能还包含其他可能受其他许可证约束的软件（如基础发行版中的Bash等，以及主要软件的任何直接或间接依赖项）。

一些能够自动检测到的其他许可证信息可能会在[`repo-info`仓库的`opensuse/`目录](https://github.com/docker-library/repo-info/tree/master/repos/opensuse)中找到。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用都符合其中包含的所有软件的相关许可证。

## 支持和维护

- **支持的标签**：无
- **支持的架构**：无
