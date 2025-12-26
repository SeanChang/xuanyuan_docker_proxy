# SIYUAN（思源笔记）Docker 容器化部署指南

![SIYUAN（思源笔记）Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-siyuan.png)

*分类: Docker,SIYUAN | 标签: siyuan,docker,部署教程 | 发布时间: 2025-12-03 06:17:39*

> SIYUAN（思源笔记）是一款面向个人的本地知识库应用，专注于提供高效的知识管理与笔记创作体验。其核心功能包括Markdown实时编辑、双向链接、块级引用、本地数据存储等，广泛适用于学术研究、技术文档编写、个人知识整理等场景。通过Docker容器化部署SIYUAN，可实现环境一致性、快速部署与隔离、跨平台运行等优势，简化运维流程并提升系统可靠性。

## 概述

SIYUAN（思源笔记）是一款面向个人的本地知识库应用，专注于提供高效的知识管理与笔记创作体验。其核心功能包括Markdown实时编辑、双向链接、块级引用、本地数据存储等，广泛适用于学术研究、技术文档编写、个人知识整理等场景。通过Docker容器化部署SIYUAN，可实现环境一致性、快速部署与隔离、跨平台运行等优势，简化运维流程并提升系统可靠性。

本文档基于轩辕镜像访问支持服务，提供SIYUAN的完整Docker部署方案，包括环境准备、镜像拉取、容器配置、功能验证及生产环境优化建议，旨在帮助用户快速搭建稳定的SIYUAN服务。


## 环境准备

### Docker环境安装

SIYUAN基于Docker容器运行，需先在目标服务器安装Docker环境。推荐使用轩辕提供的一键安装脚本，自动完成Docker及相关组件（Docker Engine、Docker Compose）的安装与配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 脚本支持主流Linux发行版（Ubuntu、CentOS、Debian等），执行过程需root权限，建议在全新系统中运行以避免环境冲突。


## 镜像准备

### 镜像信息说明

