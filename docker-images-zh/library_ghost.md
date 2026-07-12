---
image: library/ghost
description: "用于通过网络和电子邮件通讯发布内容，支持会员注册及订阅支付的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/library/ghost
canonical: https://xuanyuan.cloud/zh/r/library/ghost
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/ghost" title="library/ghost Docker 镜像中文简介、标签列表与拉取命令">library/ghost 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ghost Docker 镜像文档

## 1. 镜像概述和主要用途

Ghost 是一个独立的在线发布平台，支持通过网页和电子邮件通讯进行内容发布。它内置了用户注册、访问权限控制和订阅支付功能（通过 Stripe 集成），让你能够与受众建立直接联系。Ghost 运行速度快、用户友好，基于 Node.js 和 MySQL8 构建。

![logo](https://raw.githubusercontent.com/docker-library/docs/c88522f95bebcab2322f3020f2f735210286939b/ghost/logo.png)

## 2. 核心功能和特性

- **多渠道发布**：支持网页和电子邮件通讯内容发布
- **用户管理**：内置用户注册和身份验证系统
- **访问控制**：支持内容访问权限管理（ gated access ）
- **订阅支付**：通过 Stripe 集成实现订阅支付功能
- **技术栈**：基于 Node.js 和 MySQL8 构建，性能高效
- **用户友好**：直观的管理界面，易于使用
- **可扩展性**：支持通过环境变量进行灵活配置

## 3. 使用场景和适用范围

- 个人博客和内容创作平台
- 电子邮件新闻通讯发布系统
- 需要会员订阅功能的独立网站
- 创作者与受众建立直接联系的内容平台
- 中小型媒体或自媒体的内容发布解决方案

## 4. 支持的标签及对应 Dockerfile 链接

- `6.3.1`, `6.3`, `6`, `latest` [Dockerfile](https://github.com/docker-library/ghost/blob/d9131c1c24594d782e0ddac3a98daae9237a1202/6/debian/Dockerfile)
- `6.3.1-alpine`, `6.3-alpine`, `6-alpine`, `alpine` [Dockerfile](https://github.com/docker-library/ghost/blob/d9131c1c24594d782e0ddac3a98daae9237a1202/6/alpine/Dockerfile)
- `5.130.5`, `5.130`, `5` [Dockerfile](https://github.com/docker-library/ghost/blob/fdba3d80f50da610007165f5fe46f9b8af69764b/5/debian/Dockerfile)
- `5.130.5-alpine`, `5.130-alpine`, `5-alpine` [Dockerfile](https://github.com/docker-library/ghost/blob/fdba3d80f50da610007165f5fe46f9b8af69764b/5/alpine/Dockerfile)

## 5. 详细使用方法和配置说明

### 5.1 基础使用（开发模式）

以下命令将启动一个 Ghost 开发实例，默认监听 2368 端口（Ghost 标准端口）：

```console
$ docker run -d --name some-ghost -e NODE_ENV=development ghost
```

### 5.2 自定义端口

如需从主机直接访问实例（无需通过容器 IP），可使用端口映射：

```console
$ docker run -d \
  --name some-ghost \
  -e NODE_ENV=development \
  -e url=http://localhost:3001 \  # 设置访问 URL
  -p 3001:2368 \                 # 主机端口:容器端口
  ghost
```

成功启动后，可通过 `http://localhost:3001` 访问网站，通过 `http://localhost:3001/ghost` 访问管理后台（若使用远程服务器，将 `localhost` 替换为服务器 IP）。

### 5.3 持久化存储

Ghost 的内容数据（如文章、图片等）需持久化存储以避免容器重启后丢失。可通过绑定主机目录或 Docker 卷实现。

#### 5.3.1 绑定主机目录

以下示例使用 Alpine 版本镜像，并将主机目录挂载到容器内的内容目录：

```console
$ docker run -d \
  --name some-ghost \
  -e NODE_ENV=development \
  -e database__connection__filename='/var/lib/ghost/content/data/ghost.db' \  # SQLite 数据库路径（仅开发模式）
  -p 3001:2368 \
  -v /path/to/ghost/blog:/var/lib/ghost/content \  # 主机目录:容器内容目录
  ghost:alpine
```

> **注意**：`database__connection__filename` 仅在开发模式下有效，用于指定 SQLite 数据库文件路径，必须设置为持久化目录内的可写路径。生产模式下不支持 SQLite，需使用外部 MySQL 服务器（见 5.7 节）。

#### 5.3.2 使用 Docker 卷

推荐使用 Docker 命名卷而非直接绑定主机路径，更便于管理：

```console
$ docker run -d \
  --name some-ghost \
  -e NODE_ENV=development \
  -e database__connection__filename='/var/lib/ghost/content/data/ghost.db' \
  -p 3001:2368 \
  -v some-ghost-data:/var/lib/ghost/content \  # Docker 卷:容器内容目录
  ghost
```

### 5.4 配置参数

所有 Ghost 配置参数（如 `url`）均可通过环境变量指定。配置键与环境变量的转换规则为：嵌套键使用双下划线（`__`）连接（例如 `database.connection.host` 对应 `database__connection__host`）。详细配置说明见 [Ghost 官方文档](https://ghost.org/docs/concepts/config/#running-ghost-with-config-env-variables)。

示例：设置网站 URL 和数据库连接参数

```console
$ docker run -d \
  --name some-ghost \
  -e NODE_ENV=development \
  -e url=http://some-ghost.example.com \
  -e database__connection__host=db \
  -e database__connection__user=root \
  ghost
```

### 5.5 查看 Node.js 版本

提交 Ghost 相关 issue 时可能需要提供 Node.js 版本，可通过以下命令获取：

```console
$ docker exec <container-id> node --version
vX.Y.Z  # Node.js 版本输出
```

### 5.6 Ghost-CLI 注意事项

尽管镜像中包含 Ghost-CLI，但许多 CLI 命令在 Docker 环境中无法正常工作，也非设计用于此场景。详细说明见 [docker-library/ghost#156](https://github.com/docker-library/ghost/issues/156#issuecomment-428159861)。

### 5.7 生产模式部署（使用 MySQL）

生产环境下，Ghost 要求使用外部 MySQL 数据库（不支持 SQLite），并需配置 HTTPS 和反向代理（需设置 `X-Forwarded-For`、`X-Forwarded-Host`、`X-Forwarded-Proto` 头）。

#### 5.7.1 Docker Compose 示例

以下 `compose.yaml` 配置启动 Ghost 生产实例和 MySQL 数据库：

```yaml
services:
  ghost:
    image: docker.xuanyuan.run/ghost:5-alpine  # 使用 Alpine 版本
    restart: always
    ports:
      - 8080:2368  # 可根据需求修改主机端口
    environment:
      # 数据库配置（需与 MySQL 服务参数对应）
      database__client: mysql
      database__connection__host: db
      database__connection__user: root
      database__connection__password: example  # MySQL 密码
      database__connection__database: ghost    # 数据库名称
      url: http://localhost:8080  # 生产环境需替换为实际域名（如 https://blog.example.com）
      # NODE_ENV: development  # 如需开发模式，取消注释此行（默认生产模式）
    volumes:
      - ghost:/var/lib/ghost/content  # 持久化 Ghost 内容

  db:
    image: docker.xuanyuan.run/mysql:8.0  # Ghost 要求 MySQL 8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example  # 与 Ghost 的 database__connection__password 一致
    volumes:
      - db:/var/lib/mysql  # 持久化 MySQL 数据

volumes:
  ghost:  # Ghost 内容卷
  db:     # MySQL 数据卷
```

启动服务：

```console
$ docker compose up -d
```

服务初始化完成后，通过 `http://localhost:8080` 访问网站（生产环境需配置域名和 HTTPS）。

## 6. 镜像变体说明

### 6.1 `ghost:<version>`（默认镜像）

基于 Debian 系统构建，是最常用的镜像版本。适用于大多数场景，兼容性好，包含必要的系统工具。如无特殊需求，推荐使用此版本。

### 6.2 `ghost:<version>-alpine`（Alpine 版本）

基于 Alpine Linux 构建，镜像体积显著更小（Alpine 基础镜像约 5MB），适合对镜像大小有严格要求的场景。

**注意**：Alpine 使用 `musl libc` 而非 `glibc`，部分依赖 glibc 的软件可能存在兼容性问题。如需使用额外工具（如 `git`、`bash`），需在 Dockerfile 中手动安装。

## 7. 许可证信息

- 镜像中软件的许可证信息：[Ghost 官方许可证](https://ghost.org/license/)
- 镜像可能包含其他软件（如基础系统组件、依赖库等），其许可证需参考各自文档。
- 自动检测的许可证信息：[repo-info 仓库的 ghost 目录](https://github.com/docker-library/repo-info/tree/master/repos/ghost)

使用本镜像时，需确保遵守所有包含软件的许可证要求。

## 8. 参考链接

- **维护者**：[Docker Community](https://github.com/docker-library/ghost)
- **获取帮助**：[Docker Community Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)、[Stack Overflow](https://stackoverflow.com/help/on-topic)
- **提交问题**：[ghost 镜像 GitHub  Issues](https://github.com/docker-library/ghost/issues)
- **支持架构**：`amd64`、`arm32v6`、`arm32v7`、`arm64v8`、`ppc64le`、`s390x`（[详细信息](https://github.com/docker-library/official-images#architectures-other-than-amd64)）
- **镜像元数据**：[repo-info 仓库的 ghost 目录](https://github.com/docker-library/repo-info/blob/master/repos/ghost)
- **Ghost 官方文档**：[Ghost.org](https://ghost.org/docs/)
