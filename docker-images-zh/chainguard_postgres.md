---
image: chainguard/postgres
description: "使用Chainguard的低至零CVE容器镜像构建、发布和运行安全软件。"
source: https://xuanyuan.cloud/zh/r/chainguard/postgres
canonical: https://xuanyuan.cloud/zh/r/chainguard/postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/chainguard/postgres" title="chainguard/postgres Docker 镜像中文简介、标签列表与拉取命令">chainguard/postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Chainguard PostgreSQL 容器镜像

## 镜像概述和主要用途
Chainguard PostgreSQL 容器镜像是专注于安全性的轻量级容器镜像，旨在提供低至零CVE（常见漏洞和暴露）的运行环境，支持用户构建、发布和运行安全的PostgreSQL数据库服务。该镜像可通过Docker Hub和Chainguard Registry获取，并提供丰富的版本信息、安全相关文档及支持资源。

## 核心功能和特性
- **高安全性**：采用低至零CVE的基础镜像，减少安全风险
- **多源获取**：同时发布于Docker Hub和Chainguard Registry，满足不同拉取需求
- **丰富资源**：提供包括FIPS支持版本、SBOM（软件物料清单）、安全公告及漏洞信息等配套文档
- **稳定支持**：提供官方FAQ和联系渠道，解决使用中的问题（如速率限制）

## 使用场景和适用范围
适用于对安全性要求较高的PostgreSQL数据库部署场景，包括但不限于：
- 生产环境中的数据库服务
- 需符合安全合规要求的企业级应用
- 对漏洞风险敏感的开发和测试环境

## 详细使用方法和配置说明

### 下载此镜像
该镜像同时托管于Docker Hub和Chainguard Registry，可根据需求选择拉取源：

#### 从Docker Hub拉取：
```bash
docker pull docker.xuanyuan.run/chainguard/postgres:latest
```

#### 从Chainguard Registry拉取：
```bash
docker pull cgr.dev/chainguard/postgres:latest
```

### 额外资源和支持
- **版本信息**：包含FIPS支持等特定版本，详见[Chainguard镜像目录](https://images.chainguard.dev/directory/image/postgres/versions)
- **安全文档**：SBOM、安全公告及漏洞信息可通过[Chainguard镜像目录](https://images.chainguard.dev/directory/image/postgres)查看
- **速率限制解决**：若遇到拉取速率限制问题，建议使用Chainguard Registry拉取
- **支持渠道**：访问[镜像FAQ](https://edu.chainguard.dev/chainguard/chainguard-images/faq/)或[联系页面](https://www.chainguard.dev/contact)获取帮助

更多详细文档请参见[Chainguard镜像目录概述](https://images.chainguard.dev/directory/image/postgres/overview)。
