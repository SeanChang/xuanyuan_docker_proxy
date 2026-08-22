# Docker 部署 openGauss：轻松搭建企业级开源关系型数据库平台

![Docker 部署 openGauss：轻松搭建企业级开源关系型数据库平台](https://img.xuanyuan.dev/docker/blog/opengauss.webp)

*分类: Docker部署教程 | 标签: openGauss,Docker,轩辕镜像,关系型数据库,私有化部署,部署教程 | 发布时间: 2026-08-06 14:51:45*

> openGauss 是一款开源的关系型数据库：用 SQL 建库建表、存业务数据、做查询与事务，角色接近 PostgreSQL / MySQL。常见用途包括业务系统后端库、中间件联调、教学实验，以及信创 / 国产化选型时的自托管试跑。

*本文基于 [opengauss/opengauss:5.0.0](https://xuanyuan.cloud/zh/r/opengauss/opengauss)（可选 [opengauss/opengauss-webclient:1.0.4](https://xuanyuan.cloud/r/opengauss/opengauss-webclient)），实测引擎 **openGauss 5.0.0**（`x86_64`，GCC 7.3.0），测试平台 **macOS**（Docker Desktop，Intel Core i5-5257U / AVX2）。*

**openGauss** 是一款开源的**关系型数据库**：用 SQL 建库建表、存业务数据、做查询与事务，角色接近 PostgreSQL / MySQL。常见用途包括业务系统后端库、中间件联调、教学实验，以及信创 / 国产化选型时的自托管试跑。协议口默认 **5432**，可用官方客户端 **`gsql`**，也可用兼容驱动从应用连接。

很多人真正卡在「怎么先跑起来」：裸机装依赖重、云托管又不便做内网联调或数据不出域。更省事的做法是用官方 Docker 镜像，在自己的机器上起一个可连的库实例，数据落在本机目录。

本文主推镜像 **`opengauss/opengauss`**（见 [镜像页](https://xuanyuan.cloud/zh/r/opengauss/opengauss)）——容器里就是数据库服务本身。同组织还有可选的 **`opengauss/opengauss-webclient`**（见 [镜像页](https://xuanyuan.cloud/r/opengauss/opengauss-webclient)），用浏览器点选对象、跑 SQL；它自带另一套库，**不替代**主库镜像。二者关系见下文「一、是什么 & 什么关系」。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 开发 / 联调 | Compose 拉起后，应用或客户端连 `服务器IP:5432`，库名默认 `postgres`，用户 `gaussdb` |
| 学习与实验 | 在容器内用 **`/usr/local/opengauss/bin/gsql`** 建表、写 SQL，数据挂到本机目录 |
| 浏览器轻操作 | 可选起 `opengauss-webclient`，打开 `http://IP:8081`（需先启用服务） |
| 内网私有化试跑 | 库与数据不出域，适合选型评估与教学环境 |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`opengauss/opengauss:5.0.0`**（**不要**盲跟当前有缺陷的 `latest`），**Docker Compose** 映射宿主机 **5432**，设置 **`LD_LIBRARY_PATH`**，用容器内 `gsql` 验证；另附可选 webclient（浏览器 **8081**，内置库实测为 **openGauss 3.1.0**，与主库数据分离）与 **`docker run` 备选**。文内附 **10** 张 Web UI 实测截图。

> **上手要点**  
> - **部署**：默认 **Compose 只起主库**（第五节）；Web UI 见 **第七节先启用再访问**；临时试玩见 **第九节 docker run**  
> - **标签**：库跟做用 **`5.0.0`**（实测可起）；当前 **`latest` 缺 `libopenblas.so.0`，会 Restarting**  
> - **端口**：主库 **5432**；**8081 仅启用 webclient 后才有**  
> - **数据卷**：宿主机 `./data` → 容器 **`/var/lib/opengauss/data`**  
> - **环境变量**：**`GS_PASSWORD`**（必填）+ **`LD_LIBRARY_PATH=/usr/local/opengauss/lib`**（实测需要）  
> - **gsql**：不在默认 PATH，用 **`/usr/local/opengauss/bin/gsql`**  
> - **CPU**：宿主机需支持 **AVX / AVX2**；无 AVX 的老 CPU 会 `Illegal instruction`  
> - **工作目录**：Linux 正文默认 `/www/wwwroot/opengauss`；**macOS 实测用 `~/docker/opengauss`**  
> - **特权**：`privileged: true`  
> - **暴露**：勿把 5432 裸暴露公网  

镜像说明：[opengauss/opengauss](https://xuanyuan.cloud/zh/r/opengauss/opengauss)、[opengauss/opengauss-webclient](https://xuanyuan.cloud/r/opengauss/opengauss-webclient)。标签：[opengauss tags](https://xuanyuan.cloud/r/opengauss/opengauss/tags)、[webclient tags](https://xuanyuan.cloud/r/opengauss/opengauss-webclient/tags)。官方容器文档：[单节点容器安装](https://docs.opengauss.org/en/docs/7.0.0-RC3/installation_guide/installation_on_a_single_node_container.html)。项目站点：[opengauss.org](https://opengauss.org/)。

---

## 一、是什么 & 什么关系？

### 1.1 两个镜像分别做什么

| 镜像 | 角色 | 维护节奏（镜像页） | 典型用法 |
|------|------|--------------------|----------|
| **`opengauss/opengauss`** | **数据库引擎**（官方主镜像） | 有更新，但标签质量不一 | 开发测试、学习、自托管联调 |
| **`opengauss/opengauss-webclient`** | **Web UI**（浏览器操作库） | 约 3 年前，标签 **`1.0.4`** | 快速在浏览器里看库；不宜当长期生产前端 |

- **`opengauss/opengauss`**：容器内默认监听 **5432**。必须设置 **`GS_PASSWORD`**；默认有超级用户 **`omm`** 与测试用户 **`gaussdb`**。容器内本机信任连接通常可不输密码；从宿主机或其他容器连库则需密码。  
- **`opengauss/opengauss-webclient`**：映射 **8081** 后用浏览器访问。镜像内会尝试自带库初始化，与主库**不是同一份数据**；且受宿主机 `core_pattern` 影响，在 Ubuntu 上易失败（见 FAQ）。

### 1.2 二者什么关系

```text
方案 A（推荐主路径）
  应用 / gsql / 图形客户端  ──:5432──▶  opengauss/opengauss（权威数据）
  ./data                     ──挂载──▶  /var/lib/opengauss/data

方案 B（可选体验）
  浏览器  ──:8081──▶  opengauss/opengauss-webclient（Web UI，可含内置库）
```

| 问题 | 结论 |
|------|------|
| 是否必须一起部署？ | **否**。只部署 **`opengauss/opengauss` 即可**。 |
| webclient 能否替代主库？ | **不建议**。 |
| 生产 / 联调数据放哪？ | **`opengauss/opengauss` + `./data`**。 |

同组织相关镜像：[opengauss/opengauss-server](https://xuanyuan.cloud/r/opengauss/opengauss-server)、[enmotech/opengauss](https://xuanyuan.cloud/r/enmotech/opengauss)。本文跟做 **官方 `opengauss/opengauss:5.0.0`**。

### 1.3 关键参数一览

| 项 | `opengauss/opengauss` | `opengauss-webclient` |
|----|------------------------|------------------------|
| 跟做标签 | **`5.0.0`** | `1.0.4` |
| 容器端口 | **5432** | **8081** |
| 必填环境变量 | **`GS_PASSWORD`**；实测另需 **`LD_LIBRARY_PATH`** | 官方示例无额外必填项 |
| privileged | **需要** | 建议需要（尤其 Linux） |
| 默认库 / 用户 | 库 `postgres`，用户 `gaussdb` | 以界面为准 |

密码示例 **`openGauss@123`**——仅跟做，上线务必改掉。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（如 Ubuntu 24.04）或 **macOS + Docker Desktop** |
| CPU | **x86_64 且支持 AVX / AVX2**（实测：无 AVX 的 Core2 Duo 会 SIGILL） |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **1～2 GB** 可用 |
| 磁盘 | `5.0.0` CONTENT SIZE 约 **464MB** 量级（DISK USAGE 约 **1.7GB**，以本机为准）+ 数据增长 |
| 端口 | 宿主机 **5432**；可选 **8081** |

```bash
docker --version
docker compose version

# macOS：查看是否具备 AVX2（有则较稳）
sysctl -a | grep -i leaf7_features

# Linux：
# grep -oE 'avx[^ ]*' /proc/cpuinfo | sort -u
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址1
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)

# 备用地址2
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

> 宿主机 **5432** 已被占用时，Compose 改为 `"15432:5432"`。

---

## 三、标签怎么选

| 镜像 | 标签 | 实测结论 | 推荐 |
|------|------|----------|------|
| `opengauss/opengauss` | **`5.0.0`** | 可起库、`gaussdb -V` 正常 | **跟做 / 本文** |
| `opengauss/opengauss` | **`latest`** | 缺 **`libopenblas.so.0`**，容器 Restarting | **暂勿跟做** |
| `opengauss/opengauss` | 其它版本号 | 需自测 | 生产钉版本前先验证 |
| `opengauss/opengauss-webclient` | **`1.0.4`** | Ubuntu 上易因 `core_pattern` 初始化失败 | 可选体验 |

完整列表：[opengauss tags](https://xuanyuan.cloud/r/opengauss/opengauss/tags)、[webclient tags](https://xuanyuan.cloud/r/opengauss/opengauss-webclient/tags)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
# 主库（本文跟做）
docker pull docker.xuanyuan.run/opengauss/opengauss:5.0.0

# Web UI（可选）
docker pull docker.xuanyuan.run/opengauss/opengauss-webclient:1.0.4
```

macOS 实测（主库 `5.0.0`）：

```text
5.0.0: Pulling from opengauss/opengauss
bf37c47dc58e: Already exists
416428d7bb5a: Already exists
15d09040b6af: Pull complete
44de8bf8b4ac: Pull complete
2ae1d2ac404d: Pull complete
ae0bcc1b03b5: Pull complete
a3d132d18f28: Pull complete
7133e4484edf: Pull complete
Digest: sha256:f8679ef310000452f7d1ce4c7752cee6fe63575fb6aa05fe8807090042645380
Status: Downloaded newer image for docker.xuanyuan.run/opengauss/opengauss:5.0.0
docker.xuanyuan.run/opengauss/opengauss:5.0.0
```

可选 webclient（Ubuntu 侧曾拉取成功）：

```text
Digest: sha256:2ceb484afcee2f19760cae0097dfd42cd7e74ec9b6dfa8a80804519af573e534
Status: Downloaded newer image for docker.xuanyuan.run/opengauss/opengauss-webclient:1.0.4
```

```bash
docker images docker.xuanyuan.run/opengauss/opengauss:5.0.0
```

冒烟（可选）：确认二进制可跑：

```bash
docker run --rm --privileged --entrypoint bash \
  docker.xuanyuan.run/opengauss/opengauss:5.0.0 -c \
  'export LD_LIBRARY_PATH=/usr/local/opengauss/lib; /usr/local/opengauss/bin/gaussdb -V; echo exit:$?'
```

实测：

```text
gaussdb (openGauss 5.0.0 build ) compiled at 2023-04-18 09:47:39 commit 0 last mr
exit:0
```

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/opengauss` |
| **macOS 实测** | **`~/docker/opengauss`** |

下文命令以 Linux 路径书写；在 Mac 上把路径换成 `~/docker/opengauss` 即可（见仓库文档规则）。

### 5.1 创建目录

```bash
# Linux
mkdir -p /www/wwwroot/opengauss/data
chown -R "$USER:$USER" /www/wwwroot/opengauss
cd /www/wwwroot/opengauss

# macOS 实测：
# mkdir -p ~/docker/opengauss/data && cd ~/docker/opengauss
```

### 5.2 编写 docker-compose.yml

默认**只起主库**（webclient 注释掉）：

```bash
cat > docker-compose.yml <<'EOF'
services:
  opengauss:
    image: docker.xuanyuan.run/opengauss/opengauss:5.0.0
    container_name: opengauss
    restart: unless-stopped
    privileged: true
    ports:
      - "5432:5432"
    environment:
      TZ: Asia/Shanghai
      GS_PASSWORD: "openGauss@123"
      LD_LIBRARY_PATH: "/usr/local/opengauss/lib"
    volumes:
      - ./data:/var/lib/opengauss/data

  # 可选：Web UI（默认注释；启用见第七节）
  # webclient:
  #   image: docker.xuanyuan.run/opengauss/opengauss-webclient:1.0.4
  #   container_name: opengauss-webclient
  #   restart: unless-stopped
  #   privileged: true
  #   ports:
  #     - "8081:8081"
EOF
```

| 项 | 作用 |
|----|------|
| `image: …:5.0.0` | 避开当前有问题的 `latest` |
| `privileged: true` | 官方要求 |
| `"5432:5432"` | 数据库协议口 |
| `GS_PASSWORD` | `omm` / `gaussdb` 密码 |
| `LD_LIBRARY_PATH` | 让 `gaussdb` 找到 `/usr/local/opengauss/lib` 下依赖 |
| `./data → /var/lib/opengauss/data` | 数据持久化 |

> **默认只有 5432**：未启用 webclient 时**没有** 8081。

### 5.3 启动与验证（仅主库）

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 100
```

macOS 实测 `ps`：

```text
NAME        IMAGE                                           COMMAND                                      SERVICE     STATUS         PORTS
opengauss   docker.xuanyuan.run/opengauss/opengauss:5.0.0   "/var/lib/opengauss/entrypoint.sh gaussdb"   opengauss   Up …           0.0.0.0:5432->5432/tcp
```

日志关键成功标志（节选）：

```text
[gs_ctl]: server started (/var/lib/opengauss/data)
CREATE DATABASE
CREATE ROLE
 default user is gaussdb
openGauss  init process complete; ready for start up.
```

常见 **WARNING**（`GAUSSLOG` / cgroup / HA sockets / `gaussdb.version`）在容器场景可忽略，只要进程保持 **Up** 且能连库即可。

容器内用 **完整路径** 的 `gsql` 验证（`bash -lc` 默认 PATH **不含** `gsql`）：

```bash
docker compose exec opengauss /usr/local/opengauss/bin/gsql -d postgres -U gaussdb -c "SELECT version();"
```

若提示 `Password for user gaussdb:`，输入与 `GS_PASSWORD` 相同的密码（跟做示例为 `openGauss@123`）。

macOS 实测：

```text
Password for user gaussdb:
                                                                   version
----------------------------------------------------------------------------------------------------------------------------------------------
 (openGauss 5.0.0 build ) compiled at 2023-04-18 09:47:39 commit 0 last mr   on x86_64-unknown-linux-gnu, compiled by g++ (GCC) 7.3.0, 64-bit
(1 row)
```

也可用显式 PATH 写法：

```bash
docker compose exec opengauss bash -lc \
  'export LD_LIBRARY_PATH=/usr/local/opengauss/lib; export PATH=/usr/local/opengauss/bin:$PATH; gsql -d postgres -U gaussdb -c "SELECT version();"'
```

从宿主机连接需本机已装客户端：

```bash
gsql -d postgres -U gaussdb -W 'openGauss@123' -h 127.0.0.1 -p 5432
```

主库验证**不依赖**浏览器与 webclient。

### 5.4 可选环境变量（主库）

| 变量 | 含义 | 默认 / 备注 |
|------|------|-------------|
| `GS_PASSWORD` | **必填** | 无 |
| `LD_LIBRARY_PATH` | 共享库搜索路径 | 实测设为 `/usr/local/opengauss/lib` |
| `GS_USERNAME` | 连接用户名 | `gaussdb` |
| `GS_NODENAME` | 节点名 | `gaussdb` |
| `GS_PORT` | 库端口 | `5432` |

---

## 六、使用主库：gsql 与简单 SQL

### 6.1 进入交互式会话

```bash
docker compose exec -it opengauss bash -lc \
  'export LD_LIBRARY_PATH=/usr/local/opengauss/lib; export PATH=/usr/local/opengauss/bin:$PATH; gsql -d postgres -U gaussdb'
```

### 6.2 建表示例

```sql
CREATE TABLE demo_users (
  id   INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);

INSERT INTO demo_users (id, name) VALUES (1, 'alice'), (2, 'bob');

SELECT * FROM demo_users;
```

退出：`\q`。

### 6.3 应用侧连接要点

| 项 | 值（本文跟做） |
|----|----------------|
| Host | 服务器 IP 或 `127.0.0.1` |
| Port | `5432` |
| Database | `postgres` |
| User | `gaussdb` |
| Password | 与 `GS_PASSWORD` 一致 |

---

## 七、可选：使用 opengauss-webclient

**前提**：第五节默认 Compose **不起** webclient；须先把 `webclient` 服务写进 Compose（或取消注释）再 `up`，`:8081` 才是 Web UI（**不是**主库的浏览器入口）。

### 7.1 启用并启动

macOS 实测目录：`~/docker/opengauss`（Linux 用 `/www/wwwroot/opengauss`）。

```bash
docker pull docker.xuanyuan.run/opengauss/opengauss-webclient:1.0.4
cd ~/docker/opengauss   # Linux：/www/wwwroot/opengauss
```

Compose 中同时保留主库与 webclient（示例）：

```yaml
  webclient:
    image: docker.xuanyuan.run/opengauss/opengauss-webclient:1.0.4
    container_name: opengauss-webclient
    restart: unless-stopped
    privileged: true
    ports:
      - "8081:8081"
```

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80 webclient
```

macOS 实测：两容器均为 **Up**，端口含 **`8081->8081`**；日志出现 `creating template1 database … ok`、`setting password … ok` 等即初始化成功。

> Ubuntu 上若反复 `core dump path is an invalid directory`，见 FAQ Q9（`core_pattern` / apport）。macOS Docker Desktop 实测可正常 init。

### 7.2 浏览器访问

```text
http://服务器IP:8081
```

本机：`http://127.0.0.1:8081`。局域网示例：`http://192.168.x.x:8081`。

| 你想用什么 | 地址 / 方式 |
|------------|-------------|
| 主库（权威数据，`./data`，**5.0.0**） | **5432** + gsql / 应用（第五、六节） |
| Web UI（镜像内置库，实测 **3.1.0**） | **8081**（本节） |

### 7.3 界面怎么用（实测）

打开后通常已连上库名 **`postgres`**。左侧是对象浏览器，顶部为功能页签（数据 / 表结构 / 索引 / 约束 / **SQL操作** / 操作历史 / 会话 / 链接信息）。

首次进入 **SQL操作** 时编辑器为空；左侧可能先看到 **`dbe_perf`**（性能相关视图很多，Tables 为 0 很正常）：

![openGauss webclient：SQL操作页签，库名 postgres，左侧 dbe_perf 与对象过滤](https://img.xuanyuan.dev/docker/blog/opengauss-1.webp)

**建议先跑一条确认连接**——在 SQL 框输入后点紫色 **执行**：

```sql
SELECT version();
```

实测结果为 **openGauss 3.1.0**（与主库容器的 **5.0.0** 不同，进一步证明是两套库）：

![openGauss webclient：执行 SELECT version()，结果为 openGauss 3.1.0](https://img.xuanyuan.dev/docker/blog/opengauss-2.webp)

再建表示例（数据落在 **webclient 内置库**，不会写入主库 `./data`）：

```sql
CREATE TABLE demo_ui (
  id   INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL
);
INSERT INTO demo_ui VALUES (1, 'alice'), (2, 'bob');
SELECT * FROM demo_ui;
```

执行后下方结果区可见 `alice` / `bob`；左侧切到 **`public` → Tables`** 会出现 **`demo_ui`**：

![openGauss webclient：SQL 建表插入并 SELECT demo_ui，结果两行 alice/bob](https://img.xuanyuan.dev/docker/blog/opengauss-3.webp)

点选表后切到 **数据** 页签，可浏览行数据（带筛选与导出）：

![openGauss webclient：数据页签浏览 demo_ui 表，显示 id 与 name](https://img.xuanyuan.dev/docker/blog/opengauss-4.webp)

**表结构** 页签查看列定义（如 `id` integer、`name` varchar(64)）：

![openGauss webclient：表结构页签显示 demo_ui 列定义](https://img.xuanyuan.dev/docker/blog/opengauss-5.webp)

**索引** 页签可见主键索引 `demo_ui_pkey`：

![openGauss webclient：索引页签显示 demo_ui_pkey](https://img.xuanyuan.dev/docker/blog/opengauss-6.webp)

**约束** 页签可见 `PRIMARY KEY (id)`：

![openGauss webclient：约束页签显示 PRIMARY KEY](https://img.xuanyuan.dev/docker/blog/opengauss-7.webp)

**操作历史** 可回看已执行的 SQL：

![openGauss webclient：操作历史列出 SELECT version 与 CREATE TABLE](https://img.xuanyuan.dev/docker/blog/opengauss-8.webp)

**会话** 页签可查看当前连接与后台线程（含 `openGauss-webclient` 应用名）：

![openGauss webclient：会话页签列出 postgres 库中的活动会话](https://img.xuanyuan.dev/docker/blog/opengauss-9.webp)

**链接信息** 可确认当前用户、服务端地址等。实测：`current_user` / `session_user` 为 **`opengauss`**，容器内服务端口为 **`5433`**，版本串为 **3.1.0**：

![openGauss webclient：链接信息页签显示用户 opengauss、端口 5433、版本 3.1.0](https://img.xuanyuan.dev/docker/blog/opengauss-10.webp)

| 区域 / 操作 | 说明 |
|-------------|------|
| 顶部库名 `postgres` | 当前数据库 |
| **过滤数据库对象** | 按名称筛选 schema / 表 / 视图 |
| **SQL操作 → 执行** | 手写 SQL；结果可导出 JSON / CSV / XML |
| **数据 / 表结构 / 索引 / 约束** | 选中表后查看内容与元数据 |
| **操作历史 / 会话 / 链接信息** | 历史、监控与连接属性 |

**和主库的关系（务必分清）：**

```text
浏览器 :8081  →  webclient 内置库（实测 openGauss 3.1.0，容器内 :5433，用户 opengauss）
gsql   :5432  →  opengauss:5.0.0 + ./data（本文权威数据，用户 gaussdb）
```

要操作主库持久化数据，请用 **5432 + gsql**；webclient 适合浏览器练手。镜像 **`1.0.4` 久未更新**，公网慎暴露 **8081**。

---

## 八、安全与生产加固

| 建议 | 做法 |
|------|------|
| 改密码 | 换强密码；已初始化数据目录不会因改环境变量自动改密 |
| 网络 | 5432 / 8081 仅内网；公网加防火墙 / HTTPS |
| 标签 | 钉死版本（如 `5.0.0`），验证后再升 |
| privileged | 仅可信环境 |
| 备份 | 定期备份 `./data` |

---

## 九、备选：docker run

### 9.1 仅主库

```bash
# Linux 示例；macOS 把路径换成 ~/docker/opengauss/data
mkdir -p /www/wwwroot/opengauss/data
docker run -d \
  --name opengauss \
  --privileged=true \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -e GS_PASSWORD='openGauss@123' \
  -e LD_LIBRARY_PATH=/usr/local/opengauss/lib \
  -p 5432:5432 \
  -v /www/wwwroot/opengauss/data:/var/lib/opengauss/data \
  docker.xuanyuan.run/opengauss/opengauss:5.0.0
```

```bash
docker exec opengauss /usr/local/opengauss/bin/gsql -d postgres -U gaussdb -c "SELECT version();"
```

### 9.2 仅 Web UI（可选）

```bash
docker run -d \
  --name opengauss-webclient \
  --privileged=true \
  --restart unless-stopped \
  -p 8081:8081 \
  docker.xuanyuan.run/opengauss/opengauss-webclient:1.0.4
```

---

## 十、升级与迁移说明

1. **备份**：`docker compose stop` 后拷贝 `./data`。  
2. **换标签**：改 `image:` → `pull` → `up -d`；跨大版本先查发行说明。  
3. **勿盲目升到 `latest`**：先确认镜像内依赖完整（见 FAQ Q8）。

---

## 十一、常见问题 FAQ

**Q1：`gsql: command not found`？**  
A：非交互 shell 默认 PATH 不含 `/usr/local/opengauss/bin`。使用：

```bash
docker compose exec opengauss /usr/local/opengauss/bin/gsql -d postgres -U gaussdb -c "SELECT version();"
```

若出现 `Password for user gaussdb:`，输入 `GS_PASSWORD`（跟做示例 `openGauss@123`）即可。

**Q2：`latest` 一直 Restarting，日志有 `libopenblas.so.0`？**  
A：当前实测 `latest` 镜像内**缺少**该库。改用 **`5.0.0`**（本文）。

**Q3：`gaussdb -V` 报 `Illegal instruction`（exit 132）？**  
A：CPU 过旧、无 **AVX**。换带 AVX2 的机器（云主机注意机型），或换编译选项更保守的镜像后自测。

**Q4：密码不符合复杂度？**  
A：至少 8 位，含大小写、数字与特殊字符。示例 `openGauss@123`。

**Q5：数据目录挂哪？**  
A：本文与 Docker Hub / 轩辕镜像页一致：`/var/lib/opengauss/data`。实测 `5.0.0` 在此路径下可完成 init。

**Q6：为什么必须 privileged？**  
A：官方要求；否则可能无法正常运行。

**Q7：webclient 和主库是否共用数据？版本为什么不一样？**  
A：**不共用**。主库跟做为 **`opengauss/opengauss:5.0.0`**（5432 / `gaussdb`）；webclient 镜像内置库实测为 **openGauss 3.1.0**（容器内常听 **5433**，用户 **`opengauss`**），经浏览器 **8081** 访问。`SELECT version()` 两边结果不同是正常现象。

**Q8：日志里一堆 GAUSSLOG / cgroup WARNING？**  
A：容器场景常见；只要 `Up` 且 `gsql` 可查，可先忽略。

**Q9：webclient 反复 `core dump path is an invalid directory`？**  
A：宿主机 `core_pattern` 为 `|…apport…` 等管道时，openGauss 初始化易失败。可临时改为文件路径再测（影响整机，测完还原），或跳过 webclient，只用主库。

**Q10：和 PostgreSQL 客户端通用吗？**  
A：端口习惯可借鉴，方言与驱动以 openGauss 为准。

---

## 十二、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/opengauss/opengauss:5.0.0

# Compose（Linux）
cd /www/wwwroot/opengauss
# macOS：cd ~/docker/opengauss
docker compose up -d
docker compose ps
docker compose logs --tail 100
docker compose exec opengauss /usr/local/opengauss/bin/gsql -d postgres -U gaussdb -c "SELECT version();"
# 若提示 Password，输入 GS_PASSWORD（示例 openGauss@123）
docker compose down
```

---

## 十三、延伸阅读

- 轩辕镜像：[opengauss/opengauss](https://xuanyuan.cloud/zh/r/opengauss/opengauss) · [标签](https://xuanyuan.cloud/r/opengauss/opengauss/tags)  
- 轩辕镜像：[opengauss/opengauss-webclient](https://xuanyuan.cloud/r/opengauss/opengauss-webclient) · [标签](https://xuanyuan.cloud/r/opengauss/opengauss-webclient/tags)  
- 官方文档：[容器单节点安装](https://docs.opengauss.org/en/docs/7.0.0-RC3/installation_guide/installation_on_a_single_node_container.html)  
- 项目站点：[opengauss.org](https://opengauss.org/)  
- Docker Hub：[opengauss/opengauss](https://hub.docker.com/r/opengauss/opengauss) · [opengauss-webclient](https://hub.docker.com/r/opengauss/opengauss-webclient)  
- 轩辕镜像使用手册：https://xuanyuan.cloud/usage  

---

## 总结

- 跟做标签：**`opengauss/opengauss:5.0.0`**（避开有问题的 `latest`）。  
- Compose：`privileged` + `GS_PASSWORD` + **`LD_LIBRARY_PATH`** + 数据卷；用 **`/usr/local/opengauss/bin/gsql`** 验证。  
- webclient 可选，且默认不启用；与主库数据不共用。  
- 关注 CPU（AVX）与 Linux 上 webclient 的 `core_pattern` 坑。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/opengauss-docker-deploy


