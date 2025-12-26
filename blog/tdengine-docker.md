---
id: 177
title: TDengine Docker 容器化部署指南
slug: tdengine-docker
summary: TDengine 是一款开源、高性能、云原生的时序数据库，专为物联网（IoT）、车联网和工业物联网场景优化设计。它能够高效处理每天TB甚至PB级别的数据，支持数十亿传感器和数据采集点的数据 ingestion、处理与监控。
category: Docker,TDengine
tags: tdengine,docker,部署教程
image_name: tdengine/tdengine
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-tdengine.png"
status: published
created_at: "2025-12-17 08:23:01"
updated_at: "2025-12-17 08:23:01"
---

# TDengine Docker 容器化部署指南

> TDengine 是一款开源、高性能、云原生的时序数据库，专为物联网（IoT）、车联网和工业物联网场景优化设计。它能够高效处理每天TB甚至PB级别的数据，支持数十亿传感器和数据采集点的数据 ingestion、处理与监控。

## 概述

TDengine 是一款开源、高性能、云原生的时序数据库，专为物联网（IoT）、车联网和工业物联网场景优化设计。它能够高效处理每天TB甚至PB级别的数据，支持数十亿传感器和数据采集点的数据 ingestion、处理与监控。TDengine 的核心优势包括：

- **高性能**：解决了高基数问题，支持数十亿数据采集点，在数据写入、查询和压缩方面表现卓越
- **简化方案**：内置缓存、流处理和数据订阅功能，降低系统设计复杂度和运维成本
- **云原生**：原生分布式设计，支持分片分区、存算分离、RAFT协议和Kubernetes部署，可在公有云、私有云或混合云环境部署
- **易用性**：简化部署维护流程，提供简洁接口和第三方工具集成，降低使用门槛
- **便捷数据分析**：通过超级表、存算分离、时间分区和预计算等特性，高效支持时序数据分析
- **开源特性**：核心模块（包括集群功能）均采用开源许可，GitHub上已积累19.9k星标，拥有活跃的开发者社区和全球超过139k运行实例

本文将详细介绍如何通过Docker容器化方式快速部署TDengine，包括环境准备、镜像拉取、容器部署、功能测试及生产环境建议，帮助用户快速实现TDengine的容器化落地。


## 环境准备

### Docker环境安装

部署TDengine容器前，需先确保服务器已安装Docker环境。推荐使用以下一键安装脚本，适用于主流Linux发行版：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

脚本将自动完成Docker引擎、Docker Compose的安装与配置，并启动Docker服务。安装完成后，可通过`docker --version`命令验证安装是否成功。

轩辕镜像访问支持可提升国内网络环境下的镜像下载访问表现，后续镜像拉取操作将自动使用访问支持能力。


## 镜像准备

### 拉取TDENGINE镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的TDENGINE镜像：

```bash
docker pull xxx.xuanyuan.run/tdengine/tdengine:latest
```

