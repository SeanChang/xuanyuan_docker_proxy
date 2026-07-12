---
image: matrixdotorg/synapse
description: "Synapse是Matrix协议的参考实现家庭服务器，用于搭建和运行Matrix网络中的主服务器，默认使用SQLite数据库，生产环境建议连接PostgreSQL，不含TURN服务器。"
source: https://xuanyuan.cloud/zh/r/matrixdotorg/synapse
canonical: https://xuanyuan.cloud/zh/r/matrixdotorg/synapse
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/matrixdotorg/synapse" title="matrixdotorg/synapse Docker 镜像中文简介、标签列表与拉取命令">matrixdotorg/synapse 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Synapse Docker

此Docker镜像以单进程方式运行Synapse。默认使用SQLite数据库；生产环境中建议连接独立的PostgreSQL数据库。该镜像不包含TURN服务器。

该镜像适用于所有Docker官方支持的平台。注意，Docker在Windows上的WS1后端Linux容器为实验性功能，不受此镜像支持。

## 卷

默认情况下，镜像需要一个位于`/data`的卷，用于存储：

* 配置文件；
* 上传的媒体文件和缩略图；
* 未配置PostgreSQL时的SQLite数据库；
* 应用服务配置。

您可根据可用的存储端点使用独立卷。例如，`/data/media`可存储在大容量但低性能的HDD存储上，而其他文件可存储在高性能端点。

要设置应用服务，只需在数据卷中创建`appservices`目录，并在其中写入应用服务YAML配置文件。支持多个应用服务。

## 生成配置文件

第一步是生成有效的配置文件。为此，可运行带`generate`命令行选项的镜像。

需指定`SYNAPSE_SERVER_NAME`和`SYNAPSE_REPORT_STATS`环境变量，并挂载Docker卷以存储配置。例如：

```
docker run -it --rm \
    --mount type=volume,src=synapse-data,dst=/data \
    -e SYNAPSE_SERVER_NAME=my.matrix.host \
    -e SYNAPSE_REPORT_STATS=yes \
    docker.xuanyuan.run/matrixdotorg/synapse:latest generate
```

