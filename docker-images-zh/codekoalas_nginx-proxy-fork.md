---
image: codekoalas/nginx-proxy-fork
description: "这是jwilder/nginx-proxy的分叉镜像，集成nginx和docker-gen工具，自动生成反向代理配置并在容器启停时重载nginx，简化多容器服务的反向代理管理与动态路由。"
source: https://xuanyuan.cloud/zh/r/codekoalas/nginx-proxy-fork
canonical: https://xuanyuan.cloud/zh/r/codekoalas/nginx-proxy-fork
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/codekoalas/nginx-proxy-fork" title="codekoalas/nginx-proxy-fork Docker 镜像中文简介、标签列表与拉取命令">codekoalas/nginx-proxy-fork 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# codekoalas/nginx-proxy-fork 镜像文档

## 镜像概述
本镜像为jwilder/nginx-proxy的分叉版本，基于nginx 1.13构建，集成docker-gen工具实现自动反向代理配置。当后端容器启动或停止时，docker-gen会动态生成nginx配置并触发重载，无需手动修改配置文件，极大简化多容器服务的反向代理管理。

## 核心功能
- **自动配置生成**：监听Docker socket，根据容器的`VIRTUAL_HOST`环境变量自动生成反向代理规则。
- **多虚拟主机支持**：单个容器可通过逗号分隔多个`VIRTUAL_HOST`值，支持多个域名绑定。
- **SSL与HTTPS**：支持Let's Encrypt证书自动管理（需配合letsencrypt-nginx-proxy-companion），支持SNI、wildcard证书及自定义SSL配置。
- **IPv6支持**：通过`ENABLE_IPV6=true`环境变量启用IPv6。
- **多端口选择**：默认使用容器暴露的80端口，可通过`VIRTUAL_PORT`指定其他端口。
- **基础认证**：通过挂载htpasswd文件实现虚拟主机的身份验证。
- **自定义配置**：支持全局或按虚拟主机的Nginx配置自定义。

## 使用场景
- 开发环境中快速部署多容器服务，无需手动维护反向代理配置。
- 生产环境中动态管理多个微服务的入口路由。
- 需要支持HTTPS、多域名或IPv6的服务部署。

## 配置说明

### 基础运行
启动nginx-proxy容器，监听80端口并挂载Docker socket：
```bash
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro docker.xuanyuan.run/codekoalas/nginx-proxy-fork
```
启动后端容器时添加`VIRTUAL_HOST`环境变量：
```bash
docker run -e VIRTUAL_HOST=foo.bar.com docker.xuanyuan.run/your-app-image
```

### Docker Compose示例
```yaml
version: '2'
services:
  nginx-proxy:
    image: docker.xuanyuan.run/codekoalas/nginx-proxy-fork
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
  whoami:
    image: docker.xuanyuan.run/jwilder/whoami
    environment:
      - VIRTUAL_HOST=whoami.local
```
启动后通过`curl -H "Host: whoami.local" localhost`测试访问。

### IPv6支持
添加`ENABLE_IPV6=true`环境变量启用IPv6：
```bash
docker run -d -p 80:80 -e ENABLE_IPV6=true -v /var/run/docker.sock:/tmp/docker.sock:ro docker.xuanyuan.run/codekoalas/nginx-proxy-fork
```

### SSL配置
挂载证书目录并暴露443端口：
```bash
docker run -d -p 80:80 -p 443:443 -v /path/to/certs:/etc/nginx/certs -v /var/run/docker.sock:/tmp/docker.sock:ro docker.xuanyuan.run/codekoalas/nginx-proxy-fork
```
证书文件需按`VIRTUAL_HOST`名称命名（如`foo.bar.com.crt`和`foo.bar.com.key`）。

### 多虚拟主机
单个容器绑定多个域名：
```bash
docker run -e VIRTUAL_HOST=foo.bar.com,baz.bar.com docker.xuanyuan.run/your-app-image
```

### 自定义Nginx配置
- **全局配置**：挂载自定义`.conf`文件到`/etc/nginx/conf.d/`。
- **按虚拟主机配置**：挂载目录到`/etc/nginx/vhost.d/`，文件名为`VIRTUAL_HOST`的值。
- **按虚拟主机location配置**：文件名为`{VIRTUAL_HOST}_location`，用于自定义location块规则。
```bash
docker run -d -p 80:80 -v /path/to/vhost.d:/etc/nginx/vhost.d:ro -v /var/run/docker.sock:/tmp/docker.sock:ro docker.xuanyuan.run/codekoalas/nginx-proxy-fork
```
在`/path/to/vhost.d/app.example.com`中添加自定义配置即可生效。
