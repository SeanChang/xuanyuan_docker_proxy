---
image: dyrnq/coredns
description: "CoreDNS镜像从k8s.gcr.io/coredns/coredns:v*同步，用于解决Kubernetes部署中kubeadm拉取CoreDNS镜像失败问题，提供正确的镜像仓库配置支持。"
source: https://xuanyuan.cloud/zh/r/dyrnq/coredns
canonical: https://xuanyuan.cloud/zh/r/dyrnq/coredns
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dyrnq/coredns" title="dyrnq/coredns Docker 镜像中文简介、标签列表与拉取命令">dyrnq/coredns 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CoreDNS 镜像文档

## 镜像概述和主要用途
本镜像为从k8s.gcr.io/coredns/coredns:v*同步的CoreDNS官方镜像，主要用于解决Kubernetes集群部署过程中，因国内网络环境无法直接拉取k8s.gcr.io仓库镜像导致的CoreDNS镜像拉取失败问题。通过指定正确的镜像仓库配置，可确保kubeadm初始化集群时顺利获取CoreDNS组件镜像。

## 核心功能和特性
- **官方同步**：与k8s.gcr.io/coredns/coredns:v*保持版本同步，确保镜像与Kubernetes官方版本兼容
- **部署支持**：解决国内环境下Kubernetes集群部署时CoreDNS镜像拉取失败问题
- **配置灵活**：支持通过kubeadm配置文件自定义CoreDNS镜像仓库地址，适配不同网络环境

## 使用场景和适用范围
适用于使用kubeadm工具部署Kubernetes集群的场景，特别是在执行`kubeadm config images pull`或`kubeadm init`时遇到以下错误的情况：
```
failed to pull image "registry.aliyuncs.com/google_containers/coredns:v1.8.4": output: Error response from daemon: manifest for registry.aliyuncs.com/google_containers/coredns:v1.8.4 not found: manifest unknown: manifest unknown
```

## 使用方法和配置说明

### 问题现象
当使用默认镜像仓库（如registry.aliyuncs.com/google_containers）部署Kubernetes时，可能出现CoreDNS镜像拉取失败，错误信息如下：
```bash
kubeadm config images pull --image-repository registry.aliyuncs.com/google_containers
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.0
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-controller-manager:v1.22.0
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-scheduler:v1.22.0
[config/images] Pulled registry.aliyuncs.com/google_containers/kube-proxy:v1.22.0
[config/images] Pulled registry.aliyuncs.com/google_containers/pause:3.5
[config/images] Pulled registry.aliyuncs.com/google_containers/etcd:3.5.0-0
failed to pull image "registry.aliyuncs.com/google_containers/coredns:v1.8.4": output: Error response from daemon: manifest for registry.aliyuncs.com/google_containers/coredns:v1.8.4 not found: manifest unknown: manifest unknown
, error: exit status 1
```

### 配置方法
通过修改kubeadm配置文件，指定CoreDNS镜像仓库地址，步骤如下：

1. 创建或编辑kubeadm配置文件（kubeadm-config.yaml）：
```yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
bootstrapTokens:
- token: abcdef.0123456789abcdef
  ttl: 0h
localAPIEndpoint:
  advertiseAddress: 192.168.88.11  # 替换为实际节点IP
  bindPort: 6443
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: v1.22.0  # 替换为目标Kubernetes版本
imageRepository: registry.aliyuncs.com/google_containers  # 其他组件镜像仓库
networking:
  podSubnet: 10.244.0.0/16  # 替换为实际Pod子网
dns:
  imageRepository: docker.io/dyrnq  # 指定CoreDNS镜像仓库
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
```

2. 验证配置是否生效
执行以下命令检查镜像列表，确认CoreDNS镜像地址已更新：
```bash
kubeadm config --config=kubeadm-config.yaml images list
```
预期输出应包含正确的CoreDNS镜像地址：
```
registry.aliyuncs.com/google_containers/kube-apiserver:v1.22.0
registry.aliyuncs.com/google_containers/kube-controller-manager:v1.22.0
registry.aliyuncs.com/google_containers/kube-scheduler:v1.22.0
registry.aliyuncs.com/google_containers/kube-proxy:v1.22.0
registry.aliyuncs.com/google_containers/pause:3.5
registry.aliyuncs.com/google_containers/etcd:3.5.0-0
docker.io/dyrnq/coredns:v1.8.4  # CoreDNS镜像已指向正确仓库
```

3. 初始化Kubernetes集群
使用修改后的配置文件初始化集群，确保CoreDNS镜像成功拉取：
```bash
kubeadm init --config=kubeadm-config.yaml
```

## 常见问题解决
- **镜像版本不匹配**：确保CoreDNS版本与Kubernetes版本对应（如Kubernetes v1.22.0对应CoreDNS v1.8.4）
- **仓库地址错误**：检查`dns.imageRepository`配置是否正确，确保目标仓库存在对应版本镜像
- **拉取超时**：若仓库访问缓慢，可尝试更换国内镜像仓库（如docker.io/dyrnq等）
