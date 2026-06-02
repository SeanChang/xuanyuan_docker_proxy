---
image: bitnami/nginx
description: "Bitnami Nginx安全镜像是由Bitnami提供的预配置、安全加固且高度优化的软件包，专为快速部署稳定可靠的Nginx Web服务器环境而设计，集成了自动安全更新、漏洞修复机制及合规性支持，可有效简化服务器配置流程，保障Web应用在生产环境中的安全性与高性能，适用于各类Web服务场景如静态资源托管、反向代理及负载均衡等。"
source: https://xuanyuan.cloud/zh/r/bitnami/nginx
canonical: https://xuanyuan.cloud/zh/r/bitnami/nginx
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/nginx" title="bitnami/nginx Docker 镜像中文简介、标签列表与拉取命令">bitnami/nginx — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/nginx" title="bitnami/nginx Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/nginx</a>

# Bitnami NGINX Open Source 软件包


## 什么是 NGINX Open Source？

NGINX Open Source 是一款 Web 服务器，同时可作为反向代理、负载均衡器和 HTTP 缓存使用。因其能提供更快的内容传输能力，适用于高需求网站。

[NGINX Open Source 概述]([])  
**商标说明**：本软件包由 Bitnami 打包，提及的商标分属各自公司所有，使用不代表关联或背书。


## 快速启动

```console
docker run --name nginx bitnami/nginx:latest
```

这是由 Bitnami 构建和维护的强化、最小化 CVE 镜像。Bitnami Secure Images（BSI）基于云优化、安全强化的企业级操作系统 [Photon Linux]([])。选择 BSI 镜像的理由：  
- 热门开源软件的强化安全镜像，漏洞接近零  
- 漏洞分类与优先级划分，支持 VEX 声明、KEV 和 EPSS 评分  
- 合规性支持，包括 FIPS、STIG、离线部署选项及安全物料清单（SBOM）  
- 通过 in-toto 提供软件供应链溯源证明  
- 原生支持主流 Helm 图表  


## 在 Kubernetes 中部署 NGINX Open Source

通过 Helm Charts 部署 Bitnami 应用是在 Kubernetes 上快速启动的最简单方式。详见 [Bitnami NGINX Open Source Chart GitHub 仓库]([])。


## 为什么使用非 root 容器？

非 root 容器增加了一层安全防护，通常推荐用于生产环境。但由于以非 root 用户运行，特权操作通常受限。详见 [相关文档]([])。


## 支持的标签及对应 Dockerfile 链接

了解 Bitnami 标签策略（滚动标签与不可变标签的区别），可参考 [文档]([])。标签对应关系可查看分支文件夹中的 `tags-info.yaml` 文件（如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）。


## 获取镜像

### 拉取预构建镜像
推荐从 [Docker Hub Registry]([]) 拉取预构建镜像：
```console
docker pull bitnami/nginx:latest  # 最新版本
```
如需特定版本，拉取带版本标签的镜像（查看 [可用版本列表]([])）：
```console
docker pull bitnami/nginx:[TAG]  # 替换 [TAG] 为具体版本
```

### 手动构建镜像
克隆仓库后构建：
```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM  # 替换占位符为实际值
docker build -t bitnami/APP:latest .
```


## 托管静态网站

镜像暴露 `/app` 目录作为卷，挂载至此的内容会通过默认服务器块提供服务：
```console
docker run -v /本地路径/app:/app bitnami/nginx:latest
```
或修改 `docker-compose.yml`：
```yaml
services:
  nginx:
    ...
    volumes:
      - /本地路径/app:/app  # 本地静态文件目录映射到容器内/app
    ...
```


## 从主机访问服务器

### 随机端口映射
让 Docker 将容器的 8080/8443 端口映射到主机随机端口：
```console
docker run --name nginx -P bitnami/nginx:latest
```
用 `docker port` 查看映射的主机端口：
```console
docker port nginx  # 示例输出：8080/tcp -> 0.0.0.0:32769
```

