---
image: ubuntu/mlflow
description: "MLflow：用于管理机器学习生命周期的平台，由Canonical维护长期支持版本。"
source: https://xuanyuan.cloud/zh/r/ubuntu/mlflow
canonical: https://xuanyuan.cloud/zh/r/ubuntu/mlflow
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/mlflow" title="ubuntu/mlflow Docker 镜像中文简介、标签列表与拉取命令">ubuntu/mlflow 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MLflow | Ubuntu

当前MLflow Docker镜像[来自Canonical](https://ubuntu.com/security/docker-images)，基于Ubuntu构建。接收安全更新，并滚动更新至更新的MLflow或Ubuntu版本。**此仓库可免费使用，且不受每用户速率限制。**


## 关于MLflow

MLflow是一个用于简化机器学习开发的平台，包括跟踪实验、将代码打包为可复现的运行以及共享和部署模型。MLflow提供了一组轻量级API，可与任何现有机器学习应用程序或库（TensorFlow、PyTorch、XGBoost等）配合使用，无论您当前在何处运行ML代码（例如在笔记本、独立应用程序或云中）。更多信息请访问[mlflow官方网站](https://mlflow.org/)。


## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
通过[Canonical的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)提供长达10年的客户安全维护。


| 通道标签 | | | 当前版本 | 架构 |
|---|---|---|---|---|
| **`2.1.1_1.0-22.04`** | ![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17) | ![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17) | Ubuntu 22.04 LTS上的MLflow 2.1.1_1.0 | `amd64` |
| _`track_risk`_ |



通道标签按稳定性顺序显示该跟踪的最稳定通道：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐式可用。因此，如果列出了`beta`，您也可以拉取`edge`；如果列出了`candidate`，您可以拉取`beta`和`edge`；当列出`stable`时，所有四个通道均可用。镜像确保按`edge`、`beta`、`candidate`、`stable`的顺序推进。

### 商业用途和扩展安全维护通道
如果您的使用场景包括商业再分发，或需要ESM或不可用的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。


## 使用方法

本地启动此镜像：

```sh
docker run -d --name mlflow-container -e TZ=UTC -p 5000:5000 docker.xuanyuan.run/ubuntu/mlflow:2.1.1_1.0-22.04_stable
```
通过`http://localhost:5000`访问MLflow UI。

#### 参数说明

| 参数 | 描述 |
|---|---|
| `-p 5000:5000` | 将MLflow暴露在`localhost:5000`。 |


#### 测试/调试

调试容器：

```sh
docker logs -f mlflow-container
```

获取交互式shell：

```sh
docker exec -it mlflow-container /bin/bash
```


## 错误和功能请求

如果您在镜像中发现错误或想要请求特定功能，请在此提交错误报告：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将错误标题命名为“`mlflow: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/mlflow:<标签>
```


## 已弃用的通道和标签
这些通道（标签）不再更新。请升级到更新的通道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 跟踪 | 版本 | 生命周期结束（EOL） | 升级路径 |
|---|---|---|---|
| _`track`_ |
