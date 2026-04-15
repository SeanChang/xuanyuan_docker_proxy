# ComfyUI Docker 镜像部署指南

![ComfyUI Docker 镜像部署指南](https://img.xuanyuan.dev/docker/blog/docker-comfyui.png)

*分类: 人工智能,ComfyUI,PyTorch,Stable Diffusion | 标签: comfyui,人工智能,部署教程,Stable Diffusion | 发布时间: 2025-12-31 06:41:21*

> ComfyUI 是一款基于节点工作流的 Stable Diffusion 图形界面，支持通过可视化方式组合复杂的图像生成流程。ComfyUI-BOOT 基于官方 ComfyUI 构建，内置：Python 运行环境，PyTorch（按 CUDA / 架构区分），ComfyUI 本体，启动与下载脚本，用于简化 ComfyUI 的部署与启动流程。

## 一、项目简介

**ComfyUI** 是一款基于节点工作流的 Stable Diffusion 图形界面，支持通过可视化方式组合复杂的图像生成流程。

**ComfyUI-BOOT** 基于官方 ComfyUI 构建，内置：

* Python 运行环境
* PyTorch（按 CUDA / 架构区分）
* ComfyUI 本体
* 启动与下载脚本

用于简化 ComfyUI 的部署与启动流程。


---

## 二、运行前准备

### 1. 系统与硬件要求

* 操作系统：Linux（推荐 Ubuntu 20.04+）
* Docker：已安装并可正常运行（建议使用 Docker 20.10+ 以支持 `--gpus` 参数）
* GPU（可选）：NVIDIA GPU（是否可用取决于 PyTorch 对该架构的支持）

> 注意：
>
> * CUDA 版本的可用性 **由 PyTorch 官方预编译包决定**，而非 NVIDIA 驱动或 CUDA Toolkit 本身。
> * 即使系统未安装 CUDA Toolkit，也不影响使用对应 CUDA 标签的镜像。

---

### 2. 安装 Docker 环境

使用以下一键脚本快速部署 Docker 及相关组件（包含 Docker Engine、Docker Compose 等）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本执行完成后，通过以下命令验证 Docker 是否安装成功：

```bash
docker --version
docker compose version
```

若输出 Docker 版本信息（如 `Docker version 26.1.4, build 5650f9b`），则说明安装成功。

---

### 3. 配置 Docker 服务

启动 Docker 服务并设置开机自启：

```bash
sudo systemctl enable --now docker
```

对于 NVIDIA GPU 用户，需安装 NVIDIA Container Toolkit 以支持 GPU 资源调度：

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

如需使用 NVIDIA GPU，请确保：

```bash
nvidia-smi
```

可正常输出显卡信息。


---

## 三、镜像准备

### 拉取 ComfyUI-BOOT 镜像

使用以下命令通过轩辕镜像访问支持域名拉取推荐版本的 ComfyUI-BOOT 镜像：

```bash
docker pull xxx.xuanyuan.run/yanwk/comfyui-boot:cu128-slim
```

> 说明：`cu128-slim` 为推荐标签，包含 CUDA 12.8 支持，适合新手使用。如需其他版本，可访问 [ComfyUI-BOOT 镜像标签列表](https://xuanyuan.cloud/r/yanwk/comfyui-boot/tags) 查看所有可用标签。

拉取完成后，通过以下命令验证镜像是否成功下载：

```bash
docker images | grep comfyui-boot
```

若输出类似以下内容，则说明镜像拉取成功：

```
xxx.xuanyuan.run/yanwk/comfyui-boot   cu128-slim   abc12345   2 weeks ago   15.2GB
```

---

## 四、快速开始（NVIDIA GPU）

### 1. 创建本地目录

该目录结构 **与官方 README 保持一致**：

```bash
mkdir -p \
  storage \
  storage-models/models \
  storage-models/hf-hub \
  storage-models/torch-hub \
  storage-user/input \
  storage-user/output \
  storage-user/workflows
```

---

### 2. 启动容器

```bash
docker run -it --rm \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -v "$(pwd)"/storage-models/models:/root/ComfyUI/models \
  -v "$(pwd)"/storage-models/hf-hub:/root/.cache/huggingface/hub \
  -v "$(pwd)"/storage-models/torch-hub:/root/.cache/torch/hub \
  -v "$(pwd)"/storage-user/input:/root/ComfyUI/input \
  -v "$(pwd)"/storage-user/output:/root/ComfyUI/output \
  -v "$(pwd)"/storage-user/workflows:/root/ComfyUI/user/default/workflows \
  xxx.xuanyuan.run/yanwk/comfyui-boot:cu128-slim
```

> 提示：如遇兼容性问题，可尝试添加 `-e CLI_ARGS="--disable-xformers"` 参数。

启动后，在浏览器中访问：

```
http://localhost:8188
```


---

## 五、CUDA 与 GPU 架构兼容性说明

### 1. 官方兼容性矩阵（摘要）

| CUDA 标签 | Blackwell | Hopper | Ada | Ampere | Turing | Volta | Pascal | Maxwell |
| ------- | --------- | ------ | --- | ------ | ------ | ----- | ------ | ------- |
| cu130   | ✔️        | ✔️     | ✔️  | ✔️     | ✔️     | ❌     | ❌      | ❌       |
| cu128 ⭐ | ✔️        | ✔️     | ✔️  | ✔️     | ✔️     | ✔️    | ❌      | ❌       |
| cu126   | ❌         | ✔️     | ✔️  | ✔️     | ✔️     | ✔️    | ✔️     | ✔️      |

⭐ 官方推荐使用 **CUDA 12.8（cu128）**。

---

### 2. 重要说明（官方原意）

* 以上限制 **并非 NVIDIA CUDA Toolkit 的限制**
* 而是 **PyTorch 官方为控制二进制体积而做出的支持取舍**
* 是否可用以 PyTorch 官方发布为准

---

## 六、镜像标签说明

### 1. Slim（推荐新手）

* 仅包含 ComfyUI 与 Manager
* 预装大量依赖，便于后续安装自定义节点

可用标签示例：

* `cu126-slim`
* `cu128-slim` ⭐
* `cu130-slim`（无 xFormers）

---

### 2. Megapak（整合包）

* 包含常用自定义节点
* 包含编译工具链

示例：

* `cu126-megapak`
* `cu128-megapak`

---

### 3. 其他标签

* `nightly`：PyTorch 开发预览版
* `rocm` / `rocm6`：AMD GPU
* `xpu-cn`：Intel GPU（国内网络优化）
* `cpu`：仅 CPU
* `archived`：已退役版本

---

## 七、CLI_ARGS 参数说明

`CLI_ARGS` 用于向 ComfyUI 启动脚本传递参数（可选），例如：

```bash
-e CLI_ARGS="--disable-xformers"
```

> 注意：
>
> * 并非所有镜像都支持 xFormers（如 cu130 明确不支持）
> * 参数是否可用取决于镜像标签与 PyTorch 构建方式
> * 如遇启动异常，请优先移除 CLI_ARGS 进行排查
> * 对新手来说，通常无需添加此参数即可正常使用

---

## 八、官方资源

### 官方文档

* [ComfyUI-BOOT 官方 GitHub](https://github.com/YanWenKun/ComfyUI-Docker)：项目源代码及详细文档
* [ComfyUI 官方文档](https://github.com/comfyanonymous/ComfyUI)：ComfyUI 核心功能使用指南

### 镜像资源

* [ComfyUI-BOOT 镜像文档（轩辕）](https://xuanyuan.cloud/r/yanwk/comfyui-boot)：轩辕镜像平台文档页面
* [ComfyUI-BOOT 镜像标签列表](https://xuanyuan.cloud/r/yanwk/comfyui-boot/tags)：所有可用镜像版本标签

### 技术社区

* [ComfyUI 论坛](https://comfyui.com/forum)：用户讨论与问题解答
* [Docker 官方文档](https://docs.docker.com/)：Docker 容器技术详细指南
* [NVIDIA Container Toolkit 文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)：GPU 容器化部署指南

---

## 结语

使用轩辕镜像访问支持可改善 ComfyUI-BOOT 镜像的访问体验，镜像来源于官方公共仓库。

如需进行目录定制、生产化部署、多 GPU 管理等高级配置，请在充分理解官方行为的前提下自行调整。

如遇问题，优先参考 GitHub Issues 与官方文档说明。

