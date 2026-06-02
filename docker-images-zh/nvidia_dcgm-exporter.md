---
image: nvidia/dcgm-exporter
description: "用于Prometheus的NVIDIA GPU指标导出器"
source: https://xuanyuan.cloud/zh/r/nvidia/dcgm-exporter
canonical: https://xuanyuan.cloud/zh/r/nvidia/dcgm-exporter
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nvidia/dcgm-exporter" title="nvidia/dcgm-exporter Docker 镜像中文简介、标签列表与拉取命令">nvidia/dcgm-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/nvidia/dcgm-exporter" title="nvidia/dcgm-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nvidia/dcgm-exporter</a>

# NVIDIA DCGM Exporter Docker镜像文档


## 1. 镜像概述和主要用途

NVIDIA DCGM Exporter是一款基于NVIDIA Data Center GPU Manager (DCGM) 的Prometheus指标导出器，用于收集和暴露NVIDIA GPU的关键性能指标。该Docker镜像封装了DCGM Exporter的运行环境，可快速部署在包含NVIDIA GPU的服务器或容器化环境中，实现对GPU的实时监控与指标采集，供Prometheus抓取并集成到监控系统（如Grafana）中进行可视化分析。


## 2. 核心功能和特性

### 2.1 核心功能
- **GPU指标采集**：支持收集GPU温度、功耗、利用率（GPU/显存/编码器/解码器）、显存使用量、ECC错误等关键指标。
- **Prometheus兼容**：以Prometheus文本格式暴露指标，支持Prometheus自动发现和抓取。
- **DCGM集成**：基于NVIDIA DCGM实现底层GPU指标采集，确保指标准确性和全面性。

### 2.2 主要特性
- **多GPU支持**：同时监控单节点多块NVIDIA GPU。
- **灵活配置**：支持通过配置文件自定义采集指标类型和频率。
- **跨架构兼容**：适配NVIDIA Kepler及以上架构的GPU（如Tesla、Quadro、RTX系列）。
- **轻量级部署**：容器化设计，部署简单，资源占用低。


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **数据中心GPU监控**：监控服务器集群中GPU的运行状态和资源利用情况。
- **容器化GPU环境**：在Kubernetes、Docker Swarm等容器编排平台中，监控容器内GPU的性能指标。
- **GPU性能分析**：辅助排查GPU瓶颈、优化GPU密集型应用（如AI训练、科学计算）的资源配置。
- **故障预警**：通过温度、功耗等指标异常，提前发现GPU硬件潜在问题。

### 3.2 适用范围
- 运行NVIDIA GPU的物理服务器或虚拟机（需安装NVIDIA驱动和nvidia-container-toolkit）。
- 基于Docker或Kubernetes的容器化环境。
- 需要通过Prometheus+Grafana构建GPU监控系统的场景。


## 4. 使用方法和配置说明

### 4.1 前置条件
- 主机已安装NVIDIA驱动（版本≥418.81.07）。
- 已安装nvidia-container-toolkit（用于容器访问GPU设备）。
- 已安装Docker或Docker Compose。


### 4.2 快速启动（docker run）
```bash
docker run -d \
  --name dcgm-exporter \
  --gpus all \
  --restart always \
  -p 9400:9400 \
  -v /etc/localtime:/etc/localtime:ro \
  nvcr.io/nvidia/k8s/dcgm-exporter:latest
```

**参数说明**：
- `--gpus all`：授予容器访问所有GPU设备的权限（需nvidia-container-toolkit支持）。
- `-p 9400:9400`：映射容器内DCGM Exporter默认端口（9400）到主机，供Prometheus抓取指标。
- `-v /etc/localtime:/etc/localtime:ro`：同步容器与主机时间，确保指标时间戳准确。


### 4.3 Docker Compose部署
创建`docker-compose.yml`文件：
```yaml
version: '3.8'
services:
  dcgm-exporter:
    image: nvcr.io/nvidia/k8s/dcgm-exporter:latest
    container_name: dcgm-exporter
    restart: always
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    ports:
      - "9400:9400"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      # 可选：挂载自定义配置文件
      # - ./dcgm-exporter.yaml:/etc/dcgm-exporter/dcgm-exporter.yaml
    environment:
      - DCGM_EXPORTER_PORT=9400  # 可选，指定暴露端口（默认9400）
      # 可选：指定自定义收集器配置
      # - DCGM_EXPORTER_CONFIG=/etc/dcgm-exporter/dcgm-exporter.yaml
```

启动服务：
```bash
docker-compose up -d
```


### 4.4 配置参数说明

#### 4.4.1 环境变量
| 环境变量名               | 描述                                                                 | 默认值                  |
|--------------------------|----------------------------------------------------------------------|-------------------------|
| `DCGM_EXPORTER_PORT`     | 指标暴露端口                                                         | `9400`                  |
| `DCGM_EXPORTER_COLLECTORS`| 指定预定义收集器集合（如`default`、`extended`），多个集合用逗号分隔 | `default`               |
| `DCGM_EXPORTER_CONFIG`   | 自定义收集器配置文件路径（需通过卷挂载到容器内）                     | `/etc/dcgm-exporter/dcgm-exporter.yaml` |


#### 4.4.2 配置文件
通过挂载自定义配置文件（`dcgm-exporter.yaml`）可定义采集指标类型、频率等。示例配置：
```yaml
collectors:
  - name: gpu_utilization
    metric_name: dcgm_gpu_utilization
    type: gauge
    help: "GPU utilization percentage"
    dcgm_field: DCGM_FI_DEV_GPU_UTIL
  - name: memory_used
    metric_name: dcgm_memory_used
    type: gauge
    help: "Memory used in bytes"
    dcgm_field: DCGM_FI_DEV_MEM_USED
```
（完整字段列表参考[DCGM字段文档](https://docs.nvidia.com/datacenter/dcgm/latest/dcgm-api/dcgm-field-ids.html)）


### 4.5 指标验证
部署后，可通过以下命令验证指标是否正常暴露：
```bash
curl http://localhost:9400/metrics
```
返回结果应包含类似以下的Prometheus格式指标：
```
# HELP dcgm_gpu_utilization GPU utilization percentage
# TYPE dcgm_gpu_utilization gauge
dcgm_gpu_utilization{gpu="0",uuid="GPU-xxx"} 25
# HELP dcgm_memory_used Memory used in bytes
# TYPE dcgm_memory_used gauge
dcgm_memory_used{gpu="0",uuid="GPU-xxx"} 4294967296
```


## 5. 许可证协议

下载并使用本镜像即表示您同意遵守镜像中包含的NVIDIA软件的许可协议条款。具体许可条款可参考NVIDIA官方文档或镜像拉取时的附加说明。


## 6. 参考链接
- [DCGM Exporter GitHub仓库](https://github.com/NVIDIA/dcgm-exporter)
- [NVIDIA DCGM官方文档](https://docs.nvidia.com/datacenter/dcgm/latest/)
- [Prometheus监控配置指南](https://prometheus.io/docs/introduction/overview/)
