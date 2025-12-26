---
id: 91
title: OPENLIST Docker 容器化部署指南
slug: openlist-docker
summary: OPENLIST是一款基于Gin后端和SolidJS前端开发的多存储文件列表程序，作为AList的分支项目，它继承了文件管理的核心功能并可能提供额外特性。该程序支持多种存储后端集成，包括本地文件系统、云存储服务等，适用于个人或企业构建轻量级文件管理解决方案。
category: Docker,OPENLIST
tags: openlist,docker,部署教程
image_name: openlistteam/openlist
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-openlist.png"
status: published
created_at: "2025-12-03 03:01:29"
updated_at: "2025-12-03 03:01:56"
---

# OPENLIST Docker 容器化部署指南

> OPENLIST是一款基于Gin后端和SolidJS前端开发的多存储文件列表程序，作为AList的分支项目，它继承了文件管理的核心功能并可能提供额外特性。该程序支持多种存储后端集成，包括本地文件系统、云存储服务等，适用于个人或企业构建轻量级文件管理解决方案。

## 概述

OPENLIST是一款基于Gin后端和SolidJS前端开发的多存储文件列表程序，作为AList的分支项目，它继承了文件管理的核心功能并可能提供额外特性。该程序支持多种存储后端集成，包括本地文件系统、云存储服务等，适用于个人或企业构建轻量级文件管理解决方案。

通过Docker容器化部署OPENLIST，可实现环境一致性、快速部署和版本隔离等优势。本文档将详细介绍OPENLIST的Docker部署流程，包括环境准备、镜像拉取、容器配置、功能验证及生产环境优化建议，帮助用户快速上手并稳定运行服务。


## 环境准备

### Docker环境安装

部署OPENLIST前需确保服务器已安装Docker环境，推荐使用轩辕云提供的一键安装脚本，该脚本适用于主流Linux发行版（Ubuntu/Debian/CentOS/RHEL等）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

执行脚本后，系统将自动完成Docker Engine、Docker Compose的安装及配置，无需手动干预。安装完成后，可通过以下命令验证Docker是否正常运行：

```bash
docker --version  # 验证Docker引擎版本
docker compose version  # 验证Docker Compose版本
systemctl status docker  # 检查Docker服务状态
```


## 镜像准备

### 镜像信息确认

