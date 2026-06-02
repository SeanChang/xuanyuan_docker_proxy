---
image: gethomepage/homepage
description: "这是一个高度可定制的主页，支持用户根据自身需求灵活配置界面布局、功能模块及数据展示方式，通过Docker容器化技术实现环境快速部署与跨平台运行，并深度整合各类服务API接口，可无缝对接第三方应用、数据服务及业务系统，为个人用户、开发团队及企业提供高效、个性化的一站式信息聚合与管理平台。"
source: https://xuanyuan.cloud/zh/r/gethomepage/homepage
canonical: https://xuanyuan.cloud/zh/r/gethomepage/homepage
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gethomepage/homepage" title="gethomepage/homepage Docker 镜像中文简介、标签列表与拉取命令">gethomepage/homepage — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/gethomepage/homepage" title="gethomepage/homepage Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/gethomepage/homepage</a>

# Homepage 简介


Homepage 是一款现代化的应用仪表盘，具备**全静态、加载极速**、**安全的全代理模式**以及高度可定制的特性。它支持 100 多种服务集成和多语言翻译，可通过 YAML 文件或 Docker 标签自动发现轻松配置。


## 核心特性

Homepage 集快速搜索、书签、天气支持、丰富集成与组件、优雅现代设计及性能优化于一体，是日常使用的理想起点和便捷助手。主要特性包括：

- **极速加载**：构建时静态生成，实现瞬间加载。  
- **安全可靠**：所有后端服务 API 请求均通过代理转发，保护 API 密钥不泄露；社区持续参与安全审查。  
- **多平台兼容**：支持 AMD64、ARM64、ARMv7、ARMv6 等架构，适配各类设备。  
- **多语言支持**：内置 40 余种语言本地化。  
- **书签与链接**：可添加自定义服务链接和网页书签。  
- **Docker 集成**：实时显示容器状态与资源占用，支持通过标签自动发现服务。  
- **服务组件**：集成 100 多种第三方服务，涵盖主流媒体管理工具（如 Radarr、Sonarr）、下载工具（Transmission、qBittorrent）及自托管应用。  
- **信息组件**：内置天气、时间、日期、搜索等实用信息展示工具。  
- **高度定制**：支持自定义主题、CSS/JS、布局、格式及本地化配置。  


## 快速开始

### 安全提示 🔒  
Homepage 本身不含认证层，若使用组件功能可能访问个人信息（如智能家居数据）。建议部署时通过反向代理添加认证/SSL 保护，或置于  环境下使用。


### 通过 Docker 部署  

#### Docker Compose（推荐）  
创建 `docker-compose.yml` 文件：  
```yaml
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    environment:
      PUID: 1000  # 可选，你的用户 ID
      PGID: 1000  # 可选，你的用户组 ID
    ports:
      - 3000:3000  # 端口映射：主机端口:容器端口
    volumes:
      - /path/to/config:/app/config  # 本地配置目录（需提前创建）
      - /var/run/docker.sock:/var/run/docker.sock:ro  # 可选，用于 Docker 集成（只读权限）
    restart: unless-stopped
```  
执行 `docker compose up -d` 启动服务。


#### Docker Run 命令  
```bash
docker run --name homepage \
  -e PUID=1000 \
  -e PGID=1000 \
  -p 3000:3000 \
  -v /path/to/config:/app/config \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --restart unless-stopped \
  ghcr.io/gethomepage/homepage:latest
```  


### 从源码部署  

1. **克隆仓库**：  
   ```bash
   git clone []   cd homepage
   ```  

2. **安装依赖并构建**（推荐使用 pnpm）：  
   ```bash
   pnpm install  # 安装依赖
   pnpm build    # 构建生产版本
   ```  

3. **初始化配置**（首次运行）：  
   将示例配置复制到本地：  
   ```bash
   cp -r src/skeleton config/
   ```  

4. **启动服务**：  
   ```bash
   pnpm start  # 生产模式运行
   ```  


## 配置说明  

完整配置指南请参考 [官方文档]([])。所有配置项（如服务集成、组件布局、主题设置等）均通过 YAML 文件管理，文档中提供了详细示例和参数说明。


## 开发指南  

1. **安装依赖**：  
   ```bash
   pnpm install  # 使用 pnpm 安装开发依赖
   ```  

2. **启动开发服务器**：  
   ```bash
   pnpm dev  # 启动热重载开发环境，访问 []   ```  

Homepage 基于 Next.js 开发，可参考 Next.js 文档了解更多框架特性。


## 文档说明  

官方文档部署于 [[]]([])，使用 Material for MkDocs 构建。如需本地运行文档：  

1. 安装依赖：  
   ```bash
   pip install -r requirements.txt
   ```  

2. 启动本地文档服务：  
   ```bash
   mkdocs serve  # 访问 []   ```  


## 支持与贡献  

### 问题反馈  
如有疑问或建议，可通过 [GitHub Discussions]([]) 发起讨论。基础配置或网络问题可先查阅 [故障排除指南]([])。

### 贡献代码  
欢迎参与贡献！具体流程请参考 [CONTRIBUTING.md]([])。  

特别感谢超过 200 位贡献者的支持，尤其感谢 [@shamoon]([]) 对社区的长期维护。


> 项目构建由 DigitalOcean 提供支持。
