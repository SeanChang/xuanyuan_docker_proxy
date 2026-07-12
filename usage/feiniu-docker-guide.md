# 飞牛 NAS Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/feiniu

在飞牛fnOS中配置Docker使用轩辕镜像服务，享受高速稳定的镜像拉取体验

## 目录

- [Docker 镜像配置](#docker-镜像配置)
- [进入镜像仓库设置](#进入镜像仓库设置)
- [配置镜像源设置](#配置镜像源设置)
- [设置首选镜像源](#设置首选镜像源)
- [日常使用说明](#日常使用说明)
- [流量耗尽错误提示](#流量耗尽错误提示)

## Docker 镜像配置

飞牛fnOS 用户可以通过配置镜像仓库镜像源来使用镜像服务。请按照下方步骤进行操作，配置完成后即可享受高速的镜像拉取服务。

> 💡 配置前请确保您已[登录](https://xuanyuan.cloud/dashboard)网站，并在左侧菜单栏的「专属域名」菜单中获取了**专属域名**。飞牛fnOS推荐使用专属域名方式，更加简单便捷。

## 进入镜像仓库设置

打开飞牛fnOS的Docker应用，进入镜像仓库设置页面

1. 打开飞牛fnOS的Docker应用
2. 点击左侧的"镜像仓库"
3. 点击右上角的"设置"按钮

![飞牛fnOS镜像仓库设置](https://img.xuanyuan.dev/docker/usage/feiniu1.jpg)

## 配置镜像源设置

在设置页面中配置镜像源

1. 在设置页面中，找到"镜像源设置"选项
2. 点击"添加URL"按钮
3. 在输入框中填写您的**专属域名**，如：
   - `https://***.xuanyuan.run` - 轩辕镜像地址
4. 点击"添加"或"确定"按钮保存

> ⚠️ **注意事项：** 必须是 `https://***.xuanyuan.run` 这种带协议头的完整链接，否则会报错：镜像源地址无效

![飞牛fnOS镜像源配置](https://img.xuanyuan.dev/docker/usage/feiniu2.jpg)

## 设置首选镜像源

将轩辕镜像源设置为最高优先级

1. 在镜像源列表中，找到刚添加的轩辕镜像源
2. 使用拖拽或上下箭头按钮，将轩辕镜像源移动到最上面
3. 确保轩辕镜像源位于列表顶部，成为首选镜像源
4. 保存配置并退出设置页面

> ✅ **配置完成：** 设置完成后，飞牛fnOS将优先使用轩辕镜像服务拉取Docker镜像，大大提升下载速度和稳定性。

## 日常使用说明

配置完成后的日常使用方法

### 后续拉取镜像：

1. 在Docker应用中搜索您需要的镜像
2. 系统会自动优先使用轩辕镜像源
3. 点击下载即可享受高速的镜像拉取服务

> 💡 **小贴士：** 将轩辕镜像源设置为最高优先级后，系统会优先使用我们的服务，确保获得最佳的下载体验。
>
> **服务说明：**
> - 轩辕镜像地址：适合国内大陆用户，访问速度更快

## 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时[充值](https://xuanyuan.cloud/recharge)：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

> 💡 当您登录或拉取镜像时返回 **402 Payment Required** 错误，表示您的流量已耗尽。请立即[充值流量包](https://xuanyuan.cloud/recharge)以继续使用镜像服务。
