---
image: hyperledger/fabric-peer
description: "超级账本项目（Hyperledger Project）的Fabric Peer节点Docker镜像是区块链网络中核心节点的容器化部署组件，支持账本维护、智能合约执行与交易验证等关键功能，可便捷集成到基于超级账本Fabric的分布式账本系统，为区块链应用提供高效可靠的节点运行环境，助力开发者快速搭建和部署企业级区块链网络。"
source: https://xuanyuan.cloud/zh/r/hyperledger/fabric-peer
canonical: https://xuanyuan.cloud/zh/r/hyperledger/fabric-peer
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hyperledger/fabric-peer" title="hyperledger/fabric-peer Docker 镜像中文简介、标签列表与拉取命令">hyperledger/fabric-peer — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/hyperledger/fabric-peer" title="hyperledger/fabric-peer Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/hyperledger/fabric-peer</a>

# Hyperledger Fabric Peer 镜像使用指南


## 快速参考

- **Hyperledger Fabric 项目页面**：[]  

- **Docker 帮助资源**：  
  [Docker 社区论坛]([])、[Docker 社区 Slack]([])、[Stack Overflow]([])  

- **Hyperledger Fabric 帮助资源**：  
  [Fabric 文档]([])、[Stack Overflow（标签：hyperledger-fabric）]([])、[聊天频道]([])（[登录帮助]([])）  

- **支持说明**：  
  本镜像仅用于开发和测试环境。生产环境需使用各厂商提供的商业支持版本。  

- **支持架构**：amd64  

- **可用标签**：  
  架构特定标签（如 `amd64-2.0.0`）、版本特定标签（如 `2.0.0`）、次要版本最新补丁（如 `2.0`）  

- **镜像 Dockerfile**：[Dockerfile 位置]([])  

- **描述来源**：[Fabric GitHub 仓库]([])  


## 什么是 Hyperledger Fabric Peer？

Hyperledger Fabric 是企业级许可制分布式账本框架，用于开发解决方案和应用。其模块化、灵活的设计可满足多种行业场景需求，采用独特的共识机制，在保障隐私的同时实现规模化性能。  

Peer 节点是 Fabric 的核心运行节点，负责管理和提供账本访问。它从排序服务节点接收区块并提交至账本。  


## 如何使用该镜像

### 启动 Fabric Peer 容器

可通过以下命令运行 Fabric Peer 容器：  

```bash
$ docker run -d --publish 7051:7051 \
  -v /tmp/fabric/config/peer0.org1.example.com:/etc/hyperledger/fabric \
  -v /tmp/fabric/-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp:/etc/hyperledger/fabric/msp \
  -v /tmp/fabric/-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls:/etc/hyperledger/fabric/tls \
  -v /tmp/fabric/data/peer0.org1.example.com:/var/hyperledger/production \
  -v /var/run:/host/var/run \
  --name peer0.org1.example.com hyperledger/fabric-peer:2.0 peer node start
```  

**说明**：  
- 该命令启动一个运行 Hyperledger Fabric Peer（2.0.x 最新补丁版本）的容器，命名为 `peer0.org1.example.com`。  
- 暴露容器的 7051 端口到主机（用于 peer 通信）。  
- 通过挂载主机目录提供配置、证书和数据存储（具体作用见下文“配置”和“数据存储”部分）。  


### 配置 Fabric Peer 容器

Peer 容器需以下三类配置信息：  
- `core.yaml` 配置文件  
- 成员服务提供者（MSP）目录（存储身份凭证）  
- TLS 目录（若启用 TLS，存储 TLS 凭证）  


#### 1. core.yaml 配置文件  
容器预设环境变量 `FABRIC_CFG_PATH` 指向 `/etc/hyperledger/fabric`，默认 `core.yaml` 配置文件位于此目录，内含 SampleOrg 组织配置（如 `peer.localMspId`）。  

**自定义配置方法**：  
- **整体覆盖**：在主机创建自定义配置目录（含 `core.yaml`），通过 `-v /host/config:/etc/hyperledger/fabric` 挂载至容器，覆盖默认配置（例如修改 `peer.localMspId` 为自定义组织 ID）。  
- **单个参数覆盖**：启动容器时通过环境变量覆盖，例如 `-e CORE_PEER_LOCALMSPID=MyOrgMSP`。  


#### 2. MSP 目录（身份凭证）  
Fabric 是许可制区块链，peer 需通过 MSP 目录中的凭证（证书、私钥）加入网络。凭证可由 Fabric CA、cryptogen 工具或其他 CA 生成。  

容器默认 MSP 目录为 `/etc/hyperledger/fabric/msp`（由 `core.yaml` 中 `peer.mspConfigPath` 指定），内含 SampleOrg 示例凭证。  

**自定义凭证**：在主机准备 MSP 目录，通过 `-v /host/msp:/etc/hyperledger/fabric/msp` 挂载至容器，覆盖默认凭证。  


#### 3. TLS 目录（TLS 凭证）  
若网络启用服务端 TLS 或双向 TLS，需提供 TLS 凭证（证书、私钥）。默认 `core.yaml` 中 `peer.tls.enabled` 和 `peer.tls.clientAuthRequired` 为 `false`，启用时需配置 TLS 目录。  

**配置方法**：在主机准备 TLS 目录，通过 `-v /host/tls:/etc/hyperledger/fabric/tls` 挂载至容器。  


### 数据存储位置  
Peer 容器默认将账本等数据写入 `/var/hyperledger/production`（由 `core.yaml` 中 `peer.fileSystemPath` 指定）。为避免容器删除后数据丢失，建议将主机目录挂载至此路径：  

```bash
-v /host/data:/var/hyperledger/production
```  

**注意**：需确保主机目录存在且容器有写入权限。  


### 与 Docker 守护进程通信  
容器需通过 `/var/run/docker.sock` 与主机 Docker 守护进程通信，因此需挂载主机的 `/var/run` 目录：  

```bash
-v /var/run:/host/var/run
```  


### 日志  
#### 查看日志  
通过 Docker 容器日志查看 peer 运行日志，例如查看名为 `peer0.org1.example.com` 的容器日志：  

```bash
$ docker logs peer0.org1.example.com
```  

#### 调整日志级别  
默认日志级别为 `INFO`，可通过环境变量 `FABRIC_LOGGING_SPEC` 覆盖，例如：  

```bash
-e FABRIC_LOGGING_SPEC='info:kvledger,chaincode.platform=debug'
```  

上述命令会增加账本（kvledger）和链码构建（chaincode.platform）的调试日志，用于排查相关问题。  

也可通过 peer 运维服务动态调整运行中节点的日志级别，详见 [日志级别管理文档]([])。  


## 构建自定义 Fabric 镜像  
可参考 Fabric 官方 Dockerfile 构建自定义镜像，或基于现有镜像添加自定义 `core.yaml` 等配置。  


## 许可协议  
Hyperledger Fabric 采用 [Apache 许可证 2.0 版]([]) 授权。
