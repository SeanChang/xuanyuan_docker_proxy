---
image: amd64/unit
description: "已弃用；官方构建的NGINX Unit：通用Web应用服务器"
source: https://xuanyuan.cloud/zh/r/amd64/unit
canonical: https://xuanyuan.cloud/zh/r/amd64/unit
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/unit" title="amd64/unit Docker 镜像中文简介、标签列表与拉取命令">amd64/unit — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/amd64/unit" title="amd64/unit Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amd64/unit</a>

# NGINX Unit Docker 镜像文档


## 废弃通知（DEPRECATION NOTICE）

自2025年10月起，NGINX Unit已归档且不再维护。相关Docker镜像将不会收到版本更新或安全补丁。

详情请参见：[NGINX Unit GitHub仓库说明](https://github.com/nginx/unit?tab=readme-ov-file#note-this-repository-has-been-archived-there-will-likely-be-no-further-development-at-this-repo-and-security-vulnerabilities-may-be-unaddressed)


## 1. 镜像概述和主要用途

### 1.1 关于 NGINX Unit
NGINX Unit 是一款轻量级、多功能的应用运行时环境，作为单一开源服务器提供 Web 应用所需的核心组件，包括：运行应用代码、提供静态资源服务、处理 TLS 加密及请求路由。


### 1.2 主要用途
历史上，该镜像用于快速部署基于 NGINX Unit 的 Web 应用服务，适用于需要集成应用运行时与 Web 服务能力的场景。


### 1.3 重要说明
本镜像为 `amd64` 架构的官方构建版本，但当前**不支持任何架构**，且项目已废弃，请勿在生产环境中使用。


## 2. 核心功能和特性

- **轻量级设计**：资源占用低，适合轻量部署场景。
- **多功能运行时**：集成 Web 应用所需核心能力，无需额外组件。
- **集成式 Web 服务**：
  - 运行应用代码（支持多语言，如 Python、Node.js、Go 等）。
  - 提供静态资源（文件、图片等）服务。
  - 内置 TLS 加密处理。
  - 灵活的请求路由管理。


## 3. 使用场景和适用范围

### 3.1 历史适用场景
- 开发环境中的 Web 应用快速测试与部署。
- 小型 Web 应用的轻量级服务部署（需单一组件满足运行时与 Web 服务需求）。
- 需要简化架构的场景（避免应用服务器与 Web 服务器分离部署）。


### 3.2 当前使用限制
由于项目已归档且不再维护，**不建议在任何新场景中使用**，已部署实例应考虑迁移至替代方案以规避安全风险。


## 4. 使用方法和配置说明

### 4.1 注意事项
- 本镜像已停止更新，存在潜在安全漏洞，不推荐使用。
- 历史使用方法请参考官方文档，但无法获得技术支持。


### 4.2 历史使用参考
初始配置与 Docker 部署指南可参考：
- [NGINX Unit 初始配置](https://unit.nginx.org/installation/#initial-configuration)
- [NGINX Unit Docker 指南](https://unit.nginx.org/howto/docker/)


## 5. 支持的架构与标签

### 5.1 架构支持
- **当前状态**：无支持架构（No supported architectures）。
- **历史说明**：原计划支持 `amd64` 架构，但实际未提供有效支持（详见官方镜像文档）。


### 5.2 可用标签
历史标签信息请参考 [NGINX Unit 官网安装页面](https://unit.nginx.org/installation/#docker-images)，但标签已不再更新。


## 6. 支持与反馈

### 6.1 维护者
- [Unit Docker Maintainers](https://github.com/nginx/unit)（项目已归档，维护终止）。


### 6.2 获取帮助
- **GitHub Issues**：[https://github.com/nginx/unit/issues](https://github.com/nginx/unit/issues)（可能无响应）。
- **NGINX Community Slack**：[https://community.nginx.org/joinslack](https://community.nginx.org/joinslack)（社区支持可能有限）。


## 7. 许可信息

- **软件许可**：镜像包含的 NGINX Unit 软件许可信息见 [LICENSE 文件](https://raw.githubusercontent.com/nginx/unit/master/LICENSE)。
- **第三方组件**：镜像可能包含基础镜像及依赖软件（如 Bash 等），其许可需用户自行确认合规性。
- **镜像元数据**：额外许可信息可参考 [repo-info 仓库的 unit 目录](https://github.com/docker-library/repo-info/tree/master/repos/unit)。


**重要提示**：使用本镜像即表示用户已知晓其废弃状态及安全风险，并自行承担相关责任。
