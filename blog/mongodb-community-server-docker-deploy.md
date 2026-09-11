# Docker 部署 MongoDB Community Server：轻松搭建文档数据库平台

![Docker 部署 MongoDB Community Server：轻松搭建文档数据库平台](https://imgs.xuanyuan.cloud/docker/blog/mongodb-server.webp)

*分类: Docker部署教程 | 标签: MongoDB,mongodb-community-server,Docker,轩辕镜像,文档数据库,NoSQL,私有化部署,部署教程 | 发布时间: 2026-09-08 07:14:20*

> MongoDB Community Server 是 MongoDB 公司维护的免费开源文档数据库，以 JSON/BSON 灵活建模，适合 Web 后端、移动应用与半结构化数据场景。本文将介绍如何通过 Docker Compose 快速部署 mongodb/mongodb-community-server，轻松搭建可自托管的文档库单节点，适合开发联调、内网试点与教学实验等场景。

*本文基于 [mongodb/mongodb-community-server:8.3.8-ubi9-slim](https://xuanyuan.cloud/zh/r/mongodb/mongodb-community-server)，实测引擎 **MongoDB 8.3.8**，测试平台 **Ubuntu 24.04** Linux。*

接口文档里字段下周又要加三个可选属性；关系库一改 schema，迁移脚本、ORM、联调环境一起抖。更常见的画面是：订单详情嵌一套物流轨迹、用户画像塞一堆标签数组——硬拆多表 JOIN，改一次字段要动一串表。开发机再各装一份本机 MongoDB，版本对不齐，周末联调卡在「你连不上我的库」。

出域托管也不总是答案。机房内网、等保、客户合同里的「数据不出域」，往往要求文档库落在自己的盘上。很多团队已经有一台跑 Docker 的 Ubuntu，缺的是：**镜像能拉下来、root 与数据卷设好、`mongosh` 能跑通第一条命令**——而不是先上整套副本集。

**MongoDB Community Server**（[官网](https://www.mongodb.com/)、[文档](https://www.mongodb.com/docs/)）是 MongoDB 公司提供的免费开源文档数据库：BSON/JSON 存储，集合结构灵活，查询与聚合开箱可用。本文用官方组织镜像 **`mongodb/mongodb-community-server`**（[镜像页](https://xuanyuan.cloud/zh/r/mongodb/mongodb-community-server)）：协议口 **27017**，数据目录 **`/data/db`**。同站还有 Official Image [`library/mongo`](https://xuanyuan.cloud/r/library/mongo)（短名常写 `mongo`），选型见 **§1.1**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 开发 / 联调 | 应用连 `mongodb://账号:密码@服务器IP:27017/?authSource=admin` |
| 交互验证 | `docker exec … mongosh` 建库、插文档、查集合 |
| Compass | 本机 [MongoDB Compass](https://www.mongodb.com/products/tools/compass) 填连接串浏览 |
| 备份 | `mongodump` / `mongorestore`，或备份 Compose 命名卷 |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`mongodb/mongodb-community-server:8.3.8-ubi9-slim`**，**Docker Compose** 做主路径：命名卷持久化、设 root、映射 **27017**。文中密码请换成你的。无 Compose 见第八节。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第八节 `docker run`
> - **CPU**：MongoDB **5.0+** 需要 **AVX**；先跑 §2.1
> - **端口**：宿主机 **27017** → 容器 **27017**
> - **标签**：跟做 **`8.3.8-ubi9-slim`**；勿写 `latest`
> - **账号**：空卷首次启动设 `MONGODB_INITDB_ROOT_USERNAME` / `MONGODB_INITDB_ROOT_PASSWORD`（成对）
> - **数据**：默认命名卷 `mongodb_data` → `/data/db`；绑定挂载须 **`chown 1000:1000`**（本镜像实测 uid）
> - **连接**：`authSource=admin`；客户端用 **`mongosh`**（不是旧版 `mongo`）
> - **工作目录**：Linux `/www/wwwroot/mongodb-community-server`；macOS 跟做用 `~/docker/mongodb-community-server`
> - **暴露**：勿把 27017 裸暴露公网

官方：[Docker 兼容性说明](https://www.mongodb.com/compatibility/docker) · [镜像页](https://xuanyuan.cloud/zh/r/mongodb/mongodb-community-server) · [标签列表](https://xuanyuan.cloud/r/mongodb/mongodb-community-server/tags) · [许可证 SSPL](https://www.mongodb.com/legal/licensing/server-side-public-license)

---

## 一、MongoDB Community Server 镜像是什么？

`mongodb/mongodb-community-server` 是 MongoDB 官方组织维护的 Community Server 容器：无安装向导式 Web 后台，验证靠 **`mongosh`**、驱动或 Compass。容器内跑 `mongod`，默认监听 **27017**。

| | 本文（Community 自托管） | 关系库（MySQL / PostgreSQL） | 云托管文档库 |
|--|--------------------------|------------------------------|--------------|
| 模型 | 文档 / 嵌套结构 | 表 + schema | 厂商托管 |
| 适合 | 字段常变、半结构化、快速联调 | OLTP、强规范化 | 少运维、开箱集群 |
| 数据 | 落本机卷 | 本机或托管 | 通常出域 |
| 代价 | 自己盯磁盘、备份、认证 | 改结构成本常更高 | 合规与出域成本 |

```text
应用 / 驱动 / Compass   ──:27017──▶  mongod
mongosh（容器内）        ──本机──▶  同上
mongodb_data（命名卷）   ──挂载──▶  /data/db
```

[`/r/`](https://xuanyuan.cloud/r/mongodb/mongodb-community-server) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/mongodb/mongodb-community-server) 为同一镜像的不同页面语言。同组织还有 Enterprise、Atlas Local 等镜像，**本文只用 `mongodb/mongodb-community-server:8.3.8-ubi9-slim`**。

### 1.1 与 `library/mongo` 怎么选

| | **本文 `mongodb/mongodb-community-server`** | **对照 `library/mongo`（短名 `mongo`）** |
|--|---------------------------------------------|------------------------------------------|
| 坐标 | MongoDB 官方组织镜像 | Docker Official Image |
| 拉取 | `docker.xuanyuan.run/mongodb/mongodb-community-server:…` | `docker.xuanyuan.run/library/mongo:…` |
| 协议 / 数据 | **27017**；数据 **`/data/db`** | 同类习惯，标签体系不同 |
| 环境变量 | 本文用 **`MONGODB_INITDB_*`**（旧名 `MONGO_INITDB_*` 已弃用） | 常见仍写 `MONGO_INITDB_*`，以该镜像文档为准 |
| 跟做版本 | 固定 **`8.3.8-ubi9-slim`** | 常见 `8.0` / `7.0` 等，需自行核对 |

要跟官方组织镜像并切到 **ubi9-slim** 时用本文；脚本已写死 `mongo:` 短名则继续用 `library/mongo`，**整篇命令用同一坐标**。已有数据目录不要仅为换教程改镜像名。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2**；建议 ≥ **20.10** |
| CPU | x86_64 须 **AVX**（MongoDB **5.0+**；见 §2.1） |
| 内存 | ≥ **1～2 GB** 可用（业务负载再加） |
| 磁盘 | 镜像约 **160MB** 内容 / 本地约 **658MB** + 数据增长 |
| 端口 | 宿主机 **27017** |
| 工作目录 | `/www/wwwroot/mongodb-community-server` |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

### 2.1 部署前自检 CPU（强制）

先跑本节再 `compose up`。自 **MongoDB 5.0** 起，官方要求 x86_64 具备 **AVX**。无 AVX 时日志常出现：

```text
WARNING: MongoDB 5.0+ requires a CPU with AVX support, and your current system does not appear to have that!
```

随后可能 `Could not init database`、容器反复重启，或 `Illegal instruction`。改密码、改端口无效。

```bash
grep -o 'avx[^ ]*' /proc/cpuinfo | sort -u | head -5 || echo 'AVX NOT found'
lscpu | grep -E 'Model name|Flags|Hypervisor'
```

| 结果 | 说明 |
|------|------|
| 有 **`avx`** | 可跟做本文 **`8.3.8-ubi9-slim`** |
| **`AVX NOT found`** | 换带 AVX 的机器，或虚拟机 CPU **host / 透传** |
| 仅有 SSE4.2、无 AVX | 不够；与 ClickHouse「SSE4.2 可跑部分版本」不同 |

Ubuntu 实测主机 `grep` 输出含 **`avx`**。宿主机 **27017** 已被占用时，Compose 改为 `"27018:27017"`，连接串同步改端口。

---

## 三、标签怎么选

跟做使用 **`8.3.8-ubi9-slim`**。完整列表：[tags](https://xuanyuan.cloud/r/mongodb/mongodb-community-server/tags)。

官方 Hub 说明摘要：优先 **`-slim`**；**Ubuntu / ubi8** 底将停系统安全更新，新部署切 **ubi9-slim**。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`8.3.8-ubi9-slim`** | 8.3.8 + UBI9 slim | **本文跟做** |
| `8.3-ubi9-slim` | 8.3 线滚动 | 不如完整号稳 |
| `8.0.x-ubi9-slim` | 8.0 维护线 | 需对齐兼容时再选，固定完整号 |
| `*-ubuntu2204` / `*-ubi8` | 旧底 | 勿作新部署默认 |
| `*-ubi9`（无 slim） | 非 slim | 将弃用；优先 slim |
| `9.0.0-rc*` | 预发布 | 仅尝鲜 |
| `latest` | 浮动 | **勿写入跟做命令** |

升级时同步改 pull、Compose、`docker run` 三处标签，并核对 [发布说明](https://www.mongodb.com/docs/manual/release-notes/)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
```

Ubuntu 24.04 实测：

```text
8.3.8-ubi9-slim: Pulling from mongodb/mongodb-community-server
75a7b57f1782: Pull complete
3636a4275722: Pull complete
bd780394f86d: Pull complete
6f0ad5753830: Pull complete
bfafcb1cd33b: Pull complete
521533efc0e5: Pull complete
d1613c2fa987: Pull complete
802771381ab8: Pull complete
205b55f9489a: Pull complete
27fd970ac2a2: Pull complete
Digest: sha256:b0cfefcaa188fd33de12e5ca460f1b5e40fd785b958d2c7a8117943b88cfa395
Status: Downloaded newer image for docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
```

```bash
docker images docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
```

```text
IMAGE                                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim   b0cfefcaa188        658MB          160MB
```

---

## 五、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/mongodb-community-server`（macOS 跟做用 `~/docker/mongodb-community-server`）。

### 5.1 创建目录

```bash
sudo mkdir -p /www/wwwroot/mongodb-community-server
cd /www/wwwroot/mongodb-community-server
```

默认用 **Docker 命名卷** 存数据，避免绑定挂载 uid 不匹配。本镜像实测进程用户为 **`uid=1000(mongod)`**（不是常见的 999）；绑定挂载见 §5.4。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  mongodb:
    image: docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
    container_name: mongodb-community
    restart: unless-stopped
    ports:
      - "27017:27017"
    environment:
      TZ: Asia/Shanghai
      MONGODB_INITDB_ROOT_USERNAME: mongoadmin
      MONGODB_INITDB_ROOT_PASSWORD: Changeme_Mongo_2026
    volumes:
      - mongodb_data:/data/db
    healthcheck:
      test:
        [
          "CMD",
          "mongosh",
          "--quiet",
          "-u",
          "mongoadmin",
          "-p",
          "Changeme_Mongo_2026",
          "--authenticationDatabase",
          "admin",
          "--eval",
          "db.adminCommand('ping').ok",
        ]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 40s

volumes:
  mongodb_data:
EOF
```

| 项 | 作用 |
|----|------|
| `"27017:27017"` | 协议口 |
| `MONGODB_INITDB_ROOT_*` | **仅空卷首次启动**时创建 root 并开认证；须成对 |
| `mongodb_data → /data/db` | 命名卷持久化 |
| 密码 | **仅跟做**；上线改强密码 |

### 5.3 启动与验证

确认 §2.1 有 **AVX** 后：

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 实测：

```text
[+] up 3/3
 ✔ Network mongodb-community-server_default     Created
 ✔ Volume mongodb-community-server_mongodb_data Created
 ✔ Container mongodb-community                  Started

NAME                IMAGE                                                                  COMMAND                  SERVICE   CREATED         STATUS                            PORTS
mongodb-community   docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim   "/usr/local/bin/dock…"   mongodb   4 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:27017->27017/tcp, [::]:27017->27017/tcp
```

日志关键行（完整 JSON 较长，摘录）：

```text
MongoDB init process complete; ready for start up.
...
"msg":"MongoDB starting",..."port":27017,"dbPath":"/data/db"...
"msg":"Build Info",..."version":"8.3.8"...
"msg":"Options set by command line",..."net":{"bindIp":"*"},"security":{"authorization":"enabled"}...
```

首次初始化约数十秒；`health: starting` 正常，稍后可为 `healthy`。若 `Permission denied` 写 `journal`，见 FAQ。

冒烟：

```bash
docker exec -it mongodb-community mongosh \
  -u mongoadmin -p 'Changeme_Mongo_2026' \
  --authenticationDatabase admin \
  --eval 'db.version()'
```

实测：

```text
8.3.8
```

写入与查询（heredoc 用 **`-i`**，不要加 **`-t`**）：

```bash
docker exec -i mongodb-community mongosh \
  -u mongoadmin -p 'Changeme_Mongo_2026' \
  --authenticationDatabase admin <<'JS'
use demo
db.orders.insertOne({ order_id: "A1001", items: ["sku-1", "sku-2"], total: 99.5 })
db.orders.find().pretty()
JS
```

实测节选：

```text
Using MongoDB:     8.3.8
Using Mongosh:     2.6.0
...
switched to db demo
{
  acknowledged: true,
  insertedId: ObjectId('6a9fb363edaad97dfa8ce5b0')
}
[
  {
    _id: ObjectId('6a9fb363edaad97dfa8ce5b0'),
    order_id: 'A1001',
    items: [ 'sku-1', 'sku-2' ],
    total: 99.5
  }
]
```

`mongosh` 可能提示推荐 XFS、调整 swappiness 等，开发跟做可忽略。

连接串（应用 / Compass）：

```text
mongodb://mongoadmin:Changeme_Mongo_2026@服务器IP:27017/?authSource=admin
```

把 IP 与密码换成你的；密码含特殊字符时注意 URL 编码。

### 5.4 可选：绑定挂载 `./data`

需要固定宿主机路径时：

```bash
docker run --rm --entrypoint id \
  docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
# 实测：uid=1000(mongod) gid=1000(mongod) groups=1000(mongod)

sudo mkdir -p /www/wwwroot/mongodb-community-server/data
sudo chown -R 1000:1000 /www/wwwroot/mongodb-community-server/data
```

Compose 改为：

```yaml
    volumes:
      - ./data:/data/db
```

并去掉文件末尾的 `volumes: mongodb_data:`。其它标签以 `id` 输出为准。

---

## 六、客户端与常用操作

### 6.1 交互 mongosh

```bash
docker exec -it mongodb-community mongosh \
  -u mongoadmin -p 'Changeme_Mongo_2026' \
  --authenticationDatabase admin
```

进入后只输入 mongosh 语句（不要粘文档里的 `# 注释`，会 `SyntaxError`；注释用 `//`）：

```javascript
show dbs
use appdb
db.users.insertOne({ name: "alice", roles: ["editor"] })
db.users.find({ name: "alice" })
```

Ubuntu 实测：

```text
test> show dbs
admin   100.00 KiB
config   12.00 KiB
demo     40.00 KiB
local    72.00 KiB

test> use appdb
switched to db appdb

appdb> db.users.insertOne({ name: "alice", roles: ["editor"] })
{
  acknowledged: true,
  insertedId: ObjectId('6a9fb3c658f73e06828ce5b0')
}

appdb> db.users.find({ name: "alice" })
[
  {
    _id: ObjectId('6a9fb3c658f73e06828ce5b0'),
    name: 'alice',
    roles: [ 'editor' ]
  }
]
```

### 6.2 Compass（可选）

安装 [MongoDB Compass](https://www.mongodb.com/products/tools/compass)，粘贴第五节连接串，确认可见 `admin` / 业务库。非部署必选项。

### 6.3 初始化脚本（可选）

空卷首次启动时，可将 `*.js` / `*.sh` 挂到 `/docker-entrypoint-initdb.d` 做种子数据。Compose 示例：

```yaml
    volumes:
      - mongodb_data:/data/db
      - ./initdb:/docker-entrypoint-initdb.d:ro
```

**已有数据的卷不会再次执行**这些脚本。

---

## 七、安全与生产加固

| 项 | 建议 |
|----|------|
| 密码 | 强密码；勿用文中占位串上公网 |
| 暴露面 | 优先内网 / VPN；公网务必限源 |
| 认证 | 应用用最小权限业务用户，勿共用 root |
| 备份 | 定期 `mongodump`；命名卷可用 `docker volume inspect` 找挂载点 |
| 改密 | `MONGODB_INITDB_*` 只在首次初始化生效；事后用 `mongosh` 改用户 |
| 高可用 | 本文为单节点开发 / 轻量自托管；生产副本集、分片请按官方运维文档，或评估 Enterprise / Atlas |

---

## 八、备选：docker run

```bash
docker volume create mongodb_data

docker run -d \
  --name mongodb-community \
  --restart unless-stopped \
  -p 27017:27017 \
  -e TZ=Asia/Shanghai \
  -e MONGODB_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGODB_INITDB_ROOT_PASSWORD=Changeme_Mongo_2026 \
  -v mongodb_data:/data/db \
  docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
```

验证同第五节。长期建议迁回 Compose。

---

## 九、升级与迁移

1. 备份（`mongodump`，或停写后备份命名卷 / `./data`）。  
2. 改 Compose（及 run）中的完整标签。  
3. `docker compose pull && docker compose up -d`。  
4. `db.version()` 与业务冒烟。  

跨大版本先读官方 release notes。

---

## 十、常见问题 FAQ

**Q：拉 `latest` 还是具体版本？**  
A：跟做与生产都用 **`8.3.8-ubi9-slim`**。其它版本到 [标签列表](https://xuanyuan.cloud/r/mongodb/mongodb-community-server/tags) 选完整号 + **ubi9-slim**。

**Q：为何不用官方旧文常见的 `8.0-ubi8`？**  
A：Hub 已说明 Ubuntu / ubi8 将停系统安全更新，非 slim 也将弃用。新部署直接用 **`8.3.8-ubi9-slim`**。

**Q：日志警告无 AVX / 或 `Permission denied` 写 journal？**  
A：先 `grep avx`（§2.1）。无 AVX 就换机或 CPU 透传。有 AVX 仍起不来时，看是否绑定挂载权限：本镜像为 **`uid=1000`**，`chown 999:999` 会失败。优先改用第五节命名卷；绑定挂载则：

```bash
cd /www/wwwroot/mongodb-community-server
docker compose down
sudo chown -R 1000:1000 ./data   # 以 entrypoint id 为准
```

权限失败时日志里也可能夹带 AVX 警告，以 `grep` 结果与真正的 ERROR 为准。

**Q：`MONGO_INITDB_* is deprecated`？**  
A：改用 **`MONGODB_INITDB_ROOT_USERNAME` / `MONGODB_INITDB_ROOT_PASSWORD`**。

**Q：设了密码却 Authentication failed？**  
A：① 漏 `authSource=admin`；② 卷非空，`MONGODB_INITDB_*` 未生效；③ 密码不一致。空卷重建，或手动 `createUser`。

**Q：改了 Compose 密码，旧密码仍能登录？**  
A：正常。初始化变量只跑一次；用 `mongosh` 改密，或清空卷重建（丢数据）。

**Q：和 `library/mongo` 有何不同？**  
A：见 **§1.1**。勿混用两套镜像坐标。

**Q：没有 `mongo` 命令？**  
A：用 **`mongosh`**。

**Q：`docker exec -it … <<'JS'` 报 stdin / TTY 错误？**  
A：heredoc 用 **`docker exec -i`**（去掉 `-t`），或改用 `--eval`。

**Q：mongosh 里粘 `# 列出库` 报 SyntaxError？**  
A：`#` 是 bash 注释，不要贴进 mongosh；注释用 `//`。

**Q：这条 Compose 能当生产副本集？**  
A：不能直接当。本文是单节点入门；副本集 / 分片另按官方文档设计。

---

## 十一、命令速查

```bash
# CPU
grep -o 'avx[^ ]*' /proc/cpuinfo | sort -u | head -5 || echo 'AVX NOT found'

# 拉取
docker pull docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim

# Compose
cd /www/wwwroot/mongodb-community-server
docker compose up -d
docker compose ps
docker compose logs -f --tail=100
docker compose down

# mongosh
docker exec -it mongodb-community mongosh \
  -u mongoadmin -p 'Changeme_Mongo_2026' \
  --authenticationDatabase admin \
  --eval 'db.version()'

# 备选 run
docker volume create mongodb_data
docker run -d --name mongodb-community -p 27017:27017 \
  -e MONGODB_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGODB_INITDB_ROOT_PASSWORD=Changeme_Mongo_2026 \
  -v mongodb_data:/data/db \
  docker.xuanyuan.run/mongodb/mongodb-community-server:8.3.8-ubi9-slim
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [mongodb/mongodb-community-server 镜像页](https://xuanyuan.cloud/zh/r/mongodb/mongodb-community-server) | [https://xuanyuan.cloud/zh/r/mongodb/mongodb-community-server](https://xuanyuan.cloud/zh/r/mongodb/mongodb-community-server) |
| [镜像概览](https://xuanyuan.cloud/r/mongodb/mongodb-community-server) | [https://xuanyuan.cloud/r/mongodb/mongodb-community-server](https://xuanyuan.cloud/r/mongodb/mongodb-community-server) |
| [标签列表](https://xuanyuan.cloud/r/mongodb/mongodb-community-server/tags) | [https://xuanyuan.cloud/r/mongodb/mongodb-community-server/tags](https://xuanyuan.cloud/r/mongodb/mongodb-community-server/tags) |
| [Docker 与 MongoDB 官方说明](https://www.mongodb.com/compatibility/docker) | [https://www.mongodb.com/compatibility/docker](https://www.mongodb.com/compatibility/docker) |
| [MongoDB 文档](https://www.mongodb.com/docs/) | [https://www.mongodb.com/docs/](https://www.mongodb.com/docs/) |
| [Docker Hub · mongodb/mongodb-community-server](https://hub.docker.com/r/mongodb/mongodb-community-server) | [https://hub.docker.com/r/mongodb/mongodb-community-server](https://hub.docker.com/r/mongodb/mongodb-community-server) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- **`mongodb/mongodb-community-server`**：官方 Community 文档库，**27017**，数据 **`/data/db`**。  
- 跟做 **`8.3.8-ubi9-slim`**，轩辕镜像加速拉取；主路径 Compose + **命名卷**。  
- 须有 **AVX**；空卷设 **`MONGODB_INITDB_ROOT_*`**；连接加 **`authSource=admin`**。  
- `db.version()` 与写入通过后再接业务。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/mongodb-community-server-docker-deploy


