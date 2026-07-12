---
image: libreofficedocker/libreoffice-unoserver
description: "基于Alpine的Docker镜像，集成LibreOffice的unoserver和REST API，提供文档处理能力，适用于内部系统的文档转换等场景。"
source: https://xuanyuan.cloud/zh/r/libreofficedocker/libreoffice-unoserver
canonical: https://xuanyuan.cloud/zh/r/libreofficedocker/libreoffice-unoserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/libreofficedocker/libreoffice-unoserver" title="libreofficedocker/libreoffice-unoserver Docker 镜像中文简介、标签列表与拉取命令">libreofficedocker/libreoffice-unoserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述

一个在Docker中集成LibreOffice的unoserver和REST API的打包镜像。

### 预构建镜像

该镜像基于 [`alpine`](https://hub.docker.com/_/alpine) 构建。

> **注意**
> 
> 您可以在 [Docker Hub](https://hub.docker.com/u/libreofficedocker) 上找到预构建镜像。所有发布版本均遵循Alpine的版本号，仅构建最近的10个版本。

```docker
docker pull docker.xuanyuan.run/libreofficedocker/libreoffice-unoserver:${ALPINE_VERSION}
```

### REST API

此镜像默认内置用于unoserver的REST API。

更多信息请参见 https://github.com/libreofficedocker/unoserver-rest-api。

> **警告**
> 
> 重要提示：REST API层不提供任何形式的安全保护。不建议将此容器镜像暴露到互联网。

## 可用版本

以下版本标签可供使用：

- `edge`
- `3.19`
- `3.18`
- `3.17`
- `3.16`
- `3.15`
- `3.14`
- `3.13`
- `3.12`
- `3.11`

> **注意**
> 
> 容器镜像通过自动化流程定期构建并推送到仓库。每周日00:00执行构建，以确保镜像包含最新的安全补丁和更新。
> 
> 如果需要固定特定版本，可使用对应提交哈希作为标签拉取镜像。详情请查看 [![Release](https://github.com/libreofficedocker/libreoffice-unoserver/actions/workflows/release.yml/badge.svg?branch=v2)](https://github.com/libreofficedocker/libreoffice-unoserver/actions/workflows/release.yml) 工作流获取可用的构建和标签。
> 
> 部分工作流运行显示为失败，但镜像仍会构建并推送到仓库。失败的运行是由于Alpine v3.19中的一些Python变更导致。

## 限制

> ⚠️⚠️ 请勿将容器暴露到互联网 ⚠️⚠️

重要提示：REST API层不提供任何形式的安全保护。

服务一次只能处理一个文档。`unoserver`和**REST API**均未内置任何形式的负载均衡机制。

## 许可证

基于 [Apache-2.0 许可证](LICENSE) 授权。
