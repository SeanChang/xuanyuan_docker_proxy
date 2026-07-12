---
image: elestio/strapi-production
description: "Strapi生产环境版本，由Elestio验证并打包，用于部署无头CMS以构建API和管理内容的可靠镜像。"
source: https://xuanyuan.cloud/zh/r/elestio/strapi-production
canonical: https://xuanyuan.cloud/zh/r/elestio/strapi-production
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elestio/strapi-production" title="elestio/strapi-production Docker 镜像中文简介、标签列表与拉取命令">elestio/strapi-production 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Strapi（由Elestio验证和打包）

## 镜像概述和主要用途

[Strapi](https://github.com/strapi/strapi-docker) 是一款开源、完全可定制且可扩展的基于JavaScript的无头CMS（内容管理系统）。Elestio提供的此镜像经过验证和打包，旨在帮助用户快速部署和管理Strapi实例，适用于创建易于维护的JavaScript API。

![Strapi界面](https://elest.io/images/softwares/65/screenshot2.jpg)

## 核心功能和特性

### Strapi核心功能
- 开源无头CMS，专注于API开发
- 完全可定制的数据模型和内容结构
- 基于JavaScript/Node.js构建，支持现代前端框架集成
- 内置用户认证、权限管理和API文档

### Elestio镜像特性
- 与原始源码更新同步，通过自动化流程快速发布新版本
- 及时提供最新的漏洞修复和功能更新
- 经过质量控制检查，确保符合高标准的产品质量

## 使用场景和适用范围

- 需要快速开发和管理RESTful或GraphQL API的项目
- 前端与后端分离架构中，作为后端数据管理和API提供层
- 中小型企业构建自定义内容管理系统
- JavaScript/Node.js开发者需要低代码后端解决方案
- 需灵活扩展和定制数据模型的应用场景

## 详细使用方法和配置说明

### Docker Compose部署

以下是使用Docker Compose部署Strapi的示例配置：

```yaml
version: "3"
services:
  strapi:
    image: docker.xuanyuan.run/elestio/strapi-${NODE_ENV}:latest
    restart: always
    env_file: .env
    environment:
      DATABASE_CLIENT: ${DATABASE_CLIENT}
      DATABASE_HOST: db
      DATABASE_PORT: ${DATABASE_PORT}
      DATABASE_NAME: ${DATABASE_NAME}
      DATABASE_USERNAME: ${DATABASE_USERNAME}
      DATABASE_PASSWORD: ${DATABASE_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
      ADMIN_JWT_SECRET: ${ADMIN_JWT_SECRET}
      APP_KEYS: ${APP_KEYS}
      NODE_ENV: ${NODE_ENV}
    volumes:
      - ./config:/opt/app/config           # 配置文件持久化
      - ./src:/opt/app/src                 # 源代码持久化
      # - ./package.json:/opt/package.json  # 可选：自定义依赖
      # - ./yarn.lock:/opt/yarn.lock        # 可选：依赖版本锁定
      - ./.env:/opt/app/.env               # 环境变量文件
      - ./public/uploads:/opt/app/public/uploads  # 上传文件持久化
      - ./entrypoint.sh:/opt/app/entrypoint.sh    # 入口脚本
    ports:
      - "172.17.0.1:9930:1337"             # 端口映射（主机:容器）
    depends_on:
      - db                                 # 依赖PostgreSQL数据库

  db:
    image: docker.xuanyuan.run/elestio/postgres:latest         # Elestio PostgreSQL镜像
    restart: always
    environment:
      POSTGRES_DB: ${DATABASE_NAME}        # 数据库名
      POSTGRES_USER: ${DATABASE_USERNAME}  # 数据库用户
      POSTGRES_PASSWORD: ${DATABASE_PASSWORD}  # 数据库密码
      PGDATA: /var/lib/postgresql/data     # 数据存储路径
    volumes:
      - ./pgdata:/var/lib/postgresql/data  # 数据库数据持久化
    ports:
      - "172.17.0.1:24538:5432"            # PostgreSQL端口映射
```

### 环境变量配置

| 变量名                | 示例值                  | 说明                          |
|-----------------------|-------------------------|-------------------------------|
| ADMIN_PASSWORD        | your-password           | 管理员密码                    |
| ADMIN_EMAIL           | your@email.com          | 管理员邮箱                    |
| BASE_URL              | https://your.domain     | 应用基础URL                   |
| SMTP_HOST             | 172.17.0.1              | SMTP服务器地址                |
| SMTP_PORT             | 25                      | SMTP服务器端口                |
| SMTP_AUTH_STRATEGY    | NONE                    | SMTP认证策略（如NONE、LOGIN） |
| SMTP_FROM_EMAIL       | sender@email.com        | 发件人邮箱                    |
| DATABASE_CLIENT       | postgres                | 数据库客户端（如postgres、mysql） |
| DATABASE_PORT         | 5432                    | 数据库端口                    |
| DATABASE_NAME         | strapi                  | 数据库名称                    |
| DATABASE_USERNAME     | postgres                | 数据库用户名                  |
| DATABASE_PASSWORD     | your-password           | 数据库密码                    |
| JWT_SECRET            | your-password           | JWT签名密钥                   |
| ADMIN_JWT_SECRET      | your-password           | 管理员JWT密钥                 |
| APP_KEYS              | your-password           | 应用密钥                      |
| NODE_ENV              | production              | 运行环境（production/development） |
| DATABASE_HOST         | db                      | 数据库主机名（Docker服务名）  |
| API_TOKEN_SALT        | your-password           | API令牌盐值                   |
| TRANSFER_TOKEN_SALT   | your-password           | 传输令牌盐值                  |

### 访问方式

部署完成后，可通过以下地址访问Strapi Web管理界面：  
`http://你的域名:9930`

## 维护

### 日志查看

Elestio Strapi镜像将容器日志输出到stdout，可通过以下命令查看：

```bash
docker-compose logs -f
```

### 停止容器

停止整个服务栈：

```bash
docker-compose down
```

### 备份与恢复

由于采用文件夹卷挂载，备份和恢复操作简单：

#### 创建备份（ZIP归档）
进入docker-compose.yml所在目录，执行以下命令创建归档：

```bash
zip -r myarchive.zip .
```

#### 从备份恢复
将归档解压到原始目录：

```bash
unzip myarchive.zip -d /path/to/original/folder
```

#### 启动服务
恢复完成后，启动服务栈：

```bash
docker-compose up -d
```

## 相关链接

- [Strapi GitHub仓库](https://github.com/strapi/strapi-docker)
- [Strapi官方文档](https://docs.strapi.io/)
