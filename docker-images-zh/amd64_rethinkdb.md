---
image: amd64/rethinkdb
description: "RethinkDB是一个开源的文档数据库，便于构建和扩展实时应用程序。"
source: https://xuanyuan.cloud/zh/r/amd64/rethinkdb
canonical: https://xuanyuan.cloud/zh/r/amd64/rethinkdb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/rethinkdb" title="amd64/rethinkdb Docker 镜像中文简介、标签列表与拉取命令">amd64/rethinkdb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**注意**：这是 [rethinkdb 官方镜像](https://hub.docker.com/_/rethinkdb) 的 `amd64` 架构构建的“每架构”仓库——更多信息，请参见官方镜像文档中的“[非 amd64 架构？](https://github.com/docker-library/official-images#architectures-other-than-amd64)”和官方镜像 FAQ 中的“[Git 中的镜像源已更改，现在该怎么办？](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)”。

# 快速参考

- **维护者**：  
  [RethinkDB](https://github.com/rethinkdb/rethinkdb-dockerfiles)

- **获取帮助的地方**：  
  [Docker 社区 Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的 `Dockerfile` 链接

- [`2.4.4-bookworm-slim`, `2.4-bookworm-slim`, `2-bookworm-slim`, `bookworm-slim`, `2.4.3`, `2.4`, `2`, `latest`](https://github.com/rethinkdb/rethinkdb-dockerfiles/blob/48876a66c3be922c6b01c436bf78d662e53bceef/bookworm/2.4.4/Dockerfile)

# 快速参考（续）

- **问题提交地址**：  
  [https://github.com/rethinkdb/rethinkdb-dockerfiles/issues](https://github.com/rethinkdb/rethinkdb-dockerfiles/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/rethinkdb/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/rethinkdb/)、[`s390x`](https://hub.docker.com/r/s390x/rethinkdb/)

- **发布的镜像制品详情**：  
  [repo-info 仓库的 `repos/rethinkdb/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/rethinkdb)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/rethinkdb)）  
 （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images 仓库的 `library/rethinkdb` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Frethinkdb)  
  [official-images 仓库的 `library/rethinkdb` 文件](https://github.com/docker-library/official-images/blob/master/library/rethinkdb)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/rethinkdb)）

- **本描述的来源**：  
  [docs 仓库的 `rethinkdb/` 目录](https://github.com/docker-library/docs/tree/master/rethinkdb)（[历史记录](https://github.com/docker-library/docs/commits/master/rethinkdb)）

# 什么是 RethinkDB？

RethinkDB 是一个开源的分布式数据库，旨在存储 JSON 文档并轻松扩展到多台机器。它易于设置和学习，并具有简单但强大的查询语言，支持表连接、分组、聚合和函数。

![logo](https://raw.githubusercontent.com/docker-library/docs/af9f91fe186f3ea3afee511d0a53b50088fdc381/rethinkdb/logo.png)

# 如何使用此镜像

## 在工作目录中挂载数据启动实例

该镜像的默认 CMD 是 `rethinkdb --bind all`，因此 RethinkDB 守护进程将绑定到容器可用的所有网络接口（默认情况下，RethinkDB 仅接受来自 `localhost` 的连接）。

```bash
docker run --name some-rethink -v "$PWD:/data" -d docker.xuanyuan.run/amd64/rethinkdb
```

## 将实例连接到应用程序

```bash
docker run --name some-app --link some-rethink:rdb -d docker.xuanyuan.run/application-that-uses-rdb
```

## 在同一主机上连接 Web 管理界面

```bash
$BROWSER "http://$(docker inspect --format \
  '{{ .NetworkSettings.IPAddress }}' some-rethink):8080"
```

# 通过 SSH 连接远程/虚拟主机上的 Web 管理界面

其中 `remote` 是远程 user@hostname 的别名：

```bash
# 启动端口转发
ssh -fNTL localhost:8080:$(ssh remote "docker inspect --format \
  '{{ .NetworkSettings.IPAddress }}' some-rethink"):8080 remote

# 在浏览器中打开界面
xdg-open http://localhost:8080

# 停止端口转发
kill $(lsof -t -i @localhost:8080 -sTCP:listen)
```

## 配置

有关使用和配置 RethinkDB 集群的信息，请参阅 [官方文档](http://www.rethinkdb.com/docs/)。

# 镜像变体

`amd64/rethinkdb` 镜像有多种版本，每种版本设计用于特定用例。

## `amd64/rethinkdb:<version>`

这是默认镜像。如果不确定自己的需求，可能需要使用此版本。它设计为既可作为临时容器使用（挂载源代码并启动容器以启动应用），也可作为构建其他镜像的基础。

其中一些标签可能包含 bookworm 等名称。这些是 [Debian](https://wiki.debian.org/DebianReleases) 发行版的代号，表示镜像基于哪个发行版。如果您的镜像需要安装除镜像自带包之外的其他包，建议明确指定其中一个代号，以最大程度减少 Debian 新版本发布时的中断。

## `amd64/rethinkdb:<version>-slim`

此镜像不包含默认标签中的通用包，仅包含运行 `amd64/rethinkdb` 所需的最小包。除非您的环境中仅部署 `amd64/rethinkdb` 镜像且有空间限制，否则强烈建议使用此仓库的默认镜像。

# 许可证

查看此镜像中包含的软件的 [许可证信息](https://raw.githubusercontent.com/rethinkdb/rethinkdb/next/LICENSE)。

与所有 Docker 镜像一样，这些镜像可能还包含其他受其他许可证约束的软件（例如基础发行版中的 Bash 等，以及主要软件的任何直接或间接依赖项）。

一些能够自动检测到的额外许可证信息可能位于 [repo-info 仓库的 `rethinkdb/` 目录](https://github.com/docker-library/repo-info/tree/master/repos/rethinkdb) 中。

至于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用符合其中包含的所有软件的相关许可证。
