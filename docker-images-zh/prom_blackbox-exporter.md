---
image: prom/blackbox-exporter
description: "Blackbox Exporter是Prometheus生态的黑盒探测工具，支持通过HTTP、HTTPS、DNS、TCP、ICMP和gRPC协议对目标端点进行探测，提供探测成功率等指标，用于监控端点可用性和性能。"
source: https://xuanyuan.cloud/zh/r/prom/blackbox-exporter
canonical: https://xuanyuan.cloud/zh/r/prom/blackbox-exporter
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/prom/blackbox-exporter" title="prom/blackbox-exporter Docker 镜像中文简介、标签列表与拉取命令">prom/blackbox-exporter — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/prom/blackbox-exporter" title="prom/blackbox-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/prom/blackbox-exporter</a>

# Blackbox Exporter

Blackbox Exporter是Prometheus项目提供的黑盒探测工具，允许通过HTTP、HTTPS、DNS、TCP、ICMP和gRPC协议对目标端点进行探测，广泛用于监控各类网络服务的可用性和性能。

## 核心功能和特性

- **多协议支持**：支持HTTP、HTTPS、DNS、TCP、ICMP和gRPC多种探测协议
- **灵活配置**：通过配置文件定义探测模块，支持自定义探测规则
- **多目标探测**：实现多目标exporter模式，可同时探测多个目标端点
- **配置重载**：支持运行时配置重载，无需重启服务
- **安全特性**：支持TLS加密和基本认证，保护HTTP端点访问
- **详细日志**：独立的探针日志系统，支持调整日志级别获取调试信息
- **自动配置重载**：可启用配置文件自动检查和重载功能

## 使用场景

- 网站/API可用性监控（HTTP/HTTPS探针）
- DNS解析有效性测试（DNS探针）
- 服务器端口连通性检查（TCP探针）
- 网络设备可达性探测（ICMP ping）
- gRPC服务健康状态监控（gRPC探针）
- 多目标批量监控（结合Prometheus服务发现）

## 使用方法

### Docker镜像使用

**注意**：如需使用IPv6探测，可能需要[在Docker配置中启用IPv6](https://docs.docker.com/v17.09/engine/userguide/networking/default_network/ipv6/)

```bash
docker run --rm \
  -p 9115/tcp \
  --name blackbox_exporter \
  -v $(pwd):/config \
  quay.io/prometheus/blackbox-exporter:latest --config.file=/config/blackbox.yml
```

参数说明：
- `-p 9115/tcp`：映射容器9115端口到主机，用于访问exporter API
- `-v $(pwd):/config`：挂载当前目录到容器/config，用于提供配置文件
- `--config.file=/config/blackbox.yml`：指定配置文件路径

### 检查探测结果

访问以下URL可获取对google.com的HTTP探测指标：
```
http://localhost:9115/probe?target=google.com&module=http_2xx
```

- `probe_success`指标表示探测是否成功（1为成功，0为失败）
- 添加`debug=true`参数可获取探测调试信息：
  ```
  http://localhost:9115/probe?target=google.com&module=http_2xx&debug=true
  ```

exporter自身运行指标可通过以下端点获取：
```
http://localhost:9115/metrics
```

### TLS和基本认证

Blackbox Exporter支持通过TLS和基本认证保护HTTP端点，需通过`--web.config.file`参数指定配置文件，配置文件格式详见[exporter-toolkit文档](https://github.com/prometheus/exporter-toolkit/blob/master/docs/web-configuration.md)。

配置后，所有HTTP端点（/metrics、/probe和Web UI）均受保护。

### 探针日志级别控制

Blackbox Exporter有两个独立日志系统：应用日志和探针日志。探针日志默认级别为`info`，可通过`--log.prober`参数调整：

- `--log.prober=info`（默认）：仅记录重要探针事件
- `--log.prober=debug`：记录详细探针过程，包括DNS解析、请求详情等

**debug级别示例**：
```bash
docker run --rm \
  -p 9115/tcp \
  --name blackbox_exporter \
  -v $(pwd):/config \
  quay.io/prometheus/blackbox-exporter:latest --config.file=/config/blackbox.yml --log.prober=debug
```

## 配置说明

### 配置文件

通过`--config.file`参数指定配置文件路径，配置文件定义探测模块（module）和探测规则。示例配置文件可参考[example.yml](https://github.com/prometheus/blackbox_exporter/blob/master/example.yml)。

### 配置重载

支持三种配置重载方式：
1. 发送SIGHUP信号到进程
2. 发送HTTP POST请求到`/-/reload`端点
3. 启用自动重载：
   ```bash
   --config.enable-auto-reload --config.auto-reload-interval=60  # 每60秒检查配置更新
   ```

### 超时设置

探测超时时间由以下方式决定（优先级从高到低）：
1. 配置文件中模块的`timeout`参数
2. Prometheus配置中的`scrape_timeout`（自动减小区网络延迟）
3. 默认120秒

## Prometheus配置

Blackbox Exporter实现多目标exporter模式，需在Prometheus配置中使用relabeling传递目标参数。

### 基本配置示例

```yaml
scrape_configs:
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # 使用http_2xx模块探测
    static_configs:
      - targets:
        - http://prometheus.io    # HTTP目标
        - https://prometheus.io   # HTTPS目标
        - http://example.com:8080 # 带端口的HTTP目标
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target  # 将目标作为probe参数
      - source_labels: [__param_target]
        target_label: instance        # 实例标签设为目标
      - target_label: __address__
        replacement: 127.0.0.1:9115  # Blackbox Exporter地址
```

### DNS服务发现配置示例

```yaml
scrape_configs:
  - job_name: 'blackbox_dns'
    metrics_path: /probe
    params:
      module: [http_2xx]
    dns_sd_configs:
      - names:
          - example.com
          - prometheus.io
        type: A
        port: 443
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
        replacement: https://$1/  # 构建HTTPS探测URL
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9115  # Blackbox Exporter地址
      - source_labels: [__meta_dns_name]
        target_label: __param_hostname  # 设置Host头
      - source_labels: [__meta_dns_name]
        target_label: vhost  # 存储域名到vhost标签
```

## 权限说明

ICMP探针（ping）需要特殊权限：

- **Linux**：
  - 将用户添加到`net.ipv4.ping_group_range`配置的组中
  - 或赋予`CAP_NET_RAW` capability：`setcap cap_net_raw+ep blackbox_exporter`
  - 或使用root用户运行
- **Windows**：需要管理员权限
- **BSD/macOS**：
  - BSD需要root权限
  - macOS无需额外权限
- **Docker环境**：使用ICMP探针时需添加`--cap-add=NET_RAW`参数
  ```bash
  docker run --rm --cap-add=NET_RAW -p 9115:9115 quay.io/prometheus/blackbox-exporter:latest
