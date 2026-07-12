---
image: ubuntu/zookeeper
description: "ZooKeeper提供集中式配置信息维护，由Canonical提供长期支持的跟踪版本。"
source: https://xuanyuan.cloud/zh/r/ubuntu/zookeeper
canonical: https://xuanyuan.cloud/zh/r/ubuntu/zookeeper
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/zookeeper" title="ubuntu/zookeeper Docker 镜像中文简介、标签列表与拉取命令">ubuntu/zookeeper 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# zookeeper | Ubuntu

当前zookeeper Docker镜像[来自Canonical](https://ubuntu.com/security/docker-images)，基于Ubuntu。接收安全更新，并滚动到更新的zookeeper或Ubuntu版本。**此仓库免费使用，且免每个用户的速率限制。**

## 关于zookeeper

来自Canonical的当前Apache ZooKeeper Docker镜像，基于Ubuntu。接收安全更新，并跟踪Apache ZooKeeper和Ubuntu的最新组合。**此仓库免费使用，且免每个用户的速率限制。**

# 关于Apache ZooKeeper

ZooKeeper是一个集中式服务，用于维护配置信息、命名、提供分布式同步和组服务。分布式应用都会以某种形式使用这些服务。在Apache网站上了解更多信息。此镜像用于支持Apache Kafka镜像。

请注意，标记为3.1及以下版本的镜像是基于Dockerfile的镜像，而从3.8.2版本开始，镜像现在是rocks。因此，入口点现在是Pebble。在[Rockcraft文档](https://canonical-rockcraft.readthedocs-hosted.com/en/latest/explanation/rocks/)上了解更多信息。

## 标签和架构

![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
长达10年的客户安全维护[来自Canonical的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)。

| 通道标签 |  | 支持至 | 当前版本 | 架构 |
|---|---|---|---|---|
| **`3.1-22.04_beta`** | **`3.1-22.04_edge`、`edge`、`latest`** | - | Ubuntu 22.04 LTS上的zookeeper 3.1 | `s390x`、`ppc64le`、`arm64`、`amd64` |
| `3.8-22.04_edge` | `3.8-22.04_edge` | - | Ubuntu 22.04 LTS上的zookeeper 3.8 | `amd64` |
| _`track_risk`_ |

通道标签按稳定性顺序显示该跟踪的最稳定通道：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐式可用。因此，如果列出了`beta`，您也可以拉取`edge`；如果列出了`candidate`，您可以拉取`beta`和`edge`；当列出`stable`时，所有四个通道都可用。镜像保证按`edge`、`beta`、`candidate`的顺序推进，然后才是`stable`。

### 商业使用和扩展安全维护通道

如果您的使用包括商业再分发，或需要ESM或不可用的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或通过rocks@canonical.com）。

## 使用方法

本地启动此镜像：

```sh
docker run -d --name zookeeper-container -e TZ=UTC -p 2181:2181 docker.xuanyuan.run/ubuntu/zookeeper:3.1-22.04_beta
```
在`http://localhost:2181`访问您的ZooKeeper服务器。

#### 参数

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 时区。 |
| `-p 2181:2181` | 将ZooKeeper服务器暴露在`localhost:2181`。 |
| `-v /path/to/config/file:/etc/zookeeper/zoo.cfg` | 本地ZooKeeper配置文件。 |
| `-v zookeeperData:/var/lib/zookeeper/data` | 在名为`zookeeperData`的Docker卷中持久化数据。确保挂载点与配置属性`dataDir`一致。 |
| `-v zookeeperLogData:/var/lib/zookeeper/data-log` | 在名为`zookeeperLogData`的Docker卷中持久化数据。确保挂载点与配置属性`dataLogDir`一致。 |

#### 测试/调试

调试容器：

```sh
docker logs -f zookeeper-container
```

获取交互式shell：

```sh
docker exec -it zookeeper-container /bin/bash
```

## 错误和功能请求

如果您在我们的镜像中发现错误或想要请求特定功能，请在此提交错误：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将错误标题设为“`zookeeper: <问题摘要>`”。确保包含您正在使用的镜像的摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/zookeeper:<tag>
```

## 已弃用的通道和标签

这些通道（标签）不再更新。请升级到更新的通道，或如果无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 跟踪 | 版本 | 生命周期结束（EOL） | 升级路径 |
|---|---|---|---|
| _`track`_ |
