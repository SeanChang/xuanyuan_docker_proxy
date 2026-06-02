<!-- xuanyuan-docker-images-zh
image: library/nats
source: https://xuanyuan.cloud/zh/r/library/nats
canonical: https://xuanyuan.cloud/zh/r/library/nats
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/nats" title="library/nats Docker 镜像中文简介、标签列表与拉取命令">library/nats — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/nats" title="library/nats Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/nats</a></p>

# NATS Docker镜像使用指南


## 快速参考

### 维护者  
[NATS项目]([])


### 获取帮助的途径  
- Docker社区Slack：[dockr.ly/comm-slack]([])  
- Server Fault：[serverfault.com/help/on-topic]([])  
- Unix & Linux：[unix.stackexchange.com/help/on-topic]([])  
- Stack Overflow：[stackoverflow.com/help/on-topic]([])  


## 支持的标签及对应Dockerfile链接  

（关于"共享标签"与"基础标签"的区别，可参考[FAQ]([])）


### 基础标签（Simple Tags）  
- `2.12.0-alpine3.22`, `2.12-alpine3.22`, `2-alpine3.22`, `alpine3.22`, `2.12.0-alpine`, `2.12-alpine`, `2-alpine`, `alpine`  
  [Dockerfile]([])  

- `2.12.0-scratch`, `2.12-scratch`, `2-scratch`, `scratch`, `2.12.0-linux`, `2.12-linux`, `2-linux`, `linux`  
  [Dockerfile]([])  

- `2.12.0-windowsservercore-ltsc2022`, `2.12-windowsservercore-ltsc2022`, `2-windowsservercore-ltsc2022`, `windowsservercore-ltsc2022`  
  [Dockerfile]([])  

- `2.12.0-nanoserver-ltsc2022`, `2.12-nanoserver-ltsc2022`, `2-nanoserver-ltsc2022`, `nanoserver-ltsc2022`  
  [Dockerfile]([])  

- `2.11.10-alpine3.22`, `2.11-alpine3.22`, `2.11.10-alpine`, `2.11-alpine`  
  [Dockerfile]([])  

- `2.11.10-scratch`, `2.11-scratch`, `2.11.10-linux`, `2.11-linux`  
  [Dockerfile]([])  

- `2.11.10-windowsservercore-ltsc2022`, `2.11-windowsservercore-ltsc2022`  
  [Dockerfile]([])  

- `2.11.10-nanoserver-ltsc2022`, `2.11-nanoserver-ltsc2022`  
  [Dockerfile]([])  

- `2.10.29-alpine3.22`, `2.10-alpine3.22`, `2.10.29-alpine`, `2.10-alpine`  
  [Dockerfile]([])  

- `2.10.29-scratch`, `2.10-scratch`, `2.10.29-linux`, `2.10-linux`  
  [Dockerfile]([])  

- `2.10.29-windowsservercore-ltsc2022`, `2.10-windowsservercore-ltsc2022`  
  [Dockerfile]([])  

- `2.10.29-nanoserver-ltsc2022`, `2.10-nanoserver-ltsc2022`  
  [Dockerfile]([])  


### 共享标签（Shared Tags）  
- `2.12.0`, `2.12`, `2`, `latest`：  
  - `2.12.0-scratch` [Dockerfile]([])  
  - `2.12.0-nanoserver-ltsc2022` [Dockerfile]([])  

- `2.12.0-windowsservercore`, `2.12-windowsservercore`, `2-windowsservercore`, `windowsservercore`：  
  - `2.12.0-windowsservercore-ltsc2022` [Dockerfile]([])  

- `2.12.0-nanoserver`, `2.12-nanoserver`, `2-nanoserver`, `nanoserver`：  
  - `2.12.0-nanoserver-ltsc2022` [Dockerfile]([])  

- `2.11.10`, `2.11`：  
  - `2.11.10-scratch` [Dockerfile]([])  
  - `2.11.10-nanoserver-ltsc2022` [Dockerfile]([])  

- `2.11.10-windowsservercore`, `2.11-windowsservercore`：  
  - `2.11.10-windowsservercore-ltsc2022` [Dockerfile]([])  

