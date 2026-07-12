---
image: azul/zulu-openjdk
description: "Azul Zulu是由Azul Systems推出的开源OpenJDK发行版，针对Ubuntu Linux操作系统进行了深度优化，遵循Java SE标准，具备高性能、长期支持及跨平台兼容性，集成安全更新与性能增强功能，支持Java应用程序的开发、部署和稳定运行，适用于企业级开发场景和个人开发者，确保在Ubuntu环境中提供可靠、高效的Java运行体验。"
source: https://xuanyuan.cloud/zh/r/azul/zulu-openjdk
canonical: https://xuanyuan.cloud/zh/r/azul/zulu-openjdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/azul/zulu-openjdk" title="azul/zulu-openjdk Docker 镜像中文简介、标签列表与拉取命令">azul/zulu-openjdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Azul Zulu Ubuntu Docker镜像介绍


## 概述  
本文介绍基于Ubuntu系统的Azul Zulu OpenJDK Docker镜像。Azul Zulu OpenJDK构建版本可免费无限使用，且作为Azul Platform Core套件的一部分，由Azul提供商业支持。更多信息可参考[Azul Platform Core] ，技术文档详见[docs.azul.com/core] 。


## 镜像仓库  
Azul Zulu Docker镜像根据基础系统不同，分布在以下仓库：  
- **Ubuntu**: azul/zulu-openjdk  
- **Alpine**: azul/zulu-openjdk-alpine  
- **CentOS**: azul/zulu-openjdk-centos  
- **Debian**: azul/zulu-openjdk-debian  
- **Distroless**: azul/zulu-openjdk-distroless  


## 标签及Dockerfile信息  

### 最新标签  
以下是基于Ubuntu的Azul Zulu OpenJDK最新版本镜像标签（含具体版本号）：  
- `25.0.0-25.28`、`25-latest`  
- `22.0.2-22.32`、`22-latest`  
- `21.0.8-21.44`、`21-latest`  
- `17.0.16-17.60`、`17-latest`  
- `11.0.28-11.82`、`11-latest`  
- `8u462-8.88`、`8-latest`  


### 历史标签  
以下是基于Ubuntu的Azul Zulu OpenJDK历史版本镜像标签（每个版本含最新3个更新标签）：  

#### 25系列  
- jre-headless类型：`25-jre-headless-latest`、`25.0.0-25.28-jre-headless`  

#### 24系列  
- jre-headless类型：`24-jre-headless-latest`、`24.0.0-24.28-jre-headless`、`24.0.1-24.30-jre-headless`  

#### 23系列  
- jre-headless类型：`23-jre-headless-latest`、`23.0.0-23.28-jre-headless`、`23.0.1-23.30-jre-headless`  

#### 22系列  
- jre-headless类型：`22-jre-headless-latest`、`22.0.0-22.28-jre-headless`、`22.0.1-22.30-jre-headless`  

#### 21系列  
- jre-headless类型：`21-jre-headless-latest`、`21.0.0-21.28.85-jre-headless`、`21.0.1-21.30-jre-headless`  

#### 20系列  
- jre-headless类型：`20-jre-headless-latest`、`20.0.0-20.28.85-jre-headless`、`20.0.1-20.30.11-jre-headless`  

#### 19系列  
- jre-headless类型：`19-jre-headless-latest`、`19.0.0-19.28.81-jre-headless`、`19.0.1-19.30.11-jre-headless`  

#### 18系列  
- jre-headless类型：`18-jre-headless-latest`、`18.0.1-18.30.11-jre-headless`、`18.0.2.1-18.32.13-jre-headless`  

#### 17系列  
- jre-headless类型：`17-jre-headless-latest`、`17.0.0-17.28.13-jre-headless`、`17.0.1-17.30.15-jre-headless`  

（其他历史版本如15、13、11、8系列及jre-crac、jdk-crac等类型标签，可参考官方仓库详细列表）  


## 许可信息  
Azul Zulu包含第三方许可软件包，部分有分发限制或报告要求。最新版Azul Platform Core中第三方软件的许可文档详见[docs.azul.com/core/tpl] 。  

与所有Docker镜像一样，镜像中可能包含其他软件（如基础系统的Bash等），用户需自行确保使用符合所有包含软件的许可要求。整体镜像遵循[BSD 3-Clause Clear License] 。
