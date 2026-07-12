# 爱快路由 ikuai Docker 镜像加速 - 轩辕镜像配置手册

在爱快路由中配置Docker使用<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>加速服务，享受高速稳定的镜像拉取体验

## 1. 爱快路由 Docker 镜像加速配置

爱快用户可以通过以下步骤配置 Docker 镜像仓库。首先请参考爱快 Docker 官方文档完成 Docker 的安装。

配置前请确保您已在<a href="https://xuanyuan.cloud/" target="_blank">个人中心</a>获取了免登录镜像仓库地址。 爱快路由推荐使用免登录方式，更加简单便捷。

## 2. 爱快路由 Docker 配置步骤

爱快路由用户可以通过以下步骤配置 Docker 镜像仓库：

### 爱快路由 Docker 镜像仓库配置步骤

点击图片可查看大图:[https://imgs.xuanyuan.run/img/ikuai.jpg](https://imgs.xuanyuan.run/img/ikuai.jpg)

## 3. 详细配置步骤

在爱快路由的 Docker 管理界面中配置镜像仓库：

1. 在<a href="https://xuanyuan.cloud/" target="_blank">个人中心</a>的「用户信息」页面中的「镜像仓库信息」卡片里找到您的免登录镜像仓库地址
2. 复制您的专属免登录地址（格式如：xxx.xuanyuan.run）
3. 在爱快 Docker 管理界面中，按照上图所示配置镜像仓库地址
4. 将复制的免登录地址填入相应的配置项中
5. 保存配置并测试连接

✅ **配置成功提示**：如果测试连接成功，说明配置正确。 之后您就可以通过轩辕镜像仓库快速拉取各种 Docker 镜像了。

💡 **小贴士**：使用免登录地址无需填写用户名和密码，直接配置镜像仓库地址即可。 推荐使用轩辕镜像加速地址获得最佳速度。 如需了解更多爱快 Docker 功能，请参考官方文档。

## 4. 日常使用说明

配置完成后的日常使用方法

### 后续拉取镜像：

1. 在爱快 Docker 管理界面中，进入镜像管理页面
2. 点击"拉取镜像"或"添加镜像"按钮
3. 输入您需要的镜像名称和标签
4. 系统会自动使用配置的轩辕镜像加速服务
5. 等待镜像下载完成

💡 **小贴士**：配置完成后，爱快路由会自动使用轩辕镜像加速服务拉取镜像， 大大提升下载速度和稳定性。您可以在下载过程中看到明显的速度提升。 根据您的网络环境，系统会自动选择最优的加速节点。

## 5. 配置说明

推荐配置：爱快路由用户使用轩辕镜像加速地址， 可获得最佳的国内网络访问速度。

## 6. 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时<a href="https://xuanyuan.cloud/recharge" target="_blank">充值</a>：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

💡 当您登录或拉取镜像时返回 402 Payment Required 错误，表示您的流量已耗尽。请立即<a href="https://xuanyuan.cloud/recharge" target="_blank">充值</a>流量包以继续使用镜像加速服务。
