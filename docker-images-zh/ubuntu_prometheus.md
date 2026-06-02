---
image: ubuntu/prometheus
description: "普罗米修斯是一款广泛应用于IT领域的系统与服务监控系统，它通过部署在目标环境中的组件对计算机系统、网络服务、应用程序等各类系统及服务的运行状态、资源使用情况、性能表现、故障信息等进行全天候实时监测、数据采集、指标分析与告警通知，为系统运维和管理提供可靠的数据支持，其中长期支持版本由Canonical公司负责持续维护与更新。"
source: https://xuanyuan.cloud/zh/r/ubuntu/prometheus
canonical: https://xuanyuan.cloud/zh/r/ubuntu/prometheus
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/prometheus" title="ubuntu/prometheus Docker 镜像中文简介、标签列表与拉取命令">ubuntu/prometheus — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/prometheus" title="ubuntu/prometheus Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/prometheus</a>

# Prometheus | Ubuntu Docker镜像介绍


## 当前镜像信息  
本Prometheus Docker镜像由Canonical基于Ubuntu系统构建，支持安全更新，并会滚动升级至新版本的Prometheus或Ubuntu。该仓库可免费使用，且不受用户速率限制。


## 关于Prometheus  
Prometheus是一款系统与服务监控工具，能够按配置间隔从目标采集指标、评估规则表达式、展示结果，并在满足特定条件时触发告警。更多信息可访问[Prometheus官网]([])。


## 标签与架构  

### LTS与ESM说明  
- **LTS**：LTS通道提供最长5年免费安全维护。  
- **ESM**：通过Canonical的受限仓库，可获取最长10年的商业安全维护（[联系Canonical]([])）。  


### 标签详情  
| 通道标签                | 其他可用标签                                                                 | 支持状态   | 当前版本                          | 支持架构                                     |
|-------------------------|----------------------------------------------------------------------------|------------|-----------------------------------|--------------------------------------------|
| **`2-24.04_stable`**    | `2-24.04`, `2-24.04_beta`, `2-24.04_candidate`, `2-24.04_edge`             | 持续支持   | Prometheus 2 基于 Ubuntu 24.04 LTS | `amd64`                                    |
| `3-24.04_stable`        | `3-24.04`, `3-24.04_beta`, `3-24.04_candidate`, `3-24.04_edge`             | 持续支持   | Prometheus 3 基于 Ubuntu 24.04 LTS | `amd64`                                    |
| `2.50-22.04_stable`     | `2.50-22.04`, `2.50-22.04_beta`, `2.50-22.04_candidate`, `2.50-22.04_edge` | 持续支持   | Prometheus 2.50 基于 Ubuntu 22.04 LTS | `amd64`                                 |
| `2.46-22.04_stable`     | `2.46-22.04`, `2.46-22.04_beta`, `2.46-22.04_candidate`, `2.46-22.04_edge` | 持续支持   | Prometheus 2.46 基于 Ubuntu 22.04 LTS | `amd64`                                 |
| `2.33-22.04_beta`       | `edge`, `latest`                                                          | 持续支持   | Prometheus 2.33 基于 Ubuntu 22.04 LTS | `amd64`、`s390x`、`ppc64le`、`arm64`     |
| `2.28-21.10_beta`       | `2.28-21.10_edge`                                                        | 持续支持   | Prometheus 2.28 基于 Ubuntu 21.10 | `amd64`、`s390x`、`ppc64le`、`arm64`     |
| `2.25-21.04_beta`       | `2.25-21.04_edge`                                                        | 持续支持   | Prometheus 2.25 基于 Ubuntu 21.04 | `s390x`、`arm64`、`ppc64le`、`amd64`     |
| `2.20-20.04_beta`       | `2.20-20.04_edge`                                                        | 持续支持   | Prometheus 2.20 基于 Ubuntu 20.04 LTS | `amd64`、`s390x`、`ppc64le`、`arm64`     |
| `2.32-20.04_beta`       | `2.32-20.04_edge`                                                        | 持续支持   | Prometheus 2.32 基于 Ubuntu 20.04 LTS | `s390x`、`ppc64le`、`amd64`、`arm64`     |
| `2.33-22.04_edge`       | `2.33-22.04_edge`                                                        | 持续支持   | Prometheus 2.33 基于 Ubuntu 22.04 LTS | `amd64`、`s390x`、`ppc64le`、`arm64`     |
| _`track_risk`_          |                                                                           |            |                                    |                                            |  


