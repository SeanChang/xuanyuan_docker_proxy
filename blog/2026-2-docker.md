# 2026 年 2 月最新 Docker 镜像源加速列表与使用指南

![2026 年 2 月最新 Docker 镜像源加速列表与使用指南](https://img.xuanyuan.dev/docker/blog/docker-202602.png)

*分类: Docker,镜像源,轩辕镜像 | 标签: Docker,镜像源,轩辕镜像 | 发布时间: 2026-02-01 02:24:07*

> 本文汇总了当前可用且稳定的国内Docker镜像加速地址，覆盖Docker、K8s containerd、Podman、nerdctl等主流场景，零基础用户也能按步骤完成配置。

本文汇总了当前可用且稳定的Docker镜像加速地址，覆盖Docker、K8s containerd、Podman、nerdctl等主流场景，零基础用户也能按步骤完成配置。

⚠️ 说明：本文内容仅限学习研究，请勿违规使用。建议收藏，以便获取后续更新。

## 2026年2月可用镜像加速源
1. 腾讯云镜像  
   地址：`https://mirror.ccs.tencentyun.com`  
   仅推荐在腾讯云服务器上使用，其他环境可能无法正常访问

2. 阿里云镜像  
   地址：`https://xxx.mirror.aliyuncs.com`（不同账号专属地址不同）  
   仅推荐在阿里云ECS环境中使用，需配合自身账号配置

3. 轩辕镜像（推荐优先使用）  
   轩辕镜像专业版（适合开发者、科研人员、企业及NAS专业用户）  
   地址：`https://xuanyuan.cloud` 
   需登录，提供专属加速地址（如xxx.xuanyuan.run），速度更稳定  
   支持K8s（k3s/cri-o）、群晖/威联通/极空间NAS等特殊环境  
   🔐 企业级特性（前置展示）：  
   - 高可用方案：支持多节点fallback配置，避免单点故障  
   - 私有部署支持：可对接Harbor本地镜像缓存，同步常用镜像  
   - 企业专属节点：独立IP+带宽，保障生产环境稳定性  
   - 监控与售后：实时节点监控、拉取日志审计、7×24小时技术支持  
   提供企业级支持、售后服务及定制化配置方案

   轩辕镜像免费版（适合普通用户）  
   地址：`https://docker.xuanyuan.me`  
   无需登录，免费使用  
   兼容Linux桌面/服务器/NAS设备，支持containerd、Podman环境  
   提供官网搜索功能，方便查找镜像

## 一键安装与配置镜像加速（推荐方案）
🧪 测试环境 / 🏭 生产环境（需审计）  
Linux Docker & Docker Compose 一键安装配置脚本  
脚本支持13种主流Linux发行版（含国产系统），可一键完成Docker、Docker Compose安装及轩辕镜像加速配置，无需手动操作。

### 执行命令
#### 🧪 测试环境（快速体验，仅限非生产场景）
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

#### 🏭 生产环境（推荐，安全优先）
```bash
# 1. 下载脚本到本地
wget https://xuanyuan.cloud/docker.sh -O docker-install.sh

# 2. （可选）审计脚本源码（建议企业环境必做）
less docker-install.sh  # 或使用vim、cat查看脚本内容

# 3. 执行脚本
bash docker-install.sh
```

⚠️ 安全强制提示：  
1. `curl | bash` / `wget | bash` 方式仅建议用于测试、个人学习或非核心环境，生产环境禁止直接执行远程脚本；  
2. 金融、政务、内网等敏感环境，必须先下载脚本进行安全审计，确认无恶意代码后再执行；  

### 脚本特性与优势
- 支持13种发行版：覆盖openEuler、OpenCloudOS、Anolis OS、Alinux、Kylin Linux等国产系统，以及Fedora、Rocky Linux、Ubuntu、Debian、CentOS等主流发行版  
- 国产系统深度适配：自动识别国产操作系统版本，提供最优配置方案  
- 多源智能切换：内置阿里云、腾讯云、华为云、中科大、清华等6+国内镜像源，自动选择最快节点  
- 老版本兼容：支持Ubuntu 16.04、Debian 9/10等过期系统，自动适配兼容安装方案  
- 双重安装保障：包管理器安装失败时，自动切换到二进制安装，确保安装成功  
- 跨系统提示：检测到macOS或Windows系统时，自动提供Docker Desktop安装指引  
- 开源透明：脚本已在GitHub开源: `https://github.com/SeanChang/xuanyuan_docker_proxy`

### 支持的操作系统详情
| 分类         | 操作系统               | 版本          | 支持状态 | 说明                          |
|--------------|------------------------|---------------|----------|-------------------------------|
| 国产操作系统 | openEuler (欧拉)       | 20.03+, 22.03+, 24.03+ | ✅        | 华为开源，兼容CentOS          |
|              | OpenCloudOS            | 9.x           | ✅        | 腾讯开源，兼容CentOS 9        |
|              | Anolis OS (龙蜥)       | 7.x, 8.x      | ✅        | 阿里云支持，兼容RHEL          |
|              | Alinux (阿里云)        | 2.x, 3.x      | ✅        | 阿里云ECS默认系统             |
|              | Kylin Linux (银河麒麟) | V10           | ✅        | 国产系统，兼容RHEL            |
| CentOS替代品 | Rocky Linux            | 8.x, 9.x      | ✅        | 10年支持周期，兼容RHEL        |
|              | AlmaLinux              | 8.x, 9.x      | ✅        | 10年支持周期，兼容RHEL        |
| 创新发行版   | Fedora                 | 34+           | ✅        | Red Hat上游，含最新特性       |
| 传统发行版   | Ubuntu                 | 16.04+        | ✅        | 含老版本特殊兼容处理          |
|              | Debian                 | 9+            | ✅        | 含老版本特殊兼容处理          |
|              | CentOS                 | 7, 8, 9       | ✅        | 包含Stream版本                |
|              | RHEL                   | 7, 8, 9       | ✅        | Red Hat企业级发行版           |
|              | Oracle Linux           | 7, 8, 9       | ✅        | Oracle企业级发行版            |

💡 提示：脚本会自动检测系统类型和版本，无需手动选择安装方案，全程自动化完成。

## 手动配置镜像加速（已安装Docker环境）
### Linux系统
```bash
# 创建配置目录
sudo mkdir -p /etc/docker

# 写入加速配置
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://docker.xuanyuan.me"]
}
EOF

# 重新加载配置并重启Docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```

验证配置：执行 `docker info | grep "Registry Mirrors" -A 3`，输出包含 `https://docker.xuanyuan.me` 即配置成功。

💡 关键说明：`registry-mirrors` 仅作用于Docker Hub（docker.io）镜像，若需加速ghcr.io、registry.k8s.io等第三方仓库，需按对应容器环境的专属配置操作（如下文containerd、Podman章节）。

### macOS（Docker Desktop）
#### 基础配置（免费加速源）
1. 点击菜单栏Docker图标 → Preferences  
2. 找到Daemon → Registry mirrors  
3. 添加地址 `https://docker.xuanyuan.me`  
4. 点击Apply & Restart完成重启

#### 补充配置（轩辕专业版专属地址）
1. 进入Docker Desktop设置 → 左侧Docker Engine  
2. 按以下格式修改配置（替换xxx.xuanyuan.run为专属地址）
```json
{
  "registry-mirrors": ["https://xxx.xuanyuan.run", "https://docker.xuanyuan.me"]
  // ⚠️ 仅限测试环境：若专属地址无合法证书，可添加以下配置（生产环境禁止）
  // "insecure-registries": ["xxx.xuanyuan.run"]
}
```
3. 点击Apply & Restart，通过`docker info`验证生效

⚠️ 安全提示：`insecure-registries` 仅允许在测试环境临时使用，生产环境必须使用带合法SSL证书的加速地址，避免MITM（中间人攻击）风险。

### Windows（Docker Desktop）
#### 基础配置（免费加速源）
1. 右键点击右下角Docker图标 → Settings  
2. 打开Docker Daemon配置，修改JSON内容
```json
{
  "registry-mirrors": ["https://docker.xuanyuan.me"]
}
```
3. 点击Apply，等待Docker重启完成

#### 补充配置（轩辕专业版专属地址）
1. 进入Docker Desktop → Settings → Docker Engine  
2. 按以下格式修改配置（替换xxx.xuanyuan.run为专属地址）
```json
{
  "registry-mirrors": ["https://xxx.xuanyuan.run"]
  // ⚠️ 仅限测试环境：若专属地址无合法证书，可添加以下配置（生产环境禁止）
  // "insecure-registries": ["xxx.xuanyuan.run"]
}
```
3. 点击Apply重启，通过`docker info`查看Registry Mirrors确认生效

⚠️ 安全提示：生产环境使用`insecure-registries`会导致安全审计不通过，建议联系轩辕镜像客服申请带SSL证书的专属地址。

## 其他容器环境加速配置
### K8s containerd 镜像加速配置
适用于Kubernetes（k3s/cri-o）或自建containerd环境，提升镜像拉取速度。

#### 适用版本
| containerd版本 | 支持说明                                  |
|----------------|-------------------------------------------|
| < 1.4          | 配置方式存在差异（CRI插件结构不同），不建议新环境使用 |
| 1.4 ~ 1.7.x    | 完全支持，需按以下步骤配置                |
| ≥ 1.7.x        | 推荐使用，支持更多高级特性                |

查看当前版本：`containerd --version`

#### 配置步骤
1. 初始化配置文件（若未生成）
```bash
containerd config default > /etc/containerd/config.toml
```

2. 编辑配置文件：`sudo nano /etc/containerd/config.toml`  
   在`plugins."io.containerd.grpc.v1.cri".registry.mirrors`节点下添加以下内容（替换xxx.xuanyuan.run为专属地址）
```toml
[plugins."io.containerd.grpc.v1.cri".registry]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    # Docker Hub 加速
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
      endpoint = ["https://xxx.xuanyuan.run"]  # 生产环境推荐：多节点fallback配置 ["https://node1.xxx.xuanyuan.run", "https://node2.xxx.xuanyuan.run"]
    # K8s 旧版镜像仓库（k8s.gcr.io）
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
      endpoint = ["https://xxx-k8s.xuanyuan.run"]
    # GCR 镜像仓库
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
      endpoint = ["https://xxx-gcr.xuanyuan.run"]
    # GHCR 镜像仓库
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."ghcr.io"]
      endpoint = ["https://xxx-ghcr.xuanyuan.run"]
    # 新版 K8s 镜像仓库（registry.k8s.io）
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
      endpoint = ["https://xxx.xuanyuan.run"]
    # ⚠️ 仅限测试环境：若加速地址无合法证书，添加以下配置（生产环境禁止）
    # [plugins."io.containerd.grpc.v1.cri".registry.configs."xxx.xuanyuan.run".tls]
    #   insecure_skip_verify = true
```

⚠️ 安全提示：`insecure_skip_verify = true` 仅允许在测试环境临时使用，生产环境必须启用TLS校验（使用合法证书或私有CA签名证书），避免数据泄露风险。

#### 生效与验证
```bash
# 重启containerd
sudo systemctl restart containerd

# 验证配置
grep -A 5 "docker.io" /etc/containerd/config.toml

# 拉取测试镜像
ctr images pull xxx.xuanyuan.run/library/alpine:latest

# K8s环境测试
kubectl run test-pod --image=nginx:latest
kubectl describe pod test-pod | grep "Image:"
```

### nerdctl 镜像加速配置（K8s/企业首选）
nerdctl是containerd的Docker兼容CLI工具，企业环境推荐使用，配置与containerd共享，无需额外重复配置。

#### 配置步骤
1. 确保containerd已按上述步骤配置完成（nerdctl自动读取containerd配置）  
2. 验证加速效果：
```bash
# 拉取镜像（自动走containerd配置的加速源）
nerdctl pull nginx:latest

# 查看镜像拉取来源
nerdctl inspect nginx:latest | grep -i "registry"

# 运行容器（兼容Docker命令）
nerdctl run -d -p 8080:80 --name nginx-test nginx:latest
```

#### 额外优化（可选）
创建nerdctl专属配置文件，自定义加速规则：
```bash
sudo mkdir -p /etc/nerdctl
cat <<EOF | sudo tee /etc/nerdctl/nerdctl.toml
[registry]
mirrors = [
  { host = "docker.io", mirrors = ["https://xxx.xuanyuan.run"] },
  { host = "ghcr.io", mirrors = ["https://xxx-ghcr.xuanyuan.run"] }
]
EOF
```

### Podman 镜像加速配置
适用于无守护进程的轻量场景，兼容Docker命令习惯。

#### 配置步骤
新建自定义配置文件（推荐，避免覆盖系统默认配置）：
```bash
sudo nano /etc/containers/registries.conf.d/custom.conf
```

写入以下配置（替换xxx.xuanyuan.run为专属地址）：
```toml
# 默认搜索Docker Hub
unqualified-search-registries = ['docker.io']

# Docker Hub 加速
[[registry]]
prefix = "docker.io"
location = "registry-1.docker.io"
  [[registry.mirror]]
  location = "xxx.xuanyuan.run"
# ⚠️ 仅限测试环境：若加速地址为HTTP或证书无效，添加以下配置（生产环境禁止）
# insecure = true

# K8s.gcr.io 加速
[[registry]]
prefix = "k8s.gcr.io"
location = "k8s.gcr.io"
  [[registry.mirror]]
  location = "xxx-k8s.xuanyuan.run"

# GCR.io 加速
[[registry]]
prefix = "gcr.io"
location = "gcr.io"
  [[registry.mirror]]
  location = "xxx-gcr.xuanyuan.run"

# GHCR.io 加速
[[registry]]
prefix = "ghcr.io"
location = "ghcr.io"
  [[registry.mirror]]
  location = "xxx-ghcr.xuanyuan.run"
```

⚠️ 安全提示：`insecure = true` 仅允许在测试环境使用，生产环境应确保加速地址使用HTTPS协议且证书有效；若使用私有CA，需将CA证书放入 `/etc/containers/certs.d/xxx.xuanyuan.run/` 目录。

保存文件（Ctrl+O → 回车 → Ctrl+X）

#### 验证生效
```bash
# 拉取测试镜像
podman pull docker.io/library/alpine:latest

# 查看镜像拉取来源
podman inspect alpine:latest | grep -i "registry"
```

## 镜像拉取使用示例
### 拉取官方镜像
```bash
# Docker（免费源）
docker pull docker.xuanyuan.me/library/mysql:5.7
docker pull docker.xuanyuan.me/library/nginx:1.25

# Docker（轩辕镜像专业版专属地址）
docker pull xxx.xuanyuan.run/library/mysql:8.0
docker pull xxx.xuanyuan.run/library/nginx:latest

# Podman（自动走加速）
podman pull mysql:5.7
podman pull nginx:1.25

# containerd（显式指定加速地址）
ctr images pull xxx.xuanyuan.run/library/mysql:5.7
ctr images pull xxx-k8s.xuanyuan.run/k8s.gcr.io/pause:3.9

# nerdctl（兼容Docker命令，自动加速）
nerdctl pull mysql:8.0
nerdctl pull registry.k8s.io/pause:3.9
```

### 拉取用户自定义镜像
```bash
# Docker 拉取Docker Hub用户镜像
docker pull xxx.xuanyuan.run/username/my-web-app:v1.0

# Docker 拉取GHCR用户镜像
docker pull xxx-ghcr.xuanyuan.run/username/my-tool:v2.1

# Podman 拉取GHCR用户镜像
podman pull ghcr.io/username/my-tool:v2.1

# containerd 拉取GCR用户镜像
ctr images pull xxx-gcr.xuanyuan.run/google-samples/node-hello:1.0

# nerdctl 拉取GCR用户镜像
nerdctl pull gcr.io/google-samples/node-hello:1.0
```

## Docker Compose 使用示例
🔐 安全配置：避免明文密码，使用环境变量注入（测试/生产环境通用）

### docker-compose.yml 示例（Nginx + MySQL）
```yaml
version: "3.8"
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
    restart: always  # 生产环境推荐：自动重启
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}  # 从.env文件读取密码
      MYSQL_DATABASE: test_db
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql-data:/var/lib/mysql
      - ./mysql/init:/docker-entrypoint-initdb.d  # 初始化脚本目录
    restart: always
    healthcheck:  # 生产环境推荐：健康检查
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u${MYSQL_USER}", "-p${MYSQL_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 3
volumes:
  mysql-data:
```

### .env 文件示例（与docker-compose.yml同目录）
```env
# MySQL配置（生产环境请使用强密码，并定期更换）
MYSQL_ROOT_PASSWORD=StrongRootPassw0rd!
MYSQL_USER=appuser
MYSQL_PASSWORD=AppUserPassw0rd!
```

### 安全说明
1. 切勿将`.env`文件提交到版本控制系统（如Git），需在`.gitignore`中添加`.env`；  
2. 生产环境推荐使用密钥管理工具（如Vault、Kubernetes Secrets）存储密码，而非`.env`文件；  
3. 定期轮换数据库密码，避免长期使用固定密码；  
4. 限制`mysql-data`数据卷的访问权限（如`chmod 700`），防止敏感数据泄露。

### 运行与停止命令
```bash
# 启动服务（后台运行）
docker compose up -d

# 查看状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止服务（保留数据）
docker compose down

# 停止并删除数据卷（谨慎使用）
docker compose down -v
```

## containerd 单独使用示例
🧪 测试环境（--net-host仅用于测试，生产环境禁止）
```bash
# 拉取镜像
ctr images pull xxx.xuanyuan.run/library/nginx:latest

# 运行容器（--net-host仅限测试，生产环境使用自定义网络）
ctr run --rm -t --net-host xxx.xuanyuan.run/library/nginx:latest nginx-test

# 查看容器
ctr containers ls

# 停止容器
ctr tasks stop nginx-test
```

🏭 生产环境示例（使用自定义网络）
```bash
# 创建自定义网络
ctr network create nginx-net

# 运行容器（指定端口映射和网络）
ctr run --rm -t --net nginx-net -p 8080:80 xxx.xuanyuan.run/library/nginx:latest nginx-prod
```

## Podman 使用示例（兼容Docker命令）
```bash
# 运行Redis容器
podman run -d -p 6379:6379 --name redis-test --restart=always redis:7.2

# 查看容器状态
podman ps

# 进入容器
podman exec -it redis-test redis-cli

# 停止并删除容器
podman stop redis-test
podman rm redis-test
```

## 容器运行时 vs 加速配置位置对照表
| 容器运行时 | 配置文件位置                          | 加速类型支持                | 适用场景                  |
|------------|---------------------------------------|-----------------------------|---------------------------|
| Docker     | /etc/docker/daemon.json               | Docker Hub（registry-mirrors） | 个人/企业单机使用         |
| containerd | /etc/containerd/config.toml           | 多仓库（docker.io/gcr.io等） | K8s集群/容器云平台        |
| nerdctl    | /etc/containerd/config.toml + /etc/nerdctl/nerdctl.toml | 多仓库兼容Docker命令 | 企业生产环境（替代Docker） |
| Podman     | /etc/containers/registries.conf.d/*.conf | 多仓库轻量加速              | 无守护进程场景/边缘设备   |


## 企业生产环境配置Checklist（🔐 安全合规优先）
| 检查项                | 要求                                                                 |
|-----------------------|----------------------------------------------------------------------|
| 镜像源选择            | 使用企业级专属镜像源（如轩辕专业版），避免公共源                    |
| 安全校验              | 镜像拉取前校验SHA256，启用TLS校验，禁止insecure配置                  |
| 高可用配置            | 镜像源配置多节点fallback，避免单点故障                               |
| 本地缓存              | 搭建Harbor/Registry本地镜像仓库，同步常用镜像，降低对外依赖          |
| 密码管理              | 禁止明文密码，使用密钥管理工具存储敏感信息                           |
| 权限控制              | 容器以非root用户运行，限制数据卷访问权限                             |
| 监控告警              | 配置镜像拉取成功率、速度监控，异常时触发告警                         |
| 审计日志              | 开启镜像拉取日志审计，留存至少90天，满足合规要求                     |
| 定期更新              | 定期更新Docker/containerd版本及镜像源配置，修复安全漏洞               |

## 常见问题（FAQ）
### Q1：配置加速源后，部分镜像仍拉不下来？
核心原因是`registry-mirrors`仅对Docker Hub（docker.io）镜像生效。若拉取ghcr.io、registry.k8s.io等第三方仓库镜像，需按对应环境配置专属加速：  
- containerd/nerdctl：在config.toml中配置对应仓库的mirrors；  
- Podman：在registries.conf中添加对应仓库的mirror配置；  
- 企业用户：使用轩辕专业版，获取全仓库加速方案，或联系客服定制地址。

### Q2：NAS（群晖、威联通）如何配置？
推荐使用轩辕镜像专业版，步骤如下：  
1. 登录轩辕官网，在「NAS配置」专区选择对应设备型号；  
2. 按指引进入NAS的Docker/containerd配置界面（群晖需开启SSH，威联通进入容器Station高级设置）；  
3. 粘贴专属加速地址（带合法证书），保存并重启NAS容器服务；  
4. 拉取`nginx:latest`测试速度，确认配置生效。

### Q3：K8s部署Pod提示镜像拉取失败？
1. 检查config.toml是否配置了Pod所需镜像的仓库（如registry.k8s.io）；  
2. 重启containerd后，通过`kubectl describe pod <pod-name>`查看错误日志；  
3. 若为证书错误：生产环境更换带合法证书的加速地址，测试环境可临时添加`tls_config = { insecure_skip_verify = true }`；  
4. 若为endpoint不可达：确认加速地址正确性，或联系轩辕客服排查节点可用性。

### Q4：Podman提示“insecure registry”错误？
1. 若加速地址为HTTP协议：仅测试环境允许`insecure = true`，生产环境必须使用HTTPS；  
2. 若为HTTPS协议：检查地址是否包含`https://`，且服务器证书有效；自签证书需放入`/etc/containers/certs.d/xxx.xuanyuan.run/`目录；  
3. 企业环境：联系镜像源提供商获取合法SSL证书，避免insecure配置。

### Q5：企业环境如何保障镜像源稳定性？
1. 使用轩辕专业版「企业专属节点」，获取独立IP和带宽，避免共享资源竞争；  
2. 配置多节点fallback（如`endpoint = ["https://node1.xxx.xuanyuan.run", "https://node2.xxx.xuanyuan.run"]`）；  
3. 搭建Harbor本地镜像缓存，同步常用镜像，降低对外依赖；  
4. 开通「企业级监控」，实时查看节点状态、拉取速度和成功率；  
5. 签订SLA服务协议，保障故障时快速响应（如1小时内技术支持）。

## 总结（架构师视角）
- **个人/测试环境**：优先使用轩辕免费加速源`https://docker.xuanyuan.me`或一键安装脚本（需审计源码），快速满足需求；  
- **企业生产环境**：必须选择企业级专属镜像源（如轩辕专业版），配置高可用、本地缓存和安全校验，满足合规要求；  
- **K8s/集群环境**：核心配置containerd+nerdctl的多仓库加速，搭配Harbor本地缓存，确保集群部署稳定不超时；  
- **安全合规优先**：任何环境都应禁止insecure配置和明文密码，生产环境坚决避免直接执行远程脚本，所有操作需留痕审计。

建议收藏本文，每月会更新镜像源可用性及配置细节；遇到问题可查看轩辕镜像官网FAQ（`https://xuanyuan.cloud/faq`），或联系官网客服获取企业级技术支持。

