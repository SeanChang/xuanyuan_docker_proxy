---
image: jelastic/postgres
description: "由Jelastic PaaS维护的PostgreSQL数据库服务器镜像，具备负载自适应的资源优化、内置Web管理面板、自动访问恢复功能及定期安全更新。"
source: https://xuanyuan.cloud/zh/r/jelastic/postgres
canonical: https://xuanyuan.cloud/zh/r/jelastic/postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jelastic/postgres" title="jelastic/postgres Docker 镜像中文简介、标签列表与拉取命令">jelastic/postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PostgreSQL 数据库服务器镜像

## 镜像概述和主要用途
该PostgreSQL镜像是由Jelastic PaaS维护的数据库服务器镜像，专为在[Jelastic PaaS](http://jelastic.com/)中作为隔离容器运行而设计。通过使用此托管Docker模板，用户可获得经过优化的数据库部署和管理体验。

## 核心功能和特性
- **定期更新与安全补丁**：由Jelastic团队维护，确保镜像持续更新至最新版本并包含安全补丁
- **自动资源调优**：根据负载和可用资源自动调整配置，实现优化性能
- **密码重置功能**：支持数据库密码重置选项，提升管理灵活性
- **内置Web管理面板**：提供内置Web UI，方便数据库管理操作
- **Jelastic UI兼容性**：与Jelastic平台UI完全兼容，支持便捷的可视化管理

## 使用场景和适用范围
适用于需要在Jelastic PaaS中部署PostgreSQL数据库的用户，特别适合需要自动化资源管理、简化数据库维护流程以及确保安全更新的场景，如企业级应用数据库托管、开发测试环境数据库部署等。

## 使用方法和配置说明

### 安装托管容器
按照[指南](https://docs.jelastic.com/setting-up-environment)在Jelastic PaaS中安装包含所需堆栈的托管容器。

### 自定义容器部署
该镜像可被 Fork、修改，并作为[自定义容器](https://docs.jelastic.com/dockers-management)在平台内安装。

### 了解更多
有关Jelastic PaaS中的[数据库云托管](https://docs.jelastic.com/database-hosting)详情，请参阅相关文档。
