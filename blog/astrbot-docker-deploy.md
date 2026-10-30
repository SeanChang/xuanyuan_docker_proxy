# Docker 部署 AstrBot：轻松搭建多平台 AI 聊天机器人平台

![Docker 部署 AstrBot：轻松搭建多平台 AI 聊天机器人平台](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot.webp)

*分类: Docker部署教程 | 标签: AstrBot,soulter/astrbot,Docker,轩辕镜像,聊天机器人,Agent,私有化部署,部署教程 | 发布时间: 2026-10-29 14:47:01*

> AstrBot 是一款面向想在自己的聊天软件里使用大模型的人的开源 Agent 聊天机器人平台，旨在把模型、插件和多个即时通讯平台收在同一个管理面板里，并通过 WebUI 完成配置。本文将介绍如何通过 Docker Compose 部署 AstrBot，搭建自托管聊天机器人平台，帮助在自己的服务器上打开管理面板并接入聊天软件，适合个人助手及团队客服等场景。

## AstrBot 是什么

AstrBot 是 AstrBotDevs 维护的开源 Agent 聊天机器人平台。它把大模型对话接到 QQ、企业微信、飞书、钉钉、微信公众号、Telegram、Slack 等即时通讯软件上，也可以在浏览器里直接对话。平台、模型、插件和日志都在 WebUI 里改。

与在每个聊天软件里各写一个机器人不同，AstrBot 把这些平台和模型放在同一套配置里。对话仍在原来的聊天软件里，密钥和人格留在自己的服务器上。

## AstrBot 能做什么

- **接入聊天软件**：把机器人接到 QQ、飞书、企业微信、Telegram 等平台。
- **接入模型**：填写模型服务的密钥，或继续使用 Dify、扣子、阿里云百炼里已经建好的应用。
- **在浏览器里对话**：用内置聊天页和已配置的模型说话。
- **安装插件**：在插件页启用已安装的插件，或从插件市场继续安装。
- **设定人格和知识库**：修改默认人格的提示词，并把资料放进知识库供对话检索。

## 为什么要使用 AstrBot

每个聊天软件各写一套程序时，密钥、人格和日志不在一处。把账号交给别人的托管服务，对话内容也不在自己的机器上。

AstrBot 把平台和模型放在自己的服务器上，用管理面板修改。适合要在已有聊天软件里使用自己的模型、又不想在系统里安装 Python 的人。

## 使用 Docker 部署 AstrBot

用 Docker 跑 AstrBot，宿主机不用再安装 Python、Node.js 和 ffmpeg。开始之前准备好 Docker，以及后面要接入的模型服务。

接下来用 Docker Compose 写好数据目录和端口，启动服务，再在浏览器里打开管理面板并登录。

## 环境要求

本文使用 **`soulter/astrbot:v4.29.3`** 版本实测。日志里的版本是 AstrBot v4.29.3。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/astrbot` 换成 `~/docker/astrbot`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 磁盘 | Docker Hub 标签记录里，amd64 压缩体积约 684 MB，arm64 约 660 MB。配置、插件和知识库在 `data/` 里另计 |
| 端口 | 宿主机 **6185** → 容器 **6185**（管理面板）。宿主机 **6199** → 容器 **6199**（可选，OneBot v11 WebSocket） |
| 工作目录 | `/www/wwwroot/astrbot` |
| 数据目录 | `data/` 对应容器内 `/AstrBot/data`。账号、平台和模型配置写在这里 |
| 账号 | 首次启动的用户名通常是 `astrbot`。密码在第一次启动的日志里，登录后立刻修改 |

```text
浏览器
  ├─ 宿主机 6185 → 容器 6185   管理面板
  └─ 宿主机 6199 → 容器 6199   可选，OneBot v11 WebSocket
            │
            ▼
  ./data → /AstrBot/data
