---
image: alist666/alist
description: "AList是一个支持多种存储的文件列表程序，由Gin和Solidjs驱动，可帮助用户统一管理各类存储服务中的文件。"
source: https://xuanyuan.cloud/zh/r/alist666/alist
canonical: https://xuanyuan.cloud/zh/r/alist666/alist
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alist666/alist" title="alist666/alist Docker 镜像中文简介、标签列表与拉取命令">alist666/alist 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# AList Docker镜像文档

## 镜像概述
AList是一款支持多种存储的文件列表程序，基于Gin后端和Solidjs前端构建，旨在为用户提供统一的文件管理界面，方便整合和访问不同存储服务中的文件资源。

## 核心功能与特性
- **多存储支持**：兼容多种存储服务（如本地存储、云存储等）
- **Web界面**：基于Solidjs构建的直观用户界面
- **数据持久化**：通过挂载卷实现配置和数据的持久化存储
- **灵活配置**：支持通过环境变量自定义用户权限、文件权限等

## 使用场景
- 个人文件管理中心，整合本地与云端存储
- 小型团队文件共享与访问
- 作为轻量级文件服务器，提供Web文件浏览服务

## 使用方法

### 稳定版部署
```bash
docker run -d --restart=always \
  -v /etc/alist:/opt/alist/data \
  -p 5244:5244 \
  -e PUID=0 \
  -e PGID=0 \
  -e UMASK=022 \
  --name="alist" \
  docker.xuanyuan.run/xhofe/alist:latest
```

### 测试版部署（不推荐生产环境使用）
```bash
docker run -d --restart=always \
  -v /etc/alist:/opt/alist/data \
  -p 5244:5244 \
  -e PUID=0 \
  -e PGID=0 \
  -e UMASK=022 \
  --name="alist" \
  docker.xuanyuan.run/xhofe/alist:main
```

### 参数说明
- `-v /etc/alist:/opt/alist/data`: 挂载本地目录用于持久化存储AList数据和配置
- `-p 5244:5244`: 端口映射，将容器内5244端口映射到主机5244端口
- `-e PUID=0`: 运行AList的用户ID（0为root用户）
- `-e PGID=0`: 运行AList的组ID（0为root组）
- `-e UMASK=022`: 设置文件权限掩码

### 密码管理
- **初始密码**：首次启动时，初始密码会输出到日志中，可通过`docker logs alist`查看
- **随机生成新密码**：
  ```bash
  docker exec -it alist ./alist admin random
  ```
- **手动设置新密码**（将`NEW_PASSWORD`替换为自定义密码）：
  ```bash
  docker exec -it alist ./alist admin set NEW_PASSWORD
  ```

## 文档与支持
- **官方文档**：https://alist.nn.ci/
- **讨论论坛**：用于一般问题咨询（issues仅用于bug报告）

## 许可证
AList是开源软件，采用AGPL-3.0许可证。
