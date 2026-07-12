---
image: plantuml/plantuml-server
description: "提供PlantUML图在线生成服务的服务器镜像，支持通过Web界面或API快速创建类图、时序图等UML图表，无需本地安装，便于即时协作与图表生成。"
source: https://xuanyuan.cloud/zh/r/plantuml/plantuml-server
canonical: https://xuanyuan.cloud/zh/r/plantuml/plantuml-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/plantuml/plantuml-server" title="plantuml/plantuml-server Docker 镜像中文简介、标签列表与拉取命令">plantuml/plantuml-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![Build Status](https://travis-ci.org/plantuml/plantuml-server.png?branch=master)](https://travis-ci.org/plantuml/plantuml-server) [![](https://images.microbadger.com/badges/image/plantuml/plantuml-server.svg)](https://microbadger.com/images/plantuml/plantuml-server "Get your own image badge on microbadger.com") [![Docker Pull](https://img.shields.io/docker/pulls/plantuml/plantuml-server.svg)](https://hub.docker.com/r/plantuml/plantuml-server/) [![](https://images.microbadger.com/badges/version/plantuml/plantuml-server.svg)](https://microbadger.com/images/plantuml/plantuml-server "Get your own version badge on microbadger.com")

# PlantUML Server Docker镜像文档

## 镜像概述和主要用途

PlantUML Server Docker镜像是[PlantUML Server](https://github.com/plantuml/plantuml-server)的官方容器化实现，基于Jetty或Tomcat Web服务器构建，用于提供在线的PlantUML图表渲染服务。

主要用途：允许用户通过Web界面或HTTP API输入PlantUML语法，实时生成并预览各类UML图表（如时序图、类图、活动图等）。


## 核心功能和特性

- **多图表类型支持**：兼容PlantUML语法定义的各类图表，包括时序图、类图、活动图、状态图、用例图等。
- **双Web服务器选项**：提供基于Jetty（默认）和Tomcat的两种镜像标签，适配不同部署环境需求。
- **Web界面交互**：内置直观的Web界面，支持在线编辑PlantUML代码并实时预览图表效果。
- **HTTP API支持**：可通过HTTP请求调用图表生成功能，便于集成到第三方工具（如文档系统、IDE插件）中。
- **轻量级部署**：容器化设计简化部署流程，无需手动配置依赖，快速启动服务。


## 使用场景和适用范围

### 使用场景
- **团队协作**：团队成员共享PlantUML代码，通过服务器实时预览图表，提升协作效率。
- **文档集成**：为Markdown文档、Wiki系统（如Confluence）或静态站点动态生成UML图表，保持文档与代码同步。
- **开发验证**：开发过程中快速验证PlantUML语法正确性，即时调整图表结构。
- **教学演示**：教学场景中实时展示UML图表绘制过程和渲染结果。

### 适用范围
- 个人开发者：本地验证PlantUML代码或生成图表。
- 开发团队：团队内部共享图表渲染服务，支持多人协作。
- 文档编写者：为技术文档添加动态生成的UML图表，增强文档可读性。


## 详细的使用方法和配置说明

### 基础运行方法

#### 使用Docker命令运行
镜像通过标签区分Web服务器版本：`jetty`（默认）和`tomcat`，可根据需求选择。

- **使用Jetty服务器**（推荐，轻量级）：
  ```docker
  docker run -d -p 8080:8080 docker.xuanyuan.run/plantuml/plantuml-server:jetty
  ```

- **使用Tomcat服务器**：
  ```docker
  docker run -d -p 8080:8080 docker.xuanyuan.run/plantuml/plantuml-server:tomcat
  ```

服务启动后，通过 `http://localhost:8080` 访问Web界面，输入PlantUML代码即可生成图表。


#### 使用Docker Compose运行
创建 `docker-compose.yml` 文件，配置如下（以Jetty为例）：
```yaml
version: '3'
services:
  plantuml-server:
    image: docker.xuanyuan.run/plantuml/plantuml-server:jetty  # 如需Tomcat，替换为 :tomcat
    ports:
      - "8080:8080"  # 主机端口:容器端口，可自定义主机端口（如 80:8080）
    restart: unless-stopped  # 服务异常时自动重启
```

执行以下命令启动服务：
```bash
docker-compose up -d
```


### 默认配置说明
- **端口映射**：容器内部默认使用8080端口，需通过 `-p <主机端口>:8080` 映射到主机端口（如 `-p 80:8080` 可通过80端口访问）。
- **数据持久化**：服务无持久化存储需求，图表生成过程在内存中完成，重启后不保留历史数据。
- **安全配置**：默认配置未启用身份验证或HTTPS，生产环境建议结合反向代理（如Nginx）添加访问控制和SSL加密。


### 自定义配置（可选）
当前镜像未提供额外可配置的环境变量。如需扩展功能（如添加插件、调整渲染参数），可通过挂载自定义配置文件到容器内部路径（具体路径需参考[PlantUML Server源码](https://github.com/plantuml/plantuml-server)的配置结构）。
