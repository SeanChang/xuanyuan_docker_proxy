---
image: emqx/neuronex
description: "NeuronEX是一款工业边缘数据中心，专注于实时工业数据接入与智能分析，支持丰富协议集成以满足多场景数据采集与统一接入需求，帮助用户快速获取业务洞察并提升运营效率与可持续性。"
source: https://xuanyuan.cloud/zh/r/emqx/neuronex
canonical: https://xuanyuan.cloud/zh/r/emqx/neuronex
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/emqx/neuronex" title="emqx/neuronex Docker 镜像中文简介、标签列表与拉取命令">emqx/neuronex 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NeuronEX Docker镜像文档


## 镜像概述与主要用途

NeuronEX是一款工业边缘数据中心（Industrial Edge Data Hub），专注于实时工业数据接入与智能分析。其核心功能是实现工业设备数据的实时采集、处理与分析，帮助用户快速获取业务洞察，提升生产运营效率与可持续性。


## 核心功能与特性

### 丰富的协议集成能力
支持多种工业协议，适配各类工业场景，可实现PLC、数控机床、机器人、SCADA系统、智能传感器等设备数据的实时采集与统一接入。

### 低延迟数据处理
专为工业领域设计，提供低延迟的数据接入与处理能力，支持多系统间快速数据传输，满足实时监控与决策需求。

### 轻量级与灵活部署
采用轻量化设计，内存占用低，支持多CPU架构（如amd64、arm64）部署，兼容Docker与Kubernetes等容器化平台，部署方式灵活多样。

### 强大的流处理与分析
具备完善的流处理与分析能力，支持数据过滤、清洗、标准化、分析检测及实时告警等功能。

### AI/ML智能分析集成
支持用户自定义函数扩展及AI算法集成，提供智能化数据解析能力，赋能边缘端智能分析场景。


## 使用场景与适用范围

### 工业设备数据采集与集成
适用于各类工业现场设备（如PLC、CNC机床、工业机器人、智能传感器）的数据实时采集，实现跨设备、跨系统数据统一接入。

### 实时监控与运营决策
通过低延迟数据处理与实时分析，支持生产过程实时监控、异常检测及快速决策，提升生产稳定性。

### 边缘计算与智能分析
部署于边缘节点，结合流处理与AI/ML能力，实现数据本地化分析与智能决策，减少云端数据传输压力。

### 多架构环境部署
支持amd64、arm64等多种CPU架构，可部署于工业服务器、边缘网关、嵌入式设备等不同硬件环境。


## 使用方法与配置说明

### 快速启动NeuronEX容器

通过以下命令启动最新版本的NeuronEX容器：

```shell
docker run -d --name neuronex -p 8085:8085 emqx/neuronex:latest
```

**参数说明**：
- `-d`：后台运行容器；
- `--name neuronex`：指定容器名称为`neuronex`；
- `-p 8085:8085`：将容器内8085端口映射至主机8085端口（Web管理界面默认端口）；
- `emqx/neuronex:latest`：使用最新版本的NeuronEX镜像。


### 访问Web管理界面

容器启动后，通过浏览器访问以下地址打开NeuronEX管理控制台（Dashboard）：  
`http://localhost:8085/`  

通过管理控制台可配置设备连接、查看运行状态、管理数据处理任务等。


### 默认登录凭据

首次登录时，使用默认用户名和密码：  
- 用户名：`admin`  
- 密码：`0000`  


## Docker部署方案示例

### 基础部署（docker run）
上述“快速启动NeuronEX容器”中的命令即为基础部署示例，适用于快速测试与简单场景。


### 持久化部署（可选）
若需持久化存储配置数据，可通过挂载主机目录实现（具体数据目录需参考NeuronEX官方文档）：

```shell
docker run -d --name neuronex -p 8085:8085 -v /path/to/host/data:/opt/neuronex/data emqx/neuronex:latest
```


### Docker Compose配置（可选）
创建`docker-compose.yml`文件，内容如下：

```yaml
version: '3'
services:
  neuronex:
    image: emqx/neuronex:latest
    container_name: neuronex
    ports:
      - "8085:8085"  # Web管理界面端口
    restart: unless-stopped  # 容器退出时自动重启（除非手动停止）
    # volumes:
    #   - ./data:/opt/neuronex/data  # 如需持久化数据，取消注释并配置本地目录
```

通过`docker-compose up -d`命令启动服务。


## 注意事项

- **端口映射**：默认Web管理端口为8085，若主机8085端口被占用，可修改映射（如`-p 8086:8085`将主机8086端口映射至容器8085端口）。  
- **安全配置**：生产环境中需修改默认登录密码（admin/0000），并根据需求配置网络访问控制。  
- **架构支持**：镜像支持amd64与arm64架构，拉取时Docker会自动匹配主机架构。
