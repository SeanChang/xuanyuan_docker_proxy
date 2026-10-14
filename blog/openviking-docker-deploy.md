# Docker 部署 OpenViking：轻松搭建 AI Agent 上下文数据库平台

![Docker 部署 OpenViking：轻松搭建 AI Agent 上下文数据库平台](https://imgs.xuanyuan.cloud/docker/blog/openviking.webp)

*分类: Docker部署教程 | 标签: OpenViking,openviking/openviking,Docker,轩辕镜像,AI Agent,上下文数据库,私有化部署,部署教程 | 发布时间: 2026-10-09 13:58:20*

> OpenViking 是一款面向 AI Agent 的开源上下文数据库，旨在统一管理智能体所需的记忆、资源和技能等上下文信息，并通过文件系统式的组织方式简化上下文检索与使用。本文将介绍如何通过 Docker 快速部署 OpenViking，搭建 AI Agent 上下文管理平台，帮助开发者更高效地管理长期记忆、知识资源和任务上下文，适合 AI Agent 开发及智能应用构建等场景。

*本文基于 [openviking/openviking:v0.4.23](https://xuanyuan.cloud/zh/r/openviking/openviking)，以 **v0.4.23** 版本实测，测试平台 **Ubuntu 24.04** Linux。*

## OpenViking 是什么

OpenViking 由字节跳动火山引擎 Viking 团队开源，是给 AI Agent 用的上下文数据库。项目资料、用过的经验和以后还能照做的方法，放在同一套虚拟文件系统里，按路径保存、查找，并在下一次任务里取出来用。

常见的 RAG 先把文档切开，再按相似度去找片段。OpenViking 要管的是这些内容如何放在一起、如何分层去读，以及一次任务结束以后如何留下来。

## OpenViking 能做什么

- **放在同一套目录里**：文档、外部资料、用户记忆和技能用同一套目录组织。
- **先读摘要再打开原文**：目录带有摘要和概览，确认相关之后再读详细内容。
- **在目录范围内检索**：语义搜索可以限定在某个目录，结果仍能看出它原来的位置。
- **把会话留成记忆**：对话中的偏好和任务经验可以沉淀下来，供以后的任务调用。
- **打开目录核对结果**：保存下来的内容可以按目录查看，方便对照这次检索用到了什么。

## 为什么要使用 OpenViking

Agent 要连续做一件事时，当次提示词和一个向量库往往接不住。资料在一处，偏好在另一处，做过的事到下一次又对不上。检索偏了，也看不出读到的是哪一份材料，后面排查和改动都会变多。

OpenViking 把资料、记忆和技能收进同一套目录。做智能体，或要给现有 AI 项目补上可查找、可记住、可复用的上下文时，可以用它。

## 使用 Docker 部署 OpenViking

OpenViking 可以用 Docker 启动，本机不必先安装它的 Python 运行环境。开始之前，先准备好 Docker，并配好实际要用的模型服务。

下面用 Docker Compose 写好运行配置，启动服务，并确认可以访问。

## 环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文命令按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/openviking` 换成 `~/docker/openviking` |
| Docker | Engine + **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64**（`v0.4.23` 两套都有） |
| 磁盘 | Ubuntu 24.04 上 `docker images` 显示 DISK **1.74GB**、CONTENT **308MB**（amd64）；原文和向量写在挂载目录，随入库增长 |
| 内存 | 容器不打包大模型。占用随入库规模增长，先用一份有代表性的语料观察 |
| 端口 | 宿主机 **1933/tcp** → 容器 **1933** |
| 出网 | 容器要能访问方舟 API：`https://ark.cn-beijing.volces.com` |
| 模型 | 嵌入模型与 VLM 各一个。本文按火山方舟：`doubao-embedding-vision-251215`、`doubao-seed-2-0-lite-260428` |
| 工作目录 | `/www/wwwroot/openviking` |

先在方舟创建 API Key，并打开 [Doubao-Embedding-Vision](https://console.volcengine.com/ark/region:cn-beijing/model/detail?name=doubao-embedding-vision) 开通嵌入模型。未开通时 `doctor` 会报 404、`ModelNotOpen`，见下文 Q4。模型说明见[火山引擎模型购买说明](https://docs.openviking.ai/zh/guides/02-volcengine-purchase-guide)。

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

## 标签怎么选

[GitHub Release v0.4.23](https://github.com/volcengine/OpenViking/releases/tag/v0.4.23) 发布于 2026-10-02。同日推送的 `latest` 与 `v0.4.23` 指向同一份镜像清单；`main` 会随主分支构建继续变。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`v0.4.23`** | 当前正式版本，amd64 / arm64 | **是** |
| `v0.4.22` | 上一正式版本 | 仅作回退 |
| `v0.4.23.dev…`、`main` | 开发构建，会移动 | 否 |
| `latest` | 浮动标签，之后可能改指向 | 否 |

完整列表见[标签页](https://xuanyuan.cloud/r/openviking/openviking/tags)。升级时改 Compose 里的标签，并对照 [Releases](https://github.com/volcengine/OpenViking/releases)。

---

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/openviking/openviking:v0.4.23
```

Ubuntu 24.04 实测：

```text
v0.4.23: Pulling from openviking/openviking
b14f2539d39c: Pull complete
589007fc1f86: Pull complete
49ae429f6151: Pull complete
b967c07a5a02: Pull complete
6b37362b3da7: Pull complete
42d2af197b20: Pull complete
bfd385278b10: Pull complete
9d8258efce77: Pull complete
cf83b3575e87: Pull complete
4f4fb700ef54: Pull complete
7e7563f2ddb6: Pull complete
5ed2ef5ecece: Pull complete
44136fa355b3: Download complete
12c7c1f81ade: Download complete
Digest: sha256:e29398501454e01838586ed5dfde2187f3b5b3da8b16551b8d87827a6ec317cb
Status: Downloaded newer image for docker.xuanyuan.run/openviking/openviking:v0.4.23
docker.xuanyuan.run/openviking/openviking:v0.4.23
```

拉取完成后确认本地有这个标签：

```bash
docker images docker.xuanyuan.run/openviking/openviking:v0.4.23
```

```text
IMAGE                                               ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/openviking/openviking:v0.4.23   e29398501454       1.74GB          308MB
```

---

## 编写 ov.conf

容器内工作目录是 `/app/.openviking`，配置文件是 `/app/.openviking/ov.conf`。`storage.workspace` 写成 `./data` 时，原文和向量落在 `/app/.openviking/data`。下面把宿主机 `/www/wwwroot/openviking/data` 整目录挂进去，配置和数据在同一次挂载里。

入口监听 `0.0.0.0:1933`，宿主机才能把端口映射进来。`server.root_api_key` 必须是非空字符串，否则进程拒绝启动。这把根密钥只填「连接设置」里的管理员栏。方舟 API Key 只填 `embedding` 和 `vlm` 的 `api_key`。两把钥匙对调后，方舟返回 401，见 Q3。

Compose 里 `OPENVIKING_WITH_BOT` 为 `1`。对话用这里的 `vlm`（`doubao-seed-2-0-lite-260428`）。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/openviking/data
sudo chown -R "$USER":"$USER" /www/wwwroot/openviking
```

2. 方舟 API Key 已经复制好（一般以 `sk-` 开头）、嵌入模型已经开通之后，再写配置。只改第一行引号里的内容。`ROOT_API_KEY` 由 `openssl` 生成，并写到 `/www/wwwroot/openviking/root_api_key.txt`，这个文件不在挂载目录里。

```bash
ARK_API_KEY='sk-这里换成方舟控制台复制的密钥'
ROOT_API_KEY="$(openssl rand -hex 32)"

umask 077
printf '%s
' "$ROOT_API_KEY" > /www/wwwroot/openviking/root_api_key.txt

if [ "$ARK_API_KEY" = "sk-这里换成方舟控制台复制的密钥" ]; then
  echo "还没换成方舟密钥，ov.conf 没有写入"
else
  cat > /www/wwwroot/openviking/data/ov.conf <<EOF
{
  "server": {
    "root_api_key": "${ROOT_API_KEY}"
  },
  "storage": {
    "workspace": "./data",
    "agfs": { "backend": "local" },
    "vectordb": { "backend": "local" }
  },
  "embedding": {
    "dense": {
      "provider": "volcengine",
      "api_key": "${ARK_API_KEY}",
      "model": "doubao-embedding-vision-251215",
      "api_base": "https://ark.cn-beijing.volces.com/api/v3",
      "dimension": 1024,
      "input": "multimodal"
    }
  },
  "vlm": {
    "provider": "volcengine",
    "api_key": "${ARK_API_KEY}",
    "model": "doubao-seed-2-0-lite-260428",
    "api_base": "https://ark.cn-beijing.volces.com/api/v3",
    "temperature": 0.1,
    "max_retries": 3
  }
}
EOF
  echo "ov.conf 已写入"
fi
```

终端应打印 `ov.conf 已写入`。若打印「还没换成方舟密钥」，改完 `ARK_API_KEY` 再执行一次。

目录关系：

```text
/www/wwwroot/openviking/root_api_key.txt   根密钥，不进容器
/www/wwwroot/openviking/data/ov.conf       →  /app/.openviking/ov.conf
/www/wwwroot/openviking/data/data/         →  /app/.openviking/data
```

`workspace` 保持 `./data`。写成宿主机绝对路径时，容器里没有那个目录。

3. 常驻服务还没启动。用一次性容器检查。Embedding 不是 PASS 时，先改配置，不要进入下一节：

```bash
docker run --rm 
  -v /www/wwwroot/openviking/data:/app/.openviking 
  docker.xuanyuan.run/openviking/openviking:v0.4.23 
  openviking-server doctor
```

Ubuntu 24.04 上，模型已开通且两把钥匙填对之后，Embedding 为 PASS。VikingBot 那一行是 WARN：用户还没在 Studio 里创建，不挡后面的启动。

```text
OpenViking Doctor

  Config:         PASS  /app/.openviking/ov.conf
  Python:         PASS  3.13.16 (>= 3.10 required)
  Native Engine:  PASS  variant=x86_sse3
  AGFS:           PASS  AGFS SDK 0.1.7
  Authentication: PASS  api_key: 1 passed, 0 warned, 0 failed
  Embedding:      PASS  volcengine/doubao-embedding-vision-251215 api_base=https://ark.cn-beijing.volces.com/api/v3 dimension=1024 probe ok (dimension=1024)
  VLM:            PASS  volcengine/doubao-seed-2-0-lite-260428
  Ollama:         PASS  not configured
  VikingBot:      WARN  bot.ov_server not configured and ovcli.conf api_key not configured
                  Fix: Configure bot.ov_server.api_key or ovcli.conf api_key with an OpenViking User API key
  Disk:           PASS  79.8 GB free in data

  1 warning(s). Review the suggestions above.
```

若输出末尾出现 LiteLLM 拉取 `model_prices_and_context_window.json` 超时，它会改用镜像里的价目表，服务仍可继续。方舟报 401 或 404 时看 Q3、Q4。

---

## Docker Compose 部署

宿主机 **1933** 对应容器 **1933**。API 与 Web Studio 共用这个端口，Studio 在 `/studio`，不另开端口。

1. 进入工作目录并写入 Compose。`image` 使用上一节拉好的标签：

```bash
cd /www/wwwroot/openviking
cat > docker-compose.yml <<'EOF'
services:
  openviking:
    image: docker.xuanyuan.run/openviking/openviking:v0.4.23
    container_name: openviking
    restart: unless-stopped
    ports:
      - "1933:1933"
    volumes:
      - /www/wwwroot/openviking/data:/app/.openviking
    environment:
      OPENVIKING_WITH_BOT: "1"
      OPENVIKING_SERVER_PORT: "1933"
    healthcheck:
      test: ["CMD", "openviking-entrypoint", "--healthcheck"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 30s
EOF
```

只在本机访问时，把端口改成 `127.0.0.1:1933:1933`。局域网要访问时再对 1933/tcp 放行。1933 已被占用时，同时改三处：Compose 的宿主机端口、`OPENVIKING_SERVER_PORT`、以及 `ov.conf` 里如果写了 `server.port` 也要一致。入口脚本优先读环境变量 `OPENVIKING_SERVER_PORT`，其次才读配置文件里的端口。

2. 启动。Ubuntu 24.04 实测会先建网络再拉起容器：

```bash
docker compose up -d
```

```text
[+] up 2/2
 ✔ Network openviking_default Created
 ✔ Container openviking       Started
```

3. 看状态。启动后约 12 秒，健康检查还是 `health: starting`，这时访问 1933 会连接被重置：

```bash
docker compose ps
curl -sS http://127.0.0.1:1933/health
curl -sS http://127.0.0.1:1933/ready
```

```text
NAME         IMAGE                                               COMMAND                  SERVICE      CREATED          STATUS                             PORTS
openviking   docker.xuanyuan.run/openviking/openviking:v0.4.23   "openviking-entrypoi…"   openviking   14 seconds ago   Up 12 seconds (health: starting)   0.0.0.0:1933->1933/tcp, [::]:1933->1933/tcp
```

```text
curl: (56) Recv failure: Connection reset by peer
```

`/health` 和 `/ready` 在这个窗口都会这样。这是端口还没接好。等 `docker compose ps` 的 STATUS 不再是 `health: starting`，再执行那两条 `curl`。Studio 能打开之后，以「浏览器首次使用」里「监控」页的组件状态为准。改过 `ov.conf` 后，再执行一次 `docker compose up -d`，让进程重新读配置。

---

## 浏览器首次使用

浏览器打开 `http://服务器IP:1933/studio`。本文局域网地址以实测 `http://192.168.1.35:1933` 为例。

还没在「连接设置」里保存密钥时，首页三张卡都写着「当前连接身份尚未确认」：

![OpenViking Studio 首页，上下文数据量、今日 Token 用量、今日检索次数都提示身份尚未确认](https://imgs.xuanyuan.cloud/docker/blog/openviking-1.webp)

1. 打开左侧「连接设置」（地址是 `/studio/settings`）。服务地址会带出当前访问的主机和端口。Root 密钥和用户密钥都空着时，「控制面权限」「数据访问」都是未检查。把 `/www/wwwroot/openviking/root_api_key.txt` 里的那一行填进「Root 或管理员 API 密钥」并保存。

![连接设置页，服务地址为局域网 1933，API 密钥模式，控制面权限与数据访问均为未检查](https://imgs.xuanyuan.cloud/docker/blog/openviking-2.webp)

密钥生效后，首页能读到用量。实测在还没建用户时，上下文数据量已经是 6（文件 2、技能 2、记忆 2），今日 Token 用量 972，全部来自 Embedding 输入：

![Studio 首页显示上下文数据量 6、今日 Token 用量 972、今日检索次数 0](https://imgs.xuanyuan.cloud/docker/blog/openviking-3.webp)

2. 打开左侧「用户与权限」。账号下还没有用户时，用户数和可见 API 密钥都是 0。点「+ 新增用户」。

![用户与权限页，用户数 0，提示选中的账号下没有用户](https://imgs.xuanyuan.cloud/docker/blog/openviking-4.webp)

3. 在 `default` 空间填写用户名，角色选 `user`。实测用户名为 `xuanyuan`，记忆策略用「通用策略」（用户记忆抽取、Agent 经验记忆抽取都勾上）。生成的密钥只在创建后展示一次。

![新增用户对话框，用户名 xuanyuan，角色 user，记忆策略为通用策略](https://imgs.xuanyuan.cloud/docker/blog/openviking-5.webp)

![新的 API 密钥对话框，身份为 default / xuanyuan，关闭前需复制密钥](https://imgs.xuanyuan.cloud/docker/blog/openviking-6.webp)

点「复制」，再点「收起」。这把密钥只完整显示这一次。

4. 回到「连接设置」，把用户密钥填进「用户 API 密钥」并保存。根密钥留在管理员那一栏。保存后，控制面权限和数据访问都是正常，用户身份是 `[default/xuanyuan]`。「导入一份文档并检索」里的 `ov` 也用这把用户密钥。

![连接设置两项均为正常，服务地址为局域网 1933，用户身份 default/xuanyuan](https://imgs.xuanyuan.cloud/docker/blog/openviking-20.webp)

5. 打开「VikingBot」。Compose 里已经是 `OPENVIKING_WITH_BOT=1`，刷新后是对话入口。「机器人」里目前只有飞书可以点连接，Slack、钉钉、Discord、Telegram 显示开发中。若页面仍写着「先启用 VikingBot」，看 Q7。

![VikingBot 对话页，有新建对话按钮和开始与 VikingBot 对话](https://imgs.xuanyuan.cloud/docker/blog/openviking-9.webp)

![添加机器人对话框，飞书为连接飞书，其余平台为开发中](https://imgs.xuanyuan.cloud/docker/blog/openviking-10.webp)

6. 点「+ 新建对话」。空会话标题是 OpenViking，输入框提示「输入消息...」。实测发送「你好，你是谁」，回复来自 VikingBot，会话出现在左侧列表。

![新建对话的空白输入页，中间文案为探索你的知识库](https://imgs.xuanyuan.cloud/docker/blog/openviking-11.webp)

![VikingBot 对话「你好，你是谁」，回复说明自己基于 OpenViking 上下文数据库](https://imgs.xuanyuan.cloud/docker/blog/openviking-12.webp)

「检索」在还没有可检索上下文时是空的，可点「上传文件」。「编译」要先在 Skills 里添加带 `SKILL.md` 的目录，否则编译 Skill 一栏写着暂无可用 Skill。「Agent 经验」在会话提交之前也是空的。

![检索页提示当前还没有可检索的上下文，并有上传文件按钮](https://imgs.xuanyuan.cloud/docker/blog/openviking-13.webp)

![新建编译页，编译 Skill 暂无可用，素材目录为 viking://resources](https://imgs.xuanyuan.cloud/docker/blog/openviking-14.webp)

![Agent 经验页显示还没有 Agent 经验，并列出三条检查](https://imgs.xuanyuan.cloud/docker/blog/openviking-15.webp)

「请求日志」能看到当前身份 `default / xuanyuan` 的调用。实测总调用 41 次，成功率 93%，其中一条 `GET /api/v1/fs/ls` 为 404，其余多为 200。「任务中心」在没有后台任务时成功率为 100%（0 条任务）。「定时同步」在没有添加远程资源时为空。

![请求日志，范围 default / xuanyuan，总调用 41 次，成功率 93%](https://imgs.xuanyuan.cloud/docker/blog/openviking-16.webp)

![任务中心，任务成功率 100%，暂无后台任务](https://imgs.xuanyuan.cloud/docker/blog/openviking-17.webp)

![定时同步页显示暂无定时同步](https://imgs.xuanyuan.cloud/docker/blog/openviking-18.webp)

「监控」页标题带版本 **v0.4.23**。实测 6 个组件都是正常：任务队列、向量数据库、模型、文件系统、锁、检索。

![监控页 v0.4.23，所有组件运行正常，6/6](https://imgs.xuanyuan.cloud/docker/blog/openviking-19.webp)

页面没有账号密码框。管理员栏填根密钥，数据访问填用户密钥。

---

## 导入一份文档并检索

「浏览器首次使用」里的「检索」还是空的。要在容器里导入一份样例，先有用户密钥。导入会调用嵌入模型和 VLM，按方舟账单计费。样例只有几行。

1. 在挂载目录里放一份样例，容器内路径是 `/app/.openviking/samples/ov-release-rotation.md`：

```bash
mkdir -p /www/wwwroot/openviking/data/samples
cat > /www/wwwroot/openviking/data/samples/ov-release-rotation.md <<'EOF'
# 发布值班

OpenViking 每周五发一个版本。
值班顺序：qin-ctx、zhoujh01、ZaynJarvis、t0saki。
EOF
```

2. 写命令行配置。`api_key` 填「浏览器首次使用」里复制的用户密钥。`url` 用容器内访问本服务的地址：

```bash
cat > /www/wwwroot/openviking/data/ovcli.conf <<'EOF'
{
  "url": "http://127.0.0.1:1933",
  "api_key": "REPLACE_WITH_USER_API_KEY"
}
EOF
```

3. 导入并等到处理结束。超时就把命令返回的 `task_id` 交给 `ov task status`，状态变成 `completed` 再继续：

```bash
docker exec openviking ov health
docker exec openviking ov add-resource /app/.openviking/samples/ov-release-rotation.md 
  --to viking://resources/ov-release-rotation 
  --wait --timeout 120
```

4. 看目录、摘要，并在这个资源目录里检索：

```bash
docker exec openviking ov tree viking://resources/ov-release-rotation
docker exec openviking ov overview viking://resources/ov-release-rotation
docker exec openviking ov find "每周版本谁值班" --uri viking://resources/ov-release-rotation
```

`find` 的结果里带 `viking://` URI。要把某一条读出来，把该 URI 传给 `ov read`。

宿主机已有 Node.js 18 及以上时，可以 `npm install -g @openviking/cli`，在 `ov config` 里填 `http://服务器IP:1933` 和同一把用户密钥。上面的检查用容器里的 `ov` 即可。

---

## 备选：docker run

没有 Compose 时，用同一份挂载和同一套环境变量。已经用 Compose 起过名为 `openviking` 的容器时，先在 `/www/wwwroot/openviking` 执行 `docker compose down`，再跑下面的命令，避免容器名冲突。

`ov.conf` 仍然要按「编写 ov.conf」写好，并通过 `doctor`。

```bash
docker run -d 
  --name openviking 
  --restart unless-stopped 
  -p 1933:1933 
  -v /www/wwwroot/openviking/data:/app/.openviking 
  -e OPENVIKING_WITH_BOT=1 
  -e OPENVIKING_SERVER_PORT=1933 
  docker.xuanyuan.run/openviking/openviking:v0.4.23
```

查看与停止：

```bash
docker ps --filter name=openviking
docker logs -f --tail 100 openviking
curl -sS http://127.0.0.1:1933/health
curl -sS http://127.0.0.1:1933/ready
docker stop openviking
```

浏览器地址与「浏览器首次使用」相同。

---

## 常见问题

**Q1：`latest` 或 `main` 能不能写进 Compose？**

`v0.4.23` 是 2026-10-02 的正式标签。`latest` 以后可能改指向，`main` 随主分支更新。本文命令固定 `v0.4.23`。回退时把标签换成 `v0.4.22`，先备份「编写 ov.conf」里的数据目录再 `up -d`。

**Q2：容器一起就退出，日志里提到 dev mode 或 loopback？**

入口在容器里绑定 `0.0.0.0`。`server.root_api_key` 为空时，进程把它当成 dev 模式，拒绝在非回环地址启动。把「编写 ov.conf」生成的根密钥写进 `server.root_api_key`，再执行 `docker compose up -d`。

`openviking-server init` 在 `v0.4.23` 里选 Local，会写成 `127.0.0.1:1933`，认证是 `auth dev (no auth)`，并先把已有 `ov.conf` 备份成 `ov.conf.bak`。Docker 部署用「编写 ov.conf」里的 JSON。已经跑过向导时，绑定地址选 Remote（0.0.0.0），保存前摘要里要有 root key，然后再跑 `doctor`。

**Q3：`doctor` 里 Embedding 是 FAIL，错误码 401，`The API key format is incorrect`？**

模型密钥不是方舟签发的。Ubuntu 24.04 上把本机 `openssl rand -hex 32` 的输出填进 `embedding.dense.api_key` 时，探针返回：

```text
Embedding:      FAIL  volcengine/doubao-embedding-vision-251215 api_base=https://ark.cn-beijing.volces.com/api/v3 dimension=1024 (probe failed: Volcengine embedding failed: Error code: 401 - {'error': {'code': 'AuthenticationError', 'message': 'The API key format is incorrect. ...', 'type': 'Unauthorized'}})
VLM:            PASS  volcengine/doubao-seed-2-0-lite-260428
```

按量接口用 `https://ark.cn-beijing.volces.com/api/v3` 和模型 `doubao-embedding-vision-251215`。方舟 Agent Plan 是另一套：`api_base` 为 `https://ark.cn-beijing.volces.com/api/plan/v3`，嵌入模型 `doubao-embedding-vision`，VLM `doubao-seed-2.0-lite`，`api_key` 填 Agent Plan 的密钥。密钥和端点要成对，填错时 Embedding 同样是 401，VLM 仍可能 PASS。`Authentication: PASS` 只表示配置里有一段字符串，或当前是 dev 模式。改完后再跑 `doctor`，看 Embedding 那一行。

**Q4：`doctor` 里 Embedding 是 FAIL，错误码 404，`ModelNotOpen`？**

方舟认了这把 API Key，但账号还没开通嵌入模型。Ubuntu 24.04 实测的提示是尚未开通 `doubao-embedding-vision-251215`。打开 [Doubao-Embedding-Vision](https://console.volcengine.com/ark/region:cn-beijing/model/detail?name=doubao-embedding-vision) 完成开通，不要改 `ov.conf`，再跑一次 `doctor`。开通后 Embedding 应为 `PASS`，并带 `probe ok (dimension=1024)`。

**Q5：`/health` 是 ok，`/ready` 里 embedding 失败？**

存活检查不验证模型密钥。看 `ov.conf` 里的 `provider`、`model`、`api_key`、`api_base` 是否仍是占位符，方舟控制台是否已开通对应模型，容器能否访问 `ark.cn-beijing.volces.com`。改完配置后重启容器，再请求 `/ready`。

**Q6：根密钥拿去调 `ov add-resource` 失败？**

根密钥做管理。读写资源、记忆和技能要用 Studio 用户页给出的用户密钥，写在 `ovcli.conf` 的 `api_key`。

**Q7：`/studio/vikingbot` 提示先启用 VikingBot？**

`OPENVIKING_WITH_BOT` 为 `0` 或未设置时，工作台和 VikingBot 页是下面这样：

![工作台打开 viking://，右侧提示当前服务未启用 Agent 对话功能](https://imgs.xuanyuan.cloud/docker/blog/openviking-7.webp)

![VikingBot 页提示先启用，命令为 openviking-server --with-bot](https://imgs.xuanyuan.cloud/docker/blog/openviking-8.webp)

把 Compose 里的 `OPENVIKING_WITH_BOT` 改成 `1`，执行 `docker compose up -d`，再刷新。对话模型用 `ov.conf` 里的 `vlm`。本文按这个配置打开后，发送「你好，你是谁」能收到回复。若页面仍提示缺少用户密钥，在 `bot.ov_server.api_key` 填「浏览器首次使用」里的用户密钥，见 [VikingBot 配置](https://docs.openviking.ai/en/guides/17-vikingbot)。

**Q8：详情页中文简介里的端口和镜像名对不上？**

简介里的端口 8080、镜像名 `apecloud/openviking` 是另一份说明。拉取用 `docker.xuanyuan.run/openviking/openviking:v0.4.23`，端口 **1933**，挂载 `/app/.openviking`。

**Q9：仓库自带的 Compose 示例写的是 ghcr.io？**

示例镜像是 `ghcr.io/volcengine/openviking`，还带 Caddy 的宿主机端口 1934。按本文拉取 `docker.xuanyuan.run/openviking/openviking:v0.4.23`，浏览器打开 `http://服务器IP:1933/studio`。详情页：[openviking/openviking](https://xuanyuan.cloud/zh/r/openviking/openviking)。

**Q10：以前的容器把数据写在 `/app/data`，升级后目录是空的？**

较老的镜像把相对路径 `./data` 解析到 `/app/data`，那个路径在默认挂载之外。停掉旧容器后，用 `docker cp` 把旧容器里的 workspace 拷出来，再放进现在的宿主机目录 `/www/wwwroot/openviking/data/data`。已有数据不要直接覆盖。新装 `v0.4.23` 且从一开始就按本文挂载的，数据就在这次挂载里。

**Q11：只想试用，不想自己配模型？**

火山引擎有托管的 OpenViking。在控制台创建 API Key 后，服务地址是 `https://api.vikingdb.cn-beijing.volces.com/openviking`。产品说明见 [OpenViking 托管服务](https://www.volcengine.com/product/openviking-service)。这条地址走托管服务，不用跑本文的 Compose。

**Q12：1933 要不要对公网开放？**

本文的映射适合本机或内网。要对公网提供服务，先确认根密钥和用户密钥没有泄露，再按[部署文档](https://docs.openviking.ai/en/guides/03-deployment)做 HTTPS 与访问控制。不要把未加访问控制的 1933 直接暴露到公网。

**Q13：拉取报 `no matching manifest`？**

`v0.4.23` 提供 linux/amd64 与 linux/arm64。到[标签页](https://xuanyuan.cloud/r/openviking/openviking/tags)核对架构。32 位 ARM 不在这两套清单里。

**Q14：备份怎么做？**

先 `docker compose stop openviking`，再打包宿主机目录 `/www/wwwroot/openviking/data`（含 `ov.conf` 和 `data/`）。恢复时停容器，把目录放回原处，再 `docker compose start openviking`。`ov.conf` 里有密钥，备份文件不要放到公开位置。

---

## 命令速查

```bash
docker pull docker.xuanyuan.run/openviking/openviking:v0.4.23

cd /www/wwwroot/openviking
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 openviking
curl -sS http://127.0.0.1:1933/health
curl -sS http://127.0.0.1:1933/ready

docker exec openviking ov health
docker compose restart openviking
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:1933/studio`。

---

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [openviking/openviking 镜像页](https://xuanyuan.cloud/zh/r/openviking/openviking) | [https://xuanyuan.cloud/zh/r/openviking/openviking](https://xuanyuan.cloud/zh/r/openviking/openviking) |
| [openviking/openviking 概览](https://xuanyuan.cloud/r/openviking/openviking) | [https://xuanyuan.cloud/r/openviking/openviking](https://xuanyuan.cloud/r/openviking/openviking) |
| [openviking/openviking 标签列表](https://xuanyuan.cloud/r/openviking/openviking/tags) | [https://xuanyuan.cloud/r/openviking/openviking/tags](https://xuanyuan.cloud/r/openviking/openviking/tags) |
| [Docker Hub · openviking/openviking](https://hub.docker.com/r/openviking/openviking) | [https://hub.docker.com/r/openviking/openviking](https://hub.docker.com/r/openviking/openviking) |
| [Docker Hub 标签](https://hub.docker.com/r/openviking/openviking/tags) | [https://hub.docker.com/r/openviking/openviking/tags](https://hub.docker.com/r/openviking/openviking/tags) |
| [GitHub · volcengine/OpenViking](https://github.com/volcengine/OpenViking) | [https://github.com/volcengine/OpenViking](https://github.com/volcengine/OpenViking) |
| [Release v0.4.23](https://github.com/volcengine/OpenViking/releases/tag/v0.4.23) | [https://github.com/volcengine/OpenViking/releases/tag/v0.4.23](https://github.com/volcengine/OpenViking/releases/tag/v0.4.23) |
| [部署文档](https://docs.openviking.ai/en/guides/03-deployment) | [https://docs.openviking.ai/en/guides/03-deployment](https://docs.openviking.ai/en/guides/03-deployment) |
| [模型配置](https://docs.openviking.ai/en/guides/01-configuration) | [https://docs.openviking.ai/en/guides/01-configuration](https://docs.openviking.ai/en/guides/01-configuration) |
| [火山引擎模型购买说明](https://docs.openviking.ai/zh/guides/02-volcengine-purchase-guide) | [https://docs.openviking.ai/zh/guides/02-volcengine-purchase-guide](https://docs.openviking.ai/zh/guides/02-volcengine-purchase-guide) |
| [开通 Doubao-Embedding-Vision](https://console.volcengine.com/ark/region:cn-beijing/model/detail?name=doubao-embedding-vision) | [https://console.volcengine.com/ark/region:cn-beijing/model/detail?name=doubao-embedding-vision](https://console.volcengine.com/ark/region:cn-beijing/model/detail?name=doubao-embedding-vision) |
| [VikingBot 配置](https://docs.openviking.ai/en/guides/17-vikingbot) | [https://docs.openviking.ai/en/guides/17-vikingbot](https://docs.openviking.ai/en/guides/17-vikingbot) |
| [认证](https://docs.openviking.ai/en/guides/04-authentication) | [https://docs.openviking.ai/en/guides/04-authentication](https://docs.openviking.ai/en/guides/04-authentication) |
| [导入与检索快速开始](https://docs.openviking.ai/en/getting-started/02-quickstart) | [https://docs.openviking.ai/en/getting-started/02-quickstart](https://docs.openviking.ai/en/getting-started/02-quickstart) |
| [OpenViking 官网](https://openviking.ai) | [https://openviking.ai](https://openviking.ai) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/openviking-docker-deploy


