---
image: solace/solace-pubsub-connector-awssqs
description: "Solace PubSub+ Connector for AWS SQS是连接Solace PubSub+事件代理与AWS SQS服务的Docker镜像，用于实现两者间的消息传递，支持配置管理、健康检查及JVM参数设置。"
source: https://xuanyuan.cloud/zh/r/solace/solace-pubsub-connector-awssqs
canonical: https://xuanyuan.cloud/zh/r/solace/solace-pubsub-connector-awssqs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/solace/solace-pubsub-connector-awssqs" title="solace/solace-pubsub-connector-awssqs Docker 镜像中文简介、标签列表与拉取命令">solace/solace-pubsub-connector-awssqs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# pubsubplus-connector-awssqs
Solace Corporation https://solace.com

*版本：1.7.6*  
*版本日期：2025-07-11*

## 目录

- [前言](#前言)
- [快速开始](#快速开始)
  - [前提条件](#前提条件)
  - [使用方法](#使用方法)
  - [连接主机上的服务](#连接主机上的服务)
  - [配置健康检查](#配置健康检查)
- [提供配置](#提供配置)
- [端口](#端口)
- [卷](#卷)
  - [卷：Spring配置文件](#卷spring配置文件)
  - [卷：库文件](#卷库文件)
  - [卷：类路径文件](#卷类路径文件)
  - [卷：输出文件](#卷输出文件)
- [配置JVM](#配置jvm)
  - [支持](#支持)
- [许可证](#许可证)

## 前言

Solace PubSub+ Connector for AWS SQS（AWS SQS连接器）是用于连接Solace PubSub+事件代理与AWS SQS服务的Docker镜像，实现两者间的消息传递。

## 快速开始

[发布说明]

### 前提条件

- [Docker] 或 [Podman]
- [PubSub+ 事件代理]
- AWS SQS服务

### 使用方法

### 连接主机上的服务

若服务（如PubSub+事件代理）暴露在本地主机，可通过容器平台的特殊DNS名称结合`SOLACE_JAVA_HOST`环境变量引用，该名称会解析为主机使用的内部IP地址。

Docker示例命令：
```bash
docker run -d --name my-connector \
  -v `pwd`/libs/:/app/external/libs/:ro \
  -v `pwd`/config/:/app/external/spring/config/:ro \
  --env SOLACE_JAVA_HOST=host.docker.internal:55555 \
  docker.xuanyuan.run/solace/solace-pubsub-connector-awssqs:1.7.6
```

Podman示例命令：
```bash
podman run -d --name my-connector \
  -v `pwd`/libs/:/app/external/libs/:ro \
  -v `pwd`/config/:/app/external/spring/config/:ro \
  --env SOLACE_JAVA_HOST=host.containers.internal:55555 \
  solace/solace-pubsub-connector-awssqs:1.7.6
```

### 配置健康检查

健康检查可执行以下任务：
- 通过`SOLACE_CONNECTOR_SECURITY_USERS_0_NAME`和`SOLACE_CONNECTOR_SECURITY_USERS_0_PASSWORD`创建名为`healthcheck`的只读用户。
- 使用`healthcheck`用户轮询容器内的管理健康端点，若连接器不健康则检查失败。

Docker健康检查配置示例：
```bash
docker run -d --name my-connector \
  -v `pwd`/libs/:/app/external/libs/:ro \
  -v `pwd`/application.yml:/app/external/spring/config/application.yml:ro \
  --env SOLACE_CONNECTOR_SECURITY_USERS_0_NAME=healthcheck \
  --env SOLACE_CONNECTOR_SECURITY_USERS_0_PASSWORD=healthcheck \
  --healthcheck-command="curl -X GET -u healthcheck:healthcheck --fail localhost:8090/actuator/health" \
  docker.xuanyuan.run/solace/solace-pubsub-connector-awssqs:1.7.6
```

Podman健康检查配置示例：
```bash
podman run -d --name my-connector \
  -v `pwd`/libs/:/app/external/libs/:ro \
  -v `pwd`/application.yml:/app/external/spring/config/application.yml:ro \
  --env SOLACE_CONNECTOR_SECURITY_USERS_0_NAME=healthcheck \
  --env SOLACE_CONNECTOR_SECURITY_USERS_0_PASSWORD=healthcheck \
  --healthcheck-command="curl -X GET -u healthcheck:healthcheck --fail localhost:8090/actuator/health" \
  solace/solace-pubsub-connector-awssqs:1.7.6
```

## 提供配置

可通过以下方式为容器提供Spring配置属性：
1. 使用[环境变量]。
2. 使用[包含Spring配置文件的卷]（及其他卷）。

## 端口

容器需使用以下端口：

| 端口 | 用途 |
|------|------|
| `8090` | 连接器的管理端点 |

## 卷

以下目录支持创建卷或绑定挂载：

| 内容 | 容器路径 | 是否可选 | 推荐权限 |
|------|----------|----------|----------|
| Spring配置文件 | `/app/external/spring/config/` | 除非所有属性通过环境变量定义，否则为必填 | 只读 |
| 库文件 | `/app/external/libs/` | 必填 | 只读 |
| 类路径文件 | `/app/external/classpath/` | 可选 | 只读 |
| 输出文件 | `/app/external/output/` | 可选 | 读写 |

### 卷：Spring配置文件

该卷用于添加Spring配置文件（如`application.yml`等），需挂载为只读卷或绑定到`/app/external/spring/config/`。

此目录遵循[Spring默认`config/`目录]的语义，连接器启动时会自动从以下位置加载配置文件：
1. `/app/external/spring/config/`的根目录。
2. `/app/external/spring/config/`的直接子目录。

> **提示**  
> 若需在同一`config`目录中为不同环境（如开发、生产）配置多个连接器的文件，建议使用[Spring Boot配置文件]而非子目录。例如：  
> - 推荐配置：  
>   - `/app/external/spring/config/application-prod.yml`  
>   - `/app/external/spring/config/application-dev.yml`  
> - 不推荐配置：  
>   - `/app/external/spring/config/prod/application.yml`  
>   - `/app/external/spring/config/dev/application.yml`  
> 子目录用于合并多个配置源的属性。如需通过多子目录组合应用配置，详见[Spring Boot文档]。

### 卷：库文件

该卷用于添加额外库文件，需挂载为只读卷或绑定到`/app/external/libs/`。

此目录存放连接器特定功能所需的Java库依赖（外部JAR文件），如使用Prometheus指标导出功能时的Prometheus库。详见ZIP包中连接器`libs`目录的文档。

### 卷：类路径文件

该卷用于添加任意文件（非JAR库或Spring Boot配置文件），需挂载为只读卷或绑定到`/app/external/classpath/`。

> **注意**  
> 此目录不得包含库JAR文件或Spring Boot配置文件，否则可能导致库未被正确加载或覆盖连接器内部配置。

### 卷：输出文件

该卷用于支持生成输出文件的功能（如文件日志），需挂载为读写卷或绑定到`/app/external/output/`。

> **重要**  
> 使用生成文件的功能时，必须将文件输出路径配置为`/app/external/output/`目录。生成文件到其他目录不受支持。

## 配置JVM

可通过容器的`JDK_JAVA_OPTIONS`环境变量配置Java虚拟机（JVM）。

详见[JDK文档]。

> **提示**  
> 本容器已通过以下参数测试：  
> - 两个活动处理器（`-XX:ActiveProcessorCount=2`）  
> - 最大堆内存2 GB（`-Xmx2048m`）

### 支持

通过[Solace开发者社区]提供尽力支持。

高级支持选项可用，详情请[联系Solace]。

## 许可证

本项目采用Solace社区许可证1.0版。详见容器`/licenses`目录下的`LICENSE`文件。

[前言]: #前言
[快速开始]: #快速开始
[前提条件]: #前提条件
[使用方法]: #使用方法
[连接主机上的服务]: #连接主机上的服务
[配置健康检查]: #配置健康检查
[提供配置]: #提供配置
[端口]: #端口
[卷]: #卷
[卷：Spring配置文件]: #卷spring配置文件
[卷：库文件]: #卷库文件
[卷：类路径文件]: #卷类路径文件
[卷：输出文件]: #卷输出文件
[配置JVM]: #配置jvm
[支持]: #支持
[许可证]: #许可证
[发布说明]: https://products.solace.com/download/__TBD__PLACEHOLDER
[Docker]: https://www.docker.com/
[Podman]: https://podman.io/
[PubSub+ 事件代理]: https://solace.com/products/event-broker/
[环境变量]: https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config.typesafe-configuration-properties.relaxed-binding.environment-variables
[包含Spring配置文件的卷]: #卷spring配置文件
[Spring默认`config/`目录]: https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config.files
[Spring Boot配置文件]: https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config.files.profile-specific
[Spring Boot文档]: https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config.files.wildcard-locations
[JDK文档]: https://docs.oracle.com/en/java/javase/17/docs/specs/man/java.html#using-the-jdk_java_options-launcher-environment-variable
[Solace开发者社区]: https://solace.community/
[联系Solace]: https://solace.com/contact-us
