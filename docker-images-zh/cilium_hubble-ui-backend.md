---
image: cilium/hubble-ui-backend
description: "Hubble UI是Cilium Hubble的开源用户界面，用于微服务应用连接性的故障排除。"
source: https://xuanyuan.cloud/zh/r/cilium/hubble-ui-backend
canonical: https://xuanyuan.cloud/zh/r/cilium/hubble-ui-backend
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cilium/hubble-ui-backend" title="cilium/hubble-ui-backend Docker 镜像中文简介、标签列表与拉取命令">cilium/hubble-ui-backend 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Hubble UI

## 镜像概述和主要用途
Hubble UI 是 [Cilium Hubble](https://github.com/cilium/hubble) 的开源用户界面，旨在为 Kubernetes 集群提供服务依赖关系和数据流的可视化管理能力，帮助用户直观地监控和排查微服务通信问题。


## 核心功能和特性
### 核心功能
- **多层级服务依赖发现**：支持 L3/L4（网络层/传输层）乃至 L7（应用层）的 Kubernetes 集群服务依赖关系自动发现，无需额外配置。
- **数据流可视化**：通过 Service Map（服务地图）以用户友好的方式展示数据流，支持实时可视化和过滤。
- **微服务连接性排查**：提供直观的故障排查入口，帮助定位服务间通信异常。

### 特性
- 零配置自动发现：无需手动定义服务关系，自动识别集群内服务依赖。
- 多维度数据展示：覆盖网络层到应用层的服务交互数据。
- 实时数据流过滤：支持按服务、协议、状态等维度筛选数据流。


## 使用场景和适用范围
### 适用场景
- Kubernetes 集群中微服务连接性故障排查。
- 服务依赖关系梳理与架构可视化。
- 实时监控集群内跨服务数据流状态。

### 适用范围
- 已部署 Cilium 网络插件的 Kubernetes 集群。
- 集成 Hubble 进行网络可观测性的环境。


## 使用方法和配置说明
### 安装说明
Hubble UI 作为 Hubble 的组件之一部署，无需单独安装。具体部署步骤请参考 [Hubble 入门指南](https://docs.cilium.io/en/stable/gettingstarted/hubble/#deploy-cilium-and-hubble)，通过部署 Cilium 和 Hubble 自动集成 Hubble UI。


### 开发指南
如需本地开发或修改 Hubble UI，可按以下步骤配置开发环境。

#### 后端开发
若需将前端连接到 minikube 中部署的后端，执行端口转发：
```bash
kubectl port-forward -n kube-system deployment/hubble-ui 8081
```

若需修改 Go 后端代码，需额外执行以下步骤：
1. 进入后端目录并启动服务：
   ```bash
   cd ./backend && ./ctl.sh run
   ```
   等待构建完成并启动后端服务器。

2. 在另一个终端中，进入包含 Envoy 配置的服务器目录并启动 Envoy（需预先安装 Envoy）：
   ```bash
   cd ./server && envoy -c ./envoy.yaml
   ```

3. 在第三个终端中，转发 hubble-relay 端口：
   ```bash
   kubectl port-forward -n kube-system deployment/hubble-relay 50051:4245
   ```

#### 前端开发
1. 安装依赖：
   ```bash
   npm install
   ```

2. 启动开发服务器：
   ```bash
   npm run watch
   ```

3. 访问前端页面：[http://localhost:8080](http://localhost:8080)


## 社区
了解更多关于 [Cilium 社区](https://github.com/cilium/cilium#community) 的信息，包括贡献指南、交流渠道等。


## 许可证
Hubble UI 基于 [Apache License, Version 2.0](https://github.com/cilium/hubble-ui/blob/master/LICENSE) 开源。
