---
image: mysql/mysql-router
description: "MySQL Router提供应用程序与后端MySQL服务器之间的透明路由。"
source: https://xuanyuan.cloud/zh/r/mysql/mysql-router
canonical: https://xuanyuan.cloud/zh/r/mysql/mysql-router
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [mysql/mysql-router — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/mysql/mysql-router)

含镜像标签、拉取命令、部署文档与相关推荐。

[mysql/mysql-router Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/mysql/mysql-router)

# MySQL Router 是什么？

MySQL Router 是 InnoDB 集群的一部分，是一种轻量级中间件，可在应用程序与后端 MySQL 服务器之间提供透明路由。它可用于多种场景，例如通过有效地将数据库流量路由到适当的后端 MySQL 服务器来提供高可用性和可扩展性。其可插拔架构还使开发人员能够扩展 MySQL Router 以满足自定义需求。

# 支持的标签及对应 Dockerfile 链接

* MySQL Router 8.0（标签：[`latest`, `8.0`](https://github.com/mysql/mysql-docker/blob/mysql-router/8.0/Dockerfile)）（[mysql-router/8.0/Dockerfile](https://github.com/mysql/mysql-docker/blob/mysql-router/8.0/Dockerfile)）

镜像会在新的 MySQL Server 维护版本和开发里程碑发布时更新。请注意，非 GA 版本仅用于预览目的，不应在生产环境中使用。

# 如何使用 MySQL Router 镜像

当前镜像使用以下必填环境变量：

| 变量                 | 描述                                 |
|----------------------|--------------------------------------|
| MYSQL_HOST           | 要连接的 MySQL 主机                  |
| MYSQL_PORT           | 要使用的端口                         |
| MYSQL_USER           | 用于连接的用户                       |
| MYSQL_PASSWORD       | 用于连接的密码                       |

在容器中运行需要一个正常工作的 InnoDB 集群。

镜像使用以下可选环境变量：

| 变量                 | 描述                                 |
|----------------------|--------------------------------------|
| MYSQL_INNODB_CLUSTER_MEMBERS | 等待至少此数量的集群实例处于 ONLINE 状态 |
| MYSQL_CREATE_ROUTER_USER | 是否为 Router 创建新账户。默认为 1，设为 0 可禁用 |

如果提供了上述变量，运行脚本将等待指定的 MySQL 主机启动、InnoDB 集群具有 MYSQL_INNODB_CLUSTER_MEMBERS 数量的实例，然后使用指定的服务器进行引导模式（[引导](https://dev.mysql.com/doc/mysql-router/8.0/en/mysql-router-deploying-bootstrapping.html)）。

可通过以下命令运行镜像：

```
docker run -e MYSQL_HOST=localhost -e MYSQL_PORT=3306 -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql -e MYSQL_INNODB_CLUSTER_MEMBERS=3 -ti mysql/mysql-router
```

可通过以下命令验证：

```
docker ps
```

应显示类似以下输出：

```
4954b1c80be1 mysql-router:8.0 "/run.sh mysqlrouter" About a minute ago Up About a minute (healthy) 6447/tcp, 6448/tcp, 0.0.0.0:6446->6446/tcp, 6449/tcp innodbcluster_mysql-router_1
```

# 暴露的端口

MySQL Router 容器暴露以下 TCP 端口：

| 端口  | 描述                                                                 |
|-------|----------------------------------------------------------------------|
| 6446  | 读写（R/W）连接端口。连接到此端口的客户端将被转发到 PRIMARY           |
| 6447  | 只读（R/O）连接端口。连接到此端口的客户端将被转发到 SECONDARY         |
| 6448  | X 协议读写（R/W）连接端口。用于 X 协议客户端连接的读写端口            |
| 6449  | X 协议只读（R/O）连接端口。用于 X 协议客户端连接的只读端口            |
| 8443  | HTTPS REST 接口端口                                                  |

有关 REST 接口 API 的更多信息，请参见：  
https://dev.mysql.com/doc/mysql-router/8.0/en/mysql-router-rest-api-reference.html

有关完整使用文档，请参见：  
https://dev.mysql.com/doc/mysql-router/8.0/en/mysql-router-installation-docker.html
