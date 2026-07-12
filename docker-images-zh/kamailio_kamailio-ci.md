---
image: kamailio/kamailio-ci
description: "Kamailio的自动化Docker镜像，用于快速部署高性能SIP服务器，支持多种网络模式和版本标签，适用于构建VoIP和实时通信平台。"
source: https://xuanyuan.cloud/zh/r/kamailio/kamailio-ci
canonical: https://xuanyuan.cloud/zh/r/kamailio/kamailio-ci
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kamailio/kamailio-ci" title="kamailio/kamailio-ci Docker 镜像中文简介、标签列表与拉取命令">kamailio/kamailio-ci 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Kamailio Docker镜像

[![Docker Stars](https://img.shields.io/docker/stars/kamailio/kamailio-ci.svg)](https://hub.docker.com/r/kamailio/kamailio-ci/)
[![Docker Pulls](https://img.shields.io/docker/pulls/kamailio/kamailio-ci.svg)](https://hub.docker.com/r/kamailio/kamailio-ci/)
[![Docker Automated build](https://img.shields.io/docker/automated/kamailio/kamailio-ci.svg)](https://hub.docker.com/r/kamailio/kamailio-ci/)

### 什么是Kamailio?

Kamailio是一个开源SIP服务器，基于GPL协议发布，能够每秒处理数千次呼叫建立。它可用于构建大型VoIP和实时通信平台，支持 presence、WebRTC、即时消息等应用。

![logo](https://www.kamailio.org/w/wp-content/uploads/2016/04/kamailio-logo-2015-140x64.png)

### 支持的标签

- `master`, `master-alpine`, `master-alpine.debug`
- `latest`, `latest-alpine`, `latest-alpine.debug`
- `5.4`, `5.4-alpine`, `5.4-alpine.debug`
- `5.3`, `5.3-alpine`, `5.3-alpine.debug`
- `5.2`, `5.2-alpine`, `5.2-alpine.debug`
- `5.1`, `5.1-alpine`, `5.1-alpine.debug`
- `5.4.3`, `5.4.3-alpine`, `5.4.3-alpine.debug`
- `5.4.2`, `5.4.2-alpine`, `5.4.2-alpine.debug`
- `5.4.1`, `5.4.1-alpine`, `5.4.1-alpine.debug`
- `5.4.0`, `5.4.0-alpine`, `5.4.0-alpine.debug`
- `5.3.8`, `5.3.8-alpine`, `5.3.8-alpine.debug`
- `5.3.7`, `5.3.7-alpine`, `5.3.7-alpine.debug`
- `5.3.6`, `5.3.6-alpine`, `5.3.6-alpine.debug`
- `5.3.5`, `5.3.5-alpine`, `5.3.5-alpine.debug`
- `5.3.4`, `5.3.4-alpine`, `5.3.4-alpine.debug`
- `5.3.3`, `5.3.3-alpine`, `5.3.3-alpine.debug`
- `5.3.2`, `5.3.2-alpine`, `5.3.2-alpine.debug`
- `5.3.1`, `5.3.1-alpine`, `5.3.1-alpine.debug`
- `5.3.0`, `5.3.0-alpine`, `5.3.0-alpine.debug`
- `5.2.8`, `5.2.8-alpine`, `5.2.8-alpine.debug`
- `5.2.7`, `5.2.7-alpine`, `5.2.7-alpine.debug`
- `5.2.6`, `5.2.6-alpine`, `5.2.6-alpine.debug`
- `5.2.5`, `5.2.5-alpine`, `5.2.5-alpine.debug`
- `5.2.4`, `5.2.4-alpine`, `5.2.4-alpine.debug`
- `5.2.3`, `5.2.3-alpine`, `5.2.3-alpine.debug`
- `5.2.2`, `5.2.2-alpine`, `5.2.2-alpine.debug`
- `5.2.1`, `5.2.1-alpine`, `5.2.1-alpine.debug`
- `5.2.0`, `5.2.0-alpine`, `5.2.0-alpine.debug`
- `5.1.10`, `5.1.10-alpine`, `5.1.10-alpine.debug`
- `5.1.9`, `5.1.9-alpine`, `5.1.9-alpine.debug`
- `5.1.8`, `5.1.8-alpine`, `5.1.8-alpine.debug`
- `5.1.7`, `5.1.7-alpine`, `5.1.7-alpine.debug`
- `5.1.6`, `5.1.6-alpine`, `5.1.6-alpine.debug`
- `5.1.5`, `5.1.5-alpine`, `5.1.5-alpine.debug`
- `5.1.4`, `5.1.4-alpine`, `5.1.4-alpine.debug`
- `5.1.3`, `5.1.3-alpine`, `5.1.3-alpine.debug`
- `5.1.2`, `5.1.2-alpine`, `5.1.2-alpine.debug`
- `5.1.1`, `5.1.1-alpine`, `5.1.1-alpine.debug`
- `5.1.0`, `5.1.0-alpine`, `5.1.0-alpine.debug`

### 标签说明

- `master`, `latest`, `5.2` 和 `5.1` 标签基于Alpine镜像构建，除libc、busybox、tcpdump、dumpcap、gawk、kamailio及其依赖库外，已移除所有其他库。
- 包含 `-alpine` 关键字的标签基于Alpine镜像构建，保留所有操作系统工具，可以使用`apk`工具。
- 包含 `-alpine.debug` 关键字的标签基于Alpine镜像构建，并包含`gdb`调试工具和Kamailio调试文件。

所有镜像均设计为可在主机网络、桥接网络和swarm网络上运行。

### 镜像使用

#### 准备配置文件

首次运行前需要准备Kamailio默认配置文件。如果已有Kamailio配置文件，可以跳过此步骤。执行以下命令准备默认配置文件：
```console
docker create --name kamailio kamailio/kamailio-ci
docker cp kamailio:/etc/kamailio /etc
docker rm kamailio
```

#### 启动容器

准备好配置文件后，可以启动Docker镜像：
```console
docker run --net=host --name kamailio \
           -v /etc/kamailio:/etc/kamailio \
           docker.xuanyuan.run/kamailio/kamailio-ci -m 64 -M 8
```

### systemd服务配置

可以在Docker主机上使用以下systemd服务文件。将服务文件放置在`/etc/systemd/system/kamailio-docker.service`，并通过以下命令启用：
```console
systemctl start kamailio-docker.service
systemctl enable kamailio-docker.service
```

如果使用`debug`镜像，需要将主机目录（或卷）映射到容器的`/var/lib/coredump`文件夹。可以通过添加`docker run`选项`-v /var/lib/coredump:/var/lib/coredump`实现。

#### 主机网络配置

```console
[Unit]
Description=kamailio Container
After=docker.service network-online.target
Requires=docker.service


[Service]
Restart=always
TimeoutStartSec=0
#One ExecStart/ExecStop line to prevent hitting bugs in certain systemd versions
ExecStart=/bin/sh -c 'docker rm -f kamailio; \
          docker run -t --rm=true --log-driver=none --name kamailio \
                  --net=host \
                 -v /etc/kamailio:/etc/kamailio \
                 docker.xuanyuan.run/kamailio/kamailio-ci'
ExecStop=/usr/bin/docker stop kamailio

[Install]
WantedBy=multi-user.target
```

#### 默认桥接网络配置

```console
[Unit]
Description=kamailio Container
After=docker.service network-online.target
Requires=docker.service


[Service]
Restart=always
TimeoutStartSec=0
#One ExecStart/ExecStop line to prevent hitting bugs in certain systemd versions
ExecStart=/bin/sh -c 'docker rm -f kamailio; \
          docker run -t --rm=true --log-driver=none --name kamailio \
                 --network bridge \
                 -p 5060:5060/udp -p 5060:5060 -p 5061:5061 \
                 --hostname kamailio \
                 -v /etc/kamailio:/etc/kamailio \
                 docker.xuanyuan.run/kamailio/kamailio-ci'

ExecStop=/usr/bin/docker stop kamailio

[Install]
WantedBy=multi-user.target
```

#### 用户定义桥接和swarm网络配置

首先需要创建用户定义网络：

```console
docker network create --driver bridge  --subnet 10.0.0.0/24 my-net
```

或者创建swarm网络：

```console
docker network create --driver overlay --attachable --subnet 10.0.0.0/24 my-net
```

然后创建systemd服务文件：

```console
[Unit]
Description=kamailio Container
After=docker.service network-online.target
Requires=docker.service


[Service]
Restart=always
TimeoutStartSec=0
#One ExecStart/ExecStop line to prevent hitting bugs in certain systemd versions
ExecStart=/bin/sh -c 'docker rm -f kamailio; \
          docker run -t --rm=true --log-driver=none --name kamailio \
                 --network my-net \
                 --ip docker.xuanyuan.run/10.0.0.2 \
                 -p 5060:5060/udp -p 5060:5060 -p 5061:5061 \
                 --hostname kamailio.my-net \
                 -v /etc/kamailio:/etc/kamailio \
                 kamailio/kamailio-ci'

ExecStop=/usr/bin/docker stop kamailio

[Install]
WantedBy=multi-user.target
```

### .bashrc配置

为简化Kamailio管理，可以在.bashrc文件中添加`kamctl`的别名，例如：
```console
alias kamctl='docker exec -i -t kamailio /usr/sbin/kamctl'
```
