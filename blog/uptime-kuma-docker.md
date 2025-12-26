---
id: 98
title: UPTIME-KUMA Docker 容器化部署指南
slug: uptime-kuma-docker
summary: UPTIME-KUMA是一款功能强大的自托管监控工具，旨在为用户提供直观、可靠的服务可用性监控解决方案。作为一款开源工具，它支持多种监控类型（如HTTP、TCP、Ping、DNS等），提供实时状态展示、历史数据统计及告警通知功能，适用于个人开发者、中小企业及各类需要自建监控系统的场景。通过Docker容器化部署，UPTIME-KUMA可以实现快速交付、环境一致性及简化维护等优势，成为现代DevOps实践中的理想监控组件。
category: Docker,UPTIME-KUMA
tags: uptime-kuma,docker,部署教程
image_name: louislam/uptime-kuma
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-uptime-kuma.png"
status: published
created_at: "2025-12-03 06:22:58"
updated_at: "2025-12-04 05:36:17"
---

# UPTIME-KUMA Docker 容器化部署指南

> UPTIME-KUMA是一款功能强大的自托管监控工具，旨在为用户提供直观、可靠的服务可用性监控解决方案。作为一款开源工具，它支持多种监控类型（如HTTP、TCP、Ping、DNS等），提供实时状态展示、历史数据统计及告警通知功能，适用于个人开发者、中小企业及各类需要自建监控系统的场景。通过Docker容器化部署，UPTIME-KUMA可以实现快速交付、环境一致性及简化维护等优势，成为现代DevOps实践中的理想监控组件。

## 概述

UPTIME-KUMA是一款功能强大的自托管监控工具，旨在为用户提供直观、可靠的服务可用性监控解决方案。作为一款开源工具，它支持多种监控类型（如HTTP、TCP、Ping、DNS等），提供实时状态展示、历史数据统计及告警通知功能，适用于个人开发者、中小企业及各类需要自建监控系统的场景。通过Docker容器化部署，UPTIME-KUMA可以实现快速交付、环境一致性及简化维护等优势，成为现代DevOps实践中的理想监控组件。


## 环境准备

### Docker环境安装

部署UPTIME-KUMA前需确保服务器已安装Docker环境。推荐使用以下一键安装脚本，自动完成Docker及相关组件（Docker Engine、Docker CLI、Docker Compose）的安装与配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 脚本执行过程中可能需要sudo权限，请根据提示输入密码。安装完成后，可通过`docker --version`验证安装是否成功。


## 镜像准备

### 镜像信息确认

UPTIME-KUMA官方镜像名称为`louislam/uptime-kuma`，属于多段镜像名（包含斜杠`/`），根据镜像拉取规则，采用以下格式拉取：

```bash
docker pull xxx.xuanyuan.run/louislam/uptime-kuma:{TAG}
```

### 标签选择

