---
image: apache/dolphinscheduler
description: "Apache DolphinScheduler是一个分布式、可扩展的工作流调度平台，提供强大的DAG可视化界面，致力于解决数据管道中的复杂作业依赖，支持多种任务类型开箱即用。"
source: https://xuanyuan.cloud/zh/r/apache/dolphinscheduler
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[apache/dolphinscheduler](https://xuanyuan.cloud/zh/r/apache/dolphinscheduler)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Apache DolphinScheduler Docker镜像文档

## 镜像概述和主要用途

**注意**：该Docker仓库自3.0.0起已弃用，请使用以下仓库：
- https://hub.docker.com/repository/docker/apache/dolphinscheduler-standalone-server
- https://hub.docker.com/repository/docker/apache/dolphinscheduler-api
- https://hub.docker.com/repository/docker/apache/dolphinscheduler-master
- https://hub.docker.com/repository/docker/apache/dolphinscheduler-worker
- https://hub.docker.com/repository/docker/apache/dolphinscheduler-alert-server
- https://hub.docker.com/repository/docker/apache/dolphinscheduler-tools

Apache DolphinScheduler（孵化中）是一个分布式、可扩展的工作流调度平台，具有强大的DAG可视化界面。它致力于解决数据管道中的复杂作业依赖问题，使多种类型的任务能够开箱即用。

## 核心功能和特性

### 主要特性
- 基于任务依赖关系以DAG图关联任务，可实时可视化任务运行状态
- 支持多种任务类型：Shell、MR、Spark、SQL（MySQL、PostgreSQL、Hive、Spark SQL）、Python、Sub_Process、Procedure等
- 支持流程调度、依赖调度、手动调度，支持手动暂停/停止/恢复，支持失败重试/告警，支持从指定节点恢复，支持终止任务等
- 支持流程和任务优先级、任务故障转移、任务超时告警或失败
- 支持流程全局参数和节点自定义参数设置
- 支持资源文件在线上传/下载、管理等，支持在线文件创建和编辑
- 支持任务日志在线查看和滚动、在线下载日志等
- 通过Zookeeper实现集群HA，Master集群和Worker集群去中心化
- 支持查看Master/Worker的CPU负载、内存和CPU使用率指标
- 支持工作流历史的树状图或甘特图展示，以及每个工作流中任务和流程状态的统计结果
- 支持数据回填
- 支持多租户
- 支持国际化
- 更多功能等待探索...

### 功能对比
| 稳定性 | 易用性 | 功能 | 可扩展性 |
|--------|--------|------|----------|
| 去中心化多Master和多Worker | 可视化流程定义，任务状态、类型、重试次数、运行机器、变量等关键信息一目了然 | 支持暂停、恢复操作 | 支持自定义任务类型 |
| 原生支持HA | 全流程定义操作可视化，拖拽任务绘制DAG，配置数据源和资源；同时为第三方系统提供API模式操作 | 支持租户与Hadoop用户的多对一或一对一映射，对大数据作业调度至关重要 | 调度器采用分布式调度，整体调度能力随集群规模线性增长，Master和Worker支持动态上下线 |
| 过载处理：通过任务队列机制，可灵活配置单机能调度的任务数量，任务队列缓存容量高容错，避免机器卡顿 | 一键部署 | 支持传统Shell任务及大数据平台任务调度（MR、Spark、SQL等） |  |

## 使用场景和适用范围

适用于需要管理和调度复杂数据处理流程的场景，特别是：
- 数据管道中存在复杂作业依赖关系的场景
- 需要可视化监控工作流运行状态的需求
- 需支持多种任务类型（如Shell、Spark、SQL等）统一调度的场景
- 要求高可用性和可扩展性的企业级工作流调度需求
- 多租户环境下的工作流隔离与管理

## 使用方法和配置说明

### Docker部署
> **注意**：当前仓库已弃用，建议使用3.0.0及以上版本的官方镜像（见概述中的新仓库链接）。

Docker部署请参考官方文档：[Docker部署指南](https://dolphinscheduler.apache.org/en-us/docs/latest/user_doc/docker-deployment.html)

## 用户界面

提供直观的可视化界面，包括但不限于：
- 工作流列表页
- DAG图编辑界面
- 任务日志在线查看
- 资源文件管理界面
- 集群监控界面
- 工作流历史树状图/Gantt图展示

## 贡献与支持

### 如何贡献
欢迎参与贡献，详情请参考：[贡献指南](https://dolphinscheduler.apache.org/en-us/community/development/contribute.html)

### 获取帮助
1. 在GitHub提交issue
2. 订阅邮件列表：[邮件订阅](https://dolphinscheduler.apache.org/en-us/community/development/subscribe.html)
3. Twitter：[@dolphinschedule](https://twitter.com/dolphinschedule)
4. Slack：[ASF DolphinScheduler Slack](https://asf-dolphinscheduler.slack.com)

## 官方资源

- 官方网站：[dolphinscheduler.apache.org](https://dolphinscheduler.apache.org)
