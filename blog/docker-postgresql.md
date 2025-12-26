# Docker 部署 PostgreSQL 数据库教程

![Docker 部署 PostgreSQL 数据库教程](https://img.xuanyuan.dev/docker/blog/docker-postgresql.png)

*分类: Docker,PostgreSQL  | 标签: PostgreSQL,docker,部署教程 | 发布时间: 2025-10-03 06:56:04*

> 本文详细介绍基于轩辕镜像的Docker部署PostgreSQL流程，涵盖镜像详情查看、登录验证/免登录/官方直连三种拉取方式、快速/挂载目录/docker-compose三种部署方式、结果验证步骤，及无法连接、配置持久化等常见问题的解决办法。

PostgreSQL是一款开源免费的高级关系型数据库管理系统，始于1986年，由全球开发者社区持续维护迭代，兼具悠久历史与前沿特性。它严格遵循ACID事务原则，确保数据读写的一致性与可靠性，同时突破传统关系型数据库局限，支持多模型存储——既能兼容标准SQL，又可高效处理JSON、数组、地理空间（GIS）等复杂数据类型。

其核心优势在于极强的扩展性：可通过自定义函数、存储过程及丰富插件（如PostGIS用于地理信息分析）拓展功能，适配从中小型应用到企业级海量数据场景（如电商交易、日志分析、科学计算）。此外，它采用多版本并发控制（MVCC）优化高并发读写性能，内置数据加密、访问控制等安全机制，是平衡功能深度、稳定性与运维友好性的主流开源数据库优选。

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

在镜像页面中，你会看到多种拉取方式，下面逐一说明如何下载与部署。


## 2、下载 PostgreSQL 镜像

### 2.1 使用轩辕镜像登录验证方式拉取
```bash
docker pull  xxx.xuanyuan.run/library/postgres:latest
```

### 2.2 拉取后改名
```bash
docker pull  xxx.xuanyuan.run/library/postgres:latest \
&& docker tag  xxx.xuanyuan.run/library/postgres:latest library/postgres:latest \
&& docker rmi  xxx.xuanyuan.run/library/postgres:latest
```

**说明**：
- docker pull：从轩辕镜像访问支持拉取
- docker tag：重命名为 library/postg xxx.xuanyuan.runres:latest，保持与官方一致
- docker rmi：删除临时标签，避免重复占用空间

### 2.3 使用免登录方式拉取（推荐）
免登录方式无需配置账户，新手可直接使用。
```bash
docker pull xxx.xuanyuan.run/library/postgres:latest
```

带重命名的完整命令：
```bash
docker pull xxx.xuanyuan.run/library/postgres:latest \
&& docker tag xxx.xuanyuan.run/library/postgres:latest library/postgres:latest \
&& docker rmi xxx.xuanyuan.run/library/postgres:latest
```

### 2.4 官方直连方式
若网络可直连 Docker Hub，或已配置加速器，可直接：
```bash
docker pull postgres:latest
```

### 2.5 查看镜像是否拉取成功
```bash
docker images
```

输出类似：
```
REPOSITORY      TAG       IMAGE ID       CREATED        SIZE
postgres        latest    5d2f9e78c6f1   2 weeks ago    374MB
```


## 3、部署 PostgreSQL
以下示例均基于已下载的 `library/postgres:latest` 镜像，提供三种部署方式。

### 3.1 快速部署（最简方式）
适合测试或学习：
```bash
docker run -d --name pg-test \
  -e POSTGRES_PASSWORD=123456 \
  -p 5432:5432 \
  library/postgres:latest
```

**参数说明**：
- --name pg-test：容器名称
- -e POSTGRES_PASSWORD=123456：设置 postgres 超级用户密码（必填）
- -p 5432:5432：将宿主机端口映射到容器 5432 端口

**验证方式**：
```bash
docker exec -it pg-test psql -U postgres
```
若成功进入 psql，说明部署完成。

### 3.2 挂载目录（推荐方式，适合生产环境）
持久化数据与配置，避免容器删除后数据丢失。

#### 第一步：创建宿主机目录
```bash
mkdir -p /data/postgres/{data,conf,logs}
```

#### 第二步：启动容器并挂载目录
```bash
docker run -d --name pg-web \
  -e POSTGRES_PASSWORD=123456 \
  -p 5432:5432 \
  -v /data/postgres/data:/var/lib/postgresql/data \
  -v /data/postgres/logs:/var/log/postgresql \
  library/postgres:latest
```

#### 目录说明
| 宿主机目录               | 容器目录                  | 说明                     |
|--------------------------|---------------------------|--------------------------|
| /data/postgres/data      | /var/lib/postgresql/data  | 数据持久化目录           |
| /data/postgres/logs      | /var/log/postgresql       | 日志目录                 |
| /data/postgres/conf      | /etc/postgresql（可选）   | 配置目录（需扩展）       |

### 3.3 docker-compose 部署（适合企业级场景）
统一管理配置与容器，支持一键启动。

#### 第一步：编写 docker-compose.yml
```yaml
version: '3'
services:
  postgres:
    image: library/postgres:latest
    container_name: pg-service
    restart: always
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: 123456
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./logs:/var/log/postgresql
```

#### 第二步：启动服务
```bash
docker compose up -d
```

**补充说明**：
- 默认会自动创建数据库 mydb 和用户 admin
- 修改配置/网页可直接操作挂载目录


## 4、结果验证

### 查看容器状态
```bash
docker ps
```
应看到 postgres 容器 Up 状态。

### 进入 PostgreSQL
```bash
docker exec -it pg-service psql -U admin -d mydb
```

### 创建测试表
```sql
CREATE TABLE test(id SERIAL PRIMARY KEY, name TEXT);
INSERT INTO test(name) VALUES('Hello Xuanyuan!');
SELECT * FROM test;
```
输出结果即表示数据库可用。


## 5、常见问题

### 5.1 无法连接数据库？
- 确认 防火墙或安全组 放行 5432 端口
- 检查数据库密码是否正确
- 执行 `docker logs 容器名` 查看错误原因

### 5.2 如何持久化配置？
官方镜像会在 `/var/lib/postgresql/data` 存储数据，建议挂载宿主机目录。如需自定义配置，可拷贝默认配置：
```bash
docker exec -it pg-web bash
cat /var/lib/postgresql/data/postgresql.conf
```
复制出来后放到宿主机目录再挂载回去。

### 5.3 数据库时区不正确？
启动时指定：
```bash
-e TZ=Asia/Shanghai
```

### 5.4 如何启用远程访问？
1. 在 `postgresql.conf` 中修改：
   ```
   listen_addresses = '*'
   ```
2. 在 `pg_hba.conf` 添加：
   ```
   host all all 0.0.0.0/0 md5
   ```
3. 然后重启容器：
   ```bash
   docker restart pg-web
   ```

### 5.5 日志文件过大？
挂载日志目录后，使用宿主机 logrotate 管理：
```
/data/postgres/logs/*.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
}
```


## 结尾
至此，你已掌握基于 轩辕镜像 的 PostgreSQL 部署全流程：从 镜像下载、快速运行、持久化目录挂载，再到 docker-compose 企业级部署 与 问题排查。

初学者可直接用「快速部署」验证数据库，高级工程师则可基于「目录挂载 + docker-compose」实现生产环境部署。随着使用深入，你还可以探索 主从复制、备份恢复、性能优化、监控 等进阶功能，让 PostgreSQL 成为业务的核心数据库引擎。

