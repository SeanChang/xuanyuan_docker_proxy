---
image: scylladb/scylla
description: "Scylla是一款高度可扩展、最终一致性的分布式分区行数据库，适用于大规模数据存储与访问场景。"
source: https://xuanyuan.cloud/zh/r/scylladb/scylla
canonical: https://xuanyuan.cloud/zh/r/scylladb/scylla
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/scylladb/scylla" title="scylladb/scylla Docker 镜像中文简介、标签列表与拉取命令">scylladb/scylla 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ScyllaDB Docker镜像文档


## 1. 镜像概述和主要用途

ScyllaDB是一款高性能NoSQL数据库系统，完全兼容Apache Cassandra。该数据库以开源形式发布，遵循GNU Affero通用公共许可证第3版（AGPLv3）和Apache许可证，可免费使用和修改。

ScyllaDB的核心设计目标是提供极高的吞吐量和低延迟，适用于需要处理大规模数据集的场景。通过Docker镜像，用户可快速部署单节点或多节点ScyllaDB集群，简化开发、测试和生产环境的搭建流程。


## 2. 核心功能和特性

- **高性能**：采用优化的C++实现和异步I/O模型，吞吐量和延迟性能显著优于传统Cassandra。
- **完全兼容Cassandra**：支持CQL协议、Cassandra查询语法及工具（如`cqlsh`、`nodetool`），可无缝迁移现有Cassandra应用。
- **可扩展性**：支持多节点集群部署，自动分片和负载均衡，线性扩展存储和计算能力。
- **Docker化优化**：支持数据卷挂载、资源限制配置（CPU/内存）、容器内进程管理（supervisord）。
- **灵活配置**：通过命令行参数和环境变量自定义节点角色、网络地址、存储路径、安全认证等。
- **开发者模式**：提供简化的单节点配置，降低开发环境搭建门槛。


## 3. 使用场景和适用范围

### 3.1 开发环境
- 单节点开发者模式：快速启动轻量级实例，用于应用开发和功能测试，无需复杂的集群配置。

### 3.2 生产环境
- 多节点集群：通过种子节点（seeds）配置构建分布式集群，需调整内核参数（如`aio-max-nr`）以优化性能。
- 高性能数据存储：适用于日志存储、实时分析、IoT数据采集等需要高吞吐量的场景。

### 3.3 兼容性场景
- 从Cassandra迁移的应用：利用完全兼容性，无缝替换Cassandra以提升性能。


## 4. 快速开始

### 4.1 单节点开发者模式
通过以下命令启动单节点ScyllaDB集群（开发者模式），限制使用1个CPU核心：

```bash
docker run --name some-scylla --hostname some-scylla -d docker.xuanyuan.run/scylladb/scylla --smp 1
```

**说明**：  
- `--smp 1`：限制CPU核心数（生产环境需根据内核参数调整，详见下文）。  
- 开发者模式默认启用（`--developer-mode 1`），放松对XFS文件系统等配置的检查，适合测试。


## 5. 详细使用方法

### 5.1 启动Scylla服务实例
启动基础ScyllaDB节点（默认启用开发者模式）：

```bash
docker run --name some-scylla --hostname some-scylla -d docker.xuanyuan.run/scylladb/scylla
```

### 5.2 运行集群管理工具

#### 5.2.1 使用`nodetool`查看节点状态
```bash
docker exec -it some-scylla nodetool status
```

**示例输出**：
```
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens  Owns (effective)  Host ID                               Rack
UN  172.17.0.2  125.51 KB  256     100.0%            c9155121-786d-44f8-8667-a8b915b95665  rack1
```

#### 5.2.2 使用`cqlsh`连接数据库
```bash
docker exec -it some-scylla cqlsh
```

**示例输出**：
```
Connected to Test Cluster at 172.17.0.2:9042.
[cqlsh 5.0.1 | Cassandra 2.1.8 | CQL spec 3.2.1 | Native protocol v3]
Use HELP for help.
cqlsh>
```

### 5.3 创建多节点集群

#### 5.3.1 手动添加节点
以现有节点为种子，启动第二个节点：

```bash
# 获取第一个节点的IP
SEED_IP=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' some-scylla)
# 启动第二个节点，指定种子节点
docker run --name some-scylla2 --hostname some-scylla2 -d docker.xuanyuan.run/scylladb/scylla --seeds="$SEED_IP"
```

