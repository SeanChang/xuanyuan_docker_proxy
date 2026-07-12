---
image: tractusx/portal-notification-service
description: "Eclipse Tractus-X门户通知服务Docker镜像，基于.NET 9.0 ASP.NET运行时和Alpine基础镜像，用于支持门户管理服务的通知功能，遵循Apache License 2.0许可证。"
source: https://xuanyuan.cloud/zh/r/tractusx/portal-notification-service
canonical: https://xuanyuan.cloud/zh/r/tractusx/portal-notification-service
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tractusx/portal-notification-service" title="tractusx/portal-notification-service Docker 镜像中文简介、标签列表与拉取命令">tractusx/portal-notification-service 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Eclipse Tractus-X Portal Notification Service Docker镜像文档

## 镜像概述

本镜像包含Eclipse Tractus-X项目的**Portal Administration Service**（门户管理服务）组件，提供门户系统的通知服务功能。基于微软.NET 9.0 ASP.NET运行时构建，采用Alpine Linux基础镜像以实现轻量级部署，适用于Tractus-X门户生态系统的集成与扩展。

### 基本信息
- **DockerHub地址**：[https://hub.docker.com/r/tractusx/portal-notification-service](https://hub.docker.com/r/tractusx/portal-notification-service)
- **主项目许可证**：[Apache License, Version 2.0](https://github.com/eclipse-tractusx/portal-backend/blob/main/LICENSE)

## 核心组件说明

### Portal Administration Service
- **功能定位**：Eclipse Tractus-X门户系统的核心管理组件，提供通知服务等关键功能
- **代码仓库**：[https://github.com/eclipse-tractusx/portal-backend](https://github.com/eclipse-tractusx/portal-backend)
- **项目主页**：[https://projects.eclipse.org/projects/automotive.tractusx](https://projects.eclipse.org/projects/automotive.tractusx)
- **Dockerfile**：[https://github.com/eclipse-tractusx/portal-backend/blob/main/docker/Dockerfile-notification-service](https://github.com/eclipse-tractusx/portal-backend/blob/main/docker/Dockerfile-notification-service)

## 基础镜像信息

### 运行时基础镜像
- **镜像名称**：`mcr.microsoft.com/dotnet/aspnet:9.0-alpine`
- **Dockerfile**：[https://github.com/dotnet/dotnet-docker/blob/main/src/aspnet/9.0/alpine3.20/amd64/Dockerfile](https://github.com/dotnet/dotnet-docker/blob/main/src/aspnet/9.0/alpine3.20/amd64/Dockerfile)
- **项目仓库**：[https://github.com/dotnet/dotnet-docker](https://github.com/dotnet/dotnet-docker)
- **DockerHub地址**：[https://hub.docker.com/_/microsoft-dotnet-aspnet](https://hub.docker.com/_/microsoft-dotnet-aspnet)

## 使用场景与适用范围

适用于Eclipse Tractus-X门户系统的部署环境，用于集成并提供门户管理服务的通知功能，支持企业级门户系统的通知发送与管理。适合需要构建或扩展Tractus-X生态系统的组织或企业使用。

## 许可证说明

- **主组件许可证**：Portal Administration Service遵循Apache License 2.0
- **基础镜像及依赖**：基础镜像`mcr.microsoft.com/dotnet/aspnet:9.0-alpine`及其他包含的软件（如Bash等系统组件）可能具有独立许可证

> **重要提示**：使用本镜像时，用户需自行确保对镜像中所有软件的使用符合其相关许可证要求。
