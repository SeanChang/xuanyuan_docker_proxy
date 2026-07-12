---
image: yobasystems/alpine-nginx
description: "基于Alpine Linux的Nginx容器镜像，支持amd64、armhf和aarch64架构，提供轻量级Web服务、反向代理、缓存等功能，具备极小体积和内存占用特性。"
source: https://xuanyuan.cloud/zh/r/yobasystems/alpine-nginx
canonical: https://xuanyuan.cloud/zh/r/yobasystems/alpine-nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/yobasystems/alpine-nginx" title="yobasystems/alpine-nginx Docker 镜像中文简介、标签列表与拉取命令">yobasystems/alpine-nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 基于Alpine Linux的Nginx容器镜像

[![Docker Automated build](https://img.shields.io/docker/automated/yobasystems/alpine-nginx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/yobasystems/alpine-nginx/)
[![Docker Pulls](https://img.shields.io/docker/pulls/yobasystems/alpine-nginx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/yobasystems/alpine-nginx/)
[![Docker Stars](https://img.shields.io/docker/stars/yobasystems/alpine-nginx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/yobasystems/alpine-nginx/)

[![Alpine Version](https://img.shields.io/badge/Alpine%20version-v3.22.1-green.svg?style=for-the-badge)](https://alpinelinux.org/)
[![Nginx Version](https://img.shields.io/badge/Nginx%20Mainline-v1.29.0-green.svg?style=for-the-badge)](https://nginx.org/en/)
[![Nginx Version](https://img.shields.io/badge/Nginx%20Stable-v1.28.0-green.svg?style=for-the-badge)](https://nginx.org/en/)


此容器镜像[(yobasystems/alpine-nginx)](https://hub.docker.com/r/yobasystems/alpine-nginx/)基于轻量级[Alpine Linux](https://alpinelinux.org/)构建，包含[Nginx](https://nginx.org/en/) 1.29.0版本。


### Alpine版本 3.22.1（发布于2025-07-15）
##### Nginx版本 1.29.0（Mainline主线版）
##### Nginx版本 1.28.0（Stable稳定版）

----


## 目录

- [什么是Alpine Linux？](#什么是alpine-linux)
- [特性](#特性)
- [支持架构](#支持架构)
- [标签](#标签)
- [层与大小](#层与大小)
- [如何使用此镜像](#如何使用此镜像)
- [镜像内容与漏洞分析](#镜像内容与漏洞分析)
- [源码仓库](#源码仓库)
- [容器仓库](#容器仓库)
- [链接](#链接)
- [捐赠](#捐赠)


## 🏔️ 什么是Alpine Linux？
Alpine Linux是一个围绕musl libc和BusyBox构建的Linux发行版。该镜像仅5MB大小，且拥有比其他基于BusyBox的镜像更完整的软件包仓库。这使得Alpine Linux成为实用工具甚至生产应用的理想镜像基础。

## 什么是Nginx？
Nginx是一款开源的Web服务器软件，支持反向代理、缓存、负载均衡、媒体流等功能。它最初设计用于实现最高性能和稳定性的Web服务。除HTTP服务外，Nginx还可作为邮件代理服务器（IMAP、POP3、SMTP）以及HTTP、TCP、UDP服务器的反向代理和负载均衡器。


## ✨ 特性

* 仅最小尺寸，最少层数
* 简单安装下内存占用极小
* 使用`yobasystems/alpine-nginx:git`或`yobasystems/alpine-nginx:git-ssh`标签支持从仓库自动克隆代码


## 🏗️ 支持架构

* ```:amd64```, ```:x86_64``` - 64位Intel/AMD（x86_64/amd64）
* ```:arm64v8```, ```:aarch64``` - 64位ARM（ARMv8/aarch64）
* ```:arm32v7```, ```:armhf``` - 32位ARM（ARMv7/armhf）

#### 📝 请查看下方标签了解支持的架构，以上为架构说明列表


## 🏷️ 标签

* ```:latest``` - 基于主线版的最新分支（自动架构选择）
* ```:main``` - 主分支，通常与latest保持一致（自动架构选择）
* ```:mainline``` - 基于主线版发布的最新分支（自动架构选择）
* ```:stable``` - 基于稳定版发布的分支（自动架构选择）
* ```:git``` - 基于主线版且包含git的最新分支（自动架构选择）
* ```:git-ssh``` - 基于主线版且包含git和私有仓库SSH认证的最新分支（自动架构选择）
* ```:amd64```, ```:x86_64``` - amd64架构，基于latest标签
* ```:amd64-git```, ```:x86_64-git``` - amd64架构，基于latest标签且包含git
* ```:amd64-git-ssh```, ```:x86_64-git-ssh``` - amd64架构，基于latest标签且包含git和私有仓库SSH认证
* ```:aarch64```, ```:arm64v8``` - Armv8架构，基于latest标签
* ```:aarch64-git```, ```:arm64v8-git``` - Armv8架构，基于latest标签且包含git
* ```:aarch64-git-ssh```, ```:arm64v8-git-ssh``` - Armv8架构，基于latest标签且包含git和私有仓库SSH认证
* ```:armhf```, ```:arm32v7``` - Armv7架构，基于latest标签
* ```:armhf-git```, ```:arm32v7-git``` - Armv7架构，基于latest标签且包含git
* ```:armhf-git-ssh```, ```:arm32v7-git-ssh``` - Armv7架构，基于latest标签且包含git和私有仓库SSH认证


## 📏 层与大小

![Version](https://img.shields.io/badge/version-amd64-blue.svg?style=for-the-badge)
![Docker Image Version (tag)](https://img.shields.io/docker/v/yobasystems/alpine-nginx/amd64.svg?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/yobasystems/alpine-nginx/amd64.svg?style=for-the-badge)

![Version](https://img.shields.io/badge/version-aarch64-blue.svg?style=for-the-badge)
![Docker Image Version (tag)](https://img.shields.io/docker/v/yobasystems/alpine-nginx/aarch64.svg?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/yobasystems/alpine-nginx/aarch64.svg?style=for-the-badge)

![Version](https://img.shields.io/badge/version-armhf-blue.svg?style=for-the-badge)
![Docker Image Version (tag)](https://img.shields.io/docker/v/yobasystems/alpine-nginx/armhf.svg?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/yobasystems/alpine-nginx/armhf.svg?style=for-the-badge)


## 🚀 如何使用此镜像

### 环境变量：

* `URL`：指定Nginx监听的URL，默认为localhost


### HTML内容

要修改Nginx提供的HTML内容（添加网站文件），可在Dockerfile中添加：

```dockerfile
ADD /path/to/content /etc/nginx/html
```

默认主页为index.html，可通过配置修改（见下文）。


### Nginx配置

此镜像提供基础Nginx配置，可通过以下方式自定义：
- 创建自定义`nginx.conf`
- 在Dockerfile中确保`nginx.conf`被复制到`/etc/nginx/nginx.conf`

**注意：配置中需包含`daemon off;`以禁用守护进程模式，否则容器会在Nginx启动后立即退出。**


### 创建实例

要使用此镜像，可在Dockerfile顶部添加`FROM yobasystems/alpine-nginx`。

```bash
docker run --name webapp -p 80:80 -p 443:443 -e URL=www.example.co.uk docker.xuanyuan.run/yobasystems/alpine-nginx
```

如需持久化数据，可使用卷挂载：

```bash
docker run --name webapp -p 80:80 -p 443:443 -e URL=www.example.co.uk -v /app/www:/etc/nginx/html docker.xuanyuan.run/yobasystems/alpine-nginx
```

Nginx日志（访问日志和错误日志）分别输出到`stdout`和`stderr`。


### Docker Compose示例：

```yaml
version: '2'
services:
  webapp:
    image: yobasystems/alpine-nginx
    environment:
      URL: www.example.co.uk
    expose:
      - "80"
      - "443"
    volumes:
      - /app/www:/etc/nginx/html
    domainname: www.example.co.uk
    restart: always
```


### Docker Compose示例（Git版本）：

```yaml
version: '2'
services:
  webapp:
    image: yobasystems/alpine-nginx:git
    environment:
      URL: www.example.co.uk
      REPO: https://yobasystems@bitbucket.org/yobasystems/default-index.git
    expose:
      - "80"
      - "443"
    volumes:
      - /app/www:/etc/nginx/html
    domainname: www.example.co.uk
    restart: always
```


## 🔍 镜像内容与漏洞分析

| 软件包名称          | 软件包版本 | 漏洞信息         |
|---------------------|------------|------------------|


## 📚 源码仓库

* [Github - yobasystems/alpine-nginx](https://github.com/yobasystems/alpine-nginx)
* [Gitlab - yobasystems/alpine-nginx](https://gitlab.com/yobasystems/alpine-nginx)
* [Bitbucket - yobasystems/alpine-nginx](https://bitbucket.org/yobasystems/alpine-nginx/)


## 🐳 容器仓库

* [Dockerhub - yobasystems/alpine-nginx](https://hub.docker.com/r/yobasystems/alpine-nginx/)
* [Quay.io - yobasystems/alpine-nginx](https://quay.io/repository/yobasystems/alpine-nginx)
* [GHCR - yobasystems/alpine-nginx](https://ghcr.io/yobasystems/alpine-nginx)


## 🔗 链接

* [Yoba Systems](https://yoba.systems/)
* [Github - Yoba Systems](https://github.com/yobasystems/)
* [Dockerhub - Yoba Systems](https://hub.docker.com/u/yobasystems/)
* [Quay.io - Yoba Systems](https://quay.io/organization/yobasystems)
* [GHCR - Yoba Systems](https://ghcr.io/yobasystems)
* [维护者 - Dominic Taylor](https://github.com/dominictayloruk)


## 捐赠
如果您觉得此项目有帮助，欢迎捐赠支持开发。