#### 5.3.2 使用Docker Compose部署3节点集群
创建`docker-compose.yml`文件：

```yaml
version: '3'

services:
  some-scylla:
    image: docker.xuanyuan.run/scylladb/scylla
    container_name: some-scylla

  some-scylla2:
    image: docker.xuanyuan.run/scylladb/scylla
    container_name: some-scylla2
    command: --seeds=some-scylla

  some-scylla3:
    image: docker.xuanyuan.run/scylladb/scylla
    container_name: some-scylla3
    command: --seeds=some-scylla
```

启动集群：

```bash
docker-compose up -d
```

### 5.4 查看容器日志
```bash
docker logs some-scylla | tail
```

**示例输出**：
```
INFO  2016-08-04 06:57:40,839 [shard 0] storage_service - Starting listening for CQL clients on 172.17.0.2:9042...
INFO  2016-08-04 06:57:40,840 [shard 0] storage_service - Thrift server listening on 172.17.0.2:9160 ...
```

### 5.5 配置数据卷持久化存储
为提升性能并确保数据持久化，建议挂载宿主机目录作为数据卷：

#### 5.5.1 宿主机准备目录
```bash
sudo mkdir -p /var/lib/scylla/data /var/lib/scylla/commitlog /var/lib/scylla/hints /var/lib/scylla/view_hints
```

#### 5.5.2 启动容器并挂载卷
禁用开发者模式（生产环境），并挂载数据卷：

```bash
docker run --name some-scylla --volume /var/lib/scylla:/var/lib/scylla -d docker.xuanyuan.run/scylladb/scylla --developer-mode=0
```

### 5.6 配置资源限制
默认情况下，Scylla容器运行在过度配置模式（不启用CPU绑定优化）。为提升性能，建议通过以下参数限制资源：

- `--smp`：限制CPU核心数  
- `--memory`：限制内存使用量  
- `--cpuset`：指定绑定的CPU核心  

**示例**：限制2个CPU核心、4GB内存，并绑定至物理CPU 0-1：

```bash
docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --smp 2 --memory 4G --cpuset 0-1 --overprovisioned 0
```

### 5.7 重启Scylla服务
容器内通过`supervisorctl`管理Scylla进程，重启命令：

```bash
docker exec -it some-scylla supervisorctl restart scylla
```


## 6. 配置参数说明

### 6.1 命令行选项
通过`docker run`命令传递，用于自定义Scylla节点行为。

#### `--seeds SEEDS`
- **作用**：配置集群种子节点IP列表，多个IP用逗号分隔。未指定时，节点将自身IP作为种子。  
- **示例**：指定两个种子节点  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --seeds 192.168.0.100,192.168.0.200
  ```

#### `--listen-address ADDR`
- **作用**：配置节点监听其他节点连接的IP地址。  
- **示例**：监听`10.0.0.5`  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --listen-address 10.0.0.5
  ```
- **版本**：1.4+

#### `--alternator-address ADDR`
- **作用**：配置Alternator API（兼容DynamoDB）的监听地址，默认与`--listen-address`相同。  
- **版本**：3.2+

#### `--alternator-port PORT`
- **作用**：启用Alternator API并指定监听端口（默认禁用）。  
- **示例**：启用HTTP端口8000  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --alternator-port 8000
  ```
- **版本**：3.2+

#### `--alternator-https-port PORT`
- **作用**：启用Alternator API的HTTPS端口，需提前在容器内放置SSL证书（`/etc/scylla/scylla.crt`和`/etc/scylla/scylla.key`）。  
- **版本**：4.2+

#### `--alternator-write-isolation policy`
- **作用**：配置Alternator写入隔离策略（启用Alternator时必填），具体策略参考Scylla文档。  
- **版本**：4.1+

#### `--broadcast-address ADDR`
- **作用**：配置节点向集群其他节点广播的IP地址（用于跨网络访问）。  
- **示例**：  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --broadcast-address 10.0.0.5
  ```

#### `--broadcast-rpc-address ADDR`
- **作用**：配置节点向客户端广播的RPC服务IP地址。  

#### `--smp COUNT`
- **作用**：限制使用的CPU核心数，默认使用所有可用核心。  
- **示例**：限制1个核心  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --smp 1
  ```

#### `--memory AMOUNT`
- **作用**：限制内存使用量，支持`M`（MB）或`G`（GB）为单位。  
- **示例**：限制4GB内存  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --memory 4G
  ```

