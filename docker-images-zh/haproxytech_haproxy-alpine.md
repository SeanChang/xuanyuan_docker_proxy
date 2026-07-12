---
image: haproxytech/haproxy-alpine
description: "HAProxy社区版Docker镜像，基于Alpine Linux构建，提供高性能负载均衡与反向代理功能，适用于构建轻量级、高可用的Web服务或应用集群。"
source: https://xuanyuan.cloud/zh/r/haproxytech/haproxy-alpine
canonical: https://xuanyuan.cloud/zh/r/haproxytech/haproxy-alpine
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/haproxytech/haproxy-alpine" title="haproxytech/haproxy-alpine Docker 镜像中文简介、标签列表与拉取命令">haproxytech/haproxy-alpine 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# HAProxy CE Docker Alpine 镜像文档

## 支持的标签及对应Dockerfile链接

- [`3.3-dev9`, `s6-3.3-dev9`, `3.3`, `s6-3.3`](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/3.3/Dockerfile)
- [`3.2.6`, `s6-3.2.6`, `3.2`, `s6-3.2`, `latest`](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/3.2/Dockerfile)
- [`3.1.9`, `s6-3.1.9`, `3.1`, `s6-3.1`](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/3.1/Dockerfile)
- [`3.0.12`, `s6-3.0.12`, `3.0`, `s6-3.0`](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/3.0/Dockerfile)
- [`2.8.16`, `s6-2.8.16`, `2.8`, `s6-2.8`](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/2.8/Dockerfile)
- [`2.6.23`, `s6-2.6.23`, `2.6`, `s6-2.6`](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/2.6/Dockerfile)
- [`2.4.30`, `s6-2.4.30`, `2.4`, `s6-2.4`](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/2.4/Dockerfile)

## 镜像概述和主要用途

HAProxy是目前速度最快、使用最广泛的开源负载均衡器和应用交付控制器。采用C语言编写，以高效利用CPU和内存著称。它支持四层（TCP）和七层（HTTP）代理，并具备HTTP消息检查、路由和修改等扩展功能。

该镜像内置Web监控界面（HAProxy Stats页面），可用于监控错误率、流量 volume 和延迟。通过修改单个配置文件即可启用各类功能，配置语法支持定义路由规则、速率限制、访问控制等。

## 核心功能和特性

- **高性能代理**：支持四层（TCP）和七层（HTTP）代理，资源利用率高效
- **监控能力**：内置Stats页面，实时监控流量指标
- **SSL/TLS终止**：集中处理SSL/TLS加密和解密
- **数据压缩**：支持Gzip压缩，减少传输带宽
- **健康检查**：自动检测后端服务器健康状态
- **协议支持**：兼容HTTP/2和gRPC
- **脚本扩展**：支持Lua脚本自定义功能
- **服务发现**：集成DNS服务发现机制
- **连接重试**：自动重试失败的连接
- **日志功能**：详细的请求日志记录

## 使用场景和适用范围

- 高流量网站的负载均衡与流量分发
- 微服务架构中的服务网关和请求路由
- SSL/TLS termination，简化后端服务配置
- API网关，实现请求限流、认证和监控
- 跨区域部署的流量调度与灾备切换
- 后端服务器的健康检查与自动故障转移

## 快速参考

