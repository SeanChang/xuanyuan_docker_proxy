---
image: kasmweb/nginx
description: "基于nginx:alpine构建的Nginx镜像，集成logrotate日志轮转功能，轻量高效且支持自动日志管理。"
source: https://xuanyuan.cloud/zh/r/kasmweb/nginx
canonical: https://xuanyuan.cloud/zh/r/kasmweb/nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kasmweb/nginx" title="kasmweb/nginx Docker 镜像中文简介、标签列表与拉取命令">kasmweb/nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nginx with Logrotate 镜像文档

## 镜像概述

本镜像基于官方`nginx:alpine`构建，保留Nginx核心功能的同时集成`logrotate`工具，专为需要自动日志管理的Nginx部署场景设计。依托Alpine Linux基础，镜像体积轻量（约20MB），适合资源受限环境；通过`logrotate`实现日志自动轮转、压缩与清理，有效解决Nginx日志持续增长导致的磁盘空间占用问题。

## 核心功能与特性

### 基础功能
- 完整继承`nginx:alpine`的所有Nginx功能，包括HTTP/HTTPS服务、反向代理、负载均衡、静态资源托管等
- 基于Alpine Linux，镜像体积小、启动速度快，适合容器化部署

### 日志管理特性
- 集成`logrotate`工具，支持Nginx访问日志（`access.log`）和错误日志（`error.log`）自动轮转
- 默认配置包含日志轮转周期（如每日/每周）、保留历史日志数量、日志压缩（gzip）等功能
- 支持自定义`logrotate`配置，满足不同场景下的日志管理需求

## 使用场景与适用范围

- **开发/测试环境**：快速部署Nginx服务，同时避免日志堆积占用开发机磁盘空间
- **小型生产环境**：资源有限的服务器或边缘计算场景，轻量级镜像降低资源消耗
- **日志敏感型应用**：需合规保留日志或控制日志文件大小的场景，通过自动轮转简化运维

## 使用方法

### 基本部署

通过`docker run`快速启动容器：

```bash
docker run -d \
  --name nginx-logrotate \
  -p 80:80 \
  -v /path/to/nginx/conf.d:/etc/nginx/conf.d \  # 挂载自定义Nginx配置（可选）
  -v /path/to/logs:/var/log/nginx \            # 挂载日志目录（持久化日志，可选）
  [镜像名称]:[标签]
```

### 自定义Nginx配置

如需修改Nginx服务配置（如反向代理规则、虚拟主机等），可通过挂载`/etc/nginx/conf.d`目录实现：

```bash
# 宿主机准备配置文件：/path/to/nginx/conf.d/default.conf
docker run -d \
  --name nginx-logrotate \
  -p 80:80 \
  -v /path/to/nginx/conf.d:/etc/nginx/conf.d \
  [镜像名称]:[标签]
```

### 自定义Logrotate配置

默认`logrotate`配置路径为`/etc/logrotate.d/nginx`，可通过挂载该文件自定义日志轮转规则：

```bash
# 宿主机准备自定义logrotate配置：/path/to/logrotate/nginx.conf
docker run -d \
  --name nginx-logrotate \
  -p 80:80 \
  -v /path/to/logrotate/nginx.conf:/etc/logrotate.d/nginx \  # 覆盖默认logrotate配置
  [镜像名称]:[标签]
```

#### 默认Logrotate配置说明

默认`/etc/logrotate.d/nginx`配置示例：
```
/var/log/nginx/*.log {
    daily               # 每日轮转
    missingok           # 日志文件不存在时不报错
    rotate 7            # 保留7份历史日志
    compress            # 压缩历史日志（gzip）
    delaycompress       # 延迟压缩（保留当前轮转日志未压缩，下次轮转时压缩）
    notifempty          # 日志为空时不轮转
    create 0640 nginx nginx  # 新建日志文件权限与属主
}
```

## 配置参数说明

### Nginx配置

同官方`nginx:alpine`，支持通过以下路径自定义配置：
- 主配置：`/etc/nginx/nginx.conf`（建议通过挂载覆盖）
- 虚拟主机配置：`/etc/nginx/conf.d/*.conf`（推荐挂载该目录添加自定义配置）

### Logrotate配置

可通过修改`/etc/logrotate.d/nginx`调整日志轮转策略，关键参数说明：
- `daily/weekly/monthly`：轮转周期（每日/每周/每月）
- `rotate N`：保留N份历史日志
- `size M`：当日志达到M大小时触发轮转（如`size 100M`）
- `compress`：启用压缩（默认gzip）
- `nocompress`：禁用压缩
- `missingok`：忽略日志文件不存在的错误

## 注意事项

- 若挂载日志目录（`/var/log/nginx`），需确保宿主机目录权限允许容器内`nginx`用户（UID/GID通常为101）读写
- 自定义`logrotate`配置时，需保证语法正确，可通过`logrotate -d /etc/logrotate.d/nginx`测试配置有效性
- 镜像基于`nginx:alpine`，Alpine Linux使用`apk`包管理器，如需额外依赖可通过`docker exec`进入容器安装
