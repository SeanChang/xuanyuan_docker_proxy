# 2026 最新国内 Docker 镜像源加速列表（9 月更新）

![2026 最新国内 Docker 镜像源加速列表（9 月更新）](https://imgs.xuanyuan.cloud/docker/blog/docker-2026-9.png)

*分类: Docker部署教程 | 标签: Docker,镜像加速,国内镜像源,轩辕镜像,registry-mirrors,containerd,Kubernetes,Podman | 发布时间: 2026-09-02 12:16:33*

> docker pull 超时、镜像拉取失败时，先别急着换一堆来路不明的地址。这篇整理的是 2026 年 9 月还能用的国内 Docker 镜像加速写法，高校、实验室、公司研发机都可以照着配。拉 Docker Hub、ghcr.io、GCR、registry.k8s.io 时，常见是慢、超时，或者碰上 401 / 429 / manifest unknown。很多时候不是「源挂了」，而是配错了地方：daemon.json 里的 registry-mirrors 主要管 docker.io；Kubernetes 节点用的是 containerd，不会读你笔记本 Docker Desktop 里的加速配置。

## 前言

`docker pull` 超时、镜像拉取失败时，先别急着换一堆来路不明的地址。这篇整理的是 2026 年 9 月还能用的国内 Docker 镜像加速写法，高校、实验室、公司研发机都可以照着配。

拉 Docker Hub、ghcr.io、GCR、`registry.k8s.io` 时，常见是慢、超时，或者碰上 `401` / `429` / `manifest unknown`。很多时候不是「源挂了」，而是配错了地方：`daemon.json` 里的 `registry-mirrors` 主要管 `docker.io`；Kubernetes 节点用的是 containerd，不会读你笔记本 Docker Desktop 里的加速配置。

机器在阿里云、腾讯云、华为云上，优先用各家内网镜像源。网易云公共加速早就停了，文里仍写出那个旧地址，是怕你 `daemon.json` 里还留着。换到笔记本、另一家云、家里 NAS，或者还要拉 ghcr.io、K8s 官方镜像，用 [轩辕镜像专业版](https://xuanyuan.cloud) 更省事：注册后复制专属域名，再改配置、测拉取。分平台步骤见 [使用手册](https://xuanyuan.cloud/usage)，报错查 [FAQ](https://xuanyuan.cloud/faq)。

> 国内 Docker 镜像源会变，建议收藏，我们按月更新。生产以 [xuanyuan.cloud](https://xuanyuan.cloud) 为准。流量在 [充值中心](https://xuanyuan.cloud/recharge) 买——**新人使用仅 ¥2.9 起**，**50GB 仅需 ¥8**。

---

## 🔍 9 月 2 日最新可用镜像源加速

### 云厂商内网源，以及别再用的旧公共源

| 来源 | 地址 | 9 月状态 | 适用范围 |
|------|------|----------|----------|
| 腾讯云 | `https://mirror.ccs.tencentyun.com` | 同云可用 | 仅腾讯云 CVM |
| 阿里云 | `https://xxx.mirror.aliyuncs.com` | 同云可用（控制台取专属地址） | 仅阿里云 ECS |
| 华为云 | 按 SWR 控制台文档配置 | 同云可用 | 华为云环境 |
| 网易云 | `https://hub-mirror.c.163.com` | **已停用，勿再配置** | 旧地址，留着只会拖慢拉取 |

怎么选：

- 腾讯云、阿里云、华为云内网镜像，在**对应云服务器**上拉 Docker Hub 往往够用；换到本机、另一家云、CI、家里 NAS 通常无效，也基本不管 ghcr.io / `registry.k8s.io`。
- 网易云等大厂**公共** Docker 镜像加速早已停服。配置里还留着 `hub-mirror.c.163.com` 的，删掉。
- 要跨环境、团队共用，或加速 GHCR / K8s 官方仓库，用轩辕镜像专业版。

### 轩辕镜像专业版（推荐）

打开 [xuanyuan.cloud](https://xuanyuan.cloud) 注册。个人中心能看到专属域名（形如 `xxx.xuanyuan.run`）和镜像账户 / 镜像密码。Docker Hub、ghcr.io、GCR、`registry.k8s.io` 都能走；Linux、Docker Desktop、群晖、极空间、威联通也能配。

流量在 [充值中心](https://xuanyuan.cloud/recharge) 购买：**新人使用仅 ¥2.9 起**，**50GB 仅需 ¥8**。

### 轩辕镜像免费版（仅体验）

地址是 `https://docker.xuanyuan.me`（注意是 `.me`，不是 `.run`）。免费、不用登录，但**只加速 Docker Hub**，没有 GHCR / K8s，别拿去撑生产。差别见 [免费版与专业版](https://xuanyuan.cloud/faq/free-vs-pro)。

动手顺序：先 [注册专业版](https://xuanyuan.cloud)，需要的话先 [充值](https://xuanyuan.cloud/recharge)，再在个人中心复制 `xxx.xuanyuan.run`，写进后面的加速配置。

---

## 一键安装与配置镜像加速（推荐方案）

还没装 Docker 的 Linux 机器，可以用官方一键脚本装 Docker 和 Docker Compose。测试环境一条命令即可；生产环境请先下载脚本看过再执行。

脚本大约覆盖 15 种发行版（含统信 UOS、深度 Deepin 等）。装好后把专业版专属加速地址写进 `daemon.json`。

> 最好先注册专业版并拿到专属域名，再跑脚本，少改一次配置。

### 执行命令

#### 测试环境

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

#### 生产环境

```bash
# 1. 下载脚本到本地
wget https://get.xuanyuan.cloud/docker.sh -O docker-install.sh

# 2. 审计脚本源码
less docker-install.sh

# 3. 执行脚本
bash docker-install.sh
```

### 脚本特性

- **发行版覆盖**：openEuler、OpenCloudOS、Anolis OS、Alinux、Kylin Linux、统信 UOS、深度 Deepin、Fedora、Rocky Linux、AlmaLinux、Ubuntu、Debian、CentOS（8+ / Stream）、RHEL、Oracle Linux
- **多源安装包**：内置阿里云、腾讯云、华为云、中科大、清华等国内软件源，便于装 Docker 本体
- **老系统兼容**：Ubuntu 16.04、Debian 9/10 等有兼容分支
- **失败回退**：包管理器失败时可切二进制安装
- **跨系统提示**：检测到 macOS / Windows 时给出 Docker Desktop 安装指引
- **开源**：[github.com/SeanChang/xuanyuan_docker_proxy](https://github.com/SeanChang/xuanyuan_docker_proxy)

> **CentOS 7**：已 EOL，yum 源大量下线，**一键脚本不支持 CentOS 7**。请迁到 Rocky Linux、AlmaLinux 或 CentOS Stream 8+。

验证：

```bash
docker --version
docker compose version
```

---

## 镜像搜索与在线工具

注册专业版后，可在 [Docker 镜像搜索](https://xuanyuan.cloud/search) 复制带专属域名的 `docker pull` 命令：

- [Docker Run 在线命令生成器](https://xuanyuan.cloud/docker/run?image=library%2Fnginx%3Alatest&containerName=nginx)
- [Docker Compose 在线生成器](https://xuanyuan.cloud/docker/compose)

---

## 合规服务

轩辕镜像在境内运营，会拦截违规、违法和明显恶意的镜像，只加速合规开源镜像。高校、科研单位、国企等也在用。细节见 [镜像合规](https://xuanyuan.cloud/faq/image-compliance)。

### 支持的操作系统详情

| 分类 | 操作系统 | 版本 | 支持状态 | 说明 |
|------|----------|------|----------|------|
| 国产操作系统 | openEuler (欧拉) | 20.03+, 22.03+, 24.03+ | 支持 | 华为开源，兼容 CentOS |
| | OpenCloudOS | 9.x | 支持 | 腾讯开源，兼容 CentOS 9 |
| | Anolis OS (龙蜥) | 7.x, 8.x | 支持 | 阿里云支持，兼容 RHEL |
| | Alinux (阿里云) | 2.x, 3.x | 支持 | 阿里云 ECS 默认系统 |
| | Kylin Linux (银河麒麟) | V10 | 支持 | 国产系统，兼容 RHEL |
| | 统信 UOS、深度 Deepin | 主流版本 | 支持 | 信创桌面与服务器 |
| CentOS 替代 | Rocky Linux / AlmaLinux | 8.x, 9.x | 支持 | 长周期，兼容 RHEL |
| 创新发行版 | Fedora | 34+ | 支持 | Red Hat 上游 |
| 传统发行版 | Ubuntu | 16.04+ | 支持 | 含老版本兼容 |
| | Debian | 9+ | 支持 | 含老版本兼容 |
| | CentOS | 8, 9, Stream | 支持 | **不含 CentOS 7** |
| | RHEL / Oracle Linux | 7, 8, 9 | 支持 | 企业级发行版 |

脚本会检测系统类型和版本，一般不必手选安装方案。

---

## 手动配置镜像加速（已安装 Docker 环境）

### 先注册专业版，准备好域名

1. 打开 [轩辕镜像官网](https://xuanyuan.cloud) 注册
2. 个人中心复制**专属域名**（形如 `xxx.xuanyuan.run`）
3. 查看**镜像账户 / 镜像密码**（见 [如何拉取镜像](https://xuanyuan.cloud/faq/how-to-pull-images)）
4. 若走公共登录域拉取，对 `docker.xuanyuan.run` 登录一次（**不要**对专属域 `*.xuanyuan.run` 做 `docker login`，尤其 NAS）：

```bash
docker login docker.xuanyuan.run
```

文中的 `xxx.xuanyuan.run` 请换成你自己的前缀。非 Hub 仓库还有 `xxx-ghcr`、`xxx-k8s`、`xxx-gcr` 等后缀，见 [支持的仓库](https://xuanyuan.cloud/faq/supported-registries)。

---

### Linux 系统

#### 推荐配置（轩辕专业版专属地址）

```bash
sudo mkdir -p /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://xxx.xuanyuan.run"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
```

验证：`docker info | grep "Registry Mirrors" -A 3`，输出含专属地址即可；再 `docker pull nginx:latest` 测速。

#### 基础配置（免费体验，仅 Docker Hub）

临时体验可写入 `https://docker.xuanyuan.me`。不含 GHCR / K8s，别当生产方案。

> **注意**：`registry-mirrors` 主要作用于 Docker Hub（`docker.io`）。要加速 `ghcr.io`、`registry.k8s.io`，还得在专业版专属域名之外，去配后面的 containerd 或 Podman。原因见 [mirrors 为何不生效](https://xuanyuan.cloud/faq/registry-mirrors-not-working)。

---

### macOS（Docker Desktop）

#### 推荐配置（轩辕专业版专属地址）

1. 菜单栏 Docker 图标 → **Settings** → **Docker Engine**
2. 修改 JSON（替换 `xxx.xuanyuan.run`）：

```json
{
  "registry-mirrors": ["https://xxx.xuanyuan.run"]
}
```

3. **Apply & Restart**，用 `docker info` 核对 Registry Mirrors

#### 基础配置（免费体验）

Settings → Docker Engine → 添加 `"registry-mirrors": ["https://docker.xuanyuan.me"]` → Apply & Restart。

⚠️ 生产环境不要用 `insecure-registries` 跳过 TLS。证书问题见 [TLS 证书 FAQ](https://xuanyuan.cloud/faq/tls-certificate-error)。

---

### Windows（Docker Desktop）

#### 推荐配置（轩辕专业版专属地址）

1. 任务栏 Docker 图标 → **Settings** → **Docker Engine**
2. 写入与 macOS 相同 JSON，Apply 后重启
3. `docker info` 确认 Registry Mirrors

#### 基础配置（免费体验）

将 mirrors 改为 `https://docker.xuanyuan.me`。

---

## 其他容器环境加速配置

### K8s containerd 镜像加速配置

适用于 Kubernetes、K3s 或自建 containerd。集群节点**不会读取** Docker 的 `daemon.json`，必须在 containerd 里配多仓库 mirrors，否则容易出现 **ImagePullBackOff**。

#### 适用版本

| containerd 版本 | 支持说明 |
|-----------------|----------|
| < 1.4 | 配置结构不同，新环境别用 |
| 1.4 ~ 1.7.x | 按下面步骤即可 |
| ≥ 1.7.x | 推荐 |

查看版本：`containerd --version`

#### 配置步骤

1. 若尚无配置文件，可初始化：

```bash
containerd config default | sudo tee /etc/containerd/config.toml
```

2. 编辑 `/etc/containerd/config.toml`，在 registry mirrors 下增加（替换专属前缀）：

```toml
[plugins."io.containerd.grpc.v1.cri".registry]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
      endpoint = ["https://xxx.xuanyuan.run"]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
      endpoint = ["https://xxx-k8s.xuanyuan.run"]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
      endpoint = ["https://xxx-gcr.xuanyuan.run"]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."ghcr.io"]
      endpoint = ["https://xxx-ghcr.xuanyuan.run"]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
      endpoint = ["https://xxx-k8s.xuanyuan.run"]
```

生产可配多节点 fallback：

```toml
endpoint = ["https://node1.xxx.xuanyuan.run", "https://node2.xxx.xuanyuan.run"]
```

⚠️ 生产禁止 `insecure_skip_verify = true`，须使用合法 TLS。

#### 生效与验证

```bash
sudo systemctl restart containerd
grep -A 5 "docker.io" /etc/containerd/config.toml
ctr images pull xxx.xuanyuan.run/library/alpine:latest

kubectl run test-pod --image=nginx:latest
kubectl describe pod test-pod | grep "Image:"
```

更细的截图步骤见 [containerd 教程](https://xuanyuan.cloud/usage/containerd)、[K3s 教程](https://xuanyuan.cloud/usage/k3s)。

---

### nerdctl 镜像加速配置（K8s / 企业常用）

nerdctl 与 containerd 共用配置，一般不必再配一遍。

```bash
nerdctl pull nginx:latest
nerdctl inspect nginx:latest | grep -i "registry"
nerdctl run -d -p 8080:80 --name nginx-test nginx:latest
```

可选：自建 `/etc/nerdctl/nerdctl.toml` 写 mirrors（多数场景可跳过）。

---

### Podman 镜像加速配置

新建 `/etc/containers/registries.conf.d/custom.conf`：

```ini
unqualified-search-registries = ['docker.io']

[[registry]]
prefix = "docker.io"
location = "registry-1.docker.io"
  [[registry.mirror]]
  location = "xxx.xuanyuan.run"

[[registry]]
prefix = "k8s.gcr.io"
location = "k8s.gcr.io"
  [[registry.mirror]]
  location = "xxx-k8s.xuanyuan.run"

[[registry]]
prefix = "gcr.io"
location = "gcr.io"
  [[registry.mirror]]
  location = "xxx-gcr.xuanyuan.run"

[[registry]]
prefix = "ghcr.io"
location = "ghcr.io"
  [[registry.mirror]]
  location = "xxx-ghcr.xuanyuan.run"

[[registry]]
prefix = "registry.k8s.io"
location = "registry.k8s.io"
  [[registry.mirror]]
  location = "xxx-k8s.xuanyuan.run"
```

验证：

```bash
podman pull docker.io/library/alpine:latest
podman inspect alpine:latest | grep -i "registry"
```

更多见 [Podman 教程](https://xuanyuan.cloud/usage/podman)。

---

## 镜像拉取使用示例

### 拉取官方镜像

```bash
# Docker：专属域路径（替换 xxx）
docker pull xxx.xuanyuan.run/library/mysql:8.0
docker pull xxx.xuanyuan.run/library/nginx:1.27

# 已配置 registry-mirrors 后可用短名
docker pull nginx:1.27
docker pull mysql:8.0

# 公共登录域（需先 docker login docker.xuanyuan.run）
docker pull docker.xuanyuan.run/library/alpine:3.20

# 免费版（仅 Hub）
docker pull docker.xuanyuan.me/library/alpine:3.20

# containerd
ctr images pull xxx.xuanyuan.run/library/mysql:8.0
ctr images pull xxx-k8s.xuanyuan.run/pause:3.9

# nerdctl
nerdctl pull mysql:8.0
nerdctl pull registry.k8s.io/pause:3.9

# Podman
podman pull mysql:8.0
podman pull nginx:1.27
```

### 拉取用户自定义镜像

```bash
docker pull xxx.xuanyuan.run/username/my-web-app:v1.0
docker pull xxx-ghcr.xuanyuan.run/username/my-tool:v2.1
nerdctl pull gcr.io/google-samples/node-hello:1.0
```

去掉域名前缀可用 `docker tag`，见 [去前缀 FAQ](https://xuanyuan.cloud/faq/remove-domain-prefix)。

---

## Docker Compose 使用示例

密码用环境变量注入，不要写进仓库。

### docker-compose.yml 示例（Nginx + MySQL）

```yaml
services:
  web:
    image: xxx.xuanyuan.run/library/nginx:1.27
    ports:
      - "8080:80"
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
    restart: unless-stopped
  db:
    image: xxx.xuanyuan.run/library/mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: test_db
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql-data:/var/lib/mysql
      - ./mysql/init:/docker-entrypoint-initdb.d
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u${MYSQL_USER}", "-p${MYSQL_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 3
volumes:
  mysql-data:
```

若已配置 `registry-mirrors`，也可继续写短名 `nginx:1.27` / `mysql:8.0`。Compose 说明见 [Docker Compose 配置](https://xuanyuan.cloud/usage/docker-compose)。

### .env 文件示例

```env
MYSQL_ROOT_PASSWORD=StrongRootPassw0rd!
MYSQL_USER=appuser
MYSQL_PASSWORD=AppUserPassw0rd!
```

### 安全说明

1. `.env` 加入 `.gitignore`，勿提交 Git
2. 生产用 Vault / Kubernetes Secrets 管密码
3. 定期轮换数据库密码
4. 限制数据卷权限（如 `chmod 700`）

### 运行与停止

```bash
docker compose up -d
docker compose ps
docker compose logs -f
docker compose down
docker compose down -v
```

---

## containerd 单独使用示例

测试（`--net-host` 仅限测试）：

```bash
ctr images pull xxx.xuanyuan.run/library/nginx:1.27
ctr run --rm -t --net-host xxx.xuanyuan.run/library/nginx:1.27 nginx-test
ctr containers ls
ctr tasks stop nginx-test
```

生产（自定义网络）：

```bash
ctr network create nginx-net
ctr run --rm -t --net nginx-net -p 8080:80 xxx.xuanyuan.run/library/nginx:1.27 nginx-prod
```

---

## Podman 使用示例（兼容 Docker 命令）

```bash
podman run -d -p 6379:6379 --name redis-test --restart=always redis:7.2
podman ps
podman exec -it redis-test redis-cli
podman stop redis-test && podman rm redis-test
```

---

## 容器运行时 vs 加速配置位置对照表

| 容器运行时 | 配置文件位置 | 加速类型支持 | 适用场景 |
|------------|--------------|--------------|----------|
| Docker | `/etc/docker/daemon.json` | Docker Hub（registry-mirrors） | 个人 / 企业单机 |
| containerd | `/etc/containerd/config.toml` | 多仓库（docker.io / ghcr.io / registry.k8s.io 等） | K8s 集群 / 容器云 |
| nerdctl | 共享 containerd 配置 | 多仓库，命令接近 Docker | 企业生产替代 Docker CLI |
| Podman | `/etc/containers/registries.conf.d/*.conf` | 多仓库 | 无守护进程 / 边缘 |

群晖、威联通、极空间：把专属域名写进容器引擎即可，教程见 [群晖](https://xuanyuan.cloud/usage/synology)、[威联通](https://xuanyuan.cloud/usage/weiliantong)、[极空间](https://xuanyuan.cloud/usage/jikongjian)。**不要**对专属域做 `docker login`。

---

## 企业生产环境配置 Checklist

| 检查项 | 要求 |
|--------|------|
| 镜像源 | 生产用轩辕专业版专属节点；别把网易等已停公共源、不稳定免费源写进生产机 |
| TLS | 开 HTTPS / 合法证书，别开 insecure |
| 高可用 | mirrors 配两个以上 endpoint，单点挂了还能拉 |
| 本地缓存 | Harbor 等把常用镜像缓存进内网 |
| 密码 | 别把数据库密码写进仓库；用密钥或 Secrets |
| 权限 | 容器尽量非 root；数据目录权限收紧 |
| 观察 | 看拉取是否经常失败、是否明显变慢 |
| 日志 | 拉取相关日志按公司合规要求留存 |
| 流量 | 专业版先 [充值](https://xuanyuan.cloud/recharge)；遇到 `402` 去充值，别反复改密码 |
| 脚本 | 生产先把 `docker.sh` 下载下来看完再执行 |

---

## 常见问题（FAQ）

### Q1：配置了 Docker 镜像加速，部分镜像仍拉不下来？

`registry-mirrors` 主要对 Docker Hub（`docker.io`）生效。拉 `ghcr.io`、`registry.k8s.io` 等需要：

- **containerd / nerdctl**：在 `config.toml` 配对应仓库 mirrors（注意 K8s 用 `xxx-k8s.xuanyuan.run`）
- **Podman**：在 `registries.conf` 加 mirror
- **团队 / 生产**：用 [轩辕镜像专业版](https://xuanyuan.cloud) 专属域名，把 Hub / GHCR / K8s 等仓库都配上

见 [支持哪些镜像仓库](https://xuanyuan.cloud/faq/supported-registries)、[mirrors 不生效](https://xuanyuan.cloud/faq/registry-mirrors-not-working)。

### Q2：网易云 hub-mirror.c.163.com 还能用吗？

**不能。** 网易云等大厂公共 Docker 镜像加速已停用。请从 `daemon.json` / Desktop 配置中删除该地址，改用云厂商**同云内网源**或轩辕专业版 / 免费版。

### Q3：阿里云、腾讯云镜像加速配好了，家里电脑为什么还是慢？

这些地址多在**对应云内网**生效。笔记本、另一家云、CI 跑不通是正常现象。跨环境请用轩辕专属域名。

### Q4：NAS（群晖、威联通、极空间）怎么配？

1. 登录 [轩辕镜像专业版](https://xuanyuan.cloud)，打开 [使用手册](https://xuanyuan.cloud/usage) 选对应 NAS
2. 在 NAS 容器引擎里写入专属加速地址（优先专属域，免 login）
3. 保存并重启容器服务，拉 `nginx:latest` 验证

### Q5：K8s Pod 提示镜像拉取失败 / ImagePullBackOff？

1. 确认节点改的是 containerd（或 K3s），不是笔记本上的 Docker Desktop
2. `config.toml` 是否包含 Pod 所用仓库（如 `registry.k8s.io` → `xxx-k8s`）
3. `sudo systemctl restart containerd` 后 `kubectl describe pod <name>` 看 Events

证书问题见 [TLS FAQ](https://xuanyuan.cloud/faq/tls-certificate-error)；架构不匹配见 [no matching manifest](https://xuanyuan.cloud/faq/no-matching-manifest-architecture)。

### Q6：Podman 提示 insecure registry？

1. HTTP 地址：仅测试可 `insecure = true`，生产必须 HTTPS
2. HTTPS：检查证书；自签证书放入 `/etc/containers/certs.d/xxx.xuanyuan.run/`
3. 生产用专业版合法证书

### Q7：企业怎么保证镜像源稳定？

1. 用轩辕专业版专属节点，带宽别跟公共免费源抢
2. mirrors 写多个 endpoint，互为备份
3. 常用镜像进 Harbor，少依赖外网
4. 拉取经常失败就查节点和流量；不够就去充值中心加流量，必要时找官网支持

`401` / `402` / `429` / `manifest unknown` 等错误码说明见 [FAQ 列表](https://xuanyuan.cloud/faq)。

---

## 总结

- **同云 ECS、只拉 Docker Hub**：继续用阿里云 / 腾讯云 / 华为云内网源；配置里删掉网易等已停公共源。
- **本机、跨云、NAS、CI，或要 GHCR / K8s**：用 [轩辕镜像专业版](https://xuanyuan.cloud) 专属域名；K8s 改 containerd 多仓库 mirrors，常用镜像可再进 Harbor。
- **自己临时试 Hub**：`docker.xuanyuan.me` 或一键脚本就行；团队和生产请充专业版流量。
- **安全**：生产别开 insecure，别把密码写进仓库；远程脚本先下载看过再跑。

常用链接：

- [注册轩辕镜像专业版](https://xuanyuan.cloud) · [充值中心](https://xuanyuan.cloud/recharge)（新人 ¥2.9 起，50GB ¥8）
- [使用手册](https://xuanyuan.cloud/usage) · [FAQ](https://xuanyuan.cloud/faq) · [镜像搜索](https://xuanyuan.cloud/search)

下次 `docker pull` 又超时，先回来对一下这份 9 月国内 Docker 镜像源加速列表，再改配置。


