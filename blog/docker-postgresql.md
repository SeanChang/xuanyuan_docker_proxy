# Docker 部署 PostgreSQL 数据库教程

![Docker 部署 PostgreSQL 数据库教程](https://img.xuanyuan.dev/docker/blog/docker-postgresql.png)

*分类: Docker,PostgreSQL  | 标签: PostgreSQL,docker,部署教程 | 发布时间: 2025-10-03 06:56:04*

> 本文详细介绍基于轩辕镜像的Docker部署PostgreSQL流程，涵盖镜像详情查看、登录验证/免登录/官方直连三种拉取方式、快速/挂载目录/docker-compose三种部署方式、结果验证步骤，及无法连接、配置持久化等常见问题的解决办法。

PostgreSQL 是一款开源免费的高级关系型数据库管理系统，始于 1986 年，由全球开发者社区持续维护迭代，兼具悠久历史与前沿特性。它严格遵循 ACID 事务原则，确保数据读写的一致性与可靠性，同时突破传统关系型数据库局限，支持多模型存储——既能兼容标准 SQL，又可高效处理 JSON、数组、地理空间（GIS）等复杂数据类型。

其核心优势在于极强的扩展性：可通过自定义函数、存储过程及丰富插件（如 PostGIS 用于地理信息分析）拓展功能，适配从中小型应用到企业级海量数据场景（如电商交易、日志分析、科学计算）。此外，它采用多版本并发控制（MVCC）优化高并发读写性能，内置数据加密、访问控制等安全机制，是平衡功能深度、稳定性与运维友好性的主流开源数据库优选。

## 🧰 准备工作
若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装
一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1、查看 PostgreSQL 镜像详情
你可以在 轩辕镜像 中找到 PostgreSQL 镜像页面：
👉 [https://xuanyuan.cloud/r/library/postgres](https://xuanyuan.cloud/r/library/postgres)

在镜像页面中，你会看到多种拉取方式，下面逐一说明如何下载与部署（**生产环境务必使用明确版本号，禁止直接使用 latest**）。

## 2、下载 PostgreSQL 镜像
### 2.1 版本选择说明
| 镜像标签       | 适用场景       | 风险提示                                   |
|----------------|----------------|--------------------------------------------|
| postgres:latest | 测试/学习      | 版本不固定，大版本升级可能导致数据不可用   |
| postgres:16    | 生产环境推荐   | 稳定版本，兼容当前主流应用，升级需按官方流程 |
| postgres:15    | 生产环境备选   | 长期支持版本，适合需要稳定性的 legacy 系统 |

### 2.2 使用轩辕镜像登录验证方式拉取
```bash
# 生产推荐（指定 16 版本）
docker pull xxx.xuanyuan.run/library/postgres:16
```

### 2.3 拉取后改名（保持与官方镜像命名一致）
```bash
# 生产推荐（16 版本）
docker pull xxx.xuanyuan.run/library/postgres:16 \
&& docker tag xxx.xuanyuan.run/library/postgres:16 library/postgres:16 \
&& docker rmi xxx.xuanyuan.run/library/postgres:16
```

**说明**：
- docker pull：从轩辕镜像访问支持拉取
- docker tag：重命名为 library/postgres:16，统一镜像引用方式
- docker rmi：删除临时标签，避免重复占用空间

### 2.4 免登录方式拉取（推荐，无需配置账户）
```bash
# 生产推荐（16 版本）
docker pull xxx.xuanyuan.run/library/postgres:16
```

带重命名的完整命令：
```bash
docker pull xxx.xuanyuan.run/library/postgres:16 \
&& docker tag xxx.xuanyuan.run/library/postgres:16 library/postgres:16 \
&& docker rmi xxx.xuanyuan.run/library/postgres:16
```

### 2.5 官方直连方式（网络支持时使用）
若网络可直连 Docker Hub，或已配置加速器，可直接：
```bash
# 测试用
docker pull postgres:latest

# 生产推荐
docker pull postgres:16
```

### 2.6 查看镜像是否拉取成功
```bash
docker images
```

输出类似（生产环境应显示明确版本号）：
```
REPOSITORY      TAG       IMAGE ID       CREATED        SIZE
postgres        16        5d2f9e78c6f1   2 weeks ago    374MB
```

## 3、部署 PostgreSQL
以下示例按「测试 → 准生产 → 企业级」分类，生产环境请优先选择 3.2 或 3.3 方案，并补充安全配置。

### 3.1 快速部署（✅ 测试/学习专用，禁止生产使用）
适合快速验证功能，数据不持久化，重启后丢失：
```bash
docker run -d --name pg-test \
  -e POSTGRES_PASSWORD=StrongTestPass123! \  # 测试用强密码示例
  -p 5432:5432 \
  library/postgres:latest  # 仅测试使用 latest
```

**参数说明**：
- --name pg-test：容器名称
- -e POSTGRES_PASSWORD=StrongTestPass123!：设置 postgres 超级用户密码（必填，测试也建议用强密码）
- -p 5432:5432：将宿主机端口映射到容器 5432 端口

**验证方式**：
```bash
docker exec -it pg-test psql -U postgres
```
若成功进入 psql 命令行，说明部署完成。

### 3.2 挂载数据目录（⚠️ 准生产方案，需补充安全配置）
该方式解决了数据持久化问题，是生产环境的基础形态。**必须补充版本锁定、密码管理、网络隔离、资源限制等安全措施后，方可用于真实生产环境**。

#### 第一步：创建宿主机目录并配置权限
PostgreSQL 容器内部使用 UID 999、GID 999 的 postgres 用户运行进程，宿主机目录需授权该用户可读写：
```bash
# 创建目录
mkdir -p /data/postgres/{data,logs}

# 配置权限（关键步骤，避免启动失败）
chown -R 999:999 /data/postgres
chmod -R 700 /data/postgres  # 严格限制目录权限，仅所有者可访问
```

#### 第二步：启动容器并挂载目录（生产推荐 16 版本）
```bash
docker run -d --name pg-web \
  -e POSTGRES_PASSWORD=ComplexProdPass_2024! \  # 生产级强密码（字母+数字+特殊字符）
  -e POSTGRES_USER=appuser \  # 非默认超级用户，降低权限风险
  -e POSTGRES_DB=appdb \      # 预先创建业务数据库，避免使用默认库
  -e TZ=Asia/Shanghai \       # 指定时区，避免时间不一致问题
  -p 127.0.0.1:5432:5432 \    # 仅本地监听，禁止公网直接访问（生产核心安全配置）
  --restart always \          # 容器异常自动重启
  --memory 2G \               # 限制最大内存（根据服务器配置调整）
  --cpus 1 \                  # 限制 CPU 核心数（根据服务器配置调整）
  -v /data/postgres/data:/var/lib/postgresql/data \  # 核心数据目录（必须挂载）
  library/postgres:16  # 生产环境锁定 16 版本
```

#### 目录说明（官方镜像标准路径）
| 宿主机目录               | 容器目录                  | 说明                     | 是否必选 |
|--------------------------|---------------------------|--------------------------|----------|
| /data/postgres/data      | /var/lib/postgresql/data  | 核心数据目录（含配置文件）| 是       |
| /data/postgres/logs      | /var/log/postgresql       | 日志目录（需手动配置）   | 否       |

> ⚠️ 重要说明：  
> 1. 官方 PostgreSQL 镜像的配置文件（postgresql.conf、pg_hba.conf）默认存储在 `$PGDATA`（即 /var/lib/postgresql/data）目录下，而非 /etc/postgresql（该路径为 Debian 系统原生安装路径，容器镜像不适用）；  
> 2. 日志默认输出到 stdout，推荐通过 Docker 日志驱动收集（如 json-file、loki），而非直接挂载文件目录。

### 3.3 docker-compose 部署（🏭 企业级参考方案，需根据业务调整）
统一管理配置与容器，支持一键启动、集群扩展，适合生产环境规模化部署。

#### 第一步：编写 docker-compose.yml（生产级配置）
```yaml
version: '3.8'  # 明确 Compose 版本
services:
  postgres:
    image: library/postgres:16  # 锁定生产版本
    container_name: pg-service
    restart: always  # 异常自动重启
    environment:
      POSTGRES_USER: ${DB_USER}  # 从 .env 文件读取，避免明文
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
      TZ: Asia/Shanghai
      PGDATA: /var/lib/postgresql/data  # 明确数据存储路径
    ports:
      - "127.0.0.1:5432:5432"  # 仅本地监听，通过应用或代理访问
    volumes:
      - ./data:/var/lib/postgresql/data  # 数据持久化
      # - ./init-scripts:/docker-entrypoint-initdb.d  # 初始化脚本目录（可选）
    deploy:
      resources:
        limits:
          cpus: '2'  # 限制 CPU 使用率
          memory: 4G  # 限制最大内存
    healthcheck:  # 健康检查（生产必备）
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 3
    networks:
      - app-network  # 自定义网络，隔离其他服务

networks:
  app-network:
    driver: bridge  # 生产可替换为 overlay 网络（集群场景）
```

#### 第二步：创建 .env 文件（密码管理，避免明文暴露）
在 docker-compose.yml 同级目录创建 .env 文件：
```env
# .env 文件（需设置权限 chmod 600，仅所有者可读）
DB_USER=appadmin
DB_PASSWORD=StrongProdPass@2024#
DB_NAME=businessdb
```

#### 第三步：启动服务
```bash
# 创建数据目录并授权
mkdir -p ./data && chown -R 999:999 ./data && chmod 700 ./data

# 启动容器（后台运行）
docker compose up -d

# 查看启动状态
docker compose ps
```

**补充说明**：
- 初始化脚本：若需启动时自动执行 SQL（如创建表、授权），可在 ./init-scripts 目录下放置 .sql 或 .sh 文件，容器启动时会自动执行；
- 配置修改：直接编辑 ./data/postgresql.conf 和 ./data/pg_hba.conf，修改后需重启容器生效；
- 网络隔离：通过自定义网络 app-network 隔离数据库服务，仅允许同网络内的应用访问。

## 4、结果验证
### 查看容器状态
```bash
# 普通部署
docker ps | grep postgres

# docker-compose 部署
docker compose ps
```
应看到容器状态为 Up（健康检查通过会显示 healthy）。

### 进入 PostgreSQL 命令行
```bash
# 普通部署（pg-web 为容器名）
docker exec -it pg-web psql -U appuser -d appdb

# docker-compose 部署
docker compose exec postgres psql -U ${DB_USER} -d ${DB_NAME}
```

### 创建测试表验证功能
```sql
CREATE TABLE test(id SERIAL PRIMARY KEY, name TEXT, create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT INTO test(name) VALUES('Hello PostgreSQL!');
SELECT * FROM test;
```
输出如下结果即表示数据库可用：
```
 id |        name        |         create_time
----+--------------------+----------------------------
  1 | Hello PostgreSQL!  | 2024-05-20 10:00:00+08
(1 row)
```

## 5、生产环境关键配置补充（🏭 必看）
### 5.1 远程访问配置（⚠️ 严格限制访问范围）
默认配置仅允许本地访问，若需跨服务器访问（如应用与数据库分离），需修改配置文件，**禁止直接开放 0.0.0.0/0**：

#### 第一步：修改 postgresql.conf
```bash
# 进入数据目录
cd /data/postgres/data

# 编辑配置文件（开启远程监听）
sed -i 's/^listen_addresses = .*/listen_addresses = '*'/' postgresql.conf
```

#### 第二步：修改 pg_hba.conf（限定内网网段）
```bash
# 编辑访问控制文件
vi /data/postgres/data/pg_hba.conf

# 添加内网网段授权（示例：允许 172.18.0.0/16 网段访问）
echo "host    all             all             172.18.0.0/16            md5" >> pg_hba.conf
```

> 🚫 高危警告：  
> 禁止添加 `host all all 0.0.0.0/0 md5`（全网开放），若需公网访问，必须通过 VPN、反向代理或云数据库网关，同时启用 SSL 加密。

#### 第三步：重启容器
```bash
docker restart pg-web  # 普通部署
# 或
docker compose restart postgres  # Compose 部署
```

### 5.2 密码安全优化
1. 定期更换密码：
```bash
# 进入容器执行
docker exec -it pg-web psql -U postgres
ALTER USER appuser WITH PASSWORD 'NewStrongPass2024!';
```
2. 生产环境推荐使用 Docker Secrets 或云厂商密钥管理服务（如 AWS Secrets Manager），避免 .env 文件泄露。

### 5.3 日志配置（容器化最佳实践）
推荐使用 Docker 日志驱动收集日志，而非文件挂载：
```bash
# 启动时指定日志驱动（示例：json-file 并限制大小）
docker run -d --name pg-web \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  # 其他参数...
  library/postgres:16
```

如需输出日志到文件，需修改 postgresql.conf：
```sql
# 进入数据库执行
ALTER SYSTEM SET logging_collector = on;
ALTER SYSTEM SET log_directory = '/var/log/postgresql';
ALTER SYSTEM SET log_filename = 'postgresql-%Y-%m-%d.log';
ALTER SYSTEM SET log_rotation_age = '1d';
ALTER SYSTEM SET log_rotation_size = '100MB';
SELECT pg_reload_conf();  # 无需重启生效
```

### 5.4 备份策略（生产必备）
#### 手动备份示例：
```bash
# 全量备份（推荐每日执行）
docker exec pg-web pg_dump -U appuser -d appdb -F c -f /var/lib/postgresql/data/backup_$(date +%Y%m%d).dump

# 复制备份文件到宿主机
docker cp pg-web:/var/lib/postgresql/data/backup_20240520.dump /data/backups/
```

#### 定时备份（使用 crontab）：
```bash
# 编辑定时任务
crontab -e

# 添加每日凌晨 2 点备份（需替换容器名、用户名、数据库名）
0 2 * * * docker exec pg-web pg_dump -U appuser -d appdb -F c -f /var/lib/postgresql/data/backup_$(date +%Y%m%d).dump && docker cp pg-web:/var/lib/postgresql/data/backup_$(date +%Y%m%d).dump /data/backups/ && find /data/backups/ -name "backup_*.dump" -mtime +7 -delete
```

## 6、常见问题排查
### 6.1 容器启动失败（日志显示权限错误）
**原因**：宿主机数据目录权限不足，容器内 postgres 用户（UID 999）无法读写。  
**解决**：
```bash
chown -R 999:999 /data/postgres
chmod -R 700 /data/postgres
```

### 6.2 无法连接数据库（应用或客户端报错）
1. 检查端口是否放行：
```bash
# 查看 5432 端口监听状态
netstat -tulpn | grep 5432

# 防火墙放行（仅内网环境）
firewall-cmd --add-port=5432/tcp --permanent && firewall-cmd --reload
```
2. 检查 pg_hba.conf 配置：确保客户端 IP 在授权网段内；
3. 查看容器日志排查：
```bash
docker logs pg-web  # 普通部署
# 或
docker compose logs postgres  # Compose 部署
```

### 6.3 数据库时区不正确
**解决**：启动时添加时区环境变量：
```bash
-e TZ=Asia/Shanghai
```
已启动的容器可通过以下方式修改：
```sql
ALTER SYSTEM SET timezone = 'Asia/Shanghai';
SELECT pg_reload_conf();
```

### 6.4 大版本升级（如 15 → 16）
⚠️ 重要提醒：PostgreSQL 大版本升级**不可直接替换镜像版本**，数据目录不兼容，需通过 pg_dump 备份 + 恢复 或 pg_upgrade 工具迁移。

示例流程（15 → 16）：
1. 备份 15 版本数据：
```bash
docker exec pg-v15 pg_dumpall -U postgres -f /data/backup/all_dump.sql
```
2. 停止并删除 15 版本容器：
```bash
docker stop pg-v15 && docker rm pg-v15
```
3. 启动 16 版本容器（新数据目录）：
```bash
docker run -d --name pg-v16 -e POSTGRES_PASSWORD=xxx -v /data/postgres-v16:/var/lib/postgresql/data library/postgres:16
```
4. 恢复数据到 16 版本：
```bash
docker cp /data/backup/all_dump.sql pg-v16:/tmp/
docker exec pg-v16 psql -U postgres -f /tmp/all_dump.sql
```

### 6.5 日志文件过大
**解决**：启用日志轮转（参考 5.3 日志配置），或使用 logrotate 管理宿主机日志文件：
```bash
# 创建 logrotate 配置文件
vi /etc/logrotate.d/postgres

# 配置内容
/data/postgres/logs/*.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0600 999 999  # 保持权限一致
}
```

## 7、可选优化（提升专业度与安全性）
### 7.1 为什么不推荐 root 用户跑数据库？
1. 权限过大：容器内 root 用户可操作宿主机资源，存在安全风险；
2. 数据安全：意外操作（如 rm -rf）可能直接删除宿主机数据；
3. 符合最小权限原则：PostgreSQL 官方镜像默认使用非 root 用户，降低攻击面。

### 7.2 Docker Volume vs Bind Mount（数据挂载选择）
| 挂载方式       | 优点                     | 缺点                     | 适用场景       |
|----------------|--------------------------|--------------------------|----------------|
| Bind Mount（宿主机目录） | 直接访问文件，备份方便   | 权限配置复杂，跨平台兼容差 | 生产环境（可控服务器） |
| Docker Volume  | 权限自动管理，跨平台兼容 | 文件路径隐藏，需通过 docker volume 命令管理 | 测试/集群环境 |

### 7.3 PostgreSQL 在容器中与 K8s 的差异
- 容器部署：适合中小规模应用，配置简单，运维成本低；
- K8s 部署：适合大规模、高可用场景，支持自动扩缩容、滚动更新、StatefulSet 持久化，但需额外配置 PV/PVC、ConfigMap、Secret 等资源。

## 结尾
至此，你已掌握 PostgreSQL Docker 从测试到准生产的完整部署流程，包括镜像版本选择、数据持久化、安全配置、备份策略与问题排查。

- 初学者：使用「3.1 快速部署」验证功能，熟悉 PostgreSQL 基础操作；
- 中小团队：基于「3.2 挂载数据目录」或「3.3 docker-compose 部署」，补充权限控制、网络隔离、定时备份，即可满足大部分生产需求；
- 企业级场景：需进一步探索主从复制、读写分离、SSL 加密、监控告警（如 Prometheus + Grafana）等进阶功能，结合业务需求优化配置。

始终牢记：**生产环境无小事**，版本锁定、权限最小化、数据备份、网络隔离是数据库安全的四大基石，切勿直接将测试配置用于真实业务场景。

