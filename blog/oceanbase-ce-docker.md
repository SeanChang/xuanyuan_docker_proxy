---
id: 72
title: OCEANBASE-CE Docker 容器化部署指南
slug: oceanbase-ce-docker
summary: OceanBase CE（Community Edition）是一款开源的分布式HTAP（Hybrid Transactional and Analytical Processing）数据库管理系统，具备高可用、高扩展、高性能的特性，适用于海量数据存储与处理场景。通过Docker容器化部署OceanBase CE，可以快速搭建测试环境，简化部署流程，降低环境配置复杂度。本文将详细介绍OceanBase CE的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试及生产环境建议等内容。
category: Docker,OCEANBASE-CE
tags: oceanbase-ce,docker,部署教程
image_name: oceanbase/oceanbase-ce
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-oceanbase-oceanbase-ce.png"
status: published
created_at: "2025-11-26 05:55:55"
updated_at: "2025-11-26 05:55:55"
---

# OCEANBASE-CE Docker 容器化部署指南

> OceanBase CE（Community Edition）是一款开源的分布式HTAP（Hybrid Transactional and Analytical Processing）数据库管理系统，具备高可用、高扩展、高性能的特性，适用于海量数据存储与处理场景。通过Docker容器化部署OceanBase CE，可以快速搭建测试环境，简化部署流程，降低环境配置复杂度。本文将详细介绍OceanBase CE的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试及生产环境建议等内容。

## 概述

OceanBase CE（Community Edition）是一款开源的分布式HTAP（Hybrid Transactional and Analytical Processing）数据库管理系统，具备高可用、高扩展、高性能的特性，适用于海量数据存储与处理场景。通过Docker容器化部署OceanBase CE，可以快速搭建测试环境，简化部署流程，降低环境配置复杂度。本文将详细介绍OceanBase CE的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试及生产环境建议等内容。


## 环境准备

### Docker安装

容器化部署OceanBase CE需先安装Docker环境，推荐使用以下一键安装脚本（支持Linux系统）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

该脚本会自动安装Docker引擎、配置服务自启动，并完成基础环境优化。安装完成后，可通过`docker --version`命令验证安装结果，示例输出：`Docker version 26.1.4, build 5650f9b`。


## 镜像准备

### 镜像信息说明

OceanBase CE官方镜像名称为`oceanbase/oceanbase-ce`，采用以下格式拉取：

```bash
docker pull xxx.xuanyuan.run/oceanbase/oceanbase-ce:{TAG}
```

