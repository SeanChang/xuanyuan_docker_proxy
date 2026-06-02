---
image: garethflowers/svn-server
description: "这是一个基于Subversion版本控制系统的简单服务器，采用svnserve作为核心服务程序，旨在为小型开发团队或个人项目提供轻量级的版本控制解决方案，具有配置便捷、部署快速的特点，无需依赖复杂的Web服务器环境，可直接通过svn协议实现代码的提交、更新与管理，满足基础的版本控制需求。"
source: https://xuanyuan.cloud/zh/r/garethflowers/svn-server
canonical: https://xuanyuan.cloud/zh/r/garethflowers/svn-server
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/garethflowers/svn-server" title="garethflowers/svn-server Docker 镜像中文简介、标签列表与拉取命令">garethflowers/svn-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/garethflowers/svn-server" title="garethflowers/svn-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/garethflowers/svn-server</a>

# SVN 服务器

基于 `svnserve` 的简易 Subversion 服务器。


## 如何使用此镜像

### 启动 Subversion 服务器实例

若要启动容器，并将数据存储在主机的 `/home/svn` 目录，可使用以下命令：
```sh
docker run \
	--name my-svn-server \
	--detach \
	--volume /home/svn:/var/opt/svn \
	--publish 3690:3690 \
	garethflowers/svn-server
```


### 创建新的 SVN 仓库

可在容器内使用 `svnadmin` 命令创建和管理仓库。

例如，要在容器 `my-svn-server` 中创建名为 `new-repo` 的仓库，可使用以下命令：
```sh
docker exec -it my-svn-server svnadmin create new-repo
```


## 许可证

- Apache Subversion 基于 [Apache 许可证]([]) 发布。
- 本镜像基于 [MIT 许可证]([]) 发布。
