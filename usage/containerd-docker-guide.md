# Containerd Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/containerd

适用于使用 containerd 的系统，如 Kubernetes（k3s / cri-o）或自建 containerd 环境，支持通过配置专属镜像域名提升镜像拉取速度、可控性与可用性。本教程同时支持 containerd v1.x 和 v2.x 版本，请根据您的版本选择对应的配置方式。

## 目录

- [适用版本](#适用版本)
- [containerd v1.x 配置](#containerd-v1x-配置)
- [containerd v2.x 配置](#containerd-v2x-配置)

## 适用版本

本手册适用于以下 containerd 版本，请先确认您的版本：

| containerd 版本 | 配置方式 | 说明 |
| --- | --- | --- |
| < 1.4 | 不支持 | ❌ 语法不同 |
| 1.4 ~ 1.7.x | config.toml | ✅ 完全支持（见下方 v1.x 配置） |
| ≥ 1.7.x (v1.x) | config.toml | ✅ 推荐使用（见下方 v1.x 配置） |
| ≥ 2.0 (v2.x) | hosts.toml | ✅ 配置方式不同（见下方 v2.x 配置） |

请使用以下命令查看版本：

```bash
containerd --version
```

## containerd v1.x 配置

### 配置文件路径（v1.x）

containerd 的默认配置文件为：

```
/etc/containerd/config.toml
```

如未生成此文件，可使用以下命令初始化默认配置：

```bash
containerd config default > /etc/containerd/config.toml
```

### 镜像源配置示例（v1.x）

请在 config.toml 中添加以下配置（位于 `plugins."io.containerd.grpc.v1.cri".registry.mirrors` 节点）：

```toml
[plugins."io.containerd.grpc.v1.cri".registry.mirrors]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
    endpoint = [
      "https://***.xuanyuan.run",
      "https://registry-1.docker.io"
    ]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."quay.io"]
    endpoint = ["https://***-quay.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."nvcr.io"]
    endpoint = ["https://***-nvcr.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
    endpoint = ["https://***-k8s.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."mcr.microsoft.io"]
    endpoint = ["https://***-mcr.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.elastic.co"]
    endpoint = ["https://***-elastic.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."container-registry.oracle.com"]
    endpoint = ["https://***-oracle.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.gitlab.com"]
    endpoint = ["https://***-gitlab.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
    endpoint = ["https://***-gcr.xuanyuan.run"]

  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."ghcr.io"]
    endpoint = ["https://***-ghcr.xuanyuan.run"]
```

> **重要提示：** 请将配置中的 `***` 替换为您的专属域名前缀。例如，如果您的专属域名为 `123abc.xuanyuan.run`，则应将 `***` 替换为 `123abc`。

**说明：** 多个 endpoint 可按优先级排列，containerd 会依次尝试，直到成功。

**最佳实践：** docker.io 的配置中，我们添加了 `https://registry-1.docker.io` 作为 fallback endpoint。这样即使专属域名配置有误或不可用，containerd 仍可回退到官方源，确保服务不会中断。

**注意：** 以上配置已包含常用镜像仓库，如果您的项目使用其他镜像仓库，请参考上述格式自行添加配置。

**扩展配置示例：**

```toml
[plugins."io.containerd.grpc.v1.cri".registry.mirrors]
  # 所有主要镜像仓库配置示例（如需添加其他仓库，请参考上述格式）
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."your-registry.io"]
    endpoint = ["https://***-your.xuanyuan.run"]
```

### TLS 注意事项（v1.x）

如果因偶发情况触发证书验证失败，可使用以下配置忽略 TLS 校验：

```toml
[plugins."io.containerd.grpc.v1.cri".registry.configs."***.xuanyuan.run".tls]
  insecure_skip_verify = true
```

可针对不同域名分别设置。

### 应用配置（v1.x）

配置修改完成后，需重启 containerd：

```bash
sudo systemctl restart containerd
```

> 建议重启后使用 `journalctl -u containerd -f` 观察是否有报错信息。

### 验证配置是否生效（v1.x）

**方法一：拉取镜像并观察网络行为**

```bash
sudo crictl pull docker.io/library/nginx:alpine
```

或使用 nerdctl：

```bash
sudo nerdctl pull nginx:alpine
```

若配置生效，镜像将从你设置的专属域名拉取，而非默认 registry-1.docker.io。

## containerd v2.x 配置

### 配置 config.toml（v2.x）

首先，需要在 `/etc/containerd/config.toml` 中配置 `config_path`，指定 hosts.toml 配置文件的目录路径：

```toml
[plugins."io.containerd.cri.v1.images".registry]
  config_path = "/etc/containerd/certs.d"
```

> **重要：** 此配置是必需的，否则 containerd 无法识别 `/etc/containerd/certs.d` 目录下的 hosts.toml 配置文件。配置完成后需要重启 containerd 服务。

### 配置文件路径（v2.x）

containerd v2.x 版本使用独立的 `hosts.toml` 文件进行配置，每个镜像仓库需要创建对应的目录和配置文件：

```
/etc/containerd/certs.d/<registry_host>/hosts.toml
```

例如，对于 docker.io，配置文件路径为：

```
/etc/containerd/certs.d/docker.io/hosts.toml
```

### 创建配置目录和文件（v2.x）

首先，为每个镜像仓库创建对应的目录和配置文件。以 docker.io 为例：

1. 创建配置目录：

```bash
sudo mkdir -p /etc/containerd/certs.d/docker.io
```

2. 创建 hosts.toml 配置文件：

```bash
sudo nano /etc/containerd/certs.d/docker.io/hosts.toml
```

### 镜像源配置示例（v2.x）

在 hosts.toml 文件中添加以下配置内容。以 docker.io 为例：

```toml
server = "https://registry-1.docker.io"

[host."https://***.xuanyuan.run"]
  capabilities = ["pull", "resolve"]
  skip_verify = false
```

> **重要提示：** 对于 docker.io，`server` 字段必须使用 `https://registry-1.docker.io`，不能使用 `https://docker.io`。因为 docker.io 是命名空间，而 registry-1.docker.io 才是实际的 registry 地址。containerd 会严格校验，docker.io 下没有 /v2/ API，这可能导致配置失败。

> **重要提示：** 请将配置中的 `***` 替换为您的专属域名前缀。例如，如果您的专属域名为 `123abc.xuanyuan.run`，则应将 `***` 替换为 `123abc`。

**其他镜像仓库配置示例：**

quay.io 的配置（文件路径：`/etc/containerd/certs.d/quay.io/hosts.toml`）：

```toml
server = "https://quay.io"

[host."https://***-quay.xuanyuan.run"]
  capabilities = ["pull", "resolve"]
  skip_verify = false
```

gcr.io 的配置（文件路径：`/etc/containerd/certs.d/gcr.io/hosts.toml`）：

```toml
server = "https://gcr.io"

[host."https://***-gcr.xuanyuan.run"]
  capabilities = ["pull", "resolve"]
  skip_verify = false
```

**注意：** 对于其他镜像仓库（如 registry.k8s.io、ghcr.io、mcr.microsoft.io 等），请按照相同的方式创建对应的目录和 hosts.toml 文件，并修改 `server` 和 `host` 字段为对应的仓库地址和您的专属域名。

### TLS 配置（v2.x）

如果遇到证书验证失败的问题，可以在 hosts.toml 中设置 `skip_verify = true`：

```toml
server = "https://registry-1.docker.io"

[host."https://***.xuanyuan.run"]
  capabilities = ["pull", "resolve"]
  skip_verify = true
```

可针对不同仓库的 hosts.toml 文件分别设置。

### 应用配置（v2.x）

**首次配置：** 修改了 `config.toml` 文件后，需要重启 containerd 服务使配置生效：

```bash
sudo systemctl restart containerd
```

> 建议重启后使用 `journalctl -u containerd -f` 观察是否有报错信息。

**后续更新：** 首次配置完成后，后续如果只需要修改 `/etc/containerd/certs.d/` 目录下的 hosts.toml 文件，**不需要重启 containerd 服务**。containerd 会自动检测并加载新的配置。

### 验证配置是否生效（v2.x）

配置完成后，尝试拉取镜像验证配置是否生效：

```bash
sudo crictl pull docker.io/library/nginx:alpine
```

或使用 nerdctl：

```bash
sudo nerdctl pull nginx:alpine
```

若配置生效，镜像将从您设置的专属域名拉取，而非默认 registry-1.docker.io。

## 常见问题

| 问题描述 | 可能原因 | 解决方法 |
| --- | --- | --- |
| 镜像拉取仍走官方源（v1.x） | • config.toml 配置无效或路径错误<br>• config.toml 配置中没有配置对应的仓库<br>• 专属域名没有流量 | • 确认文件路径和语法，或重建配置文件<br>• journalctl -u containerd -f 观察报错信息，看看具体是哪个仓库链接不上，配置到 config.toml 中<br>• 前往 [充值页面](https://xuanyuan.cloud/recharge) 充值流量包 |
| 镜像拉取仍走官方源（v2.x） | • hosts.toml 文件路径错误或不存在<br>• hosts.toml 配置语法错误<br>• 未为对应的镜像仓库创建 hosts.toml 文件<br>• 专属域名没有流量<br>• 使用了错误的配置方式（v2.x 不能使用 v1.x 的 config.toml 配置） | • 确认 hosts.toml 文件路径正确（/etc/containerd/certs.d/\<registry\>/hosts.toml）<br>• 检查 hosts.toml 文件语法是否正确，确保 server 和 host 字段配置正确<br>• 为每个需要访问的镜像仓库创建对应的目录和 hosts.toml 文件<br>• journalctl -u containerd -f 观察报错信息<br>• 前往 [充值页面](https://xuanyuan.cloud/recharge) 充值流量包<br>• 确认使用的是 v2.x 配置方式，不要使用 v1.x 的 config.toml 配置 |
| containerd v2.x 配置后验证错误 | • 使用了 v1.x 的 config.toml 配置方式（v2.x 不支持）<br>• hosts.toml 文件路径或格式错误<br>• TLS 证书验证失败 | • 确认 containerd 版本，v2.x 必须使用 hosts.toml 配置，不能使用 config.toml 的 registry.mirrors 配置<br>• 检查 hosts.toml 文件路径和格式是否正确<br>• 在 hosts.toml 中设置 skip_verify = true 跳过 TLS 验证（如需要）<br>• 参考上方的 v2.x 配置指南重新配置 |
| TLS 证书校验失败（v1.x） | 见 TLS 注意事项（v1.x） | 见 TLS 注意事项（v1.x） |
| TLS 证书校验失败（v2.x） | 见 TLS 配置（v2.x） | 在 hosts.toml 中设置 skip_verify = true |
| 拉取失败报错 no matching endpoint | endpoint 拼写错误或域名不可访问 | 检查域名可用性与拼写正确性 |
