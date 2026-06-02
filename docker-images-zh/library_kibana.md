---
image: library/kibana
description: "Kibana作为Elastic Stack的核心组件，能够将Elasticsearch中索引的各类数据——包括结构化数据（如交易记录、系统指标、用户行为日志）和非结构化数据（如文本文档、邮件内容、社交媒体评论）——进行整合、处理、分析与可视化，它通过提供多样化的可视化组件（如折线图、柱状图、热力图、仪表盘、地理空间地图等）、灵活的查询工具和交互式探索功能，将复杂分散的数据转化为具有清晰逻辑结构和实用洞察的直观内容，帮助用户深入理解数据模式、实时监控业务动态、快速发现潜在问题，并基于数据驱动做出明智决策，从而充分释放Elasticsearch索引数据的价值。"
source: https://xuanyuan.cloud/zh/r/library/kibana
canonical: https://xuanyuan.cloud/zh/r/library/kibana
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/kibana" title="library/kibana Docker 镜像中文简介、标签列表与拉取命令">library/kibana 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Kibana Docker镜像介绍


### 快速参考  
- **维护方**：[Elastic团队]([])  
- **获取帮助**：可通过 [Kibana Discuss论坛]([]) 或 [Elastic社区]([]) 获取支持  


### 支持的标签及对应Dockerfile链接  
以下是当前支持的Kibana Docker镜像标签，及对应的Dockerfile源码链接：  
- [`7.17.29`]([])  
- [`8.17.10`]([])  
- [`8.18.8`]([])  
- [`8.19.5`]([])  
- [`9.0.8`]([])  
- [`9.1.5`]([])  


### 快速参考（续）  
- **问题反馈**：若镜像或Kibana本身存在问题，可提交至 [GitHub Issues]([])  
- **支持架构**：  
  - [`amd64`]([])  
  - [`arm64v8`]([])  
  （更多架构信息可参考 [官方说明]([])）  
- **镜像详情**：包括元数据、传输大小等，可查看 [repo-info仓库的`kibana`目录]([])（含 [历史记录]([])）  
- **镜像更新**：可关注 [official-images仓库的`library/kibana`标签]([]) 或 [文件历史]([])  
- **描述来源**：本文档内容源自 [docs仓库的`kibana`目录]([])（含 [历史记录]([])）  


### 关于Kibana  
Kibana是一款开源的分析与可视化平台，专为Elasticsearch设计。用户可通过Kibana搜索、查看并交互Elasticsearch索引中的数据，轻松进行高级数据分析，并以图表、表格、地图等多种形式可视化数据。  
更多信息可访问 [Elastic官网产品页]([])。  


### 关于本镜像  
- 本默认发行版受Elastic License管辖，包含 [全套免费功能]([])。  
- 详细发行说明可查看 [官方文档]([])。  
- 如需其他版本，可访问 [docker.elastic.co]([])。  


### 使用指南  
#### 注意事项  
- 拉取镜像时需指定具体版本标签，不支持`latest`标签。  
- 对于6.4.0之前的版本，镜像、标签及文档可参考 [docker.elastic.co]([])。  
- 完整使用文档见 [Kibana官方指南]([])。  

#### 开发模式  
以下示例中，Kibana将连接到用户定义的网络（便于与Elasticsearch等服务通信）。若网络未创建，需先执行：  
```console
$ docker network create somenetwork
```  
（注：示例中Kibana使用默认配置，需连接本地运行的Elasticsearch实例（[]  

启动Kibana容器：  
```console
$ docker run -d --name kibana --net somenetwork -p 5601:5601 kibana:tag
```  
（参数说明：`-d`后台运行，`--name`指定容器名，`--net`绑定网络，`-p`映射端口5601）  

访问方式：通过浏览器访问 `[] 或 `[]  

#### 生产模式  
生产环境下的配置与运行指南，建议参考官方文档 [《在Docker上运行Kibana》]([])。  


### 许可证信息  
- 本镜像包含的软件许可证信息可查看 [ELASTIC-LICENSE-2.0.txt]([])。  
- 镜像可能包含基础系统或依赖软件，其许可证信息可参考 [repo-info仓库的`kibana`目录]([]) 中的自动检测结果。  
- 使用本镜像时，用户需自行确保符合所有包含软件的许可证要求。
