---
id: 117
title: VALKEY Docker 容器化部署指南
slug: valkey-docker
summary: VALKEY是一款高性能的数据结构服务器，主要用于处理键值（key/value）工作负载。它支持多种原生数据结构，并提供可扩展的插件系统，用于添加新的数据结构和访问模式。通过Docker容器化部署VALKEY，可以实现环境一致性、快速部署和资源隔离，适用于开发、测试和生产环境。
category: Docker,VALKEY
tags: valkey,docker,部署教程
image_name: valkey/valkey
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-valkey.png"
status: published
created_at: "2025-12-09 07:00:59"
updated_at: "2025-12-09 07:00:59"
---

# VALKEY Docker 容器化部署指南

> VALKEY是一款高性能的数据结构服务器，主要用于处理键值（key/value）工作负载。它支持多种原生数据结构，并提供可扩展的插件系统，用于添加新的数据结构和访问模式。通过Docker容器化部署VALKEY，可以实现环境一致性、快速部署和资源隔离，适用于开发、测试和生产环境。

## 概述

VALKEY是一款高性能的数据结构服务器，主要用于处理键值（key/value）工作负载。它支持多种原生数据结构，并提供可扩展的插件系统，用于添加新的数据结构和访问模式。通过Docker容器化部署VALKEY，可以实现环境一致性、快速部署和资源隔离，适用于开发、测试和生产环境。

本文档将详细介绍如何通过Docker容器化方式部署VALKEY，包括环境准备、镜像拉取、容器部署、功能测试及生产环境优化建议，所有操作均基于轩辕镜像访问支持服务以提升部署效率。


## 环境准备

### Docker环境安装

VALKEY容器化部署依赖Docker引擎，建议使用以下一键脚本快速安装Docker环境（支持主流Linux发行版）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本执行完成后，可通过`docker --version`命令验证安装是否成功：

```bash
docker --version
# 预期输出示例：Docker version 26.0.0, build 8b79278
```

## 镜像准备

### 拉取VALKEY镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的VALKEY镜像：

```bash
docker pull xxx.xuanyuan.run/valkey/valkey:latest
```

拉取完成后，可通过`docker images`命令验证镜像是否成功下载：

```bash
docker images | grep valkey/valkey
# 预期输出示例：xxx.xuanyuan.run/valkey/valkey   latest    abc12345   2 weeks ago   130MB
```


## 容器部署

### 基础部署

使用以下命令启动一个基础的VALKEY容器实例：

```bash
docker run -d \
  --name valkey-server \
  -p 6379:6379 \
  xxx.xuanyuan.run/valkey/valkey:latest
```

