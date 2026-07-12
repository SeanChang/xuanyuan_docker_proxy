---
image: library/telegraf
description: "Telegraf是一款用于收集指标并将其写入InfluxDB或其他输出目标的代理工具。"
source: https://xuanyuan.cloud/zh/r/library/telegraf
canonical: https://xuanyuan.cloud/zh/r/library/telegraf
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/telegraf" title="library/telegraf Docker 镜像中文简介、标签列表与拉取命令">library/telegraf 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 快速参考

- **维护者**：
  [InfluxData](https://github.com/influxdata/influxdata-docker)

- **获取帮助的途径**：
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应 Dockerfile 链接

- [`1.34`, `1.34.4`](https://github.com/influxdata/influxdata-docker/blob/045df18324070d29fcdd716644bf908ed4fedf48/telegraf/1.34/Dockerfile)

- [`1.34-alpine`, `1.34.4-alpine`](https://github.com/influxdata/influxdata-docker/blob/045df18324070d29fcdd716644bf908ed4fedf48/telegraf/1.34/alpine/Dockerfile)

- [`1.35`, `1.35.4`](https://github.com/influxdata/influxdata-docker/blob/045df18324070d29fcdd716644bf908ed4fedf48/telegraf/1.35/Dockerfile)

- [`1.35-alpine`, `1.35.4-alpine`](https://github.com/influxdata/influxdata-docker/blob/045df18324070d29fcdd716644bf908ed4fedf48/telegraf/1.35/alpine/Dockerfile)

- [`1.36`, `1.36.2`, `latest`](https://github.com/influxdata/influxdata-docker/blob/045df18324070d29fcdd716644bf908ed4fedf48/telegraf/1.36/Dockerfile)

- [`1.36-alpine`, `1.36.2-alpine`, `alpine`](https://github.com/influxdata/influxdata-docker/blob/045df18324070d29fcdd716644bf908ed4fedf48/telegraf/1.36/alpine/Dockerfile)

# 快速参考（续）

- **提交问题的位置**：
  [https://github.com/influxdata/influxdata-docker/issues](https://github.com/influxdata/influxdata-docker/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))
  [`amd64`](https://hub.docker.com/r/amd64/telegraf/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/telegraf/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/telegraf/)

- **已发布镜像工件详情**：
  [repo-info 仓库的 `repos/telegraf/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/telegraf)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/telegraf)）
  （镜像元数据、传输大小等）

- **镜像更新**：
  [official-images 仓库的 `library/telegraf` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Ftelegraf)
  [official-images 仓库的 `library/telegraf` 文件](https://github.com/docker-library/official-images/blob/master/library/telegraf)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/telegraf)）

- **本描述的来源**：
  [docs 仓库的 `telegraf/` 目录](https://github.com/docker-library/docs/tree/master/telegraf)（[历史记录](https://github.com/docker-library/docs/commits/master/telegraf)）

# 什么是 Telegraf？

Telegraf 是一款开源代理工具，用于收集、处理、聚合和写入指标。它基于插件系统，使社区开发者能够轻松添加对额外指标收集的支持。插件分为五种不同类型：

- 输入插件：从系统、服务或第三方 API 收集指标
- 输出插件：将指标写入各种目标
- 处理器插件：转换、装饰和/或过滤指标
- 聚合器插件：创建聚合指标（如平均值、最小值、最大值、分位数等）
- 密钥存储插件：用于隐藏配置文件中的密钥

[Telegraf 官方文档](https://docs.influxdata.com/telegraf/latest/get_started/)

![logo](https://raw.githubusercontent.com/docker-library/docs/7b128c7411e3e8375d9639e6455e47874940f012/telegraf/logo.png)

# 如何使用本镜像

## 暴露端口

- 8125 UDP
- 8092 UDP
- 8094 TCP

## 配置文件

使用本镜像需提供有效的配置文件，该文件至少需指定一个输入插件和一个输出插件。以下步骤将指导您快速上手。

### 基本示例

配置文件是基于 TOML 格式的文件，用于声明要使用的插件。一个非常简单的配置文件 `telegraf.conf`（收集系统 CPU 指标并输出到标准输出）如下：

```toml
[[inputs.cpu]]
[[outputs.file]]
```

创建自定义配置文件后，可通过挂载该文件启动 Telegraf 容器：

```console
$ docker run -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro telegraf
```

将 `$PWD` 修改为存储配置文件的目录。

了解更多 Telegraf 配置信息，请参见 [此处](https://docs.influxdata.com/telegraf/latest/administration/configuration/)。

### 生成示例配置

用户可使用 `config` 子命令生成示例配置。此配置包含多个已启用的系统输入插件，但仍需至少配置一个输出插件才能使用：

```console
$ docker run --rm telegraf telegraf config > telegraf.conf
```

## 支持的插件参考

以下是 Telegraf 可用的各类插件链接：

- [输入插件](https://docs.influxdata.com/telegraf/latest/plugins/#input-plugins)
- [输出插件](https://docs.influxdata.com/telegraf/latest/plugins/#output-plugins)
- [处理器插件](https://docs.influxdata.com/telegraf/latest/plugins/#processor-plugins)
- [聚合器插件](https://docs.influxdata.com/telegraf/latest/plugins/#aggregator-plugins)

# 示例

## 监控 Docker 引擎主机

Telegraf 的一个常见用例是从容器内部监控 Docker 引擎主机。推荐方法是将主机文件系统挂载到容器中，并使用环境变量指示 Telegraf 定位文件系统。

不同插件所需挂载的文件有所不同。以下示例展示了完整的支持位置集：

```console
$ docker run -d --name=telegraf \
  -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
  -v /:/hostfs:ro \
  -e HOST_ETC=/hostfs/etc \
  -e HOST_PROC=/hostfs/proc \
  -e HOST_SYS=/hostfs/sys \
  -e HOST_VAR=/hostfs/var \
  -e HOST_RUN=/hostfs/run \
  -e HOST_MOUNT_PREFIX=/hostfs \
  telegraf
```

## 监控 Docker 容器

要监控其他 Docker 容器，可使用 docker 插件并将 docker socket 挂载到容器中。示例配置如下：

```toml
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
```

然后启动 telegraf 容器：

```console
$ docker run -d --name=telegraf \
  --net=influxdb \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
  telegraf
```

更多信息请参考 docker [插件文档](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/docker/README.md)。

## 安装额外包

部分插件需要安装额外包。例如，`ntpq` 插件需要 `ntpq` 命令。建议创建自定义衍生镜像来安装所需命令。

以下示例 Dockerfile 向基础镜像添加 `mtr-tiny`，保存为 `telegraf-mtr.docker`：

```dockerfile
FROM docker.xuanyuan.run/telegraf:1.12.3

RUN apt-get update && apt-get install -y --no-install-recommends mtr-tiny && \
  rm -rf /var/lib/apt/lists/*
```

构建衍生镜像：

```console
$ docker build -t telegraf-mtr:1.12.3 - < telegraf-mtr.docker
```

创建 `telegraf.conf` 配置文件：

```toml
[[inputs.exec]]
  interval = "60s"
  commands=["mtr -C -n example.org"]
  timeout = "40s"
  data_format = "csv"
  csv_skip_rows = 1
  csv_column_names=["", "", "status", "dest", "hop", "ip", "loss", "snt", "", "", "avg", "best", "worst", "stdev"]
  name_override = "mtr"
  csv_tag_columns = ["dest", "hop", "ip"]

[[outputs.file]]
  files = ["stdout"]
```

运行衍生镜像：

```console
$ docker run --name telegraf --rm -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf telegraf-mtr:1.12.3
```

# 镜像变体

`telegraf` 镜像有多种版本，适用于不同场景。

## `telegraf:<version>`

这是默认镜像。如果不确定需求，建议使用此版本。它既可作为临时容器（挂载源代码并启动容器以运行应用），也可作为构建其他镜像的基础。

## `telegraf:<version>-alpine`

此镜像基于流行的 [Alpine Linux 项目](https://alpinelinux.org)，来自 [alpine 官方镜像](https://hub.docker.com/_/alpine)。Alpine Linux 比大多数发行版基础镜像小得多（约 5MB），因此生成的镜像通常更精简。

当首要关注点是最小化最终镜像大小时，此变体非常有用。需要注意的是，它使用 [musl libc](https://musl.libc.org) 而非 [glibc 等](https://www.etalabs.net/compare_libcs.html)，因此软件可能因 libc 依赖/假设而遇到问题。更多讨论参见 [此 Hacker News 评论线程](https://news.ycombinator.com/item?id=10782897)。

为最小化镜像大小，Alpine 基础镜像通常不包含额外相关工具（如 `git` 或 `bash`）。如需添加，可在自己的 Dockerfile 中进行（参考 [`alpine` 镜像描述](https://hub.docker.com/_/alpine/) 中的包安装示例）。

# 许可证

查看此镜像中包含的软件的 [许可证信息](https://github.com/influxdata/telegraf/blob/master/LICENSE)。

与所有 Docker 镜像一样，此镜像可能包含其他软件，这些软件可能采用其他许可证（如基础发行版中的 Bash 等，以及主要软件的任何直接或间接依赖）。

部分可自动检测的额外许可证信息可能位于 [repo-info 仓库的 `telegraf/` 目录](https://github.com/docker-library/repo-info/tree/master/repos/telegraf)。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用符合其中包含的所有软件的相关许可证。
