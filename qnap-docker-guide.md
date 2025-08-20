# 威联通 NAS Docker 加速 - 轩辕镜像配置手册

在威联通NAS中配置Container Station使用轩辕镜像加速服务，享受高速稳定的镜像拉取体验

## 1. 威联通 NAS Container Station 镜像仓库配置

威联通 NAS 用户可以通过 Container Station 配置自定义镜像仓库来使用镜像加速服务。 请按照下方步骤进行操作，配置完成后即可享受高速的镜像拉取服务。

配置前请确保您已在[个人中心](https://xuanyuan.cloud/)获取了免登录镜像仓库地址。 威联通NAS推荐使用免登录方式，更加简单便捷。

## 2. 第一步：配置自定义存储库

在 Container Station 中添加自定义镜像存储库

1. 打开威联通 QTS 控制面板
2. 进入"App Center"，安装 Container Station（如果尚未安装）
3. 打开 Container Station，点击左侧的"存储库"
4. 找到"自定义存储库"区域，点击"添加"按钮
5. 在弹出的配置窗口中：
   - 提供商：选择"其他"
   - 名称：填写"[轩辕镜像](https://xuanyuan.cloud/)"（或您喜欢的名称）
   - URL：填写您的免登录镜像仓库地址，如：
     • abc123def456.xuanyuan.run - 轩辕镜像加速地址
6. 点击"测试连接"验证配置是否正确
7. 测试成功后，点击"应用"保存配置

![威联通NAS Container Station自定义存储库配置](https://imgs.xuanyuan.run/img/weiliantong.jpg)

> ✅ **配置成功提示**：如果测试连接成功，说明自定义存储库配置正确。 之后您就可以通过轩辕镜像存储库快速拉取各种 Docker 镜像了。

## 3. 第二步：测试镜像拉取

验证自定义存储库配置是否正常工作

1. 在 Container Station 中，点击左侧的"映像"
2. 点击右上角的"提取"按钮
3. 在提取映像窗口中：
   - 模式：选择"基本模式"
   - 存储库：从下拉菜单中选择"[轩辕镜像](https://xuanyuan.cloud/)"
   - 映像：填写要拉取的镜像名称，如 jellyfin/jellyfin
   - 勾选"将存储库设置为默认设置"（可选，方便后续使用）
4. 点击"提取"开始下载镜像

![威联通NAS Container Station镜像提取配置](https://imgs.xuanyuan.run/img/weiliantong2.jpg)

## 4. 日常使用说明

配置完成后的日常使用方法

**后续拉取镜像：**
1. 进入 Container Station → 映像 → 提取
2. 存储库选择"[轩辕镜像](https://xuanyuan.cloud/)"
3. 输入要拉取的镜像名称
4. 点击提取即可享受加速服务

💡 **小贴士**：建议勾选"将存储库设置为默认设置"， 这样后续拉取镜像时会自动使用[轩辕镜像](https://xuanyuan.cloud/)加速服务，无需每次手动选择。 配置完成后，威联通 NAS 会自动使用[轩辕镜像](https://xuanyuan.cloud/)加速服务拉取镜像， 大大提升下载速度和稳定性。

**加速服务说明：**
• [轩辕镜像](https://xuanyuan.cloud/)加速地址：适合中国大陆用户，访问速度更快

## 5. 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时充值：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

💡 当您登录或拉取镜像时返回 402 Payment Required 错误，表示您的流量已耗尽。请立即充值流量包以继续使用镜像加速服务。

## ❓ 常见问题解答

### 🐳 Q: 为什么配置后显示"存储库提供商不匹配"？

**问题现象：**

在威联通 Container Station 中配置自定义存储库后，拉取镜像时出现"存储库提供商不匹配"错误，导致无法正常使用镜像加速服务。

**解决方案：**

#### 1. 检查 DNS 配置
将威联通 NAS 的 DNS 服务器地址修改为：114.114.114.114 和 223.5.5.5

#### 2. 确认免登录地址流量状态
检查您的专属免登录地址是否有可用流量。如果地址没有购买流量，Docker 客户端请求时会返回 402 Payment Required 错误，威联通系统会认为该代理地址不可用，因而显示 "存储库提供商不匹配" 的错误。

**解决方案：** 请前往充值页面购买相应的流量包，确保您的免登录地址有足够的流量支持镜像拉取服务。

#### 3. SSH 命令行验证
如果上述方法无法解决，请通过 SSH 登录威联通 NAS，执行以下命令验证：

```bash
docker pull abc123def456.xuanyuan.run/mysql
```

如果正常拉取，说明免登录地址可用且有流量；如果无法拉取，请根据具体报错信息进行排查。

💡 **提示**： 如无法自行解决，请前往官方QQ群：51517718寻求技术支持。
