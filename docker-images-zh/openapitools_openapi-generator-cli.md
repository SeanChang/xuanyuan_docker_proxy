---
image: openapitools/openapi-generator-cli
description: "OpenAPI Generator的命令行界面工具，用于通过命令行生成API客户端、服务器端代码及文档等。"
source: https://xuanyuan.cloud/zh/r/openapitools/openapi-generator-cli
canonical: https://xuanyuan.cloud/zh/r/openapitools/openapi-generator-cli
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openapitools/openapi-generator-cli" title="openapitools/openapi-generator-cli Docker 镜像中文简介、标签列表与拉取命令">openapitools/openapi-generator-cli — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openapitools/openapi-generator-cli" title="openapitools/openapi-generator-cli Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openapitools/openapi-generator-cli</a>

# openapi-generator-cli 镜像文档


## 1. 镜像概述与主要用途  
openapi-generator-cli 镜像是 [OpenAPI Generator](https://openapi-generator.tech) 的容器化命令行界面（CLI）工具，用于基于 [OpenAPI 规范](https://openapis.org/)（v2/v3）自动生成 API 相关代码及文档。其核心用途是简化多语言 API 客户端、多框架服务器存根的开发流程，同时支持 API 文档的自动化生成，避免手动编写重复代码。


## 2. 核心功能与特性  
### 2.1 核心功能  
- **API 客户端生成**：支持 30+ 编程语言（如 Python、Java、JavaScript、Go 等）的客户端代码生成，包含请求/响应模型、认证逻辑及 API 调用方法。  
- **服务器存根生成**：支持 20+ 框架（如 Spring Boot、Express、Flask、Django 等）的服务器骨架代码生成，包含路由定义、请求处理及模型绑定。  
- **文档生成**：支持生成 HTML、Markdown 等格式的 API 文档，基于 OpenAPI 规范自动同步接口说明。  

### 2.2 特性  
- **容器化部署**：无需本地安装依赖（如 JDK、特定语言环境），直接通过 Docker 运行，环境一致性高。  
- **灵活配置**：支持通过命令行参数或配置文件自定义生成逻辑（如包名、类名、输出路径等）。  
- **规范兼容性**：兼容 OpenAPI 2.0（Swagger）和 OpenAPI 3.x 规范文件（.yaml 或 .json 格式）。  


## 3. 使用场景与适用范围  
### 3.1 典型使用场景  
- **多语言客户端开发**：API 提供者为不同语言（如 Web 前端 JavaScript、移动端 Swift、后端 Python）的使用者生成统一客户端，减少对接成本。  
- **服务器快速开发**：后端开发人员基于 OpenAPI 规范快速生成框架代码（如 Spring Boot 控制器、Express 路由），聚焦业务逻辑实现。  
- **文档自动化**：在 CI/CD 流程中集成，自动同步 API 规范变更并更新文档，确保文档与接口一致。  

### 3.2 适用范围  
- API 开发团队（前后端分离项目、微服务架构）。  
- 需要跨语言/跨框架支持的 API 项目。  
- 需自动化代码生成以提升效率的场景（如频繁迭代的 API）。  


## 4. 详细使用方法与配置说明  

### 4.1 前提条件  
- 本地安装 Docker（确保 `docker` 或 `docker-compose` 命令可用）。  
- 准备符合 OpenAPI 规范的输入文件（`.yaml` 或 `.json` 格式，以下简称「规范文件」）。  


### 4.2 基本使用命令格式  
```bash
docker run [Docker 选项] openapitools/openapi-generator-cli generate [生成参数]
```  
- **Docker 选项**：如挂载本地目录（`-v`）、设置用户权限（`--user`）等。  
- **生成参数**：OpenAPI Generator CLI 的核心参数，用于指定输入、输出及生成规则。  


### 4.3 常用生成参数说明  
| 参数                | 说明                                                                 | 示例值                          |
|---------------------|----------------------------------------------------------------------|---------------------------------|
| `-i <path>`         | 必选，OpenAPI 规范文件在容器内的路径                                 | `/local/openapi.yaml`           |
| `-g <generator>`    | 必选，生成器类型（语言/框架），可通过 `list` 命令查看支持列表         | `python`（客户端）、`spring`（服务器） |
| `-o <path>`         | 必选，生成文件在容器内的输出路径                                     | `/local/python-client`          |
| `--additional-properties <key=val>` | 可选，额外配置参数（如包名、版本等） | `packageName=myapi,projectVersion=1.0.0` |
| `--skip-validate-spec` | 可选，跳过规范文件校验（用于非标准规范文件）                         | -                               |  


### 4.4 部署示例  

#### 4.4.1 单命令生成（docker run）  
**场景**：生成 Python 语言的 API 客户端，规范文件位于本地 `./openapi.yaml`，输出到 `./python-client`。  

```bash
docker run --rm \
  -v $(pwd):/local \  # 挂载本地当前目录到容器内 /local
  openapitools/openapi-generator-cli generate \
  -i /local/openapi.yaml \  # 容器内规范文件路径
  -g python \  # 生成器类型（Python 客户端）
  -o /local/python-client \  # 容器内输出路径（映射到本地 ./python-client）
  --additional-properties=packageName=my_api_client  # 自定义包名
```  
- `--rm`：容器运行后自动删除，避免残留。  
- 本地路径 `$(pwd)` 需替换为实际规范文件所在目录的绝对路径（Windows 系统使用 `%cd%` 替换 `$(pwd)`）。  


#### 4.4.2 批量生成配置（docker-compose）  
**场景**：通过 docker-compose 配置多语言客户端生成（如 Python + Java），复用规范文件。  

创建 `docker-compose.yml`：  
```yaml
version: '3'
services:
  generate-python-client:
    image: openapitools/openapi-generator-cli
    volumes:
      - ./:/local  # 挂载本地目录
    command: generate -i /local/openapi.yaml -g python -o /local/python-client

  generate-java-client:
    image: openapitools/openapi-generator-cli
    volumes:
      - ./:/local
    command: generate -i /local/openapi.yaml -g java -o /local/java-client --additional-properties=groupId=com.example,artifactId=my-api-client
```  

执行生成：  
```bash
docker-compose up
```  


### 4.5 注意事项  
- **文件权限**：容器默认使用 root 用户生成文件，可能导致本地文件权限异常。可通过 `--user $(id -u):$(id -g)` 参数指定本地用户 ID，避免权限问题：  
  ```bash
  docker run --rm --user $(id -u):$(id -g) -v $(pwd):/local ...
  ```  
- **生成器列表**：通过 `list` 命令查看所有支持的生成器：  
  ```bash
  docker run --rm openapitools/openapi-generator-cli list
  ```  
- **高级配置**：复杂需求（如模板自定义、过滤器）可参考 [官方文档](https://github.com/OpenAPITools/openapi-generator#16---docker)。  


## 5. 参考链接  
- 官方项目文档：[OpenAPI Generator GitHub README](https://github.com/OpenAPITools/openapi-generator#16---docker)  
- 教程：[YouTube 视频教程](https://www.youtube.com/watch?v=9MuEP01h1XU)
