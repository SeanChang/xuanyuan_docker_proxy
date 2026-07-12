---
image: ubuntu/loki
description: "Grafana Loki是一个类似于Prometheus的日志聚合系统，由Canonical提供长期维护支持。"
source: https://xuanyuan.cloud/zh/r/ubuntu/loki
canonical: https://xuanyuan.cloud/zh/r/ubuntu/loki
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/loki" title="ubuntu/loki Docker 镜像中文简介、标签列表与拉取命令">ubuntu/loki 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# loki | Ubuntu

当前的loki Docker镜像[来自Canonical](https://ubuntu.com/security/docker-images)，基于Ubuntu构建。接收安全更新并滚动到更新的loki或Ubuntu版本。**此仓库可免费使用，不受每用户速率限制。**

## 关于loki

Loki是一个受Prometheus启发的水平可扩展、高可用、多租户日志聚合系统。它设计为具有高成本效益且易于操作。它不索引日志内容，而是为每个日志流建立一组标签。在[官方网站](https://grafana.com/oss/loki/)上了解更多信息。
请注意，标记为2.4及以下版本的镜像是基于Dockerfile的镜像，而从2.8.4版本开始，镜像现在是rocks格式。因此，入口点现在是Pebble。在[Rockcraft文档](https://canonical-rockcraft.readthedocs-hosted.com/en/latest/explanation/rocks/)上了解更多信息。

## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
通过[Canonical的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)提供长达10年的客户安全维护。


| 通道标签 | | 支持期限 | 当前版本 | 架构 |
|---|---|---|---|---|
| **`2.9.15-24.04_stable`** | **`2-24.04`, `2-24.04_beta`, `2-24.04_candidate`, `2-24.04_edge`, `2-24.04_stable`, `2.9-24.04`, `2.9-24.04_beta`, `2.9-24.04_candidate`, `2.9-24.04_edge`, `2.9-24.04_stable`, `2.9.15-24.04`, `2.9.15-24.04_beta`, `2.9.15-24.04_candidate`, `2.9.15-24.04_edge`** | 10/2025 | Ubuntu 24.04 LTS上的loki 2.9.15 | `amd64` |
| `3.5-24.04_stable` | `3-24.04`, `3-24.04_beta`, `3-24.04_candidate`, `3-24.04_edge`, `3-24.04_stable`, `3.5-24.04`, `3.5-24.04_beta`, `3.5-24.04_candidate`, `3.5-24.04_edge` | - | Ubuntu 24.04 LTS上的loki 3.5 | `amd64` |
| `2.4-22.04_beta` | `edge`, `latest` | - | Ubuntu 22.04 LTS上的loki 2.4 | `amd64`, `s390x`, `ppc64le`, `arm64` |
| `2.4-22.04_edge` | `2.4-22.04_edge` | - | Ubuntu 22.04 LTS上的loki 2.4 | `amd64`, `s390x`, `ppc64le`, `arm64` |
| _`track_risk`_ |


通道标签按稳定性排序显示该跟踪的最稳定通道：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐式可用。因此，如果列出了`beta`，您也可以拉取`edge`。如果列出了`candidate`，您可以拉取`beta`和`edge`。当列出`stable`时，所有四个通道都可用。镜像保证按`edge`、`beta`、`candidate`、`stable`的顺序发布。

### 商业用途和扩展安全维护通道
如果您的使用包括商业再分发，或需要ESM或不可用的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。

## 使用方法

本地启动此镜像：

```sh
docker run -d --name loki-container -e TZ=UTC -p 3100:3100 docker.xuanyuan.run/ubuntu/loki:2.9.15-24.04_stable
```
在`http://localhost:3100`访问您的Loki实例。

#### 参数

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 时区设置。 |
| `-p 3100:3100` | 在`localhost:3100`上暴露Loki服务。 |
| `-v /path/to/config/file:/etc/loki/local-config.yaml` | 本地配置文件`local-config.yml`。 |
| `-v lokidata:/loki` | 在名为`lokidata`的Docker卷中持久化数据 |


#### 测试/调试

调试容器：

```sh
docker logs -f loki-container
```

获取交互式shell：

```sh
docker exec -it loki-container /bin/bash
```

### 调试

调试容器：

```bash
docker logs -f loki-container
```

获取交互式shell：

```bash
# 对于基于Dockerfile的镜像
docker exec -it loki-container /bin/bash
# 对于rocks格式的镜像
docker exec -it loki-container exec /bin/bash
```


## 错误和功能请求

如果您在我们的镜像中发现错误或想要请求特定功能，请在此提交错误报告：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将错误标题设为"`loki: <问题摘要>`"。确保包含您正在使用的镜像的摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/loki:<tag>
```


## 已弃用的通道和标签

这些通道（标签）不再更新。请升级到更新的通道，或者如果无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 跟踪 | 版本 | 生命周期结束 | 升级路径 |
|---|---|---|---|
| ~~3.4.2-24.04~~ | Ubuntu 24.04 LTS上的loki 3.4.2 | 05/2025 | - |
| ~~3.4.1-24.04~~ | Ubuntu 24.04 LTS上的loki 3.4.1 | 05/2025 | - |
| ~~2.8.4-22.04~~ | Ubuntu 22.04 LTS上的loki 2.8.4 | 03/2025 | - |
| ~~2.9.6-22.04~~ | Ubuntu 22.04 LTS上的loki 2.9.6 | 05/2025 | - |
| ~~2.9.3-22.04~~ | Ubuntu 22.04 LTS上的loki 2.9.3 | 03/2025 | - |
| ~~3.0.0-22.04~~ | Ubuntu 22.04 LTS上的loki 3.0.0 | 05/2025 | - |
| ~~2.9.5-22.04~~ | Ubuntu 22.04 LTS上的loki 2.9.5 | 03/2025 | - |
| ~~2.9.2-22.04~~ | Ubuntu 22.04 LTS上的loki 2.9.2 | 03/2025 | - |
| ~~2.9.4-22.04~~ | Ubuntu 22.04 LTS上的loki 2.9.4 | 03/2025 | - |
| _`track`_ |
