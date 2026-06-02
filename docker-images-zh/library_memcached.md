---
image: library/memcached
description: "这是一款免费且开源的高性能分布式内存对象缓存系统，主要通过将频繁访问的数据存储在内存中以实现快速数据检索，有效减轻数据库等后端存储的访问压力，提升应用系统的响应速度和整体性能，广泛适用于各类分布式架构环境及高并发业务场景，为开发者提供可靠、高效的数据缓存解决方案。"
source: https://xuanyuan.cloud/zh/r/library/memcached
canonical: https://xuanyuan.cloud/zh/r/library/memcached
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/memcached" title="library/memcached Docker 镜像中文简介、标签列表与拉取命令">library/memcached — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/memcached" title="library/memcached Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/memcached</a>

# Memcached Docker 镜像使用说明


## 快速参考

### 维护者  
[Docker 社区]([])  


### 获取帮助  
可通过以下渠道寻求支持：  
- [Docker 社区 Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  

以下是当前支持的镜像标签，及对应的 Dockerfile 源码链接：  

- `1.6.39`, `1.6`, `1`, `latest`, `1.6.39-trixie`, `1.6-trixie`, `1-trixie`, `trixie`  
  [Dockerfile]([])  

- `1.6.39-alpine`, `1.6-alpine`, `1-alpine`, `alpine`, `1.6.39-alpine3.22`, `1.6-alpine3.22`, `1-alpine3.22`, `alpine3.22`  
  [Dockerfile]([])  


## 快速参考（续）

### 问题反馈  
若发现镜像问题，可在 [GitHub 仓库]([]) 提交 issue。  


### 支持的架构  
（更多信息见 [官方说明]([])）  
`amd64`, `arm32v5`, `arm32v6`, `arm32v7`, `arm64v8`, `i386`, `ppc64le`, `riscv64`, `s390x`  


### 镜像详情  
镜像的元数据、传输大小等详细信息，可查看 [repo-info 仓库的 memcached 目录]([])（含 [历史记录]([])）。  


### 镜像更新  
镜像更新信息可通过以下途径追踪：  
- [official-images 仓库的 library/memcached 标签]([])  
- [official-images 仓库的 library/memcached 文件]([])（含 [历史记录]([])）  


### 描述来源  
本文档内容来源于 [docs 仓库的 memcached 目录]([])（含 [历史记录]([])）。  


## 什么是 Memcached？  

Memcached 是一款通用的分布式内存缓存系统，常用于加速动态数据库驱动网站，通过将数据和对象缓存到内存中，减少对外部数据源（如数据库或 API）的读取次数。  

Memcached 的 API 提供了一个跨多台机器的大型哈希表。当哈希表满时，新插入的数据会按“最近最少使用”（LRU）原则淘汰旧数据。使用 Memcached 的应用通常会优先从内存中读取或写入数据，仅在内存不可用时才依赖数据库等较慢的后端存储。  

> 更多信息：[维基百科 Memcached 条目]()  


## 如何使用此镜像  


### 基本运行  

运行以下命令启动一个基本的 memcached 容器：  

```console
$ docker run --name my-memcache -d memcached
```  


### 自定义配置  

若需调整 memcached 服务器配置，可先通过以下命令查看支持的配置选项：  

```console
$ docker run --rm memcached -h
```  

#### 通过 `docker run` 配置  

例如，限制内存使用为 64MB：  

```console
$ docker run --name my-memcache -d memcached memcached --memory-limit=64
```  

#### 通过 Docker Compose 配置  

在 `docker-compose.yml` 中添加自定义参数（如连接限制、内存限制、线程数）：  

```yaml
services:
  memcached:
    image: memcached
    command:
      - --conn-limit=1024    # 最大连接数限制为 1024
      - --memory-limit=64    # 内存限制为 64MB
      - --threads=4          # 启动 4 个工作线程
```  

更多配置细节可参考 [memcached 官方 wiki]([])。  


## 镜像变体  

`memcached` 镜像提供多种变体，适用于不同场景：  


### `memcached:<version>`  

这是默认镜像，基于 Debian 系统构建。若不确定需求，建议使用此变体。它既可用作临时容器（挂载代码后直接启动），也可作为基础镜像构建其他镜像。  

部分标签包含 Debian 版本代号（如 `trixie`），对应 Debian 的具体发行版。若需在镜像中安装额外包，建议显式指定此类标签，以减少 Debian 版本更新带来的兼容性问题。  


### `memcached:<version>-alpine`  

此变体基于 [Alpine Linux]([])（轻量级 Linux 发行版）构建，镜像体积极小（约 5MB），适合对镜像大小有严格要求的场景。  

**注意**：Alpine 使用 `musl libc` 而非 `glibc`，部分依赖 `glibc` 的软件可能存在兼容性问题。此外，Alpine 镜像通常不包含 `git`、`bash` 等额外工具，若需安装，可参考 [Alpine 官方镜像文档]([]) 进行扩展。  


## 许可证  

镜像中包含的 memcached 软件许可证信息，可查看 [memcached 源码仓库的 LICENSE 文件]([])。  

与所有 Docker 镜像一样，本镜像可能包含其他软件（如 Debian 基础系统中的 Bash 等），这些软件可能具有独立许可证。自动检测到的额外许可证信息，可参考 [repo-info 仓库的 memcached 目录]([])。  

使用前请确保遵守镜像中所有软件的相关许可证要求。
