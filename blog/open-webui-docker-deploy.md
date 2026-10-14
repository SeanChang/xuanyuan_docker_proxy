# Docker 部署 Open WebUI：轻松搭建本地大模型对话平台

![Docker 部署 Open WebUI：轻松搭建本地大模型对话平台](https://imgs.xuanyuan.cloud/docker/blog/open-webui/open-webui.webp)

*分类: Docker部署教程 | 标签: Open WebUI,Ollama,openwebui/open-webui,ollama/ollama,Docker,轩辕镜像,大模型,私有化部署,部署教程 | 发布时间: 2026-10-14 10:34:07*

> Open WebUI 是一款面向个人和团队的开源自托管 AI 界面，旨在把对话留在自己的机器上，并通过浏览器完成聊天、切换模型和查看记录。本文将介绍如何通过 Docker Compose 部署 Open WebUI 与 Ollama，搭建本地大模型对话平台，帮助你在浏览器里使用本机模型，适合内网试用及不把对话发到云端等场景。

*本文基于 [openwebui/open-webui:0.12.0](https://xuanyuan.cloud/zh/r/openwebui/open-webui) 与 [ollama/ollama:0.40.4](https://xuanyuan.cloud/zh/r/ollama/ollama)，Open WebUI 为 **0.12.0**，Ollama 为 **0.40.4**。*

## Open WebUI 是什么

Open WebUI 是一套自托管的大模型网页界面。模型可以跑在同一台机器上的 Ollama 里，对话在浏览器中完成。账号、聊天记录和设置保存在本机。

只在终端里操作模型时，每次都要指定模型名。Open WebUI 把选择模型、继续上次对话和创建管理员放到网页里。Ollama 负责下载并运行模型，Open WebUI 负责把这些模型接到对话界面上。

## Open WebUI 能做什么

- **浏览器对话**：打开网页，选中模型后直接输入问题。
- **切换模型**：Ollama 里已经下载的模型会出现在界面上，可以换一个再聊。
- **保留对话**：聊天记录留在本机数据目录，下次打开还能看到。
- **管理员账号**：第一次打开时创建管理员，之后用这个账号登录。
- **使用本机模型**：请求发到同一套 Compose 里的 Ollama，对话留在这台机器上。

## 为什么要使用 Open WebUI

把问题发给云端聊天服务时，内容会离开这台机器。只想在自己的电脑或内网里试用模型，又不想每次都敲命令，就需要一个留在本地的网页。

Open WebUI 和 Ollama 放在一起之后，模型文件和聊天记录都在本机目录里。适合个人试用，也适合在内网给几个人开一个对话入口。

## 使用 Docker 部署 Open WebUI

Open WebUI 和 Ollama 都可以用 Docker 跑起来，宿主机不必单独安装它们的运行环境。开始之前准备好 Docker，并想好浏览器要打开的地址。模型在 Ollama 起来之后再下载。

下面用 Docker Compose 写好两个服务，启动后拉取模型，再在浏览器里创建管理员并开始对话。

## 环境要求

本文命令使用 Open WebUI **0.12.0** 与 Ollama **0.40.4**。两个服务跑在同一台机器上，由 Compose 放进同一个网络，Open WebUI 用服务名访问 Ollama。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）；macOS 把 `/www/wwwroot/open-webui` 换成 `~/docker/open-webui`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64** 或 **linux/arm64**。两个标签在轩辕镜像标签页上都有这两种架构 |
| 磁盘 | Open WebUI **0.12.0** 的 amd64 约 1.62 GB，Ollama **0.40.4** 的 amd64 约 3.78 GB。示例模型 qwen:0.5b 约 394 MB，另留出余量 |
| 端口 | 宿主机 **3002** → Open WebUI 容器 **8080**。宿主机 **11434** → Ollama 容器 **11434**，只给本机检查 API，不对公网放行 |
| 工作目录 | `/www/wwwroot/open-webui` |
| 其他 | 生成 `WEBUI_SECRET_KEY` 需要 `openssl` |

Ollama 的 HTTP API 默认不校验登录。11434 映到宿主机，是为了在这台机器上执行 `curl`。安全组和防火墙不要把 11434 对公网打开。浏览器访问用 3002。

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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > compose.yaml <<EOF` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

[Open WebUI v0.12.0](https://github.com/open-webui/open-webui/releases/tag/v0.12.0) 发布于 2026-10-10。Docker Hub 镜像 `openwebui/open-webui` 上对应的具体标签是 **`0.12.0`**，不带 `v` 前缀。轩辕镜像标签页上，该标签更新于 2026-10-10，linux/amd64 与 linux/arm64 都有。

官方说明：`:latest` 跟着 `main` 分支走，并不是「当前稳定版」这一个固定版本。`:0.12` 会跟着 0.12 线的后续补丁移动。下面的命令使用具体版本 **`0.12.0`**。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`0.12.0`** | 稳定版 0.12.0，标准镜像 | **是** |
| `0.12` | 0.12 线的滚动标签 | 否 |
| `latest` | 跟随 `main`，会继续变化 | 否 |
| `0.12.0-slim` | 体积更小，本地嵌入和语音等能力不在镜像里 | 否 |
| `0.12.0-ollama` | 把 Ollama 打进同一个容器 | 否 |
| `0.12.0-cuda` / `0.12.0-cuda126` | 带 NVIDIA CUDA | 否 |

本文把 Open WebUI 和 Ollama 分成两个容器。不要改用 `0.12.0-ollama`。没有 NVIDIA GPU 时，也不要改用带 `cuda` 的标签。

Ollama 使用具体版本 **`0.40.4`**。轩辕镜像标签页上，该标签更新于 2026-10-14，linux/amd64 约 3.78 GB，linux/arm64 约 2.81 GB。`latest` 和 `rocm` 都会移动，不写入本文命令。AMD GPU 才需要 `0.40.4-rocm`。请使用 **0.40.4**，不要使用 **0.35.0** 之前的版本。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`0.40.4`** | 具体版本 0.40.4 | **是** |
| `latest` | 浮动标签 | 否 |
| `0.40.4-rocm` | AMD GPU | 否 |
| `rocm` | AMD GPU 的浮动标签 | 否 |

完整标签见 [openwebui/open-webui 标签列表](https://xuanyuan.cloud/r/openwebui/open-webui/tags) 与 [ollama/ollama 标签列表](https://xuanyuan.cloud/r/ollama/ollama/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**：

```bash
docker pull docker.xuanyuan.run/openwebui/open-webui:0.12.0
docker pull docker.xuanyuan.run/ollama/ollama:0.40.4
```

两条都完成后，再写下面的 Compose。

## Docker Compose 部署

模型文件在宿主机目录 `ollama/`，对应容器内 `/root/.ollama`。账号和聊天记录在 `data/`，对应容器内 `/app/backend/data`。删除这两个目录会丢掉模型和对话。`docker compose down` 不加额外参数时，不会删除这两个目录。

`data/` 里已经有管理员账号时，不要重新执行写入 `compose.yaml` 的那一步。新的 `WEBUI_SECRET_KEY` 和已经写入的数据对不上时，已登录会话会失效。沿用 `webui_secret_key.txt` 里原来的密钥。

11434 只给本机检查 Ollama API。Open WebUI 在 Compose 网络里访问 `http://ollama:11434`，不走宿主机端口。容器内 Open WebUI 监听 8080，宿主机映到 3002，避开本机常见的 3000。

以前用 `docker run` 创建过同名容器时，先删掉容器再启动 Compose。这一步不删除命名卷。

1. 创建目录，并把所有权交给当前用户，后面的 `cat` 才能写进去：

```bash
sudo mkdir -p /www/wwwroot/open-webui/data /www/wwwroot/open-webui/ollama
sudo chown -R "$USER":"$USER" /www/wwwroot/open-webui
```

同名容器还在时：

```bash
docker rm -f ollama open-webui
```

2. 生成密钥并写入 `compose.yaml`。`umask 077` 让 `webui_secret_key.txt` 和 `compose.yaml` 只有当前用户可读；写完后把 umask 调回 `022`。

```bash
cd /www/wwwroot/open-webui
WEBUI_SECRET_KEY="$(openssl rand -hex 32)"
umask 077
printf '%s
' "$WEBUI_SECRET_KEY" > webui_secret_key.txt
cat > compose.yaml <<EOF
name: open-webui

services:
  ollama:
    image: docker.xuanyuan.run/ollama/ollama:0.40.4
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ./ollama:/root/.ollama

  open-webui:
    image: docker.xuanyuan.run/openwebui/open-webui:0.12.0
    container_name: open-webui
    restart: unless-stopped
    depends_on:
      - ollama
    environment:
      OLLAMA_BASE_URL: http://ollama:11434
      WEBUI_SECRET_KEY: ${WEBUI_SECRET_KEY}
    ports:
      - "3002:8080"
    volumes:
      - ./data:/app/backend/data
EOF
umask 022
unset WEBUI_SECRET_KEY
```

3. 启动两个服务：

```bash
cd /www/wwwroot/open-webui
docker compose up -d
```

4. 看状态。两个服务都应为 Up。open-webui 的端口是 `0.0.0.0:3002->8080/tcp`，ollama 是 `0.0.0.0:11434->11434/tcp`。

```bash
docker compose ps
```

5. 下载示例模型 qwen:0.5b。这个模型体积小，适合先确认网页和 Ollama 已经连上。要换别的模型时，把模型名换成 [Ollama 模型库](https://ollama.com/library/qwen) 里的名字，再执行同样的命令。

```bash
docker exec -it ollama ollama pull qwen:0.5b
```

6. 查看已经下载的模型：

```bash
docker exec -it ollama ollama list
```

下载成功时，列表里有 `qwen:0.5b`，大小约 394 MB：

```text
NAME        SIZE
qwen:0.5b   394MB
```

7. 在 Open WebUI 容器里访问 Ollama。返回的 JSON 里，`models` 中应有 `"name": "qwen:0.5b"`。

```bash
docker exec -it open-webui curl http://ollama:11434/api/tags
```

本机也可以直接看 Ollama：

```bash
curl http://127.0.0.1:11434/api/tags
```

## 在浏览器里开始对话

两个容器都是 Up，并且 `ollama list` 里已经有 qwen:0.5b 之后，再打开浏览器。第一次启动 Open WebUI 时，容器会做数据库迁移，日志里会出现 `INFO [alembic.runtime.migration]`。页面还打不开时，先等 1 到 2 分钟，再刷新。

在跑 Docker 的这台机器上打开：

```text
http://127.0.0.1:3002
```

从别的电脑访问时，把 `127.0.0.1` 换成这台机器的 IP，例如 `http://服务器IP:3002`。云服务器还要在安全组里放行 **3002**。不要为了访问网页去放行 11434。

欢迎页上点击「开始使用」。

![Open WebUI 欢迎页，下方按钮为开始使用](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama.png)

下一页标题是「开始使用 Open WebUI」。页面写明：Open WebUI 不会与外部建立任何连接，数据会存放在本地托管的服务器上。填写「名称」「电子邮箱」「密码」，点击「创建管理员账号」。这里没有预置账号。第一个注册用户就是管理员。

![创建管理员账号，需填写名称、电子邮箱和密码](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama-2.png)

登录后，左上角的模型选择里应能看到 **qwen:0.5b**。选中它。界面右上角会出现「已登录。」

![登录后模型已选中 qwen:0.5b](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama-5.png)

在输入框里发一句话。回复出现在对话区域后，这条链路就通了。

![使用 qwen:0.5b 进行对话](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama-6.png)

以后要再增加模型，在服务器上执行：

```bash
docker exec -it ollama ollama pull 模型名
```

把「模型名」换成 Ollama 模型库中的名字。拉取完成后刷新 Open WebUI，新模型会出现在模型列表里。

## 备选：docker run

上面的 Compose 已经在跑时，停在那里即可，不必再做这一节。

没有 Compose、只想短期打开看看时，用两条 `docker run`。两个容器必须在同一个 Docker 网络里，Open WebUI 才能解析主机名 `ollama`。3002 上已经有 Compose 里的容器时，先停掉它，否则这条命令起不来。数据目录用 `/www/wwwroot/open-webui-run`，不要挂上面的 `data/` 和 `ollama/`。

```bash
cd /www/wwwroot/open-webui
docker compose down
```

```bash
docker network create open-webui-net
sudo mkdir -p /www/wwwroot/open-webui-run/data /www/wwwroot/open-webui-run/ollama
sudo chown -R "$USER":"$USER" /www/wwwroot/open-webui-run
cd /www/wwwroot/open-webui-run
WEBUI_SECRET_KEY="$(openssl rand -hex 32)"
umask 077
printf '%s
' "$WEBUI_SECRET_KEY" > webui_secret_key.txt
umask 022
docker run -d 
  --name ollama 
  --network open-webui-net 
  --restart unless-stopped 
  -p 11434:11434 
  -v /www/wwwroot/open-webui-run/ollama:/root/.ollama 
  docker.xuanyuan.run/ollama/ollama:0.40.4
docker run -d 
  --name open-webui 
  --network open-webui-net 
  --restart unless-stopped 
  -p 3002:8080 
  -e OLLAMA_BASE_URL=http://ollama:11434 
  -e WEBUI_SECRET_KEY="$WEBUI_SECRET_KEY" 
  -v /www/wwwroot/open-webui-run/data:/app/backend/data 
  docker.xuanyuan.run/openwebui/open-webui:0.12.0
unset WEBUI_SECRET_KEY
```

网络已经存在时，`docker network create` 会提示已存在，继续执行后面的命令即可。

然后下载模型，并确认 Open WebUI 能访问 Ollama：

```bash
docker exec -it ollama ollama pull qwen:0.5b
docker exec -it ollama ollama list
docker exec -it open-webui curl http://ollama:11434/api/tags
```

`ollama list` 里出现 `qwen:0.5b`，并且 `curl` 返回的 JSON 里有这个模型名之后，浏览器打开 `http://127.0.0.1:3002`，按「在浏览器里开始对话」填写。

试用结束、要回到 Compose 时，停掉这两个容器，再启动原来的 Compose。不要重新生成 `/www/wwwroot/open-webui/webui_secret_key.txt`。

```bash
docker stop open-webui ollama && docker rm open-webui ollama
cd /www/wwwroot/open-webui
docker compose up -d
```

## 常见问题

**Q1：Open WebUI 里看不到模型？**

先看这三件事：

1. `docker exec -it ollama ollama list` 里是否已有 `qwen:0.5b`。没有的话，先执行 `ollama pull`。
2. `compose.yaml` 里是否有 `OLLAMA_BASE_URL: http://ollama:11434`。主机名是服务名 `ollama`，端口是容器内的 11434。
3. 在 Open WebUI 容器里执行 `docker exec -it open-webui curl http://ollama:11434/api/tags`。JSON 里有模型名时，刷新浏览器。

仍然是空列表时，再重启两个服务：

```bash
cd /www/wwwroot/open-webui
docker compose restart
```

**Q2：出现 Could not resolve host: ollama 怎么办？**

这表示当前容器解析不到主机名 `ollama`。Compose 部署时，两个服务要在同一份 `compose.yaml` 里，Open WebUI 的环境变量使用 `http://ollama:11434`。

用 `docker run` 启动时，两条命令都要带 `--network open-webui-net`。Open WebUI 没进这个网络时，可以执行：

```bash
docker network connect open-webui-net open-webui
```

**Q3：本机能打开 Ollama，网页里仍然没有模型？**

先确认 Ollama 容器在运行：

```bash
docker ps
```

列表里没有 `ollama` 时：

```bash
docker start ollama
```

再在宿主机上执行：

```bash
curl http://127.0.0.1:11434/api/tags
```

这里能返回模型，说明 Ollama 本身在监听。接着按 Q1 检查 `OLLAMA_BASE_URL` 和容器网络。

**Q4：页面要等很久才打开？**

第一次启动时，日志里的 `INFO [alembic.runtime.migration]` 表示正在做数据库迁移。等 1 到 2 分钟再刷新 `http://127.0.0.1:3002`。

看日志：

```bash
cd /www/wwwroot/open-webui
docker compose logs --tail 80 open-webui
```

**Q5：3002 端口被占用怎么办？**

把宿主机端口改成别的，容器内仍是 8080。例如改成 18080 时，Compose 里写成 `"18080:8080"`，再执行 `docker compose up -d`。浏览器访问 `http://127.0.0.1:18080`。

用 `docker run` 启动时，把 `-p 3002:8080` 改成同样的宿主机端口。不要把宿主机端口改成 3000。

**Q6：数据和模型在哪里？**

Compose 部署时，模型在 `/www/wwwroot/open-webui/ollama`，账号和聊天记录在 `/www/wwwroot/open-webui/data`。密钥在 `/www/wwwroot/open-webui/webui_secret_key.txt`。

以前用命名卷 `-v ollama:/root/.ollama` 和 `-v open-webui:/app/backend/data` 时，文件在 Docker 的命名卷里，不在这两个目录中。要沿用旧数据，把 `compose.yaml` 里的卷改回原来的命名卷，不要删除那些卷。

**Q7：如何升级？**

先保留 `data/`、`ollama/` 和 `webui_secret_key.txt`。本文命令使用 Open WebUI `0.12.0`、Ollama `0.40.4`。要升到更新的具体版本时，把 `compose.yaml` 里的标签改成那个版本号，然后执行：

```bash
cd /www/wwwroot/open-webui
docker compose pull
docker compose up -d
```

不要把标签改成 `latest`、`0.12` 或 `rocm`。数据目录和密钥文件保持不动。

**Q8：如何停止？**

确认还需要模型和聊天记录时，不要删除 `data/` 和 `ollama/`。

Compose 停止并保留目录：

```bash
cd /www/wwwroot/open-webui
docker compose down
```

用 `docker run` 启动的：

```bash
docker stop open-webui ollama && docker rm open-webui ollama
```

站点不再需要时，再删除数据目录：

```bash
rm -rf /www/wwwroot/open-webui/data /www/wwwroot/open-webui/ollama /www/wwwroot/open-webui-run
```

**Q9：可以把 11434 暴露到公网吗？**

不要。Ollama 的 HTTP API 默认不校验登录。本文把 11434 映到宿主机，只为了在这台机器上执行 `curl http://127.0.0.1:11434/api/tags`。对外只放行网页用的 3002，并配上你自己的访问控制。

**Q10：能用 GPU 吗？**

本文按 CPU 编写。NVIDIA GPU 或 AMD GPU 的启动参数见 [ollama/ollama 镜像页](https://xuanyuan.cloud/r/ollama/ollama)。换 GPU 镜像时，仍然使用具体版本标签，例如 AMD 用 `ollama/ollama:0.40.4-rocm`，不要改成浮动的 `rocm`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/openwebui/open-webui:0.12.0
docker pull docker.xuanyuan.run/ollama/ollama:0.40.4

cd /www/wwwroot/open-webui
docker compose up -d
docker compose ps
docker exec -it ollama ollama pull qwen:0.5b
docker exec -it ollama ollama list
docker exec -it open-webui curl http://ollama:11434/api/tags
curl http://127.0.0.1:11434/api/tags

docker compose logs --tail 80 open-webui
docker compose down
```

没有 Compose 时用「备选：docker run」里的命令。浏览器打开 `http://127.0.0.1:3002`，点击「开始使用」，再创建管理员。模型选 **qwen:0.5b**。密钥在 `webui_secret_key.txt`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [openwebui/open-webui 镜像页](https://xuanyuan.cloud/zh/r/openwebui/open-webui) | [https://xuanyuan.cloud/zh/r/openwebui/open-webui](https://xuanyuan.cloud/zh/r/openwebui/open-webui) |
| [openwebui/open-webui 概览](https://xuanyuan.cloud/r/openwebui/open-webui) | [https://xuanyuan.cloud/r/openwebui/open-webui](https://xuanyuan.cloud/r/openwebui/open-webui) |
| [openwebui/open-webui 标签列表](https://xuanyuan.cloud/r/openwebui/open-webui/tags) | [https://xuanyuan.cloud/r/openwebui/open-webui/tags](https://xuanyuan.cloud/r/openwebui/open-webui/tags) |
| [ollama/ollama 镜像页](https://xuanyuan.cloud/zh/r/ollama/ollama) | [https://xuanyuan.cloud/zh/r/ollama/ollama](https://xuanyuan.cloud/zh/r/ollama/ollama) |
| [ollama/ollama 概览](https://xuanyuan.cloud/r/ollama/ollama) | [https://xuanyuan.cloud/r/ollama/ollama](https://xuanyuan.cloud/r/ollama/ollama) |
| [ollama/ollama 标签列表](https://xuanyuan.cloud/r/ollama/ollama/tags) | [https://xuanyuan.cloud/r/ollama/ollama/tags](https://xuanyuan.cloud/r/ollama/ollama/tags) |
| [Docker Hub · openwebui/open-webui](https://hub.docker.com/r/openwebui/open-webui) | [https://hub.docker.com/r/openwebui/open-webui](https://hub.docker.com/r/openwebui/open-webui) |
| [Docker Hub · ollama/ollama](https://hub.docker.com/r/ollama/ollama) | [https://hub.docker.com/r/ollama/ollama](https://hub.docker.com/r/ollama/ollama) |
| [GitHub · open-webui/open-webui](https://github.com/open-webui/open-webui) | [https://github.com/open-webui/open-webui](https://github.com/open-webui/open-webui) |
| [Release v0.12.0](https://github.com/open-webui/open-webui/releases/tag/v0.12.0) | [https://github.com/open-webui/open-webui/releases/tag/v0.12.0](https://github.com/open-webui/open-webui/releases/tag/v0.12.0) |
| [GitHub · ollama/ollama](https://github.com/ollama/ollama) | [https://github.com/ollama/ollama](https://github.com/ollama/ollama) |
| [Release v0.40.4](https://github.com/ollama/ollama/releases/tag/v0.40.4) | [https://github.com/ollama/ollama/releases/tag/v0.40.4](https://github.com/ollama/ollama/releases/tag/v0.40.4) |
| [Open WebUI Quick Start](https://docs.openwebui.com/getting-started/quick-start/) | [https://docs.openwebui.com/getting-started/quick-start/](https://docs.openwebui.com/getting-started/quick-start/) |
| [Ollama 模型库 · qwen](https://ollama.com/library/qwen) | [https://ollama.com/library/qwen](https://ollama.com/library/qwen) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/open-webui-docker-deploy


