# Docker 部署 ReMe：轻松搭建 AI Agent 记忆管理平台

![Docker 部署 ReMe：轻松搭建 AI Agent 记忆管理平台](https://imgs.xuanyuan.cloud/docker/blog/remo/remo.webp)

*分类: Docker部署教程 | 标签: ReMe,agentscope-ai/reme,Docker,轩辕镜像,AI Agent,记忆管理,私有化部署,部署教程 | 发布时间: 2026-10-31 19:55:18*

> ReMe 是一款面向 AI Agent 的开源记忆工具，旨在统一管理对话、资料和长期知识，并通过本地 Markdown 工作区简化记忆的查看、检索与复用。本文将介绍如何通过 Docker 快速部署 ReMe，搭建智能体记忆管理平台，帮助开发者更高效地管理可检查、可备份的本地记忆，适合 AI Agent 开发及多个助手共用同一工作区等场景。

## ReMe 是什么

ReMe 是 AgentScope 开源的智能体记忆工具，全称 Remember Me, Refine Me。对话、资料和长期知识放在同一份本地工作区里，供智能体检索，并在后面的任务里继续使用。

这个名字有两个出处，容易混。一篇论文叫《Remember Me, Refine Me: A Dynamic Procedural Memory Framework for Experience-Driven Agent Evolution》，2026 年被 ACL Findings 收录，讲的是经验驱动的程序记忆怎么组织；ReMe 是同一套思路的工程实现，也就是本文要部署的这个服务。中文资料里说的「ReMe 记忆框架」，多数指的是前一篇，要落到能跑的部署，看的是后一个。

与只靠当次提示词，或把文档切块后做向量检索不同，ReMe 把要长期留下的内容写成普通 Markdown。人和智能体都能打开这些文件查看、修改和备份。查找时按相关段落和笔记之间的链接取回内容。

## ReMe 能做什么

- **留成 Markdown 文件**：对话和资料整理成可以打开、修改和检索的笔记。
- **分成日记和长期知识**：当日内容进日记，稳定的事实、偏好和流程进长期知识。
- **按段落检索**：用关键词和笔记链接定位相关段落。
- **多个智能体共用一份工作区**：个人助理和编程智能体读写同一套本地记忆。
- **在浏览器里查看**：Studio 用来浏览、预览和编辑这些文件。

## 为什么要使用 ReMe

智能体接着做一件事时，偏好和做过的步骤常常还在上一段聊天里。资料、经验和操作步骤分开存放，下一次对不上，也看不出读到的是哪一篇。

ReMe 把这些留成工作区里的 Markdown。索引可以从文件重建，文件本身仍然是长期内容。做智能体，或要让多个助手共用一份可以打开、可以备份的记忆时，可以用它。

## 使用 Docker 部署 ReMe

ReMe 可以用 Docker 启动，本机不必先安装 Python 和 Node.js。开始之前，先准备好 Docker。文件读写和关键词检索在默认配置下不需要模型凭证。需要从对话里自动整理长期记忆，或使用 Studio 里的 Agent 对话时，再准备模型服务的访问凭证。

接下来用 Docker Compose 写好工作目录和运行参数，启动服务，并确认 Studio 与接口可以访问。

## 环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（本文命令按 Ubuntu 目录书写）；macOS 把 `/www/wwwroot/reme` 换成 `~/docker/reme` |
| Docker | Engine + **Compose V2**（`docker compose`）。官方 Compose 示例要求 **2.24.0** 或更新 |
| 架构 | **0.4.2.1** 同时提供 **linux/amd64** 与 **linux/arm64** |
| 内存 | 镜像不打包大模型。占用随工作区增长 |
| 磁盘 | 记忆文件写在挂载目录里，随写入增长 |
| 端口 | 宿主机 **2333** → 容器 **2333**。局域网浏览器访问 `http://192.168.1.35:2333`，IP 换成你的 |
| 工作目录 | `/www/wwwroot/reme`，数据目录 `data/` 挂到容器 `/data` |
| 运行用户 | 与 `data/` 属主一致。本文写入 Compose 时取当前用户的 UID、GID |
| 模型 | 默认关闭向量检索。文件操作和 BM25 检索不需要密钥。自动整理记忆和 Agent 对话需要模型凭证 |

HTTP 接口可以写入和删除，没有登录。本文把宿主机 **2333** 发布出来，局域网浏览器才能打开 Studio。不要把 **2333** 直接暴露到公网。官方示例把端口绑在 **127.0.0.1**，那样局域网会连接被拒绝，见「局域网里的电脑打不开页面」。

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=reme-docker-deploy)。

## 标签怎么选

当前稳定版是 GitHub Release **v0.4.2.1**（2026-10-27）。镜像仓库里对应的标签是 **`0.4.2.1`**，没有 `v` 前缀。`latest` 会在后续稳定版发布时改指向，`main` 跟随主分支检查通过后的构建。这两枚标签都不写入本文命令。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`0.4.2.1`** | 稳定版 v0.4.2.1 的包版本。linux/amd64 与 linux/arm64 | **是** |
| `latest` | 稳定版发布时更新。当前与 `0.4.2.1` 指向同一清单，之后会变 | 否 |
| `main` | 主分支检查通过后发布，不是某一次 Release | 否 |
| `v0.4.2.1` | GHCR 上没有这枚标签 | 否 |

