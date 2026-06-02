---
image: rocketchat/rocket.chat
description: "官方Rocket.Chat Docker部署镜像，用于快速部署开源团队聊天与协作平台。"
source: https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat
canonical: https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat" title="rocketchat/rocket.chat Docker 镜像中文简介、标签列表与拉取命令">rocketchat/rocket.chat — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat" title="rocketchat/rocket.chat Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rocketchat/rocket.chat</a>

# Rocket.Chat Docker镜像文档


## 镜像概述和主要用途

Rocket.Chat 是一款开源的企业级 Web 聊天平台，支持实时通信、团队协作和社区互动。本 Docker 镜像是官方提供的部署镜像，旨在简化 Rocket.Chat 服务器的搭建过程，确保环境一致性和部署效率。通过该镜像，用户可快速部署私有聊天服务器，实现数据自主管理和定制化配置。


## 核心功能和特性

- **多场景通信支持**：公共频道、私有群组、直接消息、私聊群等多种聊天模式  
- **丰富的消息功能**：支持 Markdown 格式、表情符号、自定义表情、消息 reactions、消息编辑与删除  
- **多媒体集成**：媒体嵌入、链接预览、文件上传/共享（支持 S3 存储与 CDN 加速）、地理位置分享  
- **通知系统**：桌面通知、@提及提醒、未读消息标识  
- **身份验证与安全**：LDAP 集成、CAS 1.0/2.0 支持、SAML v2（Okta SSO）、本地用户管理  
- **搜索与历史**：全文搜索、全局跨频道搜索、聊天记录存档  
- **协作增强**：实时协作编辑、TeX 数学公式渲染、代码块高亮  
- **多平台访问**：支持桌面客户端（Windows/macOS/Linux）、移动应用（iOS/Android）及 Web 端  
- **集成能力**：REST API、Webhook、Hubot 机器人支持、XMPP 桥接、Jitsi 视频会议集成  


## 使用场景和适用范围

- **企业内部通信**：替代传统邮件或即时通讯工具，实现团队实时协作  
- **开发团队协作**：代码讨论、任务分配、集成 CI/CD 通知（如 GitHub/GitLab 事件推送）  
- **在线社区管理**：构建私有或公开社区，支持用户互动与内容管理  
- **客户支持系统**：作为实时客服工具，集成工单系统处理用户咨询  
- **教育机构**：师生交流、课程讨论、在线答疑平台  


## 使用方法和配置说明

### 前提条件

- Docker 19.03+ 环境  
- MongoDB 4.0+ 数据库（可通过 Docker 容器或外部服务部署）  


### 1. 拉取镜像

官方镜像托管于 Docker Hub，支持以下标签：  
- `latest`：最新稳定版  
- `X.X.X`（如 `v6.3.0`）：特定版本（需替换为实际版本号）  

```bash
# 拉取最新稳定版
docker pull rocketchat/rocket.chat:latest

# 拉取特定版本（示例）
docker pull rocketchat/rocket.chat:v6.3.0
```


### 2. 基本部署（Docker Run）

需先启动 MongoDB 容器（或配置外部 MongoDB），再运行 Rocket.Chat：

#### 步骤 1：启动 MongoDB
```bash
docker run -d \
  --name mongodb \
  -v /path/to/mongodb/data:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=mongopassword \
  mongo:4.4 --replSet rs0
```

#### 步骤 2：初始化 MongoDB 副本集（必需）
```bash
# 进入 MongoDB 容器
docker exec -it mongodb mongosh -u mongoadmin -p mongopassword

# 在 MongoDB 终端执行初始化命令
rs.initiate({
  _id: "rs0",
  members: [{_id: 0, host: "localhost:27017"}]
})
exit
```

#### 步骤 3：启动 Rocket.Chat
```bash
docker run -d \
  --name rocketchat \
  --link mongodb:mongodb \
  -p 3000:3000 \
  -e ROOT_URL=http://your-domain.com:3000 \  # 访问 URL（需替换为实际域名/IP）
  -e MONGO_URL=mongodb://mongoadmin:mongopassword@mongodb:27017/rocketchat?authSource=admin \
  -e MONGO_OPLOG_URL=mongodb://mongoadmin:mongopassword@mongodb:27017/local?authSource=admin&replSet=rs0 \
  rocketchat/rocket.chat:latest
```

访问 `http://your-domain.com:3000` 即可进入 Rocket.Chat 初始化界面，创建管理员账户并配置服务器。


### 3. 推荐部署（Docker Compose）

使用 `docker-compose.yml` 管理多容器部署（包含 MongoDB 和 Rocket.Chat）：

