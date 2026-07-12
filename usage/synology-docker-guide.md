# 群晖 NAS Docker 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/synology

在群晖 NAS 中配置 Docker 使用轩辕镜像服务，享受高速稳定的镜像拉取体验。

**快速跳转：** [群晖 NAS 使用 Docker Compose 教程](#群晖nas使用docker-compose教程) | [注册表查询失败排查](#container-manager-注册表查询失败排查)

## 目录

- [Docker 镜像配置](#docker-镜像配置)
- [Docker 配置步骤](#docker-配置步骤)
- [详细配置步骤](#详细配置步骤)
- [日常使用说明](#日常使用说明)
- [流量耗尽错误提示](#流量耗尽错误提示)
- [Docker Compose 教程](#群晖nas使用docker-compose教程)
- [注册表查询失败排查](#container-manager-注册表查询失败排查)

## Docker 镜像配置

群晖 NAS 用户可以通过配置 Docker 镜像仓库来使用镜像服务。请按照下方步骤进行操作，配置完成后即可享受高速的镜像拉取服务。

> 配置前请确保您已 [登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fsynology) 网站，并在左侧菜单栏的「个人中心」中获取了您的**专属域名**。群晖 NAS 推荐使用专属域名配置，无需账号密码验证，配置更简单方便。

## Docker 配置步骤

群晖 NAS 用户可以通过以下步骤配置 Docker 镜像仓库：

![群晖 NAS Docker 镜像仓库配置步骤](https://img.xuanyuan.dev/docker/synology-docker-0516.jpg)

> **推荐配置：** 我们的专属域名已全面支持群晖系统，推荐用户默认使用专属域名（如 `***.xuanyuan.run`）进行配置，无需填写账号密码验证，配置更简单方便。

## 详细配置步骤

在群晖 NAS 的 Docker 应用中配置镜像仓库：

1. 打开群晖 DSM 控制面板
2. 进入"套件中心"，安装 Docker 套件（如果尚未安装）
3. 打开 Docker 应用
4. 点击左侧的"注册表"
5. 点击右上角的"设置"按钮
6. 在设置窗口中，点击"添加"按钮
7. 填写注册表信息（两种方式任选其一）：

   **✅ 方式一：使用专属域名（推荐）**

   - **注册表 URL：** 填写您的专属域名 `***.xuanyuan.run`（[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fsynology) 后，在左侧菜单栏的「个人中心」中查看）
   - **用户名 / 密码：** 留空即可，无需填写

   **🔑 方式二：使用通用域名**

   - **注册表 URL：** 填写 `docker.xuanyuan.run`
   - **用户名：** 您在轩辕镜像网站的**镜像账户**
   - **密码：** 您在轩辕镜像网站的**镜像密码**（如忘记密码，可 [登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fsynology) 后在「个人中心」中重新设置）

8. 点击"测试连接"确认配置正确
9. 点击"保存"完成配置

> **配置成功提示：** 如果测试连接成功，说明配置正确。之后您就可以通过轩辕镜像仓库快速拉取各种 Docker 镜像了。

> **小贴士：** 推荐使用您的专属域名配置：
>
> • 专属域名：`***.xuanyuan.run`（请替换为您的实际专属域名）

## 日常使用说明

配置完成后的日常使用方法。

### 后续拉取镜像

1. 保存镜像仓库配置后，在 Docker 应用左侧进入「镜像仓库」。
2. 在页面右上角搜索框输入关键词（例如要拉取 `vllm/vllm-openai`，可输入 `vllm`），在结果列表中选中目标镜像（一般为名称最匹配的第一条）。
3. 在目标镜像上右键，选择「下载此映像」。
4. 在标签栏填写要拉取的标签：多数镜像可填 `latest`；若该仓库没有 `latest`，请改为填写镜像在仓库中实际存在的标签（如具体版本号）。

> **小贴士：** 配置完成后，群晖 NAS 会自动使用轩辕镜像服务拉取镜像，大大提升下载速度和稳定性。您可以在下载过程中看到明显的速度提升。

## 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时 [充值](https://xuanyuan.cloud/recharge)：

```
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

当您登录或拉取镜像时返回 **402 Payment Required** 错误，表示您的流量已耗尽。请立即 [充值流量包](https://xuanyuan.cloud/recharge) 以继续使用镜像服务。

## 群晖NAS使用Docker Compose教程

群晖 DSM 7.2 版本后将自己的 Docker 改名容器服务，套件中心里叫「Container Manager」。虽然提供了图形界面，但终端设置不生效，如需使用 docker compose 等命令，需要手动编辑配置文件。

> **版本说明：** DSM 7.2+ 版本中，Docker 套件已更名为「Container Manager」，旧版系统请将配置文件路径中的 ContainerManager 替换为 Docker。

### 配置文件路径

- **DMS7.2+ 版本：** `/var/packages/ContainerManager/etc/dockerd.json`
- **旧版系统：** `/var/packages/Docker/etc/dockerd.json`

### 查看当前配置

首先查看现有的配置文件内容：

**DMS7.2+ 版本：**

```bash
sudo cat /var/packages/ContainerManager/etc/dockerd.json
```

**旧版系统：**

```bash
sudo cat /var/packages/Docker/etc/dockerd.json
```

### 配置示例

当前配置文件可能包含多个镜像源，建议保留默认设置，仅修改 registry-mirrors 部分：

```json
{
    "registry-mirrors": [
        "https://***.xuanyuan.run"
    ],
    "data-root": "/var/packages/ContainerManager/var/docker",
    "log-driver": "db",
    "storage-driver": "btrfs"
}
```

> **注意：** 请将 `***.xuanyuan.run` 替换为您的专属域名

### 重启 Docker 服务

修改配置文件后，需要重启 Docker 服务使配置生效：

**DMS7.2+ 版本：**

```bash
/var/packages/ContainerManager/scripts/start-stop-status stop
/var/packages/ContainerManager/scripts/start-stop-status start
```

**旧版系统：**

```bash
/var/packages/Docker/scripts/start-stop-status stop
/var/packages/Docker/scripts/start-stop-status start
```

> **配置验证：** 重启服务后，您就可以在终端中使用 `docker compose` 等命令，并且会自动使用轩辕镜像服务，享受丝滑的 Docker 操作体验。

## Container Manager 注册表查询失败排查

当群晖 Container Manager 无法正常查询注册表时，通常是网络连通性问题导致。本模块提供系统性的排查思路和解决方案，帮助您快速恢复镜像拉取功能。

> **问题本质：** Container Manager 注册表查询失败本质上还是群晖 Docker 网络连通性问题，因此解决方案主要集中在如何让群晖 Docker 正常连接到镜像源。

### 1. 检查代理设置

确认群晖网络没有配置或开启代理，由于轩辕镜像专业版采用国内地址，因此务必关闭网络代理。

**操作步骤：**

1. 进入 DSM 控制面板
2. 打开"网络"设置
3. 检查"代理服务器"配置
4. 确保代理功能已关闭

### 2. 修改 DNS 设置

控制面板——网络——手动配置 DNS 服务器，在里面填写国内公用 DNS，一般用阿里的或者 114。

| DNS 服务 | 地址 |
| --- | --- |
| 阿里 DNS | 223.5.5.5 |
| 114 DNS | 114.114.114.114 |

**操作步骤：**

1. 控制面板 → 网络
2. 选择网络接口（通常是"局域网1"）
3. 点击"编辑"按钮
4. 选择"手动配置 DNS 服务器"
5. 输入上述 DNS 地址
6. 点击"确定"保存设置

### 3. SSH 命令行测试

如果前两步完成后 Docker 注册表仍然无法正常使用，可以通过 SSH 登录群晖，用命令行拉取测试。虽说在图形界面无法加载，但是通过 SSH 可以顺利拉取镜像，只要能够顺利拉取镜像，再在图形界面进行部署，就方便多了。

**启用 SSH 功能：**

1. 控制面板 → 终端机和 SNMP
2. 勾选"启用 SSH 服务"
3. 设置端口（默认 22）
4. 点击"应用"保存设置

**SSH 连接和镜像拉取：**

1. **连接群晖：** 使用 PuTTY 或其他终端软件登录到 NAS
2. **获取权限：** 输入 `sudo -i` 获取 root 权限
3. **拉取镜像：** 输入拉取命令测试连接

```bash
docker pull ***.xuanyuan.run/mysql
```

示例：拉取 MySQL 镜像（请将 `***.xuanyuan.run` 替换为您的专属域名）

> **成功标志：** 如果命令行拉取成功，返回 NAS 的 Docker 映像页面，您会发现刚才拉取的镜像已经在里面了，接下来就可以愉快地通过图形界面进行容器的安装。

> **仍无法解决？** 如果命令行拉取也出现异常，请保留具体报错截图，[提交工单](https://xuanyuan.cloud/tickets?tab=create) 联系我们技术客服帮您解决。
