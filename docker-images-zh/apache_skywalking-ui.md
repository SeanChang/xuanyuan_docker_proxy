---
image: apache/skywalking-ui
description: "Apache SkyWalking Web用户界面是开源可观测性平台Apache SkyWalking的可视化交互入口，用于集中呈现分布式系统的监控数据，支持服务拓扑图展示、性能指标（如响应时间、吞吐量、错误率）实时监控、分布式追踪链路查询及告警状态可视化等核心功能，帮助运维与开发人员直观掌握系统运行状态，快速定位性能瓶颈与故障点，有效提升分布式架构下的系统可观测性与问题排查效率。"
source: https://xuanyuan.cloud/zh/r/apache/skywalking-ui
canonical: https://xuanyuan.cloud/zh/r/apache/skywalking-ui
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [apache/skywalking-ui — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/apache/skywalking-ui)

含镜像标签、拉取命令、部署文档与相关推荐。

[apache/skywalking-ui Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/apache/skywalking-ui)

# Apache SkyWalking UI 镜像


Apache SkyWalking UI Docker镜像并非Apache软件基金会（ASF）的官方发布版本，而是为方便用户使用提供的工具。官方建议优先通过源码构建进行部署。


## SkyWalking 简介  
SkyWalking 是一款应用性能监控（APM）系统，专为微服务、云原生及容器化架构（如Docker、Kubernetes、Mesos）设计。


## 镜像相关说明  
- Dockerfile 可在 [此处]([]) 获取。  
- 该镜像仅用于启动 SkyWalking UI 服务。  
- SkyWalking Kubernetes 部署脚本默认使用此镜像。  


## 如何使用该镜像  

### 启动容器连接 OAP 服务器（地址为 `oap:12800`）  
执行以下命令，启动一个连接指定 OAP 服务器的 UI 容器：  
```bash
$ docker run --name oap-ui --restart always -d -e SW_OAP_ADDRESS=[] apache/skywalking-ui
```  
**参数说明**：  
- `--name oap-ui`：设置容器名称为 `oap-ui`；  
- `--restart always`：配置容器退出后自动重启；  
- `-d`：后台运行容器；  
- `-e SW_OAP_ADDRESS=[] OAP 服务器地址。  


## 配置说明  
可通过设置环境变量调整镜像配置，具体如下：  

### SW_OAP_ADDRESS  
作用：指定 OAP 服务器地址。  
默认值：`oap:12800`。  

### SW_TIMEOUT  
作用：设置读取超时时间。  
默认值：`20000`（单位：毫秒）。
