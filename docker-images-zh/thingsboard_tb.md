---
image: thingsboard/tb
description: "ThingsBoard单实例Docker镜像，内置HSQLDB数据库，是用于物联网数据收集、处理、可视化及设备管理的开源平台。"
source: https://xuanyuan.cloud/zh/r/thingsboard/tb
canonical: https://xuanyuan.cloud/zh/r/thingsboard/tb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/thingsboard/tb" title="thingsboard/tb Docker 镜像中文简介、标签列表与拉取命令">thingsboard/tb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ThingsBoard Docker镜像文档

## 镜像概述

ThingsBoard是一个开源物联网平台，提供数据收集、处理、可视化和设备管理功能。本镜像为ThingsBoard单实例部署，内置HSQLDB数据库，适合快速启动和测试环境使用。

## 核心功能和特性

- **数据收集**：支持MQTT、COAP、LwM2M等多种物联网协议
- **数据处理**：提供规则引擎，支持实时数据处理和业务逻辑执行
- **可视化**：内置仪表盘，支持数据可视化和报表生成
- **设备管理**：支持设备注册、状态监控、固件更新等设备全生命周期管理
- **单实例部署**：内置HSQLDB数据库，无需额外配置外部数据库

## 使用场景

- 物联网项目原型开发和测试
- 小型物联网应用部署
- 学习和评估ThingsBoard平台功能

## 使用方法

### 准备工作

在启动容器前，需创建数据和日志目录并设置权限：

```bash
$ mkdir -p ~/.mytb-data && sudo chown -R 799:799 ~/.mytb-data
$ mkdir -p ~/.mytb-logs && sudo chown -R 799:799 ~/.mytb-logs
```

### 启动容器

执行以下命令启动ThingsBoard容器：

```bash
$ docker run -it -p 9090:9090 -p 1883:1883 -p 7070:7070 -p 5683-5688:5683-5688/udp -v ~/.mytb-data:/data -v ~/.mytb-logs:/var/log/thingsboard --name mytb --restart always thingsboard/tb
```

#### 参数说明：
- `-it`：附加终端会话，显示ThingsBoard进程输出
- `-p 9090:9090`：映射HTTP端口（Web界面）
- `-p 1883:1883`：映射MQTT端口
- `-p 7070:7070`：映射Edge RPC端口
- `-p 5683-5688:5683-5688/udp`：映射COAP和LwM2M UDP端口
- `-v ~/.mytb-data:/data`：挂载主机数据目录到容器数据库目录
- `-v ~/.mytb-logs:/var/log/thingsboard`：挂载主机日志目录到容器日志目录
- `--name mytb`：容器名称
- `--restart always`：系统重启或容器故障时自动重启
- `thingsboard/tb`：Docker镜像名称



### 访问访问

容器启动浏览器访问 `http://{你的主机-ip }:9090`，将看到ThingsBoard登录页面。使用以下默认凭据：

- **系统管理员**：sysadmin@thingsboard.org / sysadmin
- **租户管理员**：tenant@thingsboard.org / tenant
- **客户用户**：customer@thingsboard.org / customer

> 可在账户配置页面修改各账号密码。

### 容器管理

- **分离终端会话**：按 `Ctrl-p` `Ctrl-q`，容器将在后台继续运行
- **重新附加终端**（查看日志）：`docker attach mytb`
- **停止容器**：`docker stop mytb`
- **启动容器**：`docker start mytb`

## 升级步骤

要更新到最新镜像，执行以下命令：

```bash
$ docker pull docker.xuanyuan.run/thingsboard/tb
$ docker stop mytb
$ docker run -it -v ~/.mytb-data:/data --rm thingsboard/tb upgrade-tb.sh
$ docker rm my
$ docker run -it -p 9090:9090 -p 1883:1883 -p 7070:7070 -p 5683-5688:5683-5688/udp -v ~/.mytb-data:/data -v ~/.mytb-logs:/var/log/thingsboard --name mytb --restart always thingsboard/tb
```

> **注意**：将 `~/.mytb-data` 替换为容器创建时使用的主机数据目录。

## 文档资源

完整文档托管在 [thingsboard.io](https://thingsboard.io/docs)。