发布镜像在 GHCR，没有 Docker Hub 官方仓。详情见 [ghcr.io/agentscope-ai/reme](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?xy_from=reme-docker-deploy)，拉取说明见 [拉取页](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?tab=pull&xy_from=reme-docker-deploy)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=reme-docker-deploy) **加速拉取**。把 `***` 换成个人中心的 GHCR 专属前缀，配置见 [GHCR 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/ghcr?xy_from=reme-docker-deploy)。在 `***-ghcr.xuanyuan.run` 上执行 `docker login` 时，不要填写 GitHub PAT。

```bash
docker pull ***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1
```

Ubuntu 24.04 实测：

```text
0.4.2.1: Pulling from agentscope-ai/reme
4f4fb700ef54: Pull complete
c870b0de8008: Pull complete
11422d7ca1a4: Pull complete
dd0c1cfa4fdf: Pull complete
8ebbc9227530: Pull complete
632cb32d8745: Pull complete
a65263729b7f: Pull complete
479c0b79ca09: Pull complete
44136fa355b3: Download complete
bd20a484ae30: Download complete
df56b91934ee: Download complete
Digest: sha256:49fc19123c54651e87b49673129262d9b27d058741b51fa22b7a5c9fd1192d8e
Status: Downloaded newer image for ***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1
***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1
```

## Docker Compose 部署

容器里的工作区固定是 `/data`。这里面有源对话、资料、日记、长期记忆，以及可以重建的 `metadata/`。只挂载 `metadata/` 留不住源记忆。宿主机目录要事先建好，并且让 Compose 里的运行用户可以写。

镜像默认以 UID、GID **1000** 运行。当前用户不是 1000 时，下面的 Compose 会写成你的 UID 和 GID。换一台机器或换一个用户时，重新生成这份文件，使 `user` 与 `data/` 属主一致。

同一份 `data/` 只运行一个 ReMe 写入进程。已经用后面的 `docker run` 挂过这个目录时，先停掉那个容器，再执行 Compose。

1. 创建目录，并把属主交给当前用户：

```bash
sudo mkdir -p /www/wwwroot/reme/data
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/reme
```

macOS：

```bash
mkdir -p ~/docker/reme/data
cd ~/docker/reme
```

2. 写入 `.env`。文件操作和 BM25 检索保持这几行注释即可。需要 `auto_memory`、`auto_resource`、`auto_dream` 或 Studio 的 Agent 对话时，再去掉 `LLM_*` 三行的注释并填入自己的密钥。密钥只放在这个文件里，不要写进镜像构建参数。

```bash
cd /www/wwwroot/reme
cat > .env <<'EOF'
# 文件操作和 BM25 检索不需要模型凭证。
# 需要自动整理记忆或 Agent 对话时，去掉下面三行的注释并填写。
# LLM_API_KEY=
# LLM_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
# LLM_MODEL_NAME=qwen3.7-plus
EOF
```

官方示例里的模型名是 `qwen3.7-plus`，地址是阿里云百炼的兼容接口。换成别的 OpenAI 兼容服务时，只改这三项。

3. 写入 `compose.yaml`。`user` 在写入时取当前用户的 UID 和 GID。宿主机 **2333** 转到容器 **2333**。`REME_TIMEZONE` 设为 `Asia/Shanghai`。

```bash
cd /www/wwwroot/reme
cat > compose.yaml <<EOF
services:
  reme:
    image: ***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1
    container_name: reme
    user: "$(id -u):$(id -g)"
    ports:
      - "2333:2333"
    volumes:
      - ./data:/data
    environment:
      REME_HOST: 0.0.0.0
      REME_PORT: "2333"
      REME_WORKSPACE_DIR: /data
      REME_TIMEZONE: Asia/Shanghai
    env_file:
      - .env
    restart: unless-stopped
    stop_grace_period: 60s
EOF
```

4. 启动：

```bash
cd /www/wwwroot/reme
docker compose up -d
```

首次启动会创建网络。Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network reme_default Created
 ✔ Container reme       Started
```

5. 查看容器状态。健康检查有 **120** 秒启动宽限期。刚启动时可以是 `health: starting`。宽限期内还没通过，不表示这次部署失败。等状态变成 **healthy**，再做健康检查和打开页面。

```bash
cd /www/wwwroot/reme
docker compose ps
```

`ports` 为 `2333:2333` 时，Ubuntu 24.04 实测如下。这是改端口后重新启动的记录，创建时间 **13** 秒，起来 **7** 秒，状态仍是 `health: starting`。PORTS 为 `0.0.0.0:2333` 和 `[::]:2333`。若以 `127.0.0.1:` 开头，见「局域网里的电脑打不开页面」。

```text
NAME      IMAGE                                              COMMAND                  SERVICE   CREATED          STATUS                            PORTS
reme      ***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1   "/usr/bin/tini -- py…"   reme      13 seconds ago   Up 7 seconds (health: starting)   0.0.0.0:2333->2333/tcp, [::]:2333->2333/tcp
```

6. 看启动日志：

```bash
docker compose logs --tail 50 reme
```

Ubuntu 24.04 实测节选。向量回填被跳过，原因是 `embedding_disabled`。Uvicorn 在容器内监听 `0.0.0.0:2333`。日志里的 `host` 是 `127.0.0.1`，那是服务信息里的地址，不是 Docker 把端口只绑在本机。日志时间 **11:30** 是 UTC，当时宿主机是北京时间傍晚。

```text
reme  | 2026-10-31 11:30:20 | INFO | local_file_store.py:378 | _start_embedding_backfill | default: embedding backfill skipped: reason=embedding_disabled, elapsed=0.000s
reme  | 2026-10-31 11:30:20 | INFO | base_service.py:66 | lifespan | HttpService started: REME_SERVICE_INFO={"host": "127.0.0.1", "port": 2333}
reme  | 2026-10-31 11:30:20 | INFO | watch_changes.py:103 | execute | Watching: ['/data/daily', '/data/digest'] mode=awatch step=1000ms debounce=5000ms poll_delay=5000ms
reme  | INFO:     Application startup complete.
reme  | INFO:     Uvicorn running on http://0.0.0.0:2333 (Press CTRL+C to quit)
reme  | INFO:     127.0.0.1:46536 - "POST /health_check HTTP/1.1" 200 OK
```

工作区在宿主机上的大致结构如下。`metadata/` 可以重建，其余目录里的文件需要随 `data/` 一起备份。

```text
/www/wwwroot/reme/data/
├── session/          # 对话来源
├── resource/         # 外部原始资料
├── daily/            # 日记和当日整理结果
├── digest/           # 长期记忆：personal、procedure、wiki
└── metadata/         # 可重建的索引、图谱和缓存
```

## 确认服务可用

健康检查通过后，再打开浏览器或写入记忆。下面两条都访问本机 **2333**。`/health_check` 需要返回里的 `success` 为 `true`，并且 `metadata.health.healthy` 为 `true`。

```bash
curl -sS http://127.0.0.1:2333/health_check 
  -H 'Content-Type: application/json' 
  -d '{}'
