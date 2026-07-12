---
image: herodotus/sentinel-dashboard
description: "基于Spring Cloud Alibaba Sentinel Dashboard扩展改造的镜像，支持微服务流量监控数据持久化到InfluxDB（1.x），流量控制配置存储到Nacos（2.x），可通过配置动态开关存储机制，默认使用内存存储。"
source: https://xuanyuan.cloud/zh/r/herodotus/sentinel-dashboard
canonical: https://xuanyuan.cloud/zh/r/herodotus/sentinel-dashboard
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/herodotus/sentinel-dashboard" title="herodotus/sentinel-dashboard Docker 镜像中文简介、标签列表与拉取命令">herodotus/sentinel-dashboard 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# herodotus/sentinel-dashboard 镜像文档

## 镜像概述

本镜像基于最新版`Spring Cloud Alibaba Sentinel Dashboard`扩展改造，核心功能是支持微服务流量监控数据持久化存储到`InfluxDB`时序数据库（1.x版本），并支持通过`Sentinel Dashboard`界面将流量控制配置存储到`Nacos`（2.x版本）。默认使用`Sentinel Dashboard`原有内存方式存储，可通过配置参数动态开启或关闭`InfluxDB`和`Nacos`存储机制。

## 核心功能与特性

- **数据持久化**：支持将微服务流量监控数据持久化至InfluxDB 1.x时序数据库
- **配置存储**：支持通过Sentinel Dashboard界面将流量控制规则存储至Nacos 2.x
- **动态配置**：可通过环境变量动态开启/关闭InfluxDB和Nacos存储机制，默认使用内存存储
- **灵活部署**：提供Docker容器化部署方式，支持自定义JVM参数和管理员账户

## 使用场景

- 微服务架构下的流量监控与治理
- 需要持久化存储流量监控数据的场景
- 需要集中管理和持久化流量控制规则的场景
- 基于Sentinel进行服务熔断、限流等流量控制的微服务系统

## 使用方法

### 镜像下载

```bash
docker pull docker.xuanyuan.run/herodotus/sentinel-dashboard:tagname
```

### 基本启动命令

```bash
docker run --name sentinel -d -p 8858:8858 docker.xuanyuan.run/herodotus/sentinel-dashboard:tagname
```

### 环境变量配置

#### Sentinel 核心参数

| 变量 | 默认值 | 是否必需 | 说明 |
|------|--------|----------|------|
| JAVA_OPTS |  | false | JVM运行参数 |
| SENTINEL_ADMIN_USERNAME | sentinel | false | Sentinel Dashboard管理员用户名 |
| SENTINEL_ADMIN_PASSWORD | sentinel | false | Sentinel Dashboard管理员密码 |

#### InfluxDB 存储参数

| 变量 | 默认值 | 是否必需 | 说明 |
|------|--------|----------|------|
| INFLUXDB_URL |  | false | InfluxDB连接地址，格式：http(s)://ip:port |
| INFLUXDB_USERNAME |  | false | InfluxDB用户名 |
| INFLUXDB_PASSWORD |  | false | InfluxDB密码 |
| INFLUXDB_DATABASE |  | false | InfluxDB数据库名 |

> **注意**：需同时设置`INFLUXDB_URL`、`INFLUXDB_USERNAME`、`INFLUXDB_PASSWORD`、`INFLUXDB_DATABASE`四个参数才能启用InfluxDB存储模式，否则使用默认内存存储。

#### Nacos 存储参数

| 变量 | 默认值 | 是否必需 | 说明 |
|------|--------|----------|------|
| NACOS_SERVER_ADDRESS |  | false | Nacos Server地址，格式：http://ip:port |
| NACOS_CONFIG_DATA_ID_SUFFIX | -flow-rules | false | Nacos存储配置Data ID后缀，用于区分配置用途（如：xxx-service-flow-rules） |
| NACOS_CONFIG_NAMESPACE |  | false | Nacos命名空间ID（注意是ID而非名称） |
| NACOS_CONFIG_GROUP | sentinel | false | Nacos配置分组 |
| NACOS_CONFIG_TYPE | json | false | Nacos配置类型，具体参见：com.alibaba.nacos.api.config.ConfigType |
| NACOS_ADMIN_USERNAME | nacos | false | Nacos用户名（开启认证后需配置） |
| NACOS_ADMIN_PASSWORD | nacos | false | Nacos密码（开启认证后需配置） |
| NACOS_AUTH_ENABLED | false | false | Nacos是否开启认证 |
| NACOS_TOKEN_TTL | 18000 | false | Nacos Token有效期（开启认证后需配置） |

> **注意**：仅当设置`NACOS_SERVER_ADDRESS`参数时启用Nacos存储模式，否则使用默认内存存储。

## Docker Compose 示例

```yaml
version: "3"
services:
  sentinel:
    image: docker.xuanyuan.run/herodotus/sentinel-dashboard:latest
    container_name: sentinel-dashboard
    environment:
      SENTINEL_ADMIN_USERNAME: herodotus
      SENTINEL_ADMIN_PASSWORD: herodotus
      INFLUXDB_URL: http://127.0.0.1:8086
      INFLUXDB_USERNAME: herodotus
      INFLUXDB_PASSWORD: herodotus
      INFLUXDB_DATABASE: sentinel
      NACOS_SERVER_ADDRESS: http://127.0.0.1:8848
      NACOS_CONFIG_DATA_ID_SUFFIX: -flow-rules
    ports:
      - "8858:8858"
```

## 代码仓库与文档

- **代码仓库**：
  - [Gitee](https://gitee.com/dromara/dante-cloud)
  - [Github](https://github.com/dromara/dante-cloud)
- **官方文档**：[https://www.herodotus.cn](https://www.herodotus.cn)
