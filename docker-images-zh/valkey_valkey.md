---
image: valkey/valkey
description: "Valkey 是一款高性能的数据结构服务器，主要专注于为键值（key/value）类型的工作负载提供服务，它凭借优化的数据处理机制和高效的存储结构，能够快速响应各类键值对操作请求，适用于高吞吐量、低延迟的应用场景，通过稳定可靠的运行机制为用户提供高效的数据服务支持。"
source: https://xuanyuan.cloud/zh/r/valkey/valkey
canonical: https://xuanyuan.cloud/zh/r/valkey/valkey
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/valkey/valkey" title="valkey/valkey Docker 镜像中文简介、标签列表与拉取命令">valkey/valkey — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/valkey/valkey" title="valkey/valkey Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/valkey/valkey</a>

# Valkey Docker 镜像使用指南  


本文档由 [Valkey-Release-Automation]([]) 自动生成  
最后更新时间：2025-10-08  


## 快速参考  

- **维护方**：  
  [Valkey 社区]([])  

- **获取帮助**：  
  请在 [Valkey 社区 GitHub 仓库]([]) 提交 Issue 描述问题。  


## 支持的标签及对应 Dockerfile 链接  

### 官方发布版  
- [`8.1.4`, `8.1`, `8`, `latest`, `8.1.4-trixie`, `8.1-trixie`, `8-trixie`, `trixie`]([])  
- [`8.1.4-alpine`, `8.1-alpine`, `8-alpine`, `alpine`, `8.1.4-alpine3.22`, `8.1-alpine3.22`, `8-alpine3.22`, `alpine3.22`]([])  
- [`8.0.6`, `8.0`, `8.0.6-trixie`, `8.0-trixie`]([])  
- [`8.0.6-alpine`, `8.0-alpine`, `8.0.6-alpine3.22`, `8.0-alpine3.22`]([])  
- [`7.2.11`, `7.2`, `7`, `7.2.11-trixie`, `7.2-trixie`, `7-trixie`]([])  
- [`7.2.11-alpine`, `7.2-alpine`, `7-alpine`, `7.2.11-alpine3.22`, `7.2-alpine3.22`, `7-alpine3.22`]([])  


### 候选发布版  
- [`9.0.0-rc3`, `9.0`, `9.0.0-rc3-trixie`, `9.0-trixie`]([])  
- [`9.0.0-rc3-alpine`, `9.0-alpine`, `9.0.0-rc3-alpine3.22`, `9.0-alpine3.22`]([])  


### 最新不稳定版  
- [`unstable`, `unstable-bookworm`]([])  
- [`unstable-alpine`, `unstable-alpine3.21`]([])  


## 什么是 Valkey？  
Valkey 是一款高性能数据结构服务器，主要用于处理键值工作负载。它支持多种原生数据结构，并提供可扩展插件系统，用于添加新的数据结构和访问模式。  


## 安全注意事项  
为便于通过 Docker 网络从其他容器访问 Valkey，默认关闭“保护模式”。这意味着如果通过 `-p` 参数将端口暴露到主机外部（如互联网），任何人都可无密码访问。**强烈建议**在暴露实例到互联网时通过配置文件设置密码。更多安全信息可参考：  
- [Valkey 安全文档]([])  
- [保护模式说明]([])  
- [antirez 关于安全的几点说明]([])  


## 如何使用本镜像  

### 启动 Valkey 实例  
```console
$ docker run --name some-valkey -d valkey/valkey
```  


### 启用持久化存储  
如需启用数据持久化，可配置定期快照（如下示例每 60 秒且至少 1 次写入时保存快照）：  
```console
$ docker run --name some-valkey -d valkey/valkey valkey-server --save 60 1 --loglevel warning
```  
持久化数据默认存储在 `VOLUME /data` 目录，可通过 `-v /host/dir:/data` 挂载主机目录，或使用 `--volumes-from` 共享卷（详见 [Docker 卷文档]([])）。  


### 通过 `valkey-cli` 连接  
在同一网络中连接到 Valkey 实例：  
```console
$ docker run -it --network some-network --rm valkey/valkey valkey-cli -h some-valkey
```  
（`some-network` 为容器所在网络，`some-valkey` 为 Valkey 容器名称）  


### 通过环境变量传递启动参数  
使用 `VALKEY_EXTRA_FLAGS` 环境变量传递 `valkey-server` 参数，无需覆盖 CMD：  
```console
$ docker run --env VALKEY_EXTRA_FLAGS='--save 60 1 --loglevel warning' valkey/valkey
```  


### 使用自定义 `valkey.conf`  
#### 方法 1：通过 Dockerfile 集成配置  
创建包含自定义配置的 Dockerfile：  
```dockerfile
FROM valkey/valkey
COPY valkey.conf /usr/local/etc/valkey/valkey.conf
CMD [ "valkey-server", "/usr/local/etc/valkey/valkey.conf" ]
```  

#### 方法 2：运行时挂载配置文件  
直接挂载主机目录中的配置文件，无需编写 Dockerfile：  
```console
$ docker run -v /myvalkey/conf:/usr/local/etc/valkey --name myvalkey valkey/valkey valkey-server /usr/local/etc/valkey/valkey.conf
```  
**注意**：挂载目录需可写，Valkey 可能需要创建或修改配置文件。  


### Systemd 启动通知（适用于 Podman Quadlet）  
Valkey 支持通过 Systemd 通知启动状态，确保依赖服务在 Valkey 就绪后启动。在 Quadlet 服务文件中配置：  
```systemd
[Container]
Image=docker.io/valkey/valkey:latest
Exec=valkey-server --supervised systemd
Notify=true
```  


## 镜像变体  

### `valkey/valkey:<version>`（默认镜像）  
基于 Debian 系统，包含完整依赖，适用于大多数场景。标签中如 `trixie` 为 Debian 发行版代号，如需安装额外包，建议指定具体代号以避免兼容性问题。  


### `valkey/valkey:<version>-alpine`（轻量级镜像）  
基于 Alpine Linux，体积更小（约 5MB 基础镜像），适合对镜像大小敏感的场景。需注意 Alpine 使用 musl libc，部分依赖 glibc 的软件可能存在兼容性问题。  


## 许可信息  
本镜像包含的软件许可信息可查看 [Valkey 许可文件]([])。Docker 镜像可能包含其他软件（如 Bash 等基础系统工具），其许可需用户自行确认并遵守。
