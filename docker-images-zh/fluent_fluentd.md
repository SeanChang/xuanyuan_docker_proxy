---
image: fluent/fluentd
description: "Fluentd Docker镜像是由Fluent项目开发的官方Docker镜像，用于简化Fluentd的部署与使用，Fluentd作为一款开源数据收集器，旨在实现统一的日志收集与处理，支持多种数据源和输出目标，可帮助用户高效聚合、过滤和转发日志数据，该镜像可通过Docker直接快速部署，方便用户在容器化环境中集成Fluentd进行日志管理，更多信息可访问其官方网站[]"
source: https://xuanyuan.cloud/zh/r/fluent/fluentd
canonical: https://xuanyuan.cloud/zh/r/fluent/fluentd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fluent/fluentd" title="fluent/fluentd Docker 镜像中文简介、标签列表与拉取命令">fluent/fluentd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Fluentd Docker 镜像


## 什么是 Fluentd？
Fluentd 是一款开源数据收集工具，可统一数据采集与消费流程，帮助用户更好地利用和理解数据。  
官网：[www.fluentd.org]   


## 支持的标签及对应 Dockerfile 链接

### 当前镜像（Edge 版本）
以下标签包含镜像版本后缀，用于跟踪镜像更新。推荐用于需要最新功能的场景，建议反馈使用中的问题以帮助优化。  
当前镜像基于 Fluentd v1 系列，**自 v1.19.0 起不再提供 Alpine 镜像**。

- **通用标签**  
  `v1.19.0-2.1`、`v1.19-2`、`edge`、`latest`  
  （对应 Dockerfile：[v1.19/debian/Dockerfile][fluentd-1-debian]）

- **Debian 多架构镜像**  
  - 支持 arm64（AArch64）、armhf、amd64（x86_64）：  
    `v1.19.0-debian-2.1`、`v1.19-debian-2`、`edge-debian`  
  - 特定架构：  
    - amd64：`v1.19.0-debian-amd64-2.1`、`v1.19-debian-amd64-2`、`edge-debian-amd64`（[Dockerfile][fluentd-1-debian]）  
    - arm64：`v1.19.0-debian-arm64-2.1`、`v1.19-debian-arm64-2`、`edge-debian-arm64`（[Dockerfile][fluentd-1-debian-arm64]）  
    - armhf：`v1.19.0-debian-armhf-2.1`、`v1.19-debian-armhf-2`、`edge-debian-armhf`（[Dockerfile][fluentd-1-debian-armhf]）

- **Windows 镜像**  
  - Windows Server 2019 LTSC：`v1.19.0-windows-ltsc2019-1.0`、`v1.19-windows-ltsc2019-1`（[Dockerfile][fluentd-1-ltsc2019-windows]）  
  - Windows Server 2022 LTSC：`v1.19.0-windows-ltsc2022-1.0`、`v1.19-windows-ltsc2022-1`（[Dockerfile][fluentd-1-ltsc2022-windows]）

> 提示：关于已弃用的旧镜像，详见 [DEPRECATED](DEPRECATED.md)。  
> **生产环境推荐使用 Debian 版本**，其通过 jemalloc 缓解内存碎片问题。


### 若使用 Kubernetes？
请参考 [fluentd-kubernetes-daemonset]  镜像。


## 镜像标签说明
镜像基于 Debian 或 Alpine Linux（旧版本）构建，以下为当前镜像的标签规则说明：

### 标签命名规则
- **`edge`**：Fluentd 最新发布版本。  
- **`vX.Y-A`**：Fluentd `vX.Y` 分支的最新版本。`A` 为镜像重大更新计数器（Fluentd 版本更新时重置为 1）。  
- **`vX.Y.Z-A.B`**：具体的 Fluentd `vX.Y.Z` 版本（推荐生产环境使用）。`A` 为镜像重大更新计数器，`B` 为小更新/修复计数器（Fluentd 版本更新时 `A.B` 重置为 1.0）。

### 标签后缀说明
- **含 `debian`**：基于 [Debian 镜像][7] 构建，适用于需安装 Alpine 不支持的插件（如 `fluent-plugin-systemd`）。  
- **含 `armhf`**：基于 ARM 架构镜像，适用于树莓派等设备。支持通过 resin.io 工具跨平台构建，原生构建时需设置 `CROSS_BUILD_START` 和 `CROSS_BUILD_END` 为 `:`（空操作）。


### 旧镜像说明（已弃用）
以下标签仅为兼容性保留，**不建议新部署使用**，请迁移至上述“当前镜像”：  
- `stable`、`latest`（已移除，避免混淆）  
- `vX.Y`、`vX.Y.Z`（无镜像版本后缀的旧标签）  
- 含 `onbuild` 的标签（已弃用，建议使用非 onbuild 镜像构建自定义镜像）


## 如何使用镜像

### 基本运行
启动容器并暴露日志收集端口（TCP/UDP 24224），默认配置将日志存储至 `/fluentd/log`：  
```bash
docker run -d -p 24224:24224 -p 24224:24224/udp -v /data:/fluentd/log docker.xuanyuan.run/fluent/fluentd:v1.19-debian-2
```
默认行为：  
- 监听 24224 端口（Fluentd forward 协议）；  
- 标签为 `docker.**` 的日志存储至 `/fluentd/log/docker.*.log`（并创建 `docker.log` 软链接）；  
- 其他日志存储至 `/fluentd/log/data.*.log`（并创建 `data.log` 软链接）。


### 自定义配置与参数
通过 `docker run` 命令追加 Fluentd 参数，例如指定配置文件并开启 verbose 模式：  
```bash
docker run -ti --rm \
  -v /本地配置目录:/fluentd/etc \  # 挂载本地配置目录至容器内
  fluent/fluentd \
  -c /fluentd/etc/你的配置文件.conf \  # 指定配置文件路径
  -v  # 开启 verbose 日志
```


### 更改运行用户
使用 `-u` 参数指定运行用户：  
```bash
docker run -p 24224:24224 -u 用户名 -v /数据目录:/fluentd/log docker.xuanyuan.run/fluent/fluentd:v1.19-debian-2
```


## 如何构建自定义镜像
详见 [HOWTOBUILD](HOWTOBUILD.md) 文档。


## 参考资料
- [Docker Logging | fluentd.org][5]  
- [Fluentd 日志驱动 - Docker 文档][6]  


## 问题反馈
请勿在 DockerHub 评论区反馈问题。如有疑问或问题，请通过 [GitHub Issue]  联系我们。


[5]: []  
[6]: []  
[7]: []  
[fluentd-1-debian]: []  
[fluentd-1-debian-arm64]: []  
[fluentd-1-debian-armhf]: []  
[fluentd-1-ltsc2019-windows]: []  
[fluentd-1-ltsc2022-windows]: []
