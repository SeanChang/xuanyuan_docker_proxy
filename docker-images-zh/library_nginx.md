---
image: library/nginx
description: "Nginx 官方 Docker 镜像，提供高性能 Web 服务器和反向代理能力，适合部署静态站点、反向代理和负载均衡入口，可通过挂载配置和静态目录快速搭建统一的 Web 与 API 网关层。"
source: https://xuanyuan.cloud/zh/r/library/nginx
canonical: https://xuanyuan.cloud/zh/r/library/nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/nginx" title="library/nginx Docker 镜像中文简介、标签列表与拉取命令">library/nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nginx 官方 Docker 镜像中文说明

## 一、概述

Nginx 是一款广泛使用的高性能 Web 服务器与反向代理服务器，擅长处理高并发 HTTP 请求，并内置负载均衡、静态资源服务、反向代理、TLS 终止等能力。本镜像由官方维护，预装标准 Nginx 运行环境，适合快速构建：

- 静态网站 / 前端单页应用（SPA）
- 反向代理与 API 网关
- 站点的 HTTPS 入口与负载均衡层

## 二、典型使用场景

- **托管静态站点**：部署文档站、博客或前端构建产物（如 React / Vue / Next.js 的静态导出）。
- **反向代理与负载均衡**：将流量转发到后端应用（Node.js、Java、PHP 等），进行路径路由与健康检查。
- **HTTPS 终止**：Nginx 负责处理 TLS，后端使用 HTTP 通信，简化应用服务配置。

## 三、快速开始

### 1. 最简静态站点示例

假设本地静态文件放在 `/var/www/html`：

```bash
docker run -d \
  --name nginx \
  -p 80:80 \
  -v /var/www/html:/usr/share/nginx/html:ro \
  docker.xuanyuan.run/nginx:latest
```

- 将宿主机 `/var/www/html` 挂载为容器内默认站点目录；
- `:ro` 只读挂载，避免容器意外修改本地文件；
- 访问 `http://<服务器IP>` 即可查看站点内容。

### 2. 使用自定义 Nginx 配置

若需反向代理、负载均衡或多站点配置，一般会自定义 `nginx.conf` 或放在 `conf.d` 中：

```bash
# 假设 /opt/nginx/conf/nginx.conf 为自定义配置

docker run -d \
  --name nginx \
  -p 80:80 \
  -v /opt/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro \
  -v /var/www/html:/usr/share/nginx/html:ro \
  docker.xuanyuan.run/nginx:latest
```

推荐做法是：

- 在宿主机上基于官方默认配置复制一份，再按需修改；
- 将静态资源目录与日志目录（如需）以卷的形式单独挂载。

## 四、反向代理与负载均衡示例

### 1. 简单反向代理

在自定义配置中，将 Nginx 作为后端服务的网关：

```nginx
server {
    listen 80;
    server_name _;

    location /api/ {
        proxy_pass http://backend:8080/;  # backend 为 Docker 网络中的服务名
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

将该配置写入宿主机配置文件后挂载到容器，即可让 Nginx 同时提供前端静态页面和后端 API 入口。

### 2. 多后端负载均衡（示意）

```nginx
upstream app_upstream {
    server app1:8080;
    server app2:8080;
}

server {
    listen 80;
    location / {
        proxy_pass http://app_upstream;
    }
}
```

在 Docker Compose 中只需确保 `nginx`、`app1`、`app2` 在同一个网络下即可。

## 五、模板与环境变量（常见部署模式）

在容器化场景中，常见做法是：

1. 在宿主机或镜像中准备一个带占位符的模板文件（如 `default.conf.template`）；
2. 使用启动脚本或工具将环境变量渲染到模板中；
3. 将生成的配置放入 `/etc/nginx/conf.d/` 后启动 Nginx。

这样的方式适合：

- 在多环境（dev / test / prod）之间切换后端地址、域名或端口；
- 将同一镜像部署到不同租户/站点，仅通过环境变量差异完成配置。

## 六、运维与调试

- **查看日志**：

  ```bash
  docker logs -f nginx
  ```

- **进入容器排查问题**：

  ```bash
  docker exec -it nginx /bin/sh
  ```

- **只读根文件系统场景**：

  可将 `/var/cache/nginx`、`/var/run` 等必须可写目录挂载到数据卷或宿主机目录，使容器根文件系统保持只读，提升安全性。

## 七、选择合适的镜像变体

- **`nginx:<version>`（Debian 默认版）**：功能完整、生态成熟，适合作为通用 Web 入口；
- **`nginx:<version>-alpine`**：体积小，适合对镜像大小敏感的场景；
- **`nginx:<version>-slim`**：进一步裁剪依赖，仅保留运行 Nginx 所需的最小组件。

## 八、适用人群

- 需要快速搭建静态站点或文档服务的开发者；
- 希望为后端应用提供统一入口、反向代理与负载均衡的运维工程师；
- 需要在容器化环境中构建标准化 Web 前端和 API 网关层的团队。
