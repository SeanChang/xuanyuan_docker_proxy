# Docker 部署 OpenClaw：轻松搭建自托管个人 AI 助手

![Docker 部署 OpenClaw：轻松搭建自托管个人 AI 助手](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw.webp)

*分类: Docker部署教程 | 标签: OpenClaw,openclaw/openclaw,Docker,轩辕镜像,AI 助手,Gateway,私有化部署,部署教程 | 发布时间: 2026-10-15 00:34:16*

> OpenClaw 是一款面向个人和内网使用者的开源自托管 AI 助手 Gateway，旨在把聊天渠道、模型供应商和浏览器控制台接到同一个 Gateway，并通过本机目录保存会话与配置。本文将介绍如何通过 Docker Compose 部署 OpenClaw，搭建自托管个人 AI 助手平台，帮助你在自己的服务器上接入模型并打开控制台，适合个人助手及内网自托管等场景。

*本文基于 [openclaw/openclaw:2026.10.3](https://xuanyuan.cloud/r/openclaw/openclaw)，以 **2026.10.3** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## OpenClaw 是什么

OpenClaw 是 OpenClaw Foundation 维护的开源 AI 助手 Gateway。它跑在你自己的机器上，把 Discord、Telegram、Slack、WhatsApp 等聊天应用接到一个 AI 代理，在这些聊天工具里调用助手。

和把对话放在托管网站上不同，会话、路由和渠道连接都留在这台机器的 Gateway 里。模型密钥和配置也在本机。浏览器里的 Control UI 和命令行连的是同一个 Gateway。

## OpenClaw 能做什么

- **接入聊天渠道**：把 Discord、Telegram、Slack、WhatsApp 接到同一个 Gateway。
- **浏览器控制台**：在 Control UI 里查看智能体、会话和这台机器的状态。
- **选择模型供应商**：为智能体配置模型，密钥保存在本机目录。
- **记忆与技能**：在本机工作区保留记忆，并按当前系统启用可用技能。
- **定时与自动化**：用 cron、hooks 和 webhooks 安排周期任务。

## 为什么要使用 OpenClaw

助手如果放在别人的网站上，会话和模型密钥不在自己手里，助手也读不到这台机器上的文件。

OpenClaw 把 Gateway 放在自己的服务器上，聊天渠道和浏览器控制台都连回这里。适合要从 Telegram、Discord 一类渠道呼叫助手的人，也适合把模型和会话留在内网的小团队。

## 使用 Docker 部署 OpenClaw

OpenClaw 可以用 Docker 跑起来，宿主机不必先安装 Node.js。部署前准备好 Docker，以及准备使用的模型供应商密钥。

下面用 Docker Compose 配置运行参数，完成启动，并在浏览器里验证 Control UI。

## 环境要求

本文使用 **`openclaw/openclaw:2026.10.3`** 版本实测。这是 2026-10-13 发布的稳定版。预发布标签不要写入命令，见「标签怎么选」。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）；macOS 把 `/www/wwwroot/openclaw` 换成 `~/docker/openclaw`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| CPU / 内存 | 官方对**本地编译**镜像写了至少 6 GB 内存。本文使用预构建镜像，不在本机编译。运行时占用取决于模型和是否启用容器内浏览器 |
| 架构 | Docker Hub 标签页上，`2026.10.3` 包含 linux/amd64 与 linux/arm64 |
| 磁盘 | Docker Hub 标签页列出的压缩大小：linux/amd64 约 1.15 GB，linux/arm64 约 1.18 GB。Ubuntu 24.04 上 `docker images` 显示这块镜像磁盘占用 5.01 GB，内容大小 1.25 GB。配置、会话和日志另计 |
| 端口 | 宿主机 **18789** → 容器 **18789**（Control UI 与 Gateway）。宿主机 **18790** → 容器 **18790**（官方 Compose 一并发布；Canvas / MCP Apps 沙箱） |
| 工作目录 | `/www/wwwroot/openclaw` |
| 数据目录 | `config/` → `/home/node/.openclaw`；`workspace/` → `/home/node/.openclaw/workspace`；`auth-secrets/` → `/home/node/.config/openclaw` |
| 运行用户 | 镜像内用户 `node`，uid **1000** |
| 模型 | 自行准备供应商 API Key，或宿主机上的 Ollama / LM Studio |
| 其他 | 生成 Gateway 令牌需要 `openssl` |

镜像基于 Node 24。宿主机不用再装 Node.js。

只在本机打开时用 `http://127.0.0.1:18789/`。给别人用、或放到公网时，在前面加 HTTPS，并收紧来源允许列表，见「常见问题」。

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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

[Docker 安装说明](https://docs.openclaw.ai/install/docker)写明：预构建镜像先发到 GHCR，同一版本再发布到 Docker Hub 的 `openclaw/openclaw`。稳定版会移动 `latest` 和 `main`。`extended-stable` 只跟随更早一批 Gateway 稳定版。带版本号的标签，例如 `2026.10.3`，不会再改指向。

本文使用 Docker Hub 仓库 **`openclaw/openclaw`** 的 **`2026.10.3`**。不要改成其他命名空间下的同名镜像。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`2026.10.3`** | 2026-10-13 稳定版。Docker Hub 有 linux/amd64、linux/arm64 | **是** |
| `2026.10.3-browser` | 同一版本，镜像内带 Chromium。只有要用 Gateway 控制的浏览器时再换 | 备选，见常见问题 |
| `latest` / `main` | 会随新的稳定版变化 | 否 |
| `extended-stable` | 跟随更早一批稳定版，不是当前这一版 | 否 |
| `*-slim` / `latest-browser` / `main-browser` | 精简变体，或会移动的浏览器变体 | 否 |
| `2026.10.5-beta.3` 等 beta | 预发布 | 否 |

默认镜像已经带上 `codex` 和 `diagnostics-otel` 插件。`-browser` 额外带有 Chromium，供 Control UI 里由 Gateway 控制的浏览器使用。你自己打开控制台的那个浏览器不依赖这个变体。

完整标签见[标签列表](https://xuanyuan.cloud/r/openclaw/openclaw/tags)。升级时改具体版本，见「常见问题」。发布说明见 [v2026.10.3](https://docs.openclaw.ai/releases/2026.10.3)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/openclaw/openclaw:2026.10.3
```

Ubuntu 24.04 上拉取结束时：

```text
Digest: sha256:70b8dbd23f8d27a206f43f9828fdebc87289e50d56dc55177354c9270d764026
Status: Downloaded newer image for docker.xuanyuan.run/openclaw/openclaw:2026.10.3
docker.xuanyuan.run/openclaw/openclaw:2026.10.3
```

同一台机器上，`docker images` 里这一条是：

```text
IMAGE                                             ID             DISK USAGE   CONTENT SIZE
docker.xuanyuan.run/openclaw/openclaw:2026.10.3   70b8dbd23f8d       5.01GB         1.25GB
```

## Docker Compose 部署

[官方 Compose](https://github.com/openclaw/openclaw/blob/v2026.10.3/docker-compose.yml)把配置目录挂到 `/home/node/.openclaw`，工作区挂到 `/home/node/.openclaw/workspace`，旧版认证密钥目录挂到 `/home/node/.config/openclaw`。Gateway 端口是 18789，绑定模式用 `lan`，这样宿主机上的浏览器才能通过端口映射访问。容器内路径要固定成上面这些值。若把宿主机的 `/Users/...` 或 `/www/...` 写进容器环境变量，Linux 容器里会出现 `mkdir '/Users'` 一类的权限错误。

官方安装脚本会生成 Gateway 令牌，交互执行 `onboard`，再把 `gateway.mode`、`gateway.bind` 和 Control UI 来源写进配置。下面按同样的顺序做，工作目录放在 `/www/wwwroot/openclaw`。

令牌写在项目目录的 `.env`。`docker compose down` 不加额外参数时，不会删除 `config/`、`workspace/` 和 `auth-secrets/`。目录里已经有配置时，不要清空，也不要重新生成令牌。

当前 OAuth 令牌以明文放在 `config/` 里的 SQLite 中。`.env`、`config/` 和它们的备份都按密钥保管。

以前用 `docker run` 创建过名为 `openclaw-gateway` 的容器时，先删掉容器再启动 Compose。`docker rm` 不删除 `config/`、`workspace/` 和 `auth-secrets/`。没有这个容器就跳过下面这条。

```bash
docker rm -f openclaw-gateway
```

1. 创建目录。官方脚本还会预先建好 `identity` 和默认代理目录，避免第一次启动时在挂载点里新建子目录失败：

```bash
sudo mkdir -p /www/wwwroot/openclaw/config/identity
sudo mkdir -p /www/wwwroot/openclaw/config/agents/main/agent
sudo mkdir -p /www/wwwroot/openclaw/config/agents/main/sessions
sudo mkdir -p /www/wwwroot/openclaw/workspace
sudo mkdir -p /www/wwwroot/openclaw/auth-secrets
sudo chown -R 1000:1000 /www/wwwroot/openclaw/config /www/wwwroot/openclaw/workspace /www/wwwroot/openclaw/auth-secrets
```

镜像以 uid **1000**（用户 `node`）写入这些目录。宿主机 `chown` 之后，写好 `compose.yaml` 还要用容器内的 root 再改一次属主。只做宿主机 `chown` 就执行 `onboard`，会得到 `EACCES: permission denied, mkdir '/home/node/.openclaw/migration'`。

2. 写入 `.env`。已有 `.env` 时不要覆盖，否则正在使用的令牌会被换掉。

```bash
cd /www/wwwroot/openclaw
if [ -f .env ]; then
  echo "已有 .env，保持原令牌"
else
  umask 077
  printf 'OPENCLAW_GATEWAY_TOKEN=%s
OPENCLAW_TZ=Asia/Shanghai
' "$(openssl rand -hex 32)" > .env
  chmod 600 .env
fi
```

3. 写入 `compose.yaml`。宿主机 18789 对应容器 18789。容器内的 `OPENCLAW_GATEWAY_PORT` 保持 `18789`，不要改成宿主机端口。18790 与官方 Compose 一致，留给 Canvas / MCP Apps 沙箱。不用 Microsoft Teams 时不必发布 3978。

```bash
cd /www/wwwroot/openclaw
cat > compose.yaml <<'EOF'
name: openclaw

services:
  openclaw-gateway:
    image: docker.xuanyuan.run/openclaw/openclaw:2026.10.3
    env_file:
      - .env
    environment:
      HOME: /home/node
      OPENCLAW_HOME: /home/node
      TERM: xterm-256color
      OPENCLAW_STATE_DIR: /home/node/.openclaw
      OPENCLAW_CONFIG_PATH: /home/node/.openclaw/openclaw.json
      OPENCLAW_CONFIG_DIR: /home/node/.openclaw
      OPENCLAW_WORKSPACE_DIR: /home/node/.openclaw/workspace
      OPENCLAW_GATEWAY_PORT: "18789"
      TZ: ${OPENCLAW_TZ:-Asia/Shanghai}
    volumes:
      - ./config:/home/node/.openclaw
      - ./workspace:/home/node/.openclaw/workspace
      - ./auth-secrets:/home/node/.config/openclaw
    extra_hosts:
      - "host.docker.internal:host-gateway"
    cap_drop:
      - NET_RAW
      - NET_ADMIN
    security_opt:
      - no-new-privileges:true
    ports:
      - "18789:18789"
      - "18790:18790"
    init: true
    restart: unless-stopped
    command:
      [
        "node",
        "dist/index.js",
        "gateway",
        "--bind",
        "lan",
        "--port",
        "18789",
      ]
    healthcheck:
      test:
        [
          "CMD",
          "node",
          "dist/docker-healthcheck.js",
        ]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 20s

  openclaw-cli:
    image: docker.xuanyuan.run/openclaw/openclaw:2026.10.3
    network_mode: "service:openclaw-gateway"
    env_file:
      - .env
    environment:
      HOME: /home/node
      OPENCLAW_HOME: /home/node
      TERM: xterm-256color
      OPENCLAW_STATE_DIR: /home/node/.openclaw
      OPENCLAW_CONFIG_PATH: /home/node/.openclaw/openclaw.json
      OPENCLAW_CONFIG_DIR: /home/node/.openclaw
      OPENCLAW_WORKSPACE_DIR: /home/node/.openclaw/workspace
      OPENCLAW_GATEWAY_PORT: "18789"
      BROWSER: echo
      TZ: ${OPENCLAW_TZ:-Asia/Shanghai}
    volumes:
      - ./config:/home/node/.openclaw
      - ./workspace:/home/node/.openclaw/workspace
      - ./auth-secrets:/home/node/.config/openclaw
    cap_drop:
      - NET_RAW
      - NET_ADMIN
    security_opt:
      - no-new-privileges:true
    stdin_open: true
    tty: true
    init: true
    entrypoint: ["node", "dist/index.js"]
    depends_on:
      - openclaw-gateway
EOF
```

`openclaw-cli` 和 Gateway 共用网络命名空间，所以要等 Gateway 容器已经存在，才能用它执行渠道命令。初始化发生在 Gateway 启动之前，下一步改用 `openclaw-gateway` 和 `--no-deps`。

4. 检查 Compose 文件能否被解析。这条不把 `.env` 里的令牌打到终端：

```bash
cd /www/wwwroot/openclaw
docker compose config --quiet
```

报错时先改 `compose.yaml` 或 `.env`，再做初始化。不要把不带 `--quiet` 的 `docker compose config` 全文贴出去，展开结果里有 Gateway 令牌。

5. 在容器里把挂载目录交给 `node`。官方安装脚本用 root 做这一步，因为容器里看到的属主才是 `onboard` 使用的那一个。

```bash
cd /www/wwwroot/openclaw
docker compose run --rm --no-deps --user root --entrypoint sh openclaw-gateway -c 'chown -R node:node /home/node/.openclaw /home/node/.config'
docker compose run --rm --no-deps --entrypoint sh openclaw-gateway -c 'mkdir -p /home/node/.openclaw/migration && rmdir /home/node/.openclaw/migration && echo writable'
```

第二条以镜像默认用户 `node` 运行。终端出现 `writable` 后再做初始化。仍然是 `Permission denied` 时，不要继续 `onboard`，先看「常见问题」。

6. 在终端里做首次初始化。命令已经指定本地模式、令牌认证，并且不安装系统服务。向导会停住，按下面选择。还没有可用的模型密钥时，供应商选 **Skip for now**。OpenAI 的 **Codex login (device code)** 在这台 Ubuntu 上返回 HTTP 403，错误码是 `unsupported_country_region_territory`，不要反复选它。

```bash
cd /www/wwwroot/openclaw
docker compose run --rm --no-deps --entrypoint node openclaw-gateway 
  dist/index.js onboard 
  --mode local 
  --no-install-daemon 
  --gateway-auth token 
  --gateway-token-ref-env OPENCLAW_GATEWAY_TOKEN 
  --skip-ui 
  --suppress-gateway-token-output
```

`--gateway-token-ref-env` 让 Gateway 使用 `.env` 里的 `OPENCLAW_GATEWAY_TOKEN`。不要把 `.env` 删掉。向导摘要里的 **Gateway secret (generated)** 不要另抄一串。

这次向导的选择是：

1. 安全声明选 **Yes**。
2. 是否帮助改进选 **No thanks**。
3. **Setup mode** 选 **QuickStart (recommended)**。
4. 第一个代理的名字用 **main**。
5. **Model/auth provider** 选 **Skip for now**。接着 **Default model** 选 **Keep current**。
6. **Select channel** 选 **Skip for now**。
7. **Search provider** 选 **Skip for now**。
8. **Install missing skill dependencies** 选 **Skip for now**。

QuickStart 摘要里的 **Gateway bind** 是 **Loopback (127.0.0.1)**。不改的话，宿主机映射的 18789 连不进容器。下一步会把它改成 `lan`。

Ubuntu 24.04 上，初始化写完配置时：

```text
Updated config: $OPENCLAW_HOME/.openclaw/openclaw.json
Workspace OK: $OPENCLAW_HOME/.openclaw/workspace
Sessions OK: $OPENCLAW_HOME/.openclaw/agents/main/sessions
```

同一轮末尾还有这几行。Gateway 还没启动，所以都是这一步的正常结果。不要在这个已经退出的容器里执行向导提示的 `openclaw gateway run`。

```text
Systemd user services are not available inside this container.
Gateway not detected yet.
Gateway: not detected (connect ECONNREFUSED 127.0.0.1:18789)
Failed to generate completion cache.
```

技能状态这次是 Eligible 15、Missing requirements 31、Unsupported on this OS 5。官方镜像没有 Homebrew，Brew 依赖不会在这里安装。跳过即可。

7. 写入 Docker 下的 Gateway 默认项。来源允许列表先只放本机的 `localhost` 和 `127.0.0.1`。若页面提示 `origin not allowed`，再按「常见问题」追加来源。不要在改过允许列表之后重跑这一条，否则列表会被盖回只剩本机。

```bash
cd /www/wwwroot/openclaw
docker compose run --rm --no-deps --entrypoint node openclaw-gateway 
  dist/index.js config set --batch-json '[{"path":"gateway.mode","value":"local"},{"path":"gateway.bind","value":"lan"},{"path":"gateway.controlUi.allowedOrigins","value":["http://localhost:18789","http://127.0.0.1:18789"]}]'
```

Ubuntu 24.04 上成功时：

```text
Updated 3 config paths. Restart the gateway to apply.
```

等这行出现、提示符回到宿主机之后，再执行下一步。这一步只改配置，18789 这时还没有进程在听。`curl` 若报 `Couldn't connect to server`，先启动 Gateway。

8. 只启动 Gateway。不要省略服务名，否则 `openclaw-cli` 也会被拉起。

```bash
cd /www/wwwroot/openclaw
docker compose up -d openclaw-gateway
```

Ubuntu 24.04 上：

```text
[+] up 1/1
 ✔ Container openclaw-openclaw-gateway-1 Started
```

9. 查看状态。启动后大约 10 秒，健康检查仍是 `starting`，日志只有 doctor 的标题。入口会先跑 doctor，Gateway 还没开始监听。这时访问 18789 会得到 `curl: (56) Recv failure: Connection reset by peer`。先看状态和日志，等日志走过 doctor 再做两条 `curl`。

```bash
cd /www/wwwroot/openclaw
docker compose ps
docker compose logs --tail 80 openclaw-gateway
```

```bash
curl -fsS http://127.0.0.1:18789/healthz
curl -fsS http://127.0.0.1:18789/startupz
```

刚启动时的状态和日志是：

```text
NAME                          IMAGE                                             COMMAND                  SERVICE            CREATED          STATUS                            PORTS
openclaw-openclaw-gateway-1   docker.xuanyuan.run/openclaw/openclaw:2026.10.3   "tini -s -- node /ap…"   openclaw-gateway   10 seconds ago   Up 8 seconds (health: starting)   0.0.0.0:18789-18790->18789-18790/tcp, [::]:18789-18790->18789-18790/tcp
```

```text
openclaw-gateway-1  | ┌  OpenClaw doctor
```

`/healthz` 是存活检查，`/startupz` 是启动和流量接入检查，两者都不需要令牌。`/readyz` 会把渠道故障算成未就绪，不要用它判断控制台能不能打开。doctor 还在跑时先不要打开浏览器。这次等它过去之后，从局域网打开了令牌页。

## 浏览器打开 Control UI

在跑 Docker 的这台机器上打开：

```text
http://127.0.0.1:18789/
```

从别的电脑访问时，把地址换成 `http://这台机器的IP:18789/`。这次打开 `http://192.168.1.35:18789/chat`，页面标题是「此 Gateway 需要令牌」，Gateway URL 为 `ws://192.168.1.35:18789`。允许列表里当时只有 `localhost` 和 `127.0.0.1`，这一页仍然出现了。若你的页面提示 `origin not allowed`，再按「常见问题」追加来源，不要回头重跑上一条 `config set`，否则列表会被盖回只剩本机。云服务器还要在安全组里放行 **18789**。

![OpenClaw 令牌页：此 Gateway 需要令牌，Gateway URL 为 ws://192.168.1.35:18789](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-1.webp)

页面要求令牌时，在 Gateway 那台机器上查看，把等号后面的值填进 **Gateway 密钥**。不要把这一行贴到聊天或工单。本文使用令牌认证，没有预置用户名和密码。

```bash
grep '^OPENCLAW_GATEWAY_TOKEN=' /www/wwwroot/openclaw/.env
```

填对之后，页面标题变成「批准此浏览器」，提示 `device pairing required`，并给出 `requestId`。页面上写的是 `openclaw devices approve <requestId>`。在这台 Ubuntu 上直接执行会得到 `openclaw: command not found`。

![OpenClaw 批准此浏览器：devices approve 命令旁显示已复制](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-2.webp)

OpenClaw 在容器里。把 `<requestId>` 换成页面上的那一串。Gateway 已经 Up 时才能跑这条，因为 `openclaw-cli` 和 Gateway 共用网络。

```bash
cd /www/wwwroot/openclaw
docker compose run --rm openclaw-cli devices approve <requestId>
```

这次批准的结果是：

```text
[+] run 1/1
 ✔ Container openclaw-openclaw-gateway-1 Running
Approved 67f886e2c2035ea1a016b694e2d7d9372d0945c8008c091675d0201c9556ee72 (19194691-2782-4954-8574-11f4bc36d3c6)
```

`Approved` 后面括号里的是页面上的 `requestId`。页面上的「正在等待批准…」会自己连上。

Control UI 里还有一块由 Gateway 控制的浏览器，它不是你正在用来打开控制台的那个浏览器。默认镜像不含 Chromium。要使用那块面板时，见「常见问题」。

## 连上之后的控制台

批准之后进入智能体 `main`。初始化时跳过了供应商，输入框旁是「没有可用的模型」，这一页还不能对话。

![OpenClaw 首页：智能体 main，输入框显示没有可用的模型](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-3.webp)

智能体页列出 `main`，模型是 `openai/gpt-6-astra`，状态是近期无活动、暂无消息。

![OpenClaw 智能体：main 使用 openai/gpt-6-astra，暂无消息](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-4.webp)

仪表盘上的主机名是 `50ec0875240a`。负载 2.39，已用内存 1.7 GB，已用磁盘 74 GB，可用磁盘空间 74 GB。桌面服务器这一块提示先在 Linux 上配置 VNC。

![OpenClaw 仪表盘：主机 50ec0875240a，负载 2.39，已用内存 1.7 GB](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-5.webp)

自动化里已有三条。Heartbeat（main）每 30 分钟，Memory Dreaming Promotion 的 cron 是 `0 3 * * *`，Skill collection review（main）每 7 天。

![OpenClaw 自动化：Heartbeat、Memory Dreaming Promotion 与 Skill collection review](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-6.webp)

插件页是目录，卡片上是「安装」。

![OpenClaw 插件目录：精选与热门插件，卡片上是安装](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-7.webp)

设置里的模型页提示「需要连接提供商」。辅助模型是 `openai/gpt-5.6-luna`，备用模型是「无备用模型」。点「连接提供商」后，列表里有 Anthropic、Copilot、Google、Huggingface、LiteLLM。

![OpenClaw 设置模型：需要连接提供商，辅助模型为 openai/gpt-5.6-luna](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-8.webp)

![OpenClaw 连接提供商：Anthropic、Copilot、Google、Huggingface、LiteLLM](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-9.webp)

设置里的插件页打开的是「已安装」。列表里能看到 1Password、A2A、Active Memory、admin-HTTP-rpc、alibaba。

![OpenClaw 设置插件：已安装列表，含 1Password、A2A 与 alibaba](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-10.webp)

Skills 页筛选里，就绪是 15。内置技能包括 1password、apple-notes、blogwatcher。和初始化时的 Eligible 15 一致。

![OpenClaw 设置 Skills：就绪 15，列表含 1password 与 blogwatcher](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-11.webp)

MCP 页上，服务器、已启用、OAuth、已筛选都是 0，还没有 MCP 服务器。

![OpenClaw 设置 MCP：服务器、已启用、OAuth、已筛选均为 0](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-12.webp)

记忆页标题是「记忆已唤醒」，引擎是 memory-core。浅眠、REM、深眠三个阶段都是已启用。

![OpenClaw 设置记忆：记忆已唤醒，浅眠、REM、深眠均为已启用](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-13.webp)

自动化设置里，「允许 Bash 聊天命令」「允许 /config」「允许 /debug」「允许 /mcp」是关闭的。「允许 /restart」是开启的。

![OpenClaw 设置自动化：允许 Bash 聊天命令关闭，允许 /restart 开启](https://imgs.xuanyuan.cloud/docker/blog/openclaw/openclaw-14.webp)

## 接入聊天渠道（可选）

Gateway 已经是 Up 之后，才使用 `openclaw-cli`。把下面的令牌换成渠道后台发给你的值。

```bash
cd /www/wwwroot/openclaw
docker compose run --rm openclaw-cli channels login
```

```bash
cd /www/wwwroot/openclaw
docker compose run --rm openclaw-cli channels add --channel telegram --token "<token>"
```

```bash
cd /www/wwwroot/openclaw
docker compose run --rm openclaw-cli channels add --channel discord --token "<token>"
```

第一条是 WhatsApp 扫码。后两条分别接入 Telegram 和 Discord。渠道说明见 [Channels](https://docs.openclaw.ai/channels)。

## 备选：docker run

没有 Compose 时再用这一节。已经按「Docker Compose 部署」跑起来时，不要对同一份 `config/` 再执行这里的初始化。下面使用单独目录 `/www/wwwroot/openclaw-run`。

1. 创建目录并交给 uid 1000：

```bash
sudo mkdir -p /www/wwwroot/openclaw-run/config/identity
sudo mkdir -p /www/wwwroot/openclaw-run/config/agents/main/agent
sudo mkdir -p /www/wwwroot/openclaw-run/config/agents/main/sessions
sudo mkdir -p /www/wwwroot/openclaw-run/workspace
sudo mkdir -p /www/wwwroot/openclaw-run/auth-secrets
sudo chown -R 1000:1000 /www/wwwroot/openclaw-run/config /www/wwwroot/openclaw-run/workspace /www/wwwroot/openclaw-run/auth-secrets
```

2. 写入 `.env`。已有文件时不要覆盖：

```bash
cd /www/wwwroot/openclaw-run
if [ -f .env ]; then
  echo "已有 .env，保持原令牌"
else
  umask 077
  printf 'OPENCLAW_GATEWAY_TOKEN=%s
OPENCLAW_TZ=Asia/Shanghai
' "$(openssl rand -hex 32)" > .env
  chmod 600 .env
fi
```

3. 在容器里把挂载目录交给 `node`，并确认能建目录。没有 `writable` 时不要做下一步。

```bash
docker run --rm --user root --entrypoint sh 
  -v /www/wwwroot/openclaw-run/config:/home/node/.openclaw 
  -v /www/wwwroot/openclaw-run/workspace:/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/auth-secrets:/home/node/.config/openclaw 
  docker.xuanyuan.run/openclaw/openclaw:2026.10.3 
  -c 'chown -R node:node /home/node/.openclaw /home/node/.config'
docker run --rm --entrypoint sh 
  -v /www/wwwroot/openclaw-run/config:/home/node/.openclaw 
  -v /www/wwwroot/openclaw-run/workspace:/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/auth-secrets:/home/node/.config/openclaw 
  docker.xuanyuan.run/openclaw/openclaw:2026.10.3 
  -c 'mkdir -p /home/node/.openclaw/migration && rmdir /home/node/.openclaw/migration && echo writable'
```

4. 初始化。向导里的选择与「Docker Compose 部署」相同：供应商选 **Skip for now**，渠道、搜索和技能依赖都跳过。不要在宿主机上执行向导提示的 `openclaw gateway run`。

```bash
cd /www/wwwroot/openclaw-run
docker run --rm -it 
  --env-file /www/wwwroot/openclaw-run/.env 
  -e HOME=/home/node 
  -e OPENCLAW_HOME=/home/node 
  -e OPENCLAW_STATE_DIR=/home/node/.openclaw 
  -e OPENCLAW_CONFIG_PATH=/home/node/.openclaw/openclaw.json 
  -e OPENCLAW_CONFIG_DIR=/home/node/.openclaw 
  -e OPENCLAW_WORKSPACE_DIR=/home/node/.openclaw/workspace 
  -e OPENCLAW_GATEWAY_PORT=18789 
  -v /www/wwwroot/openclaw-run/config:/home/node/.openclaw 
  -v /www/wwwroot/openclaw-run/workspace:/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/auth-secrets:/home/node/.config/openclaw 
  --entrypoint node 
  docker.xuanyuan.run/openclaw/openclaw:2026.10.3 
  dist/index.js onboard 
  --mode local 
  --no-install-daemon 
  --gateway-auth token 
  --gateway-token-ref-env OPENCLAW_GATEWAY_TOKEN 
  --skip-ui 
  --suppress-gateway-token-output
```

5. 写入与 Compose 相同的 Gateway 默认项：

```bash
docker run --rm 
  --env-file /www/wwwroot/openclaw-run/.env 
  -e HOME=/home/node 
  -e OPENCLAW_HOME=/home/node 
  -e OPENCLAW_STATE_DIR=/home/node/.openclaw 
  -e OPENCLAW_CONFIG_PATH=/home/node/.openclaw/openclaw.json 
  -e OPENCLAW_CONFIG_DIR=/home/node/.openclaw 
  -e OPENCLAW_WORKSPACE_DIR=/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/config:/home/node/.openclaw 
  -v /www/wwwroot/openclaw-run/workspace:/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/auth-secrets:/home/node/.config/openclaw 
  --entrypoint node 
  docker.xuanyuan.run/openclaw/openclaw:2026.10.3 
  dist/index.js config set --batch-json '[{"path":"gateway.mode","value":"local"},{"path":"gateway.bind","value":"lan"},{"path":"gateway.controlUi.allowedOrigins","value":["http://localhost:18789","http://127.0.0.1:18789"]}]'
```

名为 `openclaw-gateway` 的容器还在时，先删掉再启动。没有这个容器就跳过。`docker rm` 不删除 `/www/wwwroot/openclaw-run`。

```bash
docker rm -f openclaw-gateway
```

6. 启动 Gateway：

```bash
docker run -d 
  --name openclaw-gateway 
  --restart unless-stopped 
  --init 
  --env-file /www/wwwroot/openclaw-run/.env 
  -e HOME=/home/node 
  -e OPENCLAW_HOME=/home/node 
  -e OPENCLAW_STATE_DIR=/home/node/.openclaw 
  -e OPENCLAW_CONFIG_PATH=/home/node/.openclaw/openclaw.json 
  -e OPENCLAW_CONFIG_DIR=/home/node/.openclaw 
  -e OPENCLAW_WORKSPACE_DIR=/home/node/.openclaw/workspace 
  -e OPENCLAW_GATEWAY_PORT=18789 
  -e TZ=Asia/Shanghai 
  -p 18789:18789 
  -p 18790:18790 
  -v /www/wwwroot/openclaw-run/config:/home/node/.openclaw 
  -v /www/wwwroot/openclaw-run/workspace:/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/auth-secrets:/home/node/.config/openclaw 
  --add-host=host.docker.internal:host-gateway 
  --cap-drop NET_RAW 
  --cap-drop NET_ADMIN 
  --security-opt no-new-privileges:true 
  docker.xuanyuan.run/openclaw/openclaw:2026.10.3 
  node dist/index.js gateway --bind lan --port 18789
```

7. 确认映射和存活检查：

```bash
docker ps --filter name=openclaw-gateway
docker logs --tail 80 openclaw-gateway
curl -fsS http://127.0.0.1:18789/healthz
curl -fsS http://127.0.0.1:18789/startupz
```

浏览器打开 `http://127.0.0.1:18789/`。令牌在 `/www/wwwroot/openclaw-run/.env`。

没有 Compose 时，渠道命令挂到正在运行的 Gateway 网络命名空间上，卷和环境变量与上面保持一致：

```bash
docker run --rm -it 
  --network container:openclaw-gateway 
  --env-file /www/wwwroot/openclaw-run/.env 
  -e HOME=/home/node 
  -e OPENCLAW_STATE_DIR=/home/node/.openclaw 
  -e OPENCLAW_CONFIG_PATH=/home/node/.openclaw/openclaw.json 
  -e OPENCLAW_CONFIG_DIR=/home/node/.openclaw 
  -e OPENCLAW_WORKSPACE_DIR=/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/config:/home/node/.openclaw 
  -v /www/wwwroot/openclaw-run/workspace:/home/node/.openclaw/workspace 
  -v /www/wwwroot/openclaw-run/auth-secrets:/home/node/.config/openclaw 
  --entrypoint node 
  docker.xuanyuan.run/openclaw/openclaw:2026.10.3 
  dist/index.js channels add --channel telegram --token "<token>"
```

## 常见问题

**Q1：有没有默认用户名和密码？**

没有。Control UI 使用 `.env` 里的 `OPENCLAW_GATEWAY_TOKEN`。不要把这个文件提交到仓库，也不要发到聊天里。

**Q2：为什么不用 `latest`？**

`latest` 和 `main` 会在后续稳定版发布后改指向。`2026.10.3` 固定在 2026-10-13 这一版。标签对照见「标签怎么选」。

**Q3：日志里是 `EACCES` 或 `openat2 beneath root: Permission denied`？**

镜像以用户 `node`（uid **1000**）写 `/home/node/.openclaw`。Ubuntu 24.04 上，宿主机已经 `chown 1000:1000` 之后，`onboard` 仍可能报：

```text
EACCES: permission denied, mkdir '/home/node/.openclaw/migration'
```

紧接着的 `config set` 会报 `openat2 beneath root: Permission denied (os error 13)`。这两条都是容器里的 `node` 写不了挂载目录。不要改成长期以 root 跑 Gateway。在 `compose.yaml` 已经写好的前提下，用官方安装脚本的做法，在容器里改属主，并确认 `node` 能建目录：

```bash
cd /www/wwwroot/openclaw
docker compose run --rm --no-deps --user root --entrypoint sh openclaw-gateway -c 'chown -R node:node /home/node/.openclaw /home/node/.config'
docker compose run --rm --no-deps --entrypoint sh openclaw-gateway -c 'mkdir -p /home/node/.openclaw/migration && rmdir /home/node/.openclaw/migration && echo writable'
```

出现 `writable` 之后，从「Docker Compose 部署」里的初始化重新做。不要清空已经写好的 `.env`。

若日志是 `blocked plugin candidate: suspicious ownership`，并且提示期望 root，仍保持 uid 1000，把挂载目录的属主改成 `node`。不要为了消掉这行日志而改成以 root 运行。

**Q4：页面提示 origin not allowed？**

允许列表里的来源必须和浏览器地址栏一致，包含 `http` 或 `https`、主机名和端口，末尾不要加 `/`。写入 Gateway 默认项时只放了 `http://localhost:18789` 和 `http://127.0.0.1:18789`。这次从 `http://192.168.1.35:18789/chat` 打开时没有出现这条提示。出现 `origin not allowed` 时再改列表。

这条命令会覆盖整个列表，所以要把仍然要使用的 `localhost` 和 `127.0.0.1` 一起写上。把 `192.168.1.35` 换成浏览器地址栏里的主机名。

```bash
cd /www/wwwroot/openclaw
docker compose run --rm --no-deps --entrypoint node openclaw-gateway 
  dist/index.js config set --batch-json '[{"path":"gateway.controlUi.allowedOrigins","value":["http://localhost:18789","http://127.0.0.1:18789","http://192.168.1.35:18789"]}]'
docker compose restart openclaw-gateway
```

**Q5：本机能开，别的电脑打不开？**

按这个顺序看：

1. `docker compose ps` 里 `openclaw-gateway` 是否为 Up。
2. 在服务器上打开 `http://127.0.0.1:18789/`。本机打不开时，再看 `docker compose logs --tail 80 openclaw-gateway`。
3. 本机通、别的电脑不通时，检查安全组是否放行了 18789，以及 Q4 的来源是否包含那台电脑使用的地址。

从局域网打开并填入令牌后，还会出现「批准此浏览器」。宿主机上执行页面给出的 `openclaw devices approve` 会得到 `openclaw: command not found`。批准命令见「浏览器打开 Control UI」。

**Q6：令牌不一致，CLI 报 unauthorized？**

`.env` 里的 `OPENCLAW_GATEWAY_TOKEN` 必须和初始化时使用的是同一个。覆盖过 `.env`，或初始化时没有带 `--gateway-token-ref-env`，两边就会不同。停掉容器，确认 `.env` 仍是当初那一串，再执行 `docker compose up -d openclaw-gateway`。不要为了排错去清空 `config/`。

**Q7：想改宿主机端口？**

只改映射冒号左边，容器内端口和 `OPENCLAW_GATEWAY_PORT` 仍是 18789。把 `"18789:18789"` 改成 `"18089:18789"` 时，浏览器打开 `http://127.0.0.1:18089/`。来源允许列表也要改成 `http://127.0.0.1:18089` 和 `http://localhost:18089`。宿主机端口不要用 3000。

改完执行：

```bash
cd /www/wwwroot/openclaw
docker compose up -d openclaw-gateway
```

**Q8：容器一直在重启，或健康检查失败？**

先看 `docker compose logs --tail 80 openclaw-gateway`。更换镜像后，入口会在启动 Gateway 前执行 `openclaw doctor --fix`。状态迁不过去时，进程会以代码 78 退出。保留 `config/` 里已有的备份文件，不要删掉数据库或锁文件来让它安静。需要单独再跑一次时：

```bash
cd /www/wwwroot/openclaw
docker compose run --rm --no-deps --entrypoint node openclaw-gateway 
  dist/index.js doctor --fix
docker compose up -d openclaw-gateway
```

**Q9：如何换成带浏览器的镜像？**

打开 Control UI 本身不需要。要用控制台里由 Gateway 控制的浏览器时，把 `compose.yaml` 里两处镜像标签改成 `2026.10.3-browser`，保留卷和 `.env`：

```bash
cd /www/wwwroot/openclaw
docker compose pull openclaw-gateway openclaw-cli
docker compose up -d openclaw-gateway
```

若另外挂载了 `/home/node/.cache/ms-playwright`，可能挡住镜像里自带的 Chromium。先保留数据，再调整那一处挂载。

**Q10：容器里怎么访问宿主机上的 Ollama 或 LM Studio？**

容器里的 `127.0.0.1` 是容器自己，不是宿主机。Compose 已经加了 `host.docker.internal`。模型地址分别写成 `http://host.docker.internal:11434` 和 `http://host.docker.internal:1234`。宿主机上的服务需要监听 Docker 能访问的地址，例如 `OLLAMA_HOST=0.0.0.0:11434`。

**Q11：如何升级？**

先停容器，再备份整个 `config/`、`workspace/`、`auth-secrets/` 和 `.env`。只拷数据库，恢复不了工作区和令牌。

```bash
cd /www/wwwroot/openclaw
docker compose stop openclaw-gateway
```

把 `compose.yaml` 里的标签改成新的具体版本，不要改成 `latest`，然后执行：

```bash
docker compose pull openclaw-gateway openclaw-cli
docker compose up -d openclaw-gateway
```

不要删除 `config/`。入口会在启动前执行 Doctor。升级后打开 Control UI，确认原来的渠道和模型还在。

**Q12：如何停止？**

还要保留配置和令牌时，不要删除 `config/`、`workspace/`、`auth-secrets/` 和 `.env`。

```bash
cd /www/wwwroot/openclaw
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop openclaw-gateway && docker rm openclaw-gateway
```

站点不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/openclaw /www/wwwroot/openclaw-run
```

**Q13：可以把 18789 直接暴露到公网吗？**

Gateway 能调用工具，也能连接聊天渠道。给公网使用时，用 HTTPS 反向代理，并只放行你自己的来源。不要长期开放没有认证保护的明文端口。18790 是沙箱监听，不要单独映射到公网。

**Q14：什么时候才发布 3978？**

官方仓库里的 Compose 还会映射 Microsoft Teams 使用的 3978。不用 Teams 时，本文的 Compose 不发布它。要用时，在 `openclaw-gateway` 的 `ports` 里加上 `"3978:3978"`，再执行 `docker compose up -d openclaw-gateway`。

**Q15：OpenAI 设备码登录返回 HTTP 403？**

这次返回的是 `unsupported_country_region_territory`。向导会提示换供应商、换认证方式，或选 **Skip for now**。没有可用密钥时选跳过，Gateway 仍能启动。控制台里的对话要等模型认证配好之后才有回复。向导原文是：`No auth configured for provider "openai"`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/openclaw/openclaw:2026.10.3

cd /www/wwwroot/openclaw
docker compose up -d openclaw-gateway
docker compose ps
docker compose logs --tail 80 openclaw-gateway
curl -fsS http://127.0.0.1:18789/healthz
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://127.0.0.1:18789/`，令牌在 `.env` 的 `OPENCLAW_GATEWAY_TOKEN`。配置在 `config/`，挂载路径是容器内 `/home/node/.openclaw`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [openclaw/openclaw 镜像页](https://xuanyuan.cloud/r/openclaw/openclaw) | [https://xuanyuan.cloud/r/openclaw/openclaw](https://xuanyuan.cloud/r/openclaw/openclaw) |
| [openclaw/openclaw 标签列表](https://xuanyuan.cloud/r/openclaw/openclaw/tags) | [https://xuanyuan.cloud/r/openclaw/openclaw/tags](https://xuanyuan.cloud/r/openclaw/openclaw/tags) |
| [Docker Hub · openclaw/openclaw](https://hub.docker.com/r/openclaw/openclaw) | [https://hub.docker.com/r/openclaw/openclaw](https://hub.docker.com/r/openclaw/openclaw) |
| [GitHub · openclaw/openclaw](https://github.com/openclaw/openclaw) | [https://github.com/openclaw/openclaw](https://github.com/openclaw/openclaw) |
| [v2026.10.3 发布说明](https://docs.openclaw.ai/releases/2026.10.3) | [https://docs.openclaw.ai/releases/2026.10.3](https://docs.openclaw.ai/releases/2026.10.3) |
| [Docker 安装说明](https://docs.openclaw.ai/install/docker) | [https://docs.openclaw.ai/install/docker](https://docs.openclaw.ai/install/docker) |
| [网络与存储](https://docs.openclaw.ai/install/docker/networking-and-storage) | [https://docs.openclaw.ai/install/docker/networking-and-storage](https://docs.openclaw.ai/install/docker/networking-and-storage) |
| [Compose 操作](https://docs.openclaw.ai/install/docker/compose-operations) | [https://docs.openclaw.ai/install/docker/compose-operations](https://docs.openclaw.ai/install/docker/compose-operations) |
| [Channels](https://docs.openclaw.ai/channels) | [https://docs.openclaw.ai/channels](https://docs.openclaw.ai/channels) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

[https://xuanyuan.cloud/blog/openclaw-docker-deploy](https://xuanyuan.cloud/blog/openclaw-docker-deploy)