其中`{TAG}`为镜像版本标签，[查看所有可用标签](https://xuanyuan.cloud/r/oceanbase/oceanbase-ce/tags)。官方推荐使用`latest`标签（最新稳定版），因此实际拉取命令为：

```bash
docker pull xxx.xuanyuan.run/oceanbase/oceanbase-ce:latest
```

### 镜像验证

拉取完成后，可通过`docker images`命令查看镜像信息，示例输出：

```
REPOSITORY                                   TAG       IMAGE ID       CREATED      SIZE
xxx.xuanyuan.run/oceanbase/oceanbase-ce   latest    8f3d7e2c5a1b   2 weeks ago  4.2GB
```

若需指定版本（如`4.2.1`），将`latest`替换为对应标签即可：

```bash
docker pull xxx.xuanyuan.run/oceanbase/oceanbase-ce:4.2.1
```


## 容器部署

OceanBase CE容器支持多种部署模式，可通过环境变量和启动参数灵活配置。以下介绍常见部署场景及操作步骤。


### 基础部署（默认mini模式）

**mini模式**为默认部署模式，适用于测试环境，使用最少系统资源（推荐主机配置：2核8GB内存）。启动命令：

```bash
docker run -d \
  --name oceanbase-ce \
  -p 2881:2881 \  # 数据库服务端口（MySQL协议）
  --memory=8g \    # 限制容器内存（建议不低于8GB）
  --cpus=2 \       # 限制容器CPU核心数（建议不低于2核）
  xxx.xuanyuan.run/oceanbase/oceanbase-ce:latest
```

参数说明：
- `-d`：后台运行容器；
- `--name`：指定容器名称，便于后续操作；
- `-p 2881:2881`：映射容器内数据库服务端口到主机，外部通过`主机IP:2881`访问；
- `--memory`/`--cpus`：资源限制，避免容器过度占用主机资源。


### 自定义部署模式

根据场景需求，可通过`MODE`环境变量指定部署模式，支持以下取值：

| 模式值  | 资源占用 | 适用场景                     | 核心特性                                  |
|---------|----------|------------------------------|-------------------------------------------|
| `mini`  | 最低     | 快速测试、功能验证           | 使用最少资源，单节点部署                  |
| `normal`| 最高     | 性能测试、功能完整性验证     | 利用容器最大资源，模拟生产环境配置        |
| `slim`  | 中等     | 快速启动、轻量级测试         | 仅启动observer进程，跳过租户资源配置步骤  |


#### 1. normal模式（推荐用于性能测试）

```bash
docker run -d \
  --name oceanbase-ce-normal \
  -p 2881:2881 \
  -e MODE=normal \  # 指定normal模式
  -e OB_MEMORY_LIMIT=12G \  # 集群内存限制（需配合容器内存调整）
  --memory=16g \
  --cpus=4 \
  xxx.xuanyuan.run/oceanbase/oceanbase-ce:latest
```


#### 2. slim模式（快速启动）

```bash
docker run -d \
  --name oceanbase-ce-slim \
  -p 2881:2881 \
  -e MODE=slim \  # 指定slim模式
  --memory=4g \
  --cpus=1 \
  xxx.xuanyuan.run/oceanbase/oceanbase-ce:latest
```


### 初始化脚本挂载

若需在数据库启动后自动执行初始化SQL脚本（如创建用户、表结构等），可通过`-v`参数挂载本地脚本目录至容器内`/root/boot/init.d`路径：

```bash
# 本地创建脚本目录并编写初始化SQL
mkdir -p ./init-sql && echo "CREATE DATABASE IF NOT EXISTS demo;" > ./init-sql/init-db.sql

# 启动容器并挂载脚本目录
docker run -d \
  --name oceanbase-ce-init \
  -p 2881:2881 \
  -v $PWD/init-sql:/root/boot/init.d \  # 挂载本地脚本目录
  xxx.xuanyuan.run/oceanbase/oceanbase-ce:latest
```

**注意**：初始化脚本中请勿修改root用户密码，如需自定义密码，需通过`OB_SYS_PASSWORD`（sys租户）或`OB_TENANT_PASSWORD`（普通租户）环境变量指定。


### 启动状态验证

容器启动后，OceanBase CE需经历约3-5分钟的初始化流程。可通过以下命令检查启动结果：

```bash
docker logs oceanbase-ce | tail -1
```

若输出`boot success!`，表示初始化完成，数据库服务已就绪。若长时间未出现该提示，可通过`docker logs oceanbase-ce`查看完整日志定位问题。


## 功能测试

### 连接数据库

OceanBase CE支持通过MySQL客户端或`obclient`工具连接，默认提供以下访问入口：

| 租户类型 | 用户名       | 默认密码 | 连接命令示例                                  |
|----------|--------------|----------|-----------------------------------------------|
| sys租户  | `root`       | 空值     | `mysql -h127.0.0.1 -P2881 -uroot`             |
| 普通租户 | `root@test`  | 空值     | `mysql -h127.0.0.1 -P2881 -uroot@test`        |


#### 本地连接示例（需安装mysql客户端）

```bash
# 连接sys租户（系统管理租户）
mysql -h127.0.0.1 -P2881 -uroot

# 连接普通租户（默认租户名称为test）
mysql -h127.0.0.1 -P2881 -uroot@test
```

连接成功后，可执行`SELECT VERSION();`查看数据库版本，示例输出：`OceanBase 4.2.1 CE`。


### 基础功能验证

#### 1. 数据读写测试

```sql
-- 连接test租户后执行
CREATE TABLE demo.t_user (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO demo.t_user (name) VALUES ('OceanBase'), ('Docker');
SELECT * FROM demo.t_user;
```

预期输出：
```
+----+-----------+---------------------+
| id | name      | create_time         |
+----+-----------+---------------------+
|  1 | OceanBase | 2024-07-20 10:30:00 |
|  2 | Docker    | 2024-07-20 10:30:05 |
+----+-----------+---------------------+
```


#### 2. 性能基准测试

镜像内置`sysbench`工具，可用于性能测试。执行以下命令运行OLTP读写测试（需容器处于运行状态）：

```bash
docker exec -it oceanbase-ce obd test sysbench obcluster
```

测试完成后，将输出TPS（每秒事务数）、QPS（每秒查询数）等关键指标，示例结果：`SQL statistics: queries performed: read: 143880, write: 41108, other: 20554, total: 205542`。


### 数据持久化验证

默认情况下，容器内数据存储于`/root/ob`（数据文件）和`/root/.obd/cluster`（配置文件）目录。为避免容器删除导致数据丢失，需通过挂载主机目录实现持久化：

```bash
# 创建主机数据目录
mkdir -p ./ob/data ./ob/config

# 挂载目录启动容器
docker run -d \
  --name oceanbase-ce-persist \
  -p 2881:2881 \
  -v $PWD/ob/data:/root/ob \  # 持久化数据文件
  -v $PWD/ob/config:/root/.obd/cluster \  # 持久化配置文件
  xxx.xuanyuan.run/oceanbase/oceanbase-ce:latest
```

重启容器后，通过查询之前创建的`demo.t_user`表，验证数据是否保留。


## 生产环境建议

OceanBase CE Docker镜像**仅推荐用于测试环境**，生产环境部署需注意以下要点：


### 1. 避免单节点部署

Docker容器本质为单进程实例，无法实现OceanBase的分布式高可用特性。生产环境需部署至少3个节点（通过ob-operator或手动部署），确保数据多副本存储与自动故障转移。


### 2. 资源配置优化

- **内存**：生产环境单节点内存建议不低于32GB，其中`OB_MEMORY_LIMIT`（集群内存）建议设置为物理内存的50%-70%。
- **磁盘**：使用SSD磁盘，数据目录与日志目录分离，单节点数据盘容量不低于100GB。
- **网络**：配置万兆网卡，优化TCP参数（如增大`net.core.somaxconn`、`net.ipv4.tcp_max_syn_backlog`）。


### 3. 安全加固

- **密码管理**：通过`OB_SYS_PASSWORD`和`OB_TENANT_PASSWORD`环境变量设置强密码，避免空密码登录。
- **端口限制**：仅开放必要端口（如2881/MySQL协议、2882/RPC协议），通过防火墙限制访问IP。
- **镜像安全**：使用官方镜像，避免第三方修改版，定期更新镜像至最新稳定版。


### 4. 监控与运维

- 部署Prometheus + Grafana监控体系，通过OceanBase提供的`oceanbase-exporter`采集 metrics 指标。
- 配置定期备份策略，使用`ob_backup`工具实现全量+增量备份，备份文件存储至独立存储系统（如对象存储）。
- 启用审计日志，记录关键操作（如用户登录、DDL语句），通过日志分析工具（如ELK）实时监控异常行为。


## 故障排查

### 常见问题及解决方法


#### 1. 容器启动后日志无“boot success!”输出

**可能原因**：资源不足或配置冲突。  
**排查步骤**：
- 查看容器日志：`docker logs oceanbase-ce`，搜索关键词`ERROR`或`failed`。
- 检查容器资源限制：确保`--memory`不低于8GB，`--cpus`不低于2核。
- 清理残留数据：若之前启动失败，删除挂载目录下的残留文件（如`./ob/data`）后重试。


#### 2. 连接数据库提示“Access denied”

**可能原因**：密码错误或租户不存在。  
**排查步骤**：
- 确认是否设置密码：未设置时直接使用空密码登录（`-p`参数不输密码）。
- 检查租户名称：默认普通租户为`test`，连接时需指定`-uroot@test`。
- 重置密码：通过环境变量`OB_TENANT_PASSWORD=NewPass123`重启容器，重置租户密码。


#### 3. 容器启动后端口未监听

**可能原因**：observer进程未正常启动。  
**排查步骤**：
- 进入容器检查进程：`docker exec -it oceanbase-ce ps -ef | grep observer`。
- 若进程未启动，查看详细日志：`cat /root/ob/log/observer.log`。
- 设置`EXIT_WHILE_ERROR=false`重启容器，避免进程退出后进入容器调试：
  ```bash
  docker run -d \
    --name oceanbase-ce-debug \
    -e EXIT_WHILE_ERROR=false \
    xxx.xuanyuan.run/oceanbase/oceanbase-ce:latest
  ```


## 参考资源

- [OceanBase CE镜像文档（轩辕）](https://xuanyuan.cloud/r/oceanbase/oceanbase-ce)  
  （包含镜像版本说明、环境变量详情等）
- [OceanBase CE镜像标签列表](https://xuanyuan.cloud/r/oceanbase/oceanbase-ce/tags)  
  （查看所有可用镜像版本）
- OceanBase官方文档：https://en.oceanbase.com/docs  
  （包含分布式部署、性能优化、运维指南等生产环境相关内容）
- ob-operator项目：https://github.com/oceanbase/ob-operator  
  （Kubernetes环境下的OceanBase部署工具）


## 总结

本文详细介绍了OCEANBASE-CE的Docker容器化部署方案，从环境准备、镜像拉取到容器部署、功能测试，完整覆盖了测试环境搭建的全流程。通过Docker部署，用户可快速启动OceanBase CE实例，验证其分布式HTAP数据库的核心功能。


### 关键要点
- **环境准备**：使用一键脚本安装Docker并自动配置轩辕镜像访问支持，提升部署效率。
- **镜像拉取**：多段镜像名`oceanbase/oceanbase-ce`采用`xxx.xuanyuan.run/oceanbase/oceanbase-ce:{TAG}`格式拉取。
- **部署模式**：根据测试需求选择`mini`（快速启动）、`normal`（性能测试）或`slim`（轻量模式）。
- **数据持久化**：通过挂载主机目录`/root/ob`和`/root/.obd/cluster`实现数据与配置的持久化。


### 后续建议
- **深入学习**：参考官方文档学习OceanBase分布式架构、事务模型、索引优化等高级特性。
- **生产部署**：测试环境验证通过后，通过ob-operator在Kubernetes集群部署生产环境，实现高可用与弹性扩展。
- **社区参与**：加入OceanBase社区（https://open.oceanbase.com/），获取技术支持并参与开源贡献。

通过合理利用容器化技术与官方工具，可显著降低OceanBase CE的上手门槛，为后续业务应用与性能优化奠定基础。

