# Docker 部署 MaxKB：轻松搭建企业级智能体平台

![Docker 部署 MaxKB：轻松搭建企业级智能体平台](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb.webp)

*分类: Docker部署教程 | 标签: MaxKB,1panel/maxkb,Docker,轩辕镜像,智能体,知识库,私有化部署,部署教程 | 发布时间: 2026-10-19 21:22:20*

> MaxKB 是一款面向企业和团队的开源智能体平台，旨在把知识库与对话模型放在一起，并通过文档分段和向量检索回答问题。本文将介绍如何通过 Docker Compose 部署 MaxKB，搭建企业知识问答平台，帮助你在自己的服务器上管理知识库和智能体，适合内部问答及客服等场景。

*本文基于 [1panel/maxkb:v2.10.7-lts](https://xuanyuan.cloud/zh/r/1panel/maxkb)，以 **v2.10.7-lts** 版本实测，内置 PostgreSQL **17.11**，测试平台 **Ubuntu 24.04** Linux。*

## MaxKB 是什么

MaxKB（Max Knowledge Brain）是飞致云开源的企业级智能体平台。它把知识库和对话模型放在同一套系统里，用来做内部问答和智能客服。

与只在聊天窗口里临时上传文件不同，MaxKB 会把文档切段并做成向量，问答时先检索这些段落。文档留在自己的服务器上。对话模型可以接私有部署的模型，也可以接公有模型服务。

## MaxKB 能做什么

- **搭建知识库**：上传文档或导入网页，自动分段并做向量化。
- **编排智能体**：用简易配置做问答，或用工作流串起多步处理。
- **调用工具**：在流程里使用函数、Skills 和 MCP。
- **接入模型**：向量模型和对话模型分开配置，可以接本地模型，也可以接公有模型。
- **嵌入网页**：把问答页面放到已有网站里。

## 为什么要使用 MaxKB

内部文档交给公有聊天服务后，内容会离开这台机器。只接对话模型、不检索自己的文档，回答也容易对不上材料。

MaxKB 把知识库和智能体放在自己的服务器上，适合内部问答、客服，以及给现有网站加一个问答入口。镜像自带中文向量模型。对话用的大语言模型要在登录后另行接入。

## 使用 Docker 部署 MaxKB

MaxKB 可以用 Docker 跑起来。同一个容器里还带有数据库和缓存，宿主机不必再单独安装这些组件。开始之前准备好 Docker，并想好登录后要接入哪一家对话模型。

接下来用 Docker Compose 写好运行参数，完成启动和浏览器访问验证。

## 环境要求

本文命令使用 **v2.10.7-lts** 版本。这一版发布于 2026-10-15。镜像把 MaxKB、PostgreSQL 17.11 和 Redis 放在同一个容器里。容器内 PostgreSQL 监听 5432，Redis 监听 6379。下面的 Compose 不把这两个端口映到宿主机。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/maxkb` 换成 `~/docker/maxkb`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`）。官方在线安装文档建议使用 **26.0.0** 及以上 |
| 架构 | **linux/amd64** 或 **linux/arm64** |
| 配置 | 官方在线安装文档列出的生产配置是 4 核、8 GB 内存、100 GB 磁盘，系统示例为 Ubuntu 22.04 与 CentOS 7（内核不低于 3.10）。本文在 Ubuntu 24.04 上看到该标签 DISK USAGE **4.62 GB**、CONTENT SIZE **1.23 GB** |
| 端口 | 宿主机 **8080** → 容器 **8080** |
| 工作目录 | `/www/wwwroot/maxkb` |
| 数据 | 宿主机 `data/` 对应容器内 `/opt/maxkb`，数据库、缓存、日志和上传文件都在这里 |
| 账号 | 用户名 `admin`，初始密码 `MaxKB@123..`。登录后请修改 |

官方在线安装文档把生产环境的推荐方式写成离线安装包。下面用这个 Docker 镜像完成部署。

镜像内置中文向量模型。模型页里的名称是 `maxkb-embedding`，基础模型路径为 `/opt/maxkb-app/model/embedding/shibing624_text2vec-base-chinese`。创建知识库时选择它即可。对话模型仍要在「模型」里另行添加，并填入你自己的 API Key。

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

[MaxKB v2.10.7-lts](https://github.com/1Panel-dev/MaxKB/releases/tag/v2.10.7-lts) 发布于 2026-10-15。Docker Hub 镜像 `1panel/maxkb` 上对应的具体标签是 **`v2.10.7-lts`**。同一天，`latest` 和 `v2` 各架构的镜像 digest 与 `v2.10.7-lts` 相同。这两个标签还会随后续版本移动，不要写进命令。本文 `docker pull` 打印的是清单 digest，见「拉取镜像」。

这一版的发布说明包含安全修复。新部署使用 **`v2.10.7-lts`**，不要留在更早的 2.10 补丁上。`v1.10.15-lts` 属于 v1 线，数据目录不能直接交给 v2 容器。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`v2.10.7-lts`** | 2026-10-15 发布的 v2 LTS | **是** |
| `v2` | 跟随 v2 线，会继续变化 | 否 |
| `latest` | 浮动标签，会继续变化 | 否 |
| `v1.10.15-lts` | v1 线的具体版本 | 否 |

完整标签见 [1panel/maxkb 标签列表](https://xuanyuan.cloud/r/1panel/maxkb/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts
```

Ubuntu 24.04 实测：

```text
Digest: sha256:8b9f00944afe388b00e552e5c949a772203653cd79278378e1f823cb214bfc1d
Status: Downloaded newer image for docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts
docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts
```

完成后确认本地有这个标签，再写下面的 Compose：

```bash
docker images docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts
```

```text
IMAGE                                          ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts   8b9f00944afe       4.62GB         1.23GB
```

## Docker Compose 部署

工作目录是 `/www/wwwroot/maxkb`。`data/` 挂到容器内 `/opt/maxkb`。删掉 `data/` 会丢掉数据库、知识库、上传文件和已经改过的密码。`docker compose down` 不加额外参数时，不会删除这个目录。

宿主机 **8080** 对应容器内 **8080**，与官方在线安装文档的 Web 端口一致。8080 已被占用时，只改冒号左边的宿主机端口。

以前用 `docker run` 创建过名为 `maxkb` 的容器时，先删掉容器再启动 Compose。这一步不删除宿主机上的 `data/`。

`data/` 里如果已经有一份跑起来的数据，不要清空。下面的 `mkdir` 只保证目录存在。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/maxkb/data
sudo chown -R "$USER":"$USER" /www/wwwroot/maxkb
```

2. 写入 `compose.yaml`：

```bash
cd /www/wwwroot/maxkb
cat > compose.yaml <<'EOF'
name: maxkb

services:
  maxkb:
    image: docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts
    container_name: maxkb
    restart: always
    ports:
      - "8080:8080"
    environment:
      TZ: Asia/Shanghai
    volumes:
      - ./data:/opt/maxkb
EOF
```

3. 启动：

```bash
cd /www/wwwroot/maxkb
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network maxkb_default Created
 ✔ Container maxkb       Started
```

4. 查看启动日志。首次启动会初始化内置 PostgreSQL。数据库和缓存起来之后，启动脚本最多再等 180 秒，直到容器内 8080 可以连接。看到 `MaxKB started.` 后再打开浏览器。`Ctrl+C` 只结束日志跟踪，不会停掉容器。

```bash
cd /www/wwwroot/maxkb
docker compose logs -f --tail 100 maxkb
```

下面是 Ubuntu 24.04 首次启动里用来判断成功的几行。数据库迁移列表很长，不在这里展开。迁移中途有一次 `tool_executor_init_dir.lock` 找不到的 ERROR，后面的迁移仍继续，最后打印 `MaxKB started.`。说明见「常见问题」。

```text
PostgreSQL starting...
2026-10-19 20:41:41.879 CST [65] LOG:  starting PostgreSQL 17.11 (Debian 17.11-1.pgdg13+2) on x86_64-pc-linux-gnu, compiled by gcc (Debian 14.2.0-19) 14.2.0, 64-bit
PostgreSQL init process complete; ready for start up.
PostgreSQL started.
Redis starting...
Redis started.
MaxKB starting...
wait-for-it: waiting 180 seconds for 127.0.0.1:8080
2026-10-19 20:43:42 [tool_code ERROR] Exception: [Errno 2] No such file or directory: '/opt/maxkb-app/tmp/tool_executor_init_dir.lock'
- Start Gunicorn WSGI HTTP Server
- Start Celery as Distributed Task Queue: Celery
- Start Gunicorn Local Model WSGI HTTP Server
wait-for-it: 127.0.0.1:8080 is available after 112 seconds
MaxKB started.
```

日志里若出现 `Upgrade from v1 to v2 is not supported`，说明 `data/` 是 v1 的数据布局。停掉容器，换一个空目录再启动。不要把 v1 的数据目录直接挂给这个版本。

5. 确认容器在运行：

```bash
cd /www/wwwroot/maxkb
docker compose ps
```

这次在迁移尚未结束时执行，容器已经是 Up，8080 已经映射出来。5432 和 6379 只出现在容器端口上，没有映射到宿主机。就绪仍以日志里的 `MaxKB started.` 为准。

```text
NAME      IMAGE                                          COMMAND                  SERVICE   CREATED          STATUS          PORTS
maxkb     docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts   "bash -c /usr/bin/st…"   maxkb     42 seconds ago   Up 39 seconds   5432/tcp, 6379/tcp, 0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp
```

浏览器访问 `http://服务器IP:8080`。把地址里的服务器 IP 换成这台机器的地址。

## 浏览器首次使用

初始密码写在安装说明里。登录后先改掉，再创建智能体和知识库。下面的界面里，大语言模型还没选中，文档列表也是 0 条。

1. 打开 `http://服务器IP:8080`。右上角语言保持「简体中文」。账号填 `admin`，密码填 `MaxKB@123..`，点击「登录」。

![MaxKB 登录页：语言为简体中文，账号已填 admin，按钮为登录](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-1.webp)

2. 首页上打开「修改密码」。两个输入框都填新密码，页面上没有原密码。点击「保存」。

![MaxKB 首页修改密码：两个新密码输入框，按钮为保存](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-2.webp)

3. 保存后看首页。顶部是「首页」「智能体」「知识库」「工具」「模型」。「快速创建」里有「创建智能体」「创建知识库」「添加工具」「添加模型」。资源里智能体、知识库、工具都是 0。模型总数是 1，其中大语言是 0，向量是 1。这个 1 是内置向量模型，还不能用来对话。

![MaxKB 首页：导航含首页、智能体、知识库、工具、模型，模型卡片里向量为 1、大语言为 0](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-3.webp)

4. 在「快速创建」里打开「创建智能体」，进入「创建简易智能体」。名称和描述都填轩辕镜像小助手，点击「创建」。

![MaxKB 创建简易智能体：名称和描述都是轩辕镜像小助手](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-4.webp)

5. 设置页左侧是名称、描述、AI 模型和提示词，右侧是「调试预览」。AI 模型仍是「请选择 AI 模型」。开场白还是「您好，我是 XXX 小助手」。右上角有「保存」和「发布」。此页还没有选中对话模型。

![MaxKB 智能体设置：AI 模型仍为请选择 AI 模型，调试预览开场白仍是 XXX 小助手](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-5.webp)

6. 回到首页时，智能体「已发布」为 1。在「快速创建」里打开「创建知识库」，进入「创建通用知识库」。知识库名称填轩辕镜像知识库，描述填轩辕镜像小助手。向量模型选择 `maxkb-embedding`，点击「创建」。

![MaxKB 创建通用知识库：名称轩辕镜像知识库，向量模型为 maxkb-embedding](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-6.webp)

7. 创建成功后进入「文档」。顶部提示「创建成功」，列表是「暂无数据」，共 0 条。要导入文件时点「上传文档」。官方说明的默认限制是每次最多 50 个文件，每个文件不超过 100 MB，格式包括 Markdown、TXT、PDF、DOCX、HTML、XLS、XLSX、CSV、ZIP。

![MaxKB 知识库文档页：提示创建成功，列表暂无数据，共 0 条](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-7.webp)

8. 左侧「工作流」页写的是把当前知识库转成工作流知识库，并注明转换后不可撤回。页面上的上传窗口可选「本地文件」「Web 站点」或「飞书知识库」。不要点「转换」。普通文档仍从「文档」页的「上传文档」导入。

![MaxKB 知识库工作流页：说明转换后不可撤回，上传窗口可选本地文件、Web 站点或飞书知识库](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-8.webp)

9. 从首页「添加工具」打开「创建 Skills」。名称和描述都填「轩辕镜像skills」。启动参数表是空的。文件区接受 ZIP，大小不超过 100 MB。此时首页上知识库文档数仍是 0。

![MaxKB 创建 Skills：名称轩辕镜像skills，文件为不超过 100 MB 的 ZIP](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-9.webp)

10. 打开「模型」。全部模型里已有 `maxkb-embedding`，模型类型是向量模型，基础模型路径为 `/opt/maxkb-app/model/embedding/shibing624_text2vec-base-chinese`，创建时间是 2026-10-19。点击「添加模型」，在供应商里选一家。列表中有阿里云百炼、DeepSeek、Ollama、OpenAI、Kimi、本地模型、智谱 AI 等。选中后按表单填写模型名称、模型类型和你自己的 API Key。模型类型选大语言模型。填完回到「轩辕镜像小助手」的设置，在 AI 模型里选中它，再点「保存」。

![MaxKB 模型页：已有向量模型 maxkb-embedding，添加模型时选择供应商](https://imgs.xuanyuan.cloud/docker/blog/maxkb/maxkb-10.webp)

## 升级

升级前先备份 `/www/wwwroot/maxkb/data`。新容器必须继续挂载这个目录。换了一条空目录，启动后会是一套没有数据的新系统。

1. 把 `compose.yaml` 里的镜像标签改成要升级的版本号。

2. 拉取并重建容器：

```bash
cd /www/wwwroot/maxkb
docker compose pull
docker compose up -d
```

3. 再次确认日志里出现 `MaxKB started.`，然后用原来的账号登录。

v1 不能靠更换标签直接升到 v2。官方迁移说明要求：先把 v1 升到 v1.10.10-lts 或更高的 v1 版本，再用迁移工具导入一台空的 v2.1.0，之后才能继续升到更新的 v2。社区版和专业版也不能互相迁移。本文不写这套迁移步骤，需要从 v1 迁出时按 [迁移工具](https://docs.fit2cloud.com/maxkb/installation/migrate) 操作。

## 备选：docker run

没有 Compose 时，可以用 `docker run` 做一次临时启动。数据目录、端口和镜像标签与上面的 Compose 相同。

已经有名为 `maxkb` 的容器时，先删除容器。这一步不删除 `/www/wwwroot/maxkb/data`。

```bash
docker rm -f maxkb
docker run -d 
  --name maxkb 
  --restart always 
  -p 8080:8080 
  -e TZ=Asia/Shanghai 
  -v /www/wwwroot/maxkb/data:/opt/maxkb 
  docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts
```

查看日志，仍然以 `MaxKB started.` 为准：

```bash
docker logs -f --tail 100 maxkb
```

浏览器地址与「浏览器首次使用」相同。

## 常见问题

**Q1：`latest` 或 `v2` 能不能写进 Compose？**

不要写。2026-10-15 当天，`latest` 和 `v2` 各架构的镜像 digest 与 `v2.10.7-lts` 相同，之后仍会改指向。说明见「标签怎么选」。

**Q2：要不要再部署 PostgreSQL 和 Redis？**

不用。这个镜像在 `MAXKB_DB_HOST` 和 `MAXKB_REDIS_HOST` 为 `127.0.0.1` 时，会在同一个容器里启动内置 PostgreSQL 和 Redis。本文没有映射 5432 和 6379。不要把这两个端口暴露到公网。

官方安装文档里用 `mkctl` 修改内置数据库端口的做法，针对的是离线安装包。在线 Docker 镜像默认不带这个命令。

**Q3：日志里有 `tool_executor_init_dir.lock` 找不到？**

Ubuntu 24.04 这次首次启动，迁移进行到一半时出现过：

```text
2026-10-19 20:43:42 [tool_code ERROR] Exception: [Errno 2] No such file or directory: '/opt/maxkb-app/tmp/tool_executor_init_dir.lock'
```

后面的迁移仍然显示 OK，接着启动了 Gunicorn、Celery 和本地模型进程，并打印 `MaxKB started.`。看到这一行后可以打开页面。不要因为这一条 ERROR 就清空 `data/`。

**Q4：日志里是 `Upgrade from v1 to v2 is not supported`？**

启动脚本发现数据目录带有 v1 的 `PG_VERSION` 时会直接退出。v1 的常见挂载是容器内 `/var/lib/postgresql/data`，v2 是 `/opt/maxkb`。换一个空的 `data/` 再启动。已有 v1 业务数据时，按「升级」里的迁移说明处理，不要把旧目录直接挂上来。

**Q5：8080 已经被占用？**

只改映射的宿主机端口，例如 `8088:8080`。容器内仍然是 8080。访问地址改成新的宿主机端口。

**Q6：页面能打开，智能体却不能回答？**

设置页里 AI 模型如果仍是「请选择 AI 模型」，就还没有对话模型。首页上那个向量数为 1 的模型是 `maxkb-embedding`，只用于知识库向量化。先在「模型」里添加大语言模型，再回到智能体里选中它。API Key 或供应商地址填错时，回到「模型」里改参数。

**Q7：忘记管理员密码？**

初始密码只在数据目录第一次初始化时生效。`data/` 还在时，删掉容器不会把密码改回 `MaxKB@123..`。还没有需要保留的知识库和账号时，可以停掉服务，清空 `data/` 后重新启动，系统会再次使用初始密码。清空会丢掉已有数据。

**Q8：升级或重建之后，里面是空的？**

核对宿主机挂载是否仍是 `/www/wwwroot/maxkb/data`。官方升级说明要求新容器的数据目录与原来一致。`docker compose down` 本身不会删除这个目录。

**Q9：拉取报 `no matching manifest`？**

`v2.10.7-lts` 提供 linux/amd64 与 linux/arm64。32 位机器拉不到这个标签。

**Q10：可以放到公网吗？**

对外开放 8080 之前，先改掉初始密码。这条 Compose 只发布 8080，没有发布 5432 和 6379。安全组里只放行需要访问的地址。生产环境官方更推荐离线安装包。

## 命令速查

```bash
docker pull docker.xuanyuan.run/1panel/maxkb:v2.10.7-lts

cd /www/wwwroot/maxkb
docker compose up -d
docker compose ps
docker compose logs -f --tail 100 maxkb

docker compose pull
docker compose up -d
docker compose restart maxkb
docker compose stop
docker compose start
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://服务器IP:8080`，用户名 `admin`，初始密码 `MaxKB@123..`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [1panel/maxkb 镜像页](https://xuanyuan.cloud/zh/r/1panel/maxkb) | [https://xuanyuan.cloud/zh/r/1panel/maxkb](https://xuanyuan.cloud/zh/r/1panel/maxkb) |
| [1panel/maxkb 概览](https://xuanyuan.cloud/r/1panel/maxkb) | [https://xuanyuan.cloud/r/1panel/maxkb](https://xuanyuan.cloud/r/1panel/maxkb) |
| [1panel/maxkb 标签列表](https://xuanyuan.cloud/r/1panel/maxkb/tags) | [https://xuanyuan.cloud/r/1panel/maxkb/tags](https://xuanyuan.cloud/r/1panel/maxkb/tags) |
| [Docker Hub · 1panel/maxkb](https://hub.docker.com/r/1panel/maxkb) | [https://hub.docker.com/r/1panel/maxkb](https://hub.docker.com/r/1panel/maxkb) |
| [GitHub · 1Panel-dev/MaxKB](https://github.com/1Panel-dev/MaxKB) | [https://github.com/1Panel-dev/MaxKB](https://github.com/1Panel-dev/MaxKB) |
| [Release · v2.10.7-lts](https://github.com/1Panel-dev/MaxKB/releases/tag/v2.10.7-lts) | [https://github.com/1Panel-dev/MaxKB/releases/tag/v2.10.7-lts](https://github.com/1Panel-dev/MaxKB/releases/tag/v2.10.7-lts) |
| [MaxKB 官网](https://maxkb.cn/) | [https://maxkb.cn/](https://maxkb.cn/) |
| [在线安装](https://docs.fit2cloud.com/maxkb/installation/online_installtion) | [https://docs.fit2cloud.com/maxkb/installation/online_installtion](https://docs.fit2cloud.com/maxkb/installation/online_installtion) |
| [快速入门](https://docs.fit2cloud.com/maxkb/quick_start) | [https://docs.fit2cloud.com/maxkb/quick_start](https://docs.fit2cloud.com/maxkb/quick_start) |
| [离线安装](https://docs.fit2cloud.com/maxkb/installation/offline_installtion/) | [https://docs.fit2cloud.com/maxkb/installation/offline_installtion/](https://docs.fit2cloud.com/maxkb/installation/offline_installtion/) |
| [迁移工具](https://docs.fit2cloud.com/maxkb/installation/migrate) | [https://docs.fit2cloud.com/maxkb/installation/migrate](https://docs.fit2cloud.com/maxkb/installation/migrate) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/maxkb-docker-deploy


