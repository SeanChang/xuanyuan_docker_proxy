---
image: jiujiude/phpstudy
description: "用于构建phpstudy环境的Docker镜像，支持通过Docker或Docker Compose快速部署，包含多端口映射和本地目录挂载功能，适用于php开发和测试环境搭建。"
source: https://xuanyuan.cloud/zh/r/jiujiude/phpstudy
canonical: https://xuanyuan.cloud/zh/r/jiujiude/phpstudy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jiujiude/phpstudy" title="jiujiude/phpstudy Docker 镜像中文简介、标签列表与拉取命令">jiujiude/phpstudy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker Phpstudy 镜像文档

## 镜像概述和主要用途
该镜像通过Dockerfile构建phpstudy环境，提供便捷的php开发和测试环境部署方案。支持本地目录挂载和多端口映射，可通过Docker或Docker Compose快速启动，适用于需要隔离、便捷部署php环境的场景。

## 核心功能和特性
- 基于Dockerfile构建phpstudy镜像，支持自定义镜像名称
- 支持多端口映射，包括22(SSH)、21(FTP)、80(HTTP)、443(HTTPS)等常用端口
- 支持本地目录挂载，可将本地代码目录映射到容器内/www目录
- 兼容Docker Compose部署，支持后台模式运行
- 提供镜像构建、登录及发布到Docker Hub的完整流程

## 使用场景和适用范围
- 本地php开发环境快速搭建
- 多版本php应用测试环境
- 需要隔离环境的php项目开发
- 快速部署临时php测试服务

## 详细使用方法和配置说明

### 镜像构建与发布

#### 构建镜像
```bash
docker build -t 镜像名称 .
```
*说明：在Dockerfile所在目录执行，将生成指定名称的镜像*

#### 登录Docker Hub
```bash
docker login
```
*说明：执行后输入Docker Hub账号和密码完成登录*

#### 发布镜像
```bash
docker image push 镜像名称
```
*说明：将本地构建的镜像发布到Docker Hub仓库*

### Docker运行命令
```bash
docker run -i -t -d --name phpstudy -p 22:22 -p 21:21 -p 80:80 -p 443:443 -p 30000:30000 -p 9080:9080 -p 30050:30050 --privileged=true -v C:\www:/www 镜像名称
```

**参数说明**：
- `-i -t -d`：以交互式终端模式后台运行容器
- `--name phpstudy`：指定容器名称为phpstudy
- `-p`：端口映射，格式为`主机端口:容器端口`，映射的端口包括22(SSH)、21(FTP)、80(HTTP)、443(HTTPS)等
- `--privileged=true`：赋予容器特权模式，确保目录挂载等功能正常
- `-v C:\www:/www`：将本地C:\www目录挂载到容器内/www目录，实现代码文件共享

### Docker Compose运行命令
```bash
docker-compose up -d
```
*说明：在包含docker-compose.yml文件的目录执行，将以后台模式启动服务*

### 相关资源
- GitHub地址：[https://github.com/jiujiude/DockerPhpstudy](https://github.com/jiujiude/DockerPhpstudy)
