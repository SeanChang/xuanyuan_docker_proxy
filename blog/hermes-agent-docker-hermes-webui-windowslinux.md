# 给 Hermes Agent 装个可视化面板！Docker 一键部署 Hermes WebUI 完整教程（Windows\+Linux 双环境）

![给 Hermes Agent 装个可视化面板！Docker 一键部署 Hermes WebUI 完整教程（Windows\+Linux 双环境）](https://img.xuanyuan.dev/docker/blog/docker-hermes-webui-1.png)

*分类: Hermes-Agent,部署教程,部署文档 | 标签: Hermes-Agent,部署教程,部署文档 | 发布时间: 2026-04-23 06:16:28*

> 用过 Hermes Agent 的朋友都知道，它的命令行模式虽然功能强大，但对新手和不想敲命令的朋友来说还是有点门槛。好消息是，它的 Web UI 终于来了！不用再对着黑框框敲命令，点一点就能配置、管理和使用，今天就给大家分享一下 Hermes WebUI 的完整部署教程。

用过 Hermes Agent 的朋友应该都知道，它的命令行操作对新手不太友好，很多简单的操作都需要记复杂指令，上手门槛不低。好在现在有了 Hermes WebUI，通过可视化界面就能轻松操作 Hermes Agent，极大降低了使用难度。今天就给大家详细讲解，如何在 Windows（PowerShell）和 Linux 环境下，用 Docker 快速部署 Hermes WebUI，实现本地 AI Web 界面的快速运行与访问。

先给大家放个 Hermes Agent 镜像中文地址：[https://xuanyuan\.cloud/zh/r/nousresearch/hermes\-agent](https://xuanyuan.cloud/zh/r/nousresearch/hermes-agent)，以及 Hermes WebUI 镜像中文地址：[https://xuanyuan\.cloud/ghcr\.io/nesquena/hermes\-webui?tag=latest](https://xuanyuan.cloud/ghcr.io/nesquena/hermes-webui?tag=latest)，有需要的可以提前收藏。

## 前置准备：Docker 环境一键搞定

部署 Hermes WebUI 之前，必须先搭好 Docker 环境。这里给大家准备了适配全场景的一键安装方案，Linux 系统（包括国产系统如银河麒麟、欧拉）可直接使用，Windows 和 Mac 用户操作也很简单。

### 1\. Linux 系统 Docker 一键安装

#### 🧪 测试环境（快速体验，仅限非生产）

直接执行一条命令，就能自动安装 Docker、Docker Compose，还会配置好轩辕镜像加速，省去手动配置的麻烦：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

#### 🏭 生产环境（推荐，安全优先）

企业或正式使用场景，建议先审计脚本内容，确认安全后再执行，更稳妥：

```bash
# 1. 下载脚本到本地
wget https://xuanyuan.cloud/docker.sh -O docker-install.sh

# 2. （可选但推荐）查看脚本源码，确认脚本安全
less docker-install.sh  # 也可以用vim、cat命令查看

# 3. 执行脚本安装
bash docker-install.sh
```

### 2\. Windows / Mac 用户

直接前往 [Docker 官网](https://www.docker.com/products/docker-desktop/) 下载 Docker Desktop，按照安装向导一步步操作即可。安装完成后启动 Docker，图形化界面操作简单，无需复杂配置，等待启动完成就可以使用了。

## 一、环境准备（双系统适配）

### Windows 环境

- 操作系统：Windows 10 / 11（64位，需开启 WSL 2，Docker Desktop 安装时可自动开启）

- 已安装：Docker Desktop（启动状态）

- 终端工具：PowerShell（系统自带，管理员身份运行更佳）

- 可用端口：推荐 3001（若被占用可更换）

### Linux 环境

- 操作系统：CentOS、Ubuntu、银河麒麟、欧拉等主流 Linux 发行版

- 已安装：Docker、Docker Compose（通过上面的一键脚本已完成安装）

- 终端工具：任意 Linux 终端（Xshell、Putty 或系统自带终端均可）

- 可用端口：推荐 3001（若被占用可更换）

## 二、拉取 Hermes WebUI 镜像

无论是 Windows 还是 Linux 环境，拉取镜像的命令基本一致，区别仅在于终端工具（PowerShell / Linux 终端），直接执行以下命令即可（使用轩辕镜像，请将 `***-ghcr.xuanyuan.run` 替换为你自己的轩辕镜像专属域名）：

```bash
docker pull ***-ghcr.xuanyuan.run/nesquena/hermes-webui:latest
```

等待镜像拉取完成，若拉取速度较慢，可检查 Docker 镜像加速是否配置成功（一键脚本已自动配置轩辕镜像，无需额外操作）。

## 三、创建本地数据目录（用于持久化）

为了避免容器重启后数据丢失（如会话记录、配置信息等），需要创建本地目录并挂载到容器中，双系统操作如下：

### Windows（PowerShell）

```powershell
mkdir C:\docker\hermes
```

### Linux 终端

```bash
mkdir -p /root/docker/hermes
```

说明：Linux 目录可自定义，比如 /home/docker/hermes，后续部署命令对应修改路径即可。

## 四、标准部署方式

部署核心是通过 docker run 命令启动容器，配置端口映射、环境变量和目录挂载，确保服务稳定运行，双系统命令分别如下：

### Windows（PowerShell）

```powershell
docker run -d --name hermes-webui -p 3001:8787 `
-e HERMES_WEBUI_STATE_DIR=/app/data `
-v C:\docker\hermes:/app/data `
--restart unless-stopped `
***-ghcr.xuanyuan.run/nesquena/hermes-webui:latest
```

### Linux 终端

```bash
docker run -d --name hermes-webui -p 3001:8787 \
-e HERMES_WEBUI_STATE_DIR=/app/data \
-v /root/docker/hermes:/app/data \
--restart unless-stopped \
***-ghcr.xuanyuan.run/nesquena/hermes-webui:latest
```

命令说明：

- \-d：后台运行容器，不占用终端

- \-\-name hermes\-webui：给容器命名为 hermes\-webui，方便后续管理（如停止、删除容器）

- \-p 3001:8787：端口映射，将宿主机 3001 端口映射到容器 8787 端口（容器内部默认端口为 8787）

- \-e HERMES\_WEBUI\_STATE\_DIR=/app/data：必须设置的环境变量，指定容器内数据存储目录，否则容器会反复重启

- \-v 本地目录:/app/data：将本地创建的目录挂载到容器 /app/data 目录，实现数据持久化

- \-\-restart unless\-stopped：容器异常停止时自动重启，保证服务稳定性

## 五、访问 Hermes WebUI

容器启动成功后，无需额外配置，直接通过浏览器访问即可，双系统访问地址一致：

http://localhost:3001

![Hermes WebUI 设置界面](https://img.xuanyuan.dev/docker/blog/docker-hermes-webui.png)

若在远程服务器部署（Linux 服务器），则访问：http://服务器IP:3001（需确保服务器 3001 端口已开放）。

访问成功后，即可看到 Hermes WebUI 的可视化界面，后续操作都可以在界面上完成，比命令行简单太多。

![Hermes WebUI 对话界面](https://img.xuanyuan.dev/docker/blog/docker-hermes-webui-2.png)

## 六、运行架构说明

为了让大家更清楚服务的运行逻辑，整理了核心配置信息，一目了然：

|项目|配置信息|
|---|---|
|Web 服务内部端口|8787（容器默认，不可修改）|
|宿主机映射端口|3001（可自定义，如 3002、8080 等）|
|容器内数据存储目录|/app/data（必须与环境变量一致）|
|Windows 本地挂载路径|C:\\docker\\hermes|
|Linux 本地挂载路径|/root/docker/hermes（可自定义）|

## 七、常见问题排查

部署过程中难免遇到问题，整理了 4 个最常见的问题及解决方法，新手可直接对照排查：

### 1️⃣ 端口被占用

现象：执行部署命令后，提示 “ports are not available”，无法启动容器。

解决方法：更换宿主机映射端口，比如将 3001 改为 3002，修改命令中的 \-p 3002:8787 即可。

### 2️⃣ 页面无法访问（ERR\_CONNECTION\_REFUSED）

原因：大概率是容器未正常启动，可能是环境变量或目录挂载配置错误。

排查步骤：执行以下命令，查看正在运行的容器，确认 hermes\-webui 容器是否在列。

```bash
docker ps
```

若未在列，执行 docker ps \-a 查看容器状态，进一步排查错误原因。

### 3️⃣ 容器反复重启

现象：容器启动后，很快自动停止，反复循环，无法稳定运行。

排查方法：查看容器日志，定位错误原因。

```bash
docker logs hermes-webui
```

常见原因：未设置 HERMES\_WEBUI\_STATE\_DIR 环境变量，或环境变量路径与挂载路径不一致。

解决方法：确保部署命令中包含 \-e HERMES\_WEBUI\_STATE\_DIR=/app/data，且挂载路径正确。

### 4️⃣ 容器已存在冲突

现象：执行部署命令时，提示 “container name already in use”。

原因：之前已部署过 hermes\-webui 容器，容器名称重复。

解决方法：删除已存在的容器，再重新部署。

```bash
docker rm -f hermes-webui
```

## 八、AI 模型接入说明

Hermes WebUI 支持多种模型后端，无需复杂配置，可以部署后，在网页接入，也可以通过环境变量即可接入，常用的有 3 种：OpenAI、OpenRouter、Ollama。

以 OpenAI 为例，部署时添加 OpenAI API Key 环境变量即可，修改后的部署命令（以 Linux 为例，Windows 仅需将 \\ 改为 \`）：

```bash
docker run -d --name hermes-webui -p 3001:8787 \
-e HERMES_WEBUI_STATE_DIR=/app/data \
-e OPENAI_API_KEY=sk-xxxxxxx（替换为你的API Key） \
-v /root/docker/hermes:/app/data \
--restart unless-stopped \
***-ghcr.xuanyuan.run/nesquena/hermes-webui:latest
```

## 九、推荐进阶部署方式

如果是企业或正式使用，不推荐用单条 docker run 命令部署，建议采用以下方式，更易管理和维护：

- 用 docker\-compose 管理容器，将所有配置（端口、环境变量、挂载目录）写入 docker\-compose\.yml 文件，一键启动、停止。

- 坚持数据卷持久化，避免容器删除后数据丢失，可根据需求备份本地挂载目录。

- 统一管理 API KEY 等敏感信息，避免直接暴露在命令中，可通过 \.env 文件管理环境变量。

- 使用独立的 AI 模型提供商（如 Ollama 本地部署模型），减少对外部网络的依赖，提升访问速度。

## 十、总结

其实 Hermes WebUI 的 Docker 部署并不复杂，核心就 3 点，只要满足这 3 点，无论是 Windows 还是 Linux 环境，都能稳定运行：

1. 正确配置端口映射（容器 8787 端口映射到宿主机任意可用端口）；

2. 必须设置 HERMES\_WEBUI\_STATE\_DIR 环境变量，指定容器内数据存储目录；

3. 必须挂载本地目录到容器 /app/data，实现数据持久化。

对于新手来说，无需深入理解 Docker 原理，跟着教程一步步执行命令，就能快速部署成功。有了 Hermes WebUI，再也不用记复杂的 Hermes Agent 命令行，可视化操作更简单、更高效。如果部署过程中遇到其他问题，欢迎在评论区留言交流～

