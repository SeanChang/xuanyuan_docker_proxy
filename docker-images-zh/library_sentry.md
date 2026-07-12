---
image: library/sentry
description: "该Docker镜像已弃用，详情请参见https://develop.sentry.dev/self-hosted/。"
source: https://xuanyuan.cloud/zh/r/library/sentry
canonical: https://xuanyuan.cloud/zh/r/library/sentry
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/sentry" title="library/sentry Docker 镜像中文简介、标签列表与拉取命令">library/sentry 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Sentry Docker 镜像文档

## 弃用通知

此镜像已被弃用，建议使用完整安装方案，请参考 [自托管 Sentry 文档](https://develop.sentry.dev/self-hosted/)（最后更新于 2019 年 7 月；[getsentry/docker-sentry#189](https://github.com/getsentry/docker-sentry/pull/189)）。

## 镜像概述和主要用途

Sentry 是一个实时事件日志记录和聚合平台，专注于错误监控，并提取进行事后分析所需的所有信息，无需标准用户反馈循环的繁琐流程。

## 核心功能和特性

- 实时错误监控与报告
- 事件聚合与分析
- 错误详情捕获与上下文信息收集
- 支持多种编程语言和框架集成
- 可扩展的架构设计

## 使用场景和适用范围

Sentry 适用于需要实时监控应用程序错误的开发团队和组织，可帮助开发人员快速识别、诊断和解决生产环境中的问题，提高应用程序稳定性和用户体验。

## 快速参考

- **维护者**：[Sentry](https://github.com/getsentry/docker-sentry)
- **获取帮助**：[Docker 社区论坛](https://forums.docker.com/)、[Docker 社区 Slack](https://dockr.ly/slack) 或 [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)
- **提交问题**：[https://github.com/getsentry/docker-sentry/issues](https://github.com/getsentry/docker-sentry/issues)
- **支持的架构**：无
- **镜像更新**：[official-images repo 的 `library/sentry` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fsentry)

## 详细使用方法和配置说明

### 完整 Sentry 实例设置步骤

1. **启动 Redis 容器**

```console
$ docker run -d --name sentry-redis redis
```

2. **启动 Postgres 容器**

```console
$ docker run -d --name sentry-postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=sentry postgres
```

3. **生成新的密钥**

此密钥将用作 `SENTRY_SECRET_KEY` 环境变量，供所有 Sentry 容器共享。

```console
$ docker run --rm sentry config generate-secret-key
```

4. **数据库初始化（新数据库需要执行）**

```console
$ docker run -it --rm -e SENTRY_SECRET_KEY='<secret-key>' --link sentry-postgres:postgres --link sentry-redis:redis sentry upgrade
```

**注意：`-it` 参数非常重要，因为初始升级会提示创建初始用户，缺少此参数将导致失败。**

5. **启动 Sentry 服务器**

```console
$ docker run -d --name my-sentry -e SENTRY_SECRET_KEY='<secret-key>' --link sentry-redis:redis --link sentry-postgres:postgres sentry
```

6. **启动 Celery 组件**

默认配置需要 Celery Beat 和 Celery Workers，根据需要启动多个 worker（每个使用唯一名称）：

```console
$ docker run -d --name sentry-cron -e SENTRY_SECRET_KEY='<secret-key>' --link sentry-postgres:postgres --link sentry-redis:redis sentry run cron
$ docker run -d --name sentry-worker-1 -e SENTRY_SECRET_KEY='<secret-key>' --link sentry-postgres:postgres --link sentry-redis:redis sentry run worker
```

### 端口映射

如果希望从主机访问实例而不使用容器 IP，可以使用标准端口映射。只需将 `-p 8080:9000` 添加到 `docker run` 参数中，然后在浏览器中访问 `http://localhost:8080` 或 `http://host-ip:8080`。

```console
$ docker run -d --name my-sentry -p 8080:9000 -e SENTRY_SECRET_KEY='<secret-key>' --link sentry-redis:redis --link sentry-postgres:postgres sentry
```

### 配置初始用户

如果在 `upgrade` 过程中未创建超级用户，可使用以下命令创建：

```console
$ docker run -it --rm -e SENTRY_SECRET_KEY='<secret-key>' --link sentry-redis:redis --link sentry-postgres:postgres sentry createuser
```

## 环境变量

启动 `sentry` 镜像时，可以通过在 `docker run` 命令行上传递一个或多个环境变量来调整 Sentry 实例的配置。请注意，这些环境变量仅作为快速启动使用，强烈建议挂载自己的配置文件或使用 `sentry:onbuild` 变体。

### `SENTRY_SECRET_KEY`

用于 Sentry 内加密功能的密钥。此密钥应唯一且在所有运行实例中保持一致。可通过以下方式生成新密钥：

```console
$ docker run --rm sentry config generate-secret-key
```

### 数据库相关变量

- `SENTRY_POSTGRES_HOST`: Postgres 服务器主机名
- `SENTRY_POSTGRES_PORT`: Postgres 服务器端口
- `SENTRY_DB_NAME`: 数据库名称
- `SENTRY_DB_USER`: 数据库用户名
- `SENTRY_DB_PASSWORD`: 数据库密码

如果存在链接的 `postgres` 容器，则不需要这些值。

### Redis 相关变量

- `SENTRY_REDIS_HOST`: Redis 服务器主机名
- `SENTRY_REDIS_PORT`: Redis 服务器端口
- `SENTRY_REDIS_DB`: Redis 数据库编号

如果存在链接的 `redis` 容器，则不需要这些值。

### Memcached 相关变量

- `SENTRY_MEMCACHED_HOST`: Memcache 服务器主机名
- `SENTRY_MEMCACHED_PORT`: Memcache 服务器端口

如果存在链接的 `memcached` 容器，则不需要这些值。

### 文件存储相关变量

- `SENTRY_FILESTORE_DIR`: 上传文件的存储目录，默认为 `/var/lib/sentry/files`，是用于持久数据的 `VOLUME`。

### 邮件相关变量

- `SENTRY_SERVER_EMAIL`: 出站邮件中 `From:` 使用的电子邮件地址，默认为 `root@localhost`
- `SENTRY_EMAIL_HOST`: SMTP 服务器主机名
- `SENTRY_EMAIL_PORT`: SMTP 服务器端口
- `SENTRY_EMAIL_USER`: SMTP 用户名
- `SENTRY_EMAIL_PASSWORD`: SMTP 密码
- `SENTRY_EMAIL_USE_TLS`: 是否使用 TLS，布尔值

如果存在链接的 `smtp` 容器，则不需要这些值。

### Mailgun 相关变量

- `SENTRY_MAILGUN_API_KEY`: 如果使用 Mailgun 处理入站邮件，请设置此 API 密钥并配置路由转发到 `/api/hooks/mailgun/inbound/`。

## Docker Compose 配置示例

```yaml
version: '3'

services:
  redis:
    image: docker.xuanyuan.run/redis
    restart: always
    
  postgres:
    image: docker.xuanyuan.run/postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_USER: sentry
      
  sentry:
    image: docker.xuanyuan.run/sentry
    restart: always
    depends_on:
      - redis
      - postgres
    environment:
      SENTRY_SECRET_KEY: '<secret-key>'
    ports:
      - "8080:9000"
      
  sentry-cron:
    image: docker.xuanyuan.run/sentry
    restart: always
    depends_on:
      - redis
      - postgres
    environment:
      SENTRY_SECRET_KEY: '<secret-key>'
    command: run cron
    
  sentry-worker:
    image: docker.xuanyuan.run/sentry
    restart: always
    depends_on:
      - redis
      - postgres
    environment:
      SENTRY_SECRET_KEY: '<secret-key>'
    command: run worker
```

## 许可证

有关此镜像中包含的软件的许可信息，请查看 [许可信息](https://github.com/getsentry/sentry/blob/master/LICENSE)。

与所有 Docker 镜像一样，这些镜像可能还包含其他软件，这些软件可能受其他许可证（如基础发行版中的 Bash 等，以及主要软件的任何直接或间接依赖项）约束。

一些能够自动检测到的其他许可信息可能会在 [repo-info 仓库的 `sentry/` 目录](https://github.com/docker-library/repo-info/tree/master/repos/sentry) 中找到。

至于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用符合其中包含的所有软件的任何相关许可。
