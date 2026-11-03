# Docker 部署 Trivy 漏洞库：轻松搭建容器镜像漏洞扫描数据源

![Docker 部署 Trivy 漏洞库：轻松搭建容器镜像漏洞扫描数据源](https://imgs.xuanyuan.cloud/docker/blog/trivy/trivy.webp)

*分类: Docker部署教程 | 标签: Trivy DB,aquasec/trivy-db,Trivy,aquasec/trivy,Docker,轩辕镜像,漏洞扫描,CVE,容器安全,部署教程 | 发布时间: 2026-11-03 15:48:27*

> Trivy 漏洞库是 Aqua Security 为 Trivy 扫描器发布的 CVE 情报制品，汇集 NVD、Red Hat、Debian 等来源的数据。本文将介绍如何通过 Docker Compose 配合 aquasec/trivy，拉取并缓存 aquasec/trivy-db，搭建可复用的漏洞扫描数据源，适合 CI、内网镜像巡检，以及需要固定漏洞库拉取地址的场景。

## Trivy 漏洞库是什么

Trivy 漏洞库（`aquasec/trivy-db`）是 Aqua Security 为 Trivy 扫描器发布的漏洞情报制品。它把 NVD、Red Hat、Debian 等来源的 CVE 与发行版安全公告整理成一份数据库，供漏洞扫描使用。

它以 OCI 制品形式发布在容器仓库里，不是带长期进程的应用镜像：没有网页后台，也不能当成常驻服务来跑。真正执行扫描的是 `aquasec/trivy`；漏洞库由 Trivy 下载后写入本机缓存。

## Trivy 漏洞库能做什么

- **提供 CVE 情报**：为操作系统包与应用依赖的漏洞比对提供数据。
- **支撑镜像与依赖扫描**：Trivy 扫描容器镜像、文件系统等目标时，据此判定已知漏洞。
- **改用指定仓库**：把漏洞库拉取地址改到加速源或内网仓库。
- **先更新库再扫描**：只下载或刷新漏洞库，稍后再对目标做扫描。
- **缓存后离线复用**：库文件落在本机目录后，弱网或内网里可跳过更新继续扫。

## 为什么要使用 Trivy 漏洞库

Trivy 自带扫描引擎，但不自带完整、持续更新的漏洞情报。首次扫描或本地库过期时，会从默认仓库下载；下载失败时，扫描会直接中断。

把漏洞库地址指到可加速的仓库，并把缓存挂到本机目录，就能把「更新漏洞库」和「执行扫描」分开。适合 CI、内网巡检，以及需要固定漏洞库来源的环境。

## 使用 Docker 部署 Trivy 漏洞库

漏洞库本身没有常驻业务进程。部署时启动 Trivy 扫描器，指向漏洞库仓库，并把缓存目录挂到宿主机。部署前准备好 Docker，并规划好缓存目录。

接下来用 Docker Compose 写好镜像、仓库地址和卷，先下载漏洞库，再对示例镜像做一次扫描。

## 环境要求

本文使用 **`aquasec/trivy:0.76.1`**，漏洞库使用 **`aquasec/trivy-db:2`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。`2` 是当前 Trivy DB 的 schema 版本；上游约每 6 小时向同一标签推送重建结果。扫描器支持 **linux/amd64**、**linux/arm64** 等架构；本次扫描器 Digest 为 `sha256:790fd66d1697395d8693d1acaa1ea702406a20f109b6fc7bac8db623eca6c06c`。

没有网页，也不映射端口。结果看终端和 `cache/` 目录。容器内下载漏洞库需要 Docker 登录凭证，须把宿主机的 `~/.docker/config.json` 只读挂进容器。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文按 Ubuntu 目录）；macOS 把 `/www/wwwroot/trivy-db` 换成 `~/docker/trivy-db` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** 等 |
| 内存 | 建议 ≥ **512 MB** 可用；下载库与扫描时占用会升高 |
| 磁盘 | 实测下载漏洞库约 **131.64 MiB**，另加扫描器镜像与 `cache/` |
| 端口 | 不映射 |
| 工作目录 | `/www/wwwroot/trivy-db` |
| 凭证 | 宿主机已对 `docker.xuanyuan.run` 登录，且存在 `~/.docker/config.json` |
| 账号 | 无登录页；扫描本机镜像时需挂载 `docker.sock` |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=trivy-db-docker-deploy)。

