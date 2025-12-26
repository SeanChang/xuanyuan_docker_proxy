---
id: 102
title: LANGFUSE Docker 容器化部署指南
slug: langfuse-docker
summary: LANGFUSE 是一款开源的 LLM 工程平台，旨在为大型语言模型（LLM）应用提供可观测性、评估工具、提示管理、 playground 界面及性能指标分析等核心功能。作为连接 LLM 模型与实际业务应用的桥梁，LANGFUSE 支持与各类模型、框架集成，允许复杂的嵌套结构，并提供开放 API 以构建下游业务场景。
category: Docker,LANGFUSE
tags: langfuse,docker,部署教程
image_name: langfuse/langfuse
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-langfuse.png"
status: published
created_at: "2025-12-03 08:13:32"
updated_at: "2025-12-03 08:13:32"
---

# LANGFUSE Docker 容器化部署指南

> LANGFUSE 是一款开源的 LLM 工程平台，旨在为大型语言模型（LLM）应用提供可观测性、评估工具、提示管理、 playground 界面及性能指标分析等核心功能。作为连接 LLM 模型与实际业务应用的桥梁，LANGFUSE 支持与各类模型、框架集成，允许复杂的嵌套结构，并提供开放 API 以构建下游业务场景。

## 概述

LANGFUSE 是一款开源的 LLM 工程平台，旨在为大型语言模型（LLM）应用提供可观测性、评估工具、提示管理、 playground 界面及性能指标分析等核心功能。作为连接 LLM 模型与实际业务应用的桥梁，LANGFUSE 支持与各类模型、框架集成，允许复杂的嵌套结构，并提供开放 API 以构建下游业务场景。

随着 LLM 技术在企业级应用中的普及，快速、可靠的部署方式成为工程实践的关键。Docker 容器化部署凭借其环境一致性、隔离性和可移植性，成为 LANGFUSE 部署的理想选择。本文将详细介绍如何通过 Docker 容器化方案部署 LANGFUSE，从环境准备到生产环境优化，为技术团队提供可落地的实施指南。


## 环境准备

### Docker 安装

部署 LANGFUSE 容器前需确保 Docker 环境已正确安装。推荐使用轩辕云提供的一键安装脚本，该脚本适用于主流 Linux 发行版（Ubuntu、Debian、CentOS、Fedora 等），可自动完成 Docker 引擎、Docker Compose 及相关依赖的安装与配置。

执行以下命令安装 Docker 环境：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

> **安装说明**：
> - 脚本将自动检测操作系统类型并适配安装流程
> - 过程中需要 sudo 权限，请确保当前用户具有 sudo 执行权限
> - 安装完成后会自动启动 Docker 服务并设置开机自启

安装完成后，通过以下命令验证 Docker 是否正常运行：

```bash
# 检查 Docker 版本
docker --version

# 检查 Docker Compose 版本
docker compose version

# 验证 Docker 服务状态
systemctl status docker
```

若输出 Docker 版本信息（如 `Docker version 26.0.0, build 2ae903e`）且服务状态为 `active (running)`，则表示安装成功。


如需验证加速配置是否生效，可查看 Docker 守护进程配置：

```bash
cat /etc/docker/daemon.json
```

若配置正确，将看到包含 `xxx.xuanyuan.run` 镜像仓库的配置内容。


## 镜像准备

### 镜像拉取

