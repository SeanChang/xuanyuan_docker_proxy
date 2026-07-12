---
image: padhihomelab/alpine-base
description: "这是一个轻量级多架构Alpine Linux Docker基础镜像，集成tini init系统、模块化入口点和su-exec权限降低功能，仅比官方Alpine镜像增加约50KB，适合作为构建安全、高效容器的基础。"
source: https://xuanyuan.cloud/zh/r/padhihomelab/alpine-base
canonical: https://xuanyuan.cloud/zh/r/padhihomelab/alpine-base
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/padhihomelab/alpine-base" title="padhihomelab/alpine-base Docker 镜像中文简介、标签列表与拉取命令">padhihomelab/alpine-base 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker_alpine-base

一个轻量级多架构Alpine Linux Docker镜像，在官方Alpine基础上仅增加约50KB，集成了tini init系统、模块化入口点和su-exec权限降低功能，支持多种硬件架构，适合作为构建其他容器的基础镜像。

## 镜像概述

该镜像基于Alpine Linux，专注于轻量级和安全性，主要特点包括：
- 多架构支持：386、amd64、arm/v6、arm/v7、arm64、ppc64le、s390x、riscv64
- 极小体积：仅比官方Alpine镜像增加约50KB
- 内置tini init系统，解决PID 1僵尸进程回收问题
- 模块化入口点，支持预启动配置脚本
- 自动权限降低功能，提升容器安全性

## 核心功能与特性

### 核心组件

- **tini**：轻量级init系统，支持进程subreaping，解决僵尸进程问题
- **模块化entrypoint**：灵活的入口点脚本，支持预启动配置
- **su-exec**：轻量级权限切换工具，实现从root到普通用户的安全权限降低

### 环境变量

以下环境变量可控制入口点行为，可通过`ENV`指令在Dockerfile中设置或通过`docker run -e`参数传递：

#### 控制权限降低
- `DOCKER_UID`：默认`"12345"`，普通用户UID
- `DOCKER_GID`：默认`"23456"`，普通用户组GID
- `DOCKER_USER`：默认`"user"`，普通用户名
- `DOCKER_GROUP`：默认`"user"`，普通用户组名

#### 控制入口点行为
- `ENTRYPOINT_D`：默认`"/etc/docker-entrypoint.d"`，配置脚本目录
- `ENTRYPOINT_RUN_AS_ROOT`：默认`""`，非空时禁用权限降低
- `ENTRYPOINT_SKIP_CONFIG`：默认`""`，非空时禁用配置脚本执行
- `ENTRYPOINT_LOG_THRESHOLD`：默认`1`，日志级别阈值（1=调试，2=信息，3=警告，4=错误，≥5=禁用）

### 配置脚本

可在`ENTRYPOINT_D`目录中放置额外配置脚本，入口点会在执行`CMD`前运行所有带可执行权限的`.sh`脚本。添加方式：
- 在Dockerfile中使用`COPY`指令复制脚本到`${ENTRYPOINT_D}`
- 运行时通过`-v`参数挂载脚本到`${ENTRYPOINT_D}`

## 使用场景

- 作为构建其他Docker镜像的基础镜像
- 需要轻量级运行环境的应用
- 关注容器安全性，需降低进程权限的场景
- 运行后台服务，需处理僵尸进程的场景
- 多架构部署需求的应用

## 使用方法

### 在Dockerfile中作为基础镜像

```dockerfile
FROM docker.xuanyuan.run/padhihomelab/alpine-base

# 修改环境变量默认值（如有需要）
ENV ENTRYPOINT_LOG_THRESHOLD 3

# 添加配置脚本（如有需要）
COPY config_scripts/*.sh ${ENTRYPOINT_D}/
RUN chmod +x ${ENTRYPOINT_D}/*.sh

# ... 其他自定义配置 ...
```

> 注意：请勿修改镜像的ENTRYPOINT指令

### 运行派生镜像

通常建议运行时设置`DOCKER_UID`以匹配宿主机用户UID，避免权限问题：

