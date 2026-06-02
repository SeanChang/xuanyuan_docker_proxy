---
image: library/mongo
description: "MongoDB是一种文档型数据库，具备高可用性和易扩展性，它采用灵活的文档模型（以BSON格式存储数据，类似JSON），能够高效处理非结构化和半结构化数据，通过副本集机制保障数据的高可用性，同时支持分片集群实现水平扩展，可轻松应对数据量和访问量的增长，适用于各类需要灵活存储和弹性扩展的应用场景。"
source: https://xuanyuan.cloud/zh/r/library/mongo
canonical: https://xuanyuan.cloud/zh/r/library/mongo
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/mongo" title="library/mongo Docker 镜像中文简介、标签列表与拉取命令">library/mongo — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/mongo" title="library/mongo Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/mongo</a>

# MongoDB Docker 镜像使用指南


## 快速参考

### 维护方  
[Docker 社区]([])

### 获取帮助渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应 Dockerfile 链接  

（关于 "Shared" 和 "Simple" 标签的区别，参见 [FAQ]([])。）


### Simple Tags  
- `8.0.15-noble`、`8.0-noble`、`8-noble`、`noble`  
  [Dockerfile]([])  

- `8.0.15-windowsservercore-ltsc2025`、`8.0-windowsservercore-ltsc2025`、`8-windowsservercore-ltsc2025`、`windowsservercore-ltsc2025`  
  [Dockerfile]([])  

- `8.0.15-windowsservercore-ltsc2022`、`8.0-windowsservercore-ltsc2022`、`8-windowsservercore-ltsc2022`、`windowsservercore-ltsc2022`  
  [Dockerfile]([])  

- `8.0.15-nanoserver-ltsc2022`、`8.0-nanoserver-ltsc2022`、`8-nanoserver-ltsc2022`、`nanoserver-ltsc2022`  
  [Dockerfile]([])  

- `7.0.25-jammy`、`7.0-jammy`、`7-jammy`  
  [Dockerfile]([])  

- `7.0.25-windowsservercore-ltsc2025`、`7.0-windowsservercore-ltsc2025`、`7-windowsservercore-ltsc2025`  
  [Dockerfile]([])  

- `7.0.25-windowsservercore-ltsc2022`、`7.0-windowsservercore-ltsc2022`、`7-windowsservercore-ltsc2022`  
  [Dockerfile]([])  

- `7.0.25-nanoserver-ltsc2022`、`7.0-nanoserver-ltsc2022`、`7-nanoserver-ltsc2022`  
  [Dockerfile]([])  

- `6.0.26-jammy`、`6.0-jammy`、`6-jammy`  
  [Dockerfile]([])  

- `6.0.26-windowsservercore-ltsc2025`、`6.0-windowsservercore-ltsc2025`、`6-windowsservercore-ltsc2025`  
  [Dockerfile]([])  

- `6.0.26-windowsservercore-ltsc2022`、`6.0-windowsservercore-ltsc2022`、`6-windowsservercore-ltsc2022`  
  [Dockerfile]([])  

- `6.0.26-nanoserver-ltsc2022`、`6.0-nanoserver-ltsc2022`、`6-nanoserver-ltsc2022`  
  [Dockerfile]([])  


### Shared Tags  
- `8.0.15`、`8.0`、`8`、`latest`  
  - `8.0.15-noble`（[Dockerfile]([])）  
  - `8.0.15-windowsservercore-ltsc2025`（[Dockerfile]([])）  
  - `8.0.15-windowsservercore-ltsc2022`（[Dockerfile]([])）  

- `8.0.15-windowsservercore`、`8.0-windowsservercore`、`8-windowsservercore`、`windowsservercore`  
  - `8.0.15-windowsservercore-ltsc2025`（[Dockerfile]([])）  
  - `8.0.15-windowsservercore-ltsc2022`（[Dockerfile]([])）  

- `8.0.15-nanoserver`、`8.0-nanoserver`、`8-nanoserver`、`nanoserver`  
  - `8.0.15-nanoserver-ltsc2022`（[Dockerfile]([])）  

（其他版本的 Shared Tags 结构类似，完整列表见原文链接）  


## 快速参考（续）  

- **问题反馈地址**：[[]]([])  
- **支持的架构**：`amd64`、`arm64v8`、`windows-amd64`（[更多信息]([])）  
- **镜像 artifact 详情**：[repo-info 仓库的 `repos/mongo/` 目录]([])（含镜像元数据、传输大小等）  
- **镜像更新**：[official-images 仓库的 `library/mongo` 标签]([])  
- **本文档来源**：[docs 仓库的 `mongo/` 目录]([])  


## 什么是 MongoDB？  

MongoDB 是一款免费开源的跨平台文档型数据库，属于 NoSQL 数据库范畴，使用类 JSON 格式的文档存储数据（支持模式定义）。由 MongoDB Inc. 开发，基于 Server Side Public License（SSPL）和 Apache License 双重许可发布。  

最初由 10gen 公司（现 MongoDB Inc.）于 2007 年 10 月开发，作为平台即服务（PaaS）产品的组件，2009 年转向开源开发模式，提供商业支持和服务。目前已被 MetLife、巴克莱、ADP、UPS、维亚康姆、纽约时报等众多机构采用，是最流行的 NoSQL 数据库之一。  


## 安全提示  

