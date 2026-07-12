---
image: scalarapi/aspire-api-reference
description: "为.NET Aspire应用提供API参考文档的Scalar Docker镜像，用于生成、托管和展示API文档，支持OpenAPI规范解析与交互式文档浏览，简化API文档管理流程。"
source: https://xuanyuan.cloud/zh/r/scalarapi/aspire-api-reference
canonical: https://xuanyuan.cloud/zh/r/scalarapi/aspire-api-reference
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/scalarapi/aspire-api-reference" title="scalarapi/aspire-api-reference Docker 镜像中文简介、标签列表与拉取命令">scalarapi/aspire-api-reference 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Scalar API Reference Docker Image for Aspire

## 镜像概述

Scalar API Reference Docker Image for Aspire是Scalar API参考文档工具的Docker化版本，专为.NET Aspire应用生态系统设计。该镜像提供API文档生成、托管和交互展示的一站式解决方案，支持解析OpenAPI规范文件，生成可视化、可交互的API文档界面，帮助开发团队高效管理API文档资源。

## 核心功能与特性

- **OpenAPI规范兼容**：支持OpenAPI 2.0（Swagger）和OpenAPI 3.x规范，自动解析JSON/YAML格式的API定义文件
- **交互式文档界面**：提供直观的Web界面，支持API端点检索、请求参数填写、响应示例预览及在线API调试
- **.NET Aspire适配**：优化支持.NET Aspire项目结构，可与Aspire服务发现机制集成，自动关联微服务API规范
- **容器化部署**：轻量级Docker镜像设计，支持跨平台快速部署，降低文档服务搭建复杂度
- **自定义配置**：通过环境变量灵活配置文档标题、描述、主题及logo，满足个性化文档需求
- **多端口与网络适配**：支持自定义服务监听端口，适配不同网络环境下的端口映射需求

## 使用场景与适用范围

- **.NET Aspire微服务项目**：为基于Aspire构建的微服务架构提供统一API文档入口，聚合多服务API规范
- **API开发协作**：供前后端开发人员、测试人员查阅API详情，减少接口沟通成本
- **CI/CD流程集成**：嵌入持续集成/部署 pipeline，实现API文档的自动更新与版本管理
- **对外API门户**：作为对外提供API服务的官方文档站点，展示API功能、使用方法及权限说明

## 使用方法与配置说明

### 前提条件

- Docker Engine 20.10+ 环境
- API规范文件（OpenAPI JSON/YAML格式）或已启用OpenAPI生成的.NET Aspire应用

### 快速启动（docker run）

通过以下命令启动容器，托管本地API规范文件：

```bash
docker run -d \
  --name aspire-api-docs \
  -p 8080:80 \
  -v /local/path/to/openapi:/app/specs \
  -e SCALAR_API_SPEC=/app/specs/aspire-api.openapi.yaml \
  -e SCALAR_TITLE="Aspire Project API Docs" \
  -e SCALAR_THEME=dark \
  docker.xuanyuan.run/scalar/aspire-api-reference:latest
```

#### 参数说明：
- `-p 8080:80`：将容器内80端口映射至主机8080端口，通过`http://localhost:8080`访问文档
- `-v /local/path/to/openapi:/app/specs`：挂载本地API规范文件目录至容器内`/app/specs`
- `-e SCALAR_API_SPEC`：指定容器内API规范文件路径（支持单个文件或目录批量加载）
- `-e SCALAR_TITLE`：设置文档页面标题

### 环境变量配置

| 环境变量名               | 描述                                   | 默认值                          |
|--------------------------|----------------------------------------|---------------------------------|
| `SCALAR_API_SPEC`        | API规范文件在容器内的路径/目录         | `/app/openapi.yaml`             |
| `SCALAR_PORT`            | 容器内服务监听端口                     | `80`                            |
| `SCALAR_TITLE`           | 文档页面主标题                         | `Scalar API Reference`          |
| `SCALAR_DESCRIPTION`     | 文档页面副标题/描述                    | `Automatically generated API documentation` |
| `SCALAR_THEME`           | 界面主题（支持`light`/`dark`/`auto`）  | `light`                         |
| `SCALAR_LOGO`            | 自定义logo图片URL（建议SVG/PNG格式）   | Scalar默认logo                  |
| `SCALAR_DEFAULT_SERVER`  | 默认API服务器地址（用于在线调试）      | `http://localhost`              |

### Docker Compose配置示例

在.NET Aspire项目中集成文档服务的`docker-compose.yml`示例：

```yaml
version: '3.8'

services:
  api-docs:
    image: docker.xuanyuan.run/scalar/aspire-api-reference:latest
    container_name: aspire-api-docs
    ports:
      - "8080:80"
    volumes:
      - ./src/AspireApiService/OpenApi:/app/specs  # 挂载Aspire服务生成的OpenAPI文件
    environment:
      - SCALAR_API_SPEC=/app/specs/v1/openapi.yaml
      - SCALAR_TITLE=Aspire E-commerce API Docs
      - SCALAR_DESCRIPTION=API Documentation for E-commerce Microservices
      - SCALAR_THEME=dark
      - SCALAR_DEFAULT_SERVER=http://api-service:5000
    depends_on:
      - api-service  # 依赖Aspire API服务（确保API规范文件已生成）
    restart: unless-stopped
```

### 与.NET Aspire集成要点

1. **启用Aspire OpenAPI生成**：在Aspire项目中为目标服务配置OpenAPI生成
   ```csharp
   // 在Program.cs中配置Aspire服务
   var builder = DistributedApplication.CreateBuilder(args);
   var apiService = builder.AddProject<Projects.Ecommerce_Api>("api-service")
                          .WithOpenApi(openApi => 
                          {
                              openApi.WithTitle("E-commerce API")
                                     .WithVersion("v1")
                                     .WithDescription("Core e-commerce microservice API");
                          });
   ```

2. **挂载Aspire生成的OpenAPI文件**：Aspire默认将OpenAPI规范文件输出至`./src/[ServiceName]/bin/[Configuration]/[Framework]/OpenApi`目录，可通过Docker volume挂载该路径

## 注意事项

- **API规范格式校验**：确保挂载的OpenAPI文件符合规范要求，可通过[OpenAPI Validator](https://validator.swagger.io/)提前校验
- **生产环境安全**：建议通过反向代理（如Nginx）配置访问控制（如Basic Auth），限制文档访问权限
- **高可用部署**：多实例部署时需确保API规范文件同步，或通过共享存储（如NFS）挂载规范文件目录
- **版本兼容性**：使用与Aspire版本匹配的Scalar镜像，避免因API规范版本差异导致解析异常