## 标签怎么选

新安装使用漏洞库 **`2`**、扫描器 **`0.76.1`**。不要把 `latest` 写进 Compose。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2`**（`aquasec/trivy-db`） | 当前 schema；上游持续向该标签推送重建库 | **是** |
| **`0.76.1`**（`aquasec/trivy`） | 扫描器具体版本 | **是** |
| `1` / `v1-*`（`trivy-db`） | 旧 schema，已停用 | 否 |
| `latest` | 浮动标签 | 否 |
| `canary`（`aquasec/trivy`） | 预览线 | 否 |

漏洞库标签见 [标签列表](https://xuanyuan.cloud/r/aquasec/trivy-db/tags?xy_from=trivy-db-docker-deploy)。扫描器标签见 [aquasec/trivy 标签列表](https://xuanyuan.cloud/r/aquasec/trivy/tags?xy_from=trivy-db-docker-deploy)。`2` 表示库格式版本，不是日期戳；内容会随上游推送刷新。

## 拉取镜像

`aquasec/trivy-db` 是 OCI 漏洞库制品，不能当成可运行镜像用普通 `docker pull` 来「安装服务」。本文先拉取扫描器 `aquasec/trivy`，再由它按仓库地址下载漏洞库。

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=trivy-db-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/aquasec/trivy:0.76.1
```

Ubuntu 24.04 上拉取完成：

```text
0.76.1: Pulling from aquasec/trivy
7982da00fb0e: Pull complete
6b85eccf6d37: Pull complete
e2de96513ba9: Pull complete
2e51b4bff2eb: Pull complete
44136fa355b3: Download complete
f6da3aa7a7da: Download complete
2a4d4a16b7c4: Download complete
Digest: sha256:790fd66d1697395d8693d1acaa1ea702406a20f109b6fc7bac8db623eca6c06c
Status: Downloaded newer image for docker.xuanyuan.run/aquasec/trivy:0.76.1
docker.xuanyuan.run/aquasec/trivy:0.76.1
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=trivy-db-docker-deploy)。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/trivy-db`**。macOS 用 **`~/docker/trivy-db`**。

| 宿主机 | 容器内 | 用途 |
|--------|--------|------|
| `cache/` | `/root/.cache/` | 漏洞库与扫描缓存 |
| `$HOME/.docker/config.json` | `/root/.docker/config.json` | 下载漏洞库鉴权（只读） |
| `/var/run/docker.sock` | `/var/run/docker.sock` | 扫描本机 Docker 镜像 |

扫描器默认入口是 `trivy`。Compose 里改成 `sleep infinity`，容器才会留在后台，再用 `docker compose exec` 下载库和扫描。容器内的 Trivy 不会自动使用宿主机刚才那次 `docker pull` 的登录状态，因此必须挂载 `config.json`。

### 1. 创建目录并确认凭证

```bash
sudo mkdir -p /www/wwwroot/trivy-db/cache
sudo chown -R "$USER":"$USER" /www/wwwroot/trivy-db
cd /www/wwwroot/trivy-db
```

macOS：

```bash
mkdir -p ~/docker/trivy-db/cache
cd ~/docker/trivy-db
```

确认凭证文件存在。文件不存在时不要启动 Compose，否则可能把挂载点变成空目录：

```bash
test -f "$HOME/.docker/config.json" && echo "config.json 存在" || echo "请先 docker login docker.xuanyuan.run"
```

### 2. 写入 compose.yaml

```bash
cat > compose.yaml <<'EOF'
services:
  trivy:
    image: docker.xuanyuan.run/aquasec/trivy:0.76.1
    container_name: trivy
    restart: unless-stopped
    environment:
      TRIVY_DB_REPOSITORY: docker.xuanyuan.run/aquasec/trivy-db:2
      TZ: Asia/Shanghai
    volumes:
      - ./cache:/root/.cache/
      - ${HOME}/.docker/config.json:/root/.docker/config.json:ro
      - /var/run/docker.sock:/var/run/docker.sock
    entrypoint: ["sleep", "infinity"]
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 扫描器 `0.76.1` |
| `TRIVY_DB_REPOSITORY` | 漏洞库仓库，标签 `2` |
| `./cache` | 漏洞库与扫描缓存 |
| `config.json` | 宿主机 Docker 登录凭证（只读） |
| `docker.sock` | 扫描本机镜像时需要；不需要时可删掉该行 |
| `entrypoint` | `sleep infinity`，使容器留在后台 |
| 端口 | 不映射 |

### 3. 启动容器

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 上启动完成：

```text
[+] up 1/1
 ✔ Container trivy Started  13.6s
