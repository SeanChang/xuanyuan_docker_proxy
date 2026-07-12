---
image: hashicorppreview/consul
description: "Consul是一款用于服务发现、配置及编排的工具，适用于分布式系统中的服务管理。"
source: https://xuanyuan.cloud/zh/r/hashicorppreview/consul
canonical: https://xuanyuan.cloud/zh/r/hashicorppreview/consul
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorppreview/consul" title="hashicorppreview/consul Docker 镜像中文简介、标签列表与拉取命令">hashicorppreview/consul 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Consul Docker镜像文档


## 一、镜像概述和主要用途

Consul 是一款分布式、高可用且支持多数据中心的服务发现、配置管理和编排工具。它旨在帮助大规模部署、配置和维护面向服务的架构（SOA）及微服务架构。

本 Docker 镜像为 Consul 的**开发版本（dev）镜像**，主要用于开发和测试环境中快速搭建 Consul 服务。**注意**：生产环境中应使用 HashiCorp 官方稳定版镜像（`hashicorp/consul`），具体可参考 [Docker Hub 仓库](https://hub.docker.com/r/hashicorp/consul)。


## 二、核心功能和特性

### 2.1 核心功能
- **服务发现**：支持服务自动注册与发现，通过 DNS 或 HTTP 接口提供服务地址查询。
- **配置管理**：基于分布式键值（KV）存储，实现配置的集中管理和动态更新。
- **健康检查**：内置健康检查机制，监控服务状态，自动隔离异常实例。


### 2.2 关键特性
- **分布式一致性**：基于 Raft 共识算法，确保数据在分布式环境中的一致性和高可用性。
- **多数据中心支持**：原生支持跨数据中心部署，实现全球范围内的服务协同。
- **安全性**：提供 TLS 加密、ACL（访问控制列表）等安全机制，保护服务通信和数据访问。
- **轻量级部署**：容器化部署简化环境依赖，支持快速启停和横向扩展。


## 三、使用场景和适用范围

### 3.1 典型使用场景
- **微服务架构**：作为服务注册中心，解决微服务间的服务发现问题，支持负载均衡。
- **分布式配置**：集中管理分布式系统的配置参数，实现配置热更新，避免重启服务。
- **跨数据中心编排**：在多地域部署中，统一管理服务拓扑，优化跨区域服务通信。
- **开发测试验证**：快速搭建本地 Consul 环境，验证服务注册、配置同步等功能。


### 3.2 适用范围
- **开发/测试环境**：本 dev 镜像适用于开发调试、功能验证场景，不保证数据持久化和生产级稳定性。
- **生产环境**：需使用 `hashicorp/consul` 官方稳定版镜像，配合持久化存储、集群部署等生产级配置。


## 四、使用方法和配置说明

### 4.1 基本使用（开发模式）
开发模式（`-dev`）下，Consul 以单节点模式运行，自动生成配置，适合快速测试：

```bash
docker run -d \
  --name consul-dev \
  -p 8500:8500 \  # HTTP API 端口（服务发现、配置管理）
  -p 8600:8600/udp  # DNS 端口（服务域名解析）
  consul:dev agent -dev -client=0.0.0.0
```

- `-dev`：启用开发模式，数据存储在内存中（非持久化）。
- `-client=0.0.0.0`：允许外部访问 HTTP/DNS 接口（默认仅本地访问）。


### 4.2 服务器模式（单节点示例）
非开发环境需以服务器模式启动，指定数据持久化目录：

```bash
docker run -d \
  --name consul-server \
  -p 8500:8500 \
  -p 8300:8300 \  # 服务器节点间通信端口
  -p 8301:8301/udp \  # Serf LAN 端口（局域网节点发现）
  -v /path/to/consul/data:/consul/data \  # 挂载数据目录（持久化）
  consul:dev agent -server \
    -bootstrap-expect=1 \  # 单节点集群（生产环境建议 ≥3 节点）
    -client=0.0.0.0 \
    -data-dir=/consul/data \
    -node=server-1  # 节点名称（集群内唯一）
```


### 4.3 Docker Compose 示例（开发环境）
```yaml
version: '3'
services:
  consul:
    image: docker.xuanyuan.run/consul:dev
    container_name: consul-dev
    ports:
      - "8500:8500"   # HTTP API
      - "8600:8600/udp"  # DNS
    command: agent -dev -client=0.0.0.0
    restart: unless-stopped
```


### 4.4 核心配置参数
| 参数/选项         | 说明                                  | 示例                          |
|-------------------|---------------------------------------|-------------------------------|
| `-server`         | 以服务器模式启动（参与 Raft 共识）    | `agent -server`               |
| `-client`         | 绑定客户端访问地址（HTTP/DNS 接口）   | `-client=0.0.0.0`             |
| `-data-dir`       | 数据持久化目录                        | `-data-dir=/consul/data`      |
| `-bootstrap-expect` | 集群期望服务器节点数（自动引导集群） | `-bootstrap-expect=3`         |
| `-join`           | 加入现有集群（指定其他节点地址）      | `-join=192.168.1.100`         |


### 4.5 验证服务可用性
启动后，通过 HTTP API 或 Web UI 验证服务状态：
- Web UI：访问 `http://localhost:8500`
- 服务健康检查：`curl http://localhost:8500/v1/agent/self`


## 五、注意事项
1. **数据持久化**：开发镜像默认不持久化数据，生产环境需通过 `-v` 挂载宿主机目录至 `/consul/data`。
2. **集群配置**：生产环境集群建议至少 3 个服务器节点，确保 Raft 共识稳定性。
3. **安全配置**：生产环境需启用 TLS 加密（`-tls-config-file`）和 ACL（`-acl-file`），限制未授权访问。
4. **镜像版本**：本镜像为开发版本，生产环境请使用 `hashicorp/consul` 并指定稳定版本标签（如 `hashicorp/consul:1.16.0`）。
