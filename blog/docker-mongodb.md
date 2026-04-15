# 基于 Docker 的 MongoDB 部署与使用指南

![基于 Docker 的 MongoDB 部署与使用指南](https://img.xuanyuan.dev/docker/blog/docker-mangodb.png)

*分类: Docker,MongoDB | 标签: MongoDB,docker,部署教程 | 发布时间: 2025-10-04 08:28:06*

> 本文介绍MongoDB的定义与适用场景，详述Docker环境下的准备工作、单节点快速部署、Docker Compose配置、初始化脚本编写、数据持久化方案、备份恢复方法，还提供副本集搭建示例、生产环境要点及常见问题排查，附官方与权威参考资源。

## 适用读者及版本说明
### 适用读者
- 新手开发者：快速搭建 MongoDB 开发/测试环境，掌握基础操作
- 中级开发者：实现数据持久化、初始化脚本、备份恢复等实用功能
- 高级工程师/运维：部署生产级高可用副本集、配置安全策略与监控告警

### 版本兼容范围
- MongoDB：6.0.x（LTS 长期支持版，支持至 2027 年，推荐 6.0.18 稳定版）
- Docker：≥ 24.0.0
- Docker Compose：≥ v2.26.1（兼容 `version: "3.8"` YML 配置）
- 操作系统：Linux（CentOS 7+/Ubuntu 18.04+）、Windows 10+/Server 2019+、macOS 12+

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
- 国内镜像：[https://xuanyuan.cloud/zh/r/library/mongo](https://xuanyuan.cloud/zh/r/library/mongo)
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
- 端口：MongoDB 默认端口 **27017**（新手注意：开发环境可临时开放本地端口，生产环境严禁公网暴露！）
- 镜像访问支持：国内用户需配置 Docker 镜像访问支持（推荐用轩辕镜像，直接拉取加速镜像即可）。
- 版本兼容性提示：
  - Docker Compose v2.x 兼容 `version: "3.8"` 及以上 YML 配置
  - MongoDB 6.0 为 LTS（长期支持版，支持至 2027 年），6.2/6.3 为非 LTS 版本，不建议生产环境使用
  - Windows 与 Linux 路径差异：Linux 用 `/` 分隔，Windows 用 `\` 分隔；Windows 挂载目录无需手动配置权限

## 3. MongoDB 镜像下载
推荐用**轩辕镜像**（避免国外网络超时），步骤均已简化。

### 3.1 方式1：使用轩辕镜像
```bash
# 拉取 6.0.18 稳定版（指定patch版本，避免版本漂移，适合开发/生产）
docker pull docker.xuanyuan.run/library/mongo:6.0.18

# （可选）将镜像改名为官方标准名称
docker tag docker.xuanyuan.run/library/mongo:6.0.18 mongo:6.0.18
# 删除临时镜像标签，释放空间
docker rmi docker.xuanyuan.run/library/mongo:6.0.18
```

### 3.2 方式2：使用官方镜像
```bash
# 直接拉取 Docker Hub 官方镜像（指定patch版本）
docker pull mongo:6.0.18
```

### 3.3 验证镜像是否下载成功（新手必做）
执行命令 `docker images`，若输出如下内容，说明镜像下载成功：
```
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
mongo        6.0.18    d3ad5c1a1b22   5 days ago     700MB
```

## 4. 快速上手：单节点部署
### 开发 vs 生产环境核心差异（一目了然）
| 对比项               | 开发/测试环境                | 生产环境                      |
|----------------------|-----------------------------|-------------------------------|
| 端口映射             | 启用 `27017:27017` 本地访问  | 禁用公网映射，使用内网/VPN/反向代理 |
| 密码管理             | 可临时使用简单密码（需标注） | 强随机密码+`.env`文件管理+定期更换 |
| 资源限制             | 可选配置                    | 必须配置（`--memory`/`--cpus`） |
| 数据持久化           | Docker named volume         | 持久化卷+多副本备份            |
| 健康检查             | 可选启用                    | 必须启用                      |
| 自动重启             | 启用 `unless-stopped`       | 启用 `always`                  |

单节点适合开发、测试场景，提供两种部署方式：`docker run`（快速启动）和 `Docker Compose`（推荐，便于后续维护）。

### 4.1 方式1：docker run 快速启动
```bash
# 提示：请勿在生产环境直接明文写密码，建议使用系统环境变量
# 示例：先导出环境变量 export MONGO_ROOT_PWD=$(openssl rand -base64 16)
docker run -d \
  --name mongo-dev \          # 容器名称（自定义，如 mongo-test）
  -e MONGO_INITDB_ROOT_USERNAME=admin \  # 初始化 root 用户名（必填，避免无密码风险）
  -e MONGO_INITDB_ROOT_PASSWORD=${MONGO_ROOT_PWD:-ReplaceWithStrongRandomPwd!} \  # 优先使用系统环境变量，强制提示替换强密码
  -v mongo-data:/data/db \    # 持久化数据（用 Docker named volume，避免权限问题）
  -p 27017:27017 \            # 开发环境映射端口，生产环境请删除此行
  --memory=4g \               # 资源限制：最大使用4G内存
  --cpus=2 \                  # 资源限制：最大使用2核CPU
  --restart unless-stopped \  # 容器异常时自动重启（开发/生产均推荐）
  --health-cmd "mongosh --eval 'db.runCommand({ping:1})' --quiet" \  # 健康检查：检测MongoDB可用性
  --health-interval=30s \     # 每30秒检查一次
  --health-timeout=5s \       # 检查超时时间5秒
  --health-retries=3 \        # 连续3次失败标记为不健康
  mongo:6.0.18                # 镜像名称:指定patch版本，避免版本漂移
```

#### 关键参数解释
- `-e`：设置环境变量，`MONGO_INITDB_*` 仅**首次启动（数据卷为空时）**生效（初始化 root 用户）。
- `-v mongo-data:/data/db`：用 `named volume` 持久化数据（比直接挂载宿主目录更安全，新手无需处理权限）。
- `--memory`/`--cpus`：资源限制，避免容器占用宿主机全部资源（生产环境必须配置）。
- `--health-*`：健康检查，避免容器状态显示 `Up` 但 MongoDB 服务不可用的情况。
- `--restart unless-stopped`：避免容器意外退出后数据丢失（开发环境也建议开启）。

### 4.2 方式2：Docker Compose 部署（推荐，便于维护）
#### 步骤1：创建 .env 文件（管理敏感信息，避免明文泄露）
```bash
# 在 docker-compose.yml 同级目录创建 .env 文件
# 提示：1. 替换为强随机密码（推荐用 openssl rand -base64 16 生成）
#      2. 添加 .env 到 .gitignore，避免提交到版本库
#      3. 定期更换密码并备份该文件
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=ReplaceWithStrongRandomPwd2024!
MONGO_INITDB_DATABASE=myappdb
MONGO_APP_USER=appuser
MONGO_APP_PASSWORD=AppUserStrongPwd2024!
MONGO_MEMORY_LIMIT=4g
MONGO_CPU_LIMIT=2
```

#### 步骤2：创建 docker-compose.yml 文件（可直接复制）
```yaml
version: "3.8"  # 兼容主流 Docker Compose v2.x 版本
services:
  mongo:
    image: mongo:6.0.18  # 指定patch版本，避免版本漂移
    container_name: mongo-dev
    env_file:
      - .env  # 引用 .env 文件，加载敏感环境变量，避免明文泄露
    volumes:
      - mongo-data:/data/db
      - ./initdb:/docker-entrypoint-initdb.d:ro  # 初始化脚本挂载（ro：只读，安全）
    # 生产环境请删除以下 ports 配置，禁止公网暴露端口
    ports:
      - "27017:27017"
    restart: unless-stopped  # 自动重启策略（生产环境可改为 always）
    mem_limit: ${MONGO_MEMORY_LIMIT}  # 从 .env 加载内存限制
    cpus: ${MONGO_CPU_LIMIT}          # 从 .env 加载CPU限制
    healthcheck:  # 健康检查（生产环境必须启用）
      test: ["CMD", "mongosh", "--eval", "db.runCommand({ping:1})", "--quiet"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s  # 容器启动后10秒再开始检查

# 声明 named volume（无需手动创建，Docker 会自动初始化）
volumes:
  mongo-data:
```

#### 步骤3：创建 docker-compose.override.yml（开发环境专属配置，无需修改主配置）
```yaml
# 开发环境覆盖配置，与 docker-compose.yml 同级目录
# 生产环境部署时，可通过 -f 指定主配置，忽略该文件：docker compose -f docker-compose.yml up -d
version: "3.8"
services:
  mongo:
    # 开发环境额外映射端口、开启调试日志
    ports:
      - "27017:27017"
    command: ["mongod", "--verbose"]  # 开启详细日志，便于开发调试
```

#### 步骤4：启动容器
```bash
# 在 docker-compose.yml 所在目录执行
docker compose up -d
```

### 4.3 验证部署是否成功
#### 步骤1：查看容器状态与健康状态
```bash
# 查看容器运行状态（健康状态显示 healthy 即为正常）
docker ps | grep mongo-dev
```
若输出包含 `Up` 和 `healthy`（如 `Up 5 minutes (healthy)`），说明容器与 MongoDB 服务均正常运行。

#### 步骤2：连接 MongoDB 测试（两种方式）
- **方式A：本地安装 mongosh 连接**（适合有 mongosh 的用户）：
  ```bash
  # 替换为你的用户名和密码
  mongosh "mongodb://admin:ReplaceWithStrongRandomPwd2024!@localhost:27017/admin"
  ```
  成功后会进入 `mongosh` 交互界面（显示 `admin> ` 提示符）。

- **方式B：容器内连接**（新手推荐，无需安装 mongosh）：
  ```bash
  # 替换为你的密码
  docker exec -it mongo-dev mongosh -u admin -p ReplaceWithStrongRandomPwd2024! --authenticationDatabase admin
  ```
  同样进入交互界面，输入 `db.version()` 可查看 MongoDB 版本（验证连接成功）。

## 5. 初始化脚本：自动创建用户与数据库
新手需自动初始化业务用户，高级用户可自定义脚本（如建索引、导入初始数据），脚本仅**首次启动（数据卷为空时）**执行。

### 5.1 编写初始化脚本（优化版：从.env注入密码，创建索引）
#### 步骤1：创建脚本目录与文件
```bash
# 在 docker-compose.yml 所在目录创建 initdb 文件夹
mkdir -p initdb
# 创建初始化脚本（用 vim 或记事本编辑，新手可复制内容）
vim initdb/01-create-app-user-and-index.js
```

#### 步骤2：脚本内容（密码从环境变量读取，增加索引创建）
```javascript
try {
  // 从容器环境变量中读取业务用户配置（避免明文硬编码）
  const appUser = process.env.MONGO_APP_USER;
  const appPwd = process.env.MONGO_APP_PASSWORD;
  const targetDbName = process.env.MONGO_INITDB_DATABASE || "myappdb";

  // 校验环境变量是否存在
  if (!appUser || !appPwd) {
    throw new Error("业务用户配置缺失：请在 .env 中设置 MONGO_APP_USER 和 MONGO_APP_PASSWORD");
  }

  // 切换到预创建的业务数据库
  const targetDb = db.getSiblingDB(targetDbName);

  // 检查业务用户是否已存在，避免重复创建报错
  const existingUser = targetDb.getUser(appUser);
  if (existingUser) {
    print(`业务用户 ${appUser} 已存在，无需重复创建`);
    return;
  }

  // 创建业务用户（仅授予 targetDbName 的读写权限，遵循最小权限原则）
  targetDb.createUser({
    user: appUser,
    pwd: appPwd,
    roles: [
      { role: "readWrite", db: targetDbName }  // 仅授予业务数据库读写权限，禁止root权限
    ]
  });
  print(`业务用户 ${appUser} 创建成功`);

  // 创建常用索引（优化查询性能，生产环境必备）
  // 示例1：用户表按手机号创建唯一索引
  const userCollection = targetDb.createCollection("users");
  userCollection.createIndex({ phone: 1 }, { unique: true, background: true });
  print("用户表 phone 唯一索引创建成功");

  // 示例2：日志表按时间戳创建索引
  const logCollection = targetDb.createCollection("operation_logs");
  logCollection.createIndex({ createTime: -1 }, { background: true });
  print("日志表 createTime 倒序索引创建成功");

  // （可选）插入测试数据
  const insertResult = targetDb.testCollection.insertOne({ 
    name: "MongoDB_Init_Test", 
    time: new Date(),
    status: "success"
  });
  if (insertResult.insertedId) {
    print(`测试数据插入成功，ID：${insertResult.insertedId}`);
  } else {
    print("测试数据插入失败");
  }
} catch (err) {
  print(`初始化脚本执行异常：${err.message}`);
  // 抛出异常，让容器启动失败，便于发现问题
  throw err;
}
```

### 5.2 挂载脚本并重启（结合 Docker Compose）
#### 步骤1：确认 docker-compose.yml 已挂载脚本目录
```yaml
volumes:
  - mongo-data:/data/db
  - ./initdb:/docker-entrypoint-initdb.d:ro  # 已挂载，无需重复修改
```

#### 步骤2：重启容器（首次执行脚本需清空旧数据卷）
```bash
# 警告：-v 参数会删除 mongo-data 数据卷，清空所有原有数据！
# 仅首次执行初始化脚本时使用，已有业务数据请勿执行此命令
docker compose down -v  
# 重新启动容器，执行初始化脚本
docker compose up -d
```

#### 步骤3：验证脚本是否生效（必做，确保初始化成功）
```bash
# 方式1：容器内用业务用户连接测试
docker exec -it mongo-dev mongosh -u ${MONGO_APP_USER} -p ${MONGO_APP_PASSWORD} --authenticationDatabase myappdb
# 查看测试数据（若输出插入的文档，说明脚本生效）
db.testCollection.find().pretty();
# 查看索引（验证索引创建成功）
db.users.getIndexes();
db.operation_logs.getIndexes();

# 方式2：检查脚本执行日志（排查失败原因）
docker logs mongo-dev | grep -E "appuser|MongoDB_Init_Test|索引创建成功"
```

## 6. 备份与恢复（开发/生产必备，优化压缩/增量备份）
新手需掌握基础备份，高级用户需结合定时任务（如 crontab），推荐用官方工具 `mongodump`/`mongorestore`。

### 6.1 备份数据（优化版：压缩备份+增量备份+权限对齐）
#### 方式1：压缩备份（节省存储，推荐生产使用）
```bash
# 1. 定义带时间戳的备份目录
BACKUP_TIMESTAMP=$(date +%F-%H%M%S)
HOST_BACKUP_DIR="/backup/mongo/${BACKUP_TIMESTAMP}"
mkdir -p ${HOST_BACKUP_DIR}

# 2. 容器内执行压缩备份（gzip 压缩，减少存储占用）
docker exec -it mongo-dev bash -c "
  mongodump --uri='mongodb://admin:ReplaceWithStrongRandomPwd2024!@localhost:27017' \
    --gzip \  # 启用 gzip 压缩
    --out /tmp/backup_${BACKUP_TIMESTAMP}
"

# 3. 复制压缩备份到宿主机，并对齐 UID/GID（避免权限无法访问）
docker cp mongo-dev:/tmp/backup_${BACKUP_TIMESTAMP} ${HOST_BACKUP_DIR}
chown -R $(id -u):$(id -g) ${HOST_BACKUP_DIR}  # 对齐宿主机当前用户权限
echo "压缩备份完成，存储路径：${HOST_BACKUP_DIR}"

# 4. 删除容器内临时备份
docker exec -it mongo-dev rm -rf /tmp/backup_${BACKUP_TIMESTAMP}
```

#### 方式2：增量备份（基于 oplog，适合大规模数据）
```bash
# 前提：仅副本集支持增量备份（单节点无 oplog 完整日志）
# 1. 先执行一次全量备份，记录 oplog 时间点
FULL_BACKUP_DIR="/backup/mongo/full-$(date +%F)"
mkdir -p ${FULL_BACKUP_DIR}
docker exec -it mongo1 mongosh -u admin -p ReplaceWithStrongRandomPwd2024! --authenticationDatabase admin --eval '
  var backupTimestamp = new Date();
  printjson({ fullBackupTime: backupTimestamp, ts: db.getReplicationInfo().latestOpTime.ts });
' > ${FULL_BACKUP_DIR}/backup-meta.json

# 2. 执行全量备份
docker exec -it mongo1 bash -c "
  mongodump --uri='mongodb://admin:ReplaceWithStrongRandomPwd2024!@localhost:27017' \
    --gzip \
    --out /tmp/full-backup \
    --oplog  # 记录备份期间的 oplog
"
docker cp mongo1:/tmp/full-backup ${FULL_BACKUP_DIR}
chown -R $(id -u):$(id -g) ${FULL_BACKUP_DIR}

# 3. 增量备份（基于上次全量备份的 oplog 时间点）
INCR_BACKUP_DIR="/backup/mongo/incr-$(date +%F-%H%M%S)"
mkdir -p ${INCR_BACKUP_DIR}
docker exec -it mongo1 bash -c "
  mongodump --uri='mongodb://admin:ReplaceWithStrongRandomPwd2024!@localhost:27017' \
    --gzip \
    --out /tmp/incr-backup \
    --oplogReplay \  # 重放 oplog 实现增量备份
    --sinceTimestamp $(cat ${FULL_BACKUP_DIR}/backup-meta.json | grep ts | awk -F ':' '{print $2}' | tr -d ' ,')
"
docker cp mongo1:/tmp/incr-backup ${INCR_BACKUP_DIR}
chown -R $(id -u):$(id -g) ${INCR_BACKUP_DIR}
echo "增量备份完成，存储路径：${INCR_BACKUP_DIR}"
```

### 6.2 恢复数据（导入）
```bash
# 替换为你的备份目录（带时间戳）
BACKUP_DIR="/backup/mongo/2024-10-01-143000"
# 恢复前建议停止业务服务，避免数据写入冲突
mongorestore --uri="mongodb://admin:ReplaceWithStrongRandomPwd2024!@localhost:27017" \
  --gzip \  # 若备份时启用压缩，恢复时需指定
  ${BACKUP_DIR}
echo "数据恢复完成"
```

#### 注意事项
- 恢复前建议停止业务服务，避免数据写入冲突。
- 生产环境需定期测试恢复流程（避免备份文件损坏却未发现）。
- 备份文件建议多副本存储（本地+云存储，如阿里云OSS/腾讯云COS）。
- 备份目录权限：确保宿主机 UID/GID 与备份文件对齐，避免后续无法读取。

## 7. 进阶：副本集（Replica Set）部署（高可用需求）
副本集实现**高可用**（故障自动转移）、**读写分离**，是生产环境必备配置。本节分为「基础示例（新手学习）」和「生产优化（高级工程师）」，并补充图示与跨主机部署说明。

### 7.1 副本集核心概念（新手了解+图示）
#### 核心节点说明
- 主节点（Primary）：处理所有写请求，同步数据到从节点，仅1个。
- 从节点（Secondary）：同步主节点数据，处理读请求，可多个，主节点故障后自动选举升级为主节点。
- 仲裁节点（Arbiter）：仅参与投票选举，不存储数据，无复制压力，适合资源紧张场景（3节点副本集可不用）。

#### 副本集架构图示（文字版，便于新手理解）
```
# 3节点副本集（无仲裁节点，推荐生产使用）
┌─────────────┐     写请求     ┌─────────────┐
│  客户端     ├───────────────>│  Primary    │
│             │                │  (mongo1)   │
└─────────────┘                └──────┬──────┘
       ▲                             │
       │ 读请求（secondaryPreferred） │ 数据同步
       │                             │
┌──────┴──────┐                ┌──────▼──────┐
│ Secondary 1 │<───────────────│ Secondary 2 │
│ (mongo2)    │                │ (mongo3)    │
└─────────────┘                └─────────────┘
# 故障转移：当 mongo1 宕机后，mongo2/mongo3 自动选举新主节点，客户端无缝切换
```

### 7.2 基础示例：3 节点副本集部署（新手学习，无安全配置）
#### 步骤1：创建 docker-compose-replica-basic.yml
```yaml
version: "3.8"
# 自定义 Docker 网络，用于副本集节点内部通信（无需依赖端口映射）
networks:
  mongo-net:
    driver: bridge  # 单机部署使用 bridge 网络，跨主机使用 overlay 网络

services:
  # 主节点（初始，后续自动选举）
  mongo1:
    image: mongo:6.0.18
    container_name: mongo1
    command: ["mongod", "--replSet", "rs0", "--bind_ip_all"]  # --replSet 指定副本集名称 rs0
    ports: ["27017:27017"]  # 开发环境映射，生产环境删除
    volumes: ["mongo1-data:/data/db"]
    restart: unless-stopped
    networks: [mongo-net]  # 加入自定义内部网络
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.runCommand({ping:1})", "--quiet"]
      interval: 30s
      timeout: 5s
      retries: 3

  # 从节点1
  mongo2:
    image: mongo:6.0.18
    container_name: mongo2
    command: ["mongod", "--replSet", "rs0", "--bind_ip_all"]
    ports: ["27018:27017"]  # 开发环境映射，生产环境删除
    volumes: ["mongo2-data:/data/db"]
    restart: unless-stopped
    networks: [mongo-net]
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.runCommand({ping:1})", "--quiet"]
      interval: 30s
      timeout: 5s
      retries: 3

  # 从节点2
  mongo3:
    image: mongo:6.0.18
    container_name: mongo3
    command: ["mongod", "--replSet", "rs0", "--bind_ip_all"]
    ports: ["27019:27017"]  # 开发环境映射，生产环境删除
    volumes: ["mongo3-data:/data/db"]
    restart: unless-stopped
    networks: [mongo-net]
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.runCommand({ping:1})", "--quiet"]
      interval: 30s
      timeout: 5s
      retries: 3

volumes:
  mongo1-data:
  mongo2-data:
  mongo3-data:
```

#### 步骤2：启动副本集容器
```bash
docker compose -f docker-compose-replica-basic.yml up -d
```

#### 步骤3：初始化副本集（基础版）
```bash
# 等待所有节点健康运行（约10秒）
sleep 10
# 进入 mongo1 容器，执行初始化命令
docker exec -it mongo1 mongosh --eval '
  rs.initiate({
    _id: "rs0",  # 副本集名称，需与 command 中 --replSet 一致
    members: [
      { _id: 0, host: "mongo1:27017" },  # 节点1（容器名:端口，内部网络通信）
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

### 7.3 生产优化：3 节点副本集（启用 keyfile 认证+TLS/SSL 加密）
#### 步骤1：生成 keyfile（节点间互信密钥，生产必备）
```bash
# 1. 创建 keyfile 存储目录
mkdir -p mongo-keyfile
# 2. 生成 keyfile（256位随机字符串，MongoDB 要求）
openssl rand -base64 756 > mongo-keyfile/keyfile
# 3. 设置权限为 600（MongoDB 强制要求，否则节点启动失败）
chmod 600 mongo-keyfile/keyfile
# 4. （Linux/Mac）修改所属用户（避免容器内权限问题）
chown 999:999 mongo-keyfile/keyfile  # 999 是 mongo 容器内默认用户ID
```

#### 步骤2：生成 TLS/SSL 证书（测试用自签名/生产用正式证书）
```bash
# 方式1：生成自签名证书（仅测试环境使用，生产环境请使用 CA 签发证书）
mkdir -p mongo-tls
openssl req -x509 -newkey rsa:4096 -days 365 -nodes \
  -keyout mongo-tls/mongo.key \
  -out mongo-tls/mongo.crt \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=MyCompany/OU=IT/CN=mongo.rs0.local"

# 设置证书权限
chmod 600 mongo-tls/mongo.key
chown 999:999 mongo-tls/mongo.key mongo-tls/mongo.crt

# 方式2：生产环境挂载 CA 签发证书（将证书放入 mongo-tls 目录即可，无需重新生成）
```

#### 步骤3：创建 docker-compose-replica-prod.yml
```yaml
version: "3.8"
networks:
  mongo-net:
    driver: bridge  # 跨主机部署时改为 overlay 网络（需 Docker Swarm/K8s）

services:
  mongo1:
    image: mongo:6.0.18
    container_name: mongo1
    command: [
      "mongod", 
      "--replSet", "rs0", 
      "--bind_ip_all", 
      "--keyFile", "/etc/mongo-keyfile/keyfile",  # 挂载 keyfile
      "--authorization", "enabled",  # 启用认证
      "--sslMode", "requireSSL",  # 强制启用 TLS/SSL 加密
      "--sslPEMKeyFile", "/etc/mongo-tls/mongo.crt",  # 证书（含公钥+私钥）
      "--sslCAFile", "/etc/mongo-tls/mongo.crt",  # CA 证书（自签名证书与服务端证书一致）
      "--sslAllowInvalidCertificates"  # 测试环境允许无效证书（生产环境删除此行）
    ]
    volumes:
      - mongo1-data:/data/db
      - ./mongo-keyfile:/etc/mongo-keyfile:ro  # 只读挂载 keyfile 目录
      - ./mongo-tls:/etc/mongo-tls:ro  # 只读挂载 TLS/SSL 证书目录
    restart: always
    networks: [mongo-net]
    mem_limit: 8g
    cpus: 4
    healthcheck:
      test: ["CMD", "mongosh", "-u", "admin", "-p", "${MONGO_ROOT_PASSWORD}", "--ssl", "--eval", "db.runCommand({ping:1})", "--quiet"]
      interval: 30s
      timeout: 5s
      retries: 3
    env_file:
      - .env.prod

  mongo2:
    image: mongo:6.0.18
    container_name: mongo2
    command: [
      "mongod", 
      "--replSet", "rs0", 
      "--bind_ip_all", 
      "--keyFile", "/etc/mongo-keyfile/keyfile",
      "--authorization", "enabled",
      "--sslMode", "requireSSL",
      "--sslPEMKeyFile", "/etc/mongo-tls/mongo.crt",
      "--sslCAFile", "/etc/mongo-tls/mongo.crt",
      "--sslAllowInvalidCertificates"  # 测试环境删除，生产环境保留CA验证
    ]
    volumes:
      - mongo2-data:/data/db
      - ./mongo-keyfile:/etc/mongo-keyfile:ro
      - ./mongo-tls:/etc/mongo-tls:ro
    restart: always
    networks: [mongo-net]
    mem_limit: 8g
    cpus: 4
    healthcheck:
      test: ["CMD", "mongosh", "-u", "admin", "-p", "${MONGO_ROOT_PASSWORD}", "--ssl", "--eval", "db.runCommand({ping:1})", "--quiet"]
      interval: 30s
      timeout: 5s
      retries: 3
    env_file:
      - .env.prod

  mongo3:
    image: mongo:6.0.18
    container_name: mongo3
    command: [
      "mongod", 
      "--replSet", "rs0", 
      "--bind_ip_all", 
      "--keyFile", "/etc/mongo-keyfile/keyfile",
      "--authorization", "enabled",
      "--sslMode", "requireSSL",
      "--sslPEMKeyFile", "/etc/mongo-tls/mongo.crt",
      "--sslCAFile", "/etc/mongo-tls/mongo.crt",
      "--sslAllowInvalidCertificates"  # 测试环境删除，生产环境保留CA验证
    ]
    volumes:
      - mongo3-data:/data/db
      - ./mongo-keyfile:/etc/mongo-keyfile:ro
      - ./mongo-tls:/etc/mongo-tls:ro
    restart: always
    networks: [mongo-net]
    mem_limit: 8g
    cpus: 4
    healthcheck:
      test: ["CMD", "mongosh", "-u", "admin", "-p", "${MONGO_ROOT_PASSWORD}", "--ssl", "--eval", "db.runCommand({ping:1})", "--quiet"]
      interval: 30s
      timeout: 5s
      retries: 3
    env_file:
      - .env.prod

volumes:
  mongo1-data:
  mongo2-data:
  mongo3-data:
```

#### 步骤4：创建 .env.prod 文件（生产环境敏感信息）
```bash
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=ReplaceWithStrongRandomPwd2024!  # 用 openssl rand -base64 16 生成
MONGO_INITDB_DATABASE=admin
MONGO_APP_USER=appuser
MONGO_APP_PASSWORD=AppUserStrongPwd2024!
```

#### 步骤5：启动并初始化生产级副本集
```bash
# 1. 启动容器
docker compose -f docker-compose-replica-prod.yml up -d
# 2. 等待节点健康运行
sleep 10
# 3. 初始化副本集（启用 keyfile 认证+SSL）
docker exec -it mongo1 mongosh -u admin -p ReplaceWithStrongRandomPwd2024! --authenticationDatabase admin --ssl --eval '
  rs.initiate({
    _id: "rs0",
    keyFile: "/etc/mongo-keyfile/keyfile",  # 指定 keyfile 路径
    members: [
      { _id: 0, host: "mongo1:27017" },
      { _id: 1, host: "mongo2:27017" },
      { _id: 2, host: "mongo3:27017" }
    ]
  })
'
# 4. 验证副本集状态
docker exec -it mongo1 mongosh -u admin -p ReplaceWithStrongRandomPwd2024! --authenticationDatabase admin --ssl
rs.status()
```

#### 步骤6：跨机房/跨宿主机部署注意事项
1.  **网络配置**：Docker bridge 网络仅支持单机通信，跨宿主机需使用 **Docker Swarm overlay 网络** 或 **Kubernetes Service**，确保节点间能访问 27017 端口。
2.  **Hostname/DNS 配置**：副本集节点地址需使用可解析的 hostname 或固定 IP，避免容器重启后 IP 变化导致同步失败。
3.  **资源隔离**：不同宿主机需配置相同的资源限制（CPU/内存），避免节点性能差异导致选举异常。
4.  **容灾策略**：3 个节点尽量分布在 2-3 个机房，避免单机房断电导致整个副本集不可用。
5.  **防火墙配置**：仅开放节点间 27017 端口通信，禁止公网访问。

## 8. 生产环境核心注意事项
### 8.1 安全第一（重中之重）
1.  严禁暴露 27017 端口到公网（用内网、VPN 或反向代理（如 Nginx）访问）。
2.  启用认证（root 用户+业务用户分离，最小权限原则）：
    - root 用户仅用于运维操作（备份/恢复/节点管理），禁止业务系统直接使用。
    - 业务用户仅授予对应业务数据库的读写权限，禁止授予 `root`/`dbOwner` 等高权限。
3.  开启 TLS/SSL 加密（客户端与服务器、节点间通信均加密）：
    - 生产环境使用 CA 签发的有效证书，禁止使用自签名证书。
    - 证书定期更换（建议每 1 年），并备份旧证书避免切换异常。
4.  密码管理：
    - 强随机密码（长度≥16位，包含大小写字母、数字、特殊字符）。
    - 特殊字符处理：YAML 配置中用单引号包裹密码（如 `'P@ssw0rd!123'`），Shell 中用转义符（如 `P\@ssw0rd\!123`）。
    - 定期更换密码（建议每 90 天），更换时先更新 .env 文件，再重启容器。
5.  keyfile 权限严格设置为 600，仅授权运维用户访问，避免泄露；所有节点的 keyfile 内容必须一致。
6.  将 `.env`、`mongo-keyfile`、`mongo-tls` 等敏感文件添加到 `.gitignore`，禁止提交到版本库。

### 8.2 高可用保障
1.  副本集至少 3 节点（1 主 2 从），跨机房部署（应对机房断电）。
2.  配置 `--restart always`，确保容器异常后自动重启。
3.  启用健康检查，及时发现服务不可用状态。
4.  避免单点故障：数据卷使用持久化存储，备份文件多副本存储。
5.  读写分离：客户端连接时指定 `readPreference: "secondaryPreferred"`，将读请求分流到从节点，减轻主节点压力。

### 8.3 备份策略
1.  每日自动备份（用 crontab 定时执行 `mongodump`），备份文件带时间戳，避免覆盖。
    ```bash
    # 添加 crontab 定时任务（每天凌晨 2 点执行压缩备份）
    crontab -e
    # 写入以下内容
    0 2 * * * /bin/bash /backup/mongo-backup-script.sh >> /var/log/mongo-backup.log 2>&1
    ```
2.  备份文件存多份（本地+云存储），保留 30 天备份历史，过期自动清理。
3.  每月测试恢复流程（确保备份可用，避免备份损坏未发现）。
4.  大规模数据优先使用增量备份，减少备份时间与存储占用。

### 8.4 监控与告警（优化版：oplog 滞后监控+指标对应表）
1.  部署监控工具：Prometheus + Grafana（监控 CPU、内存、磁盘 IO、连接数、oplog 滞后）。
2.  简单监控配置示例（Prometheus + Grafana）：
    - 步骤1：部署 MongoDB Exporter
      ```bash
      docker run -d \
        --name mongo-exporter \
        --net mongo-net \
        -e MONGODB_URI="mongodb://admin:ReplaceWithStrongPwd!@mongo1:27017?ssl=true" \
        prom/mongodb-exporter:latest
      ```
    - 步骤2：Prometheus 配置目标（添加到 prometheus.yml）
      ```yaml
      scrape_configs:
        - job_name: 'mongodb'
          static_configs:
            - targets: ['mongo-exporter:9216']
      ```
    - 步骤3：Grafana 导入 MongoDB 监控仪表盘（ID：10494）
3.  **oplog 滞后监控告警**：
    - 监控指标：`mongodb_replset_member_optime_date_seconds`（主从节点 oplog 时间差）。
    - 告警阈值：主从延迟 > 10s 触发警告，> 30s 触发紧急告警。
    - 手动查询滞后：`rs.secondaryLag()`（在主节点执行，返回从节点最大滞后时间）。
4.  **容器指标与 MongoDB 指标对应关系表**
    | 容器指标（Docker） | MongoDB 内部指标 | 监控意义 | 告警阈值 |
    |--------------------|------------------|----------|----------|
    | CPU 使用率         | `db.serverStatus().cpu` | 节点计算压力 | > 80%（持续5分钟） |
    | 内存使用率         | `db.serverStatus().mem` | 内存占用情况 | > 90%（持续5分钟） |
    | 磁盘 IO 吞吐量     | `db.serverStatus().diskIO` | 存储读写压力 | > 80% 磁盘带宽 |
    | 网络吞吐量         | `db.serverStatus().network` | 节点间通信压力 | > 100MB/s（持续5分钟） |
    | 容器重启次数       | `docker inspect` | 节点稳定性 | > 3 次/小时 |

### 8.5 资源与性能
1.  给容器配置资源限制（`--memory`/`--cpus`），避免占用宿主机全部资源。
2.  优化内核参数：
    - 关闭 Transparent Huge Pages（THP）：`echo never > /sys/kernel/mm/transparent_hugepage/enabled`
    - 增大文件描述符限制：`ulimit -n 65535`（永久生效需修改 `/etc/security/limits.conf`）
3.  合理设计索引，避免全集合扫描，定期优化聚合查询。
4.  扩容 oplog 大小：默认 oplog 仅占磁盘 5%，生产环境可扩容至 10%-20%，避免从节点同步失败。

## 9. 常见问题排查（补充优化）
### 9.1 容器启动失败
- 排查方法：查看日志 `docker logs -f mongo-dev`，常见原因：
  1.  端口被占用：`netstat -tuln | grep 27017`，杀死占用进程或换端口。
  2.  数据卷权限：用 `named volume` 替代宿主目录挂载（新手推荐），或执行 `chmod 777 /path/on/host`（临时测试，生产不推荐）。
  3.  密码含特殊字符：用单引号包裹密码，或通过 `.env` 文件加载。
  4.  keyfile 权限错误：确保 keyfile 权限为 600，所属用户为 999（mongo 容器默认用户）。
  5.  TLS 证书错误：确保证书文件存在且权限为 600，自签名证书需添加 `--sslAllowInvalidCertificates` 参数。

### 9.2 MONGO_INITDB_* 环境变量无效
- 原因：仅**首次初始化（数据卷为空）**时生效，已有数据的卷不会重新执行。
- 解决：删除旧数据卷 `docker volume rm 项目名_mongo-data`，重新启动容器（注意备份数据）。

### 9.3 初始化脚本不执行
- 原因：数据卷非空，或脚本挂载路径错误，或脚本权限问题。
- 解决：
  1.  删除旧数据卷 `docker compose down -v`。
  2.  检查脚本挂载路径是否为 `/docker-entrypoint-initdb.d`。
  3.  确保脚本后缀为 `.js`，权限为可读。
  4.  查看容器日志 `docker logs mongo-dev`，排查脚本执行异常。

### 9.4 副本集从节点无法同步数据
- 排查步骤：
  1.  查看主节点 oplog 大小：`use local; db.oplog.rs.stats().size`（确保 oplog 足够大，默认仅存 24 小时数据）。
  2.  检查节点间网络：`docker exec -it mongo1 ping mongo2`（确保容器间能通信）。
  3.  确认 keyfile 配置：所有节点的 keyfile 内容必须一致，权限为 600。
  4.  查看节点日志：`docker logs mongo2`，排查认证或同步错误。
  5.  检查副本集配置：`rs.conf()`，确保节点地址正确且状态为 `UP`。

### 9.5 副本集主节点切换异常
- 常见原因：节点性能差异、网络延迟、投票数不足。
- 排查步骤：
  1.  查看节点状态：`rs.status()`，确认是否有节点状态为 `DOWN` 或 `RECOVERING`。
  2.  检查节点日志：`docker logs mongo1`（查看选举失败原因）。
  3.  确认副本集投票数：3 节点副本集需至少 2 个节点正常运行才能完成选举。
  4.  恢复故障节点：重启故障容器，或重新添加节点到副本集（`rs.add("mongo2:27017")`）。

### 9.6 资源瓶颈导致 MongoDB 卡顿
- 排查步骤：
  1.  **内存瓶颈**：`docker stats mongo-dev` 查看内存使用率，若接近 100%，需扩容内存或优化查询。
  2.  **CPU 瓶颈**：查看 CPU 使用率，若持续 > 80%，需排查慢查询（`db.currentOp()`）或扩容 CPU。
  3.  **IO 瓶颈**：`iostat -x 1` 查看磁盘 IO 使用率，若 %util > 90%，需更换 SSD 或优化索引。
  4.  **慢查询优化**：开启慢查询日志（`db.setProfilingLevel(1, { slowms: 100 })`），排查并优化耗时查询。

### 9.7 连接超时
- 新手：检查容器是否运行（`docker ps`）、端口是否映射（`docker port mongo-dev`）、防火墙是否开放端口。
- 高级用户：检查防火墙（`ufw status` 或 `iptables -L`）、TLS 证书是否正确、副本集节点地址是否可访问、内部网络是否连通。

## 10. 后续学习路径
- **新手**：先熟悉单节点操作（创建集合、插入/查询数据）→ 学习 MongoDB 基本语法（参考 [MongoDB 基础教程](https://www.mongodb.com/docs/manual/tutorial/getting-started/)）→ 尝试初始化脚本自定义数据。
- **高级工程师**：深入副本集原理→ 学习分片集群部署（应对 TB 级数据）→ 优化索引与聚合查询性能→ 掌握生产级监控与故障排查→ 实现 MongoDB 与业务系统的无缝集成。

## 附录
### 附录1：常用命令速查表
| 操作类型 | 命令示例 | 说明 |
|----------|----------|------|
| 容器启动 | `docker compose up -d` | 后台启动 MongoDB 容器 |
| 容器停止 | `docker compose down` | 停止并删除容器（保留数据卷） |
| 容器停止（删除数据卷） | `docker compose down -v` | 停止容器并删除数据卷（谨慎使用） |
| 查看容器状态 | `docker ps | grep mongo` | 查看 MongoDB 容器运行状态与健康状态 |
| 查看容器日志 | `docker logs -f mongo-dev` | 实时查看容器日志（排查故障） |
| 进入容器交互终端 | `docker exec -it mongo-dev bash` | 进入 MongoDB 容器内部 |
| 连接 MongoDB（容器内） | `docker exec -it mongo-dev mongosh -u admin -p 密码 --authenticationDatabase admin` | 无需本地安装 mongosh，直接连接 |
| 查看 MongoDB 版本 | `docker exec -it mongo-dev mongosh --eval 'db.version()'` | 快速查看 MongoDB 版本 |
| 备份数据（压缩） | `docker exec -it mongo-dev mongodump --uri=xxx --gzip --out /tmp/backup` | 容器内执行压缩备份 |
| 恢复数据（压缩） | `mongorestore --uri=xxx --gzip 备份目录` | 恢复 gzip 压缩的备份数据 |
| 查看副本集状态 | `docker exec -it mongo1 mongosh -u admin -p 密码 --ssl --eval 'rs.status()'` | 查看生产级副本集状态 |
| 查看慢查询 | `docker exec -it mongo-dev mongosh -u admin -p 密码 --eval 'db.currentOp({ "secs_running": { "$gt": 1 } })'` | 排查运行超过 1 秒的慢查询 |

### 附录2：.env.example 模板
```bash
# 复制此文件为 .env，修改为实际配置
# 生成强密码命令：openssl rand -base64 16
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=ReplaceWithStrongRandomPwd2024!
MONGO_INITDB_DATABASE=myappdb
MONGO_APP_USER=appuser
MONGO_APP_PASSWORD=AppUserStrongPwd2024!
MONGO_MEMORY_LIMIT=4g
MONGO_CPU_LIMIT=2
```

### 附录3：.env.prod.example 模板
```bash
# 生产环境环境变量模板
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=ReplaceWithStrongRandomPwd2024!
MONGO_INITDB_DATABASE=admin
MONGO_APP_USER=appuser
MONGO_APP_PASSWORD=AppUserStrongPwd2024!
MONGO_MEMORY_LIMIT=8g
MONGO_CPU_LIMIT=4
```

