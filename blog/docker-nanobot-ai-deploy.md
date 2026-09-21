# Docker 部署 nanobot 完整教程：搭建超轻量个人 AI 助手

![Docker 部署 nanobot 完整教程：搭建超轻量个人 AI 助手](https://imgs.xuanyuan.cloud/docker/blog/nanobot.webp)

*分类: Docker部署教程 | 标签: nanobot,smanx/nanobot, Docker,轩辕镜像,AI 助手,个人代理,自托管,私有化部署,部署教程 | 发布时间: 2026-09-20 03:49:53*

> nanobot 是开源超轻量个人 AI 助手，可在 WebUI、终端或聊天通道中调用工具、记忆与 MCP。本文将介绍如何通过 Docker Compose 部署社区镜像 smanx/nanobot，用轩辕镜像加速拉取，适合自托管个人代理、内网助手与轻量实验等场景。

*本文基于 [smanx/nanobot:0.3.5](https://xuanyuan.cloud/zh/r/smanx/nanobot)，实测引擎 **nanobot 0.3.5**，测试平台 **Ubuntu 24.04** Linux。*

想在服务器上留一个常驻助手：有人本机装 Python，依赖一升就炸；有人把会话丢到云端对话产品，密钥、备忘、脚本路径一并出域。想在 Telegram / 飞书里接一个能读文件、跑命令、记长期记忆的 bot，又被一堆配套服务劝退——配置散在各处，模型路由改了哪一层都不清楚。

放到第三方托管 Agent，还要过合规与费用关：内网文档和机房脚本本来就不该默认上传。很多机房或 NAS 上已经有一台跑 Docker 的 Ubuntu，缺的是：**镜像能拉、配置落本机、网关常驻，浏览器打开就能配模型、接通道**。

**nanobot**（[GitHub · HKUDS/nanobot](https://github.com/HKUDS/nanobot)、[PyPI · nanobot-ai](https://pypi.org/project/nanobot-ai/)）是开源个人 AI 助手运行时，核心代理代码量级约数千行，支持 WebUI、终端、多聊天通道、工具调用、长期记忆、MCP 与 OpenAI 兼容 API。本文跟做社区镜像 **`smanx/nanobot`**（[镜像页](https://xuanyuan.cloud/r/smanx/nanobot)）：健康检查 **18790**，WebUI / WebSocket **8765**，配置目录在容器内 **`/root/.nanobot`**（须挂到宿主机）。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 初始化 | `nanobot onboard` 生成 `config.json` 与 workspace |
| 常驻网关 | Compose 起 Gateway；未配模型也可先起来 |
| 配模型 / 对话 | 浏览器登录 WebUI → 设置 → **模型** |
| 接通道 | Channels 里启飞书 / Telegram 等 |
| 备份 | 停容器后打包宿主机 `./data` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`smanx/nanobot:0.3.5`**，**Docker Compose** 启动。把下文 IP、模型与 API 换成你的。无 Compose 见第七节。文内附 **13** 张实测截图。

> **上手要点**
> - **主路径**：第四节 Compose；备选 `docker run` 见第七节
> - **标签**：跟做 **`0.3.5`**；勿写 `latest`
> - **挂载**：`./data` → **`/root/.nanobot`**（勿挂 `/home/nanobot/.nanobot`）
> - **端口**：宿主机 **8765** → 容器 **8765**；健康检查 **`127.0.0.1:18790`→`18790`**，路径 **`/health`**
> - **局域网访问**：先把 Gateway / WebSocket 的 `host` 改为 **`0.0.0.0`**，并设置 **`tokenIssueSecret`**（即 WebUI 密码），再 `up -d`
> - **体积**：DISK **899MB** / CONTENT **265MB**
> - **启动标志**：`Starting nanobot gateway version 0.3.5`、`Health endpoint: …/health`
> - **目录**：Linux `/www/wwwroot/nanobot`；macOS `~/docker/nanobot`

官方：[部署文档](https://github.com/HKUDS/nanobot/blob/main/docs/deployment.md) · [镜像页](https://xuanyuan.cloud/r/smanx/nanobot) · [标签列表](https://xuanyuan.cloud/r/smanx/nanobot/tags) · [Docker Hub](https://hub.docker.com/r/smanx/nanobot) · [GitHub](https://github.com/HKUDS/nanobot)

---

## 一、smanx/nanobot 是什么？

`smanx/nanobot` 把 nanobot 打成可拉取镜像：配置与会话在 **`/root/.nanobot`**，Gateway 常驻后提供健康检查与 WebUI / WebSocket，并可按配置接聊天通道。相对云端对话产品或体量很大的 Agent 平台，它更适合想把状态留在自己机器上的个人与小团队场景。

| | smanx/nanobot（本文） | 本机 pip / uv 装 nanobot-ai | 云端对话 / 托管 Bot |
|--|----------------------|----------------------------|---------------------|
| 形态 | 社区 Docker 镜像 | Python 包 + 本机进程 | SaaS |
| 状态 | 挂载 → `/root/.nanobot` | 默认 `~/.nanobot` | 云端会话 |
| 适合 | 服务器 / NAS 常驻 | 开发机试用 | 不愿运维时 |

```text
WebUI / CLI / 聊天 App ──▶  nanobot Gateway（0.3.5）
                              ├── /root/.nanobot  ← ./data
                              ├── :18790/health
                              └── :8765（WebUI / WebSocket）
```

Hub 上还有其他命名空间的同名镜像；**本文只跟做 `smanx/nanobot:0.3.5`**。[`/r/`](https://xuanyuan.cloud/r/smanx/nanobot) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/smanx/nanobot) 为同一镜像的不同语言路径。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；也可 Docker Desktop |
| Docker | Engine + **Compose V2** |
| 架构 | **amd64** / **arm64**（`0.3.5` 均有） |
| 内存 | 可用 ≥ **1 GB** |
| 磁盘 | 镜像约 **899MB**，另加会话与媒体空间 |
| 端口 | **8765/tcp**；**18790/tcp**（建议只绑本机） |
| 工作目录 | `/www/wwwroot/nanobot` |
| 模型 | 需自行配置 Provider（未配置时 Gateway 仍可启动） |

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

| 标签 | 说明 | 是否跟做 |
|------|------|----------|
| **`0.3.5`** | 当前较新的具体版本（amd64 / arm64） | **推荐** |
| `0.3.0` | 同属 0.3 线的较早标签 | 可回退 |
| `0.2.x` / `0.1.x` | 旧线 | 仅兼容旧配置 |
| `latest` | 浮动标签 | **勿写入跟做命令** |

完整列表见 [标签页](https://xuanyuan.cloud/r/smanx/nanobot/tags)。升级时改 Compose 标签，并对照 [上游 Releases](https://github.com/HKUDS/nanobot/releases)。

### 3.2 用轩辕镜像加速拉取

```bash
docker pull docker.xuanyuan.run/smanx/nanobot:0.3.5
```

Ubuntu 24.04 实测：

```text
0.3.5: Pulling from smanx/nanobot
923e32d1a218: Pull complete
6b37362b3da7: Pull complete
cca21d59a46c: Pull complete
41e7217c2e50: Pull complete
58abdd9670ca: Pull complete
890e462c029b: Pull complete
0526d5e29bf3: Pull complete
94cca41a2931: Pull complete
bcd4b1ad816e: Pull complete
a400e9529b2a: Pull complete
44136fa355b3: Download complete
a8239fb94629: Download complete
Digest: sha256:1151e981528841e05e55a6962af135cb85438abf03fdfbfbebfcca7dc9df9aa0
Status: Downloaded newer image for docker.xuanyuan.run/smanx/nanobot:0.3.5
docker.xuanyuan.run/smanx/nanobot:0.3.5
```

```bash
docker images docker.xuanyuan.run/smanx/nanobot:0.3.5
```

```text
IMAGE                                     ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/smanx/nanobot:0.3.5   1151e9815288        899MB          265MB
```

---

## 四、Docker Compose 部署（主路径）

推荐顺序：**建目录 → onboard → 改 config（绑定 + 密码）→ 写 Compose → up → 浏览器登录 → 设置模型**。

### 4.1 准备目录

```bash
sudo mkdir -p /www/wwwroot/nanobot/data
cd /www/wwwroot/nanobot
```

macOS 可用 `~/docker/nanobot`。本镜像以 root 写 **`/root/.nanobot`**，一般不必 `chown 1000`。

### 4.2 首次 onboard

**卷目标必须是 `/root/.nanobot`。** 若误挂 `/home/nanobot/.nanobot`，日志仍可能出现 `Created config at /root/.nanobot/...`，但宿主机 `./data` 是空的，你在宿主机改的配置也不会生效。

```bash
docker run --rm \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot onboard
```

成功时宿主机应有 `data/config.json`、`data/workspace` 等：

```text
✓ Created config at /root/.nanobot/config.json
  Created AGENTS.md
  Created SOUL.md
  Created HEARTBEAT.md
  Created USER.md
  Created memory/MEMORY.md
  Created prompts/README.md
  Created memory/history.jsonl

✓ nanobot is ready. Run: nanobot webui
… | Git store initialized at /root/.nanobot/workspace
```

配置已存在时再跑会问 `Overwrite? [y/N]`：跟做跳过即可。需要交互向导时再：

```bash
docker run --rm -it \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot onboard --wizard
```

也可在 Compose 里用环境变量覆盖常见项：

| 环境变量 | 含义 |
|----------|------|
| `NANOBOT_DEFAULT_MODEL` | 默认模型名 |
| `OPENAI_API_BASE` | OpenAI 兼容 API Base URL |
| `OPENAI_API_KEY` | API 密钥 |

### 4.3 改 config：局域网访问与 WebUI 密码

默认 Gateway / WebSocket 听容器内 **`127.0.0.1`**。此时 Docker `-p` 进不去环回：宿主机 `curl` 健康口可能 `Connection reset by peer`，局域网浏览器也打不开 WebUI。

在 **`up -d` 之前** 编辑挂载后的配置：

```bash
vim /www/wwwroot/nanobot/data/config.json
```

至少保证 WebSocket（及需要时的 Gateway）类似下面（口令换成你自己的强随机串）：

```json
{
  "gateway": { "host": "0.0.0.0" },
  "channels": {
    "websocket": {
      "host": "0.0.0.0",
      "port": 8765,
      "tokenIssueSecret": "请换成足够长的随机串"
    }
  }
}
```

说明：

- **`tokenIssueSecret`** 就是 WebUI 登录页要填的密码，**没有出厂默认值**
- Compose 里健康检查仍建议映射为 **`127.0.0.1:18790:18790`**（只本机可达）
- 字段细节见上游 [Configuration](https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md)、[WebUI](https://github.com/HKUDS/nanobot/blob/main/docs/webui.md)

### 4.4 写入 compose.yaml

```bash
cd /www/wwwroot/nanobot
cat > compose.yaml <<'EOF'
services:
  nanobot:
    image: docker.xuanyuan.run/smanx/nanobot:0.3.5
    container_name: nanobot
    restart: unless-stopped
    ports:
      - "127.0.0.1:18790:18790"
      - "8765:8765"
    volumes:
      - ./data:/root/.nanobot
    environment:
      TZ: Asia/Shanghai
      # NANOBOT_DEFAULT_MODEL: "你的模型名"
      # OPENAI_API_BASE: "https://api.openai.com/v1"
      # OPENAI_API_KEY: "sk-..."
EOF
```

| 项 | 作用 |
|----|------|
| `"8765:8765"` | WebUI / WebSocket |
| `"127.0.0.1:18790:18790"` | 健康检查仅本机 |
| `./data:/root/.nanobot` | 配置与会话持久化 |

### 4.5 启动与健康检查

```bash
docker compose up -d
docker compose ps
docker compose logs --tail 80
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network nanobot_default Created
 ✔ Container nanobot       Started

NAME      IMAGE                                     COMMAND                  SERVICE   CREATED         STATUS         PORTS
nanobot   docker.xuanyuan.run/smanx/nanobot:0.3.5   "/usr/local/bin/entr…"   nanobot   …               Up …           0.0.0.0:8765->8765/tcp, [::]:8765->8765/tcp, 127.0.0.1:18790->18790/tcp
```

日志关键行（未配模型时 Gateway 仍会起来）：

```text
🐈 Starting nanobot gateway version 0.3.5 on port 18790...
… Registered 23 tools: […]
✓ Channels enabled: websocket
✓ Health endpoint: http://127.0.0.1:18790/health
… WebSocket server listening on ws://…
Provider/model setup is incomplete: No provider is configured for model ''.
Gateway will start so you can configure a provider and model in WebUI Settings → Models.
```

探活用 **`/health`**（不要打根路径 `/`）：

```bash
curl -sS http://127.0.0.1:18790/health
```

```text
{"status": "ok", "process": "alive", "ready": true, "websocket": "running"}
```

若仍绑环回导致宿主机 curl 失败，可临时：

```bash
docker exec nanobot curl -sS http://127.0.0.1:18790/health
```

### 4.6 浏览器登录

打开 `http://服务器IP:8765`：

![nanobot WebUI 登录页 Connect to nanobot 与密码输入框](https://imgs.xuanyuan.cloud/docker/blog/nanobot-1.webp)

密码框填 **4.3 里设置的 `tokenIssueSecret`**。可用下面命令核对：

```bash
grep -nE 'tokenIssueSecret|"token"' /www/wwwroot/nanobot/data/config.json
```

登录后进入工作台：

![nanobot WebUI 首页 Where should we start 对话输入区与侧栏](https://imgs.xuanyuan.cloud/docker/blog/nanobot-2.webp)

**未设 `tokenIssueSecret` 时不要把 8765 暴露到公网。**

---

## 五、配模型与界面导览

### 5.1 设置模型（必做）

点侧栏齿轮进入设置。**概览** 里当前模型在未配置时为 **Not configured**：

![nanobot 设置概览 Token 用量与 Current model Not configured](https://imgs.xuanyuan.cloud/docker/blog/nanobot-9.webp)

打开 **模型**：新建模型预设、添加自定义提供商，填各家 **API Key**（这是模型密钥，不是 WebUI 登录口令）：

![nanobot 设置模型页 新建模型预设与添加自定义提供商](https://imgs.xuanyuan.cloud/docker/blog/nanobot-8.webp)

配好后，可用 CLI 确认（共用同一 `./data`）：

```bash
docker run --rm \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot status

docker run --rm \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot agent -m "Hello!"
```

未配 Provider 时 `status` / `agent` 会报 `No provider is configured for model ''`，属预期。

### 5.2 侧栏功能一览

**Apps**：可挂载的工具与 MCP 相关入口：

![nanobot Apps 工具库列表与 MCP 状态 Ready](https://imgs.xuanyuan.cloud/docker/blog/nanobot-3.webp)

**Skills → Installed**：内置技能（cron、memory、image-generation 等；标 Needs setup 的还需再配）：

![nanobot Skills 已安装内置技能列表](https://imgs.xuanyuan.cloud/docker/blog/nanobot-4.webp)

**Skills → Discover**：从 skills.sh / SkillHub 等发现更多技能：

![nanobot Skills Discover 技能市场 skills.sh 与 SkillHub](https://imgs.xuanyuan.cloud/docker/blog/nanobot-5.webp)

**Automations**：任务与日历，适合定时提醒与例行工作：

![nanobot Automations 日历视图 2026年9月](https://imgs.xuanyuan.cloud/docker/blog/nanobot-6.webp)

**Channels**：WebUI 与飞书、钉钉、Telegram、Discord 等通道开关；依赖安装与 Token 见 [Chat Apps](https://github.com/HKUDS/nanobot/blob/main/docs/chat-apps.md)：

![nanobot Channels 通道列表 WebUI 已启用](https://imgs.xuanyuan.cloud/docker/blog/nanobot-7.webp)

### 5.3 外观、功能、系统、高级

**外观**：主题、语言（可改简体中文）、浏览器偏好：

![nanobot 设置外观 深色主题与简体中文](https://imgs.xuanyuan.cloud/docker/blog/nanobot-10.webp)

**功能**：图片生成、语音转写、网页访问、记忆整理等：

![nanobot 设置功能 图片生成语音网页记忆开关](https://imgs.xuanyuan.cloud/docker/blog/nanobot-11.webp)

**系统**：时区、内置工具权限、可选 OpenAI 兼容 API（默认 **8900**）。实测可见网关 **`0.0.0.0:18790`**、配置路径 **`/root/.nanobot/config.json`**：

![nanobot 设置系统 网关地址与配置文件路径 root.nanobot](https://imgs.xuanyuan.cloud/docker/blog/nanobot-12.webp)

**高级**：WebUI 安全、轮次限制、Shell 沙箱、网关监听地址等：

![nanobot 设置高级 网关监听 0.0.0.0 端口 18790](https://imgs.xuanyuan.cloud/docker/blog/nanobot-13.webp)

生产建议：密钥权限收紧；18790 保持本机映射；8765 必须有 `tokenIssueSecret`；系统页「修改自身配置」宜保持关闭；工具执行按最小权限开启。

---

## 六、升级与备份

| 项 | 做法 |
|----|------|
| 备份 | 停服务后打包 `/www/wwwroot/nanobot/data` |
| 升级 | 改 `image` 标签 → `docker compose pull` → `docker compose up -d` |
| 回归 | 看日志，再跑 `nanobot status` / `agent -m` |

跨大版本前先读上游 changelog。

---

## 七、备选：docker run

```bash
docker run --rm \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot onboard
```

按 4.3 改好 `config.json` 后：

```bash
docker run -d \
  --name nanobot \
  --restart unless-stopped \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  -p 127.0.0.1:18790:18790 \
  -p 8765:8765 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/smanx/nanobot:0.3.5
```

长期运行仍推荐第四节 Compose。

---

## 八、常见问题

**Q：该用哪个版本？**  
A：跟做 **`0.3.5`**，不要写 `latest`。

**Q：为什么必须挂 `/root/.nanobot`？**  
A：本镜像实测配置写在 **`/root/.nanobot`**。挂 `/home/nanobot/.nanobot` 时进程仍写容器内 `/root/...`，宿主机目录不会持久化。上游自建 Dockerfile 文档里的 `/home/nanobot/.nanobot` 适用于官方镜像，与本社区镜像不同。

**Q：宿主机改了 `config.json` 不生效？**  
A：先 `ls data/` 确认 onboard 后确有文件，再核对 Compose 是否挂到 `/root/.nanobot`，然后 `docker compose restart`。

**Q：映射了端口，curl 仍 Connection reset？**  
A：多半还在听 `127.0.0.1`。按 4.3 改为 `0.0.0.0` 并重启；探活用 **`/health`**。

**Q：WebUI 密码是什么？**  
A：没有默认密码，填 `channels.websocket.tokenIssueSecret`（或你设的静态 `token`）。

**Q：`agent -m` 报 No provider is configured？**  
A：先到设置 → **模型** 配好 Provider，或跑 `nanobot onboard --wizard`。

**Q：再次 onboard 出现 Overwrite? / Aborted？**  
A：配置已存在。非交互环境直接跳过；需要向导时加 `-it` 跑 `--wizard`。

**Q：健康检查口能对公网开吗？**  
A：不建议。跟做用 `127.0.0.1:18790:18790`。

**Q：和官方自建镜像有何区别？**  
A：上游更推荐用仓库 Dockerfile 自建（非 root、路径多为 `/home/nanobot/.nanobot`）。`smanx/nanobot` 便于在轩辕镜像拉取试用；生产请自行评估镜像来源。

---

## 九、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/smanx/nanobot:0.3.5

# 目录与初始化
sudo mkdir -p /www/wwwroot/nanobot/data
cd /www/wwwroot/nanobot
docker run --rm \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot onboard
# 然后按 4.3 编辑 data/config.json

# Compose
docker compose up -d
docker compose ps
docker compose logs -f nanobot
docker compose down

# 健康检查
curl -sS http://127.0.0.1:18790/health

# 配好模型后探活
docker run --rm \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot status

docker run --rm \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  docker.xuanyuan.run/smanx/nanobot:0.3.5 \
  nanobot agent -m "Hello!"

# 备选 run
docker run -d --name nanobot --restart unless-stopped \
  -v /www/wwwroot/nanobot/data:/root/.nanobot \
  -p 127.0.0.1:18790:18790 -p 8765:8765 \
  docker.xuanyuan.run/smanx/nanobot:0.3.5
```

验证：`/health` · WebUI `:8765` · 标签 `0.3.5`

---

## 十、延伸阅读

| 资源 | 链接 |
|------|------|
| [smanx/nanobot 镜像页](https://xuanyuan.cloud/zh/r/smanx/nanobot) | [https://xuanyuan.cloud/zh/r/smanx/nanobot](https://xuanyuan.cloud/zh/r/smanx/nanobot) |
| [镜像标签列表](https://xuanyuan.cloud/r/smanx/nanobot/tags) | [https://xuanyuan.cloud/r/smanx/nanobot/tags](https://xuanyuan.cloud/r/smanx/nanobot/tags) |
| [Docker Hub · smanx/nanobot](https://hub.docker.com/r/smanx/nanobot) | [https://hub.docker.com/r/smanx/nanobot](https://hub.docker.com/r/smanx/nanobot) |
| [GitHub · HKUDS/nanobot](https://github.com/HKUDS/nanobot) | [https://github.com/HKUDS/nanobot](https://github.com/HKUDS/nanobot) |
| [上游 Deployment](https://github.com/HKUDS/nanobot/blob/main/docs/deployment.md) | [https://github.com/HKUDS/nanobot/blob/main/docs/deployment.md](https://github.com/HKUDS/nanobot/blob/main/docs/deployment.md) |
| [Configuration](https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md) | [https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md](https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md) |
| [Chat Apps](https://github.com/HKUDS/nanobot/blob/main/docs/chat-apps.md) | [https://github.com/HKUDS/nanobot/blob/main/docs/chat-apps.md](https://github.com/HKUDS/nanobot/blob/main/docs/chat-apps.md) |
| [PyPI · nanobot-ai](https://pypi.org/project/nanobot-ai/) | [https://pypi.org/project/nanobot-ai/](https://pypi.org/project/nanobot-ai/) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 跟做 **`smanx/nanobot:0.3.5`**，挂载 **`./data`→`/root/.nanobot`**，映射 **8765** 与本机 **18790**。
- **先 onboard，再改 `0.0.0.0` + `tokenIssueSecret`，再 Compose up**；登录后到设置 → **模型** 配 Provider。
- 健康检查用 **`/health`**；未配模型时 Gateway 可起，`agent -m` 会失败属正常。
- 8765 勿裸暴露公网；18790 建议仅本机。

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-nanobot-ai-deploy


