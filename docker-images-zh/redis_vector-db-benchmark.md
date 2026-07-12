---
image: redis/vector-db-benchmark
description: "用于向量搜索引擎基准测试的框架，支持Redis（含RediSearch和Vector Sets）、Weaviate、Milvus等多种向量数据库，可分析精度与性能权衡，提供实时监控和详细结果报告。"
source: https://xuanyuan.cloud/zh/r/redis/vector-db-benchmark
canonical: https://xuanyuan.cloud/zh/r/redis/vector-db-benchmark
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redis/vector-db-benchmark" title="redis/vector-db-benchmark Docker 镜像中文简介、标签列表与拉取命令">redis/vector-db-benchmark 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Redis向量数据库基准测试工具

一个全面的向量数据库基准测试工具，支持Redis（包括RediSearch和Vector Sets）、Weaviate、Milvus、Qdrant、OpenSearch、Postgres等多种向量数据库。通过简单的命令行工具，您可以获取精度与性能权衡分析、实时性能指标等详细基准测试结果。

## 快速开始

```bash
# 拉取最新镜像
docker pull docker.xuanyuan.run/redis/vector-db-benchmark:latest

# 查看帮助信息
docker run --rm docker.xuanyuan.run/redis/vector-db-benchmark:latest run.py --help

# 查看可用数据集
docker run --rm docker.xuanyuan.run/redis/vector-db-benchmark:latest run.py --describe datasets

# 基础Redis基准测试（需本地Redis）
docker run --rm -v $(pwd)/results:/app/results --network=host \
  docker.xuanyuan.run/redis/vector-db-benchmark:latest \
  run.py --host localhost --engines redis-default-simple --dataset random-100
```

## 核心功能

- **42+ 数据集**：预配置25到10亿+向量的数据集
- **多引擎支持**：兼容Redis、Qdrant、Weaviate、Milvus等多种向量数据库
- **实时监控**：基准测试过程中的实时性能指标
- **精度分析**：详细的精度与性能权衡分析
- **便捷探索**：通过`--describe`命令查看数据集和引擎信息

## 可用标签

- `latest` - 来自update.redisearch分支的最新开发构建

## Redis快速开始

### 带RediSearch的Redis 8.2

```bash
# 启动带内置向量支持的Redis 8.2
docker run -d --name redis-test -p 6379:6379 docker.xuanyuan.run/redis:8.2-rc1-bookworm

# 运行基准测试
docker run --rm -v $(pwd)/results:/app/results --network=host \
  docker.xuanyuan.run/redis/vector-db-benchmark:latest \
  run.py --host localhost --engines redis-default-simple --dataset glove-25-angular
```

## 常用使用模式

### 探索可用选项

```bash
# 列出所有数据集
docker run --rm docker.xuanyuan.run/redis/vector-db-benchmark:latest run.py --describe datasets

# 列出所有引擎
docker run --rm docker.xuanyuan.run/redis/vector-db-benchmark:latest run.py --describe engines
```

### 运行基准测试

```bash
# 使用小型数据集进行快速测试
docker run --rm -v $(pwd)/results:/app/results --network=host \
  docker.xuanyuan.run/redis/vector-db-benchmark:latest \
  run.py --host localhost --engines redis-default-simple --dataset random-100

# 使用多种配置进行全面基准测试
docker run --rm -v $(pwd)/results:/app/results --network=host \
  docker.xuanyuan.run/redis/vector-db-benchmark:latest \
  run.py --host localhost --engines "*redis*" --dataset glove-25-angular

# 带Redis认证的测试
docker run --rm -v $(pwd)/results:/app/results --network=host \
  -e REDIS_AUTH=mypassword -e REDIS_USER=myuser \
  docker.xuanyuan.run/redis/vector-db-benchmark:latest \
  run.py --host localhost --engines redis-default-simple --dataset random-100
```

### 结果分析

```bash
# 查看精度摘要
jq '.precision_summary' results/*-summary.json

# 查看详细结果
jq '.search' results/*-summary.json
```

## 卷挂载

- `/app/results` - 基准测试结果（JSON文件）
- `/app/datasets` - 数据集存储（可选，自动下载）

## 环境变量

- `REDIS_HOST` - Redis服务器主机名（默认：localhost）
- `REDIS_PORT` - Redis服务器端口（默认：6379）
- `REDIS_AUTH` - Redis密码（默认：无）
- `REDIS_USER` - Redis用户名（默认：无）
- `REDIS_CLUSTER` - 启用Redis集群模式（默认：0）

## 性能提示

1. **使用`--network=host`** - 与本地Redis配合使用时获得最佳性能
2. **挂载结果卷** - 持久化基准测试数据
3. **从小型数据集开始** - 使用random-100、glove-25-angular等小型数据集进行测试
4. **使用通配符模式** - 测试多种配置：`--engines "*-m-16-*"`

## 示例输出

```json
{
  "precision_summary": {
    "0.91": {
      "qps": 1924.5,
      "p50": 49.828,
      "p95": 58.427
    },
    "0.94": {
      "qps": 1819.9,
      "p50": 51.68,
      "p95": 66.83
    }
  }
}
```

## 支持

- **GitHub**：[redis-performance/vector-db-benchmark](https://github.com/redis-performance/vector-db-benchmark)
- **问题反馈**：在GitHub上报告错误和功能请求
- **文档**：完整文档可在仓库中获取

## 许可证

本项目采用MIT许可证 - 详见仓库获取详情。
