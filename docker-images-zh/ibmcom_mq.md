---
image: ibmcom/mq
description: "IBM MQ Advanced for Developers是消息中间件，用于简化和加速跨平台应用程序与业务数据的集成，现Docker Hub不再托管9.2.4之后版本，需从IBM Container Registry获取，仅保留旧版本供兼容性使用。"
source: https://xuanyuan.cloud/zh/r/ibmcom/mq
canonical: https://xuanyuan.cloud/zh/r/ibmcom/mq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ibmcom/mq" title="ibmcom/mq Docker 镜像中文简介、标签列表与拉取命令">ibmcom/mq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# IBM MQ Advanced for Developers Docker镜像文档

## 已弃用（Deprecated）

**Docker Hub上不再托管9.2.4之后版本的IBM MQ**。如需最新版本，请从IBM Container Registry下载。

IBM® MQ是消息中间件，可简化和加速跨多个平台的不同应用程序和业务数据的集成。它使用消息队列促进信息交换，并为云、移动、物联网（IoT）和本地环境提供单一消息解决方案。

通过连接从简单的应用程序对到最复杂的业务环境的几乎所有内容，IBM MQ帮助您提高业务响应能力、控制成本、降低风险，并从移动、IoT和传感器数据中获取实时洞察。

## 维护中的镜像（Maintained images）

**Docker Hub上没有积极维护的镜像**。请改用IBM Container Registry：

* MQ Advanced for Developers 9.3.0：`icr.io/ibm-messaging/mq:9.3.2.0-r2`

## 未维护的镜像（Unmaintained images）

以下镜像标签及其对应的`Dockerfile`链接不再积极维护安全修复，或使用不再受支持的MQ版本。建议避免使用这些镜像，但为兼容性保留，可能随时撤回：

- `9.2.4.0-r1`、`latest`（[Dockerfile](https://github.com/ibm-messaging/mq-container/blob/9.2.4/Dockerfile-server)）
- `9.2.3.0-r1`（[Dockerfile](https://github.com/ibm-messaging/mq-container/blob/9.2.3/Dockerfile-server)）
- `9.2.2.0-r1`（[Dockerfile](https://github.com/ibm-messaging/mq-container/blob/9.2.2/Dockerfile-server)）
- `9.2.1.0-r1`（[Dockerfile](https://github.com/ibm-messaging/mq-container/blob/9.2.1/Dockerfile-server)）
- `9.2.0.0-r2`（[Dockerfile](https://github.com/ibm-messaging/mq-container/blob/9.2.0/Dockerfile-server)）
- `9.2.0.0-r1`（[Dockerfile](https://github.com/ibm-messaging/mq-container/blob/9.2.0/Dockerfile-server)）
- `9.1.5.0-r2`

**所有镜像均为“持续交付”（CD）版本，自9.1.0.0起可下载一年，新版本将取代旧版本**。如要使用MQ V8.0.0或V9.0.0，请参见[此示例](https://github.com/ibm-messaging/mq-docker/)构建自己的镜像。

## 快速参考（Quick reference）

- **许可证**：  
  [IBM MQ Advanced for Developers](https://www14.software.ibm.com/cgi-bin/weblap/lap.pl?popup=Y&li_formnum=L-APIG-BYHCL7) 和 [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)。注意：IBM MQ Advanced for Developers许可证不允许进一步分发，且条款限制仅用于开发机器。

- **获取帮助**：  
  [IBM MQ文档](https://www.ibm.com/docs/en/ibm-mq/9.2?topic=mq-in-containers-cloud-pak-integration)

- **提交问题**：  
  [GitHub](https://github.com/ibm-messaging/mq-container/issues)

- **维护者**：  
  IBM

- **支持的架构**：  
  `amd64`、`s390x`

## 概述（Overview）

在容器中运行[IBM® MQ Advanced for Developers](https://www.ibm.com/products/mq/advanced)。

## 使用方法（Usage）

有关运行容器的详细信息，请参见[使用文档](https://github.com/ibm-messaging/mq-container/blob/master/docs/usage.md)。

注意，使用该镜像需通过设置`LICENSE`环境变量接受IBM MQ许可证条款。

### 此镜像支持的环境变量

- **LICENSE**：设为`accept`表示同意MQ Advanced for Developers许可证；设为`view`可查看许可证。
- **LANG**：设置查看许可证时的语言。
- **LOG_FORMAT**：更改容器stdout日志格式。设为“json”使用JSON格式（每行一个JSON对象）；设为“basic”使用简单易读格式。默认值为“basic”。
- **MQ_QMGR_NAME**：设置要创建的队列管理器名称。
- **MQ_ENABLE_METRICS**：设为`true`为队列管理器生成Prometheus指标。
- **MQ_DEV**：设为`false`停止创建默认对象。
- **MQ_ADMIN_PASSWORD**：更改`admin`用户密码，至少8个字符。默认值为`passw0rd`。
- **MQ_APP_PASSWORD**：更改app用户密码。设置后，`DEV.APP.SVRCONN`通道将被保护，仅允许提供有效用户名和密码的连接，至少8个字符。MQ客户端默认无需密码，HTTP客户端默认密码为`passw0rd`。
- **MQ_TLS_KEYSTORE**：**已弃用**：参见“[提供TLS证书](https://github.com/ibm-messaging/mq-container/blob/master/docs/usage.md#supplying-tls-certificates)”。允许指定包含单个证书的PKCS#12密钥库位置，用于Web控制台和队列管理器，需配合`MQ_TLS_PASSPHRASE`使用。启用后，创建的通道将使用`TLS_RSA_WITH_AES_128_CBC_SHA256`密码规范。注意：需通过挂载卷使密钥库在容器内可用。
- **MQ_TLS_PASSPHRASE**：**已弃用**：参见“[提供TLS证书](https://github.com/ibm-messaging/mq-container/blob/master/docs/usage.md#supplying-tls-certificates)”。`MQ_TLS_KEYSTORE`引用的密钥库密码。

有关MQ Advanced for Developers镜像支持的默认开发配置详情，请参见[默认开发配置文档](https://github.com/ibm-messaging/mq-container/blob/master/docs/developer-config.md)。

## Kubernetes

如要在[Kubernetes](https://kubernetes.io)中使用IBM MQ，可参见示例[Helm](https://helm.sh/)图表：[IBM charts](https://github.com/IBM/charts)。有关在Kubernetes中使用IBM MQ的更多信息，请参见[此处](https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_9.1.0/com.ibm.mq.mcpak.doc/mcpak.htm)。

## 版权

© Copyright IBM Corporation 2015, 2022
