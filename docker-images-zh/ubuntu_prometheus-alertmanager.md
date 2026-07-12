---
image: ubuntu/prometheus-alertmanager
description: "Alertmanager处理来自Prometheus服务器的客户端告警，提供告警去重、分组、路由及静默抑制功能，由Canonical维护长期版本跟踪。"
source: https://xuanyuan.cloud/zh/r/ubuntu/prometheus-alertmanager
canonical: https://xuanyuan.cloud/zh/r/ubuntu/prometheus-alertmanager
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/prometheus-alertmanager" title="ubuntu/prometheus-alertmanager Docker 镜像中文简介、标签列表与拉取命令">ubuntu/prometheus-alertmanager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## **永久迁移**

此仓库已迁移至 [ubuntu/alertmanager](https://hub.docker.com/r/ubuntu/alertmanager)，将在该处继续接收更新。

# Prometheus Alertmanager | Ubuntu

当前 Prometheus Alertmanager Docker 镜像 [来自 Canonical](https://ubuntu.com/security/docker-images)，基于 Ubuntu。接收安全更新，并跟踪 Prometheus Alertmanager 与 Ubuntu 的最新组合。**此仓库可免费使用，且不受每用户速率限制影响。**


## 关于 Prometheus Alertmanager

Alertmanager 处理来自客户端应用（如 Prometheus 服务器）的告警。它负责告警的去重、分组和路由，将其发送到正确的接收方集成（如电子邮件、PagerDuty 或 OpsGenie）。它还负责告警的静默和抑制。在 [Prometheus Alertmanager 官网](https://prometheus.io/docs/alerting/latest/alertmanager/) 了解更多信息。


## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS 频道提供长达 5 年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
`from canonical/prometheus-alertmanager` 提供长达 10 年的客户安全维护。[申请访问](https://ubuntu.com/security/docker-images#get-in-touch)。

*斜体标签在 ubuntu/prometheus-alertmanager 中不可用，此处列出仅供完整参考。*

| 频道标签 |  |  | 当前版本 | 架构 |
|---|---|---|---|---|
| **`0.23-22.04_beta`** &nbsp;&nbsp; |  | | Ubuntu 22.04 LTS 上的 Prometheus Alertmanager 0.23 | `amd64`、`arm64`、`ppc64el`、`s390x` |
| _`track_risk`_ |

频道标签表示该跟踪版本中最稳定的频道。跟踪版本是应用版本与底层 Ubuntu 系列的组合，例如 `1.0-22.04`。频道按稳定性从高到低排序：`stable`、`candidate`、`beta`、`edge`。风险较高的频道始终隐含可用。因此，若列出 `beta`，则也可拉取 `edge`；若列出 `candidate`，则可拉取 `beta` 和 `edge`；若列出 `stable`，则四个频道均可用。镜像保证按 `edge` → `beta` → `candidate` → `stable` 的顺序发布。

### 商业用途和扩展安全维护频道
如果您的使用场景包括商业再分发，或需要未列出的频道/版本，请 [联系 Canonical 团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至 rocks@canonical.com）。


## 使用方法

### 本地启动镜像

```sh
docker run -d --name prometheus-alertmanager-container -e TZ=UTC -p 30093:9093 docker.xuanyuan.run/ubuntu/prometheus-alertmanager:0.23-22.04_beta
```
通过 `localhost:30093` 访问 Prometheus Alertmanager 服务器。

#### 参数说明

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 时区。 |
| `-p 30093:9093` | 将 Prometheus Alertmanager 暴露在 `localhost:30093`。 |
| `-v /path/to/alertmanager.yml:/etc/prometheus/alertmanager.yml` | 本地 [配置文件](https://www.prometheus.io/docs/alerting/latest/configuration/) `alertmanager.yml`（可尝试 [此示例](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/prometheus-alertmanager/plain/examples/config/alertmanager.yml?h=0.23-22.04)）。 |
| `-v /path/to/persisted/data:/alertmanager` | 持久化数据，而非为每个新启动的容器初始化新数据库。**重要说明**：用于持久化数据的目录需属于 `nogroup:nobody`。启动容器前，可运行 `chown nogroup:nobody <path_to_persist_data>`。 |


#### 测试/调试

调试容器：

```sh
docker logs -f prometheus-alertmanager-container
```

获取交互式 shell：

```sh
docker exec -it prometheus-alertmanager-container /bin/bash
```


## 使用 Kubernetes 部署

适用于任何 Kubernetes；如果您没有 Kubernetes，建议 [安装 MicroK8s](https://microk8s.io/) 并运行 `microk8s.enable dns storage`，然后 `snap alias microk8s.kubectl kubectl`。

下载 [alertmanager.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/prometheus-alertmanager/plain/examples/config/alertmanager.yml?h=0.23-22.04) 和 [prometheus-alertmanager-deployment.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/prometheus-alertmanager/plain/examples/alertmanager-deployment.yml?h=0.23-22.04)，并在 `prometheus-alertmanager-deployment.yml` 中设置 `containers.prometheus-alertmanager.image` 为您选择的频道标签（例如 `ubuntu/prometheus-alertmanager:0.23-22.04_beta`），然后执行：

```sh
kubectl create configmap alertmanager-config --from-file=alertmanager=alertmanager.yml
kubectl apply -f prometheus-alertmanager-deployment.yml
```

现在可通过 `localhost:30093` 连接到 Prometheus Alertmanager 服务器。


## Bug 和功能请求

如果您在我们的镜像中发现 bug 或想要请求特定功能，请在此提交 bug：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将 bug 标题设为 “`prometheus-alertmanager: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/prometheus-alertmanager:<tag>
```


## 已弃用的频道和标签

这些频道（标签）不再更新。请升级到较新频道，如无法升级，请 [联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 跟踪版本 | 版本 | 终止支持日期 | 升级路径 |
|---|---|---|---|
| ~~0.22-21.10~~ | Ubuntu 21.10 上的 Prometheus Alertmanager 0.22.0 | 2022-04 | 0.23-22.04_beta |
| ~~0.21-21.04~~ | Ubuntu 21.04 上的 Prometheus Alertmanager 0.21.0 | 2022-01 | ~~0.22-21.10~~ |
| ~~0.21-20.04~~ | Ubuntu 20.04 LTS 上的 Prometheus Alertmanager 0.21.0 | 2021-01 | ~~0.21-21.04~~ |
| _`track`_ |  |  |  |
