---
image: prom/prometheus
description: "Prometheus（简称Prom）是一款开源的监控与告警系统，由SoundCloud发起，现为云原生计算基金会（CNCF）毕业项目，采用时序数据库存储监控指标，支持多维度数据模型和PromQL查询语言，可通过静态配置或动态服务发现机制采集数据，并能基于自定义规则触发告警，广泛集成于Kubernetes等云原生环境，为分布式系统提供可靠的性能监控与问题诊断能力。"
source: https://xuanyuan.cloud/zh/r/prom/prometheus
canonical: https://xuanyuan.cloud/zh/r/prom/prometheus
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/prom/prometheus" title="prom/prometheus Docker 镜像中文简介、标签列表与拉取命令">prom/prometheus 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Prometheus


访问 [prometheus.io]  可获取完整文档、示例及指南。


## 项目概述

Prometheus 是 [Cloud Native Computing Foundation] （CNCF）旗下项目，专注于系统和服务监控。它通过配置的目标定期收集指标，评估规则表达式，展示结果，并能在满足特定条件时触发告警。


## 核心特点

- **多维度数据模型**：时间序列由指标名称和一组键值维度定义。  
- **PromQL 查询语言**：强大灵活，可充分利用数据的维度特性。  
- **独立部署能力**：无需依赖分布式存储，单节点即可自主运行。  
- **HTTP 拉取模式**：通过拉取方式收集时间序列数据。  
- **支持推送模式**：通过中间网关支持批处理任务的时间序列推送。  
- **目标发现机制**：支持服务发现或静态配置两种方式发现监控目标。  
- **丰富的可视化支持**：提供多种图表和仪表盘展示模式。  
- **联邦能力**：支持层级和水平联邦部署。  


## 架构概览

项目提供架构图展示组件关系（可参考官方文档中的架构示意图）。


## 安装指南

### 预编译二进制文件

已发布版本的预编译二进制文件可在 [prometheus.io 的下载页面]  获取。推荐使用最新的生产版本二进制文件进行安装，具体步骤可参考文档中的 [安装章节] 。


### Docker 镜像

Docker 镜像托管在 [Quay.io]  或 [Docker Hub] 。  
快速启动 Prometheus 容器进行试用：  
```bash
docker run --name prometheus -d -p 127.0.0.1:9090:9090 docker.xuanyuan.run/prom/prometheus
```  
启动后可通过 <[]> 访问 Prometheus。


### 从源码构建

#### 依赖要求
- Go：版本需不低于 [go.mod](./go.mod) 中指定的版本。  
- NodeJS：版本需不低于 [.nvmrc](./web/ui/.nvmrc) 中指定的版本。  
- npm：版本 8 及以上（可通过 `npm --version` 检查，安装参考 [npm 官网] ）。

#### 构建步骤
1. 克隆仓库：  
   ```bash
   git clone []   cd prometheus
   ```  

2. 使用 `go install` 构建（需从仓库根目录运行）：  
   ```bash
   GO111MODULE=on go install github.com/prometheus/prometheus/cmd/...
   prometheus --config.file=your_config.yml
   ```  
   > 注意：此方式需确保 `web/ui/static` 和 `web/ui/templates` 目录下的前端资源存在，且未包含 React UI（需通过 `make assets` 或 `make build` 显式构建）。

3. 使用 `make build` 构建（内置前端资源，可随处运行）：  
   ```bash
   make build
   ./prometheus --config.file=your_config.yml
   ```  

#### Makefile 目标说明
- `build`：构建 `prometheus` 和 `promtool` 二进制文件（含前端资源编译）。  
- `test`：运行所有测试。  
- `test-short`：运行简短测试。  
- `format`：格式化源代码。  
- `vet`：检查代码常见错误。  
- `assets`：构建 React UI。


### 服务发现插件

Prometheus 内置多种服务发现插件。从源码构建时，可编辑 [plugins.yml](./plugins.yml) 文件（YAML 格式的 Go 导入路径列表）禁用不需要的插件，修改后需重新执行 `make build`。  
若需添加第三方插件（暂不推荐），需额外调整 `go.mod` 和 `go.sum` 文件。


## 作为 Go 库使用

### Remote Write
Remote Write 的 Protobuf 定义独立发布于 [buf.build] ，可通过以下命令获取（实验性功能）：  
```shell
go get buf.build/gen/go/prometheus/prometheus/protocolbuffers/go@latest
```

### 版本对应关系
Prometheus 版本号与 Go 模块版本遵循以下规则：  
- **v3.y.z 版本**：对应 Go 模块标签 `v0.3y.z`（y 为两位数，不足补零，如 v3.0.0 对应 `v0.300.0`）。  
  示例：安装 v3.0.0 作为库：  
  ```shell
  go get github.com/prometheus/prometheus@v0.300.0
  ```  
- **v2.y.z 版本**：对应 Go 模块标签 `v0.y.z`。  
  示例：安装 v2.35.0 作为库：  
  ```shell
  go get github.com/prometheus/prometheus@v0.35.0
  ```  


## React UI 开发

关于 React 前端的构建、运行及开发详情，可参考 React 应用的 [README.md](web/ui/README.md)。


## 更多信息
- Go 文档：通过 [pkg.go.dev]  查看（v3.y.z 显示为 `v0.3y.z`，v2.y.z 显示为 `v0.y.z`）。  
- 社区支持：访问 [社区页面]  获取开发者和用户交流渠道。


## 贡献指南

参考 [CONTRIBUTING.md] 。


## 许可协议

采用 Apache License 2.0，详见 [LICENSE] 。
