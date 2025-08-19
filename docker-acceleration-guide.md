# 各大镜像仓库使用轩辕镜像加速教程

本教程将详细介绍如何使用<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>加速Dockerhub、ghcr、gcr、quay、nvcr、k8s、mcr、elastic、oracle等各大主流镜像仓库，提升镜像拉取速度和稳定性。

## 📚 目录

- [📌 前置说明](#-前置说明)
- [1. Docker Hub（docker.io）](#1-docker-hubdockerio)
- [2. GitHub Container Registry（ghcr.io）](#2-github-container-registryghcrio)
- [3. Google Container Registry（gcr.io）](#3-google-container-registrygcro)
- [4. Quay.io](#4-quayio)
- [5. NVIDIA Container Registry（nvcr.io）](#5-nvidia-container-registrynvcro)
- [6. Kubernetes Registry（registry.k8s.io）](#6-kubernetes-registryregistryk8sio)
- [7. Microsoft Container Registry（mcr.microsoft.io）](#7-microsoft-container-registrymcrmicrosoftio)
- [8. Elastic Registry（docker.elastic.co）](#8-elastic-registrydockerelasticco)
- [9. Oracle Container Registry（container-registry.oracle.com）](#9-oracle-container-registrycontainer-registryoraclecom)
- [✅ 常见用法建议](#-常见用法建议)
- [🚫 避免的问题](#-避免的问题)

## 📌 前置说明

本教程默认您的专属加速域名为 `xxx.xuanyuan.run`（请替换为您在个人中心获取的真实地址）

如果您还没有专属加速域名，请先前往 <a href="https://xuanyuan.cloud/" target="_blank">个人中心</a> 获取您的专属加速地址。

## 1. Docker Hub（docker.io）

最常用的官方镜像仓库，包含大量开源项目的官方镜像。

**官方源：**
```bash
docker pull docker.io/library/nginx:latest
```

**轩辕加速地址：**
```bash
docker pull xxx.xuanyuan.run/library/nginx:latest
```

> **注意**：部分镜像无需 `library/` 也可用（取决于原始镜像名）

## 2. GitHub Container Registry（ghcr.io）

GitHub 提供的容器镜像仓库，支持公开和私有镜像。

**官方源：**
```bash
docker pull ghcr.io/org/image:tag
```

**轩辕加速地址：**
```bash
docker pull xxx-ghcr.xuanyuan.run/org/image:tag
```

## 3. Google Container Registry（gcr.io）

Google 提供的容器镜像仓库，包含 Kubernetes 官方镜像等。

**官方源：**
```bash
docker pull gcr.io/google-containers/pause:3.9
```

**轩辕加速地址：**
```bash
docker pull xxx-gcr.xuanyuan.run/google-containers/pause:3.9
```

## 4. Quay.io

Red Hat 提供的容器镜像仓库，包含大量开源项目镜像。

**官方源：**
```bash
docker pull quay.io/coreos/etcd:latest
```

**轩辕加速地址：**
```bash
docker pull xxx-quay.xuanyuan.run/coreos/etcd:latest
```

## 5. NVIDIA Container Registry（nvcr.io）

NVIDIA 提供的容器镜像仓库，包含深度学习框架和 GPU 相关镜像。

**官方源（需要登录认证）：**
```bash
docker pull nvcr.io/nvidia/pytorch:23.05-py3
```

**轩辕加速地址（需登录或使用内部授权）：**
```bash
docker pull xxx-nvcr.xuanyuan.run/nvidia/pytorch:23.05-py3
```

> **注意**：私有镜像仍需登录，详见官网获取 API Key 或使用企业授权

## 6. Kubernetes Registry（registry.k8s.io）

Kubernetes 官方镜像仓库，包含 K8s 组件和工具镜像。

**官方源：**
```bash
docker pull registry.k8s.io/kube-apiserver:v1.30.1
```

**轩辕加速地址：**
```bash
docker pull xxx-k8s.xuanyuan.run/kube-apiserver:v1.30.1
```

## 7. Microsoft Container Registry（mcr.microsoft.io）

Microsoft 提供的容器镜像仓库，包含 .NET、Azure 等官方镜像。

**官方源：**
```bash
docker pull mcr.microsoft.com/dotnet/runtime:8.0
```

**轩辕加速地址：**
```bash
docker pull xxx-mcr.xuanyuan.run/dotnet/runtime:8.0
```

## 8. Elastic Registry（docker.elastic.co）

Elastic 官方镜像仓库，包含 Elasticsearch、Kibana、Logstash 等镜像。

**官方源：**
```bash
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.13.4
```

**轩辕加速地址：**
```bash
docker pull xxx-elastic.xuanyuan.run/elasticsearch/elasticsearch:8.13.4
```

## 9. Oracle Container Registry（container-registry.oracle.com）

Oracle 官方镜像仓库，包含 Oracle 数据库、Java 等企业级镜像。

**官方源：**
```bash
docker pull container-registry.oracle.com/database/enterprise:21.3.0
```

**轩辕加速地址：**
```bash
docker pull xxx-oracle.xuanyuan.run/database/enterprise:21.3.0
```

> **注意**：Oracle 镜像需先登录授权，详见 Oracle 官网说明。

## ✅ 常见用法建议

以下是一些常见的使用场景和建议：

| 用法 | 示例 |
|------|------|
| 设置镜像加速器 | 配置 daemon.json 中的 "registry-mirrors" 为 `https://xxx.xuanyuan.run` |
| 用于 CI/CD 构建 | 在 Dockerfile 或 CI 脚本中修改镜像源前缀 |
| 脚本预拉取 | `docker pull xxx-ghcr.xuanyuan.run/org/image:tag` |
| 替换已有镜像 | `docker tag xxx-ghcr.xuanyuan.run/org/image image` |

## 🚫 避免的问题

使用镜像加速时需要注意以下问题：

- **不要用完整官方域名**：避免使用 `docker.io/` 等完整域名，优先使用加速地址。
- **各大仓库的私有镜像仍需登录**： 轩辕镜像加速不改变权限控制，支持公开镜像加速，各大仓库的私有镜像仍需登录认证。
- **避免误用缓存过期镜像**：建议定期更新加速源或配置 webhook 拉取策略。
- **注意镜像标签一致性**：确保加速地址和原始地址的镜像标签完全一致。

---

更多配置教程和技术支持，请访问 <a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像官网</a>
