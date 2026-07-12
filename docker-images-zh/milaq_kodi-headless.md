---
image: milaq/kodi-headless
description: "这是一个无头的Docker化Kodi实例，适用于共享MySQL媒体库设置，可提供Web界面并自动定期更新媒体库，无需播放器系统持续运行。"
source: https://xuanyuan.cloud/zh/r/milaq/kodi-headless
canonical: https://xuanyuan.cloud/zh/r/milaq/kodi-headless
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/milaq/kodi-headless" title="milaq/kodi-headless Docker 镜像中文简介、标签列表与拉取命令">milaq/kodi-headless 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![](http://kodi.wiki/images/4/43/Side-by-side-dark-transparent.png)](https://kodi.tv/)

# 简介
这是一个无头（headless）的Docker化Kodi实例，用于共享MySQL媒体库设置，允许在无需播放器系统持续运行的情况下拥有Web界面和自动定期更新媒体库的功能。

# 标签
| 标签名       | 分支       | Kodi版本 | 基础发行版       |
|-------------|-----------|---------|------------------|
| `latest`    | leia      | 18      | Debian Stretch   |
| `leia`      | leia      | 18      | Debian Stretch   |
| `krypton`   | krypton   | 17      | Debian Stretch   |

**注意**：以下信息可能因分支/标签而异，请确保查看对应标签的README。  
__您当前查看的是`leia`分支的README__

# 前提条件
您需要事先通过阅读、理解并执行[MySQL媒体库共享指南](http://kodi.wiki/view/MySQL)中的必要步骤，设置好通过专用MySQL数据库的媒体库共享。  
**警告** - 正如维基中所述，这里再次强调：所有客户端必须运行相同版本的Kodi！  

在容器中设置媒体库共享的最佳方式是：先通过另一个GUI主机（例如您的HTPC）完全配置共享库、其源和刮削器，然后再设置无头Kodi实例。服务器需要完全配置的数据库访问权限，且您的源（SMB或NFS）必须能从无头实例访问。之后，所有更新、刮削和清理都可以由无头Kodi实例自动处理。  

**提醒**：如果您不使用默认刮削器，则需要自行负责在容器中安装和启用相应插件。

# 使用方法

获取容器镜像：
```bash
docker pull docker.xuanyuan.run/milaq/kodi-headless:leia
```

运行容器并设置必要的环境变量：
```bash
docker run -d --restart=always --log-opt max-size=50M --name kodi-headless -e KODI_DBHOST=<MY_KODI_DBHOST> -e KODI_DBUSER=<MY_KODI_DBUSER> -e KODI_DBPASS=<MY_KODI_DBPASS> milaq/kodi-headless:leia
```

如果需要原生映射Web界面端口，请追加：
```bash
-p 8080:8080 -p 9090:9090
```

如果需要容器外部访问事件服务器：
```bash
-p 9777:9777
```

## 容器环境变量
- `KODI_DBHOST` - MySQL数据库主机地址  
- `KODI_DBUSER` - Kodi的MySQL用户  
- `KODI_DBPASS` - Kodi用户的MySQL密码  
- `KODI_DBPORT` - MySQL远程端口（默认：`3306`）  
- `KODI_DBPREFIX_VIDEOS` - 视频数据库的MySQL前缀  
- `KODI_DBPREFIX_MUSIC` - 音乐数据库的MySQL前缀  
- `KODI_UPDATE_INTERVAL_ADDONS` - 插件更新间隔（秒，默认：21600 [6小时]）  
- `KODI_UPDATE_INTERVAL` - 扫描远程源视频/音乐库变化的间隔（秒，`0`禁用，默认：300 [5分钟]）  
- `KODI_UPDATE_INTERVAL_VIDEOS` - 扫描远程源视频库变化的间隔（秒，`0`禁用，默认：`KODI_UPDATE_INTERVAL`）  
- `KODI_UPDATE_INTERVAL_MUSIC` - 扫描远程源音乐库变化的间隔（秒，`0`禁用，默认：`KODI_UPDATE_INTERVAL`）  
- `KODI_CLEAN_INTERVAL` - 清理视频/音乐库的间隔（秒，需存在sources.xml，`0`禁用，默认：禁用）  
- `KODI_CLEAN_INTERVAL_VIDEOS` - 清理视频库的间隔（秒，`0`禁用，默认：`KODI_CLEAN_INTERVAL`）  
- `KODI_CLEAN_INTERVAL_MUSIC` - 清理音乐库的间隔（秒，`0`禁用，默认：`KODI_CLEAN_INTERVAL`）  

**已弃用**：  
- `KODI_CLEAN` - 是否定期清理库 [`true`/`false`]（已弃用，使用`KODI_CLEAN_INTERVAL`）  

**实验性**：您也可以挂载自己的`advancedsettings.xml`副本。容器启动时将跳过任何数据库配置变量（KODI_DB*），仅使用提供的副本。

## 自动库清理
如果要启用自动库清理，您**必须**创建适当的`sources.xml`和`passwords.xml`（或从HTPC获取副本），并放置在容器卷内：  
```bash
/config/userdata/sources.xml  
/config/userdata/passwords.xml  
```  
或者在Docker主机上引用副本，例如：  
```bash
-v /path/to/sources.xml:/config/userdata/sources.xml  
-v /path/to/passwords.xml:/config/userdata/passwords.xml  
```  
然后通过相应标志启用库清理，例如：  
```bash
-e KODI_CLEAN_INTERVAL=86400  
```  

**警告**：配置错误的sources.xml或passwords.xml可能导致Kodi实例无法找到任何媒体，从而清空数据库。请备份数据库并在启用此功能前仔细确认！  

**注意**：如果您不使用需要身份验证的网络共享，也可以提供一个空的`passwords.xml`：  
```xml
<passwords>  
</passwords>  
```  

# 致谢
感谢linuxserver.io创建了可靠的Docker化Kodi基础版本。  
特别感谢Celedhrim创建了最初的无头补丁，以及sinopsysHK为Leia版本创建了新的无头补丁。
