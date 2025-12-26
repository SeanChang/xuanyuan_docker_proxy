---
id: 94
title: NGINX-PROXY-MANAGER Docker 容器化部署指南
slug: nginx-proxy-manager-docker
summary: NGINX-PROXY-MANAGER（简称NPM）是一款基于Docker容器的Nginx代理主机管理工具，提供直观的Web界面用于配置反向代理、SSL证书自动签发与续期、流量路由等功能。其核心优势在于将复杂的Nginx配置简化为图形化操作，无需手动编写Nginx配置文件，即可快速实现域名代理、负载均衡、HTTPS加密等高级功能。
category: Docker,NGINX-PROXY-MANAGER
tags: nginx-proxy-manager,docker,部署教程
image_name: jc21/nginx-proxy-manager
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-nginx-proxy-manager.png"
status: published
created_at: "2025-12-03 05:41:32"
updated_at: "2025-12-03 05:41:32"
---

# NGINX-PROXY-MANAGER Docker 容器化部署指南

> NGINX-PROXY-MANAGER（简称NPM）是一款基于Docker容器的Nginx代理主机管理工具，提供直观的Web界面用于配置反向代理、SSL证书自动签发与续期、流量路由等功能。其核心优势在于将复杂的Nginx配置简化为图形化操作，无需手动编写Nginx配置文件，即可快速实现域名代理、负载均衡、HTTPS加密等高级功能。

## 概述

NGINX-PROXY-MANAGER（简称NPM）是一款基于Docker容器的Nginx代理主机管理工具，提供直观的Web界面用于配置反向代理、SSL证书自动签发与续期、流量路由等功能。其核心优势在于将复杂的Nginx配置简化为图形化操作，无需手动编写Nginx配置文件，即可快速实现域名代理、负载均衡、HTTPS加密等高级功能。

容器化部署NGINX-PROXY-MANAGER具有以下优势：
- **环境隔离**：与主机系统隔离，避免依赖冲突
- **快速部署**：无需手动编译安装Nginx及相关组件
- **配置持久化**：通过Docker数据卷实现配置与证书持久化
- **跨平台兼容**：支持所有Docker兼容的Linux发行版
- **版本控制**：通过镜像标签轻松管理不同版本


## 环境准备

### Docker环境安装

部署NGINX-PROXY-MANAGER前需先安装Docker环境，推荐使用官方一键安装脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 脚本适用系统：Ubuntu 18.04+/Debian 10+/CentOS 7+/Fedora 30+。执行过程中需输入sudo密码，脚本将自动完成Docker引擎、Docker Compose的安装，并配置开机自启。


## 镜像准备

采用以下拉取格式：

```bash
docker pull xxx.xuanyuan.run/jc21/nginx-proxy-manager:{TAG}
```

### 拉取推荐版本

官方推荐标签为`latest`（最新稳定版），执行以下命令拉取：

```bash
docker pull xxx.xuanyuan.run/jc21/nginx-proxy-manager:latest
```

### 验证镜像拉取结果

拉取完成后，通过以下命令验证镜像是否成功下载：

```bash
docker images | grep jc21/nginx-proxy-manager
```

预期输出示例：
```
xxx.xuanyuan.run/jc21/nginx-proxy-manager   latest    abc12345   2 weeks ago   180MB
```

### 其他版本选择

