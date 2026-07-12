---
image: serversideup/ansible
description: "在任何地方运行Ansible的轻量级且功能强大的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/serversideup/ansible
canonical: https://xuanyuan.cloud/zh/r/serversideup/ansible
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/serversideup/ansible" title="serversideup/ansible Docker 镜像中文简介、标签列表与拉取命令">serversideup/ansible 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# serversideup/ansible Docker镜像文档

## 概述

`serversideup/ansible` 是一个轻量级解决方案，用于在容器化环境中运行Ansible。该项目基于从 [willhallonline/docker-ansible](https://github.com/willhallonline/docker-ansible) 学到的经验构建，提供安全隔离的Ansible任务运行环境，支持Alpine和Debian发行版，可作为非特权用户运行，避免文件权限问题。

## 核心功能和特性

- 🐧 **Debian和Alpine** - 选择您的操作系统
- 🐍 **基于官方Python镜像构建** - 选择您的Python版本
- 🔒 **非特权用户** - 可选择以root或非特权用户身份运行
- 📌 **固定Ansible版本** - 可精确到补丁版本设置Ansible版本
- 🔧 **自定义"运行身份"用户** - 自定义运行用户名
- 🔑 **设置自己的PUID和PGID** - 使PUID和PGID与主机用户匹配
- 📦 **支持DockerHub和GitHub容器 registry** - 选择镜像拉取来源
- 🤖 **多架构支持** - 每个镜像均提供x86_64和arm64架构

## 使用场景和适用范围

适用于需要在不同环境中一致运行Ansible任务的场景，包括开发、测试和生产环境。特别适合需要隔离Ansible运行环境、避免主机依赖冲突，或需要灵活配置用户权限的场景。提供两种镜像变体满足不同需求：

| 变体 | 镜像大小 | 描述 |
|------|----------|------|
| `serversideup/ansible-core` | [![DockerHub serversideup/ansible-core:alpine](https://img.shields.io/docker/image-size/serversideup/ansible-core/alpine?label=alpine)](https://hub.docker.com/r/serversideup/ansible-core/tags?name=alpine)<br>[![DockerHub serversideup/ansible-core](https://img.shields.io/docker/image-size/serversideup/ansible-core/latest?label=debian)](https://hub.docker.com/r/serversideup/ansible-core) | 轻量级的Ansible核心安装 |
| `serversideup/ansible` | [![DockerHub serversideup/ansible:alpine](https://img.shields.io/docker/image-size/serversideup/ansible/alpine?label=alpine)](https://hub.docker.com/r/serversideup/ansible/tags?name=alpine)<br>[![DockerHub serversideup/ansible](https://img.shields.io/docker/image-size/serversideup/ansible/latest?label=debian)](https://hub.docker.com/r/serversideup/ansible) | "开箱即用"的Ansible完整安装 |

## 镜像标签系统

Docker镜像采用全面的标签系统，提供灵活性和特异性。

### 标签组件

| 组件 | 示例 |
|------|------|
| Ansible版本 | `2.17.3`, `2.17` |
| 基础操作系统 | `alpine3.20`, `bullseye` |
| Python版本 | `python3.11` |
| 操作系统系列 | `alpine`, `debian` |

### 标签示例

| 标签 | 含义 |
|------|------|
| `2.17.3-alpine3.20-python3.11` | 最具体的标签（指定Ansible版本、OS版本和Python版本） |
| `2.17.3-alpine3.20` | 指定Ansible版本和OS版本，使用最新Python |
| `2.17.3` | 指定Ansible版本，使用最新OS和Python |
| `2.17-alpine3.20-python3.11` | 指定Ansible次要版本和补丁版本，OS版本和Python版本 |
| `2.17-alpine-python3.11` | 基于操作系统系列的标签 |

## 使用方法

### 运行Playbook

> [!IMPORTANT]  
> 在几乎所有情况下，您需要将卷挂载到Ansible"工作目录"（默认：`/ansible`）和SSH配置（通常为`~/.ssh`）。

```bash
docker run --rm -it \
  -v "$HOME/.ssh:/ssh" \
  -v "$(pwd):/ansible" \
  docker.xuanyuan.run/serversideup/ansible:latest ansible-playbook playbook.yml
```

### 更改运行用户、PUID和PGID

```bash
docker run --rm -it \
  -v "$HOME/.ssh:/ssh" \
  -v "$(pwd):/ansible" \
  -e PUID=9999 -e PGID=9999 \
  -e RUN_AS_USER=bob \
  docker.xuanyuan.run/serversideup/ansible:latest ansible-playbook playbook.yml
```

### 运行Shell

```bash
docker run --rm -it \
  -v "$HOME/.ssh:/ssh" \
  -v "$(pwd):/ansible" \
  docker.xuanyuan.run/serversideup/ansible:latest /bin/sh
```

### SSH使用说明

> [!NOTE]  
> 使用SSH密钥可能比较复杂，特别是动态设置`RUN_AS_USER`时。我们提供了一些工具来简化配置。

#### `/ssh`目录

默认情况下，`/ssh`目录通过符号链接链接到`~/.ssh`，作为SSH密钥和配置的统一来源。如果设置`RUN_AS_USER`，入口点将在`/home/${RUN_AS_USER}`创建主目录，并从`/home/${RUN_AS_USER}/.ssh`符号链接到`/ssh`，方便灵活设置运行用户。

#### 挂载SSH认证套接字

SSH认证套接字是SSH代理用于与其他进程通信的Unix套接字，支持安全密钥管理。

**macOS:**
```bash
docker run --rm -it \
  -v "$HOME/.ssh:/ssh:ro" \
  -v "$HOME/.ssh/known_hosts:/ssh/known_hosts:rw" \
  -v "$(pwd):/ansible" \
  -v "/run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock" \
  -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
  docker.xuanyuan.run/serversideup/ansible:latest ansible-playbook playbook.yml
```

**Linux:**
```bash
docker run --rm -it \
  -v "$HOME/.ssh:/ssh:ro" \
  -v "$HOME/.ssh/known_hosts:/ssh/known_hosts:rw" \
  -v "$(pwd):/ansible" \
  -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
  -e SSH_AUTH_SOCK="$SSH_AUTH_SOCK" \
  docker.xuanyuan.run/serversideup/ansible:latest ansible-playbook playbook.yml
```

## 环境变量

可通过以下环境变量自定义镜像：

| 变量 | 默认值 | 描述 |
|------|--------|------|
| `PUID` | `1000` | 设置运行Ansible的用户ID |
| `PGID` | `1000` | 设置运行Ansible的组ID |
| `RUN_AS_USER` | `ansible` | 运行Ansible的用户名（将自动创建，默认为非特权用户） |
| `DEBUG` | `false` | 启用容器启动的调试输出 |

## 资源

- **[DockerHub](https://hub.docker.com/r/serversideup/ansible)** - 浏览镜像
- **[Discord](https://serversideup.net/discord)** - 获取社区和团队的友好支持
- **[GitHub](https://github.com/serversideup/docker-ansible)** - 源代码、错误报告和项目管理
- **[专业支持](https://serversideup.net/professional-support)** - 直接从核心贡献者获取视频+屏幕共享帮助

## 贡献

作为开源项目，我们致力于开发过程的透明度和协作。非常感谢社区成员提供的任何贡献。无论您是修复错误、提出功能建议、改进文档还是传播项目，您的参与都将增强项目。请查看我们的[行为准则](./.github/code_of_conduct.md)，了解我们如何尊重地合作。

- **错误报告**：如使用镜像时遇到问题，请[创建issue](https://github.com/serversideup/docker-ansible/issues/new/choose)
- **功能请求**：通过[提交功能请求](https://github.com/serversideup/docker-ansible/discussions/)改进项目
- **文档**：通过[提交文档更改](./README.md)改进我们的文档
- **社区支持**：在[GitHub Discussions](https://github.com/serversideup/docker-ansible/discussions)或[Discord](https://serversideup.net/discord)帮助他人
- **安全报告**：通过[负责任的披露政策](https://www.notion.so/Responsible-Disclosure-Policy-421a6a3be1714d388ebbadba7eebbdc8)报告严重安全问题

## 关于我们

我们是Dan和Jay——一个热爱开源产品的两人团队。我们创建了[Server Side Up](https://serversideup.net)来分享我们学到的知识。

如果您喜欢这个项目，一定要查看我们的其他项目。

### 📚 书籍
- **[构建API和SPA的终极指南](https://serversideup.net/ultimate-guide-to-building-apis-and-spas-with-laravel-and-nuxt3/)**：从同一代码库构建Web和移动应用
- **[构建多平台浏览器扩展](https://serversideup.net/building-multi-platform-browser-extensions/)**：从同一代码库向所有浏览器发布扩展

### 🛠️ 软件即服务
- **[Bugflow](https://bugflow.io/)**：直接在GitHub、GitLab等获取可视化错误报告
- **[SelfHost Pro](https://selfhostpro.com/)**：将Stripe或Lemonsqueezy连接到私有Docker registry，用于自托管应用

### 🌍 开源项目
- **[AmplitudeJS](https://521dimensions.com/open-source/amplitudejs)**：开源HTML5和JavaScript Web音频库
- **[Spin](https://serversideup.net/open-source/spin/)**：Laravel Sail的替代方案，用于从开发到生产运行Docker
- **[Financial Freedom](https://github.com/serversideup/financial-freedom)**：Mint、YNAB和Monarch Money的开源替代方案
