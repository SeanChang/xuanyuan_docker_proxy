---
id: 89
title: gitea Docker 容器化部署指南
slug: gitea-docker
summary: GITEA 是一款开源、轻量级的自托管 Git 服务，提供类似于 GitHub、GitLab 的代码托管功能，支持版本控制、代码审查、issue 跟踪、Wiki 等核心特性。其设计目标是简单易用、资源占用低，适合个人开发者、小型团队或企业内部搭建私有代码仓库。
category: Docker,GITEA
tags: gitea,docker,部署教程
image_name: gitea/gitea
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-gitea.png"
status: published
created_at: "2025-12-02 08:00:17"
updated_at: "2025-12-02 08:00:17"
---

# gitea Docker 容器化部署指南

> GITEA 是一款开源、轻量级的自托管 Git 服务，提供类似于 GitHub、GitLab 的代码托管功能，支持版本控制、代码审查、issue 跟踪、Wiki 等核心特性。其设计目标是简单易用、资源占用低，适合个人开发者、小型团队或企业内部搭建私有代码仓库。

## 概述

GITEA 是一款开源、轻量级的自托管 Git 服务，提供类似于 GitHub、GitLab 的代码托管功能，支持版本控制、代码审查、issue 跟踪、Wiki 等核心特性。其设计目标是简单易用、资源占用低，适合个人开发者、小型团队或企业内部搭建私有代码仓库。

通过 Docker 容器化部署 GITEA 可带来以下优势：
- **环境一致性**：容器封装所有依赖，避免"在我电脑上能运行"的环境差异问题
- **快速部署**：无需手动配置系统依赖，一条命令即可启动服务
- **隔离性**：与主机系统及其他应用隔离，减少冲突风险
- **易于维护**：支持数据卷持久化存储，升级或迁移时只需操作容器和数据卷
- **资源可控**：可通过 Docker 限制 CPU、内存等资源占用

本文将详细介绍通过 Docker 容器化部署 GITEA 的完整流程，包括环境准备、镜像拉取、容器配置、功能测试及生产环境优化建议，所有操作基于轩辕镜像访问支持服务以确保国内环境下的部署效率。


## 环境准备

### Docker 安装

GITEA 容器化部署需依赖 Docker 环境，推荐使用以下一键安装脚本完成 Docker 及相关组件（Docker Engine、Docker Compose）的安装与配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 脚本支持主流 Linux 发行版（Ubuntu、Debian、CentOS、Rocky Linux 等），会自动处理系统依赖、添加官方源、安装最新稳定版 Docker 并配置服务自启动。


## 镜像准备

拉取命令格式如下：

```bash
docker pull xxx.xuanyuan.run/gitea/gitea:{TAG}
```