如需指定版本，可从[NGINX-PROXY-MANAGER镜像标签列表](https://xuanyuan.cloud/r/jc21/nginx-proxy-manager/tags)查看所有可用标签，替换`{TAG}`即可，例如拉取v2.10.4版本：

```bash
docker pull xxx.xuanyuan.run/jc21/nginx-proxy-manager:v2.10.4
```


## 容器部署

### 数据卷创建

为实现配置、证书及日志的持久化存储，需创建专用数据卷：

```bash
# 创建配置数据卷（存储Nginx配置、用户设置等）
docker volume create npm_config

# 创建证书数据卷（存储SSL证书）
docker volume create npm_ssl

# 创建日志数据卷（存储访问日志和错误日志）
docker volume create npm_logs
```

### 容器运行命令

使用以下命令启动NGINX-PROXY-MANAGER容器，映射必要端口并挂载数据卷：

```bash
docker run -d \
  --name nginx-proxy-manager \
  --restart unless-stopped \
  -p 80:80 \       # HTTP流量端口（必须映射，用于Let's Encrypt验证）
  -p 443:443 \     # HTTPS流量端口
  -p 81:81 \       # 管理界面端口
  -v npm_config:/config \
  -v npm_ssl:/etc/letsencrypt \
  -v npm_logs:/var/log/nginx \
  xxx.xuanyuan.run/jc21/nginx-proxy-manager:latest
```

> **参数说明**：
> - `-d`：后台运行容器
> - `--name`：指定容器名称，便于管理
> - `--restart unless-stopped`：容器退出时自动重启（除非手动停止）
> - `-p`：端口映射（主机端口:容器端口）
> - `-v`：数据卷挂载（数据卷名称:容器内路径）

### 验证容器运行状态

执行以下命令检查容器是否正常启动：

```bash
# 查看容器运行状态
docker ps | grep nginx-proxy-manager

# 查看容器日志（前100行）
docker logs --tail 100 nginx-proxy-manager
```

若日志中出现`Application started successfully`字样，说明启动成功。


## 功能测试

### 访问管理界面

在浏览器中输入`http://<服务器IP>:81`访问管理界面，首次登录使用默认凭据：
- **默认邮箱**：admin@example.com
- **默认密码**：changeme

> 注意：若服务器开启防火墙，需确保81端口允许访问（生产环境建议仅对内网开放此端口）。

### 首次登录配置

1. 登录后系统会强制要求修改密码，输入新密码并确认
2. 更新管理员邮箱（建议使用真实邮箱，用于密码找回）
3. 完成后进入主控制台，界面包含"Proxy Hosts"、"SSL Certificates"、"Hosts"等功能模块

### 基本功能测试

#### 测试1：添加反向代理

1. 点击左侧菜单"Proxy Hosts" → "Add Proxy Host"
2. 填写基本信息：
   - Domain Names: 输入测试域名（如`test.example.com`，需确保DNS解析指向当前服务器）
   - Scheme: 选择`http`
   - Forward Hostname/IP: 输入目标服务IP（如`192.168.1.100`）
   - Forward Port: 输入目标服务端口（如`8080`）
3. 点击"Save"保存配置
4. 在本地修改`hosts`文件（或通过DNS解析）将测试域名指向服务器IP，访问`http://test.example.com`，验证是否成功代理到目标服务

#### 测试2：配置SSL证书

1. 在已创建的代理主机条目右侧点击"Edit"
2. 切换到"SSL"标签页
3. 选择"Let's Encrypt" → "Request a new SSL Certificate"
4. 勾选"Force SSL"和"HSTS Enabled"
5. 输入邮箱地址（用于证书到期提醒）
6. 点击"Save"，系统将自动申请并配置SSL证书
7. 几分钟后访问`https://test.example.com`，验证HTTPS是否生效（浏览器显示安全锁图标）


## 生产环境建议

### 安全加固

1. **端口访问控制**
   - 管理端口（81）仅允许内网IP访问，通过防火墙限制：
     ```bash
     # 以ufw为例，仅允许192.168.1.0/24网段访问81端口
     sudo ufw allow from 192.168.1.0/24 to any port 81
     sudo ufw deny 81  # 拒绝其他IP访问
     ```
   - HTTP（80）和HTTPS（443）端口保持开放（用于代理和证书验证）

2. **容器权限控制**
   - 使用非root用户运行容器（需修改镜像或挂载权限）：
     ```bash
     # 添加--user参数指定用户ID（需确保数据卷权限正确）
     docker run -d --user 1000:1000 ...
     ```

3. **定期更新镜像**
   - 每月检查[镜像标签列表](https://xuanyuan.cloud/r/jc21/nginx-proxy-manager/tags)，更新至最新稳定版以修复安全漏洞

### 性能优化

1. **资源限制**
   - 根据服务器配置限制容器资源，避免资源耗尽：
     ```bash
     docker run -d \
       --memory=1G \       # 限制内存使用1GB
       --cpus=0.5 \        # 限制CPU使用0.5核
       --memory-swap=2G \  # 限制交换空间
       ...
     ```

2. **日志管理**
   - 配置日志轮转（通过Docker日志驱动或挂载到主机）：
     ```bash
     # 使用json-file驱动并限制日志大小
     docker run -d \
       --log-driver json-file \
       --log-opt max-size=10m \
       --log-opt max-file=3 \
       ...
     ```

3. **缓存配置**
   - 在代理主机设置中启用"Cache Assets"，减少后端服务压力

### 高可用方案

1. **多实例部署**
   - 部署多个NPM容器，使用负载均衡器（如HAProxy）分发流量
   - 所有实例共享同一数据库（默认使用SQLite，生产环境建议迁移至MySQL/PostgreSQL）

2. **数据备份策略**
   - 定期备份数据卷内容：
     ```bash
     # 备份配置数据卷
     docker run --rm -v npm_config:/source -v $(pwd):/backup alpine tar -czf /backup/npm_config_backup.tar.gz -C /source .
     ```
   - 备份文件建议存储在异地或对象存储中


## 故障排查

### 常见问题及解决方法

#### 问题1：管理界面无法访问
- **排查步骤**：
  1. 检查容器状态：`docker inspect -f '{{.State.Status}}' nginx-proxy-manager`
  2. 检查端口映射：`docker port nginx-proxy-manager | grep 81`
  3. 检查防火墙规则：`sudo ufw status`（或对应防火墙工具）
  4. 查看容器日志：`docker logs nginx-proxy-manager | grep -i error`
- **解决方案**：
  - 若容器未运行：`docker start nginx-proxy-manager`
  - 若端口冲突：使用`lsof -i :81`查找占用进程并停止，或修改映射端口（如`-p 8081:81`）

#### 问题2：SSL证书申请失败
- **排查步骤**：
  1. 确认80端口未被占用且可从公网访问（Let's Encrypt验证需要）
  2. 检查域名DNS解析是否正确：`nslookup test.example.com`
  3. 查看证书申请日志：`docker exec -it nginx-proxy-manager cat /var/log/letsencrypt/letsencrypt.log`
- **解决方案**：
  - 确保服务器80/443端口对公网开放
  - 验证域名A记录指向当前服务器IP
  - 清除浏览器缓存或使用无痕模式重试

#### 问题3：代理主机无法访问后端服务
- **排查步骤**：
  1. 检查目标服务是否正常：`curl http://<目标IP>:<目标端口>`
  2. 查看Nginx访问日志：`docker exec -it nginx-proxy-manager cat /var/log/nginx/access.log`
  3. 查看Nginx错误日志：`docker exec -it nginx-proxy-manager cat /var/log/nginx/error.log`
- **解决方案**：
  - 确保目标服务IP和端口正确（容器内无法使用`localhost`访问主机服务，需使用主机内网IP）
  - 检查目标服务是否允许来自NPM容器IP的访问
  - 验证代理配置中的"Scheme"是否与目标服务一致（http/https）


## 参考资源

- [NGINX-PROXY-MANAGER镜像文档（轩辕）](https://xuanyuan.cloud/r/jc21/nginx-proxy-manager)
- [NGINX-PROXY-MANAGER镜像标签列表](https://xuanyuan.cloud/r/jc21/nginx-proxy-manager/tags)
- [Docker官方文档 - 数据卷管理](https://docs.docker.com/storage/volumes/)
- [Let's Encrypt官方文档](https://letsencrypt.org/docs/)
- [Nginx官方文档 - 反向代理配置](https://nginx.org/en/docs/http/ngx_http_proxy_module.html)


## 总结

本文详细介绍了NGINX-PROXY-MANAGER的Docker容器化部署流程，从环境准备、镜像拉取到容器运行、功能测试，提供了完整可复现的步骤。通过容器化部署，可快速搭建功能完善的Nginx代理管理平台，简化反向代理和SSL证书管理流程。

**关键要点**：
- 使用轩辕一键脚本可快速配置Docker环境及镜像访问支持
- 镜像拉取直接使用`xxx.xuanyuan.run/原始名称:标签`
- 数据卷持久化是确保配置和证书不丢失的关键
- 生产环境需重点关注端口安全、资源限制和数据备份

**后续建议**：
- 深入学习NGINX-PROXY-MANAGER高级功能，如负载均衡、流量限制、自定义Nginx配置
- 结合监控工具（如Prometheus+Grafana）监控代理流量和服务健康状态
- 探索Docker Compose或Kubernetes部署方案，实现更灵活的服务编排
- 定期关注官方更新，及时修复安全漏洞，保持系统稳定运行

