---
image: haproxytech/haproxy-ubuntu
description: "HAProxy社区版Docker Ubuntu镜像"
source: https://xuanyuan.cloud/zh/r/haproxytech/haproxy-ubuntu
canonical: https://xuanyuan.cloud/zh/r/haproxytech/haproxy-ubuntu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/haproxytech/haproxy-ubuntu" title="haproxytech/haproxy-ubuntu Docker 镜像中文简介、标签列表与拉取命令">haproxytech/haproxy-ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 支持的标签及对应Dockerfile链接

- ["3.3-dev9", "s6-3.3-dev9", "3.3", "s6-3.3"](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/3.3/Dockerfile)
- ["3.2.6", "s6-3.2.6", "3.2", "s6-3.2", "latest"](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/3.2/Dockerfile)
- ["3.1.9", "s6-3.1.9", "3.1", "s6-3.1"](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/3.1/Dockerfile)
- ["3.0.12", "s6-3.0.12", "3.0", "s6-3.0"](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/3.0/Dockerfile)
- ["2.8.16", "s6-2.8.16", "2.8", "s6-2.8"](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/2.8/Dockerfile)
- ["2.6.23", "s6-2.6.23", "2.6", "s6-2.6"](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/2.6/Dockerfile)
- ["2.4.30", "s6-2.4.30", "2.4", "s6-2.4"](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/2.4/Dockerfile)

# 快速参考

- **获取帮助途径**：
  [HAProxy邮件列表](mailto:haproxy@formilux.org)、[HAProxy社区Slack](https://slack.haproxy.org/) 或 [#haproxy on Libera.chat](irc://irc.libera.chat/%23haproxy)

- **问题反馈地址**：
  [https://github.com/haproxytech/haproxy-docker-ubuntu/issues](https://github.com/haproxytech/haproxy-docker-ubuntu/issues)

- **维护者**：
  [HAProxy Technologies](https://github.com/haproxytech)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))
  `linux/amd64`、`linux/arm64`、`linux/arm/v7`

- **镜像更新**：
  [haproxytech/haproxy-docker-ubuntu仓库提交记录](https://github.com/haproxytech/haproxy-docker-ubuntu/commits/main)、[haproxytech/haproxy-docker-ubuntu镜像顶层文件夹](https://github.com/haproxytech/haproxy-docker-ubuntu)

- **本描述来源**：
  [README.md](https://github.com/haproxytech/haproxy-docker-ubuntu/blob/main/README.md)

# 什么是HAProxy？

HAProxy是速度最快、使用最广泛的开源负载均衡器和应用交付控制器。采用C语言编写，以高效利用处理器和内存而闻名。它可在四层（TCP）或七层（HTTP）进行代理，并具备检查、路由和修改HTTP消息的附加功能。

内置Web界面（HAProxy统计页面），可用于监控错误率、流量 volume 和延迟。通过更新单个配置文件即可启用功能，该文件提供定义路由规则、速率限制、访问控制等的语法。

其他功能包括：

- SSL/TLS终止
- Gzip压缩
- 健康检查
- HTTP/2支持
- gRPC支持
- Lua脚本
- DNS服务发现
- 自动重试失败连接
- 详细日志

![logo](https://www.haproxy.org/img/HAProxyCommunityEdition_60px.png)

# 如何使用本镜像

本镜像附带简单示例配置，实际使用时需根据[详细文档](https://docs.haproxy.org/)和[示例](https://github.com/haproxy/haproxy/tree/master/examples)进行配置。以下展示如何用自定义配置覆盖默认haproxy.cfg。

## 创建Dockerfile

```dockerfile
FROM docker.xuanyuan.run/haproxytech/haproxy-ubuntu:3.0
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

需通过`-p`选项将HAProxy监听端口映射到主机，例如`-p 8080:80`表示将主机8080端口映射到容器80端口。

## 使用卷实现配置持久化

```console
$ docker run -d --name my-running-haproxy -v /path/to/etc/haproxy:/usr/local/etc/haproxy:ro haproxytech/haproxy-ubuntu:3.0
```

注意主机`/path/to/etc/haproxy`目录需包含`haproxy.cfg`文件及其他`/etc/haproxy`本地附属文件。

## 重新加载配置

可向容器发送`SIGUSR2`信号以重新加载HAProxy配置：

```console
$ docker kill -s USR2 my-running-haproxy
```

## 启用Data Plane API

2.0+版本镜像默认包含[Data Plane API](https://www.haproxy.com/documentation/hapee/2-7r1/api/data-plane-api/)侧车，启用需执行以下步骤：

1. 通过`userlist`定义一个或多个用户
2. 通过`program api`启用dataplane api进程
3. 以读写方式挂载Docker中的haproxy.cfg（通过定义读写卷或重新构建包含自定义配置的镜像）
4. 用`--expose`暴露dataplane TCP端口

haproxy.cfg相关配置如下：

```
userlist haproxy-dataplaneapi
    user admin insecure-password mypassword

program api
   command /usr/bin/dataplaneapi --host 0.0.0.0 --port 5555 --haproxy-bin /usr/sbin/haproxy --config-file /usr/local/etc/haproxy/haproxy.cfg --reload-cmd "kill -SIGUSR2 1" --restart-cmd "kill -SIGUSR2 1" --reload-delay 5 --userlist haproxy-dataplaneapi
   no option start-on-reload
```

运行此类镜像的命令如下（注意挂载haproxy.cfg的卷为读写模式，且暴露tcp/5555端口）：

```console
$ docker run -d --name my-running-haproxy --expose 5555 -v /path/to/etc/haproxy:/usr/local/etc/haproxy:rw haproxytech/haproxy-ubuntu
```

# 许可证

查看本镜像包含软件的[许可证信息](https://raw.githubusercontent.com/haproxy/haproxy/master/LICENSE)。

与所有Docker镜像一样，本镜像可能包含其他软件（如基础发行版中的Bash等），这些软件可能采用其他许可证。
