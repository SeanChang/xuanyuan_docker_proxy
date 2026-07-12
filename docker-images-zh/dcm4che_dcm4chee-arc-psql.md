---
image: dcm4che/dcm4chee-arc-psql
description: "dcm4che归档组件5，采用PostgreSQL数据库，用于医疗影像的归档存储与管理。"
source: https://xuanyuan.cloud/zh/r/dcm4che/dcm4chee-arc-psql
canonical: https://xuanyuan.cloud/zh/r/dcm4che/dcm4chee-arc-psql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dcm4che/dcm4chee-arc-psql" title="dcm4che/dcm4chee-arc-psql Docker 镜像中文简介、标签列表与拉取命令">dcm4che/dcm4chee-arc-psql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# dcm4chee-arc-psql Docker镜像文档

## 1. 镜像概述和主要用途

### 1.1 概述
dcm4chee-arc-psql是基于dcm4chee Archive 5构建的Docker镜像，集成PostgreSQL数据库，提供开源的DICOM（数字成像和通信医学）归档解决方案。该镜像简化了医学影像数据的存储、检索、管理及共享流程，适用于医疗影像相关系统的快速部署。

### 1.2 主要用途
- 医学影像归档：存储医院、影像中心产生的DICOM图像及元数据
- 影像检索服务：支持DICOM C-FIND/C-MOVE及DICOMweb QIDO-RS/WADO-RS协议
- 医疗系统集成：与PACS、RIS、HIS等医疗信息系统对接
- 科研数据管理：为医学影像研究提供标准化数据管理平台

## 2. 核心功能和特性

### 2.1 DICOM服务支持
- DICOM存储服务（C-STORE SCP）：接收并持久化DICOM图像
- 查询/检索服务：支持C-FIND（查询）、C-MOVE（检索）、C-GET操作
- 工作列表管理：处理DICOM Modality Worklist (MWL) 和HL7 Order消息

### 2.2 DICOMweb支持
- RESTful API接口：QIDO-RS（影像查询）、WADO-RS（影像获取）、STOW-RS（影像存储）
- 兼容IHE规范：支持跨机构文档共享与工作流集成

### 2.3 数据库集成
- PostgreSQL原生支持：内置数据库适配，无需额外配置
- 数据分层存储：支持元数据与影像文件分离存储

### 2.4 系统特性
- 高可用性：支持多实例集群部署
- 可扩展性：模块化架构，支持功能模块按需扩展
- 标准化兼容：符合DICOM 3.14标准及IHE工作流规范

## 3. 使用场景和适用范围

### 3.1 适用场景
- 中小型医院PACS系统部署
- 区域医疗影像中心数据集中管理
- 远程医疗影像传输与共享平台
- 医学影像科研项目数据管理

### 3.2 适用范围
- 医疗机构：放射科、超声科、病理科等影像产生科室
- 第三方医疗IT厂商：基于开源组件构建定制化解决方案
- 科研机构：医学影像AI研究、临床数据挖掘项目

## 4. 使用方法和配置说明

### 4.1 环境要求
- Docker Engine 20.10+
- Docker Compose 2.0+（推荐）
- 内存：最低2GB（生产环境建议4GB+）
- 存储：根据影像数据量配置（建议10GB+初始空间）

### 4.2 快速启动（docker run）

#### 4.2.1 基本命令
```bash
docker run -d \
  --name dcm4chee-arc \
  -p 11112:11112 \  # DICOM端口
  -p 8080:8080 \    # HTTP端口
  -e POSTGRES_DB=dcm4chee \
  -e POSTGRES_USER=dcm4chee \
  -e POSTGRES_PASSWORD=secret \
  -e DB_HOST=localhost \
  -v dcm4chee-data:/opt/dcm4chee-arc/server/default/archive \
  dcm4che/dcm4chee-arc-psql:latest
```

