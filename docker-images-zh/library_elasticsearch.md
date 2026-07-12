---
image: library/elasticsearch
description: "Elasticsearch是一款功能强大的开源搜索与分析引擎，它基于Lucene构建，具备分布式、高扩展、实时处理的特性，能够高效存储、检索和分析各类结构化与非结构化数据，广泛应用于日志分析、全文搜索、业务智能等场景，通过简化数据探索流程，帮助用户快速从海量数据中获取有价值的洞察，让复杂数据的分析与利用变得简单高效。"
source: https://xuanyuan.cloud/zh/r/library/elasticsearch
canonical: https://xuanyuan.cloud/zh/r/library/elasticsearch
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/elasticsearch" title="library/elasticsearch Docker 镜像中文简介、标签列表与拉取命令">library/elasticsearch 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Elasticsearch Docker镜像使用指南


## 一、快速参考信息

### 维护者  
由[Elastic团队] 维护。


### 获取帮助渠道  
- Elasticsearch Discuss论坛：[[]]   
- Elastic社区：[[]]   


## 二、支持的标签及对应Dockerfile链接  
以下是当前支持的Elasticsearch Docker镜像标签，及对应Dockerfile的GitHub链接：  
- `8.17.10`：[Dockerfile]   
- `8.18.8`：[Dockerfile]   
- `8.19.5`：[Dockerfile]   
- `9.0.8`：[Dockerfile]   
- `9.1.5`：[Dockerfile]   


## 三、补充参考信息  

### 问题反馈  
- 若遇到Elasticsearch Docker镜像或Elasticsearch本身的问题，可在GitHub提交：[[]]   


### 支持的架构  
- `amd64`：[镜像地址]   
- `arm64v8`：[镜像地址]   
（架构说明：[详见Docker官方文档] ）  


### 镜像制品详情  
- 包含镜像元数据、传输大小等信息，可查看：[repo-info仓库的elasticsearch目录] （含[历史记录] ）  


### 镜像更新  
- 关注标签：[official-images仓库的library/elasticsearch标签]   
- 配置文件及历史：[official-images仓库的library/elasticsearch文件] （含[历史记录] ）  


### 描述来源  
本文档基于[docs仓库的elasticsearch目录] （含[历史记录] ）整理。  


## 四、关于Elasticsearch  
Elasticsearch是一款分布式RESTful搜索分析引擎，可支持多种场景需求。作为Elastic Stack的核心，它能集中存储数据，帮助用户发现已知信息、挖掘潜在规律。  
了解更多：[Elasticsearch官方产品页]   


## 五、关于此镜像  
- 许可证：默认分发版本遵循Elastic License，包含[完整免费功能集] 。  
- 版本说明：若需其他版本，可访问[docker.elastic.co] 查询历史版本。  
- 发布说明：详细版本信息见[Elasticsearch官方发布 notes] 。  


## 六、使用方法  

### 注意  
拉取镜像需使用特定版本号标签，不支持`latest`标签。6.4.0之前版本的镜像、标签及文档，可访问[docker.elastic.co] 查询。完整文档见[Elasticsearch官方指南] 。  


### 开发模式部署  

#### 步骤1：创建用户自定义网络  
（便于连接其他服务，如Kibana）  
```console
$ docker network create somenetwork
```

#### 步骤2：启动Elasticsearch  
```console
$ docker run -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:tag
```  
（将`tag`替换为具体版本，如`8.19.5`）  


### 生产模式部署  
生产环境部署请参考官方文档：[Install Elasticsearch with Docker]   


## 七、许可证信息  

### 软件许可证  
镜像中Elasticsearch的许可证信息：[ELASTIC-LICENSE-2.0]   

### 其他说明  
Docker镜像可能包含基础系统（如Bash等）及依赖软件，这些软件可能采用其他许可证。部分自动检测的许可证信息可参考[repo-info仓库的elasticsearch目录] 。  

使用前请确保遵守所有包含软件的相关许可证要求，用户需自行承担合规责任。
