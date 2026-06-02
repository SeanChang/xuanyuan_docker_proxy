---
image: atlassian/maven
description: "在预创建的非root用户下运行的Apache Maven"
source: https://xuanyuan.cloud/zh/r/atlassian/maven
canonical: https://xuanyuan.cloud/zh/r/atlassian/maven
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/maven" title="atlassian/maven Docker 镜像中文简介、标签列表与拉取命令">atlassian/maven 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Maven Docker镜像文档

## 1. 镜像概述

Apache Maven是一款基于项目对象模型（POM）的软件项目管理与理解工具，可通过集中化信息管理项目的构建、报告和文档。本镜像基于官方Maven镜像构建，核心改进在于使Maven运行于预创建的非root用户环境中，主目录为`/home/user`，Maven配置文件存储路径为`/home/user/.m2`。

## 2. 核心功能与特性

- **基于官方镜像**：完全继承官方Maven镜像的功能特性，确保与标准Maven工具链的兼容性
- **非root用户运行**：通过预创建的非root用户执行Maven进程，降低容器运行的权限风险，符合安全最佳实践
- **固定用户目录结构**：用户主目录固定为`/home/user`，Maven配置目录固定为`/home/user/.m2`，便于数据持久化与权限管理

## 3. 使用场景与适用范围

- **安全敏感环境**：适用于对容器权限有严格限制的生产环境或企业内部开发环境，通过非root用户隔离进程权限
- **CI/CD流程集成**：可安全集成到持续集成/部署流水线中，执行项目构建、测试等任务，避免权限滥用风险
- **多用户共享环境**：在需要多用户使用同一镜像的场景下，通过独立用户目录实现配置与数据隔离

## 4. 使用方法与配置说明

### 4.1 基本运行方式

执行标准Maven命令（如查看版本信息）：

```bash
docker run --rm [镜像名称] mvn --version
```

### 4.2 持久化配置与依赖缓存

通过挂载主机目录到容器内Maven配置目录，实现配置持久化和依赖缓存共享：

```bash
docker run --rm -v /本地路径/.m2:/home/user/.m2 [镜像名称] mvn clean install
```

### 4.3 用户与权限说明

- **运行用户**：容器内默认使用预创建的非root用户（用户名通常为`user`，具体可通过`docker exec -it [容器ID] whoami`命令查看）
- **目录权限**：`/home/user`和`/home/user/.m2`目录拥有非root用户的读写权限，避免对主机文件系统的未授权修改
- **权限扩展**：如需额外权限，可通过`--user`参数临时调整用户，但建议优先保持非root运行模式以确保安全性
