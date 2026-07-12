---
image: ubuntu/memcached
description: "Memcached 是一种内存中的键值存储，用于存储小块任意数据（如字符串、对象），由 Canonical 维护长期跟踪。"
source: https://xuanyuan.cloud/zh/r/ubuntu/memcached
canonical: https://xuanyuan.cloud/zh/r/ubuntu/memcached
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/memcached" title="ubuntu/memcached Docker 镜像中文简介、标签列表与拉取命令">ubuntu/memcached 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Memcached | Ubuntu

当前的 Memcached Docker 镜像来自 Canonical，基于 Ubuntu 构建。该镜像接收安全更新，并跟踪最新的 Memcached 和 Ubuntu 组合。**此仓库可免费使用，且不受每用户速率限制。**


## 关于 Memcached

Memcached 是一种内存中的键值存储，用于存储小块任意数据（字符串、对象），这些数据通常来自数据库调用、API 调用或页面渲染的结果。它是应用程序的短期内存。Memcached 允许从系统中内存过剩的部分获取内存，并将其提供给内存不足的区域。更多信息请访问 [memcached 官网](https://memcached.org/)。


## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS 通道提供长达 5 年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
`from canonical/memcached` 提供长达 10 年的客户安全维护。[请求访问](https://ubuntu.com/security/docker-images#get-in-touch)。

*斜体标签在 ubuntu/memcached 中不可用，但在此处列出以保持完整性。*

| 通道标签                |       |       | 当前版本                          | 架构                          |
|-------------------------|-------|-------|-----------------------------------|-------------------------------|
| **`1.6-22.04_beta`**     |       |       | Memcached 1.6 基于 Ubuntu 22.04 LTS | `amd64`, `arm64`, `ppc64el`, `s390x` |
| `1.5-20.04_beta`         | ![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17) |       | Memcached 1.5.22 基于 Ubuntu 20.04 LTS | `amd64`, `arm64`, `ppc64el`, `s390x` |
| _`track_risk`_           |       |       |                                   |                               |

通道标签表示该轨道最稳定的通道。轨道是应用版本和底层 Ubuntu 系列的组合，例如 `1.0-22.04`。通道按稳定性从高到低排序：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐式可用。因此，如果列出了 `beta`，您也可以拉取 `edge`；如果列出了 `candidate`，您可以拉取 `beta` 和 `edge`；如果列出了 `stable`，则所有四个通道均可用。镜像保证按 `edge`、`beta`、`candidate`、`stable` 的顺序发布。

### 商业用途和扩展安全维护通道
如果您的使用场景包括商业再分发，或需要不可用的通道/版本，请 [联系 Canonical 团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至 rocks@canonical.com）。


## 使用方法

### 本地启动镜像

```sh
docker run -d --name memcached-container -e TZ=UTC docker.xuanyuan.run/ubuntu/memcached:1.6-22.04_beta
```

#### 参数说明

| 参数                          | 描述                                                                 |
|-------------------------------|----------------------------------------------------------------------|
| `-e TZ=UTC`                   | 时区。                                                                |
| `-e MEMCACHED_CACHE_SIZE=64MB`| 确定缓存大小。                                                        |
| `-e MEMCACHED_MAX_CONNECTIONS=1024` | 确定最大并发连接数。                                                |
| `-e MEMCACHED_THREADS=4`      | 确定处理请求的线程数。                                                |
| `-e MEMCACHED_PASSWORD`       | 如果提供了其他用户名，为 `root` 用户定义密码。默认禁用身份验证，但如果传递此选项则启用。 |
| `-e MEMCACHED_USERNAME`       | 定义新用户。如果传递此选项，需要密码来验证新用户。                      |
| `-p 11211:11211`              | Memcached 在容器内暴露于端口 `11211`。                                |


#### 测试/调试

查看容器日志：

```sh
docker logs -f memcached-container
```

获取交互式 shell：

```sh
docker exec -it memcached-container /bin/bash
```

<details>
<summary>您可以从另一个容器通过 telnet 访问 Memcached 实例（点击展开）。</summary>

```sh
# 创建专用网络
$ docker network create memcached-network
# 将主容器连接到网络
$ docker network connect memcached-network memcached-container
# 运行带有最新 Ubuntu 的交互式容器
$ docker run -it --rm --name telnet --network memcached-network ubuntu bash
# 在容器内安装 telnet 命令行工具
> apt update && apt install telnet -y
# 使用 telnet 连接到 memcached 实例
> telnet memcached-container 11211
Trying 172.30.0.2...
Connected to memcached.
Escape character is '^]'.
```
从这里您可以运行 `memcached` 命令，如 [其 wiki](https://github.com/memcached/memcached/wiki/Commands) 中所述。

</details>

```sh
$ telnet memcached-container 11211
```

在某些情况下，可能需要传递一些无法通过环境变量配置的 memcached 命令行标志。此时，您可以将标志本身或 shell 脚本附加到运行命令中。


## 使用 Kubernetes 部署

适用于任何 Kubernetes；如果您没有 Kubernetes，建议安装 [MicroK8s](https://microk8s.io/)，执行 `microk8s.enable dns storage`，然后执行 `snap alias microk8s.kubectl kubectl`。

下载 [memcached-deployment.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/memcached/plain/examples/memcached-deployment.yml?h=1.6-22.04)，并在 `memcached-deployment.yml` 中将 `containers.memcached.image` 设置为您选择的通道标签（例如 `ubuntu/memcached:1.6-22.04_beta`），然后执行：

```sh
kubectl apply -f memcached-deployment.yml
```

Memcached 将在主机上的端口 `31211` 监听。


## 错误和功能请求

如果您在镜像中发现错误或想要请求特定功能，请在此提交错误报告：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将错误标题设为 “`memcached: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/memcached:<tag>
```


## 已弃用的通道和标签
这些通道（标签）不再更新。请升级到较新的通道，或如果无法升级，请 [联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 轨道               | 版本                                  | EOL       | 升级路径          |
|--------------------|---------------------------------------|-----------|-------------------|
| ~~1.6-21.10~~      | Memcached 1.6.9 基于 Ubuntu 21.10     | 07/2022   | 1.6-22.04_beta    |
| ~~1.6-21.04~~      | Memcached 1.6.9 基于 Ubuntu 21.04     | 01/2022   | ~~1.6-21.10~~     |
| _`track`_          |                                       |           |                   |
