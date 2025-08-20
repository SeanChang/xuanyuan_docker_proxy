# 极空间 NAS Docker 加速 - 轩辕镜像配置手册

在极空间NAS中配置Docker使用<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>加速服务，享受高速稳定的镜像拉取体验

## 1. 极空间 NAS Docker 镜像加速配置

极空间 NAS 用户可以通过配置加速器来使用镜像加速服务。 请按照下方步骤进行操作，配置完成后即可享受高速的镜像拉取服务。

配置前请确保您已在<a href="https://xuanyuan.cloud/" target="_blank">个人中心</a>获取了免登录镜像仓库地址。 极空间NAS推荐使用免登录方式，更加简单便捷。

## 2. 步骤1：打开Docker客户端并进入镜像仓库设置

打开Docker客户端，点击左侧「镜像」→ 点击「仓库」→ 点击右上角「设置」

![极空间NAS Docker配置步骤1](https://imgs.xuanyuan.run/img/jikongjian31.jpg)

## 3. 步骤2：选择加速器配置

在设置弹窗中，点击「加速器配置」标签页

![极空间NAS Docker配置步骤2](https://imgs.xuanyuan.run/img/jikongjian41.jpg)

## 4. 步骤3：添加免登录地址并保存

将您的免登录地址填写在输入框中，如果没有输入框，点击「添加URL」按钮添加。确认地址无误后，点击「保存」按钮完成配置。

可选择的地址格式：

- `abc123def456.xuanyuan.run` - <a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>加速地址（国内CDN加速）

![极空间NAS Docker配置步骤3](https://imgs.xuanyuan.run/img/jikongjian51.jpg)

## 5. 配置完成

配置完成后，您就可以在极空间NAS中搜索和下载镜像了。

- 配置保存成功后，即可使用加速的镜像拉取服务
- 返回镜像页面，搜索并下载您需要的Docker镜像
- 所有通过极空间NAS拉取的Docker镜像都将通过我们的加速服务，大大提升下载速度和稳定性

## ✅ 配置总结：

1. 打开Docker客户端
2. 点击镜像并选择仓库
3. 选择加速器配置
4. 点击添加URL，把免登录镜像源地址添加进去
5. 添加完成后点击确定保存配置
6. 现在就可以去搜索和下载镜像了

💡 **小贴士**：配置完成后，极空间NAS会自动使用<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>加速服务拉取镜像， 大大提升下载速度和稳定性。您可以在下载过程中看到明显的速度提升。

**加速服务说明：**
- <a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>加速地址：适合中国大陆用户，访问速度更快

## 6. 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时充值：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

💡 当您登录或拉取镜像时返回 402 Payment Required 错误，表示您的流量已耗尽。请立即充值流量包以继续使用镜像加速服务。
