---
image: redislabs/redis
description: "Redis Labs提供的集群化内存数据库引擎，完全兼容开源Redis，具备企业级特性，支持高性能、零停机线性扩展和高可用性，适用于分布式应用场景。"
source: https://xuanyuan.cloud/zh/r/redislabs/redis
canonical: https://xuanyuan.cloud/zh/r/redislabs/redis
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redislabs/redis" title="redislabs/redis Docker 镜像中文简介、标签列表与拉取命令">redislabs/redis 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### 支持的标签
* _`8.0.2-41`_,
* _`7.22.2-41`_,
* _`7.22.0-241`_,
* _`7.8.6-13`_, 
* _`7.8.4-95`_, 
* _`7.8.2-60`_, 
* _`7.4.6-275`_, 
* _`7.2.4-122`_,
* _`6.4.2-121`_, 
* _`6.4.2-61`_,
* _`6.2.18-71`_, 
* _`6.2.12-82`_, 
* _`6.2.12-68`_, 
* _`6.2.10-129`_, 
* _`6.2.8-64`_,
* _`6.2.4-54`_, 
* _`6.0.20-97`_, 
* _`6.0.20-95`_, 
* _`6.0.20-69`_, 
* _`6.0.12-58`_,
* _`6.0.8-30`_, 
* _`6.0.6-39`_, 
* _`5.6.0-31`_, 
* _`5.4.14-34`_,
* _`5.4.10-22`_,
* _`5.4.6-17`_,
* _`5.4.4-7`_,
* _`5.4.2-27`_,
* _`5.4.0-19`_,
* _`5.2.2-24`_,
* _`5.2.0-14`_,
* _`5.0.2-30`_,
* _`5.0.0-31`_,
* _`4.5.0-51`_

### 预览版本

