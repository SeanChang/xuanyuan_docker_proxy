---
image: archivebox/archivebox
description: "这是ArchiveBox自托管互联网归档工具的官方Docker镜像，该工具允许用户自行搭建服务，用于归档网页、链接、图片、视频等互联网内容，确保信息永久保存并可离线访问，无需依赖第三方平台，为个人或组织提供安全、可控的网络内容存档解决方案。"
source: https://xuanyuan.cloud/zh/r/archivebox/archivebox
canonical: https://xuanyuan.cloud/zh/r/archivebox/archivebox
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/archivebox/archivebox" title="archivebox/archivebox Docker 镜像中文简介、标签列表与拉取命令">archivebox/archivebox 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ArchiveBox：开源自托管的网页归档工具

ArchiveBox 是一款功能强大的开源自托管网页归档解决方案，帮助个人和组织收集、保存网页内容并离线查看。互联网上的内容随时可能消失或变更，虽然 Archive.org 等中心化服务做得很好，但无法保存私有内容，也不能覆盖所有类型的资源。ArchiveBox 则让你能自主掌控数据，既可以归档公开网页，也能保存私有内容（如需要登录的页面），适用于书签备份、法律证据留存、社交媒体内容存档、研究资料保存等场景。


## 核心特性

- **开源免费，本地存储**：无需在线注册，所有数据保存在本地，完全掌控隐私和数据所有权。
- **多格式全面归档**：自动提取网页中的各类内容，包括 HTML、PDF、截图、音视频、文本、代码仓库等（详见下方【输出格式】）。
- **灵活的输入方式**：支持手动添加 URL、批量导入书签/历史记录、定时抓取 RSS 订阅或社交媒体动态（详见下方【输入来源】）。
- **标准工具与格式**：基于 Chrome、wget、yt-dlp 等成熟工具，归档数据以普通文件（HTML、PDF、MP4 等）和文件夹存储，无需依赖 ArchiveBox 也能直接访问。
- **多端访问方式**：可通过命令行（CLI）、网页界面、Python API 或直接操作文件/数据库管理归档内容。


## 快速开始

### 环境要求
- 系统：Linux、macOS、Windows（建议通过 WSL2）
- 推荐配置：Docker（简化安装和依赖管理），或 Python 3.10+、Node.js 18+（手动安装）


### 安装方法（推荐 Docker Compose）

Docker Compose 是最简单的安装方式，自动包含所有依赖，适合大多数用户：

1. **安装 Docker**  
   先在系统上安装 [Docker] （如已安装可跳过）。

2. **创建目录并下载配置文件**  
   新建一个存放归档数据的目录，下载 `docker-compose.yml` 配置文件：
   ```bash
   mkdir -p ~/archivebox/data && cd ~/archivebox
   # 下载配置文件，可根据需要编辑其中的参数（如端口、存储路径）
   curl -fsSL '[]' > docker-compose.yml
   ```

3. **初始化并创建管理员用户**  
   运行初始化命令，按提示设置管理员账号（用于网页界面登录）：
   ```bash
   docker compose run archivebox init --setup
   ```

4. **启动服务并访问网页界面**  
   启动服务后，访问 `[] 即可打开网页管理界面：
   ```bash
   docker compose up
   ```


### 其他安装方式

#### 手动安装（pip）
适合熟悉命令行的用户，需手动处理依赖：
```bash
# 安装 Python 包
pip3 install --upgrade archivebox yt-dlp playwright
playwright install --with-deps chromium  # 安装 Chromium 及依赖

# 创建数据目录并初始化
mkdir -p ~/archivebox/data && cd ~/archivebox/data
archivebox init --setup  # 初始化归档库，自动安装剩余依赖
```

#### 包管理器（apt/brew 等）
- **Ubuntu/Debian**：通过 PPA 安装  
  ```bash
  sudo add-apt-repository ppa:archivebox/archivebox
  sudo apt update && sudo apt install archivebox
  ```
- **macOS**：通过 Homebrew 安装  
  ```bash
  brew tap archivebox/archivebox && brew install archivebox
  ```


## 基础使用

### 添加网页到归档

#### 命令行添加
```bash
# Docker 环境（需在 docker-compose.yml 所在目录执行）
docker compose run archivebox add '[]'

# 本地 pip 安装环境
archivebox add '[]'
```

#### 网页界面添加
打开 `[] URL】，输入网址并可选添加标签、备注。


### 查看归档内容
- **网页界面**：直接在浏览器中浏览所有归档，支持搜索、筛选标签。
- **文件系统**：归档数据保存在 `~/archivebox/data/archive` 目录，每个 URL 对应一个子文件夹，内含 HTML、PDF、截图等文件，可直接打开。
- **命令行**：查看归档列表或详情  
  ```bash
  archivebox list          # 列出所有归档
  archivebox show '[]'  # 查看指定 URL 的归档详情
  ```


## 输入来源与输出格式

### 支持的输入来源
- **手动输入**：单个 URL、多行文本中的 URL 列表。
- **书签/历史记录**：Chrome/Firefox 书签（HTML 导出）、浏览器历史记录（JSON/CSV）。
- **订阅与服务**：RSS/Atom 订阅、Pocket/Pinboard 导出文件、社交媒体动态（需配合爬虫）。
- **浏览器扩展**：通过 [ArchiveBox Exporter]  一键添加当前页面。


### 支持的输出格式
ArchiveBox 会根据网页类型自动提取多种格式，确保内容可长期保存：
- **通用网页**：原始 HTML+CSS+JS、单文件 HTML（SingleFile）、截图（PNG）、PDF、WARC 存档、标题、正文文本。
- **音视频**：/B 站等平台的视频（MP4）、音频（MP3）、字幕、缩略图、元数据。
- **社交媒体/新闻**：帖子正文、评论、作者信息、图片。
- **代码仓库**：GitHub/GitLab 链接的 Git 源码克隆、README、项目图片。


## 数据安全与长期保存

ArchiveBox 使用标准文件格式（HTML、PDF、WARC 等）存储数据，不依赖专有格式，即使未来工具停止维护，也能通过普通软件访问归档内容。建议定期备份 `~/archivebox/data` 目录，确保数据长期安全。


## 适用场景

- **个人用户**：备份浏览器书签、保存喜欢的文章/视频，防止链接失效。
- **研究者**：归档研究资料、追踪网页变更、收集社交媒体数据用于分析。
- **法律/记者**：保存网页证据，生成不可篡改的归档记录。
- **企业/组织**：存档内部文档、监控外部提及的品牌信息。

通过 ArchiveBox，你可以安心保存互联网上有价值的内容，确保即使原页面消失，这些数据也能长期留存并随时访问。
