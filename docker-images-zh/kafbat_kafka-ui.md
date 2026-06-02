---
image: kafbat/kafka-ui
description: "Apache Kafka的Kafbat UI镜像，提供可视化用户界面，用于管理和监控Apache Kafka集群。"
source: https://xuanyuan.cloud/zh/r/kafbat/kafka-ui
canonical: https://xuanyuan.cloud/zh/r/kafbat/kafka-ui
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kafbat/kafka-ui" title="kafbat/kafka-ui Docker 镜像中文简介、标签列表与拉取命令">kafbat/kafka-ui — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kafbat/kafka-ui" title="kafbat/kafka-ui Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kafbat/kafka-ui</a>

# Kafbat UI Docker镜像技术文档


## 镜像概述和主要用途

Kafbat UI（前身为kafka-ui）是一款免费开源的Web UI工具，用于监控和管理Apache Kafka集群。它提供直观的界面，帮助用户观察数据流、快速排查问题并优化性能。通过轻量级仪表盘，用户可以轻松跟踪Kafka集群的关键指标，包括Broker、主题（Topic）、分区（Partition）、生产和消费情况。

Kafbat UI由Kafbat团队开发，自豪地继承了原UI Apache Kafka项目的遗产。团队致力于项目的持续演进，在坚持其核心愿景的同时适应现代需求。感谢Provectus过去的开创性支持，这为当前的创新和发展奠定了基础。Kafbat团队由项目初始阶段的主要贡献者组成，拥有丰富的经验和洞察力。


## 核心功能和特性

### 多集群管理
在单一界面中监控和管理所有Kafka集群，实现集中化管控。

### 性能监控与指标仪表盘
通过轻量级仪表盘跟踪关键Kafka指标，实时掌握集群性能状态。

### Kafka Broker查看
查看主题和分区分配情况、控制器状态等Broker详细信息。

### Kafka Topic查看
查看分区数量、副本状态及自定义配置，全面了解主题属性。

### 消费者组（Consumer Groups）查看
查看每个分区的停放偏移量（parked offsets）、合并滞后量（combined lag）及分区级滞后量（per-partition lag）。

### 消息浏览
支持JSON、纯文本和Avro编码格式的消息浏览，方便数据验证和调试。

### 动态主题配置
通过界面快速创建和配置新主题，支持动态调整主题参数。

### 可配置认证
支持可选的Github/Gitlab/Google OAuth 2.0认证，保障安装安全性。

### 自定义序列化/反序列化插件
支持现成的序列化/反序列化工具（如AWS Glue、Smile），或自定义开发插件。

### 基于角色的访问控制（RBAC）
通过细粒度权限管理，控制用户对UI的访问权限。

### 数据屏蔽
对主题消息中的敏感数据进行脱敏处理，保护数据安全。


## 使用场景和适用范围

- **多Kafka集群环境**：适用于需要集中监控和管理多个Kafka集群的团队，减少跨集群切换成本。
- **Kafka运维监控**：运维人员可通过指标仪表盘实时跟踪集群性能，及时发现并解决问题。
- **开发调试**：开发人员可浏览消息内容、查看消费者组滞后情况，加速应用调试。
- **主题和消费者组管理**：需要频繁创建、配置主题或监控消费者组状态的场景。
- **企业级安全管控**：需通过认证、RBAC和数据屏蔽保障Kafka集群访问安全的企业环境。


## 详细使用方法和配置说明

### 快速启动（Demo运行）

适用于临时试用，无需持久化配置：

```bash
docker run -it -p 8080:8080 -e DYNAMIC_CONFIG_ENABLED=true ghcr.io/kafbat/kafka-ui
```

启动后，通过 `http://localhost:8080` 访问Web UI。试用后可迁移至**持久化安装**。


### 持久化安装

通过`docker-compose`实现持久化部署，支持自定义配置：

```yaml
services:
  kafbat-ui:
    container_name: kafbat-ui
    image: ghcr.io/kafbat/kafka-ui:latest
    ports:
      - 8080:8080  # 映射Web UI端口
    environment:
      DYNAMIC_CONFIG_ENABLED: 'true'  # 启用动态配置
    volumes:
      - ~/kui/config.yml:/etc/kafkaui/dynamic_config.yaml  # 挂载自定义配置文件
```

**说明**：  
- `~/kui/config.yml`：本地配置文件路径，需根据实际需求编写（参考[配置文件说明](https://ui.docs.kafbat.io/configuration/configuration-file)）。  
- `DYNAMIC_CONFIG_ENABLED: 'true'`：启用动态配置，使挂载的配置文件生效。


### Helm Charts部署

适用于Kubernetes环境，快速部署Kafbat UI：

参考[Helm Charts快速启动](https://ui.docs.kafbat.io/configuration/helm-charts/quick-start)。


### 从源码构建

如需自定义功能，可从源码构建镜像：

参考[源码构建指南](https://ui.docs.kafbat.io/development/building/prerequisites)。


### 健康检查

- **存活和就绪探针**：端点为 `/actuator/health`，用于容器健康状态检测。  
- **构建信息端点**： `/actuator/info`，返回应用构建信息。


## 配置参数说明

### 关键环境变量

| 环境变量                | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| `DYNAMIC_CONFIG_ENABLED` | 是否启用动态配置，值为`true`或`false`，持久化安装需设为`true`。       |

### 配置文件

持久化安装时，需通过挂载配置文件（如`dynamic_config.yaml`）自定义集群、认证等参数。配置文件语法及示例参考[配置文件说明](https://ui.docs.kafbat.io/configuration/configuration-file)。

### 其他配置

- **认证配置**：支持OAuth 2.0（Github/Gitlab/Google），参考[认证文档](https://ui.docs.kafbat.io/configuration/authentication)。  
- **序列化/反序列化插件**：配置自定义Serde，参考[Serde文档](https://ui.docs.kafbat.io/configuration/serialization-serde)。  
- **RBAC权限管理**：配置用户角色和权限，参考[RBAC文档](https://ui.docs.kafbat.io/configuration/rbac-role-based-access-control)。  


## 界面预览

![Kafbat UI界面](https://raw.githubusercontent.com/kafbat/kafka-ui/images/overview.gif)


## 贡献与支持

### 贡献指南
参考[贡献文档](https://ui.docs.kafbat.io/development/contributing)参与项目开发。

### 支持项目
Kafbat团队独立运作，成员利用业余时间贡献代码。如需赞助，可访问[赞助页面](https://github.com/sponsors/kafbat)。
