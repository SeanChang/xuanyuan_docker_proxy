---
image: ubuntu/valkey
description: "Valkey是一个灵活的分布式键值数据存储，专为缓存和实时工作负载优化。"
source: https://xuanyuan.cloud/zh/r/ubuntu/valkey
canonical: https://xuanyuan.cloud/zh/r/ubuntu/valkey
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/valkey" title="ubuntu/valkey Docker 镜像中文简介、标签列表与拉取命令">ubuntu/valkey 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# valkey | Ubuntu

当前的valkey Docker镜像由Canonical提供，基于Ubuntu系统。该镜像会接收安全更新，并会滚动更新至更新的valkey版本或Ubuntu发行版。本仓库可免费使用，且不受每用户速率限制。


## 关于Valkey

这是一个OCI镜像，捆绑了Valkey和指标导出器。Valkey是一个开源、灵活的分布式键值数据存储，专为缓存和其他实时工作负载优化。

# 快速开始

部署一个简单的Valkey容器：
```bash
docker run --name valkey docker.xuanyuan.run/ubuntu/valkey:7.2.7-24.04
```

连接到Valkey并检查状态：
```bash
docker exec valkey valkey-cli ping
```

若要调整Valkey容器的配置（例如禁用保护模式），请创建配置文件并将其挂载到容器的以下目录：
```
/var/lib/valkey
```

## 标签与架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
通过Canonical的受限仓库，可提供长达10年的客户安全维护（[了解更多](https://ubuntu.com/security/docker-images#get-in-touch)）。


| 通道标签                 |  | 支持至       | 当前版本                          | 架构     |
|---|---|---|---|---|
| **`7.2.10-24.04_stable`** | **`7.2.10-24.04`、`7.2.10-24.04_beta`、`7.2.10-24.04_candidate`、`7.2.10-24.04_edge`** | 04/2029 | 基于Ubuntu 24.04 LTS的valkey 7.2.10 | `amd64` |
| _`track_risk`_           |  |            |                                   |          |

通道标签按稳定性从高到低列出该追踪的通道：`stable`、`candidate`、`beta`、`edge`。风险较高的通道始终默认可用。例如，若列出`beta`，则`edge`也可用；若列出`candidate`，则`beta`和`edge`可用；若列出`stable`，则四个通道均可用。镜像会严格按照`edge`→`beta`→`candidate`→`stable`的顺序发布。

### 商业用途与扩展安全维护通道
如果您的使用场景包括商业再分发，或需要ESM（扩展安全维护）或未列出的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。

## 使用方法

本地启动该镜像：

```sh
docker run -d --name valkey-container -e TZ=UTC -p 6379:6379 docker.xuanyuan.run/ubuntu/valkey:7.2.10-24.04_stable
```
可通过`http://localhost:6379`访问Valkey服务器。


### 测试/调试

调试容器：
```sh
docker logs -f valkey-container
```

获取交互式shell：
```sh
docker exec -it valkey-container /bin/bash
```

### 调试

调试容器：
```bash
docker logs -f <valkey-container>
```

获取交互式shell：
```bash
docker exec -it <valkey-container> /bin/bash
```


## Bug与功能请求

如果您在镜像中发现Bug或需要请求特定功能，请通过以下链接提交Bug：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将Bug标题格式设为“`valkey: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：
```sh
docker images --no-trunc --quiet ubuntu/valkey:<tag>
```


## 已弃用的通道与标签

以下通道（标签）不再更新。请升级至较新的通道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 追踪   | 版本   | 停止维护日期 | 升级路径 |
|---|---|---|---|
| _`track`_ |        |              |          |
