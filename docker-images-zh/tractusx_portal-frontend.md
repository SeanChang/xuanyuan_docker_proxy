---
image: tractusx/portal-frontend
description: "Eclipse Tractus-X Portal前端Docker镜像，基于nginxinc/nginx-unprivileged:alpine构建，包含Tractus-X门户前端应用，适用于部署Tractus-X门户前端服务。"
source: https://xuanyuan.cloud/zh/r/tractusx/portal-frontend
canonical: https://xuanyuan.cloud/zh/r/tractusx/portal-frontend
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tractusx/portal-frontend" title="tractusx/portal-frontend Docker 镜像中文简介、标签列表与拉取命令">tractusx/portal-frontend 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# tractusx/portal-frontend Docker镜像文档

## 镜像概述

本镜像为Eclipse Tractus-X项目的门户前端（Portal frontend）Docker镜像，基于`nginxinc/nginx-unprivileged:alpine`基础镜像构建，用于部署Tractus-X门户的前端应用。镜像托管于[DockerHub](https://hub.docker.com/r/tractusx/portal-frontend)。

## 核心功能与特性

### 包含的Eclipse Tractus-X产品
- **Portal frontend**
  - GitHub仓库：[https://github.com/eclipse-tractusx/portal-frontend](https://github.com/eclipse-tractusx/portal-frontend)
  - 项目主页：[https://projects.eclipse.org/projects/automotive.tractusx](https://projects.eclipse.org/projects/automotive.tractusx)
  - Dockerfile：[https://github.com/eclipse-tractusx/portal-frontend/blob/main/.conf/Dockerfile.prebuilt](https://github.com/eclipse-tractusx/portal-frontend/blob/main/.conf/Dockerfile.prebuilt)
  - 项目许可证：[Apache License, Version 2.0](https://github.com/eclipse-tractusx/portal-frontend/blob/main/LICENSE)

### 基础镜像信息
- **基础镜像**：`nginxinc/nginx-unprivileged:alpine`
  - Dockerfile：[https://github.com/nginxinc/docker-nginx-unprivileged/blob/main/Dockerfile-alpine.template](https://github.com/nginxinc/docker-nginx-unprivileged/blob/main/Dockerfile-alpine.template)
  - GitHub项目：[https://github.com/nginxinc/docker-nginx-unprivileged](https://github.com/nginxinc/docker-nginx-unprivileged)
  - DockerHub：[https://hub.docker.com/r/nginxinc/nginx-unprivileged](https://hub.docker.com/r/nginxinc/nginx-unprivileged)

## 使用场景

适用于需要部署Eclipse Tractus-X门户前端应用的场景，作为Tractus-X生态系统的前端入口服务。

## 使用方法与配置说明

### 获取镜像
从DockerHub拉取镜像：
```bash
docker pull docker.xuanyuan.run/tractusx/portal-frontend
```

### 注意事项
- 本镜像基于`nginxinc/nginx-unprivileged:alpine`构建，包含Nginx非特权用户版本及Portal frontend应用。
- 镜像中可能包含其他软件（如基础发行版中的Bash等），这些软件可能具有不同的许可证。
- 作为预构建镜像的使用者，您有责任确保对本镜像的任何使用均符合其中包含的所有软件的相关许可证要求。

## 许可证信息

- Portal frontend项目许可证：[Apache License, Version 2.0](https://github.com/eclipse-tractusx/portal-frontend/blob/main/LICENSE)
- 基础镜像（nginx-unprivileged:alpine）的许可证信息请参考其[GitHub项目](https://github.com/nginxinc/docker-nginx-unprivileged)
- 其他包含软件的许可证需用户自行核查并确保合规使用。
