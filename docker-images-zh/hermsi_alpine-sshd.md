---
image: hermsi/alpine-sshd
description: "基于Alpine的可定制OpenSSH服务器Docker镜像，已安装rsync和bash，支持灵活的用户配置与多种认证方式。"
source: https://xuanyuan.cloud/zh/r/hermsi/alpine-sshd
canonical: https://xuanyuan.cloud/zh/r/hermsi/alpine-sshd
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hermsi/alpine-sshd" title="hermsi/alpine-sshd Docker 镜像中文简介、标签列表与拉取命令">hermsi/alpine-sshd 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![Travis](https://shields.beevelop.com/travis/Hermsi1337/docker-sshd.svg?style=flat-square)](https://travis-ci.com/Hermsi1337/docker-sshd)
[![Pulls](https://shields.beevelop.com/docker/pulls/hermsi/alpine-sshd.svg?style=flat-square)](https://hub.docker.com/r/hermsi/alpine-sshd/)
[![Stars](https://shields.beevelop.com/docker/stars/hermsi/alpine-sshd.svg?style=flat-square)](https://hub.docker.com/r/hermsi/alpine-sshd/)
[![Layers](https://shields.beevelop.com/docker/image/layers/hermsi/alpine-sshd/latest.svg?style=flat-square)](https://hub.docker.com/r/hermsi/alpine-sshd/)
[![Size](https://shields.beevelop.com/docker/image/image-size/hermsi/alpine-sshd/latest.svg?style=flat-square)](https://hub.docker.com/r/hermsi/alpine-sshd/)
[![Donate](https://img.shields.io/badge/Donate-PayPal-yellow.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=T85UYT37P3YNJ&source=url)

## 让你的OpenSSH在Alpine上飞驰

### 概述

使用此Docker镜像启动轻量且高度可定制的sshd服务器，已预安装bash和rsync。

### 定期自动构建

感谢[Travis-CI](https://travis-ci.com/)，此镜像每周自动推送更新，若有新版本可用则创建新[标签](https://hub.docker.com/r/hermsi/alpine-sshd/tags/)。

### 标签

最新标签请查看[Dockerhub](https://hub.docker.com/r/hermsi/alpine-sshd/tags/)。

### 核心功能

* 已安装bash shell和rsync工具
* 包含Ubuntu默认的.bashrc配置
* 通过环境变量可配置默认shell
* 通过环境变量启用/禁用root用户
  * 支持root用户的密钥对或密码认证
  * 通过环境变量可配置root用户密码
* 通过环境变量可创建额外ssh用户
  * 额外用户仅支持密钥对认证
* 彩色日志输出，美观易读

### 使用示例

#### 通过密码认证root用户

```bash
$ docker run --rm \
--publish=1337:22 \
--env ROOT_PASSWORD=MyRootPW123 \
hermsi/alpine-sshd
```

容器启动后，可使用环境变量中设置的密码通过root用户SSH登录：

```bash
$ ssh root@mydomain.tld -p 1337
```

#### 通过密钥对认证root用户

```bash
$ docker run --rm \
--publish=1337:22 \
--env ROOT_KEYPAIR_LOGIN_ENABLED=true \
--volume /path/to/authorized_keys:/root/.ssh/authorized_keys \
hermsi/alpine-sshd
```

容器启动后，可使用与容器内`/root/.ssh/authorized_keys`中公钥匹配的私钥通过root用户SSH登录：

```bash
$ ssh root@mydomain.tld -p 1337 -i /path/to/private_key
```

#### 通过密钥对认证额外用户

```bash
$ docker run --rm \
--publish=1337:22 \
--env SSH_USERS="hermsi:1000:1000" \
--volume /path/to/hermsi_public_key:/conf.d/authorized_keys/hermsi \
hermsi/alpine-sshd
```

容器启动后，可使用与容器内`/conf.d/authorized_keys/hermsi`中公钥匹配的私钥通过创建的用户SSH登录：

```bash
$ ssh mydomain.tld -l hermsi -p 1337 -i /path/to/hermsi_private_key
```

#### 创建多个额外用户并通过密钥对认证

```bash
$ docker run --rm \
--publish=1337:22 \
--env SSH_USERS="hermsi:1000:1000,dennis:1001:1001" \
--volume /path/to/hermsi_public_key:/conf.d/authorized_keys/hermsi \
--volume /path/to/dennis_public_key:/conf.d/authorized_keys/dennis \
hermsi/alpine-sshd
```

容器启动后，可使用对应私钥通过创建的任一用户SSH登录。

### 配置说明

本镜像在保持轻量和原生特性的同时，提供高度可定制化配置。

#### 环境变量

| 变量名 | 可能值 | 默认值 | 说明 |
|:-----------------:|:-----------------:|:----------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------:|
| ROOT_LOGIN_UNLOCKED | 'true' 或 'false' | 'false' | 是否允许root用户登录 |
| ROOT_KEYPAIR_LOGIN_ENABLED | 'true' 或 'false' | 'false' | 启用root用户密钥对认证（会自动启用ROOT_LOGIN_UNLOCKED）。需将公钥挂载至容器内`/root/.ssh/authorized_keys` |
| ROOT_PASSWORD | 任意字符串 | `undefined` | 设置root用户密码（会自动启用ROOT_LOGIN_UNLOCKED） |
| USER_LOGIN_SHELL | 任何已存在的shell路径 | `/bin/bash` | 所有额外用户的默认shell。若配置的shell不存在，将回退至`/bin/ash` |

### 扩展镜像

本镜像设计为轻量原生，如需添加`git`等工具，建议基于本镜像构建自定义镜像：

```Dockerfile
FROM docker.xuanyuan.run/hermsi/alpine-sshd:latest

RUN apk add --no-cache \
            git
```

### 与docker-compose配合使用

本镜像最初设计用于与nginx和fpm-php容器配合，通过sftp传输文件。如需参考此类配置示例，可查看[此处](https://github.com/Hermsi1337/docker-compose/blob/master/full_php_dev_stack/docker-compose.yml)。
