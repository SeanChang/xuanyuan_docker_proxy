<!-- xuanyuan-docker-images-zh
image: apache/rocketmq
source: https://xuanyuan.cloud/zh/r/apache/rocketmq
canonical: https://xuanyuan.cloud/zh/r/apache/rocketmq
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/apache/rocketmq" title="apache/rocketmq Docker 镜像中文简介、标签列表与拉取命令">apache/rocketmq — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/apache/rocketmq" title="apache/rocketmq Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/rocketmq</a></p>

# Apache RocketMQ 介绍


## 一、概述  
Apache RocketMQ 是一款开源的分布式消息中间件，2016年成为 Apache 顶级项目。它专为企业级分布式系统设计，主要解决分布式架构中的异步通信、流量削峰、系统解耦等问题，支持高并发、高可靠的消息传递，适合各类企业级业务场景。  


## 二、核心特性  
### 1. 高吞吐与低延迟  
- 支持百万级消息吞吐量（TPS），消息投递延迟低至毫秒级，能应对高并发业务场景（如电商大促、日志采集）。  
- 采用零拷贝、PageCache 等优化技术，提升消息存储和传输效率。  


### 2. 高可靠消息投递  
- **多副本机制**：Broker 支持主从架构和多副本存储，消息写入时可配置同步/异步刷盘，确保数据不丢失。  
- **重试机制**：消费者消费失败后，支持定时重试；生产者发送失败时，可配置重试策略（如重试次数、间隔）。  
- **事务消息**：提供分布式事务消息能力，通过“半事务消息+本地事务+事务状态回查”机制，确保跨系统数据一致性（如电商订单与库存扣减的原子性）。  


### 3. 灵活的消息模式  
- **普通消息**：默认的点对点/发布订阅模式，支持集群消费（消息只被一个消费者处理）和广播消费（消息被所有消费者处理）。  
- **顺序消息**：支持全局顺序（单队列）和局部顺序（按业务 key 分区），适用于需要严格顺序的场景（如订单状态变更）。  
- **定时/延时消息**：支持消息定时投递（如指定 10 分钟后发送），延时级别可自定义。  
- **批量消息**：允许生产者批量发送消息，减少网络交互，提升吞吐量。  


### 4. 易扩展与高可用  
- **无状态 NameServer**：作为路由中心，NameServer 集群无状态、轻量级，可独立部署多节点，支持动态扩容，避免单点故障。  
- **Broker 水平扩展**：Broker 支持多节点集群部署，可按业务拆分 Topic 到不同 Broker，实现存储和负载的横向扩展。  
- **跨地域部署**：支持多集群同步（如异地灾备），通过 DLedger 模式实现 Broker 主从自动切换。  


### 5. 低运维成本  
- 部署简单：基于 Java 开发，依赖少，支持 Docker、K8s 容器化部署，提供一键启动脚本。  
- 监控完善：自带控制台（RocketMQ Dashboard），支持消息轨迹追踪、 Broker 状态监控、消费进度查询等，方便问题排查。  


## 三、适用场景  
### 1. 分布式系统解耦  
- **场景**：微服务架构中，服务间通过消息通信，替代直接 RPC 调用。  
- **举例**：用户下单后，订单系统发送“订单创建”消息，库存、物流、积分系统独立消费消息，避免订单系统与多个下游系统强耦合。  


### 2. 流量削峰填谷  
- **场景**：秒杀、促销等突发高流量场景，通过消息队列缓冲请求，避免下游服务被瞬时流量击垮。  
- **举例**：秒杀活动中，用户请求先发送到 RocketMQ，下游订单服务按处理能力匀速消费消息，防止系统过载。  


### 3. 数据一致性保障  
- **场景**：跨系统数据同步需确保原子性（如“下单成功则扣减库存”）。  
- **举例**：电商订单场景，使用 RocketMQ 事务消息：订单系统发送半事务消息→执行本地订单创建→若成功则提交消息，库存系统消费消息扣减库存；若失败则回滚消息，避免“订单创建但库存未扣减”的不一致问题。  


