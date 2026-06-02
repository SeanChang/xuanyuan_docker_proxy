---
image: elestio/minio
description: "由Elestio验证并打包的Minio对象存储服务，提供兼容S3 API的高性能数据存储解决方案，适用于云原生环境下的文件存储与管理。"
source: https://xuanyuan.cloud/zh/r/elestio/minio
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[elestio/minio](https://xuanyuan.cloud/zh/r/elestio/minio)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# MinIO，由 Elestio 验证和打包

[MinIO](https://github.com/minio/minio) 是一个云原生对象存储系统，可在任何基础设施（公有云、私有云或边缘云）上运行。主要用例包括数据湖、数据库、AI/ML、SaaS 应用程序以及快速备份与恢复。

![minio](https://github.com/elestio-examples/minio/raw/master/screenshot.png)

如果您需要自动化备份、带 SSL 终止的反向代理、防火墙、自动化操作系统和软件更新，以及由 Linux 专家和开源爱好者组成的团队确保服务始终安全可用，可在 [elest.io](https://elest.io/) 上部署 [完全托管的 MinIO](https://elest.io/open-source/minio)。

[![deploy](https://github.com/elestio-examples/minio/raw/master/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/minio)


## 镜像概述和主要用途

MinIO 作为云原生对象存储，旨在提供高可用性、高吞吐量和兼容性，兼容 Amazon S3 API。其主要用途包括：
- 构建企业级数据湖，存储和处理海量非结构化数据
- 作为数据库的后端存储，支持数据持久化
- 为 AI/ML 工作流提供高性能数据存储
- 支撑 SaaS 应用程序的对象存储需求
- 实现快速备份与灾难恢复解决方案


## 核心功能和特性

### MinIO 核心功能
- **云原生架构**：专为容器化和分布式环境设计，支持横向扩展
- **S3 兼容性**：完全兼容 Amazon S3 API，降低迁移成本
- **高性能**：优化的存储引擎，支持高吞吐量和低延迟访问
- **多平台支持**：可部署在公有云、私有云、边缘设备等各种基础设施
- **数据安全**：支持服务端加密、客户端加密、访问控制策略等安全特性

### Elestio 镜像优势
- **与上游同步**：Elestio 持续跟踪原始源码更新，通过自动化流程快速发布新版本镜像
- **及时修复与更新**：提供最新的 bug 修复和功能特性
- **质量控制**：专业团队进行质量检查，确保发布的产品符合高标准


## 使用场景和适用范围

MinIO 适用于以下场景：
- **企业数据湖**：存储结构化和非结构化数据，支持大数据分析
- **AI/ML 数据存储**：为机器学习模型训练提供高吞吐量的数据访问
- **SaaS 应用后端**：为多租户 SaaS 应用提供安全、隔离的对象存储
- **数据库备份**：作为数据库的备份目标，支持增量备份和版本控制
- **边缘计算存储**：在边缘设备部署，满足低延迟数据处理需求


## 详细的使用方法和配置说明

### 环境准备

#### Git 克隆项目

通过以下命令快速部署：

```bash
git clone https://github.com/elestio-examples/minio.git
```

#### 配置环境变量

复制测试环境的 `.env` 文件到项目目录：

```bash
cp ./tests/.env ./.env
```

编辑 `.env` 文件，设置自定义值，关键环境变量说明：
- `SOFTWARE_VERSION_TAG`：MinIO 镜像版本标签
- `ADMIN_EMAIL`：MinIO 管理员用户名（对应 `MINIO_ROOT_USER`）
- `ADMIN_PASSWORD`：MinIO 管理员密码（对应 `MINIO_ROOT_PASSWORD`）
- `DOMAIN`：访问域名（用于浏览器重定向和服务器 URL）

#### 创建数据目录并设置权限

```bash
mkdir -p ./data
chown -R 1000:1000 ./data  # 设置与容器内用户一致的权限（UID:GID=1000:1000）
```

### Docker Compose 部署

#### Docker Compose 配置示例

```yaml
version: '3.3'
services:
  minio:
    image: elestio/minio:${SOFTWARE_VERSION_TAG}
    restart: always
    dns:
      - 8.8.8.8
    ports:
      - "172.17.0.1:9000:9000"  # S3 API 端口
      - "172.17.0.1:9001:9001"  # Web 控制台端口
    volumes:
      - ./data:/data  # 数据持久化目录
    environment:
      MINIO_ROOT_USER: ${ADMIN_EMAIL}          # 管理员用户名
      MINIO_ROOT_PASSWORD: ${ADMIN_PASSWORD}    # 管理员密码
      MINIO_BROWSER_REDIRECT_URL: https://${DOMAIN}  # 浏览器重定向 URL
      MINIO_SERVER_URL: https://${DOMAIN}:34256     # 服务器 API URL
    command: server --address ":9000" --console-address ":9001" /data  # 启动命令，指定端口和数据目录
```

#### 启动服务

```bash
docker-compose up -d
```

服务启动后，通过以下地址访问 Web 控制台：`http://your-domain:9001`（将 `your-domain` 替换为实际域名或 IP）


## 维护说明

### 日志查看

Elestio MinIO 镜像将容器日志输出到标准输出（stdout），通过以下命令查看日志：

```bash
docker-compose logs -f
```

停止服务：

```bash
docker-compose down
```

### 备份与恢复

通过文件夹卷挂载实现数据持久化，备份和恢复操作简单便捷：

#### 创建备份归档

进入 `docker-compose.yml` 所在目录，执行以下命令创建 ZIP 归档：

```bash
zip -r myarchive.zip .  # 归档当前目录下所有文件（含数据和配置）
```

#### 从归档恢复

将归档文件解压到原始目录：

```bash
unzip myarchive.zip -d /path/to/original/folder  # 将 /path/to/original/folder 替换为实际目录
```

#### 启动服务

恢复完成后，启动服务：

```bash
docker-compose up -d
```


## 相关链接

- [MinIO GitHub 仓库](https://github.com/minio/minio)
- [MinIO 官方文档](https://min.io/docs/minio/linux/index.html)
- [Elestio/MinIO GitHub 仓库](https://github.com/elestio-examples/minio)
