# Podman Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/podman

适用于 CentOS / Ubuntu / Arch 等系统，支持通过配置专属镜像地址提升镜像拉取速度、可控性与可用性。

## 目录

- [1. 适用场景](#1-适用场景)
- [2. 打开配置文件](#2-打开配置文件)
- [3. 添加配置内容](#3-添加配置内容)
- [4. 测试是否生效](#4-测试是否生效)
- [5. 常见问题](#5-常见问题)

## 1. 适用场景

- 你使用的是 Podman 替代 Docker
- 想加快从 docker.io、ghcr.io、gcr.io、k8s.gcr.io 拉取镜像的速度
- 你有自己的专属镜像地址，如：`***.xuanyuan.run`

## 2. 打开配置文件

编辑 Podman 的镜像仓库配置文件：

```bash
sudo nano /etc/containers/registries.conf
```

有些系统是 `/etc/containers/registries.conf.d/` 目录内多个文件，也可以新增一个 `custom.conf` 文件。

## 3. 添加配置内容

在配置文件中添加以下内容：

```toml
unqualified-search-registries = ["docker.io"]

[[registry]]
prefix = "docker.io"
insecure = true
location = "registry-1.docker.io"

[[registry.mirror]]
location = "***.xuanyuan.run"

[[registry]]
prefix = "k8s.gcr.io"
insecure = true
location = "k8s.gcr.io"

[[registry.mirror]]
location = "***-k8s.xuanyuan.run"

[[registry]]
prefix = "registry.k8s.io"
insecure = true
location = "registry.k8s.io"

[[registry.mirror]]
location = "***-k8s.xuanyuan.run"

[[registry]]
prefix = "gcr.io"
insecure = true
location = "gcr.io"

[[registry.mirror]]
location = "***-gcr.xuanyuan.run"

[[registry]]
prefix = "ghcr.io"
insecure = true
location = "ghcr.io"

[[registry.mirror]]
location = "***-ghcr.xuanyuan.run"
```

**说明：**请将 `***.xuanyuan.run` 替换为你的专属镜像地址。

## 4. 测试是否生效

运行以下命令测试是否走专属域名：

```bash
podman pull docker.io/library/alpine
```

然后查看是否访问了 `***.xuanyuan.run`，可以在代理服务器或网络抓包工具中确认。

## 5. 常见问题

| 问题描述 | 可能原因 | 解决方法 |
|---------|---------|---------|
| 镜像拉取仍走官方源 | 配置文件路径错误或语法错误；配置文件中没有配置对应的仓库；专属域名没有流量 | 检查配置文件路径和 TOML 语法；检查具体是哪个仓库链接不上，配置到配置文件中；前往[充值页面](https://xuanyuan.cloud/recharge)充值流量包 |
