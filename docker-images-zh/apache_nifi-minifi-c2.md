---
image: apache/nifi-minifi-c2
description: "Apache NiFi MiNiFi C2 Server非官方Docker镜像，用于集中管理MiNiFi代理设备，支持配置分发、状态监控及通信协调，简化边缘数据采集节点的管理流程。"
source: https://xuanyuan.cloud/zh/r/apache/nifi-minifi-c2
canonical: https://xuanyuan.cloud/zh/r/apache/nifi-minifi-c2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/nifi-minifi-c2" title="apache/nifi-minifi-c2 Docker 镜像中文简介、标签列表与拉取命令">apache/nifi-minifi-c2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache NiFi MiNiFi C2 Server Docker镜像

## 镜像概述
本镜像为Apache NiFi MiNiFi C2 (Command & Control) Server的非官方Docker化构建，提供轻量级部署方案。MiNiFi C2 Server作为NiFi生态的核心组件，用于集中管理分布式部署的MiNiFi代理设备，实现配置分发、状态监控、生命周期控制等功能，适用于边缘计算与物联网场景下的分布式数据采集节点管理。

## 核心功能与特性

### 1. 代理设备集中管理
- **配置全生命周期管理**：支持MiNiFi代理配置的创建、分发、版本控制及回滚，确保边缘节点运行一致性策略
- **实时状态监控**：收集代理设备在线状态、资源使用率、数据流处理指标等关键信息，提供全局视图
- **生命周期控制**：支持远程启动、停止代理实例，协调边缘节点运行状态

### 2. 通信与协议支持
- 原生支持HTTP/HTTPS协议，保障配置与状态数据传输安全性
- 兼容MiNiFi Java/C++代理的标准通信接口，无需额外适配即可接入现有部署
- 支持自定义通信超时、重试机制，适应弱网络环境下的边缘设备通信

### 3. 可扩展性与灵活性
- 支持配置文件挂载，可自定义服务器参数、代理类型及存储策略
- 可集成外部监控系统（如Prometheus、Grafana），扩展指标采集与告警能力
- 支持水平扩展部署，通过负载均衡器应对大规模代理集群管理需求

## 使用场景
- **物联网边缘设备管理**：集中管控工厂、园区等场景的分布式MiNiFi代理，协调边缘数据采集流程
- **跨地域数据采集节点控制**：统一管理不同区域的MiNiFi代理，确保数据采集策略一致性
- **边缘计算资源优化**：基于代理状态数据动态调整配置，优化边缘节点CPU/内存资源使用
- **混合云环境协调**：在多云、混合云架构中，实现跨环境MiNiFi代理的配置同步与状态监控

## 使用方法

### 基本运行命令
```bash
docker run -d -p 10080:10080 --name minifi-c2-server docker.xuanyuan.run/example/minifi-c2-server:latest
```
> 说明：默认暴露容器内10080端口（HTTP通信端口），可通过`-p`参数自定义宿主机端口映射

### 环境变量配置
| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `C2_SERVER_HTTP_PORT` | HTTP服务监听端口 | `10080` |
| `C2_SERVER_HTTPS_PORT` | HTTPS服务监听端口（启用时生效） | `10443` |
| `C2_SERVER_CONTEXT_PATH` | 服务访问上下文路径 | `/c2` |
| `C2_SERVER_MAX_THREADS` | 最大工作线程数 | `200` |
| `LOG_LEVEL` | 日志级别（DEBUG/INFO/WARN/ERROR） | `INFO` |
| `AGENT_CLASSES` | 支持的代理设备类型（逗号分隔） | `minifi-java,minifi-cpp` |

示例（自定义端口与日志级别）：
```bash
docker run -d \
  -p 8080:8080 \
  -e C2_SERVER_HTTP_PORT=8080 \
  -e LOG_LEVEL=DEBUG \
  -e AGENT_CLASSES=minifi-java \
  --name minifi-c2-server docker.xuanyuan.run/example/minifi-c2-server:latest
```

### 持久化存储配置
为避免容器重启导致配置与数据丢失，建议挂载宿主机目录至容器关键路径：
```bash
docker run -d \
  -p 10080:10080 \
  -v /host/path/conf:/opt/minifi-c2/conf \
  -v /host/path/data:/opt/minifi-c2/data \
  --name minifi-c2-server docker.xuanyuan.run/example/minifi-c2-server:latest
```
> 挂载路径说明：<br>
> - `/opt/minifi-c2/conf`：核心配置目录（含`c2-server.properties`等配置文件）<br>
> - `/opt/minifi-c2/data`：运行时数据目录（含代理状态记录、配置版本信息等）

### Docker Compose示例
```yaml
version: '3.8'
services:
  minifi-c2-server:
    image: docker.xuanyuan.run/example/minifi-c2-server:latest
    container_name: minifi-c2-server
    ports:
      - "10080:10080"  # HTTP端口
      - "10443:10443"  # HTTPS端口（如需启用）
    environment:
      - C2_SERVER_HTTP_PORT=10080
      - LOG_LEVEL=INFO
      - AGENT_CLASSES=minifi-java,minifi-cpp
    volumes:
      - ./conf:/opt/minifi-c2/conf  # 宿主机配置目录挂载
      - ./data:/opt/minifi-c2/data  # 宿主机数据目录挂载
    restart: unless-stopped
```

### 核心配置文件说明
关键配置文件路径：`/opt/minifi-c2/conf/c2-server.properties`，核心配置项包括：
- `nifi.c2.server.connector.http.port`：HTTP监听端口（对应环境变量`C2_SERVER_HTTP_PORT`）
- `nifi.c2.server.agent.classes`：支持的代理类型（对应环境变量`AGENT_CLASSES`）
- `nifi.c2.provider.configuration.class`：配置存储提供者（如`org.apache.nifi.minifi.c2.provider.configuration.FileSystemConfigurationProvider`）
- `nifi.c2.server.security.ssl.enabled`：是否启用HTTPS（`true`/`false`），启用时需配置SSL证书路径

## 注意事项
1. 本镜像为非官方构建，生产环境使用前需进行安全评估与兼容性测试
2. 启用HTTPS时，需通过挂载方式提供SSL证书，并在`c2-server.properties`中配置证书路径（`nifi.c2.server.security.ssl.keystore.path`等）
3. 大规模代理集群场景下，建议使用外部数据库存储代理状态数据，避免本地文件存储瓶颈
4. 容器运行用户默认为非root，如需调整权限可通过`--user`参数指定宿主机用户ID

## 参考链接
- [Apache NiFi MiNiFi官方文档](https://nifi.apache.org/minifi)
- [MiNiFi C2 Server配置指南](https://nifi.apache.org/docs/nifi-minifi-docs/latest/html/administration-guide.html#c2-server-configuration)