- **镜像名称**：openlistteam/openlist
- **推荐标签**：latest（稳定版，如需特定版本可参考[OPENLIST镜像标签列表](https://xuanyuan.cloud/r/openlistteam/openlist/tags)）
- **功能描述**：多存储支持的文件列表程序，基于Gin后端和SolidJS前端，AList分支项目


### 镜像拉取命令

拉取命令格式为：

```bash
docker pull xxx.xuanyuan.run/openlistteam/openlist:latest
```

#### 验证拉取结果：
拉取完成后，可通过以下命令检查本地镜像：

```bash
docker images | grep openlistteam/openlist
```

预期输出示例：
```
xxx.xuanyuan.run/openlistteam/openlist   latest    abc12345   2 weeks ago   500MB
```


## 容器部署

### 基础部署命令

根据OPENLIST的应用特性（文件列表程序），基础部署需包含端口映射和数据持久化配置。以下为推荐的容器启动命令：

```bash
docker run -d \
  --name openlist \
  --restart always \
  -p 5244:5244 \  # 假设默认端口为5244（参考AList默认端口，具体以[轩辕镜像 - OPENLIST文档](https://xuanyuan.cloud/r/openlistteam/openlist)为准）
  -v /data/openlist:/app/data \  # 持久化存储目录（配置文件、数据等）
  xxx.xuanyuan.run/openlistteam/openlist:latest
```

#### 参数说明：
- `-d`：后台运行容器
- `--name openlist`：指定容器名称为`openlist`，便于管理
- `--restart always`：容器退出时自动重启，确保服务持续运行
- `-p 5244:5244`：端口映射（宿主机端口:容器端口），请根据[官方文档](https://xuanyuan.cloud/r/openlistteam/openlist)确认实际端口
- `-v /data/openlist:/app/data`：持久化挂载，将容器内`/app/data`目录映射到宿主机`/data/openlist`，避免数据丢失

### 自定义配置（可选）

如需通过环境变量调整配置，可添加`-e`参数，例如设置管理员密码：

```bash
docker run -d \
  --name openlist \
  --restart always \
  -p 5244:5244 \
  -v /data/openlist:/app/data \
  -e ADMIN_PASSWORD="your_secure_password" \  # 自定义管理员密码
  -e LOG_LEVEL="info" \  # 日志级别
  xxx.xuanyuan.run/openlistteam/openlist:latest
```

> 所有支持的环境变量可参考[轩辕镜像 - OPENLIST文档](https://xuanyuan.cloud/r/openlistteam/openlist)中的"环境变量"章节。

### 部署验证

容器启动后，通过以下命令检查状态：

```bash
docker ps | grep openlist
```

若状态为`Up`，表示启动成功：
```
abc123456789   xxx.xuanyuan.run/openlistteam/openlist:latest   "/entrypoint.sh"   2 minutes ago   Up 2 minutes   0.0.0.0:5244->5244/tcp   openlist
```


## 功能测试

### 服务访问验证

1. **通过浏览器访问**：  
   在本地浏览器输入 `http://<服务器IP>:5244`（替换为实际服务器IP和端口），若看到OPENLIST的登录/首页界面，说明服务部署成功。

2. **基础功能测试**：
   - **登录验证**：使用默认管理员账号（通常为`admin`，密码可能在首次启动日志中，或通过环境变量设置）登录系统
   - **存储配置**：尝试添加本地存储或云存储（如阿里云OSS、OneDrive等），验证多存储支持功能
   - **文件操作**：上传、下载、删除文件，检查基本文件管理功能是否正常
   - **界面响应**：测试页面切换、搜索功能，验证SolidJS前端交互是否流畅

### 日志验证

若服务无法访问，可通过日志排查问题：

```bash
docker logs openlist
```

关键日志信息包括：
- 服务启动日志：`Server started on :5244`（确认端口监听）
- 配置加载日志：`Loaded config from /app/data/config.json`（确认持久化目录挂载正常）
- 错误日志：若出现`port is already in use`，表示端口冲突，需修改宿主机端口映射


## 生产环境建议

### 数据安全增强

1. **持久化存储优化**：
   - 使用独立分区或存储卷（如Docker Volume）管理`/app/data`目录，避免宿主机磁盘空间不足影响服务
   - 定期备份`/data/openlist`目录，可通过`rsync`或备份脚本实现自动化备份：
     ```bash
     # 示例：每日凌晨2点备份数据
     echo "0 2 * * * rsync -av /data/openlist /backup/openlist_$(date +\%Y\%m\%d)" >> /etc/crontab
     ```

2. **权限控制**：
   - 避免使用`root`用户运行容器，通过`--user`参数指定非特权用户：
     ```bash
     docker run -d --user 1001:1001 ...  # 假设宿主机存在UID/GID为1001的用户
     ```
   - 限制宿主机挂载目录权限：`chmod 700 /data/openlist`，仅允许容器用户访问

### 性能与稳定性优化

1. **资源限制**：
   根据服务器配置限制容器资源，避免过度占用系统资源：
   ```bash
   docker run -d \
     --memory=2G \  # 限制内存使用2GB
     --cpus=1 \  # 限制CPU核心1个
     ...  # 其他参数
   ```

2. **网络优化**：
   - 使用Docker自定义网络隔离服务：`docker network create openlist-net && docker run --network openlist-net ...`
   - 搭配Nginx反向代理，实现HTTPS加密（推荐Let's Encrypt免费证书）：
     ```nginx
     server {
       listen 443 ssl;
       server_name file.yourdomain.com;
       
       ssl_certificate /etc/letsencrypt/live/file.yourdomain.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/file.yourdomain.com/privkey.pem;
       
       location / {
         proxy_pass http://openlist:5244;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
       }
     }
     ```

### 监控与运维

1. **健康检查**：
   添加Docker健康检查，自动检测服务状态：
   ```bash
   docker run -d \
     --health-cmd "curl -f http://localhost:5244/api/health || exit 1" \
     --health-interval 30s \
     --health-timeout 10s \
     --health-retries 3 \
     ...  # 其他参数
   ```

2. **日志管理**：
   - 使用`docker logs --tail 100 -f openlist`实时查看日志
   - 配置日志驱动，将日志输出到文件或日志系统（如ELK Stack）：
     ```bash
     docker run -d \
       --log-driver json-file \
       --log-opt max-size=10m \  # 单日志文件最大10MB
       --log-opt max-file=3 \  # 最多保留3个日志文件
       ...  # 其他参数
     ```


## 故障排查

### 常见问题解决

1. **容器启动后立即退出**：
   - 检查日志：`docker logs openlist`，若提示`config.json: permission denied`，需修复宿主机挂载目录权限：
     ```bash
     chown -R 1001:1001 /data/openlist  # 与容器运行用户UID/GID保持一致
     ```
   - 检查端口冲突：使用`netstat -tuln | grep 5244`确认端口是否被其他服务占用，若冲突则修改宿主机端口映射（如`-p 5245:5244`）

2. **无法访问Web界面**：
   - 网络检查：确认服务器防火墙开放5244端口（以CentOS为例）：
     ```bash
     firewall-cmd --add-port=5244/tcp --permanent && firewall-cmd --reload
     ```
   - 容器IP验证：通过`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' openlist`获取容器IP，在宿主机执行`curl http://<容器IP>:5244`验证服务是否正常

3. **存储配置后文件不显示**：
   - 检查存储路径权限：确保容器对挂载的存储目录有读写权限
   - 查看应用日志：`docker logs openlist | grep storage`，排查存储配置错误（如访问密钥错误、路径不存在等）

### 高级排查工具

1. **进入容器调试**：
   ```bash
   docker exec -it openlist /bin/sh  # 进入容器命令行
   ```
   可检查配置文件、依赖库、进程状态等

2. **容器资源监控**：
   ```bash
   docker stats openlist  # 实时查看CPU、内存、网络IO使用情况
   ```
   若资源占用异常，可能需优化配置或升级服务器规格


## 参考资源

1. **官方文档与镜像信息**：
   - [轩辕镜像 - OPENLIST文档](https://xuanyuan.cloud/r/openlistteam/openlist)（镜像使用说明）
   - [OPENLIST镜像标签列表](https://xuanyuan.cloud/r/openlistteam/openlist/tags)（所有可用版本）

2. **Docker相关工具**：
   - [Docker官方文档](https://docs.docker.com/)（基础命令与概念）
   - [Docker Compose文档](https://docs.docker.com/compose/)（多容器部署工具）

3. **同类项目参考**：
   - [AList官方文档](https://alist.nn.ci/)（OPENLIST的上游项目，功能与配置可参考）


## 总结

本文详细介绍了OPENLIST的Docker容器化部署方案，从环境准备到生产环境优化，覆盖了完整的部署生命周期。通过轩辕镜像访问支持，实现了海外镜像的快速拉取；通过容器化部署，确保了服务的环境一致性和快速迁移能力。

**关键要点**：
- 使用轩辕一键脚本可快速配置Docker环境及镜像访问支持，简化部署流程
- 镜像拉取直接使用`xxx.xuanyuan.run/openlistteam/openlist:latest`拉取
- 生产环境需重点关注数据持久化、权限控制和资源监控，确保服务稳定安全运行
- 故障排查优先通过日志定位问题，结合容器内外网络与权限检查快速解决常见问题

**后续建议**：
- 深入学习[轩辕镜像 - OPENLIST文档](https://xuanyuan.cloud/r/openlistteam/openlist)中的高级配置，如LDAP认证、多用户管理等特性
- 根据业务需求调整存储策略，结合对象存储服务（如S3、OSS）实现大规模文件管理
- 探索容器编排方案（如Docker Compose、Kubernetes），实现多实例部署和自动扩缩容

通过本文档的指导，用户可快速部署OPENLIST服务，并根据实际需求进行功能扩展与性能优化，充分发挥其多存储文件列表的核心优势。

