# verl Docker 容器化部署手册

![verl Docker 容器化部署手册](https://img.xuanyuan.dev/docker/blog/docker-verl.png)

*分类: Docker,verl | 标签: verl,docker,部署教程 | 发布时间: 2025-10-08 14:26:55*

> 无论你是刚接触大模型工具的初学者，还是需要高效管理训练任务的高级工程师，本教程都将带你一步步完成 verlai/verl 镜像的 Docker 部署——从工具认知、环境搭建到多场景部署实践，每个步骤均配备完整命令与详细说明，确保照着做就能成。

## 前言
verl 是一款聚焦大模型“训练+推理”全流程的工具集，核心定位是降低大模型强化学习（RL）训练与高效推理的门槛，尤其适配企业级大模型落地场景。其本质是通过封装主流深度学习框架（如 PyTorch、Megatron-LM）和推理引擎（如 vLLM），让开发者无需手动解决复杂的环境依赖、分布式配置问题，专注于模型优化与业务逻辑。

## verl 的核心功能
verl 的能力覆盖“训练”和“推理”两大核心场景，且支持灵活扩展：
- **大模型训练**：主打强化学习与分布式能力
  支持多训练后端：适配 FSDP（PyTorch 原生分布式框架，适合快速验证原型）、Megatron-LM（NVIDIA 高性能分布式框架，支持万卡级大模型训练，适合大规模落地）。
- **强化学习（RL）优化**：内置 RL 训练流程封装，可直接用于大模型 RLHF（基于人类反馈的强化学习）、RLHF 变种任务，无需从零搭建训练 pipeline。
- **依赖自动兼容**：自动适配 PyTorch、CUDA、FlashAttention 等核心依赖版本，避免“版本冲突导致训练崩溃”。
- **大模型推理**：高效生成 rollout 结果
  支持多推理引擎：集成 vLLM（业界领先的高吞吐推理框架，支持动态批处理）、TGI（Hugging Face Text Generation Inference，适合标准 Hugging Face 模型），未来将支持 SGLang。
- **聚焦“rollout 生成”**：专为强化学习场景设计——快速生成模型输出样本（如 RLHF 中的“模型回答候选”），推理访问表现比原生 Hugging Face pipeline提升 5-10 倍。
- **高扩展性与定制化**
  - 支持自定义训练配置：可通过 YAML 配置文件修改训练参数（如学习率、 batch size、分布式策略）。
  - 源码级可定制：若使用挂载目录部署，可直接修改 verl 源码（如适配新的 RL 算法、自定义数据集），无需重新构建镜像。

## verl 的适用场景
| 用户类型 | 适用场景 |
| ---- | ---- |
| 算法工程师 | 快速验证大模型 RL 算法、搭建 RLHF 训练流程、测试不同推理引擎的 rollout 效率 |
| 企业运维/DevOps | 为团队快速部署统一的大模型训练/推理环境，避免“一人一环境”的运维混乱 |
| 初学者 | 零门槛体验大模型分布式训练与高效推理，无需手动配置 CUDA、PyTorch 等复杂环境 |
| 大型团队 | 基于 Megatron-LM后端搭建大规模分布式训练集群，支撑百亿/千亿参数模型训练 |

本文部署流程基于以下官方文档与代码仓库整理而成，确保信息准确性与权威性：
- vLLM 官方文档（含推理引擎特性、PyTorch/CUDA 版本约束、V1 引擎说明）
- SGLang 官方文档及 Issue Tracker（功能特性、适配注意事项）
- NVIDIA 官方仓库：Megatron-LM、Apex、TransformerEngine（安装约束、硬件适配）
- verl 官方 Dockerfile、CI Workflow 及源码仓库（部署标准、依赖配置）

## 一、环境要求
### 1.1 基础依赖版本（版本锁定，避免兼容问题）
> **依赖提示**：所有版本需严格匹配，裸机安装需通过requirements.txt或校验脚本锁定版本，避免pip自动升级破坏环境。
- Python：≥ 3.10；Docker/官方镜像环境推荐 3.12，裸机安装场景下 3.10–3.11 稳定性更高。
- CUDA：版本 ≥ 12.8，部分镜像依赖 12.9（如稳定版 vLLM 镜像），需根据安装方式匹配。
  > **注**：CUDA Toolkit 版本需与 PyTorch/vLLM 编译版本严格匹配；不同容器可并存，但单一运行环境内不可混用 12.8 与 12.9 的 Toolkit。
- cuDNN：版本 ≥ 9.10.0，推荐 9.16.0.29（已在官方镜像中验证，可规避部分 PyTorch 2.9.x 的兼容问题）。

不同应用场景下的后端选择建议见 1.2 节。

### 1.2 后端引擎选择建议（按应用场景）
| 应用场景 | 推荐方案 | 核心优势 |
| ---- | ---- | ---- |
| 单机/1-4卡训练、原型开发 | FSDP + vLLM | 配置简单，适配多数模型与算法调研需求 |
| 多机多卡大规模训练、高扩展性需求 | Megatron-LM | 分布式训练优化，支持超大模型部署 |
| 高性能推理、Agent Loop 场景 | vLLM（开启 V1 引擎） | 推理速度快，并发能力强，稳定性经验证 |
| 多模态推理、复杂任务编排 | SGLang | 高级特性丰富，持续迭代优化，支持复杂指令 |
| 单卡调试、简单功能验证 | Hugging Face TGI | 轻量易部署，适合快速排查问题 |

#### 训练后端（可选）
- **FSDP**：适合模型、数据集及强化学习算法的调研、原型开发，使用指南见 FSDP Workers（关联项目仓库）。
- **Megatron-LM**：追求更高扩展性时推荐，文档中提及的 v0.13.1 为官方说明版本，verl 在 Docker 与 CI 中实际使用的是 v0.15.0（core 分支），已在官方镜像与测试流程中验证可用。需配合 NVIDIA Apex 使用以优化训练性能，使用指南见 Megatron-LM Workers（关联项目仓库）。
  > **特别提醒**：Megatron-LM 在 0.14.x 至 0.15.0 版本中，optimizer、mcore、pipeline 接口有过调整，部分社区代码对 0.13.x 版本存在硬编码，若使用第三方 Megatron 脚本或历史代码，建议优先确认其对 v0.15.0 的兼容性。

#### 推理后端
- **vLLM**：0.8.3 及以上版本稳定性已验证，稳定版镜像内置 v0.12.0。推荐设置环境变量`VLLM_USE_V1=1`，该变量用于启用 vLLM V1 推理引擎，适合高并发、低延迟场景，对长序列推理优化明显，但不支持部分旧版自定义采样策略（如自定义 logits processor、旧版 agent loop 中的采样 hook）；若需兼容旧功能，可保持默认关闭。
  此外，vLLM 对 PyTorch 版本有严格约束（需匹配 CUDA 版本，如 CUDA 12.9 对应 PyTorch 2.9.0+），且要求 NVIDIA 驱动版本 ≥ 535.86.05。
  > **生产环境提示**：启用 V1 引擎前，需在测试环境验证采样逻辑、Agent Loop 兼容性及性能表现；若生产环境出现行为异常，立即执行回滚操作：删除 `VLLM_USE_V1=1` 环境变量，重启服务并切换至 V0 引擎，同时保留日志用于问题排查。注意：若使用自定义采样逻辑、老版本 Agent Loop 或非标准 logits 处理流程，建议先在测试环境验证 V1 引擎行为一致性，再用于生产。
- **SGLang**：功能迭代中，提供高级特性与优化，安装及使用详情见 SGLang Backend（关联项目仓库），问题反馈可通过 SGLang Issue Tracker 提交。
- **Hugging Face TGI**：主要用于调试及单 GPU 探索场景。

## 二、Docker 镜像安装（推荐）
### 2.0 前置：安装 Docker 环境
部署前需先安装 Docker 及相关组件（含 Docker Engine、Docker Compose），使用以下一键脚本快速部署，适配主流 Linux 发行版：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```
脚本执行完成后，通过以下命令验证安装是否成功：
```bash
docker --version
docker compose version
```
若输出 Docker 版本信息（如 `Docker version 26.1.4, build 5650f9b`）及 Docker Compose 版本信息，则说明安装成功，可继续后续镜像部署步骤。

### 2.1 基础镜像与应用镜像
#### 基础镜像（官方源）
- vLLM：官方源 `https://hub.docker.com/r/vllm/vllm-openai`，轩辕镜像：`https://xuanyuan.cloud/r/vllm/vllm-openai`
- SGLang：官方源 `https://hub.docker.com/r/lmsysorg/sglang`（稳定版镜像使用 v0.5.6.post2），轩辕镜像：`https://xuanyuan.cloud/r/lmsysorg/sglang`

#### 预构建应用镜像（Docker Hub）
所有预构建应用镜像均托管于 Docker Hub：`verlai/verl`，轩辕镜像：`https://xuanyuan.cloud/r/verlai/verl`，示例标签：
- `verlai/verl:sgl055.latest`（SGLang 基础镜像版本）
- `verlai/verl:vllm011.latest`（vLLM 基础镜像版本）

开发及 CI 最新镜像可参考 GitHub 工作流配置：
- vLLM 相关：`.github/workflows/vllm.yml`
- SGLang 相关：`.github/workflows/sgl.yml`

#### 自定义 Dockerfile 核心说明
官方提供的稳定版 Dockerfile 用于自定义构建，以下为核心功能总结（避免逐行堆叠，聚焦关键操作）：
- `Dockerfile.stable.vllm`：基于 `nvidia/cuda:12.9.1-devel-ubuntu22.04`，核心操作包括：固定 PyTorch 2.9.0 + vLLM 0.12.0 版本；编译安装 Apex、TransformerEngine（高耗时步骤，建议复用镜像）；内置 DeepEP、Megatron-LM v0.15.0；预装 NSight 工具，修复 cudnn 与 PyTorch 兼容问题。
- `Dockerfile.stable.sglang`：基于 `lmsysorg/sglang:v0.5.6.post2`，核心操作包括：复用 SGLang 官方镜像已安装的 DeepEP；安装 Apex、TransformerEngine 及各类辅助依赖；强制重装 `nvidia-cudnn-cu12==9.16.0.29`，规避与 PyTorch 2.9.1 的冲突。

> **注**：Dockerfile 中部分配置（如 NSight 安装、内部镜像源）为 CI/生产环境定制，普通用户无需照抄，可基于核心依赖按需修改。

### 2.2 Docker 安装步骤
#### 步骤 1：拉取镜像并创建容器
> **核心提示**：测试与生产环境配置差异较大，生产环境需严格遵循最小权限、安全加固原则，避免使用高危参数。

##### 测试环境（快速部署/调试，允许高危参数）
```bash
# 适合单机调试、多机Ray/NCCL测试，优先保证易用性
docker create --runtime=nvidia \
  --gpus all \
  --net=host \ # 仅在多机训练或Ray/NCCL高性能通信场景推荐使用，规避端口映射复杂度
  --shm-size="10g" \
  --cap-add=SYS_ADMIN \ # 仅调试或性能分析时启用，用于Profiler及低层工具
  --name verl-test \
  -v .:/workspace/verl \ # 测试环境临时映射，生产环境禁用此方式
  verlai/verl:vllm011.latest \
  sleep infinity

# 启动容器
docker start verl-test
docker exec -it verl-test bash
```

##### 生产环境（安全加固/高可用，严格限制权限）
```bash
# 核心优化：非host网络、非root用户、最小权限、资源限制、健康检查、重启策略
docker create --runtime=nvidia \
  --gpus '"device=0,1"' \ # 限制使用指定GPU，避免资源抢占（根据实际设备调整）
  --network bridge \ # 替换host网络，使用桥接网络隔离端口
  --shm-size="16g" \ # 按需调整，避免共享内存溢出
  --memory="64g" \ # 限制容器总内存，防止占满宿主机内存
  --restart=always \ # 容器异常退出自动恢复，保证高可用
  --health-cmd="python -c 'import verl; import vllm'" \ # 健康检查：验证核心库可用性
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  --name verl-prod \
  -u 1000:1000 \ # 非root用户（UID:GID，需提前在容器内创建）
  -v verl-data:/workspace/verl \ # 专用数据卷，替代宿主机目录映射
  -v verl-cache:/root/.cache/huggingface \ # 模型缓存独立卷
  -p 8265:8265 \ # 按需暴露必要端口，避免全量暴露
  --cap-drop=ALL \ # 禁用所有特权，实现最小权限
  verlai/verl:vllm011.latest \
  sleep infinity

# 启动生产容器
docker start verl-prod
docker exec -it -u 1000:1000 verl-prod bash
```
> **说明**：1. 非root用户需提前在Dockerfile中创建（`USER 1000:1000`）；2. 数据卷需提前创建：`docker volume create verl-data verl-cache`

#### 步骤 2：安装 verl
使用预构建镜像时，无需额外安装依赖，直接安装 verl 即可：
```bash
# 克隆仓库（推荐 nightly 版本）
git clone https://github.com/volcengine/verl && cd verl

# 无依赖安装（推荐，避免覆盖镜像自带依赖）
pip3 install --no-deps -e .
```

##### 可选：切换后端框架
若需在同一容器中切换 vLLM/SGLang 后端，可按以下命令安装：
```bash
git clone https://github.com/volcengine/verl && cd verl
# 安装 vLLM 后端支持
pip3 install -e .[vllm]
# 安装 SGLang 后端支持
pip3 install -e .[sglang]
```

## 三、自定义环境安装（非 Docker 方式）
### 3.1 安装前置依赖
#### 安装 CUDA 12.8
```bash
# 下载 CUDA 12.8 安装包（Ubuntu 22.04）
wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2204-12-8-local_12.8.1-570.124.06-1_amd64.deb

# 安装并配置
dpkg -i cuda-repo-ubuntu2204-12-8-local_12.8.1-570.124.06-1_amd64.deb
cp /var/cuda-repo-ubuntu2204-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
apt-get update
apt-get -y install cuda-toolkit-12-8
update-alternatives --set cuda /usr/local/cuda-12-8
```

#### 安装 cuDNN 9.10+
```bash
# 下载 cuDNN 安装包（Ubuntu 22.04）
wget https://developer.download.nvidia.com/compute/cudnn/9.10.2/local_installers/cudnn-local-repo-ubuntu2204-9.10.2_1.0-1_amd64.deb

# 安装并配置
dpkg -i cudnn-local-repo-ubuntu2204-9.10.2_1.0-1_amd64.deb
cp /var/cudnn-local-repo-ubuntu2204-9.10.2/cudnn-*-keyring.gpg /usr/share/keyrings/
apt-get update
apt-get -y install cudnn-cuda-12
```

### 3.2 配置 Conda 环境并安装依赖（版本锁定增强）
> **裸机安装风险提示**：强烈建议通过版本锁定脚本或requirements.txt控制依赖版本，避免pip覆盖破坏CUDA/PyTorch兼容性。
```bash
# 1. 创建并激活 Conda 环境（锁定Python版本）
conda create -n verl python==3.11.8 -y # 裸机优先3.11，稳定性更高
conda activate verl

# 2. 安装核心依赖（使用版本锁定脚本，避免版本漂移）
# 方式1：支持Megatron-LM（含vLLM/SGLang），自动校验版本
bash scripts/install_vllm_sglang_mcore.sh --lock-version

# 方式2：仅支持FSDP（不含Megatron-LM）
USE_MEGATRON=0 bash scripts/install_vllm_sglang_mcore.sh --lock-version

# 3. 版本校验（确保依赖兼容）
python scripts/verify_deps.py # 建议新增校验脚本，检查CUDA/PyTorch/cuDNN版本匹配性
```

#### 3.2.1 推荐 requirements.txt（裸机专用，版本锁定）
```txt
# 基础依赖（匹配CUDA 12.8）
torch==2.9.0+cu128 --index-url https://download.pytorch.org/whl/cu128
torchvision==0.24.0+cu128 --index-url https://download.pytorch.org/whl/cu128
torchaudio==2.9.0+cu128 --index-url https://download.pytorch.org/whl/cu128

# 推理后端（锁定版本）
vllm==0.12.0
sglang==0.5.6.post2
transformers==4.41.2
accelerate==0.30.1

# 训练依赖
apex @ git+https://github.com/NVIDIA/apex.git@2386a91#egg=apex
transformer-engine==1.5.0
flash-attn==2.5.8 --no-build-isolation

# 辅助依赖（锁定兼容版本）
pyarrow==15.0.2
tensordict==0.5.8
nvidia-cudnn-cu12==9.16.0.29
ray==2.30.0
pyyaml==6.0.1
```
安装命令：
```bash
pip install --no-deps -r requirements.txt
```
> **说明**：`--no-deps` 参数避免自动升级依赖破坏环境。

若脚本执行报错，可手动跟随脚本内步骤安装，核心依赖包括：flash_attn、TransformerEngine、DeepEP、PyTorch 2.9.0+ 等。其中 `USE_MEGATRON=0` 为关键环境变量，设置后会禁用 Megatron-LM 及相关依赖（如 Apex）的安装，减少环境复杂度，仅保留 FSDP 训练所需组件，适合无需大规模分布式训练的场景。

### 3.3 可选：安装 NVIDIA Apex（Megatron-LM 必需，编译优化）
> **编译提示**：高并发编译易导致OOM或CPU卡死，优先推荐使用预构建镜像；裸机安装需根据硬件调整MAX_JOB参数（CPU核心数的1/2~2/3）。
```bash
# 克隆仓库（锁定指定版本，避免源码更新导致编译失败）
git clone https://github.com/NVIDIA/apex.git && cd apex
git checkout 2386a91 # 验证兼容的稳定版本

# 安装：根据CPU核心数调整MAX_JOB（如8核CPU设为4，16核设为8）
MAX_JOB=8 pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext" ./

# 备选方案：使用预编译wheel包（避免编译风险）
# pip install apex-wheel==0.1+cu128 -f https://nvidia.github.io/apex/wheels/cu128/torch-2.9/index.html
```

### 3.4 安装 verl
```bash
git clone https://github.com/volcengine/verl.git
cd verl
pip install --no-deps -e .
```

### 3.5 后置检查
需确认以下依赖包安装成功且版本符合要求：
- PyTorch 系列（torch、torchvision、torchaudio）
- 推理后端（vLLM、SGLang）
- 辅助包（pyarrow ≥15.0.0、tensordict <0.6、nvidia-cudnn-cu12）

## 四、AMD GPU（ROCm 平台）部署
### 4.1 构建 ROCm 镜像
```bash
# 1. 进入项目目录，使用官方 ROCm Dockerfile
cd verl
docker build -f docker/Dockerfile.rocm -t verl-rocm .
```
> **说明**：镜像基于 `rocm/vllm:rocm6.2_mi300_ubuntu20.04_py3.9_vllm_0.6.4`，内置 vLLM 0.6.3、PyTorch ROCm 适配版

### 4.2 启动 ROCm 容器（分测试/生产）
> **安全警示**：`--privileged`与`--cap-add SYS_PTRACE`仅用于测试/调试，生产环境禁用，需使用最小权限配置。

#### 测试环境（调试/功能验证）
```bash
docker run --rm -it \
  --device /dev/dri \
  --device /dev/kfd \
  -p 8265:8265 \
  --group-add video \
  --cap-add SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --privileged \ # 仅测试可用，生产移除
  -v $HOME/.ssh:/root/.ssh \
  -v $HOME:$HOME \
  --shm-size 128G \
  -w $PWD \
  verl-rocm \
  /bin/bash
```

#### 生产环境（安全加固）
```bash
docker run -d \
  --restart=always \
  --device /dev/dri \
  --device /dev/kfd \
  -p 8265:8265 \
  --group-add video \
  -u 1000:1000 \ # 非root用户
  -v rocm-data:/workspace/verl \ # 专用数据卷
  -v rocm-cache:/root/.cache/huggingface \
  --shm-size 64G \
  --memory="128g" \ # 资源限制
  --health-cmd="python -c 'import verl; import vllm'" \
  --health-interval=30s \
  -w $PWD \
  verl-rocm \
  sleep infinity

# 非root用户启动补充环境变量
# -e HOST_UID=$(id -u) -e HOST_GID=$(id -g)
```
非 root 用户启动需添加环境变量：`-e HOST_UID=$(id -u) -e HOST_GID=$(id -g)`。

> **说明**：当前 AMD GPU 支持 FSDP 训练后端及 vLLM/SGLang 推理后端，后续将支持 Megatron-LM。注：ROCm 版本 vLLM 功能与 NVIDIA CUDA 版存在代际差异，部分新特性（如 V1 引擎）不可用。

## 五、补充说明
### 5.1 Dockerfile 核心内容
- `Dockerfile.stable.vllm` 与 `Dockerfile.stable.sglang` 核心功能已在 2.1 节「自定义 Dockerfile 核心说明」中详细阐述，此处仅作总结：两者分别基于 vLLM、SGLang 官方镜像构建，预装核心依赖并修复版本兼容问题，适配 NVIDIA GPU 生产环境，可根据后端需求选择对应 Dockerfile 二次定制。

### 5.2 CI 工作流说明
GitHub 工作流用于自动化测试，关键配置：
- `vllm.yml`：触发 `main/v0.*` 分支的 push/pull 请求，测试 vLLM 后端异步推理、服务中断等功能，使用专用 CI 镜像。
- `sgl.yml`：测试 SGLang 后端异步推理与智能体循环功能，禁用 NCCL 共享内存与点对点通信以提升稳定性。

### 5.3 测试与生产部署差异总结
| 配置项 | 测试环境 | 生产环境 |
| ---- | ---- | ---- |
| 网络模式 | `--net=host`（易用性优先） | 桥接网络/自定义网络（端口隔离） |
| 权限控制 | `--cap-add=SYS_ADMIN`、root用户 | `--cap-drop=ALL`、非root用户 |
| 存储映射 | 宿主机目录直接映射（快速调试） | 专用数据卷，限制读写权限 |
| 高可用 | 无重启策略（按需启动） | `--restart=always`（异常自愈） |
| 资源限制 | 无限制（快速验证） | `--gpus`、`--memory`、`--shm-size` 限制 |
| 健康检查 | 可选（手动验证） | 必选（自动监控服务状态） |
| 高危参数 | `--privileged`、`SYS_PTRACE`（调试用） | 禁用所有高危参数 |

### 5.4 安全加固与资源管理建议
#### 安全加固要点
- 避免使用root用户运行容器，提前在Dockerfile中创建普通用户（`USER 1000:1000`）。
- 禁止映射宿主机敏感目录（`/root`、`/etc`、`/var`），仅映射必要数据目录。
- 敏感环境变量（如API密钥）通过Docker Secrets或环境变量文件挂载，避免明文写入命令。
- 生产环境使用TLS加密API通信，避免明文传输数据。

#### 资源管理要点
- GPU限制：使用`--gpus '"device=0,1"'`指定可用GPU，避免单容器占用所有GPU。
- 内存限制：根据模型大小设置`--memory`（如64g），`--shm-size`建议为GPU总内存的1/4~1/2。
- CPU限制：通过`--cpus=8`、`--cpu-shares=1024`控制CPU占用，避免编译或推理抢占资源。

### 5.5 不同用户部署建议
- 新手/生产环境：直接使用 `verlai/verl:*latest` 预构建镜像（如 `verlai/verl:vllm011.latest`），无需手动配置依赖，开箱即用，稳定性最高。
- 需定制依赖：基于 `Dockerfile.stable.vllm/sglang` 二次构建，仅修改核心依赖版本（如调整 vLLM 版本），复用官方编译好的 Apex、TransformerEngine，节省时间。
- AMD MI300 设备：仅支持 ROCm 镜像，严格按照 `docker/Dockerfile.rocm` 构建，当前仅支持 FSDP 训练及 vLLM/SGLang 推理，暂不支持 Megatron-LM。
- 裸机安装：⚠️ verl 官方 CI 与文档均以 Docker 镜像作为主要交付与验证方式，该安装方式对 CUDA、PyTorch、cuDNN、NCCL 版本匹配要求极高，任何一个依赖被 pip 覆盖都可能导致整体环境不可用，仅推荐给具备丰富环境配置经验的高阶用户，且不建议在生产环境首次部署时采用，需严格遵循前置依赖版本要求，避免依赖冲突。

## 六、部署验证与监控
### 6.1 基础验证（最小可跑测试）
#### 6.1.1 基础库导入验证
```bash
# 激活对应环境（Docker容器内可直接执行）
# Conda环境需先执行：conda activate verl
python -c "import verl; print('verl 导入成功，版本：', verl.__version__)"
```

#### 6.1.2 推理引擎验证（以vLLM为例，含V1/V0对比）
```bash
# 提示：国内环境首次拉取模型可能较慢，可配置HF镜像源加速
# export HF_ENDPOINT=https://mirrors.tuna.tsinghua.edu.cn/hugging-face-models

# 1. V1引擎验证
VLLM_USE_V1=1 python -c "
from vllm import LLM, SamplingParams
sampling_params = SamplingParams(temperature=0.7, top_p=0.95)
llm = LLM(model='Qwen/Qwen2.5-0.5B-Instruct', tensor_parallel_size=1)
outputs = llm.generate(['Hello, verl!'], sampling_params=sampling_params)
for output in outputs:
    print('V1引擎推理结果：', output.outputs[0].text)
"

# 2. V0引擎验证（用于对比与回滚参考）
python -c "
from vllm import LLM, SamplingParams
sampling_params = SamplingParams(temperature=0.7, top_p=0.95)
llm = LLM(model='Qwen/Qwen2.5-0.5B-Instruct', tensor_parallel_size=1)
outputs = llm.generate(['Hello, verl!'], sampling_params=sampling_params)
for output in outputs:
    print('V0引擎推理结果：', output.outputs[0].text)
"
```

#### 6.1.3 数据集预处理验证
```bash
# 执行gsm8k数据集预处理，验证数据依赖是否正常
ray stop --force
python3 examples/data_preprocess/gsm8k.py --local_dataset_path ${HOME}/models/hf_data/gsm8k
# 执行完成后检查目标目录是否生成预处理文件，无报错即为正常
```

### 6.2 健康检查配置
#### 6.2.1 Docker健康检查（容器内集成）
```bash
# 方式1：启动容器时指定健康检查（已在生产容器命令中集成）
# 方式2：编写专用健康检查脚本（healthcheck.py）
cat > healthcheck.py << EOF
import subprocess
import sys
import verl
from vllm import LLM

def check_vllm():
    try:
        llm = LLM(model='Qwen/Qwen2.5-0.5B-Instruct', tensor_parallel_size=1, max_num_batched_tokens=128)
        return True
    except Exception as e:
        print(f"vLLM 检查失败：{e}")
        return False

if __name__ == "__main__":
    if check_vllm():
        sys.exit(0)
    else:
        sys.exit(1)
EOF

# 容器内执行健康检查
python healthcheck.py
```

### 6.3 性能基准测试（可选）
```bash
# vLLM V1/V0引擎性能对比测试（批量推理）
VLLM_USE_V1=1 python -m vllm.entrypoints.api_server --model Qwen/Qwen2.5-0.5B-Instruct --tensor-parallel-size 1
# 使用curl测试吞吐量
curl -X POST http://localhost:8000/v1/completions -H "Content-Type: application/json" -d '{"model":"Qwen/Qwen2.5-0.5B-Instruct","prompt":"Hello, verl!","max_tokens":50,"n":10}'
# 记录响应时间与吞吐量，对比V1/V0引擎差异
```

> **提示**：若验证过程中出现依赖报错，优先检查对应库版本是否符合要求；推理引擎启动失败可排查CUDA驱动与后端版本兼容性。

### 最小化验证步骤（快速排查基础问题）
1. **基础库导入验证**
    ```bash
    # 激活对应环境（Docker 容器内可直接执行）
    # Conda 环境需先执行：conda activate verl
    python -c "import verl; print('verl 导入成功，版本：', verl.__version__)"
    ```
2. **推理引擎验证（以 vLLM 为例）**
    ```bash
    # 启动简单 vLLM 推理测试（需提前准备基础模型，如 Qwen/Qwen2.5-0.5B-Instruct）
    # 提示：国内环境首次拉取模型可能较慢，可配置 HF 镜像源加速
    python -c "
    from vllm import LLM, SamplingParams
    sampling_params = SamplingParams(temperature=0.7, top_p=0.95)
    llm = LLM(model='Qwen/Qwen2.5-0.5B-Instruct', tensor_parallel_size=1)
    outputs = llm.generate(['Hello, verl!'], sampling_params=sampling_params)
    for output in outputs:
        print('推理结果：', output.outputs[0].text)
    "
    ```
3. **数据集预处理验证**
    ```bash
    # 执行 gsm8k 数据集预处理，验证数据依赖是否正常
    ray stop --force
    python3 examples/data_preprocess/gsm8k.py --local_dataset_path ${HOME}/models/hf_data/gsm8k
    # 执行完成后检查目标目录是否生成预处理文件，无报错即为正常
    ```

> **提示**：若验证过程中出现依赖报错，优先检查对应库版本是否符合要求；推理引擎启动失败可排查CUDA驱动与后端版本兼容性。

