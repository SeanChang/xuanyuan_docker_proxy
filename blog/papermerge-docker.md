# PAPERMERGE Docker 容器化部署指南

![PAPERMERGE Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-papermerge.png)

*分类: Docker,PAPERMERGE | 标签: papermerge,docker,部署教程 | 发布时间: 2025-12-07 15:03:01*

> PAPERMERGE是一款容器化的开源文档管理系统(DMS)，专为数字化档案的归档和检索而设计。在PAPERMERGE的语境中，文档指任何适合归档的信息片段——通常是不可编辑但需要为将来参考而存储的内容，如收据、合同、扫描文档等。这些文档通常以PDF或TIFF格式存储，非常适合长期存档。

## 概述

PAPERMERGE是一款容器化的开源文档管理系统(DMS)，专为数字化档案的归档和检索而设计。在PAPERMERGE的语境中，文档指任何适合归档的信息片段——通常是不可编辑但需要为将来参考而存储的内容，如收据、合同、扫描文档等。这些文档通常以PDF或TIFF格式存储，非常适合长期存档。

PAPERMERGE提供REST API接口，允许开发者与其集成，实现更灵活的文档管理工作流。系统默认使用SQLite数据库进行数据存储，同时也支持PostgreSQL数据库以满足更高的性能和可靠性要求。

本文档将详细介绍如何使用Docker容器化方式部署PAPERMERGE，包括环境准备、镜像拉取、容器配置和功能测试等步骤，帮助用户快速搭建起自己的文档管理系统。

## 环境准备

### Docker环境安装

PAPERMERGE作为容器化应用，需要运行在Docker环境中。推荐使用以下一键安装脚本部署Docker环境，该脚本会自动安装Docker Engine、Docker CLI、Docker Compose等必要组件，并配置好相关依赖：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> 注意：执行此脚本需要root权限，安装过程可能需要几分钟时间，请耐心等待。安装完成后，系统会自动启动Docker服务并配置开机自启。

安装完成后，可以通过以下命令验证Docker是否安装成功：

```bash
docker --version
docker compose version
```

如果命令输出了Docker和Docker Compose的版本信息，则说明安装成功。

## 镜像准备

### 拉取PAPERMERGE镜像

使用以下命令通过轩辕镜像访问支持地址拉取推荐版本(3.5.3)的PAPERMERGE镜像：

```bash
docker pull xxx.xuanyuan.run/papermerge/papermerge:3.5.3
```

拉取完成后，可以使用以下命令验证镜像是否成功获取：

```bash
docker images | grep papermerge/papermerge
```

如果输出中包含`xxx.xuanyuan.run/papermerge/papermerge:3.5.3`的记录，则说明镜像拉取成功。

