---
image: alpine/socat
description: "基于Alpine的轻量级容器，用于运行socat网络工具，实现端口转发、数据流转发等网络通信功能。"
source: https://xuanyuan.cloud/zh/r/alpine/socat
canonical: https://xuanyuan.cloud/zh/r/alpine/socat
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [alpine/socat — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/alpine/socat)

含镜像标签、拉取命令、部署文档与相关推荐。

[alpine/socat Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/alpine/socat)

# socat Docker镜像文档

## 镜像概述和主要用途

socat Docker镜像是一个基于Alpine Linux的轻量级容器，用于运行socat命令。socat是一个多功能的网络工具，用于在不同类型的套接字之间建立双向数据流。该镜像每周自动构建，以确保包含最新版本的socat工具。

## 核心功能和特性

- **轻量级**：基于Alpine Linux，镜像体积小，资源占用低
- **多架构支持**：提供多种硬件架构的镜像版本
- **自动更新**：每周自动构建，确保包含最新版本的socat
- **灵活性**：可用于各种网络转发和端口映射场景

## 镜像信息

- **Docker Hub地址**：[https://hub.docker.com/r/alpine/socat/](https://hub.docker.com/r/alpine/socat/)
- **源代码仓库**：[https://github.com/alpine-docker/multi-arch-libs/tree/master/socat](https://github.com/alpine-docker/multi-arch-libs/tree/master/socat)
- **镜像标签**：[https://hub.docker.com/r/alpine/socat/tags/](https://hub.docker.com/r/alpine/socat/tags/)
- **构建日志**：[https://app.circleci.com/pipelines/github/alpine-docker/multi-arch-libs](https://app.circleci.com/pipelines/github/alpine-docker/multi-arch-libs)

## 使用场景和适用范围

### 场景一：在macOS上暴露TCP socket以访问Docker API

Docker for Mac应用程序允许在不使用vagrant或其他虚拟化Linux操作系统的情况下使用Docker引擎，但不提供与其他版本相同的Docker守护进程配置选项。通过socat可以建立一个绑定到本地主机的TCP套接字，使Docker for Mac API可用。

#### 使用示例

将Unix套接字(`/var/run/docker.sock`)通过Docker守护进程发布为本地主机(127.0.0.1)上的2376端口：

```bash
$ docker pull alpine/socat
$ docker run -d --restart=always \
    -p 127.0.0.1:2376:2375 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    alpine/socat \
    tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
```

> **警告**：Docker API默认是不安全的。请务必将TCP套接字绑定到`localhost`接口，否则Docker API将绑定到所有接口，存在安全风险。

### 场景二：发布现有容器的端口

Docker不允许直接修改现有容器的端口映射配置。通常需要销毁并重新创建容器才能更改发布的端口。使用socat镜像可以作为一种 workaround，通过转发端口和链接容器来解决此限制。

#### 使用示例

将容器`example-container`的1234端口发布为Docker主机的4321端口：

```bash
$ docker pull alpine/socat
$ docker run \
    --publish 4321:1234 \
    --link example-container:target \
    alpine/socat \
    tcp-listen:1234,fork,reuseaddr tcp-connect:target:1234
```

* 若要在后台运行容器，可在`docker run`后添加`--detach`参数
* 若要在重启时自动启动容器，可添加`--restart always`参数
* 若要在重启时自动启动容器（除非被显式停止），可添加`--restart unless-stopped`参数

### 场景三：使用nginx-proxy访问本地Cockpit实例

Socat Docker镜像在Dockerfile中没有使用EXPOSE指令，这可能会影响依赖此信息的其他容器（如nginx-proxy）。通过在运行时使用expose选项，可以允许nginx-proxy正确检测并与socat实例通信，而无需像使用ports选项那样在主机上打开端口。

#### 使用示例

以下示例使用socat将主机的Cockpit实例中继到nginx-proxy镜像，从而可以利用代理端口和可选的Let's Encrypt支持：

```yaml
version: '3'

services:
  cockpit-relay:
    image: alpine/socat
    container_name: cockpit-relay
    depends_on:
      - nginx-proxy
    command: "TCP-LISTEN:9090,fork,reuseaddr TCP:172.17.0.1:9090"
    expose:
      - "9090"
    environment:
      - VIRTUAL_HOST=somehost.somedomain  # 虚拟主机名
      - VIRTUAL_PROTO=https               # 使用的协议
      - LETSENCRYPT_HOST=somehost.somedomain  # Let's Encrypt主机名
      - LETSENCRYPT_EMAIL=some@email.somedomain  # Let's Encrypt邮箱
    restart: unless-stopped
    logging:
      driver: journald
    networks:
      - webservices

networks:
  webservices:
```

## 构建流程

1. 在代码仓库上启用CI定时任务，定期在master分支上运行构建（每周一次）
2. 构建并推送带有latest标签的镜像
3. 在本地运行最新镜像，获取应用程序版本
4. 使用上一步获取的版本为镜像打标签
5. 通过crane工具推送带有版本标签的镜像

## 镜像标签

所有可用的镜像标签可在Docker Hub上查看：[https://hub.docker.com/r/alpine/socat/tags/](https://hub.docker.com/r/alpine/socat/tags/)
