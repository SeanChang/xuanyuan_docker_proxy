---
image: alpine/helm
description: "当Kubernetes Helm有新发布时自动触发Docker构建的镜像"
source: https://xuanyuan.cloud/zh/r/alpine/helm
canonical: https://xuanyuan.cloud/zh/r/alpine/helm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/helm" title="alpine/helm Docker 镜像中文简介、标签列表与拉取命令">alpine/helm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Alpine/Helm Docker镜像文档


## 镜像概述与主要用途

Alpine/Helm是一个基于Alpine Linux的Docker镜像，用于自动构建并发布Kubernetes Helm工具的最新版本。该镜像通过自动化流程监听Helm官方发布，当有新版本发布时自动触发构建，确保用户能够快速获取对应版本的Helm容器化环境。镜像设计轻量高效，适用于需要在隔离环境中运行Helm命令的场景。


## 核心功能与特性

- **自动版本同步**：通过GitHub Action自动监听Helm官方发布，实时构建并推送对应版本镜像至Docker Hub。
- **多架构支持**：自3.5.4版本起支持多架构，包括`linux/amd64`、`linux/arm/v7`、`linux/arm64/v8`、`linux/arm/v6`、`linux/ppc64le`、`linux/s390x`（旧版本不支持多架构）。
- **轻量级基础**：基于Alpine Linux，镜像体积小，资源占用低。
- **环境隔离**：容器化运行Helm，避免本地环境依赖冲突。
- **灵活集成**：支持CI/CD流程、本地命令行别名配置等多种使用方式。


## 使用场景与适用范围

- **CI/CD流程**：作为持续集成/持续部署流水线的一部分，执行Helm chart打包、部署等操作。
- **自动化构建/部署**：嵌入自动化脚本，实现Kubernetes应用的自动化发布。
- **本地开发环境**：在不直接安装Helm的情况下，通过容器化方式临时使用特定版本的Helm。
- **多环境隔离**：通过挂载不同Kubernetes配置文件，快速切换集群环境。


## 使用方法与配置说明

### 基本使用（默认最新版本）

通过`docker run`命令运行容器，挂载必要的数据卷以持久化配置和缓存：

```bash
docker run -ti --rm -v $(pwd):/apps -w /apps \
  -v ~/.kube:/root/.kube \
  -v ~/.helm:/root/.helm \
  -v ~/.config/helm:/root/.config/helm \
  -v ~/.cache/helm:/root/.cache/helm \
  docker.xuanyuan.run/alpine/helm
```

**数据卷说明**：
- `-v $(pwd):/apps -w /apps`：挂载当前工作目录至容器内`/apps`，并设置为工作目录。
- `-v ~/.kube:/root/.kube`：挂载本地Kubernetes配置（如`config`文件），使Helm能访问集群。
- `-v ~/.helm:/root/.helm`、`-v ~/.config/helm:/root/.config/helm`、`-v ~/.cache/helm:/root/.cache/helm`：挂载Helm的配置、状态和缓存目录，确保数据持久化。


### 指定版本运行

生产环境中应避免使用`latest`标签，需指定具体版本号（标签对应Helm版本）：

```bash
docker run -ti --rm -v $(pwd):/apps -w /apps \
  -v ~/.kube:/root/.kube \
  -v ~/.helm:/root/.helm \
  -v ~/.config/helm:/root/.config/helm \
  -v ~/.cache/helm:/root/.cache/helm \
  docker.xuanyuan.run/alpine/helm:3.11.1 # 示例版本，需替换为实际需求版本
```


### 设置命令别名（简化本地使用）

通过`alias`将容器化Helm映射为本地命令，简化日常使用：

```bash
alias helm='docker run -ti --rm -v $(pwd):/apps -w /apps \
  -v ~/.kube:/root/.kube \
  -v ~/.helm:/root/.helm \
  -v ~/.config/helm:/root/.config/helm \
  -v ~/.cache/helm:/root/.cache/helm \
  alpine/helm'

# 验证别名
helm --help
```


### 环境变量配置

通过`-e`参数传递环境变量，例如指定多个Kubernetes配置文件：

```bash
alias helm='docker run -e KUBECONFIG="/root/.kube/config:/root/.kube/some-other-context.yaml" -ti --rm -v $(pwd):/apps -w /apps \
  -v ~/.kube:/root/.kube \
  -v ~/.helm:/root/.helm \
  -v ~/.config/helm:/root/.config/helm \
  -v ~/.cache/helm:/root/.cache/helm \
  alpine/helm'
```

**环境变量说明**：
- `KUBECONFIG`：指定容器内Kubernetes配置文件路径，支持多个文件以冒号分隔（如示例中同时加载默认配置和其他集群配置）。


## 注意事项

1. **版本标签使用**：`latest`标签对应Helm最新发布版本，但生产环境必须使用具体版本标签（如`3.11.1`），避免版本变更导致意外。
2. **多架构支持范围**：
   - 3.5.4及3.6.0-rc.1版本手动支持多架构；
   - 3.6.0及后续新版本默认支持多架构（`linux/amd64, linux/arm/v7, linux/arm64/v8, linux/arm/v6, linux/ppc64le, linux/s390x`）；
   - 3.5.4之前的旧版本不支持多架构。
3. **与kubectl配合使用**：若需同时运行`helm`和`kubectl`，建议使用专用镜像`alpine/k8s`（而非本镜像）。
4. **构建流水线变更**：2024年10月14日起，自动化构建流水线已从Circle CI迁移至GitHub Action。


## 镜像构建流程

1. 配置GitHub Action定时任务，定期检查Helm官方GitHub仓库的新版本标签。
2. 通过GitHub REST API获取Helm最新发布信息，通过Docker Hub REST API查询现有镜像标签。
3. 若检测到未构建的新版本，自动构建对应版本镜像并推送至Docker Hub。


## 相关链接

- **Docker Hub镜像地址**：[https://hub.docker.com/r/alpine/helm](https://hub.docker.com/r/alpine/helm)
- **GitHub代码仓库**：[https://github.com/alpine-docker/helm](https://github.com/alpine-docker/helm)
- **CI构建日志**：[https://github.com/alpine-docker/helm/actions](https://github.com/alpine-docker/helm/actions)
- **镜像标签列表**：[https://hub.docker.com/r/alpine/helm/tags](https://hub.docker.com/r/alpine/helm/tags)
