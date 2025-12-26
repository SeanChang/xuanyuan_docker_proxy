---
id: 24
title: NVIDIA CUDA 镜像 Docker 容器化部署全流程
slug: nvidia-cuda-docker
summary: CPU 像“全能但慢的多面手”，适合处理逻辑复杂但数据量小的任务；GPU 像“成千上万的小工人”，擅长同时处理大量重复、简单的计算。CUDA 就是连接开发者与 GPU 能力的“桥梁”，让 GPU 能脱离显卡驱动，直接为科学计算、AI 训练、数据处理等任务服务。
category: Docker,CUDA
tags: nvidia,cuda,docker,部署教程
image_name: nvidia/cuda
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-cuda.png"
status: published
created_at: "2025-10-10 02:44:12"
updated_at: "2025-10-10 03:36:56"
---

# NVIDIA CUDA 镜像 Docker 容器化部署全流程

> CPU 像“全能但慢的多面手”，适合处理逻辑复杂但数据量小的任务；GPU 像“成千上万的小工人”，擅长同时处理大量重复、简单的计算。CUDA 就是连接开发者与 GPU 能力的“桥梁”，让 GPU 能脱离显卡驱动，直接为科学计算、AI 训练、数据处理等任务服务。

## 一、关于 NVIDIA CUDA：到底是什么？能做什么？
CUDA 全称为 **Compute Unified Device Architecture**（统一计算设备架构），是 NVIDIA 开发的**并行计算平台与编程模型**，核心作用是让开发者能利用 GPU（图形处理器）的强大并行计算能力，加速各类通用计算任务——而不只是传统的图形渲染。

简单说：CPU 像“全能但慢的多面手”，适合处理逻辑复杂但数据量小的任务；GPU 像“成千上万的小工人”，擅长同时处理大量重复、简单的计算。CUDA 就是连接开发者与 GPU 能力的“桥梁”，让 GPU 能脱离显卡驱动，直接为科学计算、AI 训练、数据处理等任务服务。

### 1. CUDA 的核心价值（谁需要用？）
- **AI 与机器学习**：TensorFlow、PyTorch 等框架依赖 CUDA 实现 GPU 加速，训练模型访问表现比 CPU 快 10-100 倍（比如训练一个图像识别模型，CPU 要几天，GPU 可能几小时）；
- **科学计算**：物理模拟、气象预测、分子动力学等领域，需要处理海量数据的并行计算，CUDA 能大幅缩短计算周期；
- **图形与视频处理**：3D 渲染、视频编码/解码、特效生成等任务，通过 CUDA 调用 GPU 资源，提升处理效率；
- **工业软件**：CAD、有限元分析、流体力学模拟等专业软件，CUDA 可加速复杂模型的计算与预览。

### 2. CUDA Toolkit 包含什么？
要使用 CUDA，通常需要 **CUDA Toolkit**（CUDA 工具包），它是开发者的“工具箱”，包含：
- GPU 加速库：如 cuDNN（深度学习专用库）、NCCL（多 GPU 通信库）、cuBLAS（线性代数库）等，直接调用就能实现加速，不用重复造轮子；
- 编译器：nvcc（CUDA C/C++ 编译器），将开发者写的 CUDA 代码编译成 GPU 能执行的指令；
- 开发工具：如 CUDA Debugger、Profiler（性能分析工具），帮开发者排查代码问题、优化性能；
- CUDA 运行时（Runtime）：让编译后的程序能在 GPU 上正常运行的基础环境。

### 3. CUDA 容器镜像的优势
直接在主机安装 CUDA 常面临“版本冲突、环境不兼容、多任务隔离差”等问题（比如一台机器要跑不同 CUDA 版本的模型，主机安装多个版本容易出错）。而 CUDA 容器镜像已将“CUDA 运行时/开发工具 + 系统依赖”打包好，优势如下：
- 环境绝对一致：无论在开发机、测试机还是生产服务器，只要能跑 Docker，CUDA 环境就完全一样，避免“本地能跑、线上报错”；
- 隔离安全：不同 CUDA 任务用不同容器，互不干扰（比如一个容器跑 CUDA 11，另一个跑 CUDA 13）；
- 快速切换：更新 CUDA 版本只需拉取新镜像，回滚只需启动旧镜像，比主机安装高效 10 倍以上。


