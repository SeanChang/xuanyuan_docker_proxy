<!-- xuanyuan-docker-images-zh
image: haproxytech/haproxy-debian
source: https://xuanyuan.cloud/zh/r/haproxytech/haproxy-debian
canonical: https://xuanyuan.cloud/zh/r/haproxytech/haproxy-debian
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [haproxytech/haproxy-debian — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/haproxytech/haproxy-debian "haproxytech/haproxy-debian Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/haproxytech/haproxy-debian

# 支持的标签及对应的`Dockerfile`链接

- [`3.3-dev10`, `s6-3.3-dev10`, `3.3`, `s6-3.3`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.3/Dockerfile)
- [`3.2.6`, `s6-3.2.6`, `3.2`, `s6-3.2`, `latest`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.2/Dockerfile)
- [`3.1.9`, `s6-3.1.9`, `3.1`, `s6-3.1`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.1/Dockerfile)
- [`3.0.12`, `s6-3.0.12`, `3.0`, `s6-3.0`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.0/Dockerfile)
- [`2.8.16`, `s6-2.8.16`, `2.8`, `s6-2.8`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/2.8/Dockerfile)
- [`2.6.23`, `s6-2.6.23`, `2.6`, `s6-2.6`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/2.6/Dockerfile)
- [`2.4.30`, `s6-2.4.30`, `2.4`, `s6-2.4`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/2.4/Dockerfile)

# 快速参考

- **获取帮助的地方**：  
  [HAProxy邮件列表](mailto:haproxy@formilux.org)、[HAProxy社区Slack](https://slack.haproxy.org/) 或 [#haproxy on Libera.chat](irc://irc.libera.chat/%23haproxy)

- **提交问题的地方**：  
  [https://github.com/haproxytech/haproxy-docker-debian/issues](https://github.com/haproxytech/haproxy-docker-debian/issues)

- **维护者**：  
  [HAProxy Technologies](https://github.com/haproxytech)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  `linux/amd64`, `linux/arm64`, `linux/arm/v7`

- **镜像更新**：  
  [haproxytech/haproxy-docker-debian的提交记录](https://github.com/haproxytech/haproxy-docker-debian/commits/main)、[haproxytech/haproxy-docker-debian镜像顶层文件夹](https://github.com/haproxytech/haproxy-docker-debian)

- **本描述的来源**：  
  [README.md](https://github.com/haproxytech/haproxy-docker-debian/blob/main/README.md)

# 什么是HAProxy？

HAProxy是最快且使用最广泛的开源负载均衡器和应用交付控制器。用C语言编写，以高效利用处理器和内存而闻名。它可以在四层（TCP）或七层（HTTP）进行代理，并具有检查、路由和修改HTTP消息的附加功能。

它内置了一个Web UI，称为HAProxy统计页面，可用于监控错误率、流量 volume 和延迟。通过更新单个配置文件即可启用功能，该文件提供了定义路由规则、速率限制、访问控制等的语法。

其他功能包括：

- SSL/TLS终止
- Gzip压缩
- 健康检查
- HTTP/2支持
- gRPC支持
- Lua脚本
- DNS服务发现
- 自动重试失败连接
- 详细日志记录

![logo](https://www.haproxy.org/img/HAProxyCommunityEdition_60px.png)

# 如何使用此镜像

此镜像附带一个简单的示例配置，实际使用时应根据[详细文档](https://docs.haproxy.org/)和[示例](https://github.com/haproxy/haproxy/tree/master/examples)进行配置。以下说明如何用您自己的haproxy.cfg覆盖默认配置。

## 创建`Dockerfile`

```dockerfile
FROM haproxytech/haproxy-debian:3.0
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
```

## 构建容器

```console
$ docker build -t my-haproxy .
```

## 测试配置文件

```console
$ docker run -it --rm my-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
```

## 运行容器

```console
$ docker run -d --name my-running-haproxy my-haproxy
```

您还需要通过指定`-p`选项将HAProxy监听的端口发布到主机，例如`-p 8080:80`将容器的80端口映射到主机的8080端口。

## 使用卷进行配置持久化

```console
$ docker run -d --name my-running-haproxy -v /path/to/etc/haproxy:/usr/local/etc/haproxy:ro haproxytech/haproxy-debian:3.0
```

注意，您主机上的`/path/to/etc/haproxy`文件夹应包含名为`haproxy.cfg`的文件以及`/etc/haproxy`下的其他相关文件。

## 重新加载配置

要重新加载HAProxy配置，您可以向容器发送`SIGUSR2`信号：

```console
$ docker kill -s USR2 my-running-haproxy
```

## 启用数据平面API

所有2.0+版本的镜像默认包含[数据平面API](https://www.haproxy.com/documentation/hapee/2-7r1/api/data-plane-api/)，启用它需要以下步骤：

1. 通过`userlist`定义一个或多个用户
2. 通过`program api`启用数据平面API进程
3. 以读写方式挂载Docker中的haproxy.cfg，可通过定义读写卷或使用自定义haproxy.cfg重建镜像实现
4. 使用`--expose`在Docker中暴露数据平面TCP端口

haproxy.cfg的相关部分如下：

```
userlist haproxy-dataplaneapi
    user admin insecure-password mypassword

program api
   command /usr/bin/dataplaneapi --host 0.0.0.0 --port 5555 --haproxy-bin /usr/sbin/haproxy --config-file /usr/local/etc/haproxy/haproxy.cfg --reload-cmd "kill -SIGUSR2 1" --restart-cmd "kill -SIGUSR2 1" --reload-delay 5 --userlist haproxy-dataplaneapi
   no option start-on-reload
```

运行此类镜像的命令如下（注意包含haproxy.cfg的卷以读写方式挂载，且tcp/5555端口被暴露）：

```console
$ docker run -d --name my-running-haproxy --expose 5555 -v /path/to/etc/haproxy:/usr/local/etc/haproxy:rw haproxytech/haproxy-debian
```

# 许可证

查看此镜像中包含的软件的[许可证信息](https://raw.githubusercontent.com/haproxy/haproxy/master/LICENSE)。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可证（如基础发行版中的Bash等，以及主要软件的任何直接或间接依赖项）。</think>===SHORT_DESC===
HAProxy社区版Docker Debian镜像，提供高性能的开源负载均衡和应用交付控制功能，支持TCP/HTTP代理、SSL终止、健康检查等特性。
===FULL_DESC===
# 支持的标签及对应的`Dockerfile`链接

- [`3.3-dev10`, `s6-3.3-dev10`, `3.3`, `s6-3.3`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.3/Dockerfile)
- [`3.2.6`, `s6-3.2.6`, `3.2`, `s6-3.2`, `latest`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.2/Dockerfile)
- [`3.1.9`, `s6-3.1.9`, `3.1`, `s6-3.1`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.1/Dockerfile)
- [`3.0.12`, `s6-3.0.12`, `3.0`, `s6-3.0`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/3.0/Dockerfile)
- [`2.8.16`, `s6-2.8.16`, `2.8`, `s6-2.8`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/2.8/Dockerfile)
- [`2.6.23`, `s6-2.6.23`, `2.6`, `s6-2.6`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/2.6/Dockerfile)
- [`2.4.30`, `s6-2.4.30`, `2.4`, `s6-2.4`](https://github.com/haproxytech/haproxy-docker-debian/blob/main/2.4/Dockerfile)

# 快速参考

- **获取帮助的地方**：  
  [HAProxy邮件列表](mailto:haproxy@formilux.org)、[HAProxy社区Slack](https://slack.haproxy.org/) 或 [#haproxy on Libera.chat](irc://irc.libera.chat/%23haproxy)

- **提交问题的地方**：  
  [https://github.com/haproxytech/haproxy-docker-debian/issues](https://github.com/haproxytech/haproxy-docker-debian/issues)

- **维护者**：  
  [HAProxy Technologies](https://github.com/haproxytech)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  `linux/amd64`, `linux/arm64`, `linux/arm/v7`

- **镜像更新**：  
  [haproxytech/haproxy-docker-debian的提交记录](https://github.com/haproxytech/haproxy-docker-debian/commits/main)、[haproxytech/haproxy-docker-debian镜像顶层文件夹](https://github.com/haproxytech/haproxy-docker-debian)

- **本描述的来源**：  
  [README.md](https://github.com/haproxytech/haproxy-docker-debian/blob/main/README.md)

# 什么是HAProxy？

HAProxy是最快且使用最广泛的开源负载均衡器和应用交付控制器。用C语言编写，以高效利用处理器和内存而闻名。它可以在四层（TCP）或七层（HTTP）进行代理，并具有检查、路由和修改HTTP消息的附加功能。

它内置了一个Web UI，称为HAProxy统计页面，可用于监控错误率、流量 volume 和延迟。通过更新单个配置文件即可启用功能，该文件提供了定义路由规则、速率限制、访问控制等的语法。

其他功能包括：

- SSL/TLS终止
- Gzip压缩
- 健康检查
- HTTP/2支持
- gRPC支持
- Lua脚本
- DNS服务发现
- 自动重试失败连接
- 详细日志记录

![logo](https://www.haproxy.org/img/HAProxyCommunityEdition_60px.png)

# 如何使用此镜像

此镜像附带一个简单的示例配置，实际使用时应根据[详细文档](https://docs.haproxy.org/)和[示例](https://github.com/haproxy/haproxy/tree/master/examples)进行配置。以下说明如何用您自己的haproxy.cfg覆盖默认配置。

## 创建`Dockerfile`

```dockerfile
FROM haproxytech/haproxy-debian:3.0
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
```

## 构建容器

```console
$ docker build -t my-haproxy .
```

## 测试配置文件

```console
$ docker run -it --rm my-haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
```

## 运行容器

```console
$ docker run -d --name my-running-haproxy my-haproxy
```

您还需要通过指定`-p`选项将HAProxy监听的端口发布到主机，例如`-p 8080:80`将容器的80端口映射到主机的8080端口。

## 使用卷进行配置持久化

```console
$ docker run -d --name my-running-haproxy -v /path/to/etc/haproxy:/usr/local/etc/haproxy:ro haproxytech/haproxy-debian:3.0
```

注意，您主机上的`/path/to/etc/haproxy`文件夹应包含名为`haproxy.cfg`的文件以及`/etc/haproxy`下的其他相关文件。

## 重新加载配置

要重新加载HAProxy配置，您可以向容器发送`SIGUSR2`信号：

```console
$ docker kill -s USR2 my-running-haproxy
```

## 启用数据平面API

所有2.0+版本的镜像默认包含[数据平面API](https://www.haproxy.com/documentation/hapee/2-7r1/api/data-plane-api/)，启用它需要以下步骤：

1. 通过`userlist`定义一个或多个用户
2. 通过`program api`启用数据平面API进程
3. 以读写方式挂载Docker中的haproxy.cfg，可通过定义读写卷或使用自定义haproxy.cfg重建镜像实现
4. 使用`--expose`在Docker中暴露数据平面TCP端口

haproxy.cfg的相关部分如下：

```
userlist haproxy-dataplaneapi
    user admin insecure-password mypassword

program api
   command /usr/bin/dataplaneapi --host 0.0.0.0 --port 5555 --haproxy-bin /usr/sbin/haproxy --config-file /usr/local/etc/haproxy/haproxy.cfg --reload-cmd "kill -SIGUSR2 1" --restart-cmd "kill -SIGUSR2 1" --reload-delay 5 --userlist haproxy-dataplaneapi
   no option start-on-reload
```

运行此类镜像的命令如下（注意包含haproxy.cfg的卷以读写方式挂载，且tcp/5555端口被暴露）：

```console
$ docker run -d --name my-running-haproxy --expose 5555 -v /path/to/etc/haproxy:/usr/local/etc/haproxy:rw haproxytech/haproxy-debian
```

# 许可证

查看此镜像中包含的软件的[许可证信息](https://raw.githubusercontent.com/haproxy/haproxy/master/LICENSE)。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可证（如基础发行版中的Bash等，以及主要软件的任何直接或间接依赖项）。
