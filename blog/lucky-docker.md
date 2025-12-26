# Lucky Docker 部署文档

![Lucky Docker 部署文档](https://img.xuanyuan.dev/docker/blog/docker-lucky.png)

*分类: Docker,lucky | 标签: lucky,docker,部署教程 | 发布时间: 2025-10-07 14:07:06*

> Lucky最初是作为一个小工具，由开发者为自己的个人使用而开发，用于替代socat，在小米路由AX6000官方系统上实现公网IPv6转内网IPv4的功能。Lucky的设计始终致力于让更多的Linux嵌入式设备运行，以实现或集成个人用户常用功能，降低用户的硬件和软件操作学习成本，同时引导使用者注意网络安全。随着版本更新和网友反馈，Lucky不断迭代改进，拥有更多功能和更好的性能，成为用户值得信赖的工具。

## 🧰 准备工作

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

## 1. Lucky 简介
Lucky最初是作为一个小工具，由开发者为自己的个人使用而开发，用于替代socat，在小米路由AX6000官方系统上实现公网IPv6转内网IPv4的功能。Lucky的设计始终致力于让更多的Linux嵌入式设备运行，以实现或集成个人用户常用功能，降低用户的硬件和软件操作学习成本，同时引导使用者注意网络安全。随着版本更新和网友反馈，Lucky不断迭代改进，拥有更多功能和更好的性能，成为用户值得信赖的工具。


## 2. Lucky 核心技术
- **核心程序**：完全采用 Golang 实现，具有高效、稳定、跨平台等优点。
- **后台前端**：采用 Vue3.2 技术开发，具有良好的用户体验和响应访问表现。
- **架构设计**：管理后台采用前后端分离架构，第三方开发者可通过 OpenToken 轻松调用 Lucky 的各种功能接口。


## 3. 安装运行&升级备份

### 3.1 Lucky 和万吉(wanji)版本的区别
| 版本类型       | 功能说明                                                                 | 适用场景                     |
|----------------|--------------------------------------------------------------------------|------------------------------|
| Lucky 轻量版   | 包含常用模块：动态域名、Web 服务、端口转发、STUN 穿透、计划任务、证书管理（ACME）、网络唤醒、FTP 服务、WebDAV 服务等。 | 资源有限的路由器，满足日常使用 |
| 万吉（Wanji）全能版 | 在 Lucky 基础功能上增加：grpc 反向代理支持、CorazaWAF、rclone、filebrowser、DLNA 服务、CloudFlare tunnel 客户端等功能。 | 硬件资源允许，需全面功能支持 |
| Core 精简版    | 移除前端文件，二进制体积较标准版缩小约 1 MB。                           | 存储空间有限的路由器（非推荐首选） |

> 说明：Docker 版本为万吉版，GitHub 主要发布 Lucky 版，配置文件通用；其他版本需自行通过网盘下载，在 Lucky 后台升级替换。


### 3.2 外网无法访问 Lucky 的解决方法
1. 在 **配置目录** 下创建 `localips` 文件。
2. 将实际的 **内网 IP 网段** 或 **特定内网 IP** 填入该文件，每行一条记录。

> 注意：当 `localips` 文件不为空时，系统将忽略默认内置网段。

**默认内置内网网段**：
- 10.0.0.0/8
- 172.16.0.0/12
- 169.254.0.0/16
- 192.168.0.0/16


### 3.3 安装 Lucky
> 提示：不同安装方式可能存在冲突，切换安装方式前请先卸载干净之前的版本。其中：
> - 一键安装方式的卸载：再次执行安装指令，选择选项 2 完成卸载。
> - OpenWrt IPK 包的卸载：依次执行以下三条指令：
>   ```bash
>   opkg remove lucky
>   opkg remove luci-i18n-lucky-zh-cn
>   opkg remove luci-app-lucky
>   ```

#### 3.3.1 OpenWrt IPK 包
- **官方 IPK 包源码地址**：https://github.com/gdy666/luci-app-lucky

##### 警告
1. 使用自定义 OpenWrt 固件编译时，需手动勾选 `luci-app-lucky` 和 `lucky` 包，才能在编译后的固件中包含 Lucky。
2. 安装官方 Lucky IPK 包前，必须完全卸载所有第三方 Lucky IPK 包，否则可能无法启动 Lucky；同时需确保已删除 `/etc/config/lucky` 和 `/etc/init.d/lucky`。若此前通过一键脚本安装，需先执行脚本并选择选项 2 卸载。

##### IPK 包下载安装步骤
1. 打开 Releases 页面：https://github.com/gdy666/luci-app-lucky/releases
2. 先安装与 CPU 架构对应的 Lucky 核心 IPK 包。
3. 再安装最新的 `luci-app-lucky_XXX_all.ipk` 和 `luci-i18n-lucky-zh-cn_XXX_all.ipk`。


#### 3.3.2 Docker 镜像
##### Docker Run 命令
1. **Host 模式（推荐 Linux 系统，支持 IPv4/IPv6）**：
   ```bash
   docker run -d --name lucky --restart=always --net=host xxx.xuanyuan.run/gdy666/lucky
   ```
2. **桥接模式（仅支持 IPv4，不推荐 Windows 使用）**：
   ```bash
   docker run -d --name lucky --restart=always -p 16601:16601 xxx.xuanyuan.run/gdy666/lucky
   ```
3. **挂载主机目录（配置持久化，删除容器后配置不丢失）**：
   ```bash
   docker run -d --name lucky --restart=always --net=host -v /root/luckyconf:/goodluck xxx.xuanyuan.run/gdy666/lucky
   ```
   > 注意：Lucky 在 Docker 容器内部的配置文件夹路径为 `/goodluck`，可将 `/root/luckyconf` 替换为自定义主机目录，配置文件为 `lucky.conf`。

##### Docker Compose 配置
```yaml
services:
  lucky:
    image: xxx.xuanyuan.run/gdy666/lucky
    container_name: lucky
    volumes:
      - 容器外持久化路径:/goodluck  # 替换为实际主机路径
    network_mode: host
    restart: always
```

##### Unraid 带图标配置
```yaml
services:
  lucky:
    image: xxx.xuanyuan.run/gdy666/lucky
    container_name: lucky
    labels:
      net.unraid.docker.icon: "![icon](https://cdn.jsdelivr.net/gh/IceWhaleTech/CasaOS-AppStore@main/Apps/Lucky/icon.png)"
      net.unraid.docker.webui: "http://[IP]:[PORT:16601]"  # 替换 [IP] 为设备IP
    volumes:
      - 容器外持久化路径:/goodluck  # 替换为实际主机路径
    network_mode: host
    restart: always
```

##### 提示与警告
- **提示**：在 Docker 安装的 Lucky 环境中，部分场景支持直接在后台上传 `tar.gz` 升级包升级；若不支持，需在映射的 `/goodluck` 目录下创建 `bin` 文件夹，将升级包中的 `lucky` 文件放入 `bin` 并重启容器（`bin` 目录下的程序优先于容器内置程序）。若升级无效，可删除或替换 `bin` 目录下的 `lucky` 文件。
- **警告 1（Linux 环境）**：不推荐使用 bridge 模式，该模式下 Lucky 不支持 IPv6，且 IPv4 可能出现端口无法访问问题；若遇端口问题，可尝试 host 模式或更换端口；若非必要，建议不使用 Docker 安装。
- **警告 2（Windows 环境）**：不推荐 Docker 安装，建议通过“安装服务”实现开机自启。在 Lucky 后台设置页面底部可找到“安装/卸载 Windows 服务”选项；安装前需将 Lucky 文件放在目标路径，且安装服务需管理员权限运行 Lucky；服务形式启动的 Lucky 无系统托盘图标，需通过后台设置页面卸载服务。


#### 3.3.3 Linux Docker & Docker Compose 一键安装
##### 一键安装配置脚本
- **推荐方案**：一键安装配置脚本
- **脚本功能**：支持多种 Linux 发行版，一键安装 Docker、Docker Compose，且一键配置轩辕镜像访问支持源。
- **执行命令**：
  ```bash
  bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
  ```


#### 3.3.4 自动脚本安装
##### 前置条件提示
1. 确认路由器已开启 SSH 并获取 root 权限（带 GUI 的 Linux 设备可使用自带终端）。
2. 使用 SSH 工具（如 putty、JuiceSSH、系统终端）连接设备，切换到 root 用户。
3. 确认设备已安装 `curl` 或 `wget`；若为 OpenWrt 设备（小米官方系统、潘多拉、高恪等），需先安装 `curl`：
   ```bash
   opkg update && opkg install curl  # 已安装可忽略
   ```

##### 安装命令（任选其一）
> 提示：升级新版本只需重新运行安装指令，安装完成后在后台设置页面重启程序即可；若无法连接或出现 SSL 错误，可尝试更换安装源。
1. ```bash
   URL="http://release.66666.host"; curl -o /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
   ```
2. ```bash
   URL="http://release.66666.host"; wget -O  /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
   ```
3. ```bash
   URL="https://release.66666.host"; curl -o /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
   ```
4. ```bash
   URL="https://release.66666.host"; wget -O  /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
   ```


#### 3.3.5 半自动离线脚本安装方法
1. 将 `daji.sh` 下载并上传到 `/tmp/` 目录。
2. 执行以下命令赋予脚本执行权限：
   ```bash
   chmod +x daji.sh
   ```
3. 运行脚本查看当前 CPU 架构：
   ```bash
   sh daji.sh
   ```
4. 根据 CPU 架构，从 GitHub 或网盘/Q群下载对应的 `lucky.tar.gz` 包，上传到 `/tmp` 目录。
5. 再次执行 `sh daji.sh`，选择选项 1 并按提示完成安装。

##### 警告
大部分设备/系统已预装以下依赖，无影响可忽略：
- 必须依赖：`bash/ash`（全部缺少时无法安装运行脚本）、`curl/wget`（全部缺少时无法在线安装更新及使用节点保存功能）。
- 一般依赖：`systemd/rc.common`（全部缺少时只能使用保守模式，可能无法设置开机自启）。


#### 3.3.6 手动运行
> 提示：适用于不兼容其他安装方式的系统环境。

1. 下载与 Linux 系统匹配的 `tar.gz` 包，解压出 `lucky` 核心程序，复制到目标路径。
2. 赋予执行权限并启动（以路径 `/usr/local/bin/lucky`、配置文件 `/etc/lucky/lucky.conf` 为例）：
   ```bash
   # 赋予执行权限
   chmod +x /usr/local/bin/lucky
   # 启动 Lucky
   /usr/local/bin/lucky -c /etc/lucky/lucky.conf
   ```
3. Windows 版：直接双击 `lucky` 程序即可运行。


### 3.4 启动方式与参数
> 信息：若已通过 OpenWrt IPK 包、一键脚本、Docker 或固件自带方式安装 Lucky，可跳过本小节。

#### 启动方式
Lucky 仅需单个可执行文件，熟悉 Linux 系统可将 `lucky` 二进制文件放在任意路径。

#### 启动参数
| 参数                | 功能说明                                                                 | 版本要求                |
|---------------------|--------------------------------------------------------------------------|-------------------------|
| `-c <配置文件路径>`  | 指定配置文件位置，支持相对/绝对路径；若配置文件不存在则自动创建。         | 全版本                  |
| `-cd <配置目录路径>` | 指定配置文件存放文件夹（仅绝对路径）；2.x 版本兼容 `-c` 参数，会从 1.0 配置文件路径提取配置目录。 | 2.x 版本                |
| `-rCancelSafeURL`    | 取消安全入口。                                                           | 2.10.0 及以上（需进程正常运行，无需指定配置目录） |
| `-rDisable2FA`       | 禁用 2FA 验证。                                                          | 2.10.0 及以上           |
| `-rResetUser`        | 重置用户账号密码为 `666：666`。                                          | 2.10.0 及以上           |
| `-rRestart`          | 重启 Lucky。                                                             | 2.10.0 及以上           |
| `-rSetHttpAdminPort` | 设置 Lucky 后台 HTTP 访问端口。                                          | 2.10.0 及以上           |
| `-rSetHttpsAdminPort`| 设置 Lucky 后台 HTTPS 访问端口。                                         | 2.10.0 及以上           |
| `-rUnlock`           | 立即解锁登录限制，无需重启 Lucky。                                       | 2.10.0 及以上           |

> 提示：Windows 环境下双击运行 Lucky 时，默认将配置文件指定为程序所在目录的 `lucky.conf`；初次使用时配置文件会自动创建，无需理会日志中“未指定配置文件路径，使用默认路径”的提示。


### 3.5 默认登录信息
- **默认登录地址**：http://{IP地址}:16601（替换 `{IP地址}` 为设备实际 IP）
- **默认账号**：666
- **默认密码**：666

> 提示：
> 1. 从版本 2.13.9 开始，默认配置中外网访问开关关闭；但 `lucky_base.lkcf` 配置初始化后十分钟内允许外网访问，若十分钟内保存配置，外网访问开关设置优先生效；若错过时间，需删除 `lucky_base.lkcf` 并重启 Lucky 重新初始化。
> 2. 从版本 2.13.9 开始，未设置安全入口或未修改默认账号密码时，无法使用所有功能模块；若确需跳过设置，可在设置面板启用“禁用安全入口设置检查”和“禁用默认账号密码检查”（两个选项会闪烁提示）。
> 3. 从版本 2.15.8 开始，可通过配置目录下的 `localips` 文件记录 IP/网段（每行一条）；该文件不为空时，默认内置网段失效，无需重启 Lucky。


### 3.6 使用 Lucky 前的重要提醒
1. **立即修改用户名和密码**。
2. **设置 Lucky 后台安全入口**。
3. **定时备份 Lucky 配置**。

> 提示：Lucky 支持自定义脚本运行，但账号密码和后台入口泄露可能导致严重后果。设置安全入口后，访问 http://{IP}:16601 不会显示登录页，需访问 http://{IP}:16601/{安全入口}（例：安全入口为 666 时访问 http://{IP}:16601/666）；建议将安全入口设置复杂，并在外网访问时使用 HTTPS。


### 3.7 2.0 版本配置注意
- 2.0 版本各模块配置分离，但恢复配置时支持以下格式：
  1. 导入 1.x 版本备份的 `xx.conf` 文件（**注意：2.8 版本后不再支持 1.0 配置**）。
  2. 导入 2.X 版本备份的 `xx.zip` 文件。
  3. 导入 2.X 版本备份 `xx.zip` 中的单个模块配置 `XX.lkcf`（仅恢复指定模块，不可修改文件名）。


### 3.8 升级 Lucky
> 提示：在大多数环境（包括 Docker、Windows 服务形式）中，可通过 Lucky 后台页面上传对应系统的 `XXX.tar.gz` 升级包完成升级；若个别环境（如部分 Docker）升级失败，需备份配置后重新安装最新版本。


### 3.9 备份还原配置
> 提示：在 Lucky 的设置页面底部，可直接执行备份和恢复配置操作；建议定期备份，并在每次升级前备份配置，确保数据安全。