```

`v4.29.3` 的默认配置把管理面板绑在 `0.0.0.0:6185`。管理面板有登录。云服务器的安全组只放行你自己的地址。**6199** 只在 OneBot 客户端要从别的机器连入时才放行。

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=astrbot-docker-deploy)。

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

[官方 Compose](https://github.com/AstrBotDevs/AstrBot/blob/v4.29.3/compose.yml) 里写的是 `latest`。Docker Hub 上，`latest` 与 **`v4.29.3`** 在 2026-10-24 指向同一份镜像，和 [GitHub Release v4.29.3](https://github.com/AstrBotDevs/AstrBot/releases/tag/v4.29.3) 是同一天。`latest` 以后会变，本文命令使用 **`v4.29.3`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`v4.29.3`** | 2026-10-24 的版本，含 amd64 与 arm64 | **是** |
| `latest` | 2026-10-24 与 `v4.29.3` 同一份镜像，以后会变 | 否 |
| `v4.29.2`、`v4.29.1` | 更早的版本标签，可用来回退 | 否 |
| `master` | 2025-02 的滚动标签，不是当前版本 | 否 |

完整标签见[标签列表](https://xuanyuan.cloud/r/soulter/astrbot/tags?xy_from=astrbot-docker-deploy)。升级前对照 [Releases](https://github.com/AstrBotDevs/AstrBot/releases)，并确认 Docker Hub 上有这个标签。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=astrbot-docker-deploy) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/soulter/astrbot:v4.29.3
```

Ubuntu 24.04 实测：

```text
v4.29.3: Pulling from soulter/astrbot
eb8021b3a156: Pull complete
5c397e4307db: Pull complete
be6443c06d3c: Pull complete
87c306698d09: Pull complete
f2be67225471: Pull complete
822d5b0594c0: Pull complete
1c021507f799: Pull complete
b524bb3aba73: Pull complete
44136fa355b3: Download complete
7e9a0a2839c6: Download complete
Digest: sha256:c93a6d19507ba45474c3dfb82aad9d36eb432a478112f13c7e6325b5ebffc5f2
Status: Downloaded newer image for docker.xuanyuan.run/soulter/astrbot:v4.29.3
docker.xuanyuan.run/soulter/astrbot:v4.29.3
```

这次 Digest 与 Docker Hub 上 `v4.29.3` 的标签记录一致。拉取结束后，到「Docker Compose 部署」启动。

## Docker Compose 部署

