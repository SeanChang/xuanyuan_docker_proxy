---
image: zytomorrow/rsshub
description: "RSSHub是全球最大的RSS网络，拥有超过5000个实例，聚合各类来源内容并提供RSS订阅服务，由活跃的开源社区维护，支持新路由、功能更新和bug修复。"
source: https://xuanyuan.cloud/zh/r/zytomorrow/rsshub
canonical: https://xuanyuan.cloud/zh/r/zytomorrow/rsshub
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zytomorrow/rsshub" title="zytomorrow/rsshub Docker 镜像中文简介、标签列表与拉取命令">zytomorrow/rsshub 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# RSSHub

![RSSHub](https://docs.rsshub.app/img/logo.png)

> 🧡 万物皆可RSS

## 镜像概述

RSSHub是全球最大的RSS网络，拥有超过5000个全球实例，可聚合各类来源的内容并提供RSS订阅服务。其活跃的开源社区持续维护新路由、开发新功能及修复漏洞，确保数百万内容的稳定分发。

## 核心功能与特性

- **全球最大RSS网络**：覆盖超过5000个实例，服务范围广泛
- **多来源内容聚合**：支持从各类平台、网站聚合内容，提供统一RSS输出
- **活跃开源社区**：持续更新路由规则、添加新功能及修复问题
- **高可用性**：稳定分发数百万内容，满足各类订阅需求
- **丰富生态支持**：配套浏览器扩展、移动应用等工具，提升使用体验

## 使用场景

- **个人用户**：订阅社交媒体、新闻网站、博客等各类平台内容，集中管理信息源
- **开发者**：集成RSSHub到应用中，快速获取第三方平台内容
- **内容聚合平台**：作为核心数据源，构建个性化内容推荐系统
- **企业/组织**：监控行业动态、竞品信息，整合内部外部内容资源

## 使用方法与配置说明

### Docker 快速部署

通过以下命令快速启动RSSHub容器：

```bash
docker run -d --name rsshub -p 1200:1200 diygod/rsshub
```

启动后，访问 `http://localhost:1200` 即可使用，默认端口为1200。

### Docker Compose 部署

创建 `docker-compose.yml` 文件：

```yaml
version: '3'
services:
  rsshub:
    image: diygod/rsshub
    container_name: rsshub
    ports:
      - "1200:1200"  # 端口映射，左侧为宿主机端口，右侧为容器内端口
    restart: always  # 自动重启
    environment:
      - CACHE_EXPIRE=300  # 缓存过期时间（秒），默认300
      - NODE_ENV=production  # 运行环境，默认production
      # 更多环境变量配置可参考官方文档
    volumes:
      - ./data:/app/data  # 数据持久化（如缓存、配置文件）
```

执行以下命令启动服务：

```bash
docker-compose up -d
```

### 配置参数说明

| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `PORT` | 服务监听端口 | 1200 |
| `CACHE_EXPIRE` | 内容缓存过期时间（秒） | 300 |
| `NODE_ENV` | 运行环境 | production |
| `PROXY` | 全局代理地址 | 无 |
| `LOG_LEVEL` | 日志级别（debug/info/warn/error） | info |

更多配置参数详见 [官方部署文档](https://docs.rsshub.app/deploy/)。

## 相关项目

- **RSSHub Radar**：浏览器扩展，帮助快速发现并订阅当前网站的RSS和RSSHub源
- **RSSBud**：iOS平台的RSSHub Radar，专为移动生态优化
- **RSSAid**：Android平台的RSSHub Radar，基于Flutter构建
- **DocSearch**：将RSSHub文档搜索集成到Raycast

## 参与贡献

欢迎提交Pull Request贡献代码，也可通过 [GitHub Issues](https://github.com/DIYgod/RSSHub/issues) 提供建议和反馈。贡献指南详见 [快速开始](https://docs.rsshub.app/joinus/)。

## 致谢

### 贡献者

感谢所有为RSSHub贡献代码的开发者：

[![贡献者](https://opencollective.com/RSSHub/contributors.svg?width=890)](https://github.com/DIYgod/RSSHub/graphs/contributors)

### 赞助商

特别感谢以下机构的支持：

<a href="https://www.cloudflare.com" target="_blank"><img height="50px" src="https://i.imgur.com/7Ph27Fq.png"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.netlify.com" target="_blank"><img height="40px" src="https://i.imgur.com/cU01915.png"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://1password.com" target="_blank"><img height="40px" src="https://i.imgur.com/a2XjflO.png"></a>

## 关于作者

**RSSHub** 由 [DIYgod](https://github.com/DIYgod) 开发，基于 [MIT 许可证](./LICENSE) 开源。项目由DIYgod及 contributors 共同维护。

> 博客 [@DIYgod](https://diygod.cc) · GitHub [@DIYgod](https://github.com/DIYgod) · X（原Twitter）[@DIYgod](https://x.com/DIYgod) · Telegram频道[@awesomeDIYgod](https://t.me/awesomeDIYgod)
