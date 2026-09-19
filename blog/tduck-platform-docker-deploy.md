# Docker 部署填鸭表单完整教程：搭建私有化问卷与表单收集平台

![Docker 部署填鸭表单完整教程：搭建私有化问卷与表单收集平台](https://imgs.xuanyuan.cloud/docker/blog/tduck.webp)

*分类: Docker部署教程 | 标签: 填鸭表单,TDuck,TDuck Platform,tduckcloud/tduck-platform,Docker,轩辕镜像,问卷,表单,私有化部署,部署教程 | 发布时间: 2026-09-14 06:53:57*

> 填鸭表单（TDuck Platform）是一款开源问卷与在线表单系统，支持拖拽建表、答卷统计与模板发布。本文将介绍如何通过 Docker Compose 部署 tduckcloud/tduck-platform 并配套 MySQL，轻松搭建可自托管的表单收集平台，适合内部调研、活动报名、课程评价与信息登记等场景。

*本文基于 [tduckcloud/tduck-platform:latest](https://xuanyuan.cloud/zh/r/tduckcloud/tduck-platform)，跟做标签 **latest**（选型见第三节），实测 **填鸭表单社区版 6.0**（Spring Boot **2.7.8**），测试平台 **Ubuntu 24.04** Linux。*

年会报名要手机号、部门、是否吃辣；培训结束发满意度；人事再做一轮匿名调研——表格往往散在微信群 Excel、第三方问卷链接，甚至打印后扫码回传。改一题就要重发链接，答卷字段对不齐，活动结束还得手工合并 CSV。

放到公有问卷 SaaS，又会碰到更硬的约束：**答卷、附件和受访者信息最好留在自己的库里**。内网机房、等保或「数据不出域」时，外链问卷不合适；自建又怕装 JDK、配前端、手搓 MySQL。很多团队其实已经有一台跑 Docker 的 Ubuntu，缺的是镜像能拉、库能初始化、浏览器打开 **8999** 就能拖组件。

**填鸭表单（TDuck Platform）**（[文档](https://doc.tduckcloud.com)、[Gitee](https://gitee.com/TDuckApp/tduck-platform)、[镜像页](https://xuanyuan.cloud/zh/r/tduckcloud/tduck-platform)）是开源问卷 / 在线表单：拖拽建表、逻辑显隐、统计报表、模板与 WebHook。官方镜像 **`tduckcloud/tduck-platform`** 把前后端打进同一容器，**外置 MySQL**，上传目录用卷持久化。跟做时务必带上官方 **`tduck-v5.sql`**——镜像本身不会建表。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 打开管理台 | `http://服务器IP:8999`，默认管理员登录后改密 |
| 拖拽建表单 | 新建「周末聚餐报名」一类表单，加姓名 / 联系方式等字段 |
| 发布收集 | 生成链接与二维码，公开页填写，后台看统计 |
| 备份搬家 | 停栈后打包 `./mysql-data`、`./upload`、`./init-db` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`tduckcloud/tduck-platform:latest`**，**Docker Compose** 拉起 MySQL + 应用。把下文中的 IP 与数据库密码换成你的。无 Compose 见第八节。文内附 **18** 张实测截图。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第八节
> - **SQL**：必须挂载官方 `docker/init-db/tduck-v5.sql`（空库会缺表重启）
> - **端口**：宿主机 **8999** → 容器 **8999**
> - **标签**：跟做 **`latest`**（`v5` 仅 arm64，见 §3.1）
> - **体积**：应用 DISK **736MB** / CONTENT **267MB**；MySQL 8.0 DISK **1.1GB** / CONTENT **249MB**
> - **冷启动**：首次导库约 **2～3 分钟**；应用约 **24 秒** 出「社区版6.0-启动成功」
> - **账号**：**`admin@tduckcloud.com` / `123456`**（生产立即改密）
> - **目录**：Linux `/www/wwwroot/tduck-platform`；macOS `~/docker/tduck-platform`
> - **可忽略**：启动时 `OssStorageFactory … 更新存储配置失败` 仍可起来，后台再配存储
> - **填表边界**：本文镜像是**社区版**；公开 H5 收集可用，**密码 / 登录门槛、IP·账号答题次数、定时定量回收、选项名额、审批流**等属 Pro / X（见 §1.1）

官方：[Docker 部署](https://doc.tduckcloud.com/openSource/deploy/dockerDeploy.html) · [版本对比](https://doc.tduckcloud.com/buyPro/contrast.html) · [镜像页](https://xuanyuan.cloud/zh/r/tduckcloud/tduck-platform) · [标签列表](https://xuanyuan.cloud/r/tduckcloud/tduck-platform/tags) · [Docker Hub](https://hub.docker.com/r/tduckcloud/tduck-platform)

---

## 一、填鸭表单镜像是什么？

`tduckcloud/tduck-platform` 是填鸭表单的**应用一体镜像**（API + 前端静态资源），监听 **8999**。业务在 MySQL，上传文件在挂载目录。它**不内置库表**：要么让 MySQL 首次启动时执行 `init-db` 里的 SQL，要么你手动导入。

| | 填鸭表单（本文） | 问卷星 / 金数据等 SaaS |
|--|------------------|------------------------|
| 数据位置 | 本机 MySQL + 上传卷 | 厂商云端 |
| 建表方式 | 浏览器拖拽 | 厂商编辑器 |
| 适合 | 内网合规、要控答卷 | 快速外链、少运维 |

```text
浏览器 ──HTTP:8999──▶  tduck-platform（Spring Boot 2.7.x）
                           ├── JDBC ──▶ MySQL（库名 tduck，由 tduck-v5.sql 建表）
                           └── ./upload ──▶ /application/BOOT-INF/lib/upload
```

[`/zh/r/`](https://xuanyuan.cloud/zh/r/tduckcloud/tduck-platform) 与 [`/r/`](https://xuanyuan.cloud/r/tduckcloud/tduck-platform) 为同一镜像的中英文详情页。

官方 Gitee 的 `docker/` 目录也会挂 `./init-db`（内含 `tduck-v5.sql`）。本文不强制整仓 clone：只下载该 SQL，再用轩辕镜像坐标写 Compose。若你已按官方 clone，把 `image:` 改成 `docker.xuanyuan.run/...` 即可。

### 1.1 社区版填表有什么限制？

官方镜像走的是 **TDuck 社区版**（MIT，允许商用但须保留版权声明；填写页常见 **Powered By**）。适合学习、内网基础收集；**不是**问卷星式「按次 / 按人限填」全家桶。细表见官方 [产品版本对比](https://doc.tduckcloud.com/buyPro/contrast.html) 与 [功能明细](https://www.tduckcloud.com/doc/x/nSJMvQh6)。

| 能力 | 社区版（本文） | 说明 |
|------|----------------|------|
| 拖拽建表 + 公开发布 | ✅ | H5 链接 / 二维码收集；答卷落本机 MySQL |
| 基础组件 | ✅ 约 **30+** | 单行 / 多选 / 日期 / 上传 / 矩阵等常用题型 |
| 显示逻辑（显隐） | ✅ | 按选项显隐题目；**逻辑跳转 / 结束问卷**属商业版 |
| 基础统计与导出 | ✅ | 回收量、趋势；Excel / CSV 全量导出 |
| WebHook | ✅ | 答卷增删改可推到外部 URL |
| 填写端形态 | 仅 **H5** | 无官方小程序 / App 多端包 |
| **密码填写 / 登录后填写 / 白名单** | ❌ | 默认公开链接谁都能填 |
| **IP / 账号 / 微信答题次数限制** | ❌ | 防刷、每人限填一次等需 Pro / X |
| **定时定量回收、选项名额** | ❌ | 到点自动停收、选项配额属商业版 |
| **工作流 / 审批** | ❌ | 无审批节点；提交即入库 |
| 高级组件（NPS、OCR、预约、支付等） | ❌ | 见官方对比表 |
| 表单设计器源码 | 不可改 | v4 / v5 设计器以 npm 引入，社区版可永久免费用，但不能改编辑器源码 |

**选型一句话**：只要「发链接 → 收答卷 → 本机看统计」，社区版够用；若必须「限填一次、密码进入、到点关停、审批流转、小程序」，请评估 [TDuckPro / TDuckX](https://doc.tduckcloud.com/buyPro/contrast.html)，本文不覆盖商业版部署。

官方定位社区版偏学习与体验，**不提供 1v1 即时技术支持**；能力边界以官方对比页为准，版本迭代时个别项可能微调。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；也可 Docker Desktop |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64** 用 `latest`；**arm64** 可用 `latest` 或 `v5` |
| 内存 | 可用 ≥ **2 GB**（MySQL + Java 同机） |
| 磁盘 | 应用约 **736MB** 磁盘占用 + MySQL **1.1GB** + 数据增长 |
| 端口 | 宿主机 **8999**；MySQL 默认仅栈内网 |
| 工作目录 | `/www/wwwroot/tduck-platform` |

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

## 三、拉取镜像

### 3.1 标签怎么选

| 标签 | 架构 | 说明 | 是否跟做 |
|------|------|------|----------|
| **`latest`** | amd64 + arm64 | 较新（约 2026-06） | **推荐** |
| `v5` | **仅 arm64** | 约 2026-05 | 仅 ARM 机器可选 |
| `new` / `4` | 见 Hub | 偏旧 | 不推荐 |

规范上优先写具体版本号，但当前 **`v5` 没有 amd64**，常见 x86_64 Ubuntu 拉 `v5` 会失败；`new` / `4` 过旧。故在上游给出可用的多架构语义化标签之前，跟做使用 **`latest`**，升级前对照 [标签列表](https://xuanyuan.cloud/r/tduckcloud/tduck-platform/tags)。arm64 可改用 `v5`。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/tduckcloud/tduck-platform:latest
docker pull docker.xuanyuan.run/library/mysql:8.0
```

Ubuntu 24.04 实测：

```text
latest: Pulling from tduckcloud/tduck-platform
c3d540630ac8: Download complete
2ebcedb0253b: Pull complete
d5099453b19b: Pull complete
997278513bfd: Pull complete
e4600cca76ff: Pull complete
73cb655b6fa1: Pull complete
d1f56e4c7f2f: Pull complete
613b839994a8: Pull complete
81e2f2053c8f: Pull complete
d316eafedae0: Pull complete
Digest: sha256:74400b35e5397b5cf78f07a82ac9d3594989bb7065edfdea2f95bd3b7f575f49
Status: Downloaded newer image for docker.xuanyuan.run/tduckcloud/tduck-platform:latest
docker.xuanyuan.run/tduckcloud/tduck-platform:latest
```

```text
8.0: Pulling from library/mysql
96d30d9fbee8: Pull complete
297d04cfe470: Pull complete
edf85873f64e: Pull complete
6ef6c7b50a93: Pull complete
e3e5d1ac74c1: Pull complete
0d74d296605b: Pull complete
7534d1db9f8d: Pull complete
4c8a3e0d4e4b: Pull complete
a63160a5eda1: Pull complete
49ec2dab01d9: Pull complete
ab24264a27e9: Pull complete
796812c73292: Download complete
af166387641d: Download complete
Digest: sha256:7dcddc01f13bab2f15cde676d44d01f61fc9f99fe7785e86196dfc07d358ae2b
Status: Downloaded newer image for docker.xuanyuan.run/library/mysql:8.0
docker.xuanyuan.run/library/mysql:8.0
```

```bash
docker images docker.xuanyuan.run/tduckcloud/tduck-platform:latest
docker images docker.xuanyuan.run/library/mysql:8.0
```

```text
IMAGE                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/tduckcloud/tduck-platform:latest   74400b35e539        736MB          267MB

IMAGE                                   ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/library/mysql:8.0   7dcddc01f13b        1.1GB          249MB
```

---

## 四、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/tduck-platform` |
| **macOS** | **`~/docker/tduck-platform`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\tduck-platform` |

### 4.1 准备目录并下载初始化 SQL

```bash
sudo mkdir -p /www/wwwroot/tduck-platform/{mysql-data,upload,init-db}
sudo chown -R 999:999 /www/wwwroot/tduck-platform/mysql-data
cd /www/wwwroot/tduck-platform

# macOS：mkdir -p ~/docker/tduck-platform/{mysql-data,upload,init-db} && cd ~/docker/tduck-platform

wget -O init-db/tduck-v5.sql \
  https://gitee.com/TDuckApp/tduck-platform/raw/master/docker/init-db/tduck-v5.sql
ls -lh init-db/tduck-v5.sql
```

实测 SQL 约 **29KB**。`999:999` 对应官方 MySQL 镜像常见 uid；权限报错见 FAQ。

`/docker-entrypoint-initdb.d` **只在数据目录为空时执行一次**。若你曾经用空库起过栈，见 §4.4。

### 4.2 编写 docker-compose.yml

将 `ChangeMe_Tduck_Root_Pwd` 换成强密码（MySQL 与应用必须一致）：

```bash
cat > docker-compose.yml <<'EOF'
services:
  mysql:
    image: docker.xuanyuan.run/library/mysql:8.0
    container_name: tduck-mysql
    restart: unless-stopped
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_general_ci
      - --default-authentication-plugin=mysql_native_password
    environment:
      MYSQL_ROOT_PASSWORD: ChangeMe_Tduck_Root_Pwd
      MYSQL_DATABASE: tduck
      TZ: Asia/Shanghai
    volumes:
      - ./mysql-data:/var/lib/mysql
      - ./init-db:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-uroot", "-pChangeMe_Tduck_Root_Pwd"]
      interval: 10s
      timeout: 5s
      retries: 18
      start_period: 60s

  tduck-platform:
    image: docker.xuanyuan.run/tduckcloud/tduck-platform:latest
    container_name: tduck-platform
    restart: unless-stopped
    depends_on:
      mysql:
        condition: service_healthy
    ports:
      - "8999:8999"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/tduck?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&tinyInt1isBit=false&nullCatalogMeansCurrent=true&allowPublicKeyRetrieval=true
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: ChangeMe_Tduck_Root_Pwd
      TZ: Asia/Shanghai
    volumes:
      - ./upload:/application/BOOT-INF/lib/upload
EOF
```

| 项 | 说明 |
|----|------|
| `8999:8999` | Web 入口 |
| `./init-db:/docker-entrypoint-initdb.d` | 首次空数据目录时导入 `tduck-v5.sql` |
| JDBC 主机名 `mysql` | Compose **服务名**，不要写 `127.0.0.1` |
| 未映射 3306 | 库仅栈内可达 |

JDBC 参数里的 `tinyInt1isBit=false`、`nullCatalogMeansCurrent=true`、`allowPublicKeyRetrieval=true` 建议保留（官方文档同款；后一项对 MySQL 8 常见）。

### 4.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs -f tduck-platform
```

Ubuntu 24.04 实测：MySQL 到 `healthy` 约 **3 分钟**，应用约 **24 秒** 完成启动。

```text
✔ Network tduck-platform_default Created
✔ Container tduck-mysql          Healthy
✔ Container tduck-platform       Started
```

成功日志（节选）：

```text
:: Spring Boot ::                (v2.7.8)
...
Tomcat initialized with port(s): 8999 (http)
...
DatebookHikariCP - Start completed.
...
SysEnvConfigMapper.selectList  : <==      Total: 2
...
已在数据库中自动生成并保存了新的高强度随机 JWT 密钥。
...
Tomcat started on port(s): 8999 (http) with context path ''
Started TduckApiApplication in 24.207 seconds (JVM running for 25.573)
Tduck-填鸭表单社区版6.0-启动成功>>
启动成功，请访问：http://localhost:8999
请使用管理员账号登录，用户名：admin@tduckcloud.com，密码：123456,然后请尽快修改密码!!!
```

看到 **`社区版6.0-启动成功`**，且没有 `sys_env_config doesn't exist`，即可打开浏览器。

```bash
curl -I http://127.0.0.1:8999
```

### 4.4 已起过空库时怎么补救

若第一次没挂 SQL，日志会反复报 `Table 'tduck.sys_env_config' doesn't exist`。数据目录非空后，init 脚本不会再跑。

**尚无业务数据（推荐）**：确认 `init-db/tduck-v5.sql` 存在，且 Compose 已含 §4.2 的 `init-db` 挂载，然后：

```bash
cd /www/wwwroot/tduck-platform
docker compose down
sudo rm -rf mysql-data/*
docker compose up -d
docker compose logs -f tduck-platform
```

**不想清目录**：手动导入后重启应用：

```bash
cd /www/wwwroot/tduck-platform
wget -O init-db/tduck-v5.sql \
  https://gitee.com/TDuckApp/tduck-platform/raw/master/docker/init-db/tduck-v5.sql
docker exec -i tduck-mysql \
  mysql -uroot -pChangeMe_Tduck_Root_Pwd tduck < init-db/tduck-v5.sql
docker compose restart tduck-platform
```

把 `-p` 后的密码换成 Compose 里的实际值。

---

## 五、浏览器首次初始化

打开 `http://服务器IP:8999`，应出现 Tduck CE 登录页。用 **`admin@tduckcloud.com` / `123456`** 登录（与启动日志一致），登录后立刻改密。

![TDuck CE 登录页：账号密码登录，默认管理员 admin@tduckcloud.com](https://imgs.xuanyuan.cloud/docker/blog/tduck-1.webp)

进入「我的项目」时列表为空，可点 **+ 新建表单**；需要时再试 **AI 智能建表**。

![TDuck 我的项目：首次登录空列表，可 AI 建表或新建表单](https://imgs.xuanyuan.cloud/docker/blog/tduck-2.webp)

![TDuck AI 智能构建表单：输入提示词后生成问卷](https://imgs.xuanyuan.cloud/docker/blog/tduck-3.webp)

下面以手动新建「周末聚餐报名」为例：填名称与描述后进入编辑器。

![TDuck 新建收集表单弹窗：填写表单名称与描述](https://imgs.xuanyuan.cloud/docker/blog/tduck-4.webp)

左侧拖入组件，中间改标题与题干，右侧调必填、占位等属性。实测可先加「姓名」「联系方式」两个单行文本。

![TDuck 表单编辑器：左侧组件库与中间画布](https://imgs.xuanyuan.cloud/docker/blog/tduck-5.webp)

![TDuck 表单编辑：姓名与联系方式字段及右侧属性面板](https://imgs.xuanyuan.cloud/docker/blog/tduck-6.webp)

点「预览」可在手机 / 电脑视图间切换；手机预览旁有扫码二维码（预览模式通常不可真正提交）。

![TDuck 预览：手机视图与扫码预览二维码](https://imgs.xuanyuan.cloud/docker/blog/tduck-7.webp)

![TDuck 预览：电脑视图下的周末聚餐报名表](https://imgs.xuanyuan.cloud/docker/blog/tduck-8.webp)

发布前建议先到侧栏「系统配置」核对 **系统基础域名**（须含协议并带尾部 `/`，例如 `http://192.168.1.35:8999/`），否则外链与二维码可能指向错误地址。文件存储也可一并配好（对应启动时的 Oss 告警）。

---

## 六、主界面与核心功能

### 6.1 逻辑、外观与提交设置

「逻辑」里可为单选 / 下拉等题设置**显隐**规则（社区版有显示逻辑，无商业版那种跳转 / 结束节点）；「外观」可开关 Logo、头图、背景；「设置 → 提交设置」可改提交后文案或跳转 URL。若要找 **密码填写、IP 限次、定时停收、选项名额** 等入口——社区版没有，见 §1.1，勿在设置里空转。

![TDuck 逻辑设置：为空时可立即添加显隐规则](https://imgs.xuanyuan.cloud/docker/blog/tduck-9.webp)

![TDuck 外观设置：手机预览与 Logo / 头图 / 背景开关](https://imgs.xuanyuan.cloud/docker/blog/tduck-10.webp)

![TDuck 提交设置：提交后提示文案与跳转网址](https://imgs.xuanyuan.cloud/docker/blog/tduck-11.webp)

### 6.2 发布、填写与统计

「发布 → 立即发布」后，可复制专属链接或下载二维码。公开填写页底部有 Powered By 标识，旁侧可扫码打开。

![TDuck 发布页：立即发布以生成链接与二维码](https://imgs.xuanyuan.cloud/docker/blog/tduck-12.webp)

![TDuck 发布成功：网页链接分享与扫码填写](https://imgs.xuanyuan.cloud/docker/blog/tduck-13.webp)

![TDuck 公开填写页：周末聚餐报名与右侧扫码](https://imgs.xuanyuan.cloud/docker/blog/tduck-14.webp)

「统计」汇总有效回收量、浏览量、回收率与周趋势；「数据」里可查看具体答卷（有提交后才有明细）。

![TDuck 统计视图：有效回收量、浏览量与周收集趋势](https://imgs.xuanyuan.cloud/docker/blog/tduck-15.webp)

### 6.3 模板、用户与系统配置

共享模板库可按名称检索；用户管理里可见默认 `admin@tduckcloud.com`（以及 SQL 种子里的 `test` 账号，生产建议禁用或改密）。系统配置页版本徽章为 **V6.0**，并可切换到文件存储、邮件、短信、微信、AI 等页签。

![TDuck 共享模板：模板库检索与空状态](https://imgs.xuanyuan.cloud/docker/blog/tduck-16.webp)

![TDuck 用户管理：默认 admin@tduckcloud.com 与 test 账号](https://imgs.xuanyuan.cloud/docker/blog/tduck-17.webp)

![TDuck 系统配置：版本 V6.0、系统名称与基础域名](https://imgs.xuanyuan.cloud/docker/blog/tduck-18.webp)

更多能力见 [填鸭表单文档](https://doc.tduckcloud.com)。

---

## 七、安全、备份与生产加固

| 项 | 建议 |
|----|------|
| 默认账号 | 立刻改 `admin@tduckcloud.com` 密码；处理 SQL 自带的 `test` 用户 |
| 基础域名 | 写成外网 / 内网真实访问地址，保证链接与二维码正确 |
| 数据库密码 | 勿保留文档示例；勿把 Compose 提交到公开仓库 |
| 端口 | 公网勿裸奔 **8999**；前面加反向代理与 TLS |
| 备份 | 定期打包 `mysql-data`、`upload`（可含 `init-db` 与 Compose） |

```bash
cd /www/wwwroot/tduck-platform
docker compose stop
tar -czf tduck-backup-$(date +%Y%m%d).tgz mysql-data upload init-db docker-compose.yml
docker compose start
```

---

## 八、备选：docker run（临时 / 无 Compose）

适用于已有可访问的 MySQL，且**已导入 `tduck-v5.sql`**。容器内不要把库地址写成宿主机 `127.0.0.1`（Linux 用宿主机局域网 IP；Docker Desktop 可用 `host.docker.internal`）。

```bash
mysql -uroot -p -e "CREATE DATABASE IF NOT EXISTS tduck DEFAULT CHARACTER SET utf8mb4;"
mysql -uroot -p tduck < /www/wwwroot/tduck-platform/init-db/tduck-v5.sql

docker run -d \
  --name tduck-platform \
  --restart unless-stopped \
  -p 8999:8999 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://主机或IP:3306/tduck?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&tinyInt1isBit=false&nullCatalogMeansCurrent=true&allowPublicKeyRetrieval=true" \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD='你的数据库密码' \
  -v /www/wwwroot/tduck-platform/upload:/application/BOOT-INF/lib/upload \
  docker.xuanyuan.run/tduckcloud/tduck-platform:latest
```

```bash
docker logs -f tduck-platform
curl -I http://127.0.0.1:8999
```

成功时不应再出现 `sys_env_config doesn't exist`。

---

## 九、迁移与升级说明

1. 备份 `mysql-data`、`upload`、`init-db`、`docker-compose.yml`。
2. 在 [标签列表](https://xuanyuan.cloud/r/tduckcloud/tduck-platform/tags) 确认目标标签架构（amd64 / arm64）。
3. 修改 Compose 中 `image:` 后执行：

```bash
docker compose pull
docker compose up -d
docker compose logs -f tduck-platform
```

4. 浏览器登录冒烟测试。跨旧线（如 `4` → `latest`）前先在测试机验证库结构。

---

## 十、常见问题 FAQ

**Q1：拉取 `v5` 报 `no matching manifest`？**  
A：`v5` 当前多为 arm64。x86_64 请用 `latest`。

**Q2：日志报 `Table 'tduck.sys_env_config' doesn't exist`？**  
A：镜像不会自动建表。按 §4.1 下载 SQL 并挂到 `/docker-entrypoint-initdb.d`；数据目录已非空则按 §4.4 清库或手动 `mysql < tduck-v5.sql`。

**Q3：连库失败（不是缺表）？**  
A：JDBC 主机是否为服务名 `mysql`；密码是否与 `MYSQL_ROOT_PASSWORD` 一致；MySQL 是否已 `healthy`；是否含 `allowPublicKeyRetrieval=true`。

**Q4：浏览器打不开？**  
A：首次冷启动可能要数分钟；若在缺表循环，先修 Q2。确认防火墙放行 **8999**。

**Q5：上传文件刷新后丢失？**  
A：确认已挂载 `./upload:/application/BOOT-INF/lib/upload`。

**Q6：默认账号登不进去？**  
A：须先成功导入 SQL。账号为 `admin@tduckcloud.com` / `123456`（见启动日志）。

**Q7：该用 `tduck-v5.sql` 还是 `tduck-v6.sql`？**  
A：跟做官方 Docker 目录用 **`docker/init-db/tduck-v5.sql`**。实测 `latest` 横幅为社区版 6.0，与该 SQL 可跑通。`doc/tduck-v6.sql` 面向另一套安装包，换用前请先在测试机验证。

**Q8：日志有 `OssStorageFactory … 更新存储配置失败`？**  
A：仍可启动成功。登录后到「系统配置 → 文件存储」配置即可。

**Q9：经轩辕镜像拉 MySQL 怎么写坐标？**  
A：library 镜像写 **`docker.xuanyuan.run/library/mysql:8.0`**，不要写成无 `library/` 的 `mysql:8.0` 前缀形式（若你习惯 Hub 短名，在轩辕加速域下仍建议显式 `library/`）。

**Q10：社区版填表有哪些限制？能限每人只填一次吗？**  
A：公开 H5 收集、基础组件、显隐逻辑、统计导出、WebHook 可用。**密码 / 登录门槛、IP·账号·微信答题次数、定时定量回收、选项名额、审批流、原生小程序**等属 Pro / X，社区版没有。详见 §1.1 与官方 [版本对比](https://doc.tduckcloud.com/buyPro/contrast.html)。

---

## 十一、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/tduckcloud/tduck-platform:latest
docker pull docker.xuanyuan.run/library/mysql:8.0

# SQL
mkdir -p /www/wwwroot/tduck-platform/init-db
wget -O /www/wwwroot/tduck-platform/init-db/tduck-v5.sql \
  https://gitee.com/TDuckApp/tduck-platform/raw/master/docker/init-db/tduck-v5.sql

# Compose
cd /www/wwwroot/tduck-platform
docker compose up -d
docker compose ps
docker compose logs -f tduck-platform
docker compose down
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [tduckcloud/tduck-platform 镜像页](https://xuanyuan.cloud/zh/r/tduckcloud/tduck-platform) | [https://xuanyuan.cloud/zh/r/tduckcloud/tduck-platform](https://xuanyuan.cloud/zh/r/tduckcloud/tduck-platform) |
| [tduckcloud/tduck-platform 概览](https://xuanyuan.cloud/r/tduckcloud/tduck-platform) | [https://xuanyuan.cloud/r/tduckcloud/tduck-platform](https://xuanyuan.cloud/r/tduckcloud/tduck-platform) |
| [tduckcloud/tduck-platform 标签列表](https://xuanyuan.cloud/r/tduckcloud/tduck-platform/tags) | [https://xuanyuan.cloud/r/tduckcloud/tduck-platform/tags](https://xuanyuan.cloud/r/tduckcloud/tduck-platform/tags) |
| [官方 · Docker 部署](https://doc.tduckcloud.com/openSource/deploy/dockerDeploy.html) | [https://doc.tduckcloud.com/openSource/deploy/dockerDeploy.html](https://doc.tduckcloud.com/openSource/deploy/dockerDeploy.html) |
| [官方 · 产品版本对比](https://doc.tduckcloud.com/buyPro/contrast.html) | [https://doc.tduckcloud.com/buyPro/contrast.html](https://doc.tduckcloud.com/buyPro/contrast.html) |
| [官方 · 功能明细对比](https://www.tduckcloud.com/doc/x/nSJMvQh6) | [https://www.tduckcloud.com/doc/x/nSJMvQh6](https://www.tduckcloud.com/doc/x/nSJMvQh6) |
| [Gitee · TDuckApp/tduck-platform](https://gitee.com/TDuckApp/tduck-platform) | [https://gitee.com/TDuckApp/tduck-platform](https://gitee.com/TDuckApp/tduck-platform) |
| [Gitee · docker/init-db/tduck-v5.sql](https://gitee.com/TDuckApp/tduck-platform/raw/master/docker/init-db/tduck-v5.sql) | [https://gitee.com/TDuckApp/tduck-platform/raw/master/docker/init-db/tduck-v5.sql](https://gitee.com/TDuckApp/tduck-platform/raw/master/docker/init-db/tduck-v5.sql) |
| [Docker Hub · tduckcloud/tduck-platform](https://hub.docker.com/r/tduckcloud/tduck-platform) | [https://hub.docker.com/r/tduckcloud/tduck-platform](https://hub.docker.com/r/tduckcloud/tduck-platform) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`latest` + `tduck-v5.sql` + Compose**，端口 **8999**，实测为 **社区版 6.0**。
- 空库缺表是最常见坑，按 §4.1 / §4.4 处理。
- 默认 **`admin@tduckcloud.com` / `123456`**，上线改密、写好基础域名，并备份 `mysql-data` 与 `upload`。
- 社区版适合公开 H5 基础收集；**限填、密码门、定时停收、审批**等见 §1.1，勿按商业版预期。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/tduck-platform-docker-deploy


