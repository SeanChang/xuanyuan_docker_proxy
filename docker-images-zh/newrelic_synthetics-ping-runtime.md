---
image: newrelic/synthetics-ping-runtime
description: "合成监控ping测试的运行时环境，用于支持网络连通性检测的执行"
source: https://xuanyuan.cloud/zh/r/newrelic/synthetics-ping-runtime
canonical: https://xuanyuan.cloud/zh/r/newrelic/synthetics-ping-runtime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/newrelic/synthetics-ping-runtime" title="newrelic/synthetics-ping-runtime Docker 镜像中文简介、标签列表与拉取命令">newrelic/synthetics-ping-runtime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# synthetics-ping-runtime Docker镜像文档

## 1. 镜像概述和主要用途

synthetics-ping-runtime是一款轻量级Docker镜像，专为网络合成监控设计，提供ICMP ping测试功能。该镜像可部署在各类环境中，用于执行网络连通性检测、延迟测量和数据包丢失率监控等基础网络诊断任务，帮助用户实时掌握网络状态。

## 2. 核心功能和特性

- 支持ICMP协议的网络连通性测试
- 精准测量网络延迟、抖动和数据包丢失率
- 可配置的测试频率和超时阈值
- 兼容IPv4和IPv6网络环境
- 低资源占用设计，适合边缘环境部署
- 详细的测试结果记录和指标输出
- 支持集成到监控系统和告警机制

## 3. 使用场景和适用范围

- 网络设备与服务的可用性监控
- 全球分布式网络性能基准测试
- 网络故障排查与诊断
- SLA服务级别协议合规性验证
- DevOps工作流中的网络健康检查
- 云服务和基础设施的持续监控
- IoT设备网络连接质量评估

## 4. 使用方法和配置说明

### 4.1 基本使用

```bash
docker run -d --name synthetics-ping --cap-add=NET_RAW docker.xuanyuan.run/synthetics-ping-runtime
```

> 注意：由于ICMP协议需要原始套接字权限，必须添加`--cap-add=NET_RAW`参数

### 4.2 配置目标主机

通过环境变量指定监控目标：

```bash
docker run -d --name synthetics-ping --cap-add=NET_RAW \
  -e TARGET_HOST=example.com \
  docker.xuanyuan.run/synthetics-ping-runtime
```

### 4.3 自定义测试参数

```bash
docker run -d --name synthetics-ping --cap-add=NET_RAW \
  -e TARGET_HOST=example.com \
  -e PING_COUNT=10 \
  -e PING_INTERVAL=1000 \
  -e TIMEOUT=5000 \
  -e PACKET_SIZE=64 \
  docker.xuanyuan.run/synthetics-ping-runtime
```

### 4.4 Docker Compose部署

```yaml
version: '3'
services:
  ping-monitor:
    image: docker.xuanyuan.run/synthetics-ping-runtime
    container_name: synthetics-ping
    cap_add:
      - NET_RAW
    environment:
      - TARGET_HOST=google.com
      - PING_COUNT=5
      - PING_INTERVAL=2000
      - TIMEOUT=3000
      - TEST_INTERVAL=60
      - LOG_LEVEL=info
      - METRICS_ENABLED=true
    ports:
      - "9090:9090"
    restart: always
```

## 5. 环境变量配置参数

| 参数名 | 描述 | 默认值 | 可选值 |
|--------|------|--------|--------|
| TARGET_HOST | 目标主机或IP地址 | example.com | 域名或IP地址 |
| PING_COUNT | 每次测试发送的数据包数量 | 4 | 1-100 |
| PING_INTERVAL | 数据包发送间隔(毫秒) | 1000 | 100-5000 |
| TIMEOUT | 超时时间(毫秒) | 2000 | 500-10000 |
| PACKET_SIZE | ICMP数据包大小(字节) | 56 | 32-1024 |
| IP_VERSION | IP协议版本 | 4 | 4, 6 |
| TEST_INTERVAL | 测试周期(秒) | 60 | 10-3600 |
| LOG_LEVEL | 日志输出级别 | info | debug, info, warn, error |
| REPORT_FORMAT | 报告输出格式 | json | json, text, prometheus |
| METRICS_ENABLED | 是否启用指标导出 | false | true, false |
| METRICS_PORT | 指标暴露端口 | 9090 | 1024-65535 |

## 6. 使用示例

### 6.1 基础连通性测试

```bash
docker run --rm --cap-add=NET_RAW \
  -e TARGET_HOST=8.8.8.8 \
  -e PING_COUNT=5 \
  -e REPORT_FORMAT=text \
  docker.xuanyuan.run/synthetics-ping-runtime
```

### 6.2 长时间监控并导出指标

```bash
docker run -d --name ping-monitor --cap-add=NET_RAW \
  -e TARGET_HOST=api.example.com \
  -e TEST_INTERVAL=30 \
  -e METRICS_ENABLED=true \
  -p 9090:9090 \
  docker.xuanyuan.run/synthetics-ping-runtime
```

### 6.3 IPv6测试

```bash
docker run --rm --cap-add=NET_RAW \
  -e TARGET_HOST=2001:4860:4860::8888 \
  -e IP_VERSION=6 \
  docker.xuanyuan.run/synthetics-ping-runtime
```

## 7. 注意事项

- 部分容器平台可能需要额外配置网络策略以允许ICMP流量
- 生产环境部署时建议设置资源限制，避免影响其他服务
- 长时间运行时应定期清理日志数据，防止磁盘空间耗尽
- 在Kubernetes环境中部署时，需使用特权容器或适当的安全上下文配置
- 某些云服务提供商可能限制或阻止ICMP流量，需提前确认网络策略

## 8. 故障排除

- **容器无法启动**：检查是否添加`--cap-add=NET_RAW`权限
- **测试失败**：验证目标主机是否允许ICMP流量，检查网络连接
- **结果不准确**：调整数据包大小和测试次数，增加样本量
- **查看日志**：使用`docker logs <container_id>`命令获取详细日志信息
