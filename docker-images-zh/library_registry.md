---
image: library/registry
description: "一种针对容器化技术的分发实现方案，专注于容器镜像及各类相关制品的存储与分发管理，支持从制品构建、版本控制到跨环境部署的全生命周期流程，保障镜像和制品在开发、测试与生产环节中的高效传输与可靠供应，为容器化应用的持续集成和持续部署提供稳定的基础设施支持。"
source: https://xuanyuan.cloud/zh/r/library/registry
canonical: https://xuanyuan.cloud/zh/r/library/registry
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/registry" title="library/registry Docker 镜像中文简介、标签列表与拉取命令">library/registry — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/registry" title="library/registry Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/registry</a>

# Distribution Registry 镜像介绍


## 快速参考

### 维护方  
[Docker 社区]([])


### 获取帮助  
可通过 [CNCF 社区 Slack]([]) 或 [Stack Overflow]([])（标签：`docker+registry`）获取支持。


### 支持的标签及对应 Dockerfile 链接  
- [`3.0.0`, `3.0`, `3`, `latest`]([])  


## 快速参考（续）

### 问题反馈地址  
[[]]([])


### 支持的架构  
（更多信息：[[]]([])）  
[`amd64`]([])、[`arm32v6`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])  


### 镜像详情  
包括元数据、传输大小等信息，可查看 [repo-info 仓库的 `repos/registry/` 目录]([])（[更新历史]([])）。  


### 镜像更新记录  
- 查看更新动态：[official-images 仓库的 `library/registry` 标签]([])  
- 查看更新文件历史：[official-images 仓库的 `library/registry` 文件]([])（[更新历史]([])）  


### 本文档来源  
[docs 仓库的 `registry/` 目录]([])（[更新历史]([])）  


## 关于 Distribution Registry  
这个镜像包含 OCI Distribution 规范的实现。关于该规范的详情可查看 [github.com/opencontainers/distribution-spec]([])，完整源码见 [github.com/distribution/distribution]([])。  


## 本地运行 registry：快速版  
### 启动 registry 容器  
```console
$ docker run -d -p 5000:5000 --restart always --name registry registry:3
```

### 在 Docker 中使用本地 registry  
```console
# 拉取官方镜像
$ docker pull ubuntu

# 为镜像打本地 registry 标签
$ docker tag ubuntu localhost:5000/ubuntu

# 推送到本地 registry
$ docker push localhost:5000/ubuntu
```


## 推荐阅读  
官方 [文档]([]) 详细介绍了 registry 的功能、工作原理及使用方法。  
特别是 [部署相关章节]([])，包含了比本地运行更复杂场景的配置指南。  


## 许可证  
- 镜像中软件的许可证信息可查看 [源码仓库的 LICENSE 文件]([])。  
- 与所有 Docker 镜像类似，该镜像可能包含其他软件（如基础系统的 Bash 等），这些软件可能采用不同许可证。部分自动检测到的许可证信息可在 [repo-info 仓库的 `registry/` 目录]([]) 中找到。  
- 使用预构建镜像时，用户需自行确保对镜像中所有软件的使用符合相关许可证要求。