其中 `{TAG}` 为镜像版本标签，推荐使用 `latest`（最新稳定版），可通过 [GITEA 镜像标签列表](https://xuanyuan.cloud/r/gitea/gitea/tags) 查看所有可用版本。

### 拉取推荐镜像

执行以下命令拉取推荐的 `latest` 标签镜像：

```bash
docker pull xxx.xuanyuan.run/gitea/gitea:latest
```

> 若需指定特定版本（如 `1.21.0`），将命令中的 `latest` 替换为对应标签即可，例如：`docker pull xxx.xuanyuan.run/gitea/gitea:1.21.0`

拉取完成后，可通过 `docker images` 命令验证镜像是否成功下载：

```bash
docker images | grep gitea/gitea
# 预期输出类似：
# xxx.xuanyuan.run/gitea/gitea   latest    xxxxxxxx    2 weeks ago    450MB
```


## 容器部署

### 数据卷创建

为确保 GITEA 数据持久化（配置文件、仓库数据、数据库等），需创建专用数据卷（Docker Volume）存储数据：

```bash
# 创建数据存储卷（存放仓库数据、用户上传等）
docker volume create gitea-data

# 创建配置存储卷（存放配置文件）
docker volume create gitea-config
```

> 数据卷由 Docker 管理，默认存储路径为 `/var/lib/docker/volumes/`，相比主机目录挂载具有更好的权限管理和移植性。

### 容器运行命令

使用以下命令启动 GITEA 容器，包含基础配置、端口映射、数据卷挂载及自启动设置：

```bash
docker run -d \
  --name gitea \
  --restart always \
  --publish 3000:3000 \  # HTTP 服务端口（Web 界面）
  --publish 2222:22 \    # SSH 服务端口（代码仓库 SSH 访问）
  --volume gitea-data:/data \       # 数据卷挂载（核心数据）
  --volume gitea-config:/etc/gitea \ # 配置卷挂载（配置文件）
  --env USER_UID=1000 \             # 运行用户 UID（与主机用户保持一致可避免权限问题）
  --env USER_GID=1000 \             # 运行用户 GID
  xxx.xuanyuan.run/gitea/gitea:latest
```

#### 参数说明：
- `--name gitea`：指定容器名称为 `gitea`，便于后续管理
- `--restart always`：设置容器开机自启，异常退出后自动重启
- `--publish 3000:3000`：将主机 3000 端口映射到容器 3000 端口（GITEA Web 界面默认端口）
- `--publish 2222:22`：将主机 2222 端口映射到容器 22 端口（GITEA SSH 服务默认端口，避免与主机 SSH 22 端口冲突）
- `--volume`：挂载数据卷，确保容器重启或重建后数据不丢失
- `--env USER_UID/GID=1000`：设置容器内运行用户的 UID/GID，建议与主机当前用户保持一致（可通过 `id` 命令查看主机用户 UID/GID）

### 容器状态检查

容器启动后，通过以下命令确认运行状态：

```bash
# 查看容器运行状态
docker ps | grep gitea
# 预期输出类似（STATUS 为 Up 表示运行正常）：
# abc12345  xxx.xuanyuan.run/gitea/gitea:latest  "/usr/bin/entrypoint…"  5 minutes ago  Up 5 minutes  0.0.0.0:3000->3000/tcp, 0.0.0.0:2222->22/tcp  gitea

# 查看容器日志（验证启动过程是否有错误）
docker logs -f gitea
# 正常启动会输出类似 "Listen: http://0.0.0.0:3000" 的日志
```


## 功能测试

### Web 界面访问验证

1. **初始配置**  
   容器启动后，通过浏览器访问 `http://<服务器IP>:3000` 进入 GITEA 初始配置页面，关键配置项说明：
   - **数据库设置**：默认使用 SQLite3（文件数据库，适合单机部署），也可选择 MySQL/PostgreSQL（需提前准备数据库服务）  
   - **应用基本设置**：
     - 站点名称：自定义（如"我的代码仓库"）
     - 服务器域名：填写实际访问域名或服务器 IP
     - SSH 端口：填写主机映射的 SSH 端口（即 2222，而非容器内的 22）
     - HTTP 端口：保持 3000（容器内端口）
   - **管理员账户设置**：创建初始管理员账号（用户名、密码、邮箱）

2. **界面验证**  
   完成配置后点击"安装 Gitea"，等待约 10-30 秒，自动跳转至登录页面。使用管理员账户登录，确认以下功能正常：
   - 仪表盘显示（统计信息、最近活动）
   - 导航菜单（仓库、组织、用户、设置等）
   - 响应式布局（PC 端/移动端适配）

### 仓库功能测试

1. **创建测试仓库**  
   登录后点击右上角"+"图标 → "新建仓库"，填写仓库名称（如 `test-repo`），选择"初始化仓库"并勾选"添加 README 文件"，点击"创建仓库"。

2. **HTTP 克隆测试**  
   在本地终端执行以下命令克隆仓库（替换 `<服务器IP>` 为实际 IP）：
   ```bash
   git clone http://<服务器IP>:3000/<用户名>/test-repo.git
   ```
   克隆成功后，修改 README.md 并推送提交：
   ```bash
   cd test-repo
   echo "测试内容" >> README.md
   git add README.md
   git commit -m "first commit"
   git push origin main
   ```
   返回 Web 界面刷新，确认提交已成功显示。

3. **SSH 克隆测试**  
   首先在 GITEA 个人设置 → "SSH/GPG 密钥"中添加本地 SSH 公钥（`~/.ssh/id_rsa.pub` 内容）。  
   然后执行以下命令克隆仓库（注意 SSH 端口为 2222）：
   ```bash
   git clone ssh://git@<服务器IP>:2222/<用户名>/test-repo.git
   ```
   若无需输入密码即可克隆，说明 SSH 访问配置正常。


## 生产环境建议

### 数据库优化

默认 SQLite3 适合小规模使用，生产环境建议使用外部数据库以提升性能和可靠性：

1. **推荐配置**：MySQL 8.0+ 或 PostgreSQL 14+
2. **创建数据库**（以 MySQL 为例）：
   ```sql
   CREATE DATABASE gitea CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'gitea'@'%' IDENTIFIED BY 'StrongPassword123!';
   GRANT ALL PRIVILEGES ON gitea.* TO 'gitea'@'%';
   FLUSH PRIVILEGES;
   ```
3. **容器启动时添加数据库环境变量**：
   ```bash
   --env DB_TYPE=mysql \
   --env DB_HOST=<mysql-ip>:3306 \
   --env DB_NAME=gitea \
   --env DB_USER=gitea \
   --env DB_PASSWD=StrongPassword123! \
   ```

### HTTPS 配置

生产环境必须启用 HTTPS 以保障数据传输安全，推荐通过 Nginx 反向代理实现：

1. **Nginx 配置示例**：
   ```nginx
   server {
       listen 80;
       server_name git.example.com;
       return 301 https://$host$request_uri;  # HTTP 重定向到 HTTPS
   }

   server {
       listen 443 ssl;
       server_name git.example.com;

       ssl_certificate /etc/letsencrypt/live/git.example.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/git.example.com/privkey.pem;
       # 其他 SSL 安全配置（如协议、密码套件等）

       location / {
           proxy_pass http://127.0.0.1:3000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```
2. **GITEA 配置调整**：  
   在 GITEA 管理界面 → "设置" → "服务器设置"中，将"SSH 服务器域名"和"HTTP 服务器域名"改为实际域名（如 `git.example.com`），并将"ROOT_URL"设置为 `https://git.example.com/`。

### 数据备份策略

定期备份 GITEA 数据卷以防止数据丢失：

```bash
# 创建备份脚本 backup-gitea.sh
#!/bin/bash
BACKUP_DIR="/var/backups/gitea"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p $BACKUP_DIR

# 备份数据卷
docker run --rm -v gitea-data:/source -v $BACKUP_DIR:/backup alpine \
  tar -czf /backup/gitea-data-$TIMESTAMP.tar.gz -C /source .

docker run --rm -v gitea-config:/source -v $BACKUP_DIR:/backup alpine \
  tar -czf /backup/gitea-config-$TIMESTAMP.tar.gz -C /source .

# 保留最近30天备份
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
```

添加可执行权限并通过 crontab 设置每日自动备份：
```bash
chmod +x /path/to/backup-gitea.sh
crontab -e
# 添加：0 2 * * * /path/to/backup-gitea.sh  # 每天凌晨2点执行备份
```

### 资源限制与监控

1. **资源限制**：启动容器时添加以下参数限制资源占用：
   ```bash
   --memory=2g \          # 限制最大内存为 2GB
   --memory-swap=2g \     # 限制内存+交换分区总和为 2GB（禁止使用交换分区）
   --cpus=1 \             # 限制 CPU 核心数为 1
   ```

2. **容器监控**：  
   - 基础监控：通过 `docker stats gitea` 实时查看资源占用  
   - 高级监控：集成 Prometheus + Grafana，启用 GITEA 的 Prometheus 指标（在配置文件 `app.ini` 中设置 `[metrics] ENABLED = true`）


## 故障排查

### 常见问题及解决方法

#### 1. 容器启动后 Web 界面无法访问
- **检查端口映射**：`docker port gitea` 确认 3000 端口是否正确映射到主机
- **检查防火墙**：`ufw status`（Ubuntu）或 `firewall-cmd --list-ports`（CentOS）确认 3000 端口已开放
- **查看应用日志**：`docker logs gitea | grep -i error` 查找错误信息（如端口被占用、配置文件错误）

#### 2. 数据卷权限问题
- 现象：容器日志出现 "permission denied" 错误，或数据无法持久化
- 解决：确保数据卷挂载目录权限正确，可通过以下命令修复：
  ```bash
  # 查看数据卷实际路径
  docker volume inspect gitea-data | grep Mountpoint
  # 修复权限（假设路径为 /var/lib/docker/volumes/gitea-data/_data）
  sudo chown -R 1000:1000 /var/lib/docker/volumes/gitea-data/_data
  sudo chown -R 1000:1000 /var/lib/docker/volumes/gitea-config/_data
  ```

#### 3. SSH 克隆失败
- **检查 SSH 端口映射**：确认容器 22 端口映射到主机的 2222 端口（或其他非 22 端口）
- **验证 SSH 密钥配置**：检查公钥是否正确添加到 GITEA 用户设置中，格式是否完整（以 `ssh-rsa` 或 `ssh-ed25519` 开头）
- **测试 SSH 连接**：`ssh -p 2222 git@<服务器IP>`，若提示 "Hi there, You've successfully authenticated..." 说明连接正常

### 日志查看与分析

GITEA 容器日志包含详细运行信息，关键日志位置：
- 容器标准输出日志：`docker logs -f gitea`（主要应用日志）
- 数据卷内日志：`docker exec -it gitea cat /data/log/gitea/gitea.log`（详细访问日志、错误日志）

可通过以下命令筛选错误日志：
```bash
docker logs gitea | grep -iE "error|fatal|panic"
```


## 参考资源

- **GITEA 官方文档**：[https://docs.gitea.com/](https://docs.gitea.com/)（项目官方指南，包含详细功能说明和配置选项）
- **轩辕镜像文档**：[GITEA 镜像文档（轩辕）](https://xuanyuan.cloud/r/gitea/gitea)（镜像相关说明及加速配置）
- **镜像标签列表**：[GITEA 镜像标签列表](https://xuanyuan.cloud/r/gitea/gitea/tags)（所有可用版本标签）
- **Docker 官方文档**：[Docker 容器运行参考](https://docs.docker.com/engine/reference/run/)（容器运行参数详细说明）
- **GITEA 配置指南**：[配置 cheat sheet](https://docs.gitea.com/administration/config-cheat-sheet)（`app.ini` 配置项详解）


## 总结

本文详细介绍了 GITEA 的 Docker 容器化部署方案，从环境准备、镜像拉取、容器配置到功能测试，提供了完整的操作流程。通过轩辕镜像访问支持服务可显著提升国内环境下的镜像下载访问表现，而容器化部署则简化了 GITEA 的安装与维护流程，同时保证了环境一致性和数据安全性。

**关键要点**：
- 使用轩辕一键脚本可快速配置 Docker 环境并启用镜像访问支持，无需手动处理复杂依赖
- GITEA 拉取命令格式为 `docker pull xxx.xuanyuan.run/gitea/gitea:{TAG}`
- 必须通过数据卷（Volume）持久化存储 GITEA 数据，避免容器重建导致数据丢失
- 生产环境需重点关注数据库优化、HTTPS 配置、定期备份及资源监控，确保服务稳定运行

**后续建议**：
- 深入学习 GITEA 高级特性，如 LDAP 认证集成、CI/CD 功能、WebHook 配置等，提升团队协作效率
- 根据实际用户规模和访问量调整容器资源配置，必要时通过 Docker Compose 或 Kubernetes 实现多实例部署
- 定期关注 GITEA 官方更新和安全公告，通过 `docker pull` 拉取新版本镜像并重启容器完成升级
- 结合业务需求定制备份策略，建议采用异地备份或云存储备份以应对极端故障场景

**参考链接**：
- [GITEA 官方网站](https://gitea.io/)
- [GITEA 镜像文档（轩辕）](https://xuanyuan.cloud/r/gitea/gitea)
- [GITEA Docker 部署官方指南](https://docs.gitea.com/installation/install-with-docker)
- [Docker 数据卷管理文档](https://docs.docker.com/storage/volumes/)

