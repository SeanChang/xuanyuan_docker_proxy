# 宝塔面板 Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/baota

在宝塔面板中配置Docker使用轩辕镜像服务，享受高速稳定的镜像拉取体验

## 目录

- [宝塔面板 Docker 镜像配置](#宝塔面板-docker-镜像配置)
- [Docker 配置步骤](#docker-配置步骤)
- [详细配置步骤](#详细配置步骤)
- [测试镜像拉取](#测试镜像拉取)
- [流量耗尽错误提示](#流量耗尽错误提示)

## 宝塔面板 Docker 镜像配置

宝塔面板用户可以通过以下步骤配置 Docker 镜像仓库。首先请确保您的宝塔面板已安装 Docker 管理器插件。如果尚未安装，请在宝塔面板的软件商店中搜索并安装 Docker 管理器。

> 💡 配置前请确保您已[登录](https://xuanyuan.cloud/dashboard)网站，并在左侧菜单栏的「专属域名」菜单中获取了**专属域名**。宝塔面板推荐使用专属域名方式，更加简单便捷。

## Docker 配置步骤

宝塔面板用户可以通过以下步骤配置 Docker 镜像仓库：

![宝塔面板 Docker 镜像仓库配置步骤](https://img.xuanyuan.dev/docker/usage/baota.jpg)

## 详细配置步骤

在宝塔面板的 Docker 管理界面中配置镜像仓库：

1. [登录](https://xuanyuan.cloud/dashboard)后，在左侧菜单栏的「专属域名」菜单中找到您的**专属域名**
2. 复制您的专属域名（格式如：`***.xuanyuan.run`）
3. 在宝塔面板中打开**「软件商店」** → **「Docker管理器」**
4. 点击**「设置」** → **「镜像仓库」**
5. 在**「镜像仓库地址」**中输入您的专属域名
6. 点击**「保存」**完成配置

> ⚠️ **注意：** 宝塔面板的 Docker 管理器插件需要更新到最新版本才能正常使用镜像仓库配置功能。如果遇到问题，请先更新插件到最新版本。

## 测试镜像拉取

配置完成后，可以通过以下命令测试镜像拉取是否正常：

```bash
docker pull 您的专属域名/redis:latest
```

如：`docker pull ***.xuanyuan.run/redis:latest`

## 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时[充值](https://xuanyuan.cloud/recharge)：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

> 💡 当您登录或拉取镜像时返回 **402 Payment Required** 错误，表示您的流量已耗尽。请立即[充值流量包](https://xuanyuan.cloud/recharge)以继续使用镜像服务。
