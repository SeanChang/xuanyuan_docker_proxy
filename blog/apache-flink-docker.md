# Apache Flink Docker 容器化部署指南

![Apache Flink Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-apache-flink.png)

*分类: Docker,Apache Flink | 标签: apache-flink,docker,部署教程 | 发布时间: 2025-12-14 14:14:37*

> Apache Flink® 是一个强大的开源分布式流处理与批处理框架，具备高吞吐、低延迟和强状态一致性等特性。通过 Docker 方式部署 Flink，可实现环境一致性、快速部署与简化运维，非常适合开发测试、POC 以及中小规模生产场景。
> 
> 本文将详细介绍 如何使用 Docker 容器化部署 Apache Flink Session 集群，内容涵盖环境准备、镜像拉取、集群部署、功能验证、生产环境建议及常见故障排查，帮助你快速搭建一套稳定、可用的 Flink 运行环境。

## 概述

Docker 部署 Flink 的典型优势包括：

- 环境一致，避免「本地能跑、服务器跑不了」
- 快速启动与销毁，适合弹性扩缩容
- 便于结合私有镜像仓库与加速服务
- 运维成本低，适合开发与测试场景

⚠️ 说明：
Docker 方式更适合开发测试、POC 及轻量生产环境；
大规模生产集群（高可用、多租户）推荐使用 Kubernetes 或 YARN。

## 环境准备

### Docker 环境安装

在部署 Flink 容器前，请确保服务器已安装 Docker。
可使用以下一键脚本快速完成 Docker 安装与配置：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后，执行以下命令验证：

```bash
docker --version
```

若输出类似 `Docker version 20.10.x`，则说明 Docker 安装成功。

### 镜像准备

#### 拉取 Flink 镜像

推荐明确指定版本标签，避免使用 latest 带来的不确定性风险。

```bash
docker pull xxx.xuanyuan.run/library/flink:2.1.1-scala_2.12-java17
```

验证镜像是否拉取成功：

```bash
docker images | grep flink
```

## 容器部署（Session 集群模式）

Flink 常见运行模式包括：

| 模式 | 说明 | 是否支持提交多个作业 |
|------|------|----------------------|
| standalone | 本地调试 | ❌ |
| standalone-job | 容器即作业 | ❌ |
| session（推荐） | 常驻集群 | ✅ |

本文采用官方推荐的 Session 模式，即：
- 1 个 JobManager
- N 个 TaskManager
- 可通过 Web UI / CLI 提交多个作业

### 创建 Docker 自定义网络（推荐）
```bash
docker network create flink-network
```

使用自定义网络可以避免使用已废弃的 `--link`，并提高可维护性。

### 启动 JobManager
```bash
docker run -d \
  --name flink-jobmanager \
  --network flink-network \
  -p 8081:8081 \
  -e JOB_MANAGER_RPC_ADDRESS=flink-jobmanager \
  -e JOB_MANAGER_HEAP_SIZE=1024m \
  xxx.xuanyuan.run/library/flink:2.1.1-scala_2.12-java17 \
  jobmanager
```

**参数说明**：
- JOB_MANAGER_RPC_ADDRESS：必须为 JobManager 容器名
- 8081：Flink Web UI 默认端口

### 启动 TaskManager
```bash
docker run -d \
  --name flink-taskmanager-1 \
  --network flink-network \
  -e JOB_MANAGER_RPC_ADDRESS=flink-jobmanager \
  -e TASK_MANAGER_HEAP_SIZE=2048m \
  -e TASK_MANAGER_NUMBER_OF_TASK_SLOTS=2 \
  xxx.xuanyuan.run/library/flink:2.1.1-scala_2.12-java17 \
  taskmanager
```

💡 建议：
- Task Slots 通常 ≈ CPU 核心数
- 可通过增加 TaskManager 数量实现横向扩展

### 启动状态验证
```bash
docker ps | grep flink
```

## 功能验证

