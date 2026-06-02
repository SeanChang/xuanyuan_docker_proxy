---
image: suwayomi/suwayomi-vui
description: "基于Svelte框架构建的Suwayomi应用基础用户界面"
source: https://xuanyuan.cloud/zh/r/suwayomi/suwayomi-vui
canonical: https://xuanyuan.cloud/zh/r/suwayomi/suwayomi-vui
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/suwayomi/suwayomi-vui" title="suwayomi/suwayomi-vui Docker 镜像中文简介、标签列表与拉取命令">suwayomi/suwayomi-vui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Robonau's Svelte + Skeleton Suwayomi UI 镜像文档


## 1. 镜像概述和主要用途
本镜像为基于 Svelte 前端框架和 Skeleton UI 工具包构建的 Suwayomi 自定义前端界面，旨在为 Suwayomi Manga 服务器提供现代化、轻量化的 Web 用户界面。Suwayomi Manga 是一个开源漫画阅读服务器，本镜像作为其前端组件，提供漫画浏览、章节管理、阅读历史同步等核心功能的可视化操作界面。


## 2. 核心功能和特性
- **技术栈优势**：基于 Svelte 框架构建，具备零运行时开销、组件化开发特性，配合 Skeleton UI 工具包提供一致的设计语言和响应式布局；
- **Suwayomi 集成**：完整适配 Suwayomi Manga 后端 API，支持漫画库管理、章节下载、阅读进度同步、分类标签筛选等核心功能；
- **轻量化设计**：静态资源预编译，启动速度快，资源占用低，兼容低配置设备；
- **现代化界面**：遵循 Skeleton UI 设计规范，提供简洁直观的交互体验，支持深色/浅色模式切换；
- **跨设备兼容**：响应式布局设计，适配桌面端、平板及移动端浏览器。


## 3. 使用场景和适用范围
- **个人漫画阅读系统**：配合 Suwayomi 后端，搭建个人本地漫画库，通过本界面管理和阅读漫画；
- **家庭局域网共享**：部署在家庭服务器中，通过局域网为多设备提供统一漫画阅读入口；
- **Suwayomi 前端定制**：作为 Suwayomi 官方 UI 的替代方案，满足对界面设计、交互体验有个性化需求的用户。


## 4. 使用方法和配置说明

### 4.1 前提条件
- 已部署 Suwayomi Manga 后端服务（推荐版本 ≥ v1.4.0），且网络可被本镜像访问；
- 安装 Docker 或 Docker Compose 环境。


### 4.2 快速启动（`docker run` 命令）
通过以下命令快速启动镜像，默认连接本地 Suwayomi 后端：

```bash
docker run -d \
  --name suwayomi-ui \
  -p 80:80 \
  -e BACKEND_URL=http://suwayomi-backend:4567 \  # 替换为实际 Suwayomi 后端地址
  robonau/svelte-skeleton-suwayomi-ui:latest
```

**参数说明**：
- `-p 80:80`：将容器内 80 端口映射到主机 80 端口（可根据需求修改主机端口，如 `-p 8080:80`）；
- `-e BACKEND_URL`：指定 Suwayomi 后端 API 地址（必填，需包含协议和端口，如 `http://192.168.1.100:4567`）。


### 4.3 Docker Compose 配置示例
推荐与 Suwayomi 后端联动部署，以下为 `docker-compose.yml` 示例：

```yaml
version: '3'

services:
  suwayomi-backend:
    image: ghcr.io/suwayomi/suwayomi-server:latest
    restart: always
    ports:
      - "4567:4567"  # Suwayomi 后端默认端口
    volumes:
      - suwayomi-data:/config
      - /path/to/manga:/manga  # 本地漫画文件目录映射

  suwayomi-ui:
    image: robonau/svelte-skeleton-suwayomi-ui:latest
    restart: always
    ports:
      - "80:80"  # UI 访问端口
    environment:
      - BACKEND_URL=http://suwayomi-backend:4567  # 通过容器名访问后端（需在同一网络内）
    depends_on:
      - suwayomi-backend

volumes:
  suwayomi-data:
```


### 4.4 环境变量配置说明
| 环境变量名       | 描述                                  | 默认值                  | 是否必填 |
|------------------|---------------------------------------|-------------------------|----------|
| `BACKEND_URL`    | Suwayomi 后端 API 基础地址            | `http://localhost:4567` | 否（建议显式指定） |
| `PORT`           | 容器内 Web 服务监听端口               | `80`                    | 否       |
| `THEME_MODE`     | 默认主题模式（`light`/`dark`/`auto`） | `auto`                  | 否       |


### 4.5 访问方式
部署完成后，通过浏览器访问 `http://<主机IP>:<映射端口>`（如 `http://192.168.1.100:80`）即可打开 UI 界面，首次使用需通过 Suwayomi 后端的用户认证（默认无密码，建议在后端配置访问密码）。


## 5. 注意事项
- **版本兼容性**：建议使用 Suwayomi 后端 v1.4.0 及以上版本，以确保 API 兼容性；
- **网络配置**：`BACKEND_URL` 需确保前端容器可访问后端服务（局域网 IP 或容器名，避免使用 `localhost` 除非前后端在同一容器内）；
- **静态资源**：本镜像为预编译静态前端，无持久化数据需求，无需挂载数据卷（配置通过环境变量动态注入）。
