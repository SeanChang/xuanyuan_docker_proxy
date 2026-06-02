<!-- xuanyuan-docker-images-zh
image: openeuler/kylin
source: https://xuanyuan.cloud/zh/r/openeuler/kylin
canonical: https://xuanyuan.cloud/zh/r/openeuler/kylin
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [openeuler/kylin — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/openeuler/kylin "openeuler/kylin Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/openeuler/kylin

# 镜像概述

官方Kylin Docker镜像，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。Kylin是一款高并发、高性能的智能OLAP引擎，提供低成本且极致的数据分析体验，当前镜像基于[openEuler](https://repo.openeuler.org/)构建，可免费使用且无用户速率限制。更多信息请访问[kylin官方网站](https://kylin.apache.org/)。

# 核心功能与特性

- 高并发：支持大规模并发查询请求
- 高性能：优化的数据处理引擎，提供快速查询响应
- 智能OLAP：专为联机分析处理设计，支持复杂数据分析
- 基于openEuler：稳定可靠的基础镜像，保障运行环境的安全性和兼容性

# 支持的标签及对应Dockerfile链接

每个Kylin Docker镜像的标签由Kylin版本和基础镜像版本组成，详情如下：

| 标签 | 当前版本 | 架构 |
|------|----------|------|
|[5.0.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kylin/5.0.2/24.03-lts-sp1/Dockerfile)| Apache Kylin 5.0.2 基于 openEuler 24.03-LTS-SP1 | amd64, arm64 |

# 使用方法

## 部署Kylin实例

无需预先部署Hadoop组件，通过以下命令部署Kylin实例：

```bash
docker run -d \
    --name Kylin \
    --hostname localhost \
    -e TZ=UTC \
    -m 10G \
    -p 7070:7070 \
    -p 8088:8088 \
    -p 9870:9870 \
    -p 8032:8032 \
    -p 8042:8042 \
    -p 2181:2181 \
    openeuler/kylin:latest
```

## 查看启动日志

通过以下命令查看容器日志，确认Kylin是否就绪：

```bash
docker logs --follow Kylin
```

当日志中出现以下信息时，表示Kylin已准备就绪：

```
Kylin service is already available for you to preview.
```

此时按Ctrl + C退出日志查看，即可访问Kylin Web UI。

## 访问服务

| 服务名称 | URL |
|----------|-----|
| Kylin | http://localhost:7070/kylin⁠ |
| Yarn | http://localhost:8088⁠ |
| HDFS | http://localhost:9870⁠ |

## 登录信息

登录Kylin Web UI时，用户名：ADMIN，密码：KYLIN。

## 停止和删除容器

使用以下命令停止并删除容器：

```bash
docker stop Kylin
docker rm Kylin
```

# 问题与解答

如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