## 二、准备工作：必须安装的工具
要运行 CUDA 容器，除了 Docker，还需要 **NVIDIA Container Toolkit**（NVIDIA 容器工具包）——它能让 Docker 容器直接访问主机的 GPU 资源。如果你的系统还没装 Docker，先完成以下步骤。

### 1. 第一步：安装 Docker 与 Docker Compose（Linux 系统）
如果你的 Linux 机器未安装 Docker，直接用轩辕镜像的一键安装脚本（支持 Ubuntu、CentOS、Rocky Linux 等主流发行版，自动配置加速源）：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```
执行后按提示选择“1) 一键安装配置”，脚本会自动完成 Docker、Docker Compose 安装，并配置轩辕镜像访问支持（后续拉取 CUDA 镜像会更快）。

安装完成后，验证 Docker 是否正常运行：
```bash
docker --version  # 显示 Docker 版本，如 Docker version 26.0.0
docker compose --version  # 显示 Docker Compose 版本，如 v2.25.0
```

### 2. 第二步：安装 NVIDIA Container Toolkit（关键！）
这一步是“让容器访问 GPU”的核心，不同 Linux 发行版命令略有不同，按你的系统选择：

#### 情况 1：Ubuntu / Debian 系统
```bash
# 1. 添加 NVIDIA 官方源的 GPG 密钥
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/7fa2af80.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/nvidia-cuda.gpg

# 2. 添加 NVIDIA Container Toolkit 源
echo "deb [signed-by=/etc/apt/trusted.gpg.d/nvidia-cuda.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | sudo tee /etc/apt/sources.list.d/nvidia-cuda.list

# 3. 更新源并安装 Toolkit
sudo apt update && sudo apt install -y nvidia-container-toolkit

# 4. 配置 Docker 以使用 NVIDIA 运行时
sudo nvidia-ctk runtime configure --runtime=docker

# 5. 重启 Docker 服务，使配置生效
sudo systemctl restart docker
```

#### 情况 2：CentOS / Rocky Linux / RHEL 系统
```bash
# 1. 添加 NVIDIA Container Toolkit 源
sudo dnf config-manager --add-repo=https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo

# 2. 安装 Toolkit
sudo dnf install -y nvidia-container-toolkit

# 3. 配置 Docker 运行时
sudo nvidia-ctk runtime configure --runtime=docker

# 4. 重启 Docker
sudo systemctl restart docker
```

#### 验证 Toolkit 是否安装成功
运行以下命令，如果能看到主机的 GPU 信息，说明配置正确：
```bash
docker run --rm --gpus all nvidia/cuda:13.0.1-runtime-ubuntu22.04 nvidia-smi
```
输出类似以下内容（显示 GPU 型号、驱动版本、CUDA 版本）：
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 535.104.05   Driver Version: 535.104.05   CUDA Version: 13.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla T4            Off  | 00000000:00:04.0 Off |                    0 |
| N/A   34C    P8     9W /  70W |      0MiB / 15360MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
```


