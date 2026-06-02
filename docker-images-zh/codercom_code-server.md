---
image: codercom/code-server
description: "在任何设备上运行VS Code并通过浏览器访问，提供跨设备一致的开发环境，支持利用远程服务器资源提升开发效率。"
source: https://xuanyuan.cloud/zh/r/codercom/code-server
canonical: https://xuanyuan.cloud/zh/r/codercom/code-server
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/codercom/code-server" title="codercom/code-server Docker 镜像中文简介、标签列表与拉取命令">codercom/code-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/codercom/code-server" title="codercom/code-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/codercom/code-server</a>

# code-server Docker镜像文档

## 概述

code-server Docker镜像是一个允许在任何机器上运行[VS Code](https://github.com/Microsoft/vscode)并通过浏览器访问的解决方案。它打破了设备限制，让用户可以在Chromebook、平板、笔记本等各类设备上使用一致的开发环境，所有操作通过浏览器完成。

## 核心功能与特性

### 随时随地编码
- 在Chromebook、平板和笔记本电脑上使用一致的开发环境
- 在Linux机器上开发，可从任何具有网页浏览器的设备继续工作

### 服务器驱动
- 利用大型云服务器加速测试、编译、下载等任务
- 外出时节省设备电量，所有密集型任务在服务器上运行
- 将闲置电脑转变为完整的开发环境

## 使用场景

- 跨设备开发：需要在办公电脑、家用设备、移动设备间保持一致开发体验的开发者
- 资源优化：希望利用远程服务器资源（如更高配置的云服务器）提升开发效率的用户
- 设备复用：将闲置硬件（如旧电脑）转化为可用开发环境的场景

## 使用方法

### 基本部署示例

以下命令将启动code-server容器，并通过`http://127.0.0.1:8080`访问。它会挂载本地配置目录和当前工作目录，确保文件权限与宿主机一致，并保留用户配置。

```bash
# 创建配置目录（若不存在）
mkdir -p ~/.config

# 启动code-server容器
docker run -it --name code-server -p 127.0.0.1:8080:8080 \
  -v "$HOME/.config:/home/coder/.config" \  # 挂载配置目录，确保外部可修改code-server配置
  -v "$PWD:/home/coder/project" \          # 挂载当前目录到容器内的项目目录
  -u "$(id -u):$(id -g)" \                 # 转发宿主机用户UID/GID，确保文件系统操作权限一致
  -e "DOCKER_USER=$USER" \                 # 传递宿主机用户名到容器环境变量
  codercom/code-server:latest
```

### 参数说明

| 参数 | 说明 |
|------|------|
| `-p 127.0.0.1:8080:8080` | 将容器的8080端口映射到本地8080端口，仅限本地访问 |
| `-v "$HOME/.config:/home/coder/.config"` | 挂载宿主机`~/.config`目录到容器内，确保`code-server`配置文件（位于`~/.config/code-server/config.json`）可在外部修改 |
| `-v "$PWD:/home/coder/project"` | 将宿主机当前工作目录挂载到容器内的`/home/coder/project`，作为开发项目目录 |
| `-u "$(id -u):$(id -g)"` | 设置容器内运行用户的UID和GID与宿主机一致，避免文件权限冲突 |
| `-e "DOCKER_USER=$USER"` | 将宿主机用户名传递到容器内，用于身份标识 |

## 开源依赖

本镜像使用以下开源依赖：

- [Visual Studio Code](https://github.com/microsoft/vscode)（MIT许可证）
- 更多依赖归因请参考：[https://coder.com/legal/open-source-licenses](https://coder.com/legal/open-source-licenses)
