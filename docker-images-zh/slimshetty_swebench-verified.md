<!-- xuanyuan-docker-images-zh
image: slimshetty/swebench-verified
source: https://xuanyuan.cloud/zh/r/slimshetty/swebench-verified
canonical: https://xuanyuan.cloud/zh/r/slimshetty/swebench-verified
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/slimshetty/swebench-verified" title="slimshetty/swebench-verified Docker 镜像中文简介、标签列表与拉取命令">slimshetty/swebench-verified — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/slimshetty/swebench-verified" title="slimshetty/swebench-verified Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/slimshetty/swebench-verified</a></p>

# slimshetty/swebench-verified 镜像使用指南

## 一、镜像概述与核心定位

`slimshetty/swebench-verified` 镜像由 Slim Shetty（AI 编程助手 R2E-Gym 项目核心参与者）发布，专为 SWE-Bench Verified 基准提供预配置的容器环境。该镜像封装了基准数据集、测试工具与适配的运行时环境，旨在避免手动搭建依赖，确保 AI 编程助手性能验证实验的可复现性。

### 核心特性

- **基准环境**：完整集成 SWE-Bench Verified 权威编程任务基准的运行环境，支持数据集加载与测试执行
- **一键部署**：预装必要的 Python 环境、测试框架与依赖库，开箱即用
- **项目适配**：针对 R2E-Gym 等项目优化，支持快速复现「34.4% Pass@1」「64.4% Pass@Any」等性能指标
- **实验复现**：确保基于 SWE-Bench Verified 的开发、测试与评估任务具备一致性与可复现性

## 二、适用场景

### 2.1 AI 编程助手性能验证

- **模型测试**：在 SWE-Bench Verified 基准上快速测试自研 AI 编程模型
- **性能对比**：与 R2E-Gym 项目发布的性能指标进行对比评估
- **结果复现**：使用 R2E-Gym 开源资源（如 32B 规模的 R2EGym-32B 模型）复现实验

### 2.2 基准工具开发

- **验证器开发**：开发适配 SWE-Bench Verified 的代码生成结果验证工具（如混合验证器）
- **测试用例生成**：构建面向该基准的自动化测试用例生成工具
- **辅助工具调试**：调试与基准集成的各类辅助工具链

### 2.3 开源资源部署

- **数据集部署**：快速部署包含 8100 个可执行环境的合成数据集
- **模型部署**：一键启动 R2E-Gym 项目的开源模型与训练轨迹
- **实验流程**：复现从数据集加载到模型评估的完整实验流程

## 三、前置准备

### 3.1 硬件与软件要求

| 项目 | 要求 |
| --- | --- |
| **操作系统** | Linux（Ubuntu 20.04+ 推荐）、Windows 10/11（需 WSL2）、macOS |
| **容器工具** | Docker 19.03+ 或 Podman 3.0+ |
| **存储空间** | 建议预留 ≥10GB（用于数据集与模型文件） |
| **GPU** | 可选（如使用 R2EGym-32B 等大型模型，建议 ≥16GB 显存） |

### 3.2 网络环境

- 首次使用需联网下载基准数据集或相关资源
- 如需访问 Hugging Face 等平台，建议配置科学上网或镜像加速

## 四、镜像启动与使用

### 4.1 镜像拉取

```bash
docker pull docker.xuanyuan.run/r/slimshetty/swebench-verified:latest
```

### 4.2 容器启动

#### 4.2.1 基础启动模式

```bash
docker run -d \
  --name swebench-verified \
  -p 8888:8888 \
  -v /宿主机/数据路径:/app/data \
  -v /宿主机/结果路径:/app/results \
  docker.xuanyuan.run/r/slimshetty/swebench-verified:latest
```

参数说明：
- `-p 8888:8888`：映射容器端口（如提供 Web 界面或 API 服务）
- `-v`：挂载数据与结果目录到宿主机，避免数据丢失

#### 4.2.2 GPU 加速模式

如需运行大型模型，启用 GPU 支持：

```bash
docker run -d \
  --name swebench-verified-gpu \
  --gpus all \
  -p 8888:8888 \
  -v /宿主机/数据路径:/app/data \
  -v /宿主机/结果路径:/app/results \
  docker.xuanyuan.run/r/slimshetty/swebench-verified:latest
```

