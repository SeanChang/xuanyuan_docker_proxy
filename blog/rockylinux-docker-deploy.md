# Docker 部署 Rocky Linux：轻松搭建 RHEL 兼容企业级基础镜像平台

![Docker 部署 Rocky Linux：轻松搭建 RHEL 兼容企业级基础镜像平台](https://imgs.xuanyuan.cloud/docker/blog/rocky.webp)

*分类: Docker部署教程 | 标签: Rocky Linux,rockylinux/rockylinux,Docker,轩辕镜像,RHEL 兼容,基础镜像,私有化部署,部署教程 | 发布时间: 2026-09-06 01:58:27*

> Rocky Linux（文档、Wiki）是社区支持的企业级 Linux：源码来自 Red Hat 公开的 RHEL 源码，目标功能兼容 RHEL，主要去掉上游厂商品牌与图标，免费可再分发；每个大版本约有长达 10 年的安全更新周期。容器镜像 rockylinux/rockylinux（镜像页）把这套系统做成 Docker 基础镜像，适合当 Dockerfile 底、CI 构建环境，以及临时的 RHEL 兼容沙箱。

*本文基于 [rockylinux/rockylinux:9.8](https://xuanyuan.cloud/zh/r/rockylinux/rockylinux)，实测引擎 **Rocky Linux 9.8 (Blue Onyx)**，测试平台 **Ubuntu 24.04** Linux。*

Jenkins 流水线还在 `FROM centos:7`，安全扫描一亮红灯；联调机装了 Alma，业务容器却是旧 RHEL 小版本，包名对得上、`systemctl` 一启就报单元找不到。有人把脚本拷进本机 root 目录「先跑通」，换同事笔记本又差一截 glibc。要的其实很具体：一个**免费、可再分发、功能对齐 RHEL** 的容器底，标签写清楚，CI 和笔记本拉到的是同一份。

构建缓存、安全补丁和中间产物最好落在自己的盘上。公有云托管构建按分钟计费，等保机房也不宜把源码和依赖送出域。很多团队已经有一台跑 Docker 的 Ubuntu，缺的是镜像能拉、容器能常驻、`dnf` 能装包、`FROM` 能写进流水线——而不是再装一台物理 Rocky。

**Rocky Linux**（[文档](https://docs.rockylinux.org)、[Wiki](https://wiki.rockylinux.org)）是社区支持的企业级 Linux：源码来自 Red Hat 公开的 RHEL 源码，目标功能兼容 RHEL，主要去掉上游厂商品牌与图标，免费可再分发；每个大版本约有长达 **10 年**的安全更新周期。容器镜像 **`rockylinux/rockylinux`**（[镜像页](https://xuanyuan.cloud/zh/r/rockylinux/rockylinux)）把这套系统做成 Docker 基础镜像，适合当 Dockerfile 底、CI 构建环境，以及临时的 RHEL 兼容沙箱。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 验证版本 | `docker compose exec rockylinux cat /etc/os-release`（实测 **9.8 Blue Onyx**） |
| 进沙箱装包 | `exec` 进 bash，用 `dnf` 联调（注意 `curl-minimal`，见 Q8） |
| 写业务镜像 | `FROM docker.xuanyuan.run/rockylinux/rockylinux:9.8` |
| 挂工作目录 | `./workspace` ↔ `/workspace`，脚本与产物落在宿主机 |
| 备份搬家 | 停容器后打包 `docker-compose.yml` 与挂载目录 |

本文按「能跟做」写完整链路：用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`rockylinux/rockylinux:9.8`**，**Docker Compose** 起常驻沙箱并验证版本；真正落地以第六节 **Dockerfile `FROM`** 为主。无 Compose 见第八节。

> **上手要点**
> - **部署**：第五节 Compose（沙箱）；生产用法见第六节 `FROM`；临时 shell 见第八节
> - **无 Web 控制台**：验证靠终端与 `/etc/os-release`（实测 `SUPPORT_END=2032-05-31`）
> - **标签**：跟做 **`9.8`**；**勿写 `latest`**。要持续吃补丁用滚动 **`9`**，或在 Dockerfile 里 `dnf -y update`
> - **坐标**：用 **`rockylinux/rockylinux`**，勿依赖短名 `rockylinux`（`library/rockylinux` 可能过时或缺标签）
> - **包管理**：`dnf`（实测 **4.14.0**）。已带 **`curl-minimal`** / **`vim-minimal`**，勿再装完整 `curl`
> - **体积**：DISK **348MB** / CONTENT **87.6MB**
> - **数据**：`./workspace` → `/workspace`
> - **systemd**：默认未激活；仅依赖 `systemctl` 时看第七节

官方：[文档站](https://docs.rockylinux.org) · [Wiki](https://wiki.rockylinux.org) · [镜像页](https://xuanyuan.cloud/zh/r/rockylinux/rockylinux) · [标签列表](https://xuanyuan.cloud/r/rockylinux/rockylinux/tags)

---

## 一、Rocky Linux 镜像是什么？

`rockylinux/rockylinux` 是 **RHEL 兼容的操作系统基础镜像**：没有业务 Web 后台，入口是终端、`dnf` 和 Dockerfile。跟「继续用停更的 CentOS 容器」或「本机装一套再往里拷脚本」比，容器底更容易复现、换机器、进 CI。

| | Rocky Linux（本文） | 停更 CentOS 容器 | RHEL UBI / 订阅镜像 |
|--|---------------------|------------------|---------------------|
| 定位 | 社区、免费可再分发、对齐 RHEL | 已停更，不适合新项目 | 厂商支持，依赖订阅与合规策略 |
| 怎么用 | `FROM` / CI / `exec` 沙箱 | 遗留兼容 | 同上 + 厂商文档 |
| 更新 | 滚动标签 `9`，或 Dockerfile 内 `dnf update` | 不宜再当生产底 | 按订阅仓库 |
| 适合 | 企业基础镜像、流水线、联调 | 仅存量 | 已有 Red Hat 订阅 |

```text
宿主机 Ubuntu（Docker）
        │
        ▼
rockylinux/rockylinux:9.8
   ├── bash / dnf（实测 4.14.0）
   ├── ./workspace → /workspace
   └── 业务进程写在你的 Dockerfile 里（可选 systemd）
```

同站还有 `library/rockylinux`、`arm64v8/rockylinux` 等坐标。**本文只用社区维护的 `rockylinux/rockylinux:9.8`**。[`/r/`](https://xuanyuan.cloud/r/rockylinux/rockylinux) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/rockylinux/rockylinux) 是同一镜像的不同页面语言。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux，建议 **Ubuntu 24.04** |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64 / arm64**（以 [tags](https://xuanyuan.cloud/r/rockylinux/rockylinux/tags) 为准；本文实测 **x86_64**） |
| 内存 | ≥ **512 MB**；装大量包或跑 systemd 再加 |
| 磁盘 | DISK **348MB** / CONTENT **87.6MB** + 挂载目录 |
| 端口 | 沙箱**不映射**；httpd / systemd 示例用 **8080→80** |

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

映射 **8080** 前可先查占用：

```bash
ss -tlnp | grep ':8080'
```

冲突则改映射左侧（如 `"18080:80"`）。

---

## 三、标签怎么选

跟做使用 **`9.8`**。完整列表：[tags](https://xuanyuan.cloud/r/rockylinux/rockylinux/tags)。

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`9.8`** | 次要版本，贴近安装介质 | **本文跟做**；镜像层**不**滚动打补丁 |
| `9.8.20260525.0` | 带构建日期 | 需要可追溯时 |
| `9` | 主版本滚动（约每月或紧急修复时更新） | 生产想持续吃补丁时 |
| `9-minimal` / `9.8-minimal` | 精简变体 | 体积敏感 |
| `9-ubi` / `9.8-ubi` | UBI 风格变体 | 按上游说明 |
| `10` / `10.2` | Rocky Linux 10 | 新栈评估 |
| `8` / `8.10` | Rocky Linux 8 | 遗留兼容 |
| `latest` | 跟踪当前最新大版本线 | **勿写入跟做命令** |

次要标签（如 `9.8`）对齐 ISO 内容，官方说明**不会**持续更新镜像层——Dockerfile 里应加 `RUN dnf -y update && dnf clean all`，或改用滚动 **`9`**（流水线建议记录 digest）。升级时同步改 pull、Compose、`docker run`、Dockerfile 四处标签，并核对 [发行说明](https://docs.rockylinux.org)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/rockylinux/rockylinux:9.8
```

Ubuntu 24.04 实测：

```text
9.8: Pulling from rockylinux/rockylinux
99c753a880cc: Pull complete
Digest: sha256:8101994123cf3d0a8fee517bee7f39e555c7d92bd2d9eb3303cc988a0eeed00f
Status: Downloaded newer image for docker.xuanyuan.run/rockylinux/rockylinux:9.8
docker.xuanyuan.run/rockylinux/rockylinux:9.8
```

```bash
docker images docker.xuanyuan.run/rockylinux/rockylinux:9.8
```

```text
IMAGE                                           ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/rockylinux/rockylinux:9.8   8101994123cf        348MB         87.6MB
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `rockylinux/rockylinux:9.8` | `docker pull docker.xuanyuan.run/rockylinux/rockylinux:9.8` |

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq)。

---

## 五、Docker Compose 部署（推荐 · 沙箱）

| 平台 | 工作目录 |
|------|----------|
| **Linux**（正文默认） | `/www/wwwroot/rockylinux` |
| **macOS** | **`~/docker/rockylinux`** |

基础镜像没有常驻业务进程。跟作用 **`sleep infinity`** 保活，再用 `exec` 进 shell——方便对照版本、试 `dnf`、挂工作目录。业务镜像请走第六节 `FROM`，不要把空沙箱长期当生产进程。

### 5.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/rockylinux/workspace
cd /www/wwwroot/rockylinux

# macOS：mkdir -p ~/docker/rockylinux/workspace && cd ~/docker/rockylinux
```

非 root 给 `mkdir` / `docker` 加 `sudo`。

### 5.2 编写 docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  rockylinux:
    image: docker.xuanyuan.run/rockylinux/rockylinux:9.8
    container_name: rockylinux
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
    command: ["sleep", "infinity"]
    volumes:
      - ./workspace:/workspace
EOF
```

| 项 | 说明 |
|----|------|
| `command` | `sleep infinity` 保活。不写 command 时入口多为交互 shell，无 TTY 会立刻退出 |
| `./workspace` | 宿主机与容器共享目录 |
| 端口 | 沙箱不必映射；对外服务在自建镜像里声明 |

### 5.3 启动并验证

```bash
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network rockylinux_default Created
 ✔ Container rockylinux       Started
```

```text
NAME         IMAGE                                           COMMAND            SERVICE      CREATED         STATUS         PORTS
rockylinux   docker.xuanyuan.run/rockylinux/rockylinux:9.8   "sleep infinity"   rockylinux   6 seconds ago   Up 2 seconds
```

`PORTS` 为空是预期（未映射端口）。`sleep infinity` 几乎无应用日志，不必盯 `compose logs`。

```bash
docker compose exec rockylinux cat /etc/os-release
docker compose exec rockylinux bash -lc 'dnf --version; uname -m'
```

实测关键字段：

```text
NAME="Rocky Linux"
VERSION="9.8 (Blue Onyx)"
ID="rocky"
VERSION_ID="9.8"
PRETTY_NAME="Rocky Linux 9.8 (Blue Onyx)"
SUPPORT_END="2032-05-31"
ROCKY_SUPPORT_PRODUCT_VERSION="9.8"
```

```text
4.14.0
  Installed: dnf-0:4.14.0-34.el9_8.rocky.0.1.noarch at Mon May 25 20:18:55 2026
  …
x86_64
```

进入交互 shell：

```bash
docker compose exec -it rockylinux bash
# 退出：exit
```

容器内可按需装包。镜像已带 **`vim-minimal`**、**`curl-minimal`**（命令行仍叫 `curl`），**不要**再执行 `dnf install curl`（会冲突，见 Q8）。示例：

```bash
dnf -y install less procps-ng && dnf clean all
```

宿主机把文件放进 `./workspace`，容器内路径为 `/workspace`。

### 5.4 可选：临时演示 httpd（非生产）

只想看「容器内起服务 + 端口映射」时可用；**每次启动都会 `dnf install`，勿当长期方案**。正式服务请写成 Dockerfile。

```yaml
services:
  rockylinux-httpd:
    image: docker.xuanyuan.run/rockylinux/rockylinux:9.8
    container_name: rockylinux-httpd
    restart: unless-stopped
    ports:
      - "8080:80"
    command:
      - bash
      - -lc
      - |
        dnf -y install httpd &&
        echo 'Hello from Rocky Linux container' > /var/www/html/index.html &&
        exec /usr/sbin/httpd -DFOREGROUND
```

```bash
curl -s http://127.0.0.1:8080/
```

---

## 六、当作 Dockerfile 基础镜像（生产主路径）

联调用第五节沙箱即可；**交付业务镜像**应 `FROM` 固化依赖，而不是长期挂一个空 `sleep` 容器。

```dockerfile
FROM docker.xuanyuan.run/rockylinux/rockylinux:9.8

# 次要标签不滚动更新时，自行打补丁：
RUN dnf -y update && dnf clean all

RUN dnf -y install python3 && dnf clean all

WORKDIR /app
COPY . /app
CMD ["python3", "--version"]
```

```bash
docker build -t local/rocky-app:9.8 .
docker run --rm local/rocky-app:9.8
```

### 6.1 包文档（nodocs）

官方默认启用 **`nodocs`** 以减小体积。若缺 man / 文档文件：

```bash
sed -i 's/^tsflags=nodocs/#tsflags=nodocs/' /etc/yum.conf
dnf -y reinstall <package-name> && dnf clean all
```

部分环境配置在 `/etc/dnf/dnf.conf`，以容器内实际文件为准。

---

## 七、可选：启用 systemd（进阶）

镜像含 systemd，但**默认不是 PID 1**。只有必须 `systemctl enable …` 时才需要；普通前台进程（如 `httpd -DFOREGROUND`）跳过本节。

### 7.1 systemd 基础镜像

```dockerfile
FROM docker.xuanyuan.run/rockylinux/rockylinux:9.8
ENV container=docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ "$i" = \
systemd-tmpfiles-setup.service ] || rm -f "$i"; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
```

```bash
docker build --rm -t local/r9-systemd .
```

### 7.2 带 httpd 的应用镜像

```dockerfile
FROM local/r9-systemd
RUN dnf -y install httpd && dnf clean all && systemctl enable httpd.service
EXPOSE 80
CMD ["/usr/sbin/init"]
```

```bash
docker build --rm -t local/r9-systemd-httpd .
docker run -d --name rocky-httpd \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -p 8080:80 \
  local/r9-systemd-httpd
```

Ubuntu 宿主机若 systemd 起不来，可再挂临时 `/run`：

```bash
docker run -d --name rocky-httpd \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -v /tmp/$(mktemp -d):/run \
  -p 8080:80 \
  local/r9-systemd-httpd
```

访问：`http://服务器IP:8080/`。用完：`docker stop rocky-httpd && docker rm rocky-httpd`。

---

## 八、备选：docker run

临时进一次 shell：

```bash
docker run -it --rm \
  --name rockylinux \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/rockylinux/workspace:/workspace \
  docker.xuanyuan.run/rockylinux/rockylinux:9.8 \
  bash
```

常驻后台（等价第五节）：

```bash
docker run -d \
  --name rockylinux \
  --restart unless-stopped \
  -e TZ=Asia/Shanghai \
  -v /www/wwwroot/rockylinux/workspace:/workspace \
  docker.xuanyuan.run/rockylinux/rockylinux:9.8 \
  sleep infinity

docker exec -it rockylinux bash
docker exec rockylinux cat /etc/os-release
```

```bash
docker stop rockylinux && docker rm rockylinux
```

---

## 九、迁移 / 升级

1. 备份 `docker-compose.yml`、`./workspace` 与自建 Dockerfile。  
2. 在 [tags](https://xuanyuan.cloud/r/rockylinux/rockylinux/tags) 选定新标签（更新的次要版本，或改滚动 `9`）。  
3. 改标签后：

```bash
cd /www/wwwroot/rockylinux
docker compose pull
docker compose up -d
docker compose exec rockylinux cat /etc/os-release
```

4. 大版本跨越（8→9、9→10）按官方策略评估；容器场景优先**重建镜像**，少在容器内做原地跨大版本升级。

---

## 十、常见问题 FAQ

**Q1：`docker pull rockylinux:9.8` 失败，完整名可以？**  
短名走 `library/rockylinux`，标签可能缺失或过时。统一用 **`rockylinux/rockylinux:9.8`**（经轩辕镜像：`docker.xuanyuan.run/rockylinux/rockylinux:9.8`）。

**Q2：为什么用 `9.8` 而不是 `latest` / `9`？**  
`latest` 会漂移，跟做步骤易对不上。`9.8` 可复现，但**不**滚动打镜像补丁——要持续更新用滚动 **`9`**，或在 Dockerfile 里 `dnf update`，并记录 digest。

**Q3：容器一启动就退出？**  
守护场景加上 `command: ["sleep", "infinity"]`，或换成你的前台业务命令；交互试玩用 `docker run -it … bash`。

**Q4：和 AlmaLinux / RHEL UBI 怎么选？**  
都是 RHEL 兼容生态。Rocky 侧重社区免费可再分发；已有 Red Hat 订阅可评估 UBI。本文只覆盖 `rockylinux/rockylinux`。

**Q5：一定要 systemd 吗？**  
不必。前台进程即可时跳过第七节。

**Q6：示例为什么映射 8080 而不是 80？**  
减少与宿主机已有 Web 冲突；可按环境改左侧端口。

**Q7：有默认管理员密码吗？**  
无 Web 登录。容器内多为 root；限制谁能 `docker exec`，业务进程尽量非 root。

**Q8：`dnf install curl` 与 `curl-minimal` 冲突？**  
实测 `9.8` 已装 **`curl-minimal`**（命令仍可用）。勿再装完整 `curl`；必须换包时用 `dnf -y install curl --allowerasing`。`vim-minimal` 亦已预装。

---

## 十一、命令速查

```bash
docker pull docker.xuanyuan.run/rockylinux/rockylinux:9.8

cd /www/wwwroot/rockylinux
docker compose up -d
docker compose ps
docker compose exec -it rockylinux bash
docker compose exec rockylinux cat /etc/os-release

docker compose pull && docker compose up -d
docker compose down

# 备选
docker run -it --rm docker.xuanyuan.run/rockylinux/rockylinux:9.8 bash
```

---

## 十二、延伸阅读

| 资源 | 链接 |
|------|------|
| [rockylinux/rockylinux 镜像页（中文）](https://xuanyuan.cloud/zh/r/rockylinux/rockylinux) | [https://xuanyuan.cloud/zh/r/rockylinux/rockylinux](https://xuanyuan.cloud/zh/r/rockylinux/rockylinux) |
| [rockylinux/rockylinux 概览](https://xuanyuan.cloud/r/rockylinux/rockylinux) | [https://xuanyuan.cloud/r/rockylinux/rockylinux](https://xuanyuan.cloud/r/rockylinux/rockylinux) |
| [rockylinux/rockylinux 标签列表](https://xuanyuan.cloud/r/rockylinux/rockylinux/tags) | [https://xuanyuan.cloud/r/rockylinux/rockylinux/tags](https://xuanyuan.cloud/r/rockylinux/rockylinux/tags) |
| [Rocky Linux 文档站](https://docs.rockylinux.org) | [https://docs.rockylinux.org](https://docs.rockylinux.org) |
| [Rocky Linux Wiki](https://wiki.rockylinux.org) | [https://wiki.rockylinux.org](https://wiki.rockylinux.org) |
| [Rocky Linux Mattermost](https://chat.rockylinux.org) | [https://chat.rockylinux.org](https://chat.rockylinux.org) |
| [Docker Hub · rockylinux/rockylinux](https://hub.docker.com/r/rockylinux/rockylinux) | [https://hub.docker.com/r/rockylinux/rockylinux](https://hub.docker.com/r/rockylinux/rockylinux) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`rockylinux/rockylinux:9.8`**：Compose + `sleep infinity`，用 `exec` 验 `/etc/os-release`  
- **生产主路径**是 Dockerfile `FROM`；次要标签自行 `dnf update`，或改用滚动 **`9`**  
- 坐标用完整名；勿默认 `latest`；注意 **`curl-minimal`** 冲突  
- systemd 仅在需要时启用  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/rockylinux-docker-deploy


