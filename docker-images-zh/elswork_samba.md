---
image: elswork/samba
description: "用于构建多架构Samba镜像的Dockerfile，支持Linux与Windows文件共享，适配amd64、arm64等多种平台，是个人定制的Docker配置方案。"
source: https://xuanyuan.cloud/zh/r/elswork/samba
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[elswork/samba](https://xuanyuan.cloud/zh/r/elswork/samba)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Samba

一个用于构建多平台（linux/amd64、linux/arm64、linux/ppc64le、linux/s390x、linux/386、linux/arm/v7、linux/arm/v6）镜像的[Docker](http://docker.com)文件，包含[Samba](https://www.samba.org/)安装。Samba是Linux和Unix系统的标准Windows互操作性套件，本镜像为个人定制的多架构Docker配置方案。

> 注意！你应当仔细阅读每个工具的使用文档！

## 致谢

- [Samba](https://www.samba.org/)
- [dastrasmue rpi-samba](https://github.com/dastrasmue/rpi-samba)

## 详细信息

| 网站 | GitHub | Docker Hub |
| --- | --- | --- |
| [Deft.Work 个人博客](https://deft.work/Samba) | [Samba](https://github.com/DeftWork/samba) | [Samba](https://hub.docker.com/r/elswork/samba) |

| Docker 拉取量 | Docker 星标数 | 镜像大小 | 赞助商 |
| --- | --- | --- | --- |
| [![Docker pulls](https://img.shields.io/docker/pulls/elswork/samba.svg)](https://hub.docker.com/r/elswork/samba "Docker Hub上的samba") | [![Docker stars](https://img.shields.io/docker/stars/elswork/samba.svg)](https://hub.docker.com/r/elswork/samba "Docker Hub上的samba") | [![Docker Image size](https://img.shields.io/docker/image-size/elswork/samba)](https://hub.docker.com/r/elswork/samba "Docker Hub上的samba") | [![GitHub Sponsors](https://img.shields.io/github/sponsors/elswork)](https://github.com/sponsors/elswork "赞助我！") |

## 兼容架构

本镜像使用[buildx](https://docs.docker.com/buildx/working-with-buildx/)构建，支持以下架构：
- amd64、arm64、ppc64le、s390x、386、arm/v7、arm/v6

## 用法

我使用它在Linux和Windows之间共享文件，但Samba还有许多其他功能。

**注意**：此配置方案高度适配我的个人需求，可能不符合你的使用场景。本地文件系统权限、容器权限和Samba权限的处理较为复杂，因此我采用了一种简化方案，将共享路径的所有者与Samba用户同步，这意味着需要承担一些限制和妥协。

容器将配置为Samba共享服务器，只需提供：
- 要挂载的主机目录
- 用户信息（一个或多个uid:gid:username:usergroup:password元组）
- 共享定义（名称、路径、授权用户）

### 用户参数（-u）

格式：`-u uid:gid:username:usergroup:password`
- uid：用户ID，例如1000
- gid：用户所属组ID，例如1000
- username：用户名，例如alice
- usergroup：用户所属组名，例如alice
- password：密码（可与主机文件系统中用户的实际密码不同）

### 共享参数（-s）

格式：`-s name:path:rw:user1[,user2[,userN]]`
- 添加共享，显示名称为`name`，暴露`path`目录的内容，权限为读写（rw）或只读（ro），授权用户为user1、user2、...、userN

### 服务启动

启动Samba文件共享服务。

```sh
docker run -d -p 139:139 -p 445:445 \
  --hostname any-host-name \ # 可选，主机名
  -e TZ=Europe/Madrid \ # 可选，时区
  -v /any/path:/share/data \ # 将/any/path替换为系统中由实际用户拥有的路径
  elswork/samba \
  -u "1000:1000:alice:alice:put-any-password-here" \ # 至少第一个用户需与主机文件系统中的实际用户匹配（密码可不同）
  -u "1001:1001:bob:bob:secret" \
  -u "1002:1002:guest:guest:guest" \
  -s "Backup directory:/share/backups:rw:alice,bob" \ 
  -s "Alice (private):/share/data/alice:rw:alice" \
  -s "Documents (readonly):/share/data/documents:ro:guest,alice,bob"
```

我的实际使用命令：

```sh
docker run -d -p 139:139 -p 445:445 -e TZ=Europe/Madrid \
    -v /home/pirate/docker/makefile:/share/folder elswork/samba \
    -u "1000:1000:pirate:pirate:put-any-password-here" \
    -s "SmbShare:/share/folder:rw:pirate"
```

若共享路径的所有者与启动容器的用户匹配，可使用：

```sh
docker run -d -p 139:139 -p 445:445 --hostname $HOSTNAME -e TZ=Europe/Madrid \
    -v /home/pirate/docker/makefile:/share/folder elswork/samba \
    -u "$(id -u):$(id -g):$(id -un):$(id -gn):put-any-password-here" \
    -s "SmbShare:/share/folder:rw:$(id -un)"
```

在Windows中，通过文件浏览器访问`\\主机IP\`即可查看共享内容。

---
**[赞助我！](https://github.com/sponsors/elswork) 我们一起将项目做得更好。**

其他支持方式：

[![GitHub Sponsors](https://img.shields.io/github/sponsors/elswork)](https://github.com/sponsors/elswork) [![通过PayPal捐赠](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/donate/?business=LFKA5YRJAFYR6&no_recurring=0&item_name=Open+Source+Donation&currency_code=EUR) [![通过比特币捐赠](https://en.cryptobadges.io/badge/micro/18yfsHW2ma4SiY685wh4h7a1aTCqkq2AEc)](https://en.cryptobadges.io/donate/18yfsHW2ma4SiY685wh4h7a1aTCqkq2AEc) [![通过以太坊捐赠](https://en.cryptobadges.io/badge/micro/0x186b91982CbB6450Af5Ab6F32edf074dFCE8771c)](https://en.cryptobadges.io/donate/0x186b91982CbB6450Af5Ab6F32edf074dFCE8771c)
