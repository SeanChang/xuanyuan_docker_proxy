---
image: ojafri/kafdrop
description: "这是Kafdrop的Docker镜像，用于可视化和管理Apache Kafka集群，支持查看主题、消息、消费者组及Schema Registry集成，帮助开发者快速调试和监控Kafka服务。"
source: https://xuanyuan.cloud/zh/r/ojafri/kafdrop
canonical: https://xuanyuan.cloud/zh/r/ojafri/kafdrop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ojafri/kafdrop" title="ojafri/kafdrop Docker 镜像中文简介、标签列表与拉取命令">ojafri/kafdrop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kafdrop Docker镜像说明

## 镜像概述
本镜像基于HomeAdvisor/Kafdrop项目构建，提供Apache Kafka的Web UI工具，支持直观查看Kafka集群的主题、消息、消费者组等核心信息，简化Kafka的日常管理与调试流程。

## 核心功能
1. 查看Kafka集群的主题列表、分区分布及消息统计
2. 浏览指定主题的消息内容（支持JSON、Avro等格式解析）
3. 监控消费者组的偏移量、 lag值及成员状态
4. 集成Schema Registry，查看和管理Avro schema信息
5. 支持自定义端口与ZooKeeper地址配置

## 使用场景
- 开发者调试Kafka消息生产/消费逻辑
- 运维人员监控Kafka集群的运行状态
- 团队协作分析Kafka消息流的异常问题
- 快速验证Kafka集群的配置正确性

## 配置说明
主要环境变量配置：
- `ZK_HOSTS`：ZooKeeper集群地址（多个地址用逗号分隔）
- `KAFDROP_PORT`：Kafdrop服务监听端口（默认9000）
- `SCHEMA_REGISTRY`：Schema Registry服务地址（可选）
- `SG_FORMAT`：Schema Registry数据格式（默认DEFAULT）

## 部署示例
### 构建镜像
```bash
docker build --no-cache -f Dockerfile --rm -t kafdrop .
```

### 运行容器
```bash
docker run -i -t \
  -e ZK_HOSTS="localhost:2181,localhost:2182" \
  -e KAFDROP_PORT=9000 \
  -e SCHEMA_REGISTRY="http://localhost:8080" \
  -p 9000:9000 docker.xuanyuan.run/kafdrop
```
运行后访问`http://localhost:9000`即可进入Kafdrop UI界面。
