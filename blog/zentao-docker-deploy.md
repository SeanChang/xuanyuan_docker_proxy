# Docker 部署 ZenTao：轻松搭建研发项目管理平台

![Docker 部署 ZenTao：轻松搭建研发项目管理平台](https://assets.xuanyuan.me/docker/blog/zentao.webp)

*分类: Docker部署教程 | 标签: ZenTao,禅道,Docker,轩辕镜像,项目管理,敏捷,Scrum,缺陷跟踪,私有化部署,部署教程 | 发布时间: 2026-08-18 07:44:33*

> 研发一忙，需求就散在聊天记录、表格和口头承诺里：产品经理改一版 Excel，开发对不上行号，测试不知道该验哪条；缺陷在群文件里传来传去，对几次就丢了上下文。再大一点的团队还要同时管多条产品线、多个迭代，没有一个「产品 / 项目 / 测试」既能分开又能衔接的地方，周会只能靠人肉对账...

*本文基于 [easysoft/zentao:22.4-20260729](https://xuanyuan.cloud/zh/r/easysoft/zentao)，实测引擎 **ZenTao 22.4**，配套 **MariaDB 10.6.28**，测试平台 **Ubuntu 24.04** Linux。*

研发一忙，需求就散在聊天记录、表格和口头承诺里：产品经理改一版 Excel，开发对不上行号，测试不知道该验哪条；缺陷在群文件里传来传去，对几次就丢了上下文。再大一点的团队还要同时管多条产品线、多个迭代，没有一个「产品 / 项目 / 测试」既能分开又能衔接的地方，周会只能靠人肉对账。

把整套流程放到商业 SaaS，授权按人计费，需求和缺陷出域也过不了内网审计。自建 Jira 一类重型平台，对「先把项目管理跑起来」又偏重。更省事的做法是：**数据留在自己的服务器**，浏览器打开就能管需求、任务和 Bug。

**ZenTao**（中文名 **禅道**）是国产开源项目管理软件，在浏览器里管产品、项目、测试、文档和组织。官方镜像是 **`easysoft/zentao`**（见 [镜像页](https://xuanyuan.cloud/zh/r/easysoft/zentao)）。本文跟做开源版标签 **`22.4-20260729`**，跟做命令不要写 `latest`。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 产品与需求 | 建产品、拆需求、维护发布计划 |
| 项目与迭代 | 建项目 / 执行，把需求拆成任务并跟进度 |
| 测试与缺陷 | 提 Bug、关联需求与任务、看测试单 |
| 文档与组织 | 团队文档、部门与权限 |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`easysoft/zentao:22.4-20260729`**，以 **Docker Compose + MariaDB** 启动，到浏览器走完安装向导并登录——全程零基础可跟做；文末附 **`docker run` + 内置 MySQL** 备选，文内附 **22** 张实测截图。

> **上手要点**
> - **部署**：默认 **Compose + 外置 MariaDB**（第五节）；临时试玩见 **第九节 docker run**
> - **标签**：**`22.4-20260729`**（不要把 `latest` 写入跟做命令）
> - **端口**：宿主机 **8080 → 容器 80**；本文实测 `http://192.168.1.251:8080`
> - **数据卷**：`./data` → `/data`（禅道）；`./mysql` → `/var/lib/mysql`（MariaDB）
> - **库密码**：Compose 里的 **`ZT_MYSQL_PASSWORD`** 须与 MariaDB **`MYSQL_ROOT_PASSWORD`** 相同，并改成你自己的强密码
> - **管理员**：必须走安装向导，账号密码是你自己填的（本文示例为 `sean`），不是镜像预置密码
> - **step5 报 JSON 空响应**：22.x 已知问题，日志出现 `Zentao is ready to use` 后打开首页登录即可（第六节、FAQ Q5）
> - **暴露**：公网请防火墙 + 改密 + 反代 HTTPS；内置 MySQL（仅 docker run 备选）官方账号为 `root` / `123456`，只适合测试

镜像说明：[easysoft/zentao](https://xuanyuan.cloud/zh/r/easysoft/zentao) · [tags](https://xuanyuan.cloud/r/easysoft/zentao/tags) · [Docker 手册](https://www.zentao.net/book/zentaopms/docker-1111.html)。开源版许可：**AGPL / ZPL**（商用请自行核对）。

---

## 一、ZenTao 是什么？

禅道把产品、项目、测试、文档放在同一套系统里，需求和缺陷不必再放到公有云。和常见做法比：

| | ZenTao 开源版（本文） | 表格 / 聊天 | Jira 等商业套件 |
|--|----------------------|-------------|-----------------|
| 数据位置 | 自托管 | 散落 | 多为云端或高授权 |
| 覆盖范围 | 产品 + 项目 + 测试 | 无流程 | 强，但重、贵 |
| 上手 | Compose + 安装向导 | 零安装、难协作 | 重 |

**易混对象（只需跟做一个镜像）：**

| 对象 | 说明 |
|------|------|
| **`easysoft/zentao`** | **本文跟做镜像**（开源 / 企业 / 旗舰 / IPD 用不同标签） |
| **`easysoft/quickon-zentao`** | 已归档，官方指向 `easysoft/zentao`，不要再拉 |
| **`hub.zentao.net/app/zentao`** | 禅道自己的国内镜像坐标；本文用轩辕镜像加速同一份镜像 |
| 轩辕 `/r/` 与 `/zh/r/` | **同一镜像**的概览页 / 中文简介页，不是两个仓库 |
| 企业版 `biz*` / 旗舰 `max*` / IPD `ipd*` | 商业版本标签，需对应授权；本文只跟做开源版 |

```text
浏览器 ──HTTP:8080──▶ 禅道容器 (:80, PHP)
                         │
                  Compose 网络
                         │
                    MariaDB (:3306)
./data  ──挂载──▶ /data
./mysql ──挂载──▶ /var/lib/mysql
```

官方演示（非自建）：[开源版 Demo](https://demo.zentao.net/)。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| CPU / 内存 | 官方测试 **1 核 / 1 GB** 可起；推荐 **2 核 / 4 GB** |
| 磁盘 | 禅道 CONTENT SIZE 约 **265 MB**（DISK USAGE 约 **1.1 GB**）+ MariaDB 约 **108 MB / 440 MB** + 数据增长 |
| 架构 | **amd64 / arm64**（先查 [tags](https://xuanyuan.cloud/r/easysoft/zentao/tags)） |
| 端口 | 宿主机 **8080**（容器内 **80**） |

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

> 宿主机 **8080** 已被占用时，Compose 改为 `"18080:80"`，访问 `http://IP:18080`。

---

## 三、标签怎么选

`easysoft/zentao` 标签很多：开源版、企业版、旗舰版、IPD，以及 `php7`、`k8s`、达梦等变体。**跟做只拉开源版时间戳标签**，不要用 `latest` 当生产默认。

撰写时开源稳定构建对应 **`22.4-20260729`**（Docker Hub 上当时 **没有** 单独的裸标签 `22.4`；当时 `latest` 与这枚时间戳指向同一开源构建，但 `latest` 会滚动）。完整列表以 [tags](https://xuanyuan.cloud/r/easysoft/zentao/tags) 为准。

| 标签 | 含义 | 本文 |
|------|------|------|
| **`22.4-20260729`** | 开源版 22.4 的时间戳构建（数字开头 = 开源版） | **跟做** |
| `latest` | 跟踪最新开源稳定版（会滚动） | **不要写入跟做命令** |
| `22.4-20260729-php7` | 同一开源版的 PHP 7 变体 | 仅当插件强制 PHP 7 |
| `biz13.4` / `max8.4` / `ipd5.4` | 企业 / 旗舰 / IPD（`biz` / `max` / `ipd` 开头） | 有授权再换；本文不跟做 |
| `*.k8s` | K8s 定制构建 | 集群场景，单机 Compose 不必 |

同一小版本可能有多枚时间戳标签（如 `18.7-20230916` 与 `18.7-20230918`）。要可复现部署，钉死带日期的那枚，升级时再改标签。从 **18.6** 之前的旧镜像升上来，不要只改标签，见第十节。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/easysoft/zentao:22.4-20260729
docker pull docker.xuanyuan.run/library/mariadb:10.6
```

Ubuntu 24.04 实测（禅道）：

```text
22.4-20260729: Pulling from easysoft/zentao
24de5f1523ae: Pull complete
677c21efff47: Pull complete
5411c0823101: Pull complete
1c68c48a3224: Pull complete
69fb10dc82f9: Pull complete
be3c4536b55c: Pull complete
241946931369: Pull complete
3bb6b7d9befb: Pull complete
9f8c3976bb58: Pull complete
3ea12eec3682: Pull complete
b43826e1936d: Pull complete
a437921b6bd8: Pull complete
018c41f7747e: Pull complete
deb0fc7002e1: Pull complete
4f4fb700ef54: Pull complete
e25567c85c52: Download complete
Digest: sha256:053271d835595b9cf77f89666f23f4b9754a85a8296866b5b92a678bd43dfb4e
Status: Downloaded newer image for docker.xuanyuan.run/easysoft/zentao:22.4-20260729
docker.xuanyuan.run/easysoft/zentao:22.4-20260729
```

MariaDB 10.6 第一次拉取曾出现 `net/http: timeout awaiting response headers`，**再执行一次同一条 `docker pull` 即可**（layer 会续传）。成功输出：

```text
10.6: Pulling from library/mariadb
206600c01e95: Download complete
4b2afa549606: Pull complete
84157c0e882b: Pull complete
9dad1a8753e0: Pull complete
56d1433f0703: Pull complete
c69f7ffc4ddf: Pull complete
d544298cabd5: Pull complete
Digest: sha256:92e50059ea0a5965a33ef751970eab37d421b91ebbd01ac909039cffe159e574
Status: Downloaded newer image for docker.xuanyuan.run/library/mariadb:10.6
docker.xuanyuan.run/library/mariadb:10.6
```

```bash
docker images docker.xuanyuan.run/easysoft/zentao:22.4-20260729
docker images docker.xuanyuan.run/library/mariadb:10.6
```

```text
IMAGE                                               ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/easysoft/zentao:22.4-20260729   053271d83559        1.1GB          265MB
docker.xuanyuan.run/library/mariadb:10.6            92e50059ea0a        440MB          108MB
```

---

## 五、Docker Compose 部署（推荐）

官方建议：**生产用外置数据库**；内置 MySQL 只适合测试。本节用 **MariaDB 10.6** 与禅道同栈启动（与官方 Compose 示例一致）。

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/zentao` |
| **macOS 实测** | **`~/docker/zentao`** |

### 5.1 创建目录

```bash
mkdir -p /www/wwwroot/zentao/{data,mysql}
chown -R "$USER:$USER" /www/wwwroot/zentao
cd /www/wwwroot/zentao
```

非 root 时给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

把 **`ChangeMe_Zentao_Db`** 换成你自己的强密码（MariaDB root 与禅道 `ZT_MYSQL_PASSWORD` **必须相同**）：

```bash
cat > docker-compose.yml <<'EOF'
services:
  zentao-db:
    image: docker.xuanyuan.run/library/mariadb:10.6
    container_name: zentao-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ChangeMe_Zentao_Db
      MYSQL_DATABASE: zentao
      TZ: Asia/Shanghai
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
    volumes:
      - ./mysql:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 12
    networks:
      - zentao-net

  zentao:
    image: docker.xuanyuan.run/easysoft/zentao:22.4-20260729
    container_name: zentao
    restart: unless-stopped
    depends_on:
      zentao-db:
        condition: service_healthy
    ports:
      - "8080:80"
    volumes:
      - ./data:/data
    environment:
      MYSQL_INTERNAL: "false"
      ZT_MYSQL_HOST: zentao-db
      ZT_MYSQL_PORT: "3306"
      ZT_MYSQL_USER: root
      ZT_MYSQL_PASSWORD: ChangeMe_Zentao_Db
      ZT_MYSQL_DB: zentao
      PHP_MAX_EXECUTION_TIME: "120"
      PHP_MEMORY_LIMIT: 512M
      PHP_POST_MAX_SIZE: 128M
      PHP_UPLOAD_MAX_FILESIZE: 128M
      TZ: Asia/Shanghai
    networks:
      - zentao-net

networks:
  zentao-net:
    driver: bridge
EOF
```

| 配置项 | 说明 |
|--------|------|
| `MYSQL_INTERNAL: "false"` | 使用 Compose 里的 MariaDB，不用镜像内置库 |
| `ZT_MYSQL_HOST: zentao-db` | 容器间用服务名通信，不要填宿主机 `127.0.0.1` |
| `8080:80` | 浏览器入口；容器内 Web 为 **80** |
| `./data:/data` | 配置、附件、会话等持久化；空目录首次会自动初始化 |
| `./mysql` | 数据库文件；**不要**把 MariaDB 的 3306 映射到公网 |

这些环境变量让容器能连上 MariaDB，**不会跳过浏览器安装向导**。向导里仍要按第六节填写同一组库信息，才会写出 `my.php`。未改示例密码就不要把 **8080** 暴露到公网。

### 5.3 启动服务

```bash
docker compose pull
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
```

期望：`zentao-db` 为 **healthy / Up**，`zentao` 为 **Up**，端口 `0.0.0.0:8080->80/tcp`。MariaDB 首次初始化大约 **40 秒**（实测 `Healthy` 约 44s），不要在容器刚 Created 时就打开浏览器。

Ubuntu 24.04 实测：

```text
[+] up 3/3
 ✔ Network zentao_zentao-net Created
 ✔ Container zentao-db       Healthy
 ✔ Container zentao          Started
```

```text
NAME        IMAGE                                               COMMAND                  SERVICE     CREATED              STATUS                        PORTS
zentao      docker.xuanyuan.run/easysoft/zentao:22.4-20260729   "/usr/bin/entrypoint…"   zentao      About a minute ago   Up 26 seconds                 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
zentao-db   docker.xuanyuan.run/library/mariadb:10.6            "docker-entrypoint.s…"   zentao-db   About a minute ago   Up About a minute (healthy)   3306/tcp
```

日志关键行（节选）：

```text
Welcome to the Easysoft ZenTao 22.4 container
INFO  ==> Apache: MySQL is ready.
INFO  ==> Database zentao already exists
AH00163: Apache/2.4.62 (Unix) ... resuming normal operations
INFO  ==> Sentry: Apache is ready.
INFO  ==> 服务已启动完成, 请使用浏览器访问设置的域名或ip:port, 继续完成后续安装向导
```

看到 **Up** 且出现 **Apache is ready** / **继续完成后续安装向导** 后，按 `Ctrl+C` 退出日志跟踪，再打开浏览器。此时还没有登录页，必须走第六节安装向导。

> MariaDB 日志里的 `io_uring_queue_init() failed with EPERM` / `liburing disabled` 在部分内核上常见，会回退到 `innodb_use_native_aio=OFF`，一般不影响建库与安装。

---

## 六、浏览器安装向导

浏览器打开：

```text
http://服务器IP:8080
```

本文实测：`http://192.168.1.251:8080`。请用 **IP 直连** 完成安装（先不要走 Nginx 反代），避免向导里的 AJAX 被缓冲或改写。

### 6.1 欢迎与许可

首页是 **欢迎使用禅道项目管理软件**，页脚写明版本 **22.4**。右上角可切换语言（默认简体）。点 **开始安装**。

![ZenTao 安装向导：欢迎使用禅道 22.4，点击开始安装](https://assets.xuanyuan.me/docker/blog/zentao-1.webp)

阅读授权协议（ZPL / AGPL），勾选 **已阅读并同意**，点 **下一步**。

![ZenTao 安装向导：授权协议页，勾选已阅读并同意](https://assets.xuanyuan.me/docker/blog/zentao-2.webp)

### 6.2 系统检查

**系统检查** 会核对 PHP 版本、扩展（PDO、JSON、MBSTRING 等）与 `/data` 下目录是否可写。本文实测为 **PHP 8.1.31**，Docker 镜像里通常全部通过，直接 **下一步**。

![ZenTao 安装向导：系统检查全部通过，PHP 8.1 与扩展已加载](https://assets.xuanyuan.me/docker/blog/zentao-3.webp)

### 6.3 数据库配置

在 **生成配置文件** 页填写外置 MariaDB 信息，与第五节 Compose **保持一致**：

| 项 | 填写 |
|----|------|
| 时区 | `Asia/Shanghai`（或 `(UTC+08:00) Shanghai`） |
| 默认语言 | 简体 |
| 数据库服务器 | **`zentao-db`**（Compose 服务名，不是 `127.0.0.1`） |
| 服务器端口 | **3306** |
| 数据库编码 | **utf8mb4** |
| 数据库用户名 | **`root`** |
| 数据库密码 | 与 Compose 中 **`MYSQL_ROOT_PASSWORD`** 相同（示例 `ChangeMe_Zentao_Db`） |
| 数据库名称 | **`zentao`** |

![ZenTao 安装向导：生成配置文件，数据库主机 zentao-db、库名 zentao](https://assets.xuanyuan.me/docker/blog/zentao-4.webp)

点 **下一步** 后进入 **正在安装数据库表**。进度条会显示 `x / 845` 一类计数，列表里逐条出现「新增」表与索引；**不要刷新页面**，等 **下一步** 按钮可点（实测约一两分钟）。

![ZenTao 安装向导：正在安装数据库表，进度 10/845](https://assets.xuanyuan.me/docker/blog/zentao-5.webp)

完成后会提示配置已写入 **`/apps/zentao/config/my.php`**（容器内路径），点 **下一步**。

![ZenTao 安装向导：配置已保存到 my.php](https://assets.xuanyuan.me/docker/blog/zentao-6.webp)

### 6.4 使用模式与管理员账号

选择 **使用模式**：

| 模式 | 适合 |
|------|------|
| **轻量级管理模式** | 小团队，只要敏捷 / 看板 / 测试等核心能力 |
| **全生命周期管理模式** | 需要项目集、产品线、瀑布等完整能力 |

本文选 **全生命周期管理模式**。

![ZenTao 安装向导：选择轻量级或全生命周期管理模式](https://assets.xuanyuan.me/docker/blog/zentao-7.webp)

在 **设置帐号** 页填写公司名称与管理员账号密码（6 位及以上，含大小写字母与数字）。可勾选 **导入 demo 数据** 便于体验（本文勾选，第七节截图里的示例产品 / 项目都来自这里）。点 **保存**。

![ZenTao 安装向导：设置公司名称与管理员账号密码，可导入 demo 数据](https://assets.xuanyuan.me/docker/blog/zentao-8.webp)

### 6.5 step5 报 `Unexpected end of JSON input`（已知问题）

点 **保存** 后，浏览器可能仍停在 `install.php?m=install&f=step5`，弹窗类似：

```text
POST: /install.php?m=install&f=step5&zin=1
Error: Unexpected end of JSON input
Response:
```

这是禅道 **22.x** 安装向导的已知问题（[官方问答：该报错不影响](https://www.zentao.net/ask/599513.html)）。保存管理员后容器会切到 RoadRunner，前端再 POST `step5` 时响应体常为空，JSON 解析失败。

**不要删数据重装。** 看日志是否已出现：

```text
INFO  ==> Zentao is ready to use.
[INFO] RoadRunner server started; version: 2025.1.2, ...
```

出现后，地址栏改成首页（不要再停在 `install.php`）：

```text
http://服务器IP:8080/
```

本文实测为 `http://192.168.1.251:8080/`。应进入 **登录页**，标题会带上你填的公司名称（本文为「轩辕镜像项目管理系统」）。用向导里刚设的管理员登录（本文用户名为 `sean`）。

![ZenTao 登录页：轩辕镜像项目管理系统，用户名与密码](https://assets.xuanyuan.me/docker/blog/zentao-9.webp)

若首页仍卡在向导、或提示未生成配置文件，再按 FAQ Q5 处理。

---

## 七、主界面与核心功能

登录后可能弹出 **22.4 新版本介绍**，点 **下一页** 或关闭即可。随后进入 **地盘**：左侧是全局导航，中间是待办、使用帮助和禅道动态，右下角写着 **开源版 22.4**。地盘是个人工作台，业务数据要从侧栏的产品、项目、测试进。

![ZenTao 首次登录：22.4 新版本介绍弹窗](https://assets.xuanyuan.me/docker/blog/zentao-10.webp)

![ZenTao 地盘仪表盘：待办统计、使用帮助与禅道动态，用户 sean](https://assets.xuanyuan.me/docker/blog/zentao-11.webp)

本文勾选了 **导入 demo 数据**，所以后面截图里的「企业管理」「公司企业网站建设」都是示例，用来确认页面能打开，不是空库新建。正式环境建议安装时不勾选；已经导入的，到 **组织** 里停用或删除 demo 账号，并删掉不需要的示例产品 / 项目。

没勾选 demo 时，从 **产品 → 创建产品** 开始，再在 **项目** 里关联该产品、在 **执行** 里拆任务、在 **测试** 里提 Bug。可以记一条链：**产品（需求）→ 项目 / 执行（任务）→ 测试（缺陷）**。

### 7.1 项目集与产品

**项目集 → 项目视角**：demo 里有「企业管理」项目集，下面挂了若干子项目和进度。没有项目集时，产品仍然可以单独建。

![ZenTao 项目集列表：企业管理项目集与进行中状态](https://assets.xuanyuan.me/docker/blog/zentao-12.webp)

**产品 → 产品列表**：需求从产品进来。demo 里有「公司企业网站建设」「企业内部工时管理系统」两条产品线，列表会显示需求、计划、发布等统计。

![ZenTao 产品列表：两条示例产品与需求统计列](https://assets.xuanyuan.me/docker/blog/zentao-13.webp)

### 7.2 项目、执行与任务

**项目 → 项目列表**：把产品需求放进具体项目里推进。demo 项目「企业管理系统」的负责人是项目经理。

![ZenTao 项目列表：企业管理系统项目](https://assets.xuanyuan.me/docker/blog/zentao-14.webp)

进入某一 **执行 → 任务**：执行相当于一次迭代 / 冲刺。任务可按模块树查看状态（未开始 / 进行中 / 已完成）和工时。

![ZenTao 执行任务页：公司企业网站建设任务列表与工时统计](https://assets.xuanyuan.me/docker/blog/zentao-15.webp)

### 7.3 测试

**测试 → 仪表盘**：按产品看 Bug 修复率、待测测试单。demo 数据下已有示例 Bug 与测试任务；空库时这里是空的，提第一条缺陷即可验证流程。

![ZenTao 测试仪表盘：Bug 修复率与待测测试单](https://assets.xuanyuan.me/docker/blog/zentao-16.webp)

### 7.4 其它模块

开源版侧栏还有 DevOps、BI、看板、文档。跟做部署时点开确认能进页面即可，不是必配。

**DevOps**：模块能打开；启用完整 DevOps 4.0 需按提示在宿主机执行 GitFox 安装脚本（可选，本文未跟做）。

![ZenTao DevOps：安装 GitFox 引擎说明页](https://assets.xuanyuan.me/docker/blog/zentao-17.webp)

**BI → 大屏**：预置宏观数据、年度总结、燃尽图等模板。

![ZenTao BI 大屏：预置数据可视化模板列表](https://assets.xuanyuan.me/docker/blog/zentao-18.webp)

**看板**：分协作 / 公共 / 私人空间。新装未建空间时显示「暂时没有空间」，即使导入了 demo 也可能是空的，正常。

![ZenTao 看板：空间列表为空时的初始页](https://assets.xuanyuan.me/docker/blog/zentao-19.webp)

**文档 → 我的空间**：可创建文档库与团队空间。

![ZenTao 文档：我的空间与默认空间](https://assets.xuanyuan.me/docker/blog/zentao-20.webp)

### 7.5 组织与后台

**组织 → 团队**：用户列表。导入 demo 后会多出一批示例账号，和你自己创建的管理员（本文为 `sean`）在一起。正式使用前应停用或删除 demo 用户。

![ZenTao 组织团队：用户列表含 demo 账号与管理员](https://assets.xuanyuan.me/docker/blog/zentao-21.webp)

**后台**：系统设置、成员管理、插件、数据导入。登录后尽快改掉管理员密码，并确认只有自己能进后台。

![ZenTao 后台：系统设置、成员管理与插件推荐](https://assets.xuanyuan.me/docker/blog/zentao-22.webp)

企业版 / 旗舰版 / IPD 的模块更多，需要对应许可证，不能靠改开源版标签「升级成商业版」。

---

## 八、日常运维与生产加固

```bash
cd /www/wwwroot/zentao
docker compose ps
docker compose logs -f --tail 100
docker compose restart
docker compose stop
```

生产上建议：

- **改密**：管理员、MariaDB root 都换成强密码；改库密码后同步改 Compose 里的 `ZT_MYSQL_PASSWORD` 再 `up -d`
- **demo 账号**：导入过示例数据的，在组织里停用或删除，避免示例用户留在生产
- **不要**把 `3306` 映射到宿主机公网
- 公网访问时前置反向代理 + HTTPS，防火墙只放行可信来源访问 **8080**（或只放行 443）
- 定期备份 **`./data`** 与 **`./mysql`**（停库或至少保证一致性后再拷）
- 上传大附件时可加大 `PHP_POST_MAX_SIZE`、`PHP_UPLOAD_MAX_FILESIZE`、`PHP_MAX_EXECUTION_TIME`
- 多实例才需要 Redis 存 Session（`PHP_SESSION_TYPE=redis`）；**21.2+** 镜像还支持 `REDIS_INTERNAL=true`（内置 Redis 默认密码官方写 **`pass4Redis`**，务必改掉）。零基础单机不必先上 Redis

---

## 九、备选：docker run（内置 MySQL）

仅临时试玩或没有 Compose 时使用；官方写明 **内置数据库仅供测试**。日常跟做仍用第五节。

```bash
mkdir -p /www/wwwroot/zentao/data
docker run -d \
  --name zentao \
  --restart unless-stopped \
  -p 8080:80 \
  -v /www/wwwroot/zentao/data:/data \
  -e MYSQL_INTERNAL=true \
  docker.xuanyuan.run/easysoft/zentao:22.4-20260729
```

| 项 | 值 |
|----|-----|
| 内置 MySQL | **`root` / `123456`**（官方手册） |
| 访问 | `http://IP:8080` |
| 管理员 | 仍须走安装向导；登录密码以向导填写为准 |

与 Compose 容器重名时先 `docker compose down` 或换 `--name`。前台调试可去掉 `-d`，看初始化日志。

用 `docker run` 接**已有**外置库时，设 `MYSQL_INTERNAL=false`，并传入 `ZT_MYSQL_HOST` / `PORT` / `USER` / `PASSWORD` / `DB`；不要再开内置库。

---

## 十、迁移 / 升级

镜像会检测数据版本与程序版本，同一产品线内换标签后常会自动做库结构升级。仍建议：

1. `docker compose stop`，备份 `./data` 与 `./mysql`
2. 在 [tags](https://xuanyuan.cloud/r/easysoft/zentao/tags) 选定目标开源标签（例如更新的 `22.x-日期`）
3. 修改 `docker-compose.yml` 中的 `image:` 行
4. `docker compose pull && docker compose up -d`
5. 浏览器登录，抽查产品 / 任务 / 缺陷
6. 异常则改回旧标签再 `up -d`，并从备份恢复

从 **18.6 之前**的旧镜像升级到新结构，不要只改标签，先读官方 [旧版 Docker 镜像升级说明](https://www.zentao.net/book/zentaopms/docker-1111.html)。商业版与开源版标签不要混用同一数据目录。

---

## 十一、常见问题 FAQ

**Q1：该拉 `latest` 还是 `22.4-20260729`？**
跟做与生产钉死 **`22.4-20260729`**（或你选定的其它时间戳标签）。`latest` 会跟着开源稳定版滚动，文档里的界面步骤可能对不上。撰写时 Docker Hub 上没有裸标签 `22.4`。

**Q2：企业版 / 旗舰版标签能当开源版用吗？**
不能。`biz*` / `max*` / `ipd*` 是商业产品线，需要授权。本文只覆盖开源版。

**Q3：页面打不开？**
查 `docker compose ps` / `logs`；放行 **8080**；确认映射是 `8080:80` 而不是只映射了 80。数据库未就绪时禅道会起不来，等 `zentao-db` **healthy** 再看。权限问题可检查 `./data`、`./mysql` 是否可写。

**Q4：安装向导里数据库主机填什么？**
Compose 外置库填服务名 **`zentao-db`**，不是 `127.0.0.1`（那是禅道容器自己）。账号 `root`，密码与 `MYSQL_ROOT_PASSWORD` 相同，库名 `zentao`。Compose 里的 `ZT_MYSQL_*` 不会替你点完向导。

**Q5：step5 报 `Unexpected end of JSON input`，Response 为空？**
22.x 已知问题，**通常已经装完**。对照日志：出现 **`Zentao is ready to use`** 和 **`RoadRunner server started`** 后，改访问 `http://IP:8080/` 登录，账号是向导里填的那组。不要反复点 step5，也不要因此 `compose down -v` 清数据。

若日志已 ready，首页却仍停在向导或提示「还没有生成配置文件」：用 IP 直连（不要走反代），换无痕窗口再打开 `/`；仍不行再查 [官方问答](https://www.zentao.net/ask/599513.html)，不要清空数据目录重装。

**Q6：管理员密码是 `admin` / `123456` 吗？**
Docker 这条路径要走**安装向导**，管理员密码是你在设置帐号页 **自己设的**。内置 MySQL（仅 docker run 备选）才是官方写的 **`root` / `123456`**。外置 MariaDB 的 root 是 Compose 里的 `MYSQL_ROOT_PASSWORD`。

**Q7：为什么不用宿主机 80 或 3000？**
**80** 常被 Nginx / 宝塔占用；**3000** 易与前端开发冲突，本系列教程不把服务发到宿主机 3000。本文用 **8080→80**。

**Q8：还要再拉 `easysoft/quickon-zentao` 吗？**
不用。该仓库已归档，请只用 **`easysoft/zentao`**。

**Q9：内置 MySQL 和外置 MariaDB 可以混用吗？**
不要。`MYSQL_INTERNAL=true` 与外置 `ZT_MYSQL_*` 只选一条路径。已经用外置库跑起来的数据，不要突然改成内置库指向空目录。

**Q10：拉取 MariaDB 超时？**
`timeout awaiting response headers` 时再执行同一条 `docker pull`，已下载 layer 会续传。401 / 402 见 [登录认证](https://xuanyuan.cloud/usage/login) 与 [充值](https://xuanyuan.cloud/recharge)；其它见 [常见问题](https://xuanyuan.cloud/faq)。

**Q11：MariaDB 日志里 io_uring / liburing 告警？**
内核禁用 io_uring 时的回退，实测仍能 `healthy` 并完成安装，可忽略。

**Q12：上传附件失败或超时？**
加大 `PHP_UPLOAD_MAX_FILESIZE`、`PHP_POST_MAX_SIZE`、`PHP_MAX_EXECUTION_TIME` 后 `docker compose up -d`。

---

## 十二、命令速查

```bash
docker pull docker.xuanyuan.run/easysoft/zentao:22.4-20260729
docker pull docker.xuanyuan.run/library/mariadb:10.6

cd /www/wwwroot/zentao
docker compose up -d
docker compose ps
docker compose logs -f --tail 100

# 浏览器 http://服务器IP:8080 走安装向导
# 管理员 = 向导里填写的账号；step5 JSON 空响应则打开首页登录

docker compose down
```

临时试玩（内置 MySQL，不推荐生产）：

```bash
docker run -d --name zentao --restart unless-stopped \
  -p 8080:80 \
  -v /www/wwwroot/zentao/data:/data \
  -e MYSQL_INTERNAL=true \
  docker.xuanyuan.run/easysoft/zentao:22.4-20260729
```

---

## 十三、延伸阅读

- [easysoft/zentao 镜像页](https://xuanyuan.cloud/zh/r/easysoft/zentao) · [标签列表](https://xuanyuan.cloud/r/easysoft/zentao/tags)
- [GitHub · easysoft/zentaopms](https://github.com/easysoft/zentaopms)
- [GitHub · quicklyon/zentao-docker](https://github.com/quicklyon/zentao-docker)
- [禅道官网](https://www.zentao.net/) · [Docker / K8s 部署手册](https://www.zentao.net/book/zentaopms/docker-1111.html)
- [禅道使用手册](https://www.zentao.net/book/zentaopmshelp/405.html)
- [安装 step5 JSON 空响应（官方：不影响，打开首页登录）](https://www.zentao.net/ask/599513.html)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

## 总结

- 跟做 **`easysoft/zentao:22.4-20260729`**：Compose 映射 **8080→80**，外置 **MariaDB 10.6**，数据在 **`./data`** 与 **`./mysql`**。
- 日志出现「继续完成后续安装向导」后，用浏览器走完向导；管理员密码以向导填写为准。
- **step5** 报 `Unexpected end of JSON input` 时，若日志已有 **`Zentao is ready to use`**，直接打开首页登录即可。
- `latest`、商业版标签、已归档的 `quickon-zentao` 都不要写进跟做命令。

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/zentao-docker-deploy


