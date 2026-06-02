---
image: bitnami/jaeger
description: "Bitnami提供的安全镜像，用于部署Jaeger分布式追踪系统，支持微服务架构下的请求追踪与性能分析，具备安全加固特性。"
source: https://xuanyuan.cloud/zh/r/bitnami/jaeger
canonical: https://xuanyuan.cloud/zh/r/bitnami/jaeger
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/jaeger" title="bitnami/jaeger Docker 镜像中文简介、标签列表与拉取命令">bitnami/jaeger — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/jaeger" title="bitnami/jaeger Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/jaeger</a>

# Bitnami Jaeger 镜像文档

## 镜像概述和主要用途

### 关于 Jaeger

Jaeger 是一个分布式追踪系统，用于监控和排查基于微服务架构的分布式系统。

[Jaeger 官方概述](https://jaegertracing.io/)

**商标说明**：本软件列表由 Bitnami 打包。所提及的 respective 商标归各自公司所有，使用这些商标并不意味着任何关联或认可。

### Bitnami 镜像重要变更通知

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的安全加固镜像：

- 首次向社区用户提供流行容器镜像的安全优化版本。
- Bitnami 将开始在免费 tier 中弃用非加固的基于 Debian 的软件镜像，并逐步从公共目录中移除非最新标签。因此，社区用户将只能访问数量减少的加固镜像，这些镜像仅以“latest”标签发布，且仅用于开发目的。
- 自 8 月 28 日起，两周内所有现有容器镜像（包括旧版本或特定版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产工作负载和长期支持，建议用户采用 Bitnami Secure Images，包括加固容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOMs 和企业支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。

## 核心功能和特性

### Jaeger 核心功能
- 分布式追踪：跟踪请求在微服务间的流转路径
- 性能监控：收集和分析服务调用延迟、吞吐量等指标
- 故障排查：定位分布式系统中的性能瓶颈和错误根源
- 服务依赖可视化：展示微服务间的调用关系

### Bitnami 镜像特性
- **安全加固**：基于最小化操作系统（Photon Linux）构建，减少攻击面
- **非 root 用户运行**：增强容器安全性，符合生产环境最佳实践
- **供应链安全**：提供 SLSA-3 合规的软件工厂生成的证明签名（Notation）、SBOMs、病毒扫描报告等元数据
- **CVE 透明度**：通过 VEX/KEV、EPSS 分数提供漏洞可利用性信息
- **配置灵活性**：支持通过环境变量自定义服务端口、存储类型、数据库连接等参数
- **一致性**：与 Bitnami 虚拟机和云镜像使用相同的组件和配置方式，便于跨格式迁移

## 使用场景和适用范围
- **开发环境分布式追踪**：在开发阶段对微服务架构进行请求追踪和性能分析
- **微服务架构监控**：实时监控服务间调用链路，识别性能瓶颈
- **分布式系统故障排查**：快速定位跨服务调用中的错误和异常
- **仅用于开发目的**：根据 Bitnami 政策，公共目录中的加固镜像（latest 标签）仅适用于开发环境，生产环境建议使用 Bitnami Secure Images

## 使用方法和配置说明

### 获取镜像

推荐通过 Docker Hub 拉取预构建镜像：

```console
docker pull bitnami/jaeger:latest
```

如需使用特定版本，可拉取带版本标签的镜像（注意：2025 年 8 月 28 日后旧版本标签将迁移至 bitnamilegacy 仓库）：

```console
docker pull bitnami/jaeger:[TAG]
```

也可手动构建镜像：

```console
git clone https://github.com/bitnami/containers.git
cd bitnami/jaeger/[VERSION]/[OPERATING-SYSTEM]
docker build -t bitnami/jaeger:latest .
```

### 快速启动

使用以下命令快速启动 Jaeger 容器：

```console
docker run --name jaeger bitnami/jaeger:latest
```

### Docker Compose 配置

**注意**：`docker-compose.yaml` 文件未经过内部测试，建议仅用于开发或测试环境。生产环境推荐使用 [Bitnami Jaeger Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/jaeger)。

如需使用 Docker Compose，可参考以下示例结构（具体配置请以官方仓库为准）：

```yaml
version: '3'
services:
  jaeger:
    image: bitnami/jaeger:latest
    ports:
      - "16686:16686"  # Query UI 端口
      - "14268:14268"  # Collector HTTP 端口
    environment:
      - SPAN_STORAGE_TYPE=memory  # 使用内存存储（开发环境）
      - JAEGER_AGENT_HTTP_PORT_NUMBER=5778
```

### 环境变量配置

#### 可自定义环境变量

| 名称                                 | 描述                                                                 | 默认值                                          |
|--------------------------------------|----------------------------------------------------------------------|------------------------------------------------|
| `JAEGER_USERNAME`                    | Jaeger 用户名                                                        | `user`                                         |
| `JAEGER_PASSWORD`                    | Jaeger 密码                                                          | `bitnami`                                      |
| `JAEGER_AGENT_ZIPKIN_UDP_PORT_NUMBER`| Jaeger Agent UDP 端口（接收 zipkin.thrift 紧凑协议）                 | `5775`                                         |
| `JAEGER_AGENT_COMPACT_UDP_PORT_NUMBER`| Jaeger Agent UDP 端口（接收 jaeger.thrift 紧凑协议）                 | `6831`                                         |
| `JAEGER_AGENT_BINARY_UDP_PORT_NUMBER`| Jaeger Agent UDP 端口（接收 jaeger.thrift 二进制协议）               | `6832`                                         |
| `JAEGER_AGENT_HTTP_PORT_NUMBER`      | Jaeger Agent HTTP 端口（提供配置服务）                               | `5778`                                         |
| `JAEGER_QUERY_HTTP_PORT_NUMBER`      | Jaeger Query HTTP 端口                                              | `16686`                                        |
| `JAEGER_QUERY_GRPC_PORT_NUMBER`      | Jaeger Query GRPC 端口                                              | `16685`                                        |
| `JAEGER_COLLECTOR_ZIPKIN_PORT_NUMBER`| Jaeger Collector Zipkin 兼容端口                                     | `nil`                                          |
| `JAEGER_COLLECTOR_HTTP_PORT_NUMBER`  | Jaeger Collector HTTP 端口（直接接收 jaeger.thrift）                 | `14268`                                        |
| `JAEGER_COLLECTOR_GRPC_PORT_NUMBER`  | Jaeger Collector GRPC 端口（直接接收 jaeger.thrift）                 | `14250`                                        |
| `JAEGER_ADMIN_HTTP_PORT_NUMBER`      | Jaeger Admin 端口                                                    | `14269`                                        |
| `JAEGER_METRICS_PORT_NUMBER`         | Jaeger Prometheus 指标端口                                           | `8888`                                         |
| `JAEGER_HEALTHCHECK_PORT_NUMBER`     | Jaeger 健康检查端口                                                  | `13133`                                        |
| `JAEGER_COLLECTOR_OTLP_GRPC_PORT_NUMBER` | Jaeger Collector OpenTelemetry gRPC 端口                          | `4317`                                         |
| `JAEGER_COLLECTOR_OTLP_HTTP_PORT_NUMBER` | Jaeger Collector OpenTelemetry HTTP 端口                          | `4318`                                         |
| `SPAN_STORAGE_TYPE`                  | Jaeger 存储类型                                                      | `cassandra`                                    |
| `JAEGER_CASSANDRA_HOST`              | Cassandra 服务器主机                                                 | `127.0.0.1`                                    |
| `JAEGER_CASSANDRA_PORT_NUMBER`       | Cassandra 服务器端口                                                 | `9042`                                         |
| `JAEGER_CASSANDRA_KEYSPACE`          | Cassandra 键空间                                                    | `bn_jaeger`                                    |
| `JAEGER_CASSANDRA_DATACENTER`        | Cassandra 数据中心                                                  | `dc1`                                          |
| `JAEGER_CASSANDRA_USER`              | Cassandra 用户名                                                     | `cassandra`                                    |
| `JAEGER_CASSANDRA_PASSWORD`          | Cassandra 用户密码                                                   | `nil`                                          |
| `JAEGER_CASSANDRA_ALLOWED_AUTHENTICATORS` | Cassandra 允许的密码认证器列表（逗号分隔）                     | `org.apache.cassandra.auth.PasswordAuthenticator` |

#### 只读环境变量

| 名称                  | 描述                  | 值                                  |
|-----------------------|-----------------------|-------------------------------------|
| `JAEGER_BASE_DIR`     | Jaeger 安装目录       | `${BITNAMI_ROOT_DIR}/jaeger`        |
| `JAEGER_BIN_DIR`      | Jaeger 二进制文件目录 | `${JAEGER_BASE_DIR}/bin`            |
| `JAEGER_CONF_DIR`     | Jaeger 配置目录       | `${JAEGER_BASE_DIR}/conf`           |
| `JAEGER_CONF_FILE`    | Jaeger 配置文件       | `${JAEGER_CONF_DIR}/jaeger.yml`     |
| `JAEGER_LOGS_DIR`     | Jaeger 日志目录       | `${JAEGER_BASE_DIR}/logs`           |
| `JAEGER_LOG_FILE`     | Jaeger 日志文件       | `${JAEGER_LOGS_DIR}/jaeger.log`     |
| `JAEGER_TMP_DIR`      | Jaeger 临时目录       | `${JAEGER_BASE_DIR}/tmp`            |
| `JAEGER_PID_FILE`     | Jaeger PID 文件       | `${JAEGER_TMP_DIR}/jaeger.pid`      |
| `JAEGER_DAEMON_USER`  | Jaeger 守护进程用户   | `jaeger`                            |
| `JAEGER_DAEMON_GROUP` | Jaeger 守护进程组     | `jaeger`                            |

### 运行命令

在容器内执行命令可使用 `docker run`，例如查看 Jaeger 帮助信息：

```console
docker run --rm --name jaeger bitnami/jaeger:latest --help
```

更多命令请参考 [Jaeger 官方文档](https://jaegertracing.io/docs)。

### FIPS 配置（Bitnami Secure Images）

Bitnami Secure Images 提供 FIPS 模式配置，支持以下环境变量：

- `OPENSSL_FIPS`：是否启用 OpenSSL FIPS 模式，可选值：`yes`（默认）、`no`

## 注意事项
- **镜像迁移**：2025 年 8 月 28 日后，旧版本标签将迁移至 `docker.io/bitnamilegacy` 仓库，不再更新。
- **生产环境**：公共目录中的 `latest` 标签镜像仅用于开发，生产环境请采用 Bitnami Secure Images 以获取长期支持。
- **存储配置**：默认存储类型为 Cassandra，需确保 Cassandra 服务可用；开发环境可设置 `SPAN_STORAGE_TYPE=memory` 使用内存存储。

## 贡献与反馈
- 如有问题或功能需求，可通过 [Bitnami Containers GitHub 仓库](https://github.com/bitnami/containers) 提交 issue 或 pull request。
- 贡献请遵循 [贡献指南](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md)。

## 许可证
Copyright &copy; 2025 Broadcom。"Broadcom" 指 Broadcom Inc. 及其子公司。

根据 Apache License 2.0 许可协议授权。您必须遵守许可协议才能使用本软件。
许可协议副本可在 <http://www.apache.org/licenses/LICENSE-2.0> 获取。

除非适用法律要求或书面同意，否则软件按“原样”分发，不提供任何明示或暗示的担保或条件。
