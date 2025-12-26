---
id: 143
title: DrawIO Docker 容器化部署指南
slug: drawio-docker
summary: DRAWIO（jgraph/drawio）是一款功能强大的容器化图表绘制应用，基于Tomcat 9-jre11构建，提供直观的图形界面用于创建流程图、网络拓扑图、UML图、ER图等多种类型的图表。作为diagrams.net（原draw.io）的容器化版本，DRAWIO支持本地部署，确保数据隐私和安全控制，同时提供与主流云存储服务的集成能力。
category: Docker,DrawIO
tags: drawio,docker,部署教程
image_name: jgraph/drawio
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-drawio.png"
status: published
created_at: "2025-12-13 06:52:54"
updated_at: "2025-12-13 06:52:54"
---

# DrawIO Docker 容器化部署指南

> DRAWIO（jgraph/drawio）是一款功能强大的容器化图表绘制应用，基于Tomcat 9-jre11构建，提供直观的图形界面用于创建流程图、网络拓扑图、UML图、ER图等多种类型的图表。作为diagrams.net（原draw.io）的容器化版本，DRAWIO支持本地部署，确保数据隐私和安全控制，同时提供与主流云存储服务的集成能力。

## 概述

DRAWIO（jgraph/drawio）是一款功能强大的容器化图表绘制应用，基于Tomcat 9-jre11构建，提供直观的图形界面用于创建流程图、网络拓扑图、UML图、ER图等多种类型的图表。作为diagrams.net（原draw.io）的容器化版本，DRAWIO支持本地部署，确保数据隐私和安全控制，同时提供与主流云存储服务的集成能力。

容器化部署DRAWIO带来多项优势：简化的安装流程、一致的运行环境、灵活的扩展性以及便捷的版本管理。本文档将详细介绍如何通过Docker快速部署DRAWIO，并提供生产环境下的最佳实践建议。

## 环境准备

### Docker环境安装

在开始部署前，需要确保服务器已安装Docker环境。推荐使用以下一键安装脚本，该脚本会自动配置Docker及相关依赖：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 注意：执行上述脚本需要root权限。安装完成后，建议将当前用户添加到docker用户组以避免每次执行docker命令都需要sudo权限：
> 
> ```bash
> sudo usermod -aG docker $USER
> ```
> 执行完毕后需注销并重新登录使配置生效。

### 系统要求

DRAWIO对系统资源要求适中，建议运行在满足以下条件的服务器上：
- 至少1GB RAM（生产环境建议2GB以上）
- 10GB以上可用磁盘空间
- 2核或更高CPU
- 操作系统：Ubuntu 18.04/20.04/22.04 LTS、CentOS 7/8或其他支持Docker的Linux发行版
- 网络：能够访问互联网以下载Docker镜像，同时开放必要的端口供外部访问

## 镜像准备

### 拉取DRAWIO镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的DRAWIO镜像：

```bash
docker pull xxx.xuanyuan.run/jgraph/drawio:latest
```

### 验证镜像

拉取完成后，可以使用以下命令验证镜像是否成功下载：

```bash
docker images | grep jgraph/drawio
```

若输出类似以下内容，说明镜像拉取成功：

```
xxx.xuanyuan.run/jgraph/drawio   latest    abc12345   2 weeks ago   500MB
```

### 查看镜像信息

可以使用`docker inspect`命令查看镜像的详细信息，包括环境变量、暴露端口等：

```bash
docker inspect xxx.xuanyuan.run/jgraph/drawio:latest
```

## 容器部署

### 基础部署

使用以下命令启动一个基础的DRAWIO容器实例：

```bash
docker run -d \
  --name drawio \
  -p 8080:8080 \
  -p 8443:8443 \
  xxx.xuanyuan.run/jgraph/drawio:latest
```

**参数说明**：
- `-d`: 后台运行容器
- `--name drawio`: 指定容器名称为"drawio"
- `-p 8080:8080`: 将容器的8080端口映射到主机的8080端口（HTTP）
- `-p 8443:8443`: 将容器的8443端口映射到主机的8443端口（HTTPS）