```

```text
NAME      IMAGE                                      COMMAND            SERVICE   CREATED         STATUS         PORTS
trivy     docker.xuanyuan.run/aquasec/trivy:0.76.1   "sleep infinity"   trivy     4 seconds ago   Up 2 seconds
```

`STATUS` 为运行中后再继续。`PORTS` 列应为空。

### 4. 只下载漏洞库

```bash
docker compose exec trivy /usr/local/bin/trivy image --download-db-only
```

Ubuntu 24.04 上下载完成（体积与耗时随网络变化）：

```text
2026-11-03T07:40:38Z    INFO    [vulndb] Need to update DB
2026-11-03T07:40:38Z    INFO    [vulndb] Downloading vulnerability DB...
2026-11-03T07:40:38Z    INFO    [vulndb] Downloading artifact...        repo="docker.xuanyuan.run/aquasec/trivy-db:2"
131.64 MiB / 131.64 MiB [--------------------------------------------------------------------------------------------------------------------------------------------------] 100.00% 993.88 KiB p/s 2m16s
2026-11-03T07:43:01Z    INFO    [vulndb] Artifact successfully downloaded       repo="docker.xuanyuan.run/aquasec/trivy-db:2"
```

看到 `Artifact successfully downloaded` 后，`cache/` 里会有漏洞库文件，可供后续扫描复用。若报 `UNAUTHORIZED`，见「常见问题」。

### 5. 扫描示例镜像

先拉取示例镜像：

```bash
docker pull docker.xuanyuan.run/library/alpine:3.20
```

Ubuntu 24.04 上拉取完成：

```text
3.20: Pulling from library/alpine
25f1d6b1951a: Pull complete
3a030ca3f633: Download complete
d4050d56ebf2: Download complete
Digest: sha256:d9e853e87e55526f6b2917df91a2115c36dd7c696a35be12163d44e6e2a4b6bc
Status: Downloaded newer image for docker.xuanyuan.run/library/alpine:3.20
docker.xuanyuan.run/library/alpine:3.20
```

漏洞库下载成功后再扫描：

```bash
docker compose exec trivy /usr/local/bin/trivy image 
  --skip-db-update 
  docker.xuanyuan.run/library/alpine:3.20
```

Ubuntu 24.04 上输出（漏洞条目会随库版本变化）：

```text
2026-11-03T07:43:12Z    INFO    [vuln] Vulnerability scanning is enabled
2026-11-03T07:43:12Z    INFO    [secret] Secret scanning is enabled
2026-11-03T07:43:15Z    INFO    Detected OS     family="alpine" version="3.20.10"
2026-11-03T07:43:15Z    INFO    [alpine] Detecting vulnerabilities...   os_version="3.20" repository="3.20" pkg_num=14
2026-11-03T07:43:15Z    WARN    This OS version is no longer supported by the distribution      family="alpine" version="3.20.10"

Report Summary

┌──────────────────────────────────────────────────────────┬────────┬─────────────────┬─────────┐
│                          Target                          │  Type  │ Vulnerabilities │ Secrets │
├──────────────────────────────────────────────────────────┼────────┼─────────────────┼─────────┤
│ docker.xuanyuan.run/library/alpine:3.20 (alpine 3.20.10) │ alpine │        2        │    -    │
└──────────────────────────────────────────────────────────┴────────┴─────────────────┴─────────┘

Total: 2 (UNKNOWN: 2, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)

