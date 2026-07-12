---
image: metabase/metabase-enterprise
description: "Metabase企业版Docker镜像，提供数据分析、报表生成与数据可视化功能，具备企业级安全、协作及高级支持特性，便于快速部署和集成到企业数据环境中。"
source: https://xuanyuan.cloud/zh/r/metabase/metabase-enterprise
canonical: https://xuanyuan.cloud/zh/r/metabase/metabase-enterprise
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/metabase/metabase-enterprise" title="metabase/metabase-enterprise Docker 镜像中文简介、标签列表与拉取命令">metabase/metabase-enterprise 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Metabase Enterprise Edition Docker镜像文档


## 1. 镜像概述与主要用途

Metabase Enterprise Edition Docker镜像是Metabase数据分析平台的企业级容器化分发版本。作为付费订阅产品，该镜像提供了基础版（Open Source）之外的企业级功能，主要用于：  
- 管理大规模数据分析部署（如多团队协作、跨部门数据共享）  
- 为客户或内部用户提供交互式嵌入式分析能力（将Metabase分析功能集成至自有应用）  
- 满足企业级数据治理、安全与合规需求。  


## 2. 核心功能与特性

该镜像包含Metabase企业版专属功能，支持企业级场景需求：  
- **高级部署管理**：支持大型集群部署、负载均衡与横向扩展，适配企业级IT架构。  
- **交互式嵌入式分析**：提供API与SDK，可将仪表盘、报表无缝嵌入第三方应用，支持白标定制。  
- **企业级安全与权限**：包含细粒度访问控制、SAML/OAuth单点登录（SSO）、审计日志等功能。  
- **性能优化**：针对大规模数据集查询优化，支持异步查询、结果缓存与资源隔离。  


## 3. 使用场景与适用范围

### 适用场景  
- **大型组织数据分析平台**：企业内部跨部门数据协作、统一数据门户建设。  
- **SaaS应用嵌入式分析**：为SaaS产品集成客户数据可视化功能（如电商平台销售报表、SaaS用户行为分析）。  
- **企业数据治理与合规**：需满足严格数据访问审计、权限管控的金融、医疗等行业。  

### 适用规模  
- 支持数百至数千用户的并发访问。  
- 适配TB级以上数据集的查询与分析需求。  


## 4. 使用方法与配置说明

