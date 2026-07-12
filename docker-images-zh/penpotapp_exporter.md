---
image: penpotapp/exporter
description: "Penpot是用于设计与代码协作的开源设计工具，支持设计师创建设计稿、原型及设计系统，开发者可直接使用现成代码。"
source: https://xuanyuan.cloud/zh/r/penpotapp/exporter
canonical: https://xuanyuan.cloud/zh/r/penpotapp/exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/penpotapp/exporter" title="penpotapp/exporter Docker 镜像中文简介、标签列表与拉取命令">penpotapp/exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### Penpot 概述
Penpot 是首个用于设计与代码协作的开源设计工具。设计师可创建精美的设计稿、交互式原型和规模化设计系统，开发者则能直接使用现成代码，简化工作流程并提高效率，有效消除交接障碍。

### 核心特性
- **开源免费**：基于 MPL-2.0 许可证（[![License: MPL-2.0](https://img.shields.io/badge/MPL-2.0-blue.svg)](https://www.mozilla.org/en-US/MPL/2.0)），支持自由使用、修改与分发。
- **设计功能**：提供设计稿创作、交互式原型制作及规模化设计系统管理能力。
- **开发者友好**：输出即用型代码，无缝衔接开发流程，减少手动转换工作。
- **协作无缝**：打通设计师与开发者协作链路，降低沟通成本，提升团队效率。

### 使用场景
- **设计师**：独立或团队协作完成视觉设计、交互原型设计及设计系统维护。
- **开发者**：直接获取设计稿对应的代码资源，加速开发迭代。
- **团队协作**：跨职能团队（设计+开发）协同工作，优化项目整体流程。

### Docker 部署方案示例
推荐通过 Docker Compose 部署，基础配置示例如下（详情请参考[官方文档](https://help.penpot.app/technical-guide/getting-started/#install-with-docker)）：
```yaml
version: '3'
services:
  penpot-frontend:
    image: docker.xuanyuan.run/penpot/frontend:latest
    ports:
      - "80:80"
    depends_on:
      - penpot-backend
  penpot-backend:
    image: docker.xuanyuan.run/penpot/backend:latest
    environment:
      - PENPOT_DATABASE_URI=postgresql://user:pass@db:5432/penpot
    depends_on:
      - db
  db:
    image: docker.xuanyuan.run/postgres:14
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=penpot
```
执行 `docker-compose up -d` 启动服务，访问 http://localhost 即可使用。

### 相关资源
- **官方网站**：[penpot.app](https://penpot.app/)
- **用户指南**：[help.penpot.app/user-guide](https://help.penpot.app/user-guide/)
- **GitHub 仓库**：[penpot/penpot](https://github.com/penpot/penpot)（问题反馈与贡献）
- **社区支持**：[Penpot Community](https://community.penpot.app/)（[![Penpot Community](https://img.shields.io/discourse/posts?server=https%3A%2F%2Fcommunity.penpot.app)](https://community.penpot.app/)）
