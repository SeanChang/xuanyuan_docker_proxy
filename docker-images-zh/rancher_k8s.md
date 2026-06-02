---
image: rancher/k8s
description: "Rancher Kubernetes镜像提供Kubernetes集群所需的基础组件与运行环境，用于Rancher管理的Kubernetes集群的部署、运维及管理，确保集群稳定运行。"
source: https://xuanyuan.cloud/zh/r/rancher/k8s
canonical: https://xuanyuan.cloud/zh/r/rancher/k8s
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rancher/k8s" title="rancher/k8s Docker 镜像中文简介、标签列表与拉取命令">rancher/k8s — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rancher/k8s" title="rancher/k8s Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rancher/k8s</a>

# Rancher Kubernetes Images 技术文档


## 1. 镜像概述和主要用途  
Rancher Kubernetes Images 是基于 [rancher/kubernetes-package](https://github.com/rancher/kubernetes-package) 构建的Docker镜像，专为Kubernetes集群的部署、管理和运维设计。该镜像集成了Rancher生态系统的核心组件，旨在简化Kubernetes环境的搭建流程，提供与Rancher管理平台的无缝兼容性，适用于企业级Kubernetes集群的标准化部署场景。


## 2. 核心功能和特性  
- **Rancher生态兼容性**：与Rancher管理平台深度集成，支持通过Rancher UI/API进行集群生命周期管理。  
- **预打包Kubernetes组件**：内置经过验证的Kubernetes核心组件（如kube-apiserver、kube-controller-manager等）及依赖工具，减少手动配置成本。  
- **版本化管理**：支持多版本Kubernetes部署，可通过参数指定目标K8s版本，满足不同环境需求。  
- **简化部署流程**：提供标准化部署脚本，支持一键式集群初始化，降低运维复杂度。  
- **安全合规**：遵循Rancher安全最佳实践，包含基础安全配置（如RBAC、TLS加密支持）。  


## 3. 使用场景和适用范围  
- **企业级Kubernetes集群部署**：适用于需要规模化、标准化管理Kubernetes集群的企业环境。  
- **Rancher管理的K8s环境**：作为Rancher Server的配套镜像，用于扩展或维护Rancher管理的Kubernetes集群。  
- **开发/测试环境快速搭建**：支持开发者在本地或测试环境中快速拉起Kubernetes集群，验证应用兼容性。  
- **边缘计算K8s部署**：适配边缘场景下的轻量级Kubernetes集群需求，与Rancher Edge功能协同。  


## 4. 使用方法和配置说明  

### 4.1 基础使用（`docker run` 命令）  
通过`docker run`直接启动镜像，需指定必要的环境变量和挂载卷（用于持久化配置/数据）：  

```bash
docker run -d \
  --name rancher-k8s \
  --privileged \
  -p 6443:6443 \  # Kubernetes API端口
  -p 8080:8080 \  # 管理端口（如适用）
  -e K8S_VERSION=v1.28.5 \  # 指定Kubernetes版本
  -e RANCHER_SERVER_URL=https://rancher.example.com \  # Rancher Server地址（如需关联）
  -v /var/lib/rancher/k8s:/var/lib/rancher/k8s \  # 持久化K8s配置数据
  -v /etc/kubernetes:/etc/kubernetes \  # 挂载K8s配置目录
  rancher/kubernetes-package
```  

> **说明**：`--privileged` 权限用于容器内操作宿主机资源（如网络、存储），生产环境需根据安全策略调整。


### 4.2 Docker Compose 配置示例  
通过`docker-compose.yml`定义服务，适合多容器协同场景（如与Rancher Agent联动）：  

```yaml
version: '3.8'
services:
  rancher-k8s:
    image: rancher/kubernetes-package
    container_name: rancher-k8s
    privileged: true
    ports:
      - "6443:6443"
      - "8080:8080"
    environment:
      - K8S_VERSION=v1.28.5
      - RANCHER_SERVER_URL=https://rancher.example.com
      - CLUSTER_NAME=my-k8s-cluster
      - CNI_PLUGIN=calico  # 指定CNI插件（如calico、flannel）
    volumes:
      - /var/lib/rancher/k8s:/var/lib/rancher/k8s
      - /etc/kubernetes:/etc/kubernetes
      - /var/run/docker.sock:/var/run/docker.sock  # 如需与宿主机Docker交互
    restart: unless-stopped
```  

启动命令：  
```bash
docker-compose up -d
```  


## 5. 配置参数和环境变量  
| 参数名                | 类型   | 描述                                                                 | 默认值          |
|-----------------------|--------|----------------------------------------------------------------------|-----------------|
| `K8S_VERSION`         | 字符串 | 指定部署的Kubernetes版本（需符合Rancher支持列表，如`v1.28.5`）       | `v1.27.8`       |
| `RANCHER_SERVER_URL`  | 字符串 | Rancher Server的访问地址（如关联Rancher管理，格式：`https://<IP>:<PORT>`） | 无              |
| `CLUSTER_NAME`        | 字符串 | 集群名称（用于标识和管理）                                           | `rancher-k8s-cluster` |
| `CNI_PLUGIN`          | 字符串 | 网络插件类型（支持`calico`、`flannel`、`canal`等）                   | `calico`        |
| `LOG_LEVEL`           | 字符串 | 日志级别（`debug`/`info`/`warn`/`error`）                           | `info`          |
| `DATA_DIR`            | 字符串 | 容器内数据持久化目录（建议通过挂载卷映射到宿主机）                   | `/var/lib/rancher/k8s` |


## 6. 注意事项  
- 镜像需运行在支持Kubernetes的Linux系统（如Ubuntu 20.04+、CentOS 7+），并确保宿主机已安装Docker或containerd。  
- 生产环境中，建议通过Rancher官方文档验证`K8S_VERSION`与Rancher Server版本的兼容性。  
- 敏感配置（如Rancher API密钥）建议通过环境变量注入或加密挂载，避免明文暴露。
