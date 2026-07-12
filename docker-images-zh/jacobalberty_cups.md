---
image: jacobalberty/cups
description: "从官方源码构建的CUPS镜像，包含少量定制化以使其更适合Docker环境使用。"
source: https://xuanyuan.cloud/zh/r/jacobalberty/cups
canonical: https://xuanyuan.cloud/zh/r/jacobalberty/cups
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jacobalberty/cups" title="jacobalberty/cups Docker 镜像中文简介、标签列表与拉取命令">jacobalberty/cups 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CUPS Docker镜像

## 概述

该镜像提供CUPS构建版本，包含一些额外特性以简化其在Docker中的安装和维护。与Docker Hub上其他CUPS镜像不同，本镜像不使用发行版包，而是从源码构建CUPS和cups-filters。这意味着可以更快地更新到新版本，并支持指定CUPS版本进行部署。

### Buster版本当前问题

自2.3版本起，本镜像基于Buster。目前Debian Buster上的dnssd发现功能不稳定，使用IP地址或常规主机名时工作正常，但dnssd发现的打印机可能会间歇性断开连接。这可能通过调整avahi配置解决，但avahi默认不包含在镜像中，仅在安装hplip驱动时才会安装。

## TODO

用户管理机制尚不完善，CUPS默认配置也不太适合Docker环境。欢迎通过文档改进、源码补丁或安装配置补丁等方式提交修复建议，以提升镜像可用性。

## 驱动

CUPS默认安装的驱动较少，若无驱动则功能有限。建议通过创建基于本镜像的Dockerfile来安装所需驱动。为简化驱动安装，镜像在`/usr/local/docker/share/drivers`目录下提供了Shell脚本，用于安装常见驱动。若成功安装新驱动，欢迎在GitHub issue跟踪器提交安装方法描述或PR。

### hplip

可通过在镜像中运行`/usr/local/docker/share/drivers/hplip.sh`安装hplip，之后需执行`hp-plugin`并接受许可协议以完成完整安装。

### foomatic

可通过运行`/usr/local/docker/share/drivers/foomatic.sh`安装foomatic，该脚本仅安装foomatic-filters和foomatic-db-filters。若需安装foomatic-db和foomatic-db-nonfree，需后续运行`/usr/local/docker/share/drivers/foomatic-db.sh`。未来在测试并确认foomatic-filters安装稳定后，可能会将其整合到主构建脚本中，并将三个db包合并为单个安装脚本。

## 卷

### `/config`

该卷包含以下子目录：

#### `/config/etc`
存储CUPS配置文件。

#### `/config/log`
存储日志文件。

#### `/config/init.d`（可选）
可选子目录，包含CUPS守护进程启动前需运行的脚本。

## 暴露端口

### 631/tcp

### 631/udp
