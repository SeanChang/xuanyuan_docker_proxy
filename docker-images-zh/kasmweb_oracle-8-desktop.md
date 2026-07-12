---
image: kasmweb/oracle-8-desktop
description: "Kasm Workspaces的Oracle Linux 8桌面镜像，提供浏览器可访问的桌面环境，预装多种生产力和开发应用，支持独立部署或在Kasm Workspaces中使用，基于开源KasmVNC实现高性能Web访问。"
source: https://xuanyuan.cloud/zh/r/kasmweb/oracle-8-desktop
canonical: https://xuanyuan.cloud/zh/r/kasmweb/oracle-8-desktop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/oracle-8-desktop" title="kasmweb/oracle-8-desktop Docker 镜像中文简介、标签列表与拉取命令">kasmweb/oracle-8-desktop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces Oracle Linux 8桌面镜像

## 在线演示

[在线演示](https://app.kasmweb.com/#/cast/8652257120)（在新浏览器窗口中启动实时演示）

![Oracle Linux 8桌面演示](https://info.kasmweb.com/hubfs/dockerhub/GIFs/oracle-8-desktop.gif)

> **注意**：演示限制3分钟，出于安全考虑，上传/下载功能受限。

## 快速开始

尝试免费社区版：[下载](https://kasmweb.com/downloads)

Kasm Workspaces团队开源了镜像库：[镜像信息](https://www.kasmweb.com/docs/latest/guide/custom_images.html) & [源代码](https://github.com/kasmtech/workspaces-images)

Web原生渲染由开源项目KasmVNC提供支持：[KasmVNC](https://github.com/kasmtech/KasmVNC)

## 镜像概述和主要用途

该镜像包含浏览器可访问的Oracle Linux 8桌面环境，预装多种生产力和开发应用。设计用于Kasm Workspaces平台（容器流送平台，提供桌面、应用和Web服务的浏览器访问），也可独立部署并通过Web浏览器直接访问。

![镜像截图](https://5856039.fs1.hubspotusercontent-na1.net/hubfs/5856039/dockerhub/oracle-8-desktop.png)

## 核心功能和特性

- **浏览器原生访问**：无需安装客户端，通过Web浏览器直接访问Linux桌面
- **预装应用套件**：包含生产力工具和开发软件，满足日常工作需求
- **灵活部署模式**：支持独立运行或集成到Kasm Workspaces平台
- **高性能渲染**：基于开源KasmVNC技术，提供低延迟、高清晰度的Web访问体验
- **安全可靠**：基于Oracle Linux 8稳定基线，遵循安全最佳实践

## 使用场景和适用范围

- 远程办公：需要通过浏览器访问Linux桌面环境的远程工作场景
- 开发测试：快速部署包含预置工具的Linux开发环境
- 临时工作站：临时需要Linux桌面进行文件处理或应用测试的场景
- 教学培训：共享标准化Linux桌面环境进行教学演示

## 详细使用方法和配置说明

### 独立部署

该镜像可独立部署，无需Kasm Workspaces平台即可通过浏览器访问：

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/oracle-8-desktop:1.17.0
```

#### 访问方式
容器启动后，通过浏览器访问：`https://服务器IP:6901`

#### 登录凭据
- 用户名：kasm_user
- 密码：password（通过`VNC_PW`环境变量设置）

> **注意**：部分高级功能（如音频、上传/下载、麦克风直通）仅在Kasm Workspaces中使用时可用。

## 标签说明

- **1.17.0**  
  基于Kasm Workspaces发布版本构建的稳定镜像，版本号与Workspaces保持一致。

- **1.17.0-rolling**  
  滚动更新标签，每日构建以集成最新安全补丁和软件更新。

- **develop**  
  开发测试标签，用于预览新功能，不保证稳定性和兼容性。

## 附加信息

### 源代码
- **KasmVNC**：[GitHub](https://github.com/kasmtech/KasmVNC) - 开源VNC服务器，支持Web原生、安全、高性能访问
- **Workspaces镜像库**：[GitHub](https://github.com/kasmtech/workspaces-images) - Kasm Workspaces官方镜像集合
- **核心镜像库**：[GitHub](https://github.com/kasmtech/workspaces-core-images) - 用于构建自定义镜像的基础OS基线

### 官方文档
- **开发者API**：[文档](https://www.kasmweb.com/docs/latest/developers/developer_api.html) - 与应用和工作流集成指南
- **Workspaces安装**：[文档](https://www.kasmweb.com/docs/latest/install.html) - 安装和配置Kasm Workspaces的详细说明
- **自定义镜像**：[文档](https://www.kasmweb.com/docs/latest/how_to/building_images.html) - 自定义镜像配置和软件安装指南

### 问题反馈
- **GitHub Issue Tracker**：[提交问题](https://github.com/kasmtech/workspaces-issues/issues) - 社区问题报告和支持