### 访问 Flink Web UI

在浏览器中访问：
```
http://<服务器IP>:8081
```

若能看到 Flink Dashboard，并显示已注册的 TaskManager，则说明集群运行正常。

### 提交测试作业（WordCount）

进入 JobManager 容器：
```bash
docker exec -it flink-jobmanager /bin/bash
```

提交示例作业：
```bash
./bin/flink run ./examples/streaming/WordCount.jar
```

在 Web UI 的 **Running Jobs** / **Completed Jobs** 页面中，可查看作业状态与执行详情。

### 查看容器日志
```bash
docker logs flink-jobmanager
docker logs flink-taskmanager-1
```

若日志中出现：
- JobManager started
- Registered TaskManager

则说明集群通信正常。

## 生产环境建议

### 状态数据与检查点持久化（重要）

⚠️ Flink 不会自动识别普通环境变量配置状态后端，
推荐使用 `FLINK_PROPERTIES` 方式注入配置：

```bash
docker run -d \
  --name flink-jobmanager \
  --network flink-network \
  -p 8081:8081 \
  -v /data/flink/checkpoints:/opt/flink/checkpoints \
  -e JOB_MANAGER_RPC_ADDRESS=flink-jobmanager \
  -e FLINK_PROPERTIES="
state.backend: filesystem
state.checkpoints.dir: file:///opt/flink/checkpoints
parallelism.default: 4
" \
  xxx.xuanyuan.run/library/flink:2.1.1-scala_2.12-java17 \
  jobmanager
```

### 资源限制
```bash
docker run -d \
  --name flink-taskmanager \
  --network flink-network \
  --memory=4g \
  --cpus=2 \
  -e JOB_MANAGER_RPC_ADDRESS=flink-jobmanager \
  xxx.xuanyuan.run/library/flink:2.1.1-scala_2.12-java17 \
  taskmanager
```

### 常用环境变量速查

| 配置项 | 说明 | 示例 |
|--------|------|------|
| JOB_MANAGER_HEAP_SIZE | JM 内存 | 1024m |
| TASK_MANAGER_HEAP_SIZE | TM 内存 | 4096m |
| TASK_MANAGER_NUMBER_OF_TASK_SLOTS | Slot 数 | 4 |
| parallelism.default | 默认并行度 | 4 |
| state.backend | 状态后端 | filesystem / rocksdb |

## 常见故障排查

1. **容器启动即退出**
   执行命令查看日志：
   ```bash
   docker logs flink-jobmanager
   ```
   常见原因：
   - 端口冲突（8081）
   - 内存不足
   - RPC 地址配置错误

2. **Web UI 无法访问**
   检查项：
   - `-p 8081:8081` 是否配置
   - 防火墙是否放行 8081
   - 容器是否在 Running 状态

3. **作业无法运行**
   常见原因：
   - TaskManager 数量不足
   - Slot 数小于作业并行度
   - 作业 Jar 依赖未打包完整

## 参考资料

- Flink 镜像文档（轩辕）：[https://xuanyuan.cloud/r/library/flink](https://xuanyuan.cloud/r/library/flink)
- 镜像标签列表：[https://xuanyuan.cloud/r/library/flink/tags](https://xuanyuan.cloud/r/library/flink/tags)
- Apache Flink 官网：[https://flink.apache.org/](https://flink.apache.org/)
- Flink Docker 官方文档
- Docker 官方文档

## 总结

本文介绍了 基于 Docker 的 Apache Flink Session 集群部署方案，涵盖从环境准备到生产实践的完整流程。

**关键要点**：
- 明确区分 Flink 的运行模式，避免混用
- 使用自定义 Docker 网络替代 `--link`
- 使用 `FLINK_PROPERTIES` 注入核心配置
- 生产环境固定镜像版本，避免 `latest`

该方案适合开发测试及中小规模生产使用，若需要更高可用性与弹性能力，建议进一步迁移至 Kubernetes 环境。

