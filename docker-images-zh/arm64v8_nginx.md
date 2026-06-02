---
image: arm64v8/nginx
description: "Nginx的官方构建版本是一款高性能的HTTP和反向代理服务器，同时也可作为IMAP/POP3/SMTP代理服务器，其官方版本经过严格测试，包含稳定的核心功能及多种扩展模块，广泛应用于网站部署、负载均衡、动静分离等场景，凭借高效的并发处理能力和低资源消耗，成为全球范围内主流的Web服务器解决方案之一。"
source: https://xuanyuan.cloud/zh/r/arm64v8/nginx
canonical: https://xuanyuan.cloud/zh/r/arm64v8/nginx
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [arm64v8/nginx — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/arm64v8/nginx)

含镜像标签、拉取命令、部署文档与相关推荐。

[arm64v8/nginx Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/arm64v8/nginx)

# arm64v8 架构的 nginx 官方 Docker 镜像说明


## 说明  
本仓库是 [nginx 官方镜像]([])针对 `arm64v8` 架构的“按架构拆分”仓库。更多信息可参考官方镜像文档中的[“非 amd64 架构说明”]([])和 FAQ 中的[“镜像源码在 Git 中变更后如何处理？”]([])。


## 快速参考  

### 维护方  
[NGINX Docker 维护团队]([])  

