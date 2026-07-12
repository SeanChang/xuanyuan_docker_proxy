---
image: webdevops/azure-devops-exporter
description: "Azure DevOps (VSTS)的Prometheus exporter，用于收集项目、构建（含构建时间和队列等待时间）、代理池利用率及活动拉取请求等指标。"
source: https://xuanyuan.cloud/zh/r/webdevops/azure-devops-exporter
canonical: https://xuanyuan.cloud/zh/r/webdevops/azure-devops-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/webdevops/azure-devops-exporter" title="webdevops/azure-devops-exporter Docker 镜像中文简介、标签列表与拉取命令">webdevops/azure-devops-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Azure DevOps Exporter (VSTS)

## 镜像概述

Azure DevOps Exporter是一个Prometheus exporter，用于从Azure DevOps (VSTS)收集指标，包括项目、构建、构建时间（耗时和队列等待时间）、代理池利用率及活动拉取请求等数据，帮助监控Azure DevOps环境的性能和活动状态。

## 核心功能与特性

- **多类型指标收集**：支持项目、构建、发布、部署、代理池、拉取请求、资源使用等多种指标
- **可配置的抓取时间**：为不同类型的指标设置独立的抓取频率，平衡监控精度与资源消耗
- **灵活的项目与代理池过滤**：支持通过白名单/黑名单筛选需要监控的项目和代理池
- **资源使用限制**：可配置并发请求数、重试次数及数据查询范围（如构建/发布历史时间范围）
- **详细的状态监控**：包括构建状态、发布环境状态、代理状态、拉取请求状态等

## 使用场景与适用范围

- DevOps团队监控CI/CD流水线性能（构建耗时、队列等待时间、成功率）
- SRE团队监控代理池资源利用率（代理数量、队列长度、活跃任务）
- 项目管理者跟踪项目活动（活跃拉取请求、代码仓库统计、发布频率）
- 需要将Azure DevOps数据集成到Prometheus+Grafana监控系统的场景

## 配置说明

### 命令行选项与环境变量

| 选项 | 环境变量 | 默认值 | 描述 |
|------|----------|--------|------|
| `--debug` | `DEBUG` | - | 启用调试模式 |
| `-v, --verbose` | `VERBOSE` | - | 启用详细日志模式 |
| `--log.json` | `LOG_JSON` | - | 切换日志输出为JSON格式 |
| `--scrape.time` | `SCRAPE_TIME` | `30m` | 默认抓取时间（duration格式） |
| `--scrape.time.projects` | `SCRAPE_TIME_PROJECTS` | - | 项目指标抓取时间 |
| `--scrape.time.repository` | `SCRAPE_TIME_REPOSITORY` | - | 仓库指标抓取时间 |
| `--scrape.time.build` | `SCRAPE_TIME_BUILD` | - | 构建指标抓取时间 |
| `--scrape.time.release` | `SCRAPE_TIME_RELEASE` | - | 发布指标抓取时间 |
| `--scrape.time.deployment` | `SCRAPE_TIME_DEPLOYMENT` | - | 部署指标抓取时间 |
| `--scrape.time.pullrequest` | `SCRAPE_TIME_PULLREQUEST` | - | 拉取请求指标抓取时间 |
| `--scrape.time.stats` | `SCRAPE_TIME_STATS` | - | 统计指标抓取时间 |
| `--scrape.time.resourceusage` | `SCRAPE_TIME_RESOURCEUSAGE` | - | 资源使用指标抓取时间 |
| `--scrape.time.query` | `SCRAPE_TIME_QUERY` | - | 查询结果抓取时间 |
| `--scrape.time.live` | `SCRAPE_TIME_LIVE` | `30s` | 实时指标抓取时间 |
| `--stats.summary.maxage` | `STATS_SUMMARY_MAX_AGE` | - | 统计摘要指标最大保留时间 |
| `--azuredevops.url` | `AZURE_DEVOPS_URL` | - | Azure DevOps URL（微软托管版留空） |
| `--azuredevops.access-token` | `AZURE_DEVOPS_ACCESS_TOKEN` | - | Azure DevOps访问令牌 |
| `--azuredevops.organisation` | `AZURE_DEVOPS_ORGANISATION` | - | Azure DevOps组织名称 |
| `--azuredevops.apiversion` | `AZURE_DEVOPS_APIVERSION` | `5.1` | Azure DevOps API版本 |
| `--whitelist.project` | `AZURE_DEVOPS_FILTER_PROJECT` | - | 项目白名单（UUIDs） |
| `--blacklist.project` | `AZURE_DEVOPS_BLACKLIST_PROJECT` | - | 项目黑名单（UUIDs） |
| `--whitelist.agentpool` | `AZURE_DEVOPS_FILTER_AGENTPOOL` | - | 代理池白名单（IDs） |
| `--list.query` | `AZURE_DEVOPS_QUERIES` | - | 查询与项目UUID对，格式：`<queryId>@<projectId>` |
| `--request.concurrency` | `REQUEST_CONCURRENCY` | `10` | 并发请求数 |
| `--request.retries` | `REQUEST_RETRIES` | `3` | 请求重试次数 |
| `--limit.project` | `LIMIT_PROJECT` | `100` | 项目数量限制 |
| `--limit.builds-per-project` | `LIMIT_BUILDS_PER_PROJECT` | `100` | 每个项目的构建数量限制 |
| `--limit.builds-per-definition` | `LIMIT_BUILDS_PER_DEFINITION` | `10` | 每个构建定义的构建数量限制 |
| `--limit.releases-per-project` | `LIMIT_RELEASES_PER_PROJECT` | `100` | 每个项目的发布数量限制 |
| `--limit.releases-per-definition` | `LIMIT_RELEASES_PER_DEFINITION` | `100` | 每个发布定义的发布数量限制 |
| `--limit.deployments-per-definition` | `LIMIT_DEPLOYMENTS_PER_DEFINITION` | `100` | 每个定义的部署数量限制 |
| `--limit.releasedefinitions-per-project` | `LIMIT_RELEASEDEFINITION_PER_PROJECT` | `100` | 每个项目的发布定义数量限制 |
| `--limit.build-history-duration` | `LIMIT_BUILD_HISTORY_DURATION` | `48h` | 构建历史查询时间范围 |
| `--limit.release-history-duration` | `LIMIT_RELEASE_HISTORY_DURATION` | `48h` | 发布历史查询时间范围 |
| `--bind` | `SERVER_BIND` | `:8080` | 服务绑定地址 |

