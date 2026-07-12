---
image: kleen/forgejo
description: "这是codeberg.org/forgejo/forgejo官方rootless容器镜像的副本，重新发布到Docker Hub，方便依赖Docker Hub的用户轻松部署Forgejo。"
source: https://xuanyuan.cloud/zh/r/kleen/forgejo
canonical: https://xuanyuan.cloud/zh/r/kleen/forgejo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kleen/forgejo" title="kleen/forgejo Docker 镜像中文简介、标签列表与拉取命令">kleen/forgejo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Forgejo 容器镜像

## 镜像概述

本镜像为官方Forgejo rootless容器镜像的Docker Hub重新发布版本。镜像直接从Codeberg上游发布（codeberg.org/forgejo/forgejo）拉取，未做任何修改，旨在为依赖Docker Hub可用性的用户提供便捷的Forgejo部署途径。

Forgejo是一款自托管的轻量级Git forge，提供Git仓库托管及完整的协作功能，设计目标是简单易运行、易维护，适合需要自主控制Git平台的团队使用。

## 核心功能与特性

### Forgejo 核心功能
- Git仓库托管
- 拉取/合并请求
- 代码审查
- 问题跟踪
- 项目看板
- 维基功能
- 发布管理
- 包注册表
- CI/CD集成（通过webhooks和API）

### 镜像特性
- **Rootless设计**：容器内无需root进程运行（具体取决于运行时环境和卷权限配置）
- **上游一致性**：直接同步Codeberg上游发布，镜像内容无修改
- **标签同步**：Docker Hub仓库标签与上游发布版本保持一致

## 使用场景与适用范围

- 依赖Docker Hub镜像源的用户
- 需要自托管Git协作平台的团队
- 希望简单部署和维护Git服务的组织
- 对数据控制权有要求的开发团队

## 使用方法与配置说明

### 基本部署（docker run）

```bash
docker run -d \
  --name forgejo \
  -p 3000:3000 \
  -v forgejo-data:/data \
  docker.io/[镜像仓库名]/forgejo:[标签]
```

### 关键配置说明

1. **数据持久化**
   - 建议通过`-v`参数挂载数据卷（如示例中的`forgejo-data`），确保数据持久化

2. **端口映射**
   - 默认HTTP端口为3000，可根据需求调整端口映射（如`-p 80:3000`）

3. **标签选择**
   - 使用与上游一致的标签，例如`1.21.0-rootless`，具体标签可参考Docker Hub仓库

4. **环境变量配置**
   - 具体环境变量配置请参考上游文档，常见配置包括数据库连接、域名设置、邮件服务等

### 参考文档

完整的官方文档、配置指南及发布说明，请访问Codeberg上的Forgejo官方项目：  
[https://codeberg.org/forgejo/forgejo](https://codeberg.org/forgejo/forgejo)
