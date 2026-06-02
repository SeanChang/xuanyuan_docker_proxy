---
image: ubuntu/cortex
description: "Cortex是基于Ubuntu的Prometheus长期存储解决方案，由Canonical维护，提供水平扩展、高可用、多租户支持及多种长期存储选项。"
source: https://xuanyuan.cloud/zh/r/ubuntu/cortex
canonical: https://xuanyuan.cloud/zh/r/ubuntu/cortex
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/cortex" title="ubuntu/cortex Docker 镜像中文简介、标签列表与拉取命令">ubuntu/cortex — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/cortex" title="ubuntu/cortex Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/cortex</a>

## **弃用通知**

此Docker镜像已弃用，将不再接收更新。Cortex v1.11.1将是发布的最终版本。

# Cortex | Ubuntu

当前Cortex Docker镜像[来自Canonical](https://ubuntu.com/security/docker-images)，基于Ubuntu。接收安全更新，并跟踪Cortex和Ubuntu的最新组合。**此仓库可免费使用，且不受每用户速率限制。**


## 关于Cortex

Cortex为Prometheus提供水平扩展、高可用、多租户的长期存储解决方案。

* **水平扩展**：Cortex可在集群中的多台机器上运行，突破单台机器的吞吐量和存储限制。这使您能够将多个Prometheus服务器的指标发送到单个Cortex集群，并在一个位置对所有数据运行“全局聚合”查询。
* **高可用**：在集群中运行时，Cortex可在机器之间复制数据。这使您能够在机器故障时仍保持图表无中断。
* **多租户**：Cortex可在单个集群中隔离来自多个独立Prometheus源的数据和查询，允许不受信任的各方共享同一集群。
* **长期存储**：Cortex支持Amazon DynamoDB、Google Bigtable、Cassandra、S3、GCS和Microsoft Azure作为指标数据的长期存储。这使您能够将数据持久存储超过单台机器的生命周期，并使用这些数据进行长期容量规划。

在[Cortex官网](https://cortexmetrics.io/)了解更多信息。


## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
`from canonical/cortex`提供长达10年的客户安全维护。[申请访问](https://ubuntu.com/security/docker-images#get-in-touch)。

_斜体标签在ubuntu/cortex中不可用，此处列出仅为完整起见。_

| 通道标签 | | | 当前版本 | 架构 |
|---|---|---|---|---|
 | **`1.11-22.04_beta`** &nbsp;&nbsp; |  | | Ubuntu 22.04 LTS上的Cortex 1.11 | `amd64`, `arm64`, `ppc64el`, `s390x` |
| _`track_risk`_ |

通道标签表示该轨道最稳定的通道。轨道是应用版本和底层Ubuntu系列的组合，例如`1.0-22.04`。通道按稳定性从高到低排序：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐含可用。因此，如果列出了`beta`，您也可以拉取`edge`；如果列出了`candidate`，您可以拉取`beta`和`edge`；当列出`stable`时，四个通道均可用。镜像保证按`edge`→`beta`→`candidate`→`stable`的顺序发布。

### 商业使用和扩展安全维护（ESM）通道
如果您的使用场景包括商业再分发或需要未提供的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。


## 使用方法

### 本地启动镜像

```sh
docker run -d --name cortex-container -e TZ=UTC -p 32709:9009 ubuntu/cortex:1.11-22.04_beta
```
访问Cortex服务器：`http://localhost:32709`。

#### 参数说明

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 时区设置。 |
| `-p 32709:9009` | 将Cortex暴露在`localhost:32709`。 |
| `-v /my/local/cortex.yaml:/etc/cortex/cortex.yaml` | 本地[配置文件](https://cortexmetrics.io/docs/configuration/) `cortex.yaml`（可尝试[此示例](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/cortex/plain/oci/examples/config/cortex.yaml?h=1.11-22.04)）。 |

#### 测试/调试

查看容器日志：

```sh
docker logs -f cortex-container
```

进入交互式shell：

```sh
docker exec -it cortex-container /bin/bash
```


## 使用Kubernetes部署

适用于任何Kubernetes集群；如果您没有集群，建议[安装MicroK8s](https://microk8s.io/)，执行`microk8s.enable dns storage`，然后`snap alias microk8s.kubectl kubectl`。

下载[cortex.yaml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/cortex/plain/oci/examples/config/cortex.yaml?h=1.11-22.04)和[cortex-deployment.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/cortex/plain/oci/examples/cortex-deployment.yml?h=1.11-22.04)，并在`cortex-deployment.yml`中设置`containers.cortex.image`为您选择的通道标签（例如`ubuntu/cortex:1.11-22.04_beta`），然后执行：

```sh
kubectl create configmap cortex-config --from-file=main-config=cortex.yaml
kubectl apply -f cortex-deployment.yml
```

现在您可以通过`localhost:32709`连接到Cortex服务器。


## Bug报告和功能请求

如果您在镜像中发现bug或想要请求特定功能，请在此提交bug：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将bug标题格式设为“`cortex: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/cortex:<tag>
```


## 已弃用的通道和标签

以下通道（标签）不再更新。请升级到较新的通道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 轨道 | 版本 | 生命周期结束（EOL） | 升级路径 |
|---|---|---|---|
 | ~~1.10-21.10~~ | Ubuntu 21.10上的Cortex 1.10.0 | 2022年4月 | 1.11-22.04_beta |
 | ~~1.7-21.04~~ | Ubuntu 21.04上的Cortex 1.7.0 | 2022年1月 | ~~1.10-21.10~~ |
 | ~~1.4-20.04~~ | Ubuntu 20.04 LTS上的Cortex 1.4.0 | 2021年1月 | ~~1.7-21.04~~ |
| _`track`_ |
