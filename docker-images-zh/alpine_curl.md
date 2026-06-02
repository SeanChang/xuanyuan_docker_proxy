---
image: alpine/curl
description: "基于Alpine Linux的轻量级Docker镜像，集成了curl命令行工具，专为网络数据传输设计。支持HTTP、HTTPS、FTP等多种协议，可用于API测试、文件下载、服务监控等场景。得益于Alpine的精简特性，镜像体积小巧，启动快速，非常适合在容器化环境中执行临时网络请求或自动化任务，是开发调试、CI/CD流程及微服务健康检查的理想工具。"
source: https://xuanyuan.cloud/zh/r/alpine/curl
canonical: https://xuanyuan.cloud/zh/r/alpine/curl
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/curl" title="alpine/curl Docker 镜像中文简介、标签列表与拉取命令">alpine/curl 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# alpine/curl


## 概述  
基于 Alpine 系统的轻量 curl 镜像。  

原上游仓库（[] `alpine:3.7` 构建，距今已 4 年，存在安全漏洞。本仓库持续维护，使用最新 Alpine 版本构建，并通过 trivy 安全扫描，确保低风险。  


## 补充说明  
若需支持 **HTTP/3**，可使用另一个镜像 `alpine/curl-http3`（[]  


## 使用方法  

### 1. 通过 `docker run` 使用  
直接运行命令：  
```console
$ docker run --rm alpine/curl -fsSL []  

也可将其设为别名命令，简化使用：  
```bash
alias curl="docker run --rm alpine/curl"

# 使用别名调用
curl -fsSL []  


### 2. 通过 `kubectl run` 在 Kubernetes 中使用  
#### 基本用法  
每次执行需拉取镜像和创建 Pod，耗时约 5-10 秒：  
```bash
kubectl run curl --rm -it --image=alpine/curl -- -fsSL []  

#### 测试集群内服务  
若需访问 Kubernetes 集群内服务，例如服务名为 `productpage`，端口 9080：  
```bash
# 先查看服务信息
kubectl get service  
# 假设输出：productpage   ClusterIP   10.99.117.108    <none>        9080/TCP   123m  

# 访问服务
kubectl run curl --rm -it --image=alpine/curl -- -sS productpage.default:9080/index.html
```  


#### 特殊情况处理：禁用 Istio 自动注入  
若 Kubernetes 集群启用了 Istio 自动注入（或类似边车代理），可能因 sidecar 容器（如 istio-proxy）未就绪导致网络问题。此时需添加标签禁用注入：  
```bash
kubectl run curl --rm -it \
  --overrides='{ "apiVersion": "v1", "metadata": { "labels": { "sidecar.istio.io/inject": "false" } } }' \
  --image=alpine/curl -- -sS productpage.default:9080/productpage
```  


#### 设为别名命令  
```bash
alias kubecurl="kubectl run curl --rm -it --image=alpine/curl --"

# 使用别名调用
kubecurl -fsSL []  


## 标签说明  
镜像标签基于 curl 版本命名，例如：  
- `alpine/curl:8.1.2`：对应 curl 8.1.2 版本  


## 安全扫描  
镜像已通过 trivy 安全扫描，无已知漏洞。可通过以下命令验证：  
```console
$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy image alpine/curl

...
================================
Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```
