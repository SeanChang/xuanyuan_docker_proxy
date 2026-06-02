---
image: prom/pushgateway
description: "Prometheus Pushgateway是用于接收临时性或批处理作业指标数据并将其暴露给Prometheus服务器抓取的中间件，解决非持续运行作业的指标收集问题。"
source: https://xuanyuan.cloud/zh/r/prom/pushgateway
canonical: https://xuanyuan.cloud/zh/r/prom/pushgateway
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/prom/pushgateway" title="prom/pushgateway Docker 镜像中文简介、标签列表与拉取命令">prom/pushgateway — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/prom/pushgateway" title="prom/pushgateway Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/prom/pushgateway</a>

# Prometheus Pushgateway 镜像文档


## 1. 概述

Prometheus Pushgateway 是 Prometheus 生态系统中的核心组件，主要用于解决临时作业（Ephemeral Jobs）和批处理作业（Batch Jobs）无法被 Prometheus 有效抓取指标的问题。由于这类作业生命周期短暂，可能在 Prometheus 完成抓取周期前终止，导致指标丢失。Pushgateway 作为中间缓存层，接收作业主动推送的指标，并持续暴露 HTTP 端点供 Prometheus 抓取，从而实现对临时任务的指标监控。


## 2. 核心功能与特性

### 2.1 核心功能
- **指标缓存**：接收并存储来自临时/批处理作业的 Prometheus 格式指标。
- **抓取代理**：暴露标准 HTTP 端点（默认 `/metrics`），允许 Prometheus 定期抓取缓存的指标。
- **持久化支持**：可配置将指标持久化到本地文件，确保服务重启后指标不丢失。

### 2.2 关键特性
- **无指标聚合**：不对指标进行聚合或修改，保持与作业原生暴露指标的一致性。
- **无 TTL 机制**：不支持指标自动过期（超时），需作业主动管理指标生命周期。
- **轻量部署**：单二进制文件，支持 Docker 容器化部署，资源占用低。
- **可配置监听**：支持自定义网络监听地址和端口，适配不同网络环境。


## 3. 使用场景与适用范围

### 3.1 适用场景
- **临时任务监控**：如 CI/CD 流水线任务、定时数据处理脚本等生命周期短暂的作业。
- **批处理作业指标**：需上报运行状态（如成功/失败数、处理耗时）的周期性批处理任务。
- **服务级指标收集**：需关联到特定服务而非单台机器的业务指标（如任务队列长度、请求成功率）。

### 3.2 不适用场景
- **机器级指标**：主机硬件/系统指标（如 CPU、内存）应使用 Node Exporter 的 `textfile` 收集器。
- **分布式计数器**：不支持 statsd 式的分布式计数，此类场景建议使用 `statsd_exporter` 或 `prom-aggregation-gateway`。
- **事件存储**：无法作为事件日志系统（如发布事件、告警触发），需结合专门的事件框架（如 Grafana Annotations）。
- **指标自动清理**：不支持基于 TTL 的指标过期，强制依赖作业主动删除指标，避免残留无效数据。


## 4. 使用方法与配置说明

### 4.1 Docker 快速部署

#### 4.1.1 基础部署（无持久化）
直接运行容器，默认监听 `0.0.0.0:9091`，指标仅保存在内存中（服务重启后丢失）：
```bash
docker run -d \
  --name pushgateway \
  -p 9091:9091 \
  prom/pushgateway
```

#### 4.1.2 持久化部署
通过 `--persistence.file` 参数指定本地文件路径，实现指标持久化：
```bash
docker run -d \
  --name pushgateway \
  -p 9091:9091 \
  -v /host/path/to/persistence:/data \  # 挂载宿主机目录到容器内
  prom/pushgateway \
  --persistence.file=/data/pushgateway_metrics  # 持久化文件路径
```

#### 4.1.3 docker-compose 配置示例
```yaml
version: '3.8'
services:
  pushgateway:
    image: prom/pushgateway
    container_name: pushgateway
    ports:
      - "9091:9091"  # 宿主机端口:容器端口
    volumes:
      - ./persistence:/data  # 持久化目录（相对路径或绝对路径）
    command:
      - --web.listen-address=0.0.0.0:9091  # 监听地址（默认值）
      - --persistence.file=/data/pushgateway_metrics  # 持久化文件
      - --web.telemetry-path=/metrics  # 指标暴露路径（默认值）
    restart: unless-stopped  # 异常退出后自动重启
```


### 4.2 核心配置参数

| 参数名                  | 说明                                                                 | 默认值              |
|-------------------------|----------------------------------------------------------------------|---------------------|
| `--web.listen-address`  | 网络监听地址，格式为 `IP:端口`                                       | `0.0.0.0:9091`      |
| `--persistence.file`    | 指标持久化文件路径，若不指定则仅内存存储                              | 空（不持久化）      |
| `--web.telemetry-path`  | Prometheus 抓取指标的 HTTP 路径                                      | `/metrics`          |
| `--web.enable-lifecycle`| 启用 HTTP 生命周期接口（如 `/-/reload` 重新加载配置）                 | `false`             |
| `--log.level`           | 日志级别，可选 `debug`/`info`/`warn`/`error`                         | `info`              |


## 5. 注意事项

- **指标管理**：Pushgateway 不会自动删除指标，作业完成后需通过 API（如 `DELETE /metrics/job/<job_name>`）主动清理，避免无效指标残留。
- **持久化权限**：若启用持久化，需确保容器对挂载目录有读写权限（可通过 `--user` 参数指定容器用户）。
- **安全性**：默认无认证/加密，生产环境建议通过反向代理（如 Nginx）配置 TLS 和 Basic Auth。
- **Prometheus 配置**：需在 Prometheus 的 `prometheus.yml` 中添加 Pushgateway 作为抓取目标：
  ```yaml
  scrape_configs:
    - job_name: 'pushgateway'
      static_configs:
        - targets: ['pushgateway:9091']  # Pushgateway 地址（容器名或 IP）
