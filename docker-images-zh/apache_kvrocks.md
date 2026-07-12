---
image: apache/kvrocks
description: "Apache Kvrocks 是一款分布式键值NoSQL数据库，使用RocksDB作为存储引擎，兼容Redis协议，旨在降低内存成本并增加容量。"
source: https://xuanyuan.cloud/zh/r/apache/kvrocks
canonical: https://xuanyuan.cloud/zh/r/apache/kvrocks
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/kvrocks" title="apache/kvrocks Docker 镜像中文简介、标签列表与拉取命令">apache/kvrocks 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Kvrocks Docker镜像文档

## 镜像概述和主要用途

Apache Kvrocks 是一款分布式键值NoSQL数据库，采用RocksDB作为存储引擎，且兼容Redis协议。与Redis相比，Kvrocks的核心目标是降低内存使用成本并提升存储容量，适用于需要高效键值存储且对内存资源敏感的场景。

## 核心功能和特性

- **Redis兼容**：支持通过任何Redis客户端访问，无需修改现有客户端代码。
- **命名空间**：类似Redis的SELECT命令，但为每个命名空间配备独立令牌，增强权限控制。
- **复制机制**：采用类MySQL的binlog实现异步复制，保障数据一致性。
- **高可用性**：支持Redis哨兵模式，在主节点或从节点故障时自动执行故障转移。
- **集群支持**：采用集中式管理架构，同时兼容任何Redis集群客户端访问。

## 可用镜像标签

当前提供x64和aarch64两种架构的镜像，包含以下标签：

- `nightly`：`unstable`分支的最新 nightly 镜像，由GitHub Actions自动构建上传。
- `nightly-<date>-<commit hash>`：`unstable`分支特定提交的 nightly 镜像，格式为`nightly-<日期>-<提交哈希>`（如`nightly-20240126-3ea7f4f`），由GitHub Actions自动构建上传。
- `<version>`：特定版本的正式发布镜像，由Apache Kvrocks PMC官方发布，如`2.14.0`、`2.13.0`、`2.12.1`。
- `latest`：最新正式发布版本的镜像。

> **注意**：所有nightly镜像仅用于测试目的，生产环境中请使用特定`<version>`标签或`latest`标签。

## 更多信息

详细文档和使用指南请参考官方资源：
- GitHub仓库：https://github.com/apache/kvrocks
- 官方网站：https://kvrocks.apache.org
