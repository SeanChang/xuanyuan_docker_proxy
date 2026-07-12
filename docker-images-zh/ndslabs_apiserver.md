---
image: ndslabs/apiserver
description: "NDS Labs API Server是用于开发环境的Labs Workbench API服务器，支持通过Minikube和Etcd配置，提供API服务运行、集成测试及外部服务部署功能。"
source: https://xuanyuan.cloud/zh/r/ndslabs/apiserver
canonical: https://xuanyuan.cloud/zh/r/ndslabs/apiserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ndslabs/apiserver" title="ndslabs/apiserver Docker 镜像中文简介、标签列表与拉取命令">ndslabs/apiserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NDS Labs API Server

本文档描述如何为开发环境运行Labs Workbench API服务器。


## 安装和配置Minikube

根据你的操作系统，按照[官方文档](https://kubernetes.io/docs/tasks/tools/install-minikube/)安装并启动Minikube。

启动Minikube实例：
```
minikube start
```

Workbench依赖带标签的节点。为节点添加标签：

```
kubectl label nodes minikube  ndslabs-role-compute=true
```

## 安装和配置Etcd

Workbench需要`etcd`。出于开发目的，你可以通过Docker在本地安装：

```
docker run --rm -p 4001:4001 -d docker.xuanyuan.run/ndslabs/etcd:2.2.5 /usr/local/bin/etcd \
         --bind-addr=0.0.0.0:4001 \
         --advertise-client-urls=http://127.0.0.1:4001 
```

## 设置Go环境

安装Go用于开发（假设为Mac OS）

```
brew install go --cross-compile-common
```

设置路径：
```
mkdir $HOME/go
```

编辑`$HOME/.bash_profile`：
```
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

使配置生效：
```
. $HOME/.bash_profile
```


## 克隆并构建API服务器

克隆仓库：
```
mkdir -p $GOPATH/src/github.com/
cd $GOPATH/src/github.com/
git clone https://github.com/nds-org/ndslabs 
cd ndslabs/apiserver
```	

构建本地二进制文件：
```
./build.sh local
```

## 配置API服务器

在你的机器上任意位置克隆`ndslabs-specs`仓库：
```
git clone https://github.com/nds-org/ndslabs-specs
```

修改`apiserver.json`以反映本地配置。至少需设置`support.email`为你的邮箱地址，`kubernetes.address`为`https://minikube-ip:8443`，`specs.path`为上述克隆仓库的位置。


## 运行API服务器

假设`minikube`和`etcd`已运行，你可以直接运行apiserver二进制文件：

```
./build/bin/apiserver-darwin-amd64
```

## 运行集成测试

安装`newman`（可能需要`sudo`）：
```
npm install -g newman
```

要配置postman环境，编辑`postman/workbench.postman_environment.json`，将`host`值设置为`localhost:30001`，`email`值设置为你的邮箱地址。

由于API服务器运行在非安全模式，你需要编辑`postman/Workbench.postman_collection_local.json`，将所有`https`替换为`http`。

运行测试：
```
cd postman
newman run --insecure  --environment=workbench.postman_environment.json --delay-request=1000 Workbench.postman_collection_local.json
```

## 作为外部服务运行

也可以在集群外运行Workbench API服务器。已在MacOS上通过VirtualBox的minikube测试过此方式。

创建文件`external-apiserver.yaml`，内容如下。注意10.0.2.2是minikube VM的内部地址，可通过`minikube ssh`和`netstat -rn`确认：
```yaml
kind: "Service"
apiVersion: "v1"
metadata:
  name: "ndslabs-apiserver"
spec:
  ports:
    - protocol: "TCP"
      port: 30001
      targetPort: 30001
---
kind: "Endpoints"
apiVersion: "v1"
metadata:
  name: "ndslabs-apiserver"
subsets:
  - addresses:
    - ip: "10.0.2.2"
    ports:
    - port: 30001
```

删除集群内的API服务器并创建此外部服务/端点：
```
kubectl delete svc ndslabs-apiserver
kubectl create -f external-apiserver.yaml
