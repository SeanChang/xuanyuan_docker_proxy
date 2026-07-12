---
image: kasmweb/core-centos-7
description: "Kasm Workspaces的CentOS 7基础镜像"
source: https://xuanyuan.cloud/zh/r/kasmweb/core-centos-7
canonical: https://xuanyuan.cloud/zh/r/kasmweb/core-centos-7
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/core-centos-7" title="kasmweb/core-centos-7 Docker 镜像中文简介、标签列表与拉取命令">kasmweb/core-centos-7 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Web核心CentOS 7镜像文档

## 1. 镜像概述

Kasm Workspaces是一个Docker容器流平台，用于提供基于浏览器的桌面、应用程序和Web服务访问。本镜像包含可通过浏览器访问的CentOS 7系统，带有XFCE桌面环境，专为Kasm Workspaces设计，也可独立部署使用。

![镜像截图](https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/core-centos-7.png "镜像截图")

## 2. 核心功能与特性

- 基于CentOS 7操作系统，配备XFCE桌面环境
- 支持通过Web浏览器直接访问
- 由开源项目KasmVNC提供Web原生渲染能力
- 可集成到Kasm Workspaces平台或独立部署
- 提供安全的VNC连接，支持基本的桌面操作

## 3. 使用场景

- 作为Kasm Workspaces平台的一部分，提供CentOS 7桌面环境
- 快速部署可通过浏览器访问的Linux桌面环境
- 用于演示、测试或临时访问需求
- 作为基础镜像构建自定义的浏览器可访问应用环境

## 4. 部署与使用指南

### 4.1 独立部署

本镜像设计用于在Kasm Workspaces中运行，但也可独立部署并通过Web浏览器访问：

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/core-centos-7:1.14.0
```

部署后，可通过浏览器访问：`https://服务器IP:6901`

**默认登录凭据：**
- 用户名：kasm_user
- 密码：password (与VNC_PW环境变量设置的值相同)

> **注意**：某些功能（如音频、上传、下载和麦克风直通）仅在使用Kasm Workspaces进行编排时可用。

### 4.2 Docker Compose部署示例

```yaml
version: '3'
services:
  kasm-centos7:
    image: docker.xuanyuan.run/kasmweb/core-centos-7:1.14.0
    container_name: kasm-centos7
    shm_size: 512m
    ports:
      - "6901:6901"
    environment:
      - VNC_PW=password
    restart: unless-stopped
```

### 4.3 环境变量配置

| 环境变量 | 描述 | 默认值 |
|---------|------|--------|
| VNC_PW | VNC连接密码 | 无 |

## 5. 标签说明

- **1.14.0**：与Kasm Workspaces发布版本对应的稳定镜像
- **1.14.0-rolling**：滚动更新标签，每晚更新以确保包含最新版本
- **develop**：开发测试标签，不保证兼容性

## 6. 附加信息

### 6.1 源代码

- **KasmVNC**：[GitHub](https://github.com/kasmtech/KasmVNC) - 开源VNC服务器，支持Web原生、安全、高性能访问
- **工作区镜像库**：[GitHub](https://github.com/kasmtech/workspaces-images) - Kasm Workspaces Docker镜像库
- **核心镜像库**：[GitHub](https://github.com/kasmtech/workspaces-core-images) - 用于自定义镜像的核心OS基线库

### 6.2 文档资源

- **开发者API**：[文档](https://www.kasmweb.com/docs/latest/developers/developer_api.html) - 与应用程序和工作流集成
- **Workspaces安装**：[文档](https://www.kasmweb.com/docs/latest/install.html) - 安装和配置Kasm Workspaces的说明
- **自定义镜像**：[文档](https://www.kasmweb.com/docs/latest/how_to/building_images.html) - 配置自定义镜像和安装软件的信息

### 6.3 问题反馈

- [GitHub Issue Tracker](https://github.com/kasmtech/workspaces-issues/issues) - 社区问题报告

### 6.4 相关链接

- [Kasm Workspaces下载](https://kasmweb.com/downloads)
- [镜像信息](https://www.kasmweb.com/docs/latest/guide/custom_images.html)
- [Kasm Workspaces文档](https://www.kasmweb.com/docs/latest/install.html)
- [自定义镜像指南](https://www.kasmweb.com/docs/latest/how_to/building_images.html)