```

Ubuntu 24.04 实测：

```text
{"answer":"✅ ReMe v0.4.2.1 - healthy","success":true,"metadata":{"health":{"version":"0.4.2.1","healthy":true,"components":{"embedding_store":{},"file_graph":{"default":{"is_started":true,"n_nodes":0,"n_edges":0,"n_pending":0,"memory":"0.00 MB"}},"file_store":{"default":{"is_started":true,"n_chunks":0,"n_chunks_with_embedding":0,"memory":"0.00 MB"}},"keyword_index":{"default":{"is_started":true,"n_docs":0,"vocab_size":0,"memory":"0.00 MB"}}}}}}
```

```bash
curl -sS http://127.0.0.1:2333/version 
  -H 'Content-Type: application/json' 
  -d '{}'
```

Ubuntu 24.04 实测：

```text
{"answer":"0.4.2.1","success":true,"metadata":{"version":"0.4.2.1"}}
```

也可以在容器里看同一项检查：

```bash
cd /www/wwwroot/reme
docker compose exec reme reme health_check
```

同一进程还在 `/mcp` 提供 MCP。智能体连接已经发布的 HTTP 或 MCP 地址。不要对同一份 `data/` 再启动第二个 ReMe。

## 写入一条记忆并检索

这条写入不需要模型密钥。`path` 相对工作区，没写 `.md` 时会自动补上。

1. 写入一条长期记忆：

```bash
curl -sS http://127.0.0.1:2333/write 
  -H 'Content-Type: application/json' 
  -d '{"path":"digest/wiki/quick-start-demo","name":"Quick Start Demo","description":"A first ReMe memory node","content":"# Quick Start Demo

ReMe stores agent memory as readable Markdown.
"}'
```

Ubuntu 24.04 实测：

```text
{"answer":"Wrote /data/digest/wiki/quick-start-demo.md (137 bytes)","success":true,"metadata":{}}
```

2. 在宿主机上看生成的文件：

```bash
sed -n '1,20p' /www/wwwroot/reme/data/digest/wiki/quick-start-demo.md
```

Ubuntu 24.04 实测：

```text
---
description: A first ReMe memory node
name: Quick Start Demo
---

# Quick Start Demo

ReMe stores agent memory as readable Markdown.
```

3. 检索：

```bash
curl -sS http://127.0.0.1:2333/search 
  -H 'Content-Type: application/json' 
  -d '{"query":"agent memory markdown","limit":5}'
