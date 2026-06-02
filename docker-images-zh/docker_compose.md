---
image: docker/compose
description: "Docker Compose是Docker官方提供的工具，可帮助用户通过YAML文件便捷地定义、配置和运行由多个Docker容器组成的应用程序，实现服务、网络和卷等组件的统一管理与一键部署，详情参见官方文档[]"
source: https://xuanyuan.cloud/zh/r/docker/compose
canonical: https://xuanyuan.cloud/zh/r/docker/compose
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/docker/compose" title="docker/compose Docker 镜像中文简介、标签列表与拉取命令">docker/compose 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 重要提示  

📣 **Docker Compose 现已包含在 [Docker 官方镜像]([]) 中** 🎉  

原镜像中包含的 Compose v1 已终止支持（EOL），相关标签已冻结且不再更新。  


### 如何使用 Compose  
- **直接从容器使用**：通过 Docker 官方镜像运行：  
  ```bash
  docker run --rm -it docker compose version
  # 输出示例：Docker Compose version v2.20.2
  ```  

- **嵌入自定义镜像**：使用 [docker/compose-bin 镜像]([]) 复制二进制文件：  
  ```dockerfile
  # syntax=docker/dockerfile:1
  FROM my-image
  COPY --from=docker/compose-bin:v2.20.2 /docker-compose /usr/bin/compose
  RUN compose version
  ```  


# Docker Compose  

![Docker Compose]([] "Docker Compose Logo")  

Compose 是用于定义和运行多容器 Docker 应用的工具。通过 Compose，你可以用 Compose 文件配置应用的所有服务，然后通过一条命令创建并启动所有服务。了解功能详情可查看 [功能列表]([])。  

Compose 适用于开发、测试、staging 环境及 CI 工作流，具体场景可参考 [常见用例]([])。  


## 使用流程  
使用 Compose 主要分为三步：  

1. 用 `Dockerfile` 定义应用环境，确保可在任意环境复现。  
2. 在 `docker-compose.yml` 中定义组成应用的服务，使它们能在隔离环境中协同运行。  
3. 运行 `docker-compose up`，Compose 将启动并运行整个应用。  


## docker-compose.yml 示例  
```yaml
version: '2'

services:
  web:
    build: .
    ports:
     - "5000:5000"
    volumes:
     - .:/code
  redis:
    image: redis
```  

更多关于 Compose 文件的规范，可参考 [Compose 文件参考]([])。  


## 命令功能  
Compose 提供管理应用全生命周期的命令，包括：  
- 启动、停止和重建服务  
- 查看运行中服务状态  
- 流式输出运行服务的日志  
- 在服务上执行一次性命令  


## 安装与文档  
- 完整文档见 [Docker 官网]([])。  
- 有问题可通过 Freenode 上的 #docker-compose IRC 频道与开发者实时交流（[通过 IRCCloud 加入]([])）。  
- 代码仓库位于 [GitHub]([])。  
- 发现问题请提交 [issue]([])。  


## 贡献  
[![Build Status]([])]([])  

想参与 Compose 开发？查看 [贡献文档]([])。  


## 发布  
版本发布由维护者按照 [发布流程]([]) 执行。