如需指定其他版本，可访问[TDengine镜像标签列表](https://xuanyuan.cloud/r/tdengine/tdengine/tags)查看所有可用标签，并将命令中的`latest`替换为目标标签。


## 容器部署

### 基础部署

使用以下命令启动一个基础的TDENGINE容器实例：

```bash
docker run -d \
  --name tdengine \
  --hostname="tdengine-server" \
  -p 6030-6060:6030-6060 \
  -p 6030-6060:6030-6060/udp \
  -v ~/tdengine/data:/var/lib/taos \
  -v ~/tdengine/log:/var/log/taos \
  -e TZ=Asia/Shanghai \
  xxx.xuanyuan.run/tdengine/tdengine:latest
```

参数说明：
- `-d`：后台运行容器
- `--name tdengine`：指定容器名称为tdengine，便于后续管理
- `--hostname="tdengine-server"`：设置容器主机名，有助于集群部署和日志追踪
- `-p 6030-6060:6030-6060`：映射TCP端口范围（6030-6060），请参考官方文档了解具体端口用途
- `-p 6030-6060:6030-6060/udp`：映射UDP端口范围（6030-6060），支持UDP协议的数据传输
- `-v ~/tdengine/data:/var/lib/taos`：挂载数据目录到宿主机，实现数据持久化
- `-v ~/tdengine/log:/var/log/taos`：挂载日志目录到宿主机，便于日志查看和管理
- `-e TZ=Asia/Shanghai`：设置时区为上海时区

### 自定义配置部署

如需自定义更多配置，可通过环境变量或配置文件挂载实现。例如，设置管理员密码和调整内存分配：

```bash
docker run -d \
  --name tdengine \
  --hostname="tdengine-server" \
  -p 6030-6060:6030-6060 \
  -p 6030-6060:6030-6060/udp \
  -v ~/tdengine/data:/var/lib/taos \
  -v ~/tdengine/log:/var/log/taos \
  -v ~/tdengine/conf:/etc/taos \
  -e TZ=Asia/Shanghai \
  -e TAOS_PASSWORD=your_secure_password \
  -e MEMORY_POOL=2048 \
  xxx.xuanyuan.run/tdengine/tdengine:latest
```

其中`~/tdengine/conf`目录可放置自定义的`taos.cfg`配置文件，实现更精细的参数调整。具体配置项请参考[TDENGINE镜像文档（轩辕）](https://xuanyuan.cloud/r/tdengine/tdengine)。


## 功能测试

### 容器状态检查

容器启动后，首先检查容器运行状态：

```bash
docker ps | grep tdengine
```

若状态显示为`Up`，表示容器已成功启动。

### 日志查看

通过以下命令查看容器运行日志，确认服务是否正常启动：

```bash
docker logs -f tdengine
```

正常启动时，日志将显示TDengine服务器初始化信息及监听端口状态。按`Ctrl+C`可退出日志查看。

### 进入容器终端

使用以下命令进入运行中的容器终端：

```bash
docker exec -it tdengine /bin/bash
```

成功进入后，可执行`taos`命令启动TDENGINE Shell客户端：

```bash
taos
```

若连接成功，将显示欢迎信息及客户端版本，类似如下输出：

```
Welcome to the TDengine shell from Linux, Client Version:2.0.20.13
Copyright (c) 2020 by TAOS Data, Inc. All rights reserved.

taos>
```

在TDENGINE Shell中，可执行SQL命令进行数据库操作，例如查看数据库列表：

```sql
taos> show databases;
```

### 外部访问测试

从宿主机直接访问容器内的TDENGINE服务，验证端口映射是否正常。使用`taos`客户端（需先在宿主机安装TDENGINE客户端）：

```bash
taos -h 127.0.0.1 -P 6030 -u root -p your_secure_password
```

或通过RESTful接口访问（默认端口6041）：

```bash
curl -u root:your_secure_password -d 'show databases' 127.0.0.1:6041/rest/sql
```

成功访问将返回数据库列表的JSON格式数据。


## 生产环境建议

### 数据持久化

生产环境中必须确保数据持久化，建议：
- 使用专用存储卷（如Docker Volume）而非宿主机目录挂载，提高数据安全性
- 定期备份数据目录，可通过`docker exec`命令执行内置备份工具或直接备份挂载的卷

```bash
# 示例：创建专用数据卷
docker volume create tdengine_data
docker volume create tdengine_log

# 使用数据卷启动容器
docker run -d \
  --name tdengine \
  -v tdengine_data:/var/lib/taos \
  -v tdengine_log:/var/log/taos \
  ...其他参数...
  xxx.xuanyuan.run/tdengine/tdengine:latest
```

### 资源限制

为避免容器过度占用主机资源，建议设置资源限制：

```bash
docker run -d \
  --name tdengine \
  --memory=8g \
  --cpus=4 \
  --memory-swap=12g \
  ...其他参数...
  xxx.xuanyuan.run/tdengine/tdengine:latest
```

根据实际业务需求调整内存和CPU配额，通常建议为TDENGINE分配至少2GB内存和2核CPU。

### 网络配置

生产环境建议使用Docker自定义网络，而非默认桥接网络，提高网络隔离性和安全性：

```bash
# 创建自定义网络
docker network create tdengine_net

# 使用自定义网络启动容器
docker run -d \
  --name tdengine \
  --network tdengine_net \
  ...其他参数...
  xxx.xuanyuan.run/tdengine/tdengine:latest
```

### 监控集成

TDENGINE支持Prometheus监控，可通过配置`taosAdapter`组件暴露监控指标，并集成到Grafana等可视化平台。具体配置方法请参考[TDengine镜像文档（轩辕）](https://xuanyuan.cloud/r/tdengine/tdengine)。

### 高可用部署

对于生产环境，建议部署TDengine集群实现高可用。可通过Docker Compose或Kubernetes编排多个容器实例，配置RAFT协议实现数据副本和自动故障转移。集群部署详细步骤请参考官方文档。


## 故障排查

### 容器无法启动

1. **端口冲突**：检查宿主机端口是否被占用，特别是6030-6060范围的端口

```bash
netstat -tulpn | grep -E '603[0-9]|604[0-9]|605[0-9]|6060'
```

若有冲突，可修改端口映射或停止占用端口的服务。

2. **配置文件错误**：若挂载了自定义配置文件，检查配置是否有误

```bash
# 查看配置文件
cat ~/tdengine/conf/taos.cfg

# 检查配置语法（需进入容器）
docker exec -it tdengine taosd -C /etc/taos/taos.cfg --check
```

3. **权限问题**：检查宿主机挂载目录权限是否允许容器访问

```bash
# 调整目录权限
chmod -R 775 ~/tdengine/data ~/tdengine/log
chown -R 1000:1000 ~/tdengine/data ~/tdengine/log
```

### 服务无法访问

1. **防火墙设置**：检查宿主机防火墙是否开放相关端口

```bash
# 开放端口示例（CentOS）
firewall-cmd --add-port=6030-6060/tcp --permanent
firewall-cmd --add-port=6030-6060/udp --permanent
firewall-cmd --reload
```

2. **网络连通性**：使用`telnet`或`nc`测试端口连通性

```bash
telnet 127.0.0.1 6030
nc -zv 127.0.0.1 6041
```

3. **容器内部服务状态**：进入容器检查TDENGINE服务状态

```bash
docker exec -it tdengine /bin/bash
service taosd status
```

### 数据异常

1. **日志分析**：详细查看TDENGINE日志定位问题

```bash
# 查看错误日志
docker exec -it tdengine grep -i error /var/log/taos/taosd.log

# 查看最近100行日志
docker logs --tail=100 tdengine
```

2. **数据目录检查**：确认数据目录挂载正确且有足够空间

```bash
# 检查宿主机磁盘空间
df -h ~/tdengine/data

# 检查容器内数据目录
docker exec -it tdengine df -h /var/lib/taos
```

3. **数据库修复**：若出现数据损坏，可尝试使用内置修复工具（需谨慎操作）

```bash
docker exec -it tdengine taosdump -r
```


## 参考资源

- [TDengine镜像文档（轩辕）](https://xuanyuan.cloud/r/tdengine/tdengine)
- [TDengine镜像标签列表](https://xuanyuan.cloud/r/tdengine/tdengine/tags)
- [TDengine官方网站](https://tdengine.com/tdengine/)
- [TDengine Docker部署指南](https://tdengine.com/tdengine/how-to-install-tdengine/#docker)
- [TDengine SQL参考文档](https://tdengine.com/tdengine/taos-sql/)
- [TDengine RESTful接口文档](https://tdengine.com/tdengine/connector/#restful)


## 总结

本文详细介绍了TDengine的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境建议及故障排查等内容。通过容器化部署，可快速搭建TDengine服务，降低环境配置复杂度，提高部署一致性和可移植性。

**关键要点**：
- 使用一键脚本可快速部署Docker环境，简化前期准备工作
- 镜像拉取需使用轩辕访问支持地址`xxx.xuanyuan.run/tdengine/tdengine:latest`
- 容器部署需注意端口映射（TCP/UDP 6030-6060）和数据持久化配置
- 生产环境必须设置资源限制、网络隔离和监控，确保服务稳定运行
- 故障排查优先检查容器状态、日志和端口连通性

**后续建议**：
- 深入学习TDengine高级特性，如超级表、数据订阅和流处理功能
- 根据业务需求调整数据库参数，优化存储策略和查询性能
- 探索TDENGINE与第三方工具的集成，如Grafana可视化、Python客户端等
- 对于大规模部署，研究TDengine集群方案和云原生部署最佳实践
- 定期关注[TDengine镜像标签列表](https://xuanyuan.cloud/r/tdengine/tdengine/tags)，及时更新镜像版本以获取最新功能和安全修复

通过本文档的指导，相信您已能够顺利实现TDENGINE的Docker化部署，并为后续的时序数据处理和分析奠定基础。如需进一步帮助，可参考文中提供的参考资源或参与TDengine社区讨论。

