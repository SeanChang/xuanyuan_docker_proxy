---
image: gnzsnz/ib-gateway
description: "无需人工交互在Docker容器中运行Interactive Brokers Gateway应用的镜像，包含IB Gateway、IBC（模拟用户输入）、Xvfb（虚拟显示）、x11vnc（可选VNC服务）和socat（TCP转发），支持API连接和自动化交易。"
source: https://xuanyuan.cloud/zh/r/gnzsnz/ib-gateway
canonical: https://xuanyuan.cloud/zh/r/gnzsnz/ib-gateway
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gnzsnz/ib-gateway" title="gnzsnz/ib-gateway Docker 镜像中文简介、标签列表与拉取命令">gnzsnz/ib-gateway 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Interactive Brokers Gateway Docker

<img src="https://github.com/gnzsnz/ib-gateway-docker/blob/master/logo.png" height="300" />

## 概述

一个无需人工交互即可在Docker容器中运行Interactive Brokers Gateway应用的Docker镜像。

包含以下组件：
- [IB Gateway应用](https://www.interactivebrokers.com/en/index.php?f=16457)（[稳定版](https://www.interactivebrokers.com/en/trading/ibgateway-stable.php)、[最新版](https://www.interactivebrokers.com/en/trading/ibgateway-latest.php)）
- [IBC应用](https://github.com/IbcAlpha/IBC) - 用于控制IB Gateway应用（模拟用户输入）。
- [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) - X11虚拟帧缓冲区，用于在无图形硬件的环境中运行IB Gateway应用。
- [x11vnc](https://wiki.archlinux.org/title/x11vnc) - VNC服务器，允许与IB Gateway用户界面交互（可选，用于开发/维护目的）。
- [socat](https://linux.die.net/man/1/socat) - 接受非本地主机的TCP连接并将其转发到本地主机的IB Gateway的工具（IB Gateway默认限制仅允许127.0.0.1连接）。
- 可与[Jupyter Quant](https://github.com/gnzsnz/jupyter-quant) Docker镜像良好配合使用。

## 支持的标签

| 渠道     | IB Gateway版本 | IBC版本 | Docker标签                  |
| -------- | ------------- | ------- | -------------------------- |
| `latest` | `10.24.1e`    | `3.18.0`| `latest` `10.24` `10.24.1e` |
| `stable` | `10.19.2d`    | `3.18.0`| `stable` `10.19` `10.19.2d` |

本README可能未包含最新标签，但你可以随时获取[稳定版](https://github.com/users/gnzsnz/packages/container/ib-gateway/117795730?tag=stable)和[最新版](https://github.com/users/gnzsnz/packages/container/ib-gateway/120858613?tag=latest)以及所有可用[标签](https://github.com/gnzsnz/ib-gateway-docker/pkgs/container/ib-gateway/)。

## 使用方法

创建`docker-compose.yml`（或将ib-gateway服务添加到现有文件中）

```yaml
version: "3.4"

services:
  ib-gateway:
    image: ***-ghcr.xuanyuan.run/gnzsnz/ib-gateway:latest
    restart: always
    environment:
      TWS_USERID: ${TWS_USERID}
      TWS_PASSWORD: ${TWS_PASSWORD}
      TRADING_MODE: ${TRADING_MODE:-live}
      VNC_SERVER_PASSWORD: ${VNC_SERVER_PASSWORD:-}
      READ_ONLY_API: ${READ_ONLY_API:-}
      TWOFA_TIMEOUT_ACTION: ${TWOFA_TIMEOUT_ACTION:-exit}
      AUTO_RESTART_TIME: ${AUTO_RESTART_TIME:-}
      RELOGIN_AFTER_TWOFA_TIMEOUT: ${RELOGIN_AFTER_TWOFA_TIMEOUT:-no}
      TWOFA_EXIT_INTERVAL: ${TWOFA_EXIT_INTERVAL:-60}
      TIME_ZONE: ${TIME_ZONE:-Etc/UTC}
    ports:
      - "127.0.0.1:4001:4001"
      - "127.0.0.1:4002:4002"
      - "127.0.0.1:5900:5900"
```

在根目录创建.env文件或设置以下环境变量：

| 变量                  | 描述                                                                 | 默认值                          |
| --------------------- | -------------------------------------------------------------------- | ------------------------------ |
| `TWS_USERID`          | TWS**用户名 **。                                                      |                                |
| `TWS_PASSWORD`        | TWS**密码 **。                                                      |                                |
| `TRADING_MODE`        |** live **（实盘）或**paper**（模拟）                                 |** paper **（模拟）             |
| `READ_ONLY_API`       |** yes **或**no**（参见[说明](resources/config.ini#L316)）             |** 未定义 **                    |
| `VNC_SERVER_PASSWORD` | VNC服务器密码。若未定义，则不启动VNC服务器。                          |** 未定义 **（VNC禁用）         |
| `TWOFA_TIMEOUT_ACTION` | 'exit'（退出）或'restart'（重启），若设置`AUTO_RESTART_TIME`则设为'restart'。参见IBC[文档](https://github.com/IbcAlpha/IBC/blob/master/userguide.md#second-factor-authentication) | 'exit' |
| `AUTO_RESTART_TIME` | 重启IB Gateway的时间，无需每日二次验证。格式为hh:mm AM/PM。参见IBC[文档](https://github.com/IbcAlpha/IBC/blob/master/userguide.md#ibc-user-guide) |** 未定义 **|
| `RELOGIN_AFTER_2FA_TIMEOUT` | 支持超时后重新登录。参见IBC[文档](https://github.com/IbcAlpha/IBC/blob/master/userguide.md#second-factor-authentication) | 'no' |
| `TIME_ZONE` | 时区支持，参见TWS jts.ini文件中的[有效值](https://ibkrguides.com/tws/usersguidebook/configuretws/configgeneral.htm)或[时区数据库](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)。设置IB Gateway的时区。例如`Europe/Paris`、`America/New_York`、`Asia/Tokyo` | "Etc/UTC" |

.env文件示例：

```text
TWS_USERID=myTwsAccountName
TWS_PASSWORD=myTwsPassword
TRADING_MODE=paper
READ_ONLY_API=no
VNC_SERVER_PASSWORD=myVncPassword
TWOFA_TIMEOUT_ACTION=restart
AUTO_RESTART_TIME=11:59 PM
RELOGIN_AFTER_2FA_TIMEOUT=yes
TIME_ZONE=Europe/Lisbon
```

运行：

  $ docker-compose up

镜像下载完成、容器启动后约30秒，容器和Docker主机上的以下端口将准备就绪：

| 端口 | 描述                                                  |
| ---- | ----------------------------------------------------- |
| 4001 | 实盘账户的TWS API端口。                               |
| 4002 | 模拟账户的TWS API端口。                               |
| 5900 | 当定义`VNC_SERVER_PASSWORD`时，VNC服务器端口。        |

**注意**：上述`docker-compose.yml`中，端口仅暴露给Docker主机的本地（127.0.0.1），而非主机网络。若要暴露给整个网络，请相应修改端口映射（移除'127.0.0.1:'）。** 注意 **：参见[离开本地主机](#离开本地主机)

## 本地构建方法

1. 克隆仓库

   ```bash
   git clone https://github.com/gnzsnz/ib-gateway-docker
   ```

2. 修改Dockerfile，使用本地IB Gateway安装文件而非从项目发布版加载：在编辑器中打开`Dockerfile`，将以下行替换：

   ```docker
   RUN curl -sSL https://github.com/gnzsnz/ib-gateway-docker/raw/gh-pages/ibgateway-releases/ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh \
       --output ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh
   RUN curl -sSL https://github.com/gnzsnz/ib-gateway-docker/raw/gh-pages/ibgateway-releases/ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256 \
       --output ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256
   ```

   替换为

   ```docker
   COPY ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh
   ```

3. 从Dockerfile中移除`RUN sha256sum --check ./ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256`（除非需要保留校验和检查）
4. 下载IB Gateway并命名为`ibgateway-{IB_GATEWAY_VERSION}-standalone-linux-x64.sh`，其中`{IB_GATEWAY_VERSION}`必须与Dockerfile（第一行）中配置的版本匹配
5. 下载IBC并命名为`IBCLinux-{IBC_VERSION}.zip`，其中`{IBC_VERSION}`必须与Dockerfile（第二行）中配置的版本匹配
6. 构建并运行：`docker-compose up --build`

## 版本和标签

Docker镜像版本与镜像中的IB Gateway版本对应。参见[支持的标签](#支持的标签)

### IB Gateway安装文件

注意[Dockerfile](https://github.com/gnzsnz/ib-gateway-docker/blob/master/Dockerfile)** 不会 **从IB官网下载IB Gateway安装文件，而是从本项目的[github-pages](https://github.com/gnzsnz/ib-gateway-docker/tree/gh-pages/ibgateway-releases)下载。

这是因为需要能够（重新）构建特定Gateway版本的镜像，而IB仅提供`latest`或`stable`版本的下载链接（无“旧版本”下载归档）。

存储在[github-pages](https://github.com/gnzsnz/ib-gateway-docker/tree/gh-pages/ibgateway-releases)中的安装文件已从IB官网下载并更名以反映版本。

若要直接从IB官网下载Gateway安装文件或使用本地安装文件，修改[Dockerfile](https://github.com/gnzsnz/ib-gateway-docker/blob/master/Dockerfile)中的以下行：`RUN curl -sSL https://github.com/gnzsnz/ib-gateway-docker/raw/gh-pages/ibgateway-releases/ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh --output ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh`** 示例 **：改为`RUN curl -sSL https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh --output ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh`以使用IB官网当前稳定版。

## 自定义镜像

可通过用自定义配置文件覆盖默认配置文件来自定义镜像。

应用和配置文件位置：

| 应用        | 文件夹      | 配置文件               | 默认值                                                                                         |
| ---------- | ----------- | ---------------------- | --------------------------------------------------------------------------------------------- |
| IB Gateway | /root/Jts   | /root/Jts/jts.ini      | [jts.ini](https://github.com/gnzsnz/ib-gateway-docker/blob/master/config/ibgateway/jts.ini) |
| IBC        | /root/ibc   | /root/ibc/config.ini   | [config.ini](https://github.com/gnzsnz/ib-gateway-docker/blob/master/config/ibc/config.ini.tmpl) |

要启动IB Gateway，从Dockerfile或运行脚本中执行`/root/scripts/run.sh`。

## 安全考虑

### 离开本地主机

IB API协议基于客户端与IB Gateway之间未加密、未认证的原始TCP套接字连接。若IB API端口对网络开放，则网络中的所有设备（包括潜在恶意设备）均可通过IB Gateway访问你的IB账户。

因此，默认`docker-compose.yml`仅将IB API端口暴露给Docker主机的**本地主机 **，而非整个网络。

若要从远程设备连接IB Gateway，考虑添加额外安全层（如TLS/SSL或SSH隧道）以保护“明文”TCP套接字免受未授权访问或篡改。

### 凭据

本镜像不包含也不存储任何用户凭据。

凭据在容器启动时通过环境变量提供，主机负责妥善保护（例如使用[Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables)等）。
