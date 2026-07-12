---
image: wazuh/wazuh-manager
description: "Wazuh Manager Docker镜像为开源安全监控平台的核心组件，用于集中管理来自Agent和各类日志的安全数据，提供实时分析、入侵检测、漏洞扫描、合规性检查及多渠道告警能力。集成Web管理界面，支持可视化监控、规则配置与事件响应流程编排，容器化设计确保快速部署与环境一致性，适用于构建企业级威胁检测与安全运营中心（SOC）。"
source: https://xuanyuan.cloud/zh/r/wazuh/wazuh-manager
canonical: https://xuanyuan.cloud/zh/r/wazuh/wazuh-manager
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wazuh/wazuh-manager" title="wazuh/wazuh-manager Docker 镜像中文简介、标签列表与拉取命令">wazuh/wazuh-manager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Wazuh Docker容器


## 概述
本仓库提供Wazuh的Docker容器化部署资源，可运行Wazuh的核心组件，适用于快速搭建单节点或多节点监控环境。


## 容器组件说明
仓库包含以下三类容器，用于构建完整的Wazuh监控系统：

### Wazuh manager  
运行Wazuh管理器、Wazuh API及Filebeat OSS，负责日志收集、规则检测与告警生成。

### Wazuh dashboard  
提供Web用户界面，用于浏览告警数据、查看代理配置及运行状态。

### Wazuh indexer  
用于存储和索引告警数据，支持单节点集群或多节点集群部署。  
**注意**：部署前需调整主机的`vm.max_map_count`系统设置，具体方法见[Wazuh文档] 。


## 目录结构与功能
仓库核心目录及用途如下：  

- **build-docker-images**：包含构建Wazuh镜像的脚本、配置文件及Dockerfile，具体构建方法见该目录下的README。  
- **indexer-certs-creator**：证书生成工具及资源，用于创建Wazuh indexer所需的SSL证书，使用说明见目录内README。  
- **single-node**：单节点环境部署指南，包含1个manager、1个indexer和1个dashboard的配置文件及启动说明。  
- **multi-node**：多节点环境部署指南，包含2个manager、3个indexer和1个dashboard的集群配置及启动说明。  


## 环境准备
### SSL证书配置  
启动环境前，需提供SSL证书（正式证书或自签名证书）。  
生产环境部署的证书配置方法见[Wazuh Docker文档] 。


## 环境变量配置
以下为容器运行所需的环境变量，默认值已标注（如有）。


### Wazuh核心组件变量  

| 变量名 | 默认值 | 说明 |  
|--------|--------|------|  
| API_USERNAME | "wazuh-wui" | Wazuh API访问用户名 |  
| API_PASSWORD | "MyS3cr37P450r.*-" | Wazuh API密码，需满足复杂度要求（8位以上，包含大小写字母、特殊字符） |  
| INDEXER_URL | [] | Wazuh indexer服务地址 |  
| INDEXER_USERNAME | admin | Wazuh indexer访问用户名 |  
| INDEXER_PASSWORD | SecretPassword | Wazuh indexer访问密码 |  
| FILEBEAT_SSL_VERIFICATION_MODE | full | Filebeat SSL验证模式（full/none） |  
| SSL_CERTIFICATE_AUTHORITIES | "" | Filebeat SSL根证书路径 |  
| SSL_CERTIFICATE | "" | Filebeat SSL证书路径 |  
| SSL_KEY | "" | Filebeat SSL密钥路径 |  


### Wazuh dashboard变量  

