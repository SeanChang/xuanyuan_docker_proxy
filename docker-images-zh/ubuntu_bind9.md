---
image: ubuntu/bind9
description: "BIND 9是灵活且功能全面的DNS系统，提供由Canonical维护的长期版本。"
source: https://xuanyuan.cloud/zh/r/ubuntu/bind9
canonical: https://xuanyuan.cloud/zh/r/ubuntu/bind9
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/bind9" title="ubuntu/bind9 Docker 镜像中文简介、标签列表与拉取命令">ubuntu/bind9 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bind9 Docker镜像（基于Ubuntu）


## 镜像概述和主要用途

本镜像为Canonical提供的Bind9 Docker镜像，基于Ubuntu系统构建，持续接收安全更新，并跟踪Bind9与Ubuntu的最新版本组合。该仓库可免费使用，且不受用户速率限制。

Bind9是一款灵活、功能全面的DNS系统，主要用于域名系统（DNS）管理，包括两方面核心能力：一是为特定DNS区域权威定义域名，二是递归解析域名至对应IP地址。除DNS服务器进程`named`外，镜像还包含用于执行DNS查询和动态更新的工具。


## 核心功能和特性

- **完整DNS服务**：支持权威域名解析（定义域名与IP对应关系）和递归域名解析（查询外部域名获取IP）
- **安全维护**：基于Ubuntu LTS系统，提供长期安全更新，LTS通道支持长达5年免费安全维护，ESM通道可扩展至10年
- **多架构支持**：兼容`amd64`、`arm64`、`ppc64el`、`s390x`等架构
- **灵活配置**：支持自定义`named.conf`配置文件，可通过挂载卷实现本地配置管理
- **轻量部署**：容器化设计，支持快速启动和隔离部署
- **工具集成**：内置DNS查询工具，便于调试和管理


## 使用场景和适用范围

- **本地DNS缓存服务器**：部署轻量级缓存DNS，加速域名解析并减少外部DNS依赖
- **企业内部DNS服务**：为企业网络提供权威域名解析，管理内部域名体系
- **开发测试环境**：模拟DNS服务，用于应用程序域名解析功能测试
- **长期运行场景**：需稳定DNS服务且要求长期安全维护的生产环境（如企业基础设施、服务集群）


## 标签和架构

### 通道标签与架构支持

| 通道标签                | 维护类型                                                                 | 当前版本                          | 支持架构                          |
|-------------------------|--------------------------------------------------------------------------|-----------------------------------|-----------------------------------|
| **`9.18-22.04_beta`**   | ![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)          | Bind9 9.18 on Ubuntu 22.04 LTS    | `amd64`, `arm64`, `ppc64el`, `s390x` |
| `9.16-20.04_beta`       | ![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)          | Bind9 9.16.1 on Ubuntu 20.04 LTS  | `amd64`, `arm64`, `ppc64el`, `s390x` |
| _`track_risk`_          | -                                                                        | -                                 | -                                 |

> **说明**：斜体标签在`ubuntu/bind9`中不可用，仅为完整性展示。


### 通道稳定性说明

通道标签表示对应轨道（track）的最稳定版本。轨道是应用版本与Ubuntu系统版本的组合（如`1.0-22.04`）。通道按稳定性从高到低排序为：`stable`、`candidate`、`beta`、`edge`。风险较高的通道默认隐含可用，例如：若列出`beta`，则可拉取`edge`；若列出`candidate`，则可拉取`beta`和`edge`；若列出`stable`，则四个通道均可用。镜像版本会按`edge`→`beta`→`candidate`→`stable`的顺序依次发布。


### 长期安全维护（ESM）与商业用途

- **LTS通道**：提供长达5年免费安全维护
- **ESM通道**：通过`canonical/bind9`可获取长达10年的客户安全维护，[申请访问](https://ubuntu.com/security/docker-images#get-in-touch)
- **商业用途**：若需商业 redistribution 或使用未列出的通道/版本，请联系Canonical团队（邮箱：rocks@canonical.com）


## 使用方法和配置说明

### 本地快速启动

使用以下命令启动容器：

```sh
docker run -d --name bind9-container -e TZ=UTC -p 30053:53 -p 30053:53/udp ubuntu/bind9:9.18-22.04_beta
```

启动后可通过`localhost:30053`访问Bind9服务器。


### 配置参数说明

| 参数                                  | 描述                                                                 |
|---------------------------------------|----------------------------------------------------------------------|
| `-e TZ=UTC`                           | 设置时区（示例为UTC）                                                |
| `-p 30053:53`                         | 映射容器53端口（TCP）至本地30053端口                                 |
| `-p 30053:53/udp`                     | 映射容器53端口（UDP）至本地30053端口                                 |
| `-e BIND9_USER=bind`                  | 指定启动`named`进程的用户（默认`bind`）                              |
| `-v /path/to/named.conf:/etc/bind/named.conf` | 挂载本地配置文件`named.conf`（配置示例见[此处](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/bind9/plain/examples/caching-nameserver/named.conf.options?h=9.18-22.04)） |
| `-v /path/to/cache:/var/cache/bind`   | 挂载本地目录用于存储DNS缓存数据                                      |
| `-v /path/to/records:/var/lib/bind`   | 挂载本地目录用于存储资源记录（定义域名信息）                          |


### 测试与调试

#### 查看容器日志

```sh
docker logs -f bind9-container
```

#### 进入容器交互式终端

```sh
docker exec -it bind9-container /bin/bash
```


### Kubernetes部署

适用于任何Kubernetes环境，推荐使用MicroK8s（安装命令：`microk8s.enable dns storage`，并通过`snap alias microk8s.kubectl kubectl`设置别名）。

1. 下载部署文件：[bind9-deployment.yml](https://git.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/bind9/plain/examples/bind9-deployment.yml?h=9.18-22.04)
2. 修改文件中`containers.bind9.image`为目标通道标签（如`ubuntu/bind9:9.18-22.04_beta`）
3. 应用部署：

```sh
kubectl apply -f bind9-deployment.yml
```


## 错误和功能请求

若发现镜像错误或需请求功能，请在[此处提交issue](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)，标题格式为`bind9: <问题摘要>`。提交时需包含镜像 digest，可通过以下命令获取：

```sh
docker images --no-trunc --quiet ubuntu/bind9:<tag>
```


## 已弃用的通道和标签

| 轨道                | 版本                                  | 停止维护日期 | 升级路径          |
|---------------------|---------------------------------------|--------------|-------------------|
| ~~9.16-21.10~~      | Bind9 9.16.1 on Ubuntu 21.10          | 2022-07      | 9.18-22.04_beta   |
| _`track`_           | -                                     | -            | -                 |
