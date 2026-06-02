---
image: percona/percona-server-mongodb
description: "Percona Server for MongoDB Docker镜像是用于运行兼容MongoDB的增强版数据库服务器，提供高性能、企业级特性及可靠性的容器化解决方案。"
source: https://xuanyuan.cloud/zh/r/percona/percona-server-mongodb
canonical: https://xuanyuan.cloud/zh/r/percona/percona-server-mongodb
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [percona/percona-server-mongodb — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/percona/percona-server-mongodb)

含镜像标签、拉取命令、部署文档与相关推荐。

[percona/percona-server-mongodb Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/percona/percona-server-mongodb)

# Percona Server for MongoDB Docker镜像文档


## 镜像概述和主要用途

Percona Server for MongoDB 是一款源码可用、完全兼容的 MongoDB Community Edition 无缝替代品。它包含企业级安全、备份及开发者友好功能，这些功能原本仅在 MongoDB 企业版（MongoDB EE）中提供。该 Docker 镜像由 Percona 团队创建和维护，用于简化 Percona Server for MongoDB 的部署和管理，支持在容器化环境中快速搭建数据库服务。


## 核心功能和特性

- **加密 WiredTiger 存储引擎**：提供数据加密功能，增强数据安全性。  
- **外部认证与授权**：支持通过 OpenLDAP/AD 或 Kerberos 进行身份验证。  
- **审计日志与日志脱敏**：记录并审计用户或应用程序的数据库交互，支持日志敏感信息脱敏。  
- **与 Percona 工具集成**：兼容 Percona Toolkit 和 Percona Monitoring and Management，提供查询性能分析和故障排查工具。  
- **Kubernetes 兼容性**：可与 Percona Operator for MongoDB 配合，在 Kubernetes 上轻松部署和管理复杂的 MongoDB 拓扑结构。  


## 使用场景和适用范围

- **企业级安全需求**：需数据加密、外部认证（如 LDAP/Kerberos）或审计日志的场景。  
- **开发与生产环境**：作为 MongoDB Community Edition 的替代品，适用于开发、测试及生产环境。  
- **容器化部署**：适合 Docker 或 Kubernetes 容器化环境，简化部署流程。  
- **Percona 生态集成**：需使用 Percona 监控工具（PMM）或运维工具（Percona Toolkit）的环境。  


## 版本信息与官方文档

