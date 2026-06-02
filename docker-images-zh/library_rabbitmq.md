<!-- xuanyuan-docker-images-zh
image: library/rabbitmq
source: https://xuanyuan.cloud/zh/r/library/rabbitmq
canonical: https://xuanyuan.cloud/zh/r/library/rabbitmq
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/rabbitmq" title="library/rabbitmq Docker 镜像中文简介、标签列表与拉取命令">library/rabbitmq — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/rabbitmq" title="library/rabbitmq Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/rabbitmq</a></p>

# RabbitMQ Docker镜像使用指南


## 一、快速参考

### 维护方  
由 [Docker社区]([]) 负责维护。

### 获取帮助渠道  
可通过以下途径获取帮助：  
- [Docker社区Slack]([])  
- [Server Fault]([])  
- [Unix & Linux Stack Exchange]([])  
- [Stack Overflow]([])  


## 二、支持的标签及对应Dockerfile链接  

以下是当前支持的镜像标签及其对应的Dockerfile源码链接：  

### 4.2.x系列（RC版本）  
- `4.2.0-rc.1`、`4.2-rc` → [Dockerfile]([])  
- `4.2.0-rc.1-management`、`4.2-rc-management` → [Dockerfile]([])  
- `4.2.0-rc.1-alpine`、`4.2-rc-alpine` → [Dockerfile]([])  
- `4.2.0-rc.1-management-alpine`、`4.2-rc-management-alpine` → [Dockerfile]([])  

### 4.1.x系列（稳定版）  
- `4.1.4`、`4.1`、`4`、`latest` → [Dockerfile]([])  
- `4.1.4-management`、`4.1-management`、`4-management`、`management` → [Dockerfile]([])  
- `4.1.4-alpine`、`4.1-alpine`、`4-alpine`、`alpine` → [Dockerfile]([])  
- `4.1.4-management-alpine`、`4.1-management-alpine`、`4-management-alpine`、`management-alpine` → [Dockerfile]([])  

### 4.0.x系列  
- `4.0.9`、`4.0` → [Dockerfile]([])  
- `4.0.9-management`、`4.0-management` → [Dockerfile]([])  
- `4.0.9-alpine`、`4.0-alpine` → [Dockerfile]([])  
- `4.0.9-management-alpine`、`4.0-management-alpine` → [Dockerfile]([])  

### 3.13.x系列  
- `3.13.7`、`3.13`、`3` → [Dockerfile]([])  
- `3.13.7-management`、`3.13-management`、`3-management` → [Dockerfile]([])  
- `3.13.7-alpine`、`3.13-alpine`、`3-alpine` → [Dockerfile]([])  
- `3.13.7-management-alpine`、`3.13-management-alpine`、`3-management-alpine` → [Dockerfile]([])  


## 三、快速参考（续）  

### 问题反馈地址  
[GitHub Issues]([])  

### 支持的架构  
（更多信息见[官方说明]([])）  
`amd64`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`、`ppc64le`、`riscv64`、`s390x`  
（各架构镜像链接可通过原文获取）  

### 镜像制品详情  
包含元数据、传输大小等信息，见 [repo-info仓库的rabbitmq目录]([])（含[历史记录]([])）  

### 镜像更新  
- 官方镜像更新跟踪：[official-images仓库的library/rabbitmq标签]([])  
- 镜像定义文件：[official-images仓库的library/rabbitmq文件]([])（含[历史记录]([])）  

### 本文档来源  
[docs仓库的rabbitmq目录]([])（含[历史记录]([])）  


## 四、什么是RabbitMQ？  

RabbitMQ是一款开源消息代理软件（也称消息中间件），实现了高级消息队列协议（AMQP）。其服务端基于Erlang语言开发，并依托Open Telecom Platform框架实现集群和故障转移。目前，几乎所有主流编程语言都有与之对接的客户端库。  

> 更多信息：[维基百科RabbitMQ词条]()  

![RabbitMQ Logo]([])  


## 五、如何使用此镜像  

### 运行守护进程  
RabbitMQ的数据存储依赖“节点名称”（默认与主机名一致），因此在Docker中使用时，建议显式指定`-h`/`--hostname`以固定节点名称，避免随机主机名导致数据追踪困难：  

```bash
docker run -d --hostname my-rabbit --name some-rabbit rabbitmq:3
```  

上述命令将启动一个监听默认端口5672的RabbitMQ容器。运行后可通过`docker logs some-rabbit`查看日志，其中包含节点名称、数据目录等关键信息（如`database dir: /var/lib/rabbitmq/mnesia/rabbit@my-rabbit`）。该镜像默认将`/var/lib/rabbitmq`设为数据卷。  


### 环境变量  
RabbitMQ本身支持的环境变量列表见[官方文档“环境变量”章节]([])。  

**注意**：自RabbitMQ 3.9起，以下Docker特定环境变量已弃用，需通过配置文件替代（详见[官方配置指南]([])）：  
```bash
RABBITMQ_DEFAULT_PASS_FILE、RABBITMQ_DEFAULT_USER_FILE、RABBITMQ_MANAGEMENT_SSL_CACERTFILE、
RABBITMQ_MANAGEMENT_SSL_CERTFILE、RABBITMQ_MANAGEMENT_SSL_DEPTH、RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT、
RABBITMQ_MANAGEMENT_SSL_KEYFILE、RABBITMQ_MANAGEMENT_SSL_VERIFY、RABBITMQ_SSL_CACERTFILE、
RABBITMQ_SSL_CERTFILE、RABBITMQ_SSL_DEPTH、RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT、RABBITMQ_SSL_KEYFILE、
RABBITMQ_SSL_VERIFY、RABBITMQ_VM_MEMORY_HIGH_WATERMARK
```  


### 设置默认用户和密码  
默认用户名为`guest`，密码为`guest`。如需修改，可通过`RABBITMQ_DEFAULT_USER`和`RABBITMQ_DEFAULT_PASS`环境变量指定（RabbitMQ原生支持，非Docker特有）：  

```bash
docker run -d --hostname my-rabbit --name some-rabbit \
  -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=password \
  rabbitmq:3-management
