# Ollama 拉模型卡在 pulling manifest：3 种加速 + 实测耗时

![Ollama 拉模型卡在 pulling manifest：3 种加速 + 实测耗时](https://imgs.xuanyuan.cloud/docker/blog/docker-ollama.png)

*分类: Docker部署教程 | 标签: Ollama,pulling manifest,ollama国内镜像下载,魔搭,ModelScope,GGUF,轩辕镜像,大模型 | 发布时间: 2026-11-09 15:11:23*

> ollama pull 停在 pulling manifest，通常是拿不到 registry.ollama.ai 的清单，不是下载带宽慢。本文给出魔搭前缀拉取、GGUF 本地导入、模型目录离线拷贝三条路径，并附 qwen、deepseek、llama 的体积与耗时实测，适合国内网络下把模型落到本机。

卡在 `pulling manifest`，多半是连不上 `registry.ollama.ai` 的清单接口，不是网速慢。模型层还没开始下。

先把 Ollama 本体镜像拉下来（容器场景）：

```bash
docker pull docker.xuanyuan.run/ollama/ollama:0.40.4
```

镜像详情：[ollama/ollama](https://xuanyuan.cloud/zh/r/ollama/ollama?xy_from=ollama-pulling-manifest)

下面只解决一件事：`ollama pull` 停在 `pulling manifest`，或过了清单却下得很慢时，怎么换路径把模型落到本机。

## 先分清：卡清单，还是下得慢

`ollama pull` 大致分两段：

1. **拉 manifest（清单）**：向仓库询问标签对应哪些层、每层 digest 和大小。终端里会先出现 `pulling manifest`。
2. **拉 blob（层文件）**：按清单下载权重等层。这里才会看到百分比和 `MB/s`。

| 现象 | 更可能卡在哪 | 处理方向 |
|------|--------------|----------|
| 长时间只有 `pulling manifest`，没有百分比 | 清单请求超时、被重置或 DNS 失败 | 换魔搭前缀、挂可用代理，或干脆不走在线 pull |
| 已出现某一层进度，但只有几 KB/s | 清单已拿到，线路慢 | 换国内源、手动下 GGUF，或在能出网的机器上下好再拷 |
| 直接报 `pull model manifest: ... i/o timeout` / `EOF` | 清单阶段失败 | 同上，不要只重试同一条官方路径 |

本机用浏览器或 `curl` 能打开网页，不代表 Ollama 进程一定能连上 `registry.ollama.ai`。清单阶段失败时，换宽带往往没用。

`OLLAMA_MODELS` 只改模型存放目录，**不改变**下载源，也不能消除 `pulling manifest`。`OLLAMA_HOST` 是服务监听地址，**不是**镜像源。网上常见的 `OLLAMA_REGISTRY` / `OLLAMA_REGISTRIES` 也不是 Ollama 官方配置项，设了通常仍会打到 `registry.ollama.ai`。

## 原因：为什么会停在 pulling manifest

常见有三类，可以并存：

1. **清单请求到不了官方仓库**  
   默认仓库是 `registry.ollama.ai`。国内部分线路上，TLS 握手或长时间连接会超时、被重置。表现就是一直 `pulling manifest`，或报 `i/o timeout`、`EOF`。

2. **服务进程没用上你以为的网络出口**  
   你在终端里配了代理，但 systemd / Windows 服务 / 容器里的 Ollama **没读到** `HTTP_PROXY` / `HTTPS_PROXY`。CLI 只是客户端，真正发拉取请求的是 `ollama serve` 那一侧。

3. **磁盘或权限让后续步骤写不进去**  
   盘满、目录属主不对时，有时也会在拉层或写 manifest 阶段失败。需要和「纯网络卡住」分开看：先确认模型目录所在分区还有空间，Linux 服务账号对目录可写。

容器里跑 Ollama 时，还要确认：挂载的模型目录可写，且代理环境变量写进了**容器**而不是只写在宿主机当前 shell。

## 路径一：魔搭前缀拉取（优先试）

[ModelScope 魔搭](https://www.modelscope.cn/docs/models/advanced-usage/ollama-integration) 已支持用 Ollama 直接拉社区上的 GGUF 仓库。建议 Ollama **≥ 0.3.12**。命令形态是：

```bash
ollama pull modelscope.cn/<命名空间>/<仓库名>
```

可先用小模型确认路径通：

```bash
ollama pull modelscope.cn/Qwen/Qwen2.5-0.5B-Instruct-GGUF
```

同系列常用示例：

```bash
ollama pull modelscope.cn/unsloth/DeepSeek-R1-Distill-Qwen-1.5B-GGUF
ollama pull modelscope.cn/second-state/Llama-3.2-1B-Instruct-GGUF
```

指定量化时，在仓库名后加标签，例如 `:Q4_K_M`（大小写不敏感）。仓库页能看到有哪些 GGUF 文件。

拉完检查：

```bash
ollama list
```

列表里会出现带 `modelscope.cn/...` 前缀的名字。需要短名时再：

```bash
ollama cp modelscope.cn/Qwen/Qwen2.5-0.5B-Instruct-GGUF qwen2.5-local
ollama run qwen2.5-local
```

这条路径仍然是在线 pull，但清单和层走魔搭，不再依赖 `registry.ollama.ai` 的可达性。

## 路径二：手动下载 GGUF，再 `ollama create`

完全绕开 `ollama pull` 的在线仓库协议：在浏览器或下载工具里从魔搭（或其它你信任的来源）下好 `.gguf`，再本地导入。

1. 打开对应 GGUF 仓库，例如 [Qwen2.5-0.5B-Instruct-GGUF](https://www.modelscope.cn/models/Qwen/Qwen2.5-0.5B-Instruct-GGUF)，下载需要的量化文件。  
2. 在模型文件同目录写 `Modelfile`：

```text
FROM ./qwen2.5-0.5b-instruct-q4_k_m.gguf
```

把文件名换成你实际下载的名字。

3. 导入并运行：

```bash
ollama create qwen25-local-gguf -f Modelfile
ollama run qwen25-local-gguf
```

对话模板和参数：魔搭对接时通常会按仓库信息生成；若你只写了 `FROM` 一行，复杂模型可能还要按 [Ollama Modelfile 说明](https://github.com/ollama/ollama/blob/main/docs/modelfile.md) 补 `TEMPLATE` / `PARAMETER`。优先用路径一的 `modelscope.cn/...`，减少手写模板。

## 路径三：能上网的机器上下好，再离线拷目录

官方没有 `docker save` 那种内置 `ollama save`。可迁移的做法是拷贝模型目录里的 **`blobs`** 与 **`manifests`**（新版本还可能有 `manifests-v2`）。维护者在 [ollama#3441](https://github.com/ollama/ollama/issues/3441) 里确认：两套目录都要，blob 按内容寻址，拷过去即可。

各平台默认模型目录（可用 `OLLAMA_MODELS` 改掉；改的是 **serve 进程** 的环境，不是只改当前 shell）：

| 系统 | 默认模型目录 |
|------|----------------|
| macOS | `~/.ollama/models` |
| Windows | `%USERPROFILE%.ollamamodels` |
| Linux（官方安装脚本，服务用户） | `/usr/share/ollama/.ollama/models` |

在**已拉成功**的机器上打包（按你的实际目录改路径）：

```bash
# 示例：Linux 服务目录；先停服务再写目标机
sudo systemctl stop ollama
tar --exclude='*-partial*' -cf ollama-models.tar 
  -C /usr/share/ollama/.ollama/models blobs manifests
# 若存在 manifests-v2，一并打进包
```

拷到目标机后：

```bash
sudo systemctl stop ollama
sudo tar -xf ollama-models.tar -C /usr/share/ollama/.ollama/models
sudo chown -R ollama:ollama /usr/share/ollama/.ollama/models
sudo systemctl start ollama
ollama list
```

Windows / macOS 同样：退出 Ollama → 解压到对应 `models` → 再启动 → `ollama list`。只拷 `blobs` 不拷 `manifests`，列表里不会出现模型名。

## 实测：体积与耗时

测试时间 **2026-11-09**。客户端 Ollama **0.40.15**，服务端 **0.40.2**。同一台机器、同一出口，先走官方库标签，再走魔搭前缀；GGUF 手动路径单独计下载与 `create`。

### 在线 pull 对照

| 模型 | 官方库命令 | 官方体积 / 耗时 | 魔搭命令 | 魔搭体积 / 耗时 |
|------|------------|-----------------|----------|-----------------|
| Qwen 0.5B 档 | `ollama pull qwen2.5:0.5b` | **397 MB** / **36～38 s** | `ollama pull modelscope.cn/Qwen/Qwen2.5-0.5B-Instruct-GGUF` | **491 MB** / **31.9 s**（约 19 MB/s） |
| DeepSeek-R1 蒸馏 1.5B | `ollama pull deepseek-r1:1.5b` | **1.1 GB** / **297.9 s**（约 1.2 MB/s） | `ollama pull modelscope.cn/unsloth/DeepSeek-R1-Distill-Qwen-1.5B-GGUF` | **1.1 GB** / **71.5 s**（约 17 MB/s） |
| Llama 3.2 1B 档 | `ollama pull llama3.2:1b` | **1.3 GB** / **667.6 s** | `ollama pull modelscope.cn/second-state/Llama-3.2-1B-Instruct-GGUF` | **807 MB** / **52.6 s**（约 17 MB/s） |

说明：

- 官方库标签与魔搭 GGUF 仓库**不是同一产物**：量化、模板、体积可能不同，表中按「同系列小模型」对照，不宣称 bit 级一致。  
- 本机访问官方仓库时，小模型清单阶段能很快过；`deepseek-r1:1.5b`、`llama3.2:1b` 主要耗在层下载。你的线路若清单都过不去，会先卡在 `pulling manifest`，应直接换魔搭或离线路径。  
- 更大的常用档官方页体积（未在本轮完整计时）：[qwen2.5:7b](https://ollama.com/library/qwen2.5:7b) **4.7 GB**，[deepseek-r1:7b](https://ollama.com/library/deepseek-r1:7b) **4.7 GB**，[llama3.1:8b](https://ollama.com/library/llama3.1:8b) **4.9 GB**。体积上去后，官方慢、魔搭相对快的差距通常更明显。

### GGUF 手动导入（Qwen 0.5B Q4_K_M）

| 步骤 | 结果 |
|------|------|
| 从魔搭 resolve 下载 `qwen2.5-0.5b-instruct-q4_k_m.gguf` | **468.6 MB** / **13.1 s**（约 35.8 MB/s） |
| `ollama create qwen25-local-gguf -f Modelfile` | **0.8 s**（本机已有相同内容层时可秒级复用） |

### 离线打包

对本机已下载模型目录中的 `blobs` + `manifests` + `manifests-v2` 打包（约 **4.9 GB**）：

| 步骤 | 耗时 |
|------|------|
| `tar` 打包 | **3 s** |
| `tar` 解压到空目录 | **3 s** |

打包和解压只反映本机磁盘；跨机器还要算传输时间。中断后续传：`ollama pull` 对已下完的层会跳过；GGUF 大文件用支持断点的下载工具更稳。

### 容器镜像（给 Docker 用户）

用 [轩辕镜像](https://xuanyuan.cloud/?xy_from=ollama-pulling-manifest) **加速拉取** Ollama 运行时镜像（这是容器镜像，不是模型权重）：

```bash
docker pull docker.xuanyuan.run/ollama/ollama:0.40.4
```

本机实测：拉取耗时 **855.2 s**，`docker image inspect` 得到本地体积约 **5.2 GB**。Compose 与网页对话界面可参考 [Docker 部署 Open WebUI](https://xuanyuan.cloud/blog/open-webui-docker-deploy?xy_from=ollama-pulling-manifest)。

## `OLLAMA_HOST`、代理与目录

| 变量 / 项 | 作用 | 常见误用 |
|-----------|------|----------|
| `OLLAMA_HOST` | 服务监听地址，默认 `127.0.0.1:11434` | 填成镜像站 URL |
| `OLLAMA_MODELS` | 模型文件目录 | 以为能加速下载 |
| `HTTP_PROXY` / `HTTPS_PROXY` | 给 **serve 进程** 走代理 | 只写在当前终端，服务读不到 |
| `NO_PROXY` | 本地回环不要走代理 | 漏写 `127.0.0.1,localhost` 时，本机 API 也可能被送去代理 |

Linux systemd 示例（代理地址换成你自己的；改完 `daemon-reload` 并重启服务）：

```bash
sudo mkdir -p /etc/systemd/system/ollama.service.d
sudo tee /etc/systemd/system/ollama.service.d/proxy.conf <<'EOF'
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890"
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
Environment="NO_PROXY=127.0.0.1,localhost"
EOF
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

用容器时，把同样的环境变量写进 Compose / `docker run` 的 `-e`，不要只写在宿主机 shell。

验证服务是否在听：

```bash
curl http://127.0.0.1:11434/api/tags
```

## 常见问题

**Q1：为什么官方小模型很快，大模型却像卡死？**

小模型往往几秒就过完清单并开始下层。大模型清单也可能很快通过，但层文件有数 GB，进度条会停很久。先看有没有从 `pulling manifest` 变成某一层的百分比；有百分比就是在下，不是卡清单。

**Q2：配了 `OLLAMA_MODELS` 还是卡在 pulling manifest？**

正常。这个变量只改落盘位置。卡清单时请换「路径一 / 二 / 三」，或给 **serve 进程** 配上可用的 `HTTP_PROXY` / `HTTPS_PROXY`。

**Q3：Docker 镜像已经用轩辕加速了，`ollama pull` 为什么还慢？**

`docker pull docker.xuanyuan.run/ollama/ollama:…` 加速的是 **Ollama 程序镜像**。`ollama pull` 拉的是 **模型仓库**，默认仍是 `registry.ollama.ai`（或你写的 `modelscope.cn/...`）。两件事不要混成一个开关。

**Q4：拉到一半断了，要删干净重来吗？**

一般不用。再次执行同一条 `ollama pull`，已完成的层会留下。GGUF 手动下载请用带断点续传的工具。不要删整个 `blobs` 目录除非你确认要清空所有模型。

**Q5：魔搭前缀拉下来的名字很长，Open WebUI 里不好选？**

用 `ollama cp` 起短名，或在 Open WebUI 里直接选列表中的全名。部署 Open WebUI 与 Ollama 的 Compose 见 [Docker 部署 Open WebUI](https://xuanyuan.cloud/blog/open-webui-docker-deploy?xy_from=ollama-pulling-manifest)。

## 命令速查

```bash
# 容器：Ollama 运行时镜像
docker pull docker.xuanyuan.run/ollama/ollama:0.40.4

# 路径一：魔搭
ollama pull modelscope.cn/Qwen/Qwen2.5-0.5B-Instruct-GGUF
ollama pull modelscope.cn/unsloth/DeepSeek-R1-Distill-Qwen-1.5B-GGUF
ollama pull modelscope.cn/second-state/Llama-3.2-1B-Instruct-GGUF
ollama list

# 路径二：本地 GGUF
# Modelfile 内：FROM ./xxx.gguf
ollama create 本地名 -f Modelfile

# 路径三：打包 models 下的 blobs + manifests（路径按系统改）
tar --exclude='*-partial*' -cf ollama-models.tar -C /path/to/models blobs manifests

curl http://127.0.0.1:11434/api/tags
```

## 附录：Ollama 是什么

Ollama 在本机拉取并运行开源大模型，提供命令行和 HTTP API。模型文件落在本机目录，适合不想把对话和权重都放到云端 API 的场景。它负责下载与推理；若需要浏览器聊天界面，可再接 Open WebUI 等前端。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [ollama/ollama 镜像页](https://xuanyuan.cloud/zh/r/ollama/ollama?xy_from=ollama-pulling-manifest) | [https://xuanyuan.cloud/zh/r/ollama/ollama](https://xuanyuan.cloud/zh/r/ollama/ollama?xy_from=ollama-pulling-manifest) |
| [ollama/ollama 标签列表](https://xuanyuan.cloud/r/ollama/ollama/tags?xy_from=ollama-pulling-manifest) | [https://xuanyuan.cloud/r/ollama/ollama/tags](https://xuanyuan.cloud/r/ollama/ollama/tags?xy_from=ollama-pulling-manifest) |
| [Docker 部署 Open WebUI](https://xuanyuan.cloud/blog/open-webui-docker-deploy?xy_from=ollama-pulling-manifest) | [https://xuanyuan.cloud/blog/open-webui-docker-deploy](https://xuanyuan.cloud/blog/open-webui-docker-deploy?xy_from=ollama-pulling-manifest) |
| [ModelScope · Ollama 加载模型](https://www.modelscope.cn/docs/models/advanced-usage/ollama-integration) | [https://www.modelscope.cn/docs/models/advanced-usage/ollama-integration](https://www.modelscope.cn/docs/models/advanced-usage/ollama-integration) |
| [Docker Hub · ollama/ollama](https://hub.docker.com/r/ollama/ollama) | [https://hub.docker.com/r/ollama/ollama](https://hub.docker.com/r/ollama/ollama) |
| [GitHub · ollama/ollama](https://github.com/ollama/ollama) | [https://github.com/ollama/ollama](https://github.com/ollama/ollama) |
| [Ollama 模型库](https://ollama.com/library) | [https://ollama.com/library](https://ollama.com/library) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage?xy_from=ollama-pulling-manifest) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage?xy_from=ollama-pulling-manifest) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/ollama-pulling-manifest?xy_from=ollama-pulling-manifest

*本文基于 [ollama/ollama:0.40.4](https://xuanyuan.cloud/zh/r/ollama/ollama?xy_from=ollama-pulling-manifest)，以 **0.40.4** 版本实测容器拉取；模型拉取对照使用本机 Ollama 客户端 **0.40.15** / 服务端 **0.40.2**，测试平台 **Windows + WSL**。*


