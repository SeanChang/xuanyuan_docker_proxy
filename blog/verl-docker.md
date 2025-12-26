---
id: 20
title: verl Docker 容器化部署手册
slug: verl-docker
summary: 无论你是刚接触大模型工具的初学者，还是需要高效管理训练任务的高级工程师，本教程都将带你一步步完成 verlai/verl 镜像的 Docker 部署——从工具认知、环境搭建到多场景部署实践，每个步骤均配备完整命令与详细说明，确保照着做就能成。
category: Docker,verl
tags: verl,docker,部署教程
image_name: verlai/verl
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-verl.png"
status: published
created_at: "2025-10-08 14:26:55"
updated_at: "2025-10-08 14:26:55"
---

# verl Docker 容器化部署手册

> 无论你是刚接触大模型工具的初学者，还是需要高效管理训练任务的高级工程师，本教程都将带你一步步完成 verlai/verl 镜像的 Docker 部署——从工具认知、环境搭建到多场景部署实践，每个步骤均配备完整命令与详细说明，确保照着做就能成。

## 一、关于 verl：它是什么？能做什么？
基于 `verl` 官方文档（[https://verl.readthedocs.io](https://verl.readthedocs.io)），`verl` 是一款**聚焦大模型“训练+推理”全流程的工具集**，核心定位是降低大模型强化学习（RL）训练与高效推理的门槛，尤其适配企业级大模型落地场景。其本质是通过封装主流深度学习框架（如 PyTorch、Megatron-LM）和推理引擎（如 vLLM），让开发者无需手动解决复杂的环境依赖、分布式配置问题，专注于模型优化与业务逻辑。


### 1.1 verl 的核心功能
`verl` 的能力覆盖“训练”和“推理”两大核心场景，且支持灵活扩展：
- **大模型训练：主打强化学习与分布式能力**
  - 支持多训练后端：适配 `FSDP`（PyTorch 原生分布式框架，适合快速验证原型）、`Megatron-LM`（NVIDIA 高性能分布式框架，支持万卡级大模型训练，适合大规模落地）。
  - 强化学习（RL）优化：内置 RL 训练流程封装，可直接用于大模型 RLHF（基于人类反馈的强化学习）、RLHF 变种任务，无需从零搭建训练 pipeline。
  - 依赖自动兼容：自动适配 PyTorch、CUDA、FlashAttention 等核心依赖版本，避免“版本冲突导致训练崩溃”。

- **大模型推理：高效生成 rollout 结果**
  - 支持多推理引擎：集成 `vLLM`（业界领先的高吞吐推理框架，支持动态批处理）、`TGI`（Hugging Face Text Generation Inference，适合标准 Hugging Face 模型），未来将支持 `SGLang`。
  - 聚焦“rollout 生成”：专为强化学习场景设计——快速生成模型输出样本（如 RLHF 中的“模型回答候选”），推理访问表现比原生 Hugging Face `pipeline` 提升 5-10 倍。

- **高扩展性与定制化**
  - 支持自定义训练配置：可通过 YAML 配置文件修改训练参数（如学习率、 batch size、分布式策略）。
  - 源码级可定制：若使用挂载目录部署，可直接修改 `verl` 源码（如适配新的 RL 算法、自定义数据集），无需重新构建镜像。


### 1.2 verl 的适用场景
| 用户类型       | 适用场景                                                                 |
|----------------|--------------------------------------------------------------------------|
| 算法工程师     | 快速验证大模型 RL 算法、搭建 RLHF 训练流程、测试不同推理引擎的 rollout 效率。 |
| 企业运维/DevOps | 为团队快速部署统一的大模型训练/推理环境，避免“一人一环境”的运维混乱。       |
| 初学者         | 零门槛体验大模型分布式训练与高效推理，无需手动配置 CUDA、PyTorch 等复杂环境。 |
| 大型团队       | 基于 `Megatron-LM` 后端搭建大规模分布式训练集群，支撑百亿/千亿参数模型训练。 |


## 二、为什么用 Docker 部署 verl？
`verl` 依赖的组件（如 CUDA 12.1+、PyTorch 2.4.0+、Megatron-LM、vLLM）版本关联性极强，传统“本地手动安装”常面临 **“CUDA 版本不兼容”“FlashAttention 编译失败”“Megatron-LM 路径配置错误”** 等问题。而 Docker 部署能完美解决这些痛点，核心优势如下：
1. **环境“开箱即用”**：`verlai/verl` 镜像已预装所有核心依赖（CUDA、PyTorch、vLLM、Megatron-LM），无需手动编译或配置环境变量，新手也能 5 分钟启动训练。
2. **GPU 环境免配置**：镜像内置 GPU 驱动适配逻辑，只需在启动时指定 `--gpus all`，即可自动启用 GPU 加速，避免“本地 GPU 驱动与 CUDA 版本不匹配”。
3. **快速版本切换**：若需测试不同 `verl` 版本（如兼容 Megatron-LM v0.4.0 的旧版本），只需拉取对应标签的镜像，无需卸载重装依赖。
4. **服务隔离安全**：`verl` 容器与主机、其他服务（如 MySQL、Redis）完全隔离，即使训练任务崩溃，也不会影响其他应用。
5. **企业级可管理**：支持通过 `docker-compose` 统一管理训练任务、日志、数据挂载，便于团队协作与运维。


## 三、准备工作：搭建 Docker 与 GPU 环境
`verl` 依赖 GPU 加速（CPU 模式仅支持极小模型测试，不推荐），因此需先完成 **Docker 安装** 和 **NVIDIA GPU 环境配置**。


### 3.1 一键安装 Docker & Docker Compose（Linux 系统）
若你的服务器未安装 Docker，直接执行以下一键脚本（支持 Ubuntu、CentOS、Debian 等主流 Linux 发行版），脚本会自动安装 Docker、Docker Compose，并配置 **轩辕镜像访问支持源**（解决“镜像拉取慢”问题）：
```bash
# 一键安装 Docker、Docker Compose 并配置轩辕加速
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

#### 验证 Docker 安装成功
执行以下命令，若输出版本信息，则说明 Docker 安装正常：
```bash
# 验证 Docker 版本
docker --version
# 验证 Docker Compose 版本
docker compose version
```


### 3.2 安装 NVIDIA Container Toolkit（关键：启用 GPU 支持）
`verl` 依赖 GPU 运行，需安装 `NVIDIA Container Toolkit` 让 Docker 容器识别主机 GPU。步骤如下（以 Ubuntu 为例，其他系统可参考 [NVIDIA 官方文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)）：
1. 添加 NVIDIA 官方源：
   ```bash
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   ```

2. 安装 NVIDIA Container Toolkit：
   ```bash
   sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
   ```

3. 重启 Docker 服务使配置生效：
   ```bash
   sudo systemctl restart docker
   ```

4. 验证 GPU 支持：
   运行 NVIDIA 测试镜像，若输出 GPU 信息（如型号、CUDA 版本），则 GPU 配置正常：
   ```bash
   docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
   ```


## 四、查看 verl 镜像：轩辕镜像仓库地址
本次部署使用 **轩辕镜像仓库** 的 `verlai/verl` 镜像（地址：[https://xuanyuan.cloud/r/verlai/verl](https://xuanyuan.cloud/r/verlai/verl)），该仓库提供：
- 加速拉取：国内网络拉取访问表现比 Docker Hub 快 5-10 倍，无需科学上网。
- 免登录选项：初学者可直接拉取。


## 五、下载 verl 镜像：4 种拉取方式
根据你的权限与使用场景，选择以下任意一种方式拉取 `verlai/verl` 镜像，推荐初学者优先选择 **“免登录拉取”**（步骤最简单）。


### 5.1 方式 1：免登录拉取
直接拉取最新稳定版镜像，命令如下：
```bash
# 从轩辕镜像免登录拉取 verlai/verl 对应版本。注意，这里的版本需要按照你的配置选择，这里只是示例。

docker pull xxx.xuanyuan.run/verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
```


### 5.2 方式 2：拉取后改名（简化后续命令）
若觉得 `xuanyuan.cloud/r/verlai/verl` 镜像名过长，可拉取后重命名为 `verlai/verl`（与 Docker Hub 官方命名一致），后续启动命令更简洁：
```bash
# 拉取镜像 → 重命名 → 删除原标签（避免占用空间）
docker pull xxx.xuanyuan.run/verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2 \
&& docker tag xxx.xuanyuan.run/verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2 verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2 \
&& docker rmi xxx.xuanyuan.run/verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
```


### 5.3 方式 3：登录验证拉取（适合需要权限的镜像）
1. 登录轩辕镜像（按提示输入轩辕镜像用户名和密码）：
   ```bash
   docker login docker.xuanyuan.run
   ```
2. 拉取镜像：
   ```bash
   docker pull docker.xuanyuan.run/verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
   ```


### 5.4 方式 4：Docker Hub 官方拉取（备用）
若你的网络可直连 Docker Hub，也可直接拉取官方镜像（访问表现可能较慢，建议优先用轩辕镜像）：
```bash
docker pull verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
```


### 5.5 验证镜像拉取成功
执行以下命令，若输出 `verlai/verl` 镜像信息（如 `REPOSITORY`、`TAG`、`SIZE`），则拉取成功：
```bash
docker images | grep verlai/verl
```

#### 示例输出（成功状态）：
```
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
verlai/verl         latest    a1b2c3d4e5f6   1 week ago     15.2GB
```


## 六、部署 verl：3 种场景方案
根据你的使用需求（测试、实际项目、企业级管理），选择以下部署方案。每种方案均包含 **完整命令、参数说明、验证步骤**，确保不同水平的用户都能操作。


### 6.1 方案 1：快速部署（测试用，适合初学者）
适合快速验证 `verl` 功能（如查看版本、测试基础命令），无需持久化数据，命令极简：
```bash
# 启动 verl 容器（命名为 verl-test，启用所有 GPU，后台运行）
docker run -d \
  --name verl-test \
  --gpus all \  # 启用主机所有 GPU（关键：verl 依赖 GPU 运行）
  --shm-size="16g" \  # 共享内存设置为 16GB（避免多进程训练内存不足）
  verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
```

#### 核心参数说明：
| 参数               | 作用                                                                 |
|--------------------|----------------------------------------------------------------------|
| `-d`               | 后台运行容器，避免终端退出后容器停止。                               |
| `--name verl-test` | 为容器指定名称，便于后续管理（如停止、重启）。                       |
| `--gpus all`       | 让容器使用主机所有 GPU（若需指定单个 GPU，可改为 `--gpus "device=0"`）。 |
| `--shm-size="16g"` | 增大容器共享内存（大模型训练需高频数据交换，默认 64MB 会导致内存溢出）。 |


#### 验证部署成功：
1. 查看容器是否正常运行：
   ```bash
   docker ps | grep verl-test
   ```
   若 `STATUS` 列显示 `Up`（如 `Up 5 minutes`），则容器启动正常。

2. 进入容器测试 `verl` 功能：
   ```bash
   # 进入 verl-test 容器的命令行
   docker exec -it verl-test /bin/bash
   ```
   进入容器后，执行以下命令验证 `verl` 是否可用：
   ```bash
   # 查看 verl 版本（验证安装）
   pip list | grep verl
   # 查看 PyTorch 与 CUDA 兼容性（验证 GPU 可用）
   python -c "import torch; print('PyTorch 版本:', torch.__version__); print('CUDA 是否可用:', torch.cuda.is_available())"
   ```

   #### 预期输出（成功状态）：
   ```
   # verl 版本输出
   verl                    0.0.6
   # PyTorch 与 CUDA 输出
   PyTorch 版本: 2.4.0+cu124
   CUDA 是否可用: True
   ```

3. 退出容器：
   ```bash
   exit
   ```

4. 停止/删除测试容器（若需）：
   ```bash
   # 停止容器
   docker stop verl-test
   # 删除容器（测试完成后可删除，释放资源）
   docker rm verl-test
   ```


### 6.2 方案 2：挂载目录部署（实际项目用，推荐）
适合实际训练/推理任务——通过挂载宿主机目录，实现 **配置持久化、数据共享、日志留存**（避免容器删除后数据丢失）。核心思路：将宿主机的“配置目录”“数据目录”“日志目录”“模型目录”挂载到容器内，方便本地修改配置、管理数据。


#### 第一步：创建宿主机挂载目录
在宿主机创建 4 个核心目录（路径可自定义，此处以 `/data/verl` 为例），用于存储配置、数据、日志、模型：
```bash
# 一次性创建 4 个目录（-p 确保父目录不存在时自动创建）
mkdir -p /data/verl/{config,data,logs,models}
```

#### 目录用途说明：
| 宿主机目录          | 容器内挂载路径                | 用途                                                                 |
|---------------------|-------------------------------|----------------------------------------------------------------------|
| `/data/verl/config`  | `/root/verl/config`           | 存放 `verl` 训练/推理配置文件（如 YAML 配置）。                     |
| `/data/verl/data`    | `/root/verl/data`             | 存放数据集（如 RLHF 训练数据、推理输入数据）。                       |
| `/data/verl/logs`    | `/root/verl/logs`             | 存放训练日志、推理日志（容器内日志会实时同步到宿主机，便于查看）。   |
| `/data/verl/models`  | `/root/verl/models`           | 存放预训练模型（如 LLaMA-7B、ChatGLM-6B），避免每次启动容器重新下载。 |


#### 第二步：准备测试配置与数据（可选）
为验证挂载功能，可在宿主机目录中添加测试文件（如训练配置 YAML、简单数据集）：
1. 创建测试训练配置文件 `/data/verl/config/test_train.yml`：
   ```yaml
   # 测试用 RL 训练基础配置（简化版）
   train:
     backend: "fsdp"  # 使用 FSDP 分布式后端（适合快速验证）
     model:
       name: "llama-7b"  # 模型名称（需确保 /data/verl/models 中有该模型）
       path: "/root/verl/models/llama-7b"  # 容器内模型路径（对应宿主机 /data/verl/models/llama-7b）
     data:
       path: "/root/verl/data/train_data.json"  # 容器内数据集路径（对应宿主机 /data/verl/data/train_data.json）
     log:
       path: "/root/verl/logs/train.log"  # 容器内日志路径（对应宿主机 /data/verl/logs/train.log）
   ```

2. 创建测试数据集 `/data/verl/data/train_data.json`（简单 JSON 格式）：
   ```json
   [
     {"input": "What is AI?", "target": "AI is the simulation of human intelligence processes by machines."},
     {"input": "What is verl?", "target": "verl is a tool for large model training and inference."}
   ]
   ```


#### 第三步：启动容器并挂载目录
执行以下命令，启动容器并挂载 4 个目录，同时配置时区（避免日志时区混乱）：
```bash
docker run -d \
  --name verl-prod \  # 容器名（prod 表示生产用）
  --gpus all \
  --shm-size="32g" \  # 共享内存设为 32GB（比测试版更大，适配实际训练）
  -e TZ=Asia/Shanghai \  # 设置时区为上海（避免日志时区与本地不一致）
  # 目录挂载：宿主机目录:容器内目录
  -v /data/verl/config:/root/verl/config \
  -v /data/verl/data:/root/verl/data \
  -v /data/verl/logs:/root/verl/logs \
  -v /data/verl/models:/root/verl/models \
  verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
```


#### 验证挂载功能：
1. 进入容器，查看挂载目录是否同步宿主机文件：
   ```bash
   docker exec -it verl-prod /bin/bash
   # 查看容器内配置文件（应与宿主机 /data/verl/config/test_train.yml 内容一致）
   cat /root/verl/config/test_train.yml
   # 查看容器内数据集（应与宿主机 /data/verl/data/train_data.json 内容一致）
   cat /root/verl/data/train_data.json
   ```

2. 在容器内创建日志文件，验证宿主机是否同步：
   ```bash
   # 容器内创建测试日志
   echo "Test log from container" > /root/verl/logs/test.log
   # 退出容器
   exit
   # 宿主机查看日志文件（应能看到容器内创建的内容）
   cat /data/verl/logs/test.log
   ```

   若宿主机能看到 `Test log from container`，则挂载功能正常。


#### 更新配置后重启容器：
若修改了宿主机 `/data/verl/config` 中的配置文件，需重启容器使配置生效：
```bash
docker restart verl-prod
```


### 6.3 方案 3：docker-compose 部署（企业级，适合团队协作）
适合多容器管理、长期运行的企业级场景——通过 `docker-compose.yml` 文件统一配置容器参数（如镜像、挂载、GPU、重启策略），支持一键启动/停止/查看状态，便于团队共享配置。


#### 第一步：创建 docker-compose.yml 文件
在宿主机创建目录（如 `/data/verl-compose`），并在该目录下创建 `docker-compose.yml` 文件：
```bash
# 创建目录并进入
mkdir -p /data/verl-compose && cd /data/verl-compose
# 创建 docker-compose.yml 文件（用 vim 编辑，新手也可直接复制内容）
vim docker-compose.yml
```

将以下内容粘贴到 `docker-compose.yml` 中（按 `i` 进入编辑模式，粘贴后按 `Esc`，输入 `:wq` 保存退出）：
```yaml
version: '3.8'  # 兼容 Docker Compose V2 的语法版本

services:
  verl-service:  # 服务名（可自定义）
    image: xxx.xuanyuan.run/verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2  # 使用的镜像
    container_name: verl-service  # 容器名
    restart: always  # 容器退出后自动重启（保障服务可用性，企业级必备）
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia  # 启用 NVIDIA GPU
              count: all  # 使用所有 GPU（也可指定数量，如 count: 2）
              capabilities: [gpu]  # 声明 GPU 能力
    shm_size: "32g"  # 共享内存大小
    environment:
      - TZ=Asia/Shanghai  # 时区配置
    volumes:  # 目录挂载（与方案 2 一致）
      - /data/verl/config:/root/verl/config
      - /data/verl/data:/root/verl/data
      - /data/verl/logs:/root/verl/logs
      - /data/verl/models:/root/verl/models
    # 可选：若需暴露端口（如推理服务端口），添加 ports 配置
    # ports:
    #   - "8000:8000"  # 宿主机 8000 端口映射到容器 8000 端口（用于推理服务）
```


#### 第二步：启动服务
在 `docker-compose.yml` 所在目录（`/data/verl-compose`）执行以下命令，一键启动 `verl` 服务：
```bash
# 后台启动服务（-d 表示 detached 模式）
docker compose up -d
```


#### 常用 docker-compose 命令（企业级运维必备）
| 命令                          | 作用                                                                 |
|-------------------------------|----------------------------------------------------------------------|
| `docker compose up -d`        | 后台启动服务（首次启动或重启）。                                     |
| `docker compose ps`           | 查看服务状态（如容器是否运行、端口映射）。                           |
| `docker compose logs`         | 查看服务日志（默认输出所有日志，按 `Ctrl+C` 退出）。                 |
| `docker compose logs -f`      | 实时查看日志（动态刷新，适合排查问题）。                             |
| `docker compose restart`      | 重启服务（修改配置后执行）。                                         |
| `docker compose stop`         | 停止服务（容器保留，可重新启动）。                                   |
| `docker compose down`         | 停止并删除服务（容器、网络会被删除，挂载数据不会丢失）。             |


#### 验证服务启动成功：
```bash
# 查看服务状态
docker compose ps
# 查看实时日志（确认无报错）
docker compose logs -f
```

若 `State` 列显示 `Up`，且日志无 `CUDA error`、`No GPU found` 等报错，则服务启动正常。


## 七、常见问题与解决方案
即使按照教程操作，也可能遇到一些细节问题。以下是 `verl` Docker 部署中高频问题的排查步骤，初学者可按流程逐一验证。


### 7.1 问题 1：容器启动失败，日志显示“CUDA error: no CUDA-capable device is detected”
**原因**：Docker 容器未识别到 GPU，可能是 `NVIDIA Container Toolkit` 未安装或未重启 Docker。  
**解决方案**：
1. 验证主机 GPU 是否正常：
   ```bash
   nvidia-smi  # 若输出 GPU 信息，说明主机 GPU 正常；否则需先解决主机 GPU 驱动问题
   ```
2. 重新安装并重启 `NVIDIA Container Toolkit`（参考步骤 3.2）：
   ```bash
   sudo apt-get reinstall nvidia-container-toolkit
   sudo systemctl restart docker
   ```
3. 重新启动容器，确保添加 `--gpus all` 参数。


### 7.2 问题 2：训练时内存溢出，日志显示“Bus error (core dumped)”
**原因**：容器共享内存不足（大模型训练需高频数据交换，默认共享内存仅 64MB）。  
**解决方案**：
- 启动容器时增大 `--shm-size` 参数，如改为 `--shm-size="64g"`（根据主机内存调整，建议不超过主机内存的 50%）。
- 示例命令（修改共享内存）：
  ```bash
  docker run -d \
    --name verl-prod \
    --gpus all \
    --shm-size="64g" \  # 增大共享内存到 64GB
    -v /data/verl/config:/root/verl/config \
    verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
  ```


### 7.3 问题 3：宿主机修改配置文件后，容器内不生效
**原因**：
1. 未重启容器（配置修改后需重启容器加载新配置）；
2. 挂载路径错误（宿主机目录与容器内目录映射不匹配）。  
**解决方案**：
1. 验证挂载路径是否正确（参考步骤 6.2 中的目录映射）：
   ```bash
   # 查看容器挂载信息
   docker inspect verl-prod | grep Mounts -A 50
   ```
   确认 `Source`（宿主机目录）与 `Destination`（容器内目录）对应正确。
2. 重启容器：
   ```bash
   docker restart verl-prod
   ```


### 7.4 问题 4：镜像拉取慢或超时
**原因**：未使用轩辕镜像访问支持，或网络不稳定。  
**解决方案**：
1. 优先使用轩辕镜像拉取（参考步骤 5.1）：
   ```bash
   docker pull xxx.xuanyuan.run/verlai/verl:app-verl0.6-transformers4.56.1-sglang0.5.2-mcore0.13.0-te2.2
   ```
2. 若已安装 Docker，可手动配置轩辕镜像访问支持（脚本已自动配置，若失效可重新执行步骤 3.1 的一键脚本）。


### 7.5 问题 5：如何查看 verl 训练日志？
**解决方案**：
- 若使用挂载目录部署（方案 2/3），直接查看宿主机 `/data/verl/logs` 目录下的日志文件：
  ```bash
  # 查看训练日志（按实际日志文件名修改）
  cat /data/verl/logs/train.log
  # 实时查看日志
  tail -f /data/verl/logs/train.log
  ```
- 若未挂载目录，通过 Docker 日志命令查看：
  ```bash
  docker logs -f verl-prod
  ```


## 八、结尾：不同用户的下一步建议
本教程覆盖了 `verlai/verl` Docker 部署的全流程，从工具认知到企业级落地。根据你的角色，可参考以下建议进一步实践：

- **初学者**：先从「方案 1 快速部署」熟悉 `verl` 基础命令，再尝试「方案 2 挂载目录」，修改 `/data/verl/config` 中的配置文件，体验“配置-重启-训练”的完整流程。
- **算法工程师**：基于「方案 3 docker-compose」部署，在 `/data/verl/models` 中放入预训练模型（如 LLaMA-7B），修改配置文件使用 `Megatron-LM` 后端，测试大规模分布式训练。
- **运维工程师**：在 `docker-compose.yml` 中添加监控配置（如集成 Prometheus、Grafana），监控容器 GPU 使用率、内存占用，确保训练任务稳定运行。

若需深入学习 `verl` 的训练/推理功能，可参考官方文档：[https://verl.readthedocs.io](https://verl.readthedocs.io)。遇到教程未覆盖的问题，可通过 `docker logs 容器名` 查看详细日志，或在 `verl` 官方社区提问。

