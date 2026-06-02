---
image: coredns/coredns
description: "CoreDNS Docker仓库是用于存储和分发CoreDNS Docker镜像的平台，CoreDNS作为一款灵活可扩展的DNS服务器，采用Go语言编写，广泛应用于Kubernetes等容器编排系统，为容器集群提供高效域名解析服务；该仓库便于用户快速获取、部署及更新CoreDNS镜像，满足不同容器环境下的DNS配置需求，是容器化应用中实现可靠域名解析的重要资源。"
source: https://xuanyuan.cloud/zh/r/coredns/coredns
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[coredns/coredns](https://xuanyuan.cloud/zh/r/coredns/coredns)
> 含镜像标签、拉取命令、部署文档与相关推荐。

## CoreDNS 官方 Docker 容器介绍  


### 简介  
这是 CoreDNS 的官方 Docker 容器，用来快速部署和运行 CoreDNS 服务。CoreDNS 是一款灵活的 DNS 服务器，支持插件化架构，能通过配置文件自定义 DNS 解析规则，适合在容器化环境（如 Kubernetes、单机 Docker）中使用。  


### 使用前提  
使用前需确保本地已安装 Docker 环境。可通过终端输入 `docker --version` 检查是否安装，若未安装，参考 [Docker 官方文档]([]) 完成安装。  


### 基本操作步骤  

#### 1. 拉取官方镜像  
从 Docker Hub 拉取 CoreDNS 官方镜像（默认拉取最新版，标签为 `latest`）：  
```bash
docker pull coredns/coredns:latest
```  
若需指定版本（如 `1.11.1`），可替换标签：  
```bash
docker pull coredns/coredns:1.11.1
```  


#### 2. 运行容器  
运行容器前，需提前准备好 CoreDNS 的配置文件 `Corefile`（CoreDNS 的核心配置文件，定义 DNS 解析规则）。假设本地配置文件路径为 `/path/to/your/Corefile`，运行容器命令如下：  
```bash
docker run -d \
  --name coredns \
  -p 53:53/udp -p 53:53/tcp \  # 映射 DNS 服务默认端口（UDP/TCP 都需映射）
  -v /path/to/your/Corefile:/etc/coredns/Corefile \  # 挂载本地 Corefile 到容器内
  coredns/coredns:latest  # 使用拉取的镜像（替换为具体版本号更稳妥）
```  


#### 3. 查看容器运行状态与日志  
- 检查容器是否启动成功：  
  ```bash
  docker ps | grep coredns
  ```  
- 查看 CoreDNS 运行日志（排查配置或运行问题）：  
  ```bash
  docker logs coredns
  ```  


#### 4. 停止或删除容器  
- 停止运行中的容器：  
  ```bash
  docker stop coredns
  ```  
- 若需删除容器（删除前需先停止）：  
  ```bash
  docker rm coredns
  ```  


### 注意事项  
- **配置文件 Corefile**：必须提前准备好，否则 CoreDNS 无法正常启动。配置示例可参考 [CoreDNS 官方文档]([])。  
- **端口冲突**：默认映射主机 53 端口（DNS 标准端口），若主机已运行其他 DNS 服务（如 systemd-resolved），需先停止冲突服务或修改映射端口（如 `-p 5353:53/udp -p 5353:53/tcp`）。  
- **镜像标签**：生产环境建议使用具体版本号（如 `1.11.1`），避免 `latest` 标签自动更新导致版本不可控。  
- **持久化配置**：通过 `-v` 参数挂载本地目录（如 `/path/to/coredns-config:/etc/coredns`）保存 Corefile，避免容器删除后配置丢失。  
- **资源限制**：若需限制容器资源（如 CPU/内存），可在 `docker run` 时添加 `--cpus` `--memory` 等参数。
