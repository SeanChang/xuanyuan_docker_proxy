# Docker 部署 Codex CLI：轻松搭建终端 AI 编程环境

![Docker 部署 Codex CLI：轻松搭建终端 AI 编程环境](https://imgs.xuanyuan.cloud/docker/blog/codex-docker/codex-docker.webp)

*分类: Docker部署教程 | 标签: Codex CLI,OpenAI,Docker,轩辕镜像,终端编程,部署教程 | 发布时间: 2026-10-24 22:16:43*

> Codex CLI 是一款面向开发者的开源终端编程代理，旨在阅读并修改项目目录中的代码，并通过终端会话把修改留在工作目录里。本文将介绍如何通过 Docker Compose 部署 Codex CLI，搭建隔离的终端编程环境，帮助开发者在容器里登录并处理项目，适合本机使用及脚本中的单次任务等场景。

*本文基于 [naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim](https://xuanyuan.cloud/zh/r/naoyoshinori/codex)，以 **Codex CLI 0.164.0** 版本实测，基础镜像 **Node.js 24 bookworm-slim**，测试平台 **Ubuntu 24.04** Linux。*

## Codex CLI 是什么

Codex CLI 是 OpenAI 的终端编程代理，在你的电脑上阅读项目并修改代码。本文使用的镜像是社区项目 `naoyoshinori/codex`。镜像里已经装好 Node.js 和 Codex CLI，进程以普通用户 `node` 运行。镜像作者说明，这个项目不隶属于 OpenAI。

与在宿主机安装 Node.js 再全局安装命令相比，这份镜像把工具留在容器里。项目文件从目录挂进去，配置和会话记录放在单独的数据目录。

## Codex CLI 能做什么

- **在终端里处理项目**：对着工作目录说明任务，由 Codex 阅读并修改文件。
- **选择登录方式**：可以用 ChatGPT 账号、设备码、API 密钥或 Amazon Bedrock。
- **留下配置和会话**：配置和历史写在单独的数据目录里，下次进入还可以用。
- **查看会话并更换模型**：可以查看当前会话、限制 Codex 能做的事，并更换模型。
- **交给脚本跑完即停**：给一句任务说明，做完就退出，适合放进脚本或持续集成。

## 为什么要使用 Codex CLI

在宿主机安装 Codex CLI，要先准备 Node.js。换一台机器时，CLI 版本也不容易保持一致。

这份镜像把 Node.js 和 CLI 放在一起，项目目录单独挂载。适合不想在系统里全局安装 Node.js 的人，也适合希望脚本每次使用同一份 CLI 版本的人。

## 使用 Docker 部署 Codex CLI

用 Docker 运行 Codex CLI，宿主机不必再安装 Node.js。开始之前准备好 Docker。登录可以用 API 密钥，也可以在第一次进入时再选其他方式。

接下来用 Docker Compose 写好目录和密钥，启动容器，进入容器核对版本并完成登录。

## 环境要求

本文使用 **`naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim`** 版本实测。镜像内的 Codex CLI 是 **0.164.0**，基础系统是 **Node.js 24** 的 Debian bookworm slim。

| 项目 | 建议 |
|------|------|
| 系统 | Linux（正文命令按 bash）。macOS 把 `/www/wwwroot/codex` 换成 `~/docker/codex`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 架构 | **linux/amd64**、**linux/arm64** |
| 磁盘 | 2026-10-24 Docker Hub 列出的压缩体积：amd64 约 430 MB，arm64 约 416 MB。配置目录和项目文件另计 |
| 端口 | 不发布端口。使用方式是进入容器执行命令 |
| 工作目录 | `/www/wwwroot/codex` |
| 数据 | `codex-home` 挂到容器内 `/home/node/.codex`，保存配置和会话。`workspace` 挂到 `/workspace`，放项目文件 |
| 密钥 | 环境变量 `OPENAI_API_KEY`，写在工作目录的 `.env`。镜像没有预置密钥 |
| 用户 | 容器以 `node` 运行。官方 Node 镜像里该用户的 uid、gid 是 1000 |

`.env` 的属主是你自己的用户，权限设为仅本人可读。`codex-home` 和 `workspace` 交给 uid 1000，Codex 才能写入。你的登录用户如果也是 1000，可以直接改这两个目录里的文件。

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

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > … <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

仓库不提供 `latest`。短标签 `0-node` 指向当前 Node.js LTS（目前是 Node.js 24）上最新的 Codex CLI 0.x，基础镜像是 `24-bookworm-slim`。`0.<次要版本>-node` 会跟到该次要版本的最新补丁。`patch-<版本>-…` 对应某一次 Codex CLI 发布。

2026-10-24 查看 Docker Hub 时，`0-node`、`0.164-node`、`0-node-24-bookworm-slim`、`0.164-node-24-bookworm-slim` 和 `patch-0.164.0-node-24-bookworm-slim` 指向同一份镜像。下面的命令使用 **`patch-0.164.0-node-24-bookworm-slim`**。`0-node` 在以后的 0.x 发布后会改指向，不要写进命令。

| 标签 | 说明 | 是否写入本文命令 |
|------|------|------------------|
| **`patch-0.164.0-node-24-bookworm-slim`** | Codex CLI 0.164.0，Node.js 24 bookworm-slim。当前与 `0-node` 是同一份镜像 | **是** |
| `0-node` | 最新 Codex CLI 0.x，Node.js 24 slim。以后会变 | 否 |
| `0.164-node` | 0.164 这一次要版本的最新补丁。出现更高补丁号时会变 | 否 |
| `0-node-24-bookworm-slim` | 固定 Node.js 24 slim，Codex CLI 仍会跟到最新 0.x | 否 |
| `patch-0.164.0-javascript-node-24-bookworm` | JavaScript 开发容器。当前与 `0-javascript-node` 是同一份镜像，amd64 压缩体积约 925 MB | 否 |
| `patch-0.164.0-typescript-node-24-bookworm` | TypeScript 开发容器。当前与 `0-typescript-node` 是同一份镜像，amd64 压缩体积约 1045 MB | 仅「可选：VS Code 开发容器」 |
| `latest` | 仓库不提供 | 否 |

Node 变体另有 22 与 26。本文使用 24，因为仓库把 `0-node` 指到 Node.js 24。JavaScript、TypeScript 变体留给编辑器开发容器，体积更大，其中的 `node` 用户可以使用 sudo。本文这份最小镜像没有安装 sudo。

完整标签见 [Codex 标签列表](https://xuanyuan.cloud/r/naoyoshinori/codex/tags)。

## 拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**。

```bash
docker pull docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim
```

Ubuntu 24.04 实测：

```text
patch-0.164.0-node-24-bookworm-slim: Pulling from naoyoshinori/codex
23ea101ead8d: Pull complete
c0e48fd1aa25: Pull complete
5255c1ebca51: Pull complete
11422d7ca1a4: Pull complete
47e82ed2c720: Pull complete
6d793208473a: Pull complete
f2b8e65232e1: Pull complete
44136fa355b3: Download complete
bfdc26ba189b: Download complete
Digest: sha256:838a0d2ffa9c9ea3d163fa7c657d06f11678d61b523aacb43646695b44f165dd
Status: Downloaded newer image for docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim
docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim
```

完成后，再写下面的 Compose。

## Docker Compose 部署

这一套只有一个容器。它不提供网页，Compose 里不要写 `ports`。容器的主命令是 `sleep infinity`，用来保持运行。需要 Codex 时再执行 `docker compose exec`。不写这条命令时，镜像会按基础镜像去启动 Node.js，而不是留一个可以进入的环境。

密钥放在 `/www/wwwroot/codex/.env`，不要写进 `compose.yaml`，也不要放进 `workspace`。Codex 能读取挂进 `/workspace` 的文件。

| 宿主机路径 | 容器路径 | 内容 |
|------------|----------|------|
| `/www/wwwroot/codex/codex-home` | `/home/node/.codex` | 配置和会话 |
| `/www/wwwroot/codex/workspace` | `/workspace` | 项目文件 |
| `/www/wwwroot/codex/.env` | 不挂载 | `OPENAI_API_KEY`，由 Compose 在启动时读入 |

以前用 `docker run` 创建过名为 `codex` 的容器时，先删掉容器再启动 Compose。这一步不删除 `codex-home` 和 `workspace`。

1. 创建目录。Compose 文件留在你的用户名下，后面的 `cat` 才能写入。`codex-home` 和 `workspace` 交给 uid 1000。

```bash
sudo mkdir -p /www/wwwroot/codex/codex-home /www/wwwroot/codex/workspace
sudo chown "$USER":"$USER" /www/wwwroot/codex
sudo chown -R 1000:1000 /www/wwwroot/codex/codex-home /www/wwwroot/codex/workspace
```

同名容器还在时：

```bash
docker rm -f codex
```

2. 写入密钥文件。把 `YOUR_API_KEY_HERE` 换成你在 [OpenAI API keys](https://platform.openai.com/api-keys) 创建的密钥。等号右边不要加引号，密钥本身也不要包含空格。写完立刻收紧权限。这个文件不要提交到 Git。

```bash
cd /www/wwwroot/codex
cat > .env <<'EOF'
OPENAI_API_KEY=YOUR_API_KEY_HERE
EOF
chmod 600 .env
```

3. 写入 `compose.yaml`：

```bash
cd /www/wwwroot/codex
cat > compose.yaml <<'EOF'
name: codex

services:
  codex:
    image: docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim
    container_name: codex
    restart: unless-stopped
    working_dir: /workspace
    env_file:
      - .env
    volumes:
      - ./codex-home:/home/node/.codex
      - ./workspace:/workspace
    command: ["sleep", "infinity"]
EOF
```

容器异常退出后会自动再启动。手动 `docker compose stop` 之后，不会被拉起来。

4. 启动。`.env` 里仍是 `YOUR_API_KEY_HERE` 时，先换成你的密钥。

```bash
cd /www/wwwroot/codex
docker compose up -d
```

Ubuntu 24.04 实测。执行这条命令时容器已经在跑，所以输出是 Running。第一次创建后，以 `docker compose ps` 里的 STATUS 为 Up、PORTS 为空为准。

```text
[+] up 1/1
 ✔ Container codex Running                                                                                                                                                                           0.0s
```

5. 看状态。名为 `codex` 的容器应为 Up。这份 Compose 没有端口映射，`PORTS` 一列是空的。

```bash
cd /www/wwwroot/codex
docker compose ps
```

Ubuntu 24.04 实测：

```text
NAME      IMAGE                                                                        COMMAND                  SERVICE   CREATED         STATUS         PORTS
codex     docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim   "docker-entrypoint.s…"   codex     4 minutes ago   Up 4 minutes
```

6. 确认容器用户。`codex-home` 和 `workspace` 的属主要和这里的 uid、gid 一致。

```bash
cd /www/wwwroot/codex
docker compose exec codex id
```

Ubuntu 24.04 实测：

```text
uid=1000(node) gid=1000(node) groups=1000(node),999(npm)
```

本文输出里 uid 和 gid 都是 1000，目录属主按 1000。`999(npm)` 是镜像里的 npm 组，不用把它写进 `chown`。输出若不是 `uid=1000(node)`，把目录属主改成输出里的 uid 和 gid。

## 在容器里使用 Codex

容器起来之后，先核对版本，再进入登录界面。核对版本不访问 OpenAI 的接口。要让 Codex 修改代码时，再把项目放进 `workspace`。

1. 核对版本。

```bash
cd /www/wwwroot/codex
docker compose exec codex codex --version
```

Ubuntu 24.04 实测：

```text
codex-cli 0.164.0
```

输出与标签中的 `0.164.0` 一致。这条命令不打开登录页。

2. 打开交互界面。`-it` 把你的终端接到容器里。离开 Codex 之后，容器继续在后台运行。

`.env` 里已经有 `OPENAI_API_KEY` 时，第一次进入仍会先显示登录列表。

```bash
cd /www/wwwroot/codex
docker compose exec -it codex codex
```

![Codex CLI 首次进入：登录方式列表，光标停在 Sign in with ChatGPT](https://imgs.xuanyuan.cloud/docker/blog/codex-docker/codex-docker-1.webp)

标题是 `Welcome to Codex, OpenAI's command-line coding agent`。光标停在第 1 项。四项是：

- **Sign in with ChatGPT**：说明写着 Plus、Pro、Business 和 Enterprise 计划已包含用量。
- **Sign in with Device Code**：用一次性代码在另一台设备上登录。
- **Use an OpenAI API key**：按用量付费。
- **Use Amazon Bedrock**：使用 AWS 凭证。

底部是 `Press enter to continue`。方向键移到第 3 项，再按回车。

3. 保存 API 密钥。这一页会读到环境变量 `OPENAI_API_KEY`，并把 `.env` 里的值填进输入框。确认是你自己的密钥后，按回车保存。按 `esc` 回到上一屏。

![Codex CLI API 密钥页：已检测到 OPENAI_API_KEY，输入框为 YOUR_API_KEY_HERE](https://imgs.xuanyuan.cloud/docker/blog/codex-docker/codex-docker-2.webp)

标题是 `Use your own OpenAI API key for usage-based billing`。提示语包括 `Detected OPENAI_API_KEY environment variable.` 和 `Press enter to save`。截图里的输入框是 `YOUR_API_KEY_HERE`，因为这次 `.env` 写的是占位符。保存前先换成你的密钥；已经启动过容器的，改完文件后执行 `docker compose up -d`，再重新进入这一页。

4. 进入主界面。标题是 `OpenAI Codex (v0.164.0)`，当前目录是 `/workspace`。

![Codex CLI 主界面：版本 v0.164.0，目录 /workspace，已输入 hello，状态为 Working，模型 GPT-6.1-Sol default](https://imgs.xuanyuan.cloud/docker/blog/codex-docker/codex-docker-3.webp)

屏幕上的命令与说明是：

- `/init`：创建带有 Codex 说明的 `AGENTS.md`。
- `/status`：查看当前会话配置。
- `/permissions`：选择 Codex 可以做什么。
- `/model`：选择模型和 reasoning effort。
- `/review`：查看改动并找问题。

本文在输入框发送了 `hello`。状态行停在 `Working (2s • esc to interrupt)`，`esc` 中断这一次任务。底部左侧是 `Ask Codex to do anything`，模型行是 `GPT-6.1-Sol default`，目录仍是 `/workspace`。`?` 查看快捷键。右侧是 `1 warning`。按 `f2` 打开警告原文，看清内容再处理。

5. 要修改项目时，再把文件复制进工作目录。`/path/to/project` 换成实际路径。不要把 `.env` 复制进去。复制之后把属主改回 1000，Codex 才能写文件。

```bash
sudo cp -a /path/to/project/. /www/wwwroot/codex/workspace/
sudo chown -R 1000:1000 /www/wwwroot/codex/workspace
```

空的 `workspace` 可以打开上面的主界面。没有项目文件时，不要让 Codex 修改代码。

6. 只跑一句任务时，用非交互方式。`workspace` 里需要已经有项目文件。Codex 有权限修改这些文件。跑之前确认这个目录里的内容可以改。

```bash
cd /www/wwwroot/codex
docker compose exec codex codex exec "Explain the structure of this repository"
```

这句英文来自镜像仓库的示例，用来说明当前仓库的结构。你可以换成自己的任务。这条命令会访问 OpenAI 的接口。

要在容器里先进入 shell，再用 Codex：

```bash
cd /www/wwwroot/codex
docker compose exec -it codex bash
```

## 可选：VS Code 开发容器

主路径仍是上面的 Compose。编辑器要打开开发容器时，改用 TypeScript 变体。它当前与 `0-typescript-node` 是同一份镜像，amd64 压缩体积约 1045 MB，并带有 TypeScript 工具。`node` 用户在这个变体里可以使用 sudo。

先拉取：

```bash
docker pull docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-typescript-node-24-bookworm
```

当前用户要能在 `workspace` 里建目录。写不进去时，先把 `workspace` 临时交给当前用户，写完再改回 1000。

```bash
mkdir -p /www/wwwroot/codex/workspace/.devcontainer
cat > /www/wwwroot/codex/workspace/.devcontainer/devcontainer.json <<'EOF'
{
  "image": "docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-typescript-node-24-bookworm",
  "postCreateCommand": "codex --version",
  "remoteUser": "node"
}
EOF
sudo chown -R 1000:1000 /www/wwwroot/codex/workspace
```

用 VS Code 打开 `workspace`，选择在容器中重新打开。`postCreateCommand` 会执行 `codex --version`。这里使用的标签是 `patch-0.164.0-typescript-node-24-bookworm`。

## 安全说明

`.env` 权限保持 `600`，不要放进 `workspace`，不要提交到 Git。能在这台机器上执行 Docker 命令的人，可以看到容器环境变量里的密钥。登录页的输入框也会显示这个值。真实密钥不要跟着截图发出去。

`workspace` 里的文件会被 Codex 修改。放进去之前，先确认这些文件可以改。配置和会话留在 `codex-home`。删除这个目录会丢掉已经保存的会话。

需要和宿主机相同的 Git 身份时，再按「常见问题」增加 `gitconfig` 挂载。文件不存在就不要挂。

## 备选：docker run

没有 Docker Compose 时用这一节。不要和已经启动的 Compose 容器同时写同一份 `codex-home`。先停掉 Compose：

```bash
cd /www/wwwroot/codex
docker compose stop
```

目录和 `.env` 仍用「Docker Compose 部署」里创建的那一套。`docker run` 的 `--rm` 只删除这次的容器，不删除宿主机上的 `codex-home` 和 `workspace`。

1. 打开交互界面。结束会话后容器删除，配置仍留在 `codex-home`。第一次运行的登录画面与「在容器里使用 Codex」相同。

```bash
docker run -it --rm 
  --env-file /www/wwwroot/codex/.env 
  -v /www/wwwroot/codex/codex-home:/home/node/.codex 
  -v /www/wwwroot/codex/workspace:/workspace 
  -w /workspace 
  docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim 
  codex
```

2. 只跑一句任务：

```bash
docker run --rm 
  --env-file /www/wwwroot/codex/.env 
  -v /www/wwwroot/codex/codex-home:/home/node/.codex 
  -v /www/wwwroot/codex/workspace:/workspace 
  -w /workspace 
  docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim 
  codex exec "Explain the structure of this repository"
```

3. 用完若还要回到 Compose，再启动原来的容器：

```bash
cd /www/wwwroot/codex
docker compose start
```

## 常见问题

**复制项目时提示 No such file or directory？**

`/path/to/project` 要换成实际目录。直接执行这个占位路径时，输出是：

```text
cp: cannot stat '/path/to/project/.': No such file or directory
```

`workspace` 此时仍是空的。核对版本和打开登录界面不依赖这里有项目文件。

**密钥改了，容器里仍是旧的？**

Compose 在启动时读取 `.env`。只改文件不会更新已经在跑的容器。确认变量名是 `OPENAI_API_KEY`，等号右边不是 `YOUR_API_KEY_HERE`，然后重新创建容器：

```bash
cd /www/wwwroot/codex
docker compose up -d
```

**写不进配置或项目？**

先看容器用户：

```bash
cd /www/wwwroot/codex
docker compose exec codex id
```

再把两个目录交给这个 uid。输出是 `uid=1000(node)` 时：

```bash
sudo chown -R 1000:1000 /www/wwwroot/codex/codex-home /www/wwwroot/codex/workspace
```

uid 不是 1000 时，把命令里的 `1000:1000` 换成输出里的 uid 和 gid。

**挂上 gitconfig 之后，宿主机那个路径变成了目录？**

`$HOME/.gitconfig` 必须先是一个文件。路径不存在时，Docker 会在那里创建一个目录，Git 随后读不到配置。

先确认它是这次误建的空目录，再删掉。不要在没有看清内容时删除已有的配置文件。

```bash
cd /www/wwwroot/codex
docker compose stop
rmdir "$HOME/.gitconfig"
```

`rmdir` 只能删除空目录。它不是空目录时，先检查里面的内容，不要改用 `rm -rf`。

准备好真正的 Git 配置文件之后，在 `compose.yaml` 已有的 `volumes` 最后增加一行，不要覆盖整个文件：

```yaml
      - ${HOME}/.gitconfig:/home/node/.gitconfig:ro
```

这一行是只读挂载，避免容器改写宿主机配置。然后执行 `docker compose up -d`。

**最小镜像里能执行 apt-get 吗？**

不能。这份最小镜像的 `node` 用户没有 sudo。需要 sudo 或其他开发工具时，换「可选：VS Code 开发容器」里的 TypeScript 标签，或 JavaScript 标签 `patch-0.164.0-javascript-node-24-bookworm`。

**容器起来后，日志里没有就绪字样？**

主命令是 `sleep infinity`，容器没有网页端口。是否可用，看「在容器里使用 Codex」里的 `codex --version`。输出为 `codex-cli 0.164.0` 即可。

**如何升级？**

本文命令使用 `patch-0.164.0-node-24-bookworm-slim`。要换更新的具体发布时，先在 [标签列表](https://xuanyuan.cloud/r/naoyoshinori/codex/tags) 确认 `patch-` 开头的标签，再改 `compose.yaml` 里的 `image`，然后执行：

```bash
cd /www/wwwroot/codex
docker compose pull
docker compose up -d
```

不要把标签改成 `0-node` 或 `latest`。仓库没有 `latest`。`0-node` 会在新的 0.x 发布后改指向。`codex-home` 保持不动。

**如何停止与删除？**

还要保留配置和项目时，不要删除目录：

```bash
cd /www/wwwroot/codex
docker compose down
```

`down` 不加 `-v`。本文的数据在绑定挂载里，不在 Compose 命名卷里。

不再使用时，先确认 `.env` 里的密钥已经另存或不需要，再删除整个目录。这一步会同时删除密钥、会话和 `workspace` 里的项目副本：

```bash
rm -rf /www/wwwroot/codex
```

用 `docker run --rm` 启动的容器在会话结束后自行删除，宿主机目录不受影响。

**和官方安装、网页版是什么关系？**

宿主机安装 Codex CLI 是另一条路径，不使用本文的镜像标签。Codex 网页版和编辑器插件也不读取这个容器里的 `/workspace`。本文只覆盖社区镜像 `naoyoshinori/codex`。

## 命令速查

```bash
docker pull docker.xuanyuan.run/naoyoshinori/codex:patch-0.164.0-node-24-bookworm-slim

cd /www/wwwroot/codex
docker compose up -d
docker compose ps
docker compose exec codex codex --version
docker compose exec -it codex codex
docker compose exec codex codex exec "Explain the structure of this repository"
docker compose down
```

没有 Compose 时，用「备选：docker run」里的命令。密钥文件是 `/www/wwwroot/codex/.env`。项目文件在 `/www/wwwroot/codex/workspace`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [naoyoshinori/codex 镜像页](https://xuanyuan.cloud/zh/r/naoyoshinori/codex) | [https://xuanyuan.cloud/zh/r/naoyoshinori/codex](https://xuanyuan.cloud/zh/r/naoyoshinori/codex) |
| [naoyoshinori/codex 概览](https://xuanyuan.cloud/r/naoyoshinori/codex) | [https://xuanyuan.cloud/r/naoyoshinori/codex](https://xuanyuan.cloud/r/naoyoshinori/codex) |
| [naoyoshinori/codex 标签列表](https://xuanyuan.cloud/r/naoyoshinori/codex/tags) | [https://xuanyuan.cloud/r/naoyoshinori/codex/tags](https://xuanyuan.cloud/r/naoyoshinori/codex/tags) |
| [GitHub · naoyoshinori/docker-codex](https://github.com/naoyoshinori/docker-codex) | [https://github.com/naoyoshinori/docker-codex](https://github.com/naoyoshinori/docker-codex) |
| [GitHub · openai/codex](https://github.com/openai/codex) | [https://github.com/openai/codex](https://github.com/openai/codex) |
| [Codex CLI 文档](https://learn.chatgpt.com/docs/codex/cli) | [https://learn.chatgpt.com/docs/codex/cli](https://learn.chatgpt.com/docs/codex/cli) |
| [Docker Hub · naoyoshinori/codex](https://hub.docker.com/r/naoyoshinori/codex) | [https://hub.docker.com/r/naoyoshinori/codex](https://hub.docker.com/r/naoyoshinori/codex) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/codex-docker-deploy


