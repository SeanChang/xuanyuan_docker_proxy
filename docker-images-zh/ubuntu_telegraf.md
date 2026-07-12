---
image: ubuntu/telegraf
description: "Telegraf是一款用于收集、处理、聚合和写入指标的代理，由Canonical维护长期跟踪版本，该镜像已弃用，v1.21为最后发布版本。"
source: https://xuanyuan.cloud/zh/r/ubuntu/telegraf
canonical: https://xuanyuan.cloud/zh/r/ubuntu/telegraf
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/telegraf" title="ubuntu/telegraf Docker 镜像中文简介、标签列表与拉取命令">ubuntu/telegraf 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## **弃用通知**

此Docker镜像已弃用，将不再接收更新。v1.21将是最后发布的版本。

# Telegraf™ 软件 | Ubuntu

当前Telegraf™软件Docker镜像[来自Canonical](https://ubuntu.com/security/docker-images)，基于Ubuntu构建。接收安全更新，并跟踪Telegraf™软件和Ubuntu的最新组合。**此仓库可免费使用，且不受每用户速率限制。**


## 关于Telegraf™软件

Telegraf是一款用于收集、处理、聚合和写入指标的代理。其设计目标是具有最小的内存占用，并提供插件系统，以便社区开发者可以轻松添加指标收集支持。在[Telegraf官网](https://www.influxdata.com/time-series-platform/telegraf/)了解更多信息。


## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
`from canonical/telegraf`提供长达10年的客户安全维护。[请求访问](https://ubuntu.com/security/docker-images#get-in-touch)。

*斜体标签在ubuntu/telegraf中不可用，仅为完整起见显示。*

| 通道标签 | | | 当前版本 | 架构 |
|---|---|---|---|---|
| **`1.21-22.04_beta`** &nbsp;&nbsp; |  | | Telegraf™软件1.21 on Ubuntu&nbsp;22.04&nbsp;LTS | `amd64`、`arm64`、`ppc64el`、`s390x` |
| _`track_risk`_ |

通道标签表示该跟踪的最稳定通道。跟踪是应用版本和基础Ubuntu系列的组合，例如`1.0-22.04`。通道按稳定性从高到低排序：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐含可用。因此，如果列出了`beta`，您也可以拉取`edge`；如果列出了`candidate`，您可以拉取`beta`和`edge`；如果列出了`stable`，则四个通道均可用。镜像保证按`edge`→`beta`→`candidate`→`stable`的顺序发布。

### 商业用途和扩展安全维护通道
如果您的使用场景包括商业再分发或需要不可用的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。


## 使用方法

### 本地启动镜像

```sh
docker run -d --name telegraf-container -e TZ=UTC -p 30273:9273 docker.xuanyuan.run/ubuntu/telegraf:1.21-22.04_beta
```
通过`localhost:30273`访问您的Telegraf服务器。

#### 参数说明

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 时区设置。 |
| `-p 30273:9273` | 将Telegraf暴露在`localhost:30273`。 |
| `-v /path/to/telegraf.conf:/etc/telegraf/telegraf.conf` | 挂载本地[配置文件](https://docs.influxdata.com/telegraf/)`telegraf.conf`（可尝试[此示例](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/telegraf/plain/examples/config/telegraf.conf?h=1.21-22.04)）。 |


#### 测试/调试

查看容器日志：

```sh
docker logs -f telegraf-container
```

进入交互式shell：

```sh
docker exec -it telegraf-container /bin/bash
```


## 使用Kubernetes部署

适用于任何Kubernetes集群；如果没有，建议您[安装MicroK8s](https://microk8s.io/)并执行`microk8s.enable dns storage`，然后` snap alias microk8s.kubectl kubectl`。

下载[telegraf.conf](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/telegraf/plain/examples/config/telegraf.conf?h=1.21-22.04)和[telegraf-deployment.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/telegraf/plain/examples/telegraf-deployment.yml?h=1.21-22.04)，并在`telegraf-deployment.yml`中设置`containers.telegraf.image`为您选择的通道标签（例如`ubuntu/telegraf:1.21-22.04_beta`），然后执行：

```sh
kubectl create configmap telegraf-config --from-file=main-config=telegraf.conf
kubectl apply -f telegraf-deployment.yml
```

现在您可以通过`localhost:30073`连接到Telegraf服务器。


## 错误和功能请求

如果您在我们的镜像中发现错误或想要请求特定功能，请在此提交错误报告：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将错误标题格式化为“`telegraf: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/telegraf:<tag>
```


## 已弃用的通道和标签
以下通道（标签）不再更新。请升级到较新的通道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 跟踪 | 版本 | 生命周期结束(EOL) | 升级路径 |
|---|---|---|---|
| ~~1.19-21.10~~ | Telegraf™软件1.19.2 on Ubuntu&nbsp;21.10 | 2022年7月 | 1.21-22.04_beta |
| ~~1.17-21.04~~ | Telegraf™软件1.17.2 on Ubuntu&nbsp;21.04 | 2022年1月 | ~~1.19-21.10~~ |
| ~~1.15-20.04~~ | Telegraf™软件1.15.2 on Ubuntu&nbsp;20.04&nbsp;LTS | 2021年1月 | ~~1.17-21.04~~ |
| _`track`_ |  |  |  |
