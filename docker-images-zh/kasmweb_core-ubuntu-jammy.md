---
image: kasmweb/core-ubuntu-jammy
description: "基于Ubuntu Jammy系统的Kasm Workspaces基础镜像，用于构建和运行Kasm Workspaces环境。"
source: https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-jammy
canonical: https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-jammy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-jammy" title="kasmweb/core-ubuntu-jammy Docker 镜像中文简介、标签列表与拉取命令">kasmweb/core-ubuntu-jammy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces Ubuntu Jammy 基础镜像

## 镜像概述和主要用途

Kasm Workspaces 是一个 Docker 容器流平台，用于通过浏览器提供对桌面、应用程序和 Web 服务的访问。本镜像为 Kasm Workspaces 提供 Ubuntu Jammy 基础环境，包含可通过浏览器访问的 Ubuntu Jammy 桌面系统，基于开源的 KasmVNC 技术实现 Web 原生渲染，支持安全、高性能的远程访问。


## 核心功能和特性

- **浏览器访问能力**：无需安装客户端，直接通过 Web 浏览器访问 Ubuntu 桌面环境
- **KasmVNC 支持**：集成开源 KasmVNC 服务器，提供 Web 原生、安全、高性能的远程桌面渲染
- **独立部署支持**：可脱离 Kasm Workspaces 独立运行，通过浏览器直接访问
- **多版本标签策略**：提供稳定版、滚动更新版和开发测试版标签，满足不同使用需求
- **基础系统环境**：基于 Ubuntu Jammy 构建，可作为自定义镜像的基础模板


## 使用场景和适用范围

- **Kasm Workspaces 集成环境**：作为 Kasm Workspaces 平台的基础镜像，用于构建和运行浏览器可访问的桌面或应用容器
- **独立浏览器访问场景**：需通过 Web 浏览器快速访问 Ubuntu 桌面环境的开发、测试或演示场景
- **自定义镜像基础**：作为构建包含特定应用的自定义镜像的基础 OS 模板


## 使用方法和配置说明

### 独立部署

本镜像设计用于 Kasm Workspaces 环境，但也支持独立部署并通过浏览器访问。

#### 部署命令

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/core-ubuntu-jammy:1.17.0
```

#### 参数说明

- `--shm-size=512m`：设置共享内存大小，确保桌面环境流畅运行
- `-p 6901:6901`：映射容器 VNC 服务端口到主机，默认端口为 6901
- `-e VNC_PW=password`：设置 VNC 访问密码，用于浏览器登录验证
- `--rm`：容器停止后自动删除
- `-it`：启用交互终端

#### 访问方式

部署完成后，通过浏览器访问：`https://<服务器IP>:6901`

- 用户名：`kasm_user`
- 密码：部署时通过 `VNC_PW` 环境变量设置的值（示例中为 `password`）

#### 功能限制说明

> **注意**：部分功能（如音频、文件上传/下载、麦克风直通）仅在 Kasm Workspaces 编排环境中可用，独立部署时可能受限。


## 标签说明

| 标签                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `1.17.0`            | 稳定版标签，与 Kasm Workspaces 发行版本同步，功能稳定且兼容性有保障   |
| `1.17.0-rolling`    | 滚动更新标签，每日夜间构建更新，确保包含最新安全补丁和功能改进       |
| `develop`           | 开发测试标签，用于内部测试，不保证功能稳定性和版本兼容性             |


## 补充信息

### 源代码仓库

- **KasmVNC**：[GitHub](https://github.com/kasmtech/KasmVNC) - 开源 VNC 服务器，提供 Web 原生、安全、高性能的远程桌面渲染
- **工作区镜像库**：[GitHub](https://github.com/kasmtech/workspaces-images) - Kasm Workspaces 官方 Docker 镜像库
- **核心基础镜像库**：[GitHub](https://github.com/kasmtech/workspaces-core-images) - 用于构建自定义镜像的核心 OS 基础模板库

### 官方文档

- **开发者 API**：[文档](https://www.kasmweb.com/docs/latest/developers/developer_api.html) - 与应用程序和工作流集成的接口说明
- **Kasm Workspaces 安装配置**：[文档](https://www.kasmweb.com/docs/latest/install.html) - 安装和配置 Kasm Workspaces 的详细指南
- **自定义镜像构建**：[文档](https://www.kasmweb.com/docs/latest/how_to/building_images.html) - 配置自定义镜像和安装软件的说明

### 问题反馈

- **GitHub Issue Tracker**：[反馈渠道](https://github.com/kasmtech/workspaces-issues/issues) - 社区问题报告和跟踪平台

### 相关资源

- **Kasm Workspaces 社区版下载**：[下载页面](https://kasmweb.com/downloads)
- **镜像详细信息**：[官方指南](https://www.kasmweb.com/docs/latest/guide/custom_images.html) - 自定义镜像构建指南

![镜像截图](https://5856039.fs1.hubspotusercontent-na1.net/hubfs/5856039/dockerhub/image-screenshots/core-ubuntu-jammy.png "Ubuntu Jammy 桌面环境截图")