┌────────────┬─────────────────┬──────────┬────────┬───────────────────┬───────────────┬─────────────────────────────────────────────┐
│  Library   │  Vulnerability  │ Severity │ Status │ Installed Version │ Fixed Version │                    Title                    │
├────────────┼─────────────────┼──────────┼────────┼───────────────────┼───────────────┼─────────────────────────────────────────────┤
│ musl       │ CVE-2026-107891 │ UNKNOWN  │ fixed  │ 1.2.5-r3          │ 1.2.5-r4      │ Title Not Available                         │
│            │                 │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2026-107891 │
├────────────┤                 │          │        │                   │               │                                             │
│ musl-utils │                 │          │        │                   │               │                                             │
└────────────┴─────────────────┴──────────┴────────┴───────────────────┴───────────────┴─────────────────────────────────────────────┘
```

本次目标为 Alpine **3.20.10**，检出 **2** 条：`musl` 与 `musl-utils` 的 `CVE-2026-107891`（Severity 为 UNKNOWN，Fixed Version `1.2.5-r4`）。日志里的「发行版已不再支持」是上游对 Alpine 3.20 的提示，不影响验证「库已生效并能出报告」。

`--skip-db-update` 表示沿用本地缓存、不再联网刷新。本地还没有库时不能加该参数，否则会报 `--skip-db-update cannot be specified on the first run`。要强制刷新库时，去掉该参数，或再执行一次 `--download-db-only`。

## 备选：docker run

没有 Compose 时，可用一次性容器完成同样流程，同样要挂载登录凭证。

下载漏洞库：

```bash
sudo mkdir -p /www/wwwroot/trivy-db/cache
sudo chown -R "$USER":"$USER" /www/wwwroot/trivy-db

docker run --rm 
  -e TRIVY_DB_REPOSITORY=docker.xuanyuan.run/aquasec/trivy-db:2 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/trivy-db/cache:/root/.cache/ 
  -v "$HOME/.docker/config.json:/root/.docker/config.json:ro" 
  docker.xuanyuan.run/aquasec/trivy:0.76.1 
  image --download-db-only
```

扫描本机镜像：

```bash
docker run --rm 
  -e TRIVY_DB_REPOSITORY=docker.xuanyuan.run/aquasec/trivy-db:2 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/trivy-db/cache:/root/.cache/ 
  -v "$HOME/.docker/config.json:/root/.docker/config.json:ro" 
  -v /var/run/docker.sock:/var/run/docker.sock 
  docker.xuanyuan.run/aquasec/trivy:0.76.1 
  image --skip-db-update docker.xuanyuan.run/library/alpine:3.20
```

需要反复扫描时，优先用上文 Compose。

## 备份与升级

```bash
cd /www/wwwroot/trivy-db
docker compose stop
tar -czf trivy-db-backup.tar.gz cache compose.yaml
docker compose start
```

升级扫描器时，改 `compose.yaml` 中的 `aquasec/trivy` 标签，保留 `cache/` 后执行：

```bash
docker compose pull
docker compose up -d
```

需要最新漏洞情报时，再执行一次 `--download-db-only`（不要加 `--skip-db-update`）。

## 常见问题

### 能直接 docker run aquasec/trivy-db 吗

不能。它是给 Trivy 下载的 OCI 漏洞库制品，没有业务入口。请启动 `aquasec/trivy`，并用 `TRIVY_DB_REPOSITORY` 指向 `aquasec/trivy-db:2`。

### 为什么还要拉 aquasec/trivy

漏洞库本身不能执行扫描。扫描器负责下载库、写入缓存并输出报告。

### 有没有默认账号密码

没有。本方案不提供登录页。

### 为什么没有端口

漏洞库与本方案都不对外提供 HTTP 服务。结果看终端和 `cache/`。

### 必须挂 docker.sock 吗

扫描本机 Docker 引擎里的镜像时需要。只扫远端镜像坐标、且不访问本机引擎时，可以不挂。

### 可以用 latest 吗

不要。漏洞库用 **`2`**，扫描器用 **`0.76.1`**。见「标签怎么选」。

### JAR / Java 依赖扫描还缺什么

Java 制品识别还需要 `trivy-java-db`（可用 `TRIVY_JAVA_DB_REPOSITORY`）。本文只覆盖 `trivy-db`。

### 下载库报 UNAUTHORIZED / 请先登录

容器内 Trivy 不会沿用宿主机 `docker pull` 的登录会话。确认：

1. 宿主机已 `docker login docker.xuanyuan.run`，且 `test -f "$HOME/.docker/config.json"` 成功；
2. Compose 或 `docker run` 已挂载 `${HOME}/.docker/config.json:/root/.docker/config.json:ro`；
3. 修改卷之后已执行 `docker compose up -d`。

401 / 402 另见 [常见问题](https://xuanyuan.cloud/faq?xy_from=trivy-db-docker-deploy)。

### 报 --skip-db-update cannot be specified on the first run

本地还没有可用的漏洞库。先成功执行 `--download-db-only`，再加 `--skip-db-update` 扫描。

### 下载库失败或超时

确认 `TRIVY_DB_REPOSITORY` 为 `docker.xuanyuan.run/aquasec/trivy-db:2`，凭证挂载正确，并查看 `docker compose exec` 时的终端报错。

### Alpine 扫描出现 no longer supported

这是 Trivy 对已结束支持周期的 Alpine 小版本提示。本文用 `alpine:3.20` 只为验证流程；正式巡检请改用仍在维护的目标镜像。

### 数据如何备份迁移

打包 `cache/`（建议连同 `compose.yaml`）。新机器挂回后，可先用 `--skip-db-update` 扫描，再按需刷新库。

## 命令速查

```bash
docker pull docker.xuanyuan.run/aquasec/trivy:0.76.1

