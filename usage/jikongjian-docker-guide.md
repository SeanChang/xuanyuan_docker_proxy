# 极空间 NAS Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/jikongjian

在极空间NAS中配置Docker使用轩辕镜像访问支持服务，享受稳定顺畅的镜像拉取体验

## 目录

- [Docker 镜像访问配置](#docker-镜像访问配置)
- [打开 Docker 客户端](#打开-docker-客户端)
- [选择镜像源配置](#选择镜像源配置)
- [添加专属域名并保存](#添加专属域名并保存)
- [配置完成](#配置完成)
- [流量耗尽错误提示](#流量耗尽错误提示)

## Docker 镜像访问配置

极空间 NAS 用户可以通过配置镜像源来使用镜像访问支持服务。请按照下方步骤进行操作，配置完成后即可顺畅获取镜像。

> 💡 配置前请确保您已[登录](https://xuanyuan.cloud/dashboard)网站，并在左侧菜单栏的「专属域名」菜单中获取了**专属域名**。极空间NAS推荐使用专属域名方式，更加简单便捷。

## 打开 Docker 客户端

打开Docker客户端，点击左侧「镜像」→ 点击「仓库」→ 点击右上角「设置」

![极空间NAS Docker配置步骤1](https://img.xuanyuan.dev/docker/usage/jikongjian31.jpg)

## 选择镜像源配置

在设置弹窗中，点击「镜像源配置」标签页

![极空间NAS Docker配置步骤2](https://img.xuanyuan.dev/docker/usage/jikongjian41.jpg)

## 添加专属域名并保存

将您的专属域名填写在输入框中，如果没有输入框，点击「添加URL」按钮添加。确认地址无误后，点击「保存」按钮完成配置。

**可选择的地址格式：**

- `***.xuanyuan.run` - 轩辕镜像访问地址（国内）

> ⚠️ **重要提示：**
>
> 默认情况下，地址格式需要添加 `https://` 前缀，即 `https://***.xuanyuan.run`，否则会报错：`invalid url`。
>
> 但在一些老版本极空间NAS中，不需要 `https://` 前缀。如果您遇到 `invalid url` 错误，请分别尝试以下两种格式：
> - `https://***.xuanyuan.run`
> - `***.xuanyuan.run`

![极空间NAS Docker配置步骤3](https://img.xuanyuan.dev/docker/usage/jikongjian51.jpg)

## 配置完成

配置完成后，您就可以在极空间NAS中搜索和下载镜像了。

1. 配置保存成功后，即可使用镜像访问支持服务
2. 返回镜像页面，搜索并下载您需要的Docker镜像
3. 所有通过极空间NAS拉取的Docker镜像都将通过我们的访问支持服务，帮助提升访问体验

> ✅ **配置总结：**
> 1. 打开Docker客户端
> 2. 点击镜像并选择仓库
> 3. 选择镜像源配置
> 4. 点击添加URL，把专属域名添加进去
> 5. 添加完成后点击确定保存配置
> 6. 现在就可以去搜索和下载镜像了

> 💡 **小贴士：** 配置完成后，极空间NAS会自动使用轩辕镜像访问支持服务拉取镜像，帮助提升访问体验。
>
> **访问支持说明：**
> - 轩辕镜像访问地址：适合国内大陆用户，访问体验更顺畅

## 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时[充值](https://xuanyuan.cloud/recharge)：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

> 💡 当您登录或拉取镜像时返回 **402 Payment Required** 错误，表示您的流量已耗尽。请立即[充值流量包](https://xuanyuan.cloud/recharge)以继续使用镜像访问支持服务。