| 变量名 | 默认值 | 说明 |  
|--------|--------|------|  
| PATTERN | "wazuh-alerts-*" | 默认索引模式 |  
| CHECKS_PATTERN | true | 健康检查是否验证索引模式（true/false） |  
| CHECKS_TEMPLATE | true | 健康检查是否验证索引模板（true/false） |  
| CHECKS_API | true | 健康检查是否验证API连接（true/false） |  
| CHECKS_SETUP | true | 健康检查是否验证初始化配置（true/false） |  
| EXTENSIONS_PCI | true | 是否启用PCI合规扩展 |  
| EXTENSIONS_GDPR | true | 是否启用GDPR合规扩展 |  
| EXTENSIONS_HIPAA | true | 是否启用HIPAA合规扩展 |  
| EXTENSIONS_NIST | true | 是否启用NIST合规扩展 |  
| EXTENSIONS_TSC | true | 是否启用TSC合规扩展 |  
| EXTENSIONS_AUDIT | true | 是否启用审计扩展 |  
| EXTENSIONS_OSCAP | false | 是否启用OpenSCAP扩展 |  
| EXTENSIONS_CISCAT | false | 是否启用CISCAT扩展 |  
| EXTENSIONS_AWS | false | 是否启用AWS扩展 |  
| EXTENSIONS_GCP | false | 是否启用GCP扩展 |  
| EXTENSIONS_VIRUSTOTAL | false | 是否启用Virustotal扩展 |  
| EXTENSIONS_OSQUERY | false | 是否启用OSQuery扩展 |  
| EXTENSIONS_DOCKER | false | 是否启用Docker扩展 |  
| APP_TIMEOUT | 20000 | Wazuh应用请求超时时间（毫秒） |  
| API_SELECTOR | true | 是否允许用户在界面切换API（true/false） |  
| IP_SELECTOR | true | 是否允许用户在界面切换索引模式（true/false） |  
| IP_IGNORE | "[]" | 需忽略的索引模式列表（JSON格式） |  
| DASHBOARD_USERNAME | kibanaserver | Dashboard密钥库存储的用户名 |  
| DASHBOARD_PASSWORD | kibanaserver | Dashboard密钥库存储的密码 |  
| WAZUH_MONITORING_ENABLED | true | 是否启用wazuh-monitoring索引 |  
| WAZUH_MONITORING_FREQUENCY | 900 | wazuh-monitoring索引的生成频率（秒） |  
| WAZUH_MONITORING_SHARDS | 2 | wazuh-monitoring索引的分片数 |  
| WAZUH_MONITORING_REPLICAS | 0 | wazuh-monitoring索引的副本数 |  


## 分支说明  
- **master分支**：包含最新开发代码，可能存在未稳定的功能或bug。  
- **stable分支**：对应Wazuh最新稳定版本，推荐生产环境使用。  


## 兼容性矩阵  

| Wazuh版本 | ODFE版本 | XPACK版本 |  
|-----------|----------|-----------|  
| v4.3.0+   | N/A      | N/A       |  
| v4.2.7    | 1.13.2   | 7.11.2    |  
| v4.2.6    | 1.13.2   | 7.11.2    |  
| v4.2.5    | 1.13.2   | 7.11.2    |  
| v4.2.4    | 1.13.2   | 7.11.2    |  
| v4.2.3    | 1.13.2   | 7.11.2    |  
| v4.2.2    | 1.13.2   | 7.11.2    |  
| v4.2.1    | 1.13.2   | 7.11.2    |  
| v4.2.0    | 1.13.2   | 7.10.2    |  
| v4.1.5    | 1.13.2   | 7.10.2    |  
| v4.1.4    | 1.12.0   | 7.10.2    |  
| v4.1.3    | 1.12.0   | 7.10.2    |  
| v4.1.2    | 1.12.0   | 7.10.2    |  
| v4.1.1    | 1.12.0   | 7.10.2    |  
| v4.1.0    | 1.12.0   | 7.10.2    |  
| v4.0.4    | 1.11.0   | -         |  
| v4.0.3    | 1.11.0   | -         |  
| v4.0.2    | 1.11.0   | -         |  
| v4.0.1    | 1.11.0   | -         |  
| v4.0.0    | 1.10.1   | -         |  


## 致谢  
本项目的Docker容器基于以下项目开发：  
- [deviantony/docker-elk]   
- [xetus-oss/docker-ossec-server]   
感谢所有贡献者对本项目的支持。  


## 许可证与版权  
Wazuh Docker容器版权归Wazuh Inc.所有（2017年），采用GPLv2许可证。  


## 相关资源  
- [Wazuh官网]   
- [Wazuh完整文档]   
- [Wazuh Docker文档]   
- [Docker Hub]