### 指定端口映射
手动指定主机端口（如主机 9000 端口映射到容器 8080 端口）：
```console
docker run -p 9000:8080 bitnami/nginx:latest
```
访问 `[] 即可打开网站。


## 配置

### 添加自定义服务器块
默认 `nginx.conf` 会包含 `/opt/bitnami/nginx/conf/server_blocks/` 目录下的配置文件，按以下步骤添加：

#### 步骤 1：创建服务器块配置文件
例如 `my_server_block.conf`：
```nginx
server {
  listen 0.0.0.0:8080;
  server_name www.example.com;  # 自定义域名
  root /app;  # 静态文件目录
  index index.htm index.html;
}
```

#### 步骤 2：挂载配置文件
```console
docker run --name nginx \
  -v /本地路径/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro \
  bitnami/nginx:latest
```
或修改 `docker-compose.yml`：
```yaml
services:
  nginx:
    ...
    volumes:
      - /本地路径/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_server_block.conf:ro
    ...
```


### 按上下文添加自定义配置
默认 `nginx.conf` 支持按 NGINX 上下文组织配置文件，挂载到对应目录即可：
- `/opt/bitnami/nginx/conf/context.d/main/`：main 上下文（如模块加载、worker 进程）
- `/opt/bitnami/nginx/conf/context.d/events/`：events 上下文（如 worker_connections）
- `/opt/bitnami/nginx/conf/context.d/http/`：http 上下文（等效于 server_blocks）

**示例**：启用 WebDAV 模块  
创建 `webdav.conf`：
```nginx
load_module /opt/bitnami/nginx/modules/ngx_http_dav_module.so;
```
挂载到 main 上下文目录：
```console
docker run --name nginx \
  -v /本地路径/webdav.conf:/opt/bitnami/nginx/conf/context.d/main/webdav.conf:ro \
  bitnami/nginx:latest
```


### 添加流服务器块
如需使用 [NGINX Stream Core Module]([])，需将流服务器块配置文件挂载到 `/opt/bitnami/nginx/conf/stream_server_blocks/`，并设置环境变量 `NGINX_ENABLE_STREAM=yes`。

#### 步骤 1：创建流服务器块配置
例如 `my_stream_server_block.conf`：
```nginx
upstream backend {
    hash $remote_addr consistent;
    server backend1.example.com:12345 weight=5;
    server 127.0.0.1:12345 max_fails=3 fail_timeout=30s;
}
server {
    listen 12345;
    proxy_connect_timeout 1s;
    proxy_timeout 3s;
    proxy_pass backend;
}
```

#### 步骤 2：运行容器
```console
docker run --name nginx \
  -e NGINX_ENABLE_STREAM=yes \
  -v /本地路径/my_stream_server_block.conf:/opt/bitnami/nginx/conf/stream_server_blocks/my_stream_server_block.conf:ro \
  bitnami/nginx:latest
```


### 使用自定义 SSL 证书
#### 步骤 1：准备证书文件
本地创建 `certs` 目录，将证书重命名为 `tls.crt` 和 `tls.key`：
```console
mkdir -p /本地路径/nginx-persistence/certs
cp /证书路径/certfile.crt /本地路径/nginx-persistence/certs/tls.crt
cp /证书路径/keyfile.key /本地路径/nginx-persistence/certs/tls.key
```

#### 步骤 2：创建 SSL 服务器块配置
例如 `my_ssl_server_block.conf`：
```nginx
server {
  listen 8443 ssl;
  ssl_certificate      bitnami/certs/tls.crt;  # 容器内证书路径
  ssl_certificate_key  bitnami/certs/tls.key;
  ssl_session_cache    shared:SSL:1m;
  ssl_session_timeout  5m;
  ssl_ciphers  HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers  on;
  location / {
    root   html;
    index  index.html index.htm;
  }
}
```

#### 步骤 3：运行容器挂载证书
```console
docker run --name nginx \
  -v /本地路径/my_ssl_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/my_ssl_server_block.conf:ro \
  -v /本地路径/nginx-persistence/certs:/certs \  # 本地证书目录映射到容器/certs
  bitnami/nginx:latest
```


### 解决重定向问题
默认重定向为相对路径，可通过环境变量调整：
- `NGINX_ENABLE_ABSOLUTE_REDIRECT=yes`：启用绝对路径重定向（需注意端口）
- `NGINX_ENABLE_PORT_IN_REDIRECT=yes`：重定向 URL 包含容器监听端口（需容器与主机端口一致）

**示例**：启用绝对重定向并包含端口  
```console
docker run --name nginx -p 9000:9000 \  # 主机与容器端口一致
  -v /本地路径/my_redirect.conf:/opt/bitnami/nginx/conf/server_blocks/my_redirect.conf:ro \
  -e NGINX_ENABLE_ABSOLUTE_REDIRECT=yes \
  -e NGINX_ENABLE_PORT_IN_REDIRECT=yes \
  -e NGINX_HTTP_PORT_NUMBER=9000 \  # 容器监听端口
  bitnami/nginx:latest
