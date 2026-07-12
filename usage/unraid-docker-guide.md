# Unraid Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/unraid

在 Unraid Web 界面通过终端写入 Docker 镜像加速配置，使用轩辕镜像专属域名提升 docker.io 镜像拉取速度。

## 目录

- [适用场景](#适用场景)
- [获取专属域名](#获取专属域名)
- [终端配置镜像源](#终端配置镜像源)
- [重启 Docker 服务](#重启-docker-服务)
- [验证与使用](#验证与使用)
- [配置说明](#配置说明)
- [流量耗尽提示](#流量耗尽提示)

## 适用场景

本教程适用于已安装 Docker 插件的 Unraid 系统（通常为 Unraid 6.x 及以上），通过 Web 终端配置 `registry-mirrors` 接入轩辕镜像专属加速域名。

配置完成后，在 Unraid 的 Apps 页面搜索并下载 Docker 镜像时，系统会优先通过轩辕镜像加速拉取 docker.io 仓库镜像。

> 💡 其他 NAS 可参考[群晖](https://xuanyuan.cloud/usage/synology)、[飞牛](https://xuanyuan.cloud/usage/feiniu)等教程；多仓库前缀规则见[专属域名拉取教程](https://xuanyuan.cloud/usage/nologin)。

## 获取专属域名

登录网站后，在左侧菜单栏的「专属域名」中获取您的专属域名，格式为：`***.xuanyuan.run`

> 💡 请将 `***.xuanyuan.run` 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard)网站后，点击左侧菜单栏的「专属域名」即可获取。推荐使用专属加速域名，详见[专属域名拉取教程](https://xuanyuan.cloud/usage/nologin)。

## 终端配置镜像源

1. 打开 Unraid Web 管理页面，点击右侧菜单栏中的**终端**图标（`>_`）
2. 进入终端页面后，执行下方命令写入镜像加速配置

```bash
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<'EOF'
{
  "registry-mirrors": ["https://***.xuanyuan.run"]
}
EOF
```

此命令会将配置写入 `/etc/docker/daemon.json`

> ⚠️ 若 `daemon.json` 已存在且含其他配置项，请先执行 `cat /etc/docker/daemon.json` 备份，再手动合并 `registry-mirrors` 字段，避免覆盖原有设置。

## 重启 Docker 服务

写入配置后需重启 Docker 服务才能生效。请返回 Unraid Web 页面按以下步骤操作：

1. 点击顶部菜单栏的**设置（Settings）**
2. 找到并点击**Docker**
3. 将**启用 Docker（Enable Docker）**改为**否**，点击**应用（Apply）**，等待 Docker 服务停止
4. 再次将**启用 Docker**改为**是**，点击**应用**，等待 Docker 服务启动完成

## 验证与使用

Docker 重启完成后，即可通过 Apps 页面搜索并下载镜像：

1. 打开 Unraid 的 **Apps** 页面
2. 搜索需要的镜像（例如 `nginx`）
3. 点击安装/下载，系统会通过轩辕镜像加速拉取

也可在终端中验证配置是否已加载：

```bash
cat /etc/docker/daemon.json
```

```bash
docker info | grep -A 5 "Registry Mirrors"
```

## 配置说明

- **HTTPS 协议头**：镜像源地址须为完整 URL，例如 `https://***.xuanyuan.run`，缺少 `https://` 可能导致配置无效
- **仅对 docker.io 生效**：`registry-mirrors` 只加速 Docker Hub（docker.io）镜像；GHCR、GCR 等仓库需使用专属域名完整路径拉取，参见[专属域名拉取教程](https://xuanyuan.cloud/usage/nologin)
- **配置持久性**：Unraid 重启后 `/etc/docker/daemon.json` 通常保留；若升级系统后失效，请重新检查并重启 Docker

## 流量耗尽提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时[充值](https://xuanyuan.cloud/recharge)：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

> 💡 当您拉取镜像时返回 **402 Payment Required** 或 **PAYMENT_REQUIRED** 错误，表示流量已耗尽。请立即[充值流量包](https://xuanyuan.cloud/recharge)以继续使用镜像服务。
