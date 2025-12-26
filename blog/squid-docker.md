---
id: 104
title: SQUID Docker 容器化部署指南
slug: squid-docker
summary: SQUID是一款功能强大的Web缓存代理服务器，支持HTTP、HTTPS、FTP等多种协议。作为由Canonical维护的长期支持版本，SQUID通过缓存和重用频繁请求的网页内容，能够有效减少网络带宽消耗并提高响应速度。其丰富的访问控制功能使其成为优秀的服务器加速器，适用于多种网络环境。
category: Docker,SQUID
tags: squid,docker,部署教程
image_name: ubuntu/squid
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-ubuntu-squid.png"
status: published
created_at: "2025-12-05 04:05:57"
updated_at: "2025-12-05 04:05:57"
---

# SQUID Docker 容器化部署指南

> SQUID是一款功能强大的Web缓存代理服务器，支持HTTP、HTTPS、FTP等多种协议。作为由Canonical维护的长期支持版本，SQUID通过缓存和重用频繁请求的网页内容，能够有效减少网络带宽消耗并提高响应速度。其丰富的访问控制功能使其成为优秀的服务器加速器，适用于多种网络环境。

## 概述

SQUID是一款功能强大的Web缓存代理服务器，支持HTTP、HTTPS、FTP等多种协议。作为由Canonical维护的长期支持版本，SQUID通过缓存和重用频繁请求的网页内容，能够有效减少网络带宽消耗并提高响应访问表现。其丰富的访问控制功能使其成为优秀的服务器加速器，适用于多种网络环境。

本文档提供基于Docker容器化部署SQUID的完整方案，包括环境准备、镜像拉取、容器部署、功能测试和生产环境配置建议，旨在帮助用户快速实现SQUID的容器化部署与管理。

## 环境准备

### Docker环境安装

部署SQUID容器前，需先确保服务器已安装Docker环境。推荐使用以下一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

该脚本会自动安装最新稳定版Docker Engine并配置必要的系统参数。

## 镜像准备

### 拉取SQUID镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的SQUID镜像：

```bash
docker pull xxx.xuanyuan.run/ubuntu/squid:latest
```

拉取完成后，可使用以下命令验证镜像是否成功下载：

```bash
docker images | grep squid
```

若输出类似以下信息，则表示镜像拉取成功：

```
xxx.xuanyuan.run/ubuntu/squid   latest    <镜像ID>   <创建时间>   <大小>
```

