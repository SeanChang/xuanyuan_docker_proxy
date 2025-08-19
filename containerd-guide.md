# K8s containerd方式使用[轩辕镜像加速](https://xuanyuan.cloud/){:target="_blank"}

适用于使用 containerd 的系统，如 Kubernetes（k3s / cri-o）或自建 containerd 环境，支持通过配置私有镜像加速源提升镜像拉取速度、可控性与可用性。

## 📌 适用版本

本手册适用于以下 containerd 版本：

| containerd 版本 | 是否支持本配置格式 |
|----------------|-------------------|
| < 1.4 | 不支持（语法不同） |
| 1.4 ~ 1.7.x | 完全支持 |
| ≥ 1.7.x | 推荐使用本格式 |

请使用以下命令查看版本：

```bash
containerd --version
```

## 📁 配置文件路径

containerd 的默认配置文件为：

```
/etc/containerd/config.toml
```

如未生成此文件，可使用以下命令初始化默认配置：

```bash
containerd config default > /etc/containerd/config.toml
```

## 🛠 镜像加速源配置示例

请在 `config.toml` 中添加以下配置（位于 `plugins."io.containerd.grpc.v1.cri".registry.mirrors` 节点）：

```toml
[plugins."io.containerd.grpc.v1.cri".registry]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
      endpoint = ["https://xxxxxx.xuanyuan.run"]

    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
      endpoint = ["https://xxxxxx-k8s.xuanyuan.run"]

    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
      endpoint = ["https://xxxxxx-gcr.xuanyuan.run"]

    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."ghcr.io"]
      endpoint = ["https://xxxxxx-ghcr.xuanyuan.run"]
```

**说明**：多个 endpoint 可按优先级排列，containerd 会依次尝试，直到成功。

**注意**：以上配置为示例，具体可根据自己项目情况修改配置，比如有些k8s 镜像在 `registry.k8s.io` 地址下，示例配置没有写入，需要根据项目情况自行配置。

### 扩展配置示例：

```toml
[plugins."io.containerd.grpc.v1.cri".registry.mirrors]
  # 原配置（k8s.gcr.io）
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
    endpoint = ["https://xxx.xuanyuan.run"]

  # 新增：registry.k8s.io
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
    endpoint = ["https://xxx.xuanyuan.run"]
```

## 🔐 TLS 注意事项

如果因偶发情况触发证书验证失败。可使用以下配置忽略 TLS 校验：

```toml
[plugins."io.containerd.grpc.v1.cri".registry.configs."xxxxxx.xuanyuan.run".tls]
  insecure_skip_verify = true
```

可针对不同域名分别设置。

## ♻️ 应用配置

配置修改完成后，需重启 containerd：

```bash
sudo systemctl restart containerd
```

建议重启后使用 `journalctl -u containerd -f` 观察是否有报错信息。

## ✅ 验证配置是否生效

### 方法一：拉取镜像并观察网络行为

```bash
sudo crictl pull docker.io/library/nginx:alpine
```

或使用 nerdctl：

```bash
sudo nerdctl pull nginx:alpine
```

若配置生效，镜像将从你设置的加速域名拉取，而非默认 `registry-1.docker.io`。

## 📝 常见问题

| 问题描述 | 可能原因 | 解决方法 |
|---------|---------|---------|
| 镜像拉取仍走官方源 | • config.toml 配置无效或路径错误<br>• config.toml 配置中没有配置对应的仓库<br>• 免登录地址没有流量 | • 确认文件路径和语法，或重建配置文件<br>• journalctl -u containerd -f 观察报错信息，看看具体是哪个仓库链接不上，配置到 config.toml 中<br>• 前往充值页面购买流量包 |
| TLS 证书校验失败 | 见 TLS 注意事项 | 见 TLS 注意事项 |
| 拉取失败报错 no matching endpoint | endpoint 拼写错误或域名不可访问 | 检查域名可用性与拼写正确性 |
