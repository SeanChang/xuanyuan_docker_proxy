# SiYuan 思源笔记 Docker 部署终极指南：Windows+Linux 双平台

![SiYuan 思源笔记 Docker 部署终极指南：Windows+Linux 双平台](https://img.xuanyuan.dev/docker/blog/docker-siyuan.png)

*分类: siyuan,docker,部署教程 | 标签: siyuan,docker,部署教程 | 发布时间: 2025-12-03 06:17:39*

> SiYuan（思源笔记）是一款面向个人的本地知识库应用，专注于提供高效的知识管理与笔记创作体验。其核心功能包括Markdown实时编辑、双向链接、块级引用、本地数据存储等，广泛适用于学术研究、技术文档编写、个人知识整理等场景。通过 Docker 容器化部署 SiYuan，可实现环境一致性、快速部署与隔离、跨平台运行等优势，简化运维流程并提升系统可靠性。

## 摘要
还在为思源笔记Docker部署踩坑？本文提供Windows PowerShell和Linux双平台完整部署方案，手把手教你解决挂载路径错误、端口映射、授权码设置等99%的常见问题，5分钟搞定私有知识库！基于轩辕镜像加速服务，拉取速度提升10倍，附生产级优化建议和故障排查手册。

## 概述

SiYuan（思源笔记）是一款以"本地优先"为核心的个人知识管理工具，支持Markdown实时编辑、双向链接、块级引用和全平台同步，是学术研究、技术文档编写和个人知识整理的首选工具。通过Docker容器化部署，你可以获得环境一致性、快速迁移和隔离运行的优势，轻松搭建属于自己的私有知识库。

本文基于轩辕镜像加速服务，提供Windows PowerShell和Linux双平台的完整部署方案，包含所有常见问题的解决方案，让你一次部署成功，不再踩坑。

## 环境准备

### Linux系统Docker环境安装

推荐使用轩辕提供的一键安装脚本，自动完成Docker及相关组件的安装与国内镜像配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 脚本支持13种主流Linux发行版（Ubuntu、CentOS、Debian、openEuler等），执行过程需要root权限。

### Windows系统Docker环境安装

Windows用户请先安装Docker Desktop：
1. 访问[Docker官网](https://www.docker.com/products/docker-desktop/)下载安装包
2. 安装时勾选"Use WSL 2 instead of Hyper-V"（推荐）
3. 安装完成后启动Docker Desktop，等待状态栏显示"Running"
4. 打开PowerShell，输入`docker --version`验证安装成功

## 镜像准备

### 镜像信息说明

轩辕镜像提供的`b3log/siyuan`镜像包含思源笔记最新稳定版及所有运行依赖，支持amd64、arm64和arm架构，可在服务器、树莓派等设备上运行。

### 镜像拉取命令

**Windows PowerShell和Linux通用**：
```bash
docker pull docker.xuanyuan.run/b3log/siyuan:latest
```

> 如需指定版本，将`latest`替换为具体标签（如`v3.6.5`），完整标签列表可查看[轩辕镜像 - 思源笔记标签页](https://xuanyuan.cloud/zh/r/b3log/siyuan)。

## 容器部署

### Linux系统部署

#### 部署前准备

1. **创建数据目录**：
```bash
# 创建数据目录（建议使用绝对路径）
mkdir -p /opt/siyuan/workspace
# 设置正确的权限（容器内使用UID 1000运行）
chown -R 1000:1000 /opt/siyuan/workspace
```

2. **端口确认**：思源笔记默认使用`6806`端口，部署前确保该端口未被占用：
```bash
netstat -tuln | grep 6806
```

#### 启动容器命令

```bash
docker run -d \
  --name siyuan \
  --restart unless-stopped \
  -p 8080:6806 \
  -v /opt/siyuan/workspace:/siyuan/workspace \
  -e TZ=Asia/Shanghai \
  -e SIYUAN_ACCESS_AUTH_CODE=你的授权码（自定义） \
  docker.xuanyuan.run/b3log/siyuan:latest
```

#### 关键参数说明
- `-p 8080:6806`：将宿主机的8080端口映射到容器的6806端口（**注意：容器内部端口固定为6806**）
- `-v /opt/siyuan/workspace:/siyuan/workspace`：数据卷挂载（**必须挂载到/siyuan/workspace，不是/app/data**）
- `-e SIYUAN_ACCESS_AUTH_CODE=你的授权码`：设置访问授权码（**Docker部署强制要求，否则无法启动**）
- `--restart unless-stopped`：容器退出时自动重启

### Windows系统部署

#### 部署前准备

1. **手动创建数据目录**：
```powershell
# 必须使用绝对路径，不要使用~符号（Docker在Windows下解析~不可靠）
mkdir C:\Users\你的用户名\siyuan-workspace
```

> ❌ 错误示例：`-v ~/siyuan-data:/siyuan/workspace`
> ✅ 正确示例：`-v C:\Users\ZhangSan\siyuan-workspace:/siyuan/workspace`

2. **端口确认**：
```powershell
netstat -ano | findstr 6806
```

#### 启动容器命令

```powershell
docker run -d `
  --name siyuan `
  --restart unless-stopped `
  -p 8080:6806 `
  -v C:\Users\你的用户名\siyuan-workspace:/siyuan/workspace `
  -e TZ=Asia/Shanghai `
  -e SIYUAN_ACCESS_AUTH_CODE=你的授权码（自定义） `
  docker.xuanyuan.run/b3log/siyuan:latest
```

> 注意：PowerShell中换行符是`` ` ``（反引号），不是Linux的`\`

### 部署验证

**Windows和Linux通用**：
```bash
# 查看容器状态（STATUS应为Up）
docker ps | grep siyuan

# 查看容器日志（确认启动成功）
docker logs -f siyuan
```

看到以下日志表示启动成功：
```
I 2026/04/26 16:23:24 working.go:216: kernel booted
I 2026/04/26 16:23:24 serve.go:231: kernel [pid=1] http server [0.0.0.0:6806] is booting
```

## 访问与初始化

![思源笔记授权码页面](https://img.xuanyuan.dev/docker/blog/docker-siyuan-1.png)

1. 打开浏览器，访问：`http://你的服务器IP:8080`（Windows本地访问：`http://localhost:8080`）
2. 输入你设置的**访问授权码**（这是第一层防护，不是登录密码）
3. 首次进入后，在"设置 > 账号"中设置管理员账号和密码
4. 开始使用思源笔记！

![思源笔记首页](https://img.xuanyuan.dev/docker/blog/docker-siyuan-2.png)

## 常见问题排查（99%的坑都在这里）

### 问题1：容器无限重启，日志显示`chown: /siyuan/workspace: No such file or directory`

**原因**：挂载路径错误或宿主机目录不存在
**解决方案**：
1. 删除错误的容器：`docker rm -f siyuan`
2. 手动创建宿主机目录（必须使用绝对路径）
3. 重新运行启动命令，确保挂载路径是`/siyuan/workspace`（不是/app/data）

### 问题2：容器启动后立即退出，日志提示必须设置访问授权码

**原因**：Docker部署强制要求设置访问授权码（安全机制）
**解决方案**：
1. 删除错误的容器：`docker rm -f siyuan`
2. 在启动命令中添加`-e SIYUAN_ACCESS_AUTH_CODE=你的授权码`参数
3. 授权码可以是任意字符串，建议设置复杂一点

### 问题3：容器正常运行但浏览器无法访问，显示`ERR_CONNECTION_REFUSED`

**原因**：端口映射错误
**解决方案**：
1. 检查端口映射参数：`-p 宿主机端口:6806`
2. 确保你访问的是**宿主机端口**，不是容器的6806端口
3. 例如：如果映射是`-p 8080:6806`，就访问`http://localhost:8080`，不是6806

### 问题4：Windows下数据目录权限问题

**原因**：Windows和Linux文件权限系统差异
**解决方案**：
1. 确保Docker Desktop有访问你数据目录的权限
2. 在Docker Desktop设置中，进入"Resources > File Sharing"，添加你的数据目录所在的驱动器
3. 重启Docker Desktop后重新运行容器

## 生产环境优化建议

### 通用优化

1. **数据备份**：
```bash
# Linux每日备份脚本示例
cat > /usr/local/bin/backup-siyuan.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=/opt/siyuan/backup
SOURCE_DIR=/opt/siyuan/workspace
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
tar -zcvf $BACKUP_DIR/siyuan_backup_$TIMESTAMP.tar.gz -C $(dirname $SOURCE_DIR) $(basename $SOURCE_DIR)
# 保留最近30天备份
find $BACKUP_DIR -name "siyuan_backup_*.tar.gz" -mtime +30 -delete
EOF

chmod +x /usr/local/bin/backup-siyuan.sh
echo "0 2 * * * /usr/local/bin/backup-siyuan.sh" | crontab -
```

2. **资源限制**：
```bash
# 限制内存2GB，CPU 1核
docker run -d \
  --name siyuan \
  --restart unless-stopped \
  --memory 2g \
  --cpus 1 \
  -p 8080:6806 \
  -v /opt/siyuan/workspace:/siyuan/workspace \
  -e TZ=Asia/Shanghai \
  -e SIYUAN_ACCESS_AUTH_CODE=你的授权码（自定义） \
  docker.xuanyuan.run/b3log/siyuan:latest
```

3. **HTTPS加密**：
使用Nginx反向代理配置HTTPS，示例配置：
```nginx
server {
    listen 443 ssl;
    server_name note.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/note.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/note.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        # 必须配置WebSocket支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### Windows特定优化

1. **Docker Desktop资源限制**：
   - 打开Docker Desktop设置 > Resources
   - 将内存限制设置为至少2GB
   - 将CPU限制设置为至少2核
   - 点击"Apply & Restart"

2. **自动启动**：
   - Docker Desktop默认会随系统启动
   - 容器设置了`--restart unless-stopped`，会在Docker启动后自动运行

## 总结

### 核心要点回顾

✅ **正确的端口映射**：`-p 宿主机端口:6806`（容器内部固定6806）
✅ **正确的挂载路径**：`-v 宿主机绝对路径:/siyuan/workspace`（不是/app/data）
✅ **必须设置授权码**：`-e SIYUAN_ACCESS_AUTH_CODE=你的授权码（自定义）`
✅ **Windows使用绝对路径**：不要用~符号，用完整路径如`C:\Users\ZhangSan\siyuan-workspace`

### 一句话部署命令

**Linux**：
```bash
mkdir -p /opt/siyuan/workspace && chown -R 1000:1000 /opt/siyuan/workspace && docker run -d --name siyuan --restart unless-stopped -p 8080:6806 -v /opt/siyuan/workspace:/siyuan/workspace -e TZ=Asia/Shanghai -e SIYUAN_ACCESS_AUTH_CODE=123456 docker.xuanyuan.run/b3log/siyuan:latest
```

**Windows PowerShell**：
```powershell
mkdir C:\Users\你的用户名\siyuan-workspace; docker run -d --name siyuan --restart unless-stopped -p 8080:6806 -v C:\Users\你的用户名\siyuan-workspace:/siyuan/workspace -e TZ=Asia/Shanghai -e SIYUAN_ACCESS_AUTH_CODE=123456 docker.xuanyuan.run/b3log/siyuan:latest
```

## 参考资源

- [轩辕镜像 - 思源笔记中文文档](https://xuanyuan.cloud/zh/r/b3log/siyuan)
- [思源笔记官方GitHub仓库](https://github.com/siyuan-note/siyuan)
- [Docker官方文档](https://docs.docker.com)

