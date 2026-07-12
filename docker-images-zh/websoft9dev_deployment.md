---
image: websoft9dev/deployment
description: "基于官方Portainer镜像的定制版本，自动初始化用户名密码及本地环境端点，简化容器管理平台的快速部署与初始配置。"
source: https://xuanyuan.cloud/zh/r/websoft9dev/deployment
canonical: https://xuanyuan.cloud/zh/r/websoft9dev/deployment
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/websoft9dev/deployment" title="websoft9dev/deployment Docker 镜像中文简介、标签列表与拉取命令">websoft9dev/deployment 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Portainer定制镜像文档

## 镜像概述

本镜像基于官方Portainer容器管理平台镜像构建，是一个预配置的增强版本。主要用途是简化Portainer的部署流程，通过自动完成初始管理员凭据配置和本地Docker环境端点注册，消除手动初始化步骤，帮助用户快速搭建可用的容器管理环境。

## 核心功能与特性

### 1. 自动初始化管理员凭据
- 镜像启动时自动配置默认管理员用户名和密码，避免首次登录时的手动设置流程
- 确保部署后可直接使用预设凭据登录系统，减少配置步骤

### 2. 本地环境端点自动配置
- 自动检测并添加本地Docker环境作为管理端点
- 无需手动配置Docker连接参数（如套接字路径或TCP地址），简化单机环境管理的初始设置

### 3. 完整继承官方功能
- 保留Portainer核心功能：容器生命周期管理、镜像管理、网络配置、卷管理、堆栈部署等
- 支持Docker Swarm集群管理（取决于基础Portainer版本）

## 使用场景与适用范围

### 适用场景
- 个人开发者快速搭建本地容器管理环境
- 小型团队内部部署简易容器管理平台
- 自动化部署流程中集成Portainer服务
- 教学或演示环境中的Portainer快速启动

### 适用范围
- 本地Docker Engine环境（单机模式）
- 边缘计算设备上的容器管理（资源受限环境需评估硬件配置）
- 开发/测试环境的容器平台快速部署

## 使用方法与配置说明

### 基本部署命令

使用以下命令快速启动容器：

```bash
docker run -d -p 9000:9000 --name portainer-custom \
  -v /var/run/docker.sock:/var/run/docker.sock \
  [镜像名称]:[版本标签]
```

> 参数说明：
> - `-v /var/run/docker.sock:/var/run/docker.sock`：挂载本地Docker套接字，使Portainer能够管理主机Docker环境
> - `-p 9000:9000`：映射Web管理界面默认端口
> - `--name portainer-custom`：指定容器名称（可自定义）

### 访问与登录

1. 部署完成后，通过浏览器访问 `http://<主机IP>:9000` 打开管理界面
2. 使用镜像预设的管理员凭据登录（具体凭据请参考镜像构建时的配置，通常为默认组合如 `admin/admin`，生产环境建议部署后立即修改）

### docker-compose部署示例

```yaml
version: '3.8'
services:
  portainer:
    image: docker.xuanyuan.run/[镜像名称]:[版本标签]
    container_name: portainer
    restart: always
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data  # 持久化存储配置数据

volumes:
  portainer_data:  # 用于保存Portainer配置和数据
```

## 注意事项

- 本镜像的基础版本需与官方Portainer版本保持一致，以确保功能兼容性
- 初始凭据为预设值，生产环境部署后应立即通过管理界面修改管理员密码
- 如需管理远程Docker环境，登录后仍需手动添加远程端点配置
- 持久化卷 `portainer_data` 建议添加，以避免容器重建导致配置丢失