#### 标签稳定性说明  
通道标签按稳定性排序为：`stable`（稳定）、`candidate`（候选）、`beta`（测试）、`edge`（边缘）。风险较高的通道默认可用，例如：若列出`beta`，则可拉取`edge`；列出`candidate`，则可拉取`beta`和`edge`；列出`stable`，则四个通道均可用。镜像会按`edge`→`beta`→`candidate`→`stable`的顺序逐步更新。


### 商业用途与扩展安全维护通道  
若需商业再分发，或需要ESM通道及未列出的版本/通道，可联系Canonical团队（邮箱：[邮箱已删除]）。


## 使用方法  

### 本地启动  
通过以下命令本地启动镜像：  
```sh
docker run -d --name prometheus-container -e TZ=UTC -p 9090:9090 ubuntu/prometheus:2-24.04_stable
```  
启动后，通过 `[] 访问Prometheus实例。


### 参数说明  

| 参数 | 说明 |
|------|------|
| `-e TZ=UTC` | 设置时区（示例为UTC）。 |
| `-p 9090:9090` | 将Prometheus服务暴露在`localhost:9090`。 |
| `-v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml` | 挂载本地配置文件`prometheus.yml`。 |
| `-v /path/to/alerts.yml:/etc/prometheus/alerts.yml` | 挂载本地告警规则文件`alerts.yml`。 |


### 测试与调试  
- 查看容器日志：  
  ```sh
  docker logs -f prometheus-container
  ```  

- 进入容器交互终端：  
  ```sh
  docker exec -it prometheus-container /bin/bash
  ```  


## 错误报告与功能请求  
若发现镜像问题或需请求功能，可通过以下链接提交bug：  
[[]]([])  

提交时请按格式填写标题：`prometheus: <问题摘要>`，并附上镜像摘要（通过以下命令获取）：  
```sh
docker images --no-trunc --quiet ubuntu/prometheus:<tag>
```  


## 已弃用标签  
以下标签已停止更新，建议升级至最新稳定版：  

| 通道 | 版本 | 停止维护时间 | 升级建议 |
|------|------|--------------|----------|
| ~~2.53.3-24.04~~ | Prometheus 2.53.3 基于 Ubuntu 24.04 LTS | 2025-03 | 升级至最新稳定版 |
| ~~2.55.1-24.04~~ | Prometheus 2.55.1 基于 Ubuntu 24.04 LTS | 2025-03 | 升级至最新稳定版 |
| ~~2.50-22.04~~ | Prometheus 2.50 基于 Ubuntu 22.04 LTS | 持续支持* | 建议升级至`2.50-22.04_stable` |
| ~~2.46-22.04~~ | Prometheus 2.46 基于 Ubuntu 22.04 LTS | 持续支持* | 建议升级至`2.46-22.04_stable` |
| ~~2.37.0-22.04~~ | Prometheus 2.37.0 基于 Ubuntu 22.04 LTS | 2024-10 | 升级至最新稳定版 |
| ~~2.49.1-22.04~~ | Prometheus 2.49.1 基于 Ubuntu 22.04 LTS | 2025-05 | 升级至最新稳定版 |
| ~~2.47.2-22.04~~ | Prometheus 2.47.2 基于 Ubuntu 22.04 LTS | 2025-05 | 升级至最新稳定版 |
| ~~2.50.0-22.04~~ | Prometheus 2.50.0 基于 Ubuntu 22.04 LTS | 2025-05 | 升级至最新稳定版 |
| ~~2.45.0-22.04~~ | Prometheus 2.45.0 基于 Ubuntu 22.04 LTS | 2024-10 | 升级至最新稳定版 |
| ~~2.48.0-22.04~~ | Prometheus 2.48.0 基于 Ubuntu 22.04 LTS | 2025-05 | 升级至最新稳定版 |
| ~~2.52.0-22.04~~ | Prometheus 2.52.0 基于 Ubuntu 22.04 LTS | 2025-05 | 升级至最新稳定版 |
| _`track`_ | | | |  

*注：标记“持续支持”的已弃用标签虽未停止维护，但建议优先使用带`_stable`后缀的稳定通道。
