---
image: nacos/nacos-server
description: "用于简化Nacos服务部署的Docker镜像，支持单机和集群模式，提供便捷的环境变量配置、快速启动及自定义数据库集成，适用于服务发现与配置管理场景。"
source: https://xuanyuan.cloud/zh/r/nacos/nacos-server
canonical: https://xuanyuan.cloud/zh/r/nacos/nacos-server
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nacos/nacos-server" title="nacos/nacos-server Docker 镜像中文简介、标签列表与拉取命令">nacos/nacos-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/nacos/nacos-server" title="nacos/nacos-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nacos/nacos-server</a>

# Nacos Docker 镜像文档

![Docker Pulls](https://img.shields.io/docker/pulls/nacos/nacos-server.svg?maxAge=60480)

该项目提供用于简化[Nacos](https://github.com/alibaba/nacos)部署的Docker镜像，Nacos是阿里巴巴开源的动态服务发现、配置管理和服务管理平台。

## 项目目录

* **build**：Nacos Docker镜像的构建源代码
* **env**：Docker Compose的环境变量配置文件
* **example**：Nacos服务的Docker Compose示例配置


## 注意事项

* 最新的`nacos/nacos-server:latest`镜像已移除**数据库主从镜像**，具体原因参考[移除数据库主从镜像配置](https://github.com/nacos-group/nacos-docker/wiki/%E7%A7%BB%E9%99%A4%E6%95%B0%E6%8D%AE%E5%BA%93%E4%B8%BB%E4%BB%8E%E9%95%9C%E5%83%8F%E9%85%8D%E7%BD%AE)
* 自Nacos 1.3.1版本起，数据库存储升级至8.0，且保持向下兼容
* 若使用自定义数据库，首次部署需手动初始化[数据库脚本](https://github.com/alibaba/nacos/blob/develop/distribution/conf/nacos-mysql.sql)


## 镜像概述与主要用途

Nacos Docker镜像旨在提供便捷的Nacos服务部署方式，支持单机模式和集群模式，适用于开发、测试及生产环境。通过环境变量配置即可快速调整服务参数，无需复杂的手动配置，简化微服务架构中的服务发现与配置管理基础设施搭建。


## 核心功能与特性

* 支持单机（standalone）和集群（cluster）两种部署模式
* 兼容MySQL 5.7及8.0数据库，支持自定义数据库配置
* 提供丰富的环境变量配置，覆盖服务端口、JVM参数、认证授权等核心参数
* 支持挂载自定义配置文件，满足高级配置需求
* 集成健康检查与监控指标，可对接Prometheus+Grafana监控体系


## 使用场景

* **开发环境快速部署**：通过单机模式快速启动Nacos服务，用于本地开发调试
* **测试环境集群验证**：通过Docker Compose快速搭建Nacos集群，验证分布式服务发现与配置同步
* **生产环境基础架构**：结合自定义数据库和持久化存储，构建稳定的服务注册与配置中心


## 快速启动

通过以下命令可快速启动单机模式的Nacos服务：

```shell
docker run --name nacos-quick -e MODE=standalone -p 8849:8848 -d nacos/nacos-server:2.0.2
```

* 参数说明：
  * `--name nacos-quick`：容器名称
  * `-e MODE=standalone`：指定单机模式
  * `-p 8849:8848`：端口映射（主机端口:容器端口）
  * `-d`：后台运行
  * `nacos/nacos-server:2.0.2`：镜像名称及版本


## 高级用法

### 版本调整

可通过修改Compose文件中的环境变量调整Nacos镜像版本，配置文件路径：`example/.env`

```dotenv
NACOS_VERSION=2.0.2  # 修改为目标版本号
```


### 部署步骤

#### 1. 克隆项目

```powershell
git clone --depth 1 https://github.com/nacos-group/nacos-docker.git
cd nacos-docker
```

#### 2. 单机模式（内置Derby数据库）

适用于快速测试，无需外部数据库：

```powershell
docker-compose -f example/standalone-derby.yaml up
```

#### 3. 单机模式（MySQL数据库）

**使用MySQL 5.7**：

```powershell
docker-compose -f example/standalone-mysql-5.7.yaml up
```

**使用MySQL 8**：

```powershell
docker-compose -f example/standalone-mysql-8.yaml up
```

#### 4. 集群模式

基于主机名的集群部署：

```powershell
docker-compose -f example/cluster-hostname.yaml up
```


### 基本操作示例

#### 服务注册

```powershell
curl -X PUT 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
```

#### 服务发现

```powershell
curl -X GET 'http://127.0.0.1:8848/nacos/v1/ns/instances?serviceName=nacos.naming.serviceName'
```

#### 发布配置

```powershell
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=helloWorld"
```

#### 获取配置

```powershell
curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
```

#### 访问控制台

浏览器访问：http://127.0.0.1:8848/nacos/


## 常见配置参数

| 参数名称                          | 描述                                  | 可选值及默认值                          |
|-----------------------------------|---------------------------------------|-----------------------------------------|
| MODE                              | 部署模式                              | cluster/standalone，默认**cluster**     |
| NACOS_SERVERS                     | 集群节点地址                          | 示例：ip1:port1 ip2:port2 ip3:port3     |
| PREFER_HOST_MODE                  | 是否支持主机名                        | hostname/ip，默认**ip**                 |
| NACOS_APPLICATION_PORT            | 服务端口                              | 默认**8848**                            |
| NACOS_SERVER_IP                   | 自定义服务器IP（多网卡场景）          | -                                       |
| SPRING_DATASOURCE_PLATFORM        | 数据库平台（单机模式支持）            | mysql/empty，默认empty                  |
| MYSQL_SERVICE_HOST                | MySQL主机地址                         | -                                       |
| MYSQL_SERVICE_PORT                | MySQL端口                             | 默认**3306**                            |
| MYSQL_SERVICE_DB_NAME             | MySQL数据库名                         | -                                       |
| MYSQL_SERVICE_USER                | MySQL用户名                           | -                                       |
| MYSQL_SERVICE_PASSWORD            | MySQL密码                             | -                                       |
| MYSQL_DATABASE_NUM                | 数据库数量                            | 默认**1**                               |
| MYSQL_SERVICE_DB_PARAM            | 数据库连接参数                        | 默认：`characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false` |
| JVM_XMS                           | JVM初始堆内存                         | 默认**1g**                              |
| JVM_XMX                           | JVM最大堆内存                         | 默认**1g**                              |
| JVM_XMN                           | JVM新生代内存                         | 默认**512m**                            |
| JVM_MS                            | 元空间初始大小                        | 默认**128m**                            |
| JVM_MMS                           | 元空间最大大小                        | 默认**320m**                            |
| NACOS_DEBUG                       | 是否启用远程调试                      | y/n，默认n                              |
| TOMCAT_ACCESSLOG_ENABLED          | 是否启用Tomcat访问日志                | 默认false                               |
| NACOS_AUTH_SYSTEM_TYPE            | 认证系统类型                          | 仅支持'nacos'，默认nacos                |
| NACOS_AUTH_ENABLE                 | 是否启用认证                          | 默认false                               |
| NACOS_AUTH_TOKEN_EXPIRE_SECONDS   | 令牌过期时间（秒）                    | 默认**18000**                           |
| NACOS_AUTH_TOKEN                  | 默认令牌密钥                          | 默认：`SecretKey012345678901234567890123456789012345678901234567890123456789` |
| NACOS_AUTH_CACHE_ENABLE           | 是否启用认证信息缓存                  | 默认false                               |
| MEMBER_LIST                       | 集群节点列表（配置文件/命令行参数）   | 示例：192.168.16.101:8847?raft_port=8807,... |
| EMBEDDED_STORAGE                  | 集群模式嵌入式存储（无需MySQL）       | `embedded`，默认none                    |
| NACOS_SECURITY_IGNORE_URLS        | 安全忽略URL列表                       | 默认：`/,/error,/**/*.css,/**/*.js,/**/*.html,/**/*.map,/**/*.svg,/**/*.png,/**/*.ico,/console-fe/public/**,/v1/auth/**,/v1/console/health/**,/actuator/**,/v1/console/server/**` |


## 高级配置

若上述环境变量配置无法满足需求，可将自定义配置文件`custom.properties`挂载至容器的`/home/nacos/init.d/`目录，该文件中的Spring属性配置优先级高于镜像内置的`application.properties`。

示例参考：[cluster-hostname.yaml](/example/cluster-hostname.yaml)


## Nacos + Grafana + Prometheus

监控配置参考：[Nacos监控指南](https://nacos.io/zh-cn/docs/monitor-guide.html)

**注意**：Grafana添加数据源时，数据源地址必须为**http://prometheus:9090**
