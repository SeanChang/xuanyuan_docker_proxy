---
image: kasmweb/filezilla
description: "适用于Kasm Workspaces的FileZilla镜像，提供基于浏览器的远程FTP客户端功能，支持通过Kasm工作空间进行文件传输操作。"
source: https://xuanyuan.cloud/zh/r/kasmweb/filezilla
canonical: https://xuanyuan.cloud/zh/r/kasmweb/filezilla
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/filezilla" title="kasmweb/filezilla Docker 镜像中文简介、标签列表与拉取命令">kasmweb/filezilla 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces FileZilla 镜像文档

## 镜像概述和主要用途

Kasm Workspaces 是一个 Docker 容器流平台，用于提供基于浏览器的桌面、应用程序和 Web 服务访问。本镜像包含可通过浏览器访问的 [FileZilla](https://filezilla-project.org/) 版本，可在浏览器中直接使用 FileZilla FTP 客户端。

## 核心功能和特性

- 基于浏览器访问 FileZilla 应用程序
- 通过 KasmVNC 实现 Web 原生渲染，提供安全、高性能的远程访问
- 支持独立部署或集成到 Kasm Workspaces 平台
- 可通过环境变量自定义应用启动参数

![Image Screenshot](https://5856039.fs1.hubspotusercontent-na1.net/hubfs/5856039/dockerhub/filezilla.png "Image Screenshot")

## 使用场景和适用范围

- 作为 Kasm Workspaces 平台的一部分提供 FTP 客户端功能
- 独立部署提供基于 Web 的临时 FTP 访问能力
- 适用于需要通过浏览器快速访问 FTP 服务的场景
- 开发和测试环境中的文件传输需求

## 详细使用方法和配置说明

### 环境变量

| 变量名 | 描述 |
|--------|------|
| `APP_ARGS` | 启动应用程序时传递的额外参数 |

### 独立部署

该镜像设计用于在 Kasm Workspaces 中运行，但也可独立部署并通过 Web 浏览器访问：

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/filezilla:1.17.0
```

容器启动后，可通过浏览器访问：`https://服务器IP:6901`

- 用户：kasm_user
- 密码：password

> **注意**：部分功能（如音频、上传、下载和麦克风传递）仅在使用 Kasm Workspaces 编排时可用。

### Docker Compose 配置示例

```yaml
version: '3'
services:
  filezilla:
    image: docker.xuanyuan.run/kasmweb/filezilla:1.17.0
    shm_size: 512m
    ports:
      - "6901:6901"
    environment:
      - VNC_PW=password
      # 可选：添加额外应用参数
      # - APP_ARGS=--some-argument
    restart: unless-stopped
```

## 镜像标签

| 标签 | 描述 |
|------|------|
| `1.17.0` | 基于 Kasm Workspaces 发布版本构建的稳定镜像 |
| `1.17.0-rolling` | 滚动更新标签，每晚更新以确保包含最新版本 |
| `develop` | 开发测试标签，不保证兼容性 |

## 附加信息

### 相关资源

- **源代码**
  - [KasmVNC GitHub](https://github.com/kasmtech/KasmVNC)：开源 VNC 服务器，支持 Web 原生、安全、高性能访问
  - [Workspaces Images GitHub](https://github.com/kasmtech/workspaces-images)：Workspaces Docker 镜像库
  - [Core Images GitHub](https://github.com/kasmtech/workspaces-core-images)：用于自定义镜像的核心 OS 基线库

- **文档**
  - [开发者 API](https://www.kasmweb.com/docs/latest/developers/developer_api.html)：与应用程序和工作流集成
  - [Workspaces 安装指南](https://www.kasmweb.com/docs/latest/install.html)：安装和配置 Kasm Workspaces 的说明
  - [自定义镜像](https://www.kasmweb.com/docs/latest/how_to/building_images.html)：配置自定义镜像和安装软件的信息

### 问题报告

如遇到问题，请通过 [GitHub Issue Tracker](https://github.com/kasmtech/workspaces-issues/issues) 提交报告。

### 社区资源

- [Kasm Workspaces 社区版](https://kasmweb.com/downloads)：免费社区版下载
- [镜像信息](https://www.kasmweb.com/docs/latest/guide/custom_images.html)：Kasm 镜像库详细信息
- [KasmVNC](https://github.com/kasmtech/KasmVNC)：开源 VNC 项目，提供 Web 原生渲染能力
