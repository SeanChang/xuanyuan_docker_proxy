---
image: alpine/k8s
description: "用于EKS的Kubernetes工具箱，包含kubectl、helm、iam-authenticator、eksctl等工具，支持EKS环境下的Kubernetes集群管理与操作。"
source: https://xuanyuan.cloud/zh/r/alpine/k8s
canonical: https://xuanyuan.cloud/zh/r/alpine/k8s
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/k8s" title="alpine/k8s Docker 镜像中文简介、标签列表与拉取命令">alpine/k8s — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/alpine/k8s" title="alpine/k8s Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/alpine/k8s</a>

# 多合一Kubernetes工具镜像

## 镜像概述与主要用途

本镜像为一站式Kubernetes工具集，集成了kubectl、helm、aws-iam-authenticator、eksctl等多种常用工具，旨在简化Kubernetes集群（尤其AWS EKS）的管理与操作流程。通过将各类工具打包为单一镜像，避免了在环境中手动安装和配置多个工具的繁琐步骤，适用于需要快速部署Kubernetes工具链的场景。


## 核心功能与特性

### 支持平台
- 架构：`linux/amd64`、`linux/arm64`（2023年2月15日更新，PR #54）


### 已安装工具

#### 主要Kubernetes工具
- **kubectl**：Kubernetes命令行工具，版本对应Kubernetes最新次要版本（参考[Kubernetes版本发布页](https://kubernetes.io/releases/)）
- **kustomize**：Kubernetes配置管理工具，使用最新发布版本（参考[kustomize发布页](https://github.com/kubernetes-sigs/kustomize/releases/latest)）
- **helm**：Helm包管理器，使用最新发布版本（参考[Helm发布页](https://github.com/helm/helm/releases/latest)）
- **helm插件**：
  - helm-diff（最新提交版本）
  - helm-unittest（最新提交版本）
  - helm-push（最新提交版本）
- **aws-iam-authenticator**：AWS EKS身份认证工具，构建时获取最新版本
- **eksctl**：EKS集群管理工具，构建时获取最新版本
- **awscli v1**：AWS命令行工具v1，构建时获取最新版本
- **kubeseal**：Sealed Secrets工具，构建时获取最新版本


#### 通用工具
- 基础工具：bash、curl、wget
- 数据处理工具：jq（JSON处理）、yq（YAML处理）


### 自动化构建
- 每周通过Circle CI流水线自动构建（[构建日志](https://app.circleci.com/pipelines/github/alpine-docker/k8s)），确保工具版本持续更新


## 使用场景与适用范围

### 主要场景
1. **CI/CD流程集成**：作为持续集成/持续部署流水线的基础镜像，执行kubectl部署、helm chart测试、EKS集群配置等操作
2. **自动化部署**：嵌入自动化脚本，实现Kubernetes资源的批量管理与部署
3. **EKS集群管理**：集成eksctl、aws-iam-authenticator等工具，简化AWS EKS集群的创建、更新与维护
4. **本地开发测试**：在本地环境快速启动包含完整工具链的容器，避免本地环境配置冲突


## 详细使用方法与配置说明

### 前提条件
- 已安装Docker引擎（版本20.10+推荐）
- 如需操作Kubernetes集群，需准备kubeconfig文件（通常位于`~/.kube/config`）


### 基本使用（docker run）

#### 查看工具版本
```bash
# 查看kubectl版本
docker run --rm alpine/k8s:v1.28.0 kubectl version --client

# 查看helm版本
docker run --rm alpine/k8s:v1.28.0 helm version
```


#### 挂载kubeconfig操作集群
将本地kubeconfig文件挂载到容器中，执行集群操作：
```bash
docker run --rm -v ~/.kube/config:/root/.kube/config alpine/k8s:v1.28.0 kubectl get nodes
```


#### 交互式使用
启动bash终端，交互式执行命令：
```bash
docker run -it --rm -v ~/.kube/config:/root/.kube/config alpine/k8s:v1.28.0 bash
```


### CI/CD集成示例（GitHub Actions）
在GitHub Actions工作流中使用本镜像执行部署操作：
```yaml
name: Deploy to EKS
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Deploy with kubectl
        uses: docker://alpine/k8s:v1.28.0
        with:
          args: kubectl apply -f k8s/deployment.yaml
        env:
          KUBECONFIG: ${{ secrets.KUBECONFIG_CONTENT }}  # 从secrets传入kubeconfig内容
```


### 构建自定义镜像（如需修改工具版本）
若需自行构建镜像（例如固定特定工具版本），可参考以下步骤：
```bash
# 克隆源码仓库
git clone https://github.com/alpine-docker/k8s.git
cd k8s

# 启用本地构建（不推送镜像）
export REBUILD=true
# 注释build.sh中的"docker push ${image}:${tag}"行以禁用推送
bash ./build.sh
```


## 镜像标签说明

### 标签命名规则
- 镜像标签对应kubectl的版本，遵循Kubernetes版本规范（如`v1.28.0`、`v1.27.5`）
- 标签与Kubernetes官方最新次要版本同步（参考[Kubernetes版本发布页](https://kubernetes.io/releases/)）


### 标签选择建议
- 根据目标Kubernetes集群版本选择对应标签（例如集群版本1.28.x，选择`v1.28.0`）
- 不建议使用`latest`标签（本镜像无`latest`标签，避免版本不可控）
- 所有可用标签可在[Docker Hub标签页](https://hub.docker.com/r/alpine/k8s/tags/)查看


## 注意事项

1. **AWS EKS版本支持**：AWS EKS对Kubernetes版本有特殊维护策略（参考[EKS版本文档](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)），EKS用户需选择与集群版本匹配的镜像标签
2. **无latest标签**：本镜像不提供`latest`标签，需显式指定版本标签（如`v1.28.0`）
3. **工具扩展需求**：如需添加其他工具，可通过GitHub仓库[Issues](https://github.com/alpine-docker/k8s/issues)提交需求
4. **平台支持**：仅支持`linux/amd64`和`linux/arm64`架构，其他架构（如armv7）暂不支持


## 相关资源
- **GitHub仓库**：https://github.com/alpine-docker/k8s
- **Docker Hub镜像**：https://hub.docker.com/r/alpine/k8s
- **构建日志**：https://app.circleci.com/pipelines/github/alpine-docker/k8s
