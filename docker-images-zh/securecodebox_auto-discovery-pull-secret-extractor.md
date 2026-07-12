---
image: securecodebox/auto-discovery-pull-secret-extractor
description: "auto-discovery-secret-extraction容器作为initContainer，用于帮助Trivy等扫描工具访问私有Docker仓库镜像，通过自动发现并创建带ownerReference的临时密钥实现认证，扫描完成后临时密钥自动删除。"
source: https://xuanyuan.cloud/zh/r/securecodebox/auto-discovery-pull-secret-extractor
canonical: https://xuanyuan.cloud/zh/r/securecodebox/auto-discovery-pull-secret-extractor
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/securecodebox/auto-discovery-pull-secret-extractor" title="securecodebox/auto-discovery-pull-secret-extractor Docker 镜像中文简介、标签列表与拉取命令">securecodebox/auto-discovery-pull-secret-extractor 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# auto-discovery-secret-extraction 镜像文档

## 镜像概述和主要用途

auto-discovery-secret-extraction 是一个专为 Kubernetes 环境设计的 initContainer 镜像，旨在解决容器扫描工具（如 Trivy）访问私有 Docker 仓库镜像时的认证问题。它通过自动发现挂载的密钥、识别目标镜像所属私有仓库的凭证，并创建与 Pod 生命周期绑定的临时密钥，为扫描工具提供安全的认证支持。临时密钥通过 `ownerReference` 与 Pod 关联，确保扫描任务完成后自动清理，避免凭证长期留存风险。

## 核心功能和特性

- **initContainer 角色**：作为 Pod 初始化阶段的前置容器运行，为后续扫描工具提供认证凭证支持。
- **参数化配置**：接收镜像 ID（用于定位目标仓库）和临时密钥名称作为命令行参数。
- **密钥自动发现**：扫描 `/secrets` 目录下挂载的密钥，自动识别与目标镜像仓库域匹配的认证凭证。
- **临时密钥管理**：创建包含仓库认证凭证的临时密钥，并添加 `ownerReference` 指向所在 Pod，实现与 Pod 生命周期绑定的自动删除。
- **安全凭证隔离**：临时密钥仅在扫描期间存在，避免长期密钥暴露，提升认证安全性。

## 使用场景和适用范围

适用于 Kubernetes 集群中使用容器扫描工具（如 Trivy）对私有 Docker 仓库镜像进行安全扫描的场景。尤其适合需要动态管理认证凭证、避免长期密钥留存的自动化扫描流程，确保私有仓库镜像扫描的安全性和便捷性。

## 详细使用方法和配置说明

### 本地测试环境搭建

以下步骤介绍如何在本地搭建测试环境，验证 auto-discovery-secret-extraction 容器的功能：

#### 创建带认证的本地 Docker 仓库

1. **生成基本认证密钥**

   ```bash
   mkdir auth
   docker run \
     --entrypoint htpasswd \
     docker.xuanyuan.run/httpd:2 -Bbn testuser testpassword > auth/htpasswd
   ```

2. **启动本地仓库容器**（命令改编自 [Docker 文档](https://docs.docker.com/registry/deploying/)）

   ```bash
   docker run -d \
     -p "127.0.0.1:5000:5000" \
     --name registry \
     --restart=always \
     -v "$(pwd)"/auth:/auth \
     -e "REGISTRY_AUTH=htpasswd" \
     -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
     -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
     docker.xuanyuan.run/registry:2
   ```

3. **登录本地仓库**

   ```bash
   docker login localhost:5000 -u testuser -p testpassword
   ```

#### 配置 Kind 集群与本地仓库

1. **创建包含本地仓库配置的 Kind 集群**（命令改编自 [Kind 文档](https://kind.sigs.k8s.io/docs/user/local-registry/)）

   ```bash
   cat <<EOF | kind create cluster --config=-
   kind: Cluster
   apiVersion: kind.x-k8s.io/v1alpha4
   nodes:
     - role: control-plane
   containerdConfigPatches:
   - |-
     [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:5000"]
       endpoint = ["http://registry:5000"]
     [plugins."io.containerd.grpc.v1.cri".registry.configs."registry:5000".tls]
       insecure_skip_verify = true

   EOF

   docker network connect "kind" "registry"

   cat <<EOF | kubectl apply -f -
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: local-registry-hosting
     namespace: kube-public
   data:
     localRegistryHosting.v1: |
       host: "localhost:5000"
       help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
   EOF
   ```

#### 推送镜像与创建测试 Pod

1. **推送测试镜像到本地仓库**

   ```bash
   docker pull docker.xuanyuan.run/ubuntu
   docker tag ubuntu localhost:5000/ubuntu
   docker push localhost:5000/ubuntu
   ```

2. **创建使用本地仓库镜像的测试 Pod**

   ```bash
   cat <<EOF | kubectl apply -f -
   apiVersion: v1
   kind: Secret
   metadata:
     name: regcred
     namespace: default
   data:
     .dockerconfigjson: ewoJImF1dGhzIjogewoJCSJsb2NhbGhvc3Q6NTAwMCI6IHsKCQkJImF1dGgiOiAiZEdWemRIVnpaWEk2ZEdWemRIQmhjM04zYjNKayIKCQl9Cgl9Cn0=
   type: kubernetes.io/dockerconfigjson
   ---

   apiVersion: v1
   kind: Pod 
   metadata:
     name: private-reg
     namespace: default
   spec:
     containers:
     - name: private-reg-container
       image: localhost:5000/ubuntu
       command: ["sleep"]
       args: ["999999"]
     imagePullSecrets:
     - name: regcred
   EOF
   ```

## 使用流程说明

### 容器运行机制

1. **参数输入**：通过命令行参数接收目标镜像 ID 和临时密钥名称。
2. **密钥扫描**：读取 `/secrets` 目录下挂载的密钥文件，分析密钥中包含的仓库认证信息。
3. **仓库匹配**：根据镜像 ID 解析目标私有仓库域名，从挂载密钥中匹配对应仓库的认证凭证。
4. **临时密钥创建**：生成指定名称的临时密钥，填入匹配的认证凭证，并添加 `ownerReference` 指向所在 Pod。
5. **扫描与清理**：扫描工具使用临时密钥访问私有仓库完成镜像扫描；Pod 扫描任务结束后，临时密钥随 Pod 生命周期自动删除。

### 关键配置要求

- **密钥挂载**：需将包含私有仓库认证凭证的密钥以 Volume 形式挂载至容器的 `/secrets` 目录。
- **命令行参数**：必须提供目标镜像 ID 和临时密钥名称作为启动参数，格式为 `[镜像ID] [临时密钥名称]`。
- **Kubernetes 环境**：需在 Kubernetes 集群中运行，依赖 `ownerReference` 机制实现临时密钥自动清理。
