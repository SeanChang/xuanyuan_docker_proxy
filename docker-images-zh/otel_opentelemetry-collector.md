---
image: otel/opentelemetry-collector
description: "OpenTelemetry Collector核心版，开源可观测性数据收集器，用于收集、处理和导出遥测数据，提供统一的数据处理能力。"
source: https://xuanyuan.cloud/zh/r/otel/opentelemetry-collector
canonical: https://xuanyuan.cloud/zh/r/otel/opentelemetry-collector
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/otel/opentelemetry-collector" title="otel/opentelemetry-collector Docker 镜像中文简介、标签列表与拉取命令">otel/opentelemetry-collector 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenTelemetry Collector (Core) 镜像文档


## 一、镜像概述和主要用途

OpenTelemetry Collector (Core) 镜像是 OpenTelemetry 官方提供的核心发行版容器镜像，基于 [open-telemetry/opentelemetry-collector](https://github.com/open-telemetry/opentelemetry-collector) 仓库构建，包含 Collector 的核心组件。其主要用途是作为遥测数据（traces、metrics、logs）的统一处理管道，实现对分布式系统中遥测数据的收集、处理、聚合与导出，简化可观测性数据的管理流程。


## 二、核心功能和特性

### 2.1 核心组件支持
包含遥测数据处理的核心组件：
- **接收器（Receivers）**：支持从多种源接收遥测数据（如 OTLP、Jaeger、Prometheus 等协议）。
- **处理器（Processors）**：提供数据处理能力（如批处理、采样、属性过滤、数据转换等）。
- **导出器（Exporters）**：支持将处理后的遥测数据导出至后端系统（如 Jaeger、Prometheus、Grafana、AWS CloudWatch 等）。


### 2.2 多信号统一处理
支持三大遥测信号的统一处理：
- Traces（分布式追踪）
- Metrics（指标）
- Logs（日志）


### 2.3 轻量级与高性能
- 基于 Go 语言开发，资源占用低，处理性能高。
- 核心组件经过优化，适合大规模分布式环境部署。


### 2.4 灵活配置
通过 YAML 配置文件定义数据处理管道，支持自定义接收器、处理器、导出器的组合，满足不同场景的遥测需求。


## 三、使用场景和适用范围

### 3.1 微服务架构的遥测数据收集
在微服务集群中部署，统一收集各服务产生的遥测数据，避免多服务各自对接监控系统的复杂性。


### 3.2 混合云/多云环境的统一遥测
作为跨环境的遥测数据网关，整合来自私有云、公有云、边缘环境的遥测数据，实现统一监控视图。


### 3.3 本地/边缘环境的监控数据聚合
在边缘节点或本地数据中心部署，聚合分散的遥测数据后批量导出，减少对后端系统的请求压力。


### 3.4 第三方系统集成
通过接收器/导出器适配非 OpenTelemetry 协议的系统（如 Zipkin、Fluentd 等），实现现有监控工具的平滑迁移。


## 四、使用方法和配置说明

### 4.1 前置条件
- 已安装 Docker 或 Docker Compose。
- 已准备 Collector 配置文件（YAML 格式），定义数据处理管道。


### 4.2 Docker 部署示例

#### 4.2.1 基础 `docker run` 命令
通过挂载本地配置文件启动 Collector：

```bash
docker run -d \
  --name otel-collector \
  -p 4317:4317  # OTLP gRPC 端口（根据配置的接收器调整） \
  -v $(pwd)/otel-config.yaml:/etc/otelcol/config.yaml \  # 挂载本地配置文件
  otel/opentelemetry-collector:latest  # 镜像名称（推荐指定具体版本，如 v0.91.0）
```

> 说明：`-p 4317:4317` 为 OTLP gRPC 接收器默认端口，需根据配置文件中的接收器调整端口映射（如 HTTP 接收器端口 4318）。


#### 4.2.2 Docker Compose 配置示例
创建 `docker-compose.yml`：

```yaml
version: '3.8'
services:
  otel-collector:
    image: docker.xuanyuan.run/otel/opentelemetry-collector:latest
    container_name: otel-collector
    ports:
      - "4317:4317"  # OTLP gRPC
      - "4318:4318"  # OTLP HTTP
    volumes:
      - ./otel-config.yaml:/etc/otelcol/config.yaml  # 挂载配置文件
    environment:
      - OTEL_LOG_LEVEL=info  # 日志级别（可选，默认 info）
    restart: unless-stopped
```

启动服务：
```bash
docker-compose up -d
```


### 4.3 配置文件说明

#### 4.3.1 配置文件结构
Collector 通过 YAML 配置文件定义数据处理流程，核心结构如下：

```yaml
# 接收器配置
receivers:
  # 示例：启用 OTLP 接收器（gRPC + HTTP）
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317  # 容器内监听地址（需映射宿主机端口）
      http:
        endpoint: 0.0.0.0:4318

# 处理器配置
processors:
  # 示例：启用批处理（减少导出请求次数）
  batch:
    send_batch_size: 1024
    timeout: 5s

# 导出器配置
exporters:
  # 示例：导出至 Jaeger（Traces）
  jaeger:
    endpoint: "jaeger:14250"
    tls:
      insecure: true
  # 示例：导出至 Prometheus（Metrics）
  prometheus:
    endpoint: "0.0.0.0:8889"
    resource_to_telemetry_conversion:
      enabled: true

# 服务配置：定义数据处理管道
service:
  pipelines:
    traces:
      receivers: [otlp]       # 使用 OTLP 接收器
      processors: [batch]     # 使用批处理处理器
      exporters: [jaeger]     # 导出至 Jaeger
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
```


### 4.4 配置文件挂载说明
Collector 启动时需加载配置文件，默认读取容器内路径 `/etc/otelcol/config.yaml`。通过 Docker  volumes 将本地配置文件挂载至该路径即可生效：
```bash
-v /本地路径/otel-config.yaml:/etc/otelcol/config.yaml
```


## 五、配置参数

Collector 的行为主要通过 **配置文件** 定义，核心配置参数如下：

### 5.1 `receivers` 部分
定义数据接收方式，每个接收器需指定协议和监听地址。常见接收器配置示例：
- **OTLP 接收器**（OpenTelemetry 原生协议）：
  ```yaml
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: "0.0.0.0:4317"  # gRPC 端口
        http:
          endpoint: "0.0.0.0:4318"  # HTTP 端口
  ```
- **Prometheus 接收器**（拉取 metrics）：
  ```yaml
  receivers:
    prometheus:
      config:
        scrape_configs:
          - job_name: "otel-collector"
            static_configs:
              - targets: ["localhost:8888"]
  ```


### 5.2 `processors` 部分
定义数据处理逻辑，常见处理器：
- **`batch`**：批处理数据，减少导出请求次数。
  ```yaml
  processors:
    batch:
      send_batch_size: 1024    # 批处理大小
      timeout: 5s              # 超时时间（达到超时后即使未达 batch 大小也导出）
  ```
- **`memory_limiter`**：限制内存使用，避免 OOM。
  ```yaml
  processors:
    memory_limiter:
      check_interval: 5s
      limit_mib: 512          # 内存限制（MiB）
      spike_limit_mib: 128    # 突发内存限制（MiB）
  ```


### 5.3 `exporters` 部分
定义数据导出目标，常见导出器：
- **OTLP 导出器**（导出至其他 Collector 或后端）：
  ```yaml
  exporters:
    otlp/backend:
      endpoint: "backend-collector:4317"
      tls:
        insecure: true
  ```
- **Jaeger 导出器**（导出 traces）：
  ```yaml
  exporters:
    jaeger:
      endpoint: "jaeger:14250"  # Jaeger gRPC 接收端口
      tls:
        insecure: true
  ```


### 5.4 `service.pipelines` 部分
定义数据处理管道，关联接收器、处理器、导出器：
```yaml
service:
  pipelines:
    traces:          # traces 管道
      receivers: [otlp]       # 从 otlp 接收器接收
      processors: [memory_limiter, batch]  # 依次通过 memory_limiter 和 batch 处理器
      exporters: [jaeger]     # 导出至 jaeger 导出器
    metrics:         # metrics 管道
      receivers: [otlp, prometheus]
      processors: [batch]
      exporters: [prometheus]
```


## 六、环境变量

Collector 支持通过环境变量调整运行时行为，常见变量如下：

| 环境变量名          | 说明                                      | 默认值                          |
|---------------------|-------------------------------------------|---------------------------------|
| `OTEL_CONFIG_FILE`  | 配置文件路径（容器内路径）                | `/etc/otelcol/config.yaml`      |
| `OTEL_LOG_LEVEL`    | 日志级别（debug, info, warn, error）      | `info`                          |
| `OTEL_RESOURCE_ATTRIBUTES` | 全局资源属性（如服务名、环境等）         | 无（需手动指定，格式：`key=value,key2=value2`） |


## 七、注意事项

1. **配置文件语法校验**：启动前建议通过 `otelcol-contrib --config=otel-config.yaml --validate` 校验配置文件语法（需本地安装 Collector 二进制）。
2. **端口映射**：根据配置的接收器协议开放对应端口（如 OTLP gRPC 4317、HTTP 4318），确保数据源可访问 Collector。
3. **网络可达性**：导出器目标地址（如 Jaeger、Prometheus）需在容器网络中可访问（可通过 Docker 网络或 host 网络模式实现）。
4. **镜像版本**：生产环境建议使用具体版本标签（如 `v0.91.0`），避免 `latest` 标签带来的版本不确定性。


## 八、参考链接

- [OpenTelemetry Collector 官方文档](https://opentelemetry.io/docs/collector/)
- [GitHub 仓库](https://github.com/open-telemetry/opentelemetry-collector)
- [配置示例库](https://github.com/open-telemetry/opentelemetry-collector/tree/main/examples)
- [贡献指南](https://github.com/open-telemetry/opentelemetry-collector/blob/main/contributing.md)
