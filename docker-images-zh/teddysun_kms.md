---
image: teddysun/kms
description: "Teddysun开发的KMS服务器Docker镜像，主要用于激活微软Windows操作系统及Office办公软件等产品，基于Docker容器化技术构建，具有轻量级、部署便捷、配置简单等特点，可快速在各类支持Docker的环境中运行，为用户提供高效、稳定的密钥管理服务，助力实现相关软件的批量激活与授权管理。"
source: https://xuanyuan.cloud/zh/r/teddysun/kms
canonical: https://xuanyuan.cloud/zh/r/teddysun/kms
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/teddysun/kms" title="teddysun/kms Docker 镜像中文简介、标签列表与拉取命令">teddysun/kms 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### Teddysun的KMS服务器Docker镜像

![]() ![]()


#### 一、镜像简介

这是一个完全兼容微软的KMS服务器Docker镜像。


#### 二、关于

该镜像基于[]()项目构建。是一款完全兼容微软的KMS服务器，可为客户端提供产品激活服务，可直接替代微软KMS服务器（即已输入KMS密钥的Windows计算机）。目前支持KMS协议版本4、5、6。

vlmcsd设计用于运行在POSIX兼容操作系统上，仅需基础C库（带BSD风格sockets API）及`fork`或`pthreads`支持。这使得它能在多数嵌入式设备（如路由器、NAS、手机、平板、电视、机顶盒等）上运行，同时也支持Windows系统。


#### 三、支持的标签及对应Dockerfile链接

- `latest` [*(Dockerfile)*][1]


#### 四、支持的架构

- 支持架构：`amd64`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`（[*更多信息*][5]）


#### 五、准备主机

Docker镜像适用于各类云计算平台的快速部署。如需了解Docker及容器化技术，可参考[Docker官方文档][2]。

若需自行安装Docker，请遵循[官方安装指南][3]。


#### 六、拉取镜像

```bash
$ docker pull 
```

执行以上命令可拉取最新版本的KMS服务器镜像，镜像地址：[Docker Hub][4]。


#### 七、启动容器

```bash
$ docker run -d -p 1688:1688 --name kms --restart=always 
```

**注意**：需在防火墙中开放TCP端口`1688`。


[1]: []]: []]: []]: ]: []</think>### Teddysun的KMS服务器Docker镜像

![]() ![]()


#### 一、镜像简介
这是一款完全兼容微软的KMS服务器Docker镜像，基于项目构建，可提供KMS产品激活服务。


#### 二、关于
[]()是一款完全兼容微软的KMS服务器实现，能为客户端提供产品激活服务，可直接替代部署了KMS密钥的微软KMS服务器（如Windows系统）。目前支持KMS协议版本4、5、6。  

vlmcsd设计用于POSIX兼容操作系统，仅需基础C库（带BSD风格sockets API）及`fork`或`pthreads`支持，可运行在路由器、NAS、手机、平板、电视、机顶盒等多数嵌入式设备，同时也支持Windows系统。


#### 三、支持的标签及对应Dockerfile链接
- `latest` [*(Dockerfile)*][1]


#### 四、支持的架构
- 架构类型：`amd64`、`arm32v6`、`arm32v7`、`arm64v8`、`i386`（[*更多信息*][5]）


#### 五、准备主机
Docker镜像适用于各类云计算平台快速部署。如需了解Docker及容器化技术，可参考[Docker官方文档][2]。  

若需自行安装Docker，请遵循[官方安装指南][3]。


#### 六、拉取镜像
```bash
$ docker pull 
```
执行以上命令拉取最新版本KMS服务器镜像，镜像地址：[Docker Hub][4]。


#### 七、启动容器
```bash
$ docker run -d -p 1688:1688 --name kms --restart=always 
```
**注意**：需在防火墙中开放TCP端口`1688`。


[1]: []]: []]: []]: ]: []