Percona Server for MongoDB 各版本官方文档：  
- [版本 4.0](https://www.percona.com/doc/percona-server-for-mongodb/4.0/)  
- [版本 4.2](https://www.percona.com/doc/percona-server-for-mongodb/4.2/)  
- [版本 4.4](https://www.percona.com/doc/percona-server-for-mongodb/4.4/)  
- [版本 5.0](https://www.percona.com/doc/percona-server-for-mongodb/5.0/)  
- [版本 6.0](https://www.percona.com/doc/percona-server-for-mongodb/6.0/)  

镜像标签与版本对应关系可参考 [Docker Hub 标签列表](https://hub.docker.com/r/percona/percona-server-mongodb/tags/)。


## 镜像说明

Percona Server for MongoDB Docker 镜像由 Percona 团队官方维护，会随新版本发布同步更新。镜像默认暴露 MongoDB 标准端口（27017），支持通过环境变量、命令行参数等方式自定义配置。


## 使用方法和配置说明

### 启动 Percona Server for MongoDB 实例

使用 `docker run` 命令启动容器：  
```bash
docker run --name <container-name> -d percona/percona-server-mongodb:<tag>
```  
- `<container-name>`：自定义容器名称。  
- `<tag>`：指定镜像版本标签（如 `6.0`、`5.0` 等），标签列表见 [Docker Hub](https://hub.docker.com/r/percona/percona-server-mongodb/tags/)。  


### 访问容器 Shell

通过 `docker exec` 命令进入容器内部执行命令：  
```bash
docker exec -it <container-name> bash
```  
- `<container-name>`：目标容器名称。  


### 从本地应用连接

需暴露容器端口至主机，示例如下（映射 27017 端口）：  
```bash
docker run --name <container-name> -p 27017:27017 -d percona/percona-server-mongodb:<tag>
```  
应用可通过 `mongodb://localhost:27017` 连接数据库。  


### 从其他 Docker 容器连接

通过容器链接（`--link`）使其他容器访问 Percona Server for MongoDB：  
```bash
docker run --name <app-container-name> --link <container-name> -d <app-image>
```  
- `<app-container-name>`：应用容器名称。  
- `<container-name>`：Percona Server for MongoDB 容器名称。  
- `<app-image>`：使用 MongoDB 的应用镜像。  


### 使用命令行客户端连接

#### 版本 6.0 及以上（使用 `mongosh`）  
```bash
docker run -it --link <container-name> --rm percona/percona-server-mongodb:<tag> mongosh mongodb://<mongodb-server>:<port>/<db-name>
```  

#### 版本 6.0 以下（使用 `mongo`）  
```bash
docker run -it --link <container-name> --rm percona/percona-server-mongodb:<tag> mongo mongodb://<mongodb-server>:<port>/<db-name>
```  

**参数说明**：  
- `<container-name>`：Percona Server for MongoDB 容器名称。  
- `<mongodb-server>`：容器 IP 地址，可通过 `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container-name>` 获取。  
- `<port>`：数据库端口（默认 27017）。  
- `<db-name>`：目标数据库名称。  


### 环境变量

容器启动时可通过环境变量初始化数据库，仅在数据目录为空时生效（已存在数据库时忽略）。  

#### `MONGO_INITDB_ROOT_USERNAME` 与 `MONGO_INITDB_ROOT_PASSWORD`  
- 作用：创建管理员用户（`admin` 认证数据库，`root` 角色）。  
- 使用示例：  
  ```bash
  docker run -d --name <container-name> \
    -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
    -e MONGO_INITDB_ROOT_PASSWORD=secret \
    percona/percona-server-mongodb:<tag>
  ```  
  连接数据库：  
  ```bash
  docker exec -it <container-name> mongo -u mongoadmin -p secret --authenticationDatabase admin <db-name>
  ```  


### Docker Secrets（环境文件）

通过环境文件传递敏感信息，避免命令行暴露：  
```bash
docker run --name <container-name> --env-file <path/to/env-file> -d percona/percona-server-mongodb:<tag>
```  
- `<path/to/env-file>`：环境文件路径，文件内容示例：  
  ```ini
  MONGO_INITDB_ROOT_USERNAME=mongoadmin
  MONGO_INITDB_ROOT_PASSWORD=secret
  ```  


## 高级配置与注意事项

### 数据存储

#### 方式 1：Docker 内部卷管理（不推荐生产环境）  
Docker 自动管理数据存储，性能可能受限于存储驱动（如 devicemapper、aufs）。  

#### 方式 2：挂载主机目录（推荐）  
将主机目录挂载至容器内 MongoDB 数据目录（`/data/db`）：  
1. 主机创建目录：`mkdir -p /local/datadir`。  
2. 启动容器：  
   ```bash
   docker run --name <container-name> -v /local/datadir:/data/db -d percona/percona-server-mongodb:<tag>
   ```  
- 确保主机目录权限正确（容器内 MongoDB 进程需读写权限）。  


### 查看日志

通过 Docker 容器日志查看数据库运行日志：  
```bash
docker logs <container-name>
```  


### 传递服务器选项

可在 `docker run` 命令后追加 `mongod` 命令行选项：  
```bash
docker run --name <container-name> -d percona/percona-server-mongodb:<tag> --option1=value --option2=value
```  
示例（启用审计日志）：  
```bash
docker run --name <container-name> -d percona/percona-server-mongodb:6.0 --auditDestination=file --auditFormat=JSON --auditPath=/data/db/audit.log
```  


## Docker Compose 部署示例

创建 `docker-compose.yml` 文件：  
```yaml
version: '3'
services:
  psmdb:
    image: percona/percona-server-mongodb:6.0
    container_name: psmdb
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: mongoadmin
      MONGO_INITDB_ROOT_PASSWORD: secret
    volumes:
      - /local/datadir:/data/db
    restart: unless-stopped
```  
启动服务：`docker-compose up -d`  


## 用户反馈

欢迎提供反馈！如有问题或建议，请联系 Percona 团队。