```yaml
version: '3'

services:
  mongodb:
    image: mongo:4.4
    container_name: mongodb
    restart: always
    volumes:
      - mongodb_data:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=mongoadmin
      - MONGO_INITDB_ROOT_PASSWORD=mongopassword
    command: --replSet rs0
    networks:
      - rocketchat_network

  rocketchat:
    image: rocketchat/rocket.chat:latest
    container_name: rocketchat
    restart: always
    depends_on:
      - mongodb
    ports:
      - "3000:3000"
    environment:
      - ROOT_URL=http://your-domain.com:3000  # 替换为实际访问 URL
      - MONGO_URL=mongodb://mongoadmin:mongopassword@mongodb:27017/rocketchat?authSource=admin
      - MONGO_OPLOG_URL=mongodb://mongoadmin:mongopassword@mongodb:27017/local?authSource=admin&replSet=rs0
      - PORT=3000  # 容器内部端口（默认 3000）
    networks:
      - rocketchat_network

networks:
  rocketchat_network:

volumes:
  mongodb_data:  # 持久化 MongoDB 数据
```

启动服务：
```bash
# 初始化 MongoDB 副本集（首次运行需执行）
docker-compose exec mongodb mongosh -u mongoadmin -p mongopassword --eval "rs.initiate({_id: 'rs0', members: [{_id: 0, host: 'mongodb:27017'}]})"

# 启动所有服务
docker-compose up -d
```


## 配置参数（环境变量）

Rocket.Chat 容器通过环境变量配置核心参数，常用配置如下：

| 环境变量                | 描述                                                                 | 示例值                                                                 |
|-------------------------|----------------------------------------------------------------------|------------------------------------------------------------------------|
| `ROOT_URL`              | 服务器对外访问 URL（含协议和端口）                                   | `https://chat.example.com` 或 `http://192.168.1.100:3000`              |
| `MONGO_URL`             | MongoDB 连接 URL（需包含认证信息）                                  | `mongodb://user:pass@mongodb:27017/rocketchat?authSource=admin`       |
| `MONGO_OPLOG_URL`       | MongoDB 副本集 oplog URL（用于实时数据同步，必需）                   | `mongodb://user:pass@mongodb:27017/local?authSource=admin&replSet=rs0` |
| `PORT`                  | 容器内部服务端口（默认 3000，需与 `docker run -p` 映射一致）         | `3000`                                                                 |
| `ADMIN_USERNAME`        | 初始管理员用户名（首次启动时创建）                                   | `admin`                                                                |
| `ADMIN_PASSWORD`        | 初始管理员密码（首次启动时创建）                                     | `SecurePass123!`                                                       |
| `ADMIN_EMAIL`           | 初始管理员邮箱                                                       | `admin@example.com`                                                    |
| `FILE_UPLOAD_STORAGE`   | 文件存储方式（`local` 本地存储，`s3` AWS S3，`gridfs` MongoDB GridFS） | `s3`                                                                    |
| `SMTP_Host`             | SMTP 服务器地址（用于邮件通知）                                      | `smtp.example.com`                                                     |
| `SMTP_Port`             | SMTP 服务器端口                                                     | `587`                                                                  |
| `SMTP_Username`         | SMTP 认证用户名                                                     | `notifications@example.com`                                            |
| `SMTP_Password`         | SMTP 认证密码                                                       | `smtp-pass`                                                            |


## 注意事项

1. **数据持久化**：  
   - MongoDB 数据需通过 Docker Volume 持久化（如示例中的 `mongodb_data`），避免容器删除导致数据丢失。  
   - Rocket.Chat 本地文件上传默认存储于容器 `/app/uploads`，需挂载 Volume 持久化（添加 `-v rocketchat_uploads:/app/uploads` 到 `docker run` 或 `docker-compose` 配置）。

2. **升级说明**：  
   - 升级前需备份 MongoDB 数据。  
   - 通过 `docker pull` 获取新版本镜像后，重启容器即可（`docker-compose up -d --force-recreate`）。

3. **安全建议**：  
   - 生产环境中需配置 HTTPS（可通过 Nginx/Traefik 反向代理实现），并更新 `ROOT_URL` 为 HTTPS 地址。  
   - 限制 MongoDB 容器网络访问，仅允许 Rocket.Chat 容器连接。

4. **性能优化**：  
   - 高并发场景下，建议部署 MongoDB 副本集（多节点）并配置 `MONGO_OPLOG_URL` 以提升同步效率。  
   - 调整容器资源限制（`--memory`、`--cpus`）避免资源耗尽。


## 官方文档与支持

- **完整文档**：[Rocket.Chat 官方文档](https://rocket.chat/docs/)  
- **Docker 部署指南**：[Docker 安装说明](https://rocket.chat/docs/installation/docker-containers/)  
- **社区支持**：[Rocket.Chat 社区服务器](https://open.rocket.chat/)  
- **问题反馈**：[GitHub Issues](https://github.com/RocketChat/Rocket.Chat/issues)
