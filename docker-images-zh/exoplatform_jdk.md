---
image: exoplatform/jdk
description: "提供多种OpenJDK版本与Ubuntu系统组合的JDK Docker镜像，支持扩展镜像、运行UberJAR应用及直接启动JVM等场景。"
source: https://xuanyuan.cloud/zh/r/exoplatform/jdk
canonical: https://xuanyuan.cloud/zh/r/exoplatform/jdk
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/exoplatform/jdk" title="exoplatform/jdk Docker 镜像中文简介、标签列表与拉取命令">exoplatform/jdk — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/exoplatform/jdk" title="exoplatform/jdk Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/exoplatform/jdk</a>

# exoplatform/jdk Docker镜像

## 支持的标签及对应的Dockerfile链接

| JDK版本 | Docker标签 | Dockerfile链接 |
|-------------------------------------|------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| openjdk-17 (19.0.2) + Ubuntu 22.04 | `openjdk-19`, `openjdk-19-ubuntu`, `openjdk-19-ubuntu-22`, `openjdk-19-ubuntu-2204`, `latest` | *[( openjdk-19/ubuntu/22.04/Dockerfile )](./openjdk-19/ubuntu/22.04/Dockerfile)* |
| openjdk-17 (19.0.2) + Ubuntu 20.04 | `openjdk-17`, `openjdk-19-ubuntu-20`, `openjdk-19-ubuntu-2004` | *[( openjdk-19/ubuntu/20.04/Dockerfile )](./openjdk-19/ubuntu/20.04/Dockerfile)* |
| openjdk-17 (17.0.7) + Ubuntu 22.04 | `openjdk-17`, `openjdk-17-ubuntu`, `openjdk-17-ubuntu-22`, `openjdk-17-ubuntu-2204` | *[( openjdk-17/ubuntu/22.04/Dockerfile )](./openjdk-17/ubuntu/22.04/Dockerfile)* |
| openjdk-14 (14.0.2) + Ubuntu 22.04 | `openjdk-14`, `openjdk-14-ubuntu`, `openjdk-14-ubuntu-22`, `openjdk-14-ubuntu-2204` | *[( openjdk-14/ubuntu/22.04/Dockerfile )](./openjdk-14/ubuntu/22.04/Dockerfile)* |
| openjdk-11 (11.0.16) + Ubuntu 22.04 | `openjdk-11`, `openjdk-11-ubuntu`, `openjdk-11-ubuntu-22`, `openjdk-11-ubuntu-2204` | *[( openjdk-11/ubuntu/22.04/Dockerfile )](./openjdk-11/ubuntu/22.04/Dockerfile)* |
| openjdk-17 (17.0.7) + Ubuntu 20.04 | `openjdk-17`, `openjdk-17-ubuntu`, `openjdk-17-ubuntu-20`, `openjdk-17-ubuntu-2004` | *[( openjdk-17/ubuntu/20.04/Dockerfile )](./openjdk-17/ubuntu/20.04/Dockerfile)* |
| openjdk-14 (14.0.2) + Ubuntu 20.04 | `openjdk-14`, `openjdk-14-ubuntu`, `openjdk-14-ubuntu-20`, `openjdk-14-ubuntu-2004` | *[( openjdk-14/ubuntu/20.04/Dockerfile )](./openjdk-14/ubuntu/20.04/Dockerfile)* |
| openjdk-11 (11.0.16) + Ubuntu 20.04 | `openjdk-11`, `openjdk-11-ubuntu`, `openjdk-11-ubuntu-20`, `openjdk-11-ubuntu-2004` | *[( openjdk-11/ubuntu/20.04/Dockerfile )](./openjdk-11/ubuntu/20.04/Dockerfile)* |
| 8 (8u342) + Ubuntu 20.04 | `8`, `8-ubuntu`, `8-ubuntu-20`, `8-ubuntu-2004` | *[( 8/ubuntu/20.04/Dockerfile )](./8/ubuntu/18.04/Dockerfile)* |
| openjdk-11 (11.0.7+10) + Ubuntu 18.04 | `openjdk-11`, `openjdk-11-ubuntu`, `openjdk-11-ubuntu-18`, `openjdk-11-ubuntu-1804` | *[( openjdk-11/ubuntu/18.04/Dockerfile )](./openjdk-11/ubuntu/18.04/Dockerfile)* |
| 8 (8u201) + Ubuntu 18.04 | `8`, `8-ubuntu`, `8-ubuntu-18`, `8-ubuntu-1804` | *[( 8/ubuntu/18.04/Dockerfile )](./8/ubuntu/18.04/Dockerfile)* |
| 8 (8u201) + Ubuntu 16.04 | `8-ubuntu-1604`, `8-ubuntu-16` | *[( 8/ubuntu/16.04/Dockerfile )](./8/ubuntu/16.04/Dockerfile)* |
| openjdk-8 (8u342b07) + Ubuntu 20.04 | `openjdk-8`, `openjdk-8-ubuntu`, `openjdk-8-ubuntu-20`, `openjdk-8-ubuntu-2004` | *[( openjdk-8/ubuntu/20.04/Dockerfile )](./openjdk-8/ubuntu/20.04/Dockerfile)* |
| openjdk-8 (8u222b10) + Ubuntu 18.04 | `openjdk-8`, `openjdk-8-ubuntu`, `openjdk-8-ubuntu-18`, `openjdk-8-ubuntu-1804` | *[( openjdk-8/ubuntu/18.04/Dockerfile )](./openjdk-8/ubuntu/18.04/Dockerfile)* |
| 8 (8u201) + Ubuntu 18.04 | `8`, `8-ubuntu`, `8-ubuntu-18`, `8-ubuntu-1804` | *[( 8/ubuntu/18.04/Dockerfile )](./8/ubuntu/18.04/Dockerfile)* |
| 8 (8u201) + Ubuntu 16.04 | `8-ubuntu-1604`, `8-ubuntu-16` | *[( 8/ubuntu/16.04/Dockerfile )](./8/ubuntu/16.04/Dockerfile)* |

## 快速参考

- **获取帮助的途径**

[eXo社区Docker空间](https://community.exoplatform.com/portal/g/:spaces:docker/docker)，[eXo社区Docker论坛](https://community.exoplatform.com/portal/g/:spaces:docker/docker/forum)

- **支持的Docker版本**

[最新版本](https://github.com/docker/docker-ce/releases/latest)（基于尽力而为原则）

## 如何使用此镜像

一些可能的使用场景：

- 扩展此镜像以添加您的Java应用

```dockerfile
FROM exoplatform/jdk
...
# 添加您的所有内容
```

```bash
# 构建个性化Docker镜像
docker build -t myorga/my-app .

# 在容器中运行应用
docker run --rm myorga/my-app
```

- 启动UberJAR Java应用

```bash
docker run --rm -v /path/to/my/uberjar-app.jar:/uberjar-app.jar exoplatform/jdk -jar /uberjar-app.jar
```

- 启动JVM

```bash
# 显示帮助
$ docker run --rm exoplatform/jdk

用法: java [-options] class [args...]
           (执行类)
   或  java [-options] -jar jarfile [args...]
           (执行jar文件)
其中选项包括:
    -d32    使用32位数据模型（如果可用）
    -d64    使用64位数据模型（如果可用）
    -server   选择"server" VM
                  默认VM是server，
                  因为您运行在服务器级机器上。
...

# 显示版本
$ docker run --rm exoplatform/jdk -version

java version "1.8.0_171"
Java(TM) SE Runtime Environment (build 1.8.0_171-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.171-b11, mixed mode)
```
