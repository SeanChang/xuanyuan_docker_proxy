---
image: ddev/mysql
description: "为ddev-dbserver-mysql-5.7提供的ARM64基础镜像，适用于Apple Silicon等ARM64架构环境"
source: https://xuanyuan.cloud/zh/r/ddev/mysql
canonical: https://xuanyuan.cloud/zh/r/ddev/mysql
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ddev/mysql" title="ddev/mysql Docker 镜像中文简介、标签列表与拉取命令">ddev/mysql — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ddev/mysql" title="ddev/mysql Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ddev/mysql</a>

# ddev/mysql-arm64-images Docker镜像 (ddev/ddev-mysql)

## 概述
用于构建MySQL ARM64镜像的工具。Oracle未发布任何MySQL的ARM64镜像，但Apple Silicon（DDEV）用户确实需要原生镜像。本仓库用于发布这些镜像，并被`ddev/ddev-dbserver-mysql-5.7`使用。

**注意**：自2024年12月起，我们使用Bitnami镜像作为mysql:8.0+的基础，因此无需构建或推送`ddev/mysql:8.0`镜像。此外，Percona现已发布`percona-xtrabackup`的ARM64版本，因此我们不再需要自行构建。因此，本README正在更新，但早期的Git版本仍会显示以往的构建方式。

## 特性
这些镜像基于上游Ubuntu构建。

## 构建与推送
- 推送5.7镜像：`cd 5.7 && ./push.sh`。
- 若MySQL发布新的次要版本，更新相应的base_version.txt文件。

## 运行
单独运行容器：

```bash
docker run -it --rm --entrypoint=bash ddev/ddev-mysql:<tag> bash
```

## 源码
[https://github.com/ddev/mysql-arm64-images](https://github.com/ddev/mysql-arm64-images)

## 维护者
[DDEV Docker维护团队](https://github.com/ddev)

## 获取帮助
- [DDEV社区Discord](https://discord.gg/5wjP76mBJD)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/ddev)（标签：ddev）

## 提交问题
https://github.com/ddev/ddev/issues

## 文档
- https://ddev.readthedocs.io/
- https://ddev.com/

## 什么是DDEV？
[DDEV](https://github.com/ddev/ddev)是一款开源工具，用于在几分钟内启动本地Web开发环境。它支持PHP、Node.js和Python（实验性）。

这些环境可以扩展、版本控制和共享，因此您可以利用Docker工作流，而无需Docker经验或定制配置。项目可以轻松更改、关闭或移除，就像启动一样简单。

## 许可协议
查看[许可信息](https://github.com/ddev/ddev/blob/master/LICENSE)了解本镜像包含的软件许可。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可（例如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用均符合其中包含的所有软件的相关许可。
