---
image: kasmweb/remmina
description: "为Kasm Workspaces提供的Remmina远程桌面客户端镜像，支持RDP、VNC等多种协议，用于在容器化环境中便捷访问和管理远程计算机。"
source: https://xuanyuan.cloud/zh/r/kasmweb/remmina
canonical: https://xuanyuan.cloud/zh/r/kasmweb/remmina
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/remmina" title="kasmweb/remmina Docker 镜像中文简介、标签列表与拉取命令">kasmweb/remmina 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces Remmina 镜像文档

## 镜像概述与主要用途

本镜像包含可通过浏览器访问的 [Remmina](https://remmina.org/) 版本。Remmina 是一款功能丰富的远程桌面客户端，支持多种协议（如RDP、VNC、SSH等）。该镜像基于Kasm Workspaces技术构建，通过开源项目KasmVNC提供Web原生渲染能力，实现无需本地客户端、直接通过浏览器访问Remmina的远程桌面管理功能。

![镜像截图][Image_Screenshot]

[Image_Screenshot]: https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/remmina.png "Remmina镜像截图"


## 核心功能与特性

- **Web原生访问**：通过浏览器直接访问Remmina，无需安装本地客户端
- **高性能渲染**：基于开源KasmVNC技术，提供低延迟、高清晰度的远程桌面体验
- **灵活配置**：支持通过环境变量传递应用启动参数，满足个性化需求
- **独立部署能力**：可脱离Kasm Workspaces单独运行，也可集成到平台获得增强功能
- **安全基础**：基于Kasm Workspaces安全基线构建，默认配置遵循最小权限原则


## 使用场景与适用范围

- **远程服务器管理**：通过浏览器便捷访问和管理远程服务器（支持RDP/VNC/SSH等协议）
- **临时设备访问**：在无本地客户端的场景下（如公共设备、临时工作站）进行远程桌面操作
- **轻量化运维**：适合个人用户或小型团队的远程桌面管理需求
- **Kasm Workspaces集成**：作为平台组件使用时，可获得音频传输、文件上传/下载、麦克风穿透等增强功能


## 使用方法与配置说明

### 环境变量

| 变量名   | 描述                                                                 |
|----------|----------------------------------------------------------------------|
| APP_ARGS | 启动Remmina时传递的额外参数（例如协议配置、窗口大小设置等）           |


### 独立部署

该镜像设计用于Kasm Workspaces环境，但也可独立部署并通过浏览器直接访问。

#### 部署命令

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/remmina:1.17.0
```

#### 访问说明

1. 容器启动后，通过浏览器访问：`https://服务器IP:6901`
2. 登录凭据：
   - 用户名：`kasm_user`
   - 密码：`password`（由`VNC_PW`环境变量指定）

> **注意**：独立部署模式下，部分功能（如音频传输、文件上传/下载、麦克风穿透）不可用，这些功能仅在Kasm Workspaces编排环境中支持。


### 镜像标签说明

| 标签               | 描述                                                                 |
|--------------------|----------------------------------------------------------------------|
| 1.17.0             | 稳定版本标签，与Kasm Workspaces发行版本同步构建                       |
| 1.17.0-rolling     | 滚动更新标签，每日夜间自动构建，包含最新安全补丁和功能优化             |
| develop            | 开发测试标签，用于功能预览，不保证稳定性和兼容性                       |


## 补充信息

### 源码与相关项目

- **KasmVNC**：Web原生VNC服务器，提供核心渲染能力  
  [GitHub仓库][kasmvnc]
- **Workspaces镜像库**：Kasm Workspaces官方镜像集合（含构建脚本）  
  [GitHub仓库][workspaces_images]
- **核心基础镜像**：用于构建自定义镜像的操作系统基线  
  [GitHub仓库][core_images]


### 官方文档资源

- [Kasm Workspaces安装指南][installation]：部署完整平台的详细步骤  
- [自定义镜像开发文档][custom_images]：基于官方镜像扩展自定义应用的指南  
- [开发者API文档][developer_api]：与外部系统集成的接口说明  


### 问题反馈

通过GitHub Issue追踪器提交bug报告或功能建议：  
[GitHub Issues][github_support]


[workspaces_images]: https://github.com/kasmtech/workspaces-images "Workspaces Images"
[kasmvnc]: https://github.com/kasmtech/KasmVNC "KasmVNC"
[core_images]: https://github.com/kasmtech/workspaces-core-images "Core Images"
[developer_api]: https://www.kasmweb.com/docs/latest/developers/developer_api.html "Developer API"
[installation]: https://www.kasmweb.com/docs/latest/install.html "Installation"
[custom_images]: https://www.kasmweb.com/docs/latest/how_to/building_images.html "Custom Images"
[github_support]: https://github.com/kasmtech/workspaces-issues/issues "GitHub Support"
