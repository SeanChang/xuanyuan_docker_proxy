---
image: neowu/jre
description: "针对core-ng Web应用的精简JRE镜像"
source: https://xuanyuan.cloud/zh/r/neowu/jre
canonical: https://xuanyuan.cloud/zh/r/neowu/jre
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/neowu/jre" title="neowu/jre Docker 镜像中文简介、标签列表与拉取命令">neowu/jre 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# core-ng Web应用精简JRE镜像

## 镜像概述

本镜像专为core-ng Web应用设计，基于精简的JRE（Java Runtime Environment）构建，提供轻量级运行环境。详细信息请参考官方项目：[core-ng-project](https://github.com/neowu/core-ng-project)。

## 核心功能与特性

- **精简设计**：采用优化的JRE版本，显著减小镜像体积，降低存储和网络传输开销
- **高效运行**：针对core-ng应用特性优化，提升启动速度和运行性能
- **资源优化**：减少内存和CPU资源占用，适合资源受限环境及大规模部署场景

## 使用场景

适用于部署和运行基于core-ng框架开发的Web应用程序，特别适合对镜像大小、启动效率和系统资源占用有严格要求的生产环境或容器化部署架构。

## 使用方法

### 基本部署命令

使用以下命令启动容器（请替换实际镜像名称和标签）：

```bash
docker run -d --name core-ng-app docker.xuanyuan.run/neowu/core-ng-slim-jre:latest
```

### 高级配置

core-ng应用可能需要特定环境变量或配置参数，建议参考[官方项目文档](https://github.com/neowu/core-ng-project)获取详细配置指南，包括但不限于：

- 端口映射（如`-p 8080:8080`）
- 数据卷挂载（如`-v /local/config:/app/config`）
- 环境变量设置（如`-e SPRING_PROFILES_ACTIVE=prod`）

### 注意事项

- 确保Docker环境已正确安装并运行
- 根据应用需求调整容器资源限制（如`--memory=512m`）
- 生产环境建议结合Docker Compose或容器编排工具进行管理和扩展