### 自定义配置部署

对于需要自定义配置的场景，可以通过环境变量和数据卷挂载进行个性化设置：

```bash
docker run -d \
  --name drawio \
  -p 80:8080 \
  -p 443:8443 \
  -e LETS_ENCRYPT_ENABLED=false \
  -e PUBLIC_DNS=draw.example.com \
  -e KEYSTORE_PASS=your_secure_password \
  -v /opt/drawio/data:/user/local/tomcat/.keystore \
  -v /opt/drawio/letsencrypt:/etc/letsencrypt \
  xxx.xuanyuan.run/jgraph/drawio:latest
```

**参数说明**：
- `-p 80:8080` 和 `-p 443:8443`: 将容器服务映射到主机的标准HTTP(80)和HTTPS(443)端口
- `-e LETS_ENCRYPT_ENABLED=false`: 禁用Let's Encrypt证书（默认值），使用自签名证书
- `-e PUBLIC_DNS=draw.example.com`: 指定证书的Common Name (CN)记录
- `-e KEYSTORE_PASS=your_secure_password`: 设置密钥库密码
- `-v /opt/drawio/data:/user/local/tomcat/.keystore`: 挂载本地目录存储密钥库文件
- `-v /opt/drawio/letsencrypt:/etc/letsencrypt`: 挂载Let's Encrypt证书目录（当启用Let's Encrypt时）

### 使用Let's Encrypt证书部署

要使用Let's Encrypt提供的可信SSL证书，需满足以下前提条件：
1. 服务器能够访问互联网，且开放80和443端口
2. 拥有指向服务器公网IP的域名（如drawio.example.com）

满足上述条件后，使用以下命令部署：

```bash
# 创建必要的目录
mkdir -p /opt/drawio/data/{letsencrypt-log,letsencrypt-etc,letsencrypt-lib}

# 启动容器
docker run -d \
  --name drawio \
  -p 80:80 \
  -p 443:8443 \
  -e LETS_ENCRYPT_ENABLED=true \
  -e PUBLIC_DNS=drawio.example.com \
  -e ORGANISATION_UNIT="IT Department" \
  -e ORGANISATION="Your Company" \
  -e CITY="Beijing" \
  -e STATE="Beijing" \
  -e COUNTRY_CODE="CN" \
  -e KEYSTORE_PASS=your_secure_password \
  -v /opt/drawio/data/letsencrypt-log:/var/log/letsencrypt/ \
  -v /opt/drawio/data/letsencrypt-etc:/etc/letsencrypt/ \
  -v /opt/drawio/data/letsencrypt-lib:/var/lib/letsencrypt \
  xxx.xuanyuan.run/jgraph/drawio:latest
```

### 配置云存储集成

DRAWIO支持与Google Drive、OneDrive等云存储服务集成，可通过设置相应的环境变量启用这些功能：

```bash
docker run -d \
  --name drawio \
  -p 8080:8080 \
  -p 8443:8443 \
  -e DRAWIO_GOOGLE_DRIVE_ENABLED=true \
  -e DRAWIO_ONEDRIVE_ENABLED=true \
  xxx.xuanyuan.run/jgraph/drawio:latest
```

