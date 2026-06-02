<!-- xuanyuan-docker-images-zh
image: navyd/rsshub
source: https://xuanyuan.cloud/zh/r/navyd/rsshub
canonical: https://xuanyuan.cloud/zh/r/navyd/rsshub
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/navyd/rsshub" title="navyd/rsshub Docker 镜像中文简介、标签列表与拉取命令">navyd/rsshub — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/navyd/rsshub" title="navyd/rsshub Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/navyd/rsshub</a></p>

# RSSHub Docker镜像文档

![RSSHub](https://docs.rsshub.app/img/logo.png)

## 镜像概述

RSSHub是全球最大的RSS网络，由超过5000个全球实例组成，聚合各类来源的内容生成标准化RSS订阅源。该项目由活跃的开源社区维护，持续提供新路由、功能更新和错误修复，每月处理数百万内容请求，为用户提供稳定、丰富的RSS订阅服务。

## 核心功能与特性

- **广泛内容聚合**：从网站、社交媒体、论坛等多种来源聚合内容，生成统一的RSS订阅源
- **庞大网络规模**：全球部署5000多个实例，确保服务高可用性和广泛覆盖范围
- **活跃开源社区**：持续更新新路由和功能，快速响应bug修复，社区贡献活跃
- **多平台部署支持**：提供Docker、npm等多种部署方式，适配不同使用环境
- **高可靠性保障**：通过GitHub Actions持续集成测试，代码覆盖率高，稳定性强

## 使用场景与适用范围

- **个人信息聚合**：用户通过RSS阅读器订阅各类内容（如新闻、博客、社交媒体动态），实现信息集中获取
- **内容平台数据源**：作为内容源集成到自定义内容平台或应用中，提供丰富的信息来源
- **开发者工具集成**：为开发RSS相关应用提供标准化的数据接口，简化开发流程
- **企业信息监控**：聚合行业动态、竞争对手信息、技术文档等，辅助企业决策分析

## 部署与使用方法

### Docker快速启动

使用以下命令快速部署RSSHub容器：

```docker
docker run -d -p 1200:1200 --name rsshub diygod/rsshub
```

容器启动后，通过 `http://localhost:1200` 访问服务，通过 `http://localhost:1200/[路由]` 格式的URL获取具体订阅源（路由列表可参考[官方文档](https://docs.rsshub.app/)）。

### Docker Compose部署

创建 `docker-compose.yml` 文件进行配置部署：

```yaml
version: '3'
services:
  rsshub:
    image: diygod/rsshub
    ports:
      - "1200:1200"  # 端口映射，主机端口:容器端口
    restart: always  # 自动重启策略
    environment:
      # 可选环境变量配置
      - PORT=1200        # 服务监听端口，默认1200
      - CACHE_EXPIRE=300 # 内容缓存过期时间(秒)，默认300
      - PROXY_URI=       # 代理服务器地址(如需访问受限内容)
```

执行以下命令启动服务：

```bash
docker-compose up -d
```

### 配置参数说明

RSSHub支持通过环境变量进行自定义配置，常用参数如下：

| 环境变量        | 说明                          | 默认值  |
|-----------------|-------------------------------|---------|
| `PORT`          | 服务监听端口                  | 1200    |
| `CACHE_EXPIRE`  | 内容缓存过期时间(秒)          | 300     |
| `PROXY_URI`     | 全局代理服务器地址            | 无      |
| `LOG_LEVEL`     | 日志级别(debug/info/warn/error) | info    |
| `NODE_ENV`      | 运行环境(production/development) | production |

更多配置参数请参考[官方部署文档](https://docs.rsshub.app/deploy/)。

## 相关项目

- **RSSHub Radar**：浏览器扩展，帮助快速发现和订阅当前网站的RSS和RSSHub源
- **RSSBud**：iOS平台的RSSHub Radar，专为移动生态系统优化
- **RSSAid**：Android平台的RSSHub Radar，基于Flutter开发
- **DocSearch**：将RSSHub文档搜索功能集成到Raycast

## 贡献指南

欢迎所有形式的贡献，包括但不限于：

- 提交新路由实现
- 修复bug或优化代码
- 改进文档或翻译
- 提供功能建议

贡献前请参考[快速入门指南](https://docs.rsshub.app/joinus/)，建议和反馈可通过[GitHub Issues](https://github.com/DIYgod/RSSHub/issues)提交。

## 致谢

RSSHub的发展离不开全球贡献者的支持，详细贡献者列表可查看[GitHub贡献者页面](https://github.com/DIYgod/RSSHub/graphs/contributors)。特别感谢Logo设计者sheldonrrr，以及Cloudflare、Netlify、1Password等赞助方的支持。

## 项目信息

- **官方文档**：[docs.rsshub.app](https://docs.rsshub.app)
- **GitHub仓库**：[DIYgod/RSSHub](https://github.com/DIYgod/RSSHub)
- **许可证**：[MIT](https://github.com/DIYgod/RSSHub/blob/master/LICENSE)
- **维护者**：DIYgod及开源社区贡献者

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/navyd/rsshub" title="navyd/rsshub Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/navyd/rsshub</a></p>