MongoDB 默认配置无需认证即可访问，包括管理员用户。若计划将实例暴露到公网，**强烈建议设置 root 用户名和密码**。具体方法见下文“环境变量”部分，或参考 [MongoDB 安全文档]([])。  


## 如何使用此镜像  


### 启动 MongoDB 服务实例  

```bash
$ docker run --name some-mongo -d mongo:tag
```  
- `some-mongo`：自定义容器名称  
- `tag`：指定 MongoDB 版本标签（如 `8.0-noble`，见“支持的标签”）  


### 从其他容器连接 MongoDB  

MongoDB 默认监听 27017 端口，可通过 Docker 网络连接。示例：启动另一个容器，使用 `mongosh`（4.x 版本用 `mongo`）连接到上述 `some-mongo` 实例：  

```bash
$ docker run -it --network some-network --rm mongo mongosh --host some-mongo test
```  
- `--network some-network`：确保两个容器在同一网络（若未指定网络，需先用 `docker network create some-network` 创建）  


### 使用 docker compose  

示例 `compose.yaml` 文件：  

```yaml
services:
  mongo:
    image: mongo
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root  # 初始化 root 用户名
      MONGO_INITDB_ROOT_PASSWORD: example  # 初始化 root 密码

  mongo-express:  # 可选的 Web 管理界面
    image: mongo-express
    restart: always
    ports:
      - 8081:8081  # 映射到主机 8081 端口
    environment:
      ME_CONFIG_MONGODB_URL: mongodb://root:example@mongo:27017/  # 连接 mongo 服务
      ME_CONFIG_BASICAUTH_ENABLED: true  # 启用基础认证
      ME_CONFIG_BASICAUTH_USERNAME: mongoexpressuser  # Web 界面用户名
      ME_CONFIG_BASICAUTH_PASSWORD: mongoexpresspass  # Web 界面密码
```  

启动服务：  
```bash
$ docker compose up
```  
访问 `[] 打开管理界面。  


### 容器 Shell 访问与日志查看  

#### 进入容器 Shell  
```bash
$ docker exec -it some-mongo bash
```  

#### 查看 MongoDB 日志  
```bash
$ docker logs some-mongo
```  


## 配置  


### 无配置文件自定义参数  

多数 MongoDB 配置可通过 `mongod` 命令行参数设置，镜像入口会将参数传递给 `mongod`。示例：启用查询分析器  

```bash
$ docker run --name some-mongo -d mongo --profile 1
```  

或在 `compose.yaml` 中指定：  
```yaml
services:
  mongo:
    image: mongo
    command: --profile 1  # 自定义参数
```  


### 使用自定义配置文件  

创建配置文件（如 `/my/custom/mongod.conf`），通过挂载和 `--config` 参数指定：  

```bash
$ docker run --name some-mongo -v /my/custom:/etc/mongo -d mongo --config /etc/mongo/mongod.conf
```  
- `/my/custom`：主机配置文件目录  
- `/etc/mongo`：容器内挂载路径  


### 环境变量  

容器首次启动且数据目录为空时，可通过环境变量初始化配置（数据目录非空时无效）。  

#### `MONGO_INITDB_ROOT_USERNAME` 和 `MONGO_INITDB_ROOT_PASSWORD`  
创建管理员用户（`admin` 数据库，`root` 角色），并启用认证（`mongod --auth`）。示例：  

```bash
# 启动带认证的 MongoDB
$ docker run -d --network some-network --name some-mongo \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  mongo

# 连接到实例
$ docker run -it --rm --network some-network mongo \
  mongosh --host some-mongo -u mongoadmin -p secret --authenticationDatabase admin some-db
> db.getName();  # 输出 "some-db"
```  


#### `MONGO_INITDB_DATABASE`  
指定 `/docker-entrypoint-initdb.d/` 目录下初始化脚本（`.js`/`.sh`）的默认数据库（未指定则为 `test`）。  


### Docker Secrets  

支持从文件加载敏感信息（如密码），只需在环境变量后加 `_FILE`。示例：  

```bash
$ docker run --name some-mongo -e MONGO_INITDB_ROOT_PASSWORD_FILE=/run/secrets/mongo-root -d mongo
```  
- `/run/secrets/mongo-root`：容器内存储密码的文件路径  


## 初始化新实例  

容器首次启动时，会按字母顺序执行 `/docker-entrypoint-initdb.d/` 目录下的 `.sh` 和 `.js` 文件。`.js` 文件通过 `mongosh` 执行，默认数据库由 `MONGO_INITDB_DATABASE` 指定。  


## 注意事项  


### 数据存储位置  

#### 推荐方案：挂载主机目录  
1. 主机创建目录（如 `/my/own/datadir`）  
2. 启动容器时挂载：  
```bash
$ docker run --name some-mongo -v /my/own/datadir:/data/db -d mongo
```  
- `/data/db`：MongoDB 默认数据目录  


#### Windows 和 OS X 注意事项  
Linux 镜像的内存映射文件与宿主文件系统不兼容，无法直接挂载数据目录。建议使用**命名卷**：  
```bash
$ docker volume create mongo-data  # 创建命名卷
$ docker run --name some-mongo -v mongo-data:/data/db -d mongo  # 挂载卷
```  


### 创建数据库备份  

通过 `docker exec` 在容器内执行 `mongodump`：  

```bash
$ docker exec some-mongo sh -c 'exec mongodump -d <database_name> --archive' > /host/path/backup.archive
```  
- `<database_name>`：需备份的数据库名  
- `/host/path/backup.archive`：主机
