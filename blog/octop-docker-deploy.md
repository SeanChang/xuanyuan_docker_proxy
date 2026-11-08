# Docker 部署 Octop：轻松搭建自托管多用户 AI 助手平台

![Docker 部署 Octop：轻松搭建自托管多用户 AI 助手平台](https://imgs.xuanyuan.cloud/docker/blog/octop/octop.webp)

*分类: Docker部署教程 | 标签: Octop,tencentcloud/octop,Docker,轩辕镜像,AI 助手,多 Agent,自托管,私有化部署,部署教程 | 发布时间: 2026-11-05 16:42:14*

> Octop 是腾讯云开源的自托管 AI 助手，单进程提供 Web 控制台、CLI、IM 通道与多 Agent 协作，数据留在本机。本文将介绍如何通过 Docker Compose 部署 ghcr.io/tencentcloud/octop，搭建可私有化的多用户智能助手环境，适合家庭共用、小团队协作，以及需要对接飞书、钉钉等通道的场景。

## Octop 是什么

Octop 是腾讯云开源的自托管 AI 助手。单进程同时提供 Web 控制台、CLI、IM 通道和定时任务，支持多用户、多 Agent。对话、工作区与凭证默认写在本机数据目录。

与只提供聊天窗口、或把会话全部留在第三方云端的助手不同，它把专家、通道、知识库和连接器收在同一套本地控制台里。每位用户可以有一组按场景切换的专家，也可以通过 Connector、知识库和 ACP 与外部服务、IDE 协作。

## Octop 能做什么

- **在浏览器里管理助手**：用 Web 控制台对话、创建专家、配置供应商、通道、定时任务、知识库和插件。
- **多人共用一台实例**：多用户隔离，管理员可分配专家与权限，家庭或小团队共用同一套服务。
- **对接常用 IM**：把飞书、钉钉、QQ、微信、企业微信等接到同一实例。
- **扩展外部能力**：用 Connector（OAuth / MCP）接入腾讯文档、会议等服务，用 ACP 与 IDE / 终端 AI 双向协作。
- **把状态留在本机**：控制面数据库、密钥、Agent 工作区默认落在数据目录，可按目录备份与迁移。

## 为什么要使用 Octop

本机临时跑 CLI，会话和配置容易散落。把能执行工具的服务直接挂到局域网，又缺少统一的多用户入口。云端助手上手快，但对话、工作区和通道凭证不在自己机器上。

用固定版本的容器跑 Octop，数据进宿主机目录，浏览器打开控制台即可配置模型和专家。适合家庭共用、小团队协作，以及需要把 IM 通道和私有知识库留在自建环境里的人。

## 使用 Docker 部署 Octop

Docker 可以把 Octop 的控制台与运行时一起拉起来，本机不必先装 Python 虚拟环境。部署前准备好 Docker，并想好管理员密码，或准备走网页设置向导。

接下来用 Docker Compose 写好数据目录、环境变量和端口，启动服务，再用浏览器完成登录与模型配置。

## 环境要求

本文使用 **`ghcr.io/tencentcloud/octop:1.0.2`** 版本实测。测试平台是 Ubuntu 24.04（主机名 `ikuai-ubuntu2404`）。镜像提供 **linux/amd64** 与 **linux/arm64**。完整版含桌面相关依赖与本地向量等组件（默认不自动启动桌面），体积较大。实测 Digest 为 `sha256:c15e792f405a5b5aca8f3625adcc11f3421e13f6d01da7217ea18e6f0b98553f`；`docker images` 显示 DISK USAGE 约 **4.48 GB**，CONTENT SIZE 约 **1.09 GB**。拉取前确认磁盘有富余。

容器内默认监听 **8088**。数据目录挂到容器 `/data/.octop`，并设置 `HOME=/data`。启用远程桌面时需要更大的 `/dev/shm`，Compose 里写 `shm_size: 1gb`。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/octop` 换成 `~/docker/octop` |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 内存 | 官方建议预留数 GB，供进程与模型 / Embedding 缓存使用 |
| 磁盘 | 镜像约 **4.48 GB**（DISK）/ **1.09 GB**（CONTENT），另加数据库、工作区与知识库增长 |
| 端口 | 宿主机 **8088** → 容器 **8088** |
| 工作目录 | `/www/wwwroot/octop`，数据目录 `data/` → `/data/.octop` |
| 账号 | 默认用户名 **`admin`**；密码由 `OCTOP_DEFAULT_PASSWORD` 预设，或首次走设置向导。密码至少 **8** 位，且同时包含字母和数字 |

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

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=octop-docker-deploy)。

## 标签怎么选

新安装使用 **`1.0.2`**，对应 GitHub Release **v1.0.2**（2026-10-18），是当前最新的无 `b` 后缀发行版。`latest` 会跟随后续发版改指向，当前指向带 `b` 的预发布线，不写入本文命令。架构后缀标签（如 `1.0.2-amd64`）由多架构清单自动选择，不必手写。较新的预发布线另有 **lite** 变体（去掉桌面、本地向量等重依赖），标签形如 `*-lite`；本文主路径用完整版。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`1.0.2`** | 完整版发行标签，linux/amd64 与 linux/arm64 | **是** |
| `1.0.2-amd64` / `1.0.2-arm64` | 单架构构建 | 否，一般用清单标签即可 |
| `1.0.3b3` 等 | 带 `b` 的预发布线；`latest` 可能指向其中之一 | 否 |
| `*-lite` | 精简变体，体积更小，不带完整桌面等组件 | 需要更小镜像时再换 |
| `latest` | 浮动别名 | 否 |

发布镜像在 GHCR，没有 Docker Hub 官方仓。详情见 [ghcr.io/tencentcloud/octop](https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?xy_from=octop-docker-deploy)，拉取说明见 [拉取页](https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?tab=pull&xy_from=octop-docker-deploy)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=octop-docker-deploy) **加速拉取**。把 `***` 换成个人中心的 GHCR 专属前缀，配置见 [GHCR 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/ghcr?xy_from=octop-docker-deploy)。在 `***-ghcr.xuanyuan.run` 上执行 `docker login` 时，不要填写 GitHub PAT。

```bash
docker pull ***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2
```

Ubuntu 24.04 实测：

```text
1.0.2: Pulling from tencentcloud/octop
75b6a36c64a1: Pull complete
bbc5a1223747: Pull complete
6912e23eb445: Pull complete
ecc510c1e359: Pull complete
5211125a4fbd: Pull complete
e14da1893c6b: Pull complete
c8d01663473d: Pull complete
e76c5a55f8e9: Pull complete
fab3657ed294: Pull complete
9b7d203908f5: Pull complete
5c126df06de0: Pull complete
11884bad7a69: Pull complete
8898f8ef387c: Pull complete
5ccd70e5eb84: Pull complete
4f4fb700ef54: Pull complete
016e48ffd9f6: Pull complete
44136fa355b3: Download complete
17f7b9a14975: Download complete
Digest: sha256:c15e792f405a5b5aca8f3625adcc11f3421e13f6d01da7217ea18e6f0b98553f
Status: Downloaded newer image for ***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2
***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2
```

```bash
docker images ***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2
```

Ubuntu 24.04 实测：

```text
IMAGE                                                 ID             DISK USAGE   CONTENT SIZE   EXTRA
***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2       c15e792f405a       4.48GB         1.09GB    U
```

401 / 402 见 [常见问题](https://xuanyuan.cloud/faq?xy_from=octop-docker-deploy)。

## Docker Compose 部署

工作目录：Linux **`/www/wwwroot/octop`**。macOS 用 **`~/docker/octop`**。

| 宿主机目录 | 容器内路径 | 用途 |
|------------|------------|------|
| `data/` | `/data/.octop` | 控制面数据库、密钥、配置、Agent 工作区、日志等 |

`HOME` 必须为 `/data`，这样容器内的 `~/.octop` 才会落到挂载目录。`OCTOP_DEFAULT_PASSWORD` 合格时，首次启动会创建管理员，并把说明写入 `data/credential.txt`；未设置或密码不合格时，打开页面走设置向导，向导口令在 `data/octop-login.txt`。

### 1. 创建目录

```bash
sudo mkdir -p /www/wwwroot/octop/data
sudo chown -R "$USER":"$USER" /www/wwwroot/octop
cd /www/wwwroot/octop
```

macOS：

```bash
mkdir -p ~/docker/octop/data
cd ~/docker/octop
```

### 2. 写入 `.env`

把下面的密码换成你自己的强密码（至少 8 位，同时包含字母和数字）。不想预设密码时，把 `OCTOP_DEFAULT_PASSWORD=` 留空，启动后走网页向导。

```bash
cd /www/wwwroot/octop
cat > .env <<'EOF'
OCTOP_PORT=8088
OCTOP_ADMIN_USERNAME=admin
OCTOP_ADMIN_DISPLAY_NAME=Admin
OCTOP_DEFAULT_PASSWORD=ChangeMe9a
OCTOP_LOG_LEVEL=info
EOF
```

不要把密钥写进镜像构建参数，也不要提交到公开仓库。模型供应商可在控制台配置；若要把 `OPENAI_API_KEY`、`DASHSCOPE_API_KEY` 等放进 `.env`，还须在 Compose 的 `environment` 里声明同名变量，否则进不了容器。

### 3. 写入 `compose.yaml`

宿主机 **8088** 转到容器 **8088**。`shm_size: 1gb` 供后续启用远程桌面时使用。把 `***` 换成你的 GHCR 专属前缀。`image` 的值必须加双引号：YAML 里裸写 `***-…` 时，`*` 会被当成锚点，Compose 会报 `unknown anchor`。

```bash
cd /www/wwwroot/octop
cat > compose.yaml <<'EOF'
services:
  octop:
    image: "***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2"
    container_name: octop
    restart: unless-stopped
    shm_size: "1gb"
    ulimits:
      nofile:
        soft: 65535
        hard: 65535
    ports:
      - "8088:8088"
    volumes:
      - ./data:/data/.octop
    env_file:
      - .env
    environment:
      HOME: /data
      OCTOP_BIND_HOST: "0.0.0.0"
      OCTOP_PORT: "8088"
      OCTOP_LOG_LEVEL: ${OCTOP_LOG_LEVEL:-info}
      OCTOP_DEFAULT_PASSWORD: ${OCTOP_DEFAULT_PASSWORD:-}
      OCTOP_ADMIN_USERNAME: ${OCTOP_ADMIN_USERNAME:-admin}
      OCTOP_ADMIN_DISPLAY_NAME: ${OCTOP_ADMIN_DISPLAY_NAME:-Admin}
EOF
```

| 配置 | 说明 |
|------|------|
| `image` | 标签 `1.0.2`；整段坐标加双引号 |
| `8088:8088` | 宿主机 **8088** → 容器 **8088** |
| `./data` | 持久化到 `/data/.octop` |
| `HOME=/data` | 必需，使 `~/.octop` 落到挂载点 |
| `shm_size` | **1gb**，远程桌面需要；默认 64MB 时 Xvnc 起不来 |
| `ulimits.nofile` | 提高文件描述符上限 |

只改宿主机端口时，可写成 `"9090:8088"`，容器内仍听 **8088**。若同时改 `OCTOP_PORT`，映射两侧须与环境变量一致。

### 4. 启动

```bash
cd /www/wwwroot/octop
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network octop_default Created
 ✔ Container octop       Started
```

### 5. 查看状态与日志

```bash
cd /www/wwwroot/octop
docker compose ps
docker compose logs --tail 80 octop
```

健康检查启动宽限期约 **90** 秒。刚起来时可以是 `health: starting`，宽限期内未变成 **healthy** 不代表失败。Ubuntu 24.04 上容器创建约 **4** 分钟后查看，状态已是 **healthy**，PORTS 为 `0.0.0.0:8088` 与 `[::]:8088`：

```text
NAME      IMAGE                                                 COMMAND                  SERVICE   CREATED         STATUS                   PORTS
octop     ***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2       "docker-entrypoint.sh"   octop     4 minutes ago   Up 4 minutes (healthy)   0.0.0.0:8088->8088/tcp, [::]:8088->8088/tcp
```

首次启动日志节选：入口脚本完成初始化，凭据写入 `/data/.octop/credential.txt`，Uvicorn 听在 `0.0.0.0:8088`：

```text
octop  | [entrypoint] 首次启动，正在初始化 Octop...
octop  | [entrypoint] 凭据已保存至: /data/.octop/credential.txt
octop  | [entrypoint] 已写入初始化标记 /data/.octop/.initialized，重启将跳过 octop init。
octop  | [entrypoint] 正在启动 Octop，端口 8088...
octop  | Saved config to /data/.octop/config.json
octop  | INFO:     Started server process [1]
octop  | INFO:     Waiting for application startup.
octop  | INFO:     Application startup complete.
octop  | INFO:     Uvicorn running on http://0.0.0.0:8088 (Press CTRL+C to quit)
octop  | INFO:     127.0.0.1:47306 - "GET /api/health HTTP/1.1" 200 OK
```

## 确认服务可用

在服务器本机探测健康接口：

```bash
curl -sS http://127.0.0.1:8088/api/health
```

Ubuntu 24.04 实测：

```text
{"ok":true,"started_at":1793866861,"db":true,"users_loaded":1,"agents_running":0}
```

查看版本：

```bash
docker compose exec octop octop --version
```

Ubuntu 24.04 实测：

```text
octop v1.0.2
```

预设了合格密码时，查看凭据说明：

```bash
sed -n '1,40p' /www/wwwroot/octop/data/credential.txt
```

Ubuntu 24.04 实测（密码与 `.env` 中的 `OCTOP_DEFAULT_PASSWORD` 一致；登录后立刻改密）：

```text
Octop Login Credential
======================
URL:      http://<host>:8088
Username: admin
Password: ChangeMe9a

Please change this password after first login!
  - Via Web: avatar menu → Change password
  - Via CLI: docker exec -it <container> octop user passwd --username admin

This file is rewritten whenever the initial password is (re)generated here.
If you changed the password inside the Web console, that password wins.
```

若走设置向导，读取：

```bash
sed -n '1,40p' /www/wwwroot/octop/data/octop-login.txt
```

也可以在容器内读取同一文件：

```bash
docker compose exec octop cat /data/.octop/credential.txt
docker compose exec octop cat /data/.octop/octop-login.txt
```

## 打开控制台并完成首次配置

局域网浏览器打开（把 IP 换成你的；本机用 `127.0.0.1`）：

```text
http://服务器IP:8088
```

### 登录

- **已预设合格密码**：用户名填 `admin`（或你在 `.env` 里改过的 `OCTOP_ADMIN_USERNAME`），密码填 `.env` 里的值。先把滑块推到最右侧完成「推动滑块到最右侧完成验证」，再点「登录」。可勾选「记住登录状态」。
- **未设密码或密码不合格**：用 `octop-login.txt` 里的向导口令解锁，再在页面设置管理员用户名与密码。

登录后点侧栏底部的 **Admin** 头像，按菜单改密。页面改密后，`credential.txt` 不会自动重写。

![Octop 登录页：用户名 admin、滑块验证与登录按钮](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-1.webp)

### 进入对话与专家

登录后默认进入「对话」。左上角为 **Octop v1.0.2**。还没有专家时，中间显示「还没有专家」，可点「去创建专家」。

![Octop 对话页：还没有专家，按钮为去创建专家](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-2.webp)

打开侧栏「专家」→「我的专家」。空状态可点「+ 新建专家」，或「去内置专家」从模板创建；也有「专家市场」页签。

![Octop 专家页：我的专家为空，可新建或去内置专家](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-3.webp)

从「通用专家」模板新建时，若尚未配置模型，右侧「从『通用专家』新建」表单顶部会提示：「当前未配置任何模型，请前往管理员页面配置 Provider」。先去配置模型，再回来点「创建」。

![从『通用专家』新建：未配置模型时的黄色提示](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-4.webp)

### 配置模型

按黄色提示进入管理员页面，或打开侧栏「管理」→「模型」。在「对话模型」下，可用模型池为空时会提示先授权提供商。下方「预置提供商」分「云端」「本地」，点某个提供商的「配置 …」。

![模型配置：可用模型池为空，预置提供商待配置](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-5.webp)

以腾讯云为例，右侧打开「配置 Tencent Cloud Coding Plan」后，填写名称、类型、Base URL 与 API Key，可用「测试连接」「获取模型列表」校验，再保存。API Key 只放在控制台或本机 `.env`，不要写进公开仓库。

![配置腾讯云 Coding Plan：填写 Base URL 与 API Key](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-6.webp)

模型可用后，回到「专家」创建或启用专家，再在「对话」里选用。需要飞书、钉钉等时，到「通道」按官方文档填写凭证。不要把 **8088** 直接暴露到公网而不加反向代理与访问控制。

### 侧栏其它入口

首次安装时，下列页面多为空状态或未开启，可按需配置。

「技能包」：还没有技能包时可「+ 创建技能包」，或「从技能市场导入」。

![技能包：还没有技能包](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-7.webp)

「知识库」：显示「未启用知识库」。点「知识库设置」，打开开关并配置本地 ONNX 或在线 Embedding 后再上传文档。

![知识库：未启用知识库](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-8.webp)

「云端协同」（BETA）：暂无连接时可「添加连接」，把本机实例连到另一台 Octop。

![云端协同：暂无云端协同](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-9.webp)

「管理」→「存储」：还没有存储后端时可「浏览支持类型」，为专家配置本地、对象存储、沙箱或数据库等后端。

![存储管理：还没有存储后端](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-10.webp)

「管理」→「插件」→「插件市场」：实测可见约 **27** 个插件，可按生活、资讯、工具等分类筛选后安装。

![插件市场：按分类浏览并安装](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-11.webp)

「管理」→「安全防护」：可配置工具审批、文件访问、敏感信息、命令防护、技能扫描与审计日志。需要人工确认时，打开「启用工具人工审批」，勾选工具后点「保存全部安全设置」。

![安全防护：工具审批页](https://imgs.xuanyuan.cloud/docker/blog/octop/octop-12.webp)

## 备选：docker run

没有 Compose 时，用一条 `docker run` 启动。数据目录与 Compose 相同。若 Compose 已占用容器名 `octop`、端口 **8088** 或这份 `data/`，先在 `/www/wwwroot/octop` 执行 `docker compose down`。`down` 会删掉 Compose 创建的容器，不会删除 `data/`。

1. 创建目录。目录已存在且属主正确时，跳过这一步。

```bash
sudo mkdir -p /www/wwwroot/octop/data
sudo chown -R "$USER":"$USER" /www/wwwroot/octop
```

2. 启动容器。把 `ChangeMe9a` 和 `***` 换成你的密码与专属前缀。

```bash
docker run -d --name octop 
  --restart unless-stopped 
  --shm-size=1g 
  --ulimit nofile=65535:65535 
  -p 8088:8088 
  -v /www/wwwroot/octop/data:/data/.octop 
  -e HOME=/data 
  -e OCTOP_BIND_HOST=0.0.0.0 
  -e OCTOP_PORT=8088 
  -e OCTOP_ADMIN_USERNAME=admin 
  -e OCTOP_DEFAULT_PASSWORD=ChangeMe9a 
  ***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2
```

3. 查看状态，再按「确认服务可用」探测：

```bash
docker ps --filter name=octop
docker logs --tail 80 octop
```

停掉这个容器：

```bash
docker stop octop
docker rm octop
```

`docker rm` 不删除 `/www/wwwroot/octop/data`。

## 升级

升级前停止写入，并先备份整份 `data/` 以及 `compose.yaml`、`.env`。跨版本升级前可用容器内 `octop backup` 再留一份。改 `compose.yaml` 里的镜像标签后，再拉取并启动。

```bash
cd /www/wwwroot/octop
docker compose stop
cp -a data "data-backup-$(date +%Y%m%d)"
# 编辑 compose.yaml，将标签改为目标版本
docker compose pull
docker compose up -d
curl -sS http://127.0.0.1:8088/api/health
```

数据库结构一般在下次启动时自动迁移。仅当设置向导提示需要时，再按官方说明处理初始化。

## 常见问题

### Compose 报 `unknown anchor '**-ghcr…'`

`image` 未加引号，且仍带着占位符 `***` 时，YAML 会把 `*` 当成锚点。把整段镜像坐标写成双引号，并把 `***` 换成个人中心的专属前缀，再执行 `docker compose up -d`。

### 拉取失败或提示要登录 GHCR

确认专属前缀已换成个人中心的值，坐标是 `***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2`，不要写成 `docker.xuanyuan.run/ghcr.io/...`。在 GHCR 专属域上 `docker login` 时不要填 GitHub PAT。详见 [GHCR 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/ghcr?xy_from=octop-docker-deploy)。

### 打开页面却进入设置向导

`OCTOP_DEFAULT_PASSWORD` 未设置，或未通过「至少 8 位且同时含字母与数字」的策略时，不会自动建管理员。读取 `data/octop-login.txt` 中的向导口令完成设置。若要自动建号，须在**空数据目录**上重新初始化；已有数据库时改环境变量不会覆盖已创建的账号。

### 登录按钮点不了

登录页有滑块文案「推动滑块到最右侧完成验证」。先完成滑块，再点「登录」。

### 创建专家时提示未配置模型

先到「模型」配置至少一个 Provider，并用「获取模型列表」确认可用，再新建专家。黄色提示会指向管理员页面。

### `HOME` 没设成 `/data`

未设置 `HOME=/data` 时，数据可能写到容器内其它路径，换容器后会丢。Compose 与 `docker run` 都必须带 `HOME=/data`，并把宿主机目录挂到 `/data/.octop`。

### 远程桌面起不来

Xvnc 需要大于 Docker 默认的 **64MB** `/dev/shm`。确认 Compose 含 `shm_size: "1gb"`，或 `docker run` 含 `--shm-size=1g`，再重启容器。桌面不会在启动时自动打开，需在控制台按需启用。

### 健康检查长时间不过

启动宽限期约 **90** 秒。先看 `docker compose logs octop`。确认 `data/` 可写，且宿主机 **8088** 未被占用。

### 忘记管理员密码

```bash
docker compose exec octop octop user passwd --username admin --password '你的新密码'
```

新密码仍须至少 8 位，且同时包含字母和数字。

### 能否改用 PostgreSQL

可以。控制面默认用数据目录里的 SQLite；也可通过环境变量或 `config.json` 配置 PostgreSQL。相关变量必须写进 Compose 的 `environment`，只放在 `.env` 里不会进入容器。

## 命令速查

Compose 在 `/www/wwwroot/octop` 下执行。把 `***` 换成个人中心的 GHCR 专属前缀；`compose.yaml` 的 `image` 须加双引号。

```bash
docker pull ***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2
docker compose up -d
docker compose ps
docker compose logs --tail 80 octop
curl -sS http://127.0.0.1:8088/api/health
docker compose exec octop octop --version
docker compose stop
docker compose pull
docker compose up -d
```

无 Compose 时：

```bash
docker run -d --name octop 
  --restart unless-stopped 
  --shm-size=1g 
  --ulimit nofile=65535:65535 
  -p 8088:8088 
  -v /www/wwwroot/octop/data:/data/.octop 
  -e HOME=/data 
  -e OCTOP_BIND_HOST=0.0.0.0 
  -e OCTOP_PORT=8088 
  -e OCTOP_ADMIN_USERNAME=admin 
  -e OCTOP_DEFAULT_PASSWORD=ChangeMe9a 
  ***-ghcr.xuanyuan.run/tencentcloud/octop:1.0.2
docker logs --tail 80 octop
docker stop octop && docker rm octop
```

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [ghcr.io/tencentcloud/octop 镜像页](https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?xy_from=octop-docker-deploy) | [https://xuanyuan.cloud/ghcr.io/tencentcloud/octop](https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?xy_from=octop-docker-deploy) |
| [ghcr.io/tencentcloud/octop 拉取页](https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?tab=pull&xy_from=octop-docker-deploy) | [https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?tab=pull](https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?tab=pull&xy_from=octop-docker-deploy) |
| [GHCR 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/ghcr?xy_from=octop-docker-deploy) | [https://xuanyuan.cloud/usage/mirror-tutorial/ghcr](https://xuanyuan.cloud/usage/mirror-tutorial/ghcr?xy_from=octop-docker-deploy) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=octop-docker-deploy) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=octop-docker-deploy) |
| [GitHub · TencentCloud/Octop](https://github.com/TencentCloud/Octop) | [https://github.com/TencentCloud/Octop](https://github.com/TencentCloud/Octop) |
| [中文 README](https://github.com/TencentCloud/Octop/blob/main/README_CN.md) | [https://github.com/TencentCloud/Octop/blob/main/README_CN.md](https://github.com/TencentCloud/Octop/blob/main/README_CN.md) |
| [GitHub Release v1.0.2](https://github.com/TencentCloud/Octop/releases/tag/v1.0.2) | [https://github.com/TencentCloud/Octop/releases/tag/v1.0.2](https://github.com/TencentCloud/Octop/releases/tag/v1.0.2) |
| [GHCR 包 octop](https://github.com/TencentCloud/Octop/pkgs/container/octop) | [https://github.com/TencentCloud/Octop/pkgs/container/octop](https://github.com/TencentCloud/Octop/pkgs/container/octop) |
| [官方 Docker 部署指南](https://docs.octop.cloud/guide/quickstart-docker) | [https://docs.octop.cloud/guide/quickstart-docker](https://docs.octop.cloud/guide/quickstart-docker) |

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/octop-docker-deploy?xy_from=octop-docker-deploy)

*本文基于 [ghcr.io/tencentcloud/octop:1.0.2](https://xuanyuan.cloud/ghcr.io/tencentcloud/octop?xy_from=octop-docker-deploy)，以 **1.0.2** 版本实测，测试平台 **Ubuntu 24.04** Linux（`ikuai-ubuntu2404`）。*


