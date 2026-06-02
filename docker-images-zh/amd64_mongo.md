<!-- xuanyuan-docker-images-zh
image: amd64/mongo
source: https://xuanyuan.cloud/zh/r/amd64/mongo
canonical: https://xuanyuan.cloud/zh/r/amd64/mongo
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/amd64/mongo" title="amd64/mongo Docker 镜像中文简介、标签列表与拉取命令">amd64/mongo — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/amd64/mongo" title="amd64/mongo Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/amd64/mongo</a></p>

# MongoDB 镜像文档

## 镜像概述和主要用途

MongoDB 是一个开源的跨平台文档型数据库程序，属于 NoSQL 数据库类别。它使用类 JSON 文档（BSON）存储数据，支持动态模式，无需预先定义表结构。MongoDB 由 MongoDB Inc. 开发，发布于 Server Side Public License (SSPL) 和 Apache License 许可下。其核心优势在于提供高可用性和轻松扩展性，适用于需要灵活数据模型和大规模数据存储的应用场景。


## 核心功能和特性

- **文档型数据模型**：使用 BSON（类 JSON）格式存储数据，支持嵌套文档和数组，适合表示复杂数据结构
- **无模式设计**：集合（Collection）中的文档无需遵循统一结构，支持动态字段扩展
- **高可用性**：通过副本集（Replica Sets）实现自动故障转移和数据冗余
- **水平扩展**：支持分片（Sharding）以分布式方式存储海量数据，提高查询性能
- **强大的查询能力**：支持复杂查询、聚合管道、地理空间查询和全文搜索
- **索引支持**：提供多种索引类型（单字段、复合、地理空间、文本索引等），优化查询效率
- **事务支持**：支持多文档事务，确保数据一致性


## 使用场景和适用范围

MongoDB 适用于以下场景：

- **灵活模式需求的应用**：如内容管理系统、博客平台，需频繁调整数据结构
- **大数据量存储与高吞吐量**：日志存储、物联网数据采集、用户行为分析
- **高可用性要求的系统**：金融交易记录、电商订单系统，需避免单点故障
- **敏捷开发项目**：快速迭代的应用，需动态适应业务需求变化
- **移动应用后端**：支持跨平台数据同步和离线数据访问


# 支持的标签及 Dockerfile 链接

## 简单标签（Simple Tags）