参数说明：
- `-d`：后台运行容器
- `--name valkey-server`：指定容器名称为valkey-server
- `-p 6379:6379`：映射容器6379端口到主机6379端口（默认端口，具体请参考[VALKEY镜像文档（轩辕）](https://xuanyuan.cloud/r/valkey/valkey)）

### 带持久化存储的部署

为避免容器重启导致数据丢失，建议挂载主机目录作为持久化存储：

```bash
docker run -d \
  --name valkey-server \
  -p 6379:6379 \
  -v /data/valkey:/data \
  xxx.xuanyuan.run/valkey/valkey:latest \
  valkey-server --save 60 1 --loglevel warning
```

参数说明：
- `-v /data/valkey:/data`：将主机`/data/valkey`目录挂载到容器`/data`目录（VALKEY数据存储路径）
- `valkey-server --save 60 1 --loglevel warning`：启动参数，配置每60秒如果有至少1次写操作则保存快照，并设置日志级别为warning

### 自定义配置文件部署

如需使用自定义配置文件，可通过挂载配置目录实现：

```bash
# 1. 准备本地配置目录及文件
mkdir -p /etc/valkey
# 从容器中复制默认配置文件（可选）
docker cp valkey-server:/usr/local/etc/valkey/valkey.conf /etc/valkey/
# 2. 编辑自定义配置（根据需求修改/etc/valkey/valkey.conf）
# 3. 启动容器并挂载配置目录
docker run -d \
  --name valkey-server \
  -p 6379:6379 \
  -v /data/valkey:/data \
  -v /etc/valkey:/usr/local/etc/valkey \
  xxx.xuanyuan.run/valkey/valkey:latest \
  valkey-server /usr/local/etc/valkey/valkey.conf
```

### 环境变量配置启动参数

通过环境变量`VALKEY_EXTRA_FLAGS`传递启动参数，无需覆盖CMD：

```bash
docker run -d \
  --name valkey-server \
  -p 6379:6379 \
  -v /data/valkey:/data \
  -e VALKEY_EXTRA_FLAGS='--save 60 1 --loglevel warning --requirepass your_secure_password' \
  xxx.xuanyuan.run/valkey/valkey:latest
```


## 功能测试

### 容器状态检查

部署完成后，首先检查容器是否正常运行：

```bash
docker ps | grep valkey-server
# 预期输出示例：abc12345   xxx.xuanyuan.run/valkey/valkey:latest   "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes   0.0.0.0:6379->6379/tcp   valkey-server
```

### 日志查看

通过容器日志确认服务启动状态：

```bash
docker logs valkey-server
# 预期输出应包含"Ready to accept connections"等启动成功信息
```

### 客户端连接测试

使用`valkey-cli`工具连接VALKEY服务（需在容器内或安装valkey-cli的环境中执行）：

```bash
# 方式1：通过容器内客户端连接
docker exec -it valkey-server valkey-cli

# 方式2：通过新容器连接（需同一网络，若未指定网络，默认使用bridge网络）
docker run -it --rm xxx.xuanyuan.run/valkey/valkey:latest valkey-cli -h 宿主IP -p 6379
```

连接成功后，可执行简单命令测试功能：

```bash
# 设置键值对
set testkey "hello valkey"
# 预期输出：OK

# 获取键值
get testkey
# 预期输出："hello valkey"

# 查看服务器信息
info server
# 预期输出服务器版本、运行时间等信息
```


## 生产环境建议

### 安全加固

1. **启用密码认证**  
   VALKEY默认关闭保护模式，暴露端口时存在安全风险，建议通过配置文件或启动参数设置密码：
   ```bash
   docker run -d \
     --name valkey-server \
     -p 6379:6379 \
     -v /data/valkey:/data \
     xxx.xuanyuan.run/valkey/valkey:latest \
     valkey-server --requirepass "your_secure_password"
   ```
   连接时需提供密码：`valkey-cli -h 宿主IP -p 6379 -a "your_secure_password"`

2. **限制网络访问**  
   避免直接暴露公网，可通过`--network`指定私有网络，或使用防火墙限制访问IP：
   ```bash
   # 创建私有网络
   docker network create valkey-net
   # 在私有网络中启动容器，不映射公网端口（仅内部访问）
   docker run -d --name valkey-server --network valkey-net xxx.xuanyuan.run/valkey/valkey:latest
   ```

### 性能优化

1. **资源限制**  
   根据业务需求限制容器CPU和内存资源，避免资源争抢：
   ```bash
   docker run -d \
     --name valkey-server \
     --cpus 2 \
     --memory 4g \
     -p 6379:6379 \
     xxx.xuanyuan.run/valkey/valkey:latest
   ```

2. **持久化策略调整**  
   根据数据重要性和性能需求调整持久化策略（RDB/AOF），可在配置文件中设置：
   ```conf
   # RDB配置：每900秒至少1次写操作、300秒至少10次写操作、60秒至少10000次写操作时保存快照
   save 900 1
   save 300 10
   save 60 10000
   
   # AOF配置：开启AOF持久化
   appendonly yes
   appendfsync everysec
   ```

### 监控与维护

1. **日志轮转**  
   配置Docker日志驱动限制日志大小，避免磁盘占满：
   ```bash
   docker run -d \
     --name valkey-server \
     --log-opt max-size=10m \
     --log-opt max-file=3 \
     xxx.xuanyuan.run/valkey/valkey:latest
   ```

2. **健康检查**  
   添加健康检查确保服务可用性：
   ```bash
   docker run -d \
     --name valkey-server \
     --health-cmd "valkey-cli ping" \
     --health-interval 10s \
     --health-timeout 5s \
     --health-retries 3 \
     xxx.xuanyuan.run/valkey/valkey:latest
   ```

3. **定期备份**  
   结合持久化目录，定期备份`/data`目录数据，可使用crontab设置定时任务：
   ```bash
   # 示例：每日凌晨2点备份数据
   0 2 * * * tar -zcvf /backup/valkey-$(date +%Y%m%d).tar.gz /data/valkey
   ```


## 故障排查

### 容器无法启动

1. **查看启动日志**  
   ```bash
   docker logs valkey-server
   ```
   常见原因：端口冲突（需更换主机端口或停止占用进程）、配置文件错误（检查挂载的配置文件语法）、目录权限问题（确保挂载目录权限正确，可尝试`chmod 777 /data/valkey`临时测试）。

2. **检查容器状态**  
   ```bash
   docker inspect valkey-server | grep "Status"
   ```
   若状态为`Exited`，结合日志排查具体退出原因。

### 连接失败

1. **网络连通性测试**  
   ```bash
   # 测试端口是否开放
   telnet 宿主IP 6379
   # 或使用nc命令
   nc -zv 宿主IP 6379
   ```
   若端口不通，检查容器端口映射是否正确（`docker ps`查看PORTS列）、主机防火墙是否放行。

2. **认证问题**  
   若提示`NOAUTH Authentication required`，确认连接时是否提供正确密码，或配置文件中密码是否生效。

### 数据丢失

1. **检查持久化配置**  
   通过`info persistence`命令查看持久化状态，确认RDB/AOF是否按预期工作：
   ```bash
   valkey-cli -h 宿主IP -p 6379 -a "your_password" info persistence
   ```
   检查`rdb_last_save_time`（RDB最后保存时间）和`aof_last_write_status`（AOF最后写入状态）。

2. **挂载目录检查**  
   确认挂载目录是否正确，宿主目录数据是否存在：
   ```bash
   ls -l /data/valkey
   # 预期应包含dump.rdb（RDB文件）或appendonly.aof（AOF文件）
   ```


## 参考资源

- [VALKEY镜像文档（轩辕）](https://xuanyuan.cloud/r/valkey/valkey)
- [VALKEY镜像标签列表（轩辕）](https://xuanyuan.cloud/r/valkey/valkey/tags)
- [Docker官方文档 - 容器持久化存储](https://docs.docker.com/engine/storage/)
- [VALKEY安全最佳实践](https://valkey.io/topics/security/)（项目官方安全指南）


## 总结

本文详细介绍了VALKEY的Docker容器化部署方案，从环境准备、镜像拉取、基础部署到生产环境优化，提供了完整的操作指南和最佳实践。通过容器化部署，可快速搭建VALKEY服务，同时结合持久化存储、安全配置和监控策略，确保服务稳定可靠运行。

**关键要点**：
- 使用轩辕镜像访问支持可提升VALKEY镜像下载访问表现，拉取命令为`docker pull xxx.xuanyuan.run/valkey/valkey:latest`
- 生产环境必须启用密码认证并限制网络访问，避免安全风险
- 持久化存储和定期备份是保障数据安全的核心措施
- 功能测试建议通过`valkey-cli`执行基础命令验证服务可用性

**后续建议**：
- 深入学习VALKEY高级特性，如数据结构优化、集群部署和插件开发
- 根据业务负载调整资源配置和持久化策略，平衡性能与可靠性
- 参考[VALKEY镜像文档（轩辕）](https://xuanyuan.cloud/r/valkey/valkey)获取更多镜像使用细节和版本更新信息
- 结合监控工具（如Prometheus+Grafana）构建完善的服务监控体系，及时发现并解决潜在问题

