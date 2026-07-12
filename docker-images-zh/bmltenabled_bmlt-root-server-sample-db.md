---
image: bmltenabled/bmlt-root-server-sample-db
description: "BMLT示例数据库镜像，提供Basic Meeting List Toolbox系统的示例数据，用于测试、演示及开发环境的快速部署与验证。"
source: https://xuanyuan.cloud/zh/r/bmltenabled/bmlt-root-server-sample-db
canonical: https://xuanyuan.cloud/zh/r/bmltenabled/bmlt-root-server-sample-db
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bmltenabled/bmlt-root-server-sample-db" title="bmltenabled/bmlt-root-server-sample-db Docker 镜像中文简介、标签列表与拉取命令">bmltenabled/bmlt-root-server-sample-db 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# BMLT Sample DB Docker镜像文档


## 镜像概述和主要用途  
BMLT Sample DB是用于配合`bmlt-root-server`镜像及调试镜像的示例数据库镜像。该镜像基于经过PII（个人身份信息）清理的GNYR根服务器数据库构建，主要用途是为BMLT根服务器的开发、测试及调试场景提供预配置的示例数据环境，简化相关服务的环境搭建流程。


## 核心功能与特性  
- **PII安全保障**：内置经过严格清理的GNYR根服务器数据库，已移除个人身份信息，符合数据隐私要求  
- **即开即用**：预配置BMLT根服务器所需的完整数据库结构及示例数据，无需手动初始化  
- **场景适配**：专为`bmlt-root-server`镜像及调试场景优化，可直接联动使用  
- **轻量高效**：镜像体积精简，支持本地开发环境或测试服务器快速部署  


## 使用场景与适用范围  
### 使用场景  
- 开发人员在本地开发`bmlt-root-server`时，需快速获取可用的示例数据库环境  
- 测试BMLT根服务器功能时，需标准化的示例数据支撑功能验证  
- 演示BMLT相关服务时，作为配套数据层提供可直接使用的示例数据  

### 适用范围  
- **仅限开发、测试及调试阶段**，不支持生产环境（示例数据不具备生产级完整性和安全性）  
- BMLT根服务器（`bmlt-root-server`）相关的开发与测试流程  


## 使用方法与配置说明  

### 基本使用（Docker Run）  
通过`docker run`命令直接启动镜像，默认配置下可与`bmlt-root-server`联动：  

```bash
docker run -d \
  --name bmlt-sample-db \
  -p 5432:5432 \  # 端口示例（假设基于PostgreSQL，实际端口需根据数据库类型调整）
  --restart unless-stopped \
  bmlt-sample-db:latest
```

### Docker Compose配置示例  
与`bmlt-root-server`联动部署时，推荐使用`docker-compose`简化配置：  

```yaml
version: '3.8'
services:
  # BMLT示例数据库服务
  bmlt-db:
    image: docker.xuanyuan.run/bmlt-sample-db:latest
    container_name: bmlt-sample-db
    ports:
      - "5432:5432"  # 数据库端口（根据实际数据库类型调整，如MySQL默认3306）
    volumes:
      - bmlt-db-data:/var/lib/postgresql/data  # 可选：挂载数据卷持久化示例数据
    environment:
      - POSTGRES_USER=sample_user  # 示例用户名（根据镜像实际默认值调整）
      - POSTGRES_PASSWORD=sample_pass  # 示例密码（根据镜像实际默认值调整）
      - POSTGRES_DB=gnyr_sample  # 示例数据库名（默认通常为GNYR根服务器数据库名）

  # BMLT根服务器服务
  bmlt-root-server:
    image: docker.xuanyuan.run/bmlt-root-server:latest
    container_name: bmlt-root-server
    depends_on:
      - bmlt-db  # 依赖数据库服务启动
    ports:
      - "80:80"  # BMLT根服务器端口
    environment:
      - DB_HOST=bmlt-db  # 数据库服务名（与docker-compose服务名一致）
      - DB_PORT=5432  # 数据库端口（与上方bmlt-db端口一致）
      - DB_USER=sample_user  # 与数据库服务环境变量保持一致
      - DB_PASSWORD=sample_pass  # 与数据库服务环境变量保持一致
      - DB_NAME=gnyr_sample  # 与数据库服务环境变量保持一致

volumes:
  bmlt-db-data:  # 数据卷用于持久化示例数据库数据
```


### 配置说明  
#### 核心参数（示例）  
由于镜像未提供详细配置文档，以下为基于常规数据库镜像的通用参数说明（实际请以官方文档为准）：  

| 参数                | 说明                                  | 默认值示例          |
|---------------------|---------------------------------------|---------------------|
| `DB_PORT`           | 数据库服务端口                        | 5432（PostgreSQL）  |
| `DB_USER`           | 数据库访问用户名                      | `sample_user`       |
| `DB_PASSWORD`       | 数据库访问密码                        | `sample_pass`       |
| `DB_NAME`           | 示例数据库名称                        | `gnyr_sample`       |

#### 数据持久化  
通过Docker数据卷（如上述`docker-compose`示例中的`bmlt-db-data`卷）挂载数据库数据目录，可保留容器重启后的示例数据。


### 注意事项  
- **生产环境禁用**：本镜像仅含示例数据，无生产级数据安全保障，禁止用于生产环境  
- **凭据安全**：示例默认凭据（用户名/密码）需根据实际场景修改，避免使用弱口令  
- **数据库类型适配**：需根据`bmlt-root-server`要求确认数据库类型（如PostgreSQL、MySQL），并调整端口及配置参数  
- **版本兼容性**：建议使用与`bmlt-root-server`版本匹配的`bmlt-sample-db`镜像，避免数据结构不兼容  


## 总结  
BMLT Sample DB镜像通过提供PII清理的示例数据，为`bmlt-root-server`的开发、测试及调试提供了便捷的环境支持。用户可通过简单的Docker命令或`docker-compose`配置快速部署，降低环境搭建成本。使用时需注意其仅适用于非生产场景，并确保与目标服务版本兼容。
