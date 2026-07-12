---
image: ejabberd/ecs
description: "ejabberd社区服务器官方Docker镜像，基于Alpine Linux构建，提供开源、稳定、可扩展的实时平台，包含XMPP服务器、MQTT Broker和SIP服务，便于快速部署和配置。"
source: https://xuanyuan.cloud/zh/r/ejabberd/ecs
canonical: https://xuanyuan.cloud/zh/r/ejabberd/ecs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ejabberd/ecs" title="ejabberd/ecs Docker 镜像中文简介、标签列表与拉取命令">ejabberd/ecs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ejabberd社区服务器Docker镜像

## 镜像概述

ejabberd是一个基于[Erlang/OTP][erlang]构建的开源、健壮、可扩展且可扩展的实时平台，包含[XMPP][xmpp]服务器、[MQTT][mqtt] Broker和[SIP][sip]服务。更多特性可查看[ejabberd.im][im]、[ejabberd文档][features]、[ProcessOne的ejabberd页面][p1home]以及[支持的协议和XEPs列表][xeps]。

`ejabberd/ecs` Docker镜像是使用[docker-ejabberd/ecs](https://github.com/processone/docker-ejabberd/tree/master/ecs)构建的ejabberd稳定版本，基于Alpine Linux，旨在提供易于设置和配置的简单镜像。

## 核心功能与特性

- **多协议集成**：一站式提供XMPP服务器、MQTT消息代理和SIP服务，满足多样化实时通信需求
- **开源可靠**：基于Erlang/OTP架构，具备高并发处理能力和容错特性，适合生产环境使用
- **轻量高效**：以Alpine Linux为基础，镜像体积小，资源占用低，部署效率高
- **稳定版本**：对应ejabberd稳定发布版，确保功能稳定性和兼容性
- **简化配置**：提供优化的默认配置，降低初始部署门槛

## 使用场景

- 构建企业或社区即时通讯系统（基于XMPP协议）
- 物联网设备间通信（基于MQTT协议）
- VoIP服务部署与语音通信（基于SIP协议）
- 需要实时消息传递的Web应用或移动应用后端

## 使用方法与配置

详细使用方法和配置说明请参考[ejabberd/ecs README](https://github.com/processone/docker-ejabberd/tree/master/ecs#readme)。

### 问题反馈渠道

- 镜像打包相关问题：[docker-ejabberd Issues](https://github.com/processone/docker-ejabberd/issues)
- ejabberd核心功能问题：[ejabberd Issues](https://github.com/processone/ejabberd/issues)

## 支持的架构

当前`ejabberd/ecs`镜像仅支持`linux/amd64`架构。

## 替代镜像（GitHub Packages）

GitHub Packages提供另一个ejabberd容器镜像，可从GitHub Container Registry下载，其特性与`ejabberd/ecs`相比有以下差异：

- **架构支持**：同时支持`linux/amd64`和`linux/arm64`
- **版本覆盖**：除稳定版外，还提供`master`分支构建（开发版）
- **配置精简**：对基础ejabberd的自定义修改较少，更贴近官方原生配置
- **数据路径**：数据存储目录为`/opt/ejabberd/`（`ejabberd/ecs`为`/home/ejabberd/`）

详细文档参见[CONTAINER](https://github.com/processone/ejabberd/blob/master/CONTAINER.md)。

[im]: https://ejabberd.im/
[erlang]: https://www.erlang.org/
[xmpp]: https://xmpp.org/
[mqtt]: https://mqtt.org/
[sip]: https://en.wikipedia.org/wiki/Session_Initiation_Protocol
[features]: https://docs.ejabberd.im/admin/introduction/
[p1home]: https://www.process-one.net/en/ejabberd/
[xeps]: https://www.process-one.net/en/ejabberd/protocols/