## 三、查看 CUDA 镜像：选对版本很重要
轩辕镜像提供了 NVIDIA CUDA 全版本镜像，地址：[https://xuanyuan.cloud/r/nvidia/cuda](https://xuanyuan.cloud/r/nvidia/cuda)  
打开页面后，能看到镜像的“标签列表”——每个标签对应不同的 CUDA 版本、系统版本、镜像类型（base/runtime/devel），先搞懂标签含义再选择：

| 标签组成部分       | 含义示例                  | 说明                                  |
|--------------------|---------------------------|---------------------------------------|
| CUDA 版本          | 13.0.1                    | 推荐选最新稳定版（如 13.0.1）          |
| 附加组件          | cudnn                     | 包含 cuDNN 库（深度学习必选）          |
| 镜像类型          | runtime / devel           | runtime：仅含运行环境；devel：含开发工具（编译代码用） |
| 系统版本          | ubuntu24.04 / ubi9        | 系统镜像（ubuntu 兼容性好，ubi 适合企业级） |

### 怎么选？给初学者的建议：
- 仅运行已编译好的 CUDA 程序（如 PyTorch 模型）：选 `cudnn-runtime` 类型（如 `13.0.1-cudnn-runtime-ubuntu24.04`）；
- 需要编译 CUDA 代码（如自己写 CUDA 程序）：选 `cudnn-devel` 类型（如 `13.0.1-cudnn-devel-ubuntu24.04`）；
- 系统偏好：Ubuntu 24.04 / 22.04 兼容性最好，新手优先选。


## 四、下载 CUDA 镜像：4 种拉取方式
轩辕镜像支持免登录拉取，访问表现比官方快，推荐优先使用以下方式。

### 1. 方式 1：免登录拉取（推荐新手）
直接拉取常用版本（以 `13.0.1-cudnn-runtime-ubuntu24.04` 为例，适合运行深度学习任务）：
```bash
docker pull docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04
```
如果需要开发环境（编译 CUDA 代码），拉取 devel 版本：
```bash
docker pull docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-devel-ubuntu24.04
```

### 2. 方式 2：拉取后重命名（推荐高级工程师）
拉取后将镜像重命名为“官方标准名称”（如 `nvidia/cuda:13.0.1-cudnn-runtime`），后续运行命令更简洁，也避免与其他镜像混淆：
```bash
# 1. 拉取轩辕镜像
docker pull docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04

# 2. 重命名为官方名称
docker tag docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04 nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04

# 3. 删除临时标签（可选，节省存储空间）
docker rmi docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04
```

### 3. 方式 3：官方直连拉取（需配置加速）
如果已通过轩辕脚本配置了 Docker 加速，也可直接拉取官方镜像（访问表现与轩辕镜像一致）：
```bash
docker pull nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04
```

### 4. 验证镜像是否拉取成功
运行以下命令，若能看到 CUDA 镜像信息，说明下载成功：
```bash
docker images | grep nvidia/cuda
```
输出类似：
```
nvidia/cuda               13.0.1-cudnn-runtime-ubuntu24.04   5f4e3a7b2c12   2 weeks ago   1.86 GB
```


## 五、部署 CUDA 容器：3 种场景方案
根据你的需求选择部署方案，从“快速测试”到“企业级持久化”都有详细步骤。

### 方案 1：快速测试（适合验证 GPU 可用性）
如果只是想确认 CUDA 环境能正常工作，运行一个**交互式容器**，查看 CUDA 版本和 GPU 信息：
```bash
# 启动交互式容器（--gpus all 表示使用所有 GPU，-it 表示交互式）
docker run --rm --gpus all -it --name cuda-test docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04
```
- `--rm`：容器退出后自动删除（避免残留无用容器）；
- `--gpus all`：允许容器使用主机所有 GPU（若想指定 GPU，可写 `--gpus "device=0"`，表示只使用第 0 号 GPU）；
- `-it`：交互式模式，能直接在容器内输入命令。

#### 容器内验证：
1. 查看 CUDA 版本：
   ```bash
   nvcc -V  # 若为 runtime 版本，可能没有 nvcc，改用以下命令
   # 或查看系统环境变量中的 CUDA 版本
   echo $CUDA_VERSION
   ```
   输出类似：`13.0.1`

2. 查看 GPU 信息（与主机 `nvidia-smi` 输出一致）：
   ```bash
   nvidia-smi
   ```

3. 退出容器：
   ```bash
   exit
   ```
   由于加了 `--rm`，退出后容器会自动删除。


### 方案 2：持久化工作目录（适合实际任务）
如果需要在容器内运行自己的代码或处理数据，建议**挂载宿主机目录**——这样代码和数据不会随容器删除而丢失（比如训练模型的数据集、结果文件）。

#### 步骤 1：在宿主机创建工作目录
先在主机上创建一个目录，用于存放 CUDA 任务的代码和数据（以 `/data/cuda-work` 为例）：
```bash
mkdir -p /data/cuda-work  # -p 表示递归创建目录，避免不存在的父目录报错
```

#### 步骤 2：启动容器并挂载目录
以“运行深度学习任务”为例，拉取 `cudnn-runtime` 版本，挂载 `/data/cuda-work` 到容器的 `/work` 目录：
```bash
docker run -d \
  --name cuda-work \  # 容器命名为 cuda-work，方便后续管理
  --gpus all \        # 使用所有 GPU
  -v /data/cuda-work:/work \  # 挂载宿主机目录到容器
  -w /work \          # 容器启动后默认进入 /work 目录
  docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04 \
  sleep infinity      # 让容器后台持续运行（避免启动后立即退出）
```
- `-d`：后台运行容器；
- `-v /data/cuda-work:/work`：宿主机的 `/data/cuda-work` 目录与容器的 `/work` 目录双向同步（在主机写的代码，容器里能看到；容器里生成的结果，主机也能看到）；
- `-w /work`：容器启动后默认进入 `/work` 目录；
- `sleep infinity`：让容器后台挂起（如果是运行具体任务，可替换为任务命令，如 `python train.py`）。

#### 步骤 3：进入容器操作
```bash
# 进入正在运行的 cuda-work 容器（交互式）
docker exec -it cuda-work bash
```
此时你会进入容器的 `/work` 目录，可直接执行代码：
```bash
# 示例：在容器内创建一个测试文件（主机 /data/cuda-work 目录会同步看到）
echo "import torch; print('GPU 可用：', torch.cuda.is_available())" > test_gpu.py

# 若容器内没有 Python，先安装（以 Ubuntu 为例）
apt update && apt install -y python3 python3-pip

# 安装 PyTorch（验证 GPU 能否用于深度学习）
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# 运行测试脚本（输出 GPU 可用：True 表示成功）
python3 test_gpu.py
```

#### 步骤 4：停止/重启容器
```bash
# 停止容器
docker stop cuda-work

# 重启容器（重启后挂载目录和配置不变）
docker start cuda-work

# 查看容器日志（若任务报错，用日志排查）
docker logs cuda-work
```


### 方案 3：Docker Compose 部署（企业级场景）
如果需要长期运行 CUDA 任务，且要管理多个服务（如“CUDA 容器 + 数据库容器”），用 `docker-compose.yml` 统一配置，支持一键启动/停止。

#### 步骤 1：创建 docker-compose.yml 文件
在宿主机的 `/data/cuda-compose` 目录下创建文件（目录可自定义）：
```bash
# 创建目录并进入
mkdir -p /data/cuda-compose && cd /data/cuda-compose

# 创建 docker-compose.yml
nano docker-compose.yml
```
粘贴以下内容（以“运行 CUDA 深度学习任务”为例）：
```yaml
version: '3.8'  # 兼容 Docker Compose 2.x 版本
services:
  cuda-service:
    image: docker.xuanyuan.run/nvidia/cuda:13.0.1-cudnn-runtime-ubuntu24.04
    container_name: cuda-service  # 容器名称
    runtime: nvidia  # 启用 NVIDIA 运行时（关键，否则无法访问 GPU）
    environment:
      - TZ=Asia/Shanghai  # 设置容器时区（避免日志时间错乱）
      - CUDA_VISIBLE_DEVICES=0  # 指定使用第 0 号 GPU（多 GPU 可写 0,1）
    volumes:
      - ./work:/work  # 挂载当前目录下的 work 到容器 /work（相对路径）
      - ./data:/data  # 挂载数据目录（存放数据集）
    working_dir: /work  # 默认工作目录
    restart: always  # 容器退出后自动重启（保障服务可用性）
    command: sleep infinity  # 后台挂起（实际任务替换为你的命令，如 python train.py）
```
按 `Ctrl+O` 保存，`Ctrl+X` 退出 nano。

#### 步骤 2：创建挂载目录
在 `docker-compose.yml` 所在目录（`/data/cuda-compose`）创建 `work` 和 `data` 目录：
```bash
mkdir -p work data
```
- `work`：存放代码文件；
- `data`：存放数据集（避免容器删除导致数据丢失）。

#### 步骤 3：启动服务
在 `docker-compose.yml` 所在目录执行：
```bash
docker compose up -d
```
- `-d`：后台启动服务。

#### 步骤 4：管理服务（常用命令）
```bash
# 查看服务状态（是否正常运行）
docker compose ps

# 进入容器
docker compose exec -it cuda-service bash

# 查看容器日志（排查错误）
docker compose logs -f cuda-service  # -f 表示实时跟踪日志

# 停止服务（容器不会删除，数据保留）
docker compose stop

# 启动已停止的服务
docker compose start

# 停止并删除服务（容器会删除，但挂载目录的 data/work 保留）
docker compose down
```


## 六、常见问题：新手必看的排查方法
### 1. 容器内看不到 GPU？提示“no CUDA-capable device is detected”
- 原因 1：启动容器时没加 `--gpus all` 或 `runtime: nvidia`（Docker Compose）；  
  解决：重新启动容器，加上 `--gpus all`（如方案 1 的命令）。
- 原因 2：NVIDIA Container Toolkit 没装或没重启 Docker；  
  解决：重新执行“准备工作 2”的步骤，确保 `sudo systemctl restart docker` 执行成功。
- 原因 3：主机 GPU 驱动版本过低（不支持当前 CUDA 版本）；  
  解决：查看 NVIDIA 官方的“CUDA 与驱动版本对应表”，升级主机 GPU 驱动（参考 [NVIDIA 驱动下载页](https://www.nvidia.com/download/index.aspx)）。

### 2. 拉取镜像时提示“GPG 密钥错误”（如 NO_PUBKEY A4B469963BF863CC）
- 原因：CUDA 仓库签名密钥更新，本地密钥过期；  
  解决：导入新密钥（以 Ubuntu 为例）：
  ```bash
  curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/7fa2af80.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/cuda-new-key.gpg
  sudo apt update  # 重新更新源
  ```

### 3. 容器内运行代码提示“nvcc: command not found”
- 原因：拉的是 `runtime` 版本镜像（仅含运行环境，没有 nvcc 编译器）；  
  解决：如果需要编译 CUDA 代码，重新拉取 `devel` 版本（如 `13.0.1-cudnn-devel-ubuntu24.04`）。

### 4. 镜像拉取访问表现慢？
- 原因：没配置轩辕镜像访问支持；  
  解决：重新执行“准备工作 1”的一键脚本，确保加速源配置成功（脚本会自动修改 `/etc/docker/daemon.json`）。


## 七、结尾：进阶提示
- 镜像选择建议：开发阶段用 `devel` 版本（编译代码），生产阶段用 `runtime` 版本（体积更小，启动更快）；
- 多 GPU 调度：启动容器时用 `--gpus "device=0,1"` 指定使用第 0、1 号 GPU，避免单 GPU 过载；
- 性能优化：运行密集型任务时，可通过 `--memory 16g` 限制容器内存使用（如 `docker run --gpus all --memory 16g ...`）；
- 官方资源：若需要更深入的 CUDA 开发，参考 [NVIDIA CUDA 官方文档](https://docs.nvidia.com/cuda/)，或查看 [CUDA 容器 GitHub 仓库](https://github.com/NVIDIA/nvidia-docker)。

至此，你已掌握 CUDA 镜像的 Docker 部署全流程——从环境准备到不同场景的实战，每个步骤都能直接复制命令执行。新手建议先从“方案 1 快速测试”入手，熟悉 GPU 与容器的交互；高级工程师可基于“方案 3”扩展，结合业务需求添加监控、日志收集等功能，让 CUDA 任务更稳定、可维护。

