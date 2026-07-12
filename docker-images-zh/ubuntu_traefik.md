---
image: ubuntu/traefik
description: "基于Ubuntu的Traefik ROCK镜像，Traefik是一款现代化的HTTP反向代理和负载均衡器，便于部署微服务，支持自动动态配置并接收安全更新。"
source: https://xuanyuan.cloud/zh/r/ubuntu/traefik
canonical: https://xuanyuan.cloud/zh/r/ubuntu/traefik
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/traefik" title="ubuntu/traefik Docker 镜像中文简介、标签列表与拉取命令">ubuntu/traefik 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# traefik | Ubuntu

当前的traefik Docker镜像由Canonical提供，基于Ubuntu系统。该镜像会接收安全更新，并会滚动更新至较新版本的traefik或Ubuntu。本仓库可免费使用，且不受每用户速率限制。


## 关于traefik

Traefik是一款现代化的HTTP反向代理和负载均衡器，可简化微服务的部署流程。Traefik能与现有基础设施组件（Docker、Swarm模式、Kubernetes、Consul、Etcd、Rancher v2、Amazon ECS等）集成，并可自动动态地完成配置。更多信息请访问[官方网站](https://traefik.io/)。

## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS通道提供长达5年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
通过[Canonical的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)提供长达10年的客户安全维护。


| 通道标签 | 其他标签 | 支持至 | 当前版本 | 架构 |
|---|---|---|---|---|
| **`2.10.5-22.04_stable`** | **`2.10.5-22.04`、`2.10.5-22.04_beta`、`2.10.5-22.04_candidate`、`2.10.5-22.04_edge`** | - | Ubuntu 22.04 LTS上的traefik 2.10.5 | `amd64` |
| `2.10.4-22.04_stable` | `2.10.4-22.04`、`2.10.4-22.04_beta`、`2.10.4-22.04_candidate`、`2.10.4-22.04_edge` | - | Ubuntu 22.04 LTS上的traefik 2.10.4 | `amd64` |
| `2.11.0-22.04_stable` | `2-22.04`、`2-22.04_beta`、`2-22.04_candidate`、`2-22.04_edge`、`2-22.04_stable`、`2.11-22.04`、`2.11-22.04_beta`、`2.11-22.04_candidate`、`2.11-22.04_edge`、`2.11-22.04_stable`、`2.11.0-22.04`、`2.11.0-22.04_beta`、`2.11.0-22.04_candidate`、`2.11.0-22.04_edge` | - | Ubuntu 22.04 LTS上的traefik 2.11.0 | `amd64` |
| `2.10.6-22.04_stable` | `2.10.6-22.04`、`2.10.6-22.04_beta`、`2.10.6-22.04_candidate`、`2.10.6-22.04_edge` | - | Ubuntu 22.04 LTS上的traefik 2.10.6 | `amd64` |
| `2.10.7-22.04_stable` | `2.10-22.04`、`2.10-22.04_beta`、`2.10-22.04_candidate`、`2.10-22.04_edge`、`2.10-22.04_stable`、`2.10.7-22.04`、`2.10.7-22.04_beta`、`2.10.7-22.04_candidate`、`2.10.7-22.04_edge` | - | Ubuntu 22.04 LTS上的traefik 2.10.7 | `amd64` |
| _`track_risk`_ |

通道标签按稳定性从高到低排序：`stable`、`candidate`、`beta`、`edge`。风险较高的通道始终隐含可用，例如若列出`beta`，则也可拉取`edge`；若列出`candidate`，则可拉取`beta`和`edge`；若列出`stable`，则四个通道均可用。镜像会按`edge`→`beta`→`candidate`→`stable`的顺序发布。

### 商业用途和扩展安全维护通道
如果您的使用场景包括商业再分发，或需要ESM及其他未提供的通道/版本，请[联系Canonical团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至rocks@canonical.com）。

## 使用方法

本地启动该镜像：

```sh
docker run -d --name traefik-container -e TZ=UTC -p 80:80 docker.xuanyuan.run/ubuntu/traefik:2.10.5-22.04_stable
```
通过`http://localhost:80`访问您的Traefik实例。

#### 参数说明

| 参数 | 描述 |
|---|---|
| `-e TZ=UTC` | 时区。 |
| `-p 80:80` | 将Traefik暴露在`localhost:80`。如需TLS，应使用443端口。 |
| `-v /path/to/traefik.yml:/etc/traefik/prometheus.yml` | 本地配置文件`traefik.yml`。 |


#### 测试/调试

调试容器：

```sh
docker logs -f traefik-container
```

获取交互式shell：

```sh
docker exec -it traefik-container /bin/bash
```

### 调试

调试容器：

```bash
docker logs -f traefik-container
```

获取交互式shell：

```bash
docker exec -it traefik-container /bin/bash
```

## Bug和功能请求

如果您在镜像中发现bug或需要请求特定功能，请通过以下链接提交bug：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将bug标题格式化为“`traefik: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/traefik:<tag>
```

## 废弃的通道和标签
以下通道（标签）不再更新。请升级至较新的通道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 通道 | 版本 | 生命周期结束（EOL） | 升级路径 |
|---|---|---|---|
| _`track`_ |
