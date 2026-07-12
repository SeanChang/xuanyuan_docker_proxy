---
image: flowable/flowable-modeler
description: "基于Spring Boot 2的应用，用于编辑和部署Flowable流程、表单及决策表。"
source: https://xuanyuan.cloud/zh/r/flowable/flowable-modeler
canonical: https://xuanyuan.cloud/zh/r/flowable/flowable-modeler
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/flowable/flowable-modeler" title="flowable/flowable-modeler Docker 镜像中文简介、标签列表与拉取命令">flowable/flowable-modeler 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Flowable Modeler Docker镜像文档


## 1. 镜像概述和主要用途

Flowable Modeler是Flowable生态系统的一部分，是一款基于Spring Boot 2构建的应用，主要用于编辑和部署Flowable流程、表单及决策表。作为流程设计工具，它与Flowable IDM（身份管理）和Flowable流程引擎紧密集成，提供直观的建模环境，支持企业级流程设计与管理。

更多信息请访问[Flowable官网](http://flowable.org)。有关预配置的docker-compose配置及启动/停止脚本，可参考[Flowable Engine GitHub仓库](https://github.com/flowable/flowable-engine/tree/master/docker)。


## 2. 核心功能和特性

- **流程建模**：支持可视化编辑Flowable BPMN流程定义。  
- **表单设计**：提供表单创建与编辑功能，支持流程表单自定义。  
- **决策表管理**：支持决策表（DMN）的设计与配置。  
- **部署能力**：可直接将设计完成的流程、表单、决策表部署至Flowable流程引擎。  
- **Spring Boot 2框架**：基于Spring Boot 2构建，简化部署与集成。  
- **身份集成**：依赖Flowable IDM进行身份验证与授权，支持服务器间通信与客户端重定向。  
- **多数据库支持**：通过配置可适配PostgreSQL等多种数据库（默认使用H2内存数据库）。  


## 3. 使用场景和适用范围

### 适用场景  
- 企业级业务流程建模与设计（如审批流程、业务流程自动化）。  
- 自定义表单创建（用于流程节点数据收集）。  
- 决策规则定义（通过决策表配置业务规则）。  
- 流程设计与部署一体化工作流（从设计到上线的闭环管理）。  

### 适用人群  
- 开发人员：用于流程定义的技术实现与调试。  
- 业务分析师：通过可视化界面设计业务流程与规则。  


## 4. 使用方法

### 4.1 前置条件  
启动Flowable Modeler容器前，需确保**Flowable IDM应用已运行**（用于身份验证）。


### 4.2 快速启动（H2内存数据库）  
使用H2内存数据库启动容器（适用于测试环境）：  
```sh
docker run -p 8888:8888 \
  -e FLOWABLE_COMMON_APP_IDM-URL=http://<host-ip>:8080/flowable-idm \
  -e FLOWABLE_COMMON_APP_IDM-ADMIN_USER=admin \
  -e FLOWABLE_COMMON_APP_IDM-ADMIN_PASSWORD=test \
  docker.xuanyuan.run/flowable/flowable-modeler
```  
**参数说明**：  
- `-p 8888:8888`：映射容器内Tomcat端口（默认8888）至主机。  
- `-e`：设置环境变量（具体见配置说明）。  
- `<host-ip>`：需替换为运行Flowable IDM的主机IP。  


## 5. 配置说明

### 5.1 必填环境变量  
启动容器时必须配置以下环境变量，用于与Flowable IDM集成：  

| 环境变量                          | 说明                                      | 示例值                                  |
|-----------------------------------|-------------------------------------------|-----------------------------------------|
| `FLOWABLE_COMMON_APP_IDM-URL`     | IDM应用的完整URL，用于服务器间通信        | `http://192.168.1.100:8080/flowable-idm`|
| `FLOWABLE_COMMON_APP_IDM-ADMIN_USER` | IDM管理员用户名（默认配置为`admin`）     | `admin`                                 |
| `FLOWABLE_COMMON_APP_IDM-ADMIN_PASSWORD` | IDM管理员密码（默认配置为`test`）      | `test`                                  |


### 5.2 可选环境变量  
可根据需求配置以下可选环境变量：  

| 环境变量                                  | 说明                                                                 | 默认值/示例值                                                                 |
|-------------------------------------------|----------------------------------------------------------------------|------------------------------------------------------------------------------|
| `SERVER_PORT`                             | Tomcat服务器端口                                                     | `8888`                                                                       |
| `FLOWABLE_COMMON_APP_IDM-REDIRECT-URL`    | IDM应用的完整URL，用于客户端浏览器重定向                              | `http://localhost:8080/flowable-idm`                                         |
| `FLOWABLE_MODELER_APP_DEPLOYMENT-API-URL` | Flowable流程引擎API的完整URL（用于部署流程）                          | `http://flowable-task-app:9999/flowable-task/app-api`                        |
| `SPRING_DATASOURCE_DRIVER-CLASS-NAME`     | 数据库驱动类名（如需使用非H2数据库，如PostgreSQL）                    | `org.postgresql.Driver`                                                      |
| `SPRING_DATASOURCE_URL`                   | 数据库连接URL                                                         | `jdbc:postgresql://<db-ip>:5432/flowable`（PostgreSQL示例）                  |
| `SPRING_DATASOURCE_USERNAME`              | 数据库用户名                                                         | `flowable`                                                                   |
| `SPRING_DATASOURCE_PASSWORD`              | 数据库密码                                                           | `flowable`                                                                   |
