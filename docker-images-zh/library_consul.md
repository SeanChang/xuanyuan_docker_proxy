---
image: library/consul
description: "Consul是一种数据中心运行时工具，主要提供服务发现、配置管理和服务编排功能，能够助力分布式系统中的服务实现自动注册与发现、动态配置更新及服务生命周期协调管理，确保数据中心内各类服务高效、可靠地通信与协作，是构建现代化微服务架构和云原生应用的重要基础设施组件。"
source: https://xuanyuan.cloud/zh/r/library/consul
canonical: https://xuanyuan.cloud/zh/r/library/consul
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [library/consul — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/library/consul)

含镜像标签、拉取命令、部署文档与相关推荐。

[library/consul Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/library/consul)

# Consul Docker 镜像使用指南


## 弃用通知  
Consul 1.16版本将停止发布官方Dockerhub镜像，仅提供Verified Publisher镜像。使用Docker镜像的用户需从 [hashicorp/consul]([]) 拉取，而非原 [consul]([])。Verified Publisher镜像地址：[] 快速参考  

### 基础信息  
- **维护方**：[HashiCorp]([])  
- **获取帮助**：[Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


### 支持的标签  
当前无支持的标签。


### 其他参考信息  
- **问题反馈地址**：[[]]([])  
- **支持的架构**：无（更多信息见 [官方说明]([])）  
- **镜像详情**：[repo-info仓库的`repos/consul/`目录]([])（含元数据、传输大小等，[历史记录]([])）  
- **镜像更新**：[official-images仓库的`library/consul`标签]([]) 或 [文件]([])（[历史记录]([])）  
- **本文档来源**：[docs仓库的`consul/`目录]([])（[历史记录]([])）  


## Consul 简介  
Consul 是一款分布式、高可用、支持多数据中心的工具，用于服务发现、配置管理和编排。它支持大规模服务架构的快速部署、配置和维护。更多信息：  
- [Consul 官方文档]([])  
- [Consul GitHub 仓库]([])  


## Consul 与 Docker  
Consul 运行时包含多个组件，以下先简要介绍其架构，再说明与 Docker 的交互方式（详细架构见 [Consul 架构文档]([])）。  


### 核心架构  
- **Consul Agent**：运行在集群中每个主机的长期进程，分客户端和服务器模式。  
  - **服务器模式**：至少1个（建议3或5个以实现高可用），参与[共识协议]([])，维护集群状态，响应其他Agent的查询。  
  - **客户端模式**：通过[ gossip 协议]([])发现其他Agent并检查故障，将查询转发给服务器。  
- **应用交互**：主机上的应用通过本地Agent的HTTP API或DNS接口通信，服务注册也通过本地Agent同步至服务器。例如，应用查询`foo.service.consul`可获取提供“foo”服务的随机主机列表，实现无代理的服务发现和负载均衡。  


### Docker 环境注意事项  
在Docker中运行Consul时，建议每个主机运行一个Agent容器（与Docker守护进程共存），并配置部分Agent为服务器（至少3个实现基础高可用）。**必须使用`--net=host`网络模式**，因为Consul的共识和gossip协议对延迟和丢包敏感，其他网络类型可能引入不必要的性能问题。  


## 使用容器  

### 镜像基础信息  
- **基础镜像**：Alpine，轻量且安全，包含`curl`（Consul 0.7+）以便健康检查。  
- **进程管理**：使用[dumb-init]([])处理僵尸进程和信号转发，[gosu]([])以非root用户“consul”运行Consul，增强安全性。  
- **数据与配置**：  
  - 数据目录：`/consul/data`（卷挂载，重启时建议保留以恢复状态，开发模式下不使用）。  
  - 配置目录：`/consul/config`（可挂载卷或通过`CONSUL_LOCAL_CONFIG`环境变量传入JSON配置）。  


### 开发模式运行 Consul  
适合本地测试，**不用于生产**（数据不持久化，容器停止后状态丢失）。  

#### 启动命令  
```console
docker run -d --name=dev-consul -e CONSUL_BIND_INTERFACE=eth0 consul
```  
- 作用：后台运行开发模式的Consul服务器，自动绑定eth0接口。  

#### 扩展集群（多节点测试）  
启动额外服务器并加入集群（假设第一个节点IP为172.17.0.2）：  
```console
docker run -d -e CONSUL_BIND_INTERFACE=eth0 consul agent -dev -join=172.17.0.2  # 第二个节点
docker run -d -e CONSUL_BIND_INTERFACE=eth0 consul agent -dev -join=172.17.0.2  # 第三个节点
```  

#### 验证集群  
```console
docker exec -t dev-consul consul members  # 查看集群成员
```  


### 客户端模式运行 Agent  
用于转发查询和注册服务，需连接至服务器集群。  

#### 启动命令  
```console
docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' \
  consul agent -bind=<外部IP> -retry-join=<服务器IP>
```  
- 参数说明：  
  - `--net=host`：使用主机网络。  
  - `CONSUL_LOCAL_CONFIG`：设置容器终止时自动离开集群（Consul 0.7+默认启用，可省略）。  
  - `-bind=<外部IP>`：指定集群通信IP。  
  - `-retry-join=<服务器IP>`：重试连接服务器IP。  

#### 验证服务  
```console
curl []  # 检查服务健康状态
dig @localhost -p 8600 consul.service.consul  # DNS查询服务
```  


### 服务器模式运行 Agent  
用于维护集群状态，需指定服务器模式和预期服务器数量。  

#### 启动命令  
```console
docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
  consul agent -server -bind=<外部IP> -retry-join=<其他服务器IP> -bootstrap-expect=<服务器总数>
```  
- 参数说明：  
  - `-server`：启用服务器模式。  
  - `-bootstrap-expect=<N>`：指定集群中预期的服务器数量（达到数量后启动共识）。  
  - `skip_leave_on_interrupt`：避免意外中断时节点退出集群（Consul 0.7+默认启用，可省略）。  


### 暴露 DNS 服务至端口 53  
Consul 默认DNS端口为8600，若需使用标准端口53（需Consul 0.7+）：  

#### 启动命令（主机网络）  
```console
docker run -d --net=host -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' \
  consul agent -dns-port=53 -recursor=8.8.8.8 -bind=<桥接IP>
```  
- `-dns-port=53`：DNS端口设为53。  
- `-recursor=8.8.8.8`：非Consul域名转发至外部DNS（如Google DNS）。  

#### 其他容器使用 Consul DNS  
```console
docker run -i --dns=<桥接IP> -t ubuntu sh -c "apt-get update && apt-get install -y dnsutils && dig consul.service.consul"
```  


### 容器服务发现  
以下是注册容器服务到Consul的常用方法：  
1. **手动注册**：通过Agent API（见 [Agent API文档]([])）。  
2. **配置文件**：在`/consul/config`挂载服务配置JSON文件（见 [服务文档]([])）。  
3. **自动工具**：  
   - [Nomad]([])：HashiCorp调度器，原生支持Consul服务注册（见 [Nomad Consul集成]([])）。  
   - [Registrator]([])：监听Docker事件并自动注册服务。  
   - [ContainerPilot]([])：容器内工具，管理服务注册、健康检查和注销。  


### 容器内健康检查  
Consul 可在容器内执行健康检查，需暴露Docker守护进程并设置`DOCKER_HOST`环境变量（详见 [健康检查文档]([])）。  


## 许可证  
- 镜像中软件的许可信息：[Consul 许可证]([])。  
- 镜像可能包含其他软件（如Bash等），其许可证需用户自行确认合规性。  
- 自动检测的许可信息：[repo-info仓库的`consul/`目录]([])。
