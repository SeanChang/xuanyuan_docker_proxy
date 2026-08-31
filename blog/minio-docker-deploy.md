# Docker 部署 MinIO：轻松搭建 S3 兼容对象存储平台

![Docker 部署 MinIO：轻松搭建 S3 兼容对象存储平台](https://imgs.xuanyuan.cloud/docker/blog/minio.webp)

*分类: Docker部署教程 | 标签: MinIO,Docker,轩辕镜像,对象存储,S3,私有化部署,部署教程 | 发布时间: 2026-08-26 04:15:39*

> 数据库备份还在往 /backup 里 cp：目录越堆越乱，想给开发一条限时下载链接，只能开 Samba 或再拷 U 盘。业务代码已经按 Amazon S3 写好了 SDK——Access Key、Bucket、预签名 URL 都现成——却没有一台对内的对象存储。CI 产物留在 runner 本地，换机器就丢；监控录像和照片混在 NAS 共享目录里，没法按桶授权，也开不出「只给这一个文件、十分钟有效」的地址。

*本文基于 [minio/minio:RELEASE.2025-09-07T16-13-09Z](https://xuanyuan.cloud/zh/r/minio/minio)，实测引擎 **RELEASE.2025-09-07T16-13-09Z**，测试平台 **Ubuntu 24.04** Linux。*

数据库备份还在往 `/backup` 里 `cp`：目录越堆越乱，想给开发一条限时下载链接，只能开 Samba 或再拷 U 盘。业务代码已经按 **Amazon S3** 写好了 SDK——Access Key、Bucket、预签名 URL 都现成——却没有一台对内的对象存储。CI 产物留在 runner 本地，换机器就丢；监控录像和照片混在 NAS 共享目录里，没法按桶授权，也开不出「只给这一个文件、十分钟有效」的地址。

买公有云对象存储能立刻通，账单按流量走，客户附件、财务导出、内网日志却不宜出域。自己从源码编译、再上纠删码集群，对只要先有一个内网 `IP:9001` 的人成本太高。机房或家里已经有一台跑 Docker 的 Ubuntu，缺的是：镜像拉起来、浏览器能进控制台、应用继续用熟悉的 S3 API。

**MinIO**（[GitHub · minio/minio](https://github.com/minio/minio)）提供兼容 Amazon S3 的对象存储，许可证 **GNU AGPLv3**。镜像 **`minio/minio`**（[镜像页](https://xuanyuan.cloud/zh/r/minio/minio)）里，**9000** 是 S3 API，**9001** 是 Web Console。本文跟做 **单节点单盘 Standalone**，适合评估、开发和内网备份；版本控制、对象锁定、桶复制需要纠删码（至少 4 块盘），不在本文范围。

> **跟做前先看**：Docker Hub 上 `minio/minio` 已 **Archived**，约 **11 个月**未推新。跟做钉死 **`RELEASE.2025-09-07T16-13-09Z`**。GitHub 仓库于 **2026-04-25** 归档后社区版只发源码；更晚的源码标签（如 `RELEASE.2025-10-15T17-29-55Z`）**不一定**在 Hub 上有镜像，不要写进命令。同站其它发行见 **§1.1**，**不要和本文混用 `./data`**。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 浏览器管桶 | 打开 `http://192.168.1.35:9001`，建桶、上传、下载 |
| 应用对接 S3 | Endpoint 填 `http://IP:9000`，用 Access Key / Secret Key |
| 备份与归档 | 备份脚本、日志采集的目标改成 S3 兼容接口 |
| 命令行列对象 | 另拉 `minio/mc`，`ls local/桶名` 核对网页上传的结果 |

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`minio/minio:RELEASE.2025-09-07T16-13-09Z`**，**Docker Compose** 映射 **9000→9000**、**9001→9001**，登录后确认 License、建桶 **`testbuckets`**、上传，再用 **`minio/mc`** 列对象。无 Compose 时见第九节 **`docker run`**。局域网以 **`192.168.1.35`** 为例，请换成你的 IP。文内附 **6** 张实测截图。

> **上手要点**
> - **部署**：第五节 Compose；临时试玩见第九节
> - **访问**：宿主机 **9001** → Console；**9000** → S3 API（实测 `http://192.168.1.35:9001`）
> - **数据**：`./data` → `/data`；`command` 必须含 `--console-address ":9001"`
> - **账号**：**`minioadmin` / `ChangeMe_minio8`**（用户名 3～20 位，密码 ≥ 8 位）；上线立刻改掉
> - **首次**：登录后点 License 的 **Acknowledge**
> - **标签**：服务端 **`RELEASE.2025-09-07T16-13-09Z`**；客户端 **`minio/mc:RELEASE.2025-08-13T08-35-41Z`**（§7.4）。勿写 `latest`
> - **mc 路径**：`local/桶名`，不要只写桶名
> - **模式**：Standalone；单盘不要指望对象锁定 / 桶复制

官方容器说明：[docs/docker](https://github.com/minio/minio/blob/master/docs/docker/README.md)。项目：[GitHub · minio/minio](https://github.com/minio/minio)（已归档）。

---

## 一、MinIO 是什么？

对象按 **桶 + 对象键** 存放：浏览器走 Console，应用走 S3 API。它不是网盘同步客户端，也不会把本地文件夹自动变成「我的云盘」。

| | MinIO（本文） | 公有云对象存储 | 普通文件夹 / Samba |
|--|----------------|----------------|---------------------|
| 入口 | `:9001` Console + `:9000` S3 | 厂商控制台 + S3 | 文件管理器 |
| 数据 | 自己的 `/data` | 厂商机房 | 本机或 NAS |
| 接口 | Amazon S3 兼容 | 各家 S3 / 专有 | 无对象 API |
| 适合 | 内网备份、联调、自托管附件 | 已上云、要全球加速 | 直接拷文件 |
| 注意 | Hub 镜像已停更；Standalone 功能子集 | 出域、账单 | 难做限时链接与按桶授权 |

```text
浏览器 Console          应用 / aws-cli / SDK / mc
   │  :9001                   │  :9000
   ▼                          ▼
          minio/minio
               └── /data  ← 宿主机 ./data
```

### 1.1 同站常见 MinIO 镜像怎么选

本文只跟做 **`minio/minio`**。名字里带 MinIO 的镜像维护方、标签线不同，**不要混用同一份 Compose / `./data`**（「最近更新」以撰写时轩辕页为准，选库前再打开页面核对）：

| 镜像 | 定位 | 更新（撰写时） | 适合谁 | 轩辕镜像页 |
|------|------|----------------|--------|------------|
| **`minio/minio`（本文）** | 官方历史 Hub 镜像 | Archived，约 11 个月未推新；钉 **`RELEASE.2025-09-07T16-13-09Z`** | 旧文档写死官方坐标；评估 Standalone | [minio/minio](https://xuanyuan.cloud/zh/r/minio/minio) |
| **`elestio/minio`** | Elestio 打包 | 约 10 个月级；示例常按 Elestio 平台习惯写 | 跟 Elestio Compose 样例 | [elestio/minio](https://xuanyuan.cloud/zh/r/elestio/minio) |
| **`alpine/minio`** | 官方停发后社区自动构建 | 可跟到更晚 RELEASE（如 `RELEASE.2025-10-15T17-29-55Z`）；勿用 `latest-release` 进生产 | 要较新社区容器、多架构 | [alpine/minio](https://xuanyuan.cloud/zh/r/alpine/minio) |
| **`bitnami/minio`** | Bitnami Secure Images | 约 11 个月级；Hub 免费通道已收紧 | Bitnami 栈 / 商业订阅 | [bitnami/minio](https://xuanyuan.cloud/zh/r/bitnami/minio) |
| **`bitnamilegacy/minio`** | Bitnami 旧版备份 | 约 1 年未更新；**勿长期生产** | 临时迁出旧目录 | [bitnamilegacy/minio](https://xuanyuan.cloud/zh/r/bitnamilegacy/minio) |
| **`bitnamicharts/minio`** | Helm Chart 相关 | 偏 Kubernetes | 已在用 Bitnami Charts | [bitnamicharts/minio](https://xuanyuan.cloud/zh/r/bitnamicharts/minio) |
| **`rook/minio`** | Rook 编排 | 约 6 年级 | Rook 场景，非家用单机首选 | [rook/minio](https://xuanyuan.cloud/zh/r/rook/minio) |
| **`cleanstart/minio`** | CleanStart 加固小镜像 | 站点可见较新更新 | 小 footprint / 加固评估 | [cleanstart/minio](https://xuanyuan.cloud/zh/r/cleanstart/minio) |

仍要较新社区容器时优先看 [alpine/minio](https://xuanyuan.cloud/zh/r/alpine/minio)（钉死具体 `RELEASE.…`）。Elestio 示例里的 `172.17.0.1:9000` 不要抄到普通家用 Docker。`/r/` 与 `/zh/r/` 是同一镜像的不同页面，例如 [概览](https://xuanyuan.cloud/r/minio/minio)。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（以 tags 页为准） |
| 内存 | 评估 ≥ **512 MB**；大对象、多连接再加 |
| 磁盘 | 实测镜像 CONTENT **62.2 MB** / DISK **241 MB**；对象数据另算，挂在 `./data` |
| 端口 | 宿主机 **9000**（API）、**9001**（Console）；可改左侧 |

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

```bash
ss -tlnp | grep -E '9000|9001'
```

被占用时改成 `"19000:9000"`、`"19001:9001"`，浏览器改访新的左侧端口。

---

## 三、标签怎么选

跟做只写 **`RELEASE.2025-09-07T16-13-09Z`**，不要写 `latest`。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`RELEASE.2025-09-07T16-13-09Z`** | Hub 上可拉到的较新稳定版 | **本文跟做** |
| `RELEASE.2025-09-07T16-13-09Z-cpuv1` | 同一版本，面向较老 CPU | 旧硬件报非法指令时 |
| `RELEASE.2025-07-23T15-54-02Z` 等 | 更早 RELEASE | 回滚 |
| `latest` / `latest-cicd` | 浮动 / CI | **不要写入跟做命令** |

完整列表：[tags](https://xuanyuan.cloud/r/minio/minio/tags)。GitHub 上更晚的标签，先确认 Hub **真有**再改 compose。升级时 pull、Compose、`docker run` 三处一起改。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z
```

Ubuntu 24.04 实测（`ikuai-ubuntu2404`）：

```text
RELEASE.2025-09-07T16-13-09Z: Pulling from minio/minio
Digest: sha256:14cea493d9a34af32f524e538b8346cf79f3321eff8e708c1e2960462bd8936e
Status: Downloaded newer image for docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z
docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z
```

```bash
docker images docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z
```

```text
IMAGE                                                          ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z   14cea493d9a3        241MB         62.2MB
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/minio` |
| **macOS** | **`~/docker/minio`** |
| **Windows（Docker Desktop）** | 如 `C:\docker\minio` |

### 5.1 准备目录

```bash
mkdir -p /www/wwwroot/minio/data
chown -R 1000:1000 /www/wwwroot/minio
cd /www/wwwroot/minio

# macOS：mkdir -p ~/docker/minio/data && cd ~/docker/minio
```

`id` 不是 1000 时，把 `chown` 改成你的 uid/gid。非 root 给 `mkdir` / `chown` 加 `sudo`。

### 5.2 编写 docker-compose.yml

密码至少 **8** 位，上线前换成自己的随机串，勿提交到 Git：

```bash
cat > docker-compose.yml <<'EOF'
services:
  minio:
    image: docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z
    container_name: minio
    restart: unless-stopped
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      TZ: Asia/Shanghai
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: ChangeMe_minio8
    volumes:
      - ./data:/data
    command: server /data --console-address ":9001"
EOF
```

| 项 | 说明 |
|----|------|
| `image` | 钉死 **`RELEASE.2025-09-07T16-13-09Z`** |
| `ports` | **9000→9000**（S3）、**9001→9001**（Console） |
| `MINIO_ROOT_USER` / `PASSWORD` | 用户名 3～20 位；密码 ≥ 8 位 |
| `volumes` | `./data` → `/data` |
| `command` | 必须带 **`--console-address ":9001"`**，否则 Console 可能落在随机端口 |

不要把端口写成 `172.17.0.1:9000:9000`（局域网浏览器进不去）。不要依赖未设环境变量时的内置默认 **`minioadmin` / `minioadmin`**。

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network minio_default Created
 ✔ Container minio       Started
```

```text
NAME      IMAGE                                                          COMMAND                  SERVICE   CREATED          STATUS          PORTS
minio     docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z   "/usr/bin/docker-ent…"   minio     41 seconds ago   Up 39 seconds   0.0.0.0:9000-9001->9000-9001/tcp, [::]:9000-9001->9000-9001/tcp
```

```text
minio  | INFO: Formatting 1st pool, 1 set(s), 1 drives per set.
minio  | INFO: WARNING: Host local has more than 0 drives of set. A host failure will result in data becoming unavailable.
minio  | Version: RELEASE.2025-09-07T16-13-09Z (go1.24.6 linux/amd64)
minio  | API: http://172.24.0.2:9000  http://127.0.0.1:9000
minio  | WebUI: http://172.24.0.2:9001 http://127.0.0.1:9001
```

单盘 WARNING 表示主机故障时数据不可用，评估环境可先忽略。浏览器用宿主机 IP 的 **9001**（如 `http://192.168.1.35:9001`），不要用日志里的 `172.24.0.2`。

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:9000/minio/health/live
```

```text
200
```

本机也可用 `http://127.0.0.1:9001`。

---

## 六、浏览器首次登录

```text
http://192.168.1.35:9001
```

不要拿 `:9000` 当网站首页——那是 S3 API。若从 9000 跳到容器内网地址，直接改访 **9001**，或按第八节设 `MINIO_BROWSER_REDIRECT_URL`。

### 6.1 登录页

右侧填：

| 字段 | 跟做值 |
|------|--------|
| Username | `minioadmin` |
| Password | `ChangeMe_minio8` |

点 **Login**。

![MinIO Console 登录页：Username Password 与 Login](https://imgs.xuanyuan.cloud/docker/blog/minio-1.webp)

### 6.2 确认 License

首次登录可能弹出 **License**（GNU AGPL v3）。点 **Acknowledge** 后再用 Object Browser。

![MinIO 首次登录：License 对话框点 Acknowledge](https://imgs.xuanyuan.cloud/docker/blog/minio-2.webp)

### 6.3 进入 Object Browser

尚无桶时，中间卡片或左侧 **+ Create Bucket** 都可新建。

![MinIO Object Browser：尚无桶，提示 Create a Bucket](https://imgs.xuanyuan.cloud/docker/blog/minio-3.webp)

---

## 七、建桶、上传与命令行

### 7.1 创建存储桶

桶名用小写 DNS 风格，约 3～63 字符，不要空格和大写。实测填 **`testbuckets`**，点 **Create Bucket**。

![MinIO Create Bucket：桶名填写 testbuckets](https://imgs.xuanyuan.cloud/docker/blog/minio-4.webp)

左侧出现 **testbuckets**；进入后对象列表为空，右上有 **Upload**。实测创建时间约 **2026-08-26 11:42**（GMT+8），Access 为 **PRIVATE**。

![MinIO testbuckets 桶：尚无对象，可点 Upload](https://imgs.xuanyuan.cloud/docker/blog/minio-5.webp)

Standalone 单盘不要指望对象锁定、合规保留、桶复制；那些能力要纠删码多盘部署。

### 7.2 上传对象

点 **Upload**，选一个小文件。实测上传 **`minio-5.png`**（约 141KiB）：列表出现文件名，右侧上传面板显示 100%。

![MinIO testbuckets：已上传 minio-5.png 且进度 100%](https://imgs.xuanyuan.cloud/docker/blog/minio-6.webp)

对象键可带前缀（如 `2026/08/demo.png`），界面按前缀展示，宿主机上并不是真多层目录。点开对象可下载；分享 / 预签名请设过期时间，公网须 HTTPS。

### 7.3 给应用单独开钥匙

不要把 root 写进业务代码。在 Console 里打开 **Identity** → **Access Keys**（文案因版本可能略有差异），创建一把仅给该应用用的钥匙；能限桶、限操作更好。

| 项 | 值 |
|----|-----|
| Endpoint | `http://192.168.1.35:9000`（不是 9001） |
| Access Key / Secret Key | 新建钥匙，或试验时用 root |
| Bucket | `testbuckets` |
| Region | 可填 `us-east-1`（有的 SDK 必填） |
| Path style | 自建 S3 常需开启 |

### 7.4 命令行：minio/mc

批量操作用客户端镜像 [minio/mc](https://xuanyuan.cloud/zh/r/minio/mc)，连 **9000**。跟做钉 **`RELEASE.2025-08-13T08-35-41Z`**（[tags](https://xuanyuan.cloud/r/minio/mc/tags)），勿写 `latest` / `edge`。

```bash
docker pull docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z
```

```text
Digest: sha256:a7fe349ef4bd8521fb8497f55c6042871b2ae640607cf99d9bede5e9bdf11727
Status: Downloaded newer image for docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z
```

```text
IMAGE                                                       ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z   a7fe349ef4bd        117MB         29.8MB
```

用 `MC_HOST_local` 指定 Endpoint 与凭据（别名 `local` → 路径写 `local/...`）：

```bash
# 列所有桶
docker run --rm --network host \
  -e MC_HOST_local='http://minioadmin:ChangeMe_minio8@127.0.0.1:9000' \
  docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z \
  ls local
```

```text
[2026-08-26 03:42:28 UTC]     0B testbuckets/
```

```bash
# 列桶内对象（必须带 local/）
docker run --rm --network host \
  -e MC_HOST_local='http://minioadmin:ChangeMe_minio8@127.0.0.1:9000' \
  docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z \
  ls local/testbuckets
```

```text
[2026-08-26 03:42:52 UTC] 141KiB STANDARD minio-5.png
```

只写 `ls testbuckets/` 会报 `Requested path /testbuckets not found`（被当成磁盘路径）。

```bash
# 上传 / 下载需挂卷
echo 'hello minio' > /tmp/demo.txt
docker run --rm --network host \
  -v /tmp:/work -w /work \
  -e MC_HOST_local='http://minioadmin:ChangeMe_minio8@127.0.0.1:9000' \
  docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z \
  cp ./demo.txt local/testbuckets/

docker run --rm --network host \
  -e MC_HOST_local='http://minioadmin:ChangeMe_minio8@127.0.0.1:9000' \
  docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z \
  admin info local
```

| 注意 | 说明 |
|------|------|
| 路径 | `ls local` 列桶；`ls local/testbuckets` 列对象 |
| `--network host` | 便于访问 `127.0.0.1:9000`；否则改成局域网 IP |
| 未设 `MC_HOST_*` | 默认可能连公网 `play` 演示站 |
| 密码含 `@` `:` `/` | URL 形式 `MC_HOST_` 易解析错，改用本机 `mc alias set` |

本机已装 `mc` 时：

```bash
mc alias set local http://127.0.0.1:9000 minioadmin ChangeMe_minio8
mc ls local
mc ls local/testbuckets
mc cp /tmp/demo.txt local/testbuckets/
```

已装 AWS CLI 时，`--endpoint-url` 指向 **9000**：

```bash
export AWS_ACCESS_KEY_ID=minioadmin
export AWS_SECRET_ACCESS_KEY=ChangeMe_minio8
aws --endpoint-url http://127.0.0.1:9000 s3 ls
aws --endpoint-url http://127.0.0.1:9000 s3 ls s3://testbuckets/
```

局域网其它机器把 `127.0.0.1` 换成 **`192.168.1.35`**。

---

## 八、安全、反代与升级

| 项 | 建议 |
|----|------|
| 版本 | 保持具体 RELEASE；Hub 已停更，`latest` 不会变新 |
| 密码 / 钥匙 | 改掉跟做串；业务用 Access Key |
| 暴露 | 优先内网或 VPN；上网则 9000 / 9001 都走 HTTPS |
| 反代 | API 与 Console 分域名或分路由，分别转到 9000 / 9001 |
| 重定向 | `MINIO_BROWSER_REDIRECT_URL`；证书不含容器 IP 时再设 `MINIO_SERVER_URL` |
| 备份 | 停写入后备份整个 `./data` |
| 升级 | 换镜像标签重建；**不要**对容器跑 `mc admin update` |
| 生产 | 多盘纠删码；单容器单盘只适合评估与轻量内网 |

```yaml
      MINIO_BROWSER_REDIRECT_URL: https://console.example.com
      MINIO_SERVER_URL: https://s3.example.com
```

改 root 密码：改 compose 后 `docker compose up -d` 重建，只改文件不重建无效。

```bash
cd /www/wwwroot/minio
docker compose pull
docker compose up -d
```

Hub 不再发新版时，`pull` 不会出现更新 RELEASE；要新修复需自建镜像或换其它仍在维护的发行（与本文数据目录不通用，先备份）。

---

## 九、备选：docker run

仅临时试玩或没有 Compose 时使用：

```bash
mkdir -p /www/wwwroot/minio/data
chown -R 1000:1000 /www/wwwroot/minio

docker run -d \
  --name minio \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  -e TZ=Asia/Shanghai \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=ChangeMe_minio8 \
  -v /www/wwwroot/minio/data:/data \
  docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z \
  server /data --console-address ":9001"
```

访问 `http://IP:9001`。与 Compose 重名时先 `docker compose down`。最后一行 `server ...` 写在镜像名后面，不要漏。

---

## 十、常见问题 FAQ

**Q1：打不开 `:9001`？**  
看 `compose ps`、防火墙、本机 `curl http://127.0.0.1:9001/`。冲突则改左侧端口。日志里 Console 在随机端口 → 补 `--console-address ":9001"`。

**Q2：登录失败或容器起不来？**  
用户名 3～20 位，密码 ≥ **8** 位；检查 YAML 空格与引号。

**Q3：默认账号？**  
未设环境变量时内置 `minioadmin` / `minioadmin`。本文 compose 已设环境变量，用文件里那一对。

**Q4：网页能登，应用连不上？**  
网页 **9001**，S3 **9000**。自建存储常需 path-style；内网 HTTP 试验时关掉强制 HTTPS。

**Q5：打开 `:9000` 跳到进不去的地址？**  
重定向用了容器内网 IP。直接访 `http://IP:9001`，或设 `MINIO_BROWSER_REDIRECT_URL`。

**Q6：单盘能开版本控制 / 对象锁定吗？**  
不能按生产预期开启；需要纠删码（每节点至少 4 块盘）。见官方说明。

**Q7：和 elestio / alpine / bitnami 的区别？**  
见 **§1.1**。本文只跟做 `minio/minio:RELEASE.2025-09-07T16-13-09Z`。

**Q8：为什么标签停在 2025-09？**  
Hub 仓库已归档。跟做钉死 Hub 上仍存在的 RELEASE，不要编造没有的 tag。

**Q9：写不进 `/data`？**  
`chown -R 1000:1000 /www/wwwroot/minio/data` 后再起。

**Q10：改了密码网页还是旧的？**  
需要 `docker compose up -d` 重建容器。

**Q11：`mc ls testbuckets/` 报 path not found？**  
写成 **`ls local/testbuckets`**。

**Q12：拉取 401 / 402？**  
401：[登录认证](https://xuanyuan.cloud/usage/login)。402：[充值](https://xuanyuan.cloud/recharge)。其它：[常见问题](https://xuanyuan.cloud/faq)。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z

cd /www/wwwroot/minio
# macOS：cd ~/docker/minio
docker compose up -d
docker compose ps
docker compose logs -f --tail 100
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:9000/minio/health/live

# Console http://192.168.1.35:9001
# S3     http://192.168.1.35:9000
# 登录 minioadmin / ChangeMe_minio8

docker pull docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z
docker run --rm --network host \
  -e MC_HOST_local='http://minioadmin:ChangeMe_minio8@127.0.0.1:9000' \
  docker.xuanyuan.run/minio/mc:RELEASE.2025-08-13T08-35-41Z \
  ls local/testbuckets

docker compose down
```

备选：

```bash
docker run -d --name minio --restart unless-stopped \
  -p 9000:9000 -p 9001:9001 \
  -e TZ=Asia/Shanghai \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=ChangeMe_minio8 \
  -v /www/wwwroot/minio/data:/data \
  docker.xuanyuan.run/minio/minio:RELEASE.2025-09-07T16-13-09Z \
  server /data --console-address ":9001"
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [minio/minio 镜像页](https://xuanyuan.cloud/zh/r/minio/minio) | [https://xuanyuan.cloud/zh/r/minio/minio](https://xuanyuan.cloud/zh/r/minio/minio) |
| [minio/minio 概览](https://xuanyuan.cloud/r/minio/minio) | [https://xuanyuan.cloud/r/minio/minio](https://xuanyuan.cloud/r/minio/minio) |
| [minio/minio 标签列表](https://xuanyuan.cloud/r/minio/minio/tags) | [https://xuanyuan.cloud/r/minio/minio/tags](https://xuanyuan.cloud/r/minio/minio/tags) |
| [GitHub · minio/minio（已归档）](https://github.com/minio/minio) | [https://github.com/minio/minio](https://github.com/minio/minio) |
| [GitHub · Docker Quickstart](https://github.com/minio/minio/blob/master/docs/docker/README.md) | [https://github.com/minio/minio/blob/master/docs/docker/README.md](https://github.com/minio/minio/blob/master/docs/docker/README.md) |
| [Docker Hub · minio/minio](https://hub.docker.com/r/minio/minio) | [https://hub.docker.com/r/minio/minio](https://hub.docker.com/r/minio/minio) |
| [elestio/minio 镜像页](https://xuanyuan.cloud/zh/r/elestio/minio) | [https://xuanyuan.cloud/zh/r/elestio/minio](https://xuanyuan.cloud/zh/r/elestio/minio) |
| [alpine/minio 镜像页](https://xuanyuan.cloud/zh/r/alpine/minio) | [https://xuanyuan.cloud/zh/r/alpine/minio](https://xuanyuan.cloud/zh/r/alpine/minio) |
| [bitnami/minio 镜像页](https://xuanyuan.cloud/zh/r/bitnami/minio) | [https://xuanyuan.cloud/zh/r/bitnami/minio](https://xuanyuan.cloud/zh/r/bitnami/minio) |
| [bitnamilegacy/minio 镜像页](https://xuanyuan.cloud/zh/r/bitnamilegacy/minio) | [https://xuanyuan.cloud/zh/r/bitnamilegacy/minio](https://xuanyuan.cloud/zh/r/bitnamilegacy/minio) |
| [bitnamicharts/minio 镜像页](https://xuanyuan.cloud/zh/r/bitnamicharts/minio) | [https://xuanyuan.cloud/zh/r/bitnamicharts/minio](https://xuanyuan.cloud/zh/r/bitnamicharts/minio) |
| [rook/minio 镜像页](https://xuanyuan.cloud/zh/r/rook/minio) | [https://xuanyuan.cloud/zh/r/rook/minio](https://xuanyuan.cloud/zh/r/rook/minio) |
| [cleanstart/minio 镜像页](https://xuanyuan.cloud/zh/r/cleanstart/minio) | [https://xuanyuan.cloud/zh/r/cleanstart/minio](https://xuanyuan.cloud/zh/r/cleanstart/minio) |
| [minio/mc 镜像页](https://xuanyuan.cloud/zh/r/minio/mc) | [https://xuanyuan.cloud/zh/r/minio/mc](https://xuanyuan.cloud/zh/r/minio/mc) |
| [minio/mc 标签列表](https://xuanyuan.cloud/r/minio/mc/tags) | [https://xuanyuan.cloud/r/minio/mc/tags](https://xuanyuan.cloud/r/minio/mc/tags) |
| [Docker Hub · minio/mc](https://hub.docker.com/r/minio/mc) | [https://hub.docker.com/r/minio/mc](https://hub.docker.com/r/minio/mc) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

> 同站相关镜像对照见 **§1.1**，勿与本文 Compose / 数据目录混用。

---

## 总结

- Compose 拉起 `minio/minio:RELEASE.2025-09-07T16-13-09Z`：**9000** S3、**9001** Console；health **200**。
- `server /data --console-address ":9001"` + `./data` → `/data`。
- 登录 → Acknowledge → 建 **`testbuckets`** → 上传；`mc ls local/testbuckets` 可见 **`minio-5.png`**（141KiB）。
- 客户端钉 `minio/mc:RELEASE.2025-08-13T08-35-41Z`；路径带 **`local/`**。Hub 已停更，勿写 `latest`。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/minio-docker-deploy


