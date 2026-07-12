---
image: openeuler/nginx
description: "高性能的反向代理和Web服务器，基于openEuler构建，支持HTTP、HTTPS等协议，具备高并发、低内存占用特性，适用于静态内容服务、动态内容处理及负载均衡场景。"
source: https://xuanyuan.cloud/zh/r/openeuler/nginx
canonical: https://xuanyuan.cloud/zh/r/openeuler/nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/nginx" title="openeuler/nginx Docker 镜像中文简介、标签列表与拉取命令">openeuler/nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nginx | openEuler 镜像文档

## 镜像概述

这是基于[openEuler](https://repo.openeuler.org/)构建的官方Nginx Docker镜像，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。该镜像可免费使用，无每用户速率限制。

Nginx（发音为"engine-x"）是一款开源的反向代理服务器，支持HTTP、HTTPS、SMTP、POP3和IMAP协议，同时具备负载均衡、HTTP缓存和Web服务器（源服务器）功能。Nginx项目以高并发、高性能和低内存占用为核心设计目标，采用2条款BSD类许可证，可运行于Linux、BSD变体、Mac OS X、Solaris、AIX、HP-UX等类Unix系统，也提供了Windows系统的概念验证版本。

## 核心功能与特性

- **易于配置**：可轻松配置以提供静态Web内容或作为代理服务器
- **动态内容支持**：通过FastCGI、SCGI处理器、WSGI应用服务器或Phusion Passenger模块处理动态内容
- **负载均衡能力**：可作为软件负载均衡器部署
- **高效架构**：采用异步事件驱动方式而非线程处理请求，模块化事件驱动架构在高负载下提供可预测的性能

## 支持的标签及对应Dockerfile链接

每个`nginx`镜像标签由Nginx版本和基础镜像版本组成，具体如下：

| 标签 | 当前版本 | 架构 |
|------|----------|------|
|[1.29.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.29.1/24.03-lts-sp2/Dockerfile)| Nginx 1.29.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[1.16.1-oe2003sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.16.1/20.03-lts-sp1/Dockerfile)| Nginx 1.16.1 on openEuler 20.03-LTS-SP1 | amd64, arm64 |
|[1.21.5-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.21.5/22.03-lts/Dockerfile)| Nginx 1.21.5 on openEuler 22.03-LTS | amd64, arm64 |
|[1.25.4-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.25.4/22.03-lts-sp3/Dockerfile)| Nginx 1.25.4 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.0/22.03-lts-sp3/Dockerfile)| Nginx 1.27.0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.1/22.03-lts-sp3/Dockerfile)| Nginx 1.27.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.2-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/20.03-lts-sp4/Dockerfile)| Nginx 1.27.2 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[1.27.2-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/22.03-lts-sp1/Dockerfile)| Nginx 1.27.2 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[1.27.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/22.03-lts-sp3/Dockerfile)| Nginx 1.27.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[1.27.2-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/22.03-lts-sp4/Dockerfile)| Nginx 1.27.2 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[1.27.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.27.2/24.03-lts/Dockerfile)| Nginx 1.27.2 on openEuler 24.03-LTS | amd64, arm64 |
|[1.29.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/nginx/1.29.0/24.03-lts/Dockerfile)| Nginx 1.29.0 on openEuler 24.03-LTS | amd64, arm64 |

## 使用方法

用户可根据需求选择相应的`{Tag}`和容器启动选项。

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/openeuler/nginx:{Tag}
```

### 启动Nginx实例

```bash
docker run -d --name my-nginx -p 8080:80 docker.xuanyuan.run/openeuler/nginx:{Tag}
```

实例`my-nginx`启动后，可通过`http://localhost:8080`访问Nginx服务。

### 容器启动选项

| 选项 | 描述 |
|------|------|
| `-p 8080:80` | 将Nginx服务暴露在`localhost:8080` |
| `-v /local/path/to/website:/var/www/html` | 挂载并提供本地网站内容 |
| `-v /path/to/conf.template:/etc/nginx/templates/conf.template` | 挂载模板文件到`/etc/nginx/templates`，处理后结果将放置于`/etc/nginx/conf.d`（例如`listen ${NGINX_PORT}`会生成`listen 80`） |
| `-v /path/to/nginx.conf:/etc/nginx/nginx.conf` | 使用本地[Nginx配置文件](https://nginx.org/en/docs/) |

### 查看容器运行日志

```bash
docker logs -f my-nginx
```

### 获取交互式shell

```bash
docker exec -it my-nginx /bin/bash
```

## 问题与反馈

如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

## 获取帮助

- [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)
- [openEuler](https://gitee.com/openeuler/community)
