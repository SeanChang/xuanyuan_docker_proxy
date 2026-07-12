# K3s Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/k3s

适用于 K3s 集群（master + worker 节点），解决国内环境下 Docker Hub、Rancher、Pause 等镜像拉取超时问题。

## 目录

- [1. 常见问题现象](#1-常见问题现象)
- [2. 核心要点](#2-核心要点)
- [3. 镜像系统说明](#3-镜像系统说明)
- [4. 配置文件示例](#4-配置文件示例)
- [5. 配置步骤](#5-配置步骤)
- [6. 验证配置](#6-验证配置)
- [7. 常见问题](#7-常见问题)

## 1. 常见问题现象

当 K3s 集群出现以下错误时，通常表示镜像拉取失败：

```text
Failed to create pod sandbox
```

```text
failed to pull image "rancher/mirrored-pause:3.6"
```

```text
failed to resolve reference "docker.io/rancher/mirrored-pause:3.6"
```

```text
dial tcp ***.***.***.***:443: i/o timeout
```

> **问题原因**：K3s 节点直接访问 registry-1.docker.io（Docker Hub），由于国内网络环境限制导致连接超时。

> **关键说明**：rancher/mirrored-pause 是 K3s 创建 Pod Sandbox 时的系统级基础镜像，一旦拉取失败，整个集群将无法创建 Pod。这是为什么该问题看似很小，实际影响非常严重。

> **重要提示**：即使已配置镜像加速，如果集群中存在未生效的节点，仍会导致镜像拉取失败。

## 2. 核心要点

> **所有节点均需配置镜像加速**

K3s 集群中的 master 节点和所有 worker 节点都必须单独配置镜像加速，仅配置 master 节点无法解决 worker 节点的镜像拉取问题。

## 3. 镜像系统说明

K3s 默认使用 containerd 作为容器运行时，其镜像配置方式与 Docker 不同。

> **注意**：K3s 不会读取 Docker 的配置文件 `/etc/docker/daemon.json`

**配置文件路径：**

```text
/etc/rancher/k3s/registries.yaml
```

## 4. 配置文件示例

以下为推荐的 `registries.yaml` 配置示例：

```yaml
mirrors:
  # Docker Hub 镜像（最关键）
  docker.io:
    endpoint:
      - "https://***.xuanyuan.run"

  # Kubernetes 官方镜像（新标准）
  registry.k8s.io:
    endpoint:
      - "https://***-k8s.xuanyuan.run"

  # Rancher 镜像（可选，实际仍来自 docker.io）
  # 注意：rancher/* 镜像实际 registry 仍然是 docker.io，containerd 并不会把 rancher 当作独立 registry
  # 是否配置该项不影响拉取结果，关键仍是 docker.io 的加速配置
  rancher:
    endpoint:
      - "https://***.xuanyuan.run"

  # quay.io 镜像
  quay.io:
    endpoint:
      - "https://***-quay.xuanyuan.run"
      - "https://quay.mirrors.aliyun.com"
      - "https://quay.io"

configs: {}
```

> **配置说明**：请将配置中的 `***` 替换为您的实际专属域名前缀。例如，如果您的专属域名为 `123abc.xuanyuan.run`，则应将 `***` 替换为 `123abc`。

**配置要点：**

- **docker.io 配置：**必须使用主专属域名，不能使用带后缀的域名（如 -quay 后缀）或免费域名。
- **Kubernetes 镜像：**k8s.gcr.io 已废弃，统一使用 registry.k8s.io。
- **Rancher 镜像：**rancher/* 镜像实际 registry 仍然是 docker.io，containerd 不会将 rancher 视为独立 registry。是否配置该项不影响拉取结果，关键仍是 docker.io 的加速配置。该项为可选配置。

## 5. 配置步骤

需要在集群的每个节点（master 和 worker）上分别执行以下配置步骤。

> **注意**：如果节点是通过 k3s-agent 加入集群的，只需要重启 k3s-agent 服务，不需要重启 master 节点的 k3s 服务。

> **重要提示**：修改配置后必须重启 K3s 服务才能生效，containerd 不会自动加载配置变更。

**步骤 1：创建配置文件**

在每个节点上创建配置目录并编辑配置文件：

```bash
sudo mkdir -p /etc/rancher/k3s
```

```bash
sudo vi /etc/rancher/k3s/registries.yaml
```

将上述配置示例内容写入文件，并替换为您的专属域名。

**步骤 2：重启 K3s 服务**

**Master 节点：**

```bash
sudo systemctl restart k3s
```

**Worker 节点：**

```bash
sudo systemctl restart k3s-agent
```

## 6. 验证配置

配置完成后，可在任意节点执行以下命令验证镜像加速是否生效：

```bash
k3s crictl pull rancher/mirrored-pause:3.6
```

**配置生效的表现：**

- 镜像拉取速度正常，无明显延迟
- 不再访问 registry-1.docker.io
- 不再出现 i/o timeout 错误
- Pod Sandbox 创建失败问题得到解决

## 7. 常见问题

**问题 1：仅配置了 master 节点**

K3s 集群中所有节点都需要单独配置，仅配置 master 节点无法解决 worker 节点的镜像拉取问题。

**问题 2：docker.io 使用了错误的专属域名**

docker.io 必须使用主专属域名，不能使用带后缀的域名（如 -quay 后缀）。

```yaml
docker.io:
  endpoint:
    - https://***-quay.xuanyuan.run  # 错误示例
```

**问题 3：配置后未重启服务**

containerd 不支持配置热加载，修改配置后必须重启 k3s 或 k3s-agent 服务才能生效。