> 注意：完整的环境变量列表可通过查看容器内的`docker-entrypoint.sh`文件获取，或参考[DRAWIO镜像文档（轩辕）](https://xuanyuan.cloud/r/jgraph/drawio)。

## 功能测试

### 验证容器状态

容器启动后，首先检查容器是否正常运行：

```bash
docker ps | grep drawio
```

若STATUS列显示"Up"状态，说明容器正在运行：

```
abc123456789   xxx.xuanyuan.run/jgraph/drawio:latest   "catalina.sh run"   5 minutes ago   Up 5 minutes   0.0.0.0:8080->8080/tcp, 0.0.0.0:8443->8443/tcp   drawio
```

### 查看容器日志

通过以下命令查看容器运行日志，确认服务是否正常启动：

```bash
docker logs -f drawio
```

正常启动时，日志会显示Tomcat启动过程及最终的成功提示：

```
...
INFO: Server startup in [xxx] milliseconds
```

按`Ctrl+C`可退出日志查看。

### 访问Web界面

使用浏览器访问以下地址之一，验证DRAWIO Web界面是否可用：

- HTTP: `http://服务器IP:8080/?offline=1&https=0`
- HTTPS: `https://服务器IP:8443/?offline=1`

> 注意：URL中的`?offline=1`参数会禁用云存储支持，这是推荐的安全配置。若需要使用云存储功能，可移除该参数。

首次访问时，系统会显示DRAWIO的欢迎界面和新建图表选项，选择一个模板即可开始使用。

### 基本功能测试

1. **创建新图表**：点击"新建"按钮，选择一个图表模板，验证是否可以正常创建
2. **添加元素**：从左侧工具栏拖放元素到画布，验证元素是否可以正常添加和编辑
3. **保存图表**：点击"保存"按钮，验证是否可以正常保存图表（本地存储或云存储，取决于配置）
4. **导出功能**：尝试将图表导出为PNG、PDF等格式，验证导出功能是否正常

### API访问测试（可选）

如果需要通过API与DRAWIO集成，可以使用curl命令测试基本API响应：

```bash
curl -I http://服务器IP:8080
```

正常情况下会返回HTTP 200状态码：

```
HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Content-Type: text/html;charset=UTF-8
Transfer-Encoding: chunked
Date: Wed, 15 Nov 2023 08:00:00 GMT
```

## 生产环境建议

### 资源限制

为确保DRAWIO服务稳定运行且不影响其他系统，建议设置容器资源限制：

```bash
docker run -d \
  --name drawio \
  -p 8080:8080 \
  -p 8443:8443 \
  --memory=2g \
  --memory-swap=4g \
  --cpus=1 \
  xxx.xuanyuan.run/jgraph/drawio:latest
```

**参数说明**：
- `--memory=2g`: 限制容器使用的内存上限为2GB
- `--memory-swap=4g`: 限制容器使用的交换空间上限为4GB
- `--cpus=1`: 限制容器使用的CPU核心数为1核

根据服务器配置和实际使用情况，可以适当调整这些参数。

### 持久化存储

为确保数据持久性，特别是证书和配置文件，建议挂载必要的目录：

```bash
docker run -d \
  --name drawio \
  -p 8080:8080 \
  -p 8443:8443 \
  -v /opt/drawio/keystore:/user/local/tomcat/.keystore \
  -v /opt/drawio/config:/user/local/tomcat/webapps/drawio/WEB-INF/classes \
  xxx.xuanyuan.run/jgraph/drawio:latest
```

### 反向代理配置

在生产环境中，建议在DRAWIO前面部署Nginx等反向代理服务器，以提供更好的性能、安全性和灵活性：

```nginx
server {
    listen 80;
    server_name drawio.example.com;
    
    # 重定向到HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name drawio.example.com;
    
    # SSL配置
    ssl_certificate /etc/letsencrypt/live/drawio.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/drawio.example.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    # 代理配置
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 容器编排

对于企业级部署，建议使用Docker Compose或Kubernetes进行容器编排，以简化管理和扩展：

**Docker Compose示例 (docker-compose.yml)**：

```yaml
version: '3'

services:
  drawio:
    image: xxx.xuanyuan.run/jgraph/drawio:latest
    container_name: drawio
    restart: always
    ports:
      - "8080:8080"
      - "8443:8443"
    environment:
      - LETS_ENCRYPT_ENABLED=false
      - PUBLIC_DNS=draw.example.com
      - KEYSTORE_PASS=your_secure_password
    volumes:
      - /opt/drawio/keystore:/user/local/tomcat/.keystore
    mem_limit: 2g
    cpus: 1
```

使用以下命令启动：

```bash
docker-compose up -d
```

### 定期备份

建议定期备份DRAWIO的配置和数据文件，可使用以下脚本自动化备份过程：

```bash
#!/bin/bash
BACKUP_DIR="/opt/backups/drawio"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="drawio"

# 创建备份目录
mkdir -p $BACKUP_DIR

# 备份配置文件
docker cp $CONTAINER_NAME:/user/local/tomcat/webapps/drawio/WEB-INF/classes $BACKUP_DIR/config_$TIMESTAMP

# 备份密钥库
docker cp $CONTAINER_NAME:/user/local/tomcat/.keystore $BACKUP_DIR/keystore_$TIMESTAMP

# 压缩备份文件
tar -zcvf $BACKUP_DIR/drawio_backup_$TIMESTAMP.tar.gz $BACKUP_DIR/config_$TIMESTAMP $BACKUP_DIR/keystore_$TIMESTAMP

# 清理临时文件
rm -rf $BACKUP_DIR/config_$TIMESTAMP $BACKUP_DIR/keystore_$TIMESTAMP

# 删除7天前的备份文件
find $BACKUP_DIR -name "drawio_backup_*.tar.gz" -mtime +7 -delete
```

将此脚本保存为`backup_drawio.sh`，添加执行权限并配置到crontab定期执行：

```bash
chmod +x backup_drawio.sh
echo "0 1 * * * /path/to/backup_drawio.sh" >> /etc/crontab
```

### 安全加固

1. **使用非root用户运行容器**：
   ```bash
   docker run -d \
     --name drawio \
     -p 8080:8080 \
     -p 8443:8443 \
     --user 1000:1000 \
     xxx.xuanyuan.run/jgraph/drawio:latest
   ```

2. **启用网络隔离**：
   ```bash
   # 创建专用网络
   docker network create drawio-network
   
   # 使用专用网络运行容器
   docker run -d \
     --name drawio \
     --network drawio-network \
     -p 8080:8080 \
     -p 8443:8443 \
     xxx.xuanyuan.run/jgraph/drawio:latest
   ```

3. **定期更新镜像**：保持镜像为最新版本以获取安全补丁和功能更新
   ```bash
   docker pull xxx.xuanyuan.run/jgraph/drawio:latest
   docker stop drawio
   docker rm drawio
   # 重新运行容器（使用之前的运行命令）
   ```

## 故障排查

### 容器无法启动

1. **检查端口占用**：
   ```bash
   netstat -tulpn | grep 8080
   netstat -tulpn | grep 8443
   ```
   若端口已被占用，可更换主机端口或停止占用端口的服务。

2. **查看启动日志**：
   ```bash
   docker logs drawio
   ```
   检查日志中是否有错误信息，特别是Java异常和端口绑定失败的提示。

3. **检查资源限制**：
   若服务器资源不足，可能导致容器无法启动或启动后立即退出，可通过以下命令检查系统资源：
   ```bash
   free -m      # 内存使用情况
   df -h        # 磁盘空间使用情况
   top          # CPU使用情况
   ```

### 无法访问Web界面

1. **检查容器运行状态**：
   ```bash
   docker ps | grep drawio
   ```
   确保容器处于"Up"状态。

2. **检查网络连接**：
   ```bash
   # 从服务器内部测试
   curl -I http://localhost:8080
   
   # 检查防火墙设置
   firewall-cmd --list-ports  # 若使用firewalld
   ufw status                 # 若使用ufw
   ```

3. **检查端口映射**：
   ```bash
   docker port drawio
   ```
   确认容器端口已正确映射到主机端口。

### SSL证书问题

1. **自签名证书警告**：
   使用自签名证书时，浏览器会显示安全警告，这是正常现象。若要消除警告，需使用可信CA签发的证书。

2. **Let's Encrypt证书申请失败**：
   - 确保服务器80端口可以被外部访问
   - 确保域名正确解析到服务器IP
   - 检查Let's Encrypt日志：
     ```bash
     docker exec -it drawio cat /var/log/letsencrypt/letsencrypt.log
     ```

3. **证书过期**：
   Let's Encrypt证书有效期为90天，若使用本文档中的自动配置，证书应会自动续期。若续期失败，可手动更新：
   ```bash
   docker restart drawio
   ```

### 性能问题

1. **内存不足**：
   若DRAWIO运行缓慢，可能是内存不足导致，可通过以下命令检查容器内存使用情况：
   ```bash
   docker stats drawio
   ```
   考虑增加容器的内存限制。

2. **CPU使用率高**：
   复杂的图表渲染可能会导致CPU使用率暂时升高，若持续高CPU使用率，可考虑：
   - 升级服务器配置
   - 限制同时编辑的图表复杂度
   - 考虑使用负载均衡分散压力

### 数据丢失问题

1. **未使用持久化存储**：
   若未挂载外部卷，容器删除后数据会丢失，确保已正确配置数据卷挂载。

2. **备份恢复**：
   使用之前创建的备份恢复数据：
   ```bash
   # 解压备份文件
   tar -zxvf /opt/backups/drawio/drawio_backup_xxxxxx.tar.gz -C /tmp
   
   # 恢复配置文件
   docker cp /tmp/config_xxxxxx $CONTAINER_NAME:/user/local/tomcat/webapps/drawio/WEB-INF/
   
   # 恢复密钥库
   docker cp /tmp/keystore_xxxxxx $CONTAINER_NAME:/user/local/tomcat/
   
   # 重启容器
   docker restart $CONTAINER_NAME
   ```

## 参考资源

1. **DRAWIO镜像文档（轩辕）**：[https://xuanyuan.cloud/r/jgraph/drawio](https://xuanyuan.cloud/r/jgraph/drawio)

2. **DRAWIO镜像标签列表**：[https://xuanyuan.cloud/r/jgraph/drawio/tags](https://xuanyuan.cloud/r/jgraph/drawio/tags)

3. **DRAWIO官方代码仓库**：[https://github.com/jgraph/drawio](https://github.com/jgraph/drawio)

4. **Tomcat官方文档**：[https://tomcat.apache.org/tomcat-9.0-doc/index.html](https://tomcat.apache.org/tomcat-9.0-doc/index.html)

5. **Docker官方文档**：[https://docs.docker.com/](https://docs.docker.com/)

6. **Let's Encrypt官方文档**：[https://letsencrypt.org/docs/](https://letsencrypt.org/docs/)

7. **DRAWIO使用教程**：[https://www.diagrams.net/doc/](https://www.diagrams.net/doc/)

## 总结

本文详细介绍了DRAWIO的Docker容器化部署方案，从环境准备、镜像拉取、容器部署到功能测试，提供了全面的操作指南。同时，针对生产环境的需求，给出了资源限制、持久化存储、反向代理、容器编排、定期备份和安全加固等方面的建议，并提供了常见故障的排查方法。

通过容器化部署DRAWIO，可以快速搭建一个功能完善的图表绘制平台，满足团队协作和个人使用的需求，同时确保数据安全和系统稳定性。

**关键要点**：

- 使用轩辕镜像访问支持可提升国内网络环境下的DRAWIO镜像下载访问表现
- DRAWIO默认提供HTTP(8080)和HTTPS(8443)两种访问方式
- `?offline=1`参数可禁用云存储支持，增强安全性
- Let's Encrypt证书配置需要开放80/443端口并正确设置域名
- 生产环境中应配置资源限制、持久化存储和定期备份
- Docker Compose可简化DRAWIO的管理和扩展

**后续建议**：

- 深入学习DRAWIO的高级功能，如自定义库、宏和自动化脚本
- 根据实际使用情况调整容器资源配置，优化性能
- 探索DRAWIO与其他系统的集成方案，如文档管理系统、项目管理工具等
- 定期关注DRAWIO的更新，及时应用安全补丁和新功能
- 考虑建立高可用部署架构，确保服务持续可用

通过合理配置和持续优化，DRAWIO容器化部署可以为组织提供一个高效、安全、可靠的图表绘制解决方案，支持各类业务流程可视化和技术架构设计需求。

