---
image: flashcatcloud/categraf
description: "面向Nightingale的一站式开源遥测收集器，用于简化metrics、logs、traces等可观测性数据的采集、处理与上报。"
source: https://xuanyuan.cloud/zh/r/flashcatcloud/categraf
canonical: https://xuanyuan.cloud/zh/r/flashcatcloud/categraf
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/flashcatcloud/categraf" title="flashcatcloud/categraf Docker 镜像中文简介、标签列表与拉取命令">flashcatcloud/categraf 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Categraf Docker镜像文档

## 镜像概述

该镜像是开源项目Categraf的Docker封装形式。Categraf是一款面向Nightingale监控系统的一站式遥测收集器，旨在提供轻量化、高扩展性的可观测性数据采集解决方案，支持metrics、logs、traces等多类型数据的统一采集、处理与上报。项目源码托管于GitHub：[https://github.com/flashcatcloud/categraf](https://github.com/flashcatcloud/categraf)。

## 核心功能与特性

- **多类型数据采集**：支持metrics（指标）、logs（日志）、traces（追踪）等多种可观测性数据类型
- **丰富采集插件**：内置大量开箱即用的采集插件，覆盖系统、数据库、中间件、容器等常见监控对象
- **轻量化设计**：资源占用低，适合在各类环境（物理机、虚拟机、容器、K8s）中部署
- **与Nightingale无缝集成**：针对Nightingale监控系统优化，支持数据直接上报与格式适配
- **灵活配置**：支持通过配置文件、环境变量进行参数调整，满足多样化采集需求
- **高扩展性**：支持自定义插件开发，可扩展采集能力至特定业务场景

## 使用场景与适用范围

### 典型使用场景
- 构建基于Nightingale的统一监控平台，实现全链路可观测性
- 容器化环境（Docker/K8s）中的系统与应用指标采集
- 分布式系统的日志聚合与追踪数据收集
- 企业级监控体系中多源数据的统一汇聚与预处理

### 适用对象
- DevOps工程师与SRE团队
- 构建监控系统的技术团队
- 需要实现应用可观测性的开发人员

## 使用方法与配置说明

### 基本Docker运行命令

```bash
docker run -d \
  --name categraf \
  --restart always \
  -v /path/to/your/categraf.conf:/etc/categraf/categraf.conf \  # 挂载自定义配置文件
  -v /var/run/docker.sock:/var/run/docker.sock \  # 如需采集Docker容器指标（可选）
  -v /proc:/host/proc:ro \  # 如需采集主机proc信息（可选）
  -v /sys:/host/sys:ro \    # 如需采集主机sys信息（可选）
  flashcatcloud/categraf:latest
```

### Docker Compose配置示例

```yaml
version: '3'
services:
  categraf:
    image: docker.xuanyuan.run/flashcatcloud/categraf:latest
    container_name: categraf
    restart: always
    volumes:
      - ./categraf.conf:/etc/categraf/categraf.conf
      - /var/run/docker.sock:/var/run/docker.sock
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
    environment:
      - TZ=Asia/Shanghai  # 设置时区
      - LOG_LEVEL=info    # 日志级别（debug/info/warn/error）
    ports:
      - "9273:9273"  # 暴露监控指标端口（可选，用于自身监控）
```

### 配置文件说明

Categraf主要通过配置文件`categraf.conf`进行配置，核心配置项包括：

- **全局配置**：采集间隔、日志设置、标签配置等
- **输出配置**：Nightingale服务地址（`[[writers]]`部分的`url`字段）、认证信息
- **插件配置**：各采集插件的启用状态与参数（如`[[inputs.cpu]]`、`[[inputs.memory]]`等系统指标插件）

配置文件模板可从项目GitHub仓库获取：[https://github.com/flashcatcloud/categraf/blob/main/categraf.conf](https://github.com/flashcatcloud/categraf/blob/main/categraf.conf)

### 环境变量配置

部分常用环境变量（用于覆盖配置文件默认值）：

| 环境变量名          | 说明                          | 默认值          |
|---------------------|-------------------------------|-----------------|
| `NIGHTINGALE_URL`   | Nightingale服务地址           | `http://127.0.0.1:17000` |
| `LOG_LEVEL`         | 日志级别                      | `info`          |
| `COLLECT_INTERVAL`  | 基础采集间隔（秒）            | `10`            |
| `TZ`                | 时区设置                      | `UTC`           |

### 数据上报验证

1. 检查容器运行状态：`docker ps | grep categraf`
2. 查看采集日志：`docker logs -f categraf`
3. 在Nightingale控制台查看是否接收到指标数据

### 注意事项

- 配置文件挂载时需确保宿主机路径存在且权限正确
- 采集容器指标时需挂载`/var/run/docker.sock`并确保容器有足够权限
- 大规模部署建议结合K8s使用官方Helm Chart（详见项目GitHub文档）
