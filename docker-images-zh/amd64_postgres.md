---
image: amd64/postgres
description: "PostgreSQL对象关系型数据库系统提供可靠性和数据完整性，支持复杂SQL查询、事务处理和高并发，适用于从小型应用到大型互联网服务的各种数据存储需求。"
source: https://xuanyuan.cloud/zh/r/amd64/postgres
canonical: https://xuanyuan.cloud/zh/r/amd64/postgres
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/postgres" title="amd64/postgres Docker 镜像中文简介、标签列表与拉取命令">amd64/postgres 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**注意：** 此镜像的描述超出了Hub的25000字符限制，因此已被截断。完整描述可在[https://github.com/docker-library/docs/tree/master/postgres/README.md](https://github.com/docker-library/docs/tree/master/postgres/README.md)查看。另请参阅[docker/hub-feedback#238](https://github.com/docker/hub-feedback/issues/238)和[docker/roadmap#475](https://github.com/docker/roadmap/issues/475)。

**注意：** 这是[`postgres`官方镜像](https://hub.docker.com/_/postgres)的`amd64`架构构建的"每架构"仓库——更多信息，请参阅官方镜像文档中的["除amd64之外的架构？"](https://github.com/docker-library/official-images#architectures-other-than-amd64)和官方镜像FAQ中的["Git中的镜像源已更改，现在该怎么办？"](https://github.com/docker-library/faq#an-images-source-changed-in-git-now-what)。

# 快速参考

- **维护者：**  
  [PostgreSQL Docker社区](https://github.com/docker-library/postgres)

- **获取帮助：**  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)或[Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的`Dockerfile`链接

- [`18.0`, `18`, `latest`, `18.0-trixie`, `18-trixie`, `trixie`](https://github.com/docker-library/postgres/blob/22ca5c8d8e4b37bece4d38dbce1a060583b5308a/18/trixie/Dockerfile)

- [`18.0-bookworm`, `18-bookworm`, `bookworm`](https://github.com/docker-library/postgres/blob/22ca5c8d8e4b37bece4d38dbce1a060583b5308a/18/bookworm/Dockerfile)

- [`18.0-alpine3.22`, `18-alpine3.22`, `alpine3.22`, `18.0-alpine`, `18-alpine`, `alpine`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/18/alpine3.22/Dockerfile)

- [`18.0-alpine3.21`, `18-alpine3.21`, `alpine3.21`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/18/alpine3.21/Dockerfile)

- [`17.6`, `17`, `17.6-trixie`, `17-trixie`](https://github.com/docker-library/postgres/blob/87e6f65859a53d10c5170a587def1bfc882d3830/17/trixie/Dockerfile)

- [`17.6-bookworm`, `17-bookworm`](https://github.com/docker-library/postgres/blob/87e6f65859a53d10c5170a587def1bfc882d3830/17/bookworm/Dockerfile)

- [`17.6-alpine3.22`, `17-alpine3.22`, `17.6-alpine`, `17-alpine`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/17/alpine3.22/Dockerfile)

- [`17.6-alpine3.21`, `17-alpine3.21`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/17/alpine3.21/Dockerfile)

- [`16.10`, `16`, `16.10-trixie`, `16-trixie`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/16/trixie/Dockerfile)

- [`16.10-bookworm`, `16-bookworm`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/16/bookworm/Dockerfile)

- [`16.10-alpine3.22`, `16-alpine3.22`, `16.10-alpine`, `16-alpine`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/16/alpine3.22/Dockerfile)

- [`16.10-alpine3.21`, `16-alpine3.21`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/16/alpine3.21/Dockerfile)

- [`15.14`, `15`, `15.14-trixie`, `15-trixie`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/15/trixie/Dockerfile)

- [`15.14-bookworm`, `15-bookworm`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/15/bookworm/Dockerfile)

- [`15.14-alpine3.22`, `15-alpine3.22`, `15.14-alpine`, `15-alpine`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/15/alpine3.22/Dockerfile)

- [`15.14-alpine3.21`, `15-alpine3.21`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/15/alpine3.21/Dockerfile)

- [`14.19`, `14`, `14.19-trixie`, `14-trixie`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/14/trixie/Dockerfile)

- [`14.19-bookworm`, `14-bookworm`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/14/bookworm/Dockerfile)

- [`14.19-alpine3.22`, `14-alpine3.22`, `14.19-alpine`, `14-alpine`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/14/alpine3.22/Dockerfile)

- [`14.19-alpine3.21`, `14-alpine3.21`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/14/alpine3.21/Dockerfile)

- [`13.22`, `13`, `13.22-trixie`, `13-trixie`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/13/trixie/Dockerfile)

- [`13.22-bookworm`, `13-bookworm`](https://github.com/docker-library/postgres/blob/a2433755c76d294477c85945d68944f8cdb7cf4b/13/bookworm/Dockerfile)

- [`13.22-alpine3.22`, `13-alpine3.22`, `13.22-alpine`, `13-alpine`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/13/alpine3.22/Dockerfile)

- [`13.22-alpine3.21`, `13-alpine3.21`](https://github.com/docker-library/postgres/blob/2c751341b6454412f2048de021a1f185212939de/13/alpine3.21/Dockerfile)

# 快速参考（续）

- **问题反馈地址：**  
  [https://github.com/docker-library/postgres/issues](https://github.com/docker-library/postgres/issues?q=)

- **支持的架构：**（[更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64)）  
  [`amd64`](https://hub.docker.com/r/amd64/postgres/)、[`arm32v5`](https://hub.docker.com/r/arm32v5/postgres/)、[`arm32v6`](https://hub.docker.com/r/arm32v6/postgres/)、[`arm32v7`](https://hub.docker.com/r/arm32v7/postgres/)、[`arm64v8`](https://hub.docker.com/r/arm64v8/postgres/)、[`i386`](https://hub.docker.com/r/i386/postgres/)、[`mips64le`](https://hub.docker.com/r/mips64le/postgres/)、[`ppc64le`](https://hub.docker.com/r/ppc64le/postgres/)、[`riscv64`](https://hub.docker.com/r/riscv64/postgres/)、[`s390x`](https://hub.docker.com/r/s390x/postgres/)

- **镜像 artifact 详情：**  
  [repo-info 仓库的 `repos/postgres/` 目录](https://github.com/docker-library/repo-info/blob/master/repos/postgres)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/postgres)）  
  （镜像元数据、传输大小等）

- **镜像更新：**  
  [official-images 仓库的 `library/postgres` 标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fpostgres)  
  [official-images 仓库的 `library/postgres` 文件](https://github.com/docker-library/official-images/blob/master/library/postgres)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/postgres)）

- **本文档来源：**  
  [docs 仓库的 `postgres/` 目录](https://github.com/docker-library/docs/tree/master/postgres)（[历史记录](https://github.com/docker-library/docs/commits/master/postgres)）

# 什么是 PostgreSQL？

PostgreSQL（通常简称为"Postgres"）是一个对象关系型数据库管理系统（ORDBMS），强调可扩展性和标准合规性。作为数据库服务器，其主要功能是安全地存储数据并支持最佳实践，随后根据其他软件应用的请求检索数据，这些应用可能运行在同一台计算机上，也可能运行在网络（包括互联网）中的另一台计算机上。它可以处理从小型单机应用到具有大量并发用户的大型互联网应用的各种工作负载。最新版本还提供数据库本身的复制功能，以增强安全性和可扩展性。

PostgreSQL 实现了 SQL:2011 标准的大部分内容，支持 ACID 事务（包括大多数 DDL 语句），使用多版本并发控制（MVCC）避免锁定问题，提供脏读免疫和完全可串行化；使用许多其他数据库不具备的索引方法处理复杂 SQL 查询；支持可更新视图、物化视图、触发器、外键；支持函数和存储过程等扩展功能，并有大量第三方编写的扩展。除了能够与主要的专有和开源数据库协作外，PostgreSQL 通过广泛的标准 SQL 支持和可用的迁移工具支持从这些数据库迁移。如果使用了专有扩展，其可扩展性可以通过一些内置和第三方开源兼容性扩展（如 Oracle 兼容扩展）来模拟许多功能。

> [wikipedia.org/wiki/PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/postgres/logo.png)

# 如何使用此镜像

## 启动 PostgreSQL 实例

```console
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d amd64/postgres
```

默认的 `postgres` 用户和数据库在入口点通过 `initdb` 创建。

> postgres 数据库是一个默认数据库，供用户、工具和第三方应用使用。
>
> [postgresql.org/docs](https://www.postgresql.org/docs/14/app-initdb.html)

## ... 或通过 `psql` 使用

```console
$ docker run -it --rm --network some-network amd64/postgres psql -h some-postgres -U postgres
psql (14.3)
Type "help" for help.

postgres=# SELECT 1;
 ?column? 
----------
        1
(1 row)
```

## ... 通过 [`docker compose`](https://github.com/docker/compose) 使用

`postgres` 的 `compose.yaml` 示例：

```yaml
# 使用 postgres/example 用户/密码凭据

services:

  db:
    image: docker.xuanyuan.run/postgres
    restart: always
    # 使用 docker compose 时设置共享内存限制
    shm_size: 128mb
    # 或通过 swarm stack 部署时设置共享内存限制
    #volumes:
    #  - type: tmpfs
    #    target: /dev/shm
    #    tmpfs:
    #      size: 134217728 # 128*2^20 字节 = 128Mb
    environment:
      POSTGRES_PASSWORD: example

  adminer:
    image: docker.xuanyuan.run/adminer
    restart: always
    ports:
      - 8080:8080
```

运行 `docker compose up`，等待完全初始化后，访问 `http://localhost:8080` 或 `http://host-ip:8080`（根据实际情况）。

# 如何扩展此镜像

有多种方式可以扩展 `postgres` 镜像。这里不尝试支持所有可能的用例，仅介绍一些我们认为有用的方式。

## 环境变量

PostgreSQL 镜像使用多个容易被忽略的环境变量。唯一必需的变量是 `POSTGRES_PASSWORD`，其余为可选。

**警告：** 只有当您使用空数据目录启动容器时，Docker 特定变量才会生效；容器启动时，任何预先存在的数据库都将保持不变。

### `POSTGRES_PASSWORD`

此环境变量是使用 PostgreSQL 镜像所必需的。它不能为空或未定义。此环境变量设置 PostgreSQL 的超级用户密码。默认超级用户由 `POSTGRES_USER` 环境变量定义。

**注意 1：** PostgreSQL 镜像在本地设置了 `trust` 身份验证，因此您可能会注意到从 `localhost`（容器内部）连接时不需要密码。但是，如果从不同的主机/容器连接，则需要密码。

**注意 2：** 此变量定义 PostgreSQL 实例中的超级用户密码，由初始容器启动期间