如需查看更多可用镜像标签版本，可访问[轩辕镜像标签页面](https://xuanyuan.cloud/r/ubuntu/squid/tags)获取完整列表。

## 容器部署

### 基础部署

SQUID容器的基础部署命令如下，该命令将创建一个基本可用的SQUID代理服务：

```bash
docker run -d \
  --name squid-container \
  -e TZ=UTC \
  -p 3128:3128 \
  --restart unless-stopped \
  xxx.xuanyuan.run/ubuntu/squid:latest
```

参数说明：
- `-d`: 后台运行容器
- `--name squid-container`: 指定容器名称为squid-container，便于后续管理
- `-e TZ=UTC`: 设置容器内时区为UTC
- `-p 3128:3128`: 将容器的3128端口映射到主机的3128端口，这是SQUID的默认服务端口
- `--restart unless-stopped`: 除非手动停止，否则容器总是自动重启

### 带数据持久化的部署

为确保SQUID的配置、日志和缓存数据在容器重启或重建后不丢失，建议使用Docker卷(Volume)进行数据持久化：

```bash
# 创建本地目录用于持久化数据
mkdir -p /data/squid/{logs,data,config}

# 复制默认配置文件到本地目录（首次部署时需要）
docker cp squid-container:/etc/squid/squid.conf /data/squid/config/

# 停止并删除临时容器
docker stop squid-container && docker rm squid-container

# 使用持久化方式重新部署
docker run -d \
  --name squid-container \
  -e TZ=UTC \
  -p 3128:3128 \
  -v /data/squid/logs:/var/log/squid \
  -v /data/squid/data:/var/spool/squid \
  -v /data/squid/config/squid.conf:/etc/squid/squid.conf \
  --restart unless-stopped \
  xxx.xuanyuan.run/ubuntu/squid:latest
```

参数说明：
- `-v /data/squid/logs:/var/log/squid`: 将日志目录挂载到本地，便于日志分析和监控
- `-v /data/squid/data:/var/spool/squid`: 将缓存数据目录挂载到本地，避免容器重建后缓存丢失
- `-v /data/squid/config/squid.conf:/etc/squid/squid.conf`: 将配置文件挂载到本地，便于配置修改和版本控制

### 自定义配置部署

SQUID支持通过配置片段进行灵活的配置管理。如需添加自定义配置，可创建配置片段目录并挂载到容器中：

```bash
# 创建配置片段目录
mkdir -p /data/squid/config/conf.d

# 添加自定义配置片段（示例：设置访问控制）
cat > /data/squid/config/conf.d/access.conf << EOF
acl localnet src 192.168.0.0/16
http_access allow localnet
EOF

# 使用自定义配置启动容器
docker run -d \
  --name squid-container \
  -e TZ=UTC \
  -p 3128:3128 \
  -v /data/squid/logs:/var/log/squid \
  -v /data/squid/data:/var/spool/squid \
  -v /data/squid/config/squid.conf:/etc/squid/squid.conf \
  -v /data/squid/config/conf.d:/etc/squid/conf.d \
  --restart unless-stopped \
  xxx.xuanyuan.run/ubuntu/squid:latest
```

## 功能测试

### 容器状态检查

部署完成后，首先检查容器运行状态：

```bash
docker ps | grep squid-container
```

若输出状态为"Up"，则表示容器正在正常运行：

```
<容器ID>   xxx.xuanyuan.run/ubuntu/squid:latest   "/usr/local/bin/run.…"   X minutes ago   Up X minutes   0.0.0.0:3128->3128/tcp   squid-container
```

### 日志查看

通过查看容器日志确认SQUID服务是否正常启动：

```bash
docker logs -f squid-container
```

正常启动时，日志将显示类似以下信息：

```
2023/11/15 08:00:00| Starting Squid Cache version 5.2 for x86_64-pc-linux-gnu...
2023/11/15 08:00:00| Service Name: squid
2023/11/15 08:00:00| Process ID 1
2023/11/15 08:00:00| Process Roles: master worker
2023/11/15 08:00:00| With 1024 file descriptors available
2023/11/15 08:00:00| Initializing IP Cache...
2023/11/15 08:00:00| DNS Socket created at [::], port 43989, FD 7
2023/11/15 08:00:00| Adding nameserver 8.8.8.8 from /etc/resolv.conf
2023/11/15 08:00:00| Adding nameserver 8.8.4.4 from /etc/resolv.conf
2023/11/15 08:00:00| helperOpenServers: Starting 5 'ssl_crtd' processes
2023/11/15 08:00:00|  ssl_crtd.1: (ssl_crtd) Version 0.9.4 starting
2023/11/15 08:00:00|  ssl_crtd.2: (ssl_crtd) Version 0.9.4 starting
2023/11/15 08:00:00|  ssl_crtd.3: (ssl_crtd) Version 0.9.4 starting
2023/11/15 08:00:00|  ssl_crtd.4: (ssl_crtd) Version 0.9.4 starting
2023/11/15 08:00:00|  ssl_crtd.5: (ssl_crtd) Version 0.9.4 starting
2023/11/15 08:00:00| HTCP Disabled.
2023/11/15 08:00:00| Pinger socket opened on FD 12
2023/11/15 08:00:00| Squid plugin modules loaded: 0
2023/11/15 08:00:00| Adaptation support is off.
2023/11/15 08:00:00| Accepting HTTP Socket connections at local=0.0.0.0:3128 remote=[::] FD 13 flags=9
2023/11/15 08:00:00| Store logging disabled
2023/11/15 08:00:00| Swap maxSize 0 + 262144 KB, estimated 20164 objects
2023/11/15 08:00:00| Target number of buckets: 1008
2023/11/15 08:00:00| Using 8192 Store buckets
2023/11/15 08:00:00| Max Mem  size: 262144 KB
2023/11/15 08:00:00| Max Swap size: 0 KB
2023/11/15 08:00:00| Rebuilding storage in /var/spool/squid (dirty log)
2023/11/15 08:00:00| Using Least Load store dir selection
2023/11/15 08:00:00| Set Current Directory to /var/spool/squid
2023/11/15 08:00:00| Loaded Icons.
2023/11/15 08:00:00| HTTPS port(s) setup: none
2023/11/15 08:00:00| Warning: no_suid: setuid(0): (1) Operation not permitted
2023/11/15 08:00:00| User-Agent logging is disabled.
2023/11/15 08:00:00| Referer logging is disabled.
2023/11/15 08:00:00| Logfile: opening log daemon:/var/log/squid/access.log
2023/11/15 08:00:00| Logfile: opening log daemon:/var/log/squid/cache.log
2023/11/15 08:00:00| Logfile: opening log daemon:/var/log/squid/store.log (rotate=1024 KB, 10 logs)
2023/11/15 08:00:00| Waiting 1 seconds for DNS to stabilize...
2023/11/15 08:00:01| Finished loading MIME types and icons.
2023/11/15 08:00:01| Ready to serve requests.
```

按`Ctrl+C`可退出日志查看。

### 代理功能测试

使用`curl`命令测试SQUID代理服务是否正常工作：

```bash
# 直接访问外部网站
curl -I https://www.example.com

# 通过SQUID代理访问外部网站
curl -I -x http://localhost:3128 https://www.example.com
```

若代理工作正常，两次命令均会返回HTTP响应头，且第二次请求会在SQUID日志中留下记录：

查看SQUID访问日志确认：

```bash
tail -f /data/squid/logs/access.log
```

应能看到类似以下的访问记录：

```
1636963200.123  1234 172.17.0.1 TCP_MISS/200 1234 GET https://www.example.com/ - HIER_DIRECT/93.184.216.34 text/html
```

### 交互式调试

如需进入容器进行高级调试，可使用以下命令获取交互式shell：

```bash
docker exec -it squid-container /bin/bash
```

进入容器后，可执行`squid -k parse`命令验证配置文件语法是否正确：

```bash
squid -k parse
```

若配置文件正常，将输出：

```
2023/11/15 08:05:00| Processing Configuration File: /etc/squid/squid.conf (depth 0)
2023/11/15 08:05:00| Processing: acl localnet src 10.0.0.0/8
2023/11/15 08:05:00| Processing: acl localnet src 172.16.0.0/12
...
2023/11/15 08:05:00| Processing: http_access allow localnet
2023/11/15 08:05:00| Processing: http_access deny all
2023/11/15 08:05:00| Configuration file processing completed successfully.
```

## 生产环境建议

### 资源配置优化

根据实际业务需求调整容器资源限制，避免资源争用或浪费：

```bash
docker run -d \
  --name squid-container \
  -e TZ=UTC \
  -p 3128:3128 \
  -v /data/squid/logs:/var/log/squid \
  -v /data/squid/data:/var/spool/squid \
  -v /data/squid/config/squid.conf:/etc/squid/squid.conf \
  --memory=4g \
  --memory-swap=8g \
  --cpus=2 \
  --restart unless-stopped \
  xxx.xuanyuan.run/ubuntu/squid:latest
```

参数说明：
- `--memory=4g`: 限制容器使用的内存上限为4GB
- `--memory-swap=8g`: 限制容器使用的交换空间上限为8GB
- `--cpus=2`: 限制容器使用的CPU核心数为2个

### 安全加固措施

1. **非root用户运行**：为容器指定非root用户运行，降低安全风险

```bash
# 先在宿主机创建与容器内squid用户ID匹配的用户和目录权限
sudo chown -R 63:63 /data/squid

# 使用--user参数指定运行用户
docker run -d \
  --name squid-container \
  -e TZ=UTC \
  -p 3128:3128 \
  -v /data/squid/logs:/var/log/squid \
  -v /data/squid/data:/var/spool/squid \
  -v /data/squid/config/squid.conf:/etc/squid/squid.conf \
  --user 63:63 \
  --restart unless-stopped \
  xxx.xuanyuan.run/ubuntu/squid:latest
```

2. **网络隔离**：使用Docker网络隔离SQUID容器与其他服务

```bash
# 创建专用网络
docker network create squid-network

# 连接到专用网络
docker run -d \
  --name squid-container \
  --network squid-network \
  -e TZ=UTC \
  -p 3128:3128 \
  -v /data/squid/logs:/var/log/squid \
  -v /data/squid/data:/var/spool/squid \
  -v /data/squid/config/squid.conf:/etc/squid/squid.conf \
  --restart unless-stopped \
  xxx.xuanyuan.run/ubuntu/squid:latest
```

3. **配置访问控制**：在`squid.conf`中严格限制允许访问代理的客户端IP范围

```conf
# 仅允许特定IP段访问代理
acl trusted_clients src 192.168.1.0/24 10.0.0.0/8
http_access allow trusted_clients
http_access deny all
```

### 监控与日志管理

1. **集成日志收集**：配置日志轮转并集成ELK或其他日志收集系统

```bash
# 安装logrotate配置
cat > /etc/logrotate.d/squid << EOF
/data/squid/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 640 root root
    sharedscripts
    postrotate
        docker kill -s USR1 squid-container
    endscript
}
EOF
```

2. **健康检查**：配置Docker健康检查监控服务状态

```bash
docker run -d \
  --name squid-container \
  -e TZ=UTC \
  -p 3128:3128 \
  -v /data/squid/logs:/var/log/squid \
  -v /data/squid/data:/var/spool/squid \
  -v /data/squid/config/squid.conf:/etc/squid/squid.conf \
  --health-cmd "curl -s -o /dev/null -w '%{http_code}' http://localhost:3128 | grep -q 200" \
  --health-interval 30s \
  --health-timeout 10s \
  --health-retries 3 \
  --restart unless-stopped \
  xxx.xuanyuan.run/ubuntu/squid:latest
```

### 高可用部署

对于生产环境，建议采用多实例部署结合负载均衡实现高可用架构：

1. **多实例部署**：在不同主机上部署多个SQUID容器实例
2. **负载均衡**：使用Nginx或HAProxy作为前端负载均衡器
3. **共享缓存**：配置SQUID使用外部共享存储（如NFS）保存缓存数据

## 故障排查

### 容器无法启动

1. **检查容器日志**：

```bash
docker logs squid-container
```

2. **检查配置文件语法**：

```bash
docker run --rm -v /data/squid/config/squid.conf:/etc/squid/squid.conf xxx.xuanyuan.run/ubuntu/squid:latest squid -k parse
```

3. **检查端口占用情况**：

```bash
netstat -tulpn | grep 3128
```

### 代理连接失败

1. **检查访问控制配置**：确保客户端IP在允许访问的ACL范围内
2. **检查防火墙规则**：确保主机防火墙允许3128端口的入站连接

```bash
# 检查UFW防火墙状态
sudo ufw status

# 如需要，允许3128端口
sudo ufw allow 3128/tcp
```

3. **测试网络连通性**：

```bash
# 从容器内部测试外部网络连通性
docker exec -it squid-container ping -c 4 8.8.8.8
docker exec -it squid-container curl -I https://www.example.com
```

### 缓存不生效

1. **检查缓存配置**：确认`squid.conf`中缓存相关配置是否正确
2. **检查缓存目录权限**：

```bash
docker exec -it squid-container ls -ld /var/spool/squid
```

3. **查看缓存日志**：

```bash
tail -f /data/squid/logs/store.log
```

### 性能问题排查

1. **查看容器资源使用情况**：

```bash
docker stats squid-container
```

2. **分析访问日志**：识别频繁访问的资源和客户端

```bash
# 统计访问最多的前10个IP
awk '{print $3}' /data/squid/logs/access.log | sort | uniq -c | sort -nr | head -10

# 统计访问最多的前10个URL
awk '{print $7}' /data/squid/logs/access.log | sort | uniq -c | sort -nr | head -10
```

3. **调整缓存策略**：根据访问模式优化缓存配置参数

## 参考资源

- [SQUID镜像文档（轩辕）](https://xuanyuan.cloud/r/ubuntu/squid)
- [SQUID镜像标签列表（轩辕）](https://xuanyuan.cloud/r/ubuntu/squid/tags)
- [Squid官方文档](http://www.squid-cache.org/Doc/)
- [Docker官方文档](https://docs.docker.com/)
- [Ubuntu Docker Images](https://ubuntu.com/security/docker-images)

## 总结

本文详细介绍了SQUID的Docker容器化部署方案，从环境准备到生产环境配置，提供了一套完整的容器化部署指南。通过Docker技术，可以快速实现SQUID的部署、更新和迁移，降低运维复杂度，提高服务可靠性。

**关键要点**：
- 使用轩辕镜像访问支持可显著提升SQUID镜像的拉取访问表现
- 数据持久化是生产环境部署的必要配置，避免容器重建导致数据丢失
- 安全加固和资源限制是生产环境的重要考虑因素
- 合理的监控配置有助于及时发现和解决运行中的问题

**后续建议**：
- 深入学习SQUID的缓存策略和访问控制机制，根据实际业务场景优化配置
- 建立完善的监控告警体系，关注缓存命中率、响应时间等关键指标
- 定期更新SQUID镜像版本，确保安全补丁及时应用
- 探索SQUID集群部署方案，满足更高的性能和可用性需求

通过本文档提供的方法，用户可以快速部署一个功能完善、安全可靠的SQUID缓存代理服务，为网络环境提供高效的内容缓存和访问加速能力。

