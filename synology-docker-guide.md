# 群晖NAS使用轩辕镜像配置Docker加速

在群晖NAS中配置Docker使用轩辕镜像加速服务，享受高速稳定的镜像拉取体验

## 快速跳转

- [群晖 NAS 使用 Docker Compose 教程](#群晖nas使用docker-compose教程)
- [群晖 NAS Docker 镜像加速配置](#群晖-nas-docker-镜像加速配置)

## 群晖 NAS Docker 镜像加速配置

群晖 NAS 用户可以通过配置 Docker 镜像仓库来使用镜像加速服务。请按照下方步骤进行操作，配置完成后即可享受高速的镜像拉取服务。

配置前请确保您已在个人中心获取了镜像账户和密码。群晖NAS推荐使用登录方式，提供更好的安全性和稳定性。

## 群晖 NAS Docker 配置步骤

群晖 NAS 用户可以通过以下步骤配置 Docker 镜像仓库：

### 群晖 NAS Docker 镜像仓库配置步骤（操作图片）

![群晖NAS Docker配置](https://imgs.xuanyuan.run/img/synology-docker-0516.jpg)

## 详细配置步骤

在群晖 NAS 的 Docker 应用中配置镜像仓库：

1. 打开群晖 DSM 控制面板
2. 进入"套件中心"，安装 Docker 套件（如果尚未安装）
3. 打开 Docker 应用
4. 点击左侧的"注册表"
5. 点击右上角的"设置"按钮
6. 在设置窗口中，点击"添加"按钮
7. 填写注册表信息：
   - **注册表 URL**：`docker.xuanyuan.run`
   - **用户名**：您的镜像账户（在个人中心的「用户信息」页面查看）
   - **密码**：您的镜像密码（在个人中心的「用户信息」页面查看）
8. 点击"测试连接"确认配置正确
9. 点击"保存"完成配置

✅ **配置成功提示**：如果测试连接成功，说明配置正确。之后您就可以通过轩辕镜像仓库快速拉取各种 Docker 镜像了。

💡 **小贴士**：使用轩辕镜像加速地址：
- 登录地址：`docker.xuanyuan.run`

## 日常使用说明

配置完成后的日常使用方法

### 后续拉取镜像：

1. 在 Docker 应用中，点击左侧的"映像"
2. 点击右上角的"添加"按钮
3. 选择"从 Docker Hub 添加"
4. 在搜索框中输入镜像名称
5. 选择需要的镜像版本
6. 点击"选择"开始下载

💡 **小贴士**：配置完成后，群晖 NAS 会自动使用轩辕镜像加速服务拉取镜像，大大提升下载速度和稳定性。您可以在下载过程中看到明显的速度提升。

## 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时充值：

```bash
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

💡 当您登录或拉取镜像时返回 402 Payment Required 错误，表示您的流量已耗尽。请立即充值流量包以继续使用镜像加速服务。

## 群晖NAS使用Docker Compose教程

群晖DMS7.2版本后将自己的Docker改名容器服务，套件中心里叫「Container Manager」。虽然提供了图形界面，但终端设置不生效，如需使用docker compose等命令，需要手动编辑配置文件。

**版本说明**：DMS7.2+版本中，Docker套件已更名为「Container Manager」，旧版系统请将配置文件路径中的ContainerManager替换为Docker。

### 配置文件路径：

- **DMS7.2+版本**：`/var/packages/ContainerManager/etc/dockerd.json`
- **旧版系统**：`/var/packages/Docker/etc/dockerd.json`

### 查看当前配置：

首先查看现有的配置文件内容：

**DMS7.2+版本**
```bash
sudo cat /var/packages/ContainerManager/etc/dockerd.json
```

**旧版系统**
```bash
sudo cat /var/packages/Docker/etc/dockerd.json
```

### 配置示例：

当前配置文件可能包含多个镜像源，建议保留默认设置，仅修改registry-mirrors部分：

**推荐配置**
```json
{
    "registry-mirrors": [
        "https://xxx.xuanyuan.run"
    ],
    "data-root": "/var/packages/ContainerManager/var/docker",
    "log-driver": "db",
    "storage-driver": "btrfs"
}
```

> **注意**：请将 `xxx.xuanyuan.run` 替换为您的免登录域名

### 重启Docker服务：

修改配置文件后，需要重启Docker服务使配置生效：

**DMS7.2+版本**
```bash
/var/packages/ContainerManager/scripts/start-stop-status stop
/var/packages/ContainerManager/scripts/start-stop-status start
```

**旧版系统**
```bash
/var/packages/Docker/scripts/start-stop-status stop
/var/packages/Docker/scripts/start-stop-status start
```

✅ **配置验证**：重启服务后，您就可以在终端中使用 docker compose 等命令，并且会自动使用轩辕镜像加速服务，享受丝滑的Docker操作体验。
