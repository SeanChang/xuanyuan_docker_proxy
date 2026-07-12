---
image: apache/shardingsphere-proxy
description: "Apache ShardingSphere-Proxy是透明的数据库代理，提供基于MySQL/PostgreSQL协议的分布式数据库服务，支持数据分片、读写分离、数据加密等功能，适用于异构语言环境和云原生场景，对应用透明且兼容各类数据库客户端。"
source: https://xuanyuan.cloud/zh/r/apache/shardingsphere-proxy
canonical: https://xuanyuan.cloud/zh/r/apache/shardingsphere-proxy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/shardingsphere-proxy" title="apache/shardingsphere-proxy Docker 镜像中文简介、标签列表与拉取命令">apache/shardingsphere-proxy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述

Apache ShardingSphere是开源的分布式数据库解决方案生态系统，包含JDBC、Proxy及Sidecar（规划中）三款独立产品。它们均提供数据分片、分布式事务和分布式治理功能，适用于Java同构、异构语言及云原生等多种场景。

Apache ShardingSphere旨在充分利用分布式系统中现有数据库的计算和存储能力，而非构建全新数据库。关系型数据库作为企业基石仍占据巨大市场份额，因此我们专注于其增量扩展而非彻底颠覆。

自5.x版本起，Apache ShardingSphere聚焦插件化架构，功能可灵活嵌入项目。当前支持的数据分片、读写分离、数据加密、影子库等特性，以及MySQL、PostgreSQL、SQLServer、Oracle等SQL方言/数据库协议，均通过插件实现。开发者可像搭建乐高积木般自定义ShardingSphere，目前已拥有丰富且持续增长的SPI扩展。

[Apache ShardingSphere](https://shardingsphere.apache.org)

## ShardingSphere-Proxy

ShardingSphere-Proxy定位为透明数据库代理，提供封装数据库二进制协议的数据库服务，支持异构语言。目前提供MySQL和PostgreSQL版本（兼容基于PostgreSQL的数据库，如openGauss）。可使用任何兼容MySQL或PostgreSQL协议的终端（如MySQL命令行客户端、MySQL Workbench等）操作数据，对DBA更友好。

- 对应用透明，可直接作为MySQL和PostgreSQL服务器使用；
- 适用于任何兼容MySQL和PostgreSQL协议的终端。

![ShardingSphere-Proxy架构](https://shardingsphere.apache.org/document/current/img/shardingsphere-proxy_v2.png)

## 拉取官方Docker镜像

```bash
docker pull docker.xuanyuan.run/apache/shardingsphere-proxy
```

## 手动构建Docker镜像（可选）

```bash
git clone https://github.com/apache/shardingsphere
mvn clean install
cd shardingsphere-distribution/shardingsphere-proxy-distribution
mvn clean package -Prelease,docker
```

## 配置ShardingSphere-Proxy

在`/${your_work_dir}/conf/`目录下创建`server.yaml`和`config-xxx.yaml`，用于配置分片规则和服务器规则。
请参考[配置手册](/zh/user-manual/shardingsphere-proxy/configuration/)。
配置示例可参考[GitHub示例](https://github.com/apache/shardingsphere/tree/master/shardingsphere-proxy/shardingsphere-proxy-bootstrap/src/main/resources/conf)。

## 运行Docker

```bash
docker run -d -v /${your_work_dir}/conf:/opt/shardingsphere-proxy/conf -e PORT=3308 -p13308:3308 docker.xuanyuan.run/apache/shardingsphere-proxy:latest
```

**注意**

* 端口`3308`（容器端口）和`13308`（主机端口）可自定义。
* 必须将配置目录挂载至`/opt/shardingsphere-proxy/conf`。

```bash
docker run -d -v /${your_work_dir}/conf:/opt/shardingsphere-proxy/conf -e JVM_OPTS="-Djava.awt.headless=true" -e PORT=3308 -p13308:3308 docker.xuanyuan.run/apache/shardingsphere-proxy:latest
```

**注意**

* 可通过环境变量`JVM_OPTS`定义JVM相关参数。

```bash
docker run -d -v /${your_work_dir}/conf:/opt/shardingsphere-proxy/conf -v /${your_work_dir}/ext-lib:/opt/shardingsphere-proxy/ext-lib -p13308:3308 docker.xuanyuan.run/apache/shardingsphere-proxy:latest
```

**注意**

* 如需导入外部JAR包，需将存放目录挂载至`/opt/shardingsphere-proxy/ext-lib`。

## 访问ShardingSphere-Proxy

连接方式与连接PostgreSQL相同：

```bash
psql -U ${your_user_name} -h ${your_host} -p 13308
```

## FAQ

**问题1**：处理请求时出现I/O异常（`java.io.IOException`）：`{}->unix://localhost:80: Connection refused`。

**解答**：构建镜像前，请确保Docker守护进程已运行。

**问题2**：无法连接数据库的错误报告。

**解答**：请确保`/${your_work_dir}/conf/config-xxx.yaml`配置中指定的PostgreSQL IP可被Docker容器访问。

**问题3**：如何启动后端数据库为MySQL或openGauss的ShardingSphere-Proxy？

**解答**：将`mysql-connector.jar`或`opengauss-jdbc.jar`所在目录挂载至`/opt/shardingsphere-proxy/ext-lib`。
