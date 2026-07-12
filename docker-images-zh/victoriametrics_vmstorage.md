---
image: victoriametrics/vmstorage
description: "VictoriaMetrics集群的持久化长期存储后端，负责存储时间序列数据并处理来自vminsert和vmselect的请求。"
source: https://xuanyuan.cloud/zh/r/victoriametrics/vmstorage
canonical: https://xuanyuan.cloud/zh/r/victoriametrics/vmstorage
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/victoriametrics/vmstorage" title="victoriametrics/vmstorage Docker 镜像中文简介、标签列表与拉取命令">victoriametrics/vmstorage 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# VictoriaMetrics Cluster

[![加入我们的SLACK社区](https://img.shields.io/badge/加入我们的SLACK社区-621773?style=for-the-badge&logo=slack&logoColor=white)](https://inviter.co/victoriametrics/)
[![在GitHub上提交Bug](https://img.shields.io/badge/在GitHub上提交Bug-E94600?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)
[![源代码](https://img.shields.io/badge/源代码-323232?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vminsert)

## 什么是VictoriaMetrics Cluster?

VictoriaMetrics集群由三个可独立扩展的主要服务组成：

* **vminsert**：接收传入数据并将其路由到`vmstorage`节点。
* **vmselect**：接收查询请求，从所有`vmstorage`节点获取数据并合并结果。
* **vmstorage**：存储时间序列数据，并处理来自`vminsert`和`vmselect`的请求。

## 如何使用这些镜像

运行集群需要将三个组件网络连接在一起。以下是简化示例：

### 运行vmstorage：

```
docker run -d --name vmstorage -p 8482:8482 -p 8400:8400 -p 8401:8401 
-v /path/to/vmdata-cluster:/storage 
victoriametrics/vmstorage:latest 
-storageDataPath=/storage -vminsertAddr=:8400 -vmselectAddr=:8401
```

### 运行vminsert：

```
docker run -d --name vminsert -p 8480:8480 
victoriametrics/vminsert:latest 
-storageNode=vmstorage:8400
```

### 运行vmselect：

```
docker run -d --name vmselect -p 8481:8481 
victoriametrics/vmselect:latest 
-storageNode=vmstorage:8400
```

## 配置参数

* **-storageNode**（`vminsert`/`vmselect`）：`vmstorage`节点地址，可多次指定。
* **-storageDataPath**（`vmstorage`）：数据目录路径。
* **-retentionPeriod**（`vmstorage`）：数据保留期。
* **-vminsertAddr** / **-vmselectAddr**（`vmstorage`）：`vmstorage`监听来自`vminsert`和`vmselect`内部流量的地址。

## 获取帮助

如有疑问，可联系VictoriaMetrics社区：

* **Slack**：[加入社区Slack](https://inviter.co/victoriametrics/)
* **社区论坛**：[在社区论坛提问](https://github.com/VictoriaMetrics/VictoriaMetrics/discussions)
* **Bug报告**：[在GitHub提交Bug](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)

## 源代码

各集群组件的源代码位于VictoriaMetrics GitHub仓库：

* **vminsert**：[https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vminsert](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vminsert)
* **vmselect**：[https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmselect](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmselect)
* **vmstorage**：[https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmstorage](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmstorage)

`vmstorage`是[VictoriaMetrics集群](https://docs.victoriametrics.com/cluster-victoriametrics/#architecture-overview)的组件。

### Docker拉取命令

建议指定镜像的具体标签：
```
docker pull docker.xuanyuan.run/victoriametrics/vmstorage:{TAG}
```

查看[如何通过Docker启动VictoriaMetrics集群](https://docs.victoriametrics.com/victoriametrics/quick-start/#starting-vm-cluster-via-docker)和[VictoriaMetrics集群配置示例](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/deployment/docker#victoriametrics-cluster)。
