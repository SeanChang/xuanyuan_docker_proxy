# Docker 部署 DbGate：一站式管理 MySQL、PostgreSQL、SQLite 等数据库

![Docker 部署 DbGate：一站式管理 MySQL、PostgreSQL、SQLite 等数据库](https://imgs.xuanyuan.cloud/docker/blog/dbgate.webp)

*分类: Docker部署教程 | 标签: DbGate,Docker,轩辕镜像, 数据库客户端,MySQL,PostgreSQL,MongoDB,私有化部署,部署教程 | 发布时间: 2026-07-29 06:54:22*

> DbGate 开源 跨平台数据库客户端（GPL-3.0）：可装桌面版，也可作为 Web 应用跑在 Docker 里。浏览器打开统一界面，连接多种 SQL / NoSQL，浏览表数据、跑 SQL、导入导出、保存脚本——连接与配置落在你自己的数据卷上。
> 

*本文基于 [dbgate/dbgate:7.2.3](https://xuanyuan.cloud/zh/r/dbgate/dbgate)，**Ubuntu 24.04** 实测。*

本机要管 MySQL、PostgreSQL、MongoDB……每个库装一套桌面客户端，换电脑又要重装，团队还要对齐版本。公有云「在线库管」省事，但连接串、查询历史落在厂商侧，内网断公网或合规要求「工具也要自托管」时就不好用了。

**DbGate** 是 [dbgate/dbgate](https://github.com/dbgate/dbgate) 维护的开源 **跨平台数据库客户端**（GPL-3.0）：可装桌面版，也可作为 **Web 应用**跑在 Docker 里。浏览器打开统一界面，连接多种 SQL / NoSQL，浏览表数据、跑 SQL、导入导出、保存脚本——连接与配置落在你自己的数据卷上。

上手要点：容器内固定监听 **3000**；不少机器宿主机 **3000 已被占用**（Node 服务、其他容器），实测裸映射会 `address already in use`，本文默认 **`3080:3000`**。要持久化连接与脚本，必须挂载 **`/root/.dbgate`**。社区版默认**无登录门禁**，勿把端口裸暴露公网。

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 拉取 **`dbgate/dbgate:7.2.3`**，`docker run` / Compose 拉起，浏览器新建连接、处理 Docker 下的主机名提示。**Ubuntu 24.04** 全程实测，文末附运维命令与 FAQ。

镜像说明见 [dbgate/dbgate 镜像页](https://xuanyuan.cloud/zh/r/dbgate/dbgate)，标签列表见 [tags](https://xuanyuan.cloud/r/dbgate/dbgate/tags)。官方文档：[docs.dbgate.io](https://docs.dbgate.io/)；Docker Hub：[dbgate/dbgate](https://hub.docker.com/r/dbgate/dbgate)。

---

## 一、DbGate 是什么？

**DbGate** 面向「要同时摸多套库、又希望用浏览器或轻量 Web 服务搞定」的场景：不是数据库服务器本身，而是**管理端**——连上已有的 MySQL / PostgreSQL / MongoDB 等，做浏览、查询、导入导出与脚本保存。

核心能力一览：

| 能力 | 说明 |
|------|------|
| 多库统一入口 | MySQL / MariaDB、PostgreSQL、SQL Server、Oracle、MongoDB、Redis、SQLite、ClickHouse、CockroachDB、Firebird、DuckDB、Cassandra 等 |
| Web 自托管 | 单容器即可；浏览器访问，无需每人装桌面客户端 |
| 数据浏览与编辑 | 表数据过滤、编辑；SQL / Mongo 脚本执行 |
| 可视化与导入导出 | 查询设计、图表、CSV / Excel / JSON 等导入导出 |
| 连接持久化 | 连接、脚本、归档等落在 `/root/.dbgate`（需挂载卷） |
| 可扩展 | 插件架构；企业能力见 Premium（本文仅社区版） |

典型场景：

- 开发 / 测试环境多库统一查看，少装几个桌面客户端
- 内网运维用浏览器查库，不把客户端装到每台笔记本
- 用环境变量预配置连接，给同事一套「打开就能用」的库入口

架构（本文单容器）：

```text
浏览器 ──HTTP:3080──▶ dbgate 容器(:3000)
                         │
              ./data ──▶ /root/.dbgate
                         │
              网络连出 ──▶ MySQL / PG / Mongo / …
```

> **版本与定位**：本文使用 **`dbgate/dbgate:7.2.3`**（社区版）。生产请固定三位版本号；需要 SQLite 时**不要**用 `alpine` 标签。勿长期依赖裸 `latest`。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux 建议 **Ubuntu 24.04**（本文实测） |
| Docker | Engine + Compose V2（`docker compose`） |
| 内存 | 演示建议 ≥ **512 MB～1 GB** 可用 |
| 磁盘 | 镜像约百余 MB + `./data` 增长 |
| 端口 | 宿主机 **3080** → 容器 **3000**（容器内固定 3000） |
| 目录 | `/www/wwwroot/dbgate`，数据子目录 `./data` → `/root/.dbgate` |

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

---

## 三、标签怎么选

| 标签 | 用途 | 推荐 |
|------|------|------|
| `7.2.3` | 固定稳定版（本文实测，与 `latest` 同源） | **试用 / 生产首选** |
| `latest` | 跟踪最新稳定 | 仅临时试用 |
| `7.2.3-alpine` / `alpine` | 体积更小 | 不需要 SQLite 时可考虑；**需要 SQLite 勿用** |
| `beta` | 预览 | **勿上生产** |

标签列表：[xuanyuan.cloud/r/dbgate/dbgate/tags](https://xuanyuan.cloud/r/dbgate/dbgate/tags)。

---

## 四、拉取镜像（轩辕加速）

上游为 Docker Hub（`docker.io`）。公共登录域 `docker.xuanyuan.run`：**首次**需 `docker login`；已登录则直接 pull。规范见 [agents.md](https://xuanyuan.cloud/agents.md)。

```bash
grep -q '"docker.xuanyuan.run"' ~/.docker/config.json && echo "已登录" || echo "未登录"
# 未登录时：
# docker login docker.xuanyuan.run
```

```bash
sudo mkdir -p /www/wwwroot/dbgate/data
cd /www/wwwroot/dbgate

docker pull docker.xuanyuan.run/dbgate/dbgate:7.2.3
```

实测拉取输出（**Ubuntu 24.04**）：

```text
7.2.3: Pulling from dbgate/dbgate
4f4fb700ef54: Pull complete
437216719022: Pull complete
92737e388c25: Pull complete
597c6c618d36: Pull complete
5ee2a0fd9637: Pull complete
e33bee2ce77b: Pull complete
f76f628bbc51: Pull complete
bb65bd65926c: Pull complete
392df1351ac2: Pull complete
fe0145bb94bc: Pull complete
e0ba890fa654: Download complete
Digest: sha256:f2dc7423ea88b6a7f07ab2232f42133393c26c77dfdf6754b9d7ce5fe991bd97
Status: Downloaded newer image for docker.xuanyuan.run/dbgate/dbgate:7.2.3
docker.xuanyuan.run/dbgate/dbgate:7.2.3
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `dbgate/dbgate:7.2.3` | `docker pull docker.xuanyuan.run/dbgate/dbgate:7.2.3` |

---

## 五、docker run 快速部署（跟做主路径）

### 5.1 端口说明（必读）

容器内进程监听 **3000**。若宿主机直接 `-p 3000:3000`，在已占用 3000 的机器上会失败，实测报错：

```text
docker: Error response from daemon: failed to set up container networking: ...
failed to bind host port 0.0.0.0:3000/tcp: address already in use
```

失败后可能留下同名容器，需先删再建。本文默认宿主机 **3080**：

```bash
# 查谁占用了 3000（可选）
ss -lntp | grep 3000

# 清理失败残留（若有）
docker rm -f dbgate 2>/dev/null || true
```

### 5.2 启动容器

```bash
cd /www/wwwroot/dbgate

docker run -d \
  --name dbgate \
  --restart always \
  -p 3080:3000 \
  -v /www/wwwroot/dbgate/data:/root/.dbgate \
  docker.xuanyuan.run/dbgate/dbgate:7.2.3
```

实测成功时返回容器 ID，例如：

```text
99bcf58940ed25f112271f15361bc89570224a40f7e43edbbe4e540bb48b01a8
```

参数说明：

| 配置 | 说明 |
|------|------|
| `-p 3080:3000` | 浏览器访问宿主机 **3080**；容器内仍是 3000 |
| `-v ...:/root/.dbgate` | 持久化连接、脚本、归档等 |
| `--restart always` | 宿主机重启后自动拉起 |
| `7.2.3` | 固定版本，避免 `latest` 漂移 |

确认状态：

```bash
docker ps | grep dbgate
docker logs --tail 50 dbgate
```

浏览器打开：

```text
http://你的服务器IP:3080
```

社区版**无默认账号密码**，打开即可进入界面。对公网开放前请加反向代理鉴权或限制来源 IP。

---

## 六、浏览器使用：新建连接

打开页面后，左侧为连接与数据库内容区；点击添加连接，进入 **New Connection**。

### 6.1 选择数据库引擎

在 **Connection Type** 下拉里选择目标库类型。社区版可见 MySQL、MariaDB、PostgreSQL、Microsoft SQL Server、OracleDB、SQLite、MongoDB、Redis、ClickHouse、DuckDB、Cassandra、Firebird、CockroachDB 等。

![DbGate 新建连接：展开 Connection Type，选择 MySQL / PostgreSQL / MongoDB 等引擎](https://imgs.xuanyuan.cloud/docker/blog/dbgate-1.webp)

选好类型后，按库填写主机、端口、用户名与密码（或 URL / 文件路径）。

### 6.2 填写主机：Docker 下不要用 localhost

以 **MySQL** 为例：Connection Mode 选 **Host and port**，Port 默认 `3306`。界面会提示：

> Under docker, localhost and 127.0.0.1 will not work, use **dockerhost** instead

也就是说：数据库若跑在**宿主机**或其他容器，在 DbGate 容器里填 `127.0.0.1` / `localhost` 只会指向 **DbGate 自己**，连不上宿主机上的库。官方提供的占位主机名是 **`dockerhost`**（也可按环境改用宿主机局域网 IP、Compose 服务名，或 `extra_hosts` 映射）。

![DbGate 配置 MySQL：Server 填 dockerhost、端口 3306，界面提示 Docker 下勿用 localhost](https://imgs.xuanyuan.cloud/docker/blog/dbgate-2.webp)

填写 User / Password，可选 Default database、Display name、颜色标签，然后测试连接并保存。保存后的连接会出现在左侧 **CONNECTIONS**；配置落在挂载的 `/root/.dbgate`，重启容器不丢。

连上后可在左侧展开库表、打开 SQL 编辑器执行查询、做导入导出等日常操作。

---

## 七、Docker Compose 部署

适合希望把编排写进仓库、或预配置多条连接的场景。

```bash
sudo mkdir -p /www/wwwroot/dbgate
cd /www/wwwroot/dbgate
```

### 7.1 方案 B1：持久化 + UI 手配连接（推荐跟做）

不设 `CONNECTIONS`，连接在浏览器里配，数据落在 `./data`：

```yaml
# /www/wwwroot/dbgate/compose.yml
services:
  dbgate:
    image: docker.xuanyuan.run/dbgate/dbgate:7.2.3
    container_name: dbgate
    restart: always
    ports:
      - "3080:3000"
    volumes:
      - ./data:/root/.dbgate
```

```bash
docker compose -f /www/wwwroot/dbgate/compose.yml up -d
```

### 7.2 方案 B2：环境变量预配置多连接（可选）

适合「打开页面已有连接列表」的内网交付。`SERVER_*` 填可达地址（同 Compose 网络内用服务名；宿主机库见 FAQ）。密码请改成真实值：

```yaml
# /www/wwwroot/dbgate/compose.yml
services:
  dbgate:
    image: docker.xuanyuan.run/dbgate/dbgate:7.2.3
    container_name: dbgate
    restart: always
    ports:
      - "3080:3000"
    volumes:
      - ./data:/root/.dbgate
    environment:
      CONNECTIONS: con1,con2,con3

      LABEL_con1: MySQL
      SERVER_con1: mysql
      USER_con1: root
      PASSWORD_con1: CHANGE_ME
      PORT_con1: "3306"
      ENGINE_con1: mysql@dbgate-plugin-mysql

      LABEL_con2: PostgreSQL
      SERVER_con2: postgres
      USER_con2: postgres
      PASSWORD_con2: CHANGE_ME
      PORT_con2: "5432"
      ENGINE_con2: postgres@dbgate-plugin-postgres

      LABEL_con3: MongoDB
      URL_con3: mongodb://mongo:27017
      ENGINE_con3: mongo@dbgate-plugin-mongo
```

常用 `ENGINE_*`：

| 数据库 | ENGINE 值 |
|--------|-----------|
| MySQL | `mysql@dbgate-plugin-mysql` |
| PostgreSQL | `postgres@dbgate-plugin-postgres` |
| SQL Server | `mssql@dbgate-plugin-mssql` |
| MongoDB | `mongo@dbgate-plugin-mongo` |
| SQLite | `sqlite@dbgate-plugin-sqlite`（配 `FILE_<名>`；勿用 alpine） |

> **注意**：用环境变量预配置连接时，仍建议挂载 `/root/.dbgate` 以持久化脚本与其它应用数据。是否与 UI 手动连接混用，以官方行为为准；交付环境优先二选一，避免配置来源混乱。

运维：

```bash
docker compose -f /www/wwwroot/dbgate/compose.yml ps
docker compose -f /www/wwwroot/dbgate/compose.yml logs -f
docker compose -f /www/wwwroot/dbgate/compose.yml down
```

---

## 八、运维命令速查

```bash
# 状态 / 日志
docker ps | grep dbgate
docker logs -f dbgate

# 重启 / 停止 / 删除容器（数据在卷里，删容器不删 ./data）
docker restart dbgate
docker stop dbgate
docker rm -f dbgate

# 备份连接与脚本（停服或短暂停写更稳妥）
tar -czf dbgate-data-$(date +%F).tar.gz -C /www/wwwroot/dbgate data

# 换端口示例（先 rm 再 run）
docker rm -f dbgate
docker run -d --name dbgate --restart always -p 3081:3000 \
  -v /www/wwwroot/dbgate/data:/root/.dbgate \
  docker.xuanyuan.run/dbgate/dbgate:7.2.3
```

---

## 九、常见问题 FAQ

### 9.1 `address already in use` / 3000 端口占用

宿主机 3000 被占用时，`-p 3000:3000` 会失败。改用空闲口，例如 `-p 3080:3000`。失败后执行 `docker rm -f dbgate` 再重新 `docker run`。排查：`ss -lntp | grep 3000`。

### 9.2 连接填 localhost 连不上

DbGate 跑在容器内时，`localhost` / `127.0.0.1` 指向容器自己。连宿主机上的库：按界面提示用 **`dockerhost`**，或填宿主机局域网 IP / 网关；同 Compose 网络内填**服务名**。Linux 也可在 `docker run` 加 `--add-host=dockerhost:host-gateway`（Docker 20.10+）以增强解析可靠性。

### 9.3 重启后连接、脚本没了

未挂载 `/root/.dbgate`。按本文 `-v /www/wwwroot/dbgate/data:/root/.dbgate` 或 Compose `volumes` 挂上后，在 UI 里重新保存一次连接。

### 9.4 要用 SQLite，能选 alpine 吗？

官方明确：**需要 SQLite 时不要用 alpine 镜像**。请用本文默认的 `7.2.3`（非 alpine）。

### 9.5 社区版有没有默认登录密码？

社区版 Web 镜像默认**无应用层登录门禁**，能打开页面就能用。切勿裸奔公网；生产请反向代理 + 鉴权，或仅内网访问。企业协作与权限见 Premium。

### 9.6 `cd cd /www/wwwroot/dbgate` 报错

多敲了一个 `cd`，会变成 `cd: too many arguments`。正确：`cd /www/wwwroot/dbgate`。

---

## 十、延伸阅读

- 轩辕镜像页：[dbgate/dbgate](https://xuanyuan.cloud/zh/r/dbgate/dbgate)
- Docker Hub：[dbgate/dbgate](https://hub.docker.com/r/dbgate/dbgate)
- 源码：[github.com/dbgate/dbgate](https://github.com/dbgate/dbgate)
- 文档：[docs.dbgate.io](https://docs.dbgate.io/)
- 插件开发（进阶）：[plugin-development](https://docs.dbgate.io/plugin-development)
- 轩辕 Agent 拉取规范：[agents.md](https://xuanyuan.cloud/agents.md)


