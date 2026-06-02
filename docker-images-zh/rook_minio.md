---
image: rook/minio
description: "Minio是面向云原生环境的高性能分布式对象存储服务器。"
source: https://xuanyuan.cloud/zh/r/rook/minio
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[rook/minio](https://xuanyuan.cloud/zh/r/rook/minio)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Minio Docker镜像文档


## 镜像概述和主要用途

Minio Docker镜像是高性能分布式对象存储服务器Minio的容器化部署版本，专为云原生环境设计。Minio兼容Amazon S3 API，可用于存储非结构化数据（如图片、视频、日志、备份文件等），支持单机和分布式部署模式，提供高可用、高扩展性的对象存储服务。其核心定位是为云原生应用、大数据分析、机器学习等场景提供轻量、高效、兼容S3标准的存储解决方案。


## 核心功能和特性

### 高性能
- 基于Go语言开发，原生支持POSIX文件系统接口，读写性能接近裸盘速度，单节点可支持GB/s级吞吐量。
- 优化的I/O路径设计，适合处理大量小文件或大文件存储场景。

### S3 API兼容
- 完全兼容Amazon S3 v2/v4 API，支持S3标准操作（如PUT/GET/DELETE对象、桶管理、访问控制策略等），可无缝对接现有S3生态工具（如AWS CLI、s3cmd、boto3等）。

### 分布式架构
- 支持横向扩展，通过添加节点实现存储容量和性能线性增长，单集群可扩展至PB级存储容量。
- 分布式模式下自动实现数据分片和冗余，支持纠删码（Erasure Coding）和副本机制，确保数据可靠性。

### 云原生支持
- 原生支持Kubernetes部署，提供Operator和Helm Chart，可无缝集成云原生容器编排平台。
- 支持容器化部署（Docker、Podman等），适配微服务架构和DevOps工作流。

### 数据保护
- 内置纠删码（默认4+2模式，支持自定义配置），允许最多N-1个节点故障（N为纠删码分片数），数据不丢失。
- 支持对象版本控制、生命周期管理、数据加密（传输加密TLS/SSL、存储加密SSE）。

### 安全特性
- 基于角色的访问控制（RBAC），支持细粒度权限管理（IAM策略）。
- 支持多因素认证（MFA）、临时访问凭证、IP白名单等安全机制。


## 使用场景和适用范围

### 云原生应用后端存储
- 作为容器化应用（如微服务、Serverless函数）的静态资源存储（图片、附件、配置文件等），通过S3 API提供统一存储接口。

### 大数据分析存储层
- 存储海量结构化/非结构化数据（如日志、传感器数据、用户行为数据），供Spark、Hadoop等大数据框架直接读取分析（支持S3A协议）。

### 机器学习数据存储
- 存储训练数据集、模型文件、中间结果，支持高并发读写，满足机器学习训练过程中的数据访问需求。

### 私有S3兼容存储服务
- 替代公有云S3服务，在企业内部构建私有对象存储，满足数据本地化、合规性（如GDPR、等保）要求。

### DevOps环境 artifact存储
- 存储CI/CD流程中的构建产物（如Docker镜像、二进制包、测试报告），支持版本控制和快速检索。


## 使用方法和配置说明

### 基本使用（docker run）

#### 单机模式（默认）
通过`docker run`快速启动Minio单机实例，适用于开发测试或小规模生产环境：

```bash
docker run -d \
  --name minio \
  -p 9000:9000 \  # S3 API端口
  -p 9001:9001 \  # Web控制台端口（可选，默认自动分配）
  -e "MINIO_ROOT_USER=admin" \  # 管理员用户名（至少3字符）
  -e "MINIO_ROOT_PASSWORD=password123" \  # 管理员密码（至少8字符）
  -v /path/on/host:/data \  # 挂载主机目录作为数据存储（持久化）
  minio/minio server /data --console-address ":9001"
```

启动后，通过`http://<主机IP>:9001`访问Web控制台，使用`MINIO_ROOT_USER`和`MINIO_ROOT_PASSWORD`登录；S3 API访问地址为`http://<主机IP>:9000`。


### docker-compose配置示例

使用`docker-compose.yml`定义服务，便于管理依赖和配置：

```yaml
version: '3.8'

services:
  minio:
    image: minio/minio
    container_name: minio
    restart: always  # 自动重启
    ports:
      - "9000:9000"   # S3 API端口
      - "9001:9001"   # Web控制台端口
    environment:
      MINIO_ROOT_USER: admin          # 管理员用户名
      MINIO_ROOT_PASSWORD: password123  # 管理员密码
      MINIO_SERVER_URL: "http://minio.example.com:9000"  # 外部访问API的URL（可选）
    volumes:
      - minio_data:/data  # 使用命名卷持久化数据（推荐）
    command: server /data --console-address ":9001"

volumes:
  minio_data:  # 定义命名卷，数据存储在Docker管理的卷中
```

启动命令：`docker-compose up -d`


### 持久化存储配置

Minio默认将数据存储在容器内`/data`目录，容器重启后数据会丢失。需通过以下方式实现持久化：

#### 1. 主机目录挂载（适用于单机）
```bash
docker run -d \
  --name minio \
  -p 9000:9000 -p 9001:9001 \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=password123" \
  -v /opt/minio/data:/data \  # 主机目录/opt/minio/data映射到容器/data
  minio/minio server /data --console-address ":9001"
```

#### 2. Docker命名卷（推荐）
通过Docker命名卷管理存储，数据由Docker引擎维护，避免主机目录权限问题：
```bash
# 创建命名卷（若未在docker-compose中定义）
docker volume create minio_data

# 启动容器时挂载命名卷
docker run -d \
  --name minio \
  -p 9000:9000 -p 9001:9001 \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=password123" \
  -v minio_data:/data \  # 挂载命名卷minio_data
  minio/minio server /data --console-address ":9001"
```


### 分布式部署示例

分布式模式下，Minio将数据分片存储在多个节点，提升容量和可用性。以下为2节点分布式部署示例（实际生产建议至少4节点）：

#### 节点1（IP: 192.168.1.10）：
```bash
docker run -d \
  --name minio-node1 \
  -p 9000:9000 -p 9001:9001 \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=password123" \
  -v /opt/minio/node1/data:/data \
  minio/minio server \
    http://192.168.1.10:9000/data \  # 节点1数据路径
    http://192.168.1.11:9000/data \  # 节点2数据路径
  --console-address ":9001"
```

#### 节点2（IP: 192.168.1.11）：
```bash
docker run -d \
  --name minio-node2 \
  -p 9000:9000 -p 9001:9001 \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=password123" \
  -v /opt/minio/node2/data:/data \
  minio/minio server \
    http://192.168.1.10:9000/data \  # 节点1数据路径
    http://192.168.1.11:9000/data \  # 节点2数据路径
  --console-address ":9001"
```

> **注意**：分布式部署需确保所有节点间网络互通，且数据目录（`/data`）在各节点独立持久化；节点数和磁盘数需满足纠删码配置要求（默认至少4个磁盘，支持4+2纠删码）。


## 环境变量与配置参数

### 核心环境变量

| 环境变量名                | 说明                                                                 | 默认值                |
|--------------------------|----------------------------------------------------------------------|-----------------------|
| `MINIO_ROOT_USER`        | 管理员用户名，用于Web控制台登录和API访问（S3 Access Key）             | 无（必须显式配置）    |
| `MINIO_ROOT_PASSWORD`    | 管理员密码，用于Web控制台登录和API访问（S3 Secret Key）              | 无（必须显式配置）    |
| `MINIO_SERVER_URL`       | 外部访问Minio API的基础URL（用于生成预签名URL、通知回调等）           | 自动检测容器IP:端口   |
| `MINIO_BROWSER`          | 是否启用Web控制台（`on`/`off`）                                      | `on`                  |
| `MINIO_VOLUMES`          | 指定存储卷路径（分布式模式下可指定多个节点路径，如`http://node{1...4}/data`） | 启动命令中`server`后的路径 |
| `MINIO_REGION`           | 配置默认存储区域（如`us-east-1`），兼容S3区域概念                     | `us-east-1`           |
| `MINIO_STORAGE_CLASS_STANDARD` | 标准存储类的纠删码配置（如`EC:4`表示4个数据分片，无冗余）       | `EC:4`（分布式模式）  |


### 命令行配置参数

启动命令中`server`子命令支持以下常用参数：

| 参数                  | 说明                                                                 |
|-----------------------|----------------------------------------------------------------------|
| `--console-address`   | 指定Web控制台监听地址和端口（如`:9001`），默认随机端口               |
| `--address`           | 指定S3 API监听地址和端口（如`:9000`）                                |
| `--config-dir`        | 指定配置文件存储目录（默认`~/.minio`）                               |
| `--quiet`             | 静默模式，仅输出错误日志                                             |
| `--verbose`           | 详细日志模式，输出调试信息                                           |


## 注意事项

1. **安全建议**：生产环境中需使用强密码（`MINIO_ROOT_PASSWORD`至少12字符），并启用TLS/SSL（通过`--certs-dir`指定证书路径）。
2. **性能优化**：存储目录建议使用SSD或高性能文件系统（如XFS），分布式部署时确保节点间网络带宽充足（推荐10Gbps）。
3. **备份策略**：定期备份Minio数据目录，或通过Minio的复制功能（Replication）实现跨区域数据备份。
4. **版本兼容性**：升级镜像时需注意版本间兼容性，参考[Minio官方升级文档](https://min.io/docs/minio/linux/operations/upgrades.html)。
