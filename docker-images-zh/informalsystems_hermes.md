---
image: informalsystems/hermes
description: "Hermes是Inter-Blockchain Communication (IBC)中继器的Rust实现，用于在不同区块链间中继IBC消息，支持跨链通信协议的可靠数据传输。"
source: https://xuanyuan.cloud/zh/r/informalsystems/hermes
canonical: https://xuanyuan.cloud/zh/r/informalsystems/hermes
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/informalsystems/hermes" title="informalsystems/hermes Docker 镜像中文简介、标签列表与拉取命令">informalsystems/hermes 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Hermes IBC 中继器镜像

### 镜像概述和主要用途
Hermes是基于Rust实现的Inter-Blockchain Communication (IBC)中继器，旨在为独立区块链网络提供安全、高效的跨链消息中继服务。IBC协议允许不同区块链通过标准化接口进行数据和资产交互，而Hermes作为中继器负责在这些区块链之间传递验证后的IBC消息，是跨链通信基础设施的核心组件。

### 核心功能和特性
- **Rust语言实现**：具备高性能、内存安全和并发处理能力，适合高频跨链消息场景
- **IBC协议兼容**：全面支持IBC规范，可中继客户端更新、连接建立、通道创建及数据包传递等各类IBC消息
- **轻量级设计**：优化资源占用，可部署于多种环境（服务器、容器集群等）
- **标准化接口**：遵循IBC中继器通用规范，易于集成到现有区块链生态系统

### 官方资源
- [文档](https://hermes.informal.systems/)
- [发布版本](https://github.com/informalsystems/hermes/releases/)
- [源代码](https://github.com/informalsystems/hermes/blob/master/ci/release/hermes.Dockerfile)
- [Rust Crate](https://crates.io/crates/ibc-relayer-cli)
- [Crate文档](https://docs.rs/ibc-relayer-cli/)

### 使用场景和适用范围
Hermes适用于需要实现跨区块链通信的各类场景，包括：
- 跨链资产转移（如不同区块链间的代币转账）
- 跨链数据共享（如预言机数据、智能合约状态同步）
- 跨链智能合约交互（链间合约调用与结果返回）
- 区块链生态互联互通（连接独立区块链网络形成跨链体系）

### 使用方法和配置说明

#### 镜像基础信息
- **运行用户**：`hermes`（非root用户，确保运行安全性）
- **用户家目录**：`/home/hermes`（配置文件和数据默认存储路径，建议挂载持久化）
- **二进制路径**：`/usr/bin/hermes`（可直接调用hermes命令）
- **默认入口点**：`/usr/bin/hermes`（容器启动时默认执行hermes命令）
- **标签说明**：镜像无`latest`标签，需从[官方标签列表](https://hub.docker.com/r/informalsystems/hermes/tags?page=1&ordering=last_updated)选择特定版本（如`v1.10.0`）使用

#### Docker部署示例

##### 1. 验证镜像版本
```bash
docker run --rm docker.xuanyuan.run/informalsystems/hermes:v1.10.0 version
```

##### 2. 启动中继服务（带配置文件挂载）
Hermes依赖配置文件定义中继的区块链网络信息（如节点地址、客户端参数等），配置文件通常位于`/home/hermes/.hermes/config.toml`。运行时需将本地配置目录挂载到容器的用户家目录：

```bash
docker run -d \
  --name hermes-relayer \
  -v /path/to/local/config:/home/hermes/.hermes \
  docker.xuanyuan.run/informalsystems/hermes:v1.10.0 \
  start
```

#### 常用命令参考
Hermes支持丰富的子命令，核心功能包括：
- `config generate`：自动生成区块链网络配置文件
- `keys add`：添加区块链账户密钥（用于消息签名）
- `start`：启动中继服务，监听并转发IBC消息
- `query`：查询IBC网络状态（如通道、连接、客户端信息）
- `tx`：手动触发IBC交易（如客户端更新、通道创建）

详细命令及配置说明可查阅[官方文档](https://hermes.informal.systems/)。