LANGFUSE 推荐使用最新稳定版本（`latest` 标签），如需指定版本，可从 [LANGFUSE 镜像标签列表](https://xuanyuan.cloud/r/langfuse/langfuse/tags) 选择合适的标签。

执行以下命令拉取 LANGFUSE 镜像：

```bash
# 拉取最新版本
docker pull xxx.xuanyuan.run/langfuse/langfuse:latest

# 如需指定版本（示例：拉取 2.0 版本）
# docker pull xxx.xuanyuan.run/langfuse/langfuse:2.0
```

> **版本选择建议**：
> - 生产环境推荐使用特定主版本标签（如 `2`）而非 `latest`，以避免自动升级导致的兼容性问题
> - 可通过 [LANGFUSE 镜像标签列表](https://xuanyuan.cloud/r/langfuse/langfuse/tags) 查看所有可用版本及更新日志


### 镜像验证

拉取完成后，通过以下命令验证镜像是否成功下载：

```bash
# 查看本地镜像列表
docker images | grep langfuse

# 输出示例：
# xxx.xuanyuan.run/langfuse/langfuse   latest    abc12345   2 weeks ago   1.2GB
```

若输出包含 `xxx.xuanyuan.run/langfuse/langfuse` 及对应标签信息，则表示镜像拉取成功。可进一步通过 `docker inspect` 命令查看镜像详细信息：

```bash
docker inspect xxx.xuanyuan.run/langfuse/langfuse:latest
```

该命令将返回镜像的完整元数据，包括环境变量、暴露端口、入口命令等，有助于后续部署配置。


## 容器部署

### 基础部署（单容器模式）

LANGFUSE 基础部署需至少映射 Web 服务端口，并配置必要的环境变量。以下是快速启动命令，适用于测试环境：

```bash
docker run -d \
  --name langfuse \
  --restart unless-stopped \
  -p 3000:3000 \  # Web 服务端口映射（主机端口:容器端口）
  -e NEXTAUTH_URL=http://localhost:3000 \  # 应用访问地址
  -e DATABASE_URL=postgresql://postgres:postgres@host.docker.internal:5432/langfuse \  # 数据库连接地址
  -e NEXTAUTH_SECRET=your-secure-secret-key \  # 认证密钥（建议使用随机字符串）
  xxx.xuanyuan.run/langfuse/langfuse:latest
```

> **参数说明**：
> - `-d`：后台运行容器
> - `--name langfuse`：指定容器名称为 `langfuse`
> - `--restart unless-stopped`：容器退出时除非手动停止，否则自动重启
> - `-p 3000:3000`：将容器的 3000 端口映射到主机的 3000 端口（默认 Web 服务端口）
> - `-e`：设置环境变量（详细环境变量见下文）


### 核心环境变量配置

LANGFUSE 运行依赖多个关键环境变量，以下为常用配置项说明（完整列表请参考 [LANGFUSE 镜像文档（轩辕）](https://xuanyuan.cloud/r/langfuse/langfuse)）：

| 环境变量 | 描述 | 示例值 |
|----------|------|--------|
| `NEXTAUTH_URL` | 应用访问基础 URL（含协议和端口） | `https://langfuse.example.com` |
| `NEXTAUTH_SECRET` | 用于加密认证会话的密钥，建议至少 32 字符 | `$(openssl rand -hex 32)` |
| `DATABASE_URL` | 数据库连接字符串（PostgreSQL 必需） | `postgresql://user:pass@db:5432/langfuse` |
| `NEXT_PUBLIC_SITE_URL` | 前端访问 URL（与 `NEXTAUTH_URL` 通常一致） | `https://langfuse.example.com` |
| `LANGFUSE_ENABLE_SIGNUP` | 是否允许用户注册（生产环境建议关闭） | `false` |
| `LANGFUSE_CLOUD_MODE` | 是否启用云模式（自托管环境设为 `false`） | `false` |
| `PORT` | 容器内 Web 服务端口（默认 3000） | `3000` |


### 数据库配置（外部 PostgreSQL）

LANGFUSE 依赖 PostgreSQL 数据库存储核心数据（如追踪记录、评估结果、用户配置等）。生产环境建议使用独立部署的 PostgreSQL 实例（而非容器内置数据库），以提高数据可靠性和扩展性。

#### 1. 部署 PostgreSQL 容器（示例）

如需快速搭建测试用 PostgreSQL，可使用以下命令：

```bash
# 创建 PostgreSQL 数据卷（持久化存储）
docker volume create pgdata

# 启动 PostgreSQL 容器
docker run -d \
  --name langfuse-postgres \
  --restart unless-stopped \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  -e POSTGRES_USER=langfuse \
  -e POSTGRES_PASSWORD=secure-password \
  -e POSTGRES_DB=langfuse \
  xxx.xuanyuan.run/library/postgres:15  # PostgreSQL 官方镜像（单段镜像名，使用 library 前缀）
```

#### 2. 配置 LANGFUSE 数据库连接

使用外部 PostgreSQL 时，需调整 `DATABASE_URL` 环境变量指向数据库实例：

```bash
# 同一主机下的 PostgreSQL 连接（使用容器名称作为主机名）
-e DATABASE_URL=postgresql://langfuse:secure-password@langfuse-postgres:5432/langfuse

# 远程 PostgreSQL 连接
# -e DATABASE_URL=postgresql://user:pass@remote-postgres.example.com:5432/langfuse
```


### 数据持久化配置

为避免容器重启导致数据丢失，需将 LANGFUSE 的关键数据目录挂载到主机目录或 Docker 数据卷。LANGFUSE 主要需要持久化的目录包括日志、上传文件等（具体路径可通过 `docker inspect` 查看镜像元数据）：

```bash
# 创建本地数据目录
mkdir -p /opt/langfuse/logs /opt/langfuse/uploads

# 启动容器时挂载目录
docker run -d \
  --name langfuse \
  --restart unless-stopped \
  -p 3000:3000 \
  -v /opt/langfuse/logs:/app/logs \  # 日志目录
  -v /opt/langfuse/uploads:/app/public/uploads \  # 上传文件目录
  -e NEXTAUTH_URL=http://localhost:3000 \
  -e NEXTAUTH_SECRET=$(openssl rand -hex 32) \
  -e DATABASE_URL=postgresql://langfuse:secure-password@langfuse-postgres:5432/langfuse \
  xxx.xuanyuan.run/langfuse/langfuse:latest
```


### Docker Compose 编排（推荐生产环境）

对于多组件部署（如 LANGFUSE + PostgreSQL），推荐使用 Docker Compose 统一管理容器。创建 `docker-compose.yml` 文件如下：

```yaml
version: '3.8'

services:
  langfuse:
    image: xxx.xuanyuan.run/langfuse/langfuse:latest
    container_name: langfuse
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NEXTAUTH_URL=http://localhost:3000
      - NEXTAUTH_SECRET=${NEXTAUTH_SECRET}  # 从环境变量读取，避免硬编码
      - DATABASE_URL=postgresql://langfuse:${DB_PASSWORD}@postgres:5432/langfuse
      - LANGFUSE_ENABLE_SIGNUP=false
      - LANGFUSE_CLOUD_MODE=false
    volumes:
      - langfuse-logs:/app/logs
      - langfuse-uploads:/app/public/uploads
    depends_on:
      - postgres  # 确保数据库先启动
    networks:
      - langfuse-network

  postgres:
    image: xxx.xuanyuan.run/library/postgres:15  # PostgreSQL 官方镜像
    container_name: langfuse-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_USER=langfuse
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=langfuse
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - langfuse-network
    healthcheck:  # 数据库健康检查
      test: ["CMD-SHELL", "pg_isready -U langfuse -d langfuse"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  langfuse-logs:
  langfuse-uploads:
  pgdata:

networks:
  langfuse-network:
    driver: bridge
```

创建 `.env` 文件存储敏感信息（**不要提交到版本控制**）：

```env
# .env 文件
NEXTAUTH_SECRET=your-32-character-secure-secret-here
DB_PASSWORD=your-secure-postgres-password
```

使用以下命令启动服务：

```bash
# 启动所有服务（后台运行）
docker compose up -d

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f
```


## 功能测试

### 服务可用性验证

部署完成后，通过以下步骤验证 LANGFUSE 服务是否正常运行：

#### 1. 检查容器状态

```bash
# 查看容器运行状态
docker ps | grep langfuse

# 输出示例（状态应为 Up）：
# abc123456789   xxx.xuanyuan.run/langfuse/langfuse:latest   "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes   0.0.0.0:3000->3000/tcp   langfuse
```

若状态为 `Exited`，通过日志排查错误：

```bash
docker logs langfuse
```


#### 2. 访问 Web 界面

在浏览器中访问 `http://服务器IP:3000`（或配置的 `NEXTAUTH_URL`），应显示 LANGFUSE 登录页面。首次登录需使用默认管理员账户（具体凭据请参考 [LANGFUSE 镜像文档（轩辕）](https://xuanyuan.cloud/r/langfuse/langfuse)）。


#### 3. API 接口测试

使用 `curl` 或 Postman 测试 LANGFUSE API 可用性（需先获取 API 密钥，在 Web 界面的「设置 > API 密钥」中创建）：

```bash
# 测试 API 健康检查接口
curl -X GET http://服务器IP:3000/api/health \
  -H "Content-Type: application/json"

# 预期响应：{"status":"ok","version":"x.y.z"}
```


### 核心功能验证

#### 1. 项目创建

登录后，在 Web 界面点击「New Project」创建测试项目，填写项目名称和描述，验证项目创建功能是否正常。


#### 2. 追踪事件上报

使用以下代码示例（Python）向 LANGFUSE 上报测试追踪事件，验证数据接收能力：

```python
from langfuse import Langfuse

# 初始化客户端（API 密钥从 Web 界面获取）
langfuse = Langfuse(
    public_key="pk-xxx",
    secret_key="sk-xxx",
    host="http://服务器IP:3000"  # 自托管实例地址
)

# 创建追踪事件
trace = langfuse.trace(
    name="test-trace",
    input="Hello LANGFUSE"
)

# 添加生成内容
generation = trace.generation(
    name="test-generation",
    input="Hello",
    output="World",  
    model="test-model"
)

# 提交事件
trace.submit()
```

在 Web 界面的「Traces」页面查看是否接收到该事件，验证数据存储和展示功能。


#### 3. 评估功能测试

在项目中创建评估集（Evaluation Set），添加测试用例并执行评估，验证评估流程是否正常：

1. 进入项目 > Evaluations > New Evaluation Set
2. 添加测试用例（输入、预期输出、评分标准）
3. 运行评估并查看结果报告


## 生产环境建议

### 安全加固

#### 1. 网络隔离与端口限制

- **禁止公网直接暴露**：通过反向代理（如 Nginx、Traefik）暴露服务，避免容器端口直接映射到公网
- **使用自定义网络**：通过 Docker 自定义网络隔离 LANGFUSE 与数据库，仅暴露必要端口

```yaml
# docker-compose.yml 网络配置示例
networks:
  langfuse-network:
    driver: bridge
    internal: false  # 允许访问外部网络（如更新、外部 API）
```


#### 2. 敏感信息管理

- **环境变量加密**：使用 Docker Secrets（Swarm 模式）或外部密钥管理服务（如 HashiCorp Vault）存储敏感信息，避免明文环境变量
- **API 密钥轮换**：定期轮换 API 密钥，在 Web 界面的「设置 > API 密钥」中操作
- **数据库访问控制**：限制数据库仅允许 LANGFUSE 容器访问，通过网络策略或防火墙实现


#### 3. HTTPS 配置

生产环境必须启用 HTTPS 加密传输，推荐通过反向代理实现：

**Nginx 配置示例**：

```nginx
server {
    listen 80;
    server_name langfuse.example.com;
    return 301 https://$host$request_uri;  # HTTP 重定向到 HTTPS
}

server {
    listen 443 ssl;
    server_name langfuse.example.com;

    ssl_certificate /etc/nginx/certs/fullchain.pem;  # SSL 证书路径
    ssl_certificate_key /etc/nginx/certs/privkey.pem;

    # 代理配置
    location / {
        proxy_pass http://langfuse:3000;  # 指向 LANGFUSE 容器
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```


### 性能优化

#### 1. 资源限制与调优

为容器设置合理的资源限制，避免资源耗尽或过度占用：

```yaml
# docker-compose.yml 资源限制配置
services:
  langfuse:
    # ... 其他配置
    deploy:
      resources:
        limits:
          cpus: '2'  # CPU 限制
          memory: 4G  # 内存限制
        reservations:
          cpus: '1'  # CPU 预留
          memory: 2G  # 内存预留
```


#### 2. 数据库优化

- **使用连接池**：配置 PostgreSQL 连接池（如 PgBouncer），提高连接复用率
- **定期备份**：设置数据库定时备份策略，使用 `pg_dump` 或工具（如 pgBackRest）
- **索引优化**：根据查询模式优化数据库索引，尤其是 `traces`、`generations` 等大表


#### 3. 缓存策略

启用 Redis 缓存提升 LANGFUSE 性能，减少数据库访问压力：

```bash
# 启动 Redis 容器
docker run -d \
  --name langfuse-redis \
  --restart unless-stopped \
  -v redisdata:/data \
  xxx.xuanyuan.run/library/redis:7  # Redis 官方镜像（单段镜像名）

# 配置 LANGFUSE 使用 Redis（添加环境变量）
-e REDIS_URL=redis://langfuse-redis:6379
```


### 监控与运维

#### 1. 日志管理

- **集中式日志**：使用 ELK Stack（Elasticsearch, Logstash, Kibana）或 Loki 收集容器日志
- **日志轮转**：配置 Docker 日志驱动的轮转策略，避免日志文件过大

```json
# /etc/docker/daemon.json 日志配置
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```


#### 2. 性能监控

- **容器监控**：使用 Prometheus + Grafana 监控容器 CPU、内存、网络等指标
- **应用监控**：启用 LANGFUSE 内置 metrics 接口（`/api/metrics`），配置 Prometheus 抓取

```yaml
# prometheus.yml 配置示例
scrape_configs:
  - job_name: 'langfuse'
    static_configs:
      - targets: ['langfuse:3000']  # LANGFUSE 容器地址
```


#### 3. 自动更新与回滚

- **版本管理**：生产环境使用固定版本标签（如 `2.0`）而非 `latest`，便于回滚
- **自动化部署**：通过 CI/CD 管道（如 GitHub Actions、GitLab CI）实现镜像拉取、测试、部署自动化


## 故障排查

### 常见问题及解决方案

#### 1. 容器启动失败

**症状**：`docker ps` 显示容器状态为 `Exited`，日志中出现错误。

**排查步骤**：
1. 查看容器日志：`docker logs langfuse`
2. 检查环境变量：确认 `DATABASE_URL`、`NEXTAUTH_SECRET` 等关键变量是否正确配置
3. 检查端口占用：使用 `netstat -tulpn | grep 3000` 确认端口未被占用

**常见原因及解决**：
- **数据库连接失败**：验证数据库地址、用户名、密码是否正确，数据库是否可访问
- **密钥长度不足**：`NEXTAUTH_SECRET` 至少 32 字符，使用 `openssl rand -hex 32` 生成
- **权限问题**：挂载目录权限不足，执行 `chmod -R 775 /opt/langfuse` 授予权限


#### 2. Web 界面无法访问

**症状**：访问 `http://服务器IP:3000` 无响应或显示 502 错误。

**排查步骤**：
1. 检查容器状态和日志
2. 验证端口映射：`docker port langfuse` 确认端口映射正确
3. 检查防火墙规则：`ufw status` 或 `firewalld-cmd --list-ports` 确认端口已开放

**常见原因及解决**：
- **反向代理配置错误**：检查代理目标地址和端口是否指向 LANGFUSE 容器
- **SSL 证书问题**：HTTPS 配置错误导致无法加载页面，查看浏览器开发者工具的网络/控制台标签
- **NEXTAUTH_URL 不匹配**：确保 `NEXTAUTH_URL` 与访问 URL 一致，包括协议（http/https）


#### 3. 数据持久化失败

**症状**：容器重启后数据丢失，或日志文件未写入挂载目录。

**排查步骤**：
1. 检查数据卷挂载：`docker inspect langfuse | grep Mounts` 确认挂载配置正确
2. 查看目录权限：`ls -ld /opt/langfuse` 确认主机目录权限允许 Docker 写入

**解决方案**：
- **修复挂载路径**：确保 `-v` 参数中主机路径存在且拼写正确
- **调整目录权限**：执行 `chown -R 1000:1000 /opt/langfuse`（假设容器内用户 UID/GID 为 1000）


#### 4. API 调用失败

**症状**：客户端调用 API 时返回 401/403 错误或无响应。

**排查步骤**：
1. 检查 API 密钥：确认公钥/私钥正确，未过期或被吊销
2. 验证请求头：确保包含正确的 `Content-Type` 和认证头
3. 查看应用日志：`docker logs langfuse | grep API` 查找相关错误信息

**常见原因及解决**：
- **密钥权限不足**：创建 API 密钥时授予足够权限（如 `trace:write`、`evaluation:read`）
- **跨域配置问题**：前端调用时出现跨域错误，需在反向代理中配置 CORS 头

```nginx
# Nginx CORS 配置示例
location /api/ {
    proxy_pass http://langfuse:3000/api/;
    add_header Access-Control-Allow-Origin "https://frontend.example.com";
    add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
    add_header Access-Control-Allow-Headers "Content-Type, Authorization";
}
```


### 高级排查工具

#### 1. Docker 内置工具

- **容器内部检查**：进入容器查看运行环境

```bash
docker exec -it langfuse /bin/bash
```

- **容器资源使用监控**：实时查看容器资源占用

```bash
docker stats langfuse
```


#### 2. 数据库排查

- **连接数据库**：直接连接 PostgreSQL 检查数据

```bash
docker exec -it langfuse-postgres psql -U langfuse -d langfuse

# 查看表结构
\dt

# 检查追踪数据
SELECT * FROM traces LIMIT 10;
```


#### 3. 网络抓包

使用 `tcpdump` 在容器内抓包，分析网络请求问题：

```bash
# 在容器内安装 tcpdump（临时）
docker exec -it langfuse apt-get update && apt-get install -y tcpdump

# 抓包端口 3000
docker exec -it langfuse tcpdump -i any port 3000 -w /tmp/traffic.pcap

# 复制到主机分析
docker cp langfuse:/tmp/traffic.pcap /local/path/
```


## 参考资源

### 官方文档与镜像信息

- [LANGFUSE 镜像文档（轩辕）](https://xuanyuan.cloud/r/langfuse/langfuse)：轩辕镜像站提供的 LANGFUSE 镜像说明及配置指南
- [LANGFUSE 镜像标签列表](https://xuanyuan.cloud/r/langfuse/langfuse/tags)：所有可用镜像版本及标签信息
- [Docker 官方文档](https://docs.docker.com/)：Docker 基础概念、命令及最佳实践


### 相关工具与集成

- [LANGFUSE Python SDK](https://github.com/langfuse/langfuse-python)：Python 客户端库，用于上报追踪事件
- [LANGFUSE JavaScript SDK](https://github.com/langfuse/langfuse-js)：JavaScript/TypeScript 客户端库
- [PostgreSQL 官方文档](https://www.postgresql.org/docs/)：数据库配置与优化指南
- [Docker Compose 参考](https://docs.docker.com/compose/compose-file/)：多容器编排配置参考


### 社区资源

- [LANGFUSE GitHub 仓库](https://github.com/langfuse/langfuse)：源代码、Issue 跟踪及贡献指南
- [LANGFUSE Discord](https://discord.gg/langfuse)：社区支持与讨论
- [Docker Hub 官方镜像](https://hub.docker.com/r/langfuse/langfuse)：官方镜像仓库


## 总结

本文详细介绍了 LANGFUSE 的 Docker 容器化部署方案，从环境准备、镜像拉取、容器部署到功能测试，覆盖了单容器快速部署和多容器生产环境配置，并提供了安全加固、性能优化、监控运维及故障排查的实践指南。通过 Docker 容器化部署，可显著降低 LANGFUSE 的环境依赖复杂度，提高部署一致性和可维护性。


### 关键要点

- **镜像拉取规则**：LANGFUSE 镜像使用轩辕访问支持地址格式 `docker pull xxx.xuanyuan.run/langfuse/langfuse:{TAG}`
- **环境变量配置**：`NEXTAUTH_SECRET`、`DATABASE_URL` 为必需配置，生产环境需使用随机密钥和外部数据库
- **数据持久化**：通过 Docker 数据卷或主机目录挂载确保日志、配置等数据持久化
- **安全最佳实践**：避免公网直接暴露容器端口，使用反向代理和 HTTPS，定期轮换 API 密钥
- **监控与维护**：配置日志轮转、性能监控和数据库备份，确保服务稳定运行


### 后续建议

- **深入学习高级特性**：探索 LANGFUSE 的自定义评估指标、批量导入/导出、高级过滤等功能，结合业务场景定制化使用
- **性能调优**：根据实际业务负载调整容器资源、数据库配置和缓存策略，优化系统响应访问表现
- **灾备方案**：设计跨节点/跨区域的高可用部署架构，结合数据备份策略实现业务连续性保障
- **社区参与**：通过 GitHub 贡献代码或反馈问题，参与 LANGFUSE 社区建设，获取最新功能和最佳实践


### 参考链接

- [LANGFUSE 镜像文档（轩辕）](https://xuanyuan.cloud/r/langfuse/langfuse)
- [LANGFUSE 镜像标签列表](https://xuanyuan.cloud/r/langfuse/langfuse/tags)
- [Docker 官方文档](https://docs.docker.com/)
- [PostgreSQL 官方文档](https://www.postgresql.org/docs/)