### 4.3 容器访问与交互

```bash
# 查看容器运行状态
docker ps | grep swebench-verified

# 查看日志
docker logs -f swebench-verified

# 进入容器进行交互操作
docker exec -it swebench-verified /bin/bash
```

## 五、核心功能使用

### 5.1 基准数据集加载

容器启动后，进入容器加载 SWE-Bench Verified 数据集：

```bash
docker exec -it swebench-verified /bin/bash

# 数据集加载示例（实际命令需参考项目文档）
python load_dataset.py --dataset swebench-verified --output /app/data
```

### 5.2 运行基准测试

使用内置的基准评估工具运行测试：

```bash
# 运行完整基准评估
python run_benchmark.py --model your_model --dataset /app/data/swebench-verified

# 运行单个任务测试
python run_task.py --task task_name --output /app/results
```

### 5.3 性能评估与报告生成

```bash
# 生成性能报告
python evaluate.py --results /app/results --output /app/results/report.json

# 对比性能指标
python compare_models.py --baseline r2egym --results /app/results
```

## 六、进阶使用

### 6.1 集成自定义模型

若需测试自研模型，将模型文件挂载到容器：

```bash
docker run -d \
  --name swebench-custom \
  --gpus all \
  -v /宿主机/模型路径:/app/models \
  -v /宿主机/数据路径:/app/data \
  docker.xuanyuan.run/r/slimshetty/swebench-verified:latest
```

容器内运行测试：

```bash
python run_benchmark.py --model /app/models/your_model --dataset /app/data/swebench-verified
```

### 6.2 批量实验管理

可编写脚本批量运行不同配置的实验：

```python
# batch_experiment.py
import subprocess
import json

# 实验配置列表
configs = [
    {"model": "r2egym-32b", "temperature": 0.0},
    {"model": "r2egym-32b", "temperature": 0.5},
]

# 批量运行
for config in configs:
    cmd = [
        "python", "run_benchmark.py",
        "--model", config["model"],
        "--temperature", str(config["temperature"]),
        "--output", f"/app/results/{config['model']}_t{config['temperature']}"
    ]
    subprocess.run(cmd)
    
print("批量实验完成！")
```

### 6.3 API 服务部署（如支持）

部分场景可能提供 API 服务，启动后访问：

```bash
# API 服务地址（如适用）
http://localhost:8888/api/docs
```

## 七、常见问题与解决方案（FAQ）

| 问题现象 | 可能原因 | 解决方案 |
| --- | --- | --- |
| 数据集下载失败 | 网络连接问题或资源链接变更 | 检查网络；手动下载数据集后挂载到容器 |
| GPU 不可用 | 未安装 nvidia-docker2 或驱动不兼容 | 安装 nvidia-docker2；验证 GPU 驱动 |
| 显存不足 | 模型规模过大或 batch-size 设置过高 | 降低 batch-size；使用 CPU 模式或较小模型 |
| 评估结果不一致 | 随机种子或配置差异 | 设置固定随机种子；核对配置参数 |
| 容器启动失败 | 端口冲突或挂载路径不存在 | 修改端口映射；创建挂载目录 |

## 八、性能指标参考

基于 SWE-Bench Verified 基准的性能指标（参考 R2E-Gym 项目）：

- **Pass@1**：首个生成结果通过测试用例的比例（R2E-Gym 达 34.4%）
- **Pass@Any**：任一生成结果通过测试用例的比例（R2E-Gym 达 64.4%）

> 实际性能取决于模型规模、超参数设置与硬件配置，建议根据自身需求调整配置。

## 九、参考资源

- **SWE-Bench 官方**：<https://www.swebench.com/>
- **R2E-Gym 项目**：<https://github.com/slimshetty/r2e-gym>（如有公开仓库）
- **AI 编程助手相关论文与报告**：搜索 "SWE-Bench Verified" "AI Coding Assistant" 等关键词

---

**注意**：具体的使用命令与配置需参考项目的官方文档与 README 文件。建议先查看镜像的入口脚本或文档，了解实际提供的功能与接口。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/slimshetty/swebench-verified" title="slimshetty/swebench-verified Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/slimshetty/swebench-verified</a></p>
