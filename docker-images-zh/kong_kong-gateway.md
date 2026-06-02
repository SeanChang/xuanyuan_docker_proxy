<!-- xuanyuan-docker-images-zh
image: kong/kong-gateway
source: https://xuanyuan.cloud/zh/r/kong/kong-gateway
canonical: https://xuanyuan.cloud/zh/r/kong/kong-gateway
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [kong/kong-gateway — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kong/kong-gateway "kong/kong-gateway Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/kong/kong-gateway

# Kong Gateway Docker镜像文档


## 1. 镜像概述和主要用途

Kong Gateway 是一个可扩展的开源 API 平台（也称为 API 网关或 API 中间件）。最初由 Kong Inc.（前身为 Mashape）开发，用于为其 API 市场中的 15,000 多个微服务提供安全、管理和扩展能力，该平台每月处理数十亿次请求。

目前，Kong Gateway 已在数百个组织的生产环境中使用，包括初创公司、大型企业和政府机构，如《纽约时报》、Expedia、Healthcare.gov、《卫报》、康泰纳仕、奥克兰大学、法拉利、乐天、思科、天巡、雅虎日本、Giphy 等。

官方文档可访问 [docs.konghq.com](https://docs.konghq.com/)。


## 2. 核心功能和特性

- **可扩展性**：支持水平扩展，满足高并发请求场景
- **无数据库模式（DB-less）**：1.1 版本起支持仅使用内存存储实体，通过声明式配置文件管理
- **声明式配置**：支持 YAML/JSON 格式的静态配置，适用于无状态部署
- **数据库支持**：与 PostgreSQL 9.6+ 兼容，支持动态实体管理和全量插件功能
- **插件生态**：丰富的插件系统，支持认证（如 OAuth2）、访问控制（如 ACL）、监控等功能
- **动态重载**：支持配置热更新，无需重启服务即可应用变更
- **多部署选项**：支持容器化部署、Kubernetes Ingress 控制器等多种环境


## 3. 使用场景和适用范围

- **微服务架构**：作为 API 网关，统一管理微服务的入口流量
- **API 生命周期管理**：实现 API 的认证、授权、限流、监控和日志
- **高流量系统**：处理大规模 API 请求（如数十亿次/月）
- **企业级部署**：适用于初创公司、大型企业及政府机构的生产环境
- **Kubernetes 环境**：通过 Kong Kubernetes Ingress Controller 实现容器编排环境的流量管理


## 4. 详细使用方法和配置说明

### 4.1 无数据库模式（DB-less）

Kong Gateway 支持无数据库运行，使用内存存储实体，通过 YAML/JSON 格式的声明式配置文件管理实体。

> **安全提示**：在公共系统运行时，必须保护 Admin API。以下示例仅用于本地测试，建议仅在 localhost 暴露管理端口，详见 [官方安全指南](https://docs.konghq.com/gateway/latest/install/docker/?install=oss#start-kong-gateway)。


#### 4.1.1 启动 Kong（无数据库模式）

```shell
$ docker run -d --name kong \
    -e "KONG_DATABASE=off" \  # 启用无数据库模式
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \  # 代理访问日志输出到标准输出
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \  # Admin API 访问日志输出到标准输出
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \  # 代理错误日志输出到标准错误
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \  # Admin API 错误日志输出到标准错误
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \  # Admin API 监听地址和端口
    -p 8000:8000 \  # 代理 HTTP 端口
    -p 8443:8443 \  # 代理 HTTPS 端口
    -p 8001:8001 \  # Admin API HTTP 端口
    -p 8444:8444 \  # Admin API HTTPS 端口
    kong/kong-gateway
```


#### 4.1.2 生成声明式配置文件

创建基础配置文件骨架：

```shell
$ docker exec -it kong kong config init /home/kong/kong.yml  # 在容器内生成配置文件
$ docker exec -it kong cat /home/kong/kong.yml >> kong.yml  # 复制到本地
```


#### 4.1.3 加载声明式配置

通过 Admin API 加载本地配置文件（需安装 HTTPie）：

```shell
$ http :8001/config config=@kong.yml  # 将本地 kong.yml 加载到 Kong
```

> **注意**：部分插件与无数据库模式不兼容（需数据库协调或动态实体创建），详见 [无数据库与声明式配置文档](https://docs.konghq.com/latest/db-less-and-declarative-config/)。


### 4.2 有数据库模式

为兼容所有插件（如 ACL、OAuth2），Kong Gateway 需使用 PostgreSQL 9.6+ 作为数据存储。


#### 4.2.1 启动 PostgreSQL 容器

```shell
$ docker run -d --name kong-database \
    -p 5432:5432 \  # PostgreSQL 端口
    -e "POSTGRES_USER=kong" \  # 数据库用户
    -e "POSTGRES_DB=kong" \  # 数据库名称
    -e "POSTGRES_PASSWORD=kong" \  # 数据库密码
    postgres:9.6
```


#### 4.2.2 初始化数据库

通过临时容器执行数据库迁移：

```shell
$ docker run --rm \
    --link kong-database:kong-database \  # 链接到 PostgreSQL 容器
    -e "KONG_DATABASE=postgres" \  # 指定数据库类型为 PostgreSQL
    -e "KONG_PG_HOST=kong-database" \  # PostgreSQL 主机（容器名）
    -e "KONG_PG_USER=kong" \  # PostgreSQL 用户
    -e "KONG_PG_PASSWORD=kong" \  # PostgreSQL 密码
    kong/kong-gateway kong migrations bootstrap  # 执行数据库初始化
```

> **注意**：Kong Gateway < 0.15 版本需使用 `kong migrations up` 命令，且不支持并发迁移（仅允许单节点执行）；0.15+ 版本无此限制。


#### 4.2.3 启动 Kong（有数据库模式）

```shell
$ docker run -d --name kong \
    --link kong-database:kong-database \  # 链接到 PostgreSQL 容器
    -e "KONG_DATABASE=postgres" \  # 启用数据库模式
    -e "KONG_PG_HOST=kong-database" \  # PostgreSQL 主机
    -e "KONG_PG_PASSWORD=kong" \  # PostgreSQL 密码
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong/kong-gateway
```

启动后，Kong 监听以下端口：
- 8000：HTTP 代理端口
- 8443：HTTPS 代理端口
- 8001：Admin API HTTP 端口
- 8444：Admin API HTTPS 端口


#### 4.2.4 自定义配置

通过环境变量覆盖 Kong 配置（前缀 `KONG_` + 配置项名称）：

```shell
$ docker run -d --name kong \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=1.1.1.1" \  # 自定义 PostgreSQL 主机（如外部集群）
    -e "KONG_LOG_LEVEL=info" \  # 日志级别（debug/info/warn/error/critical）
    -e "KONG_CUSTOM_PLUGINS=helloworld" \  # 加载自定义插件
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong/kong-gateway
```


#### 4.2.5 重载配置

修改配置后，通过以下命令热重载（无 downtime）：

```shell
$ docker exec -it kong kong reload  # 在运行中的容器内执行重载
```


## 5. 配置参数说明

| 环境变量                | 说明                                                                 | 取值示例                  |
|-------------------------|----------------------------------------------------------------------|---------------------------|
| `KONG_DATABASE`         | 数据库模式                                                           | `off`（无数据库）/`postgres`（PostgreSQL） |
| `KONG_PG_HOST`          | PostgreSQL 主机地址                                                  | `kong-database`（容器名）/`1.1.1.1`（IP） |
| `KONG_PG_USER`          | PostgreSQL 用户名                                                    | `kong`                    |
| `KONG_PG_PASSWORD`      | PostgreSQL 密码                                                      | `kong`                    |
| `KONG_PG_DATABASE`      | PostgreSQL 数据库名                                                  | `kong`                    |
| `KONG_ADMIN_LISTEN`     | Admin API 监听地址和端口                                             | `0.0.0.0:8001, 0.0.0.0:8444 ssl` |
| `KONG_PROXY_ACCESS_LOG` | 代理访问日志路径                                                     | `/dev/stdout`（标准输出） |
| `KONG_LOG_LEVEL`        | 日志级别                                                             | `debug`/`info`/`warn`/`error` |
| `KONG_CUSTOM_PLUGINS`   | 自定义插件列表（逗号分隔）                                           | `helloworld,myplugin`     |


## 6. 镜像变体

`kong/kong-gateway` 镜像提供多种变体，适用于不同场景：

### 6.1 `kong/kong-gateway:<version>`

默认镜像，适用于大多数场景。包含完整功能，可作为临时容器或基础镜像使用。支持“主版本.次版本”（如 `3.7`）和完整版本（如 `3.7.0.0`）标签。


### 6.2 `kong/kong-gateway:<version>-<os><os-version>`

特定操作系统版本的镜像，如：
- `kong/kong-gateway:3.7-debian`（Debian 基础）
- `kong/kong-gateway:3.7-ubuntu`（Ubuntu 基础）
- `kong/kong-gateway:3.7-rhel`（RHEL 基础）

> **注意**：`latest` 和 `latest-<os>` 标签不保证为最新稳定版，仅用于开发测试。


## 7. 许可证

镜像包含软件的许可信息详见 [Kong 软件许可](https://konghq.com/kongsoftwarelicense/)。

与所有 Docker 镜像一样，本镜像可能包含基础系统及依赖软件的其他许可。用户需自行确保使用本镜像符合所有包含软件的许可要求。
