---
image: library/swarm
description: "已弃用；请改用“docker swarm init”。"
source: https://xuanyuan.cloud/zh/r/library/swarm
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/swarm](https://xuanyuan.cloud/zh/r/library/swarm)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Swarm 镜像文档

## 废弃通知

> Classic Swarm 已被归档，不再进行积极开发。建议使用 Docker Engine 内置的 Swarm 模式（通过 `docker swarm init` 命令）或其他编排系统。
> 
> （https://github.com/docker/classicswarm#readme）


## 镜像概述

**镜像名称**：swarm  
**原主要用途**：Docker 原生集群管理系统，用于将多个 Docker 主机组成集群并作为单一“虚拟”主机暴露，实现统一管理。  
**状态**：已废弃（DEPRECATED），无官方支持。


## 核心功能与特性（历史参考）

- **Docker API 兼容性**：使用标准 Docker API 作为前端，支持所有兼容 Docker API 的工具（如 docker-compose、Jenkins、Drone.io 等）无缝对接。  
- **集群统一管理**：将多个 Docker 主机节点聚合为单一集群，简化容器部署与管理流程。  
- **可插拔调度后端**：默认提供基础调度策略，支持通过 API 集成第三方调度后端（如 Mesos）以满足大规模生产需求。  
- **多工具支持**：兼容 dokku、flynn、deis、shipyard 等 Docker 生态工具。


## 使用场景与适用范围（历史参考）

原设计用于需要统一管理多个 Docker 主机的场景，适用于：  
- 中小型容器集群的集中化管理  
- 需通过标准 Docker 工具链操作多节点环境的场景  
- 快速搭建容器集群原型  

**当前建议**：由于该项目已废弃，所有场景均应迁移至 Docker Engine 内置的 Swarm 模式（`docker swarm init`）或 Kubernetes 等现代容器编排系统。


## 支持情况

- **支持的标签**：无  
- **支持的架构**：无  
- **镜像更新**：无官方更新（最后维护于项目归档前）  


## 使用方法（历史参考，不建议生产环境使用）

### 集群创建与管理示例

#### 1. 创建集群（获取集群 ID）
```bash
# 创建集群并获取唯一 cluster_id（仅作历史演示，实际已不可用）
docker run --rm swarm create
# 输出示例：6856663cdefdec325839a4b7e1de38e8（此为 cluster_id）
```

#### 2. 在各节点启动 Swarm 代理
```bash
# <node_ip> 为节点的 IP 地址（需保证 Swarm 管理器可访问）
docker run -d swarm join --addr=<node_ip:2375> token://<cluster_id>
```

#### 3. 启动 Swarm 管理器
```bash
# 在任意机器（如本地笔记本）启动管理器，暴露 <swarm_port> 端口
docker run -t -p <swarm_port>:2375 -t swarm manage token://<cluster_id>
```

#### 4. 通过 Docker CLI 操作集群
```bash
# 查看集群信息
docker -H tcp://<swarm_ip:swarm_port> info

# 在集群中运行容器
docker -H tcp://<swarm_ip:swarm_port> run ...

# 查看集群内容器
docker -H tcp://<swarm_ip:swarm_port> ps

# 查看容器日志
docker -H tcp://<swarm_ip:swarm_port> logs ...
```

#### 5. 列出集群节点
```bash
docker run --rm swarm list token://<cluster_id>
# 输出示例：<node_ip:2375>
```

> 更多发现服务配置可参考：[Swarm 发现服务文档](https://github.com/docker/swarm/blob/master/discovery/README.md)


## 高级调度（历史参考）

Swarm 原支持通过过滤器（Filters）和策略（Strategies）实现高级调度：  
- **过滤器**：控制容器调度的节点筛选规则（如资源限制、标签匹配等），详见 [过滤器文档](https://github.com/docker/swarm/blob/master/scheduler/filter/README.md)。  
- **策略**：定义容器在筛选后的节点上的调度优先级（如轮询、资源利用率最优等），详见 [策略文档](https://github.com/docker/swarm/blob/master/scheduler/strategy/README.md)。  


## TLS 配置（历史参考）

Swarm 原支持 CLI 与 Swarm 之间、Swarm 与 Docker 节点之间的 TLS 认证，配置方式与 Docker 一致：  
```bash
swarm manage --tlsverify --tlscacert=<CA证书路径> --tlscert=<服务端证书路径> --tlskey=<服务端密钥路径> [...]
```

> 证书生成需满足 `extendedKeyUsage = clientAuth,serverAuth`，详细 TLS 配置可参考 [Docker TLS 文档](https://docs.docker.com/articles/https/)。


## 维护与支持

- **维护者**：[Docker, Inc.](https://github.com/docker/swarm-library-image)（项目已归档）  
- **问题反馈**：[GitHub Issues](https://github.com/docker/swarm-library-image/issues)（响应有限）  
- **社区支持**：[Docker 社区论坛](https://forums.docker.com/)、[Docker 社区 Slack](https://dockr.ly/slack)、[Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)（建议转向内置 Swarm 模式相关问题）  


## 许可证信息

- **软件许可证**：详见 [Swarm 许可证](https://github.com/docker/swarm/blob/master/LICENSE.code)。  
- **镜像包含软件**：该镜像可能包含基础系统组件（如 Bash 等）及其他依赖，其许可证需另行查阅。  
- **额外许可证信息**：可参考 [repo-info 仓库的 swarm 目录](https://github.com/docker-library/repo-info/tree/master/repos/swarm)。  

**使用须知**：使用本镜像需确保遵守所有包含软件的相关许可证。
