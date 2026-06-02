---
image: opensearchproject/opensearch-dashboards
description: "OpenSearch Dashboards（官网：[]"
source: https://xuanyuan.cloud/zh/r/opensearchproject/opensearch-dashboards
canonical: https://xuanyuan.cloud/zh/r/opensearchproject/opensearch-dashboards
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opensearchproject/opensearch-dashboards" title="opensearchproject/opensearch-dashboards Docker 镜像中文简介、标签列表与拉取命令">opensearchproject/opensearch-dashboards — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/opensearchproject/opensearch-dashboards" title="opensearchproject/opensearch-dashboards Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/opensearchproject/opensearch-dashboards</a>

# OpenSearch Dashboards 镜像使用指南


## 快速参考  
- **维护方**：[OpenSearch 团队]([])  
- **寻求帮助**：在 [社区论坛]([]) 提问或交流  
- **反馈问题**：通过 [issue 跟踪器]([]) 报告构建或 Docker 镜像相关问题  


## 关于 OpenSearch  
OpenSearch 是一套可扩展、灵活且功能丰富的开源软件套件，适用于搜索、分析和可观测性应用。它衍生自 Elasticsearch 7.10.2 和 Kibana 7.10.2，采用 [Apache 2.0 许可证]([]) 授权。套件包含两部分：搜索引擎守护进程（OpenSearch）和用于数据管理与可视化的用户界面（OpenSearch Dashboards）。  


## 如何拉取镜像  
拉取 OpenSearch Dashboards 镜像的方式与其他 Docker 镜像一致，执行以下命令即可：  
```bash
docker pull opensearchproject/opensearch-dashboards:latest
```  

所有可用版本可在 [Docker Hub]([]) 查看。  

> **注意**：  
> - 1.x 版本及 2.x 版本中 2.9.0 及之前的镜像，基于 [Amazon Linux 2]([]) 构建；  
> - 2.10.0 及之后的版本，基于 [Amazon Linux 2023]([]) 构建。  
> - 若使用 [Docker Desktop]([])，建议配置至少 4GB 系统内存。  


## 如何使用镜像  
OpenSearch Dashboards 依赖运行中的 OpenSearch 集群。若已有集群，可直接部署 Dashboards 节点并接入集群。关于配置细节，可参考 [OpenSearch Dashboards 快速入门]([])。  


## 启动 OpenSearch 集群  
若需从零开始搭建 OpenSearch 集群，推荐使用 [Docker Compose]([])。  


### 步骤 1：安装 Docker Compose  
- 若已安装 [Docker Desktop]([])，则 Docker Compose 已内置，可直接使用 `docker compose` 命令；  
- 若未安装，可通过 Python 的包管理工具 `pip` 安装（需先确保环境中已安装 Python）：  
  ```bash
  pip install docker-compose
  ```  


### 步骤 2：定义集群配置  
创建 `docker-compose.yml` 文件定义集群。OpenSearch 项目提供了示例配置文件，可从 [docker-compose.yml 示例库]([]) 获取。  


### 步骤 3：启动/停止集群  
1. **启动集群**：进入 `docker-compose.yml` 所在目录，执行以下命令（`-d` 选项表示后台运行容器）：  
   ```bash
   docker-compose up -d
   ```  

2. **停止集群**：  
   ```bash
   docker-compose down
   ```  

3. **停止并删除数据卷**（如需清理集群数据）：  
   ```bash
   docker-compose down -v
   ```  


## 开始使用 OpenSearch Dashboards  
集群启动后，Docker 会自动创建 OpenSearch 和 OpenSearch Dashboards 容器。待容器运行稳定后，在本地浏览器访问 `[] Dashboards 界面。默认登录信息：  
- 用户名：`admin`  
- 密码：`admin`  

如需深入了解功能，可参考 [OpenSearch Dashboards 快速入门]([])。  


## 许可证说明  
OpenSearch 及其包含的插件均采用 [Apache License, Version 2.0]([]) 授权。  


## 如何贡献  
OpenSearch 始终保持 100% 开源（基于 Apache 2.0 许可证）。我们欢迎社区参与贡献，无需签署冗长的贡献者协议，可直接通过代码提交参与项目改进。更多详情见 [OpenSearch 官网]([])。
