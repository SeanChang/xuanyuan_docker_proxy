---
image: amd64/rocket.chat
description: "完整的开源聊天解决方案"
source: https://xuanyuan.cloud/zh/r/amd64/rocket.chat
canonical: https://xuanyuan.cloud/zh/r/amd64/rocket.chat
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/rocket.chat" title="amd64/rocket.chat Docker 镜像中文简介、标签列表与拉取命令">amd64/rocket.chat 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Rocket.Chat Docker镜像文档

## 镜像概述和主要用途

Rocket.Chat是一个完整的开源聊天解决方案，作为Web聊天服务器开发，使用JavaScript构建并基于Meteor全栈框架。本镜像为Rocket.Chat官方镜像的`amd64`架构版本，适用于希望私有部署聊天服务的社区和企业，或需要构建和扩展自有聊天平台的开发人员。

## 核心功能和特性

- 完整的团队协作平台，支持实时消息、语音和视频通话
- 支持多平台访问，包括Web、移动端和桌面应用
- 可扩展的架构，支持第三方集成和自定义插件
- 端到端加密，确保通信安全
- 支持文件共享、屏幕共享和实时协作
- 提供API接口，便于系统集成和自动化

## 使用场景和适用范围

- 企业内部沟通和协作平台
- 社区论坛和用户支持系统
- 开发团队实时协作工具
- 客户服务和支持聊天系统
- 教育机构在线教学和讨论平台
- 需要私有部署的安全通信系统

## 支持的标签及对应Dockerfile链接