```

Ubuntu 24.04 实测。命中 `digest/wiki/quick-start-demo.md` 第 **5** 到 **8** 行，关键词分数 **0.8630**。`counts` 里 `vector` 为 **0**，`keyword` 为 **1**。

```text
{"answer":"========== digest/wiki/quick-start-demo.md:5-8 [score=0.8630] ==========
# Quick Start Demo

ReMe stores agent memory as readable Markdown.","success":true,"metadata":{"results":[{"id":"abfdba3e56c878b5bd53995837d5e7a788bf80ee09d650ef24ef11189dddf2c9","text":"# Quick Start Demo

ReMe stores agent memory as readable Markdown.","metadata":{},"path":"digest/wiki/quick-start-demo.md","start_line":5,"end_line":8,"scores":{"keyword":0.8630462884902954,"score":0.8630462884902954}}],"link_expansion":{"digest/wiki/quick-start-demo.md":{"outlinks":[],"inlinks":[]}},"counts":{"vector":0,"keyword":1,"returned":1,"hybrid":false}}}
```

4. 按路径读回正文：

```bash
curl -sS http://127.0.0.1:2333/read 
  -H 'Content-Type: application/json' 
  -d '{"path":"digest/wiki/quick-start-demo","start_line":1,"end_line":20}'
```

Ubuntu 24.04 实测：

```text
{"answer":"---
description: A first ReMe memory node
name: Quick Start Demo
---

# Quick Start Demo

ReMe stores agent memory as readable Markdown.","success":true,"metadata":{}}
```

## 打开 ReMe Studio

`docker compose ps` 变为 **healthy** 后，在局域网浏览器打开。下面的 IP 是实测机器，换成你的。服务器本机用 `http://127.0.0.1:2333`。

```text
http://192.168.1.35:2333
```

中文界面左上角是 ReMe Studio **v0.1.2**，这是前端版本。后端版本在「设置」里，实测为 **v0.4.2.1**。中间一句是「从左侧打开 Markdown，或者开始一段 Agent 对话。」按钮是「开始对话」，下面写着「文件保留在你的本地工作区」。导航器底部绿点旁边是 `192.168.1.35:2333`。

![ReMe Studio 首页：左侧 digest/wiki，中间开始对话，底部绿点为 192.168.1.35:2333](https://imgs.xuanyuan.cloud/docker/blog/remo/remo-1.webp)

左侧四个入口：

| 入口 | 作用 |
|------|------|
| 工作区 | 浏览工作区里的文件。实测这里能看到 `digest` / `wiki` |
| 日记 | 查看日记目录 |
| 知识库 | 查看长期记忆里的 `wiki`、`personal`、`procedure` |
| 对话 | 与 ReMe Agent 对话。需要 `.env` 里的模型密钥。本次没有填写，所以没有进入这一页 |

在「工作区」里展开 `digest`、`wiki`，打开 `quick-start-demo.md`。页眉路径是 `digest/wiki/quick-start-demo.md`，右上角当前是「预览」。摘要区里 `description` 为 `A first ReMe memory node`，`name` 为 `Quick Start Demo`。正文标题是 Quick Start Demo，下面一句是 `ReMe stores agent memory as readable Markdown.`

![ReMe Studio 预览 quick-start-demo.md：frontmatter 的 description、name 与正文](https://imgs.xuanyuan.cloud/docker/blog/remo/remo-2.webp)

点右上角齿轮打开「设置」，进入「状态」。实测本地记忆服务地址是 `http://192.168.1.35:2333`，标记为「服务运行正常」，后端 **v0.4.2.1**。进程内存 **142.27 MiB**，估计内存 **15.10 KiB**，健康组件 **3/3**。文件图谱是 **1** 个节点、**0** 条边。文件存储是 **1** 个分块，已生成向量 **0**。启动日志里分块还是 0，这是写入这篇笔记之前的数字。

![ReMe 设置的状态页：服务运行正常，后端 v0.4.2.1，健康组件 3/3](https://imgs.xuanyuan.cloud/docker/blog/remo/remo-3.webp)

打开「索引」。页面写的是「基于已摄取的内容重建 BM25 和 Embedding 索引。」点「重建索引」后，实测返回：

```text
Reindexed scope=all: bm25=1, embedding=0, tag=0
```

这篇笔记没有链接，所以文件图谱仍然是 1 个节点、0 条边。

![ReMe 设置的索引页：重建索引结果 bm25=1，embedding=0，tag=0](https://imgs.xuanyuan.cloud/docker/blog/remo/remo-4.webp)

## 接入 Agent：MCP 与 DeepSeek Harness 插件

Studio 是给人看的。要让智能体自己检索、自己记录，就得接一个入口。ReMe 把这层能力做在同一个进程里，不需要另起服务。

### 三种接入方式

三种方式读的都是这份 `data/`，区别在谁发起调用、谁负责写入。

| 方式 | 入口 | 适合 |
|------|------|------|
| 只开 Studio | 浏览器打开 `http://服务器IP:2333` | 人自己浏览、编辑、手动写一条记忆 |
| HTTP / MCP | `http://服务器IP:2333/mcp` | 支持 MCP 的宿主，或自己的脚本、后端 |
| DeepSeek Harness 插件 | 在 DSH 里装 `@agentscope-ai/reme-dsh-plugin` | 想让 Agent 每轮自动检索、自动把对话记进日记 |

还没有起 DeepSeek Harness 的，先看同系列的三篇部署文：[moelin 镜像](https://xuanyuan.cloud/blog/deepseek-harness-moelin-docker-deploy?xy_from=reme-docker-deploy)、[smanx 镜像](https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy?xy_from=reme-docker-deploy)、[runzhliu 镜像](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy?xy_from=reme-docker-deploy)。三套跑的都是上游 `@deepseek-ai/dsh`，选哪套只看登录方式和端口习惯。

### MCP 地址与工具

MCP 走 streamable HTTP，路径固定 `/mcp`，和 Studio 共用一个 **2333**。

```text
http://127.0.0.1:2333/mcp
```

常用工具有 `search`、`read`、`traverse`、`list`、`auto_memory`、`proactive_read`。宿主如果只需要读，可以用 `service.jobs` 白名单只放只读工具，把写入动作单独配置。这个白名单里要保留 `health_check`，否则 Docker 探针会失败，容器一直显示 unhealthy。

### 在 DeepSeek Harness 里装记忆插件

DeepSeek Harness（下文写 DSH）是 DeepSeek 开源的 AI Agent 运行时。ReMe 在 DSH 的插件目录里以「精选」收录，维护者是 agentscope-ai，许可证 Apache-2.0。

装好之后有三件事发生变化：新会话会带上一条「怎么用长期记忆」的指引；多出一个只读工具 `reme_search`；完成的对话按批次交给 `auto_memory`，隔天由 `auto_dream` 整理进 `digest/`。

有一点要先说清：插件不会把历史记忆预先塞进上下文。它注入的是使用指引，真正取回内容仍要 Agent 主动调 `reme_search`。这也是它能接一个大工作区却不把上下文撑爆的原因。

本节按 ReMe 官方接入文档和 DSH 插件目录页整理，命令与默认值以官方为准；本文的实测范围只到 ReMe 服务本身，不含插件界面。

装之前先确认三件事：

1. ReMe 服务已经起来，`/health_check` 返回 `success: true`，见「确认服务可用」。
2. DSH 版本在支持范围内：`0.1.7-rc.2`、`0.2.0-rc.2`、`0.2.1-alpha.2`、`0.2.1-alpha.4`、`0.2.1-rc.2`、`0.2.2-alpha.2`。peer 范围还覆盖兼容的 `0.1.x`、`0.2.x` 正式版，**不包含 `0.3.x`**。
3. Node.js 是 `^22.19.0` 或 `>=24.0.0`。DSH `0.2.2` 需要 Node 24.9 以上。

还有一项容易漏：ReMe 配置里要保留 `search`、`auto_memory`、`auto_dream` 三个 Job。镜像默认配置带这三个；如果按官方 Docker 文档用 `REM_CONFIG` 改过 `service.jobs` 白名单，别把它们删掉。

在 DSH 终端里装。用 Web 界面时带 `--profile web`：

```bash
dsh plugin --profile web add @agentscope-ai/reme-dsh-plugin
```

DSH 插件目录页给的是另一条，从 GitHub 仓库解析：

```bash
dsh plugin add github:agentscope-ai/ReMe
```

两条指向同一个插件，区别只在来源：一条走 npm 上的发布版本，一条从 GitHub 仓库解析。目录页这条适合想按源码过一遍的人，也能按官方提示固定 commit，写成 `dsh plugin add github:agentscope-ai/ReMe#<commit>`。想跟着发布版本走，用第一条。

新版 `@agentscope-ai/reme-dsh-plugin` 取代旧的 `@agentscope-ai/reme/dsh` 组合包。装新的之前先移除旧的。同一份 DSH patch 里重复挂同一个包，会报 `remeMemory` 服务冲突。

插件以当前 `dsh` 进程的权限运行，安装过程可能执行代码。装之前看一眼仓库和许可证，内网环境里按需固定 commit。

### 把插件指到这台 ReMe

日常只需要改一处：插件设置里的「服务地址」，配置键 `endpoint`，默认 `http://127.0.0.1:2333`。

这个默认值和本文 Compose 发布的端口一致。DSH 和 ReMe 跑在同一台机器、共享同一套网络时，什么都不用改。

两种情况要改：

| 情况 | `endpoint` 怎么写 |
|------|-------------------|
| DSH 在容器里，ReMe 在宿主机 | 用宿主机在容器网络里的地址，例如 `http://host.docker.internal:2333`。Linux 上要给 DSH 容器加 `extra_hosts: ["host.docker.internal:host-gateway"]` |
| DSH 和 ReMe 在两台机器 | 用浏览器能打开的地址，例如 `http://192.168.1.35:2333`。写 `127.0.0.1` 只会指向 DSH 自己那台 |

`endpoint` 只接受绝对 HTTP(S) 地址，凭据、查询参数和片段都不能拼进 URL。要给自建网关加 Bearer 令牌，用 `authToken`，它只在 profile 配置里生效，表单里不显示。ReMe 的 HTTP 接口本身没有认证，`authToken` 是给前面那层网关用的，不是 ReMe 的用户体系。

跨机器接入时，官方接入文档还要求 ReMe 允许 DSH 页面所在浏览器的 Origin。这一步在局域网里通常不需要动，改成公网域名时先检查。不要把 **2333** 直接暴露到公网。

### 插件设置项

装完通常只动两项：服务地址和指引语言。其余保持默认。

| 设置 | 配置键 | 默认值 | 说明 |
|------|--------|--------|------|
| 服务地址 | `endpoint` | `http://127.0.0.1:2333` | 见上一小节 |
| 指引语言 | `language` | `en` | 中文环境改成 `zh`。改动只影响之后新建的会话 |
| 搜索条数 | `searchLimit` | `5` | `reme_search` 没传 `limit` 时的上限，1–50 |
| 搜索超时 | `requestTimeoutMs` | `10000` | 单位毫秒，1,000–120,000 |
| 自动记录对话 | `autoMemoryEnabled` | `true` | 关掉就不再捕获完成的回合 |
| 提交间隔 | `autoMemoryInterval` | `5` | 每完成几轮提交一次，1–1,000 |
| 只看根 Agent | `rootAgentsOnly` | `true` | 子 Agent 不注入指引，也不记录 |
| 自动整理 | `autoDreamEnabled` | `true` | 是否按计划调 `auto_dream` |
| 整理计划 | `dreamCron` | `0 23 * * *` | 五段 cron，按 `timezone` 解释 |
| 时区 | `timezone` | `Asia/Shanghai` | 每日批次和 cron 都按它算 |
| 后台超时 | `backgroundTimeoutMs` | `3600000` | `auto_memory` 与 `auto_dream` 的等待上限，单位毫秒 |

`language` 默认是 `en`，中文界面里也一样。新会话注入的指引因此是英文，想让它用中文就把这项改成 `zh`。

### ReMe Status 六个视图

设置里的「ReMe Status」是排查入口。页面可见时每 **5** 秒只刷新插件侧的运行时计数，服务诊断要手动刷新一次。

| 视图 | 看什么 |
|------|--------|
| 总览 | 连接状态、ReMe 版本、`endpoint`、进程内存、健康组件 |
| 自动记忆 | 活跃会话、待处理回合、运行中任务、排队任务 |
| 记忆整理 | 下次整理时间、cron、时区，以及「立即整理」按钮 |
| 组件 | 文件图谱、文件存储、关键词索引、向量存储 |
| 日记 | 工作区 `daily/` 下的文件 |
| 个人知识库 | `digest/` 里整理后的长期知识 |

绿色的「已连接」只说明健康检查通过，不代表每个组件都配好了。向量存储显示「未配置」时，关键词检索照旧能用，这和本文默认关闭 embedding 是同一件事。「需要处理」「未启动」才要去查 ReMe 日志，而且不要为了修索引去删源 Markdown。

### 自动整理只留一个调度方

`auto_dream` 把 `daily/` 整理成 `digest/`。这件事有两个地方能发起：

- 插件侧：`dreamCron`，默认每天 23:00。
- ReMe 侧：服务自己的 `jobs.dream_cron`。

两边只开一个。用插件调度，就在 ReMe 的 jobs 配置里关掉 `dream_cron`；用 ReMe 调度，就把插件的 `autoDreamEnabled` 设为 `false`。多个宿主共用一台 ReMe 时尤其要注意，否则同一天会被整理两遍。

插件和 Docker 部署的边界也要划清：**一个工作区只能有一个 ReMe 写入进程**。插件自带「环境管理」页，能在里面 `pip install reme-ai[core]` 再 `reme start` 起一个本地 ReMe。已经用 Docker 跑着这份 `data/` 时，别在插件里再起一个指向同一目录，两个进程会同时写。要么让插件连 Docker 这份，要么把插件的工作区换到别处。

### 确认它真的在记

1. 打开「ReMe Status → 总览」，确认是「已连接」。
2. 新建一个会话，在消息详情里展开 `reme-memory`，看指引有没有注入。同一会话只注入一次。
3. 让它查历史事实时，明确要求调用 `reme_search` 并列出 `daily/`、`digest/` 里的来源路径。
4. 聊几轮后到「自动记忆」看批次是否完成，再到「日记」确认文件落盘。
5. 想立刻验证整理结果，在「记忆整理」点「立即整理」，不必等到 23:00。

`reme_search` 查不到内容时返回 `No relevant memory found.`，服务出错时返回 `ReMe search failed: ...`。前者是确实没有相关记忆，后者是没连上，排查方向不同。

## 备选：docker run

没有 Compose 时，用一条 `docker run` 启动。数据目录与 Compose 相同。若 Compose 已经占用容器名 `reme`、端口 **2333** 或这份 `data/`，先在 `/www/wwwroot/reme` 执行 `docker compose down`。`down` 会删掉 Compose 创建的容器，不会删除 `data/`。

1. 创建目录并交给当前用户。目录已经存在且属主正确时，跳过这一步。

```bash
sudo mkdir -p /www/wwwroot/reme/data
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/reme
```

2. 启动容器：

```bash
docker run -d --name reme 
  --user "$(id -u):$(id -g)" 
  -p 2333:2333 
  --mount type=bind,source=/www/wwwroot/reme/data,target=/data 
  -e REME_HOST=0.0.0.0 
  -e REME_PORT=2333 
  -e REME_WORKSPACE_DIR=/data 
  -e REME_TIMEZONE=Asia/Shanghai 
  --restart unless-stopped 
  ***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1
```

已经填写模型凭证时，在镜像名之前加上 `--env-file /www/wwwroot/reme/.env`。

3. 查看状态，再按「确认服务可用」做健康检查：

```bash
docker ps --filter name=reme
docker logs --tail 50 reme
```

停掉这个容器：

```bash
docker stop reme
docker rm reme
```

`docker rm` 不删除 `/www/wwwroot/reme/data`。

## 升级

升级前停止写入，并先复制整份工作区和 `compose.yaml`、`.env`。改 `compose.yaml` 里的镜像标签后，再拉取新标签并启动。下面的备份目录名带有当天日期。

```bash
cd /www/wwwroot/reme
docker compose stop
cp -a data "data-backup-$(date +%Y%m%d)"
docker compose pull
docker compose up -d
docker compose exec reme reme health_check
```

`restart: unless-stopped` 只在进程退出后重启。健康检查未通过本身不会触发这一种重启。

接了 DSH 插件时，停服的这段时间里，插件提交不出去的回合会留在自己的队列里重试，服务恢复后继续排空，不用手工补。队列默认在 `$DSH_HOME/reme-memory/outbox`，没设 `DSH_HOME` 时是 `~/.dsh/reme-memory/outbox`。`.lock` 和排队文件都不要删。

索引异常时，不要为了修复索引去删除记忆文件。源文件仍在 `data/` 里。搜索索引可以从已收录的片段重建。

## 常见问题

### 拉取提示找不到 `v0.4.2.1`

GHCR 上的版本标签是 `0.4.2.1`。把命令和 `compose.yaml` 里的标签改成不带 `v` 的这一枚，再拉取。

### `data/` 无法写入

先看 `docker compose logs reme`。若其中是工作区无法写入，停掉容器，确认 `compose.yaml` 的 `user` 与 `data/` 属主一致，再执行：

```bash
sudo chown -R "$(id -u)":"$(id -g)" /www/wwwroot/reme/data
cd /www/wwwroot/reme
docker compose up -d
```

属主改好后仍无法写入，再把日志里的报错保留下来排查，不要先删 `data/`。

### 检索没有结果

写入刚结束时，监视进程可能还没有把这篇 Markdown 收进索引。再执行一次同一条 `/search`。确认文件已经出现在 `/www/wwwroot/reme/data/digest/wiki/quick-start-demo.md`。不要删掉这篇文件来换一次索引。

### 打开 Studio 很慢，或者一开始连不上

启动宽限期是 **120** 秒。先看 `docker compose ps`。宽限期过后，`/health_check` 仍不是 `success: true` 且 `metadata.health.healthy: true`，再查 `docker compose logs reme`。

### 局域网里的电脑打不开页面

浏览器打开 `http://192.168.1.35:2333` 时，Ubuntu 24.04 实测出现过：

```text
无法访问此网站
192.168.1.35 拒绝了我们的连接请求。
ERR_CONNECTION_REFUSED
```

当时 `docker compose ps` 的 PORTS 是 `127.0.0.1:2333->2333/tcp`，状态已经是 **healthy**（起来约 **49** 秒）。本机 `curl http://127.0.0.1:2333/health_check` 可以成功，局域网不行。把 `compose.yaml` 的端口改成 `"2333:2333"`，再执行 `docker compose up -d`。改完后的 PORTS 见「Docker Compose 部署」。不要把 **2333** 直接暴露到公网。

### 「对话」没有回复

「工作区」「日记」「知识库」不需要模型。「对话」需要 `.env` 里的 `LLM_API_KEY`、`LLM_BASE_URL` 和 `LLM_MODEL_NAME`。改完 `.env` 后执行 `docker compose up -d`，让容器读到新的环境变量。密钥不要写进页面或镜像层。本次实测没有填写密钥，所以没有进入「对话」。

### 插件显示已连接，Agent 却不查记忆

绿色「已连接」只说明健康检查通过，没连上时这一项不会是已连接。Agent 不查，通常是两种情况：它没有调 `reme_search`，或者工作区里确实没有相关记忆。

在会话里直接要求它检索，并让它列出命中的 `daily/`、`digest/` 路径。查不到时会返回 `No relevant memory found.`，那是工作区里确实没有相关内容，不是插件坏了。

### 注入的指引是英文

`language` 默认 `en`，中文界面也不会自动改成中文。把它改成 `zh` 后，只有新建的会话才生效，已经在跑的老会话不会重写。

### 聊完了，「日记」里没有新文件

按顺序看三处：

1. 插件设置里 `autoMemoryEnabled` 是否为 `true`。
2. 已经完成的回合够不够 `autoMemoryInterval`（默认 **5** 轮）。
3. 「ReMe Status → 自动记忆」里，批次是「空闲」「运行中」还是「失败」。失败会显示最近的错误。

`auto_memory` 和 Studio 的「对话」一样要模型凭证。`.env` 里没填 `LLM_*` 时，文件操作和检索能用，自动记忆写不进去。

### 插件里也装了一个 ReMe，会和 Docker 这份冲突吗

会。插件「环境管理」页能一键装 `reme-ai[core]` 并 `reme start`，起的是第二个写入进程。同一份工作区只能有一个。已经用 Docker 跑着，就把 `endpoint` 指向 Docker 那份，别在插件里再起一个；真要用插件自带的服务，就换一个工作区目录。

### 改了服务地址还是连不上

先确认 `endpoint` 是浏览器能打开的地址，不是 `127.0.0.1`。确认 ReMe 的 **2333** 对 DSH 所在网络可达，容器间用服务名或 `host.docker.internal`。跨机器时再检查 ReMe 是否允许 DSH 页面的 Origin。

地址改过之后，之前积压的批次仍然发往**捕获时**记录的地址，不会跟着新地址走。排空旧队列前不要反复改地址。

### ReMe 和 Mem0 是一类东西吗

定位不同，不好换着用。Mem0 走的是「自动抽取成记忆条目，再按向量取回」，记忆存在库里，一般通过 SDK/API 读写；ReMe 把记忆写成本地 Markdown 文件，人和 Agent 都能直接打开、改、备份，检索默认走 BM25 加笔记链接，向量是可选开关。

要「改一行的功夫就能改记忆」、要能整目录拷走或进 `git`，选 ReMe；要接进已有应用、只想要一次 SDK 调用，Mem0 那条路更短。本文没有把两者放到同一份语料上做对比，不给性能结论。

### 记忆内容会被发到外部模型吗

会，但只在需要模型的那几步。`auto_memory`、`auto_resource`、`auto_dream` 和 Studio 里的「对话」都要用 `.env` 中 `LLM_*` 指向的模型服务，对话内容随请求发出去。文件读写、BM25 检索、Studio 的文件浏览不经过模型。

要求内容不出内网，就把 `LLM_BASE_URL` 指向内网模型服务；或者在 `.env` 里不填 `LLM_*`，代价是自动整理用不了，记忆只能手动写。

### 向量检索

默认关闭 embedding。Ubuntu 24.04 实测日志写着 `embedding backfill skipped: reason=embedding_disabled`，检索结果里 `counts.vector` 为 **0**。文件操作和 BM25 检索不需要嵌入模型。本文不修改这项默认值。

## 命令速查

Compose 在 `/www/wwwroot/reme` 下执行。把 `***` 换成个人中心的 GHCR 专属前缀。

```bash
docker pull ***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1
docker compose up -d
docker compose ps
docker compose logs --tail 50 reme
docker compose exec reme reme health_check
curl -sS http://127.0.0.1:2333/version -H 'Content-Type: application/json' -d '{}'
docker compose stop
docker compose pull
docker compose up -d
```

无 Compose 时：

```bash
docker run -d --name reme 
  --user "$(id -u):$(id -g)" 
  -p 2333:2333 
  --mount type=bind,source=/www/wwwroot/reme/data,target=/data 
  -e REME_HOST=0.0.0.0 
  -e REME_PORT=2333 
  -e REME_WORKSPACE_DIR=/data 
  -e REME_TIMEZONE=Asia/Shanghai 
  --restart unless-stopped 
  ***-ghcr.xuanyuan.run/agentscope-ai/reme:0.4.2.1
docker logs --tail 50 reme
docker stop reme && docker rm reme
```

接 DeepSeek Harness 时，在 DSH 终端执行：

```bash
dsh plugin --profile web add @agentscope-ai/reme-dsh-plugin
```

装完后，同机部署把插件设置里的服务地址保留为 `http://127.0.0.1:2333`；跨机器改成 DSH 能访问到的 `http://服务器IP:2333`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [ghcr.io/agentscope-ai/reme 镜像页](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?xy_from=reme-docker-deploy) | [https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?xy_from=reme-docker-deploy) |
| [ghcr.io/agentscope-ai/reme 拉取页](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?tab=pull&xy_from=reme-docker-deploy) | [https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?tab=pull](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?tab=pull&xy_from=reme-docker-deploy) |
| [GHCR 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/ghcr?xy_from=reme-docker-deploy) | [https://xuanyuan.cloud/usage/mirror-tutorial/ghcr](https://xuanyuan.cloud/usage/mirror-tutorial/ghcr?xy_from=reme-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=reme-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=reme-docker-deploy) |
| [GitHub · agentscope-ai/ReMe](https://github.com/agentscope-ai/ReMe) | [https://github.com/agentscope-ai/ReMe](https://github.com/agentscope-ai/ReMe) |
| [GitHub Release v0.4.2.1](https://github.com/agentscope-ai/ReMe/releases/tag/v0.4.2.1) | [https://github.com/agentscope-ai/ReMe/releases/tag/v0.4.2.1](https://github.com/agentscope-ai/ReMe/releases/tag/v0.4.2.1) |
| [GHCR 包 reme](https://github.com/agentscope-ai/ReMe/pkgs/container/reme) | [https://github.com/agentscope-ai/ReMe/pkgs/container/reme](https://github.com/agentscope-ai/ReMe/pkgs/container/reme) |
| [ReMe 文档](https://reme.agentscope.io/) | [https://reme.agentscope.io/](https://reme.agentscope.io/) |
| [Docker 部署（官方）](https://reme.agentscope.io/zh/docker) | [https://reme.agentscope.io/zh/docker](https://reme.agentscope.io/zh/docker) |
| [ReMe Studio（官方）](https://reme.agentscope.io/zh/workspace/studio) | [https://reme.agentscope.io/zh/workspace/studio](https://reme.agentscope.io/zh/workspace/studio) |
| [Agent 集成（官方）](https://reme.agentscope.io/zh/integrations) | [https://reme.agentscope.io/zh/integrations](https://reme.agentscope.io/zh/integrations) |
| [ReMe 的 DeepSeek Harness 接入（官方）](https://reme.agentscope.io/zh/integrations/dsh) | [https://reme.agentscope.io/zh/integrations/dsh](https://reme.agentscope.io/zh/integrations/dsh) |
| [DSH 插件目录页 · ReMe](https://deepseek-harness-plugin.com/zh-CN/plugins/reme/) | [https://deepseek-harness-plugin.com/zh-CN/plugins/reme/](https://deepseek-harness-plugin.com/zh-CN/plugins/reme/) |
| [npm · @agentscope-ai/reme-dsh-plugin](https://www.npmjs.com/package/@agentscope-ai/reme-dsh-plugin) | [https://www.npmjs.com/package/@agentscope-ai/reme-dsh-plugin](https://www.npmjs.com/package/@agentscope-ai/reme-dsh-plugin) |
| [DeepSeek Harness 部署文（moelin 镜像）](https://xuanyuan.cloud/blog/deepseek-harness-moelin-docker-deploy?xy_from=reme-docker-deploy) | [https://xuanyuan.cloud/blog/deepseek-harness-moelin-docker-deploy](https://xuanyuan.cloud/blog/deepseek-harness-moelin-docker-deploy?xy_from=reme-docker-deploy) |
| [DeepSeek Harness 部署文（smanx 镜像）](https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy?xy_from=reme-docker-deploy) | [https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy](https://xuanyuan.cloud/blog/deepseek-harness-smanx-docker-deploy?xy_from=reme-docker-deploy) |
| [DeepSeek Harness 部署文（runzhliu 镜像）](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy?xy_from=reme-docker-deploy) | [https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy](https://xuanyuan.cloud/blog/deepseek-harness-docker-deploy?xy_from=reme-docker-deploy) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/reme-docker-deploy?xy_from=reme-docker-deploy)

*本文基于 [ghcr.io/agentscope-ai/reme:0.4.2.1](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?xy_from=reme-docker-deploy)，以 **0.4.2.1** 版本实测，测试平台 **Ubuntu 24.04** Linux。*


