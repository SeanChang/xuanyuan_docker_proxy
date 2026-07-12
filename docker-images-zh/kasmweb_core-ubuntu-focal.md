---
image: kasmweb/core-ubuntu-focal
description: "Kasm Workspaces的Ubuntu Focal基础镜像，提供运行所需的底层环境支持。"
source: https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-focal
canonical: https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-focal
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-focal" title="kasmweb/core-ubuntu-focal Docker 镜像中文简介、标签列表与拉取命令">kasmweb/core-ubuntu-focal 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Workspaces Core Ubuntu Focal 镜像文档


## 镜像概述和主要用途

Kasm Workspaces 是一个 Docker 容器流平台，用于通过浏览器提供对桌面、应用程序和 Web 服务的访问。本镜像为 Kasm Workspaces 提供基于 Ubuntu Focal 的基础镜像，包含浏览器可访问的 Ubuntu Focal 桌面环境，支持通过 Web 浏览器直接访问。


## 核心功能和特性

- **浏览器访问能力**：无需本地安装 VNC 客户端，通过 Web 浏览器即可访问 Ubuntu Focal 桌面环境  
- **Web 原生渲染**：基于开源项目 KasmVNC 实现，提供安全、高性能的 Web 原生渲染  
- **独立部署支持**：可脱离 Kasm Workspaces 独立运行，也可集成到 Kasm Workspaces 实现完整功能  
- **轻量化设计**：优化的容器化部署，支持快速启动和资源高效利用  


## 使用场景和适用范围

- **独立测试环境**：快速部署 Ubuntu Focal 桌面用于临时测试或演示  
- **Kasm Workspaces 集成**：作为 Kasm Workspaces 平台的基础镜像，提供标准化桌面环境  
- **开发与调试**：用于构建自定义镜像的基础 OS 基线（需结合 Kasm Workspaces 自定义镜像功能）  


## 部署与使用指南

### 独立部署

本镜像可独立部署并通过 Web 浏览器访问，执行以下命令启动容器：

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/core-ubuntu-focal:1.16.0
```

#### 参数说明
- `--shm-size=512m`：设置共享内存大小，确保桌面环境流畅运行  
- `-p 6901:6901`：映射容器端口 6901 到主机，用于 Web 访问  
- `-e VNC_PW=password`：设置 VNC 访问密码（即登录密码）  
- `kasmweb/core-ubuntu-focal:1.16.0`：指定镜像名称及标签  


#### 访问方式
容器启动后，通过浏览器访问：  
`https://<服务器IP>:6901`  

登录信息：  
- 用户名：`kasm_user`  
- 密码：`password`（与启动命令中 `VNC_PW` 参数值一致）  


#### 功能限制说明
独立部署时，部分功能（如音频、文件上传/下载、麦克风 passthrough）仅在集成到 Kasm Workspaces 平台时可用。


## 镜像标签

| 标签                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `1.16.0`            | 基于 Kasm Workspaces 发布版本构建，版本固定，兼容性有保障             |
| `1.16.0-rolling`    | 滚动更新标签，每日夜间构建，包含最新安全补丁和功能更新                 |
| `develop`           | 开发测试标签，用于功能预览，不保证兼容性和稳定性                       |


## 附加信息

### 源代码
- **KasmVNC**：开源 VNC 服务器，提供 Web 原生、安全、高性能的渲染能力  
  [GitHub 地址](https://github.com/kasmtech/KasmVNC)  
- **Workspaces 镜像库**：Kasm Workspaces 官方镜像库  
  [GitHub 地址](https://github.com/kasmtech/workspaces-images)  
- **核心镜像库**：用于构建自定义镜像的基础 OS 基线库  
  [GitHub 地址](https://github.com/kasmtech/workspaces-core-images)  


### 官方文档
- **Kasm Workspaces 安装指南**：安装和配置 Kasm Workspaces 平台  
  [文档地址](https://www.kasmweb.com/docs/latest/install.html)  
- **自定义镜像开发**：配置自定义镜像及安装软件的指南  
  [文档地址](https://www.kasmweb.com/docs/latest/how_to/building_images.html)  
- **开发者 API**：与应用程序和工作流集成的接口文档  
  [文档地址](https://www.kasmweb.com/docs/latest/developers/developer_api.html)  


### 问题反馈
如遇功能异常或漏洞，可通过 GitHub Issues 提交：  
[Issue Tracker](https://github.com/kasmtech/workspaces-issues/issues)  


## 注意事项
- 独立部署时，部分高级功能（音频、文件传输等）依赖 Kasm Workspaces 平台编排，独立模式下不可用  
- 滚动标签（如 `1.16.0-rolling`）可能引入不兼容变更，生产环境建议使用固定版本标签（如 `1.16.0`）  
- 镜像截图参考：  
  ![Ubuntu Focal 桌面截图](https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/core-ubuntu-focal.png "Ubuntu Focal 桌面截图")
