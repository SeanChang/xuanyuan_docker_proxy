---
image: intel/intel-optimized-pytorch
description: "用于在英特尔架构上运行PyTorch工作负载的容器"
source: https://xuanyuan.cloud/zh/r/intel/intel-optimized-pytorch
canonical: https://xuanyuan.cloud/zh/r/intel/intel-optimized-pytorch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/intel-optimized-pytorch" title="intel/intel-optimized-pytorch Docker 镜像中文简介、标签列表与拉取命令">intel/intel-optimized-pytorch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Intel® Extension for PyTorch* Docker镜像文档

## 镜像概述和主要用途

[Intel® Extension for PyTorch*] 扩展了 [PyTorch*]，提供针对Intel硬件的最新特性优化，以获得额外的性能提升。本镜像基于 [Ubuntu* 22.04](https://hub.docker.com/_/ubuntu) 构建，包含不同用例的Intel® Extension for PyTorch*以及其他附加软件，旨在为Intel架构提供优化的PyTorch运行环境。

> **注意：** 有两个Docker Hub仓库（`intel/intel-extension-for-pytorch` 和 `intel/intel-optimized-pytorch`）会定期更新最新镜像，但部分旧版镜像可能未发布到两个仓库。

## 核心功能和特性

### CPU优化
利用以下指令集优化Intel CPU性能：
- Intel® Advanced Matrix Extensions (Intel® AMX)
- Intel® Advanced Vector Extensions 512 (Intel® AVX-512)
- Vector Neural Network Instructions (VNNI)

### GPU优化
通过PyTorch* `xpu`设备提供简单的GPU加速，支持以下Intel GPU：
- [Intel® Arc™ A-Series Graphics]
- [Intel® Data Center GPU Flex Series]
- [Intel® Data Center GPU Max Series]

## 使用场景和适用范围

本镜像适用于需要在Intel CPU和GPU上运行PyTorch工作负载的场景，包括但不限于：
- 深度学习模型训练与推理
- 大规模分布式训练
- Jupyter Notebook交互式开发
- 生产环境模型部署（通过TorchServe*）
- MLPerf优化工作负载

## 详细的使用方法和配置说明

### 镜像类型

#### XPU镜像
同时包含CPU和GPU优化支持的镜像：

| 标签                          | PyTorch  | IPEX           | 驱动   | Dockerfile      |
|------------------------------|----------|----------------|--------|-----------------|
| `2.8.10-xpu-pip-base`,`2.8.10-xpu` | [v2.8.0] | [v2.8.10+xpu] | [1099] | [v0.4.0-Beta]  |
| `2.7.10-xpu-pip-base`,`2.7.10-xpu` | [v2.7.0] | [v2.7.10+xpu] | [1077] | [v0.4.0-Beta]  |
| `2.6.10-xpu-pip-base`,`2.6.10-xpu` | [v2.6.0] | [v2.6.10+xpu] | [1077] | [v0.4.0-Beta]  |
| `2.5.10-xpu-pip-base`,`2.5.10-xpu` | [v2.5.1] | [v2.5.10+xpu] | [1057] | [v0.4.0-Beta]  |
| `2.3.110-xpu-pip-base`,`2.3.110-xpu` | [v2.3.1][torch-v2.3.1] | [v2.3.110+xpu] | [950]  | [v0.4.0-Beta]  |
| `2.1.40-xpu-pip-base`,`2.1.40-xpu`   | [v2.1.0] | [v2.1.40+xpu]  | [914]  | [v0.4.0-Beta]   |
| `2.1.30-xpu`           | [v2.1.0] | [v2.1.30+xpu]  | [803]  | [v0.4.0-Beta]   |
| `2.1.20-xpu`           | [v2.1.0] | [v2.1.20+xpu]  | [803]  | [v0.3.4]        |
| `2.1.10-xpu`           | [v2.1.0] | [v2.1.10+xpu]  | [736]  | [v0.2.3]        |
| `xpu-flex-2.0.110-xpu` | [v2.0.1] | [v2.0.110+xpu] | [647]  | [v0.1.0]        |

**运行XPU容器：**
```bash
docker run -it --rm \
    --device /dev/dri \
    -v /dev/dri/by-path:/dev/dri/by-path \
    --ipc=host \
    docker.xuanyuan.run/intel/intel-extension-for-pytorch:2.8.10-xpu
```

#### 包含Jupyter Notebook的XPU镜像

| 标签                          | PyTorch  | IPEX           | 驱动   | Jupyter端口 | Dockerfile      |
|------------------------------|----------|----------------|--------|------------|-----------------|
| `2.8.10-xpu-pip-jupyter` | [v2.8.0]| [v2.8.10+xpu] | [1099]  |  `8888` | [v0.4.0-Beta]  |
| `2.7.10-xpu-pip-jupyter` | [v2.7.0]| [v2.7.10+xpu] | [1077]  |  `8888` | [v0.4.0-Beta]  |
| `2.6.10-xpu-pip-jupyter` | [v2.6.0]| [v2.6.10+xpu] | [1077]  |  `8888` | [v0.4.0-Beta]  |
| `2.5.10-xpu-pip-jupyter` | [v2.5.1]| [v2.5.10+xpu] | [1057]  |  `8888` | [v0.4.0-Beta]  |
| `2.3.110-xpu-pip-jupyter` | [v2.3.1][torch-v2.3.1] | [v2.3.110+xpu] | [950]  | `8888`     | [v0.4.0-Beta]   |
| `2.1.40-xpu-pip-jupyter` | [v2.1.0] | [v2.1.40+xpu] | [914]  | `8888`     | [v0.4.0-Beta]   |
| `2.1.20-xpu-pip-jupyter` | [v2.1.0] | [v2.1.20+xpu] | [803]  | `8888`    | [v0.3.4]        |
| `2.1.10-xpu-pip-jupyter` | [v2.1.0] | [v2.1.10+xpu] | [736]  | `8888`    | [v0.2.3]        |

**运行XPU Jupyter容器：**
```bash
docker run -it --rm \
    -p 8888:8888 \
    --device /dev/dri \
    -v /dev/dri/by-path:/dev/dri/by-path \
    docker.xuanyuan.run/intel/intel-extension-for-pytorch:2.8.10-xpu-pip-jupyter
```

运行命令后，复制类似 `http://127.0.0.1:$PORT/?token=` 的URL到浏览器以访问notebook服务器。

#### CPU-only镜像
仅包含CPU优化（刻意排除GPU加速支持）的镜像：

| 标签                          | PyTorch  | IPEX         | Dockerfile      |
|------------------------------|----------|--------------|-----------------|
| `2.8.0-pip-base`, `latest` | [v2.8.0] | [v2.8.0+cpu] | [v0.4.0-Beta]   |
| `2.7.0-pip-base`           | [v2.7.0] | [v2.7.0+cpu] | [v0.4.0-Beta]   |
| `2.6.0-pip-base`           | [v2.6.0] | [v2.6.0+cpu] | [v0.4.0-Beta]   |
| `2.5.0-pip-base`           | [v2.5.0] | [v2.5.0+cpu] | [v0.4.0-Beta]   |
| `2.4.0-pip-base`           | [v2.4.0] | [v2.4.0+cpu] | [v0.4.0-Beta]   |
| `2.3.0-pip-base`           | [v2.3.0] | [v2.3.0+cpu] | [v0.4.0-Beta]   |
| `2.2.0-pip-base`           | [v2.2.0] | [v2.2.0+cpu] | [v0.3.4]        |
| `2.1.0-pip-base`           | [v2.1.0] | [v2.1.0+cpu] | [v0.2.3]        |
| `2.0.0-pip-base`           | [v2.0.0] | [v2.0.0+cpu] | [v0.1.0]        |

**运行CPU容器：**
```bash
docker run -it --rm docker.xuanyuan.run/intel/intel-extension-for-pytorch:latest
```

#### 包含Jupyter Notebook的CPU-only镜像

| 标签                  | PyTorch  | IPEX         | Dockerfile      |
|-----------------------|----------|--------------|-----------------|
| `2.8.0-pip-jupyter` | [v2.8.0] | [v2.8.0+cpu] | [v0.4.0-Beta]   |
| `2.7.0-pip-jupyter` | [v2.7.0] | [v2.7.0+cpu] | [v0.4.0-Beta]   |
| `2.6.0-pip-jupyter` | [v2.6.0] | [v2.6.0+cpu] | [v0.4.0-Beta]   |
| `2.5.0-pip-jupyter` | [v2.5.0] | [v2.5.0+cpu] | [v0.4.0-Beta]   |
| `2.4.0-pip-jupyter` | [v2.4.0] | [v2.4.0+cpu] | [v0.4.0-Beta]   |
| `2.3.0-pip-jupyter` | [v2.3.0] | [v2.3.0+cpu] | [v0.4.0-Beta]   |
| `2.2.0-pip-jupyter` | [v2.2.0] | [v2.2.0+cpu] | [v0.3.4]        |
| `2.1.0-pip-jupyter` | [v2.1.0] | [v2.1.0+cpu] | [v0.2.3]        |
| `2.0.0-pip-jupyter` | [v2.0.0] | [v2.0.0+cpu] | [v0.1.0]        |

**运行Jupyter容器：**
```bash
docker run -it --rm \
    -p 8888:8888 \
    -v $PWD/workspace:/workspace \
    -w /workspace \
    docker.xuanyuan.run/intel/intel-extension-for-pytorch:2.8.0-pip-jupyter
```

#### 包含Intel® oneAPI Collective Communications Library和Neural Compressor的镜像

| 标签                          | PyTorch  | IPEX           | oneCCL               | INC       | Dockerfile     |
|-------------------------------|----------|----------------|----------------------|-----------|----------------|
| `2.4.0-pip-multinode`         | [v2.4.0] | [v2.4.0+cpu]   | [v2.4.0][ccl-v2.4.0] | [v3.0]    | [v0.4.0-Beta]  |
| `2.3.0-pip-multinode`         | [v2.3.0] | [v2.3.0+cpu]   | [v2.3.0][ccl-v2.3.0] | [v2.6]    | [v0.4.0-Beta]  |
| `2.2.0-pip-multinode`         | [v2.2.2] | [v2.2.0+cpu]   | [v2.2.0][ccl-v2.2.0] | [v2.6]    | [v0.4.0-Beta]  |
| `2.1.100-pip-mulitnode`       | [v2.1.2] | [v2.1.100+cpu] | [v2.1.0][ccl-v2.1.0] | [v2.6]    | [v0.4.0-Beta]  |
| `2.0.100-pip-multinode`       | [v2.0.1] | [v2.0.100+cpu] | [v2.0.0][ccl-v2.0.0] | [v2.6]    | [v0.4.0-Beta]  |

> **注意：** 镜像中已启用无密码SSH连接，但容器不包含任何SSH ID密钥。用户需要将这些密钥挂载到 `/root/.ssh/id_rsa` 和 `/etc/ssh/authorized_keys`。

> **提示：** 挂载任何密钥之前，请使用 `chmod 600 authorized_keys; chmod 600 id_rsa` 修改文件权限，以授予默认用户账户读取权限。

##### 配置和运行IPEX多节点容器

> **重要提示：** Intel® Extension for PyTorch* 多节点容器对Xeon处理器的维护、错误修复和发布已停止开发。最后支持的版本是 `2.4.0`。对于未来版本，请使用Intel® Extension for PyTorch* XPU多节点容器。

1. **生成SSH密钥**
   ```bash
   ssh-keygen -q -N "" -t rsa -b 4096 -f ./id_rsa
   touch authorized_keys
   cat id_rsa.pub >> authorized_keys
   ```

2. **配置文件权限**
   ```bash
   chmod 600 id_rsa config authorized_keys
   chown root:root id_rsa.pub id_rsa config authorized_keys
   ```

3. **创建hostfile（可选）**
   ```txt
   Host host1
       HostName <host1的主机名>
       IdentitiesOnly yes
       IdentityFile ~/.root/id_rsa
       Port <SSH端口>
   Host host2
       HostName <host2的主机名>
       IdentitiesOnly yes
       IdentityFile ~/.root/id_rsa
       Port <SSH端口>
   ...
   ```

4. **在Python脚本中配置Intel® oneAPI Collective Communications Library**
   ```python
   import oneccl_bindings_for_pytorch
   import os

   dist.init_process_group(
       backend="ccl",
       init_method="tcp://127.0.0.1:3022",
       world_size=int(os.environ.get("WORLD_SIZE")),
       rank=int(os.environ.get("RANK")),
   )
   ```

5. **启动worker并在launcher上执行DDP**

   **Worker运行命令：**
   ```bash
   docker run -it --rm \
       --net=host \
       -v $PWD/authorized_keys:/etc/ssh/authorized_keys \
       -v $PWD/tests:/workspace/tests \
       -w /workspace \
       docker.xuanyuan.run/intel/intel-extension-for-pytorch:2.4.0-pip-multinode \
       bash -c '/usr/sbin/sshd -D'
   ```

   **Launcher运行命令：**
   ```bash
   docker run -it --rm \
       --net=host \
       -v $PWD/id_rsa:/root/.ssh/id_rsa \
       -v $PWD/tests:/workspace/tests \
       -v $PWD/hostfile:/workspace/hostfile \
       -w /workspace \
       docker.xuanyuan.run/intel/intel-extension-for-pytorch:2.4.0-pip-multinode \
       bash -c 'ipexrun cpu  --nnodes 2 --nprocs-per-node 1 --master-addr 127.0.0.1 --master-port 3022 /workspace/tests/ipex-resnet50.py --ipex --device cpu --backend ccl'
   ```

####
