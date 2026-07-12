---
image: vshadbolt/strapi
description: "用于Strapi v4+和v5+的Docker镜像，支持创建新Strapi项目或运行现有项目，可通过环境变量配置数据库、URL、CORS等参数，支持开发和生产模式，简化API和内容管理框架的部署。"
source: https://xuanyuan.cloud/zh/r/vshadbolt/strapi
canonical: https://xuanyuan.cloud/zh/r/vshadbolt/strapi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vshadbolt/strapi" title="vshadbolt/strapi Docker 镜像中文简介、标签列表与拉取命令">vshadbolt/strapi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Strapi (v4+ 和 v5+) 容器化镜像

![Strapi](https://github.com/V-Shadbolt/Docker-strapi/blob/main/assets/PNG.logo.purple.dark.png?raw=true)

> Strapi v4 和 v5（最新版本）的Docker镜像

API创建变得简单、安全且快速。最先进的开源内容管理框架，无需费力即可构建强大的API。

[GitHub仓库](https://github.com/V-Shadbolt/Docker-strapi)

[Docker Hub](https://hub.docker.com/r/vshadbolt/strapi)

[![Docker Pulls](https://img.shields.io/docker/pulls/vshadbolt/strapi.svg?style=for-the-badge)](https://hub.docker.com/r/vshadbolt/strapi)

---

# 如何使用？

该镜像允许您在Docker中创建新的Strapi项目或运行现有Strapi项目。

无论是新项目还是现有项目，修改`NODE_ENV`环境变量将决定项目的启动方式。

- `NODE_ENV=development`：项目将以开发模式运行，执行命令[`strapi develop`](https://docs.strapi.io/developer-docs/latest/developer-resources/cli/CLI.html#strapi-develop)。

- `NODE_ENV=production`：项目将以生产模式运行，执行命令[`strapi start`](https://docs.strapi.io/developer-docs/latest/developer-resources/cli/CLI.html#strapi-start)。

> 当`NODE_ENV=production`时，[内容类型构建器](https://strapi.io/features/content-types-builder)插件将被禁用。

---

## 创建新的Strapi项目

运行此镜像时，Strapi会检查容器的`/srv/app`目录中是否存在项目。如果不存在现有项目，它将在容器的`/srv/app`目录中运行[`create strapi-app`](https://docs.strapi.io/dev-docs/quick-start#-part-a-create-a-new-project-with-strapi)命令。

该命令默认创建使用SQLite数据库的项目，然后在端口`1337`上启动Strapi。

不过，此镜像会覆盖未配置的`config/admin.js`、`config/server.js`和`config/middlewares.js`文件，以便通过Docker环境变量设置镜像源、CORS参数、管理界面URL和公共服务器URL。以下是配置示例：

### 核心配置环境变量

- `ADMIN_URL: tobemodified`：为管理页面设置自定义子域名/域名。例如：`https://api.example.com/admin`。若不设置，配置默认值为`http://localhost:1337/admin`。

- `PUBLIC_URL: tobemodified`：为API端点设置自定义域名。例如：`https://api.example.com`。若不设置环境变量，配置默认值为`http://localhost:1337`。

- `IMG_ORIGIN: "toBeModified1,toBeModified2"`：为项目添加新的镜像源。例如：`'self',data:,blob:,market-assets.strapi.io,api.example.com`。若不设置环境变量，配置默认值为`'self',data:,blob:,market-assets.strapi.io`。

- `CORS_ORIGIN: "toBeModified1,toBeModified2"`：为项目添加新的CORS源。例如：`https://myfrontendwebsite.example.com,https://api.example.com`。若不设置环境变量，配置默认值为`*`。

> 如果Docker主机是远程的，`ADMIN_URL`和`PUBLIC_URL`的默认值会抛出错误。对于远程项目，至少需要设置Docker主机IP。例如：`http://192.168.1.1:1337`。理想情况下使用nginx代理设置或子域名/域名。如果主机不是远程的，`http://localhost:1337`可正常工作。

### 数据库配置环境变量

支持配置多种数据库类型：

- `DATABASE_CLIENT: tobemodified`：Strapi支持的数据库提供程序（sqlite、postgres、mysql、mongo）。例如：postgres。

- `DATABASE_HOST: database host IP / container name`：数据库主机IP或容器名称。例如：strapiDB。

- `DATABASE_PORT: database host port / container port`：数据库主机端口或容器端口。例如：5432。

- `DATABASE_NAME: tobemodified`：数据库名称。例如：strapi。

- `DATABASE_USERNAME: tobemodified`：数据库用户名。例如：strapi。

- `DATABASE_PASSWORD: tobemodified`：数据库密码。例如：strapi。

- `DATABASE_SSL: tobemodified`：SSL布尔值。例如：false。

### 安全密钥环境变量

需设置随机字符串作为安全密钥：

- `JWT_SECRET: tobemodified`：随机字符串。例如：`JrWfVf/o9TbWQmpMgsJaYp==`。

- `ADMIN_JWT_SECRET: tobemodified`：随机字符串。例如：`MCpf2/FMiCJthF5d6Qup6iG==`。

- `APP_KEYS: toBeModified1,toBeModified2`：多个随机字符串。例如：`w9/ZTuHUWNF2EP8gdfPcNn==,LqXKC52TsN/z/Y2rUGTa6m==,d7EKo2Tp9SiGf82ZqrmSnB==,TAu2SJx6BDc7aYUyqiwxKs==`。

- `API_TOKEN_SALT: tobemodified`：随机字符串。例如：`j43/kBRfXULfPpJnzPCJzi==`。

- `TRANSFER_TOKEN_SALT: tobemodified`：随机字符串。例如：`GCX3NkRSyHrDxhfgwnmCm3==`。

### 项目构建环境变量

修改配置后需重新构建项目：

- `BUILD: tobemodified`：重新构建Strapi项目的布尔值。例如：true。

> 不添加此参数将使`/config`目录中的任何更改无效，直到添加为止。对于URL更改尤其重要。

### 反向代理支持

在开发模式（`NODE_ENV=development`）下将Strapi运行在反向代理（如Caddy、Nginx或Traefik）后面时，可能会遇到以下错误：

```
Blocked request. This host ("api.example.com") is not allowed.
To allow this host, add "api.example.com" to `server.allowedHosts` in vite.config.js.
```

可通过以下变量解决：

- `ENABLE_VITE_ALLOWED_HOSTS: tobemodified`：启用Vite允许主机修复的布尔值。例如：`true`。

设置为`true`时，将自动创建`vite.config.js`（JavaScript项目）或`vite.config.ts`（TypeScript项目）文件，允许所有主机。

> 完整示例[compose文件](https://github.com/V-Shadbolt/docker-strapi/blob/main/./examples/strapi-postgres/docker-compose.yml)及更多示例见[此处](https://github.com/V-Shadbolt/docker-strapi/tree/main/examples)。

---

## 迁移现有Strapi项目

要运行不是使用此镜像创建的现有项目，需将项目文件夹挂载到容器的`/srv/app`目录。需直接修改项目配置文件，确保数据库可访问，并谨慎备份。

> 对于现有项目，`config/admin.js`、`config/server.js`和`config/middlewares.js`文件需配置为不使用`http://localhost:1337`（除非主机是本地的）。

对于使用此镜像创建的现有项目，迁移时可挂载项目文件夹并利用上述环境变量修改配置。

---

## 更新Strapi

### V4+

停止容器，拉取指定版本镜像（`:4.x.x`或`:latest-v4`），重新创建容器。

> 升级过程缓慢，跨次要和补丁版本，可能存在破坏性变更，需备份。

### V4到V5

⚠️ 谨慎操作。停止容器，拉取`latest`或`:5.x.x`标签镜像，重新创建容器。需参考[官方升级指南](https://docs.strapi.io/dev-docs/migration/v4-to-v5/step-by-step)，确保备份。

### V5+

停止容器，拉取指定版本镜像（`:5.x.x`或`:latest`），重新创建容器。

> ⚠️ Strapi v5使用[升级工具](https://docs.strapi.io/dev-docs/upgrade-tool)，可能存在依赖冲突，需备份。

---

## 常见问题处理

### Strapi v4.15.5+ 缺少React模块

镜像已修改入口点，使用`npx create strapi-app`获取所需包，并为现有项目自动安装`react`、`react-dom`、`react-router-dom`、`styled-components`。

### Strapi Cloud v4.25.0+

入口点已修改，跳过新Strapi项目的Strapi Cloud设置。

### 数据库模块缺失

- Postgres：v5.6.0+和v4.25.16+自动添加`pg`模块。
- MySQL：v5.10.2+和v4.25.20+自动添加`mysql`模块。

---

# 官方文档

- Strapi官方文档：[https://docs.strapi.io/](https://docs.strapi.io/)
- 官方Strapi v3 Docker镜像（不再维护）：[GitHub](https://github.com/strapi/strapi-Docker)
- Strapi Docker安装文档：[https://docs.strapi.io/dev-docs/installation/Docker](https://docs.strapi.io/dev-docs/installation/Docker)
