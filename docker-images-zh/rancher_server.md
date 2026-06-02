---
image: rancher/server
description: "Rancher 1.x Server容器是用于管理Docker容器集群的服务器组件，提供容器环境的部署、管理与监控功能。"
source: https://xuanyuan.cloud/zh/r/rancher/server
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[rancher/server](https://xuanyuan.cloud/zh/r/rancher/server)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Rancher 1.x 服务器容器镜像文档


## 一、镜像概述和主要用途

### 1.1 概述
本镜像为 Rancher 1.x 版本的服务器容器，用于部署和运行 Rancher 1.x 容器管理平台。Rancher 1.x 是一款开源的容器管理平台，提供容器编排、多主机管理、服务发现等核心能力。

### 1.2 版本区分
- **Rancher 1.x**：对应本镜像（未指定具体镜像名，通常为 `rancher/server`）。  
- **Rancher 2.x**：需使用独立镜像 `rancher/rancher`（详见 [Docker Hub](https://hub.docker.com/r/rancher/rancher/)），两者架构不同，不可混用。


## 二、核心功能和特性

基于 Rancher 1.x 平台标准能力，本镜像提供以下核心功能（详细功能请参考 Rancher 1.x 官方文档）：  
- 多主机 Docker 容器管理与编排；  
- 支持多种容器编排引擎（如 Docker Compose、Kubernetes 等）；  
- 内置服务发现、负载均衡与网络策略；  
- 容器生命周期管理（部署、扩缩容、升级、回滚）；  
- 多租户权限控制与资源隔离。  


## 三、使用场景和适用范围

### 3.1 适用场景
- 开发/测试环境：快速搭建容器管理平台，简化多容器应用部署流程；  
- 生产环境：管理中小型容器集群，实现服务自动化运维（建议使用 `latest` 标签版本）；  
- 多主机环境：统一管理跨物理机/虚拟机的 Docker 容器资源。  

### 3.2 不适用场景
- 需使用 Rancher 2.x 新特性（如 Kubernetes 原生集成、UI 重构等）的场景，需迁移至 `rancher/rancher` 镜像；  
- 对稳定性要求极高且无法接受潜在升级风险的场景，避免使用 `RC` 标签版本。  


## 四、使用方法和配置说明

### 4.1 标签说明
镜像标签策略如下（镜像仓库默认标签为 `latest`）：  
- `latest`：经过 QA 测试的稳定版本，每月更新构建后发布，无 `-rcX` 后缀；  
- `rcX`（如 `v1.6.30-rc1`）：候选发布版本，包含前沿功能但可能存在未修复 bug，**可能导致无法升级至稳定版**，仅建议测试环境使用；  
- `beta`：标记 Rancher 1.x 官方 Beta 阶段初始版本，**已停止更新**，仅用于历史版本回溯，不建议任何场景使用。  


### 4.2 快速启动（docker run）
通过以下命令启动 Rancher 1.x 服务器容器，默认使用 `latest` 稳定版：  
```bash
docker run -d \
  --name rancher-server \
  --restart=unless-stopped \
  -p 8080:8080 \
  -v /opt/rancher-data:/var/lib/rancher \
  rancher/server:latest
```
- **参数说明**：  
  - `-p 8080:8080`：映射 Rancher 管理 UI 端口（默认 8080）；  
  - `-v /opt/rancher-data:/var/lib/rancher`：挂载数据卷，持久化 Rancher 配置与状态数据；  
  - `--restart=unless-stopped`：容器退出时自动重启（除手动停止外）。  


### 4.3 Docker Compose 部署
创建 `docker-compose.yml` 文件，配置如下：  
```yaml
version: '2'
services:
  rancher-server:
    image: rancher/server:latest
    container_name: rancher-server
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /opt/rancher-data:/var/lib/rancher
    # 可选：添加环境变量配置（如数据库连接等，具体参数参考 Rancher 1.x 官方文档）
    # environment:
    #   - DB_TYPE=mysql
    #   - DB_HOST=db-host
    #   - DB_PORT=3306
    #   - DB_USER=rancher
    #   - DB_PASSWORD=password
    #   - DB_NAME=rancher
```
启动命令：  
```bash
docker-compose up -d
```


### 4.4 访问与初始化
容器启动后，通过 `http://<主机IP>:8080` 访问 Rancher 管理 UI，首次登录需设置管理员密码并完成初始化配置（如添加主机、配置网络等）。


## 五、配置参数与环境变量

### 5.1 标签选择
| 标签类型   | 说明                                                                 | 适用场景                     |
|------------|----------------------------------------------------------------------|------------------------------|
| `latest`   | 经过 QA 测试的稳定版本，每月更新，无 `-rcX` 后缀                      | 生产/测试环境（推荐）         |
| `rcX`      | 前沿候选版本，包含最新功能，可能存在影响升级的 bug                    | 仅限测试新功能，禁止生产使用 |
| `beta`     | 历史 Beta 版本，已停止更新，功能陈旧                                 | 仅用于历史版本回溯           |

### 5.2 常用环境变量
Rancher 1.x 支持通过环境变量配置核心参数（完整列表请参考 [Rancher 1.x 官方文档](https://rancher.com/docs/rancher/v1.6/en/)），例如：  
- `DB_TYPE`：数据库类型（默认嵌入式 SQLite，支持 MySQL、PostgreSQL）；  
- `DB_HOST`/`DB_PORT`/`DB_USER`/`DB_PASSWORD`/`DB_NAME`：外部数据库连接参数；  
- `CATTLE_HTTP_PROXY`/`CATTLE_HTTPS_PROXY`：代理服务器配置。  


## 六、注意事项

1. **版本兼容性**：本镜像仅适用于 Rancher 1.x，2.x 版本需使用 `rancher/rancher` 镜像，两者数据结构不兼容，不支持直接升级。  
2. **数据持久化**：务必通过数据卷（`-v`）挂载 `/var/lib/rancher` 目录，避免容器重建导致数据丢失。  
3. **RC 版本风险**：`rcX` 标签版本可能包含未修复的 bug，可能导致后续无法升级至稳定版，生产环境禁止使用。  
4. **Beta 标签废弃**：`beta` 标签标记 Rancher 1.x 官方 Beta 阶段初始版本，已停止更新，功能和安全性无法保障，禁止使用。  
5. **更新策略**：稳定版（`latest`）每月更新，建议定期升级以获取安全补丁和功能优化。
