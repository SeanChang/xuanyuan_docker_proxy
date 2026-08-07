# 网站被扫、被刷？Docker 部署 SamWaf 开源 WAF，一条命令护站

![网站被扫、被刷？Docker 部署 SamWaf 开源 WAF，一条命令护站](https://img.xuanyuan.dev/docker/blog/samwaf.png)

*分类: Docker部署教程 | 标签: SamWaf,WAF,Docker,轩辕镜像,网站防火墙,反向代理,私有化部署,部署教程 | 发布时间: 2026-07-12 13:43:12*

> 零基础教程：SamWaf 是什么、轩辕镜像加速拉取 samwaf/samwaf:v1.3.21、端口占用检查、试用模式 docker run、首次登录改密、添加受保护站点与后台功能导览。Ubuntu 24.04 实测含 9 张截图。

*本文基于 [samwaf/samwaf:v1.3.21](https://xuanyuan.cloud/r/samwaf/samwaf) 镜像，Ubuntu 24.04 服务器实测（管理端口 **26666**，试用模式 WAF 入口 **8088/8443**）*

网站日志里全是扫描器、SQL 注入探测，云 WAF 按量计费又贵？**SamWaf** 是一款 **开源、轻量、可完全私有化部署** 的 Web 应用防火墙——自带独立防护引擎与反向代理，不依赖 Nginx / Apache 插件；数据加密存本地，默认内置 SQLite，**单容器即可跑通**。管理后台在 **26666** 端口，可视化配置站点、规则、攻击日志与通知渠道。

本文带你完成一次 **SamWaf Docker 部署**：轩辕镜像拉取、检查 80/443 是否被占用、创建数据目录、`docker run` 试用模式启动、读取初始密码登录改密，再导览仪表盘、网站防护、访问日志、数据分析等核心界面——全程 Ubuntu 24.04 实测，附 **9 张截图**。

国内用户从 Docker Hub 拉取 `samwaf/samwaf` 可能较慢，本文使用 [轩辕镜像](https://xuanyuan.cloud) 加速。官方文档见 [doc.samwaf.com](https://doc.samwaf.com/)，源码 [samwafgo/SamWaf](https://github.com/samwafgo/SamWaf)，中文说明 [README_cn.md](https://github.com/samwafgo/SamWaf/blob/main/README_cn.md)。

> **部署要点**：SamWaf 通常部署在网站**最前端**（WAF + 反代）。若宿主机已有 Nginx 占用 80/443，本文采用**试用模式**映射 `8088/8443`，不中断现有站点；熟悉后再考虑让 SamWaf 接管生产入口。

## 一、SamWaf 是什么？

**SamWaf** 是一款面向小公司、工作室与个人站长的 **开源轻量级网站防火墙（WAF）**，支持完全私有化部署，本地数据加密存储，一键启动，提供 Linux / Windows / ARM64 二进制与 Docker 镜像。

| 能力 | 说明 |
|------|------|
| 独立引擎 | 防护不依赖 IIS、Nginx 插件，自带反向代理 |
| 攻击防护 | SQL 注入、XSS、RCE、扫描器识别、CC 限流、OWASP CRS 规则集 |
| 访问控制 | IP / URL 黑白名单、地区封禁、人机验证 |
| 流量接入 | HTTP/1.1、HTTP/2、HTTP/3（QUIC）、WebSocket、负载均衡 |
| 证书管理 | ACME 自动申请与续签、SNI 多证书 |
| 运维管理 | RBAC、OTP 双因素、攻击/访问日志、钉钉/飞书/邮件等通知 |
| 数据存储 | 默认加密 SQLite，可选 MySQL |

典型使用场景：

- 中小型网站 **防扫描、防注入、防 CC**
- 需要 **数据不出本地** 的私有化安全方案
- 在自有 VPS / 面板服务器上，用 WAF **前置反代** 到 Trilium、WordPress 等后端应用

架构示意：

```text
用户/攻击流量 ──HTTP:80/443（或试用 8088/8443）──▶ SamWaf 容器
SamWaf 容器 ──检测/拦截后反代──▶ 后端站点（如 127.0.0.1:8080）
管理员 ──HTTP:26666──▶ SamWaf 管理后台
SamWaf 容器 ──挂载卷──▶ 宿主机 conf/ data/ logs/ ssl/
```

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux（本文 Ubuntu 24.04） |
| Docker | 已安装 Docker 与 Docker Compose V2 |
| 内存 | ≥ 512 MB（推荐 1 GB 以上） |
| CPU | 单核即可；多站点建议双核 |
| 磁盘 | ≥ 1 GB（镜像 + 日志与 SQLite 数据库） |
| 端口 | **26666**（管理后台）；**80/443** 或试用 **8088/8443**（WAF 流量入口） |
| 工作目录 | `/www/wwwroot/samwaf`（与业务应用目录分开） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装 Docker，可使用轩辕镜像一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)
```

更多安装说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

**镜像标签对照**：

| 标签 | 适用场景 |
|------|----------|
| `v1.3.21` | 本文实测标签，**生产推荐**固定版本便于回滚 |
| `latest` | 最新稳定版，自动跟进发布 |
| `beta` | 测试版，体验新特性 |

---

## 三、拉取镜像

```bash
docker pull docker.xuanyuan.run/samwaf/samwaf:v1.3.21
```

成功时终端类似输出（**Ubuntu 24.04 实测**）：

```text
v1.3.21: Pulling from samwaf/samwaf
4f4fb700ef54: Pull complete
6d1d216ac731: Pull complete
3283dc972474: Pull complete
734462797b2c: Pull complete
47489ff430a3: Pull complete
95ebccc95d8e: Pull complete
55afa1ecc21d: Pull complete
cdd2b7f0e30a: Download complete
Digest: sha256:ff0f4d9ddc562ac3469284e3eac87d001bbef6db1689532e37a186198d668c1e
Status: Downloaded newer image for docker.xuanyuan.run/samwaf/samwaf:v1.3.21
docker.xuanyuan.run/samwaf/samwaf:v1.3.21
```

| 官方镜像 | 轩辕镜像加速拉取 |
|----------|------------------|
| `samwaf/samwaf:v1.3.21` | `docker pull docker.xuanyuan.run/samwaf/samwaf:v1.3.21` |
| `samwaf/samwaf:latest` | `docker pull docker.xuanyuan.run/samwaf/samwaf:latest` |

---

## 四、检查端口占用（部署前必做）

SamWaf 默认需要 **80、443、26666**。若宿主机已有 Nginx / Apache / 宝塔面板监听 80/443，直接映射会报 `port is already allocated`。

```bash
sudo ss -tlnp | grep -E ':80 |:443 |:26666 '
docker ps --format 'table {{.Names}}\t{{.Ports}}'
```

**Ubuntu 24.04 实测**（典型面板环境）：

```text
LISTEN 0  511  0.0.0.0:80   0.0.0.0:*  users:(("nginx",pid=3136670,fd=9),...)
LISTEN 0  511  0.0.0.0:443  0.0.0.0:*  users:(("nginx",pid=3136670,fd=29),...)
# 26666 无输出 → 空闲
NAMES     PORTS
# 无运行中容器
```

**判读与对策**：

| 情况 | 做法 |
|------|------|
| 80/443 **空闲** | 用第五节 **标准模式**（`-p 80:80 -p 443:443`） |
| 80/443 **被 Nginx 等占用** | 用第五节 **试用模式**（`-p 8088:80 -p 8443:443`），本文实测走此方案 |
| 26666 被占用 | 改映射，如 `-p 26667:26666` |

---

## 五、创建目录并启动容器

SamWaf 需挂载四个目录到容器内 `/app/conf`、`/app/data`、`/app/logs`、`/app/ssl`（[2024-10-15 起建议挂载 ssl 目录](https://xuanyuan.cloud/r/samwaf/samwaf)）。**不要**与 Trilium 等业务混在同一数据目录。

```bash
sudo mkdir -p /www/wwwroot/samwaf/{conf,data,logs,ssl}
cd /www/wwwroot/samwaf
```

| 宿主机目录 | 容器路径 | 作用 |
|-----------|---------|------|
| `conf/` | `/app/conf` | 配置文件 |
| `data/` | `/app/data` | 数据库、初始密码、OWASP 规则等 |
| `logs/` | `/app/logs` | 运行与攻击日志 |
| `ssl/` | `/app/ssl` | SSL 证书文件 |

### 5.1 试用模式（80/443 已占用时）— 本文实测

不停止现有 Nginx，用非标准端口验证 WAF：

```bash
docker run -d \
  --name samwaf \
  --restart unless-stopped \
  -p 26666:26666 \
  -p 8088:80 \
  -p 8443:443 \
  -v /www/wwwroot/samwaf/conf:/app/conf \
  -v /www/wwwroot/samwaf/data:/app/data \
  -v /www/wwwroot/samwaf/logs:/app/logs \
  -v /www/wwwroot/samwaf/ssl:/app/ssl \
  docker.xuanyuan.run/samwaf/samwaf:v1.3.21
```

| 映射 | 访问方式 |
|------|----------|
| `26666:26666` | 管理后台 `http://<IP>:26666` |
| `8088:80` | WAF HTTP 入口 `http://<IP>:8088` |
| `8443:443` | WAF HTTPS 入口 `https://<IP>:8443` |

成功时返回容器 ID，例如：

```text
3a4c6ac8e34ff1a8f62392354b105f93da679346e4bb79066747cda8bd450b5f
```

### 5.2 标准模式（80/443 空闲时）

```bash
docker run -d \
  --name samwaf \
  --restart unless-stopped \
  -p 26666:26666 \
  -p 80:80 \
  -p 443:443 \
  -v /www/wwwroot/samwaf/conf:/app/conf \
  -v /www/wwwroot/samwaf/data:/app/data \
  -v /www/wwwroot/samwaf/logs:/app/logs \
  -v /www/wwwroot/samwaf/ssl:/app/ssl \
  docker.xuanyuan.run/samwaf/samwaf:v1.3.21
```

### 5.3 验证启动

```bash
docker ps
docker logs -f samwaf
curl -I http://127.0.0.1:26666
```

`docker ps` 中状态为 **Up** 且端口映射正确即表示运行中。**Ubuntu 24.04 实测**：

```text
CONTAINER ID   IMAGE                                       COMMAND             CREATED          STATUS          PORTS
3a4c6ac8e34f   docker.xuanyuan.run/samwaf/samwaf:v1.3.21   "./SamWafLinux64"   19 seconds ago   Up 18 seconds   0.0.0.0:26666->26666/tcp, 0.0.0.0:8088->80/tcp, 0.0.0.0:8443->443/tcp   samwaf
```

`curl -I` 应返回 `HTTP/1.1 200 OK`。

**日志关键行**（首次启动正常标志，节选）：

```text
==========================================
  SamWaf Web Application Firewall v1.3.21
  Version Name: 20260708
==========================================

2026-07-12 21:22:37.257 WARN    找不到配置文件..
2026-07-12 21:22:38.534 INFO    OwaspManager ["Coraza WAF reloaded successfully"]
2026-07-12 21:22:38.892 INFO    首次安装已生成随机管理员初始口令，请查看文件: data/initial_password.txt 并在登录后立即修改
2026-07-12 21:22:38.986 INFO    WebManager ["启动 HTTP 管理端, port:",26666]
2026-07-12 21:22:38.996 INFO    SamWaf has started successfully.You can open http://127.0.0.1:26666 in your Browser
```

> **日志说明**：首次启动提示「找不到配置文件」会自动生成默认配置，属正常现象。大量 `record not found` 为系统配置项初始化查询，随后会写入默认值。`plugins.yml` 缺失时会使用默认插件配置。

---

## 六、首次登录与修改密码

### 6.1 获取初始密码

SamWaf **不会**使用固定默认密码。首次安装会生成随机口令并写入数据卷：

```bash
cat /www/wwwroot/samwaf/data/initial_password.txt
```

文件格式类似：

```text
SamWaf 初始管理员账号: admin
初始随机口令: <随机字符串>
生成时间: 2026-07-12 21:22:38
请立即登录并修改密码，登录后本文件可删除。
```

> **安全提示**：请勿将 `initial_password.txt` 内容提交到公开仓库或截图外发。登录成功后建议删除该文件。

### 6.2 打开管理后台

浏览器访问：

```text
http://你的服务器IP:26666
```

默认账号：**admin**，密码填入上一步读取的随机口令。

![SamWaf 登录页：输入 admin 与初始随机口令](https://img.xuanyuan.dev/docker/blog/samwaf-1.png)

### 6.3 首次登录强制改密

使用初始口令登录后，会弹出 **修改密码** 对话框，提示「首次登录或密码已被重置，请立即修改密码」。设置新密码并确认后点击 **确认**。

![SamWaf 首次登录：强制修改管理员密码](https://img.xuanyuan.dev/docker/blog/samwaf-2.png)

建议随后在个人设置中开启 **OTP 双因素认证**，并限制管理端口 `26666` 的访问来源（防火墙 / 安全组 / 反代 + HTTPS）。

---

## 七、管理后台导览

登录成功后进入 **概览仪表盘**。首次安装会提示尚未添加受保护网站，今日攻击数、访问量、QPS 等均为 0；顶部可查看 CPU、内存、磁盘占用及数据库类型（默认 SQLite）。

![SamWaf 概览仪表盘：首次安装欢迎提示与零数据状态](https://img.xuanyuan.dev/docker/blog/samwaf-3.png)

左侧菜单主要模块：

| 模块 | 用途 |
|------|------|
| 仪表盘 | 攻击统计、流量对比图 |
| 网站防护 | 添加站点、防御规则、CC、证书 |
| 数据分析 | 访问来源地图、统计报表 |
| 防护日志 | 访问日志、攻击日志查询 |
| 隧道防护 | TCP/UDP 四层隧道（实验特性） |
| 通知管理 | 钉钉、飞书、邮件等告警渠道 |
| 系统设置 | 全局策略、升级、备份 |

左下角显示版本 **20260708(v1.3.21)**，与实测镜像标签一致。

---

## 八、添加受保护站点

要让 WAF 真正拦截流量，需在 **网站防护** 中添加站点并配置反向代理后端。

### 8.1 新建防护站点

进入 **网站防护 → 新建防护**，在 **基础内容** 选项卡填写：

| 字段 | 说明 | 示例 |
|------|------|------|
| 网站 | 对外域名或测试域名 | `notes.example.com` |
| 加密证书 | HTTP 或 HTTPS | 试用可先用「非加密」 |
| 主端口 | WAF 监听端口（容器内 80 对应宿主机 8088） | `80` |
| 后端 IP | 真实应用地址 | `127.0.0.1` |
| 后端端口 | 后端服务端口 | `8080`（如 Trilium） |
| 启动状态 | 建议「自动启动」 | 自动启动 |

下图以演示环境填写为例；生产环境请将后端指向你的实际应用（如 `http://127.0.0.1:8080` 的 Trilium）。

![SamWaf 新建防护站点：基础内容与反向代理后端配置](https://img.xuanyuan.dev/docker/blog/samwaf-4.png)

保存后可在列表中看到站点记录。首次安装还会自动创建 **全局网站** 占位项，可按需配置或忽略。

![SamWaf 网站防护列表：全局网站与新建站点记录](https://img.xuanyuan.dev/docker/blog/samwaf-5.png)

### 8.2 试用模式下的访问路径

```text
用户 → http://<IP>:8088 → SamWaf 检测/拦截 → http://127.0.0.1:8080（后端）
```

若后端尚未部署（如实测时 `docker ps` 为空），需先启动 Trilium 等应用，再在 SamWaf 中配置反代。Trilium 部署可参考 [Trilium Docker 部署教程](./trilium-docker-deploy.md)。

### 8.3 防护功能建议

站点创建后，可逐步开启：

- **防御规则**：SQL 注入、XSS、扫描器识别
- **CC 防护**：限制单 IP 请求频率
- **IP 黑白名单**、**地区封禁**
- **仅记录模式**：先观察日志再开启拦截，便于调优

---

## 九、日志、分析与扩展功能

### 9.1 访问日志

**防护日志 → 访问日志** 可按网站、来源 IP、响应码、日期筛选请求记录。新部署无流量时显示「暂无数据」，有访问后此处可审计正常流量。

![SamWaf 访问日志：按条件筛选 Web 请求记录](https://img.xuanyuan.dev/docker/blog/samwaf-6.png)

### 9.2 数据分析

**数据分析** 提供周期攻击对比、世界地图来源分布等可视化。选好日期范围后点击 **查询** 查看统计。

![SamWaf 数据分析：攻击与正常流量世界地图分布](https://img.xuanyuan.dev/docker/blog/samwaf-7.png)

### 9.3 隧道防护（可选）

**隧道防护 → 隧道管理** 支持 TCP/UDP 四层转发（实验特性），可用于保护远程数据库、Redis 等。点击 **新建隧道** 按向导配置。

![SamWaf 隧道管理：TCP/UDP 四层隧道配置页](https://img.xuanyuan.dev/docker/blog/samwaf-8.png)

### 9.4 通知渠道（可选）

**通知管理 → 通知渠道** 可接入钉钉、飞书、邮件、Webhook 等，在遭受攻击或系统异常时推送告警。

![SamWaf 通知渠道：钉钉飞书邮件等告警接入](https://img.xuanyuan.dev/docker/blog/samwaf-9.png)

---

## 十、生产推荐：Docker Compose

适合长期运行、便于版本管理与 `git` 托管部署文件。

在 `/www/wwwroot/samwaf` 创建 `docker-compose.yml`（镜像改用轩辕加速域；端口按你的环境选择试用或标准映射）：

```yaml
services:
  samwaf:
    image: docker.xuanyuan.run/samwaf/samwaf:v1.3.21
    container_name: samwaf
    restart: unless-stopped
    ports:
      - "26666:26666"
      - "8088:80"    # 试用模式；标准模式改为 "80:80"
      - "8443:443"   # 试用模式；标准模式改为 "443:443"
    volumes:
      - ./conf:/app/conf
      - ./data:/app/data
      - ./logs:/app/logs
      - ./ssl:/app/ssl
```

```bash
docker compose up -d
docker compose ps
docker compose logs -f samwaf
```

升级时先备份 `data/` 目录：

```bash
docker compose pull
docker compose up -d
```

---

## 十一、让 SamWaf 接管生产流量（进阶）

试用验证无误后，若希望 SamWaf 替代 Nginx 成为 **80/443 唯一入口**：

1. **备份** 现有 Nginx 站点配置与证书
2. **停止** Nginx：`sudo systemctl stop nginx`（或面板中停用）
3. **删除** 试用容器，用 **5.2 标准模式** 重新 `docker run`（映射 80/443）
4. 在 SamWaf 后台为每个原站点配置反代后端（端口、域名、证书）
5. 将原 Nginx `proxy_pass` 逻辑迁移到 SamWaf「网站防护」

此操作会影响服务器上**所有现有网站**，请在维护窗口进行，并先在「仅记录模式」下观察规则误拦情况。

---

## 十二、常见问题 FAQ

**Q1：`port is already allocated` 怎么办？**

说明 80/443 或 26666 已被占用。执行第四节 `ss` 命令确认进程，改用试用模式端口（`8088/8443`）或停止冲突服务后再映射标准端口。

**Q2：忘记管理员密码？**

```bash
docker exec -it samwaf ./SamWafLinux64 resetpwd
```

按提示重置后重新登录并改密。

**Q3：数据存在哪里？**

宿主机 `/www/wwwroot/samwaf/` 下四个子目录。`data/` 含加密 SQLite 与配置；**删除 `data/` 会丢失全部 WAF 规则与日志**。

**Q4：管理端口 26666 要不要对公网开放？**

不建议长期裸奔。可映射为 `-p 127.0.0.1:26666:26666` 仅本机访问，或通过 VPN / SSH 隧道 / 反代 + 认证访问。日志会提示「管理端未配置 IP 白名单，默认允许所有 IP 访问」，可在后台配置白名单。

**Q5：如何升级版本？**

```bash
docker pull docker.xuanyuan.run/samwaf/samwaf:v1.3.21   # 或新版本标签
docker stop samwaf && docker rm samwaf
# 用相同 -v 参数重新 docker run（data 卷保留配置）
```

也可在管理后台使用 **在线一键升级**（升级会短暂中断服务，建议闲时操作）。

**Q6：试用模式下用户怎么访问受保护站点？**

需使用 **8088**（HTTP）或 **8443**（HTTPS），而非默认 80/443。生产接管后改为标准端口即可。

**Q7：SamWaf 与 Trilium 是什么关系？**

二者独立容器、独立目录：SamWaf 是 **前置 WAF/反代**，Trilium 是 **后端应用**。典型链路：`用户 → SamWaf:8088 → Trilium:8080`。

---

## 十三、命令速查

```bash
# 拉取镜像
docker pull docker.xuanyuan.run/samwaf/samwaf:v1.3.21

# 检查端口
sudo ss -tlnp | grep -E ':80 |:443 |:26666 '

# 创建目录
sudo mkdir -p /www/wwwroot/samwaf/{conf,data,logs,ssl}
cd /www/wwwroot/samwaf

# 启动（试用模式，Nginx 已占 80/443）
docker run -d --name samwaf --restart unless-stopped \
  -p 26666:26666 -p 8088:80 -p 8443:443 \
  -v /www/wwwroot/samwaf/conf:/app/conf \
  -v /www/wwwroot/samwaf/data:/app/data \
  -v /www/wwwroot/samwaf/logs:/app/logs \
  -v /www/wwwroot/samwaf/ssl:/app/ssl \
  docker.xuanyuan.run/samwaf/samwaf:v1.3.21

# 查看状态与日志
docker ps
docker logs -f samwaf
curl -I http://127.0.0.1:26666

# 读取初始密码
cat /www/wwwroot/samwaf/data/initial_password.txt

# 重置密码
docker exec -it samwaf ./SamWafLinux64 resetpwd
```

---

## 十四、延伸阅读

- [轩辕镜像 · samwaf/samwaf 镜像页](https://xuanyuan.cloud/r/samwaf/samwaf)
- [SamWaf 在线文档](https://doc.samwaf.com/)
- [SamWaf GitHub 仓库](https://github.com/samwafgo/SamWaf)
- [Docker Hub · samwaf/samwaf](https://hub.docker.com/r/samwaf/samwaf)
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)
- [Trilium Docker 部署教程](./trilium-docker-deploy.md)（可作为 SamWaf 后端站点示例）

---

*本文基于 SamWaf v1.3.21 与 Ubuntu 24.04 实测整理；界面与版本迭代后字段可能略有变化，以 [官方文档](https://doc.samwaf.com/) 为准。*


