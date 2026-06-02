---
image: triliumnext/trilium
description: "Trilium Notes 是一款免费开源的跨平台层级笔记应用，专注于构建大型个人知识库，支持深度笔记树结构、富文本编辑、代码笔记、全文搜索、版本控制、加密及多设备同步等功能。"
source: https://xuanyuan.cloud/zh/r/triliumnext/trilium
canonical: https://xuanyuan.cloud/zh/r/triliumnext/trilium
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/triliumnext/trilium" title="triliumnext/trilium Docker 镜像中文简介、标签列表与拉取命令">triliumnext/trilium — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/triliumnext/trilium" title="triliumnext/trilium Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/triliumnext/trilium</a>

# Trilium Notes 镜像文档

## 镜像概述与主要用途

Trilium Notes 是一款免费开源的跨平台层级笔记应用，专为构建和管理大型个人知识库设计。它支持将笔记组织为深度树状结构，提供丰富的编辑功能、数据安全保障和多设备同步能力，适用于个人知识管理、学术研究、项目文档和敏感信息存储等场景。

## 核心功能与特性

- **层级笔记管理**：笔记可组织为任意深度的树状结构，单条笔记支持通过克隆功能放置于多个位置
- **富文本编辑**：内置 WYSIWYG 编辑器，支持表格、图片、数学公式（LaTeX）及 Markdown 自动格式化
- **代码笔记支持**：提供代码笔记编辑功能，支持多种编程语言的语法高亮
- **高效导航与搜索**：快速笔记导航、全文搜索和笔记提升（hoisting）功能，提升信息查找效率
- **版本控制**：无缝的笔记版本管理，支持历史记录查看与恢复
- **笔记属性系统**：通过自定义属性实现笔记组织、高级查询和脚本自动化
- **多语言界面**：支持英文、德文、西班牙文、法文、罗马尼亚文、中文（简体和繁体）等
- **安全认证**：集成 OpenID 和 TOTP 多因素认证，增强账户安全性
- **数据同步**：支持自托管同步服务器，也可使用第三方托管服务
- **笔记分享**：支持将笔记发布到公共网络，实现内容分享
- **加密保护**：提供笔记级别的加密功能，保护敏感数据安全
- **绘图功能**：基于 Excalidraw 的画布笔记类型，支持绘制 diagrams
- **关系可视化**：关系图（relation maps）和链接图（link maps）直观展示笔记间关联
- **思维导图**：基于 Mind Elixir 实现的思维导图功能
- **地理地图**：支持位置标记和 GPX 轨迹的地理地图笔记
- **脚本与自动化**：强大的脚本支持，可通过 API 实现高级自动化功能
- **REST API**：提供 API 接口，支持外部系统集成与自动化操作
- **高性能扩展**：在可用性和性能上支持 10 万+笔记规模的知识库
- **移动适配**：针对智能手机和平板优化的触摸友好型移动前端界面
- **主题定制**：内置深色主题，同时支持用户自定义主题样式
- **数据导入导出**：支持 Evernote 和 Markdown 格式的导入与导出
- **网页剪辑**：配套网页剪辑器工具，方便快速保存网页内容
- **UI 定制**：可自定义侧边栏按钮、用户组件等界面元素
- **指标监控**：内置使用指标，支持与 Grafana 仪表盘集成

## 使用场景与适用范围

Trilium Notes 适用于以下场景：

- **个人知识管理**：构建和维护大型个人知识库，整理学习、工作笔记
- **学术研究**：管理文献笔记、实验数据和研究思路，支持数学公式和代码片段
- **项目文档**：组织项目相关文档、任务和进度，通过同步功能实现协作
- **代码片段库**：收集和管理代码示例、脚本，支持语法高亮和版本控制
- **多设备同步**：通过自托管服务器实现跨设备（桌面、手机、平板）笔记同步
- **敏感信息管理**：利用加密功能保护隐私笔记、密码或个人数据

## 详细使用方法与配置说明

### Docker 部署示例

#### 基本部署（docker run）

使用以下命令快速启动 Trilium Notes 容器，默认端口 8080，数据持久化到本地目录：

```bash
docker run -d \
  --name trilium \
  -p 8080:8080 \
  -v /path/to/your/trilium-data:/data \
  --restart unless-stopped \
  triliumnext/trilium
```

**参数说明**：
- `-d`：后台运行容器
- `--name trilium`：指定容器名称为 trilium
- `-p 8080:8080`：映射容器端口 8080 到主机端口 8080（可修改主机端口）
- `-v /path/to/your/trilium-data:/data`：挂载主机目录到容器内 `/data` 目录，用于持久化笔记数据
- `--restart unless-stopped`：容器退出时自动重启（除非手动停止）

#### Docker Compose 部署

创建 `docker-compose.yml` 文件，内容如下：

```yaml
version: '3'

services:
  trilium:
    image: triliumnext/trilium
    container_name: trilium
    ports:
      - "8080:8080"  # 主机端口:容器端口，可根据需要修改
    volumes:
      - ./trilium-data:/data  # 当前目录下的trilium-data目录作为数据卷
    restart: unless-stopped
    environment:
      - TRILIUM_PORT=8080  # 容器内服务端口（默认8080，修改时需同步端口映射）
```

启动容器：
```bash
docker-compose up -d
```

### 访问与基础配置

容器启动后，通过浏览器访问 `http://<主机IP>:8080` 即可打开 Trilium Notes 界面。首次使用需创建管理员账户，完成后即可开始创建和管理笔记。

### 数据迁移（从 zadam/Trilium 迁移）

TriliumNext 是原 zadam/Trilium 项目的社区维护版本，迁移方法简单：
1. 停止原 zadam/Trilium 容器
2. 使用新镜像启动容器，挂载原数据目录（`/path/to/your/trilium-data`）
3. 容器将自动使用现有数据库，无需额外配置

**版本兼容性**：v0.90.4 及以下版本与原 zadam/trilium v0.63.7 兼容，更高版本因同步协议更新，无法直接迁移。

### 配置参数说明

Trilium 容器主要通过以下方式配置：

- **数据卷挂载**：必须挂载 `/data` 目录以持久化笔记数据，否则容器重启后数据将丢失
- **端口映射**：默认使用 8080 端口，可通过 `-p` 参数修改主机映射端口
- **环境变量**：目前官方未提供额外环境变量，基础配置通过端口和数据卷实现

## 相关资源

- [官方文档](https://triliumnext.github.io/Docs)
- [GitHub 仓库](https://github.com/TriliumNext/Trilium)
- [Docker Hub 镜像](https://hub.docker.com/r/triliumnext/trilium)
- [第三方资源集合](https://github.com/Nriver/awesome-trilium)（主题、脚本、插件等）