该镜像包含SIYUAN应用程序及运行所需的基础依赖，支持多平台架构（如amd64、arm64），用户可根据服务器硬件选择适配版本。可通过[SIYUAN镜像标签列表](https://xuanyuan.cloud/r/b3log/siyuan/tags)查看所有可用版本。

### 镜像拉取命令

```bash
# 拉取最新稳定版（推荐）
docker pull xxx.xuanyuan.run/b3log/siyuan:latest
```

> 如需指定版本，将`latest`替换为具体标签（如`v2.11.0`），标签列表可通过[轩辕镜像 - SIYUAN标签页面](https://xuanyuan.cloud/r/b3log/siyuan/tags)查询。拉取完成后，可通过`docker images | grep siyuan`验证镜像是否成功下载。


## 容器部署

### 部署前准备

1. **数据目录创建**：SIYUAN的笔记数据默认存储在容器内的`/app/data`目录，为避免容器重启或删除导致数据丢失，需在宿主机创建持久化目录并挂载至容器：

```bash
# 创建数据目录（可自定义路径，此处以~/siyuan-data为例）
mkdir -p ~/siyuan-data
# 设置目录权限（确保容器内进程可读写）
chmod -R 777 ~/siyuan-data
```

2. **端口确认**：根据[轩辕镜像 - SIYUAN文档](https://xuanyuan.cloud/r/b3log/siyuan)，SIYUAN默认通过`8080`端口提供Web服务。部署前需确保该端口未被占用，可通过`netstat -tuln | grep 8080`检查，若已占用，需更换宿主机端口（如映射至`8081`）。


### 启动容器命令

使用`docker run`命令启动SIYUAN容器，配置端口映射、数据挂载、重启策略等关键参数：

```bash
docker run -d \
  --name siyuan \
  --restart unless-stopped \
  -p 8080:8080 \
  -v ~/siyuan-data:/app/data \
  -e TZ=Asia/Shanghai \
  xxx.xuanyuan.run/b3log/siyuan:latest
```

#### 参数说明：
- `-d`：后台运行容器；
- `--name siyuan`：指定容器名称为`siyuan`，便于管理；
- `--restart unless-stopped`：容器退出时自动重启（除非手动停止）；
- `-p 8080:8080`：端口映射，格式为`宿主机端口:容器端口`，如需更换宿主机端口，修改左侧数值（如`8081:8080`）；
- `-v ~/siyuan-data:/app/data`：数据卷挂载，将宿主机`~/siyuan-data`目录映射至容器`/app/data`，实现数据持久化；
- `-e TZ=Asia/Shanghai`：设置时区为上海，确保日志时间与本地一致；
- `xxx.xuanyuan.run/b3log/siyuan:latest`：使用的镜像名称及标签。


### 部署验证

容器启动后，通过以下命令检查运行状态：

```bash
# 查看容器状态（健康状态应为Up）
docker ps | grep siyuan

# 查看容器日志（确认启动过程无错误）
docker logs -f siyuan
```

若日志显示“server started at http://0.0.0.0:8080”，表示SIYUAN服务已成功启动。


## 功能测试

### 访问Web界面

在浏览器中输入`http://<服务器IP>:8080`（替换`<服务器IP>`为实际服务器地址，端口为部署时映射的宿主机端口），首次访问将进入SIYUAN初始化页面，设置管理员账号密码后即可登录使用。


### 核心功能验证

1. **笔记创建**：点击“新建笔记”，输入标题与内容（支持Markdown格式，如`# 标题`、`- 列表`等），点击保存。
   
2. **数据持久化测试**：
   - 在宿主机查看数据目录：`ls ~/siyuan-data`，应生成笔记相关文件（如`notes/`、`config.json`）；
   - 重启容器：`docker restart siyuan`，再次访问Web界面，确认新建笔记未丢失。

3. **双向链接测试**：在笔记中输入`[[`触发链接提示，选择已有笔记创建双向引用，导航至目标笔记后验证反向链接是否生成。

4. **导入导出测试**：通过“设置 > 导入”上传Markdown文件，验证导入功能；通过“导出”将笔记保存为HTML或PDF，验证导出功能。


## 生产环境建议

### 数据备份策略

SIYUAN数据安全至关重要，建议配置定时备份机制：

```bash
# 创建备份脚本（示例：每日凌晨2点备份数据目录至~/siyuan-backup）
cat > ~/backup-siyuan.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/siyuan-backup
SOURCE_DIR=~/siyuan-data
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
tar -zcvf $BACKUP_DIR/siyuan_backup_$TIMESTAMP.tar.gz -C $(dirname $SOURCE_DIR) $(basename $SOURCE_DIR)
# 保留最近30天备份
find $BACKUP_DIR -name "siyuan_backup_*.tar.gz" -mtime +30 -delete
EOF

# 添加执行权限
chmod +x ~/backup-siyuan.sh

# 配置crontab定时任务
crontab -e
# 添加以下行（每日2点执行备份）
0 2 * * * ~/backup-siyuan.sh
```


### 安全加固

1. **非root用户运行**：默认容器内进程以root用户运行，存在安全风险，可通过`--user`参数指定低权限用户（需提前在容器内创建用户，或映射宿主机用户ID）：

```bash
# 示例：使用宿主机用户ID 1000运行容器（需确保~/siyuan-data属主为1000）
docker run -d \
  --name siyuan \
  --user 1000:1000 \
  --restart unless-stopped \
  -p 8080:8080 \
  -v ~/siyuan-data:/app/data \
  xxx.xuanyuan.run/b3log/siyuan:latest
```

2. **防火墙配置**：仅开放必要端口，以UFW为例：

```bash
# 允许8080端口（替换为实际映射端口）
ufw allow 8080/tcp
# 启用防火墙
ufw enable
```

3. **HTTPS加密**：通过Nginx反向代理配置HTTPS（使用Let's Encrypt证书），避免明文传输：

```nginx
# Nginx配置示例（/etc/nginx/sites-available/siyuan）server {
    listen 443 ssl;
    server_name note.yourdomain.com;  # 替换为实际域名

    ssl_certificate /etc/letsencrypt/live/note.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/note.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```


### 资源限制

为避免SIYUAN过度占用服务器资源，可通过`--memory`和`--cpus`参数限制容器资源使用：

```bash
docker run -d \
  --name siyuan \
  --restart unless-stopped \
  --memory 2g \          # 限制最大内存为2GB
  --cpus 1 \             # 限制CPU核心为1核
  -p 8080:8080 \
  -v ~/siyuan-data:/app/data \
  xxx.xuanyuan.run/b3log/siyuan:latest
```


### 监控与日志

1. **容器监控**：使用`docker stats siyuan`实时查看容器CPU、内存、网络占用；或部署Prometheus+Grafana监控系统，通过`cadvisor`收集容器 metrics。

2. **日志管理**：配置Docker日志驱动，将日志输出至文件或集中式日志系统（如ELK）：

```bash
# 修改docker run命令，添加日志配置（限制日志大小与数量）
--log-driver json-file \
--log-opt max-size=10m \
--log-opt max-file=3
```


## 故障排查

### 容器无法启动

1. **查看启动日志**：

```bash
docker logs siyuan  # 直接查看日志
docker logs --tail=100 siyuan  # 查看最后100行日志
```

常见错误及解决：
- **端口冲突**：日志含“address already in use”，需更换宿主机端口（如`-p 8081:8080`）；
- **权限不足**：日志含“permission denied”，检查宿主机数据目录权限（如`chmod -R 777 ~/siyuan-data`）；
- **镜像损坏**：删除镜像重新拉取（`docker rmi xxx.xuanyuan.run/b3log/siyuan:latest && docker pull ...`）。


### 数据卷挂载异常

若宿主机目录未正确挂载，导致数据未持久化：

```bash
# 检查容器挂载配置
docker inspect -f '{{ .Mounts }}' siyuan
```

确认`Source`（宿主机目录）与`Destination`（容器目录）是否正确，若挂载错误，需删除容器重新创建（`docker rm -f siyuan`后重新执行`docker run`命令）。


### 访问访问表现缓慢

1. **网络问题**：检查服务器带宽占用（`iftop`），排除网络拥塞；
2. **资源不足**：通过`docker stats siyuan`查看CPU/内存使用率，若接近限制，调整资源限制参数；
3. **客户端缓存**：清除浏览器缓存或使用隐私模式访问，排除前端缓存问题。


### 镜像拉取失败

若执行`docker pull`时提示“no such host”或“connection timed out”：

1. 检查网络连通性：`ping xxx.xuanyuan.run`；
2. 验证Docker加速配置：`cat /etc/docker/daemon.json`，确认包含`"registry-mirrors": ["https://xxx.xuanyuan.run"]`；
3. 重启Docker服务：`systemctl restart docker`。


## 参考资源

- [轩辕镜像 - SIYUAN文档](https://xuanyuan.cloud/r/b3log/siyuan)
- [SIYUAN镜像标签列表](https://xuanyuan.cloud/r/b3log/siyuan/tags)
- Docker官方文档：[Docker Run Reference](https://docs.docker.com/engine/reference/commandline/run/)
- SIYUAN项目官方仓库（推断）：[GitHub - siyuan-note/siyuan](https://github.com/siyuan-note/siyuan)（注：非轩辕镜像文档，为项目官方代码仓库）


## 总结

本文详细介绍了SIYUAN的Docker容器化部署方案，从环境准备、镜像拉取、容器配置到功能验证，提供了完整的操作指南。通过轩辕镜像访问支持服务，用户可快速获取SIYUAN镜像，结合容器化特性实现高效、可靠的部署与运维。


**关键要点**：
- 使用轩辕一键脚本可快速部署Docker环境并配置镜像访问支持，简化前期准备工作；
- 镜像拉取命令为`docker pull xxx.xuanyuan.run/b3log/siyuan:latest`；
- 数据持久化是核心，需通过`-v`参数挂载宿主机目录，避免容器删除导致数据丢失；
- 生产环境需重点关注数据备份、安全加固（非root运行、HTTPS）、资源限制与监控，提升系统稳定性。


**后续建议**：
- 深入学习SIYUAN高级特性，如插件开发、API集成，扩展应用功能；
- 根据业务需求调整容器配置，如增加环境变量自定义应用参数（参考[轩辕镜像 - SIYUAN文档](https://xuanyuan.cloud/r/b3log/siyuan)）；
- 定期关注[SIYUAN镜像标签列表](https://xuanyuan.cloud/r/b3log/siyuan/tags)，及时更新镜像至稳定版本，获取新功能与安全修复；
- 对于多用户场景，可结合Nginx配置访问控制或部署SIYUAN团队版（如有）。


**参考链接**：
- [轩辕镜像 - SIYUAN文档](https://xuanyuan.cloud/r/b3log/siyuan)
- [SIYUAN镜像标签列表](https://xuanyuan.cloud/r/b3log/siyuan/tags)
- Docker官方文档：[https://docs.docker.com](https://docs.docker.com)