- `8.0.15-noble`, `8.0-noble`, `8-noble`, `noble`  
  [Dockerfile](https://github.com/docker-library/mongo/blob/12330e190aa0ba8cfd07004a7a74791b270a3206/8.0/Dockerfile)

- `7.0.25-jammy`, `7.0-jammy`, `7-jammy`  
  [Dockerfile](https://github.com/docker-library/mongo/blob/12330e190aa0ba8cfd07004a7a74791b270a3206/7.0/Dockerfile)

- `6.0.26-jammy`, `6.0-jammy`, `6-jammy`  
  [Dockerfile](https://github.com/docker-library/mongo/blob/d9efcb7f46c4a17da2fdc9dbb4ef644f4f92053d/6.0/Dockerfile)

## 共享标签（Shared Tags）

- `8.0.15`, `8.0`, `8`, `latest`  
  对应基础镜像：`8.0.15-noble`

- `7.0.25`, `7.0`, `7`  
  对应基础镜像：`7.0.25-jammy`

- `6.0.26`, `6.0`, `6`  
  对应基础镜像：`6.0.26-jammy`


# 使用方法

## 启动 MongoDB 服务实例

使用 `docker run` 命令启动一个 MongoDB 容器：

```console
$ docker run --name some-mongo -d amd64/mongo:tag
```

- `some-mongo`：自定义容器名称
- `tag`：指定 MongoDB 版本标签（如 `8.0.15-noble`，完整标签列表见上文）


## 从其他 Docker 容器连接 MongoDB

MongoDB 默认监听 27017 端口，可通过 Docker 网络实现容器间通信。示例：启动客户端容器连接到已运行的 MongoDB 实例：

```console
$ docker run -it --network some-network --rm amd64/mongo mongosh --host some-mongo test
```

- `some-network`：Docker 网络名称（需提前创建或使用默认网络）
- `some-mongo`：目标 MongoDB 容器名称
- `test`：连接的数据库名称


## 使用 docker-compose 部署

以下是 `compose.yaml` 配置示例，包含 MongoDB 服务和管理界面（mongo-express）：

```yaml
services:
  mongo:
    image: amd64/mongo:8.0.15-noble  # 指定版本标签
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root  # 初始化 root 用户
      MONGO_INITDB_ROOT_PASSWORD: example  # root 用户密码
    volumes:
      - mongo-data:/data/db  # 持久化数据存储

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - "8081:8081"  # 暴露管理界面端口
    environment:
      ME_CONFIG_MONGODB_URL: mongodb://root:example@mongo:27017/  # 连接 MongoDB 的 URL
      ME_CONFIG_BASICAUTH_ENABLED: "true"  # 启用基础认证
      ME_CONFIG_BASICAUTH_USERNAME: mongoexpressuser  # 管理界面用户名
      ME_CONFIG_BASICAUTH_PASSWORD: mongoexpresspass  # 管理界面密码
    depends_on:
      - mongo  # 依赖 MongoDB 服务

volumes:
  mongo-data:  # 定义命名卷，用于持久化 MongoDB 数据
```

启动服务：

```console
$ docker compose up -d
```

访问管理界面：`http://localhost:8081`


## 容器 Shell 访问与日志查看

### 进入容器 Shell

使用 `docker exec` 命令获取容器内 bash 终端：

```console
$ docker exec -it some-mongo bash
```

### 查看 MongoDB 日志

通过 Docker 容器日志查看 MongoDB 服务输出：

```console
$ docker logs some-mongo
```


# 配置说明

## 自定义配置（无配置文件）

可通过命令行参数直接传递 `mongod` 配置项。示例：启用查询分析器（profiler）：

```console
$ docker run --name some-mongo -d amd64/mongo --profile 1
```

在 `docker-compose` 中配置：

```yaml
services:
  mongo:
    image: amd64/mongo
    command: --profile 1  # 传递 mongod 参数
```

查看所有支持的参数：

```console
$ docker run -it --rm amd64/mongo --help
```


## 使用自定义配置文件

若需复杂配置，可挂载自定义 `mongod.conf` 文件：

1. 准备配置文件（如 `/my/custom/mongod.conf`）：
   ```ini
   storage:
     dbPath: /data/db
     journal:
       enabled: true
   net:
     port: 27017
     bindIp: 0.0.0.0
   ```

2. 启动容器时挂载配置文件：

```console
$ docker run --name some-mongo -v /my/custom:/etc/mongo -d amd64/mongo --config /etc/mongo/mongod.conf
```

- `-v /my/custom:/etc/mongo`：将主机目录 `/my/custom` 挂载到容器内 `/etc/mongo`
- `--config /etc/mongo/mongod.conf`：指定配置文件路径


## 环境变量

容器启动时可通过环境变量初始化 MongoDB 实例（仅首次启动且数据目录为空时生效）：

### `MONGO_INITDB_ROOT_USERNAME` 与 `MONGO_INITDB_ROOT_PASSWORD`

- **作用**：创建 root 用户（超级管理员），授予 `root` 角色（权限覆盖所有数据库）
- **必需**：两者需同时设置，否则不创建用户
- **示例**：

```console
$ docker run -d --name some-mongo \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  amd64/mongo
```

使用 `mongosh` 连接：

```console
$ docker run -it --rm amd64/mongo mongosh --host some-mongo -u mongoadmin -p secret --authenticationDatabase admin
```


### `MONGO_INITDB_DATABASE`

- **作用**：指定初始化脚本（`.js` 文件）的默认数据库
- **默认值**：`test`
- **示例**：若设置 `MONGO_INITDB_DATABASE=appdb`，则 `/docker-entrypoint-initdb.d/*.js` 脚本默认在 `appdb` 数据库上下文执行


### Docker Secrets 支持

可通过文件注入敏感信息（如密码），环境变量名后添加 `_FILE` 后缀，值为容器内文件路径。示例：

```console
$ docker run --name some-mongo \
  -e MONGO_INITDB_ROOT_PASSWORD_FILE=/run/secrets/mongo-root-password \
  -v /host/secrets:/run/secrets \
  amd64/mongo
```

- `/host/secrets/mongo-root-password`：主机上存储密码的文件


## 初始化新实例

容器首次启动时，`/docker-entrypoint-initdb.d` 目录下的 `.sh` 和 `.js` 文件会按字母顺序执行，用于初始化数据库（如创建用户、插入数据）。

### 示例：初始化脚本

1. 创建 `init.js` 文件：

```javascript
// 创建普通用户并授权
db.createUser({
  user: "appuser",
  pwd: "apppass",
  roles: [{ role: "readWrite", db: "appdb" }]
});

// 插入测试数据
db.appdb.insertOne({ name: "Initial Data", value: "Hello MongoDB" });
```

2. 启动容器时挂载脚本：

```console
$ docker run --name some-mongo -v /host/init-scripts:/docker-entrypoint-initdb.d -d amd64/mongo
```

- `/host/init-scripts`：主机上存放初始化脚本的目录


# 注意事项

## 数据存储位置

MongoDB 数据默认存储在容器内 `/data/db` 目录，建议通过以下方式持久化数据：

### 使用 Docker 卷（推荐）

```console
$ docker run --name some-mongo -v mongo-data:/data/db -d amd64/mongo
```

- `mongo-data`：命名卷，由 Docker 管理，数据持久化于主机 `/var/lib/docker/volumes/` 目录


### 绑定主机目录

```console
$ docker run --name some-mongo -v /host/data:/data/db -d amd64/mongo
```

- **警告（Windows/OS X）**：MongoDB 使用内存映射文件，绑定主机目录可能导致性能问题或兼容性错误（如 `SERVER-8600` 问题），建议使用 Docker 卷替代。


## 创建数据库备份

使用 `mongodump` 工具导出数据，示例：

```console
$ docker exec some-mongo sh -c 'exec mongodump -d appdb --archive' > /host/backups/appdb.archive
```

- `appdb`：需备份的数据库名称
- `/host/backups/appdb.archive`：主机上的备份文件路径


# 许可证信息

MongoDB 软件许可遵循 [Server Side Public License (SSPL) v1](https://www.mongodb.com/licensing/server-side-public-license) 和 Apache License。注意：2018 年 10 月 16 日之后的版本从 AGPL 变更为 SSPLv1。

镜像中包含的其他软件（如基础系统组件、Bash 等）可能遵循不同许可证，详细信息见 [repo-info 仓库](https://github.com/docker-library/repo-info/tree/master/repos/mongo)。

使用本镜像需确保符合所有包含软件的许可证要求。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/amd64/mongo" title="amd64/mongo Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/amd64/mongo</a></p>
