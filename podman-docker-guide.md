# Podman Docker 镜像下载加速教程 - 轩辕镜像配置手册

适用于 CentOS / Ubuntu / Arch 等系统，支持通过配置私有镜像加速源提升镜像拉取速度、可控性与可用性。

## 🧩 适用场景

- 你使用的是 Podman 替代 Docker
- 想加快从 docker.io, ghcr.io, gcr.io, k8s.gcr.io 拉取镜像的速度
- 你有自己的专属镜像加速地址，如：xxx.xuanyuan.run

## 1️⃣ 打开配置文件

编辑 Podman 的镜像仓库配置文件：

```bash
sudo nano /etc/containers/registries.conf
```

有些系统是 `/etc/containers/registries.conf.d/` 目录内多个文件，也可以新增一个 `custom.conf` 文件。

## 2️⃣ 添加配置内容

在配置文件中添加以下内容：

```toml
unqualified-search-registries = ['docker.io']

[[registry]]
prefix = "docker.io"
insecure = true
location = "registry-1.docker.io"

  [[registry.mirror]]
  location = "xxx.xuanyuan.run"

[[registry]]
prefix = "k8s.gcr.io"
insecure = true
location = "k8s.gcr.io"

  [[registry.mirror]]
  location = "xxx-k8s.xuanyuan.run"

[[registry]]
prefix = "gcr.io"
insecure = true
location = "gcr.io"

  [[registry.mirror]]
  location = "xxx-gcr.xuanyuan.run"

[[registry]]
prefix = "ghcr.io"
insecure = true
location = "ghcr.io"

  [[registry.mirror]]
  location = "xxx-ghcr.xuanyuan.run"
```

**说明：** 请将 `xxx.xuanyuan.run` 替换为你的专属镜像加速地址。

## 3️⃣ 测试是否生效

运行以下命令测试是否走加速地址：

```bash
podman pull docker.io/library/alpine
```

然后查看是否访问了 `xxx.xuanyuan.run`，可以在代理服务器或网络抓包工具中确认。

## 📝 常见问题

| 问题描述 | 可能原因 | 解决方法 |
|---------|---------|---------|
| 镜像拉取仍走官方源 | 配置文件路径错误或语法错误 | 检查配置文件路径和 TOML 语法 |
| 镜像拉取仍走官方源 | 配置文件中没有配置对应的仓库 | 检查具体是哪个仓库链接不上，配置到配置文件中 |
| 镜像拉取仍走官方源 | 免登录地址没有流量 | 前往[充值](https://xuanyuan.cloud/recharge)页面购买流量包 |

## 🔗 相关链接

- [轩辕镜像](https://xuanyuan.cloud/) - 个人中心
- [充值](https://xuanyuan.cloud/recharge) - 购买流量包
