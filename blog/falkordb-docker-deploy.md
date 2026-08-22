# Docker 部署 FalkorDB：轻松搭建属性图数据库与知识图谱平台

![Docker 部署 FalkorDB：轻松搭建属性图数据库与知识图谱平台](https://assets.xuanyuan.me/docker/blog/falkordb.webp)

*分类: Docker部署教程 | 标签: FalkorDB,Docker,轩辕镜像,图数据库,知识图谱,OpenCypher,KG-RAG,私有化部署,部署教程 | 发布时间: 2026-08-05 03:37:24*

> 做推荐、风控、组织架构或运维资产盘点时，数据往往不是「一张宽表」就能说清：用户关注过哪些商品、设备挂在哪台机柜、服务依赖哪些上游、知识库里实体之间差几跳——这些都是多跳关系。用 MySQL / PostgreSQL 硬拼 JOIN，查询难写、改一次业务就要改一串表；排查时还要在代码、Wiki、Excel 之间对账，关系一复杂就容易漏边。

*本文基于 [falkordb/falkordb:latest](https://xuanyuan.cloud/zh/r/falkordb/falkordb)，实测引擎 **FalkorDB v4.20.1**，底层 Redis **8.6.3**，测试平台 **Ubuntu 24.04** Linux。*

做推荐、风控、组织架构或运维资产盘点时，数据往往不是「一张宽表」就能说清：用户关注过哪些商品、设备挂在哪台机柜、服务依赖哪些上游、知识库里实体之间差几跳——这些都是 **多跳关系**。用 MySQL / PostgreSQL 硬拼 JOIN，查询难写、改一次业务就要改一串表；排查时还要在代码、Wiki、Excel 之间对账，关系一复杂就容易漏边。

做 LLM 应用时又多了一层诉求：希望把业务知识建成 **知识图谱**，用图查询做检索增强（KG-RAG），还要 **延迟低、能私有化**。图谱若只能跑在厂商托管图库上，内网语料、客户关系、机房拓扑一类数据就不适合出域；自建若只剩「重型图平台 + 复杂运维」，小团队又扛不住授权与资源成本。

不少团队真正需要的其实很具体：**用熟悉的 Cypher 就能查图、用常见 Redis 客户端就能连、浏览器里能看见节点和边，数据落在自己的服务器上**。不必一上来就上完整企业图平台。

**FalkorDB** 正是面向这类需求的开源 **可查询属性图数据库**：图以稀疏矩阵表示邻接关系，查询语言基于 **OpenCypher**（含专有扩展），也明确面向低延迟知识图谱 / KG-RAG 场景。社区镜像 **`falkordb/falkordb`**（见 [镜像页](https://xuanyuan.cloud/zh/r/falkordb/falkordb)）在同一容器内集成 **图引擎 + FalkorDB Browser**——协议口跑 `GRAPH.QUERY`，浏览器里建图、写 Cypher、看画布，适合开发联调与自托管原型。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 关系数据自托管 | Compose 拉起后，用 Browser 或 `redis-cli` 建图、写 Cypher，数据落在本机卷 |
| KG-RAG / 知识图谱原型 | 把实体与关系写入图，低延迟查询路径与邻居，再对接自己的 LLM 流水线 |
| 可视化排查 | 浏览器打开 **:13300**，在画布上看节点、边与查询结果，少靠纯日志猜结构 |
| 应用对接 | 任意 Redis 客户端发 `GRAPH.*`；Python 等可用 `redis-py` 调原始命令 |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`falkordb/falkordb:latest`**，**Docker Compose** 映射 **6379**（协议）与宿主机 **13300**（Browser，容器内 3000），完成登录、建图与 Cypher 演示；另附 `redis-cli` 验证与 **`docker run` 备选**。全程可跟做，文内附 **11** 张实测界面截图。

> **上手要点**  
> - **部署**：默认 **Compose**（第五节）；临时试玩见 **第十节 docker run**  
> - **端口**：宿主机 **6379**、**13300→3000**（Browser；不占用宿主机 3000）  
> - **数据卷**：宿主机 `./data` → 容器 **`/var/lib/falkordb/data`**  
> - **登录**：Browser 填 Host `localhost`、Port `6379`；未设密码时 Username / Password **留空**（勿填占位文案 `Default`）  
> - **标签**：跟做用 `latest`（实测引擎 **v4.20.1**）；生产钉版本，对外暴露 Browser 建议 **≥ v4.14.9**  
> - **生产**：加 `REDIS_ARGS=--requirepass … --appendonly yes`，勿把 6379 裸暴露公网；日志里的 `vm.overcommit_memory` 见 FAQ  

镜像说明见 [falkordb/falkordb](https://xuanyuan.cloud/zh/r/falkordb/falkordb)，标签列表见 [tags](https://xuanyuan.cloud/r/falkordb/falkordb/tags)。官方文档：[Docker](https://docs.falkordb.com/operations/docker.html)、[Persistence](https://docs.falkordb.com/operations/durability/persistence.html)、[Browser](https://docs.falkordb.com/browser/)。项目：[GitHub · FalkorDB](https://github.com/FalkorDB/FalkorDB)，示例：[demo](https://github.com/FalkorDB/FalkorDB/tree/master/demo)。

---

## 一、FalkorDB 是什么？

| 能力 | 说明 |
|------|------|
| 属性图 | 节点可多标签、关系有类型，均可带属性 |
| 查询 | OpenCypher；经 Redis 协议调用 `GRAPH.QUERY` 等 |
| Browser | Web UI：画布、查询编辑器、图管理、设置与用户 |
| 典型用途 | 知识图谱 / KG-RAG、关系分析、图谱原型 |

| 方案 | 适合 |
|------|------|
| **FalkorDB（本文）** | 要自托管图库 + 可选 Browser，部署轻 |
| Neo4j 等 | 要完整企业图平台与重工具链 |
| 纯关系库 JOIN | 关系极浅、暂不引入图库 |

同组织相关镜像：[falkordb-server](https://xuanyuan.cloud/r/falkordb/falkordb-server)（仅引擎）、[falkordb-browser](https://xuanyuan.cloud/r/falkordb/falkordb-browser)（独立 UI）。

```text
redis-cli / SDK  ──:6379──▶  FalkorDB（GRAPH.*）
浏览器           ──:13300──▶  Browser（容器内 :3000）
./data           ──挂载──▶  /var/lib/falkordb/data
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **1～2 GB** 可用（随图规模增加） |
| 磁盘 | 镜像约 **159MB**（本地占用约 **613MB**）+ 数据增长 |
| 端口 | 宿主机 **6379**、**13300** |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```


备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```
更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

> 宿主机 6379 已被占用时，Compose 改为 `"6380:6379"`，客户端用 `-p 6380`。Browser 宿主机口可改，保持 `宿主机端口:3000` 即可。

---

## 三、标签怎么选

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`latest`** | 跟随稳定线 | 跟做 / 实验室（本文） |
| **`vX.Y.Z`** | 固定发布 | **生产**；Browser 相关修复选 **≥ v4.14.9** |
| `edge` | 较新构建 | 仅尝鲜 |

完整列表：[tags](https://xuanyuan.cloud/r/falkordb/falkordb/tags)。镜像页注明 React2Shell（CVE-2025-55182）自 **v4.14.9** 起修复。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/falkordb/falkordb:latest
```

Ubuntu 24.04 实测：

```text
latest: Pulling from falkordb/falkordb
4f4fb700ef54: Pull complete
fa04bbe9fc8e: Pull complete
0330f12055c2: Pull complete
6795ca2d298c: Pull complete
8211d5969d2e: Pull complete
2f452c1ad809: Pull complete
19e7049df5a3: Pull complete
766331f05d2e: Pull complete
bbe46012c3a6: Pull complete
7556589f74c9: Pull complete
02280df0d84b: Pull complete
80cf12396ee3: Pull complete
528dc8790f46: Pull complete
5f5a4bd80419: Pull complete
9861bb45faf6: Pull complete
83822391ea97: Pull complete
94d6ebf35d22: Pull complete
6c692a9fd741: Pull complete
Digest: sha256:9042fdc4e53f5390ca5a3993aa71506523970efb40ffb9a98e6a4b1a9a4f8862
Status: Downloaded newer image for docker.xuanyuan.run/falkordb/falkordb:latest
docker.xuanyuan.run/falkordb/falkordb:latest
```

```bash
docker images docker.xuanyuan.run/falkordb/falkordb:latest
```

```text
IMAGE                                          ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/falkordb/falkordb:latest   9042fdc4e53f        613MB          159MB
```

生产把 `latest` 换成具体版本号，Compose 与命令一并替换。

---

## 五、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/falkordb`（可改 `$HOME/falkordb`）。

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/falkordb/data
chown -R "$USER:$USER" /www/wwwroot/falkordb
cd /www/wwwroot/falkordb
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  falkordb:
    image: docker.xuanyuan.run/falkordb/falkordb:latest
    container_name: falkordb
    restart: unless-stopped
    ports:
      - "6379:6379"
      - "13300:3000"
    environment:
      TZ: Asia/Shanghai
      # 生产示例：
      # REDIS_ARGS: "--requirepass 请换成强密码 --appendonly yes"
      # FALKORDB_ARGS: "THREAD_COUNT 4"
    volumes:
      - ./data:/var/lib/falkordb/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s
EOF
```

| 项 | 作用 |
|----|------|
| `"6379:6379"` | 协议口 |
| `"13300:3000"` | Browser（宿主机不占 3000） |
| `./data → /var/lib/falkordb/data` | 数据持久化 |

### 5.3 启动与验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 50
```

实测：

```text
[+] Running 2/2
 ✔ Network falkordb_default  Created
 ✔ Container falkordb        Started

NAME       IMAGE                                          COMMAND                  SERVICE    CREATED         STATUS                   PORTS
falkordb   docker.xuanyuan.run/falkordb/falkordb:latest   "/var/lib/falkordb/b…"   falkordb   6 seconds ago   Up 5 seconds (healthy)   0.0.0.0:6379->6379/tcp, [::]:6379->6379/tcp, 0.0.0.0:13300->3000/tcp, [::]:13300->3000/tcp
```

日志关键行：

```text
WARNING Memory overcommit must be enabled! ... sysctl vm.overcommit_memory=1
Redis version=8.6.3 ... Running mode=standalone, port=6379.
<graph> Starting up FalkorDB version 4.20.1.
Module 'graph' loaded from /var/lib/falkordb/bin/falkordb.so
Ready to accept connections tcp
▲ Next.js 16.2.9
- Network:       http://0.0.0.0:3000
✓ Ready in 0ms
```

```bash
docker compose exec falkordb redis-cli PING
```

```text
PONG
```

浏览器打开 `http://服务器IP:13300`（本机则 `http://127.0.0.1:13300`），实测进入 `/login`。

### 5.4 生产：密码与 AOF

把 `environment` / `healthcheck` 改成：

```yaml
    environment:
      TZ: Asia/Shanghai
      REDIS_ARGS: "--requirepass ${FALKORDB_PASSWORD:-changeme} --appendonly yes"
      FALKORDB_ARGS: "THREAD_COUNT 4"
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${FALKORDB_PASSWORD:-changeme}", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s
```

```bash
export FALKORDB_PASSWORD='请换成强密码'
docker compose up -d
docker compose exec falkordb redis-cli -a "$FALKORDB_PASSWORD" PING
```

不需要 Browser、只要更轻引擎时，可改用 **`falkordb/falkordb-server`**，只映射 **6379**；可视化再另起 `falkordb-browser` 并用 `FALKORDB_URL` 指向 server（见[官方文档](https://docs.falkordb.com/operations/docker.html)）。

---

## 六、浏览器登录与建图

打开 `http://服务器IP:13300`。

### 6.1 登录

选 **Manual Configuration**：

| 字段 | 填法（未设密码） |
|------|------------------|
| Host | `localhost`（同容器连引擎，勿填局域网 IP） |
| Port | `6379`（不是 13300） |
| Username / Password | **留空**（勿填占位文案 `Default`） |
| TLS | 关闭 |

点 **Log in**。已设 `--requirepass` 时只填 Password。

![FalkorDB Browser 登录页：Manual Configuration，Host 为 localhost、Port 6379](https://assets.xuanyuan.me/docker/blog/falkordb-1.webp)

### 6.2 欢迎向导

顶栏应显示 **FalkorDB: v4.20.1**（或相近）与 **`localhost:6379`**。首次可弹出 Welcome 教程，**Next** 跟做或 **Skip Tutorial** 跳过。

![FalkorDB Browser 欢迎向导：可 Skip Tutorial 或 Next](https://assets.xuanyuan.me/docker/blog/falkordb-2.webp)

### 6.3 创建图

左侧 **Select Graph** 旁点 **+**，图名填 **`MotoGP`**，点 **Create your Graph**。

![FalkorDB Browser 创建新图：图名为 MotoGP](https://assets.xuanyuan.me/docker/blog/falkordb-3.webp)

打不开页面时：检查防火墙是否放行 **13300**，以及 `docker compose ps` 是否含 `13300->3000`。

---

## 七、Cypher 查询与画布

确认已选中 **MotoGP**。在顶部输入框写查询，点 **RUN**；结果可在 Graph / Table / JSON 间切换。

### 7.1 写入示例数据

```cypher
CREATE (:Rider {name:'Valentino Rossi'})-[:rides]->(:Team {name:'Yamaha'}),
       (:Rider {name:'Dani Pedrosa'})-[:rides]->(:Team {name:'Honda'}),
       (:Rider {name:'Andrea Dovizioso'})-[:rides]->(:Team {name:'Ducati'})
```

![FalkorDB Browser：CREATE 写入骑手与车队关系](https://assets.xuanyuan.me/docker/blog/falkordb-4.webp)

左侧统计约为 **NODES 6**、**EDGES 3**，标签 `Rider` / `Team`，关系 `rides`。

### 7.2 查骑手

```cypher
MATCH (n:Rider) RETURN n
```

![FalkorDB Browser：MATCH Rider 显示三个骑手节点](https://assets.xuanyuan.me/docker/blog/falkordb-5.webp)

### 7.3 查车队

```cypher
MATCH (n:Team) RETURN n
```

![FalkorDB Browser：MATCH Team 显示 Yamaha、Honda、Ducati](https://assets.xuanyuan.me/docker/blog/falkordb-6.webp)

### 7.4 查 rides 关系

```cypher
MATCH p=()-[:rides]->() RETURN p
```

![FalkorDB Browser：MATCH rides 路径展示骑手到车队](https://assets.xuanyuan.me/docker/blog/falkordb-7.webp)

可选：用更宽查询拉出带 `name` 的实体（画布如下）。

```cypher
MATCH (e) WHERE e.name IS NOT NULL RETURN e
UNION
MATCH ()-[e]-() WHERE e.name IS NOT NULL RETURN e
```

![FalkorDB Browser：UNION 查询返回带 name 的节点与关系](https://assets.xuanyuan.me/docker/blog/falkordb-8.webp)

更多示例：[FalkorDB/demo](https://github.com/FalkorDB/FalkorDB/tree/master/demo)。

---

## 八、设置、UDF 与用户

侧栏齿轮进 **Settings**；`{ }` 进 **UDF Libraries**。

- **UDF**：可 **Load Lib** / **Flush Libs**，初次为空正常。  
- **Browser Settings**：Chat、Graph Info、Query Execution、User Experience；可 **Replay Tutorial**。  
- **Users**：默认用户 **`default`**（Admin）。生产按需 **Add User**，ACL 持久化见 FAQ。

![FalkorDB Browser：UDF Libraries](https://assets.xuanyuan.me/docker/blog/falkordb-9.webp)

![FalkorDB Browser Settings 页](https://assets.xuanyuan.me/docker/blog/falkordb-10.webp)

![FalkorDB Browser Users：default 为 Admin](https://assets.xuanyuan.me/docker/blog/falkordb-11.webp)

---

## 九、redis-cli 验证（可选）

与 Browser 共用同一图名 `MotoGP`：

```bash
docker compose exec falkordb redis-cli
```

```text
GRAPH.QUERY MotoGP "MATCH (r:Rider)-[:rides]->(t:Team) WHERE t.name = 'Yamaha' RETURN r.name, t.name"
GRAPH.QUERY MotoGP "MATCH (r:Rider)-[:rides]->(t:Team {name:'Ducati'}) RETURN count(r)"
```

Python（`redis-py`）：

```python
import redis

r = redis.StrictRedis(host="127.0.0.1", port=6379, decode_responses=True)
print(r.execute_command(
    "GRAPH.QUERY",
    "MotoGP",
    "MATCH (r:Rider)-[:rides]->(t:Team) WHERE t.name = 'Yamaha' RETURN r.name, t.name",
))
```

已设密码时客户端需带密码。

---

## 十、备选：docker run

仅临时试玩或没有 Compose 时使用；日常跟做仍用第五节。

```bash
docker run -d \
  --name falkordb \
  --restart unless-stopped \
  -p 6379:6379 \
  -p 13300:3000 \
  -v /www/wwwroot/falkordb/data:/var/lib/falkordb/data \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/falkordb/falkordb:latest
```

带密码与 AOF：加 `-e REDIS_ARGS="--requirepass 请换成强密码 --appendonly yes"`。  
一次性试玩（无持久化）：去掉 `-d` / 挂载，加 `-it --rm`。

```bash
docker exec -it falkordb redis-cli PING
```

与 Compose 容器重名时先 `docker compose down` 或换 `--name`。

---

## 十一、迁移 / 升级

1. `docker compose stop` 后备份 `data/`  
2. 拉取新标签并改 Compose `image:`  
3. `docker compose up -d`  
4. `PING` + Browser 抽查一张图  
5. 异常则改回旧标签与备份  

生产钉版本号；跨大版本先在预发验证。

---

## 十二、常见问题 FAQ

**Q1：6379 Connection refused？**  
看 `docker compose ps` / `logs`；端口冲突则改 `"6380:6379"`。

**Q2：打不开 :13300？**  
确认镜像是 **`falkordb/falkordb`**（含 Browser）；放行 **13300**；`docker port falkordb` 应有 `13300→3000`。

**Q3：登录 Host / 密码怎么填？**  
同容器：`localhost` + `6379`，未设密码则用户名密码留空。网页口 **13300**，库口 **6379**。勿填局域网 IP，勿把 `Default` 当账号。

**Q4：日志里 overcommit / 未认证警告？**  
`sysctl vm.overcommit_memory=1`（持久化写入 `/etc/sysctl.conf`）。未设密码会提示接受任意 IP——实验室可接受，生产必须 `--requirepass` 并限制暴露。

**Q5：重启后数据没了？**  
确认挂载了 `/var/lib/falkordb/data`；建议 `--appendonly yes`。见 [Persistence](https://docs.falkordb.com/operations/durability/persistence.html)。

**Q6：ACL 用户重启丢失？**  
需 `--aclfile` 落在数据卷上，并 `ACL SAVE`。见 [ACL Persistence](https://docs.falkordb.com/operations/durability/acl-persistence.html)。

**Q7：和 Neo4j 工具通用吗？**  
否。协议是 Redis + `GRAPH.*`，请用 Redis 客户端、FalkorDB SDK 或内置 Browser。

**Q8：如何确认模块已加载？**  

```bash
docker compose exec falkordb redis-cli MODULE LIST
```

---

## 十三、命令速查

```bash
docker pull docker.xuanyuan.run/falkordb/falkordb:latest

cd /www/wwwroot/falkordb
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
docker compose exec falkordb redis-cli PING
# 浏览器 http://服务器IP:13300

docker compose down
```

---

## 十四、延伸阅读

- [falkordb/falkordb 镜像页](https://xuanyuan.cloud/zh/r/falkordb/falkordb) · [标签列表](https://xuanyuan.cloud/r/falkordb/falkordb/tags)
- [Docker and Docker Compose](https://docs.falkordb.com/operations/docker.html) · [Persistence](https://docs.falkordb.com/operations/durability/persistence.html) · [Browser](https://docs.falkordb.com/browser/)
- [GitHub · FalkorDB](https://github.com/FalkorDB/FalkorDB) · [demo](https://github.com/FalkorDB/FalkorDB/tree/master/demo)
- [openCypher 属性图模型](https://github.com/opencypher/openCypher/blob/master/docs/property-graph-model.adoc)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- Compose 拉起 **`falkordb/falkordb:latest`**：协议 **6379**，Browser **13300**（容器内 3000）。  
- Browser：`localhost:6379` 登录 → 建图 **MotoGP** → `CREATE` / `MATCH` 看画布。  
- 数据落在 **`/var/lib/falkordb/data`**；生产加密码与 AOF，并钉 ≥ v4.14.9 的版本。

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/falkordb-docker-deploy


