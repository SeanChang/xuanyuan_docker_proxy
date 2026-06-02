---
image: library/caddy
description: "Caddy 2是一款采用Go语言编写的功能强大、企业级就绪的开源Web服务器，其核心特性包括自动HTTPS功能，能够为网站提供便捷且安全的加密连接，适用于从个人项目到大型企业应用的各类场景，凭借轻量级架构和高效性能，成为Web服务部署的理想选择。"
source: https://xuanyuan.cloud/zh/r/library/caddy
canonical: https://xuanyuan.cloud/zh/r/library/caddy
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/caddy" title="library/caddy Docker 镜像中文简介、标签列表与拉取命令">library/caddy — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/caddy" title="library/caddy Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/caddy</a>

# Caddy Docker 镜像使用指南


## 快速参考

### 维护者  
[Caddy Docker 维护团队]([])  

### 获取帮助  
[Caddy 社区论坛]([])  


## 支持的标签及对应 Dockerfile 链接  

（关于“Shared 标签”和“Simple 标签”的区别，参见 [FAQ]([])）  


### Simple 标签  

- [`2.10.2-alpine`, `2.10-alpine`, `2-alpine`, `alpine`]([])  
- [`2.10.2-builder-alpine`, `2.10-builder-alpine`, `2-builder-alpine`, `builder-alpine`]([])  
- [`2.10.2-windowsservercore-ltsc2022`, `2.10-windowsservercore-ltsc2022`, `2-windowsservercore-ltsc2022`, `windowsservercore-ltsc2022`]([])  
- [`2.10.2-windowsservercore-ltsc2025`, `2.10-windowsservercore-ltsc2025`, `2-windowsservercore-ltsc2025`, `windowsservercore-ltsc2025`]([])  
- [`2.10.2-builder-windowsservercore-ltsc2022`, `2.10-builder-windowsservercore-ltsc2022`, `2-builder-windowsservercore-ltsc2022`, `builder-windowsservercore-ltsc2022`]([])  
- [`2.10.2-builder-windowsservercore-ltsc2025`, `2.10-builder-windowsservercore-ltsc2025`, `2-builder-windowsservercore-ltsc2025`, `builder-windowsservercore-ltsc2025`]([])  


### Shared 标签  

- `2.10.2`, `2.10`, `2`, `latest`:  
  - [`2.10.2-alpine`]([])  
  - [`2.10.2-windowsservercore-ltsc2022`]([])  
  - [`2.10.2-windowsservercore-ltsc2025`]([])  

- `2.10.2-builder`, `2.10-builder`, `2-builder`, `builder`:  
  - [`2.10.2-builder-alpine`]([])  
  - [`2.10.2-builder-windowsservercore-ltsc2022`]([])  
  - [`2.10.2-builder-windowsservercore-ltsc2025`]([])  

- `2.10.2-windowsservercore`, `2.10-windowsservercore`, `2-windowsservercore`, `windowsservercore`:  
  - [`2.10.2-windowsservercore-ltsc2022`]([])  
  - [`2.10.2-windowsservercore-ltsc2025`]([])  


## 快速参考（续）  

### 问题反馈  
[[]]([])  

### 支持的架构  
（[更多信息]([])）  
[`amd64`]([]), [`arm32v6`]([]), [`arm32v7`]([]), [`arm64v8`]([]), [`ppc64le`]([]), [`riscv64`]([]), [`s390x`]([]), [`windows-amd64`]([])  

