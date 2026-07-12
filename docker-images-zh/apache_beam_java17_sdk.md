---
image: apache/beam_java17_sdk
description: "Apache Beam Java 17 SDK镜像，用于构建和运行批处理与流处理数据管道，支持跨多种执行引擎（如Spark、Flink）运行，提供Java 17环境及Beam核心库，适合Java开发者快速开发分布式数据处理应用。"
source: https://xuanyuan.cloud/zh/r/apache/beam_java17_sdk
canonical: https://xuanyuan.cloud/zh/r/apache/beam_java17_sdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/beam_java17_sdk" title="apache/beam_java17_sdk Docker 镜像中文简介、标签列表与拉取命令">apache/beam_java17_sdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apache Beam Java 17 SDK 镜像文档

## 1. 镜像概述
Apache Beam Java 17 SDK镜像是基于Java 17环境构建的官方Apache Beam开发运行环境，集成了Beam Java SDK核心组件与依赖库。该镜像旨在为Java开发者提供统一的批处理与流处理数据管道开发、测试和运行平台，支持跨多种执行引擎（如DirectRunner、SparkRunner、FlinkRunner）无缝运行，简化分布式数据处理应用的开发与部署流程。

## 2. 核心功能与特性
- **Java 17运行时环境**：基于OpenJDK 17构建，支持Java 17语法特性及增强功能
- **Beam SDK集成**：包含最新稳定版Beam Java SDK，提供完整的管道构建API（如`Pipeline`、`PCollection`、`Transform`）
- **多执行引擎兼容**：原生支持DirectRunner（本地测试）、SparkRunner、FlinkRunner、DataflowRunner等多种执行引擎
- **数据I/O组件**：内置常用数据源/目标连接器（如文件系统、Kafka、Pub/Sub、JDBC）
- **轻量级部署**：精简基础镜像，优化容器体积，支持快速启动与资源高效利用

## 3. 使用场景
- **批处理任务**：日志数据清洗与分析、ETL数据转换、历史数据批量处理
- **流处理应用**：实时监控数据流、事件驱动型数据处理、实时指标计算
- **跨引擎迁移**：统一批流处理逻辑，实现从本地测试到分布式集群（Spark/Flink）的无缝迁移
- **Java 17环境适配**：需使用Java 17特性（如密封类、模式匹配）开发的Beam应用

## 4. 使用方法与配置说明

### 4.1 基本使用（Docker Run）
#### 4.1.1 拉取镜像
```bash
docker pull docker.xuanyuan.run/apache/beam-java17-sdk:latest
```

#### 4.1.2 交互式开发环境
挂载本地Beam项目代码至容器，进行开发与调试：
```bash
docker run -it --rm -v /path/to/your/beam-project:/app docker.xuanyuan.run/apache/beam-java17-sdk:latest /bin/bash
```

#### 4.1.3 直接执行管道
在容器内运行编译后的Beam应用JAR包：
```bash
# 示例：使用DirectRunner本地执行批处理管道
java -cp /app/target/your-pipeline.jar com.example.YourPipeline --runner=DirectRunner
```

### 4.2 环境变量配置
镜像支持通过环境变量自定义运行参数，常用配置如下：

| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `BEAM_RUNNER` | 默认执行引擎（可选值：`DirectRunner`/`SparkRunner`/`FlinkRunner`等） | `DirectRunner` |
| `JAVA_OPTS` | JVM启动参数（如内存配置、系统属性） | `-Xmx512m` |
| `BEAM_SDK_VERSION` | Beam SDK版本号（用于验证依赖兼容性） | 镜像内置版本 |
| `PIPELINE_ARGS` | 管道默认参数（如输入路径、输出路径） | 空 |

示例：指定使用SparkRunner并配置JVM内存
```bash
docker run -it --rm \
  -e BEAM_RUNNER=SparkRunner \
  -e JAVA_OPTS="-Xmx2g -XX:+UseG1GC" \
  -v /path/to/project:/app \
  docker.xuanyuan.run/apache/beam-java17-sdk:latest \
  java -cp /app/target/pipeline.jar com.example.SparkPipeline --spark-master=spark://spark-cluster:7077
```