```  

启动后，访问`[]  


### 设置默认虚拟主机  
通过`RABBITMQ_DEFAULT_VHOST`环境变量指定默认虚拟主机：  

```bash
docker run -d --hostname my-rabbit --name some-rabbit \
  -e RABBITMQ_DEFAULT_VHOST=my_vhost \
  rabbitmq:3-management
```  


### 内存限制  
RabbitMQ需感知cgroup施加的内存限制（如`docker run --memory=..`），相关配置通过`rabbitmq.conf`中的`vm_memory_high_watermark`参数设置（详见[官方“内存告警”文档]([])）。若使用相对比例（如`vm_memory_high_watermark.relative`），RabbitMQ将基于主机总内存计算限制，而非容器运行时限制。  


### Erlang Cookie  
集群部署或跨容器管理（如`rabbitmqctl`）需统一Erlang Cookie。可通过文件挂载（如[Docker Secrets]([])）提供Cookie文件（默认路径`/var/lib/rabbitmq/.erlang.cookie`）：  

```bash
docker service create ... --secret source=my-erlang-cookie,target=/var/lib/rabbitmq/.erlang.cookie ... rabbitmq
```  

需确保Cookie文件权限为`0600`，且所属用户/组与容器内一致（详见[Docker `--secret`文档]([])）。  


### 管理插件  
带`-management`后缀的标签预装了[管理插件]([])，默认监听15672端口，用户可通过浏览器访问管理界面：  

```bash
# 直接暴露管理端口到主机8080
docker run -d --hostname my-rabbit --name some-rabbit -p 8080:15672 rabbitmq:3-management
```  


### 启用插件  
可通过Dockerfile预装插件（需基于带管理插件的镜像）：  

```Dockerfile
FROM rabbitmq:3.8-management
RUN rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_federation_management rabbitmq_stomp
```  

也可挂载`/etc/rabbitmq/enabled_plugins`文件指定启用的插件（格式为Erlang原子列表，以句点结尾），例如：  

```erlang
[rabbitmq_federation_management,rabbitmq_management,rabbitmq_mqtt,rabbitmq_stomp].
```  


### 额外配置  
建议通过`/etc/rabbitmq/rabbitmq.conf`文件进行配置（详见[官方“配置文件”章节]([])），可通过挂载、[Docker Configs]([])或Dockerfile的`COPY`指令添加。  

也可通过`RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS`环境变量传递配置（语法见[Erlang OTP文档]([])，需指定`-rabbit`作为应用名）。例如，配置`channel_max`参数：  

```bash
-e RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS="-rabbit channel_max 4007"
```  


### 健康/存活/就绪检查  
此镜像未预设`HEALTHCHECK`，原因及自定义检查建议见[官方镜像FAQ]([])及[相关讨论]([])。  


## 六、镜像变体  

### `rabbitmq:<version>`  
默认镜像，适用于大多数场景。既可作为临时容器（挂载源码启动），也可作为基础镜像构建其他镜像。  


### `rabbitmq:<version>-alpine`  
基于[Alpine Linux]([])（轻量级发行版，基础镜像仅~5MB），镜像体积更小。适用于对最终镜像大小有严格要求的场景。  

**注意**：Alpine使用musl libc而非glibc，部分依赖glibc的软件可能运行异常。如需额外工具（如`git`、`bash`），需在Dockerfile中自行安装（参考[Alpine镜像文档]([])）。  


## 七、许可证  

镜像中软件的许可证信息见[RabbitMQ官方文档]([])。  

与所有Docker镜像一样，本镜像可能包含其他软件（如基础系统的Bash等），其许可证需另行确认。自动检测到的许可证信息可在[repo-info仓库的rabbitmq目录]([])查看。  

使用前请确保遵守所有包含软件的许可证要求。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/rabbitmq" title="library/rabbitmq Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/rabbitmq</a></p>
