---
image: arm64v8/mongo
description: "MongoDB文档数据库提供高可用性和易于扩展的特性。"
source: https://xuanyuan.cloud/zh/r/arm64v8/mongo
canonical: https://xuanyuan.cloud/zh/r/arm64v8/mongo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/mongo" title="arm64v8/mongo Docker 镜像中文简介、标签列表与拉取命令">arm64v8/mongo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MongoDB (arm64v8) Docker 镜像文档


## 1. 镜像概述和主要用途

本镜像是 MongoDB 官方镜像的 `arm64v8` 架构专用版本，基于 [MongoDB 官方镜像](https://hub.docker.com/_/mongo) 构建。MongoDB 是一个开源的面向文档的 NoSQL 数据库，采用 JSON 类文档格式存储数据，支持动态模式，提供高可用性和灵活的水平扩展能力。本镜像适用于在 arm64v8 架构环境中快速部署 MongoDB 数据库服务，满足对灵活数据模型、高可用性和可扩展性有需求的应用场景。


## 2. 核心功能和特性

- **文档导向存储**：采用 BSON（二进制 JSON）格式存储数据，支持嵌套文档和数组，适合表示复杂数据结构。
- **动态模式**：无需预定义表结构，文档可以拥有不同字段，适应数据模型的快速迭代。
- **高可用性**：支持副本集（Replica Set），通过多节点复制实现自动故障转移和数据冗余。
- **水平扩展**：支持分片集群（Sharded Cluster），可通过添加分片节点线性扩展存储容量和处理能力。
- **强大查询能力**：支持丰富的查询操作，包括聚合管道、地理空间查询、文本搜索等。
- **索引支持**：提供多种索引类型（单字段、复合、地理空间、文本索引等），优化查询性能。
- **事务支持**：支持多文档事务（4.0+），确保数据一致性。


## 3. 使用场景和适用范围

### 适用场景
- **Web 应用后端**：适合存储用户数据、会话信息、内容管理系统数据等。
- **大数据处理**：作为数据湖或中间存储，处理非结构化/半结构化数据。
- **实时分析**：支持高写入吞吐量，适合实时日志收集、事件跟踪等场景。
- **移动应用后端**：灵活的数据模型适配移动端数据需求变化。
- **内容管理系统**：存储文章、评论、媒体元数据等复杂结构内容。

### 不适用场景
- 需要强事务一致性和复杂 joins 的传统关系型数据场景（如金融交易核心系统）。
- 高度结构化且字段固定的OLTP场景（更适合关系型数据库）。


## 4. 详细的使用方法和配置说明

### 4.1 支持的标签

#### Simple Tags
- `8.0.15-noble`, `8.0-noble`, `8-noble`, `noble`（基于 Ubuntu Noble）
- `7.0.25-jammy`, `7.0-jammy`, `7-jammy`（基于 Ubuntu Jammy）
- `6.0.26-jammy`, `6.0-jammy`, `6-jammy`（基于 Ubuntu Jammy）

#### Shared Tags
- `8.0.15`, `8.0`, `8`, `latest` → 对应 `8.0.15-noble`
- `7.0.25`, `7.0`, `7` → 对应 `7.0.25-jammy`
- `6.0.26`, `6.0`, `6` → 对应 `6.0.26-jammy`


### 4.2 启动 MongoDB 实例

#### 基础启动命令
```bash
docker run --name some-mongo -d docker.xuanyuan.run/arm64v8/mongo:tag
```
- `some-mongo`：容器名称（自定义）。
- `tag`：指定 MongoDB 版本标签（如 `8.0-noble`，见 4.1 节）。
- 容器默认监听 MongoDB 标准端口 `27017`。


### 4.3 从其他容器连接 MongoDB

#### 同一网络内连接
1. 创建自定义网络（可选）：
   ```bash
   docker network create some-network
   ```
2. 启动 MongoDB 容器并加入网络：
   ```bash
   docker run --name some-mongo --network some-network -d docker.xuanyuan.run/arm64v8/mongo:tag
   ```
3. 使用 `mongosh`（6.0+）或 `mongo`（4.x）客户端连接：
   ```bash
   docker run -it --rm --network some-network docker.xuanyuan.run/arm64v8/mongo \
     mongosh --host some-mongo test  # "test" 为目标数据库名
   ```


### 4.4 使用 Docker Compose 部署

#### 示例 `compose.yaml`
```yaml
services:
  mongo:
    image: docker.xuanyuan.run/arm64v8/mongo:8.0-noble
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root  # 初始化 root 用户
      MONGO_INITDB_ROOT_PASSWORD: example  # root 用户密码
    volumes:
      - mongo-data:/data/db  # 挂载数据卷持久化数据

  mongo-express:  # 可选：MongoDB 管理界面
    image: docker.xuanyuan.run/mongo-express
    restart: always
    ports:
      - "8081:8081"  # 暴露管理界面端口
    environment:
      ME_CONFIG_MONGODB_URL: "mongodb://root:example@mongo:27017/"  # 连接 MongoDB
      ME_CONFIG_BASICAUTH_ENABLED: "true"  # 启用基础认证
      ME_CONFIG_BASICAUTH_USERNAME: admin  # 管理界面用户名
      ME_CONFIG_BASICAUTH_PASSWORD: admin123  # 管理界面密码
    depends_on:
      - mongo

volumes:
  mongo-data:  # 定义命名卷存储 MongoDB 数据
```

#### 启动命令
```bash
docker compose up -d  # 后台启动服务
```
访问 `http://localhost:8081` 即可打开 mongo-express 管理界面。


### 4.5 容器操作

#### 进入容器 Shell
```bash
docker exec -it some-mongo bash  # "some-mongo" 为容器名称
```

#### 查看 MongoDB 日志
```bash
docker logs some-mongo  # 实时日志
docker logs -f some-mongo  # 跟踪日志输出
```


### 4.6 配置说明

#### 4.6.1 自定义配置

##### 方法 1：通过命令行参数
MongoDB 支持通过 `mongod` 命令行参数自定义配置，镜像入口点会将参数传递给 `mongod`。例如启用查询分析器：
```bash
docker run --name some-mongo -d docker.xuanyuan.run/arm64v8/mongo:tag --profile 1 # 分析所有查询
```

##### 方法 2：使用自定义配置文件
1. 本地创建配置文件（如 `/my/custom/mongod.conf`），示例内容：
   ```yaml
   storage:
     dbPath: /data/db
     journal:
       enabled: true
   net:
     port: 27017
     bindIp: 0.0.0.0
   security:
     authorization: enabled
   ```
2. 挂载配置文件并启动容器：
   ```bash
   docker run --name some-mongo -v /my/custom:/etc/mongo -d docker.xuanyuan.run/arm64v8/mongo:tag \
     --config /etc/mongo/mongod.conf  # 指定配置文件路径
   ```


#### 4.6.2 环境变量

| 变量名                          | 作用                                                                 | 是否必需 |
|---------------------------------|----------------------------------------------------------------------|----------|
| `MONGO_INITDB_ROOT_USERNAME`    | 初始化 root 用户的用户名（仅首次启动时生效）                          | 与密码配对必填 |
| `MONGO_INITDB_ROOT_PASSWORD`    | 初始化 root 用户的密码（仅首次启动时生效）                            | 与用户名配对必填 |
| `MONGO_INITDB_DATABASE`         | 指定初始化脚本（`/docker-entrypoint-initdb.d/*.js`）的目标数据库名称 | 可选     |

##### 示例：启用认证并创建 root 用户
```bash
docker run -d --name some-mongo \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  docker.xuanyuan.run/arm64v8/mongo:tag
```
连接到数据库（需认证）：
```bash
docker run -it --rm docker.xuanyuan.run/arm64v8/mongo:tag \
  mongosh --host some-mongo \
    -u mongoadmin \
    -p secret \
    --authenticationDatabase admin  # root 用户认证数据库为 "admin"
```


#### 4.6.3 Docker Secrets
支持通过文件注入敏感信息（如密码），需在环境变量后添加 `_FILE` 后缀。例如：
```bash
docker run --name some-mongo -d \
  -e MONGO_INITDB_ROOT_USERNAME_FILE=/run/secrets/mongo-user \  # 从文件读取用户名
  -e MONGO_INITDB_ROOT_PASSWORD_FILE=/run/secrets/mongo-pass \  # 从文件读取密码
  --secret mongo-user \  # 挂载 Docker Secret（需提前创建）
  --secret mongo-pass \
  arm64v8/mongo:tag
```


#### 4.6.4 初始化新实例
首次启动容器时，可通过 `/docker-entrypoint-initdb.d` 目录执行初始化脚本（`.js` 或 `.sh` 文件，按字母顺序执行）：
1. 创建初始化脚本（如 `init.js`）：
   ```javascript
   // 创建数据库 "mydb" 及用户 "myuser"
   db = db.getSiblingDB('mydb');
   db.createUser({
     user: 'myuser',
     pwd: 'mypassword',
     roles: [{ role: 'readWrite', db: 'mydb' }]
   });
   // 插入测试数据
   db.mycollection.insertOne({ name: 'test' });
   ```
2. 挂载脚本目录并启动容器：
   ```bash
   docker run --name some-mongo -v /path/to/init-scripts:/docker-entrypoint-initdb.d -d docker.xuanyuan.run/arm64v8/mongo:tag
   ```


### 4.7 注意事项

#### 数据存储
MongoDB 默认将数据存储在容器内的 `/data/db` 目录，为避免数据丢失，建议通过以下方式持久化数据：

##### 方法 1：使用 Docker 命名卷（推荐）
```bash
docker run --name some-mongo -v mongo-data:/data/db -d docker.xuanyuan.run/arm64v8/mongo:tag
```
（`mongo-data` 为命名卷，由 Docker 管理存储路径）

##### 方法 2：绑定主机目录（不推荐 Windows/OS X）
```bash
docker run --name some-mongo -v /host/path/to/data:/data/db -d docker.xuanyuan.run/arm64v8/mongo:tag
```
> **警告**：Windows 和 OS X 系统中，绑定挂载的目录可能因文件系统兼容性问题导致 MongoDB 性能下降或崩溃，建议使用命名卷。


#### 创建数据库备份
使用 `mongodump` 工具备份数据（需进入容器或通过网络连接）：
```bash
# 从容器内备份到主机
docker exec some-mongo sh -c 'exec mongodump -d mydb --archive' > /host/backup/mydb.archive
```


## 5. 许可证信息

MongoDB 软件的许可证遵循 [Server Side Public License (SSPL) v1](https://www.mongodb.com/licensing/server-side-public-license)（2018 年 10 月 16 日后版本）及 [Apache License](https://en.wikipedia.org/wiki/Apache_License)（旧版本）。镜像中包含的其他软件（如基础系统组件、Bash 等）可能遵循不同许可证，用户需自行确保使用合规性。详细信息可参考 [MongoDB 许可证说明](https://github.com/mongodb/mongo/blob/6ea81c883e7297be99884185c908c7ece385caf8/README#L89-L95) 及 [镜像元数据仓库](https://github.com/docker-library/repo-info/tree/master/repos/mongo)。
