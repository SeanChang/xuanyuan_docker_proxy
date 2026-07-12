# Docker Desktop 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/desktop

在 Windows 和 Mac 系统上配置 Docker Desktop，享受高速稳定的镜像体验

## 目录

- [获取专属域名](#获取专属域名)
- [打开 Docker Desktop 设置](#打开-docker-desktop-设置)
- [配置 Docker Engine](#配置-docker-engine)
- [重启 Docker](#重启-docker)
- [验证配置](#验证配置)
- [镜像搜索步骤](#镜像搜索步骤)
- [镜像下载步骤](#镜像下载步骤)
- [配置说明](#配置说明)

## 获取专属域名

登录网站后，在左侧菜单栏的「专属域名」菜单中获取您的专属域名，格式为：`https://***.xuanyuan.run`

> **注意**：请将 ***.xuanyuan.run** 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fdesktop)网站后，点击左侧菜单栏的「专属域名」菜单即可获取。

## 打开 Docker Desktop 设置

打开 Docker Desktop，点击右上角的设置图标（齿轮）进入 Settings

**注意：**确保 Docker Desktop 已经启动并正常运行

## 配置 Docker Engine

选择左侧的 "Docker Engine"，在右侧 JSON 配置中添加或修改 registry-mirrors 配置：

```json
{
  "insecure-registries": [
    "***.xuanyuan.run"
  ],
  "registry-mirrors": [
    "https://***.xuanyuan.run"
  ]
}
```

> ⚠️ **重要：**请注意配置格式：`insecure-registries` 中不使用 `https://` 标头，`registry-mirrors` 中必须使用 `https://` 标头，否则 Docker 会启动不了。

## 重启 Docker

点击右下角的 "Apply & Restart" 按钮重启 Docker，等待 Docker 重启完成

> 💡 重启过程可能需要几分钟时间，请耐心等待

## 验证配置

可以通过 CMD 或终端，查看配置是否生效：检查 Registry Mirrors 是否存在对应的镜像源

```bash
docker info
```

## 镜像搜索步骤

打开 Docker Desktop，点击右下角 "_ Terminal" 打开终端，输入搜索命令：

```bash
docker search ***.xuanyuan.run/nginx
```

## 镜像下载步骤

打开 Docker Desktop，点击右下角 "_ Terminal" 打开终端，输入下载命令：

```bash
docker pull ***.xuanyuan.run/nginx
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

- [专属域名配置教程](https://xuanyuan.cloud/usage/nologin)
- [登录方式配置教程](https://xuanyuan.cloud/usage/login)
