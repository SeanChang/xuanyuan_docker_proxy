---
image: diygod/rsshub
description: "RSSHub是全球最大的RSS网络，拥有5000+实例，聚合各类来源内容，通过开放源码社区持续提供新路由、功能和修复，实现“万物皆可RSS”。"
source: https://xuanyuan.cloud/zh/r/diygod/rsshub
canonical: https://xuanyuan.cloud/zh/r/diygod/rsshub
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/diygod/rsshub" title="diygod/rsshub Docker 镜像中文简介、标签列表与拉取命令">diygod/rsshub — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/diygod/rsshub" title="diygod/rsshub Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/diygod/rsshub</a>

# RSSHub Docker镜像文档

![RSSHub](https://docs.rsshub.app/img/logo.png)

## 镜像概述

RSSHub是全球最大的RSS网络，由超过5000个全球实例组成，致力于聚合各类来源的内容并通过RSS格式提供。其活跃的开源社区持续维护新路由、开发新功能及修复漏洞，实现了“万物皆可RSS”的理念。

## 核心功能与特性

- **庞大的内容网络**：聚合数百万来自各类平台和网站的内容
- **丰富的路由支持**：支持数千种不同来源的内容订阅
- **活跃社区维护**：开源社区持续更新路由、功能及修复漏洞
- **跨平台兼容**：可与多种RSS阅读器及相关工具集成
- **灵活部署**：支持Docker容器化部署，易于扩展和维护

## 使用场景

- **内容订阅**：为不提供RSS的网站生成RSS源
- **信息聚合**：集中获取多个平台的内容更新
- **开发者工具**：作为后端服务为应用提供标准化内容接口
- **个人知识管理**：构建个性化的信息获取渠道
- **企业信息监控**：跟踪行业动态、竞品信息等

## 部署与使用

### 拉取镜像

```bash
docker pull diygod/rsshub
```

### 基本运行

```bash
docker run -d -p 1200:1200 --name rsshub diygod/rsshub
```

服务启动后，访问 `http://localhost:1200` 即可使用。

### Docker Compose 配置

创建 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  rsshub:
    image: diygod/rsshub
    ports:
      - "1200:1200"
    environment:
      - CACHE_EXPIRE=3600  # 缓存过期时间(秒)
      - PORT=1200          # 服务端口
      # - PROXY=http://proxy:port  # 可选代理设置
    restart: always
```

启动服务：

```bash
docker-compose up -d
```

### 环境变量配置

| 环境变量 | 说明 | 默认值 |
|----------|------|--------|
| `PORT` | 服务监听端口 | 1200 |
| `CACHE_EXPIRE` | 默认缓存过期时间(秒) | 3600 |
| `CACHE_TYPE` | 缓存类型(memory/redis) | memory |
| `REDIS_URL` | Redis连接地址(当CACHE_TYPE为redis时) | redis://localhost:6379 |
| `PROXY` | 全局代理设置 | 无 |
| `USER_AGENT` | 请求User-Agent | RSSHub/1.0 (+https://rsshub.app) |
| `TIMEOUT` | 请求超时时间(毫秒) | 10000 |

## 相关项目

- [RSSHub Radar](https://github.com/DIYgod/RSSHub-Radar)：浏览器扩展，帮助快速发现和订阅当前网站的RSS
- [RSSBud](https://github.com/Cay-Zhang/RSSBud)：iOS平台的RSSHub Radar，针对移动生态优化
- [RSSAid](https://github.com/LeetaoGoooo/RSSAid)：Android平台的RSSHub Radar，基于Flutter构建
- [DocSearch](https://github.com/Fatpandac/DocSearch)：将RSSHub文档搜索集成到Raycast
- [Awesome RSSHub Routes](https://github.com/JackyST0/awesome-rsshub-routes)：精选的RSS源和RSSHub路由列表

## 贡献与支持

- **贡献代码**：欢迎提交PR，参考[快速开始](https://docs.rsshub.app/joinus/)
- **反馈问题**：在[GitHub Issues](https://github.com/DIYgod/RSSHub/issues)提交建议或反馈
- **社区支持**：加入[Telegram群组](https://t.me/rsshub)或关注[Telegram频道](https://t.me/awesomeRSSHub)获取最新动态

## 许可证

本项目采用[AGPL-3.0](https://github.com/DIYgod/RSSHub/blob/master/LICENSE)许可证。
