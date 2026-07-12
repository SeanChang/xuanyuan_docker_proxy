---
image: vesoft/nebula-graphd
description: "Nebula Graph Graphd服务镜像。https://github.com/vesoft-inc/nebula"
source: https://xuanyuan.cloud/zh/r/vesoft/nebula-graphd
canonical: https://xuanyuan.cloud/zh/r/vesoft/nebula-graphd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vesoft/nebula-graphd" title="vesoft/nebula-graphd Docker 镜像中文简介、标签列表与拉取命令">vesoft/nebula-graphd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Nebula 概述

**Nebula** 是世界上唯一能够承载数十亿顶点（节点）和数万亿边的图数据库，同时仍能提供毫秒级延迟。

**Nebula** 的目标是为超大规模图提供高并发、低延迟的读写和计算能力。Nebula 是一个开源项目，我们期待与社区共同推广和发展图数据库。

作为图数据库，**Nebula** 具有以下特性：
* 对称分布式
* 高可扩展性
* 容错
* 强数据一致性
* 类SQL查询语言

## 获取 Nebula

除了从源码安装 **Nebula Graph** 外，您还可以使用 [官方 Nebula Graph 镜像](https://hub.docker.com/r/vesoft/nebula-graph/tags)。有关安装 Nebula Graph 的更多详细信息，请参见 [快速开始](docs/get-started.md)。

### Docker 部署方案示例
1. 拉取官方镜像：
   ```bash
   docker pull docker.xuanyuan.run/vesoft/nebula-graph:latest
   ```
2. 运行容器（需根据实际元数据服务配置调整参数）：
   ```bash
   docker run -d --name nebula-graphd --network=nebula-net -p 9669:9669 docker.xuanyuan.run/vesoft/nebula-graph:latest graphd --meta_server_addrs=meta0:9559,meta1:9559,meta2:9559
   ```
   > 注：Nebula Graph 部署需配合元数据服务（meta）和存储服务（storage），建议参考官方 [Docker Compose 部署文档](https://docs.nebula-graph.io/current/4.deployment-and-installation/2.compile-and-install-nebula/3.install-nebula-with-docker-compose/) 进行完整部署。

## 如何贡献

作为 **Nebula** 的开发团队，我们全力投入社区并致力于开源项目。所有核心功能均已并将继续在开源仓库中实现。

我们鼓励社区参与本项目，您可以通过以下方式贡献：

* 下载并试用 **Nebula**，并提供反馈
* 提交功能需求和错误报告
* 完善文档
* 修复错误或实现功能。有关如何构建项目和提交拉取请求的更多详细信息，请点击 [`贡献指南`](https://github.com/vesoft-inc/nebula/blob/master/docs/how-to-contribute.md)。

## 许可协议

**Nebula** 基于 [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) 许可证，因此您可以自由下载、修改、部署源代码以满足您的需求。您也可以自由部署 **Nebula** 作为后端服务来支持您的 SaaS 部署。

为防止云服务提供商在未贡献的情况下将项目商业化，我们在项目中添加了 [Commons Clause 1.0](https://commonsclause.com/)。如前所述，我们全力致力于开源社区。我们希望听取您对许可模型的想法，并愿意使其更适合社区。

## 联系我们
- 请使用 [`GitHub issue 跟踪器`](https://github.com/vesoft-inc/nebula/issues) 提交错误或功能需求。
- 加入 [![](https://img.shields.io/badge/slack-nebula-519dd9.svg)](https://nebulagraph.slack.com/archives/DJQC9P0H5/p1557815158000200)。
