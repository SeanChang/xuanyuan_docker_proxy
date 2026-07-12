---
image: atlassian/stash
description: "已弃用的Git本地源代码管理工具，提供安全、快速且企业级的Git源代码管理功能，现迁移为Bitbucket Server。"
source: https://xuanyuan.cloud/zh/r/atlassian/stash
canonical: https://xuanyuan.cloud/zh/r/atlassian/stash
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/stash" title="atlassian/stash Docker 镜像中文简介、标签列表与拉取命令">atlassian/stash 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 此镜像已弃用！

**Stash现已更名为Bitbucket Server。** 如需最新Docker镜像，请查看[bitbucket.org](https://bitbucket.org/atlassian/docker-atlassian-bitbucket-server)或[hub.docker.com](https://hub.docker.com/r/atlassian/bitbucket-server)上的新仓库。

详情请阅读[此公告](http://go.atlassian.com/bitbucket-server-4.0)。

Stash Docker镜像不再受支持，不建议用于生产环境。

# 概述

此Docker容器可轻松启动Stash实例用于评估目的。Atlassian暂不支持在生产环境中使用Docker。

# 快速启动

对于用于存储仓库数据（及其他内容）的`STASH_HOME`目录，建议将主机目录挂载为[数据卷](https://docs.docker.com/userguide/dockervolumes/#mount-a-host-directory-as-a-data-volume)：

### 设置数据目录权限
确保运行用户对数据目录有写入权限：
```bash
$> docker run -u root -v /data/stash:/var/atlassian/application-data/stash atlassian/stash chown -R daemon  /var/atlassian/application-data/stash
```

### 启动Atlassian Stash
```bash
$> docker run -v /data/stash:/var/atlassian/application-data/stash --name="stash" -d -p 7990:7990 -p 7999:7999 atlassian/stash
```

**成功**。Stash现已可通过[http://localhost:7990](http://localhost:7990)访问*

请确保容器已分配必要资源，建议分配2GiB内存以容纳应用服务器和Git进程。更多信息参见[支持的平台](https://confluence.atlassian.com/display/STASH/Supported+platforms)。

_* 注意：如在Mac OS X上使用`boot2docker`，请使用`open http://$(boot2docker ip):7990`访问。_

# 升级

要升级到Stash的更新版本，只需停止`stash`容器并基于更新的镜像启动新容器：
```bash
$> docker stop stash
$> docker rm stash
$> docker run ...（参见上文启动命令）
```

由于数据存储在主机的数据卷目录中，升级后数据仍可正常访问。

_注意：请确保不要使用`-v`选项意外删除`stash`容器及其卷。_

# 备份

评估环境中，可使用内置数据库（文件存储在Stash主目录），此时只需对主机上用作卷的目录（如上例中的`/data/stash`）创建备份归档即可。

Docker设置目前不支持[Stash Backup Client](https://confluence.atlassian.com/display/STASH/Data+recovery+and+backups)。如使用外部数据库，可采用[Stash DIY Backup](https://confluence.atlassian.com/display/STASH/Using+Stash+DIY+Backup)方法。

有关数据恢复和备份的更多信息：[https://confluence.atlassian.com/display/STASH/Data+recovery+and+backups](https://confluence.atlassian.com/display/STASH/Data+recovery+and+backups)

# 版本控制

`latest`标签对应Atlassian Stash的最新版本。因此`atlassian/stash:latest`将使用最新可用的Stash版本。

也可使用特定次要版本标签指定Stash版本，例如`atlassian/stash:3.5`，这将安装最新的`3.5.x`版本。

# 问题跟踪

如在使用此Dockerfile时遇到任何问题，请提交[issue](https://bitbucket.org/atlassian/docker-atlassian-stash/issues)。
