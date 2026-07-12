---
image: ubuntu/node-exporter
description: "用于导出机器指标的Prometheus node-exporter。"
source: https://xuanyuan.cloud/zh/r/ubuntu/node-exporter
canonical: https://xuanyuan.cloud/zh/r/ubuntu/node-exporter
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/node-exporter" title="ubuntu/node-exporter Docker 镜像中文简介、标签列表与拉取命令">ubuntu/node-exporter 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# node-exporter | Ubuntu

当前的node-exporter Docker镜像来自Canonical，基于Ubuntu构建。接收安全更新并会滚动到更新的node-exporter或Ubuntu版本。**此仓库可免费使用，不受每用户速率限制影响。**


## 关于node-exporter

Node-exporter以Prometheus格式公开机器指标。更多信息请参阅[官方文档](https://github.com/prometheus/node_exporter)。请注意，此仓库包含的是rock镜像而非基于Dockerfile的镜像，因此入口点为Pebble。更多信息请参阅[Rockcraft文档](https://canonical-rockcraft.readthedocs-hosted.com/en/latest/)。

## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
通过Canonical的受限仓库提供长达10年的客户安全维护[从Canonical的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)。


| 通道标签 |  | 支持至 | 当前版本 | 架构 |
|---|---|---|---|---|
| **`1.9-24.04_stable`** | **`1-24.04`、`1-24.04_beta`、`1-24.04_candidate`、`1-24.04_edge`、`1-24.04_stable`、`1.9-24.04`、`1.9-24.04_beta`、`1.9-24.04_candidate`、`1.9-24.04_edge`** | - | Ubuntu 24.04 LTS上的node-exporter 1.9 | `amd64` |
| _`track_risk`_ |


通道标签按稳定性顺序显示该轨道的最稳定通道：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐含可用。因此，如果列出了`beta`，您也可以拉取`edge`；如果列出了`candidate`，您可以拉取`beta`和`edge`；当列出`stable`时，所有四个通道均可用。镜像保证按`edge`、`beta`、`candidate`、`stable`的顺序更新。

### 商业用途和扩展安全维护（ESM）通道
如果您的使用场景包括商业再分发，或需要ESM或未列出的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或通过rocks@canonical.com）。

## 使用方法

本地启动此镜像：

```sh
docker run -d --name node-exporter-container -e TZ=UTC -p 9100:9100 docker.xuanyuan.run/ubuntu/node-exporter:1.9-24.04_stable
```
指标端点可通过`http://localhost:9100/metrics`访问。

#### 参数说明

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 时区。 |
| `-p 9100:9100` | 在`localhost:9100/metrics`暴露指标端点。 |


#### 测试/调试

调试容器：

```sh
docker logs -f node-exporter-container
```

获取交互式shell：

```sh
docker exec -it node-exporter-container /bin/bash
```

### 调试

调试容器：
```bash
docker exec node-exporter-container pebble logs node-exporter
```
获取交互式shell：
```bash
docker exec -it node-exporter-container /bin/bash
```


## 问题和功能请求

如果您在镜像中发现bug或需要请求特定功能，请在此提交bug：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将bug标题设为“`node-exporter: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/node-exporter:<tag>
```


## 废弃的通道和标签
这些通道（标签）不再更新。请升级到较新的通道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 轨道 | 版本 | 生命周期结束（EOL） | 升级路径 |
|---|---|---|---|
| _`track`_ |
