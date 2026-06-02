<!-- xuanyuan-docker-images-zh
image: library/redmine
source: https://xuanyuan.cloud/zh/r/library/redmine
canonical: https://xuanyuan.cloud/zh/r/library/redmine
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/redmine" title="library/redmine Docker 镜像中文简介、标签列表与拉取命令">library/redmine — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/redmine" title="library/redmine Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/redmine</a></p>

# Redmine Docker 镜像使用指南


## 快速参考

- **维护方**：  
  [Docker社区]([])

- **获取帮助**：  
  [Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])


## 支持的标签及对应 Dockerfile 链接

- [`6.1.0`, `6.1`, `6`, `latest`, `6.1.0-trixie`, `6.1-trixie`, `6-trixie`, `trixie`]([])

- [`6.1.0-bookworm`, `6.1-bookworm`, `6-bookworm`, `bookworm`]([])

- [`6.1.0-alpine3.22`, `6.1-alpine3.22`, `6-alpine3.22`, `alpine3.22`, `6.1.0-alpine`, `6.1-alpine`, `6-alpine`, `alpine`]([])

- [`6.1.0-alpine3.21`, `6.1-alpine3.21`, `6-alpine3.21`, `alpine3.21`]([])

- [`6.0.7`, `6.0`, `6.0.7-trixie`, `6.0-trixie`]([])

- [`6.0.7-bookworm`, `6.0-bookworm`]([])

- [`6.0.7-alpine3.22`, `6.0-alpine3.22`, `6.0.7-alpine`, `6.0-alpine`]([])

- [`6.0.7-alpine3.21`, `6.0-alpine3.21`]([])

- [`5.1.10`, `5.1`, `5`, `5.1.10-trixie`, `5.1-trixie`, `5-trixie`]([])

- [`5.1.10-bookworm`, `5.1-bookworm`, `5-bookworm`]([])

- [`5.1.10-alpine3.22`, `5.1-alpine3.22`, `5-alpine3.22`, `5.1.10-alpine`, `5.1-alpine`, `5-alpine`]([])

- [`5.1.10-alpine3.21`, `5.1-alpine3.21`, `5-alpine3.21`]([])


## 快速参考（续）

- **提交问题**：  
  [GitHub仓库issues页面]([])

- **支持的架构**：（[更多信息]([])）  
  [`amd64`]([]), [`arm32v5`]([]), [`arm32v6`]([]), [`arm32v7`]([]), [`arm64v8`]([]), [`i386`]([]), [`mips64le`]([]), [`ppc64le`]([]), [`riscv64`]([]), [`s390x`]([])

- **镜像信息详情**：  
  [repo-info仓库的`repos/redmine/`目录]([])（[历史记录]([])）  
  （包含镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的`library/redmine`标签]([])  
  [official-images仓库的`library/redmine`文件]([])（[历史记录]([])）

- **本文档来源**：  
  [docs仓库的`redmine/`目录]([])（[历史记录]([])）


## 什么是Redmine？

Redmine是一款免费开源的基于Web的项目管理和问题跟踪工具，支持多项目及子项目管理，提供项目级Wiki、论坛、时间跟踪、角色权限控制等功能。内置日历和甘特图，可直观展示项目进度和截止日期，并支持与多种版本控制系统集成，包含代码库浏览器和差异查看器。

> [.org/wiki/Redmine]()

![logo]([])


## 如何使用本镜像

### 使用SQLite3运行Redmine

这是最简单的部署方式，直接运行Redmine容器：

```console
$ docker run -d --name some-redmine redmine
```

> 注意：此方式不适用于多用户生产环境（[Redmine官方文档]([])）


### 使用数据库容器运行Redmine

推荐使用独立数据库容器部署Redmine，步骤如下：

1. **启动数据库容器**  
   - PostgreSQL：  
     ```console
     $ docker run -d --name some-postgres --network some-network -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=redmine postgres
     ```  
   - MySQL（启动Redmine时需将`-e REDMINE_DB_POSTGRES=some-postgres`替换为`-e REDMINE_DB_MYSQL=some-mysql`）：  
     ```console
     $ docker run -d --name some-mysql --network some-network -e MYSQL_USER=redmine -e MYSQL_PASSWORD=secret -e MYSQL_DATABASE=redmine -e MYSQL_RANDOM_ROOT_PASSWORD=1 mysql:5.7
     ```

