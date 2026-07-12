---
image: library/sonarqube
description: "SonarQube的官方镜像是一款专注于代码质量与安全的代码分析工具，其核心功能包括对代码进行全面扫描、精准检测潜在缺陷、有效识别安全漏洞及科学评估代码质量指标，能帮助开发团队在软件开发流程中及时发现并修复问题，从而显著提升软件产品的可靠性与安全性，是开发过程中保障代码质量和安全的重要工具。"
source: https://xuanyuan.cloud/zh/r/library/sonarqube
canonical: https://xuanyuan.cloud/zh/r/library/sonarqube
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/sonarqube" title="library/sonarqube Docker 镜像中文简介、标签列表与拉取命令">library/sonarqube 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SonarQube Docker 镜像介绍


## 快速参考

- **维护者**：  
  [SonarSource] （官方仓库）

- **获取帮助**：  
  [SonarSource 社区论坛] 、[Docker 社区论坛] 、[Docker 社区 Slack]  或 [Stack Overflow] 


## 支持的标签及对应 Dockerfile 链接

以下是各版本镜像标签及其 Dockerfile 源码链接：

- **Developer 版**：  
  [`2025.5.0-developer`、`2025.5-developer`、`developer`]   
  [`2025.4.3-developer`、`2025.4-developer`]   
  [`2025.1.4-developer`、`2025.1-developer`、`2025-lta-developer`] 

- **Enterprise 版**：  
  [`2025.5.0-enterprise`、`2025.5-enterprise`、`enterprise`]   
  [`2025.4.3-enterprise`、`2025.4-enterprise`]   
  [`2025.1.4-enterprise`、`2025.1-enterprise`、`2025-lta-enterprise`] 

- **Data Center 版（应用节点）**：  
  [`2025.5.0-datacenter-app`、`2025.5-datacenter-app`、`datacenter-app`]   
  [`2025.4.3-datacenter-app`、`2025.4-datacenter-app`]   
  [`2025.1.4-datacenter-app`、`2025.1-datacenter-app`、`2025-lta-datacenter-app`] 

- **Data Center 版（搜索节点）**：  
  [`2025.5.0-datacenter-search`、`2025.5-datacenter-search`、`datacenter-search`]   
  [`2025.4.3-datacenter-search`、`2025.4-datacenter-search`]   
  [`2025.1.4-datacenter-search`、`2025.1-datacenter-search`、`2025-lta-datacenter-search`] 

- **Community Build 版**：  
  [`25.10.0.114319-community`、`community`、`latest`] 


## 快速参考（续）

- **提交问题**：  
  [[]] 

- **支持的架构**：  
  `amd64`（[详情] ）、`arm64v8`（[详情] ）

- **镜像工件详情**：  
  包含元数据、传输大小等，见 [repo-info 仓库的 `repos/sonarqube/` 目录] （[历史记录] ）

- **镜像更新**：  
  关注 [official-images 仓库的 `library/sonarqube` 标签]  或 [文件历史] 

- **描述来源**：  
  [docs 仓库的 `sonarqube/` 目录] （[历史记录] ）


## 什么是 SonarQube？

`sonarqube` Docker 仓库存储 SonarQube Server 和 SonarQube Community Build 的官方镜像。

**SonarQube Server**（前身为 SonarQube）是一款本地部署的代码分析工具，支持 30 多种语言、框架和 IaC 平台，可检测代码质量与安全问题。该工具还能借助 Sonar 的 AI CodeFix 功能提供修复建议，通过集成 CI 流水线或主流 DevOps 平台，在每次合并/拉取请求时检查代码的可维护性、可靠性、安全性等多维度问题。

**SonarQube Community Build**（前身为 SonarQube Community）是 Sonar 免费的自管理版本，每月更新，包含最新开源核心功能，支持 21 种编程语言和框架的基础分析（如 bug 检测、代码异味识别、基础安全问题分析）。如需高级安全分析、企业级集成和可扩展性功能，可选择商业版 SonarQube Server。