#### `--reserve-memory AMOUNT`
- **作用**：为操作系统预留内存量，避免Scylla耗尽系统内存。  
- **示例**：预留2GB  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --reserve-memory 2G
  ```

#### `--overprovisioned ENABLE`
- **作用**：启用/禁用过度配置模式（0=禁用，1=启用）。禁用时，Scylla会应用CPU绑定等优化，适合静态资源分配环境。默认启用，指定`--cpuset`时自动禁用。  
- **示例**：禁用过度配置模式  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --overprovisioned 0
  ```

#### `--io-setup ENABLE`
- **作用**：控制是否在首次启动时运行`scylla_io_setup`脚本（I/O调优），默认1（启用）。Kubernetes等环境可禁用。  
- **示例**：禁用I/O setup  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --io-setup 0
  ```
- **版本**：4.3+

#### `--cpuset CPUSET`
- **作用**：指定绑定的CPU核心，支持单核心（`1`）、范围（`0-2`）或列表（`0,2,4`）。  
- **示例**：绑定至CPU 0-2和4  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --cpuset 0-2,4
  ```

#### `--developer-mode ENABLE`
- **作用**：启用/禁用开发者模式（0=禁用，1=启用）。禁用时，Scylla会严格检查系统配置（如XFS），适合生产环境。默认启用。  
- **示例**：禁用开发者模式  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --developer-mode 0
  ```

#### `--experimental ENABLE`
- **作用**：启用/禁用实验性功能（0=禁用，1=启用），默认禁用。生产环境不建议启用。  
- **示例**：启用实验模式  
  ```bash
  docker run --name some-scylla -d docker.xuanyuan.run/scylladb/scylla --experimental 1
  ```
- **版本**：2.0+

#### `--disable-version-check`
- **作用**：禁用版本验证检查。  
- **版本**：2.2+

#### `--authenticator AUTHENTICATOR`
- **作用**：指定认证器类，默认`AllowAllAuthenticator`（无认证），可选`PasswordAuthenticator`（用户名/密码认证）。  
- **版本**：2.3+

#### `--authorizer AUTHORIZER`
- **作用**：指定授权器类，默认`AllowAllAuthorizer`（无授权），可选`CassandraAuthorizer`（基于`system_auth.permissions`表授权）。  
- **版本**：2.3+

### 6.2 JMX参数
通过环境变量（`-e`）配置JMX服务，容器启动时由`/scylla-jmx-service.sh`读取。

| 环境变量          | 作用                  | 默认值                          | 示例                                  |
|-------------------|-----------------------|---------------------------------|---------------------------------------|
| `SCYLLA_JMX_PORT` | JMX监听端口           | `-jp 7199`                      | `-e "SCYLLA_JMX_PORT=-jp 7200"`       |
| `SCYLLA_API_PORT` | Scylla API端口        | `-p 10000`                      | `-e "SCYLLA_API_PORT=-p 10001"`       |
| `SCYLLA_JMX_ADDR` | JMX绑定地址           | `-ja localhost`                 | `-e "SCYLLA_JMX_ADDR=-ja 0.0.0.0"`    |
| `SCYLLA_JMX_REMOTE` | 允许远程JMX访问      | 未设置（默认禁用）               | `-e "SCYLLA_JMX_REMOTE=-r"`           |

**示例**：开放JMX远程访问（绑定0.0.0.0，端口7199）：

```bash
docker run -d -e "SCYLLA_JMX_ADDR=-ja 0.0.0.0" -e "SCYLLA_JMX_REMOTE=-r" --publish 7199:7199 docker.xuanyuan.run/scylladb/scylla
```


## 7. 相关链接
- [在Docker上运行Scylla的最佳实践](http://docs.scylladb.com/procedures/best_practices_scylla_on_docker/)


## 8. 用户反馈

### 8.1 问题报告
-  bug报告请提交至Scylla的[GitHub Issue跟踪器](https://github.com/scylladb/scylla/issues)。  
-  提交前请阅读[问题报告指南](http://docs.scylladb.com/operating-scylla/troubleshooting/report_scylla_problem/)。

### 8.2 贡献指南
-  代码贡献请参考[Scylla贡献文档](http://www.scylladb.com/kb/contributing/)。
