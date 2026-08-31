# Docker Compose 部署雷池 SafeLine WAF：浏览器即可完成网站安全管理

![Docker Compose 部署雷池 SafeLine WAF：浏览器即可完成网站安全管理](https://imgs.xuanyuan.cloud/docker/blog/safeline.png)

*分类: Docker部署教程 | 标签: SafeLine,雷池,WAF,Docker,Docker Compose,轩辕镜像,网站防火墙,私有化部署,部署教程 | 发布时间: 2026-07-17 02:20:44*

> 零基础教程：雷池 SafeLine 社区版 9.3.10 中文版 Docker Compose 部署，轩辕镜像加速拉取 7 组件、.env 配置、resetadmin 登录与个人版付费功能说明。与 SamWaf 对比，Ubuntu 24.04 实测含 12 张截图。

*本文基于 [chaitin/safeline-mgt:9.3.10](https://xuanyuan.cloud/r/chaitin/safeline-mgt) 等雷池社区版组件镜像，Ubuntu 24.04 实测（管理台 **HTTPS:9443**，流量入口占用宿主机 **80/443**）*

网站日志里全是扫描器、SQL 注入探测，云 WAF 按量又贵？**雷池 SafeLine** 是长亭科技开源的 **Web 应用防火墙（WAF）**，以反向代理方式前置到站点前，用语义分析引擎拦截恶意流量。社区「个人版」可免费私有化部署，但不少高级能力标成**增值服务**，需升级授权——实测界面里「升级授权」「请升级到专业版后再配置」会反复出现。

本文用 [轩辕镜像](https://xuanyuan.cloud) 加速，按官方手动安装思路：下载 `compose.yaml`、编写 `.env`、`docker compose pull && up -d`，拿到管理员口令后登录中文控制台并添加防护应用。全程 Ubuntu 24.04 实测，附 **13 张截图**，并与此前 [SamWaf Docker 部署教程](../samwaf_samwaf/samwaf-docker-deploy.md) 做简要对比。

官方文档：[雷池帮助文档 · 手动安装](https://help.waf-ce.chaitin.cn/node/01973fc6-e12f-789f-a8ff-e81d383c80bc)、[GitHub chaitin/SafeLine](https://github.com/chaitin/SafeLine)。

> **部署要点**：雷池的 `tengine` 使用 **host 网络**，会直接占用宿主机 **80/443**，不像 SamWaf 可轻松改成 `8088/8443` 试用。部署前务必确认 80/443 空闲，或维护窗口停掉现有 Nginx。管理台必须用 **`https://`**，不能写 `http://`。

---

## 一、雷池是什么？和 SamWaf 怎么选？

**雷池（SafeLine）** 是长亭科技推出的下一代 WAF，社区个人版可免费下载部署。典型能力包括语义分析检测、反向代理接入、攻击事件与日志、CC 频率限制、人机验证、黑白名单等。产品定位偏「专业安全产品 + 免费个人版试用/自用」，界面成熟，但**个人版禁止商业规模使用**，且大屏、加强情报、部分防护配置等会提示升级专业版/商业版。

此前写过 [SamWaf](https://xuanyuan.cloud/blog/docker-samwaf-waf)：开源、单容器、SQLite、功能相对完整且无强推付费功能。选型可参考：

| 对比项 | 雷池 SafeLine（本文） | SamWaf |
|--------|----------------------|--------|
| 部署形态 | **7 个容器** Compose 栈 | **单容器** `docker run` 即可 |
| 流量入口 | `tengine` **host 网络**，占宿主机 **80/443** | 可映射 `80/443` 或试用 **`8088/8443`** |
| 管理台 | **HTTPS `9443`** | HTTP **`26666`** |
| 数据 | PostgreSQL 独立容器 | 默认加密 SQLite |
| 授权模式 | 个人版免费，**多项增值/专业版付费** | 开源自用 |
| 适合谁 | 认准长亭品牌、能接受个人版限制、可腾出 80/443 | 轻量自建、端口被占用时想先试用、偏完全开源 |

架构示意：

```text
用户/攻击流量 ──HTTP:80 / HTTPS:443──▶ safeline-tengine（host 网络）
tengine ──检测──▶ safeline-detector / fvm 等
tengine ──反代──▶ 后端站点（如 127.0.0.1:8080）
管理员 ──HTTPS:9443──▶ safeline-mgt
mgt / luigi / chaos ──▶ safeline-pg（PostgreSQL）
```

七个组件（中文版镜像名**无 `-g` 后缀**）：

| 容器名 | 作用 | 轩辕加速坐标 |
|--------|------|--------------|
| `safeline-pg` | PostgreSQL | `docker.xuanyuan.run/chaitin/safeline-postgres:15.2` |
| `safeline-mgt` | 管理控制台 | `docker.xuanyuan.run/chaitin/safeline-mgt:9.3.10` |
| `safeline-detector` | 检测引擎 | `docker.xuanyuan.run/chaitin/safeline-detector:9.3.10` |
| `safeline-tengine` | 反代入口 | `docker.xuanyuan.run/chaitin/safeline-tengine:9.3.10` |
| `safeline-luigi` | 日志/任务 | `docker.xuanyuan.run/chaitin/safeline-luigi:9.3.10` |
| `safeline-fvm` | 规则引擎 | `docker.xuanyuan.run/chaitin/safeline-fvm:9.3.10` |
| `safeline-chaos` | 人机验证等 | `docker.xuanyuan.run/chaitin/safeline-chaos:9.3.10` |

> **中英文版**：`.env` 里 `REGION=` **留空** = 中文版（镜像无 `-g`）；`REGION=-g` = 国际英文版（镜像名带 `-g`，如 `safeline-mgt-g`）。控制台**没有**语言切换开关，装错只能改 `REGION` 后重新 `pull` + `up -d`。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 操作系统 | Linux x86_64（需 SSSE3；本文 Ubuntu 24.04） |
| Docker | ≥ 20.10.14，Compose V2（`docker compose`） |
| 内存 | ≥ 1 GB（推荐 2 GB 以上） |
| 磁盘 | ≥ 5 GB（多镜像 + 日志 + PG） |
| 端口 | **80、443**（tengine，必须空闲）；**9443**（管理台，可改 `MGT_PORT`） |
| 工作目录 | `/data/safeline`（与官方一致） |

验证 Docker：

```bash
docker --version
docker compose version
```

若尚未安装，可用轩辕一键脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```


备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```
更多说明见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、检查端口占用（部署前必做）

```bash
sudo ss -tlnp | grep -E ':80 |:443 |:9443 '
docker ps --format 'table {{.Names}}\t{{.Ports}}'
```

| 情况 | 做法 |
|------|------|
| 80/443 **空闲** | 可继续本文标准部署 |
| 80/443 **被 Nginx/宝塔占用** | 先停现有入口，或换机；**不能**像 SamWaf 那样简单改映射端口试用 |
| 9443 被占用 | 改 `.env` 中 `MGT_PORT` |

---

## 四、准备目录与 compose.yaml

```bash
sudo mkdir -p /data/safeline
cd /data/safeline
wget "https://waf-ce.chaitin.cn/release/latest/compose.yaml"
```

**Ubuntu 24.04 实测**输出节选：

```text
--2026-07-17 01:38:22--  https://waf-ce.chaitin.cn/release/latest/compose.yaml
HTTP request sent, awaiting response... 200 OK
Length: 4590 (4.5K)
Saving to: ‘compose.yaml’
compose.yaml saved [4590/4590]
```

官方 `compose.yaml` **不写死镜像名**，而是用变量拼接，例如：

```text
${IMAGE_PREFIX}/safeline-mgt${REGION}${ARCH_SUFFIX}${RELEASE}:${IMAGE_TAG}
```

因此**不用改 compose 文件**，只要在同目录写好 `.env`，就会从轩辕域拉取。

---

## 五、编写 .env（中文版 + 轩辕镜像）

```bash
cat > /data/safeline/.env <<'EOF'
SAFELINE_DIR=/data/safeline
IMAGE_TAG=9.3.10
MGT_PORT=9443
POSTGRES_PASSWORD=请换成字母数字强密码
SUBNET_PREFIX=172.22.222
IMAGE_PREFIX=docker.xuanyuan.run/chaitin
ARCH_SUFFIX=
RELEASE=
REGION=
MGT_PROXY=0
EOF
```

| 变量 | 说明 |
|------|------|
| `IMAGE_PREFIX` | 轩辕加速前缀，拼出 `docker.xuanyuan.run/chaitin/safeline-…` |
| `IMAGE_TAG` | 业务组件版本，本文固定 **9.3.10** |
| `REGION` | **留空 = 中文版**；写 `-g` = 英文国际版 |
| `POSTGRES_PASSWORD` | PG 初始化密码，建议字母数字，避免特殊字符 |
| `MGT_PORT` | 管理台宿主机端口，默认 9443 |
| `SUBNET_PREFIX` | 内部网段前缀，冲突时可改（如 `172.30.100`） |

启动前确认解析结果（应**没有** `-g`）：

```bash
cd /data/safeline
docker compose config | grep image
```

**中文版实测**应类似：

```text
image: docker.xuanyuan.run/chaitin/safeline-chaos:9.3.10
image: docker.xuanyuan.run/chaitin/safeline-detector:9.3.10
image: docker.xuanyuan.run/chaitin/safeline-fvm:9.3.10
image: docker.xuanyuan.run/chaitin/safeline-luigi:9.3.10
image: docker.xuanyuan.run/chaitin/safeline-mgt:9.3.10
image: docker.xuanyuan.run/chaitin/safeline-postgres:15.2
image: docker.xuanyuan.run/chaitin/safeline-tengine:9.3.10
```

| 官方坐标（Docker Hub） | 轩辕加速 |
|------------------------|----------|
| `chaitin/safeline-mgt:9.3.10` | `docker.xuanyuan.run/chaitin/safeline-mgt:9.3.10` |
| `chaitin/safeline-postgres:15.2` | `docker.xuanyuan.run/chaitin/safeline-postgres:15.2` |
| （其余组件同理） | `docker.xuanyuan.run/chaitin/safeline-<名>:标签` |

---

## 六、拉取镜像并启动

有了正确 `.env`，**不必手敲 7 条 `docker pull`**，一条命令拉齐：

```bash
cd /data/safeline
docker compose pull
docker compose up -d
```

**Ubuntu 24.04 实测**：`compose pull` 约 1～2 分钟拉完 7 个服务；若偶发 TLS timeout，再执行一次 `docker compose pull` 即可。`up -d` 成功时类似：

```text
✔ Network safeline-ce          Created
✔ Container safeline-pg        Started
✔ Container safeline-chaos     Started
✔ Container safeline-tengine   Started
✔ Container safeline-fvm       Started
✔ Container safeline-detector  Started
✔ Container safeline-mgt       Started
✔ Container safeline-luigi     Started
```

可选：先单独预拉数据库（标签固定 15.2）：

```bash
docker pull docker.xuanyuan.run/chaitin/safeline-postgres:15.2
```

实测 Digest 示例：

```text
Digest: sha256:4434eed0bfecb39db77c47e0b026242d97ce453df3b70254c381fe0bcb83497d
Status: Downloaded newer image for docker.xuanyuan.run/chaitin/safeline-postgres:15.2
```

---

## 七、验证启动与日志判读

```bash
docker compose ps
docker compose logs -f mgt
curl -k -I https://127.0.0.1:9443
```

首次启动时，`mgt` 可能短暂打印：

```text
panic: failed to init pg db: ... connect: connection refused
connect() failed (111: Connection refused) while connecting to upstream
```

属 PostgreSQL / 内部 API 尚未就绪时的重试。出现下面这行后即可：

```text
🚀 MGT server ready
```

`curl` 成功标志（本文实测）：

```text
HTTP/2 200
server: nginx
content-type: text/html
```

---

## 八、获取管理员密码并登录

雷池**没有**像 SamWaf 那样的 `initial_password.txt`。首次用 `resetadmin` 生成口令：

```bash
docker exec safeline-mgt resetadmin
```

实测输出格式：

```text
[INFO] Initial username：admin
[INFO] Initial password：poOWDNFp
[INFO] Done
```

> 每次执行 `resetadmin` 都会生成新口令；请以你终端实际输出为准，登录后尽快修改。勿把口令提交到公开仓库。

浏览器访问（**必须 https**）：

```text
https://你的服务器IP:9443
```

自签证书会有不安全提示，点高级 → 继续访问。若写成 `http://` 会出现 `ERR_CONNECTION_REFUSED`。局域网打不开时，先确认本机 `curl -k -I https://127.0.0.1:9443` 正常，再查 `ss -tlnp | grep 9443` 与 `ufw`。

首次进入会看到软件许可协议，点击同意后进入登录页：

![雷池 SafeLine 软件许可协议：同意并开始使用](https://imgs.xuanyuan.cloud/docker/blog/safeline-1.png)

使用 `admin` 与上一步口令登录：

![雷池登录页：用户名 admin 与密码登录](https://imgs.xuanyuan.cloud/docker/blog/safeline-2.png)

---

## 九、中文控制台导览与个人版限制

登录后进入**统计报表**。左下角版本 **9.3.10** 与本文镜像标签一致。顶栏常驻 **升级授权**，中央水印有「个人版禁止商业用途使用」一类提示——这是个人版产品策略，不是部署失败。

![雷池中文版统计报表：流量分析与 0 数据空状态，版本 9.3.10](https://imgs.xuanyuan.cloud/docker/blog/safeline-4.png)

左侧主要模块：

| 模块 | 用途 |
|------|------|
| 统计报表 | 流量分析、安全态势、防护报告；防护大屏等可能锁付费 |
| 防护应用 | 添加受保护站点与反代后端 |
| 攻击防护 | 攻击事件 / 攻击日志 |
| 黑白名单 | IP 等检测事件与自定义规则 |
| CC 防护 | 频率限制、等候室 |
| 人机验证 | 区分真人与自动化程序 |
| 身份认证 | 访问应用前二次认证 |
| 通用设置 | IP 组、指纹库、证书等 |

攻击防护（新部署暂无数据属正常）：

![雷池攻击防护：攻击事件列表暂无数据](https://imgs.xuanyuan.cloud/docker/blog/safeline-5.png)

黑白名单：

![雷池黑白名单：检测事件与自定义规则](https://imgs.xuanyuan.cloud/docker/blog/safeline-6.png)

CC 防护 · 频率限制：

![雷池 CC 防护频率限制：限流说明与拦截列表](https://imgs.xuanyuan.cloud/docker/blog/safeline-7.png)

CC 防护 · 等候室：

![雷池等候室：高峰排队能力说明页](https://imgs.xuanyuan.cloud/docker/blog/safeline-8.png)

人机验证：

![雷池人机验证：防自动化攻击说明与配置入口](https://imgs.xuanyuan.cloud/docker/blog/safeline-9.png)

身份认证：

![雷池身份认证：访问应用前认证配置页](https://imgs.xuanyuan.cloud/docker/blog/safeline-10.png)

### 个人版付费墙（实测）

通用设置中，部分配置会直接提示升级：

![雷池通用设置：提示请升级到专业版后再配置，含 IP 组与证书管理](https://imgs.xuanyuan.cloud/docker/blog/safeline-11.png)

统计报表里打开「防护大屏」配置时，会提示升级到商业版：

![雷池防护大屏配置弹窗：请升级到商业版后再配置](https://imgs.xuanyuan.cloud/docker/blog/safeline-20.png)

**结论**：个人版适合学习、个人站点与功能体验；若依赖大屏、加强情报、部分专业防护配置，需评估商业授权。若你更在意「开源、无付费墙、单容器」，可优先看 [SamWaf 教程](../samwaf_samwaf/samwaf-docker-deploy.md)。

> 若误装了国际英文版，界面类似下图；把 `.env` 的 `REGION=-g` 改为 `REGION=` 后 `docker compose pull && docker compose up -d`，再强制刷新即可切中文。

![雷池国际英文版统计页（REGION=-g）对照](https://imgs.xuanyuan.cloud/docker/blog/safeline-3.png)

---

## 十、添加防护站点（让 WAF 生效）

进入 **防护应用 → 添加应用**，弹窗中主要字段：

| 字段 | 说明 | 示例 |
|------|------|------|
| 域名 | 对外访问域名，支持通配符 | `www.example.com` |
| 端口 | 雷池监听端口，可加多个（HTTP/HTTPS 各一） | `80`（HTTP）、`443`（HTTPS） |
| 证书 | HTTPS 端口需选证书（先在通用设置添加） | — |
| 接入方式 | 代理到已有应用 / 使用静态文件搭建 / 重定向 | 选「代理到已有应用」 |
| 上游服务器 | 真实后端地址，**不支持路径** | `http://192.168.1.10:8080` |
| 应用名称 | 便于列表识别 | 自定义 |

![雷池添加应用弹窗：域名、80/443 监听端口、代理到已有应用与上游服务器配置](https://imgs.xuanyuan.cloud/docker/blog/safeline-12.png)

保存后流量路径：

```text
用户 → https://你的域名:443 → safeline-tengine → http://192.168.1.10:8080（后端）
```

建议先观察 / 仅记录，确认误拦后再全量拦截。证书可在「通用设置 → 证书管理」添加（部分能力受个人版限制，以界面提示为准）。

---

## 十一、升级与备份

升级前备份 `/data/safeline/resources/`（尤其 `postgres/data`、`mgt`、`nginx`）。

```bash
cd /data/safeline
# 修改 .env 中 IMAGE_TAG=新版本
docker compose pull
docker compose up -d
```

---

## 十二、常见问题 FAQ

**Q1：`compose.yaml` 里看不到镜像名，能用吗？**

能。镜像由 `.env` 变量拼接；用 `docker compose config | grep image` 核对即可。

**Q2：为什么不用手敲 7 条 `docker pull`？**

`.env` 正确时，`docker compose pull` 会一次拉齐全部组件（含 `postgres:15.2`）。单条 `docker pull` 仅用于排错。

**Q3：管理台 `http://IP:9443` 打不开？**

必须使用 **`https://`**。本机 `curl -k -I https://127.0.0.1:9443` 若已是 200，再查防火墙是否放行 9443。

**Q4：忘记管理员密码？**

```bash
docker exec safeline-mgt resetadmin
```

**Q5：界面是英文怎么改中文？**

`.env` 设 `REGION=`（留空），确认 `compose config` 中镜像无 `-g`，再 `pull` + `up -d`。控制台内无语言开关。

**Q6：个人版很多按钮要升级授权？**

正常现象。个人版免费但限制商业规模使用，防护大屏、加强情报等为增值能力。与完全开源的 SamWaf 定位不同。

**Q7：和现有 Nginx 同机怎么部署？**

雷池 tengine 占 host 的 80/443，需停 Nginx 或换机；没有 SamWaf 那种试用端口方案。

**Q8：`compose pull` 出现 TLS handshake timeout？**

网络抖动时再执行一次即可；本文实测中文版二次 pull 后成功。

---

## 十三、命令速查

```bash
# 目录与编排
sudo mkdir -p /data/safeline && cd /data/safeline
wget "https://waf-ce.chaitin.cn/release/latest/compose.yaml"

# .env：IMAGE_PREFIX=docker.xuanyuan.run/chaitin，REGION= 留空，IMAGE_TAG=9.3.10
# （见第五节完整内容）

docker compose config | grep image
docker compose pull
docker compose up -d

docker compose ps
curl -k -I https://127.0.0.1:9443
docker exec safeline-mgt resetadmin

# 日志
docker compose logs -f mgt
```

---

## 十四、延伸阅读

- [轩辕镜像 · chaitin/safeline-mgt](https://xuanyuan.cloud/r/chaitin/safeline-mgt)
- [雷池帮助文档 · 手动安装](https://help.waf-ce.chaitin.cn/node/01973fc6-e12f-789f-a8ff-e81d383c80bc)
- [SafeLine GitHub](https://github.com/chaitin/SafeLine)
- [SamWaf Docker 部署教程](../samwaf_samwaf/samwaf-docker-deploy.md)（轻量开源对照）
- [轩辕镜像使用手册](https://xuanyuan.cloud/usage)

---

*本文基于雷池社区版 9.3.10 中文版与 Ubuntu 24.04 实测整理；个人版功能与授权策略以官方最新说明为准。*

