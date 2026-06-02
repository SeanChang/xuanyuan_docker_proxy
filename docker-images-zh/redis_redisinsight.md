<!-- xuanyuan-docker-images-zh
image: redis/redisinsight
source: https://xuanyuan.cloud/zh/r/redis/redisinsight
canonical: https://xuanyuan.cloud/zh/r/redis/redisinsight
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [redis/redisinsight — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/redis/redisinsight "redis/redisinsight Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/redis/redisinsight

# Redis Insight 介绍与使用指南


## 一、概述

Redis Insight 是面向 Redis 开发者的工具，支持各类 Redis 部署环境（包括 Redis Open Source、Redis Stack、Redis Enterprise Software、Redis Enterprise Cloud 及 Amazon ElastiCache），可优化开发流程。核心功能包括：可视化浏览与操作数据、提供高级命令行界面及诊断工具等（更多功能见 [项目仓库]([])）。

若你觉得 Redis Insight 实用，欢迎为 [GitHub 仓库]([]) 点亮 star，让我们了解你对工具的认可。


## 二、通过 Docker 运行 Redis Insight

以下是两种 Docker 安装方式，按需选择：


### 1. 不持久化数据

直接运行容器，数据不会保留：

```bash
docker run -d --name redisinsight -p 5540:5540 redis/redisinsight:latest
```


### 2. 持久化数据

需先将 Docker 卷挂载到 `/data` 路径，再执行命令：

```bash
docker run -d --name redisinsight -p 5540:5540 -v redisinsight:/data redis/redisinsight:latest
```

#### 权限问题处理
若上述命令返回权限错误，需确保 ID 为 1000 的用户对挂载的卷（如示例中的 `redisinsight`）有访问权限。


### 访问与健康检查
- 启动后，浏览器访问 `[] 即可使用。
- 健康检查端点：`[] 三、配置环境变量

可通过环境变量自定义 Redis Insight 运行参数，配置项如下：

| 变量名               | 用途                     | 默认值                                  | 补充说明                                                                 |
|----------------------|--------------------------|-----------------------------------------|--------------------------------------------------------------------------|
| RI_APP_PORT          | 监听端口                 | Docker: 5540<br>桌面版: 5530            | 详见 [Express 文档]([])        |
| RI_APP_HOST          | 连接主机                 | Docker: 0.0.0.0<br>桌面版: 127.0.0.1    | 详见 [Express 文档]([])        |
| RI_SERVER_TLS_KEY    | HTTPS 私钥               | n/a                                     | PEM 格式（可路径或字符串），参考 [PEM 格式说明]([]) |
| RI_SERVER_TLS_CERT   | HTTPS 证书               | n/a                                     | PEM 格式公钥证书，参考 [PEM 格式说明]([]) |
| RI_ENCRYPTION_KEY    | 数据加密密钥             | n/a                                     | 仅 Docker 可用；用于加密本地存储的敏感信息（如数据库密码、Workbench 历史），需与后续 `docker run` 命令使用相同密钥解密 |
| RI_LOG_LEVEL         | 日志级别                 | `info`                                  | 优先级从高到低：error > warn > info > http > verbose > debug > silly    |
| RI_FILES_LOGGER      | 日志写入文件             | `true`                                  | Docker 日志路径：`/data/logs`；桌面版：`<用户主目录>/.redisinsight-app/logs` |
| RI_STDOUT_LOGGER     | 日志输出到 STDOUT        | `true`                                  |                                                                          |
| RI_PROXY_PATH        | 代理子路径配置           | n/a                                     | 仅 Docker 可用                                                           |
| RI_DATABASE_MANAGEMENT | 禁用数据库连接管理       | `true`                                  | 设为 `false` 时，无法添加、编辑或删除数据库连接                          |


## 四、预配置数据库连接

Redis Insight 支持通过环境变量或 JSON 文件预配置数据库连接，实现集中化高效配置。以下是两种方式的具体操作：


### 方式一：通过环境变量配置

#### 注意事项：
- 配置多个数据库连接时，需将每个环境变量中的 `*` 替换为唯一标识符（如 1、2 等）；仅配置单个连接时可省略 `*`，默认 ID 为 0。
- 修改环境变量后，需重启 Redis Insight 生效。
- 若重启时未携带这些环境变量，已添加的连接将被清除。

| 变量名                  | 用途                     | 默认值              | 补充说明                                                                 |
|-------------------------|--------------------------|---------------------|--------------------------------------------------------------------------|
| RI_REDIS_HOST*          | Redis 数据库主机         | N/A                 |                                                                          |
| RI_REDIS_PORT*          | Redis 数据库端口         | `6379`              |                                                                          |
| RI_REDIS_ALIAS*         | 连接别名                 | `{host}:{port}`     |                                                                          |
| RI_REDIS_USERNAME*      | 连接用户名               | `default`           |                                                                          |
| RI_REDIS_PASSWORD*      | 连接密码                 | 无密码              |                                                                          |
| RI_REDIS_TLS*           | 是否启用 TLS 连接        | `FALSE`             | 接受 `TRUE` 或 `FALSE`                                                   |
| RI_REDIS_TLS_CA_BASE64* | CA 证书（base64 格式）   | N/A                 | 可通过此变量提供，或通过 `RI_REDIS_TLS_CA_PATH*` 指定文件路径            |
| RI_REDIS_TLS_CA_PATH*   | CA 证书文件路径          | N/A                 |                                                                          |
| RI_REDIS_TLS_CERT_BASE64* | 客户端证书（base64 格式） | N/A                 | 可通过此变量提供，或通过 `RI_REDIS_TLS_CERT_PATH*` 指定文件路径          |
| RI_REDIS_TLS_CERT_PATH* | 客户端证书文件路径        | N/A                 |                                                                          |
| RI_REDIS_TLS_KEY_BASE64* | 客户端私钥（base64 格式） | N/A                 | 可通过此变量提供，或通过 `RI_REDIS_TLS_KEY_PATH*` 指定文件路径            |
| RI_REDIS_TLS_KEY_PATH*  | 客户端私钥文件路径        | N/A                 |                                                                          |


### 方式二：通过 JSON 文件配置

#### 注意事项：
- JSON 文件格式需与 Redis Insight 导出的数据库连接配置文件一致。
- 文件中需为每个连接指定唯一 `id`，避免冲突。
- 修改 JSON 文件后，需重启 Redis Insight 生效。
- 若移除 JSON 文件，通过该文件添加的连接将被清除。


## 五、Redis Insight API

API 文档地址：[]