### 镜像详情  
[repo-info 仓库的 `repos/caddy/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  

### 镜像更新  
[official-images 仓库的 `library/caddy` 标签]([])  
[official-images 仓库的 `library/caddy` 文件]([])（[历史记录]([])）  

### 本文档来源  
[docs 仓库的 `caddy/` 目录]([])（[历史记录]([])）  

![logo]([])  


## 什么是 Caddy？  

[Caddy 2]([]) 是一款功能强大、企业级的开源 Web 服务器，支持自动 HTTPS，使用 Go 语言编写。  


## 如何使用本镜像  

### 注意：持久化数据说明  
Caddy 需要对两个目录有写入权限：[数据目录]([]) 和 [配置目录]([])。配置目录的文件无需持久化，但数据目录必须持久化——**数据目录不可视为缓存，其内容（如 TLS 证书、私钥、OCSP 装订等）对 Caddy 运行至关重要，删除前需了解潜在风险**。  

本镜像提供两个卷挂载点：`/data`（数据目录）和 `/config`（配置目录）。下文示例中均使用命名卷 `caddy_data` 挂载 `/data`，以确保数据持久化。命名卷可跨容器重启/终止保留数据，升级镜像时可复用。  


### 基本用法  

默认配置文件会从 `/usr/share/caddy` 提供文件服务。若需从当前目录提供 `index.html`：  

```console
$ echo "hello world" > index.html
$ docker run -d -p 80:80 \
    -v $PWD/index.html:/usr/share/caddy/index.html \
    -v caddy_data:/data \
    caddy
...
$ curl [] world
```

若需自定义 [`Caddyfile`]([])，可在当前目录创建 `conf` 子目录并放入 `Caddyfile`，然后将 `conf` 目录挂载到 `/etc/caddy`：  

```console
$ docker run -d -p 80:80 \
    -v $PWD/conf:/etc/caddy \
    -v caddy_data:/data \
    caddy
```

#### 注意：不要直接挂载 Caddyfile 到 `/etc/caddy/Caddyfile`  
使用 vim 等会修改文件 inode 的编辑器时，容器内文件仅在容器重建后才会更新（详见 [Medium 文章]()）。这可能导致 Caddy 优雅重载功能异常（参考 [issue]([])）。  


### 自动 TLS 配置  
默认 `Caddyfile` 仅监听 80 端口，不启用自动 TLS。若拥有域名且 DNS A/AAAA 记录已指向服务器公网 IP，可通过以下命令启用 HTTPS：  

```console
$ docker run -d --cap-add=NET_ADMIN -p 80:80 -p 443:443 -p 443:443/udp \
    -v /site:/srv \
    -v caddy_data:/data \
    -v caddy_config:/config \
    caddy caddy file-server --domain example.com
```

关键：Caddy 需监听 80 和 443 端口（ACME HTTP 挑战必需）。更多自动 HTTPS 信息见 [Caddy 文档]([])。  


### 构建自定义 Caddy 镜像  
生产环境通常不建议挂载文件，而是基于 `caddy` 镜像构建自定义镜像：  

```Dockerfile
# 注意：生产环境不要使用 :latest 标签
FROM caddy:<version>

COPY Caddyfile /etc/caddy/Caddyfile
COPY site /srv
```

#### 添加自定义 Caddy 模块  
Caddy 支持通过[模块]([])扩展功能（模块列表见 [Caddy 下载页]([])）。可使用 `:builder` 镜像快速构建含自定义模块的 Caddy 二进制文件：  

```Dockerfile
FROM caddy:<version>-builder AS builder

RUN xcaddy build \
    --with github.com/caddyserver/nginx-adapter \
    --with github.com/hairyhenderson/caddy-teapot-module@v0.0.3-0

FROM caddy:<version>

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
```

上述示例通过第二个 `FROM` 指令将构建好的二进制文件覆盖到基础镜像，大幅减小最终镜像体积。`xcaddy` 工具用于构建含指定模块的 Caddy（支持指定模块版本，格式为 `模块名@版本`），标准模块（[`github.com/caddyserver/caddy/master/modules/standard`]([])）默认包含。  


### 优雅重载配置  
Caddy 支持零停机重载配置，通过 `caddy reload` 命令实现。Docker 环境下，推荐在运行中容器内执行该命令：  

1. 获取容器 ID/名称：  
   ```console
   $ caddy_container_id=$(docker ps | grep caddy | awk '{print $1;}')
   ```  
2. 在容器内执行重载（工作目录设为 `/etc/caddy` 以自动找到 Caddyfile）：  
   ```console
   $ docker exec -w /etc/caddy $caddy_container_id caddy reload
   ```  


### Linux  capabilities  
Caddy 默认启用 HTTP/3 支持。为提升 UDP 协议性能，底层 quic-go 库需调整 socket 缓冲区大小，`NET_ADMIN` 权限可允许其覆盖系统默认限制（无需修改内核参数）。该权限为可选，潜在安全影响参考 [Unix Stack Exchange]([])。更多信息见 [quic-go 文档]([])。  


### Docker Compose 示例  
若使用 `docker compose`，可创建 `compose.yaml` 文件，假设自定义 Caddyfile 位于 `$PWD/conf`：  

```yaml
services:
  caddy:
    image: caddy:<version>
    restart: unless-stopped
    cap_add:
      - NET_ADMIN  # 可选，用于 HTTP/3 性能优化
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"  # HTTP/3 需开放 UDP 443
    volumes:
      - $PWD/conf:/etc/caddy  # 挂载自定义配置
      - $PWD/site:/srv        # 网站文件
      - caddy_data:/data      # 持久化数据
      - caddy_config:/config  # 配置目录（可选持久化）

volumes:
  caddy_data:
  caddy_config:
```

通过以下命令重载配置：  
```console
$ docker compose exec -w /etc/caddy caddy caddy reload
```  


## 镜像变体  

### `caddy:<version>`  
默认镜像，适合大多数场景，可直接运行或作为基础镜像构建自定义镜像。  


### `caddy:<version>-alpine`  
基于 [Alpine Linux]([])（[`alpine` 官方镜像]([])），体积极小（~5MB），适合对镜像大小敏感的场景。注意：使用 musl libc 而非 glibc，部分依赖 glibc 的软件可能存在兼容性问题（参考 [对比]([])）。  


### `caddy:<version>-windowsservercore`  
基于 [Windows Server Core]([])，仅支持 Windows 10 专业版/企业版（周年更新及以上）或 Windows Server 2016 及以上环境。  


## 许可证  

本镜像包含软件的许可证信息见 [Caddy 许可证]([])。  
Docker 镜像可能包含其他软件（如基础系统的 Bash 等），其许可证需用户自行确认合规