根据[UPTIME-KUMA镜像标签列表](https://xuanyuan.cloud/r/louislam/uptime-kuma/tags)，主要标签说明如下：
- `latest`：稳定版，基于Debian系统，推荐生产环境使用
- `debian`：同`latest`，明确指定Debian基础镜像
- `beta`：测试版，包含新功能预览，可能不稳定
- `alpine`：已废弃（因DNS问题），不建议使用

推荐使用`latest`标签以获取最新稳定版本。

### 执行镜像拉取

执行以下命令拉取最新稳定版镜像：

```bash
docker pull xxx.xuanyuan.run/louislam/uptime-kuma:latest
```

> 拉取完成后，可通过`docker images | grep louislam/uptime-kuma`验证镜像是否成功下载。


## 容器部署

### 数据卷创建

为确保监控数据持久化存储（避免容器重建导致数据丢失），首先创建专用数据卷：

```bash
docker volume create uptime-kuma
```

> 数据卷默认存储路径为`/var/lib/docker/volumes/uptime-kuma/_data`，可通过`docker volume inspect uptime-kuma`查看详细信息。

### 容器启动命令

使用以下命令启动UPTIME-KUMA容器，配置参数说明如下：

```bash
docker run -d \
  --restart=always \
  -p 3001:3001 \
  -v uptime-kuma:/app/data \
  --name uptime-kuma \
  xxx.xuanyuan.run/louislam/uptime-kuma:latest
```

参数说明：
- `-d`：后台运行容器
- `--restart=always`：容器退出时自动重启，确保服务持续可用
- `-p 3001:3001`：端口映射，将宿主机3001端口映射到容器3001端口（UPTIME-KUMA默认服务端口）
- `-v uptime-kuma:/app/data`：挂载数据卷，容器内`/app/data`目录映射到宿主机数据卷
- `--name uptime-kuma`：指定容器名称，便于管理

### 容器状态验证

容器启动后，执行以下命令检查运行状态：

```bash
# 查看容器运行状态
docker ps --filter "name=uptime-kuma"

# 查看容器日志（确认服务启动情况）
docker logs -f uptime-kuma
```

若日志中出现`Server started on port 3001`，表示服务启动成功。


## 功能测试

### 访问Web界面

在浏览器中输入`http://<服务器IP>:3001`访问UPTIME-KUMA管理界面。首次访问需完成初始化设置：

1. 创建管理员账户（设置用户名和密码）
2. 确认服务条款
3. 进入主控制台

### 基础功能测试

#### 1. 添加监控项
- 点击左侧菜单栏**Add New Monitor**
- 选择监控类型（如HTTP(s)、Ping、TCP等）
- 配置监控参数（如目标URL、名称、检查间隔等）
- 点击**Save**完成添加

#### 2. 验证监控状态
- 添加完成后，监控项将显示在仪表盘
- 正常状态显示为绿色，异常状态显示为红色
- 点击监控项可查看详细历史数据和响应时间图表

#### 3. 告警配置测试
- 编辑监控项，进入**Notifications**标签页
- 添加告警渠道（如Email、Telegram、Discord等）
- 手动触发故障（如停止目标服务），验证告警是否正常发送


## 生产环境建议

### 安全加固

#### 1. 反向代理与HTTPS
通过Nginx或Traefik等反向代理工具配置HTTPS，避免直接暴露3001端口：

**Nginx示例配置**：
```nginx
server {
    listen 443 ssl;
    server_name uptime.yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

#### 2. 网络隔离
- 使用Docker网络隔离容器，避免直接暴露到公网
- 配置宿主机防火墙（如ufw），仅开放必要端口：
  ```bash
  ufw allow 443/tcp   # 仅开放HTTPS端口（若使用反向代理）
  ufw deny 3001/tcp   # 关闭直接访问的3001端口
  ```

### 资源与性能优化

#### 1. 资源限制
根据服务器配置，为容器设置CPU和内存限制，避免资源耗尽：

```bash
docker run -d \
  --restart=always \
  -p 3001:3001 \
  -v uptime-kuma:/app/data \
  --name uptime-kuma \
  --memory=512m \    # 限制最大内存512MB
  --cpus=0.5 \       # 限制CPU使用0.5核
  xxx.xuanyuan.run/louislam/uptime-kuma:latest
```

#### 2. 数据备份
定期备份数据卷内容，可通过以下脚本实现自动备份：

```bash
#!/bin/bash
BACKUP_DIR="/backup/uptime-kuma"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
docker run --rm -v uptime-kuma:/source -v $BACKUP_DIR:/backup alpine tar -czf /backup/uptime-kuma_$TIMESTAMP.tar.gz -C /source .
```

### 高可用性配置

对于关键业务监控需求，可通过以下方式提升可用性：
- 部署多实例（配合负载均衡）
- 使用外部数据库（如MySQL/PostgreSQL）替代默认SQLite，实现数据共享
- 配置主从备份，定期同步数据卷


## 故障排查

### 容器无法启动

#### 症状
执行`docker ps`未显示uptime-kuma容器，或状态为`Exited`。

#### 排查步骤
1. 查看容器日志：
   ```bash
   docker logs uptime-kuma
   ```
2. 常见原因及解决：
   - **端口冲突**：3001端口被占用，通过`netstat -tuln | grep 3001`查看占用进程，更换宿主机端口（如`-p 3002:3001`）
   - **数据卷权限**：数据卷目录权限不足，执行`chmod -R 777 /var/lib/docker/volumes/uptime-kuma/_data`（临时测试），生产环境建议调整所有者为Docker用户
   - **镜像损坏**：重新拉取镜像：`docker pull xxx.xuanyuan.run/louislam/uptime-kuma:latest`

### Web界面无法访问

#### 症状
浏览器访问`http://<服务器IP>:3001`无响应或显示连接错误。

#### 排查步骤
1. 检查容器状态及端口映射：
   ```bash
   docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{end}}' uptime-kuma
   ```
   确认3001端口映射正常。

2. 检查宿主机防火墙：
   ```bash
   ufw status | grep 3001
   ```
   若未开放，执行`ufw allow 3001/tcp`。

3. 检查网络连通性：
   ```bash
   curl http://localhost:3001  # 在服务器本地测试
   ```
   若本地可访问，可能是网络路由或外部防火墙问题。

### 监控数据丢失

#### 症状
容器重启后，之前配置的监控项消失。

#### 排查步骤
1. 确认数据卷挂载正确：
   ```bash
   docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{end}}' uptime-kuma
   ```
   应显示`uptime-kuma -> /app/data`。

2. 检查数据卷内容：
   ```bash
   docker run --rm -v uptime-kuma:/data alpine ls -la /data
   ```
   正常应包含`kuma.db`等数据库文件，若为空，可能是启动时未正确挂载数据卷，需重新创建容器并指定`-v uptime-kuma:/app/data`。


## 参考资源

- [UPTIME-KUMA镜像文档（轩辕）](https://xuanyuan.cloud/r/louislam/uptime-kuma)
- [UPTIME-KUMA镜像标签列表（轩辕）](https://xuanyuan.cloud/r/louislam/uptime-kuma/tags)
- [UPTIME-KUMA官方GitHub仓库](https://github.com/louislam/uptime-kuma)
- [Docker官方文档 - 数据卷](https://docs.docker.com/storage/volumes/)
- [Nginx反向代理配置指南](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)


## 总结

本文详细介绍了UPTIME-KUMA的Docker容器化部署方案，从环境准备到生产环境优化，提供了完整的实施指南。通过容器化部署，可快速搭建自托管监控系统，实现对各类服务的实时状态监控与告警管理。

**关键要点**：
- 使用一键脚本可快速完成Docker环境及镜像访问支持配置
- 容器部署必须配置数据卷以确保监控数据持久化
- 生产环境需通过反向代理、防火墙和资源限制提升安全性与稳定性

**后续建议**：
- 深入学习UPTIME-KUMA高级特性，如自定义告警规则、状态页面定制、API集成等
- 根据业务需求扩展监控类型，如添加数据库、Docker容器、K8s集群监控
- 定期回顾监控策略，优化检查间隔与告警阈值，避免告警风暴
- 探索与其他工具集成（如Grafana数据可视化、Prometheus指标采集），构建完整监控体系

通过本文方案部署的UPTIME-KUMA可满足中小规模监控需求，为服务稳定性提供可靠保障。

