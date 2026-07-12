---
image: jellyfin/jellyfin-vue
description: "Jellyfin Vue是Jellyfin媒体服务器的替代Web前端，基于Vue.js构建的实验性客户端。"
source: https://xuanyuan.cloud/zh/r/jellyfin/jellyfin-vue
canonical: https://xuanyuan.cloud/zh/r/jellyfin/jellyfin-vue
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jellyfin/jellyfin-vue" title="jellyfin/jellyfin-vue Docker 镜像中文简介、标签列表与拉取命令">jellyfin/jellyfin-vue 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jellyfin Vue

## 镜像概述

Jellyfin Vue是Jellyfin项目的一部分，是一个基于Vue.js开发的实验性Web客户端，旨在作为Jellyfin媒体服务器的替代Web前端。该项目专注于提供现代化的用户界面和交互体验，欢迎社区贡献与改进。

## 核心功能与特性

- **Vue.js技术栈**：采用Vue.js框架构建，具备组件化开发和响应式设计特性
- **实验性项目**：持续迭代开发，整合前沿前端技术与设计理念
- **开源许可**：遵循GPL 3.0开源许可协议，支持完全自定义与二次开发
- **容器化部署**：提供Docker镜像，支持跨平台快速部署

## 使用场景

- 替代Jellyfin默认Web界面，提升媒体管理与播放的用户体验
- 开发与测试Jellyfin前端新功能，参与开源项目贡献
- 构建个性化的媒体服务器Web管理界面

## 使用方法

### 镜像获取

可从以下平台获取官方镜像：
- Docker Hub: `jellyfin/jellyfin-vue`
- GitHub Container Registry (GHCR): `ghcr.io/jellyfin/jellyfin-vue`

### 基本部署命令

```bash
docker run -d \
  --name jellyfin-vue \
  -p 8080:80 \
  --restart unless-stopped \
  docker.xuanyuan.run/jellyfin/jellyfin-vue:latest
```

### Docker Compose配置示例

```yaml
version: '3.8'
services:
  jellyfin-vue:
    image: docker.xuanyuan.run/jellyfin/jellyfin-vue:latest
    container_name: jellyfin-vue
    ports:
      - "8080:80"  # 映射容器80端口到主机8080端口
    restart: unless-stopped
    # 如需持久化配置，可添加 volumes 映射
    # volumes:
    #   - ./config:/app/config
```

## 访问与配置

1. 容器启动后，通过浏览器访问 `http://<服务器IP>:8080` 即可打开界面
2. 首次使用需配置Jellyfin服务器连接信息（服务器地址、端口等）
3. 详细配置选项与高级功能请参考[项目主仓库文档](https://github.com/jellyfin/jellyfin-vue)

## 注意事项

- 该项目处于实验阶段，可能存在功能不稳定或兼容性问题
- 建议配合Jellyfin服务器最新稳定版使用以获得最佳体验
- 项目演示地址：[https://jf-vue.pages.dev/](https://jf-vue.pages.dev/)

## 相关资源

- 项目主页：[GitHub仓库](https://github.com/jellyfin/jellyfin-vue)
- 官方文档：[主仓库README](https://github.com/jellyfin/jellyfin-vue#readme)
- 社区支持：[Jellyfin矩阵频道](https://matrix.to/#/+jellyfin:matrix.org)
