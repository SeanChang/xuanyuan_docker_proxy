# Docker 部署 ReMe：轻松搭建 AI Agent 记忆管理平台

![Docker 部署 ReMe：轻松搭建 AI Agent 记忆管理平台](https://imgs.xuanyuan.cloud/docker/blog/remo/remo.webp)

*分类: Docker部署教程 | 标签: ReMe,agentscope-ai/reme,Docker,轩辕镜像,AI Agent,记忆管理,私有化部署,部署教程 | 发布时间: 2026-10-31 19:55:18*

> ReMe 是一款面向 AI Agent 的开源记忆工具，旨在统一管理对话、资料和长期知识，并通过本地 Markdown 工作区简化记忆的查看、检索与复用。本文将介绍如何通过 Docker 快速部署 ReMe，搭建智能体记忆管理平台，帮助开发者更高效地管理可检查、可备份的本地记忆，适合 AI Agent 开发及多个助手共用同一工作区等场景。

## ReMe 是什么

ReMe 是 AgentScope 开源的智能体记忆工具，全称 Remember Me, Refine Me。对话、资料和长期知识放在同一份本地工作区里，供智能体检索，并在后面的任务里继续使用。

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

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/reme-docker-deploy?xy_from=reme-docker-deploy)

*本文基于 [ghcr.io/agentscope-ai/reme:0.4.2.1](https://xuanyuan.cloud/ghcr.io/agentscope-ai/reme?xy_from=reme-docker-deploy)，以 **0.4.2.1** 版本实测，测试平台 **Ubuntu 24.04** Linux。*