- [`7.10.0`, `7.10`, `7`, `latest`](https://github.com/RocketChat/Docker.Official.Image/blob/9006d708f0185bafdae764924be1f553ec55bfed/7.10/Dockerfile)
- [`7.9.3`, `7.9`](https://github.com/RocketChat/Docker.Official.Image/blob/75c516a89b6e98d44085fa9cd33f9bc5f2b5986c/7.9/Dockerfile)
- [`7.8.4`, `7.8`](https://github.com/RocketChat/Docker.Official.Image/blob/dddaa7c23275b8514d1d994bdfabaafd510f0ebf/7.8/Dockerfile)
- [`7.7.8`, `7.7`](https://github.com/RocketChat/Docker.Official.Image/blob/dddaa7c23275b8514d1d994bdfabaafd510f0ebf/7.7/Dockerfile)
- [`7.6.5`, `7.6`](https://github.com/RocketChat/Docker.Official.Image/blob/dddaa7c23275b8514d1d994bdfabaafd510f0ebf/7.6/Dockerfile)
- [`7.5.4`, `7.5`](https://github.com/RocketChat/Docker.Official.Image/blob/dddaa7c23275b8514d1d994bdfabaafd510f0ebf/7.5/Dockerfile)
- [`7.4.5`, `7.4`](https://github.com/RocketChat/Docker.Official.Image/blob/dddaa7c23275b8514d1d994bdfabaafd510f0ebf/7.4/Dockerfile)

## 详细使用方法和配置说明

### 前提条件

- Docker Engine 1.10.0+
- Docker Compose (可选，用于多容器部署)
- MongoDB 4.0+ (独立部署或容器化部署)

### 基本部署步骤

#### 1. 启动MongoDB数据库

首先需要部署MongoDB并配置副本集：

```bash
# 启动MongoDB容器
docker run --name db -d docker.xuanyuan.run/mongo:4.0 --smallfiles --replSet rs0 --oplogSize 128

# 初始化MongoDB副本集
docker exec -ti db mongo --eval "printjson(rs.initiate())"
```

#### 2. 启动Rocket.Chat容器

```bash
# 基本启动命令
docker run --name rocketchat --link db --env MONGO_OPLOG_URL=mongodb://db:27017/local -d docker.xuanyuan.run/amd64/rocket.chat

# 映射端口到主机
docker run --name rocketchat -p 80:3000 --link db \
  --env ROOT_URL=http://localhost \
  --env MONGO_OPLOG_URL=mongodb://db:27017/local \
  -d docker.xuanyuan.run/amd64/rocket.chat
```

通过浏览器访问 `http://localhost` 即可打开Rocket.Chat界面。如果在实际服务器部署，请将`ROOT_URL`替换为您的域名。

#### 3. 使用第三方MongoDB服务

如果使用第三方MongoDB服务或Kubernetes部署，需要覆盖`MONGO_URL`环境变量：

```bash
docker run --name rocketchat -p 80:3000 \
  --env ROOT_URL=http://your-domain.com \
  --env MONGO_URL=mongodb://mymongourl/mydb \
  --env MONGO_OPLOG_URL=mongodb://mymongourl:27017/local \
  -d docker.xuanyuan.run/amd64/rocket.chat
```

### Docker Compose部署

创建`docker-compose.yml`文件：

```yaml
version: '3'

services:
  mongodb:
    image: docker.xuanyuan.run/mongo:4.0
    container_name: rocketchat-mongo
    restart: unless-stopped
    volumes:
      - mongo_data:/data/db
    command: mongod --smallfiles --replSet rs0 --oplogSize 128
    networks:
      - rocketchat_network

  rocketchat:
    image: docker.xuanyuan.run/amd64/rocket.chat
    container_name: rocketchat
    restart: unless-stopped
    depends_on:
      - mongodb
    environment:
      - ROOT_URL=http://localhost:3000
      - MONGO_URL=mongodb://mongodb:27017/rocketchat
      - MONGO_OPLOG_URL=mongodb://mongodb:27017/local
    ports:
      - "3000:3000"
    networks:
      - rocketchat_network

networks:
  rocketchat_network:

volumes:
  mongo_data:
```

启动服务：

```bash
# 启动前先初始化MongoDB副本集
docker-compose up -d mongodb
docker-compose exec mongodb mongo --eval "printjson(rs.initiate())"

# 启动Rocket.Chat
docker-compose up -d
```

## 环境变量配置

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| `ROOT_URL` | 应用的根URL | `http://localhost:3000` |
| `MONGO_URL` | MongoDB连接URL | `mongodb://db:27017/rocketchat` |
| `MONGO_OPLOG_URL` | MongoDB操作日志URL | `mongodb://db:27017/local` |
| `PORT` | 应用监听端口 | `3000` |
| `NODE_ENV` | 运行环境 | `production` |
| `ADMIN_USERNAME` | 管理员用户名 | - |
| `ADMIN_EMAIL` | 管理员邮箱 | - |
| `ADMIN_PASS` | 管理员密码 | - |
| `MAIL_URL` | SMTP邮件服务器配置 | - |

## 持久化数据

为确保数据持久化，建议为MongoDB和Rocket.Chat配置数据卷：

```bash
# 创建数据卷
docker volume create mongo_data
docker volume create rocketchat_data

# 使用数据卷启动容器
docker run --name db -d -v mongo_data:/data/db docker.xuanyuan.run/mongo:4.0 --smallfiles --replSet rs0 --oplogSize 128

docker run --name rocketchat -p 80:3000 -v rocketchat_data:/app/uploads \
  --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/local \
  -d docker.xuanyuan.run/amd64/rocket.chat
```

## 生产环境部署最佳实践

有关生产环境部署的详细指南，请访问官方文档：  
[https://rocket.chat/docs/installation/docker-containers/](https://rocket.chat/docs/installation/docker-containers/)

## 问题与支持

如遇到问题，可通过以下渠道获取支持：
- Docker社区Slack: [https://dockr.ly/comm-slack](https://dockr.ly/comm-slack)
- Server Fault: [https://serverfault.com/help/on-topic](https://serverfault.com/help/on-topic)
- Unix & Linux: [https://unix.stackexchange.com/help/on-topic](https://unix.stackexchange.com/help/on-topic)
- Stack Overflow: [https://stackoverflow.com/help/on-topic](https://stackoverflow.com/help/on-topic)
- Rocket.Chat社区论坛: [https://forums.rocket.chat](https://forums.rocket.chat)

## 许可证信息

本镜像包含的软件许可证信息请查看:  
[https://github.com/RocketChat/Rocket.Chat/blob/master/LICENSE](https://github.com/RocketChat/Rocket.Chat/blob/master/LICENSE)

与所有Docker镜像一样，本镜像可能还包含其他软件，这些软件可能具有不同的许可证（如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

可在[repo-info仓库的rocket.chat目录](https://github.com/docker-library/repo-info/tree/master/repos/rocket.chat)中找到一些能够自动检测到的额外许可证信息。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用符合其中包含的所有软件的相关许可证。
