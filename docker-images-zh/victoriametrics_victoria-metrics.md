<!-- xuanyuan-docker-images-zh
image: victoriametrics/victoria-metrics
source: https://xuanyuan.cloud/zh/r/victoriametrics/victoria-metrics
canonical: https://xuanyuan.cloud/zh/r/victoriametrics/victoria-metrics
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [victoriametrics/victoria-metrics — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/victoriametrics/victoria-metrics "victoriametrics/victoria-metrics Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/victoriametrics/victoria-metrics

# VictoriaMetrics

[![加入SLACK社区](https://img.shields.io/badge/Join%20our%20SLACK%20Community-621773?style=for-the-badge&logo=slack&logoColor=white)](https://inviter.co/victoriametrics/)
[![在GitHub提交Bug](https://img.shields.io/badge/File%20a%20Bug%20on%20GitHub-E94600?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)
[![源代码](https://img.shields.io/badge/Source%20Code-323232?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics)

---

## 什么是victoria-metrics？

victoria-metrics是VictoriaMetrics的单节点版本，是一款快速、经济高效且可扩展的时序数据库(TSDB)和监控解决方案。它将数据摄入、存储和查询所需的所有必要组件整合到一个易于部署的二进制文件中，非常适合中小型部署或快速入门场景。

## 如何使用此镜像

### 运行单节点VictoriaMetrics实例

```bash
docker run -d --name victoriametrics -p 8428:8428 victoriametrics/victoria-metrics:latest
```

### 常见场景

#### 数据持久化
要在主机上存储数据，可将卷挂载到容器：

```bash
docker run -d --name victoriametrics -p 8428:8428 \
  -v /path/to/vmdata:/victoria-metrics-data \
  victoriametrics/victoria-metrics:latest \
  -storageDataPath=/victoria-metrics-data
```

## 配置说明

- `-storageDataPath`：时序数据存储目录路径。默认值：victoria-metrics-data。

- `-retentionPeriod`：数据保留时长。例如，3m表示3个月，1y表示1年。默认值：1m（1个月）。

- `-httpListenAddr`：HTTP请求监听的TCP地址。默认值：:8428。

## 高级用法

上述标志涵盖了常见用例，而VictoriaMetrics具有高度可配置性。您可以通过向容器传递`--help`标志，查看所有可用配置标志、描述及默认值：

```bash
docker run --rm victoriametrics/victoria-metrics:latest --help
```

有关配置和调优的详细信息，请参阅[官方文档](https://docs.victoriametrics.com/)。

## 性能基准测试

VictoriaMetrics专为性能和资源效率而设计。建议在您自己的工作负载下，将其与其他时序数据库（如TimescaleDB、InfluxDB、Thanos、Mimir、M3和Cortex）进行比较。

比较时，请重点关注RAM使用率、CPU使用率和磁盘存储大小。欢迎与社区分享您的结果！

## 获取帮助

[![加入SLACK社区](https://img.shields.io/badge/Join%20our%20SLACK%20Community-621773?style=for-the-badge&logo=slack&logoColor=white)](https://inviter.co/victoriametrics/)

[![在GitHub提交Bug](https://img.shields.io/badge/File%20a%20Bug%20on%20GitHub-E94600?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)

[![源代码](https://img.shields.io/badge/Source%20Code-323232?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics)

## 源代码

victoria-metrics的源代码托管在GitHub上：<https://github.com/VictoriaMetrics/VictoriaMetrics>