- **获取帮助**：  
  [HAProxy邮件列表](mailto:haproxy@formilux.org)、[HAProxy社区Slack](https://slack.haproxy.org/) 或 [Libera.chat #haproxy频道](irc://irc.libera.chat/%23haproxy)

- **提交Issue**：  
  [https://github.com/haproxytech/haproxy-docker-alpine/issues](https://github.com/haproxytech/haproxy-docker-alpine/issues)

- **维护者**：  
  [HAProxy Technologies](https://github.com/haproxytech)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  `linux/amd64`, `linux/arm64`, `linux/arm/v6`, `linux/arm/v7`, `linux/386`

- **镜像更新**：  
  [haproxytech/haproxy-docker-alpine提交记录](https://github.com/haproxytech/haproxy-docker-alpine/commits/main)、[顶层镜像文件夹](https://github.com/haproxytech/haproxy-docker-alpine)

- **描述来源**：  
  [README.md](https://github.com/haproxytech/haproxy-docker-alpine/blob/main/README.md)

## 详细使用方法和配置说明

### 基础使用流程

该镜像默认包含简单示例配置，实际生产环境需根据[官方文档](https://docs.haproxy.org/)和[示例](https://github.com/haproxy/haproxy/tree/master/examples)进行自定义配置。以下是覆盖默认配置的基本步骤：

#### 创建Dockerfile

```dockerfile
FROM docker.xuanyuan.run/haproxytech/haproxy-alpine:3.0
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
```

#### 构建镜像

```console
$ docker build -t my-haproxy .
```

#### 测试配置文件

```console
$ docker run -it --rm my-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
```

#### 运行容器

```console
$ docker run -d --name my-running-haproxy -p 8080:80 my-haproxy
```

> 说明：使用`-p`参数将容器端口映射到主机，示例中主机8080端口映射到容器80端口

### 使用卷实现配置持久化

```console
$ docker run -d --name my-running-haproxy -v /path/to/etc/haproxy:/usr/local/etc/haproxy:ro haproxytech/haproxy-alpine:3.0
```

> 注意：主机目录`/path/to/etc/haproxy`需包含`haproxy.cfg`及其他必要配置文件，`:ro`表示只读挂载

### 重新加载配置

通过发送`SIGUSR2`信号实现配置热加载，无需重启容器：

```console
$ docker kill -s USR2 my-running-haproxy
```

### 启用Data Plane API

2.0+版本镜像默认包含Data Plane API（管理接口），启用步骤如下：

#### 1. 配置文件修改

在`haproxy.cfg`中添加以下内容：

```haproxy
# 定义API用户列表
userlist haproxy-dataplaneapi
    user admin insecure-password mypassword  # 用户名: admin, 密码: mypassword

# 定义API进程
program api
   command /usr/bin/dataplaneapi \
     --host 0.0.0.0 \                   # 监听地址
     --port 5555 \                      # 监听端口
     --haproxy-bin /usr/sbin/haproxy \  # haproxy可执行文件路径
     --config-file /usr/local/etc/haproxy/haproxy.cfg \  # 配置文件路径
     --reload-cmd "kill -SIGUSR2 1" \   # 重载命令
     --restart-cmd "kill -SIGUSR2 1" \  # 重启命令
     --reload-delay 5 \                 # 重载延迟(秒)
     --userlist haproxy-dataplaneapi    # 关联用户列表
   no option start-on-reload            # 避免重载时重启API进程
```

#### 2. 启动容器

```console
$ docker run -d --name my-running-haproxy --expose 5555 -v /path/to/etc/haproxy:/usr/local/etc/haproxy:rw haproxytech/haproxy-alpine
```

> 说明：`--expose 5555`暴露API端口，`:rw`表示读写挂载（API需修改配置文件）

## Docker部署方案示例

### docker-compose配置示例

```yaml
version: '3'
services:
  haproxy:
    image: docker.xuanyuan.run/haproxytech/haproxy-alpine:3.2
    container_name: haproxy
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./haproxy:/usr/local/etc/haproxy:ro
    networks:
      - haproxy-network
    healthcheck:
      test: ["CMD", "haproxy", "-c", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  haproxy-network:
    driver: bridge
```

## 许可证

镜像中软件的许可信息参见[HAProxy许可证](https://raw.githubusercontent.com/haproxy/haproxy/master/LICENSE)。

与所有Docker镜像一样，本镜像可能包含基础发行版的其他软件（如Bash等），这些软件可能具有独立的许可证。