## 指标说明

| 指标名称 | 抓取器 | 描述 |
|----------|--------|------|
| `azure_devops_stats` | live | 通用抓取器统计信息 |
| `azure_devops_agentpool_info` | live | 代理池基本信息 |
| `azure_devops_agentpool_size` | live | 每个代理池的代理数量 |
| `azure_devops_agentpool_queue_length` | live | 每个代理池的队列长度 |
| `azure_devops_agentpool_agent_info` | live | 每个代理池的代理详细信息 |
| `azure_devops_agentpool_agent_status` | live | 代理状态信息（如创建时间） |
| `azure_devops_agentpool_agent_job` | live | 每个代理上当前运行的任务 |
| `azure_devops_project_info` | live/projects | 项目基本信息 |
| `azure_devops_build_latest_info` | live | 最新构建信息 |
| `azure_devops_build_latest_status` | live | 最新构建状态信息 |
| `azure_devops_pullrequest_info` | pullrequest | 活跃拉取请求信息 |
| `azure_devops_pullrequest_status` | pullrequest | 活跃拉取请求状态信息（如创建时间） |
| `azure_devops_pullrequest_label` | pullrequest | 活跃拉取请求的标签 |
| `azure_devops_build_info` | build | 构建详细信息 |
| `azure_devops_build_status` | build | 构建状态信息（排队、开始、完成时间） |
| `azure_devops_build_definition_info` | build | 构建定义信息 |
| `azure_devops_release_info` | release | 发布详细信息 |
| `azure_devops_release_artifact` | release | 发布工件信息 |
| `azure_devops_release_environment` | release | 发布环境列表 |
| `azure_devops_release_environment_status` | release | 发布环境状态信息 |
| `azure_devops_release_approval` | release | 发布环境审批列表 |
| `azure_devops_release_definition_info` | release | 发布定义信息 |
| `azure_devops_release_definition_environment` | release | 发布定义环境列表 |
| `azure_devops_repository_info` | repository | 仓库基本信息 |
| `azure_devops_repository_stats` | repository | 仓库统计信息 |
| `azure_devops_repository_commits` | repository | 仓库提交计数器 |
| `azure_devops_repository_pushes` | repository | 仓库推送计数器 |
| `azure_devops_query_result` | live | 指定查询的最新结果 |
| `azure_devops_deployment_info` | deployment | 发布部署详细信息 |
| `azure_devops_deployment_status` | deployment | 发布部署状态信息 |
| `azure_devops_stats_agentpool_builds` | stats | 按代理池、项目和结果统计的构建数量（计数器） |
| `azure_devops_stats_agentpool_builds_wait` | stats | 按代理池、项目和结果统计的构建等待时间（摘要） |
| `azure_devops_stats_agentpool_builds_duration` | stats | 按代理池、项目和结果统计的构建持续时间（摘要） |
| `azure_devops_stats_project_builds` | stats | 按项目、定义和结果统计的构建数量（计数器） |
| `azure_devops_stats_project_builds_wait` | stats | 按项目、定义和结果统计的构建等待时间（摘要） |
| `azure_devops_stats_project_builds_success` | stats | 按项目和定义统计的构建成功率（摘要） |
| `azure_devops_stats_project_builds_duration` | stats | 按项目、定义和结果统计的构建持续时间（摘要） |
| `azure_devops_stats_project_release_duration` | stats | 按项目、定义、环境和结果统计的发布环境持续时间（摘要） |
| `azure_devops_stats_project_release_success` | stats | 按项目、定义和环境统计的发布环境成功率（摘要） |
| `azure_devops_resourceusage_build` | resourceusage | Azure DevOps构建资源使用情况（付费/受限资源） |
| `azure_devops_resourceusage_license` | resourceusage | Azure DevOps许可证资源使用情况（付费/受限资源） |

