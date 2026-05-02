# Docker 部署 Open WebUI + Ollama 完整教程（Windows / Linux 通用）—— 打造自己的本地OpenAI

![Docker 部署 Open WebUI + Ollama 完整教程（Windows / Linux 通用）—— 打造自己的本地OpenAI](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama-1.png)

*分类: OpenWebUI,Ollama,部署教程,部署方案,一键部署 | 标签: OpenWebUI,Ollama,部署教程,部署方案,一键部署 | 发布时间: 2026-04-23 15:06:47*

> 无需复杂配置！Docker一键部署Open WebUI+Ollama，Windows/Linux通用，新手也能轻松上手。无需依赖云端，打造专属本地OpenAI，实现可视化聊天交互，兼顾数据隐私，还附带常见问题排查，全程步骤清晰，快速拥有本地大模型平台！

在本地搭建专属大模型平台，不用依赖云端服务，既能实现可视化聊天交互，又能保证数据隐私——今天就给大家分享最省心的方案：用 Docker 一键部署 Open WebUI \+ Ollama，全程步骤清晰，Windows 和 Linux 系统都能适配，还会解决部署中最常见的模型识别、容器通信等问题。

## 先搞懂：Ollama 与 Open WebUI 是什么？

在开始部署前，先简单介绍下这两个核心工具，帮大家快速理解它们的作用，避免盲目操作：

**Ollama**：一款轻量级的本地大模型运行工具，支持一键下载、运行各类主流大模型（比如 Qwen、Llama 等），无需复杂的环境配置，普通人也能轻松在本地启动大模型推理，核心优势是简洁、高效、跨平台。

**Open WebUI**：一款美观、易用的大模型 Web 可视化界面，相当于给 Ollama 套了一个“可视化外壳”。它支持聊天对话、模型切换、历史记录管理等功能，让我们不用敲命令行，通过浏览器就能和本地大模型交互，体验和云端 AI 聊天工具几乎一致。

![Ollama 与 Open WebUI 是什么](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama.png)

两者搭配使用，就能实现“本地模型运行 \+ 网页可视化操作”的完整本地 AI 平台。这里给大家提供两个工具的中文镜像地址，下载速度更快，适配国内网络：