[官方 Compose](https://github.com/AstrBotDevs/AstrBot/blob/v4.29.3/compose.yml) 把管理面板映在 **6185**，并把 **6199** 留给 OneBot v11 的 WebSocket。下面的文件保留这两行。不用 OneBot 时，删掉 `6199:6199` 再启动，管理面板不受影响。

时区用 `TZ=Asia/Shanghai`。不挂载宿主机的 `/etc/localtime`，macOS 和 Windows 上经常没有这个文件。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。`docker rm` 不删除 `data/`。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/astrbot/data
sudo chown -R "$USER":"$USER" /www/wwwroot/astrbot
cd /www/wwwroot/astrbot
```

macOS 把路径换成 `~/docker/astrbot`。

同名容器还在时：

```bash
docker rm -f astrbot
```

2. 写入 `compose.yaml`：

```bash
cd /www/wwwroot/astrbot
cat > compose.yaml <<'EOF'
services:
  astrbot:
    image: docker.xuanyuan.run/soulter/astrbot:v4.29.3
    container_name: astrbot
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    environment:
      - TZ=Asia/Shanghai
    ports:
      - "6185:6185"
      - "6199:6199"
    volumes:
      - ./data:/AstrBot/data
EOF
```

3. 启动：

```bash
docker compose up -d
```

Ubuntu 24.04 实测会先建网络，再启动容器：

```text
[+] up 2/2
 ✔ Network astrbot_default Created  0.2s
 ✔ Container astrbot       Started  2.3s
```

4. 查看状态。`STATUS` 为 Up 后再看日志。

```bash
docker compose ps
```

```text
NAME      IMAGE                                         COMMAND            SERVICE   CREATED         STATUS         PORTS
astrbot   docker.xuanyuan.run/soulter/astrbot:v4.29.3   "python main.py"   astrbot   6 seconds ago   Up 4 seconds   0.0.0.0:6185->6185/tcp, [::]:6185->6185/tcp, 0.0.0.0:6199->6199/tcp, [::]:6199->6199/tcp
```

5. 查看日志。初始密码只在第一次生成时打印，重启后不再出现。

```bash
docker compose logs --tail 80 astrbot
```

容器刚起来时，连续两次执行都没有输出。再执行一次才有内容。开头有 3 处 jieba 的 `SyntaxWarning`，后面仍出现 `WebUI is ready`，启动没有停住。日志里还有启动图案，下面只保留版本、插件和面板地址。星号处是初始密码，登录时用你日志里的那一串，不要把密码贴到公开场合。

```text
astrbot  | [14:30:11.059] [Core] [INFO] [core.core_lifecycle:163]: AstrBot v4.29.3
astrbot  | [14:30:16.608] [Core] [INFO] [core.persona_mgr:64]: Loaded 1 personas.
astrbot  | [14:30:16.748] [Core] [INFO] [star.star_manager:1215]: Plugin builtin_commands (0.0.1) by Soulter: AstrBot's internal plugin, providing all built-in commands such as /reset.
astrbot  | [14:30:16.789] [Core] [INFO] [star.star_manager:1215]: Plugin astrbot (4.4.0) by AstrBot Team: AstrBot's internal plugin, providing some basic capabilities.
astrbot  | [14:30:18.135] [Core] [INFO] [knowledge_base.kb_mgr:64]: KnowledgeBase database initialized: /AstrBot/data/knowledge_base/kb.db
astrbot  | [14:30:22.827] [Core] [INFO] [dashboard.server:662]: Starting WebUI at http://0.0.0.0:6185
astrbot  | [14:30:22.827] [Core] [INFO] [dashboard.server:664]: WebUI listens on all interfaces. Check security. Set dashboard.host in data/cmd_config.json to change it.
astrbot  |  ✨✨✨
astrbot  |   AstrBot v4.29.3 WebUI is ready
astrbot  |    ➜  Local: http://localhost:6185
astrbot  |    ➜  Network: http://127.0.0.1:6185
astrbot  |    ➜  Network: http://172.31.0.2:6185
astrbot  |    ➜  Initial username: astrbot
astrbot  |    ➜  Initial password: ********
astrbot  |    ➜  Change it after logging in
astrbot  |  ✨✨✨
astrbot  | [14:30:22.830] [Core] [INFO] [core.core_lifecycle:363]: AstrBot started.
astrbot  | [2026-10-29 14:30:22 +0800] [1] [INFO] Running on http://0.0.0.0:6185 (CTRL + C to quit)
```

`data/` 里已经有密码时，日志只打印 `Username`。忘记密码时，用「常见问题」里的重置命令。

## 打开管理面板

在运行 Docker 的这台机器上打开 `http://127.0.0.1:6185`。从另一台电脑打开时，改成 `http://服务器IP:6185`。日志里的 `http://172.31.0.2:6185` 是容器地址，不要发给别的电脑。

1. 打开上面的地址。登录框标题是 AstrBot WebUI，提示「如果这是首次登录，请在日志中查看默认密码。」用户名填 `astrbot`，密码填日志里的初始密码，再点「登录」。页脚是 WebUI v4.29.3、AstrBot 4.29.3。

![AstrBot 登录页：用户名、密码和登录按钮，页脚为 WebUI v4.29.3](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-1.webp)

2. 先想好新密码。页面要求长度至少 8 位，并包含大写字母、小写字母和数字。登录后进入「设置账户」，说明是「创建用于管理 AstrBot 的账户」，新用户名已经填着 `astrbot`。填入新密码和确认新密码，点「完成设置」。

![AstrBot 设置账户：新用户名 astrbot，新密码和确认新密码，按钮为完成设置](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-2.webp)

3. 弹出「首次提示」。弹窗写明：若有人在使用过程中收费，这是诈骗，应向对方申请退款，并给 `community@astrbot.app` 发邮件。看完后点右下角「关闭」。

![AstrBot 首次提示：欢迎使用 AstrBot，右下角是关闭](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-3.webp)

4. 关闭后是欢迎页。欢迎语随时间变化，截图上是「下午好，欢迎使用 AstrBot」。快速引导有三项：「配置 AI 模型」「配置平台机器人」「允许 Agent 使用电脑」。第三项保持「不允许」。引导里的「去配置」和左侧菜单打开的是同一批页面。

![AstrBot 欢迎页：快速引导三项，允许 Agent 使用电脑为不允许](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-4.webp)

页面写着，平台和对话提供商都可以稍后再配置。机器人还没保存、模型密钥还没填时，QQ 和 Telegram 里不会有回复。

## 查看机器人和模型

密钥用你自己的账号。填法见 [快速接入指南](https://docs.astrbot.app/platform/start.html) 和 [接入模型服务](https://docs.astrbot.app/providers/start.html)。下面按左侧菜单打开这些页面。

1. 打开左侧「机器人」。中间写着「还没有机器人」。点「创建机器人」。

![AstrBot 机器人页：还没有机器人，右侧提示选择一个机器人进行配置](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-5.webp)

2. 在「选择消息平台类别」里打开下拉列表。列表里有 QQ 官方机器人（Websocket，推荐）、QQ 官方机器人（Webhook）、OneBot v11、飞书（Lark）、个人微信、企业微信（智能机器人）。个人微信的说明写着仅支持私聊。选好类别后按页面继续填写，再点「保存」。下图还停在下拉列表。

![AstrBot 创建机器人：消息平台下拉列表，含 QQ 官方机器人和 OneBot v11](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-6.webp)

3. 打开左侧「模型提供商」。顶部有「对话」「语音转文字」「文字转语音」「嵌入」「重排序」。对话页写着「暂无提供商」。

![AstrBot 模型提供商：对话页暂无提供商](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-7.webp)

4. 点「新增」，弹出「新建模型提供商」。提供商一栏右侧写着 29，其中有 OpenAI Compatible、Anthropic Compatible、Gemini Compatible 和 DeepSeek。选中一个提供商后填写密钥再保存。下图还没有填写。

![AstrBot 新建模型提供商：OpenAI Compatible、DeepSeek、Gemini Compatible 等](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-8.webp)

5. 打开左侧「插件」，停在「已安装」。AstrBot 4.4.0 和内置指令 0.0.1 的开关都是开的。内置指令的说明里有 `/reset`、`/help`、`/sid`。再到「插件市场」安装别的插件之前，先看作者。

![AstrBot 已安装插件：AstrBot 4.4.0 和内置指令 0.0.1 均为启用](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-9.webp)

6. 打开左侧「配置文件」。顶部是「默认配置文件」，「AI」是选中的。对话模型和回退对话模型都是「未选择」，异常重试次数是 5。选好模型后，点右下角磁盘图标保存。

![AstrBot 配置文件：默认配置文件的 AI 页，对话模型未选择](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-10.webp)

7. 打开「数据与日志」，默认停在「统计」。平台实例数是 1，消息总数是 0，今日模型调用是 0，CPU 是 0%，进程内存是 306 MB，运行时间是 3 分 6 秒。右侧写着当前没有平台消息统计数据。机器人列表仍是空的。这个 1 不是已经保存的聊天平台。

![AstrBot 数据与日志：平台实例数 1，消息总数 0，进程内存 306 MB](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-11.webp)

8. 打开「人格设定」。人格 ID 是 `default`，系统提示词是 `You are a helpful and friendly assistant.`。技能里勾着 `astrbot`，版本是 0.4.4。工具是 0/0，写着暂无可用工具。

![AstrBot 编辑人格：default 的系统提示词，技能 astrbot 0.4.4 已勾选](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-12.webp)

9. 打开「知识库」。页面写着「暂无知识库」，按钮是「创建知识库」。启动日志里已经建好 `kb.db`，这里还没有集合。

![AstrBot 知识库：暂无知识库，按钮为创建知识库](https://imgs.xuanyuan.cloud/docker/blog/astrbot/astrbot-13.webp)

## 备选：docker run

没有 Compose 时用这一节。目录、端口和镜像与上面相同。Compose 已经在跑时，先到工作目录执行 `docker compose down`，再跑下面的命令，避免容器名和端口冲突。

```bash
docker rm -f astrbot
docker run -d 
  --name astrbot 
  --restart unless-stopped 
  --security-opt no-new-privileges:true 
  -e TZ=Asia/Shanghai 
  -p 6185:6185 
  -p 6199:6199 
  -v /www/wwwroot/astrbot/data:/AstrBot/data 
  docker.xuanyuan.run/soulter/astrbot:v4.29.3
```

macOS 把 `/www/wwwroot/astrbot` 换成 `~/docker/astrbot`。

查看状态：

```bash
docker ps --filter name=astrbot
docker logs --tail 80 astrbot
```

然后打开 `http://服务器IP:6185`，用日志里的初始密码登录。

停掉并删除容器，保留 `data/`：

```bash
docker stop astrbot && docker rm astrbot
```

## 常见问题

**Q1：为什么命令里不写 `latest`？**

官方 Compose 示例写的是 `latest`。它会跟着新构建变。本文命令使用 `v4.29.3`。

**Q2：为什么有 6199？宿主机 6185 被占用怎么办？**

**6199** 是 OneBot v11 的 WebSocket，管理面板不走它。不用时删掉 Compose 里的 `6199:6199`，再执行 `docker compose up -d`。

宿主机 **6185** 已被占用时，只改冒号左侧，例如 `16185:6185`，浏览器改用 `16185`。容器内仍是 **6185**，不必去改 `data/cmd_config.json` 里的 `port`。

**Q3：管理面板打不开？**

先看 `docker compose ps` 的 `STATUS` 是不是 Up。容器马上退出时，看 `docker compose logs --tail 80 astrbot`。日志里若是「端口 6185 已被占用」，只改宿主机端口。

页面一直打不开时，看 `data/cmd_config.json` 里的 `dashboard.host`。`v4.29.3` 的默认值是 `0.0.0.0`。写成 `127.0.0.1` 后，进程只听容器内部，宿主机的端口映射进不去。改回 `0.0.0.0` 后执行 `docker compose restart astrbot`。这个文件在容器里生成，当前用户没有写权限时用 `sudo` 编辑。

**Q4：日志里没有 `Initial password`？**

初始密码只在第一次生成时打印。`data/` 里已经有密码，或容器重启之后，日志只显示 `Username`。用「忘记密码怎么办」里的命令重置。

**Q5：忘记密码怎么办？**

官方说明：Docker 部署用镜像里的 AstrBot CLI 重置。按提示输入新密码。

```bash
docker exec -it astrbot astrbot password
```

需要同时改用户名时，把 `新用户名` 换成你要使用的名字：

```bash
docker exec -it astrbot astrbot password --username 新用户名
```

改完后要重启容器才会生效：

```bash
docker restart astrbot
```

**Q6：日志里的 Network 地址打不开？**

`http://127.0.0.1:6185` 只在运行 Docker 的这台机器上能打开。`http://172.31.0.2:6185` 是容器地址。从别的电脑访问时用宿主机 IP。

**Q7：要和 NapCat 一起部署吗？**

本文只部署 AstrBot。官方另有一份把 AstrBot 和 NapCat 放在同一网络、并共用 `data/` 的 Compose，其中 AstrBot 的 **6199** 被注释掉了。文件在 [NapCat 的 astrbot.yml](https://github.com/NapNeko/NapCat-Docker/blob/main/compose/astrbot.yml)。NapCat 本身的部署见 [Docker 部署 NapCat](https://xuanyuan.cloud/blog/napcat-docker-deploy?xy_from=astrbot-docker-deploy)。两份 Compose 不要同时占用同一个容器名 `astrbot`。

**Q8：Agent 沙盒怎么开？**

在隔离环境里执行代码时，官方使用另一份带 Shipyard 的 Compose，需要填写访问令牌，并挂载 Docker 套接字。步骤见 [Agent 沙盒环境](https://docs.astrbot.app/use/astrbot-agent-sandbox.html)。本文的 `compose.yaml` 不包含沙盒。

**Q9：容器里要走 HTTP 代理怎么办？**

代理地址由 AstrBot 容器内部去访问。在管理面板打开「系统设置」→「网络」，填写 HTTP 代理。`http://127.0.0.1:7890` 会连到容器自己，不是宿主机。

Docker Desktop（Mac / Windows）填写 `http://host.docker.internal:7890`。Linux 上填写 `http://172.17.0.1:7890`，并把 `172.17.0.1` 换成这台机器上 docker0 的网关。AstrBot 和代理在同一个 Docker 网络里时，改用代理容器的名字，例如 `http://clash:7890`。

代理端口要映射到宿主机，并且不要只绑在 `127.0.0.1`。写成 `127.0.0.1:7890:7890` 时，别的容器从网关进不去。

**Q10：如何升级？**

先看 [Releases](https://github.com/AstrBotDevs/AstrBot/releases)，确认 Docker Hub 上有同名标签。把 `compose.yaml` 里的 `v4.29.3` 改成新版本，再执行：

```bash
cd /www/wwwroot/astrbot
docker compose up -d
```

不要删除 `data/`。升级后用原来的密码登录。

**Q11：如何停止？**

还要保留配置和插件时，不要删除 `data/`。

```bash
cd /www/wwwroot/astrbot
docker compose down
```

这套部署不再需要时，再删除工作目录：

```bash
rm -rf /www/wwwroot/astrbot
```

## 命令速查

```bash
docker pull docker.xuanyuan.run/soulter/astrbot:v4.29.3

cd /www/wwwroot/astrbot
docker compose up -d
docker compose ps
docker compose logs --tail 80 astrbot
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。管理面板是 `http://服务器IP:6185`。第一次启动的用户名和密码在日志的 `Initial username`、`Initial password` 两行。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [soulter/astrbot 镜像页](https://xuanyuan.cloud/zh/r/soulter/astrbot?xy_from=astrbot-docker-deploy) | [https://xuanyuan.cloud/zh/r/soulter/astrbot](https://xuanyuan.cloud/zh/r/soulter/astrbot?xy_from=astrbot-docker-deploy) |
| [soulter/astrbot 概览](https://xuanyuan.cloud/r/soulter/astrbot?xy_from=astrbot-docker-deploy) | [https://xuanyuan.cloud/r/soulter/astrbot](https://xuanyuan.cloud/r/soulter/astrbot?xy_from=astrbot-docker-deploy) |
| [soulter/astrbot 标签列表](https://xuanyuan.cloud/r/soulter/astrbot/tags?xy_from=astrbot-docker-deploy) | [https://xuanyuan.cloud/r/soulter/astrbot/tags](https://xuanyuan.cloud/r/soulter/astrbot/tags?xy_from=astrbot-docker-deploy) |
| [使用 Docker 部署 AstrBot](https://docs.astrbot.app/deploy/astrbot/docker.html) | [https://docs.astrbot.app/deploy/astrbot/docker.html](https://docs.astrbot.app/deploy/astrbot/docker.html) |
| [WebUI](https://docs.astrbot.app/use/webui.html) | [https://docs.astrbot.app/use/webui.html](https://docs.astrbot.app/use/webui.html) |
| [快速接入指南](https://docs.astrbot.app/platform/start.html) | [https://docs.astrbot.app/platform/start.html](https://docs.astrbot.app/platform/start.html) |
| [接入模型服务](https://docs.astrbot.app/providers/start.html) | [https://docs.astrbot.app/providers/start.html](https://docs.astrbot.app/providers/start.html) |
| [常见问题](https://docs.astrbot.app/faq.html) | [https://docs.astrbot.app/faq.html](https://docs.astrbot.app/faq.html) |
| [GitHub · AstrBotDevs/AstrBot](https://github.com/AstrBotDevs/AstrBot) | [https://github.com/AstrBotDevs/AstrBot](https://github.com/AstrBotDevs/AstrBot) |
| [Release v4.29.3](https://github.com/AstrBotDevs/AstrBot/releases/tag/v4.29.3) | [https://github.com/AstrBotDevs/AstrBot/releases/tag/v4.29.3](https://github.com/AstrBotDevs/AstrBot/releases/tag/v4.29.3) |
| [Docker Hub · soulter/astrbot](https://hub.docker.com/r/soulter/astrbot) | [https://hub.docker.com/r/soulter/astrbot](https://hub.docker.com/r/soulter/astrbot) |
| [Docker 部署 NapCat](https://xuanyuan.cloud/blog/napcat-docker-deploy?xy_from=astrbot-docker-deploy) | [https://xuanyuan.cloud/blog/napcat-docker-deploy](https://xuanyuan.cloud/blog/napcat-docker-deploy?xy_from=astrbot-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=astrbot-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=astrbot-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/astrbot-docker-deploy?xy_from=astrbot-docker-deploy)

*本文基于 [soulter/astrbot:v4.29.3](https://xuanyuan.cloud/zh/r/soulter/astrbot?xy_from=astrbot-docker-deploy)，以 **v4.29.3** 版本实测，测试平台 **Ubuntu 24.04** Linux。*


