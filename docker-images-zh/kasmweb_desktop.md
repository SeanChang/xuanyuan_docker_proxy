---
image: kasmweb/desktop
description: "Ubuntu桌面版是Kasm Workspaces平台提供的一款基于Ubuntu操作系统的容器化桌面环境，旨在为用户提供安全、高效的远程工作体验；它保留了Ubuntu原生桌面的直观操作与丰富功能，预装常用办公及开发工具，支持跨设备访问，并通过Kasm的隔离运行架构确保数据安全，同时具备灵活的资源管理能力，适用于开发、办公、学习等多种场景，助力用户轻松构建云端虚拟工作空间。"
source: https://xuanyuan.cloud/zh/r/kasmweb/desktop
canonical: https://xuanyuan.cloud/zh/r/kasmweb/desktop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/desktop" title="kasmweb/desktop Docker 镜像中文简介、标签列表与拉取命令">kasmweb/desktop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces 介绍  


Kasm Workspaces 是一款 Docker 容器流平台，支持通过浏览器访问桌面环境、应用程序及 Web 服务。


## 在线演示  
点击下方链接在新窗口启动实时演示：  
[Live Demo]   

[![Kasm Desktop 演示入口] ]   

*注：演示时长限制为 3 分钟，出于安全考虑，上传/下载功能已受限。*  


## 快速开始  
- **免费试用社区版**：[下载社区版] 。  
- **开源镜像库**：Kasm 团队开源了完整的镜像库（[镜像说明]  & [源码] ）。  
- **核心渲染技术**：基于开源项目 [KasmVNC]  实现 Web 原生渲染。  


## 关于本镜像  
该镜像包含可通过浏览器访问的 Ubuntu Jammy 桌面环境，预装 Chrome 和 Firefox 浏览器。  

![镜像截图]([] "桌面环境截图")  


## 独立部署  
本镜像默认用于 Kasm Workspaces 平台，但也可独立部署并通过浏览器访问。  


### 部署步骤  
执行以下 Docker 命令启动容器：  
```bash  
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/desktop:1.17.0  
```  

容器启动后，通过浏览器访问：`[]  

- **登录信息**：  
  - 用户名：kasm_user  
  - 密码：password  


### 注意事项  
独立部署时，部分功能（如音频、文件上传/下载、麦克风直通等）可能受限。这些功能需配合 Kasm Workspaces 编排使用才能完整支持。  


## 镜像标签说明  
- **1.17.0**：与 Kasm Workspaces 版本同步，基于固定版本构建。  
- **1.17.0-rolling**：滚动更新标签，每日夜间重建，确保镜像包含最新版本。  
- **develop**：开发测试标签，兼容性不做保证，仅供测试使用。  


## 补充信息  

### 源代码  
- [KasmVNC GitHub] ：开源 VNC 服务器，支持 Web 原生访问，安全且高性能。  
- [Images GitHub] ：Workspaces 镜像库源码。  
- [Core Images GitHub] ：用于自定义镜像的基础 OS 基线库。  


### 官方文档  
- [开发者 API] ：集成应用与工作流。  
- [安装指南] ：Kasm Workspaces 安装与配置步骤。  
- [自定义镜像] ：自定义镜像配置及软件安装说明。  


### 问题反馈  
- [GitHub Issue Tracker] ：社区问题反馈平台。
