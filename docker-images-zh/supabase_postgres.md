<!-- xuanyuan-docker-images-zh
image: supabase/postgres
source: https://xuanyuan.cloud/zh/r/supabase/postgres
canonical: https://xuanyuan.cloud/zh/r/supabase/postgres
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [supabase/postgres — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/supabase/postgres "supabase/postgres Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/supabase/postgres

### supabase/postgres 镜像使用指南  

supabase/postgres 是基于 PostgreSQL 的 Docker 镜像，预集成了多种实用扩展，方便快速部署。以下是启动步骤及内置扩展说明。


### 快速开始  
更多信息可查看 [GitHub 仓库]([])。  

#### 1. 创建配置文件  
新建 `docker-compose.yml` 文件，根据镜像版本选择以下配置：  

**14.1.0 之前版本**  
```yaml
version: '3'

services:
  db:
    image: supabase/postgres
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: postgres
```

**14.1.0 及之后版本**  
```yaml
version: '3'

services:
  db:
    image: supabase/postgres
    ports:
      - "5432:5432"
    command: postgres -c config_file=/etc/postgresql/postgresql.conf 
    environment:
      POSTGRES_PASSWORD: postgres
```

#### 2. 启动服务  
执行以下命令启动数据库（添加 `-d` 参数可后台运行）：  
```bash
docker-compose up
```  
服务启动后，数据库将在 **5432 端口**可用。  

#### 环境变量说明  
该镜像基于 [PostgreSQL 官方镜像]([]) 构建，因此支持 PostgreSQL 镜像的所有环境变量。


### 内置扩展  
镜像已预安装以下扩展，无需额外配置即可使用：  

| 扩展 | 版本 | 描述 |
| ------------- | :-------------: | ------------- |
| [Postgres contrib modules]([]) | - | 包含 pg_stat_statements 等实用工具，建议启用 |
| [PostGIS]([]) | [3.1.4]([]) | Postgres 最流行的地理信息扩展，支持空间数据处理 |
| [pgRouting]([]) | [v3.3.0]([]) | PostGIS 扩展模块，提供地理空间路由功能 |
| [pgTAP]([]) | [v1.1.0]([]) | Postgres 单元测试工具 |
| [pg_cron]([]) | [v1.4.1]([]) | 在 Postgres 内运行定时任务 |
| [pgAudit]([]) | [1.6.1]([]) | 生成合规性审计日志 |
| [pgjwt]([]) | [commit]([]) | 在 Postgres 中生成 JSON Web Token (JWT) |
| [pgsql-http]([]) | [1.3.1]([]) | Postgres HTTP 客户端，支持发送 HTTP 请求 |
| [plpgsql_check]([]) | [2.0.6]([]) | PL/pgSQL 代码检查工具 |
| [pg-safeupdate]([]) | [1.4]([]) | 防止误操作导致的数据更新或删除 |
| [wal2json]([]) | [2.4]([]) | 逻辑复制解码的 JSON 输出插件 |
| [PL/Java]([]) | [1.6.3]([]) | 支持在 Postgres 中编写 Java 函数 |
| [plv8]([]) | [commit]([]) | 支持在 Postgres 中编写 JavaScript 函数 |
| [pg_plan_filter]([]) | [commit]([]) | 仅允许符合条件的 SQL 语句执行 |
| [pg_net]([]) | [v0.3]([]) | 提供异步网络操作的 SQL 接口 |
| [rum]([]) | [1.3.9]([]) | GIN 索引的替代方案，优化全文搜索 |
| [pg_hashids]([]) | [commit]([]) | 将数字生成唯一标识符 |
| [pg_sodium]([]) | [v1.3.0]([]) | 基于 libsodium 的现代加密 API |


若未找到所需扩展，可通过 [此链接]([]) 提交建议，以便纳入未来版本。
