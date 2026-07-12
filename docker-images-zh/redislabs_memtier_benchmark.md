---
image: redislabs/memtier_benchmark
description: "用于运行memtier_benchmark的Docker镜像，这是一款由Redis开发的NoSQL键值数据库负载生成和基准测试工具，支持Redis/Memcache协议、多线程执行及多种配置选项。"
source: https://xuanyuan.cloud/zh/r/redislabs/memtier_benchmark
canonical: https://xuanyuan.cloud/zh/r/redislabs/memtier_benchmark
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redislabs/memtier_benchmark" title="redislabs/memtier_benchmark Docker 镜像中文简介、标签列表与拉取命令">redislabs/memtier_benchmark 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# memtier_benchmark

memtier_benchmark是由Redis（前身为Garantia Data Ltd.）开发的命令行工具，用于NoSQL键值数据库的负载生成和基准测试。

## 特性

* 支持Redis和Memcache协议（文本和二进制）
* 多线程多客户端执行
* 多种配置选项，包括：
    * 读写比例
    * 随机和顺序键名模式策略
    * 随机或范围键过期
    * Redis集群
    * TLS支持
    * 以及更多

更多信息请参见：

* [Redis和Memcached的高吞吐量基准测试工具](https://redis.io/blog/memtier_benchmark-a-high-throughput-benchmarking-tool-for-redis-memcached)
* [伪随机数据、高斯访问模式和范围操作](https://redis.io/blog/new-in-memtier_benchmark-pseudo-random-data-gaussian-access-pattern-and-range-manipulation/)

## Docker使用方法

### 使用Docker Hub镜像

可直接使用Docker Hub上的可用镜像：

```
# 最新稳定版
$ docker run --rm redislabs/memtier_benchmark:latest --help

# master分支边缘构建版
$ docker run --rm redislabs/memtier_benchmark:edge --help
```

### 本地构建镜像

```
$ docker build -t memtier_benchmark .
$ docker run --rm memtier_benchmark --help
```

### 使用Docker Compose

```
$ docker-compose -f docker-compose.memcached.yml up --build
```
或
```
$ docker-compose -f docker-compose.redis.yml up --build
```

## 基本使用

查看命令行选项：

```
$ docker run --rm redislabs/memtier_benchmark:latest --help
```

## 高级使用

### 集群模式

#### 连接

使用集群模式选项时，每个客户端为每个节点打开一个连接。因此，当使用大量线程和客户端时，用户必须确保不超过文件描述符的最大数量限制。

#### 使用顺序键模式

当Redis节点之间存在不对称性，且用户设置了--requests选项时，生成的键可能存在间隙。此外，比例和键生成器是按客户端（而非连接）设置的。在这种情况下，将比例设置为1:1并不能保证100%的命中率，因为键会分布到不同的连接/节点。

### 使用速率限制进行知情基准测试

在基准测试中施加速率限制，本质上是模拟受控的生产环境。这种设置对于了解在特定吞吐量约束下的延迟表现至关重要：

1. **真实性能指标**：在实际场景中，系统通常在各种限制下运行。了解这些限制如何影响延迟，比单纯进行全压力测试能提供更准确的系统性能图景。
2. **容量规划**：通过观察不同速率限制下的延迟，可以更好地规划基础设施扩展。有助于确定何时增加负载会导致不可接受的延迟，从而指导扩容决策。
3. **服务质量（QoS）保证**：对于需要特定性能保证的服务，了解特定速率限制下的延迟有助于设定现实的QoS基准。
4. **瓶颈识别**：速率限制基准测试可帮助识别系统中的瓶颈。如果速率限制小幅增加导致延迟不成比例地上升，可能表明存在需要关注的瓶颈。
5. **比较分析**：能够在相似基准条件下比较不同解决方案、配置或硬件的延迟处理能力。

#### 在memtier中使用速率限制

使用`--rate-limiting`参数并指定每个连接的期望RPS：

```
memtier_benchmark [其他选项] --rate-limiting=<RPS>
```

注意：当与集群模式选项一起使用时，速率限制与每个节点的连接相关联。

#### 速率限制示例：100%写入，100万键，60秒基准测试，10K RPS

```
memtier_benchmark --ratio=1:0 --test-time=60 --rate-limiting=100 -t 2 -c 50 --key-pattern=P:P --key-maximum 1000000
```

### 全延迟谱分析

对于非正态分布（如延迟），许多正态分布统计的“基本规则”不再适用。除了计算均值（试图用单个结果表示整个分布），还可以使用间隔采样——百分位数，它能告诉你有多少请求实际经历了该延迟。

memtier_benchmark使用HdrHistogram（因其低内存占用、高精度、基准测试期间零分配和 constant 访问时间）计算百分位数。默认输出50th、99th和99.9th百分位数。可使用`--print-percentiles`选项指定其他百分位数（例如：`--print-percentiles 90,99,99.9,99.99`）。

#### 保存全延迟谱

使用`--hdr-file-prefix`选项指定文件名前缀，可将完整延迟保存到文件。每个不同的命令将保存为两个文件：.txt（文本格式）和.hgrm（HistogramLogProcessor格式）。文本格式可通过[在线格式化工具](http://hdrhistogram.github.io/HdrHistogram/plotFiles.html)生成可视化直方图，.hgrm格式可作为Redislabs [mbdirector](https://github.com/redislabs/mbdirector)的输入以实现时域结果可视化。

全延迟谱可视化示例（使用[在线格式化工具](http://hdrhistogram.github.io/HdrHistogram/plotFiles.html)）：
![示例可视化直方图][sample_visual_histogram]

[sample_visual_histogram]: ./docs/sample_visual_histogram.png "示例全延迟谱直方图"
