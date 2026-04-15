# OPENLIST Docker 容器化部署指南

![OPENLIST Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-openlist.png)

*分类: Docker,OPENLIST | 标签: openlist,docker,部署教程 | 发布时间: 2025-12-03 03:01:29*

> OPENLIST是一款基于Gin后端和SolidJS前端开发的多存储文件列表程序，作为AList的分支项目，它继承了文件管理的核心功能并可能提供额外特性。该程序支持多种存储后端集成，包括本地文件系统、云存储服务等，适用于个人或企业构建轻量级文件管理解决方案。

## 🔖 TL;DR（5分钟速览，给有经验的使用者）

- **测试环境**：单容器 docker run + latest 标签，快速验证功能

- **生产环境**：Docker Compose + 固定版本（vX.Y.Z）+ 非特权用户，保障可控性

- **数据安全**：优先用 Docker Volume 持久化，搭配定期规范备份，避免数据丢失

- **网络策略**：Nginx 反向代理 + HTTPS 加密，不直接暴露容器端口到公网，降低攻击面

- **升级规范**：严格遵循「备份 → 停止 → 拉取 → 启动 → 验证」流程，涉及业务需灰度验证

## 谁适合阅读本文

- 具备基础 Docker 使用经验的开发者

- 需要自部署轻量级文件管理服务的中小团队

- 对数据可控性、服务合规性与可维护性有要求的企业技术人员

**定位说明**：本文为企业级部署规范说明书，适用于企业内 Wiki、官方镜像文档、技术博客「生产级实践」场景，不适合作为小白入门的「一键部署教程」。

## 概述

OPENLIST是一款基于Gin后端和SolidJS前端开发的多存储文件列表程序，作为AList的分支项目，继承了文件管理核心功能并提供额外特性。该程序支持本地文件系统、云存储服务等多种存储后端集成，适用于个人或企业构建轻量级文件管理解决方案。

通过Docker容器化部署OPENLIST可实现环境一致性、快速部署和版本隔离等优势。本文档基于「测试环境快速验证+生产环境稳定运行」双视角，详细介绍OPENLIST的Docker部署流程，包括环境准备、镜像拉取、容器配置、功能验证及生产环境优化建议，兼顾新手友好性与企业级规范。

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

- **标签策略（重要）**：
        

    - 测试/体验环境：`latest`（包含最新功能，可能存在未验证变更，仅用于测试）

    - 生产环境：`vX.Y.Z`（固定版本标签，如`v1.0.0`，避免不可控变更，推荐生产使用）

