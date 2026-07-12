# 飞牛fnOS Docker 镜像加速 - 轩辕镜像配置手册

在飞牛fnOS中配置Docker使用<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>加速服务，享受高速稳定的镜像拉取体验

## 1. 飞牛fnOS Docker 镜像加速配置

飞牛fnOS 用户可以通过配置镜像仓库加速器来使用镜像加速服务。 请按照下方步骤进行操作，配置完成后即可享受高速的镜像拉取服务。

配置前请确保您已在<a href="https://xuanyuan.cloud/" target="_blank">个人中心</a>获取了免登录镜像仓库地址。 飞牛fnOS推荐使用免登录方式，更加简单便捷。

## 2. 第一步：进入镜像仓库设置

打开飞牛fnOS的Docker应用，进入镜像仓库设置页面

- 打开飞牛fnOS的Docker应用
- 点击左侧的"镜像仓库"
- 点击右上角的"设置"按钮

![飞牛fnOS镜像仓库设置](https://imgs.xuanyuan.run/img/feiniu1.jpg)

## 3. 第二步：配置加速源设置

在设置页面中配置镜像加速源

- 在设置页面中，找到"加速源设置"选项
- 点击"添加URL"按钮
- 在输入框中填写您的免登录镜像仓库地址，如：
  - `abc123def456.xuanyuan.run` - 轩辕镜像加速地址
- 点击"添加"或"确定"按钮保存

![飞牛fnOS加速源配置](https://imgs.xuanyuan.run/img/feiniu2.jpg)

## 4. 第三步：设置轩辕镜像为首选加速源

将轩辕镜像加速源设置为最高优先级

- 在加速源列表中，找到刚添加的轩辕镜像加速源
- 使用拖拽或上下箭头按钮，将轩辕镜像加速源移动到最上面
- 确保轩辕镜像加速源位于列表顶部，成为首选加速源
- 保存配置并退出设置页面

✅ **配置完成**：设置完成后，飞牛fnOS将优先使用轩辕镜像加速服务拉取Docker镜像， 大大提升下载速度和稳定性。

## 5. 日常使用说明

配置完成后的日常使用方法

**后续拉取镜像**：
- 在Docker应用中搜索您需要的镜像
- 系统会自动优先使用轩辕镜像加速源
- 点击下载即可享受高速的镜像拉取服务

💡 **小贴士**：将轩辕镜像加速源设置为最高优先级后， 系统会优先使用我们的加速服务，确保获得最佳的下载体验。

**加速服务说明**：
- 轩辕镜像加速地址：适合中国大陆用户，访问速度更快

## 6. 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时<a href="https://xuanyuan.cloud/recharge" target="_blank">充值</a>：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

💡 当您登录或拉取镜像时返回 402 Payment Required 错误，表示您的流量已耗尽。请立即<a href="https://xuanyuan.cloud/recharge" target="_blank">充值</a>流量包以继续使用镜像加速服务。
