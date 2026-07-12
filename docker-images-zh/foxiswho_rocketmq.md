---
image: foxiswho/rocketmq
description: "RocketMQ的Docker镜像，支持4.5.0至4.8.0版本，提供NameServer和Broker组件部署，支持目录映射与一键部署，适用于快速搭建消息队列服务，4.7.0+版本统一使用base镜像通过启动文件区分组件。"
source: https://xuanyuan.cloud/zh/r/foxiswho/rocketmq
canonical: https://xuanyuan.cloud/zh/r/foxiswho/rocketmq
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/foxiswho/rocketmq" title="foxiswho/rocketmq Docker 镜像中文简介、标签列表与拉取命令">foxiswho/rocketmq 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# RocketMQ Docker镜像文档

## 镜像概述和主要用途
该镜像基于Apache RocketMQ官方Docker实现，支持4.5.0至4.8.0版本，提供NameServer和Broker组件的容器化部署。4.7.0及以后版本统一使用base镜像，通过不同启动命令区分NameServer和Broker，适用于快速搭建RocketMQ消息队列服务，满足分布式系统的异步通信、解耦等需求。

## 支持版本（Tags）
- 4.8.0
- 4.7.0
- server-4.6.1, broker-4.6.1
- server-4.5.2, broker-4.5.2
- server-4.5.1, broker-4.5.1
- server-4.5.0, broker-4.5.0

## 核心功能和特性
- 多版本支持：涵盖4.5.0至4.8.0主流版本，满足不同环境需求
- 统一镜像架构：4.7.0+版本采用单一base镜像，通过启动命令区分NameServer和Broker
- 灵活目录映射：支持日志、存储、配置目录映射，实现数据持久化与自定义配置
- 一键部署支持：提供docker-compose脚本，简化部署流程
- 控制台集成：兼容RocketMQ控制台，便于服务监控与管理

## 使用场景和适用范围
- 微服务架构中的消息队列服务搭建
- 分布式系统的异步通信、服务解耦和流量削峰
- 开发、测试及生产环境的RocketMQ快速部署
- 需要容器化管理RocketMQ服务的场景

## 使用方法和配置说明

### 重要注意事项
> **映射本地目录权限必须设置为777权限，否则启动不成功**  
> **映射本地目录权限必须设置为777权限，否则启动不成功**  
> **映射本地目录权限必须设置为777权限，否则启动不成功**

### 一键部署（docker-compose）
以4.8.0版本为例：
```shell
git clone https://github.com/foxiswho/docker-rocketmq.git
cd docker-rocketmq
cd rmq
chmod +x start.sh
./start.sh
```
访问控制台：`localhost:8180`

> **配置说明**：若微服务或项目未部署在Docker中，或无法通过IP直接访问RocketMQ容器，需修改`rmq/rmq/brokerconf`目录下的`broker.conf`文件，将`#brokerIP1=192.168.0.253`的注释去掉，并将IP地址改为RocketMQ容器所在宿主机的IP，否则可能报`com.alibaba.rocketmq.remoting.exception.RemotingConnectException`错误。

### 手动部署（4.8.0版本）

#### NameServer部署
##### 无日志目录映射
```bash
docker run -d \
      --name rmqnamesrv \
      -e "JAVA_OPT_EXT=-Xms512M -Xmx512M -Xmn128m" \
      -p 9876:9876 \
      docker.xuanyuan.run/foxiswho/rocketmq:4.8.0 \
      sh mqnamesrv
```

##### 有日志目录映射
```bash
docker run -d -v $(pwd)/logs:/home/rocketmq/logs \
      --name rmqnamesrv \
      -e "JAVA_OPT_EXT=-Xms512M -Xmx512M -Xmn128m" \
      -p 9876:9876 \
      docker.xuanyuan.run/foxiswho/rocketmq:4.8.0 \
      sh mqnamesrv
```
> **注意**：映射的本地`logs`目录需设置777权限。

#### Broker部署
##### 无目录映射
```bash
docker run -d \
      --name rmqbroker \
      -e "NAMESRV_ADDR=rmqnamesrv:9876" \
      -e "JAVA_OPT_EXT=-Xms512M -Xmx512M -Xmn128m" \
      -p 10911:10911 -p 10912:10912 -p 10909:10909 \
      docker.xuanyuan.run/foxiswho/rocketmq:4.8.0 \
      sh mqbroker -c /home/rocketmq/conf/broker.conf
```

##### 有目录映射
```bash
docker run -d -v $(pwd)/logs:/home/rocketmq/logs -v $(pwd)/store:/home/rocketmq/store \
      -v $(pwd)/conf:/home/rocketmq/conf \
      --name rmqbroker \
      -e "NAMESRV_ADDR=rmqnamesrv:9876" \
      -e "JAVA_OPT_EXT=-Xms512M -Xmx512M -Xmn128m" \
      -p 10911:10911 -p 10912:10912 -p 10909:10909 \
      docker.xuanyuan.run/foxiswho/rocketmq:4.8.0 \
      sh mqbroker -c /home/rocketmq/conf/broker.conf
```
> **注意**：若微服务未使用Docker，需修改配置文件中的`brokerIP1`为宿主机IP；映射的`logs`目录需设置777权限。

### 控制台部署
使用`styletang/rocketmq-console-ng`镜像：
```shell
docker run --name rmqconsole --link rmqnamesrv:rmqnamesrv \
-e "JAVA_OPTS=-Drocketmq.namesrv.addr=rmqnamesrv:9876 -Dcom.rocketmq.sendMessageWithVIPChannel=false" \
-p 8180:8080 -t docker.xuanyuan.run/styletang/rocketmq-console-ng
```
访问控制台：`localhost:8180`

示例：
```shell
docker run --name rmqconsole --link rmqnamesrv:namesrv \
-e "JAVA_OPTS=-Drocketmq.namesrv.addr=rmqnamesrv:9876 -Dcom.rocketmq.sendMessageWithVIPChannel=false" \
-p 8180:8080 -t docker.xuanyuan.run/styletang/rocketmq-console-ng
```

## 其他案例
- 综合部署示例：[docker-nacos-sentinel-rocketmq-rabbitmq](https://github.com/foxiswho/docker-nacos-sentinel-rocketmq-rabbitmq)
- 服务治理案例：[docker-consul-fabio-apollo-rocketmq-rabbitmq](https://github.com/foxiswho/docker-consul-fabio-apollo-rocketmq-rabbitmq)
- K8s部署案例：[k8s-nacos-sentinel-rocketmq-zipkin-elasticsearch-redis-mysql](https://github.com/foxiswho/k8s-nacos-sentinel-rocketmq-zipkin-elasticsearch-redis-mysql)

## 官方参考
该镜像基于Apache RocketMQ官方Docker实现：[https://github.com/apache/rocketmq-docker](https://github.com/apache/rocketmq-docker)
