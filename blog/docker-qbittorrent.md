# qBittorrent Docker 企业级部署（生产环境终版）

![qBittorrent Docker 企业级部署（生产环境终版）](https://img.xuanyuan.dev/docker/blog/docker-qbittorrent.png)

*分类: Docker,qBittorrent  | 标签: qBittorrent,docker,部署教程 | 发布时间: 2025-10-03 12:53:27*

> 很多 qBittorrent Docker 教程只能“跑起来”，却无法长期稳定运行在生产环境。
> 本文从企业运维视角出发，系统梳理 qBittorrent 在 Docker 环境下的标准化部署规范，明确测试、生产、企业级、PT 专用等不同场景边界，重点覆盖版本锁定、最小权限、安全隔离、资源限制、日志与健康检查等生产级要点，可直接纳入企业内部 Wiki 使用。

## 🧰 准备工作
### 前置说明
生产环境需优先保障脚本安全性与可审计性，禁止盲目执行远程脚本。

### Linux Docker & Docker Compose 一键安装
一键安装配置脚本（适用于测试/快速部署场景）：
该脚本支持多 Linux 发行版，可一键安装 Docker、Docker Compose 并配置轩辕镜像源。

⚠️ 【安全强制声明】
该脚本会以 `root` 权限执行 Docker 安装、镜像源配置等操作：
- 测试环境：可直接执行快速安装
- 生产环境/企业服务器：**必须先下载脚本审计源码，确认无风险后再执行**

```bash
# 测试环境快速执行（仅推荐非生产场景）
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 生产环境安全执行流程（企业级推荐）
wget https://xuanyuan.cloud/docker.sh  # 下载脚本到本地
less docker.sh                        # 人工审阅脚本内容（关键！）
bash docker.sh                        # 确认无风险后执行
```

---

## 1、查看 qBittorrent 镜像详情
你可在轩辕镜像中查看 qBittorrent 镜像详情：
👉 [https://xuanyuan.cloud/r/linuxserver/qbittorrent](https://xuanyuan.cloud/r/linuxserver/qbittorrent)

该镜像由 **LinuxServer.io 团队** 维护，核心特点：
- 持续更新，安全补丁及时
- 支持多架构（x86-64 / arm64）
- 非 root 用户运行（PUID/PGID），符合最小权限原则
- 配置持久化机制，保障数据不丢失

⚠️ 版本标签核心提示：
- `latest`：自动指向最新版本，适合**测试/体验**，但不可复现、可能引入破坏性变更
- 固定版本（如 `4.6.5`）：生产环境**必须使用**，保障部署可复现、版本可控

---

## 2、下载 qBittorrent 镜像
### 2.1 查看可用版本（生产环境必备）
先查询镜像稳定版本号（避免盲目使用 latest）：
```bash
# 方式1：访问轩辕镜像页面查看版本列表
https://xuanyuan.cloud/r/linuxserver/qbittorrent/tags

# 方式2：通过 Docker Hub 查询（需网络可达）
curl -s https://hub.docker.com/v2/repositories/linuxserver/qbittorrent/tags | jq -r '.results[].name' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$'
```

### 2.2 使用轩辕镜像拉取
```bash
# 测试环境：拉取 latest 标签
docker pull docker.xuanyuan.run/linuxserver/qbittorrent:latest

# 生产环境：拉取固定版本（示例：4.6.5，替换为实际稳定版本）
docker pull docker.xuanyuan.run/linuxserver/qbittorrent:4.6.5
```

### 2.3 镜像重命名（可选，简化后续命令）
```bash
# 测试环境
docker tag docker.xuanyuan.run/linuxserver/qbittorrent:latest linuxserver/qbittorrent:latest
docker rmi docker.xuanyuan.run/linuxserver/qbittorrent:latest

# 生产环境（以 4.6.5 为例）
docker tag docker.xuanyuan.run/linuxserver/qbittorrent:4.6.5 linuxserver/qbittorrent:4.6.5
docker rmi docker.xuanyuan.run/linuxserver/qbittorrent:4.6.5
```

### 2.4 官方直连方式（网络可达时）
```bash
# 测试环境
docker pull lscr.io/linuxserver/qbittorrent:latest

# 生产环境
docker pull lscr.io/linuxserver/qbittorrent:4.6.5
```

### 2.5 验证镜像下载结果
```bash
docker images
```
输出示例：
```
# 测试环境
REPOSITORY                 TAG       IMAGE ID       CREATED        SIZE
linuxserver/qbittorrent    latest    7d3c9b4a1a22   5 days ago     250MB

# 生产环境
REPOSITORY                 TAG       IMAGE ID       CREATED        SIZE
linuxserver/qbittorrent    4.6.5     a8b7d9c8e123   10 days ago    248MB
```

---

## 3、部署 qBittorrent（显性区分场景）
### 3.1 测试部署（快速验证，无持久化）
**适用场景**：首次体验、功能测试，无需保留配置/下载文件  
**特点**：临时目录、快速启停，数据无保障

```bash
docker run -d \
  --name=qbittorrent-test \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /tmp/qbt/config:/config \
  -v /tmp/qbt/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/qbittorrent:latest  # 测试环境允许使用 latest
```

⚠️ 【WebUI 安全警告（测试版）】
测试环境可临时访问 `http://服务器IP:8080`，但**禁止暴露公网**！
- 首次登录：用户名 `admin`，临时密码查看日志 `docker logs qbittorrent-test | grep -i password`
- 测试完成后：建议立即停止并删除容器 `docker rm -f qbittorrent-test`

### 3.2 生产部署（单机长期使用，数据持久化）
**适用场景**：个人服务器、NAS 长期使用，需保障配置/下载文件不丢失  
**核心规范**：版本锁定、数据持久化、最小权限、安全访问

#### 步骤1：创建持久化目录（保障数据安全）
```bash
mkdir -p /data/qbt/{config,downloads}
# 可选：适配 SELinux 场景（CentOS/Rocky Linux）
# chcon -Rt svirt_sandbox_file_t /data/qbt
```

#### 步骤2：启动生产级容器
```bash
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  # 资源限制（避免占用全部CPU/内存，单机模式生效）
  --cpus=2.0 \
  --memory=2G \
  # 端口映射（仅绑定内网IP，禁止直接公网暴露）
  -p 192.168.1.100:8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  # 数据持久化
  -v /data/qbt/config:/config \
  -v /data/qbt/downloads:/downloads \
  # 启动策略
  --restart unless-stopped \
  # 生产环境必须使用固定版本（示例：4.6.5）
  linuxserver/qbittorrent:4.6.5
```

⚠️ 【核心安全&规范提示】
1. PUID/PGID：**禁止使用 PUID=0/PGID=0（root 用户）**，失去最小权限隔离意义，查询当前用户 UID/GID：`id your_user`
2. WebUI 访问：生产环境必须仅绑定内网 IP（如 192.168.1.100），或通过防火墙/IP 白名单限制访问
3. 端口安全：6881(TCP/UDP) 需放行，但 WebUI(8080) 严禁直接暴露公网，建议通过反向代理（Nginx/Traefik）+ HTTPS + 认证访问
4. 磁盘 IO：下载目录建议挂载 SSD（提升 BT 读写性能），长期存储可迁移至 HDD（降低成本）

#### 目录映射说明
| 宿主机目录         | 容器内目录 | 作用               | 注意事项                     |
|--------------------|------------|--------------------|------------------------------|
| /data/qbt/config   | /config    | 保存配置文件       | 权限需匹配 PUID/PGID         |
| /data/qbt/downloads| /downloads | 保存下载内容       | 建议单独挂载磁盘，避免占满系统盘 |

### 3.3 企业级部署（标准化可维护，区分单机/编排模式）
**说明**：本文“企业级部署”指 **标准化、可维护的单机/多机 Docker 部署规范**，不等同于 Kubernetes，但可作为后续容器编排迁移的基础。

**适用场景**：企业服务器、多服务共存环境，需标准化、可维护的部署方式  
**核心增强**：健康检查、日志限制、资源约束、版本锁定

#### 步骤1：创建部署目录
```bash
mkdir -p /data/qbt/{config,downloads}
cd /data/qbt
```

#### 步骤2：编写 docker-compose.yml（分两种模式）
##### 模式A：单机 Docker Compose 部署（90% 企业单机场景适用）
```yaml
services:
  qbittorrent:
    image: linuxserver/qbittorrent:4.6.5  # 生产环境强制固定版本
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - WEBUI_PORT=8080
      - TORRENTING_PORT=6881
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    ports:
      - 192.168.1.100:8080:8080  # 仅绑定内网IP，禁止0.0.0.0
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
    # 资源限制（单机 Compose 生效，替代 deploy.resources）
    cpus: "2.0"
    mem_limit: 2g
    # 健康检查配置
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 60s
    # 日志限制（避免日志占满磁盘）
    logging:
      driver: "json-file"
      options:
        max-size: "100m"
        max-file: "3"
```
> ⚠️ 关键说明：`deploy.resources` 仅在 Docker Swarm/K8s 等编排环境中生效，单机 Compose 需使用 `cpus` 和 `mem_limit` 实现资源限制。

##### 模式B：Docker Swarm/K8s 编排部署（集群场景适用）
```yaml
services:
  qbittorrent:
    image: linuxserver/qbittorrent:4.6.5
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - WEBUI_PORT=8080
      - TORRENTING_PORT=6881
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    ports:
      - 192.168.1.100:8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
    # 资源限制（编排环境生效）
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 60s
    logging:
      driver: "json-file"
      options:
        max-size: "100m"
        max-file: "3"
```

> ⚠️ 健康检查依赖说明：`linuxserver/qbittorrent` 镜像内置 `curl`，可直接用于健康检查；若未来上游镜像裁剪工具链导致 `curl` 缺失，可改用 TCP 检测方式：`test: ["CMD-SHELL", "nc -z localhost 8080 || exit 1"]`

#### 步骤3：启动/管理服务
```bash
# 启动服务
docker compose up -d

# 常用管理命令
docker compose ps          # 查看状态
docker compose logs -f     # 查看实时日志
docker compose down        # 停止服务（保留数据）
docker compose pull && docker compose up -d  # 版本更新（需先确认新版本兼容）
```

### 3.4 高性能部署（--network=host，PT/专用机场景）
**适用场景**：PT 做种、高性能需求的单用途服务器  
**核心风险**：无网络隔离，需严格限定使用场景

```bash
docker run -d \
  --name=qbittorrent-host \
  --network=host  # 直接使用宿主机网络栈，无端口映射
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  --cpus=4.0 \  # PT场景可适当放宽资源限制
  --memory=4G \
  -v /data/qbt/config:/config \
  -v /data/qbt/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/qbittorrent:4.6.5  # 生产环境仍需版本锁定
```

⚠️ 【Host 模式强警告 & 云厂商限制补充】
✅ 适用：PT 专用机、单用途服务器、追求极致 BT 连接性
❌ 禁止：多服务服务器、企业环境、云主机（无网络隔离，端口易冲突、安全风险高）
❌ 云厂商注意：阿里云/腾讯云/AWS 等平台中，`--network=host` 结合安全组+NAT 并不会提升 BT 连通性，反而会增加端口冲突、权限排查难度，**云主机完全不建议使用此模式**
❌ 不可迁移：无法适配 K8s/云原生体系，仅适合单机部署

---

## 4、验证部署结果
### 4.1 基础验证
```bash
# 查看容器状态（Up 表示运行正常）
docker ps | grep qbittorrent

# 查看健康状态（仅 docker-compose 部署有）
docker inspect --format '{{.State.Health.Status}}' qbittorrent

# 查看日志（含初始密码）
docker logs -f qbittorrent
```

### 4.2 WebUI 访问（仅内网）
浏览器打开 `http://内网IP:8080`，使用默认用户名 `admin` + 日志中的临时密码登录。

✅ 登录后立即操作：
1. 修改登录密码（设置 → Web UI → 验证）
2. 关闭不必要的公网访问权限（设置 → Web UI → 仅允许内网IP访问）
3. 配置 BT 优化项（启用 DHT/PeX/UPnP，调整下载/上传限速）

⚠️ 【WebUI 公网暴露反例警告】
真实生产案例：大量直接公网暴露的 qBittorrent WebUI 会被自动化工具扫描破解，进而被用于灰产文件下载、带宽滥用，甚至牵连服务器参与 DDoS 攻击，导致服务器被运营商封禁或合规审查。

---

## 5、常见问题（生产级排查）
### 5.1 登录密码丢失/查询
```bash
# 快速查询初始密码
docker logs qbittorrent | grep -i password

# 应急重置密码（配置持久化场景，仅限当前版本）
sed -i 's/^Password=.*/Password=adminadmin/' /data/qbt/config/qBittorrent/qBittorrent.conf
docker restart qbittorrent
```

> ⚠️ 版本兼容兜底声明：该方式仅适用于**当前版本**的 qBittorrent 配置结构，若未来版本调整 WebUI 认证字段或加密方式，此方法会失效。企业环境优先通过 WebUI 正常流程重置密码，或参考官方文档的标准重置方案。

### 5.2 下载速度慢/做种效果差
1. 端口检查：确认 6881 TCP/UDP 端口已放行（防火墙+云服务器安全组）
2. 网络优化：启用 DHT/PeX/UPnP，确认公网 IP 可达（NAT 环境效果会打折扣）
3. 资源检查：确认容器资源限制未触顶（`docker stats qbittorrent`）
4. 磁盘 IO：下载目录若为 HDD，高并发时会有瓶颈，建议 SSD 作为缓存

### 5.3 WebUI 端口修改（生产级规范）
需同时修改环境变量和端口映射，且仅绑定内网 IP：
```bash
docker run -d \
  -e WEBUI_PORT=8123 \
  -p 192.168.1.100:8123:8123 \  # 宿主端口:容器端口 必须与 WEBUI_PORT 一致
  ...  # 其他参数不变
```

### 5.4 权限问题（生产级排查）
```bash
# 检查目录权限
ls -ld /data/qbt/config /data/qbt/downloads
# 输出应包含 uid=1000, gid=1000（与 PUID/PGID 一致）

# 修复权限
chown -R 1000:1000 /data/qbt
```
⚠️ 禁止使用 `chmod 777`（过度开放权限），也禁止 `PUID=0`（root 运行）。

### 5.5 版本更新（生产级流程）
```bash
# docker run 部署更新
docker pull linuxserver/qbittorrent:4.6.6  # 拉取新版本
docker stop qbittorrent
docker rm qbittorrent
# 重新启动（复用原有挂载目录，配置保留）
docker run -d ... linuxserver/qbittorrent:4.6.6

# docker-compose 部署更新
docker compose pull
docker compose up -d  # 自动重启，配置保留
```

---

## 6、生产环境高级规范（架构师级补充）
### 6.1 为什么不建议使用 `privileged=true`
本文所有部署方案均未使用 `--privileged=true` 参数，原因如下：
- 该参数会赋予容器宿主机的 root 权限，完全打破容器隔离边界，违背最小权限原则
- 权限过大易导致容器内操作影响宿主机系统安全，增加运维风险
- 企业合规审计中，`privileged=true` 通常被直接禁止

> 提示：qBittorrent 运行无需特权权限，通过 PUID/PGID 映射普通用户即可满足需求。

### 6.2 容器日志与业务日志的区分管理
- **容器运行时日志**：由 Docker `logging` 驱动管理，用于排查容器启动、健康检查等问题，需配置大小限制避免占盘
- **qBittorrent 业务日志**：存储在 `/data/qbt/config/qBittorrent/logs` 目录，记录下载任务、连接状态等信息
- 企业级建议：长期运维时，将业务日志通过 Filebeat 等工具收集至 ELK 等日志平台，便于审计和问题追溯

### 6.3 NAS 用户文件系统选择建议
对于 NAS 挂载存储的场景，不同文件系统对 BT 高并发 IO 的支持差异较大：
- **推荐**：`ext4` / `btrfs`，支持文件预分配、碎片整理，适合 BT 频繁读写
- **不推荐**：`NTFS` / `FAT32`，性能较差且权限管理复杂，不适合 Linux 容器环境

---

## 7、反向代理配置（WebUI 安全访问终解方案）
生产环境**严禁直接暴露 WebUI 端口**，推荐通过 Nginx 反向代理实现 HTTPS 访问 + 基础认证，配置示例如下：
```nginx
server {
    listen 443 ssl;
    server_name qbt.yourdomain.com;

    # HTTPS 证书配置（推荐 Let's Encrypt 免费证书）
    ssl_certificate /etc/nginx/ssl/qbt.crt;
    ssl_certificate_key /etc/nginx/ssl/qbt.key;

    # 基础认证（需先创建密码文件）
    auth_basic "qBittorrent 企业级访问认证";
    auth_basic_user_file /etc/nginx/htpasswd/qbt;

    # 反向代理配置
    location / {
        proxy_pass http://192.168.1.100:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

> 密码文件创建命令：`htpasswd -c /etc/nginx/htpasswd/qbt qbt_admin`，根据提示输入密码即可。

---

## 📋 部署模式对比（企业级快速选型表）
| 部署模式               | 适用场景                     | 核心优势                     | 核心风险                     |
|------------------------|------------------------------|------------------------------|------------------------------|
| 测试部署               | 首次体验、功能验证           | 快速启停、无需配置           | 数据不持久、无安全保障       |
| 生产部署（单机）       | 个人 NAS、单用途服务器       | 数据持久化、配置稳定         | 需手动管理资源/健康检查      |
| 企业级部署（单机 Compose） | 企业单机、多服务共存         | 标准化、可维护、资源可控     | 配置稍复杂                   |
| 企业级部署（Swarm/K8s）| 企业集群、高可用需求         | 集群调度、弹性伸缩           | 需掌握容器编排知识           |
| Host 网络部署          | PT 专用机、极致性能需求      | 连接性好、性能最优           | 无网络隔离、云主机不兼容     |

---

## 最终总结
本文档是**生产就绪级**的 qBittorrent Docker 部署规范，核心遵循以下企业级原则：
1. **版本可控**：测试用 `latest`，生产强制固定版本，保障可复现性
2. **最小权限**：禁止 root 运行，通过 PUID/PGID 实现权限隔离
3. **安全隔离**：WebUI 仅内网访问，配合反向代理 + HTTPS + 认证
4. **资源可控**：根据部署模式配置资源限制，避免影响同机服务
5. **合规运维**：明确场景边界，规避公网暴露、特权权限等合规风险

