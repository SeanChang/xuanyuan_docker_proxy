# 宝塔面板 Docker 镜像加速 - 轩辕镜像配置手册

在宝塔面板中配置Docker使用轩辕镜像加速服务，享受高速稳定的镜像拉取体验

## 1. 宝塔面板 Docker 镜像加速配置

宝塔面板用户可以通过以下步骤配置 Docker 镜像仓库。首先请确保您的宝塔面板已安装 Docker 管理器插件。 如果尚未安装，请在宝塔面板的软件商店中搜索并安装 Docker 管理器。

配置前请确保您已在[个人中心](https://xuanyuan.cloud/)获取了免登录镜像仓库地址。 宝塔面板推荐使用免登录方式，更加简单便捷。

## 2. 宝塔面板 Docker 配置步骤

宝塔面板用户可以通过以下步骤配置 Docker 镜像仓库：

### 宝塔面板 Docker 镜像仓库配置步骤

点击图片可查看大图:[https://imgs.xuanyuan.run/img/baota.jpg](https://imgs.xuanyuan.run/img/baota.jpg)

## 3. 详细配置步骤

在宝塔面板的 Docker 管理界面中配置镜像仓库：

1. 在[个人中心](https://xuanyuan.cloud/)的「用户信息」页面中的「镜像仓库信息」卡片里找到您的免登录镜像仓库地址
2. 复制您的专属免登录地址（格式如：xxx.xuanyuan.run）
3. 在宝塔面板中打开「软件商店」 → 「Docker管理器」
4. 点击「设置」 → 「镜像仓库」
5. 在「镜像仓库地址」中输入您的专属免登录地址
6. 点击「保存」完成配置

**注意：** 宝塔面板的 Docker 管理器插件需要更新到最新版本才能正常使用镜像仓库配置功能。 如果遇到问题，请先更新插件到最新版本。

## 4. 测试镜像拉取

配置完成后，可以通过以下命令测试镜像拉取是否正常：

```bash
docker pull 您的免登录地址/redis:latest
```

如：`docker pull abc123def456.xuanyuan.run/redis:latest`

## 5. 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时[充值](https://xuanyuan.cloud/recharge)：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

💡 **当您登录或拉取镜像时返回 402 Payment Required 错误，表示您的流量已耗尽。请立即[充值](https://xuanyuan.cloud/recharge)流量包以继续使用镜像加速服务。**

