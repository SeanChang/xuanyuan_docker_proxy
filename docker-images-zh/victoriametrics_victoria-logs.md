---
image: victoriametrics/victoria-logs
description: "VictoriaMetrics的快速、经济高效且易用的日志数据库，是简单而强大的解决方案。"
source: https://xuanyuan.cloud/zh/r/victoriametrics/victoria-logs
canonical: https://xuanyuan.cloud/zh/r/victoriametrics/victoria-logs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/victoriametrics/victoria-logs" title="victoriametrics/victoria-logs Docker 镜像中文简介、标签列表与拉取命令">victoriametrics/victoria-logs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# VictoriaLogs Docker镜像文档


## 镜像概述和主要用途

VictoriaLogs 是由 VictoriaMetrics 开发的一款快速、经济高效且易于使用的日志数据库。作为一个简单而强大的解决方案，它旨在提供高效的日志存储与查询能力，帮助用户轻松管理和分析日志数据。


## 核心功能和特性

- **高性能**：采用高效的存储和查询引擎，确保日志处理速度快，响应及时。
- **成本效益**：优化存储机制，降低日志长期存储的硬件资源消耗。
- **易于使用**：配置简单，部署便捷，无需复杂的前期设置。
- **持久化存储**：支持将日志数据持久化到本地文件系统，确保数据不丢失。
- **可配置的日志保留期**：允许自定义日志数据的保留时间，满足不同合规和存储需求。
- **HTTP API支持**：通过HTTP接口提供日志写入和查询能力，易于与现有日志采集工具集成。


## 使用场景和适用范围

### 使用场景
- **日志集中存储**：作为中心化日志数据库，收集来自不同应用、服务或设备的日志数据。
- **日志查询与分析**：支持高效的日志检索，满足日常故障排查、性能分析等需求。
- **长期日志保留**：通过可配置的保留期，实现日志数据的长期归档和合规存储。

### 适用范围
- 中小型企业的日志管理需求。
- 对日志处理性能和存储成本敏感的场景。
- 需要简单部署和维护的日志系统环境。


## 使用方法

### 快速启动（临时实例）
如需快速启动一个临时的 VictoriaLogs 实例（数据不持久化），可执行以下命令：

```bash
docker run --rm -it -p 9428:9428 docker.xuanyuan.run/victoriametrics/victoria-logs:latest
```

### 持久化存储部署
为确保日志数据在容器重启后不丢失，需挂载本地目录作为持久化存储：

```bash
docker run --rm -it -p 9428:9428 -v ./victoria-logs-data:/victoria-logs-data \
  docker.xuanyuan.run/victoriametrics/victoria-logs:latest -storageDataPath=victoria-logs-data
```

### Docker Compose 配置示例
创建 `docker-compose.yml` 文件，配置持久化存储和自定义参数：

```yaml
version: '3.8'
services:
  victoria-logs:
    image: docker.xuanyuan.run/victoriametrics/victoria-logs:latest
    container_name: victoria-logs
    ports:
      - "9428:9428"
    volumes:
      - ./victoria-logs-data:/victoria-logs-data
    command:
      - -storageDataPath=victoria-logs-data
      - -retentionPeriod=14d  # 日志保留期设置为14天
      - -httpListenAddr=:9428  # HTTP监听地址
    restart: unless-stopped
```

启动服务：
```bash
docker-compose up -d
```


## 配置参数说明

VictoriaLogs 支持通过命令行参数进行配置，以下是核心参数说明：

| 参数名              | 描述                                                                 | 默认值                | 示例                          |
|---------------------|----------------------------------------------------------------------|-----------------------|-------------------------------|
| `-storageDataPath`  | 日志数据存储目录路径                                                 | `victoria-logs-data`  | `-storageDataPath=/data/logs` |
| `-retentionPeriod`  | 日志数据保留期（支持单位：s-秒、m-分、h-时、d-天、w-周、y-年）       | `1w`（1周）           | `-retentionPeriod=30d`        |
| `-httpListenAddr`   | HTTP服务监听地址（格式：`IP:端口`，空IP表示监听所有网络接口）        | `:9428`（监听9428端口）| `-httpListenAddr=0.0.0.0:8080` |


## 获取帮助

- **Slack社区**：加入 [VictoriaMetrics 社区 Slack](https://inviter.co/victoriametrics) 中的 `#victorialogs` 频道。
- **官方文档**：[VictoriaLogs 详细文档](https://docs.victoriametrics.com/victorialogs/)
- **问题反馈**：在 [GitHub Issues](https://github.com/VictoriaMetrics/VictoriaLogs/issues) 提交bug报告或功能建议。


## 源代码

VictoriaLogs 的源代码托管于 GitHub 仓库：[https://github.com/VictoriaMetrics/VictoriaLogs](https://github.com/VictoriaMetrics/VictoriaLogs)