2. **启动Redmine容器**  
   ```console
   $ docker run -d --name some-redmine --network some-network -e REDMINE_DB_POSTGRES=some-postgres -e REDMINE_DB_USERNAME=redmine -e REDMINE_DB_PASSWORD=secret redmine
   ```


### 通过`docker compose`部署

以下是`docker compose`配置示例（`compose.yaml`）：

```yaml
services:
  redmine:
    image: redmine
    restart: always
    ports:
      - 8080:3000
    environment:
      REDMINE_DB_MYSQL: db
      REDMINE_DB_PASSWORD: example
      REDMINE_SECRET_KEY_BASE: supersecretkey

  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: redmine
```

执行`docker compose up`，等待初始化完成后，访问`[] 访问应用

默认管理员账号：`admin`，密码：`admin`（[登录说明]([])）。


### 数据存储位置

Docker容器数据存储有两种常见方式，建议根据需求选择：

1. **Docker管理存储**：由Docker自动管理数据卷，简单透明，但文件路径较难直接访问。  
2. **主机目录挂载**：将主机目录挂载到容器内，方便主机工具访问。例如，挂载上传文件目录：  
   ```console
   $ docker run -d --name some-redmine -v /my/own/datadir:/usr/src/redmine/files --link some-postgres:postgres redmine
   ```  
   上述命令将主机`/my/own/datadir`目录挂载到容器内`/usr/src/redmine/files`（Redmine上传文件存储路径）。


### 端口映射

如需从主机直接访问容器，可通过`-p`参数映射端口：  
```console
$ docker run -d --name some-redmine -p 3000:3000 redmine
```  
之后可通过`[] 环境变量

启动容器时，可通过环境变量自定义配置，常用变量如下：

- **`REDMINE_DB_MYSQL`/`REDMINE_DB_POSTGRES`/`REDMINE_DB_SQLSERVER`**：指定数据库主机（ mutually exclusive，仅需设置一个），未设置时默认使用SQLite。  
- **`REDMINE_DB_PORT`**：数据库端口，默认MySQL为3306，PostgreSQL为5432。  
- **`REDMINE_DB_USERNAME`**：数据库用户名，默认MySQL为`root`，PostgreSQL为`postgres`，SQLite为`redmine`。  
- **`REDMINE_DB_PASSWORD`**：数据库密码，无默认值，需手动设置。  
- **`REDMINE_DB_DATABASE`**：数据库名，默认MySQL为`redmine`，PostgreSQL为用户名，SQLite为`sqlite/redmine.db`。  
- **`REDMINE_DB_ENCODING`**：数据库编码，默认MySQL为`UTF-8`，PostgreSQL为`utf8`，SQLite为`utf8`。  
- **`REDMINE_NO_DB_MIGRATE`**：设为非空值（如`1`）可禁用容器启动时自动执行`rake db:migrate`。  
- **`REDMINE_PLUGINS_MIGRATE`**：设为非空值（如`1`）可启用容器启动时自动执行`rake redmine:plugins:migrate`。  
- **`SECRET_KEY_BASE`**：Rails会话加密密钥，用于负载均衡场景维持会话，未设置时自动生成。


### 以指定用户运行

可通过`--user`参数指定用户/用户组（UID:GID），无需容器内存在该用户：  
```console
$ docker run -d --name some-redmine --user 1000:1000 redmine
```


### Docker Secrets

支持通过`_FILE`后缀从文件加载敏感配置（如Docker Secrets），例如：  
```console
$ docker run -d --name some-redmine -e REDMINE_DB_PASSWORD_FILE=/run/secrets/db-password redmine:tag
```  
支持的变量：`REDMINE_DB_MYSQL_FILE`、`REDMINE_DB_PASSWORD_FILE`等（完整列表见上文环境变量部分）。


## 镜像变体

Redmine镜像提供多种版本，适用于不同场景：

### `redmine:<version>`

基础镜像，基于Debian（如`bookworm`、`trixie`等版本代号）。适合大多数场景，如需安装额外依赖，建议指定Debian版本代号以减少兼容性问题。


### `redmine:<version>-alpine`

基于Alpine Linux，体积更小（约5MB基础镜像），适合对镜像大小敏感的场景。注意：Alpine使用`musl libc`，部分依赖`glibc`的软件可能存在兼容性问题。


## 许可证

Redmine基于[GNU General Public License v2]([])（GPL）开源。  
镜像中可能包含其他软件，其许可证请参考[repo-info仓库的`redmine`目录]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/redmine" title="library/redmine Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/redmine</a></p>
