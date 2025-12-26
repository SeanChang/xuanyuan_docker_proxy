---
id: 35
title: Docker 部署 MinerU 全指南
slug: docker-mineru
summary: MinerU 是一款专注于PDF格式转化的工具，尤其擅长将科技文献转化为机器可读格式（如markdown、json），诞生于书生-浦语预训练过程中，核心价值体现在对复杂排版PDF的精准解析与结构化提取。
category: Docker,MinerU
tags: mineru,docker,部署教程
image_name: jianjungki/mineru
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-mineru.png"
status: published
created_at: "2025-10-21 13:16:51"
updated_at: "2025-10-22 01:45:49"
---

# Docker 部署 MinerU 全指南

> MinerU 是一款专注于PDF格式转化的工具，尤其擅长将科技文献转化为机器可读格式（如markdown、json），诞生于书生-浦语预训练过程中，核心价值体现在对复杂排版PDF的精准解析与结构化提取。

在开始 MinerU 镜像拉取与部署操作前，我们先简要明确MinerU的核心价值与Docker部署的优势——这能帮助你更清晰地理解后续操作的意义。

## 关于 MinerU：核心功能与价值
MinerU 是一款专注于PDF格式转化的工具，尤其擅长将科技文献转化为机器可读格式（如markdown、json），诞生于书生-浦语预训练过程中，核心价值体现在对复杂排版PDF的精准解析与结构化提取。其核心功能可概括为六大类：  

- **智能净化内容**：自动删除页眉、页脚、脚注、页码等冗余元素，确保文本语义连贯；  
- **排版自适应**：支持单栏、多栏及复杂排版PDF，输出符合人类阅读顺序的文本；  
- **结构化保留**：完整提取文档结构（标题、段落、列表等），维持原文逻辑层次；  
- **多元素提取**：精准识别并转换公式（LaTeX格式）、表格（HTML格式）、图像及描述、脚注等；  
- **全场景兼容**：自动检测扫描版/乱码PDF并启用OCR，支持84种语言识别，适配纯CPU及GPU/NPU/MPS加速；  
- **多格式输出**：提供多模态Markdown、有序JSON、中间格式等输出，支持可视化质检（layout/span可视化）。  

其最大特点是**专注科技文献解析**（解决符号转化难题）、**跨平台兼容**（Windows/Linux/macOS）、**轻量与高效兼顾**（支持CPU/GPU灵活切换），因此成为科研人员、开发者处理学术文献的高效工具。

## 为什么用 Docker 部署 MinerU？核心优势
传统方式部署MinerU（如源码安装、pip安装）常面临**依赖复杂、环境冲突、GPU配置繁琐**等问题（例如：Python版本不兼容、CUDA驱动与PyTorch版本 mismatch、不同系统库导致的功能缺失）。而Docker部署能完美解决这些痛点，核心优势如下：  

1. **环境零配置**：Docker镜像已打包所有依赖（Python 3.10-3.13、CUDA工具链、模型文件、系统库等），无需手动安装显卡驱动、调整Python版本或解决库冲突，开箱即用；  
2. **GPU支持无缝化**：通过`--gpus=all`参数即可一键启用GPU加速，无需单独配置NVIDIA Container Toolkit与深度学习框架的适配，避免“能检测GPU却无法加速”的问题；  
3. **跨系统一致性**：无论在Ubuntu、Windows（WSL2）还是macOS（M1/M2芯片），Docker容器内的MinerU行为完全一致，彻底消除“Linux能跑、Windows报错”的兼容问题；  
4. **快速启停与隔离**：容器启动仅需秒级，且与主机环境完全隔离，测试不同版本时只需切换镜像，不会污染本地环境；  
5. **部署流程标准化**：通过统一的命令即可完成WebUI（7860端口）与WebAPI（3000端口）的启动，无需记忆复杂的参数配置，新手也能快速上手。  

## 🧰 准备工作
若你的系统尚未安装 Docker 或 NVIDIA 容器工具（需GPU加速时），请先完成以下配置：

### 1. Docker 与 Docker Compose 一键安装（全系统通用）
#### Linux 系统
一键安装脚本（支持Ubuntu/Debian/CentOS，自动配置镜像访问支持）：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