- `2.11.10-nanoserver`, `2.11-nanoserver`：  
  - `2.11.10-nanoserver-ltsc2022` [Dockerfile]([])  

- `2.10.29`, `2.10`：  
  - `2.10.29-scratch` [Dockerfile]([])  
  - `2.10.29-nanoserver-ltsc2022` [Dockerfile]([])  

- `2.10.29-windowsservercore`, `2.10-windowsservercore`：  
  - `2.10.29-windowsservercore-ltsc2022` [Dockerfile]([])  

- `2.10.29-nanoserver`, `2.10-nanoserver`：  
  - `2.10.29-nanoserver-ltsc2022` [Dockerfile]([])  


## 快速参考（续）  

### 问题反馈地址  
[[]]([])  


### 支持的架构  
（更多信息：[official-images文档]([])）  
`amd64`, `arm32v6`, `arm32v7`, `arm64v8`, `ppc64le`, `s390x`, `windows-amd64`  


### 镜像详情  
[repo-info仓库的`repos/nats/`目录]([])（含镜像元数据、传输大小等）  


### 镜像更新  
- official-images仓库的`library/nats`标签：[issues]([])  
- official-images仓库的`library/nats`文件：[文件]([])（[更新历史]([])）  


### 本文档来源  
[docs仓库的`nats/`目录]([])（[更新历史]([])）  


## NATS：高性能云原生消息系统  

`nats`是NATS消息系统的高性能服务器，专为云原生环境设计，支持低延迟、高吞吐量的消息传递。  


## 示例用法  

```bash
# 运行NATS服务器
# 服务器暴露多个端口：
# 4222：客户端连接端口
# 8222：HTTP管理端口（用于信息监控）
# 6222：集群路由端口
# 
# 启动容器时需通过Docker端口映射（-p <主机端口>:<容器端口>）开放所需端口，
# 或使用-P参数开放所有暴露端口并映射到随机高端口。
# 
# 注意：Docker的-p参数与NATS服务器自身的-p参数不同。
# 例如，若要让NATS服务器监听4444端口，需运行：
# docker run -p 4444:4444 nats -p 4444
# 
# 若需将容器内4444端口映射到主机5555端口：
# docker run -p 5555:4444 nats -p 4444
# 
# 启用JetStream功能：
# docker run -p 4222:4222 nats -js
# 
# 持久化JetStream数据到卷（-v为Docker参数，-js和-sd为NATS参数）：
# docker run -p 4222:4222 -v nats:/data nats -js -sd /data

# 启动单个NATS服务器
$ docker run -d --name nats-main -p 4222:4222 -p 6222:6222 -p 8222:8222 nats
[INF] Starting nats-server
[INF]   Version:  2.9.8
[INF]   Git:      [60e335a]
[INF]   Cluster:  my_cluster
[INF]   Name:     NB3YN6SPZF6MWTLPGYLRE2AD5VVWSW443RO43YR5GC62I463QPYGOL5C
[INF]   ID:       NB3YN6SPZF6MWTLPGYLRE2AD5VVWSW443RO43YR5GC62I463QPYGOL5C
[INF] Using configuration file: /etc/nats/nats-server.conf
[INF] Starting http monitor on 0.0.0.0:8222
[INF] Listening for client connections on 0.0.0.0:4222
[INF] Server is ready
[INF] Cluster name is my_cluster
[INF] Listening for route connections on 0.0.0.0:6222

# 启动第二个服务器并加入集群
# 注意：传递参数时需覆盖Dockerfile的CMD，需包含配置文件路径
$ docker run -d --name=nats-2 --link nats-main -p 4222:4222 -p 6222:6222 -p 8222:8222 nats -c /etc/nats/nats-server.conf --routes=nats-route://ruser:T0pS3cr3t@nats-main:6222

# 验证集群连接（启用调试日志）
$ docker run -d --name=nats-2 --link nats-main -p 4222:4222 -p 6222:6222 -p 8222:8222 nats -c /etc/nats/nats-server.conf

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/nats" title="library/nats Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/nats</a></p>
