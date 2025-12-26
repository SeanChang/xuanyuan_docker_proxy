---
id: 10
title: 基于 Docker 的 MongoDB 部署与使用指南
slug: docker-mongodb
summary: 本文介绍MongoDB的定义与适用场景，详述Docker环境下的准备工作、单节点快速部署、Docker Compose配置、初始化脚本编写、数据持久化方案、备份恢复方法，还提供副本集搭建示例、生产环境要点及常见问题排查，附官方与权威参考资源。
category: Docker,MongoDB
tags: MongoDB,docker,部署教程
image_name: library/mongo
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-mangodb.png"
status: published
created_at: "2025-10-04 08:28:06"
updated_at: "2025-10-16 01:48:06"
---

# 基于 Docker 的 MongoDB 部署与使用指南

> 本文介绍MongoDB的定义与适用场景，详述Docker环境下的准备工作、单节点快速部署、Docker Compose配置、初始化脚本编写、数据持久化方案、备份恢复方法，还提供副本集搭建示例、生产环境要点及常见问题排查，附官方与权威参考资源。

## 1. MongoDB 简介
MongoDB 是**面向文档的 NoSQL 数据库**，以 BSON（类 JSON 格式）存储数据，兼顾灵活性与性能，适合不同技术栈用户：

### 核心特点
- **灵活数据模型**：无固定表结构，支持半结构化数据，适合快速迭代（如创业项目、需求频繁变更场景）。  
- **高性能与扩展性**：支持分片（Sharding）、水平扩展，可应对 TB 级数据（生产大规模场景）。  
- **高可用保障**：副本集（多节点备份）自动故障转移，避免单点故障（生产核心需求）。  
- **丰富生态**：支持事务、全文搜索、地理空间索引、聚合分析（满足复杂业务场景）。

### 典型应用场景
| 场景类型               | 示例                     | 适用用户       |
|------------------------|--------------------------|----------------|
| 基础后端存储           | 网站用户数据、APP配置    | 新手（练手）   |
| 实时数据处理           | 日志存储、IoT设备数据    | 中级开发者     |
| 复杂业务系统           | CMS内容管理、AI数据文档  | 高级工程师     |