#### Windows 系统
- 安装 [Docker Desktop](https://www.docker.com/products/docker-desktop)（需启用WSL2）；  
- 进入`设置 > Resources > WSL Integration`，开启目标WSL2发行版的集成。

#### macOS 系统
- 安装 [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)；  
- M1/M2芯片用户需在`设置 > Features in development`中勾选“Use Rosetta for x86/amd64 emulation on Apple Silicon”。

### 2. GPU 加速前置配置（可选，需CUDA支持）
若需启用GPU加速（推荐，提升解析访问表现5-10倍），需确保：  
- 显卡为NVIDIA Turing及以后架构（如RTX 2060+/30系列/40系列），显存≥6GB；  
- 已安装NVIDIA驱动（版本≥525.60.13）；  
- 安装NVIDIA Container Toolkit（让Docker识别GPU）：
  ```bash
  # Ubuntu/Debian 示例
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
  sudo systemctl restart docker
  ```

#### 验证GPU是否可用
运行以下命令（已替换为轩辕镜像访问支持地址），若能显示显卡信息则配置成功：
```bash
docker run --rm --gpus=all xxx.xuanyuan.run/nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi
```

## 1、获取 MinerU 镜像
### 1.1 完整 Dockerfile（含轩辕镜像访问支持）
```dockerfile
# Use the official vllm image for gpu with Ampere architecture and above (Compute Capability>=8.0)
# Compute Capability version query (https://developer.nvidia.com/cuda-gpus)
FROM xxx.xuanyuan.run/vllm/vllm-openai:v0.10.1.1

# Use the official vllm image for gpu with Turing architecture and below (Compute Capability<8.0)
# FROM xxx.xuanyuan.run/vllm/vllm-openai:v0.10.2

# Install libgl for opencv support & Noto fonts for Chinese characters
RUN apt-get update && \
    apt-get install -y \
        fonts-noto-core \
        fonts-noto-cjk \
        fontconfig \
        libgl1 && \
    fc-cache -fv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install mineru latest
RUN python3 -m pip install -U 'mineru[core]' --break-system-packages && \
    python3 -m pip cache purge

# Download models and update the configuration file
RUN /bin/bash -c "mineru-models-download -s huggingface -m all"

# Set the entry point to activate the virtual environment and run the command line tool
ENTRYPOINT ["/bin/bash", "-c", "export MINERU_MODEL_SOURCE=local && exec \"$@\"", "--"]
```

### 1.2 下载 Dockerfile
```bash
wget https://github.com/opendatalab/MinerU/raw/master/docker/global/Dockerfile -O Dockerfile
```
> 说明：下载后可直接替换文件中的镜像地址为上述轩辕访问支持地址，或直接使用上方完整Dockerfile内容创建新文件。

### 1.3 构建镜像（轩辕镜像访问支持）
```bash
docker build -t xxx.xuanyuan.run/mineru:latest .
```
#### 说明：
- 构建时使用轩辕镜像访问支持，后续部署可直接通过访问支持地址拉取；  
- 构建过程会自动通过轩辕镜像访问支持拉取基础依赖，耗时约10-30分钟（取决于网络访问表现）；  
- 镜像大小约20GB，需确保磁盘空间充足（推荐SSD，提升构建访问表现）。

### 1.4 验证镜像是否构建成功
```bash
docker images | grep xxx.xuanyuan.run/mineru
```
若输出类似以下内容，说明镜像构建成功：
```
xxx.xuanyuan.run/mineru     latest    abc123456789   10分钟前    20.5GB
```

## 2、部署 MinerU
提供三种部署方案，可根据场景选择。

### 2.1 快速部署（测试用，最简方式）
适合临时测试功能，命令如下：
```bash
docker run --rm -it \
  -p 3000:3000 -p 7860:7860 \  # 映射WebAPI（3000）和WebUI（7860）端口
  --gpus=all \  # 启用GPU加速（无GPU可删除此参数）
  xxx.xuanyuan.run/mineru:latest  # 轩辕镜像访问支持
```

#### 核心参数说明：
- `-p 3000:3000`：WebAPI端口映射，用于通过API调用解析功能；  
- `-p 7860:7860`：WebUI端口映射，用于通过浏览器可视化操作；  
- `--gpus=all`：允许容器使用所有GPU（无GPU环境需删除，自动切换为CPU模式）；  
- `--rm`：容器停止后自动删除，避免残留文件；  
- `xxx.xuanyuan.run/mineru:latest`

#### 验证方式：
- 浏览器访问 `http://localhost:7860`，应显示MinerU的WebUI界面；  
- 终端执行 `curl http://localhost:3000/docs`，应返回API文档说明。

### 2.2 挂载目录（生产用，推荐方式）
通过挂载宿主机目录，实现「PDF文件持久化」「输出结果本地保存」「配置文件自定义」，步骤如下：

#### 第一步：创建宿主机目录
```bash
# 分别用于存放输入PDF、输出结果、自定义配置
mkdir -p /data/mineru/{input,output,config}
```

#### 第二步：启动容器并挂载目录
```bash
docker run -d --name mineru-service \
  -p 3000:3000 -p 7860:7860 \
  --gpus=all \
  -v /data/mineru/input:/opt/mineru/input \  # 输入PDF目录
  -v /data/mineru/output:/opt/mineru/output \  # 输出结果目录
  -v /data/mineru/config:/opt/mineru/config \  # 配置文件目录
  xxx.xuanyuan.run/mineru:latest  # 轩辕镜像访问支持
```

#### 目录映射说明：
| 宿主机目录               | 容器内目录                | 用途                          |
|--------------------------|---------------------------|-------------------------------|
| `/data/mineru/input`     | `/opt/mineru/input`       | 存放待解析的PDF文件           |
| `/data/mineru/output`    | `/opt/mineru/output`      | 保存解析后的markdown/json等文件 |
| `/data/mineru/config`    | `/opt/mineru/config`      | 存放自定义配置（如模型参数）  |

#### 使用示例：
1. 将待解析的`paper.pdf`放入`/data/mineru/input`；  
2. 在WebUI中选择“输入路径”为`/opt/mineru/input/paper.pdf`，“输出路径”为`/opt/mineru/output/result.md`；  
3. 解析完成后，在宿主机`/data/mineru/output`中即可找到`result.md`。

### 2.3 docker-compose 部署（企业级场景，批量管理）
通过`docker-compose.yml`统一管理容器配置，支持一键启动/停止，适合多实例或与其他服务联动，步骤如下：

#### 第一步：创建 docker-compose.yml 文件
```yaml
version: '3.8'
services:
  mineru:
    image: xxx.xuanyuan.run/mineru:latest  # 轩辕镜像访问支持
    container_name: mineru-service
    ports:
      - "3000:3000"  # WebAPI
      - "7860:7860"  # WebUI
    volumes:
      - ./input:/opt/mineru/input
      - ./output:/opt/mineru/output
      - ./config:/opt/mineru/config
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all  # 使用所有GPU
              capabilities: [gpu]
    restart: always  # 容器退出后自动重启
```

#### 第二步：启动服务
在`docker-compose.yml`所在目录执行：
```bash
docker compose up -d
```

#### 补充说明：
- 停止服务：`docker compose down`；  
- 查看日志：`docker compose logs -f mineru`；  
- 如需限制GPU使用数量，将`count: all`改为具体数量（如`count: 1`）；  
- 镜像拉取优先级：本地已构建`xxx.xuanyuan.run/mineru:latest`则直接使用，否则通过轩辕加速仓库拉取。

## 3、结果验证
通过以下方式确认MinerU服务正常运行：

1. **WebUI验证**：  
   浏览器访问 `http://localhost:7860`，上传一个PDF文件（如`test.pdf`），点击“解析”按钮，若能生成markdown预览则功能正常。

2. **API验证**：  
   使用curl调用WebAPI（以解析`/opt/mineru/input/test.pdf`为例）：
   ```bash
   curl -X POST "http://localhost:3000/api/parse" \
     -H "Content-Type: application/json" \
     -d '{"input_path": "/opt/mineru/input/test.pdf", "output_path": "/opt/mineru/output/test.md"}'
   ```
   若返回`{"status": "success", "message": "解析完成"}`，则API调用成功。

3. **容器状态验证**：  
   ```bash
   docker ps | grep mineru-service
   ```
   若`STATUS`列显示`Up`，说明容器正常运行。

## 4、常见问题
### 4.1 GPU不生效？
排查方向：  
- 检查是否遗漏`--gpus=all`参数（Docker部署）或`devices`配置（docker-compose）；  
- 运行`nvidia-smi`确认主机GPU正常，驱动版本≥525.60.13；  
- 重新安装NVIDIA Container Toolkit并重启Docker：`sudo systemctl restart docker`；  
- 验证GPU镜像时确保使用轩辕访问支持地址：`docker run --rm --gpus=all xxx.xuanyuan.run/nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi`。

### 4.2 端口被占用？
解决方案：  
- 更换宿主机端口，例如将`-p 3000:3000`改为`-p 3001:3000`（用3001端口访问WebAPI）；  
- 查找占用端口的进程并关闭：`lsof -i:3000`（Linux/macOS）或`netstat -ano | findstr :3000`（Windows）。

### 4.3 解析访问表现慢？
优化建议：  
- 启用GPU加速（比CPU快5-10倍），确保显存≥6GB；  
- 减少单次解析的PDF页数（拆分大型PDF）；  
- 调整WebUI中的“解析精度”为“快速模式”（适合非复杂排版文档）。

### 4.4 OCR识别不准确？
处理方式：  
- 确认PDF为扫描版（MinerU会自动检测，非扫描版无需OCR）；  
- 在WebUI的“OCR设置”中指定文档语言（默认自动检测，小语种建议手动选择）；  
- 提升PDF清晰度（分辨率≥300dpi的扫描件识别效果更佳）。

### 4.5 容器启动后立即退出？
可能原因：  
- 磁盘空间不足（镜像+临时文件需≥25GB），清理空间后重启；  
- 内存不足（推荐≥16GB），关闭其他占用内存的进程；  
- 查看日志定位错误：`docker logs mineru-service`；  
- 确认镜像地址正确：确保使用`xxx.xuanyuan.run/mineru:latest`，避免镜像拉取失败。

## 结尾
至此，你已掌握MinerU的Docker部署全流程——从环境准备、镜像构建，到不同场景的部署实践，再到问题排查。对于初学者，建议先通过“快速部署”体验核心功能，再通过“目录挂载”实现文件持久化管理；若需集成到业务系统，可基于`docker-compose`配置实现服务自动化运维。

MinerU在科技文献解析上的优势（公式/表格/结构提取）使其成为科研辅助的利器，实际使用中可结合WebUI的可视化质检功能优化解析结果。若遇到复杂问题，可参考官方文档或提交issue反馈，社区会持续迭代优化工具能力。

