# 登录配置 Docker 镜像源配置教程

通过 Docker 登录方式配置轩辕镜像服务，享受高速稳定的 Docker 镜像拉取体验

## 1. 注册登录

在本站完成注册并登录，获取镜像仓库账号并[充值流量包](https://xuanyuan.cloud/recharge)后即可开始使用镜像服务。

## 2. 本地客户端登录轩辕镜像服务

打开命令行终端，使用以下命令登录 Docker 账户（以下命令在 Linux、macOS 和 Windows PowerShell 中可用；**Windows CMD 用户请勿给密码加双引号**，见下方分平台说明）：

```bash
echo 镜像密码 | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run
```

> **注意**：**镜像账户**和**镜像密码**可在[登录](https://xuanyuan.cloud/)后，在左侧菜单栏的「个人中心」中的**「用户信息」**页面中的**「镜像仓库信息」**卡片中查看。登录后系统会自动为您创建这些凭据。

### 各平台登录命令详细说明

#### Linux / macOS（Bash）

密码**不含**特殊字符时，请使用 `echo 镜像密码`，**不要**加双引号；仅当密码含空格或需由 shell 转义的特殊字符时，才可用双引号包裹。**请勿使用包含英文冒号（`:`）的镜像密码**，否则可能导致无法登录。

```bash
echo 镜像密码 | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run
```

含特殊字符时示例：

```bash
echo "镜像密码" | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run
```

#### Windows CMD

**不要给密码加双引号**，否则双引号会作为密码的一部分，导致验证失败。密码直接写在 echo 后即可。

```bash
echo 镜像密码 | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run
```

#### Windows PowerShell

PowerShell 中引号不会进入密码，可放心使用。

```powershell
Write-Output "镜像密码" | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run
```

#### 交互式登录（所有平台推荐备选）

按提示输入镜像账户和镜像密码，可避免引号、编码、空格等问题。

```bash
docker login docker.xuanyuan.run
```

> **注意**：使用 `--password-stdin` 方式通过标准输入传递密码，可以避免密码出现在命令历史记录中，更加安全。Linux/macOS 下普通密码勿加双引号，仅当密码含特殊字符时才需用双引号包裹；镜像密码请勿包含英文冒号 `:`。PowerShell 中引号通常不会进入密码。**在 Windows CMD 中不要使用双引号，否则会导致 UNAUTHORIZED，可改用 PowerShell 或交互式登录**。

### 关于凭证保存提示

执行登录命令后，如果看到以下错误提示：

```
Error saving credentials: error storing credentials - err: exit status 1, out: `Cannot autolaunch D-Bus without X11 $DISPLAY`
```

✅ **重要说明：这不是登录失败的错误！**

这个提示的意思是：您的服务器是纯命令行环境（没有图形界面），Docker 尝试使用图形界面的密码保存功能，但找不到图形界面，所以无法保存登录密码。

**但是，这并不影响您使用镜像服务！**即使看到这个提示，您的登录通常已经成功了。

**如何验证登录是否成功？**直接执行一条拉取命令测试即可：

```bash
docker pull docker.xuanyuan.run/library/busybox:latest
```

如果能够正常拉取镜像，说明登录已经成功，您可以正常使用镜像服务，无需处理这个提示。

**专业版用户：**如果您不想看到这个提示，可以使用专属域名方式拉取镜像，无需登录：

```bash
docker pull xxx.xuanyuan.run/镜像路径:标签
```

（请将 `xxx.xuanyuan.run` 替换为您的专属域名，可在控制台左侧菜单栏找到）

## 3. 拉取镜像

使用以下命令拉取您需要的镜像：

```bash
docker pull docker.xuanyuan.run/镜像名:标签
```

示例：

```bash
docker pull docker.xuanyuan.run/mysql:latest
```

> **注意**：**拉取成功后**，如果你想去掉前缀 `docker.xuanyuan.run`，请使用以下命令：

```bash
# 1. 拉取镜像（带轩辕镜像域名）
docker pull docker.xuanyuan.run/library/nginx:1.27.3-alpine

# 2. 打上一个本地新的 tag（去掉域名前缀）
docker tag docker.xuanyuan.run/library/nginx:1.27.3-alpine nginx:1.27.3-alpine

# 3. 删除原来的带域名的 tag（可选）
docker rmi docker.xuanyuan.run/library/nginx:1.27.3-alpine
```

这样就可以去掉 `docker.xuanyuan.run` 域名前缀了。

## 4. 搜索镜像

使用以下命令搜索可用的镜像：

```bash
docker search docker.xuanyuan.run/镜像名
```

示例：

```bash
docker search docker.xuanyuan.run/mysql
```

## 5. 流量耗尽错误提示

当您的流量用尽时，您可能会遇到以下错误。若出现这些情况，请及时[充值流量包](https://xuanyuan.cloud/recharge)以恢复服务：

### 拉取镜像时的错误：

```
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

### 登录时的错误：

```
docker login docker.xuanyuan.run -u 136******88 -p g******U
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Error response from daemon: login attempt to https://docker.xuanyuan.run/v2/ failed with status: 402 Payment Required
```

> **注意**：当您登录或拉取镜像时返回 **402 Payment Required** 错误，表示您的流量已耗尽。请立即[充值流量包](https://xuanyuan.cloud/recharge)以继续使用镜像服务。

## 6. UNAUTHORIZED 登录失败

当您确认使用的是本站"镜像仓库信息"里的镜像账号和镜像密码，但仍提示 **UNAUTHORIZED** 时，通常是本地缓存凭据导致的。

### 错误示例：

```
echo 镜像密码 | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run
Error response from daemon: Get "https://docker.xuanyuan.run/v2/": unauthorized: {"errors":[{"code":"UNAUTHORIZED","message":"您好，用户名或密码验证失败，请检查后重试。请确认您使用的是轩辕镜像官网（https://xuanyuan.cloud）的账号和密码，而非 Docker Hub 的凭据。","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

### 问题原因：

Docker 会在本地保存登录 credential。若您之前登录过该域名、后续又修改了密码，本地旧凭据可能仍被优先使用，导致看起来"账号密码正确但仍认证失败"。

**Windows CMD 用户注意：**若使用 `echo "镜像密码"`，双引号会作为密码的一部分发送，导致服务器校验失败出现 UNAUTHORIZED。请使用无引号的 `echo 镜像密码`，或改用 PowerShell / 交互式登录。

**Linux / macOS 用户注意：**普通密码勿随意加双引号；若镜像密码含英文冒号 `:`，也可能导致登录失败，请在个人中心修改密码后重试。

另外请确认：这里必须使用轩辕镜像官网（`https://xuanyuan.cloud`）中的镜像账号和镜像密码，而不是 Docker Hub 账号密码。

### 解决方案：

先清理本地缓存凭据，再重新登录即可。

```bash
# 1. 退出当前域名登录状态
docker logout docker.xuanyuan.run

# 2. 删除 Docker 本地凭据配置
rm -rf ~/.docker/config.json

# 3. 按网站镜像仓库信息重新登录（Windows CMD 下请勿在密码外加双引号）
echo 镜像密码 | docker login -u 镜像账户 --password-stdin docker.xuanyuan.run
```

如果仍然失败，可直接使用**交互式登录**避免 CMD 引号或 `echo` 管道带来的编码、换行或隐藏空格问题：执行 `docker login docker.xuanyuan.run`，按提示输入账户与密码。

- 执行 `docker login docker.xuanyuan.run` 进行交互式登录
- 避免复制粘贴带空格，建议手敲账号和密码再试一次
- 再次确认使用的是官网 `xuanyuan.cloud` 的账号，而非 Docker Hub 账号

交互式登录成功示例：

```
docker login docker.xuanyuan.run
Username: 18********8
Password:
Login Succeeded
```

## 7. 410 错误问题

当您遇到 410 Gone 错误时，这通常是由于 Docker 版本过低导致的协议不兼容问题。

### 错误示例：

```
[root@nats1 ~]# docker login -u 1585**** -p **** docker.xuanyuan.run
Login Succeeded
[root@nats1 ~]# docker pull docker.xuanyuan.run/structurizr/lite:latest
Trying to pull repository docker.xuanyuan.run/structurizr/lite ... 
Pulling repository docker.xuanyuan.run/structurizr/lite
Error: Status 410 trying to pull repository structurizr/lite: "<html>\r\n<head><title>410 Gone</title></head>\r\n<body>\r\n<center><h1>410 Gone</h1></center>\r\n<hr><center>openresty</center>\r\n</body>\r\n</html>\r\n"
```

### 问题原因：

Docker 1.x 或较低版本的 Docker 17.x/18.x 默认仅支持 Registry V1 协议，而本站镜像仓库仅支持 Registry V2 协议。当客户端尝试使用不兼容的 V1 协议访问时，会返回 410 Gone 错误。

### 解决方案：

请将 Docker 升级至 20.x 或更高版本，以支持 V2 协议。

参考 [Linux Docker 安装与升级教程](https://xuanyuan.cloud/install/linux)

升级完成后，使用 `docker info` 检查版本，重新执行登录与拉取命令即可正常使用。

## 8. manifest unknown 错误

当您遇到 manifest unknown 错误时，这表示镜像仓库中不存在指定的镜像名或标签（tag）。

### 错误示例：

```
root@btpanel:~# docker pull docker.xuanyuan.run/nodebb/nodebb:latest
Error response from daemon: manifest for docker.xuanyuan.run/nodebb/nodebb:latest not found: manifest unknown: manifest unknown
```

### 问题原因：

manifest unknown 表示镜像仓库中不存在指定的镜像名或标签（tag）。

常见原因包括：

- 镜像名称拼写错误
- 指定的标签（tag）不存在
- 镜像已被删除或下架

### 解决方案：

请先在本站镜像仓库页面搜索该镜像，确认镜像名与**标签（tag）**是否正确。

使用页面提供的完整拉取命令执行 docker pull。

**示例：**

假设网站查询到正确的镜像信息为：

- 镜像名：[elestio/nodebb](https://xuanyuan.cloud/r/elestio/nodebb)
- 标签：`v4.4.6`

则拉取命令为：

```bash
docker pull docker.xuanyuan.run/elestio/nodebb:v4.4.6
```