### 4. 日志/数据采集  
- **场景**：分布式系统中，多节点日志实时采集并集中处理（如 ELK 架构）。  
- **举例**：应用服务器通过 RocketMQ 生产者发送日志消息，消费者将消息写入 Elasticsearch，利用 RocketMQ 高吞吐特性，支撑海量日志实时传输。  


## 四、快速上手  
### 1. 环境准备  
- JDK 8+（推荐 JDK 8）  
- Maven 3.2+（如需编译源码）  


### 2. 下载与安装  
1. 从 [Apache RocketMQ 官网]([]) 下载最新稳定版（如 5.2.0），或通过源码编译：  
   ```bash  
   git clone []  
   cd rocketmq  
   mvn -Prelease-all -DskipTests clean install -U  
   cd distribution/target/rocketmq-<version>/rocketmq-<version>  
   ```  


### 3. 启动服务  
#### （1）启动 NameServer  
```bash  
# 后台启动 NameServer，日志输出到 nohup.out  
nohup sh bin/mqnamesrv &  
# 查看启动日志，出现 "The Name Server boot success" 表示启动成功  
tail -f ~/logs/rocketmqlogs/namesrv.log  
```  


#### （2）启动 Broker  
```bash  
# 启动 Broker，指定 NameServer 地址（本地默认 9876 端口）  
nohup sh bin/mqbroker -n localhost:9876 &  
# 查看启动日志，出现 "The broker[xxx, IP:PORT] boot success" 表示启动成功  
tail -f ~/logs/rocketmqlogs/broker.log  
```  


### 4. 发送与消费消息  
#### （1）发送消息（Java 示例）  
```java  
// 创建生产者，指定组名  
DefaultMQProducer producer = new DefaultMQProducer("producer_group");  
// 设置 NameServer 地址  
producer.setNamesrvAddr("localhost:9876");  
// 启动生产者  
producer.start();  

// 创建消息（topic 为 "test_topic"，tag 为 "tagA"，内容为 "Hello RocketMQ"）  
Message msg = new Message("test_topic", "tagA", "Hello RocketMQ".getBytes());  
// 发送消息  
SendResult sendResult = producer.send(msg);  
System.out.println("发送结果：" + sendResult);  

// 关闭生产者  
producer.shutdown();  
```  


#### （2）消费消息（Java 示例）  
```java  
// 创建消费者，指定组名  
DefaultMQPushConsumer consumer = new DefaultMQPushConsumer("consumer_group");  
// 设置 NameServer 地址  
consumer.setNamesrvAddr("localhost:9876");  
// 订阅 topic "test_topic"，tag 为 "tagA"（* 表示所有 tag）  
consumer.subscribe("test_topic", "tagA");  

// 注册消息监听回调  
consumer.registerMessageListener((List<MessageExt> msgs, ConsumeConcurrentlyContext context) -> {  
    for (MessageExt msg : msgs) {  
        System.out.println("收到消息：" + new String(msg.getBody()));  
    }  
    // 返回 CONSUME_SUCCESS 表示消费成功  
    return ConsumeConcurrentlyStatus.CONSUME_SUCCESS;  
});  

// 启动消费者  
consumer.start();  
System.out.println("消费者启动成功，等待接收消息...");  
// 保持运行（实际应用中需避免主线程退出）  
Thread.sleep(60000);  
```  


### 5. 停止服务  
```bash  
# 关闭 Broker  
sh bin/mqshutdown broker  
# 关闭 NameServer  
sh bin/mqshutdown namesrv  
```  


通过以上步骤，即可快速搭建 RocketMQ 环境并体验消息发送/消费流程。更多高级功能（如事务消息、顺序消息）可参考 [官方文档]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/apache/rocketmq" title="apache/rocketmq Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/apache/rocketmq</a></p>
