---
image: iotechsys/opc-ua-sim
description: "OPC-UA Simulator是一个用于模拟OPC-UA服务器的Docker镜像，可生成和提供工业数据，适用于开发、测试和演示OPC-UA客户端应用，无需真实工业设备即可进行协议交互和数据处理验证。"
source: https://xuanyuan.cloud/zh/r/iotechsys/opc-ua-sim
canonical: https://xuanyuan.cloud/zh/r/iotechsys/opc-ua-sim
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/iotechsys/opc-ua-sim" title="iotechsys/opc-ua-sim Docker 镜像中文简介、标签列表与拉取命令">iotechsys/opc-ua-sim 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OPC-UA Simulator Docker镜像文档

## 概述
OPC-UA Simulator是一个轻量级Docker镜像，提供完整的OPC-UA服务器模拟功能。该镜像旨在帮助开发、测试和演示OPC-UA客户端应用，无需依赖真实工业设备即可模拟工业数据交互场景。通过自定义数据点和数据生成规则，用户可快速构建符合需求的OPC-UA数据环境，验证客户端对协议解析、数据读取、订阅通知等功能的支持。

## 核心功能和特性
- **完整OPC-UA服务器实现**：遵循OPC UA规范（如OPC UA 1.04），支持标准地址空间、服务集（如Read、Write、Subscribe）及信息模型。
- **灵活的数据点配置**：支持自定义数据节点层级结构，可配置数据点名称、数据类型（Int32、Float、String等）、单位及描述。
- **多模式数据生成**：提供静态值、随机变化、线性递增/递减等数据生成模式，满足不同场景的数据模拟需求。
- **安全策略支持**：兼容标准OPC-UA安全策略（如None、Basic128Rsa15、Basic256等），可配置身份验证（匿名、用户名密码）。
- **低资源占用**：基于轻量级基础镜像构建，启动快速，运行时内存占用低，适合开发环境和资源受限场景。

## 使用场景和适用范围
- **开发测试**：OPC-UA客户端应用开发时，无需真实工业设备即可验证数据读取、写入、订阅等核心功能。
- **培训演示**：在培训或技术演示中，模拟工业数据流程，展示OPC-UA协议交互原理及客户端应用操作。
- **系统集成验证**：在工业控制系统集成阶段，验证数据采集、协议转换、系统联动等流程的正确性。
- **离线功能验证**：在无网络或无真实设备环境下，验证客户端对异常数据、数据更新频率变化的处理能力。

## 使用方法和配置说明

### 基本使用（Docker Run）
通过以下命令快速启动默认配置的OPC-UA Simulator容器：

```docker
docker run -d -p 4840:4840 --name opc-ua-simulator docker.xuanyuan.run/opc-ua-simulator:latest
```

- `-p 4840:4840`：映射容器内OPC-UA默认端口（4840）到主机，客户端可通过`opc.tcp://<主机IP>:4840`连接服务器。
- `--name opc-ua-simulator`：指定容器名称，便于管理。

### Docker Compose配置示例
创建`docker-compose.yml`文件，配置更灵活的服务参数：

```yaml
version: '3'
services:
  opc-ua-simulator:
    image: docker.xuanyuan.run/opc-ua-simulator:latest
    container_name: opc-ua-simulator
    ports:
      - "4840:4840"  # OPC-UA默认端口
    environment:
      - SERVER_NAME=MyOPCUASimulator  # 服务器名称
      - NAMESPACE_URI=http://example.com/opcua/simulator  # 自定义命名空间URI
      - DATA_UPDATE_INTERVAL=1000  # 数据更新间隔（毫秒），默认1000ms
      - SECURITY_POLICY=None  # 安全策略，可选：None, Basic128Rsa15, Basic256
      - DATA_POINTS=[{"name":"Temperature","type":"Float","mode":"random","min":20.0,"max":30.0},{"name":"Pressure","type":"Int32","mode":"static","value":100}]  # 数据点配置
    restart: unless-stopped
```

启动命令：`docker-compose up -d`

### 环境变量配置说明
| 环境变量名              | 描述                                                                 | 默认值                                  |
|-------------------------|----------------------------------------------------------------------|-----------------------------------------|
| `SERVER_NAME`           | OPC-UA服务器名称，客户端可见                                         | `OPC-UA-Simulator`                      |
| `NAMESPACE_URI`         | 自定义命名空间URI，用于区分数据点所属逻辑空间                         | `http://opcua-simulator/docker`         |
| `DATA_UPDATE_INTERVAL`  | 数据点值更新间隔（毫秒）                                             | `1000` (1秒)                            |
| `SECURITY_POLICY`       | 安全策略，可选值：`None`（无加密）、`Basic128Rsa15`、`Basic256`      | `None`                                  |
| `DATA_POINTS`           | JSON格式的数据点配置数组，定义模拟数据的名称、类型、生成模式等         | 内置默认数据点（如Temperature, Pressure）|

### 数据点配置详解
`DATA_POINTS`环境变量接受JSON数组，每个元素定义一个数据点，支持以下字段：

| 字段名       | 类型       | 描述                                                                 | 必选 |
|--------------|------------|----------------------------------------------------------------------|------|
| `name`       | String     | 数据点名称（如"Temperature"）                                        | 是   |
| `type`       | String     | 数据类型，支持：`Int32`、`Float`、`Boolean`、`String`                | 是   |
| `mode`       | String     | 数据生成模式：`static`（静态值）、`random`（随机值）、`linear`（线性变化） | 是   |
| `value`      | 对应类型   | `mode=static`时的静态值（如`25.5`、`true`）                          | 仅`static`模式 |
| `min`        | Number     | `mode=random`或`linear`时的最小值（如`20.0`）                         | 仅`random`/`linear`模式 |
| `max`        | Number     | `mode=random`或`linear`时的最大值（如`30.0`）                         | 仅`random`/`linear`模式 |
| `max`        | Number     | `mode=random`或`linear`时的最大值（如`30.0`）                         | 仅`random`/`linear`模式 |
| `step`       | Number     | `mode=linear`时的步长（如`0.5`，每次更新增加/减少该值，达到`max`后重置） | 仅`linear`模式 |

**示例**：
```json
[
  {"name":"Temperature","type":"Float","mode":"random","min":20.0,"max":30.0},
  {"name":"Pressure","type":"Int32","mode":"static","value":100},
  {"name":"FlowRate","type":"Float","mode":"linear","min":0.0,"max":10.0,"step":0.5}
]
```

### 验证与连接
启动容器后，可使用OPC-UA客户端工具（如UA Expert、OPC UA Client）连接`opc.tcp://<主机IP>:4840`，验证数据点是否按配置生成和更新。
