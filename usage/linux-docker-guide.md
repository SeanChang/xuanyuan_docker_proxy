# Linux 系统 Docker 镜像源配置教程 - 轩辕镜像

在 Linux 系统上配置 [轩辕镜像](https://xuanyuan.cloud/) 源，让所有 Docker 操作都享受高速加速体验。

## 1. 获取专属免登录地址

在 [轩辕镜像](https://xuanyuan.cloud/) 个人中心获取您的专属免登录加速地址，格式为：`xxx.xuanyuan.run`

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

## 2. 配置 Docker daemon

使用以下命令配置 Docker daemon 文件：

```bash
echo '{"insecure-registries":["xxx.xuanyuan.run"],"registry-mirrors":["https://xxx.xuanyuan.run"]}' | sudo tee /etc/docker/daemon.json > /dev/null
```

此命令会将镜像源配置写入 `/etc/docker/daemon.json` 文件。

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址。

## 3. 重新加载 daemon

```bash
sudo systemctl daemon-reload
```

## 4. 重启 Docker 服务

```bash
sudo systemctl restart docker
```

重启后，Docker 将使用新的镜像源配置。

## 5. 验证配置

```bash
docker info | grep -A 10 "Registry Mirrors"
```

如果配置成功，您应该能看到您的轩辕镜像地址。

## 6. 镜像搜索步骤

```bash
docker search nginx
```

## 7. 镜像下载步骤

```bash
docker pull xxx.xuanyuan.run/mysql
```

或使用标准短名（配置 mirrors 后）：

```bash
docker pull mysql:latest
```

> **PS**：不加 TAG 默认为 latest，建议指定具体的 TAG 版本进行下载。

## 配置说明

### 为什么配置了 Docker Registry Mirrors 仍然走官方源？

很多用户反馈，已经在 Docker 中配置了镜像加速器（registry-mirrors），但拉取镜像时仍然访问官方源（docker.io）。

拉取报错如下：

```
Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
```

这是因为 Docker 的镜像拉取机制是优先尝试使用镜像加速器，而不是强制始终使用。部分镜像的 tag 或 namespace 特殊（如 docker-library），可能仍绕过加速器。

### 免登录地址没有可用流量

如果你使用免登录地址，但该地址没有购买流量，当 Docker 客户端请求加速器时，服务端会返回 402 Payment Required 错误，Docker 就会直接回退到官方仓库 docker.io 拉取镜像。

**解决方案**：请前往 [轩辕镜像充值页面](https://xuanyuan.cloud/recharge) 购买相应的流量包。

### 如何确认免登录地址可用

```bash
docker pull xxx.xuanyuan.run/mysql
```

如果能正常拉取，说明免登录地址可用且有流量。

### 更多配置方式

- [专属域名配置教程](./nologin-docker-guide.md)
- [登录方式配置教程](./login-docker-guide.md)