### 4.1 前提条件  
- 有效的Metabase Enterprise Edition许可证密钥（获取方式参见[Metabase企业版激活文档](https://www.metabase.com/docs/latest/paid-features/activating-the-enterprise-edition#how-to-activate-your-token-when-self-hosting)）。  
- Docker环境（19.03+）或Docker Compose（2.0+）。  


### 4.2 快速启动（测试环境）  
通过`docker run`命令快速启动容器，适用于功能验证：  

```bash
docker run -d \
  -p 3000:3000 \
  -e MB_LICENSE_KEY="your-enterprise-license-key" \
  --name metabase-enterprise \
  docker.xuanyuan.run/metabase/metabase-enterprise:latest
```  

- **参数说明**：  
  - `-p 3000:3000`：映射容器3000端口至主机（Metabase默认Web端口）。  
  - `-e MB_LICENSE_KEY`：设置企业版许可证密钥（替换为实际密钥）。  
  - `metabase/metabase-enterprise:latest`：企业版镜像（指定`latest`或具体版本标签，如`v1.48.0`）。  

启动后，访问`http://localhost:3000`即可进入Metabase控制台。  


### 4.3 生产环境部署（推荐）  
生产环境需配置数据持久化、外部数据库（避免容器内默认H2数据库）及安全优化，推荐使用`docker-compose`：  

#### 4.3.1 docker-compose配置示例  
创建`docker-compose.yml`：  

```yaml
version: '3.8'
services:
  metabase:
    image: docker.xuanyuan.run/metabase/metabase-enterprise:latest
    container_name: metabase-enterprise
    restart: always
    ports:
      - "3000:3000"
    environment:
      # 企业版许可证
      MB_LICENSE_KEY: "your-enterprise-license-key"
      # 外部数据库配置（推荐PostgreSQL/MySQL，替代默认H2）
      MB_DB_TYPE: "postgres"
      MB_DB_DBNAME: "metabase"
      MB_DB_USER: "metabase_user"
      MB_DB_PASS: "secure_password"
      MB_DB_HOST: "postgres"
      MB_DB_PORT: "5432"
      # 其他配置（如时区、日志级别）
      TZ: "Asia/Shanghai"
      MB_LOG_LEVEL: "info"
    volumes:
      - metabase-data:/metabase-data  # 持久化应用数据（如上传文件、缓存）
    depends_on:
      - postgres

  postgres:  # 外部数据库（生产环境推荐独立部署，此处为示例）
    image: docker.xuanyuan.run/postgres:14
    container_name: metabase-db
    restart: always
    environment:
      POSTGRES_DB: "metabase"
      POSTGRES_USER: "metabase_user"
      POSTGRES_PASSWORD: "secure_password"
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  metabase-data:
  postgres-data:
```  

#### 4.3.2 启动生产环境  
```bash
# 启动服务
docker-compose up -d

# 查看日志（验证启动状态）
docker-compose logs -f metabase
```  


### 4.4 许可证激活  
企业版功能需通过许可证密钥激活，支持两种方式：  
1. **环境变量激活**：启动容器时通过`MB_LICENSE_KEY`注入密钥（推荐，如4.2/4.3示例）。  
2. **Web界面激活**：启动后访问`http://<主机IP>:3000`，在设置页面输入许可证密钥。  


## 5. 核心配置参数  

通过环境变量配置容器，常用参数如下：  

| 环境变量名          | 说明                                  | 示例值                          |  
|---------------------|---------------------------------------|---------------------------------|  
| `MB_LICENSE_KEY`    | 企业版许可证密钥（必填）              | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |  
| `MB_DB_TYPE`        | 外部数据库类型（生产必填）            | `postgres`/`mysql`              |  
| `MB_DB_DBNAME`      | 数据库名称                            | `metabase`                      |  
| `MB_DB_USER`        | 数据库用户名                          | `metabase_user`                 |  
| `MB_DB_PASS`        | 数据库密码                            | `secure_password`               |  
| `MB_DB_HOST`        | 数据库主机地址                        | `postgres`/`192.168.1.100`      |  
| `MB_DB_PORT`        | 数据库端口                            | `5432`（PostgreSQL默认）        |  
| `MB_HTTP_PORT`      | 应用监听端口（默认3000）              | `8080`                          |  
| `TZ`                | 时区设置                              | `Asia/Shanghai`                 |  


## 6. 注意事项  

- **许可证管理**：许可证密钥需与部署规模匹配，过期后企业功能将停用，需及时更新。  
- **数据持久化**：生产环境必须通过`volumes`挂载`/metabase-data`目录，避免容器重启导致数据丢失。  
- **外部数据库**：默认H2数据库仅适用于测试，生产环境需使用PostgreSQL、MySQL等外部数据库（参考4.3示例）。  
- **安全建议**：配置HTTPS（通过反向代理如Nginx）、限制容器网络访问、定期备份数据库。  
- **版本更新**：升级镜像前需备份数据，参考[Metabase升级文档](https://www.metabase.com/docs/latest/installation-and-operation/upgrading-metabase)。  


## 7. 相关资源  

- [Metabase企业版功能详情](https://www.metabase.com/product/enterprise)  
- [企业版激活文档](https://www.metabase.com/docs/latest/paid-features/activating-the-enterprise-edition)  
- [Docker部署最佳实践](https://www.metabase.com/docs/latest/installation-and-operation/running-metabase-on-docker)  
- [Metabase Cloud服务](https://www.metabase.com/pricing/)（托管版企业级部署）