```console
$ docker run -e DOCKER_UID=`id -u` -i padhihomelab/alpine-base ps aux
2020-11-22 11:27:43 docker-entrypoint (INFO) 创建用户组 'user'，GID=23456...
2020-11-22 11:27:43 docker-entrypoint (DBUG)   + 用户组创建成功。
2020-11-22 11:27:43 docker-entrypoint (INFO) 创建用户 'user'，UID=1000，隶属组 'user'...
2020-11-22 11:27:43 docker-entrypoint (DBUG)   + 用户创建成功。
2020-11-22 11:27:43 docker-entrypoint (INFO) /etc/docker-entrypoint.d 中未找到文件，跳过配置。
2020-11-22 11:27:43 docker-entrypoint (INFO) 准备启动！
PID   USER     TIME  COMMAND
    1 root      0:00 tini /usr/local/bin/docker-entrypoint ps aux
    6 user      0:00 ps aux
```

## FAQ

### 是否需要覆盖UID、GID等变量？为什么暴露这些变量？

是的，当容器需要写入宿主机文件系统时建议覆盖。若仅进行只读操作或不使用宿主机卷，则无需设置。

- 不降低权限时，容器写入宿主机的文件会属于root，宿主机非root用户难以处理
- 降低权限后，文件会属于`$DOCKER_UID`，若与宿主机用户UID不一致，宿主机处理文件会有困难

更多细节可参考[@vsupalov]的博客文章：[Avoiding Permission Issues With Docker-Created Files]。

### 什么是tini？真的需要吗？

tini是一个极轻量级的init系统。详情可参考[@Yelp]的文章："[Why you need an init system]"。

### 为什么不使用dumb-init或其他init系统？

主要原因是tini支持[Zombie processes]的[subreaping]，而dumb-init不支持。具体原因可参考Hongli Lai的博客文章："[Docker and the PID 1 zombie reaping problem]"。

更多细节：
- "[dumb-init or tini]"（@StevenACoffman）
- "[Why Tini?]"（@krallin）

### 什么是su-exec？真的需要吗？

su-exec用于在运行命令前将权限从root降低到`$DOCKER_USER`。除确实需要root权限运行的场景外，建议使用以提升安全性。

相关安全讨论：
- [Docker containers with root privileges]（Maciej Solnica）
- [Less capabilities, more security: minimize privilege escalation in Docker]（Itamar Tuerner-Trauring）

### 为什么不使用su、gosu或sudo？

主要原因是su-exec比gosu体积更小，且没有su和sudo的特性缺陷。更多细节：
- [gosu:Why?] 和 [gosu:Alternatives]（@tianon）
- "[gosu or su-exec]"（@StevenACoffman）

### 为什么不使用s6等进程管理套件？

s6功能强大，包含tini和su-exec的功能及更多工具，但对于大多数轻量级使用场景（如小型单板计算机）而言过于重量级，本镜像追求最小体积和资源占用。

[Alpine Linux]: https://alpinelinux.org
[dumb-init]: https://github.com/Yelp/dumb-init
[gosu]: https://github.com/tianon/gosu
[s6]: https://skarnet.org/software/s6/
[su]: https://man7.org/linux/man-pages/man1/su.1.html
[su-exec]: https://github.com/ncopa/su-exec
[sudo]: https://www.sudo.ws/
[tini]: https://github.com/krallin/tini

[Hongli Lai]: https://blog.phusion.nl/author/hongli/
[@krallin]: https://github.com/krallin
[@tianon]: https://github.com/tianon
[@StevenACoffman]: https://github.com/StevenACoffman
[@Yelp]: https://github.com/Yelp
[@vsupalov]: https://vsupalov.com/

[Avoiding Permission Issues With Docker-Created Files]: https://vsupalov.com/docker-shared-permissions/
[Docker and the PID 1 zombie reaping problem]: https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
[Docker containers with root privileges]: https://neoteric.eu/blog/docker-containers-with-root-privileges/
[dumb-init or tini]: https://gist.github.com/StevenACoffman/41fee08e8782b411a4a26b9700ad7af5#dumb-init-or-tini
[gosu or su-exec]: https://gist.github.com/StevenACoffman/41fee08e8782b411a4a26b9700ad7af5#gosu-or-su-exec
[gosu:Alternatives]: https://github.com/tianon/gosu#alternatives
[gosu:Why?]: https://github.com/tianon/gosu#why
[Less capabilities, more security: minimize privilege escalation in Docker]: https://pythonspeed.com/articles/root-capabilities-docker-security/
[subreaping]: https://github.com/krallin/tini#subreaping
[Why Tini?]: https://github.com/krallin/tini#why-tini
[Why you need an init system]: https://github.com/Yelp/dumb-init#why-you-need-an-init-system
[Zombie processes]: https://en.wikipedia.org/wiki/Zombie_process
