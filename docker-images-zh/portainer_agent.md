<!-- xuanyuan-docker-images-zh
image: portainer/agent
source: https://xuanyuan.cloud/zh/r/portainer/agent
canonical: https://xuanyuan.cloud/zh/r/portainer/agent
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [portainer/agent — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/portainer/agent "portainer/agent Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/portainer/agent

[![Docker Pulls]([])]([]) 

## Portainer Agent 介绍

Portainer Agent 的核心作用是解决 Docker API 在管理 Swarm 集群时存在的一个关键限制。


### Docker API 的资源管理限制
在使用 Docker API 管理 Docker 环境时，用户对资源的操作范围受限于 API 请求所指向的节点：  
- **集群感知资源**：Docker Swarm 模式引入了集群概念，同时也带来了服务、任务、配置、密钥这类集群感知资源。在 Swarm 集群的管理节点上，通过 Docker API 可以直接查询或操作集群内任意节点的这些资源（例如查询节点 2 的某个服务状态）。  
- **节点特定资源**：但容器、网络、卷、镜像仍属于节点特定资源，不具备集群感知能力。若要获取某节点（如节点 3）的卷列表，必须直接向该节点发起 API 请求，无法通过管理节点统一获取。


### Agent 的解决方案
Portainer Agent 旨在消除上述差异：它能让容器、网络、卷这类节点特定资源也具备集群感知能力，同时保持 Docker API 的原有请求格式不变。  
这意味着，通过 Agent，用户只需执行一次 Docker API 请求，即可获取 Swarm 集群内所有节点的容器、网络或卷信息（例如查询集群内所有卷的列表），无需逐个节点发起请求。


### 最终目标
Agent 的最终目标是优化 Docker 在 Swarm 集群管理场景下的用户体验，让集群资源管理更高效、更便捷。