有关选择合适服务器名称的信息，请参见[https://matrix-org.github.io/synapse/latest/setup/installation.html](https://matrix-org.github.io/synapse/latest/setup/installation.html)。

上述命令将在（通常）`/var/lib/docker/volumes/synapse-data/_data`中生成`homeserver.yaml`。应检查此文件并根据需要自定义。

`generate`模式支持以下环境变量：

* `SYNAPSE_SERVER_NAME`（必填）：服务器公共主机名。
* `SYNAPSE_REPORT_STATS`（必填，`yes`或`no`）：是否启用匿名统计报告。
* `SYNAPSE_HTTP_PORT`：Synapse监听HTTP流量的端口，默认为`8008`。
* `SYNAPSE_CONFIG_DIR`：存储其他配置文件（如日志配置和事件签名密钥）的目录，默认为`/data`。
* `SYNAPSE_CONFIG_PATH`：生成的配置文件路径，默认为`<SYNAPSE_CONFIG_DIR>/homeserver.yaml`。
* `SYNAPSE_DATA_DIR`：存储持久数据（如数据库和媒体存储）的目录，默认为`/data`。
* `UID`、`GID`：创建数据目录的用户ID和组ID，默认为`991`、`991`。

## 运行Synapse

拥有有效配置文件后，可按以下方式启动Synapse：

```
docker run -d --name synapse \
    --mount type=volume,src=synapse-data,dst=/data \
    -p 8008:8008 \
    docker.xuanyuan.run/matrixdotorg/synapse:latest
```

（假设8008是Synapse配置的HTTP监听端口。）

可通过以下命令检查启动是否正常：

```
docker logs synapse
```

若一切正常，访问`http://localhost:8008`应看到确认消息。

`run`模式支持以下环境变量：

* `SYNAPSE_CONFIG_DIR`：存储其他配置文件的目录，默认为`/data`。
* `SYNAPSE_CONFIG_PATH`：配置文件路径，默认为`<SYNAPSE_CONFIG_DIR>/homeserver.yaml`。
* `SYNAPSE_WORKER`：执行的模块，用于worker模式运行Synapse，默认为`synapse.app.homeserver`（适用于非worker模式）。
* `UID`、`GID`：运行Synapse的用户ID和组ID，默认为`991`、`991`。
* `TZ`：容器时区，默认为`UTC`（详见[时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)）。

对于更复杂的设置（如worker模式），可直接向Synapse传递参数。例如：

```
docker run -d --name synapse \
    --mount type=volume,src=synapse-data,dst=/data \
    -p 8008:8008 \
    docker.xuanyuan.run/matrixdotorg/synapse:latest run \
    -m synapse.app.generic_worker \
    --config-path=/data/homeserver.yaml \
    --config-path=/data/generic_worker.yaml
```

若未提供`-m`，则使用`SYNAPSE_WORKER`环境变量的值；若未提供至少一个`--config-path`或`-c`，则使用`SYNAPSE_CONFIG_PATH`环境变量的值。

## 生成（管理员）用户

Synapse运行后，可通过`register_new_matrix_user`创建用户。

需在配置文件中设置`registration_shared_secret`，并重启Synapse使更改生效。

然后执行脚本：

```
docker exec -it synapse register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml --help
```

不再需要时，记得删除`registration_shared_secret`并重启。

## TLS支持

默认配置暴露单个HTTP端口：`http://localhost:8008`，适用于本地测试。实际使用中，需使用反向代理或配置Synapse暴露HTTPS端口。

反向代理文档参见[https://github.com/matrix-org/synapse/blob/master/docs/reverse_proxy.md](https://github.com/matrix-org/synapse/blob/master/docs/reverse_proxy.md)。

在Synapse中启用TLS支持的更多信息，参见[https://matrix-org.github.io/synapse/latest/setup/installation.html#tls-certificates](https://matrix-org.github.io/synapse/latest/setup/installation.html#tls-certificates)。需通过`docker run`的`-p`参数暴露容器的TLS端口。

## 旧版动态配置文件支持

该Docker镜像曾支持基于环境变量创建动态配置文件，现已移除。若无配置文件运行Synapse将报错。

但可使用旧版模式的环境变量生成静态配置文件：运行带`migrate_config`命令的容器。例如：

```
docker run -it --rm \
    --mount type=volume,src=synapse-data,dst=/data \
    -e SYNAPSE_SERVER_NAME=my.matrix.host \
    -e SYNAPSE_REPORT_STATS=yes \
    docker.xuanyuan.run/matrixdotorg/synapse:latest migrate_config
```

这将生成与旧版模式相同的配置文件，存储在`/data/homeserver.yaml`，之后可按[运行Synapse](#运行synapse)部分使用。

注意，此配置文件的默认值可能与`generate`生成的不同（如默认启用TLS）。建议检查并编辑生成的配置文件以满足需求。

## 构建镜像

若需从Synapse源码构建镜像，从仓库根目录执行以下`docker build`命令：

```
docker build -t matrixdotorg/synapse -f docker/Dockerfile .
```

可通过更改`-f`参数指向其他Dockerfile构建不同镜像。

## 禁用健康检查

若在Docker内部使用非标准端口或TLS，运行`docker run`命令时可禁用健康检查：

```
--no-healthcheck
```

## 在docker-compose文件中禁用健康检查

若需在docker-compose中禁用健康检查，在服务配置中添加：

```
healthcheck:
  disable: true
```

## 在docker run中设置自定义健康检查

若需自定义健康检查指向不同端口，添加：

```
--health-cmd 'curl -fSs http://localhost:1234/health'
```

## 在docker-compose文件中设置健康检查

可添加以下配置自定义健康检查（需docker-compose版本>2.1）：

```
healthcheck:
  test: ["CMD", "curl", "-fSs", "http://localhost:8008/health"]
  interval: 15s
  timeout: 5s
  retries: 3
  start_period: 5s
```

## 使用jemalloc

镜像内置jemalloc，将替代默认分配器。有关jemalloc的信息，参见Synapse [README](https://github.com/matrix-org/synapse/blob/HEAD/README.rst#help-synapse-is-slow-and-eats-all-my-ram-cpu)。
