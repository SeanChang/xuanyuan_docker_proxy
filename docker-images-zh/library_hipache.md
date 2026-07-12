---
image: library/hipache
description: "已弃用（上游项目不再维护）；建议使用traefik、nginx、haproxy或httpd等替代方案"
source: https://xuanyuan.cloud/zh/r/library/hipache
canonical: https://xuanyuan.cloud/zh/r/library/hipache
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/hipache" title="library/hipache Docker 镜像中文简介、标签列表与拉取命令">library/hipache 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# **已弃用**

由于上游项目不再活跃（最后更新于2015年2月，[2d36766](https://github.com/hipache/hipache/commit/2d3676638f8b4b1758d70a8dffde1bef88eacf32)；最后发布于2014年4月，[0.3.1](https://github.com/hipache/hipache/releases/tag/0.3.1)），该镜像已被官方弃用。

以下是其他可能适合根据您的需求作为替代方案的HTTP代理列表：

- [mailgun/vulcand](https://hub.docker.com/r/mailgun/vulcand/)
- [traefik](https://hub.docker.com/_/traefik/)
- [nginx](https://hub.docker.com/_/nginx/)
- [haproxy](https://hub.docker.com/_/haproxy/)
- [httpd](https://hub.docker.com/_/httpd/)

# 支持的标签及对应的`Dockerfile`链接

- [`latest`, `0.3.1`（*Dockerfile*）](https://github.com/dotcloud/hipache/blob/c2d4864a663d976ff2560493fe8e0dd424b792b3/Dockerfile)

有关此镜像及其历史的更多信息，请参见[相关清单文件（`library/hipache`）](https://github.com/docker-library/official-images/blob/master/library/hipache)。此镜像通过[向`docker-library/official-images` GitHub仓库提交拉取请求](https://github.com/docker-library/official-images/pulls?q=label%3Alibrary%2Fhipache)进行更新。

有关上述各支持标签的虚拟/传输大小和各个层的详细信息，请参见[`docker-library/repo-info` GitHub仓库](https://github.com/docker-library/repo-info)中的[`repos/hipache/tag-details.md`文件](https://github.com/docker-library/repo-info/blob/master/repos/hipache/tag-details.md)。

# 什么是Hipache？

**Hipache**（发音为`hɪ'pætʃɪ`）是一个分布式代理，旨在将大量HTTP和WebSocket流量路由到数量异常多的虚拟主机，适用于后端每秒多次添加和删除的高度动态拓扑结构。它特别适合平台即服务（PaaS）和其他业务关键且多租户的环境。

Hipache最初由[dotCloud](http://www.dotcloud.com)（一家流行的平台即服务提供商）开发，用于替代其基于高度定制化nginx部署的第一代路由层。目前，它为dotCloud上托管的数万个应用程序提供生产流量服务。Hipache基于node-http-proxy库构建。

# 支持的Docker版本

此镜像官方支持Docker版本1.12.2。

对旧版本（低至1.6）的支持基于尽力而为的原则。

有关如何升级Docker守护程序的详细信息，请参见[Docker安装文档](https://docs.docker.com/installation/)。

# 用户反馈

## 问题反馈

如果您对此镜像有任何问题或疑问，请通过[GitHub issue](https://github.com/dotcloud/hipache/issues)与我们联系。如果问题与CVE相关，请先查看[`official-images`仓库上的`cve-tracker` issue](https://github.com/docker-library/official-images/issues?q=label%3Acve-tracker)。

您也可以通过[Freenode](https://freenode.net)上的`#docker-library` IRC频道联系许多官方镜像维护者。

## 贡献

我们邀请您贡献新功能、修复或更新，无论大小；我们始终欢迎拉取请求，并会尽力尽快处理。

在开始编码之前，我们建议通过[GitHub issue](https://github.com/dotcloud/hipache/issues)讨论您的计划，尤其是对于更复杂的贡献。这使其他贡献者有机会为您指明方向，提供设计反馈，并帮助您了解是否有其他人正在从事相同的工作。

## 文档

此镜像的文档存储在[`docker-library/docs` GitHub仓库](https://github.com/docker-library/docs)的[`hipache/`目录](https://github.com/docker-library/docs/tree/master/hipache)中。在尝试提交拉取请求之前，请务必熟悉该仓库的[`README.md`文件](https://github.com/docker-library/docs/blob/master/README.md)。
