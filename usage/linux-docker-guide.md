# Linux 系统 Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/linux

在 Linux 系统上配置轩辕镜像源，让所有 Docker 操作都享受优化访问体验

## 目录

- [获取专属域名](#获取专属域名)
- [配置 Docker daemon](#配置-docker-daemon)
- [重新加载 daemon](#重新加载-daemon)
- [重启 Docker 服务](#重启-docker-服务)
- [验证配置](#验证配置)
- [镜像下载步骤](#镜像下载步骤)
- [配置说明](#配置说明)

## 获取专属域名

登录网站后，在左侧菜单栏的「专属域名」菜单中获取您的专属域名，格式为：`***.xuanyuan.run`

> **注意**：请将 ***.xuanyuan.run** 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Flinux)网站后，点击左侧菜单栏的「专属域名」菜单即可获取。

## 配置 Docker daemon

### 推荐方案：一键安装配置脚本

该脚本支持多种 Linux 发行版，支持一键安装 docker、docker-compose 并且一键配置轩辕镜像源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

或者手动使用以下命令配置 Docker daemon 文件：

```bash
echo '{
  "insecure-registries": ["***.xuanyuan.run"],
  "registry-mirrors": ["https://***.xuanyuan.run"]
}' | sudo tee /etc/docker/daemon.json > /dev/null
```

此命令会将镜像源配置写入 `/etc/docker/daemon.json` 文件

> ⚠️ 请将 ***.xuanyuan.run** 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Flinux)网站后，点击左侧菜单栏的「专属域名」菜单即可获取。

> ⚠️ **注意：**daemon.json 配置的镜像仅对 docker.io 生效，其他仓库镜像需要显式指定地址拉取。
>
> `registry-mirrors` 只作用于 docker.io（Docker Hub 官方仓库）。
>
> 对于其他 Registry（如 `ghcr.io`、`quay.io`、`gcr.io` 等），Docker 客户端不会去查 registry-mirrors，而是直接请求这些域名。
>
> **正确的方法是指定地址显式拉取：**
>
> `docker pull ***-ghcr.xuanyuan.run/org/image:tag`
>
> `docker pull ***-quay.xuanyuan.run/coreos/etcd:latest`

## 重新加载 daemon

重新加载 systemd daemon 配置：

```bash
systemctl daemon-reload
```

## 重启 Docker 服务

重启 Docker 服务使配置生效：

```bash
systemctl restart docker
```

> 💡 重启后，Docker 将使用新的镜像源配置

## 验证配置

验证配置是否生效：

```bash
docker info | grep -A 10 "Registry Mirrors"
```

如果配置成功，您应该能看到您的轩辕镜像地址

## 镜像下载步骤

配置完成后，您可以直接使用标准的 Docker 命令拉取镜像：

```bash
docker pull mysql:latest
```

> ⚠️ **PS:** 不加 TAG 默认为 latest，建议指定具体的 TAG 版本进行下载。

## 配置说明

### 为什么配置了 Docker Registry Mirrors 仍然走官方源？

很多用户反馈，已经在 Docker 中配置了镜像源（registry-mirrors），但拉取镜像时仍然访问官方源（docker.io）。

**拉取报错如下：**

```
Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client. Timeout exceeded while awaiting headers)
```

这是因为 Docker 的镜像拉取机制是优先尝试使用镜像源，而不是强制始终使用。部分镜像的 tag 或 namespace 特殊（如 docker-library），可能仍绕过镜像源。

#### 常见原因

**专属域名没有可用流量**

如果你使用专属域名，但该地址没有充值流量，当 Docker 客户端请求镜像源时，服务端会返回 402 Payment Required 错误，Docker 就会直接回退到官方仓库 docker.io 拉取镜像。

**解决方案：** 请前往[充值页面](https://xuanyuan.cloud/recharge)充值相应的流量包，确保您的专属域名有足够的流量支持镜像服务。

#### 如何确认专属域名可用

建议先用下列方式测试：

```bash
docker pull ***.xuanyuan.run/mysql
```

如果能正常拉取，说明专属域名可用且有流量。

#### 解决方法

如果配置后仍然不生效，建议参考下列文档拉取镜像：

- [专属域名方式配置教程](https://xuanyuan.cloud/usage/nologin)
- [登录方式配置教程](https://xuanyuan.cloud/usage/login)