[![构建状态](https://travis-ci.org/RedisLabs/DockerHub.svg?branch=master)](https://travis-ci.org/RedisLabs/DockerHub)

## Redis Enterprise Software (RS) 是什么？
[**Redis Enterprise Software**](https://redislabs.com/redis-enterprise/software//) 是 Redis Labs 推出的企业级分布式内存 NoSQL 数据库服务器，完全兼容开源 Redis。它扩展了开源 Redis 的功能，提供稳定的高性能、零停机线性扩展和高可用性，同时显著降低运维成本。

![RS 架构](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/general/redis_arch.jpeg)

* Redis Enterprise Software 可同时使用 RAM 和 SSD 等闪存设备进行数据处理，详情参见 [Redis on Flash](https://redislabs.com/products/redis-pack/flash-memory/)。
* 支持基于 [Redis CRDTs](https://redislabs.com/redis-enterprise-documentation/concepts-architecture/intercluster-replication/) 的多活地理分布式应用。
* 支持 Redis 模块，详情参见 [RediSearch](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/redisearch/)、[ReJSON](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/rejson-quick-start/) 和 [ReBloom](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/rebloom/)。


# 快速开始

1. **运行 Redis Enterprise 容器**

```bash
docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 9443:9443 -p 12000:12000 redislabs/redis
```

2. **使用 `rladmin` 工具和 `create cluster` 命令配置 Redis Enterprise 集群**

```bash
docker exec -d --privileged rp "/opt/redislabs/bin/rladmin" cluster create name cluster.local username cihan@redislabs.com password redislabs123
```

3. **在 Redis Enterprise 集群上创建数据库**

```bash
curl -k -u "cihan@redislabs.com:redislabs123" --request POST --url "https://localhost:9443/v1/bdbs" --header 'content-type: application/json' --data '{"name":"db1","type":"redis","memory_size":102400,"port":12000}'
```

> 注意：Redis Enterprise 的启动时间取决于硬件性能，可能需要几秒钟。如果收到 **"503 Service Unavailable"** 错误，请等待片刻后重新执行步骤 2 和步骤 3。

4. **使用 `redis-cli` 连接到 Redis Enterprise 集群中的数据库**

```bash
docker exec -it rp bash

# sudo /opt/redislabs/bin/redis-cli -p 12000
# 127.0.0.1:12000> set key1 123
# OK
# 127.0.0.1:12000> get key1
# "123"
```


# 分步指南

Redis Enterprise Software 容器可在安装 Docker 的 MacOS、Linux 和 Windows 机器上运行。每个容器对应一个集群节点。入门时，您可以先搭建单节点集群，创建数据库并连接应用。

> 注意：Redis Enterprise Software Docker 镜像建议至少分配 2 核 CPU 和 6GB 内存。更多硬件和软件要求参见 [产品文档](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/hardware-software-requirements/)。

1. **运行 Redis Enterprise Software 容器**

端口 8443 用于管理 UI，端口 12000 预留用于后续步骤创建的 Redis 数据库。

```bash
docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 12000:12000 redislabs/redis
```

2. **通过访问 `https://localhost:8443` 打开 RS Web 控制台进行设置**

> 注意：浏览器可能显示证书错误，选择“继续访问”即可进入设置页面。

![设置页面](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-SetupScreen.jpeg)

3. **保留默认设置，输入集群 FQDN：`cluster.local`**

![设置页面](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-SetupScreen2.jpeg)

4. **配置免费试用版并设置集群管理员账户**

若无许可证密钥，点击“下一步”跳过许可证页面，在后续页面设置管理员邮箱和密码。

![设置页面](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-SetupScreen4.jpeg)

5. **选择创建新 Redis 数据库**

在新建数据库页面，点击“显示高级选项”，输入数据库名称 _"database1"_、端口号 _"12000"_，点击“激活”完成创建。

![数据库页面](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-DBScreen2.jpeg)

现在您已成功创建 Redis 数据库！


## 连接 Redis 数据库

数据库创建后，即可通过 `redis-cli` 或任意 Redis 客户端驱动连接并存储数据。以下是连接示例：

### 使用 `redis-cli` 连接

`redis-cli` 是 Redis 官方命令行工具，用于与 Redis 实例交互。执行以下命令连接容器内的数据库并操作数据：

```bash
docker exec -it rp bash

# sudo /opt/redislabs/bin/redis-cli -p 12000
# 127.0.0.1:12000> set key1 123
# OK
# 127.0.0.1:12000> get key1
# "123"
```

### 使用 Python 应用连接

若主机已安装 Python 和 `redis-py`（Redis Python 客户端），可通过以下示例连接数据库。

> `redis-py` 安装指南参见 [GitHub 仓库](https://github.com/andymccurdy/redis-py)。

创建 `redis_test.py` 文件，内容如下：

```python
import redis

r = redis.StrictRedis(host='localhost', port=12000, db=0)
print("set key1 123")
print(r.set('key1', '123'))
print("get key1")
print(r.get('key1'))
```

运行脚本：

```bash
python redis_test.py
```

成功连接时输出：

```
set key1 123
True
get key1
b'123'
```


# 快速参考

## 支持的 Docker 版本
Docker 17.x 或更高版本。

## 入门指南
* [Redis Enterprise 与 Docker 配合使用](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/)
* [Windows 上的 Redis Enterprise 与 Docker](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/windows/)
* [Mac OSx 上的 Redis Enterprise 与 Docker](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/macos/)
* [Linux 上的 Redis Enterprise 与 Docker](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/linux/)
* [Redis on Flash 数据库入门](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/redis-enterprise-flash/)
* [Redis CRDTs 入门](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/crdbs/)

## 详细文档
* [生产环境 Redis Enterprise 集群设置](https://redislabs.com/redis-enterprise-documentation/initial-setup-creating-a-new-cluster/)
* [技术文档](https://redislabs.com/resources/redis-pack-documentation/)
* [操作指南](https://redislabs.com/resources/how-to-redis-enterprise/)