cd /www/wwwroot/trivy-db
# 确认 config.json 存在，写入 compose.yaml 后：
docker compose up -d
docker compose ps

docker compose exec trivy /usr/local/bin/trivy image --download-db-only
docker compose exec trivy /usr/local/bin/trivy image 
  --skip-db-update 
  docker.xuanyuan.run/library/alpine:3.20

docker compose down
```

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [aquasec/trivy-db 镜像页](https://xuanyuan.cloud/r/aquasec/trivy-db?xy_from=trivy-db-docker-deploy) | [https://xuanyuan.cloud/r/aquasec/trivy-db](https://xuanyuan.cloud/r/aquasec/trivy-db?xy_from=trivy-db-docker-deploy) |
| [aquasec/trivy-db 标签列表](https://xuanyuan.cloud/r/aquasec/trivy-db/tags?xy_from=trivy-db-docker-deploy) | [https://xuanyuan.cloud/r/aquasec/trivy-db/tags](https://xuanyuan.cloud/r/aquasec/trivy-db/tags?xy_from=trivy-db-docker-deploy) |
| [aquasec/trivy 镜像页](https://xuanyuan.cloud/r/aquasec/trivy?xy_from=trivy-db-docker-deploy) | [https://xuanyuan.cloud/r/aquasec/trivy](https://xuanyuan.cloud/r/aquasec/trivy?xy_from=trivy-db-docker-deploy) |
| [aquasec/trivy 中文镜像页](https://xuanyuan.cloud/zh/r/aquasec/trivy?xy_from=trivy-db-docker-deploy) | [https://xuanyuan.cloud/zh/r/aquasec/trivy](https://xuanyuan.cloud/zh/r/aquasec/trivy?xy_from=trivy-db-docker-deploy) |
| [Docker Hub · aquasec/trivy-db](https://hub.docker.com/r/aquasec/trivy-db) | [https://hub.docker.com/r/aquasec/trivy-db](https://hub.docker.com/r/aquasec/trivy-db) |
| [Docker Hub · aquasec/trivy](https://hub.docker.com/r/aquasec/trivy) | [https://hub.docker.com/r/aquasec/trivy](https://hub.docker.com/r/aquasec/trivy) |
| [GitHub · aquasecurity/trivy-db](https://github.com/aquasecurity/trivy-db) | [https://github.com/aquasecurity/trivy-db](https://github.com/aquasecurity/trivy-db) |
| [Trivy Databases 文档](https://trivy.dev/docs/latest/configuration/db/) | [https://trivy.dev/docs/latest/configuration/db/](https://trivy.dev/docs/latest/configuration/db/) |
| [Trivy v0.76.1 Release](https://github.com/aquasecurity/trivy/releases/tag/v0.76.1) | [https://github.com/aquasecurity/trivy/releases/tag/v0.76.1](https://github.com/aquasecurity/trivy/releases/tag/v0.76.1) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=trivy-db-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=trivy-db-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/trivy-db-docker-deploy?xy_from=trivy-db-docker-deploy)

*本文基于 [aquasec/trivy-db:2](https://xuanyuan.cloud/r/aquasec/trivy-db?xy_from=trivy-db-docker-deploy) 与 [aquasec/trivy:0.76.1](https://xuanyuan.cloud/r/aquasec/trivy?xy_from=trivy-db-docker-deploy)，以漏洞库 **2**、扫描器 **0.76.1** 版本实测，测试平台 **Ubuntu 24.04** Linux。*


