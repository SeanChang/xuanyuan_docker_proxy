---
image: dbeaver/cloudbeaver-ee
description: "CloudBeaver企业版Docker镜像，提供基于Web的多数据库管理功能，支持企业级安全与团队协作，适用于快速部署数据库管理平台。"
source: https://xuanyuan.cloud/zh/r/dbeaver/cloudbeaver-ee
canonical: https://xuanyuan.cloud/zh/r/dbeaver/cloudbeaver-ee
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dbeaver/cloudbeaver-ee" title="dbeaver/cloudbeaver-ee Docker 镜像中文简介、标签列表与拉取命令">dbeaver/cloudbeaver-ee 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CloudBeaver 企业版 (Docker镜像)

## 概述
CloudBeaver 企业版是一款企业级数据库管理工具，提供基于Web的统一操作界面，支持多种主流数据库（如MySQL、PostgreSQL、Oracle、SQL Server等）的访问与管理。该Docker镜像旨在简化部署流程，适用于企业在各类环境中快速搭建数据库管理平台。

## 核心特性
- **多数据库兼容**：支持关系型、NoSQL等多种数据库类型，提供一致的管理体验。
- **Web化访问**：无需安装客户端，通过浏览器即可远程访问和管理数据库。
- **企业级安全**：集成细粒度权限控制、LDAP认证、审计日志等安全功能。
- **团队协作**：支持用户分组管理、连接与查询共享，提升团队协作效率。

## 使用场景
- 企业多数据库集中管理与监控
- 开发/运维团队远程协作访问数据库
- 跨环境（开发、测试、生产）数据库统一管理
- 轻量化数据库操作（无需本地客户端安装）

## Docker部署示例
### 1. 拉取最新镜像
使用`latest`标签获取最新版本：
```bash
docker pull docker.xuanyuan.run/dbeaver/cloudbeaver-ee:latest
```

### 2. 运行容器
启动容器并映射端口（默认端口8978），挂载数据卷以持久化配置：
```bash
docker run -d \
  -p 8978:8978 \
  --name cloudbeaver-ee \
  -v /path/to/local/data:/opt/cloudbeaver/workspace \
  docker.xuanyuan.run/dbeaver/cloudbeaver-ee:latest
```
> 说明：
> - `-p 8978:8978`：映射容器端口至主机，通过`http://localhost:8978`访问Web界面
> - `-v /path/to/local/data:/opt/cloudbeaver/workspace`：挂载本地目录至容器工作区，实现数据持久化

## 许可证与文档
- **许可证信息**：详见 [CloudBeaver 企业版许可证文档](https://dbeaver.com/docs/cloudbeaver/CloudBeaver-Enterprise-deployment-from-docker-image/)
- **部署指南**：参考 [CloudBeaver 部署文档](https://github.com/dbeaver/cloudbeaver-deploy)

## 获取最新版本
使用`latest`镜像标签可获取最新稳定版本，建议生产环境定期更新以获取功能迭代与安全补丁。
