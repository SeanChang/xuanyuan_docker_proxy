---
image: kasmweb/core-ubuntu-noble
description: "基于Ubuntu Noble的Kasm Workspaces基础镜像"
source: https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-noble
canonical: https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-noble
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/core-ubuntu-noble" title="kasmweb/core-ubuntu-noble Docker 镜像中文简介、标签列表与拉取命令">kasmweb/core-ubuntu-noble 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kasm Web Core Ubuntu Noble 镜像文档


## 镜像概述和主要用途
Kasm Workspaces 是一个 Docker 容器流平台，用于提供基于浏览器的桌面、应用程序和 Web 服务访问。本镜像包含可通过浏览器访问的 Ubuntu Noble 版本，设计用于在 Kasm Workspaces 中原生运行，同时也支持独立部署并通过 Web 浏览器访问。


## 核心功能和特性
- **浏览器访问能力**：无需本地安装客户端，直接通过 Web 浏览器访问 Ubuntu Noble 桌面环境。  
- **KasmVNC 技术支持**：采用开源项目 KasmVNC 提供 Web 原生渲染，确保安全、高性能的远程显示体验。  
- **独立部署支持**：可脱离 Kasm Workspaces 独立运行，通过简单配置即可通过浏览器访问。  
- **功能限制**：独立部署时，音频、上传、下载及麦克风直通等功能不可用，需配合 Kasm Workspaces 实现完整功能。  


## 使用场景和适用范围
- **独立桌面环境**：快速部署浏览器可访问的 Ubuntu Noble 桌面，用于临时测试、演示或轻量办公。  
- **Kasm Workspaces 集成**：作为 Kasm Workspaces 平台的一部分，实现完整功能（如文件传输、音频支持）的容器化桌面/应用交付。  


## 使用方法和配置说明

### 独立部署
本镜像支持独立运行，通过以下步骤部署：

#### 1. 运行容器
执行以下 Docker 命令启动容器：
```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/core-ubuntu-noble:1.17.0
```

#### 参数说明
- `--shm-size=512m`：设置共享内存大小，优化桌面环境性能。  
- `-p 6901:6901`：映射容器的 6901 端口到主机，用于 Web 访问。  
- `-e VNC_PW=password`：设置 VNC 访问密码（替换 `password` 为自定义密码）。  
- `--rm`：容器停止后自动删除。  
- `-it`：交互式运行，支持终端输入。

#### 2. 访问容器
容器启动后，通过浏览器访问：  
`https://<服务器IP>:6901`  

登录信息：  
- 用户名：`kasm_user`  
- 密码：步骤 1 中设置的 `VNC_PW` 值（示例中为 `password`）。


## 标签说明
镜像标签遵循以下规则：

| 标签                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `1.17.0`            | 与 Kasm Workspaces 发行版本绑定，版本固定，兼容性稳定。               |
| `1.17.0-rolling`    | 滚动更新标签，每日夜间构建，包含最新安全补丁和功能更新。             |
| `develop`           | 开发测试标签，用于内部测试，不保证兼容性和稳定性，不建议生产环境使用。 |


## 附加信息

### 镜像截图
![镜像截图](https://5856039.fs1.hubspotusercontent-na1.net/hubfs/5856039/dockerhub/image-screenshots/core-ubuntu-noble.png "Ubuntu Noble 桌面环境截图")


### 源代码与文档
- **KasmVNC**：开源 VNC 服务器，提供 Web 原生、安全、高性能的渲染能力。  
  [GitHub 仓库](https://github.com/kasmtech/KasmVNC)  
- **Workspaces 镜像库**：Kasm Workspaces 官方镜像集合。  
  [GitHub 仓库](https://github.com/kasmtech/workspaces-images)  
- **核心镜像库**：用于自定义镜像的基础 OS 基线库。  
  [GitHub 仓库](https://github.com/kasmtech/workspaces-core-images)  
- **Kasm Workspaces 文档**：  
  - [安装指南](https://www.kasmweb.com/docs/latest/install.html)  
  - [自定义镜像配置](https://www.kasmweb.com/docs/latest/how_to/building_images.html)  
  - [开发者 API](https://www.kasmweb.com/docs/latest/developers/developer_api.html)  


### 问题反馈
如遇镜像相关问题，可通过 [GitHub Issue Tracker](https://github.com/kasmtech/workspaces-issues/issues) 提交反馈。
