---
id: 161
title: Portainer-CE 中文版 Docker 容器化部署指南
slug: portainer-ce-cn-docker
summary: Portainer-CE 中文版是一款容器化应用管理工具，提供了直观的Web界面用于管理Docker环境。本版本为中文汉化版，已去除原版中的企业版升级广告及英文提示公告，提供更友好的中文用户体验。该镜像已在arm64和amd64架构上进行测试，适合各类服务器和NAS设备部署。截至目前，该项目的Docker镜像拉取量已突破150万次，反映了其在容器管理领域的广泛应用。
category: Docker,Portainer-CE
tags: portainer-ce,docker,部署教程
image_name: 6053537/portainer-ce
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-portainer-ce-cn.png"
status: published
created_at: "2025-12-14 13:03:16"
updated_at: "2025-12-14 13:03:26"
---

# Portainer-CE 中文版 Docker 容器化部署指南

> Portainer-CE 中文版是一款容器化应用管理工具，提供了直观的Web界面用于管理Docker环境。本版本为中文汉化版，已去除原版中的企业版升级广告及英文提示公告，提供更友好的中文用户体验。该镜像已在arm64和amd64架构上进行测试，适合各类服务器和NAS设备部署。截至目前，该项目的Docker镜像拉取量已突破150万次，反映了其在容器管理领域的广泛应用。

## 概述

Portainer-CE 中文版是一款容器化应用管理工具，提供了直观的Web界面用于管理Docker环境。本版本为中文汉化版，已去除原版中的企业版升级广告及英文提示公告，提供更友好的中文用户体验。该镜像已在arm64和amd64架构上进行测试，适合各类服务器和NAS设备部署。截至目前，该项目的Docker镜像拉取量已突破150万次，反映了其在容器管理领域的广泛应用。

Portainer-CE 中文版主要功能包括容器生命周期管理、镜像管理、网络配置、存储卷管理等，通过Web界面简化了Docker命令行操作的复杂性，适合Docker初学者和需要高效管理多个容器的管理员使用。

## 环境准备

### Docker环境安装

在开始部署Portainer-CE 中文版之前，需要先安装Docker环境。推荐使用以下一键安装脚本，适用于主流Linux发行版：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

该脚本会自动安装Docker Engine、Docker CLI、Docker Compose等必要组件，并配置好基础环境参数。安装完成后，建议将当前用户添加到docker用户组以避免每次使用Docker命令都需要sudo权限：

```bash
sudo usermod -aG docker $USER
```

> ⚠️ 注意：添加用户组后需要注销并重新登录才能生效

## 镜像准备

### 拉取 Portainer-CE 中文版镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的 Portainer-CE 中文版镜像：

```bash
docker pull xxx.xuanyuan.run/6053537/portainer-ce:latest
```

### 验证镜像

拉取完成后，可以使用以下命令验证镜像是否成功下载：

```bash
docker images | grep portainer-ce
```

如果输出类似以下信息，说明镜像拉取成功：

```
xxx.xuanyuan.run/6053537/portainer-ce   latest    abc12345   2 weeks ago   180MB
```

### 镜像标签说明

