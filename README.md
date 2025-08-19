# 最新 Docker 镜像源加速列表与使用指南（2025年8月更新）

## 轩辕镜像 Docker 加速服务

<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a> 提供高速稳定的 Docker 镜像加速服务，让您的 Docker 操作享受极速体验。

## Linux 配置轩辕镜像源

在 Linux 系统上配置<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>源，让所有 Docker 操作都享受高速加速体验。

### 1. 获取专属免登录地址

在<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>个人中心获取您的专属免登录加速地址，格式为：`xxx.xuanyuan.run`

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

### 2. 配置 Docker daemon

使用以下命令配置 Docker daemon 文件：

```bash
echo '{"insecure-registries":["xxx.xuanyuan.run"],"registry-mirrors":["https://xxx.xuanyuan.run"]}' | sudo tee /etc/docker/daemon.json > /dev/null
```

此命令会将镜像源配置写入 `/etc/docker/daemon.json` 文件

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

### 3. 重新加载 daemon

重新加载 systemd daemon 配置：

```bash
systemctl daemon-reload
```

### 4. 重启 Docker 服务

重启 Docker 服务使配置生效：

```bash
systemctl restart docker
```

重启后，Docker 将使用新的镜像源配置

### 5. 验证配置

验证配置是否生效：

```bash
docker info | grep -A 10 "Registry Mirrors"
```

如果配置成功，您应该能看到您的<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>地址

### 6. 镜像搜索步骤

配置完成后，您可以直接使用标准的 Docker 命令搜索镜像：

```bash
docker search nginx
```

### 7. 镜像下载步骤

配置完成后，您可以直接使用标准的 Docker 命令拉取镜像：

```bash
docker pull mysql:latest
```

> **PS**: 不加 TAG 默认为 latest，建议指定具体的 TAG 版本进行下载。

## 配置说明

### 🐳 为什么配置了 Docker Registry Mirrors 仍然走官方源？

很多用户反馈，已经在 Docker 中配置了镜像加速器（registry-mirrors），但拉取镜像时仍然访问官方源（docker.io）。

拉取报错如下：

```
Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client. Timeout exceeded while awaiting headers)
```

这是因为 Docker 的镜像拉取机制是优先尝试使用镜像加速器，而不是强制始终使用。部分镜像的 tag 或 namespace 特殊（如 docker-library），可能仍绕过加速器。

### 常见原因

#### 免登录地址没有可用流量

如果你使用免登录地址，但该地址没有购买流量，当 Docker 客户端请求加速器时，服务端会返回 402 Payment Required 错误，Docker 就会直接回退到官方仓库 docker.io 拉取镜像。

**解决方案**: 请前往<a href="https://xuanyuan.cloud/recharge" target="_blank">轩辕镜像</a>充值页面购买相应的流量包，确保您的免登录地址有足够的流量支持镜像加速服务。

### 如何确认免登录地址可用

建议先用下列方式测试：

```bash
docker pull abc123def456.xuanyuan.run/mysql
```

如果能正常拉取，说明免登录地址可用且有流量。

### 解决方法

如果配置后仍然不生效，建议参考下列文档拉取镜像：

- <a href="https://xuanyuan.cloud/" target="_blank">免登录配置教程</a> 或 <a href="https://xuanyuan.cloud/" target="_blank">登录方式配置教程</a>

## 更多信息

访问 <a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像官网</a> 获取更多配置教程和技术支持。