## 使用示例

### Docker Run 命令

```bash
docker run -d \
  --name azure-devops-exporter \
  -p 8080:8080 \
  -e AZURE_DEVOPS_ACCESS_TOKEN="your-access-token" \
  -e AZURE_DEVOPS_ORGANISATION="your-organisation" \
  -e SCRAPE_TIME_LIVE="30s" \
  -e LIMIT_BUILD_HISTORY_DURATION="72h" \
  docker.xuanyuan.run/webdevops/azure-devops-exporter
```

### Docker Compose 配置

```yaml
version: '3'
services:
  azure-devops-exporter:
    image: docker.xuanyuan.run/webdevops/azure-devops-exporter
    ports:
      - "8080:8080"
    environment:
      - AZURE_DEVOPS_ACCESS_TOKEN=your-access-token
      - AZURE_DEVOPS_ORGANISATION=your-organisation
      - SCRAPE_TIME=30m
      - SCRAPE_TIME_LIVE=30s
      - LIMIT_BUILD_HISTORY_DURATION=72h
      - WHITELIST_PROJECT=project-uuid-1,project-uuid-2
    restart: always
```

## Prometheus查询示例

### 单个项目每个定义的最近3次失败发布

```promql
topk by(projectID,releaseDefinitionName,path) (3,
  azure_devops_release_environment{projectID="XXXXXXXXXXXXXXXX", status!="succeeded", status!="inProgress"}
  * on (projectID,releaseID,environmentID) group_left() (azure_devops_release_environment_status{type="created"})
  * on (projectID,releaseID) group_left(releaseName, releaseDefinitionID) (azure_devops_release_info)
  * on (projectID,releaseDefinitionID) group_left(path, releaseDefinitionName) (azure_devops_release_definition_info)
)
```

### 代理池使用率（排除PoolMaintenance任务）

```promql
count by(agentPoolID) (
  azure_devops_agentpool_agent_job{planType!="PoolMaintenance"}
  * on(agentPoolAgentID) group_left(agentPoolID) (azure_devops_agentpool_agent_info)
)
/ on (agentPoolID) group_left() (azure_devops_agentpool_size)
* on (agentPoolID) group_left(agentPoolName) (azure_devops_agentpool_info)
```

### 当前运行的任务

```promql
label_replace(
    azure_devops_agentpool_agent_job{planType!="PoolMaintenance"}
    * on (agentPoolAgentID) group_left(agentPoolID,agentPoolAgentName) azure_devops_agentpool_agent_info
    * on (agentPoolID) group_left(agentPoolName) (azure_devops_agentpool_info)
  , "projectID", "$1", "scopeID", "^(.+)$"
)
* on (projectID) group_left(projectName) (azure_devops_project_info)
```

### 代理池规模

```promql
azure_devops_agentpool_info
* on (agentPoolID) group_left() (azure_devops_agentpool_size)
```

### 代理池规模（启用且在线的代理）

```promql
azure_devops_agentpool_info
* on (agentPoolID) group_left() (
  count by(agentPoolID) (azure_devops_agentpool_agent_info{status="online",enabled="true"})
)
