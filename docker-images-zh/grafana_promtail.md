---
image: grafana/promtail
description: "Promtail 是 Grafana Labs 开发的日志收集工具，专为与开源日志聚合系统 Loki 协同工作而设计，主要功能是收集、标记和转换容器及应用程序日志，并将其发送到 Loki 进行存储和查询。作为 Loki 日志栈的关键组件，Promtail 轻量高效，支持动态标签配置和日志过滤，广泛应用于容器化环境及传统服务器的日志收集场景，帮助用户构建完整的日志监控与分析工具链。"
source: https://xuanyuan.cloud/zh/r/grafana/promtail
canonical: https://xuanyuan.cloud/zh/r/grafana/promtail
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grafana/promtail" title="grafana/promtail Docker 镜像中文简介、标签列表与拉取命令">grafana/promtail — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/grafana/promtail" title="grafana/promtail Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/grafana/promtail</a>

# Promtail Docker 镜像使用指南

## 快速参考

### 维护方
由 Grafana Labs 官方维护。

### 帮助渠道
可通过 Grafana 官方文档、GitHub 仓库的 Issues 板块、Grafana 社区论坛获取帮助。

### 支持的标签

**稳定版本标签：**
- latest（最新稳定版）、2.9.4、2.9、2（主版本号）

**开发版本标签：**
- main（开发分支快照）

**基础镜像变体：**
- 部分标签后缀包含基础镜像信息，如 -alpine（基于 Alpine Linux）、-ubuntu（基于 Ubuntu）

### 问题反馈地址
GitHub 仓库 Issues：https://github.com/grafana/loki/issues

### 支持的架构
amd64、arm64v8、ppc64le、s390x（具体架构支持以标签页面为准）

### 镜像更新
- 跟踪更新：Grafana Loki 官方发布节奏，镜像与 Loki 版本同步更新
- 更新记录：GitHub 仓库 Release 页面

### 本文档来源
基于 Grafana 官方文档及镜像特性整理，详情参考官方文档


## 什么是 Promtail

Promtail 是 Loki 日志生态的日志收集组件，采用与 Prometheus 类似的服务发现机制，能够自动发现目标并收集其日志。它支持通过标签对日志进行分类，与 Loki 的标签查询理念一致，大幅提升日志检索效率。Promtail 通常部署在需要收集日志的节点上，可直接读取容器日志文件或通过系统服务收集应用日志，是构建轻量级、低成本日志系统的核心工具。


## 如何使用本镜像

### 启动 Promtail 实例（基础配置）

使用默认配置启动 Promtail（需提前准备配置文件）：

```bash
docker run --name some-promtail -v /path/to/config.yml:/etc/promtail/config.yml -v /var/log:/var/log -d grafana/promtail:tag --config.file=/etc/promtail/config.yml
```

- some-promtail：容器名称
- -v /path/to/config.yml:/etc/promtail/config.yml：挂载本地配置文件到容器
- -v /var/log:/var/log：挂载主机日志目录（根据实际日志路径调整）
- --config.file：指定配置文件路径

### 与 Loki 集成（Docker Compose）

以下是 Promtail + Loki 的 compose.yaml 示例：

```yaml
services:
  loki:
    image: grafana/loki:latest
    ports:
      - 3100:3100
    volumes:
      - loki-data:/loki/data

  promtail:
    image: grafana/promtail:latest
    volumes:
      - /path/to/promtail-config.yml:/etc/promtail/config.yml
      - /var/log:/var/log
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: --config.file=/etc/promtail/config.yml
    depends_on:
      - loki

volumes:
  loki-data:
```

启动命令：docker compose up -d


## 容器 shell 访问与日志查看

### 进入容器 shell

```bash
docker exec -it some-promtail sh
```

### 查看 Promtail 运行日志

```bash
docker logs some-promtail
```


## 配置文件说明

Promtail 依赖配置文件定义日志收集规则，核心配置项包括：
- server：Promtail 服务端口、日志级别等
- clients：Loki 服务地址及认证信息
- scrape_configs：日志收集规则（目标、路径、标签、Pipeline 处理等）

示例配置（简化版）：

```yaml
server:
  http_listen_port: 9080

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets: [localhost]
        labels:
          job: varlogs
          path: /var/log/*.log
```

挂载配置文件时需确保路径与容器内路径一致。


## 环境变量

常用环境变量（用于动态替换配置文件中的变量）：
- LOKI_URL：Loki 服务地址（如 http://loki:3100/loki/api/v1/push）
- PROMTAIL_CONFIG_FILE：配置文件路径（默认 /etc/promtail/config.yml）


## 数据持久化

Promtail 本身不存储日志数据（数据由 Loki 存储），但需确保：
- 挂载的日志目录（如 /var/log）在主机上持久化
- 配置文件持久化（避免容器重启后配置丢失）


## 注意事项

### 权限问题
收集容器日志时，需确保 Promtail 对 /var/lib/docker/containers 目录有读权限（可通过 --user 调整用户或设置目录权限）。

### 服务发现配置
在 Kubernetes 环境中，建议使用 Promtail 的 Kubernetes 服务发现（kubernetes_sd_configs），自动发现 Pod 并添加元数据标签。

### 性能调优
- 对于高日志量场景，可调整 batchsize（批处理大小）和 batchtimeout（批处理超时）参数
- 启用日志压缩（compression: snappy）减少网络传输量

### 版本兼容性
Promtail 版本需与 Loki 版本保持一致（如 Promtail 2.9.x 对应 Loki 2.9.x），避免因 API 不兼容导致日志发送失败。


## 许可信息

镜像中软件遵循 Apache License 2.0 许可协议，详情参考 GitHub 仓库 LICENSE 文件。