### 帮助支持  
可通过 [Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([]) 获取帮助。  


## 支持的标签及对应 Dockerfile 链接  

- **基础版（Debian）**  
  [`1.29.2`, `mainline`, `1`, `1.29`, `latest`, `1.29.2-trixie`, `mainline-trixie`, `1-trixie`, `1.29-trixie`, `trixie`]([])  

- **Perl 模块版（Debian）**  
  [`1.29.2-perl`, `mainline-perl`, `1-perl`, `1.29-perl`, `perl`, `1.29.2-trixie-perl`, `mainline-trixie-perl`, `1-trixie-perl`, `1.29-trixie-perl`, `trixie-perl`]([])  

- **OpenTelemetry 版（Debian）**  
  [`1.29.2-otel`, `mainline-otel`, `1-otel`, `1.29-otel`, `otel`, `1.29.2-trixie-otel`, `mainline-trixie-otel`, `1-trixie-otel`, `1.29-trixie-otel`, `trixie-otel`]([])  

- **Alpine 基础版**  
  [`1.29.2-alpine`, `mainline-alpine`, `1-alpine`, `1.29-alpine`, `alpine`, `1.29.2-alpine3.22`, `mainline-alpine3.22`, `1-alpine3.22`, `1.29-alpine3.22`, `alpine3.22`]([])  

- **Alpine Perl 模块版**  
  [`1.29.2-alpine-perl`, `mainline-alpine-perl`, `1-alpine-perl`, `1.29-alpine-perl`, `alpine-perl`, `1.29.2-alpine3.22-perl`, `mainline-alpine3.22-perl`, `1-alpine3.22-perl`, `1.29-alpine3.22-perl`, `alpine3.22-perl`]([])  

- **Alpine 精简版**  
  [`1.29.2-alpine-slim`, `mainline-alpine-slim`, `1-alpine-slim`, `1.29-alpine-slim`, `alpine-slim`, `1.29.2-alpine3.22-slim`, `mainline-alpine3.22-slim`, `1-alpine3.22-slim`, `1.29-alpine3.22-slim`, `alpine3.22-slim`]([])  

- **Alpine OpenTelemetry 版**  
  [`1.29.2-alpine-otel`, `mainline-alpine-otel`, `1-alpine-otel`, `1.29-alpine-otel`, `alpine-otel`, `1.29.2-alpine3.22-otel`, `mainline-alpine3.22-otel`, `1-alpine3.22-otel`, `1.29-alpine3.22-otel`, `alpine3.22-otel`]([])  

- **稳定版（Debian bookworm）**  
  [`1.28.0`, `stable`, `1.28`, `1.28.0-bookworm`, `stable-bookworm`, `1.28-bookworm`]([])（及对应 `-perl`、`-otel`、Alpine 变体，标签列表略，可参考上方链接结构）  


## 快速参考（续）  

### 问题反馈  
[[]]([])  

### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm32v5`]([])、[`arm32v6`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`i386`]([])、[`mips64le`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])  

### 镜像 artifact 详情  
[repo-info 仓库的 `repos/nginx/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  

### 镜像更新  
[official-images 仓库的 `library/nginx` 标签]([])  
[official-images 仓库的 `library/nginx` 文件]([])（[历史记录]([])）  

### 本文档来源  
[docs 仓库的 `nginx/` 目录]([])（[历史记录]([])）  


## 什么是 nginx？  
Nginx（发音“engine-x”）是一款开源的反向代理服务器，支持 HTTP、HTTPS、SMTP、POP3、IMAP 等协议，同时具备负载均衡、HTTP 缓存和 Web 服务器（源服务器）功能。其设计初衷是高并发、高性能和低内存占用，采用 2 条款 BSD 类许可证，可运行于 Linux、BSD 变体、macOS、Solaris、AIX、HP-UX 等类 Unix 系统，也提供 Windows 实验性版本。  

> 更多信息：[.org/wiki/Nginx]()  

![nginx  logo]([])  


## 如何使用本镜像  


### 托管静态内容  
通过挂载目录将本地静态文件映射到容器中：  
```console
$ docker run --name some-nginx -v /本地/静态文件目录:/usr/share/nginx/html:ro -d arm64v8/nginx
```  

或通过 Dockerfile 构建包含静态文件的自定义镜像（更推荐）：  
```dockerfile
FROM arm64v8/nginx
COPY 本地静态文件目录 /usr/share/nginx/html
```  
构建并运行：  
```console
$ docker build -t some-content-nginx .
$ docker run --name some-nginx -d some-content-nginx
```  


### 暴露外部端口  
将容器内 80 端口映射到主机 8080 端口：  
```console
$ docker run --name some-nginx -d -p 8080:80 some-content-nginx
```  
之后可通过 `[] 或 `[] 访问。  


### 自定义配置  
可通过挂载配置文件或构建新镜像实现自定义配置。  

#### 获取默认配置文件（用于修改）：  
```console
$ docker run --rm --entrypoint=cat arm64v8/nginx /etc/nginx/nginx.conf > /本地路径/nginx.conf
```  
修改本地 `nginx.conf` 后，可通过以下方式使用：  

#### 挂载自定义配置文件：  
```console
$ docker run --name my-custom-nginx -v /本地路径/nginx.conf:/etc/nginx/nginx.conf:ro -d arm64v8/nginx
```  

#### 构建包含自定义配置的镜像：  
```dockerfile
FROM arm64v8/nginx
COPY nginx.conf /etc/nginx/nginx.conf
```  
> 若自定义 `CMD`，需包含 `-g daemon off;` 确保 nginx 前台运行，避免容器启动后立即退出。  

构建并运行：  
```console
$ docker build -t custom-nginx .
$ docker run --name my-custom-nginx -d custom-nginx
```  


### 在配置中使用环境变量（1.19 版本新增）  
默认情况下，nginx 配置文件中多数区块不支持环境变量，但本镜像提供了启动前提取环境变量的功能。  

**示例（使用 compose.yaml）**：  
```yaml
web:
  image: arm64v8/nginx
  volumes:
   - ./templates:/etc/nginx/templates  # 挂载模板目录
  ports:
   - "8080:80"
  environment:
   - NGINX_HOST=foobar.com
   - NGINX_PORT=80
```  

**模板文件规则**：  
- 默认读取 `/etc/nginx/templates/*.template` 文件，通过 `envsubst` 替换变量后输出到 `/etc/nginx/conf.d`。  
- 例如，模板文件 `templates/default.conf.template` 中包含 `listen ${NGINX_PORT};`，最终会生成 `listen 80;` 并保存到 `/etc/nginx/conf.d/default.conf`。  

**可通过环境变量调整行为**：  
- `NGINX_ENVSUBST_TEMPLATE_DIR`：模板文件目录（默认 `/etc/nginx/templates`，目录不存在时不处理模板）。  
- `NGINX_ENVSUBST_TEMPLATE_SUFFIX`：模板文件后缀（默认 `.template`）。  
- `NGINX_ENVSUBST_OUTPUT_DIR`：输出目录（默认 `/etc/nginx/conf.d`，需容器用户可写）。  


### 以只读模式运行  
需挂载可写卷到 nginx 写入目录（默认 `/var/cache/nginx` 和 `/var/run`）：  
```console
$ docker run -d -p 80:80 --read-only -v $(pwd)/nginx-cache:/var/cache/nginx -v $(pwd)/nginx-pid:/var/run arm64v8/nginx
```  


### 调试模式运行  
1.9.8 及以上版本包含 `nginx-debug` 二进制，可输出详细日志：  
```console
$ docker run --name my-nginx -v /本地路径/nginx.conf:/etc/nginx/nginx.conf:ro -d arm64v8/nginx nginx-debug -g 'daemon off;'
```  


### 关闭入口点日志（1.19.0 版本新增）  
设置环境变量 `NGINX_ENTRYPOINT_QUIET_LOGS` 可关闭启动时的详细日志输出：  
```console
$ docker run -d -e NGINX_ENTRYPOINT_QUIET_LOGS=1 arm64v8/nginx
```  


### 用户与组 ID  
1.17.0 及以上版本中，Alpine 和 Debian 变体均使用相同的用户/组 ID（`uid=101(nginx), gid=101(nginx)`）运行工作进程。  


### 以非 root 用户运行  
需修改 nginx 配置，将写入目录指向非 root 用户可写路径（如 `/tmp`）：  
```nginx
pid        /tmp/nginx.pid;  # 全局配置
http {
    client_body_temp_path /tmp/client_temp;  # HTTP 上下文
    proxy_temp_path       /tmp/proxy_temp;
    # ... 其他临时目录（fastcgi_temp、uwsgi_temp 等）
}
```  
运行命令：  
```console
$ docker run -d -v $PWD/nginx.conf:/etc/nginx/nginx.conf arm64v8/nginx
```  
> 也可直接使用官方 [nginx-unprivileged 镜像]([])。  


## 镜像变体  

### `arm64v8/nginx:<version>`  
默认镜像，适合大多数场景。标签中含 `bookworm`/`trixie` 等名称时，表示基于对应 Debian 发行版构建，如需安装额外依赖，建议显式指定发行版标签以减少兼容性问题。  

### `arm64v8/nginx:<version>-perl` / `-alpine-perl`  
包含 Perl 模块的变体（1.13.0 主线版/1.12.0 稳定版起，Perl 模块从默认镜像中移除）。  

### `arm64v8/nginx:<version>-alpine`  
基于 Alpine Linux，镜像体积更小（约 5MB 基础镜像），但使用 musl libc 可能与部分依赖 glibc 的软件不兼容。适合对镜像大小敏感的场景。  

### `arm64v8/nginx:<version>-slim`  
仅包含运行 nginx 所需的最小依赖，不含默认镜像中的常见工具。除非有严格空间限制，否则推荐使用默认镜像。  


## 许可证  
镜像中软件的许可证信息可查看 [nginx 官方许可证]([])。  
Docker 镜像可能包含其他软件（如基础系统的 Bash 等），其许可证可能不同。可在 [repo-info 仓库的 `nginx/` 目录]([]) 查看自动检测的附加许可证信息。  
使用前请确保遵守所有包含软件的许可证要求。
