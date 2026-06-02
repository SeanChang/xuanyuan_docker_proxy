---
image: summary/portainer-ce
description: "Portainer-CE中文汉化版是一款轻量级容器管理平台，提供Docker、Kubernetes等容器环境的可视化管理界面，支持中文操作，便于中文用户高效管理容器资源。"
source: https://xuanyuan.cloud/zh/r/summary/portainer-ce
canonical: https://xuanyuan.cloud/zh/r/summary/portainer-ce
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/summary/portainer-ce" title="summary/portainer-ce Docker 镜像中文简介、标签列表与拉取命令">summary/portainer-ce — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/summary/portainer-ce" title="summary/portainer-ce Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/summary/portainer-ce</a>

# Portainer-CE 中文汉化版 Docker 镜像

## 镜像概述与主要用途

Portainer-CE 中文汉化版镜像是基于官方 Portainer-CE 构建的 Docker 管理面板，已完成全中文界面汉化，并合并多平台标签（支持 x86_64、ARM 等架构），拉取时自动识别宿主机平台。该镜像旨在为中文用户提供简洁易用的 Docker 环境图形化管理工具，简化容器、镜像、网络、数据卷等资源的日常运维操作。


## 核心功能与特性

### 核心功能
- **容器生命周期管理**：创建、启动、停止、重启、删除容器，查看容器日志与控制台
- **镜像管理**：拉取、推送、构建、删除镜像，查看镜像详情与历史
- **网络管理**：创建、删除自定义网络，配置网络驱动与参数，管理网络连接
- **数据卷管理**：创建、删除数据卷，挂载主机目录，查看卷占用空间
- **用户与权限控制**：多用户支持，基于角色的访问控制（RBAC），限制资源操作权限
- **系统监控**：实时监控 Docker 主机资源（CPU、内存、磁盘、网络）使用状态

### 特性
- **全中文界面**：所有操作界面、提示信息均已汉化，降低中文用户使用门槛
- **多平台支持**：合并 x86_64、ARMv7、ARM64 等架构标签，自动匹配宿主机平台
- **轻量化部署**：基于官方 Portainer-CE 精简构建，资源占用低
- **即开即用**：无需额外配置，一键部署即可使用完整功能


## 使用场景与适用范围

### 适用场景
- 个人开发者：本地 Docker 环境快速管理，简化开发测试流程
- 中小企业 IT 团队：Docker 服务器集群图形化运维，降低管理复杂度
- Docker 新手用户：通过图形界面学习 Docker 基本操作，减少命令行学习成本

### 适用范围
- 兼容 Docker 1.12+ 及 Kubernetes 环境（需额外配置）
- 支持 Linux/macOS 系统（Windows 需启用 WSL2 或 Docker Desktop）


## 使用方法与配置说明

### 前置要求
- 已安装 Docker Engine（1.12+）及 Docker CLI
- 宿主机网络通畅，可访问 Docker Hub 拉取镜像
- 开放 9000 端口（或自定义端口）的网络访问权限

### 快速部署（docker run）

#### 基础部署命令（含数据持久化）
```bash
docker run -d \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  --restart=always \
  --name=portainer-ce \
  summary/portainer-ce
```

#### 参数说明
| 参数                          | 说明                                                                 |
|-------------------------------|----------------------------------------------------------------------|
| `-d`                          | 后台运行容器                                                         |
| `-p 9000:9000`                | 端口映射：宿主机 9000 端口映射至容器 9000 端口（Web 管理界面）       |
| `-v /var/run/docker.sock:/var/run/docker.sock` | 挂载 Docker 守护进程 Unix 套接字，用于管理宿主机 Docker 环境         |
| `-v portainer_data:/data`     | 持久化数据卷：存储用户配置、权限设置等数据，避免容器重启后丢失       |
| `--restart=always`            | 容器重启策略：容器退出时自动重启                                     |
| `--name=portainer-ce`         | 指定容器名称为 `portainer-ce`                                       |

### Docker Compose 部署示例

创建 `docker-compose.yml` 文件：
```yaml
version: '3'
services:
  portainer:
    image: summary/portainer-ce
    container_name: portainer-ce
    restart: always
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
volumes:
  portainer_data:  # 自动创建命名卷，持久化数据
```

启动服务：
```bash
docker-compose up -d
```


## 访问与初始配置

### 访问管理界面
部署完成后，通过浏览器访问 `http://<宿主机IP>:9000` 进入 Portainer 中文管理界面。

### 初始设置
首次访问需完成管理员账户配置：
1. 设置管理员用户名（默认建议使用 `admin`）
2. 设置管理员密码（需满足复杂度要求：至少 8 位，包含大小写字母、数字或特殊字符）
3. 选择管理环境：首次使用建议选择“本地环境”（Local），即管理当前宿主机 Docker 环境


## 注意事项

- **数据持久化**：必须通过 `-v portainer_data:/data` 挂载数据卷，否则容器删除或升级后配置数据将丢失。
- **权限问题**：宿主机 `/var/run/docker.sock` 文件需确保容器内进程可访问（默认权限通常满足，若遇权限问题可临时调整 `chmod 666 /var/run/docker.sock`）。
- **端口冲突**：若宿主机 9000 端口已被占用，可修改端口映射（如 `-p 9001:9000` 将宿主机 9001 端口映射至容器 9000 端口）。
- **多平台适配**：ARM 设备（如树莓派）可直接拉取使用，无需指定架构标签。
