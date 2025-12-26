# SERVER (vaultwarden/server) Docker 容器化部署指南

![SERVER (vaultwarden/server) Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-vaultwarden.png)

*分类: Docker,vaultwarden | 标签: vaultwarden,docker,部署教程 | 发布时间: 2025-12-02 03:56:05*

> SERVER（vaultwarden/server）是一个基于Rust实现的Bitwarden API替代方案，提供轻量级、自托管的密码管理解决方案。该项目前身为Bitwarden_RS，旨在为资源受限环境提供与官方Bitwarden服务器兼容的功能集，同时保持较低的系统资源占用。

## 概述

SERVER（vaultwarden/server）是一个基于Rust实现的Bitwarden API替代方案，提供轻量级、自托管的密码管理解决方案。该项目前身为Bitwarden_RS，旨在为资源受限环境提供与官方Bitwarden服务器兼容的功能集，同时保持较低的系统资源占用。

### 核心功能

- **完整的Bitwarden API实现**：支持Vault核心功能、组织管理、附件存储
- **多因素认证**：支持TOTP、U2F、YubiKey及Duo认证
- **Web界面服务**：内置静态Web Vault界面，无需额外部署前端
- **跨平台兼容性**：与官方Bitwarden客户端（桌面、移动、浏览器扩展）完全兼容
- **数据持久化**：支持通过卷挂载实现数据持久化存储

### 容器化优势

- **部署简化**：无需手动配置依赖环境，一键启动服务
- **环境隔离**：与主机系统隔离，避免依赖冲突
- **版本控制**：通过镜像标签轻松管理不同版本
- **跨平台一致**：在任何支持Docker的环境中保持一致运行行为

## 环境准备

### Docker环境安装

使用轩辕提供的一键安装脚本，可快速部署Docker环境并配置镜像访问支持：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 脚本将自动完成Docker Engine、Docker Compose的安装及系统配置，适用于Ubuntu、Debian、CentOS等主流Linux发行版。


## 镜像准备

### 镜像拉取

vaultwarden/server 采用以下命令拉取轩辕加速镜像：

```bash
docker pull xxx.xuanyuan.run/vaultwarden/server:latest
```

