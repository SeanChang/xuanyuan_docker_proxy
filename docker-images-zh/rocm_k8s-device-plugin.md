---
image: rocm/k8s-device-plugin
description: "Kubernetes (k8s)设备插件，用于将AMD GPU注册到容器集群中，支持计算工作负载调度"
source: https://xuanyuan.cloud/zh/r/rocm/k8s-device-plugin
canonical: https://xuanyuan.cloud/zh/r/rocm/k8s-device-plugin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rocm/k8s-device-plugin" title="rocm/k8s-device-plugin Docker 镜像中文简介、标签列表与拉取命令">rocm/k8s-device-plugin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# AMD GPU Kubernetes设备插件

## 简介

这是一个[Kubernetes][k8s][设备插件][dp]实现，用于在容器集群中注册AMD GPU以支持计算工作负载。在适当的硬件和Kubernetes集群中部署此插件后，您将能够运行需要AMD GPU的作业。

此插件是[AMD GPU Operator](https://github.com/ROCm/gpu-operator)等工具将AMD GPU公开为可调度资源所必需的。

有关[ROCm][rocm]的更多信息。

## 先决条件

* [ROCm兼容机器][sysreq]
* [kubeadm兼容机器][kubeadm]（如果使用kubeadm部署k8s集群）
* [ROCm内核][rock]（[安装指南][rocminstall]）或最新的AMD GPU Linux驱动程序（[安装指南][amdgpuinstall]）
* [Kubernetes部署][k8sinstall]
* 如果启用设备健康检查，pod必须允许以特权模式运行（例如kube-apiserver的`--allow-privileged=true`标志），以便访问`/dev/kfd`

## 限制

* 此插件面向Kubernetes v1.18+。

## 部署

设备插件需要在所有配备AMD GPU的节点上运行。最简单的方法是创建Kubernetes[DaemonSet][ds]，它在集群中的所有（或某些）节点上运行pod副本。我们在[DockerHub][dhk8samdgpudp]上提供了预构建的Docker镜像，可用于DaemonSet。此仓库还包含名为`k8s-ds-amdgpu-dp.yaml`的预定义yaml文件。您可以通过运行以下命令在Kubernetes集群中创建DaemonSet：

```bash
kubectl create -f k8s-ds-amdgpu-dp.yaml
```

或直接从网络拉取：

```bash
kubectl create -f https://raw.githubusercontent.com/ROCm/k8s-device-plugin/master/k8s-ds-amdgpu-dp.yaml
```

如果要启用实验性设备健康检查，请在为kube-apiserver设置`--allow-privileged=true`**之后**使用`k8s-ds-amdgpu-dp-health.yaml`。

### Helm Chart

如果要使用Helm部署此设备插件，[Artifact Hub][artifacthub]上提供了[Helm Chart][helmamdgpu]。

## 示例工作负载

您可以通过向pod定义添加`resources.limits`来将工作负载限制在具有GPU的节点上。`example/pod/alexnet-gpu.yaml`中提供了示例pod定义。此pod在AMD GPU上运行AlexNet的计时基准测试，然后进入睡眠状态。您可以通过运行以下命令创建pod：

```bash
kubectl create -f alexnet-gpu.yaml
```

或

```bash
kubectl create -f https://raw.githubusercontent.com/ROCm/k8s-device-plugin/master/example/pod/alexnet-gpu.yaml
```

然后通过运行以下命令检查pod状态：

```bash
kubectl describe pods
```

创建并运行pod后，可以通过运行以下命令查看基准测试结果：

```bash
kubectl logs alexnet-tf-gpu-pod alexnet-tf-gpu-container
```

作为比较，`example/pod/alexnet-cpu.yaml`中提供了使用CPU运行相同基准测试的示例pod定义。

## 使用额外GPU属性标记节点

详情请参见[AMD GPU Kubernetes Node Labeller](cmd/k8s-node-labeller/README.md)。示例配置在[k8s-ds-amdgpu-labeller.yaml](k8s-ds-amdgpu-labeller.yaml)中：

```bash
kubectl create -f k8s-ds-amdgpu-labeller.yaml
```

或

```bash
kubectl create -f https://raw.githubusercontent.com/ROCm/k8s-device-plugin/master/k8s-ds-amdgpu-labeller.yaml
```

# 每个GPU的健康状况

* 使用安装在`/var/lib/amd-metrics-exporter/`上的grpc套接字服务的导出器健康服务，扩展每个GPU的更精细健康检测。

## 注意事项

* 此插件使用[`go modules`][gm]进行依赖管理
* 有关如何独立于docker镜像构建和使用此插件，请参考`Dockerfile`

## 待办事项

* ~~添加适当的GPU健康检查（无需访问`/dev/kfd`的健康检查。）~~

[artifacthub]: https://artifacthub.io/packages/helm/amd-gpu-helm/amd-gpu
[ds]: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
[dp]: https://kubernetes.io/docs/concepts/cluster-administration/device-plugins/
[helmamdgpu]: https://artifacthub.io/packages/helm/amd-gpu-helm/amd-gpu
[rocm]: https://rocm.docs.amd.com/en/latest/what-is-rocm.html
[rock]: https://github.com/ROCm/ROCK-Kernel-Driver
[rocminstall]: https://rocm.docs.amd.com/projects/install-on-linux/en/latest/tutorial/quick-start.html
[amdgpuinstall]: https://amdgpu-install.readthedocs.io/en/latest/
[sysreq]: https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html
[gm]: https://blog.golang.org/using-go-modules
[kubeadm]: https://kubernetes.io/docs/setup/independent/install-kubeadm/#before-you-begin
[k8sinstall]: https://kubernetes.io/docs/setup/independent/install-kubeadm
[k8s]: https://kubernetes.io
[dhk8samdgpudp]: https://hub.docker.com/r/rocm/k8s-device-plugin/