#### 4.2.2 参数说明
- `-p 11112:11112`：DICOM协议端口映射（TCP）
- `-p 8080:8080`：HTTP端口映射（DICOMweb服务与管理界面）
- `-v dcm4chee-data`：挂载卷用于DICOM影像文件持久化

### 4.3 Docker Compose部署（推荐）

#### 4.3.1 docker-compose.yml配置
```yaml
version: '3.8'

services:
  postgres:
    image: docker.xuanyuan.run/postgres:14-alpine
    container_name: dcm4chee-db
    environment:
      POSTGRES_DB: dcm4chee
      POSTGRES_USER: dcm4chee
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

  archive:
    image: docker.xuanyuan.run/dcm4che/dcm4chee-arc-psql:latest
    container_name: dcm4chee-arc
    depends_on:
      - postgres
    ports:
      - "11112:11112"  # DICOM
      - "8080:8080"    # HTTP
    environment:
      POSTGRES_DB: dcm4chee
      POSTGRES_USER: dcm4chee
      POSTGRES_PASSWORD: secret
      DB_HOST: postgres
      DICOM_AET: DCM4CHEE
      ARCHIVE_NAME: PrimaryArchive
    volumes:
      - dcm4chee-data:/opt/dcm4chee-arc/server/default/archive
    restart: unless-stopped

volumes:
  postgres-data:
  dcm4chee-data:
```

#### 4.3.2 启动命令
```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f archive
```

### 4.4 服务访问
- DICOM服务：`host:11112`（AET：DCM4CHEE）
- Web管理界面：`http://host:8080/dcm4chee-arc/ui`
- DICOMweb端点：
  - QIDO-RS：`http://host:8080/dcm4chee-arc/aets/DCM4CHEE/rs/studies`
  - WADO-RS：`http://host:8080/dcm4chee-arc/aets/DCM4CHEE/rs/studies/{studyUID}`

## 5. 配置参数说明

### 5.1 数据库配置
| 环境变量               | 描述                 | 默认值       |
|------------------------|----------------------|--------------|
| POSTGRES_DB            | 数据库名称           | dcm4chee     |
| POSTGRES_USER          | 数据库访问用户       | dcm4chee     |
| POSTGRES_PASSWORD      | 数据库用户密码       | secret       |
| DB_HOST                | 数据库主机地址       | localhost    |
| DB_PORT                | 数据库端口           | 5432         |
| DB_CONNECT_TIMEOUT     | 连接超时（秒）       | 30           |

### 5.2 归档服务配置
| 环境变量               | 描述                 | 默认值       |
|------------------------|----------------------|--------------|
| ARCHIVE_NAME           | 归档实例名称         | archive      |
| DICOM_AET              | DICOM应用实体标题    | DCM4CHEE     |
| DICOM_PORT             | DICOM监听端口        | 11112        |
| HTTP_PORT              | HTTP服务端口         | 8080         |
| MAX_INSTANCES          | 最大并发DICOM实例数  | 100          |

### 5.3 网络配置
| 环境变量               | 描述                 | 默认值       |
|------------------------|----------------------|--------------|
| HOSTNAME               | 服务主机名           | 容器ID       |
| ALLOWED_ORIGINS        | CORS允许源           | *            |
| PROXY_BASE_URL         | 反向代理基础URL      | 未设置       |

## 6. 注意事项

### 6.1 数据持久化
- 必须通过Docker卷挂载`postgres-data`和`dcm4chee-data`目录，避免容器重启导致数据丢失
- 定期备份卷数据：`docker run --rm -v postgres-data:/source -v $(pwd):/backup alpine tar -czf /backup/postgres-backup.tar.gz -C /source .`

### 6.2 性能调优
- 生产环境建议配置：4核CPU、8GB RAM、SSD存储
- 根据DICOM图像吞吐量调整`MAX_INSTANCES`参数（默认100）

### 6.3 升级说明
- 升级前必须备份数据
- 通过`docker-compose pull archive`获取新版本镜像
- 跨版本升级需参考官方数据库迁移文档
