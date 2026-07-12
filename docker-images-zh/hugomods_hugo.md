---
image: hugomods/hugo
description: "最小化、最新且自动化的社区版Hugo（gohugo.io）Docker镜像，提供多种变体。"
source: https://xuanyuan.cloud/zh/r/hugomods/hugo
canonical: https://xuanyuan.cloud/zh/r/hugomods/hugo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hugomods/hugo" title="hugomods/hugo Docker 镜像中文简介、标签列表与拉取命令">hugomods/hugo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Hugo Docker 镜像文档

[![Docker Pulls](https://flat.badgen.net/docker/pulls/hugomods/hugo)](https://hub.docker.com/r/hugomods/hugo)
[![GHCR Pulls](https://img.shields.io/badge/dynamic/json?url=https://raw.githubusercontent.com/ghcr-stats/db/main/hugomods/docker/hugo.json&query=downloads_compact&label=ghcr+pulls&style=flat-square)](https://github.com/hugomods/docker/pkgs/container/hugo)
[![GHCR Pulls Monthly](https://img.shields.io/badge/dynamic/json?url=https://raw.githubusercontent.com/ghcr-stats/db/main/hugomods/docker/hugo.json&query=downloads_month_compact&label=ghcr+pulls&suffix=/month&style=flat-square)](https://github.com/hugomods/docker/pkgs/container/hugo)
[![GHCR Pulls Weekly](https://img.shields.io/badge/dynamic/json?url=https://raw.githubusercontent.com/ghcr-stats/db/main/hugomods/docker/hugo.json&query=downloads_week_compact&label=ghcr+pulls&suffix=/week&style=flat-square)](https://github.com/hugomods/docker/pkgs/container/hugo)
[![GHCR Pulls Daily](https://img.shields.io/badge/dynamic/json?url=https://raw.githubusercontent.com/ghcr-stats/db/main/hugomods/docker/hugo.json&query=downloads_day_compact&label=ghcr+pulls&suffix=/day&style=flat-square)](https://github.com/hugomods/docker/pkgs/container/hugo)
[![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/hugomods/hugo/latest?style=flat-square)](https://hub.docker.com/r/hugomods/hugo)
[![Build](https://github.com/hugomods/docker/actions/workflows/build.yml/badge.svg)](https://github.com/hugomods/docker/actions/workflows/build.yml)


## 镜像概述

Hugo Docker 镜像是由社区维护的轻量级、持续更新且自动化构建的 Hugo（静态网站生成器，gohugo.io）容器镜像。该镜像提供多种变体，集成了扩展版 Hugo、非 root 用户运行环境及常用工具链（如 Git、Go、Node.js、NPM、Dart Sass 等），旨在简化 Hugo 静态网站的构建与部署流程。


## 核心功能与特性

- **轻量级**：基于最小基础镜像构建，减少资源占用，优化容器体积。
- **持续更新**：自动化跟踪 Hugo 官方版本，确保镜像包含最新功能与安全修复。
- **多变体支持**：提供丰富的镜像变体以满足不同场景需求，包括：
  - 扩展版 Hugo（支持 SCSS/Sass 等高级功能）
  - 非 root 用户运行环境（增强安全性）
  - 集成 Git（版本控制）
  - 集成 Go（Hugo 主题开发）
  - 集成 Node.js 与 NPM（前端资源处理）
  - 集成 Dart Sass（CSS 预编译）
- **自动化构建**：通过 GitHub Actions 实现全流程自动化构建与测试，确保镜像质量。


## 使用场景与适用范围

- **本地开发环境**：快速启动 Hugo 开发服务器，实时预览网站效果。
- **CI/CD 流程**：集成到自动化构建流水线（如 GitHub Actions、GitLab CI），实现静态网站的自动构建与部署。
- **多工具链需求**：适用于需要同时使用 Hugo 与 Node.js、Git 等工具的项目（如主题开发、前端资源打包）。
- **安全合规场景**：通过非 root 变体满足严格的容器安全策略要求。


## 使用方法

### 镜像拉取

可从 Docker Hub 或 GHCR（GitHub Container Registry）拉取镜像，标签格式为 `hugomods/hugo:[版本]-[变体]`（未指定变体时默认为标准版）。

```bash
# 拉取最新标准版
docker pull docker.xuanyuan.run/hugomods/hugo:latest

# 拉取扩展版（支持 SCSS/Sass）
docker pull docker.xuanyuan.run/hugomods/hugo:extended

# 拉取集成 Node.js 的变体
docker pull docker.xuanyuan.run/hugomods/hugo:latest-node
```


### 基本运行示例

#### 1. 构建静态网站
将当前目录（Hugo 项目根目录）挂载到容器内，执行 `hugo build` 生成静态文件：

```bash
docker run --rm -v $(pwd):/src docker.xuanyuan.run/hugomods/hugo:latest hugo build
```

#### 2. 启动本地开发服务器
启动 Hugo 开发服务器，映射容器端口到本地，实时预览网站（支持热重载）：

```bash
docker run --rm -v $(pwd):/src -p 1313:1313 docker.xuanyuan.run/hugomods/hugo:latest hugo server --bind 0.0.0.0
```

> 说明：`--bind 0.0.0.0` 确保服务器监听容器所有网络接口，允许宿主机访问。


### Docker Compose 配置示例

创建 `docker-compose.yml` 文件，定义 Hugo 服务以简化本地开发：

```yaml
version: '3'
services:
  hugo:
    image: docker.xuanyuan.run/hugomods/hugo:latest-node  # 集成 Node.js 的变体
    volumes:
      - ./:/src  # 挂载当前项目目录
    ports:
      - "1313:1313"  # 映射开发服务器端口
    command: hugo server --bind 0.0.0.0 --disableFastRender  # 启动开发服务器，禁用快速渲染提升稳定性
```

启动服务：
```bash
docker-compose up
```


## 配置参数与环境变量

### Hugo 命令参数
Hugo 命令及参数通过容器启动命令传递，例如：

```bash
# 构建生产环境版本（压缩输出）
docker run --rm -v $(pwd):/src docker.xuanyuan.run/hugomods/hugo:latest hugo build --minify --environment production

# 指定自定义配置文件
docker run --rm -v $(pwd):/src docker.xuanyuan.run/hugomods/hugo:latest hugo server --config config.prod.toml
```

### 运行环境配置
- **用户权限**：非 root 变体默认使用非特权用户运行，可通过 `--user` 参数覆盖（需镜像支持）：
  ```bash
  docker run --rm -v $(pwd):/src --user 1000:1000 docker.xuanyuan.run/hugomods/hugo:non-root hugo build
  ```
- **工作目录**：默认工作目录为 `/src`，建议将项目目录挂载到此路径以确保 Hugo 正确识别项目结构。


## 镜像变体说明

| 变体标签         | 核心特性                                  | 适用场景                                  |
|------------------|-------------------------------------------|-------------------------------------------|
| `latest`         | 标准版 Hugo                               | 基础静态网站构建（无扩展功能需求）        |
| `extended`       | 扩展版 Hugo，支持 SCSS/Sass 等扩展功能    | 需要处理 SCSS/Sass 样式的项目             |
| `latest-node`    | 集成 Node.js 与 NPM                       | 需使用 Node.js 工具链（如前端资源打包）   |
| `latest-git`     | 集成 Git                                  | 需要版本控制或拉取远程主题/内容           |
| `latest-go`      | 集成 Go 环境                              | Hugo 主题开发（需编译 Go 代码）           |
| `non-root`       | 非 root 用户运行                          | 安全性要求高的生产环境或合规场景          |
| `dart-sass`      | 集成 Dart Sass 编译器                     | 需要使用 Dart Sass 替代 LibSass 的项目    |


## 相关链接

- **官方文档**：[https://docker.hugomods.com/](https://docker.hugomods.com/)
- **GitHub 仓库**：[https://github.com/hugomods/docker](https://github.com/hugomods/docker)
- **Docker Hub**：[https://hub.docker.com/r/hugomods/hugo](https://hub.docker.com/r/hugomods/hugo)
- **GHCR**：[https://github.com/hugomods/docker/pkgs/container/hugo](https://github.com/hugomods/docker/pkgs/container/hugo)