- Open WebUI 中文镜像：[https://xuanyuan\.cloud/r/openwebui/open\-webui](https://xuanyuan.cloud/r/openwebui/open-webui)

- Ollama 中文镜像：[https://xuanyuan\.cloud/zh/r/ollama/ollama](https://xuanyuan.cloud/zh/r/ollama/ollama)

## 前置准备：Docker 环境一键搞定

部署的前提是拥有可用的 Docker 环境，不管是 Linux、Windows 还是 Mac，下面的方法都能快速搞定，尤其适合新手，避免踩环境配置的坑。

### 1\. Linux 系统 Docker 一键安装（含国产系统适配）

Linux 系统（包括银河麒麟、欧拉等国产系统）直接用下面的脚本，一键安装 Docker、Docker Compose，还会自动配置轩辕镜像加速，省去手动配置的麻烦。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```


### 2\. Windows / Mac 用户

Windows 和 Mac 用户不用复杂的命令行操作，直接去 Docker 官网下载 Docker Desktop 即可，图形化界面操作简单，安装完成后启动 Docker 即可（启动后会在后台运行，桌面状态栏会有对应图标）。

Docker Desktop 下载地址：[https://www\.docker\.com/products/docker\-desktop/](https://www.docker.com/products/docker-desktop/)

### 验证 Docker 环境

安装完成后，验证一下 Docker 是否正常运行，打开终端（Linux）或 PowerShell（Windows），输入以下命令：

```bash
docker version
```

如果能正常显示 Docker 的版本信息（Client 和 Server 都有版本号），说明环境已经准备就绪，可以开始部署了。

## 正式部署：Open WebUI \+ Ollama 步骤拆解

部署全程用 Docker 命令操作，步骤清晰，Windows 和 Linux 仅命令格式有细微差异（已单独标注），跟着做就能成功。

### 第一步：拉取镜像

先拉取 Open WebUI 和 Ollama 的镜像，这里用我们前面提供的中文镜像，下载速度比官方镜像快很多，避免因网络问题卡住。

拉取 Open WebUI 镜像：

```bash
docker pull docker.xuanyuan.run/openwebui/open-webui:latest
```

拉取 Ollama 镜像：

```bash
docker pull docker.xuanyuan.run/ollama/ollama:latest
```

拉取完成后，可以用`docker images` 命令查看镜像，确认两个镜像都已成功下载。

### 第二步：创建 Docker 网络（必做，避免通信问题）

为了让 Open WebUI 和 Ollama 两个容器能够互相通信（Open WebUI 需要连接 Ollama 才能调用模型），建议创建一个独立的 Docker 网络，这样两个容器就能通过网络直接访问，避免出现“无法解析主机”的问题。

所有系统命令一致，输入：

```bash
docker network create ai-network
```

网络创建完成后，后续启动容器时，只要加入这个网络，就能实现互相通信。

### 第三步：启动 Ollama 容器

Ollama 是核心，需要先启动它，才能下载和运行大模型。注意 Windows 和 Linux 的命令格式差异（主要是换行符不同）。

#### Linux 系统（终端执行）

```bash
docker run -d \
--name ollama \
--network ai-network \
-p 11434:11434 \
-v ollama:/root/.ollama \
--restart unless-stopped \
docker.xuanyuan.run/ollama/ollama:latest
```

#### Windows 系统（PowerShell 执行）

```powershell
docker run -d --name ollama --network ai-network -p 11434:11434 -v ollama:/root/.ollama --restart unless-stopped docker.xuanyuan.run/ollama/ollama:latest
```

命令说明：

- `\-d`：后台运行容器，不占用当前终端；

- `\-\-name ollama`：给容器命名为 ollama，方便后续操作；

- `\-\-network ai\-network`：将容器加入我们刚才创建的 ai\-network 网络；

- `\-p 11434:11434`：将容器的 11434 端口映射到本地，Ollama 的默认端口就是 11434；

- `\-v ollama:/root/\.ollama`：将 Ollama 的数据（比如下载的模型）挂载到本地，避免容器删除后模型丢失；

- `\-\-restart unless\-stopped`：设置容器开机自启，除非手动停止，避免重启系统后容器失效。

### 第四步：下载大模型

Ollama 容器启动后，还需要下载具体的大模型才能使用。这里以下载 Qwen 0\.5B 模型为例（体积小、启动快，适合新手测试），也可以根据需求下载其他模型（比如 Llama 3、Gemini 等）。

所有系统命令一致，输入：

```bash
docker exec -it ollama ollama pull qwen:0.5b
```

下载时间根据网络速度而定，模型体积越小，下载越快（Qwen 0\.5B 仅 394MB）。

下载完成后，可以查看已下载的模型，输入：

```bash
docker exec -it ollama ollama list
```

正常情况下，会输出如下内容，说明模型下载成功：

```bash
NAME        SIZE
qwen:0.5b   394MB
```

### 第五步：启动 Open WebUI 容器

Ollama 和模型都准备好后，启动 Open WebUI 容器，让我们能够通过浏览器访问和操作。同样区分 Windows 和 Linux 命令格式。

#### Linux 系统（终端执行）

```bash
docker run -d \
--name open-webui \
--network ai-network \
-p 3002:8080 \
-e OLLAMA_BASE_URL=http://ollama:11434 \
-v open-webui:/app/backend/data \
--restart unless-stopped \
docker.xuanyuan.run/openwebui/open-webui:latest
```

#### Windows 系统（PowerShell 执行）

```powershell
docker run -d --name open-webui --network ai-network -p 3002:8080 -e OLLAMA_BASE_URL=http://ollama:11434 -v open-webui:/app/backend/data --restart unless-stopped docker.xuanyuan.run/openwebui/open-webui:latest
```

关键命令说明：

- `\-p 3002:8080`：将 Open WebUI 的 8080 端口映射到本地 3002 端口，后续通过 localhost:3002 访问；

- `\-e OLLAMA\_BASE\_URL=http://ollama:11434`：关键环境变量，告诉 Open WebUI  Ollama 的地址，确保两者能够正常连接；

- `\-v open\-webui:/app/backend/data`：挂载 Open WebUI 的数据（比如管理员账号、聊天记录），避免容器删除后数据丢失。

### 第六步：访问 Open WebUI，开始使用

两个容器都启动成功后，打开浏览器，输入以下地址：

```text
http://localhost:3002
```

![创建一个管理员账号](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama-2.png)

首次访问时，需要创建一个管理员账号（设置用户名、密码），创建完成后登录，就能进入 Open WebUI 的主界面。

![Qwen 0\.5B 模型](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama-5.png)

登录后，点击界面中的“模型”选项，就能看到我们刚才下载的 Qwen 0\.5B 模型，选择模型后，就可以开始聊天交互了，和使用 ChatGPT 等工具的体验完全一致。

![始聊天交互](https://img.xuanyuan.dev/docker/blog/docker-open-webui-ollama-6.png)

## 关键验证：确认 Open WebUI 与 Ollama 正常连接

部署完成后，建议验证一下两者是否正常连接，避免出现“模型列表为空”的问题。

在终端（Linux）或 PowerShell（Windows）中输入以下命令，测试 Open WebUI 能否访问 Ollama 的 API：

```bash
docker exec -it open-webui curl http://ollama:11434/api/tags
```

如果正常返回以下内容，说明连接成功：

```json
{
    "models": [
        {
            "name": "qwen:0.5b",
            "model": "qwen:0.5b",
            "modified_at": "2026-04-23T14:32:04.754499059Z",
            "size": 394998579,
            "digest": "b5dc5e784f2a3ee1582373093acf69a2f4e2ac1710b253a001712b86a61f88bb",
            "details": {
                "parent_model": "",
                "format": "gguf",
                "family": "qwen2",
                "families": [
                    "qwen2"
                ],
                "parameter_size": "620M",
                "quantization_level": "Q4_0"
            }
        }
    ]
}
```

### 查看运行中的容器

如果想确认两个容器是否都在正常运行，输入以下命令：

```bash
docker ps
```

正常情况下，会显示两个容器的运行状态，如下所示（简化版）：

```text
CONTAINER ID   IMAGE                     PORTS
xxxxxxx        docker.xuanyuan.run/openwebui/open-webui   0.0.0.0:3002->8080/tcp
xxxxxxx        docker.xuanyuan.run/ollama/ollama         0.0.0.0:11434->11434/tcp
```

## 常见问题排查（新手必看）

部署过程中，新手可能会遇到一些小问题，这里整理了最常见的4个问题，附上解决方案，帮大家快速避坑。

### 问题1：Open WebUI 中模型列表为空

**现象**：登录 Open WebUI 后，看不到任何已下载的模型，无法选择模型聊天。

**原因**：Open WebUI 没有成功连接到 Ollama，大概率是环境变量或网络配置错误。

**解决方案**：

- 确认启动 Open WebUI 时，添加了 `\-e OLLAMA\_BASE\_URL=http://ollama:11434` 环境变量；

- 确认两个容器都加入了同一个网络（ai\-network），可以用 `docker network inspect ai\-network` 查看容器是否在网络中；

- 如果还是不行，重启两个容器：`docker restart ollama open\-webui`。

### 问题2：无法解析 ollama 主机（错误：Could not resolve host: ollama）

**现象**：执行验证命令时，出现“curl: \(6\) Could not resolve host: ollama”错误。

**原因**：Open WebUI 容器和 Ollama 容器不在同一个 Docker 网络，导致无法解析主机名。

**解决方案**：

- 将 Open WebUI 容器加入 ai\-network 网络：`docker network connect ai\-network open\-webui`；

- 或者重新启动 Open WebUI 容器，确保启动命令中包含 `\-\-network ai\-network`。

### 问题3：Open WebUI 无法连接 Ollama

**现象**：模型列表为空，且验证命令执行失败。

**解决方案**：

- 先检查 Ollama 容器是否正常运行：`docker ps \| grep ollama`，如果没有运行，执行 `docker start ollama`；

- 测试本地能否访问 Ollama API：`curl http://localhost:11434/api/tags`，如果能正常返回，说明 Ollama 本身没问题，问题出在 Open WebUI 的连接配置。

### 问题4：Open WebUI 启动慢

**现象**：启动 Open WebUI 后，浏览器访问需要等待很久，终端显示“INFO \[alembic\.runtime\.migration\]”。

**原因**：第一次启动 Open WebUI 时，会自动执行数据库迁移操作，属于正常现象，耐心等待1\-2分钟即可。

## 总结

用 Docker 部署 Open WebUI \+ Ollama，全程不用复杂的环境配置，核心就是“拉取镜像 → 创建网络 → 启动容器 → 下载模型 → 访问使用”，Windows 和 Linux 系统都能轻松适配。

部署完成后，你就拥有了一个专属的本地大模型平台：既能通过 Open WebUI 实现可视化聊天，又能通过 Ollama 灵活切换各类大模型，而且所有数据都保存在本地，隐私更有保障。

如果想尝试更大规模的模型（比如 Qwen 7B、Llama 3 8B），只需用 `docker exec \-it ollama ollama pull 模型名` 下载即可，Open WebUI 会自动识别新下载的模型，非常方便。


