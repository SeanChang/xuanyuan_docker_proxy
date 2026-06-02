---
image: tonyrl/rsshub
description: "RSSHub是全球最大的RSS网络，拥有5000多个实例，聚合各类来源内容，提供丰富的RSS订阅服务，由活跃的开源社区维护更新。"
source: https://xuanyuan.cloud/zh/r/tonyrl/rsshub
canonical: https://xuanyuan.cloud/zh/r/tonyrl/rsshub
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tonyrl/rsshub" title="tonyrl/rsshub Docker 镜像中文简介、标签列表与拉取命令">tonyrl/rsshub — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/tonyrl/rsshub" title="tonyrl/rsshub Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/tonyrl/rsshub</a>

# RSSHub

## 概述

RSSHub是全球最大的RSS网络，由5000多个全球实例组成，聚合来自各类来源的数百万内容。其活跃的开源社区持续提供新路由、新功能开发及bug修复，确保内容的稳定交付。

## 核心功能与特性

- **庞大的网络规模**：拥有5000+全球实例，是世界最大的RSS网络
- **多源内容聚合**：整合各类平台、网站内容，提供统一的RSS输出
- **活跃社区支持**：开源社区持续贡献新路由、功能优化和问题修复
- **丰富生态系统**：配套浏览器扩展、移动应用等工具，提升使用体验

## 使用场景与适用范围

- **个人内容订阅**：用户可通过RSSHub订阅各类网站、社交媒体、论坛等平台内容
- **开发者集成**：作为RSS数据源集成到应用、服务或自动化工作流中
- **内容聚合平台**：为内容聚合服务提供结构化的信息源
- **信息监控工具**：用于跟踪特定主题、关键词或平台的更新动态

## 使用方法与配置说明

### Docker部署

#### 基础部署（docker run）

```bash
docker run -d --name rsshub -p 1200:1200 diygod/rsshub
```

#### Docker Compose配置

```yaml
version: '3'
services:
  rsshub:
    image: diygod/rsshub
    ports:
      - "1200:1200"
    restart: always
    # 可根据需求添加环境变量配置，如：
    # environment:
    #   - CACHE_TYPE=redis
    #   - REDIS_URL=redis://redis:6379/0
```

### 访问与使用

容器启动后，通过 `http://localhost:1200` 访问服务。具体内容路由可参考[官方文档](https://docs.rsshub.app)，例如：
- 知乎专栏：`http://localhost:1200/zhihu/column/xxx`
- GitHub仓库动态：`http://localhost:1200/github/repo/DIYgod/RSSHub`

## 相关项目

- [RSSHub Radar](https://github.com/DIYgod/RSSHub-Radar)：浏览器扩展，快速发现和订阅当前网站的RSS和RSSHub
- [RSSBud](https://github.com/Cay-Zhang/RSSBud)：iOS平台的RSSHub Radar，针对移动生态优化
- [RSSAid](https://github.com/LeetaoGoooo/RSSAid)：Android平台的RSSHub Radar，基于Flutter构建
- [DocSearch](https://github.com/Fatpandac/DocSearch)：将RSSHub DocSearch集成到Raycast

## 贡献方式

欢迎提交Pull Request贡献新路由或功能，建议和反馈可通过[GitHub Issues](https://github.com/DIYgod/RSSHub/issues)提出。贡献指南详见[快速开始](https://docs.rsshub.app/joinus/)。

## 部署文档

详细部署指南（包括环境配置、缓存设置、反向代理等）请参考[官方部署文档](https://docs.rsshub.app/deploy/)。