```


### 完整配置
通过挂载自定义 `nginx.conf` 覆盖默认配置：
```console
docker run --name nginx \
  -v /本地路径/your_nginx.conf:/opt/bitnami/nginx/conf/nginx.conf:ro \
  bitnami/nginx:latest
```


### FIPS 配置（Bitnami Secure Images）
Bitnami 安全镜像支持 FIPS 模式，通过环境变量配置：
- `OPENSSL_FIPS=yes`（默认）：启用 FIPS 模式
- `OPENSSL_FIPS=no`：禁用 FIPS 模式


## 反向代理到其他容器
通过 Docker 链接功能，NGINX 可反向代理到其他容器。示例服务器块配置（保存为 `proxy_server_block.conf`）：
```nginx
server {
  listen 0.0.0.0:8080;
  server_name yourapp.com;
  access_log /opt/bitnami/nginx/logs/yourapp_access.log;
  error_log /opt/bitnami/nginx/logs/yourapp_error.log;
  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header HOST $http_host;
    proxy_set_header X-NginX-Proxy true;
    proxy_pass []]:[容器端口];  # 替换为目标容器信息
    proxy_redirect off;
  }
}
```
挂载配置文件并运行容器即可。


## 日志
容器日志输出到 `stdout`，通过以下命令查看：
```console
docker logs nginx  # 单个容器
docker-compose logs nginx  # Docker Compose 环境
```
可通过 `--log-driver` 选项配置 [日志驱动]([])。


## 自定义镜像

### 扩展基础镜像
若通过环境变量、自定义配置文件等方式无法满足需求，可基于 `bitnami/nginx` 构建自定义镜像。示例 `Dockerfile`：
```Dockerfile
FROM bitnami/nginx

# 安装 vim 编辑器（需 root 权限）
USER 0
RUN install_packages vim
USER 1001  # 恢复非 root 用户

# 修改 NGINX 配置（worker_connections 设为 512）
RUN sed -i -r "s#(\s+worker_connections\s+)[0-9]+;#\1512;#" /opt/bitnami/nginx/conf/nginx.conf

# 修改默认端口
ENV NGINX_HTTP_PORT_NUMBER=8181
EXPOSE 8181 8143  # 暴露新端口
```


### 添加自定义 NGINX 模块
需编译 NGINX 并复制模块文件到基础镜像。示例：添加 Perl 模块（`ngx_http_perl_module`）的 `Dockerfile`：
```Dockerfile
ARG NGINX_VERSION=1.25.0
ARG BITNAMI_NGINX_TAG=${NGINX_VERSION}-debian-12-r0

# 构建阶段：编译 Perl 模块
FROM bitnami/nginx:${BITNAMI_NGINX_TAG} AS builder
USER root
ARG NGINX_VERSION
RUN install_packages dirmngr gpg curl build-essential libpcre3-dev zlib1g-dev libperl-dev
RUN gpg --keyserver pgp.mit.edu --recv-key 520A9993A1C052F8
RUN cd /tmp && \
  curl -O []}.tar.gz && \
  curl -O []}.tar.gz.asc && \
  gpg --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz && \
  tar xzf nginx-${NGINX_VERSION}.tar.gz
RUN cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure --prefix=/opt/bitnami/nginx --with-compat --with-http_perl_module=dynamic && \
  make && make install

# 最终镜像：复制模块并启用
FROM bitnami/nginx:${BITNAMI_NGINX_TAG}
USER root
RUN install_packages libperl-dev
COPY --from=builder /opt/bitnami/nginx/modules/ngx_http_perl_module.so /opt/bitnami/nginx/modules/
RUN echo "load_module modules/ngx_http_perl_module.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
  cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
USER 1001
```


## 参考链接
- [NGINX Open Source 官方网站]([])
- [Bitnami NGINX Helm Chart]([])
- [Bitnami 容器标签策略]([])
- [非 root 容器文档]([])
