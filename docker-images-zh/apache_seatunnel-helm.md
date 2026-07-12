---
image: apache/seatunnel-helm
description: "通过Helm在Kubernetes环境中快速部署和管理Apache SeaTunnel的指南"
source: https://xuanyuan.cloud/zh/r/apache/seatunnel-helm
canonical: https://xuanyuan.cloud/zh/r/apache/seatunnel-helm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/seatunnel-helm" title="apache/seatunnel-helm Docker 镜像中文简介、标签列表与拉取命令">apache/seatunnel-helm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 使用Helm部署Apache SeaTunnel

## 概述
本文档提供使用Helm在Kubernetes环境中部署Apache SeaTunnel的快速指南，包括前置条件、安装步骤、作业提交方法及相关配置说明。

## 前置条件
部署前需确保本地环境已安装以下软件：
- [docker](https://docs.docker.com/)
- [kubernetes](https://kubernetes.io/)
- [helm](https://helm.sh/docs/intro/quickstart/)

同时确保`kubectl`和`helm`命令可在本地系统正常执行。

以minikube为例，可通过以下命令启动Kubernetes集群：
```bash
minikube start --kubernetes-version=v1.23.3
```

## 安装步骤

### 默认配置安装
```bash
# 自行选择对应版本
export VERSION=2.3.9
helm pull oci://registry-1.docker.io/apache/seatunnel-helm --version ${VERSION}
tar -xvf seatunnel-helm-${VERSION}.tgz
cd seatunnel-helm
helm install seatunnel .
```

### 指定命名空间安装
```bash
helm install seatunnel . -n <your namespace>
```

## 作业提交

### 通过端口转发访问REST API
默认配置未启用ingress，需通过端口转发访问master节点的REST API：
```bash
kubectl port-forward -n default svc/seatunnel-master 5801:5801
```
转发后可通过`http://127.0.0.1:5801/`访问REST API。

### 启用Ingress配置
若需通过域名访问，修改`value.yaml`文件：
```commandline
ingress:
  enabled: true
  host: "<your domain>"
```
更新配置后执行升级部署，即可通过`http://<your domain>`访问REST API。

### 通过Master Pod访问
也可直接进入master pod内部使用curl命令：
```commandline
# 获取master pod名称
MASTER_POD=$(kubectl get po -l  'app.kubernetes.io/name=seatunnel-master' | sed '1d' | awk '{print $1}' | head -n1)
# 进入pod容器
kubectl -n default exec -it $MASTER_POD -- /bin/bash

# 访问内部REST API
curl http://127.0.0.1:5801/running-jobs
curl http://127.0.0.1:5801/system-monitoring-information
```

### 提交作业
完成上述配置后，可通过[rest-api-v2](https://seatunnel.apache.org/docs/seatunnel-engine/rest-api-v2)提交作业。

## 更多信息
- 查看SeaTunnel支持的所有数据源和数据目的地，请参阅[连接器文档](https://seatunnel.apache.org/docs/connector-v2/source/)
- 了解其他引擎集群部署方式，请参阅[部署文档](https://seatunnel.apache.org/docs/seatunnel-engine/deployment)
