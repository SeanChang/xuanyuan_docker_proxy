---
image: dustynv/ollama
description: "GitHub仓库dusty-nv/jetson-containers中的Ollama LLM包，是为NVIDIA Jetson嵌入式平台设计的容器化解决方案，旨在简化大型语言模型（LLM）的部署与运行流程，支持多种主流LLM模型，充分利用Jetson设备的硬件加速能力，适用于边缘AI计算、智能终端开发等场景，为开发者提供便捷高效的本地化LLM部署工具。"
source: https://xuanyuan.cloud/zh/r/dustynv/ollama
canonical: https://xuanyuan.cloud/zh/r/dustynv/ollama
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dustynv/ollama" title="dustynv/ollama Docker 镜像中文简介、标签列表与拉取命令">dustynv/ollama — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/dustynv/ollama" title="dustynv/ollama Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dustynv/ollama</a>

# Ollama 使用指南


> [`容器信息`](#容器信息) [`镜像信息`](#容器镜像) [`运行容器`](#运行容器) [`构建容器`](#构建容器)


* 本文介绍的 Ollama 来自 [GitHub 仓库]([])，已启用 CUDA 支持（可执行文件路径 `/bin/ollama`）。  
* 感谢 [`@remy415`]([]) 实现了 Ollama 在 Jetson 上的运行并提供 Dockerfile（[PR #465]([])）。


## Ollama 服务端部署

首先，通过以下任一方式在后台启动本地 Ollama 服务端（守护进程）：

```bash
# 模型缓存路径：jetson-containers/data
jetson-containers run --name ollama $(autotag ollama)

# 模型缓存路径：用户主目录
docker run --runtime nvidia -it --rm --network=host -v ~/ollama:/ollama -e OLLAMA_MODELS=/ollama dustynv/ollama:r36.2.0
```

服务端启动后，可在**同一容器内**或**其他容器**中运行 Ollama 客户端。`ollama` 容器的默认启动命令为 [`/start_ollama`](./start_ollama)，该脚本会在后台启动服务端并释放终端控制权。服务端日志保存在挂载的 `jetson-containers/data/logs` 目录，方便在容器外查看。

通过环境变量 `$OLLAMA_MODELS` 可自定义模型下载路径（如上述示例）。默认情况下，模型会保存在 `jetson-containers/data/models/ollama` 目录，该路径由 `jetson-containers run` 自动挂载。


## Ollama 客户端使用

使用 Ollama 命令行界面（CLI）加载目标[模型]([])（例如 mistral 7b）：

### 场景 1：在服务端容器内运行
```bash
/bin/ollama run mistral
```

### 场景 2：在新容器中运行（另一个终端）
```bash
jetson-containers run $(autotag ollama) /bin/ollama run mistral
```

![Ollama CLI 演示]([])

### 场景 3：在容器外运行客户端
可在容器外安装 arm64 架构的 Ollama 二进制文件（无需 CUDA，仅服务端依赖 CUDA）：

```bash
# 下载最新 arm64 版本 Ollama 到 /bin 目录
sudo wget [] ls-remote --refs --sort="version:refname" --tags [] | cut -d/ -f3- | sed 's/-rc.*//g' | tail -n1)/ollama-linux-arm64 -O /bin/ollama
sudo chmod +x /bin/ollama

# 直接运行客户端（容器外）
/bin/ollama run mistral
```


## Open WebUI 部署

如需通过浏览器访问 Ollama，可部署 [Open WebUI]([]) 服务：

```bash
docker run -it --rm --network=host --add-host=host.docker.internal:host-gateway ghcr.io/open-webui/open-webui:main
```

部署后，在浏览器中访问 `[] WebUI 界面]([])


## 内存占用参考

| 模型                                                                           | 量化方式          | 内存占用（MB） |
|--------------------------------------------------------------------------------|-------------------|----------------|
| [`TheBloke/Llama-2-7B-GGUF`]([])   | `llama-2-7b.Q4_K_S.gguf` | 5,268          |
| [`TheBloke/Llama-2-13B-GGUF`]([]) | `llama-2-13b.Q4_K_S.gguf` | 8,609          |
| [`TheBloke/LLaMA-30b-GGUF`]([])     | `llama-30b.Q4_K_S.gguf` | 19,045         |
| [`TheBloke/Llama-2-70B-GGUF`]([]) | `llama-2-70b.Q4_K_S.gguf` | 37,655         |


<details open>
<summary><b><a id="容器信息">容器信息</a></b></summary>
<br>

| **`ollama` 容器** | 说明                |
|-------------------|---------------------|
| 系统要求          | `L4T ['>=34.1.0']`  |
| 依赖项            | [`build-essential`]([])、[`cuda`]([]) |
| 被依赖项          | [`llama-index`]([]) |
| Dockerfile 文件   | [`Dockerfile`]([]) |
| 镜像版本          | [`dustynv/ollama:r35.4.1`]([]) `(2024-04-25, 5.4GB)`<br>[`dustynv/ollama:r36.2.0`]([]) `(2024-04-25, 3.9GB)` |

</details>


<details open>
<summary><b><a id="容器镜像">容器镜像</a></b></summary>
<br>

| 镜像仓库/标签                          | 日期       | 架构   | 大小   |
|---------------------------------------|------------|--------|--------|
| [`dustynv/ollama:r35.4.1`]([]) | 2024-04-25 | arm64  | 5.4GB  |
| [`dustynv/ollama:r36.2.0`]([]) | 2024-04-25 | arm64  | 3.9GB  |

> <sub>容器镜像兼容同系列其他 minor 版本的 JetPack/L4T：</sub><br>
> <sub>&nbsp;&nbsp;&nbsp;&nbsp;• L4T R32.7 镜像可运行于其他 L4T R32.7 版本（JetPack 4.6+）</sub><br>
> <sub>&nbsp;&nbsp;&nbsp;&nbsp;• L4T R35.x 镜像可运行于其他 L4T R35.x 版本（JetPack 5.1+）</sub><br>
</details>


<details open>
<summary><b><a id="运行容器">运行容器</a></b></summary>
<br>

可通过 [`jetson-containers run`]([]) 配合 [`autotag`]([]) 启动容器，或手动编写 [`docker run`]([]) 命令：

```bash
# 自动拉取/构建兼容镜像
jetson-containers run $(autotag ollama)

# 显式指定镜像版本
jetson-containers run dustynv/ollama:r35.4.1

# 使用 docker run 命令（需手动指定镜像及挂载）
sudo docker run --runtime nvidia -it --rm --network=host dustynv/ollama:r35.4.1
```

> <sup>[`jetson-containers run`]([]) 会将参数转发给 [`docker run`]([])，并添加默认配置（如 `--runtime nvidia`、挂载 `/data` 缓存目录、自动检测设备）。</sup><br>
> <sup>[`autotag`]([]) 会查找与当前 JetPack/L4T 版本兼容的镜像（本地镜像、远程仓库拉取或自动构建）。</sup>

如需挂载本地目录到容器，使用 `-v` 或 `--volume` 参数：
```bash
jetson-containers run -v /本地路径:/容器内路径 $(autotag ollama)
```

如需启动容器时直接运行命令（非交互式终端）：
```bash
jetson-containers run $(autotag ollama) 目标命令 --参数
```

可传递任何 [`docker run`]([]) 支持的参数，命令执行前会打印完整构建的命令。
</details>


<details open>
<summary><b><a id="构建容器">构建容器</a></b></summary>
<br>

使用前文提到的 `autotag` 时，若本地无兼容镜像，会自动提示构建。如需手动构建，需先完成[系统环境配置]([])，然后执行：

```bash
jetson-containers build ollama
```

构建过程中会自动集成依赖项并进行测试。可添加 `--help` 参数查看构建选项：`jetson-containers build ollama --help`。
</details>
