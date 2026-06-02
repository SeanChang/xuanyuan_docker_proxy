---
image: moby/buildkit
description: "这是一款适用于容器镜像构建的并发、缓存高效且与Dockerfile无关的构建工具包，它通过并发处理能力显著提升构建速度，借助高效缓存机制大幅减少重复计算与资源消耗，同时摆脱对Dockerfile的依赖限制，支持多样化的构建配置与场景需求，为开发者提供灵活、高效且兼容性强的容器构建解决方案。"
source: https://xuanyuan.cloud/zh/r/moby/buildkit
canonical: https://xuanyuan.cloud/zh/r/moby/buildkit
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/moby/buildkit" title="moby/buildkit Docker 镜像中文简介、标签列表与拉取命令">moby/buildkit 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# BuildKit 介绍


## 关于 BuildKit  
BuildKit 是一款支持并发构建、缓存高效且不依赖 Dockerfile 的构建工具包。  


## 问题反馈与社区  
- **问题反馈**：请访问 [GitHub 仓库]([])  
- **社区交流**：可加入 Docker 社区 Slack 的 [#buildkit 频道]([])  


## 镜像标签  

### 最新稳定版  
- [`v0.25.1`, `latest`]([])  
- [`v0.25.1-rootless`, `rootless`]([])（使用说明见 [`docs/rootless.md`]([])）  


### 开发版（基于 master 分支）  
- [`master`]([])  
- [`master-rootless`]([])  


> 二进制发行版及更新日志可在 [GitHub Releases]([]) 查看  


## 使用指南  


### 在容器中运行 BuildKit 守护进程  
若要在容器中启动 BuildKit 守护进程，执行以下命令：  

```bash
docker run -d --name buildkitd --privileged moby/buildkit:latest
export BUILDKIT_HOST=docker-container://buildkitd
buildctl build --help
```  

通用使用说明详见 [BuildKit 文档]([])  


### 与 Docker Buildx 配合使用  
[Buildx]([]) 默认使用最新稳定版 BuildKit 镜像。如需指定自定义版本，可通过 `--driver-opt` 参数设置：  

```bash
docker buildx create --driver-opt image=moby/buildkit:master --use
```  


### Rootless 部署  
Rootless 模式部署说明详见 [`docs/rootless.md`]([])  


### Kubernetes 部署  
Kubernetes 部署示例可参考 [`examples/kubernetes`]([])  


### Daemonless 模式（无守护进程）  
该模式在单个容器中运行客户端和临时守护进程，命令如下：  

#### 普通模式  
```bash
docker run \
    -it \
    --rm \
    --privileged \
    -v /path/to/dir:/tmp/work \  # 替换为本地目录路径
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit:master \
        build \
        --frontend dockerfile.v0 \
        --local context=/tmp/work \
        --local dockerfile=/tmp/work
```  

#### Rootless 模式  
```bash
docker run \
    -it \
    --rm \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    -e BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \
    -v /path/to/dir:/tmp/work \  # 替换为本地目录路径
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit:master-rootless \
        build \
        --frontend dockerfile.v0 \
        --local context=/tmp/work \
        --local dockerfile=/tmp/work
```
