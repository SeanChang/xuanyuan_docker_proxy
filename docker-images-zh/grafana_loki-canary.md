---
image: grafana/loki-canary
description: "grafana/loki-canary 是 Grafana Labs 提供的 Loki 日志系统性能测试镜像，通过生成模拟日志并验证其传输、存储和查询的完整性，帮助用户评估 Loki 集群的可靠性和延迟表现。"
source: https://xuanyuan.cloud/zh/r/grafana/loki-canary
canonical: https://xuanyuan.cloud/zh/r/grafana/loki-canary
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/loki-canary" title="grafana/loki-canary Docker 镜像中文简介、标签列表与拉取命令">grafana/loki-canary 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Grafana Loki Canary Docker 镜像使用指南

## 快速参考

### 维护方
由 Grafana Labs 官方维护。

### 帮助渠道
可通过 Grafana 官方文档、GitHub 仓库或社区论坛获取支持。

### 支持的标签及对应 Dockerfile 链接
- 稳定版本标签：latest、v2.7.0 等（与 Loki 主版本同步）
- 基础镜像变体：基于 Alpine Linux（部分标签后缀标识）

### 问题反馈地址
Loki GitHub Issues：https://github.com/grafana/loki/issues

### 支持的架构
amd64（主流架构），部分版本可能支持 arm64（需参考镜像仓库）

### 镜像详情
包含元数据、传输大小等信息：Docker Hub 镜像页面

### 镜像更新
随 Loki 版本发布同步更新，支持通过镜像摘要（Digest）固定版本。


## 什么是 Grafana Loki Canary

该镜像通过以下核心功能测试 Loki 集群：

- 生成带时间戳的模拟日志，验证日志传输延迟
- 通过 WebSocket 实时监听日志，检测乱序或丢失条目
- 定期抽查历史日志，验证数据持久化能力
- 输出 Prometheus 指标（如延迟直方图、乱序计数）供监控分析


## 如何使用本镜像

### 启动测试实例

```bash
docker run --name loki-canary -v /loki-canary/logs:/logs -e LOKI_URL=http://loki:3100/loki/api/v1/push -d docker.xuanyuan.run/grafana/loki-canary:v2.7.0
```

- 挂载日志目录以保存测试数据
- 通过环境变量指定 Loki 服务地址

### 与 Loki 集成测试

在 Docker Compose 中配置 Loki 和 Promtail 进行端到端测试：

```yaml
services:
  loki:
    image: docker.xuanyuan.run/grafana/loki:v2.7.0
    ports:
      - 3100:3100
  promtail:
    image: docker.xuanyuan.run/grafana/promtail:v2.7.0
    volumes:
      - /loki-canary/logs:/logs
    command: --config.file=/etc/promtail/promtail.yml
  loki-canary:
    image: docker.xuanyuan.run/grafana/loki-canary:v2.7.0
    environment:
      - LOKI_URL=http://loki:3100/loki/api/v1/push
```

Promtail 负责将测试日志发送至 Loki。


## 容器 shell 访问与日志查看

### 进入容器

```bash
docker exec -it loki-canary sh
```

### 查看测试报告

```bash
docker logs loki-canary
```


## 环境变量

- **LOKI_URL**：Loki 服务地址（必填）
- **-wait**：日志等待超时时间（默认 60s）
- **-spot-check-interval**：抽查日志的时间间隔（默认 15m）


## 数据持久化

测试日志存储在容器内的 /logs 目录，建议通过卷挂载到主机。


## 注意事项

- 需与 Loki 和 Promtail 版本保持一致
- 高并发场景下建议调整 -batchsize 和 -batchtimeout 参数优化性能
- 生产环境测试需注意 Loki 查询负载，避免影响业务


## 许可信息

镜像遵循 Apache License 2.0，详情参考 Loki 开源协议 https://github.com/grafana/loki/blob/main/LICENSE