- **标签列表参考**：[OPENLIST镜像标签列表](https://xuanyuan.cloud/r/openlistteam/openlist/tags)

- **功能描述**：多存储支持的文件列表程序，基于Gin后端和SolidJS前端，AList分支项目

### 镜像拉取命令

#### 测试环境拉取（latest）

```bash

docker pull xxx.xuanyuan.run/openlistteam/openlist:latest
```

#### 生产环境拉取（固定版本，示例）

```bash


docker pull xxx.xuanyuan.run/openlistteam/openlist:v4.1.9
```

#### 验证拉取结果：

拉取完成后，可通过以下命令检查本地镜像：

```bash

docker images | grep openlistteam/openlist
```

预期输出示例：

```bash


xxx.xuanyuan.run/openlistteam/openlist   v4.1.9    abc12345   2 weeks ago   500MB
xxx.xuanyuan.run/openlistteam/openlist   latest    def67890   1 day ago    505MB
```

## 容器部署

### 运行用户说明（关键）

OPENLIST镜像默认以`root`用户运行容器：

- 测试/内网环境：可直接使用默认配置，简化部署流程；

- 生产环境：**强烈建议**使用非特权用户运行，需提前规划宿主机UID/GID（如1001:1001），并确保挂载目录权限与容器用户匹配。

### 部署模式说明

|部署模式|适用场景|核心特点|
|---|---|---|
|单容器直出|测试/内网轻量使用|快速部署、明文HTTP、无额外依赖|
|反向代理+HTTPS|生产环境|加密传输、网络隔离、权限控制、可维护性强|
### 模式一：单容器直出（测试/内网）

#### 基础部署命令（端口重要说明）

⚠️ 注意：OPENLIST的实际监听端口以镜像内`EXPOSE`配置或官方文档为准，**不可仅参考AList默认端口**。本文示例使用`5244`仅作演示，首次启动后需通过`docker logs openlist`确认实际端口。

```bash

docker run -d \
  --name openlist \
  --restart always \
  -p 5244:5244 \  # 宿主机端口:容器端口（需以实际监听端口为准）
  -v /data/openlist:/app/data \  # 持久化存储目录（配置文件、数据等）
  xxx.xuanyuan.run/openlistteam/openlist:latest  # 测试环境用latest，生产需替换为固定版本
```

#### 参数说明：

- `-d`：后台运行容器

- `--name openlist`：指定容器名称，便于管理

- `--restart always`：容器退出时自动重启，确保服务持续运行

- `-p 5244:5244`：端口映射（若容器实际端口非5244，需同步修改）

- `-v /data/openlist:/app/data`：持久化挂载，避免数据丢失

#### 自定义配置（可选，环境变量说明）

⚠️ 注意：

以下环境变量仅用于说明 Docker 环境变量的配置方式，截至本文撰写时，OPENLIST 是否支持这些变量需以官方文档为准。若镜像未声明支持，请勿配置，否则可能导致容器启动失败。

```bash

docker run -d \
  --name openlist \
  --restart always \
  -p 5244:5244 \
  -v /data/openlist:/app/data \
  -e ADMIN_PASSWORD="your_secure_password" \  # 示例：自定义管理员密码
  -e LOG_LEVEL="info" \  # 示例：日志级别
  xxx.xuanyuan.run/openlistteam/openlist:latest
```

### 模式二：生产环境部署（Docker Compose + 反向代理）

#### 1. Docker Compose配置（生产推荐，优化资源限制、健康检查与端口安全）

> **生产建议**：请将`docker-compose.yml`纳入Git版本管理，并通过CI/CD流水线控制服务部署与升级，避免人工操作失误。

相比`docker run`，Compose支持版本化管理、配置审计和一键启停，更适合生产环境。创建`docker-compose.yml`文件：

```yaml


version: '3.8'

# 自定义网络，隔离服务
networks:
  openlist-net:
    driver: bridge

# 持久化数据卷
volumes:
  openlist-data:
    driver: local

services:
  openlist:
    image: xxx.xuanyuan.run/openlistteam/openlist:v4.1.9  # 生产环境固定版本
    container_name: openlist
    restart: always
    networks:
      - openlist-net
    volumes:
      - openlist-data:/app/data  # 使用Docker Volume替代宿主机目录，更安全
      # 如需挂载本地存储，需确保权限匹配：- /data/local-storage:/mnt/local:rw
    user: 1001:1001  # 非特权用户运行（需宿主机存在UID/GID=1001的用户）
    # 如仅通过反向代理访问，可删除ports配置，避免服务暴露到宿主机，降低攻击面
    ports:
      - "5244:5244"  # 仅对内网开放，外网通过反向代理访问
    # 资源限制（非Swarm模式兼容写法，替代原deploy.resources）
    mem_limit: 2g
    cpus: 1.0
    # 健康检查（不依赖nc命令，使用原生TCP检测，适配极简镜像）
    healthcheck:
      test: ["CMD-SHELL", "echo > /dev/tcp/localhost/5244 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
    environment:
      - TZ=Asia/Shanghai  # 必选环境变量，统一时区
      # 其他环境变量需确认镜像支持后添加
      # - ADMIN_PASSWORD="your_secure_password"

  # Nginx反向代理（生产环境HTTPS必备）
  nginx:
    image: nginx:alpine
    container_name: openlist-nginx
    restart: always
    networks:
      - openlist-net
    ports:
      - "80:80"   # 仅用于ACME证书申请，生产可关闭
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d  # 反向代理配置
      - ./nginx/ssl:/etc/nginx/ssl        # HTTPS证书
    depends_on:
      - openlist  # 依赖openlist服务启动
```

#### 2. Nginx反向代理配置（补充关键Header）

创建`./nginx/conf.d/openlist.conf`文件：

```nginx

server {
  listen 443 ssl http2;
  server_name file.yourdomain.com;  # 替换为你的域名

  # HTTPS证书配置
  ssl_certificate /etc/nginx/ssl/fullchain.pem;
  ssl_certificate_key /etc/nginx/ssl/privkey.pem;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_prefer_server_ciphers on;

  # 关键Header（修复登录/回调/HTTPS判断异常）
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;

  # 反向代理到openlist容器
  location / {
    proxy_pass http://openlist:5244;
    proxy_connect_timeout 30s;
    proxy_read_timeout 300s;
    proxy_send_timeout 300s;
  }
}

# HTTP重定向到HTTPS（可选）
server {
  listen 80;
  server_name file.yourdomain.com;
  return 301 https://$host$request_uri;
}
```

#### 3. 启动生产环境服务

```bash

# 创建目录结构
mkdir -p ./nginx/conf.d ./nginx/ssl
# 启动服务
docker compose up -d
# 查看状态
docker compose ps
```

### 部署验证

#### 模式一（单容器）验证

```bash

docker ps | grep openlist
```

若状态为`Up`，表示启动成功：

```bash

abc123456789   xxx.xuanyuan.run/openlistteam/openlist:latest   "/entrypoint.sh"   2 minutes ago   Up 2 minutes (healthy)   0.0.0.0:5244->5244/tcp   openlist
```

#### 模式二（Compose）验证

```bash

docker compose logs openlist | grep "Server started"  # 确认服务启动
docker compose exec nginx nginx -t  # 验证Nginx配置
```

## 功能测试

### 服务访问验证

1. **单容器模式**：
 浏览器访问 `http://<服务器IP>:5244`，若看到OPENLIST登录/首页界面，说明服务部署成功。

2. **生产模式**：
 浏览器访问 `https://file.yourdomain.com`（替换为你的域名），验证HTTPS访问和反向代理是否正常。

3. **基础功能测试**：
        

    - 登录验证：使用默认/自定义管理员账号登录系统；

    - 存储配置：添加本地/云存储，验证多存储支持；

    - 文件操作：上传、下载、删除文件，检查核心功能；

    - 界面响应：测试页面切换、搜索功能，验证前端交互。

### 日志验证

若服务无法访问，通过日志排查问题：

```bash

# 单容器模式
docker logs openlist
# Compose模式
docker compose logs openlist
```

关键日志信息：

- 服务启动日志：`Server started on :5244`（确认端口监听）；

- 配置加载日志：`Loaded config from /app/data/config.json`（确认持久化目录正常）；

- 错误日志：`port is already in use`（端口冲突，需修改映射）。

## 生产环境建议

### 数据安全增强

1. **持久化存储优化**：
        

    - 生产环境优先使用`Docker Volume`（如Compose示例中的`openlist-data`），而非直接挂载宿主机目录；

    定期备份数据（规范方式，替代直接修改/etc/crontab）：

    ```bash
    
    # 方式1：使用crontab -e添加定时任务（推荐）
    crontab -e
    # 添加以下内容（每日凌晨2点备份，需提前创建/backup目录）
    # openlist_openlist-data为docker compose自动生成的Volume名称，格式：<项目名>_<Volume名>
    0 2 * * * docker run --rm -v openlist_openlist-data:/source -v /backup:/dest alpine rsync -av /source/ /dest/openlist_$(date +\%Y\%m\%d)/
    
    # 方式2：使用systemd timer（企业级推荐）
    # 参考：https://www.freedesktop.org/software/systemd/man/systemd.timer.html
    ```

2. **权限控制**：
        

    严格使用非特权用户运行容器（如UID/GID=1001），并提前配置宿主机目录权限：

    ```bash
    
    # 若挂载宿主机目录，需匹配容器用户权限
    chown -R 1001:1001 /data/openlist
    chmod 700 /data/openlist
    ```

    - 避免将敏感目录（如`/root`、`/etc`）挂载到容器内。

### 性能与稳定性优化

1. **资源限制**：
        生产环境必须限制容器资源（如Compose示例中的`cpus:1.0`、`mem_limit:2g`），避免占用过多系统资源。

2. **网络优化**：
        

    - 使用Docker自定义网络（如`openlist-net`）隔离服务，避免端口暴露到公网；

    配置Nginx限流、缓存，提升访问性能：

    ```nginx
    
    # 在location /中添加
    limit_req_zone $binary_remote_addr zone=openlist:10m rate=10r/s;
    limit_req zone=openlist burst=20 nodelay;
    proxy_cache_valid 200 304 10m;
    ```

**日志管理**：

```bash

# 单容器模式配置日志轮转
docker run -d \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  ...  # 其他参数
```

### 特殊环境适配

- **SELinux/AppArmor提示**：

若服务器启用SELinux，需为挂载目录添加上下文：

```bash

chcon -Rt svirt_sandbox_file_t /data/openlist
```

若启用AppArmor，需确保Docker配置未限制容器访问挂载目录。

## 升级流程（生产级SOP）

生产环境升级需遵循「备份→停止→拉取→启动→验证」流程，避免数据丢失：

```bash


# 1. 备份数据（关键）
# openlist_openlist-data为docker compose自动生成的Volume名称，格式：<项目名>_<Volume名>
docker run --rm -v openlist_openlist-data:/source -v /backup:/dest alpine rsync -av /source/ /dest/openlist_backup_$(date +\%Y\%m\%d)/

# 2. 停止旧版本服务
docker compose down  # Compose模式
# 单容器模式：docker stop openlist && docker rm openlist

# 3. 拉取新版本镜像（替换为目标版本）
docker pull xxx.xuanyuan.run/openlistteam/openlist:v4.2.0

# 4. 修改配置文件中的镜像版本（Compose模式）
sed -i 's/v1.0.0/v1.0.1/g' docker-compose.yml

# 5. 启动新版本服务
docker compose up -d  # Compose模式
# 单容器模式：重新执行docker run命令（使用新镜像）

# 6. 验证升级结果
# 如涉及业务用户，建议先在测试实例验证新版本，再升级生产环境
docker compose logs openlist | grep "Server started"
```

## 数据目录结构说明

OPENLIST的`/app/data`目录（持久化目录）核心结构：

```bash

/app/data/
├── config.json  # 核心配置文件（存储、用户、端口等）
├── logs/        # 应用日志
├── cache/       # 缓存文件
└── storage/     # 存储挂载临时文件
```

⚠️ 备份时需完整备份该目录，避免配置丢失。

## 故障排查

### 常见问题解决

1. **容器启动后立即退出**：
        

    权限问题：修复挂载目录权限（匹配容器用户UID/GID）：

    ```bash
    
    chown -R 1001:1001 /data/openlist
    ```

    - 端口冲突：使用`netstat -tuln | grep 5244`确认端口是否被其他服务占用，若冲突则修改宿主机端口映射（如`-p 5245:5244`）。

2. **无法访问Web界面**：
        

    网络检查：确认服务器防火墙开放5244/443端口（以CentOS为例）：

    ```bash
    
    firewall-cmd --add-port=443/tcp --permanent && firewall-cmd --reload
    ```

    - 容器IP验证：通过`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' openlist`获取容器IP，在宿主机执行`curl http://<容器IP>:5244`验证服务是否正常。

3. **存储配置后文件不显示**：
        

    - 检查存储路径权限：确保容器对挂载的存储目录有读写权限

    - 查看应用日志：`docker logs openlist | grep storage`，排查存储配置错误（如访问密钥错误、路径不存在等）。

### 高级排查工具

**进入容器调试**：

```bash

docker exec -it openlist /bin/sh  # 进入容器命令行
```

可检查配置文件、依赖库、进程状态等

**容器资源监控**：

```bash

docker stats openlist  # 实时查看CPU、内存、网络IO使用情况
```

若资源占用异常，可能需优化配置或升级服务器规格

## 扩展部署（K8s思路）

生产环境大规模部署可使用Kubernetes：

1. 使用`StatefulSet`部署OPENLIST，确保数据持久化；

2. 通过`ConfigMap`管理配置，`Secret`存储敏感信息（如管理员密码）；

3. 使用`Ingress`替代Nginx反向代理，实现HTTPS和负载均衡；

4. 配置`ResourceQuota`限制资源，`LivenessProbe`/`ReadinessProbe`做健康检查。

（注：K8s完整YAML需根据实际集群配置调整，可参考AList的K8s部署方案适配。）

**⚠️ 声明**：本节仅提供架构思路，不作为可直接套用的生产YAML模板。

## 参考资源

1. **官方文档与镜像信息**：
        

    - [轩辕镜像 - OPENLIST文档](https://xuanyuan.cloud/r/openlistteam/openlist)（镜像使用说明）

    - [OPENLIST镜像标签列表](https://xuanyuan.cloud/r/openlistteam/openlist/tags)（所有可用版本）

2. **Docker相关工具**：
        

    - [Docker官方文档](https://docs.docker.com/)（基础命令与概念）

    - [Docker Compose文档](https://docs.docker.com/compose/)（多容器部署工具）

3. **同类项目参考**：
        

    - [AList官方文档](https://alist.nn.ci/)（OPENLIST上游项目，配置可参考）

## 总结

### 关键点回顾

1. **版本与用户**：生产环境必须使用固定版本标签（如`v1.0.0`），并以非特权用户运行容器；

2. **部署模式**：测试用单容器直出，生产用`Docker Compose + Nginx反向代理 + HTTPS`，可删除容器端口映射进一步降低暴露面；

3. **数据安全**：优先使用Docker Volume持久化数据，定期规范备份，明确Volume名称规则避免新手困惑；

4. **配置严谨性**：容器端口需以镜像实际监听为准，资源限制采用非Swarm兼容写法，健康检查不依赖第三方工具，环境变量需确认官方支持后配置。

### 态度宣言

本文档不追求“一条命令跑起来”的便捷性，而强调**可控、可回滚、可审计**的生产部署方式，确保服务在企业环境中稳定运行，同时满足合规与运维要求。

### 后续建议

- 深入学习OPENLIST官方文档，配置LDAP认证、多用户管理等高级特性；

- 结合对象存储（S3/OSS）实现大规模文件管理；

- 配置监控告警（如Prometheus+Grafana），实时监控服务状态。

通过本文档的指导，你可快速完成OPENLIST的测试部署，并按照企业级规范搭建稳定、安全的生产环境，充分发挥其多存储文件列表的核心优势。

