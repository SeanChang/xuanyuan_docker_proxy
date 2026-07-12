---
image: webdevops/nginx
description: "Nginx容器，提供高性能的Web服务器和反向代理功能，适用于部署静态网站、API服务及反向代理场景，由WebDevOps构建测试，支持灵活配置。"
source: https://xuanyuan.cloud/zh/r/webdevops/nginx
canonical: https://xuanyuan.cloud/zh/r/webdevops/nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/webdevops/nginx" title="webdevops/nginx Docker 镜像中文简介、标签列表与拉取命令">webdevops/nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nginx镜像

## 镜像概述和主要用途
本镜像为Nginx容器化部署方案，由[WebDevOps Build Server](https://build.webdevops.io/)构建并测试，提供高性能的Web服务器和反向代理能力。适用于快速部署静态资源服务、API接口反向代理、负载均衡前端节点等场景，支持通过环境变量或配置文件自定义服务参数。

## 核心功能和特性
- **高性能Web服务**：支持HTTP/HTTPS协议，优化静态文件传输性能
- **反向代理与负载均衡**：可配置后端服务代理及简单负载均衡策略
- **灵活配置**：支持环境变量注入基础配置，或通过卷挂载自定义Nginx配置文件
- **稳定性保障**：由WebDevOps构建系统持续集成测试，确保镜像兼容性和稳定性
- **轻量级设计**：基于精简基础镜像，减少资源占用

## 使用场景和适用范围
- 静态网站部署（HTML、CSS、JavaScript、图片等资源）
- API服务反向代理（对接后端微服务或独立API接口）
- 负载均衡前端节点（分发请求至多个后端实例）
- 开发/测试环境Web服务器模拟
- 微服务架构中的边缘网关

## 使用方法和配置说明

### 基本部署（docker run）
```bash
# 启动基础Nginx服务，映射80端口
docker run -d -p 80:80 --name nginx-web docker.xuanyuan.run/webdevops/nginx
```

### 挂载自定义配置文件
```bash
# 将本地配置文件挂载至容器配置目录（推荐）
docker run -d -p 80:80 \
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
  -v $(pwd)/conf.d:/etc/nginx/conf.d \
  --name nginx-custom docker.xuanyuan.run/webdevops/nginx
```

### docker-compose配置示例
```yaml
version: '3'
services:
  nginx:
    image: docker.xuanyuan.run/webdevops/nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./conf.d:/etc/nginx/conf.d  # 挂载站点配置
      - ./static:/usr/share/nginx/html  # 挂载静态资源
    environment:
      - NGINX_HOST=example.com  # 默认主机名
      - NGINX_PORT=80  # 默认监听端口
    restart: always
```

### 配置说明
- **环境变量**：支持通过环境变量设置基础参数（如`NGINX_HOST`默认主机名、`NGINX_PORT`监听端口等），具体变量列表见[官方文档](http://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/nginx.html)
- **配置文件路径**：主配置文件位于`/etc/nginx/nginx.conf`，站点配置推荐放在`/etc/nginx/conf.d/`目录（支持`.conf`后缀文件自动加载）
- **日志输出**：访问日志和错误日志默认输出至容器标准输出，可通过`docker logs <容器名>`查看

## 文档和支持
- **详细文档**：包含标签说明、环境变量列表等完整配置指南，参见[ReadTheDocs.io](http://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/nginx.html)
- **社区支持**：通过[Slack](https://webdevops.io/slack/)获取技术支持和镜像更新信息