如需查看所有可用的PAPERMERGE镜像标签版本，可以访问[PAPERMERGE镜像标签列表](https://xuanyuan.cloud/r/papermerge/papermerge/tags)获取详细信息。

## 容器部署

### 基本部署（单容器模式）

PAPERMERGE提供了简单的单容器部署模式，适合快速试用和开发环境。根据官方文档，部署PAPERMERGE需要设置两个必需的环境变量：`PAPERMERGE__MAIN__SECRET_KEY`（系统密钥）和`DJANGO_SUPERUSER_PASSWORD`（管理员密码）。

使用以下命令启动PAPERMERGE容器：

```bash
docker run -d \
  --name papermerge \
  -p 8000:8000 \
  -e PAPERMERGE__MAIN__SECRET_KEY=your_secure_secret_key \
  -e DJANGO_SUPERUSER_PASSWORD=your_admin_password \
  xxx.xuanyuan.run/papermerge/papermerge:3.5.3
```

参数说明：
- `-d`: 后台运行容器
- `--name papermerge`: 为容器指定一个名称，便于后续管理
- `-p 8000:8000`: 将容器的8000端口映射到主机的8000端口
- `-e`: 设置环境变量，其中：
  - `PAPERMERGE__MAIN__SECRET_KEY`: 系统安全密钥，建议使用强随机字符串
  - `DJANGO_SUPERUSER_PASSWORD`: 管理员账户密码

如果需要自定义管理员用户名，可以添加`DJANGO_SUPERUSER_USERNAME`环境变量：

```bash
docker run -d \
  --name papermerge \
  -p 8000:8000 \
  -e PAPERMERGE__MAIN__SECRET_KEY=your_secure_secret_key \
  -e DJANGO_SUPERUSER_PASSWORD=your_admin_password \
  -e DJANGO_SUPERUSER_USERNAME=custom_admin \
  xxx.xuanyuan.run/papermerge/papermerge:3.5.3
```

### 持久化部署

为了确保文档数据在容器重启后不丢失，建议将文档存储目录挂载到主机：

```bash
docker run -d \
  --name papermerge \
  -p 8000:8000 \
  -v /data/papermerge/documents:/app/media/documents \
  -e PAPERMERGE__MAIN__SECRET_KEY=your_secure_secret_key \
  -e DJANGO_SUPERUSER_PASSWORD=your_admin_password \
  xxx.xuanyuan.run/papermerge/papermerge:3.5.3
```

其中`/data/papermerge/documents`是主机上的目录，用于持久化存储PAPERMERGE的文档数据。

### 使用PostgreSQL数据库（生产推荐）

默认情况下，PAPERMERGE使用SQLite数据库，适合开发和测试环境。对于生产环境，建议使用PostgreSQL数据库以获得更好的性能和可靠性。以下是使用Docker Compose部署PAPERMERGE和PostgreSQL的方案：

1. 创建`docker-compose.yml`文件：

```yaml
version: '3.7'
services:
  app:
    image: xxx.xuanyuan.run/papermerge/papermerge:3.5.3
    container_name: papermerge_app
    ports:
      - "8000:8000"
    environment:
      - PAPERMERGE__MAIN__SECRET_KEY=your_secure_secret_key
      - DJANGO_SUPERUSER_PASSWORD=your_admin_password
      - PAPERMERGE__DATABASE__TYPE=postgres
      - PAPERMERGE__DATABASE__USER=postgres
      - PAPERMERGE__DATABASE__PASSWORD=postgres_password
      - PAPERMERGE__DATABASE__NAME=postgres
      - PAPERMERGE__DATABASE__HOST=db
    volumes:
      - /data/papermerge/documents:/app/media/documents
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: xxx.xuanyuan.run/bitnami/postgresql:14.4.0
    container_name: papermerge_db
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    environment:
      - POSTGRES_PASSWORD=postgres_password
    restart: unless-stopped

volumes:
  postgres_data:
```

2. 使用以下命令启动服务：

```bash
docker compose up -d
```

这种部署方式提供了更好的数据持久性和系统稳定性，适合生产环境使用。

### 容器状态检查

容器启动后，可以使用以下命令检查容器运行状态：

```bash
# 查看容器运行状态
docker ps | grep papermerge

# 查看容器日志
docker logs papermerge
```

如果一切正常，日志中会显示类似"Starting server"或"Listening on port 8000"的信息。

## 功能测试

### 服务可用性测试

容器启动后，可以通过以下方式测试PAPERMERGE服务是否正常运行：

1. 使用curl命令测试API端点：

```bash
curl -I http://localhost:8000/api/
```

如果服务正常，会返回200 OK状态码。

2. 访问认证接口测试：

可以使用curl命令测试认证功能：

```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "your_admin_password"}'
```

如果认证成功，会返回包含token的JSON响应。

3. 通过浏览器访问：

打开浏览器，访问`http://服务器IP:8000`，应该能看到PAPERMERGE的登录界面。使用默认用户名`admin`和您设置的`DJANGO_SUPERUSER_PASSWORD`密码登录系统。

### 基本功能测试

成功登录后，可以进行一些基本的功能测试：

1. 检查系统概览：确认界面加载正常，没有错误提示
2. 创建文件夹：测试基本的文档组织功能
3. 上传测试文档：尝试上传一个PDF或图片文件，验证文档上传功能
4. 查看文档详情：上传后检查文档是否可以正常打开和查看

### 日志验证

如遇到问题，可以通过查看容器日志获取更多信息：

```bash
# 实时查看日志
docker logs -f papermerge

# 查看特定时间段的日志
docker logs --since 30m papermerge
```

正常情况下，日志中不应包含错误信息或异常堆栈跟踪。

## 生产环境建议

### 安全加固

1. **使用强密钥和密码**：
   - `PAPERMERGE__MAIN__SECRET_KEY`应使用随机生成的强密钥，建议长度至少32个字符
   - 管理员密码应符合密码复杂性要求，包含大小写字母、数字和特殊字符

2. **配置HTTPS**：
   生产环境中应始终使用HTTPS加密传输。可以通过在PAPERMERGE前面部署Nginx或Traefik等反向代理来实现HTTPS：
   
   ```nginx
   server {
       listen 443 ssl;
       server_name papermerge.example.com;
       
       ssl_certificate /path/to/cert.pem;
       ssl_certificate_key /path/to/key.pem;
       
       location / {
           proxy_pass http://localhost:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

3. **限制容器权限**：
   运行容器时使用非root用户，并限制容器的系统调用权限：
   
   ```bash
   docker run -d \
     --name papermerge \
     --user 1001:1001 \
     --cap-drop ALL \
     -p 8000:8000 \
     -e PAPERMERGE__MAIN__SECRET_KEY=your_secure_secret_key \
     -e DJANGO_SUPERUSER_PASSWORD=your_admin_password \
     xxx.xuanyuan.run/papermerge/papermerge:3.5.3
   ```

### 性能优化

1. **资源配置**：
   根据实际使用情况为容器分配适当的CPU和内存资源：
   
   ```bash
   docker run -d \
     --name papermerge \
     --cpus 2 \
     --memory 2G \
     -p 8000:8000 \
     ...
   ```

2. **使用外部数据库**：
   对于大规模部署，建议使用独立的PostgreSQL数据库集群，而非容器化的数据库，以提高性能和可靠性。

3. **定期维护**：
   设置定时任务清理不必要的日志和临时文件，保持系统运行效率。

### 数据备份策略

1. **文档数据备份**：
   定期备份挂载的文档目录：
   
   ```bash
   # 创建文档数据备份
   tar -czf papermerge_documents_backup_$(date +%Y%m%d).tar.gz /data/papermerge/documents
   ```

2. **数据库备份**：
   如果使用PostgreSQL数据库，定期备份数据库：
   
   ```bash
   # PostgreSQL数据库备份
   docker exec papermerge_db pg_dump -U postgres postgres > papermerge_db_backup_$(date +%Y%m%d).sql
   ```

3. **备份策略**：
   - 建议每日进行增量备份，每周进行完整备份
   - 备份文件应存储在不同的物理位置
   - 定期测试备份恢复流程，确保备份可用

### 监控与告警

1. **容器监控**：
   使用Docker的内置命令或第三方工具监控容器状态：
   
   ```bash
   # 查看容器资源使用情况
   docker stats papermerge
   ```

2. **日志管理**：
   配置日志轮转，防止日志文件过大：
   
   ```bash
   # 创建日志轮转配置文件 /etc/logrotate.d/docker-container-papermerge
   /var/lib/docker/containers/*/*-json.log {
     daily
     rotate 7
     compress
     delaycompress
     missingok
     copytruncate
   }
   ```

3. **集成监控系统**：
   对于生产环境，建议将PAPERMERGE集成到Prometheus+Grafana等监控系统中，设置关键指标的告警阈值。

## 故障排查

### 常见问题及解决方法

1. **容器无法启动**：

   - **检查日志**：使用`docker logs papermerge`查看详细错误信息
   - **端口冲突**：确认8000端口是否被其他服务占用
     ```bash
     # 检查端口占用情况
     netstat -tulpn | grep 8000
     ```
   - **环境变量错误**：确保所有必需的环境变量都已正确设置
   - **权限问题**：检查挂载目录的权限是否正确

2. **服务启动后无法访问**：

   - **防火墙设置**：检查服务器防火墙是否允许8000端口的入站流量
     ```bash
     # 检查防火墙规则
     firewall-cmd --list-ports
     # 如未开放，添加规则
     firewall-cmd --add-port=8000/tcp --permanent
     firewall-cmd --reload
     ```
   - **网络问题**：确认服务器IP地址是否正确，网络是否可达
   - **容器端口映射**：确认端口映射参数是否正确设置

3. **数据库连接问题**（PostgreSQL模式）：

   - **容器依赖**：确保数据库容器先于PAPERMERGE容器启动
   - **网络连接**：检查数据库容器是否与PAPERMERGE容器在同一网络
   - **认证信息**：验证数据库连接参数是否正确

### 高级故障排查

1. **进入容器内部检查**：

   ```bash
   # 以交互方式进入容器
   docker exec -it papermerge /bin/bash
   
   # 检查配置文件
   cat /app/papermerge/settings.py
   
   # 检查环境变量
   env | grep PAPERMERGE
   ```

2. **查看应用详细日志**：

   ```bash
   # 查看完整日志
   docker logs papermerge > papermerge_full_logs.txt
   
   # 查找错误信息
   grep -i error papermerge_full_logs.txt
   grep -i exception papermerge_full_logs.txt
   ```

3. **健康检查脚本**：

   可以创建简单的健康检查脚本`check_papermerge.sh`：

   ```bash
   #!/bin/bash
   
   # 检查容器是否运行
   if ! docker ps | grep -q papermerge; then
     echo "PAPERMERGE容器未运行"
     exit 1
   fi
   
   # 检查API是否响应
   if ! curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/ | grep -q 200; then
     echo "PAPERMERGE API无响应"
     exit 1
   fi
   
   echo "PAPERMERGE服务正常"
   exit 0
   ```

   添加执行权限并运行：

   ```bash
   chmod +x check_papermerge.sh
   ./check_papermerge.sh
   ```

## 参考资源

### 官方文档

- [PAPERMERGE镜像文档（轩辕）](https://xuanyuan.cloud/r/papermerge/papermerge)
- [PAPERMERGE镜像标签列表](https://xuanyuan.cloud/r/papermerge/papermerge/tags)
- [PAPERMERGE环境变量文档](https://docs.papermerge.io/Settings/index.html)

### Docker相关资源

- Docker官方文档: https://docs.docker.com/
- Docker Compose文档: https://docs.docker.com/compose/

### 安全最佳实践

- Docker容器安全加固指南
- OWASP Top 10安全风险防范

## 总结

本文详细介绍了PAPERMERGE的Docker容器化部署方案，从环境准备、镜像拉取、容器部署到功能测试和生产环境优化，提供了一套完整的实施指南。通过容器化部署，用户可以快速搭建起自己的文档管理系统，实现数字化档案的高效管理。

**关键要点**：

- PAPERMERGE是一款专注于文档归档和检索的开源文档管理系统，特别适合处理扫描文档、PDF等格式的文件
- 使用Docker部署PAPERMERGE可大幅简化安装过程，提高系统可移植性
- 部署时需设置两个必需的环境变量：`PAPERMERGE__MAIN__SECRET_KEY`和`DJANGO_SUPERUSER_PASSWORD`
- 生产环境中建议使用PostgreSQL数据库替代默认的SQLite，并配置适当的持久化存储
- 系统安全加固、数据备份和监控是确保生产环境稳定运行的关键

**后续建议**：

- 深入学习PAPERMERGE的高级特性，如OCR文本识别、文档分类和搜索功能
- 根据实际业务需求调整系统配置，如存储策略、用户权限和访问控制
- 定期关注PAPERMERGE的版本更新，及时应用安全补丁和功能改进
- 考虑将PAPERMERGE与其他系统集成，如办公自动化系统、CRM系统等，构建更完善的文档管理生态

如需了解更多信息，请参考[PAPERMERGE镜像文档（轩辕）](https://xuanyuan.cloud/r/papermerge/papermerge)或官方文档获取最新指导。

