---
image: relevancelab/cadvisor
description: "在容器中运行启用了CORS的cAdvisor，用于监控Docker容器性能数据。"
source: https://xuanyuan.cloud/zh/r/relevancelab/cadvisor
canonical: https://xuanyuan.cloud/zh/r/relevancelab/cadvisor
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/relevancelab/cadvisor" title="relevancelab/cadvisor Docker 镜像中文简介、标签列表与拉取命令">relevancelab/cadvisor 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述
该镜像用于在Docker容器中运行cAdvisor（Container Advisor），且已启用CORS（跨域资源共享）支持。cAdvisor是一个开源工具，用于收集、聚合、处理和导出容器的性能数据，包括CPU、内存、磁盘I/O、网络等指标。

## 核心功能和特性
- **容器监控**：实时收集容器的资源使用情况和性能指标
- **CORS支持**：允许跨域请求访问监控数据，便于前端应用集成
- **多维度数据**：提供容器级别的CPU、内存、网络、磁盘等详细指标
- **轻量级部署**：通过Docker容器化部署，简化安装和配置流程

## 使用场景
- 需要监控Docker容器运行状态的开发/生产环境
- 构建容器监控仪表盘或集成到现有监控系统
- 跨域访问cAdvisor API的前端应用场景

## 使用方法和配置说明

### 基本运行命令
```bash
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  docker.xuanyuan.run/relevancelab/cadvisor:latest
```

### 参数说明
| 参数 | 说明 |
|------|------|
| `--volume=/:/rootfs:ro` | 只读挂载主机根文件系统，用于收集系统级信息 |
| `--volume=/var/run:/var/run:rw` | 读写挂载运行时目录，用于访问Docker socket |
| `--volume=/sys:/sys:ro` | 只读挂载/sys目录，用于收集系统设备信息 |
| `--volume=/var/lib/docker/:/var/lib/docker:ro` | 只读挂载Docker数据目录，用于监控容器详情 |
| `--publish=8080:8080` | 将容器8080端口映射到主机8080端口，提供Web访问 |
| `--detach=true` | 后台运行容器 |
| `--name=cadvisor` | 指定容器名称为cadvisor |

### 访问监控界面
容器启动后，可通过 `http://<主机IP>:8080` 访问cAdvisor Web界面，查看容器监控数据。API接口也可通过该地址访问，支持跨域请求。

### 停止和重启容器
```bash
# 停止容器
docker stop cadvisor

# 启动容器
docker start cadvisor

# 删除容器
docker rm cadvisor
