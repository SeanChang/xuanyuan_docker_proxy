---
image: mcp/postman
description: "Postman的MCP服务器用于将AI代理、助手及聊天机器人直接连接至Postman上的API。"
source: https://xuanyuan.cloud/zh/r/mcp/postman
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[mcp/postman](https://xuanyuan.cloud/zh/r/mcp/postman)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Postman MCP Server 技术文档


## 1. 镜像概述和主要用途

Postman MCP Server（模型上下文协议服务器）用于将AI代理、助手和聊天机器人直接连接到Postman上的API。通过自然语言提示，AI可自动化操作Postman集合、环境、工作空间等资源，实现API开发、测试与管理的智能化流程。

> 关于MCP协议的更多信息：[什么是MCP Server？](https://www.anthropic.com/news/model-context-protocol)


## 2. 核心特性

### 2.1 基本信息

| 属性                | 详情                                                                 |
|---------------------|----------------------------------------------------------------------|
| **Docker镜像**      | [mcp/postman](https://hub.docker.com/repository/docker/mcp/postman)  |
| **作者**            | [postmanlabs](https://github.com/postmanlabs)                        |
| **代码仓库**        | https://github.com/postmanlabs/postman-mcp-server                    |
| **Dockerfile**      | https://github.com/postmanlabs/postman-mcp-server/blob/main/Dockerfile |
| **镜像构建方**      | Docker Inc.                                                          |
| **Docker Scout健康评分** | ![Docker Scout Health Score](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/postman) |
| **签名验证命令**    | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/postman --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub` |
| **许可证**          | Apache License 2.0                                                   |


### 2.2 支持的工具

MCP Server提供**38个工具**，覆盖Postman资源的创建、查询、更新等核心操作，包括集合管理、环境配置、模拟服务器部署、API规范生成等。部分工具如下表：

| 工具名称                  | 简短描述                                                                 |
|---------------------------|--------------------------------------------------------------------------|
| `createCollection`        | 使用Postman Collection v2.1.0 schema格式创建集合                        |
| `createCollectionRequest` | 在集合中创建请求                                                         |
| `createCollectionResponse`| 为集合中的请求创建响应                                                   |
| `createEnvironment`       | 创建环境                                                                 |
| `createMock`              | 在集合中创建模拟服务器                                                   |
| `createSpec`              | 在Spec Hub中创建API规范（支持OpenAPI 3.0、AsyncAPI 2.0）                 |
| `createWorkspace`         | 创建新工作空间                                                           |
| `getAuthenticatedUser`    | 获取当前认证用户信息（用户ID、用户名、团队ID等）                         |
| `getCollection`           | 查询集合详情                                                            |
| `generateCollection`      | 从API规范生成集合                                                       |
| `generateSpecFromCollection` | 从集合生成API规范                                                     |


## 3. 使用场景和适用范围

### 3.1 适用场景
- **API开发自动化**：通过自然语言指令创建集合、请求、响应，减少手动操作。
- **测试与模拟服务**：快速生成模拟服务器，支持API测试环境搭建。
- **团队协作管理**：批量创建工作空间、管理团队资源权限，适配企业级协作流程。
- **AI驱动的API治理**：结合LLM自动生成API规范（如OpenAPI）、同步集合与规范。

### 3.2 适用用户
- API开发者、测试工程师
- 依赖Postman进行API管理的团队
- 需要通过自然语言接口自动化Postman操作的AI应用开发者


## 4. 部署与配置

### 4.1 Docker快速启动

```bash
docker run -d \
  --name postman-mcp-server \
  -p 8080:8080 \
  -e POSTMAN_API_KEY="your-postman-api-key" \
  -e LOG_LEVEL="info" \
  mcp/postman:latest
```

**参数说明**：
- `-p 8080:8080`：映射容器端口到主机（默认服务端口8080）。
- `POSTMAN_API_KEY`：Postman认证密钥（必填，从Postman账户设置中获取）。
- `LOG_LEVEL`：日志级别（可选，默认info，支持debug/warn/error）。


### 4.2 Docker Compose配置

```yaml
version: '3.8'
services:
  mcp-server:
    image: mcp/postman:latest
    container_name: postman-mcp-server
    ports:
      - "8080:8080"
    environment:
      - POSTMAN_API_KEY=your-postman-api-key
      - LOG_LEVEL=info
      - WORKSPACE_ID=default-workspace-id  # 可选，默认工作空间ID
    restart: unless-stopped
    volumes:
      - ./config:/app/config  # 挂载配置文件目录（如需要自定义工具参数）
```


### 4.3 签名验证

为确保镜像完整性，可通过cosign验证签名：

```bash
COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/postman --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub
```


## 5. 工具详情

### 5.1 集合管理工具

#### `createCollection`  
**描述**：使用[Postman Collection v2.1.0 schema格式](https://schema.postman.com/collection/json/v2.1.0/draft-07/docs/index.html)创建集合。  

**参数**：
| 参数名     | 类型     | 描述                     |
|------------|----------|--------------------------|
| `workspace`| `string` | 工作空间ID（可选）       |
| `collection`| `object` | 集合配置（可选，符合v2.1.0 schema） |

**注意事项**：  
- 若未指定`workspace`，集合将创建在用户拥有的最旧个人工作空间中。


#### `getCollection`  
**描述**：查询指定集合的详细信息（符合Postman Collection Format规范）。  

**参数**：
| 参数名         | 类型     | 描述                                                                 |
|----------------|----------|----------------------------------------------------------------------|
| `collectionId` | `string` | 集合ID（格式为`<OWNER_ID>-<UUID>`，如`12345-33823532ab9e41c9b6fd12d0fd459b8b`） |
| `access_key`   | `string` | 集合只读访问密钥（可选，无需API密钥即可查询）                         |

**注意事项**：  
- 完整返回字段参考[Postman Collection Format文档](https://schema.postman.com/collection/json/v2.1.0/draft-07/docs/index.html)。


### 5.2 环境管理工具

#### `createEnvironment`  
**描述**：创建环境（存储API请求所需的变量配置）。  

**参数**：
| 参数名         | 类型     | 描述                     |
|----------------|----------|--------------------------|
| `workspace`    | `string` | 工作空间ID（可选）       |
| `environment`  | `object` | 环境配置（可选，包含变量列表） |

**注意事项**：  
- 请求体大小不超过30MB。  
- 若返回`411 Length Required`错误，需手动添加`Content-Length`请求头。  


### 5.3 工作空间管理工具

#### `createWorkspace`  
**描述**：创建新工作空间（支持个人/团队/私有/公开等可见性类型）。  

**参数**：
| 参数名       | 类型     | 描述                 |
|--------------|----------|----------------------|
| `workspace`  | `object` | 工作空间配置（可选，包含名称、可见性等） |

**注意事项**：  
- 用户需具备工作空间创建权限（团队管理员可配置权限）。  
- 公开团队工作空间名称需全局唯一，且存在创建频率限制。  


### 5.4 API规范工具

#### `createSpec`  
**描述**：在Spec Hub中创建API规范（支持单文件/多文件，OpenAPI 3.0/AsyncAPI 2.0）。  

**参数**：
| 参数名         | 类型     | 描述                     |
|----------------|----------|--------------------------|
| `files`        | `array`  | 规范文件列表（含路径和内容） |
| `name`         | `string` | 规范名称（必填）         |
| `type`         | `string` | 规范类型（如openapi/asyncapi，必填） |
| `workspaceId`  | `string` | 工作空间ID（必填）       |

**注意事项**：  
- 文件路径含`/`时自动创建文件夹（如`components/schemas.json`生成`components`文件夹）。  
- 多文件规范仅支持一个根文件，单个文件大小不超过10MB。  


## 5. 验证与安全

### 5.1 镜像签名验证
使用cosign验证镜像完整性：  
```bash
COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/postman --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub
```


### 5.2 许可证
本镜像基于Apache License 2.0开源协议，详见[LICENSE](https://github.com/postmanlabs/postman-mcp-server/blob/main/LICENSE)。