> **版本说明**：
> - `latest`：最新稳定版，适合生产环境
> - 如需指定版本，可访问[Vaultwarden镜像标签列表（轩辕）](https://xuanyuan.cloud/r/vaultwarden/server/tags)查看所有可用标签，例如拉取1.32.0版本：
>   ```bash
>   docker pull xxx.xuanyuan.run/vaultwarden/server:1.32.0
>   ```

### 镜像验证

拉取完成后，通过以下命令验证镜像信息：

```bash
docker images xxx.xuanyuan.run/vaultwarden/server
```

预期输出示例：
```
REPOSITORY                          TAG       IMAGE ID       CREATED      SIZE
xxx.xuanyuan.run/vaultwarden/server   latest    1234abcd5678   2 weeks ago  190MB
```

## 容器部署

### 基础部署

使用以下命令启动基础功能的Vaultwarden容器：

```bash
docker run -d \
  --name vaultwarden \
  --restart=always \
  -v /vw-data:/data/ \
  -p 80:80 \
  xxx.xuanyuan.run/vaultwarden/server:latest
```

#### 参数说明

| 参数                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `-d`                | 后台运行容器                                                         |
| `--name vaultwarden`| 指定容器名称为vaultwarden                                           |
| `--restart=always`  | 容器退出时自动重启，确保服务持续可用                                 |
| `-v /vw-data:/data/`| 将宿主机`/vw-data`目录挂载到容器`/data`目录，用于持久化存储所有数据   |
| `-p 80:80`          | 端口映射，将容器80端口映射到宿主机80端口                             |
| `xxx.xuanyuan.run/vaultwarden/server:latest` | 使用的镜像名称及标签                               |

### 自定义配置部署

如需自定义配置（如SMTP邮件服务、管理员设置、HTTPS等），可通过环境变量或配置文件实现。以下是包含常用配置的部署示例：

```bash
docker run -d \
  --name vaultwarden \
  --restart=always \
  -v /vw-data:/data/ \
  -v /etc/letsencrypt:/etc/letsencrypt \  # 挂载SSL证书（如需HTTPS）
  -p 80:80 \
  -p 443:443 \                            # HTTPS端口
  -e ADMIN_TOKEN="your_strong_random_token" \  # 管理员令牌
  -e SMTP_HOST=smtp.example.com \          # SMTP服务器
  -e SMTP_PORT=587 \                       # SMTP端口
  -e SMTP_FROM=vault@example.com \         # 发件人邮箱
  -e SMTP_USERNAME=user@example.com \      # SMTP用户名
  -e SMTP_PASSWORD=your_smtp_password \    # SMTP密码
  -e SMTP_SECURITY=starttls \              # SMTP安全类型（starttls/tls/none）
  -e DOMAIN=https://vault.example.com \    # 访问域名（用于生成链接）
  xxx.xuanyuan.run/vaultwarden/server:latest
```

> **管理员令牌生成**：建议使用以下命令生成高强度随机令牌：
> ```bash
> openssl rand -base64 48
> ```

### 容器状态检查

部署完成后，通过以下命令检查容器运行状态：

```bash
# 查看容器状态
docker ps | grep vaultwarden

# 查看容器日志
docker logs -f vaultwarden
```

预期日志输出应包含类似以下内容，表示服务启动成功：
```
[INFO] Vaultwarden version 1.32.0
[INFO] Web vault is being served at /
[INFO] Registered 23 different endpoints
[INFO] Starting Web Server on 0.0.0.0:80
```

## 功能测试

### 基础访问测试

1. **访问Web界面**：在浏览器中输入`http://<服务器IP>`或`https://<域名>`（如配置HTTPS）
2. **注册管理员账户**：首次访问时需创建管理员账户（注意：此账户将拥有最高权限）
3. **登录验证**：使用注册的账户登录，验证是否成功进入Vault界面

### 核心功能测试

#### 1. 密码管理测试
- 创建新密码条目，填写网站URL、用户名、密码等信息
- 测试自动填充功能（需安装Bitwarden浏览器扩展并连接到自建服务器）
- 尝试添加附件，验证附件上传/下载功能

#### 2. 组织功能测试
- 从左侧导航栏进入"组织"页面
- 创建新组织，邀请测试用户（可使用临时邮箱）
- 验证组织共享密码功能，测试权限控制

#### 3. 多因素认证测试
- 进入账户设置 → "安全" → "多因素认证"
- 启用TOTP认证（使用Google Authenticator等APP扫码）
- 退出登录后重新登录，验证TOTP码是否正常工作

### 服务可用性测试

```bash
# 测试HTTP端口响应
curl -I http://localhost:80

# 预期响应
HTTP/1.1 200 OK
Content-Length: 0
Content-Type: text/plain; charset=utf-8
```

## 生产环境建议

### HTTPS配置

由于现代浏览器限制非安全上下文（HTTP）中的Web Crypto API使用，生产环境必须配置HTTPS。推荐两种实现方式：

#### 方式一：使用反向代理（推荐）

以Nginx为例，配置反向代理及SSL终结：

```nginx
server {
    listen 80;
    server_name vault.example.com;
    return 301 https://$host$request_uri;  # HTTP重定向到HTTPS
}

server {
    listen 443 ssl;
    server_name vault.example.com;

    ssl_certificate /etc/letsencrypt/live/vault.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/vault.example.com/privkey.pem;

    # SSL配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';

    # 反向代理配置
    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### 方式二：直接配置容器HTTPS

```bash
docker run -d \
  --name vaultwarden \
  --restart=always \
  -v /vw-data:/data/ \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -p 443:8080 \
  -e ROCKET_TLS='{certs="/etc/letsencrypt/live/vault.example.com/fullchain.pem",key="/etc/letsencrypt/live/vault.example.com/privkey.pem"}' \
  xxx.xuanyuan.run/vaultwarden/server:latest
```

### 数据备份策略

1. **定期备份数据目录**：

```bash
# 创建备份脚本 /backup-vault.sh
#!/bin/bash
BACKUP_DIR="/var/backups/vaultwarden"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/vaultwarden_$TIMESTAMP.tar.gz /vw-data

# 设置权限并添加到crontab
chmod +x /backup-vault.sh
echo "0 3 * * * /backup-vault.sh" | crontab -
```

2. **备份保留策略**：保留最近30天备份，自动清理旧备份

```bash
# 添加到备份脚本末尾
find $BACKUP_DIR -name "vaultwarden_*.tar.gz" -type f -mtime +30 -delete
```

### 资源限制

为避免容器过度占用系统资源，建议添加资源限制：

```bash
docker run -d \
  --name vaultwarden \
  --restart=always \
  --memory=2G \          # 限制最大内存使用2GB
  --memory-swap=2G \     # 限制内存+交换空间总和2GB
  --cpus=1 \             # 限制CPU使用1核
  --pids-limit=50 \      # 限制进程数不超过50
  -v /vw-data:/data/ \
  -p 80:80 \
  xxx.xuanyuan.run/vaultwarden/server:latest
```

### 安全加固

1. **非root用户运行**：

```bash
# 创建数据目录并设置权限
mkdir -p /vw-data
chown -R 1000:1000 /vw-data

# 以UID/GID 1000运行容器
docker run -d \
  --name vaultwarden \
  --user 1000:1000 \
  -v /vw-data:/data/ \
  -p 80:80 \
  xxx.xuanyuan.run/vaultwarden/server:latest
```

2. **网络隔离**：创建专用Docker网络

```bash
# 创建自定义网络
docker network create vault-network

# 在专用网络中运行容器
docker run -d \
  --name vaultwarden \
  --network vault-network \
  -v /vw-data:/data/ \
  xxx.xuanyuan.run/vaultwarden/server:latest

# 反向代理也加入同一网络（无需暴露端口到宿主机）
docker run -d \
  --name nginx-proxy \
  --network vault-network \
  -p 80:80 -p 443:443 \
  -v /etc/nginx/conf.d:/etc/nginx/conf.d \
  nginx:alpine
```

3. **禁用管理员令牌（如无需）**：生产环境如不需要管理界面，可设置`ADMIN_TOKEN=`（空值）禁用管理员接口

### 监控配置

使用Prometheus+Grafana监控容器状态：

1. 添加监控标签并暴露 metrics 接口：

```bash
docker run -d \
  --name vaultwarden \
  --label "com.docker.compose.service=vaultwarden" \
  -v /vw-data:/data/ \
  -p 80:80 \
  -e ENABLE_METRICS=true \  # 启用metrics接口
  xxx.xuanyuan.run/vaultwarden/server:latest
```

2. Prometheus配置示例：

```yaml
scrape_configs:
  - job_name: 'docker'
    static_configs:
      - targets: ['cadvisor:8080']
  - job_name: 'vaultwarden'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['vaultwarden:80']
```

## 故障排查

### 常见问题及解决方法

#### 1. 容器无法启动

```bash
# 查看详细日志
docker logs vaultwarden

# 常见原因及解决：
# - 端口冲突：更换映射端口，如-p 8080:80
# - 数据目录权限：chmod 777 /vw-data 或调整目录所有者
# - 配置错误：检查环境变量是否正确设置，特别是路径和证书相关
```

#### 2. Web界面无法访问

- **网络层面**：
  ```bash
  # 检查容器端口映射
  docker port vaultwarden
  
  # 检查宿主机防火墙
  ufw status  # 如启用UFW，确保80/443端口开放
  ```

- **应用层面**：
  ```bash
  # 检查容器内服务状态
  docker exec -it vaultwarden /bin/sh
  ps aux | grep vaultwarden
  ```

#### 3. 数据库错误

Vaultwarden默认使用SQLite数据库，如出现数据库损坏：

```bash
# 进入容器
docker exec -it vaultwarden /bin/sh

# 运行SQLite修复
sqlite3 /data/db.sqlite3 "PRAGMA integrity_check;"
sqlite3 /data/db.sqlite3 ".recover" > /data/db_recovered.sqlite3

# 替换损坏数据库（需先停止容器）
docker stop vaultwarden
mv /vw-data/db.sqlite3 /vw-data/db.sqlite3.bak
mv /vw-data/db_recovered.sqlite3 /vw-data/db.sqlite3
docker start vaultwarden
```

#### 4. 邮件发送失败

检查SMTP配置并测试：

```bash
# 安装邮件测试工具
apt-get install swaks

# 测试SMTP连接
swaks --server smtp.example.com:587 \
  --from vault@example.com \
  --to test@example.com \
  --auth-user user@example.com \
  --auth-password your_smtp_password \
  --tls
```

## 参考资源

### 官方资源

- **项目GitHub仓库**：[dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden)
- **官方Wiki**：[Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- **官方论坛**：[Vaultwarden Discourse](https://vaultwarden.discourse.group/)

### 轩辕镜像资源

- **Vaultwarden镜像文档（轩辕）**：[https://xuanyuan.cloud/r/vaultwarden/server](https://xuanyuan.cloud/r/vaultwarden/server)
- **Vaultwarden镜像标签列表（轩辕）**：[https://xuanyuan.cloud/r/vaultwarden/server/tags](https://xuanyuan.cloud/r/vaultwarden/server/tags)
- **轩辕Docker一键安装脚本**：[https://xuanyuan.cloud/docker.sh](https://xuanyuan.cloud/docker.sh)

### 相关工具

- **Bitwarden客户端下载**：[https://bitwarden.com/download/](https://bitwarden.com/download/)
- **Let's Encrypt证书申请**：[Certbot](https://certbot.eff.org/)
- **Nginx反向代理配置生成器**：[nginxconfig.io](https://nginxconfig.io/)

## 总结

本文详细介绍了Vaultwarden（SERVER）的Docker容器化部署方案，从环境准备、镜像拉取、容器部署到生产环境优化，提供了完整的部署流程和最佳实践。通过Docker部署Vaultwarden，可快速搭建安全可靠的自托管密码管理服务，兼顾易用性和安全性。

**关键要点**：

- 使用轩辕一键脚本可快速完成Docker环境部署及镜像访问支持配置，解决国内网络访问Docker Hub访问表现慢的问题
- 镜像拉取：`docker pull xxx.xuanyuan.run/vaultwarden/server:latest`
- 数据持久化通过`-v /vw-data:/data/`实现，此步骤对生产环境至关重要，确保数据不会因容器重建而丢失
- 生产环境必须配置HTTPS，可通过反向代理（推荐）或直接配置容器HTTPS两种方式实现
- 定期备份`/vw-data`目录是保障数据安全的关键措施，建议配置自动化备份策略

**后续建议**：

- 深入学习Vaultwarden高级特性，如组织管理、密码策略、目录同步等功能
- 根据实际使用情况调整资源限制参数，平衡性能与资源消耗
- 建立完善的监控告警机制，及时发现并解决服务异常
- 关注项目官方更新，定期更新镜像以获取最新功能和安全补丁
- 考虑部署高可用架构，通过主从复制或集群方案提高服务可用性

**参考链接**：

- [Vaultwarden官方GitHub仓库](https://github.com/dani-garcia/vaultwarden)
- [Vaultwarden镜像文档（轩辕）](https://xuanyuan.cloud/r/vaultwarden/server)
- [Vaultwarden Wiki（部署指南）](https://github.com/dani-garcia/vaultwarden/wiki/Deployment)
- [Docker官方文档](https://docs.docker.com/)

