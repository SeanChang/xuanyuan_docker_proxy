---
image: pjf1996/rsshub
description: "RSSHub是全球最大的RSS网络，由超过5000个全球实例组成，聚合来自各种来源的数百万内容，提供丰富的RSS订阅服务，支持自定义部署。"
source: https://xuanyuan.cloud/zh/r/pjf1996/rsshub
canonical: https://xuanyuan.cloud/zh/r/pjf1996/rsshub
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [pjf1996/rsshub — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/pjf1996/rsshub)

含镜像标签、拉取命令、部署文档与相关推荐。

[pjf1996/rsshub Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/pjf1996/rsshub)

# RSSHub

## 简介

RSSHub是全球最大的RSS网络，由超过5000个全球实例组成。它聚合来自各种来源的数百万内容，充满活力的开源社区持续提供新路由、新功能和错误修复。

## 特性

- 丰富的内容聚合：从各类来源获取并整合数百万内容
- 全球分布式网络：由5000+全球实例组成的庞大网络
- 活跃的开源社区：持续更新新路由、功能和错误修复
- 多平台支持：提供多种客户端工具和集成方案

## 相关项目

- [RSSHub Radar](https://github.com/DIYgod/RSSHub-Radar)：浏览器扩展，帮助快速发现和订阅当前网站的RSS和RSSHub
- [RSSBud](https://github.com/Cay-Zhang/RSSBud)：iOS平台的RSSHub Radar，专为移动生态系统优化
- [RSSAid](https://github.com/LeetaoGoooo/RSSAid)：基于Flutter构建的Android平台RSSHub Radar
- [DocSearch](https://github.com/Fatpandac/DocSearch)：将RSSHub DocSearch链接到Raycast

## Docker部署方案

### 基本部署

```bash
# 拉取镜像
docker pull diygod/rsshub

# 运行容器
docker run -d --name rsshub -p 1200:1200 diygod/rsshub
```

### 自定义配置部署

```bash
docker run -d --name rsshub -p 1200:1200 \
  -e CACHE_TYPE=redis \
  -e REDIS_URL=redis://redis:6379/ \
  --link redis:redis \
  diygod/rsshub
```

## 贡献指南

我们欢迎所有拉取请求。建议和反馈可通过[GitHub Issues](https://github.com/DIYgod/RSSHub/issues)提出。详情请参考[贡献指南](https://docs.rsshub.app/joinus/)。

## 文档与社区

- [官方文档](https://docs.rsshub.app)
- [Telegram 群组](https://t.me/rsshub)
- [Telegram 频道](https://t.me/awesomeRSSHub)
- [X (Twitter)](https://x.com/intent/follow?screen_name=_RSSHub)

## 特别鸣谢

感谢所有贡献者对项目的支持。Logo设计者：[sheldonrrr](https://dribbble.com/sheldonrrr)。

特别感谢赞助商：Cloudflare、Netlify、1Password。

## 关于作者

**RSSHub** 由[DIYgod](https://github.com/DIYgod)创建，采用[MIT许可证](https://github.com/DIYgod/RSSHub/blob/master/LICENSE)发布。由DIYgod维护，并得到众多贡献者的帮助。
