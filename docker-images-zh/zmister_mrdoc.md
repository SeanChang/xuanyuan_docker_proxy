---
image: zmister/mrdoc
description: "MrDoc完整运行环境镜像，以uwsgi部署，集成Chromium与LibreOffice，需挂载本地MrDoc目录使用，支持开源版及专业版。"
source: https://xuanyuan.cloud/zh/r/zmister/mrdoc
canonical: https://xuanyuan.cloud/zh/r/zmister/mrdoc
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zmister/mrdoc" title="zmister/mrdoc Docker 镜像中文简介、标签列表与拉取命令">zmister/mrdoc 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MrDoc Docker 镜像文档


## 一、镜像概述

MrDoc Docker 镜像是 MrDoc 文档管理系统的完整运行环境镜像，基于 uWSGI 应用服务器部署，集成 Chromium 和 LibreOffice 工具。该镜像需挂载本地 MrDoc 源代码目录使用，支持 MrDoc 开源版与专业版，旨在简化 MrDoc 系统的部署流程，提供开箱即用的文档管理能力。


## 二、核心功能与特性

- **uWSGI 部署**：采用 uWSGI 作为应用服务器，保障系统高效稳定运行，支持高并发场景。  
- **工具集成**：内置 Chromium（用于网页渲染、PDF 生成等）和 LibreOffice（用于文档格式转换，如 Word/Excel 转 PDF/HTML）。  
- **版本兼容**：同时支持 MrDoc 开源版和专业版，满足不同用户需求。  
- **数据持久化**：需挂载本地 MrDoc 目录至容器，确保配置文件、用户数据及文档内容持久化存储。  


## 三、使用场景与适用范围

- **企业知识库搭建**：快速部署内部协作文档平台，支持团队共享与管理各类文档。  
- **个人文档管理**：个人用户搭建私有化文档库，实现本地文档集中管理与格式转换。  
- **在线文档系统**：需文档格式转换（如多格式转 PDF）或网页内容处理（如网页截图）的场景。  
- **轻量化部署**：简化依赖配置，通过 Docker 容器化部署减少环境冲突，降低运维成本。  


## 四、使用方法

### 4.1 拉取 MrDoc 源代码

需先将 MrDoc 源代码拉取至本地目录（建议 `/opt` 路径），用于挂载至容器。

#### 4.1.1 开源版

```bash
cd /opt
git clone https://gitee.com/zmister/MrDoc.git
```

#### 4.1.2 专业版

需替换 `{用户名}` 和 `{密码}` 为实际授权信息：

```bash
cd /opt
git clone https://{用户名}:{密码}@git.mrdoc.pro/MrDoc/MrDocPro.git
```


### 4.2 拉取 Docker 镜像

```bash
docker pull docker.xuanyuan.run/zmister/mrdoc:v9.1
```


### 4.3 运行 Docker 容器

根据使用的 MrDoc 版本，执行对应命令启动容器，确保本地目录路径与挂载配置正确。

#### 4.3.1 开源版

```bash
docker run -d \
  --name mrdoc \
  -p 10086:10086 \
  -v /opt/MrDoc:/app/MrDoc \
  docker.xuanyuan.run/zmister/mrdoc:v9.1
```

#### 4.3.2 专业版

```bash
docker run -d \
  --name mrdoc \
  -p 10086:10086 \
  -v /opt/MrDocPro:/app/MrDoc \
  docker.xuanyuan.run/zmister/mrdoc:v9.1
```


### 4.4 创建管理员账户

容器启动后，通过以下命令创建系统超级管理员账户（用于后台管理）：

```bash
docker exec -it mrdoc python manage.py createsuperuser
```

根据提示输入用户名、邮箱及密码，完成管理员配置。


## 五、配置说明

### 5.1 挂载卷配置

- **必填挂载项**：`/opt/MrDoc`（开源版）或 `/opt/MrDocPro`（专业版）目录需挂载至容器内 `/app/MrDoc` 路径，用于：  
  - 加载 MrDoc 源代码及配置文件；  
  - 存储用户上传的文档、图片等媒体文件；  
  - 持久化数据库文件（默认 SQLite）及系统日志。  


### 5.2 端口映射

默认使用容器内 `10086` 端口提供服务，可通过 `-p <宿主机端口>:10086` 自定义宿主机端口。例如，映射至宿主机 `80` 端口：  
```bash
-p 80:10086
```


### 5.3 Docker Compose 部署示例

创建 `docker-compose.yml` 文件，简化多容器管理（适用于需要额外服务如数据库的场景）：

```yaml
version: '3'
services:
  mrdoc:
    image: docker.xuanyuan.run/zmister/mrdoc:v9.1
    container_name: mrdoc
    restart: always  # 容器异常退出后自动重启
    ports:
      - "10086:10086"
    volumes:
      - /opt/MrDoc:/app/MrDoc  # 开源版路径，专业版替换为 /opt/MrDocPro
    # 如需自定义环境变量（如数据库连接、调试模式），添加 environment 字段
    # environment:
    #   - DEBUG=False  # 生产环境建议关闭调试模式
    #   - DATABASE_URL=mysql://user:password@db:3306/mrdoc  # 自定义数据库连接
```

启动命令：`docker-compose up -d`


## 六、注意事项

1. **目录权限**：确保宿主机 `MrDoc` 目录（`/opt/MrDoc` 或 `/opt/MrDocPro`）拥有读写权限，避免容器内权限不足导致启动失败。  
2. **镜像版本**：本文档基于 `v9.1` 版本编写，使用其他版本时需替换镜像标签（如 `zmister/mrdoc:latest`）。  
3. **数据备份**：挂载卷内包含系统核心数据，建议定期备份宿主机 `MrDoc` 目录，防止数据丢失。  
4. **工具依赖**：Chromium 和 LibreOffice 工具已内置，无需额外安装，若功能异常可检查容器日志（`docker logs mrdoc`）排查问题。
