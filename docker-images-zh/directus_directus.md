---
image: directus/directus
description: "Directus是一个开源无头内容管理系统及API，用于管理无特定格式内容。"
source: https://xuanyuan.cloud/zh/r/directus/directus
canonical: https://xuanyuan.cloud/zh/r/directus/directus
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/directus/directus" title="directus/directus Docker 镜像中文简介、标签列表与拉取命令">directus/directus 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Directus Docker镜像文档

## 1. 镜像概述和主要用途

Directus是一个实时API和应用仪表板，用于管理SQL数据库内容。它提供了一个无代码的界面，使非技术用户能够安全直观地管理数据库内容，同时为开发人员提供强大的API来构建应用程序。

主要用途：
- 作为无头CMS（内容管理系统）管理数字内容
- 为现有SQL数据库提供API接口
- 构建内部数据管理系统
- 创建自定义管理面板
- 快速开发数据驱动的应用程序后端

## 2. 核心功能和特性

### REST & GraphQL API
- 即时在任何SQL数据库上构建高性能Node.js API
- 自动生成API端点，无需手动编码
- 支持复杂查询、过滤、排序和分页

### 数据库兼容性
- 支持PostgreSQL、MySQL、SQLite、OracleDB、CockroachDB、MariaDB和MS-SQL
- 适用于新数据库或现有数据库，无需数据迁移
- 保持数据库纯净，不修改原始结构

### 部署灵活性
- 本地部署、本地服务器安装或使用Directus Cloud服务
- 容器化部署支持，适合各种基础设施环境

### 可扩展性
- 模块化架构，易于定制和扩展
- 支持白标定制，适应企业品牌需求
- 丰富的扩展生态系统，包括自定义模块、钩子和接口

### 现代化管理界面
- 基于Vue.js构建的无代码应用
- 直观的用户界面，无需培训即可使用
- 角色和权限管理，确保数据安全
- 实时数据更新和可视化

## 3. 使用场景和适用范围

### 内容管理系统
- 管理网站、移动应用和其他数字平台的内容
- 支持多种内容类型，包括文本、图像、视频等
- 非技术人员可轻松更新内容，无需开发人员参与

### 数据可视化平台
- 将复杂数据库数据转换为直观的图表和报表
- 实时数据监控和分析
- 自定义仪表板创建

### API后端服务
- 为前端应用提供标准化的数据接口
- 简化前后端分离架构的实现
- 支持REST和GraphQL两种API风格

### 内部数据管理工具
- 企业内部数据录入和管理系统
- 工作流程自动化
- 跨部门数据共享平台

## 4. 使用方法和配置说明

### 前提条件
- Docker Engine 19.03.0+
- Docker Compose (推荐)
- 数据库服务(PostgreSQL, MySQL等)

### Docker Run 快速启动

```bash
# 使用SQLite数据库(仅适用于开发环境)
docker run -p 8055:8055 docker.xuanyuan.run/directus/directus

# 使用外部数据库
docker run -p 8055:8055 \
  -e KEY="your-random-key" \
  -e SECRET="your-random-secret" \
  -e DB_CLIENT="pg" \
  -e DB_HOST="your-postgres-host" \
  -e DB_PORT="5432" \
  -e DB_DATABASE="your-db-name" \
  -e DB_USER="your-db-user" \
  -e DB_PASSWORD="your-db-password" \
  docker.xuanyuan.run/directus/directus
```

### Docker Compose 配置示例

```yaml
version: '3.8'

services:
  directus:
    image: docker.xuanyuan.run/directus/directus:latest
    ports:
      - 8055:8055
    volumes:
      - ./uploads:/directus/uploads
      - ./database:/directus/database
      - ./extensions:/directus/extensions
    environment:
      KEY: 'your-random-key'
      SECRET: 'your-random-secret'
      DB_CLIENT: 'sqlite3'
      DB_FILENAME: '/directus/database/data.db'
      ADMIN_EMAIL: 'admin@example.com'
      ADMIN_PASSWORD: 'd1r3ctu5'
      WEBSOCKETS_ENABLED: 'true'
    restart: always
```

### 初始化管理员账户

首次启动时，可以通过环境变量设置初始管理员账户：

```bash
-e ADMIN_EMAIL="admin@example.com" \
-e ADMIN_PASSWORD="your-secure-password"
```

或者在启动后通过CLI创建：

```bash
docker exec -it <container-id> npx directus admin create --email admin@example.com --password your-secure-password
```

### 环境变量配置

核心配置变量：

| 变量名 | 描述 | 默认值 |
|--------|------|--------|
| `KEY` | 用于加密的随机字符串 | 无，必须设置 |
| `SECRET` | 用于签名的随机字符串 | 无，必须设置 |
| `DB_CLIENT` | 数据库客户端类型 | `sqlite3` |
| `DB_HOST` | 数据库主机地址 | `localhost` |
| `DB_PORT` | 数据库端口 | 取决于数据库类型 |
| `DB_DATABASE` | 数据库名称 | `directus` |
| `DB_USER` | 数据库用户名 | 无 |
| `DB_PASSWORD` | 数据库密码 | 无 |
| `ADMIN_EMAIL` | 初始管理员邮箱 | 无 |
| `ADMIN_PASSWORD` | 初始管理员密码 | 无 |
| `PORT` | Directus服务端口 | `8055` |
| `LOG_LEVEL` | 日志级别 | `info` |
| `WEBSOCKETS_ENABLED` | 是否启用WebSocket | `false` |

完整的环境变量列表请参考[官方文档](https://docs.directus.io/self-hosted/config-options.html)。

## 5. Directus Cloud 服务

除了自托管部署外，Directus提供托管云服务选项：

- 价格从$15/月起
- 自助服务仪表板，集中管理所有项目
- 包含Directus、数据库、存储、自动扩展和全球CDN
- 选择所需区域，约90秒内即可完成新项目部署

[创建Directus Cloud项目](https://directus.cloud)

## 6. 社区支持与资源

### 官方文档
[Directus文档](https://docs.directus.io)是开始使用的最佳资源。

### 社区渠道
- [Discord](https://directus.chat) - 问题解答和实时讨论
- [GitHub Issues](https://github.com/directus/directus/issues) - 报告错误
- [GitHub Discussions](https://github.com/directus/discussions) - 功能请求
- [Twitter](https://twitter.com/directus) - 最新消息
- [YouTube](https://www.youtube.com/c/DirectusVideos/featured) - 视频教程

## 7. 许可协议

Directus采用[Business Source License (BSL) 1.1](https://github.com/directus/directus/blob/main/license)许可协议，并附加了允许性使用授权。

### 对大多数用户免费
如果您的组织年收入和/或资金总和低于500万美元，您可以以任何方式免费使用Directus。

### 企业使用
对于在生产环境中使用Directus的大型组织（年收入/资金>500万美元），需要商业许可。

这种许可模式有助于保持Directus对大多数社区免费，同时确保从平台中获益的大型组织为其持续开发做出贡献。

## 8. 学习资源

- [Directus官方网站](https://directus.io)
- [Directus文档](https://docs.directus.io)
- [Directus视频教程](https://www.youtube.com/c/DirectusVideos/featured)
- [Directus GitHub仓库](https://github.com/directus/directus)
