---
image: softwareplant/psql
description: "为JIRA实例预先配置的PostgreSQL数据库镜像"
source: https://xuanyuan.cloud/zh/r/softwareplant/psql
canonical: https://xuanyuan.cloud/zh/r/softwareplant/psql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/softwareplant/psql" title="softwareplant/psql Docker 镜像中文简介、标签列表与拉取命令">softwareplant/psql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# JIRA专用PostgreSQL数据库镜像

## 1. 镜像概述与主要用途

本镜像是基于官方PostgreSQL构建的专用数据库镜像，专为JIRA Server/Data Center实例设计。通过预配置JIRA所需的数据库环境（包括推荐参数、用户与权限设置），简化JIRA部署流程，确保数据库层与JIRA应用的兼容性和最佳性能。


## 2. 核心功能与特性

- **基于官方稳定版本**：构建于PostgreSQL官方镜像（当前支持14.x/15.x LTS版本），确保数据库安全性与稳定性。
- **JIRA预配置环境**：自动创建JIRA专用数据库（默认`jira_db`）及用户（默认`jira_user`），无需手动执行初始化SQL。
- **性能优化参数**：内置Atlassian推荐的数据库配置（如`shared_buffers`、`work_mem`、连接池设置），适配JIRA数据读写特性。
- **标准化编码与时区**：默认启用`UTF8`编码、`UTC`时区，符合JIRA国际化与时间戳处理要求。
- **兼容官方生态**：支持PostgreSQL官方镜像的所有标准功能（如数据持久化、SSL加密、扩展安装）。


## 3. 使用场景与适用范围

- **JIRA部署场景**：适用于JIRA Server（8.x及以上）、JIRA Data Center的开发、测试及生产环境。
- **快速环境搭建**：简化CI/CD流程中JIRA测试环境的自动化部署，无需手动配置数据库。
- **中小团队应用**：为50人以下团队的JIRA实例提供开箱即用的数据库解决方案。


## 4. 使用方法与配置说明

### 4.1 快速启动（`docker run`命令）

通过以下命令快速启动JIRA专用PostgreSQL容器：

```bash
docker run -d \
  --name jira-postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=SecurePass123 \  # 必选：JIRA数据库用户密码
  -e POSTGRES_DB=custom_jira_db \       # 可选：自定义数据库名（默认jira_db）
  -e POSTGRES_USER=custom_jira_user \   # 可选：自定义数据库用户（默认jira_user）
  -e SHARED_BUFFERS=512MB \             # 可选：调整性能参数（默认256MB）
  -v jira-pg-data:/var/lib/postgresql/data \  # 持久化数据卷
  your-registry/jira-postgres:14        # 镜像名:标签（替换为实际镜像地址）
```


### 4.2 Docker Compose配置示例

以下是JIRA与数据库的完整编排示例（`docker-compose.yml`）：

```yaml
version: '3.8'

services:
  # JIRA专用PostgreSQL数据库
  postgres:
    image: docker.xuanyuan.run/your-registry/jira-postgres:14
    container_name: jira-postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: SecurePass123  # 数据库用户密码（必填）
      POSTGRES_DB: jira_db              # 数据库名（默认jira_db）
      POSTGRES_USER: jira_user          # 数据库用户（默认jira_user）
      POSTGRES_INITDB_ARGS: "--lc-collate=C --lc-ctype=en_US.UTF-8"  # 排序规则配置
      JIRA_DB_TIMEZONE: Asia/Shanghai   # 自定义时区（默认UTC）
      MAX_CONNECTIONS: 300              # 最大连接数（默认200）
    volumes:
      - jira-pg-data:/var/lib/postgresql/data  # 数据持久化卷
    ports:
      - "5432:5432"  # 端口映射（生产环境建议仅内部网络访问，不暴露公网）
    networks:
      - jira-net     # 与JIRA共享网络

  # JIRA应用容器（示例）
  jira:
    image: docker.xuanyuan.run/atlassian/jira-software:latest
    container_name: jira-app
    restart: always
    depends_on:
      - postgres
    environment:
      ATL_JDBC_URL: jdbc:postgresql://postgres:5432/jira_db  # 数据库连接URL
      ATL_JDBC_USER: jira_user                               # 数据库用户
      ATL_JDBC_PASSWORD: SecurePass123                       # 数据库密码
      ATL_DB_TYPE: postgres72                                # 数据库类型
    ports:
      - "8080:8080"
    networks:
      - jira-net

volumes:
  jira-pg-data:  # 命名卷，自动创建并持久化数据

networks:
  jira-net:      # 自定义网络，隔离JIRA服务组
```


### 4.3 环境变量配置说明

| 环境变量名               | 描述                                  | 默认值          | 是否必填 |
|--------------------------|---------------------------------------|-----------------|----------|
| `POSTGRES_PASSWORD`      | JIRA数据库用户密码（`POSTGRES_USER`对应的密码） | 无              | **是**   |
| `POSTGRES_DB`            | JIRA专用数据库名称                    | `jira_db`       | 否       |
| `POSTGRES_USER`          | JIRA数据库用户名（具有数据库所有权限） | `jira_user`     | 否       |
| `POSTGRES_INITDB_ARGS`   | 数据库初始化参数（如编码、排序规则）  | `--encoding=UTF8` | 否       |
| `JIRA_DB_TIMEZONE`       | 数据库时区配置                        | `UTC`           | 否       |
| `MAX_CONNECTIONS`        | 数据库最大连接数（JIRA并发用户多时需调大） | `200`           | 否       |
| `SHARED_BUFFERS`         | PostgreSQL内存缓冲区大小（建议为物理内存1/4） | `256MB`         | 否       |
| `WORK_MEM`               | 每个连接的排序/哈希操作内存限制       | `16MB`          | 否       |


### 4.4 数据持久化

通过挂载Docker卷（`/var/lib/postgresql/data`）实现数据持久化，避免容器重启或删除导致数据丢失。推荐使用**命名卷**（如示例中的`jira-pg-data`）而非主机目录，简化权限管理。


### 4.5 网络与连接

- **内部网络访问**：JIRA容器与数据库容器需在同一网络（如示例中的`jira-net`），通过容器名（`postgres`）访问数据库，连接URL格式为：`jdbc:postgresql://<容器名>:5432/<数据库名>`。
- **外部访问控制**：生产环境建议不暴露`5432`端口到公网，通过JIRA容器内部访问；如需外部管理（如备份工具），可限制IP访问（通过`docker run --ip`或主机防火墙）。


## 5. 注意事项

- **生产环境安全**：敏感信息（如`POSTGRES_PASSWORD`）建议通过Docker Secrets或环境变量管理工具（如HashiCorp Vault）注入，避免明文配置。
- **性能调优**：根据JIRA用户规模调整参数（如`MAX_CONNECTIONS`、`SHARED_BUFFERS`），参考[Atlassian官方数据库调优文档](https://confluence.atlassian.com/adminjiraserver/database-configuration-938847878.html)。
- **备份策略**：定期备份`/var/lib/postgresql/data`卷数据，推荐使用`pg_dump`工具生成逻辑备份：
  ```bash
  docker exec jira-postgres pg_dump -U jira_user jira_db > jira_db_backup_$(date +%Y%m%d).sql
  ```
- **版本兼容性**：确保镜像PostgreSQL版本与JIRA兼容（JIRA 8.x支持PostgreSQL 11-14，JIRA 9.x支持12-15）。