### 官方资源
- 国内镜像：[https://xuanyuan.cloud/r/library/mongo](https://xuanyuan.cloud/r/library/mongo)  
- 官方文档：[MongoDB 官方手册](https://www.mongodb.com/docs/manual/)  


## 2. 部署前准备
新手需严格核对环境，避免后续报错；高级用户可重点关注生产级配置。

### 2.1 硬件要求
| 资源类型 | 开发环境（新手练手） | 生产环境（业务使用） | 说明                     |
|----------|----------------------|----------------------|--------------------------|
| CPU      | ≥ 2 核               | ≥ 4 核               | 生产需应对并发，避免卡顿 |
| 内存     | ≥ 4 GB               | ≥ 16 GB              | MongoDB 内存占用较高，生产需预留 |
| 硬盘     | ≥ 20 GB（SSD/HDD）   | ≥ 100 GB（建议 SSD） | 生产用 SSD 提升 IO 性能  |

### 2.2 软件依赖（必装）
- **Docker**：≥ 24.0.0（新手需先安装 Docker，参考 [Docker 一键安装脚本](https://xuanyuan.cloud/install/linux)）  
  检查版本：`docker --version`（输出如 `Docker version 26.0.0, build 2ae903e` 即合格）  
- **Docker Compose**：≥ v2.26.1（部分 Docker 已内置，无需单独安装）  
  检查版本：`docker compose version`（输出如 `Docker Compose version v2.27.0` 即合格）

- 一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

### 2.3 网络与安全基础
- 端口：MongoDB 默认端口 **27017**（新手需注意：开发环境可临时开放本地端口，生产环境严禁公网暴露！）  
- 镜像访问支持：国内用户需配置 Docker 镜像访问支持（推荐用轩辕镜像，直接拉取加速镜像即可）。

---

## 3. MongoDB 镜像下载
推荐用**轩辕镜像**（避免国外网络超时），步骤均已简化。

### 3.1 方式1：使用轩辕镜像
```bash
# 拉取 6.0 版本（稳定版，适合开发/生产）
docker pull docker.xuanyuan.run/library/mongo:6.0

# （可选）将镜像改名为官方标准名称
docker tag docker.xuanyuan.run/library/mongo:6.0 mongo:6.0
# 删除临时镜像标签，释放空间
docker rmi docker.xuanyuan.run/library/mongo:6.0
```

### 3.2 方式2：使用官方镜像
```bash
# 直接拉取 Docker Hub 官方镜像
docker pull mongo:6.0
```

### 3.3 验证镜像是否下载成功（新手必做）
执行命令 `docker images`，若输出如下内容，说明镜像下载成功：
```
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
mongo        6.0       d3ad5c1a1b22   5 days ago     700MB
```


## 4. 快速上手：单节点部署
单节点适合开发、测试场景，提供两种部署方式：`docker run`（快速启动）和 `Docker Compose`（推荐，便于后续维护）。

### 4.1 方式1：docker run 快速启动
```bash
docker run -d \
  --name mongo-dev \          # 容器名称（自定义，如 mongo-test）
  -e MONGO_INITDB_ROOT_USERNAME=admin \  # 初始化 root 用户名（必填，避免无密码风险）
  -e MONGO_INITDB_ROOT_PASSWORD=YourStrongPwd2024! \  # 密码（新手务必改强密码！）
  -v mongo-data:/data/db \    # 持久化数据（用 Docker named volume，避免权限问题）
  -p 27017:27017 \            # 端口映射（宿主机:容器，开发可映射，生产建议不映射公网）
  --restart unless-stopped \  # 容器异常时自动重启（开发/生产均推荐）
  mongo:6.0                   # 镜像名称:版本
```

#### 关键参数解释
- `-e`：设置环境变量，`MONGO_INITDB_*` 仅**首次启动**时生效（初始化 root 用户）。  
- `-v mongo-data:/data/db`：用 `named volume` 持久化数据（比直接挂载宿主目录更安全，新手无需处理权限）。  
- `--restart unless-stopped`：避免容器意外退出后数据丢失（开发环境也建议开启）。

### 4.2 方式2：Docker Compose 部署（推荐，便于维护）
#### 步骤1：创建 docker-compose.yml 文件（可直接复制）
```yaml
version: "3.8"  # 兼容主流 Docker Compose 版本
services:
  mongo:
    image: mongo:6.0  # 镜像名称
    container_name: mongo-dev  # 容器名称
    environment:
      # 初始化 root 用户（必设，替换为你的强密码）
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=YourStrongPwd2024!
      - MONGO_INITDB_DATABASE=myappdb  # 预创建业务数据库（可选，避免后续手动建）
    volumes:
      - mongo-data:/data/db  # 持久化数据（named volume）
      # - ./initdb:/docker-entrypoint-initdb.d:ro  # 初始化脚本挂载（后续章节用，当前可注释）
    ports:
      - "27017:27017"  # 端口映射（生产环境建议删除这行，不暴露公网）
    restart: unless-stopped  # 自动重启

# 声明 named volume（无需手动创建，Docker 会自动初始化）
volumes:
  mongo-data:
```

#### 步骤2：启动容器
```bash
# 在 docker-compose.yml 所在目录执行
docker compose up -d
```

### 4.3 验证部署是否成功
#### 步骤1：查看容器状态
```bash
docker ps | grep mongo-dev
```
若输出包含 `Up`（如 `Up 5 minutes`），说明容器正常运行。

#### 步骤2：连接 MongoDB 测试（两种方式）
- **方式A：本地安装 mongosh 连接**（适合有 mongosh 的用户）：
  ```bash
  mongosh "mongodb://admin:YourStrongPwd2024!@localhost:27017/admin"
  ```
  成功后会进入 `mongosh` 交互界面（显示 `admin> ` 提示符）。

- **方式B：容器内连接**（新手推荐，无需安装 mongosh）：
  ```bash
  docker exec -it mongo-dev mongosh -u admin -p YourStrongPwd2024! --authenticationDatabase admin
  ```
  同样进入交互界面，输入 `db.version()` 可查看 MongoDB 版本（验证连接成功）。


## 5. 初始化脚本：自动创建用户与数据库
新手需自动初始化业务用户，高级用户可自定义脚本（如建索引、导入初始数据），脚本仅**首次启动**时执行。

### 5.1 编写初始化脚本（示例：创建业务用户）
#### 步骤1：创建脚本目录与文件
```bash
# 在 docker-compose.yml 所在目录创建 initdb 文件夹
mkdir -p initdb
# 创建初始化脚本（用 vim 或记事本编辑，新手可复制内容）
vim initdb/01-create-app-user.js
```

#### 步骤2：脚本内容（复制到文件中）
```javascript
// 切换到预创建的业务数据库（与 docker-compose.yml 中 MONGO_INITDB_DATABASE 一致）
db = db.getSiblingDB("myappdb");

// 创建业务用户（仅授予 myappdb 的读写权限，遵循最小权限原则）
db.createUser({
  user: "appuser",          // 业务用户名
  pwd: "AppUserPwd2024!",   // 业务用户密码（改强密码）
  roles: [
    { role: "readWrite", db: "myappdb" }  // 权限：仅读写 myappdb
  ]
});

// （可选）创建测试集合与数据
db.testCollection.insertOne({ name: "MongoDB_Init_Test", time: new Date() });
```

### 5.2 挂载脚本并重启（结合 Docker Compose）
#### 步骤1：修改 docker-compose.yml
取消 `volumes` 中初始化脚本挂载的注释：
```yaml
volumes:
  - mongo-data:/data/db
  - ./initdb:/docker-entrypoint-initdb.d:ro  # 挂载脚本目录（ro：只读，安全）
```

#### 步骤2：重启容器（首次执行脚本需删除旧数据卷）
```bash
# 1. 停止并删除旧容器（数据卷需重新初始化，脚本才会执行）
docker compose down -v  # -v：删除 named volume（注意：会清空原有数据！）
# 2. 重新启动，执行脚本
docker compose up -d
```

#### 步骤3：验证脚本是否生效（新手必做）
用业务用户连接测试：
```bash
# 容器内连接（替换为你的业务用户密码）
docker exec -it mongo-dev mongosh -u appuser -p AppUserPwd2024! --authenticationDatabase myappdb
# 查看测试数据（若输出刚才插入的文档，说明脚本生效）
db.testCollection.find();
```


## 6. 备份与恢复（开发/生产必备）
新手需掌握基础备份，高级用户需结合定时任务（如 crontab），推荐用官方工具 `mongodump`/`mongorestore`。

### 6.1 备份数据（导出）
#### 方式1：宿主机直接执行（需安装 mongodump，新手可选）
```bash
# 备份所有数据库到 /backup/2024-05-20 目录（日期自动生成）
mongodump --uri="mongodb://admin:YourStrongPwd2024!@localhost:27017" \
  --out /backup/$(date +%F)
```

#### 方式2：容器内执行（无需安装工具，推荐生产使用）
```bash
# 在容器内创建备份目录，导出到容器的 /tmp/backup 目录
docker exec -it mongo-dev bash -c "
  mkdir -p /tmp/backup && \
  mongodump --uri='mongodb://admin:YourStrongPwd2024!@localhost:27017' \
    --out /tmp/backup/$(date +%F)
"
# （可选）将容器内备份复制到宿主机（避免容器删除后备份丢失）
docker cp mongo-dev:/tmp/backup/$(date +%F) /backup/
```

### 6.2 恢复数据（导入）
```bash
# 从 /backup/2024-05-20 目录恢复（替换为你的备份目录）
mongorestore --uri="mongodb://admin:YourStrongPwd2024!@localhost:27017" \
  /backup/2024-05-20
```

#### 注意事项
- 恢复前建议停止业务服务，避免数据写入冲突。  
- 生产环境需定期测试恢复流程（避免备份文件损坏却未发现）。


## 7. 进阶：副本集（Replica Set）部署（高可用需求）
适合高级工程师，实现**高可用**（故障自动转移）、**读写分离**，生产环境必备。

### 7.1 副本集作用（新手了解）
- 主节点（Primary）：处理写请求，同步数据到从节点。  
- 从节点（Secondary）：处理读请求，主节点故障后自动升级为主节点。  
- 仲裁节点（Arbiter）：仅投票，不存储数据（可选，3节点副本集可不用）。

### 7.2 Docker Compose 部署 3 节点副本集
#### 步骤1：创建 docker-compose-replica.yml
```yaml
version: "3.8"
services:
  # 主节点（初始，后续自动选举）
  mongo1:
    image: mongo:6.0
    container_name: mongo1
    command: ["mongod", "--replSet", "rs0", "--bind_ip_all"]  # --replSet 指定副本集名称 rs0
    ports: ["27017:27017"]
    volumes: ["mongo1-data:/data/db"]
    restart: unless-stopped

  # 从节点1
  mongo2:
    image: mongo:6.0
    container_name: mongo2
    command: ["mongod", "--replSet", "rs0", "--bind_ip_all"]
    ports: ["27018:27017"]
    volumes: ["mongo2-data:/data/db"]
    restart: unless-stopped

  # 从节点2
  mongo3:
    image: mongo:6.0
    container_name: mongo3
    command: ["mongod", "--replSet", "rs0", "--bind_ip_all"]
    ports: ["27019:27017"]
    volumes: ["mongo3-data:/data/db"]
    restart: unless-stopped

volumes:
  mongo1-data:
  mongo2-data:
  mongo3-data:
```

#### 步骤2：启动副本集容器
```bash
docker compose -f docker-compose-replica.yml up -d
```

#### 步骤3：初始化副本集（关键步骤）
```bash
# 进入 mongo1 容器，执行初始化命令
docker exec -it mongo1 mongosh --eval '
  rs.initiate({
    _id: "rs0",  # 副本集名称，需与 command 中 --replSet 一致
    members: [
      { _id: 0, host: "mongo1:27017" },  # 节点1（容器名:端口，内部通信）
      { _id: 1, host: "mongo2:27017" },  # 节点2
      { _id: 2, host: "mongo3:27017" }   # 节点3
    ]
  })
'
```

#### 步骤4：验证副本集状态
```bash
# 进入 mongo1，查看副本集状态
docker exec -it mongo1 mongosh
# 执行命令查看状态（"stateStr" 为 "PRIMARY" 的是主节点，"SECONDARY" 是从节点）
rs.status()
```

### 7.3 生产级副本集优化
1. **开启认证**：用 `keyfile` 实现节点间互信（避免未授权节点加入），参考 [MongoDB 官方密钥配置](https://www.mongodb.com/docs/manual/tutorial/enforce-keyfile-access-control-in-replica-sets/)。  
2. **开启 TLS**：加密节点间通信和客户端连接（生产环境必须，避免数据泄露）。  
3. **读写分离**：客户端连接时指定 `readPreference: "secondaryPreferred"`，将读请求分流到从节点。


## 8. 生产环境核心注意事项
新手可先收藏，后续生产部署时参考；高级用户需严格执行。

1. **安全第一**  
   - 严禁暴露 27017 端口到公网（用内网、VPN 或反向代理访问）。  
   - 启用认证（root 用户+业务用户分离，最小权限原则），禁用空密码。  
   - 开启 TLS/SSL 加密（客户端与服务器、节点间通信均加密）。

2. **高可用保障**  
   - 副本集至少 3 节点（1 主 2 从，避免单点故障），跨机房部署（应对机房断电）。  
   - 配置 `--failIndexKeyTooLong=false` 避免索引创建失败导致主节点挂掉。

3. **备份策略**  
   - 每日自动备份（用 crontab 定时执行 `mongodump`），备份文件存多份（本地+云存储）。  
   - 每月测试恢复流程（确保备份可用），保留 30 天备份历史。

4. **监控与告警**  
   - 部署监控工具：Prometheus + Grafana（监控 CPU、内存、磁盘 IO、连接数、oplog 滞后）。  
   - 配置告警：磁盘使用率>85%、主从延迟>10s、连接数>1000 时触发邮件/短信告警。

5. **资源与性能**  
   - 给容器配置资源限制：`--memory=16g --cpus=4`（避免占用宿主机全部资源）。  
   - 优化内核参数：关闭 Transparent Huge Pages（THP），调整 `ulimit -n 65535`（增大文件描述符限制）。


## 9. 常见问题排查
### 9.1 容器启动失败
- 排查方法：查看日志 `docker logs -f mongo-dev`，常见原因：  
  1. 端口被占用：`netstat -tuln | grep 27017`，杀死占用进程或换端口。  
  2. 数据卷权限：用 `named volume` 替代宿主目录挂载（新手推荐），或执行 `chmod 777 /path/on/host`（临时测试，生产不推荐）。  
  3. 密码含特殊字符：用单引号包裹密码，如 `-e MONGO_INITDB_ROOT_PASSWORD='Pwd@2024!'`。

### 9.2 MONGO_INITDB_* 环境变量无效
- 原因：仅**首次初始化**（数据卷为空）时生效，已有数据的卷不会重新执行。  
- 解决：删除旧数据卷 `docker volume rm 项目名_mongo-data`，重新启动容器。

### 9.3 副本集从节点无法同步数据
- 排查步骤：  
  1. 查看主节点 oplog 大小：`use local; db.oplog.rs.stats().size`（确保 oplog 足够大，默认仅存 24 小时数据）。  
  2. 检查节点间网络：`docker exec -it mongo1 ping mongo2`（确保容器间能通信）。  
  3. 确认认证配置：若开启 keyfile，所有节点的 keyfile 内容必须一致。

### 9.4 连接超时
- 新手：检查容器是否运行（`docker ps`）、端口是否映射（`docker port mongo-dev`）。  
- 高级用户：检查防火墙（`ufw status` 或 `iptables -L`）、TLS 证书是否正确、副本集节点地址是否可访问。


## 10. 后续学习路径
- **新手**：先熟悉单节点操作（创建集合、插入/查询数据）→ 学习 MongoDB 基本语法（参考 [MongoDB 基础教程](https://www.mongodb.com/docs/manual/tutorial/getting-started/)）→ 尝试初始化脚本自定义数据。  
- **高级工程师**：深入副本集原理→ 学习分片集群部署（应对 TB 级数据）→ 优化索引与聚合查询性能→ 掌握生产级监控与故障排查。

通过本文，无论是新手练手还是生产部署，都能找到对应的操作步骤，后续可根据业务需求逐步优化配置！