PORTAINER-CE镜像提供多个标签版本，推荐使用`latest`标签以获取最新的稳定版本。如需使用特定版本，可参考[Portainer-CE 中文版镜像标签列表](https://xuanyuan.cloud/r/6053537/portainer-ce/tags)选择合适的标签。

## 容器部署

Portainer-CE 中文版提供多种部署方式，可根据实际需求选择适合的部署方案。以下是几种常见场景的部署命令：

### 基础部署（推荐）

这是最常用的部署方式，适用于大多数服务器环境：

```bash
docker run -d \
  --name portainer \
  --restart always \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  xxx.xuanyuan.run/6053537/portainer-ce:latest
```

参数说明：
- `-d`: 后台运行容器
- `--name portainer`: 指定容器名称为portainer
- `--restart always`: 设置容器开机自启
- `-p 9000:9000`: 映射Web管理界面端口
- `-v /var/run/docker.sock:/var/run/docker.sock`: 挂载Docker守护进程套接字，使PORTAINER-CE能够管理主机上的Docker环境
- `-v portainer_data:/data`: 创建命名卷存储PORTAINER-CE的数据

### 启用SSL加密访问

对于需要通过公网访问的场景，建议启用SSL加密以提高安全性：

```bash
docker run -d \
  --name portainer \
  --restart always \
  -p 8000:8000 \
  -p 443:9443 \
  -v ~/local-certs:/certs \
  -v portainer_data:/data \
  -v /var/run/docker.sock:/var/run/docker.sock \
  xxx.xuanyuan.run/6053537/portainer-ce:latest \
  --ssl \
  --sslcert /certs/portainer.crt \
  --sslkey /certs/portainer.key
```

> ⚠️ 注意：使用SSL部署前，需要准备好SSL证书文件，并将证书路径替换为实际的证书存放路径。

### Windows Docker Desktop环境部署

在Windows系统上使用Docker Desktop时，部署命令略有不同：

```bash
docker run -d \
  -p 9000:9000 \
  --name portainer \
  --restart always \
  -v \\.\pipe\docker_engine:\\.\pipe\docker_engine \
  -v portainer_data:C:\data \
  xxx.xuanyuan.run/6053537/portainer-ce:latest
```

### 使用Docker Compose部署

对于更复杂的部署需求或需要与其他服务协同工作的场景，可以使用Docker Compose进行部署。创建`docker-compose.yml`文件：

```yaml
version: '3'

services:
  portainer:
    container_name: portainer
    network_mode: bridge
    image: xxx.xuanyuan.run/6053537/portainer-ce:latest
    ports:
      - 9000:9000
      # - 8000:8000  # 可选，用于Portainer Agent通信
      # - 9443:9443  # 可选，用于SSL访问
    volumes:
      - portainer_data:/data
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped

volumes:
  portainer_data:
```

然后使用以下命令启动服务：

```bash
docker-compose up -d
```

## 功能测试

### 访问Web管理界面

容器启动后，等待约30秒让服务完全初始化，然后通过浏览器访问以下地址：

```
http://<服务器IP>:9000
```

首次访问时，系统会要求创建管理员账户。设置管理员用户名和密码后，即可进入PORTAINER-CE的主界面。

### 基本功能测试

1. **登录验证**：使用创建的管理员账户登录系统，验证登录功能正常。

2. **系统状态检查**：在仪表盘页面查看系统状态，确认CPU、内存、磁盘等资源显示正常。

3. **容器管理测试**：尝试创建一个简单的Nginx容器，验证容器创建和管理功能：

   - 在左侧导航栏中选择"容器"
   - 点击"添加容器"按钮
   - 填写容器名称（如"test-nginx"）
   - 镜像名称填写"nginx:latest"
   - 端口映射设置为"8080:80"
   - 点击"部署容器"按钮

4. **访问测试容器**：在浏览器中访问`http://<服务器IP>:8080`，如果看到Nginx默认页面，说明容器创建成功，PORTAINER-CE管理功能正常。

### 日志查看

如果遇到问题，可以通过以下命令查看容器日志：

```bash
docker logs portainer
```

常见的日志问题及解决方法：

- 权限错误：确保`/var/run/docker.sock`文件权限正确
- 端口冲突：如果9000端口已被占用，修改端口映射或停止占用端口的服务
- 数据卷问题：检查命名卷是否正确创建

## 生产环境建议

### 安全加固

1. **启用SSL/TLS**：对于生产环境，强烈建议启用SSL/TLS加密，防止管理流量被窃听。

2. **设置复杂密码**：管理员密码应包含大小写字母、数字和特殊字符，长度不低于12位。

3. **限制访问来源**：通过防火墙或网络策略限制只有特定IP地址可以访问PORTAINER-CE管理界面。

4. **定期更新**：定期更新 Portainer-CE 中文版镜像以获取最新的安全补丁和功能改进：

```bash
# 拉取最新镜像
docker pull xxx.xuanyuan.run/6053537/portainer-ce:latest

# 停止并删除旧容器
docker stop portainer
docker rm portainer

# 使用新镜像启动容器（使用之前的启动命令）
docker run -d --name portainer ...
```

### 性能优化

1. **资源限制**：为容器设置适当的资源限制，避免过度占用系统资源：

```bash
docker run -d \
  --name portainer \
  --restart always \
  --memory=1G \
  --memory-swap=1G \
  --cpus=0.5 \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  xxx.xuanyuan.run/6053537/portainer-ce:latest
```

2. **数据备份**：定期备份PORTAINER-CE的数据卷，以防数据丢失：

```bash
# 创建数据卷备份
docker run --rm -v portainer_data:/source -v $(pwd):/backup alpine tar -czf /backup/portainer_backup.tar.gz -C /source .
```

### Nginx反向代理配置

对于需要通过域名访问或需要在同一服务器上部署多个Web服务的场景，可以使用Nginx作为反向代理：

```nginx
server {
    listen 80;
    server_name portainer.yourdomain.com;
    
    # 重定向到HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name portainer.yourdomain.com;
    
    ssl_certificate /path/to/ssl/cert.pem;
    ssl_certificate_key /path/to/ssl/key.pem;
    
    # SSL配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### 子目录访问配置

如果需要通过域名的子目录访问PORTAINER-CE（如`https://yourdomain.com/portainer`），可以使用以下Nginx配置：

```nginx
location ^~ /portainer/ {
    proxy_pass http://127.0.0.1:9000/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_read_timeout 300s;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

## 故障排查

### 常见问题及解决方法

1. **无法访问Web界面**

   - 检查容器是否运行：`docker ps | grep portainer`
   - 检查端口映射是否正确：`docker port portainer`
   - 检查防火墙设置：确保9000端口（或自定义端口）已开放
   - 查看容器日志：`docker logs portainer`

2. **Docker连接错误**

   如果界面显示无法连接Docker环境，可能是权限问题：

   ```bash
   # 检查Docker套接字权限
   ls -la /var/run/docker.sock
   
   # 如果权限不足，添加权限（临时解决）
   sudo chmod 666 /var/run/docker.sock
   
   # 永久解决方法：将用户添加到docker组
   sudo usermod -aG docker $USER
   ```

3. **忘记管理员密码**

   如果忘记管理员密码，需要删除数据卷并重新创建容器：

   ```bash
   # 停止并删除容器
   docker stop portainer
   docker rm portainer
   
   # 删除数据卷
   docker volume rm portainer_data
   
   # 重新创建容器（使用基础部署命令）
   docker run -d --name portainer ...
   ```

4. **容器启动后立即退出**

   查看日志确定具体原因：`docker logs portainer`，常见原因包括：
   - 端口冲突
   - 数据卷权限问题
   - Docker套接字挂载错误

### 高级故障排查

1. **进入容器内部**

   如果需要检查容器内部情况，可以使用以下命令进入容器：

   ```bash
   docker exec -it portainer sh
   ```

2. **检查容器详细信息**

   ```bash
   docker inspect portainer
   ```

3. **查看容器资源使用情况**

   ```bash
   docker stats portainer
   ```

## 参考资源

1. [Portainer-CE 中文版镜像文档（轩辕）](https://xuanyuan.cloud/r/6053537/portainer-ce)
2. [Portainer-CE 中文版镜像标签列表](https://xuanyuan.cloud/r/6053537/portainer-ce/tags)
3. [Docker官方文档](https://docs.docker.com/)
4. [Docker Compose文档](https://docs.docker.com/compose/)
5. [Nginx官方文档](https://nginx.org/en/docs/)

## 总结

本文详细介绍了 Portainer-CE 中文版的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境建议和故障排查等内容。Portainer-CE 中文版作为一款中文汉化的容器管理工具，提供了直观的Web界面，简化了Docker环境的管理难度，适合各类用户使用。

**关键要点**：
- 使用一键脚本可快速部署Docker环境
- 推荐使用基础部署命令进行初始安装
- 生产环境中应启用SSL加密以提高安全性
- 通过Nginx反向代理可实现更灵活的访问控制
- 定期备份数据卷和更新镜像可提高系统可靠性

**后续建议**：
- 深入学习Portainer-CE 中文版的高级功能，如多环境管理、用户权限控制等
- 根据实际需求调整容器资源限制和网络配置
- 建立定期备份和更新机制，确保系统安全稳定运行
- 探索 Portainer-CE 中文版与其他容器化应用的集成方案

通过本文提供的部署方案，您可以快速搭建一个功能完善的容器管理平台，有效提高Docker环境的管理效率。如需进一步了解 Portainer-CE 中文版的功能和最佳实践，建议参考官方文档和社区资源。

