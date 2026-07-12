---
image: ubuntu/alertmanager
description: "Ubuntu Rock版Alertmanager，用于处理Prometheus等客户端应用发送的警报，支持去重、分组、路由至接收器（如邮件、PagerDuty），并提供警报静音和抑制功能，基于Ubuntu且接收安全更新。"
source: https://xuanyuan.cloud/zh/r/ubuntu/alertmanager
canonical: https://xuanyuan.cloud/zh/r/ubuntu/alertmanager
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/alertmanager" title="ubuntu/alertmanager Docker 镜像中文简介、标签列表与拉取命令">ubuntu/alertmanager 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# alertmanager | Ubuntu

Canonical提供的当前alertmanager Docker镜像，基于Ubuntu系统，接收安全更新并滚动更新至新版本alertmanager或Ubuntu发行版。**本仓库可免费使用，且不受每用户速率限制。**


## 镜像概述和主要用途

alertmanager用于处理Prometheus等客户端应用发送的警报。它负责警报的去重、分组和路由，将其发送到正确的接收器集成（如邮件、PagerDuty、OpSGenie等，通过webhook接收器支持更多机制），同时处理警报的静音和抑制。更多信息请参见[官方文档](https://prometheus.io/docs/alerting/latest/alertmanager/)。

请注意，本仓库现在包含的是Rock格式镜像，而非基于Dockerfile的镜像，因此入口点现为Pebble。更多信息请参见[Rockcraft文档](https://canonical-rockcraft.readthedocs-hosted.com/en/latest/)。


## 核心功能和特性

- **警报处理**：支持警报去重、分组和路由至多种接收器
- **警报管理**：提供警报静音和抑制功能
- **安全更新**：基于Ubuntu系统，接收持续的安全更新
- **Rock格式**：采用Rock格式构建，入口点为Pebble
- **长期支持**：LTS通道提供长达5年的免费安全维护，ESM通道可通过Canonical获取长达10年的客户安全维护


## 使用场景和适用范围

适用于需要集中管理监控警报的场景，尤其是在Prometheus监控架构中，需将警报分发到不同通知渠道的企业级监控环境。可用于处理来自各类客户端应用的警报，确保警报准确送达相关人员或系统。


## 标签与架构

![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)  
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)  
ESM通道通过[Canonical的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)提供长达10年的客户安全维护。


| 通道标签 | 支持至 | 当前版本 | 架构 |
|---|---|---|---|
| **`0.28.0-24.04_stable`**<br>**`0-24.04`**, `0-24.04_beta`, `0-24.04_candidate`, `0-24.04_edge`, `0-24.04_stable`, `0.28-24.04`, `0.28-24.04_beta`, `0.28-24.04_candidate`, `0.28-24.04_edge`, `0.28-24.04_stable`, `0.28.0-24.04`, `0.28.0-24.04_beta`, `0.28.0-24.04_candidate`, `0.28.0-24.04_edge` | 2025年4月 | Ubuntu 24.04 LTS上的alertmanager 0.28.0 | `amd64` |
| _`track_risk`_ |  |  |  |

通道标签按稳定性排序：`stable` > `candidate` > `beta` > `edge`。风险较高的通道始终隐含可用（如列出`beta`则可拉取`edge`，列出`stable`则四个通道均可用）。镜像会按`edge`→`beta`→`candidate`→`stable`的顺序发布。

### 商业用途与扩展安全维护通道
若您的使用涉及商业再分发，或需要ESM及其他未列出的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。


## 详细使用方法和配置说明

### 本地启动

```sh
docker run -d --name alertmanager-container -e TZ=UTC -p 9093:9093 docker.xuanyuan.run/ubuntu/alertmanager:0.28.0-24.04_stable
```
通过`http://localhost:9093`访问Alertmanager实例。

### 参数说明

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 设置时区。 |
| `-p 9093:9093` | 将Alertmanager暴露在`localhost:9093`。 |
| `-v /path/to/alertmanager.yml:/etc/prometheus/alertmanager.yml` | 挂载本地配置文件`alertmanager.yml`。 |
| `-v /path/to/persisted/data:/alertmanager` | 持久化数据（避免每次启动容器初始化新数据库）。**重要说明**：持久化目录需属于`nogroup:nobody`用户组，启动容器前请运行`chown nogroup:nobody <path_to_persist_data>`。 |

### 测试与调试

查看容器日志：
```sh
docker logs -f alertmanager-container
```

获取交互式shell：
```sh
docker exec -it alertmanager-container /bin/bash
```

调试容器：
```bash
docker logs -f alertmanager-container
```

获取交互式shell：
```bash
docker exec -it alertmanager-container exec /bin/bash
```


## 已弃用标签

| 通道 | 版本 | 终止支持日期 | 升级路径 |
|---|---|---|---|
| ~~0.27.0-22.04~~ | Ubuntu 22.04 LTS上的alertmanager 0.27.0 | 2025年3月 | - |
| ~~0.25.0-22.04~~ | Ubuntu 22.04 LTS上的alertmanager 0.25.0 | 2025年3月 | - |
| ~~0.26.0-22.04~~ | Ubuntu 22.04 LTS上的alertmanager 0.26.0 | 2025年3月 | - |
| _`track`_ |  |  |  |


## 问题反馈

如发现镜像漏洞或需请求功能，请通过以下链接提交：  
[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将bug标题格式设为“`alertmanager: <问题摘要>`”，并包含所用镜像的完整 digest（可通过`docker images --no-trunc --quiet ubuntu/alertmanager:<tag>`获取）。
