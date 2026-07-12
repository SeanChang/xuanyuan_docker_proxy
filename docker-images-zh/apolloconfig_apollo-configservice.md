---
image: apolloconfig/apollo-configservice
description: "Apollo配置服务是Apollo配置中心的核心服务组件，负责配置的统一管理、动态更新与分发，支持多环境配置，为微服务及分布式应用提供高效的配置接入能力。"
source: https://xuanyuan.cloud/zh/r/apolloconfig/apollo-configservice
canonical: https://xuanyuan.cloud/zh/r/apolloconfig/apollo-configservice
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apolloconfig/apollo-configservice" title="apolloconfig/apollo-configservice Docker 镜像中文简介、标签列表与拉取命令">apolloconfig/apollo-configservice 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Apollo Config Service 镜像文档


## 1. 镜像概述与主要用途

Apollo 是一款可靠的分布式配置管理系统，专为微服务架构下的配置管理场景设计。本镜像为 [Apollo 配置中心](https://www.apolloconfig.com/) 的核心组件 **Apollo Config Service**，负责配置元数据的管理、配置内容的存储与分发、服务注册与发现等关键功能，是构建 Apollo 配置中心的基础服务组件。


## 2. 核心功能与特性

### 2.1 集中式配置管理
提供统一的配置管理界面，支持多应用、多集群配置的集中维护，避免配置分散在各服务节点导致的管理混乱。

### 2.2 实时配置推送
配置更新后可实时推送到客户端，无需重启应用即可生效，满足动态调整业务参数的需求。

### 2.3 配置版本控制
自动记录配置的修改历史，支持版本回溯与对比，便于追踪配置变更记录。

### 2.4 高可用架构
支持集群部署，通过服务注册与发现机制实现负载均衡，保障配置服务的高可用性与扩展性。

### 2.5 多环境支持
原生支持开发、测试、生产等多环境配置隔离，满足不同阶段的配置管理需求。

### 2.6 数据库持久化
配置数据存储于 MySQL 数据库（ApolloConfigDB），确保配置数据的持久化与可靠性。


## 3. 使用场景与适用范围

### 3.1 微服务架构配置管理
适用于微服务架构下多服务实例的配置统一管理，解决分布式环境中配置不一致问题。

### 3.2 动态配置调整需求
需频繁调整业务参数（如限流阈值、开关配置）的应用，避免因配置变更导致的服务重启。

### 3.3 多环境配置隔离
需要严格区分开发、测试、生产环境配置的场景，确保环境间配置独立且安全。

### 3.4 分布式系统配置一致性
保障分布式系统中各节点配置的实时同步与一致性，提升系统稳定性。


## 4. 使用方法与配置说明

### 4.1 前置条件
- 已部署 MySQL 数据库，并创建 Apollo 专用数据库 `ApolloConfigDB`（数据库 schema 可参考 [Apollo 官方文档](https://www.apolloconfig.com/#/zh/deployment/quick-start?id=_21-%e5%88%9b%e5%bb%ba%e6%95%b0%e6%8d%ae%e5%ba%93)）。
- 确保容器与 MySQL 数据库网络互通，且数据库用户具备 `ApolloConfigDB` 的读写权限。


### 4.2 Docker Run 命令示例
```bash
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://[MySQL服务器IP]:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai" \
  -e SPRING_DATASOURCE_USERNAME=[数据库用户名] \
  -e SPRING_DATASOURCE_PASSWORD=[数据库密码] \
  -d -v /var/log/apollo-configservice:/opt/logs \
  --name apollo-configservice docker.xuanyuan.run/apolloconfig/apollo-configservice:${version}
```

**参数说明**：
- `-p 8080:8080`：端口映射，容器内 8080 端口映射到主机 8080 端口（默认服务端口）。
- `-e`：环境变量配置（详见 4.4 环境变量说明）。
- `-d`：后台运行容器。
- `-v /var/log/apollo-configservice:/opt/logs`：日志目录挂载，持久化服务日志至主机目录。
- `--name apollo-configservice`：指定容器名称。
- `${version}`：镜像版本号，如 `2.1.0`（需替换为实际版本）。


### 4.3 Docker Compose 配置示例
创建 `docker-compose.yml`：
```yaml
version: '3'
services:
  apollo-configservice:
    image: docker.xuanyuan.run/apolloconfig/apollo-configservice:${version}
    container_name: apollo-configservice
    restart: always
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://[MySQL服务器IP]:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai
      - SPRING_DATASOURCE_USERNAME=[数据库用户名]
      - SPRING_DATASOURCE_PASSWORD=[数据库密码]
      # 可选：自定义服务端口（默认8080）
      # - SERVER_PORT=8080
    volumes:
      - /var/log/apollo-configservice:/opt/logs
    networks:
      - apollo-network

networks:
  apollo-network:
    driver: bridge
```

启动命令：`docker-compose up -d`


### 4.4 环境变量说明
| 环境变量                  | 说明                                                                 | 示例值                                                                 |
|---------------------------|----------------------------------------------------------------------|------------------------------------------------------------------------|
| `SPRING_DATASOURCE_URL`   | MySQL 数据库连接 URL，需包含 `ApolloConfigDB` 库名及必要参数。       | `jdbc:mysql://192.168.1.100:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai` |
| `SPRING_DATASOURCE_USERNAME` | 数据库登录用户名。                                                   | `apollo_user`                                                          |
| `SPRING_DATASOURCE_PASSWORD` | 数据库登录密码。                                                     | `apollo_password`                                                      |
| `SERVER_PORT`             | 服务端口（可选，默认 8080）。                                       | `8080`                                                                 |
| `LOG_LEVEL`               | 日志级别（可选，默认 INFO），支持 DEBUG/INFO/WARN/ERROR。           | `INFO`                                                                 |


### 4.5 数据卷挂载
- `/opt/logs`：容器内日志存储路径，建议挂载至主机目录（如 `/var/log/apollo-configservice`），避免容器重启后日志丢失。


### 4.6 服务验证
服务启动后，可通过访问 `http://[主机IP]:8080/health` 验证状态，返回 `{"status":"UP"}` 表示服务正常。


## 5. 相关资源
- **源代码**：[https://github.com/apolloconfig/apollo](https://github.com/apolloconfig/apollo)
- **官方文档**：[https://www.apolloconfig.com/](https://www.apolloconfig.com/)
- **贡献指南**：[https://github.com/apolloconfig/apollo/blob/master/CONTRIBUTING.md](https://github.com/apolloconfig/apollo/blob/master/CONTRIBUTING.md)
