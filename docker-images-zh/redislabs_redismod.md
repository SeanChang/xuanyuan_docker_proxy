---
image: redislabs/redismod
description: "redismod是一个包含最新Redis及精选Redis Labs模块的Docker镜像，提供一站式Redis增强功能，包括搜索、图数据库、时序数据、AI模型服务、JSON支持等。"
source: https://xuanyuan.cloud/zh/r/redislabs/redismod
canonical: https://xuanyuan.cloud/zh/r/redislabs/redismod
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redislabs/redismod" title="redislabs/redismod Docker 镜像中文简介、标签列表与拉取命令">redislabs/redismod 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# redismod - 包含精选Redis Labs模块的Docker镜像

本容器镜像捆绑了最新稳定版的[Redis](https://redis.io)和来自[Redis Labs](https://redislabs.com)的精选Redis模块，提供增强的Redis功能支持。

## 快速开始

```text
$ docker pull docker.xuanyuan.run/redislabs/redismod
Using default tag: latest
...
$ docker run -p 6379:6379 redislabs/redismod
1:C 24 Apr 2019 21:46:40.382 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
...
1:M 24 Apr 2019 21:46:40.474 * Module 'ai' loaded from /usr/lib/redis/modules/redisai.so
1:M 24 Apr 2019 21:46:40.474 * <ft> RediSearch version 1.4.7 (Git=)
1:M 24 Apr 2019 21:46:40.474 * <ft> concurrency: ON, gc: ON, prefix min length: 2, prefix max expansions: 200, query timeout (ms): 500, timeout policy: return, cursor read size: 1000, cursor max idle (ms): 300000, max doctable size: 1000000, search pool size: 20, index pool size: 8,
1:M 24 Apr 2019 21:46:40.475 * <ft> Initialized thread pool!
1:M 24 Apr 2019 21:46:40.475 * Module 'ft' loaded from /usr/lib/redis/modules/redisearch.so
1:M 24 Apr 2019 21:46:40.476 * <graph> Thread pool created, using 8 threads.
1:M 24 Apr 2019 21:46:40.476 * Module 'graph' loaded from /usr/lib/redis/modules/redisgraph.so
loaded default MAX_SAMPLE_PER_CHUNK policy: 360
1:M 24 Apr 2019 21:46:40.476 * Module 'timeseries' loaded from /usr/lib/redis/modules/redistimeseries.so
1:M 24 Apr 2019 21:46:40.476 # <ReJSON> JSON data type for Redis v1.0.4 [encver 0]
1:M 24 Apr 2019 21:46:40.476 * Module 'ReJSON' loaded from /usr/lib/redis/modules/rejson.so
1:M 24 Apr 2019 21:46:40.476 * Module 'bf' loaded from /usr/lib/redis/modules/rebloom.so
1:M 24 Apr 2019 21:46:40.477 * <rg> RedisGears version 0.2.1, git_sha=fb97ad757eb7238259de47035bdd582735b5c81b
1:M 24 Apr 2019 21:46:40.477 * <rg> PythonHomeDir:/usr/lib/redis/modules/deps/cpython/
1:M 24 Apr 2019 21:46:40.477 * <rg> MaxExecutions:1000
1:M 24 Apr 2019 21:46:40.477 * <rg> RedisAI api loaded successfully.
1:M 24 Apr 2019 21:46:40.477 # <rg> RediSearch api loaded successfully.
1:M 24 Apr 2019 21:46:40.521 * Module 'rg' loaded from /usr/lib/redis/modules/redisgears.so
1:M 24 Apr 2019 21:46:40.521 * Ready to accept connections
```

## 容器中包含的模块

* [RediSearch](https://oss.redislabs.com/redisearch/): 全功能搜索引擎
* [RedisGraph](https://oss.redislabs.com/redisgraph/): 图数据库
* [RedisTimeSeries](https://oss.redislabs.com/redistimeseries/): 时序数据库
* [RedisAI](https://oss.redislabs.com/redisai/): 张量和深度学习模型服务器
* [RedisJSON](https://oss.redislabs.com/redisjson/): 原生JSON数据类型
* [RedisBloom](https://oss.redislabs.com/redisbloom/): 原生布隆过滤器和布谷鸟过滤器数据类型
* [RedisGears](https://oss.redislabs.com/redisgears/): 动态执行框架

## 配置Redis服务器

本镜像基于[官方Redis Docker镜像](https://hub.docker.com/_/redis/)构建。默认情况下，容器以Redis默认配置启动，并加载所有包含的模块。

可通过提供额外命令行参数或自定义[Redis配置文件](http://download.redis.io/redis-stable/redis.conf)覆盖默认设置。

### 使用命令行参数运行容器

可直接通过`docker`命令提供Redis配置指令。例如，启动容器并挂载数据卷、加载特定模块：

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  redislabs/redismod \
  --loadmodule /usr/lib/redis/modules/rebloom.so \
  --dir /data
```

### 使用配置文件运行容器

创建配置文件（如`/home/user/redis.conf`）：

```text
requirepass foobared
dir /data
loadmodule /usr/lib/redis/modules/rebloom.so
```

通过以下命令启动容器：

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  -v /home/user/redis.conf:/usr/local/etc/redis/redis.conf \
  redislabs/redismod \
  /usr/local/etc/redis/redis.conf
```

此时Redis将在主机6379端口监听，要求密码"foobared"，数据存储于`/home/user/data`，并仅加载Rebloom模块。

## 许可证

本Docker镜像采用3-Clause BSD许可证。

Redis采用3-Clause BSD许可证分发。Redis商标和徽标归Redis Labs Ltd所有，使用政策详见[Redis商标指南](https://redis.io/topics/trademark)。

容器中Redis模块的版权归Redis Labs所有，采用Redis Source Available许可证分发。