### 4.3 Docker Compose配置示例
对于依赖外部服务（如Kafka、数据库）的复杂管道，可通过`docker-compose.yml`管理多容器协同：

```yaml
version: '3.8'
services:
  beam-pipeline:
    image: docker.xuanyuan.run/apache/beam-java17-sdk:latest
    volumes:
      - ./your-beam-project:/app
    environment:
      - BEAM_RUNNER=FlinkRunner
      - JAVA_OPTS=-Xmx1g
      - PIPELINE_ARGS=--inputTopic=kafka:9092/input --outputTable=jdbc:postgresql://db:5432/results
    depends_on:
      - flink-jobmanager
      - kafka
      - db

  # 依赖服务示例（Flink集群、Kafka、PostgreSQL）
  flink-jobmanager:
    image: docker.xuanyuan.run/flink:1.17-scala_2.12
    command: jobmanager
    environment:
      - JOB_MANAGER_RPC_ADDRESS=flink-jobmanager

  kafka:
    image: docker.xuanyuan.run/confluentinc/cp-kafka:7.3.0
    environment:
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
      - KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1

  db:
    image: docker.xuanyuan.run/postgres:14
    environment:
      - POSTGRES_DB=beam_results
      - POSTGRES_USER=beam_user
      - POSTGRES_PASSWORD=beam_pass
```

### 4.4 执行引擎配置示例
#### 4.4.1 本地测试（DirectRunner）
适用于开发阶段快速验证管道逻辑，无需分布式集群：
```bash
docker run -it --rm -v /path/to/project:/app docker.xuanyuan.run/apache/beam-java17-sdk:latest \
  java -cp /app/target/pipeline.jar com.example.TestPipeline \
  --runner=DirectRunner \
  --inputFile=/app/test-data/input.txt \
  --outputFile=/app/test-data/output.txt
```

#### 4.4.2 Spark集群执行（SparkRunner）
需确保容器可访问Spark集群，配置`spark-master`地址：
```bash
docker run -it --rm -v /path/to/project:/app docker.xuanyuan.run/apache/beam-java17-sdk:latest \
  java -cp /app/target/pipeline.jar com.example.SparkPipeline \
  --runner=SparkRunner \
  --spark-master=spark://spark-master:7077 \
  --spark.app.name=beam-spark-pipeline
```

#### 4.4.3 Flink集群执行（FlinkRunner）
需提前部署Flink集群，并配置JobManager地址：
```bash
docker run -it --rm -v /path/to/project:/app docker.xuanyuan.run/apache/beam-java17-sdk:latest \
  java -cp /app/target/pipeline.jar com.example.FlinkPipeline \
  --runner=FlinkRunner \
  --flink-master=flink-jobmanager:8081 \
  --streaming=true
```

## 5. 注意事项
- **网络配置**：运行分布式执行引擎时，需确保容器与目标集群（Spark/Flink）网络互通，可通过`--network`参数指定Docker网络
- **资源配置**：根据数据规模调整`JAVA_OPTS`内存参数，避免OOM错误（建议生产环境配置`-Xmx4g`以上）
- **依赖管理**：项目额外依赖（如特定连接器）需通过Maven/Gradle打包至应用JAR，镜像不包含非核心依赖
- **版本兼容性**：不同Beam版本与执行引擎存在兼容性差异，具体参考[Apache Beam官方兼容性矩阵](https://beam.apache.org/documentation/runners/capability-matrix/)

## 6. 参考链接
- [Apache Beam官方文档](https://beam.apache.org/documentation/)
- [Beam Java SDK API文档](https://beam.apache.org/releases/javadoc/current/)
- [Beam执行引擎配置指南](https://beam.apache.org/documentation/runners/)