## 如何使用本镜像

以下是 SonarQube Server（Developer/Enterprise/Data Center 版）和 SonarQube Community Build 的 Docker 镜像使用指南。


### Docker 主机要求

由于 SonarQube 内置 Elasticsearch，Docker 主机需符合 [Elasticsearch 生产模式要求]  和 [文件描述符配置] 。

例如，在 Linux 主机上，可通过以下命令（需 root 权限）临时设置推荐值：

```console
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```


### 演示

如需快速运行演示实例，参考 [Try Out SonarQube]  页面的 Docker 使用说明。准备正式部署时，建议阅读下文的“安装”和“配置”章节。


### 安装

> **多平台支持**：从 SonarQube `9.9` LTS 开始，镜像支持 `amd64` 架构和基于 `arm64` 的 Apple Silicon（M1）。

安装步骤详见 [Install the Server]  页面的“从 Docker 镜像安装服务器”部分。

如需部署 Data Center 版集群，参考 [Install the Server as a Cluster]  页面的说明。

> 注意：Docker 镜像的 `lts` 标签会随新版本 LTS 发布而更新。如需避免自动升级主版本，建议使用具体版本标签（如 `9.9-<edition>`）而非 `lts-<edition>`。


### 配置

#### 端口绑定

容器内服务默认监听 9000 端口，可通过 `-p 9000:9000` 映射到主机端口。示例命令：

```console
docker run --name sonarqube-custom -p 9000:9000 docker.xuanyuan.run/sonarqube:community
```

启动后，通过 `[] 或 `[] 访问 Web 界面。


#### 数据库

默认使用嵌入式 H2 数据库，**不适合生产环境**。生产环境需单独配置数据库，具体步骤见 [Installing the Database] 。

> **警告**：仅允许一个 SonarQube 实例（Server 或 Community Build）连接同一数据库 schema。使用 Docker Swarm 或 Kubernetes 时，需确保多实例不会同时连接同一 schema，否则可能导致数据损坏（无内置防护，详见 [SONAR-10362] ）。Data Center 版集群同样限制一个集群对应一个数据库 schema。


#### 使用卷

建议为以下目录挂载卷，确保数据持久化和配置隔离：

- `/opt/sonarqube/data`：存储嵌入式 H2 数据库文件、Elasticsearch 索引等数据  
- `/opt/sonarqube/logs`：包含访问日志、Web 进程日志、CE 进程日志、Elasticsearch 日志  
- `/opt/sonarqube/extensions`：存放第三方插件  

> **警告**：不可在多个 SonarQube 实例间共享卷。


### 升级

升级步骤详见 [Upgrade the Server]  页面的“从 Docker 镜像升级”部分。


### 高级配置

#### 自定义镜像

如需预配置插件或配置，可构建自定义镜像。示例 Dockerfile：

```dockerfile
FROM docker.xuanyuan.run/sonarqube:community
COPY sonar-custom-plugin-1.0.jar /opt/sonarqube/extensions/
```

构建并运行：

```console
$ docker build --tag=sonarqube-custom .
$ docker run -ti sonarqube-custom
```


#### 避免硬终止

SonarQube 实例会优雅停止，等待进行中的任务完成，这可能耗时较长。Docker 默认停止容器的超时时间为 10 秒，超时未停止会强制终止进程。建议通过 `--stop-timeout` 设置更长超时（如 3600 秒）：

```console
docker run --stop-timeout 3600 sonarqube
```


### 管理

SonarQube 实例管理相关文档见 [Instance Administration] 。


## 许可证

- SonarQube Community Build 基于 [GNU Lesser General Public License, Version 3.0]  许可。  
- SonarQube Server Developer/Enterprise/Data Center 版基于 [SonarSource 条款]  许可。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如基础系统的 Bash 等），其许可证需用户自行确认合规性。

部分自动检测的许可证信息可在 [repo-info 仓库的 `sonarqube/` 目录]  查看。使用前，请确保遵守所有包含软件的相关许可证。
