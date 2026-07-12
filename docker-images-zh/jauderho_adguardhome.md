---
image: jauderho/adguardhome
description: "全网络范围的广告和跟踪器拦截DNS服务器"
source: https://xuanyuan.cloud/zh/r/jauderho/adguardhome
canonical: https://xuanyuan.cloud/zh/r/jauderho/adguardhome
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jauderho/adguardhome" title="jauderho/adguardhome Docker 镜像中文简介、标签列表与拉取命令">jauderho/adguardhome 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## AdGuard Home Docker镜像

### 镜像概述和主要用途
AdGuard Home是一款网络级广告和跟踪器拦截DNS服务器，可在整个网络范围内阻止广告、跟踪器和恶意网站。本Docker镜像提供AdGuard Home的便捷部署方式，适用于家庭网络、小型企业或个人用户，帮助提升网络隐私和浏览体验。

### 核心功能和特性
- **广告与跟踪器拦截**：阻止网站广告、弹窗及第三方跟踪器
- **DNS服务**：作为本地DNS服务器提供域名解析功能
- **隐私保护**：屏蔽恶意网站和钓鱼链接，增强网络隐私
- **自定义规则**：支持添加自定义过滤列表和规则
- **Web管理界面**：通过直观的Web界面进行配置和监控
- **跨平台兼容**：可在任何支持Docker的环境中运行

### 使用场景和适用范围
- 家庭网络广告拦截：保护家庭成员免受广告干扰
- 小型办公网络：提升员工工作效率，减少网络干扰
- 个人设备保护：为多设备提供统一广告拦截解决方案
- 隐私敏感环境：减少数据收集，增强网络隐私保护

### 使用方法和配置说明

#### 基本部署（docker run）
```bash
docker run -d \
  --name adguardhome \
  -p 53:53/tcp -p 53:53/udp \
  -p 80:80/tcp -p 443:443/tcp \
  -v /path/to/adguardhome/conf:/opt/adguardhome/conf \
  -v /path/to/adguardhome/work:/opt/adguardhome/work \
  --restart unless-stopped \
  docker.xuanyuan.run/jauderho/adguardhome:latest
```

#### Docker Compose配置
```yaml
version: '3'
services:
  adguardhome:
    image: docker.xuanyuan.run/jauderho/adguardhome:latest
    container_name: adguardhome
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
      - "443:443/tcp"
    volumes:
      - /path/to/adguardhome/conf:/opt/adguardhome/conf
      - /path/to/adguardhome/work:/opt/adguardhome/work
    restart: unless-stopped
```

#### 配置说明
- **端口映射**：
  - 53/tcp/udp：DNS服务端口（必须映射）
  - 80/tcp：Web管理界面HTTP端口
  - 443/tcp：Web管理界面HTTPS端口（如需启用HTTPS）

- **数据持久化**：
  - `/opt/adguardhome/conf`：配置文件目录，需挂载本地目录保存配置
  - `/opt/adguardhome/work`：工作目录，存储日志和临时文件

- **初始设置**：
  部署后通过浏览器访问 `http://<服务器IP>:80` 完成初始配置，包括管理员账号创建和DNS服务器设置

### 镜像信息
- **构建状态**：[![Build Status](https://github.com/jauderho/dockerfiles/workflows/adguardhome/badge.svg)](https://github.com/jauderho/dockerfiles/actions)
- **最新版本**：[![Version](https://img.shields.io/docker/v/jauderho/adguardhome/latest)](https://github.com/adguardteam/adguardhome/)
- **拉取次数**：[![Docker Pulls](https://img.shields.io/docker/pulls/jauderho/adguardhome)](https://hub.docker.com/r/jauderho/adguardhome/)
- **镜像大小**：[![Image Size](https://img.shields.io/docker/image-size/jauderho/adguardhome/latest)](https://hub.docker.com/r/jauderho/adguardhome/)
