---
image: jaegertracing/jaeger-es-index-cleaner
description: "jaeger-es-index-cleaner用于清理Elasticsearch中的旧Jaeger索引，解决Elasticsearch不支持TTL过期旧数据的问题，帮助管理可观测性数据的保留时间。"
source: https://xuanyuan.cloud/zh/r/jaegertracing/jaeger-es-index-cleaner
canonical: https://xuanyuan.cloud/zh/r/jaegertracing/jaeger-es-index-cleaner
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jaegertracing/jaeger-es-index-cleaner" title="jaegertracing/jaeger-es-index-cleaner Docker 镜像中文简介、标签列表与拉取命令">jaegertracing/jaeger-es-index-cleaner 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# jaeger-es-index-cleaner 镜像文档


## 1. 镜像概述与主要用途

`jaeger-es-index-cleaner` 是一个轻量级工具镜像，用于清理 Elasticsearch 中存储的旧 Jaeger 索引。由于 Elasticsearch 本身不支持通过 TTL（Time-To-Live）机制自动过期旧数据，该工具旨在通过按时间阈值删除过期索引，帮助用户管理 Jaeger 追踪数据的生命周期，避免存储空间过度占用。


## 2. 核心功能与特性

### 2.1 核心功能
- **按时间清理索引**：根据指定的保留天数，自动识别并删除超过保留期的 Jaeger 索引（如追踪跨度、服务依赖等索引）。
- **支持 Jaeger 索引结构**：适配 Jaeger 在 Elasticsearch 中的索引命名规范（如滚动索引 `jaeger-span-YYYY-MM-DD` 或非滚动索引）。


### 2.2 关键特性
- **轻量级容器化**：以 Docker 镜像形式提供，部署简单，无需额外依赖。
- **可配置保留期**：通过命令行参数灵活指定索引保留天数。
- **滚动索引支持**：通过环境变量控制是否处理 Jaeger 的滚动索引（需显式启用）。


## 3. 使用场景与适用范围

### 3.1 适用环境
- 已集成 Jaeger 分布式追踪系统，且使用 Elasticsearch 作为后端存储。
- Elasticsearch 集群中积累了大量历史 Jaeger 索引，需定期清理以释放存储空间。


### 3.2 典型场景
- **定期维护任务**：作为定时任务（如通过 CronJob）运行，自动清理超过保留期（如 7 天、14 天）的旧索引。
- **存储空间优化**：在资源受限的环境中，避免旧追踪数据无限累积导致磁盘占满。
- **合规性要求**：满足数据保留策略，仅保留指定时间窗口内的追踪数据。


## 4. 使用方法与配置说明

### 4.1 基本使用（Docker Run）
#### 命令格式
```bash
docker run [选项] jaegertracing/jaeger-es-index-cleaner:latest <保留天数> <Elasticsearch地址>
```


#### 参数说明
| 参数类型       | 参数值                  | 说明                                                                 |
|----------------|-------------------------|----------------------------------------------------------------------|
| 位置参数 1     | `<保留天数>`            | 整数，需保留的索引最大天数，超过此天数的索引将被删除（如 `14` 表示保留14天内的索引）。 |
| 位置参数 2     | `<Elasticsearch地址>`   | Elasticsearch 服务的 URL（如 `http://elasticsearch:9200`）。          |
| 环境变量       | `ROLLOVER`              | 可选，布尔值（`true`/`false`），是否处理 Jaeger 滚动索引（默认 `false`，显式设为 `true` 时启用）。 |


#### 示例：删除超过14天的索引
```bash
docker run -it --rm --net=host \
  -e ROLLOVER=true \
  jaegertracing/jaeger-es-index-cleaner:latest \
  14 \
  http://localhost:9200
```
- **说明**：删除 Elasticsearch（`http://localhost:9200`）中保留超过14天的 Jaeger 索引，启用滚动索引处理（`ROLLOVER=true`）。
- **选项解释**：`-it` 交互模式，`--rm` 容器退出后自动删除，`--net=host` 使用主机网络（便于访问本地 Elasticsearch）。


### 4.2 Docker Compose 部署示例
适用于需要定期执行清理任务的场景，可结合 `cron` 或容器编排平台的定时任务功能（如 Kubernetes CronJob）。以下为基础 `docker-compose.yml` 示例：

```yaml
version: '3'
services:
  jaeger-es-index-cleaner:
    image: jaegertracing/jaeger-es-index-cleaner:latest
    environment:
      - ROLLOVER=true  # 启用滚动索引处理
    command: ["14", "http://elasticsearch:9200"]  # 保留14天，Elasticsearch地址为服务名（需与ES服务在同一网络）
    network_mode: "host"  # 或使用与Elasticsearch相同的自定义网络
    # 如需定时执行，可结合外部工具（如cron）调用此compose文件
```


## 5. 替代方案
若需更复杂的索引生命周期管理（如按大小、索引模式过滤等），可考虑使用 [Elasticsearch Curator](https://www.elastic.co/guide/en/elasticsearch/client/curator/current/about.html)（Elasticsearch 官方索引管理工具）。


## 6. 注意事项
- **权限检查**：确保容器对目标 Elasticsearch 具有索引删除权限（如 `delete_index` 权限）。
- **索引命名规范**：工具依赖 Jaeger 默认的索引命名格式（如 `jaeger-span-*`、`jaeger-service-*`），自定义索引名可能导致清理异常。
- **数据备份**：执行清理前建议备份重要索引，避免误删。
