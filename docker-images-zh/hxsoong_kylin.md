---
image: hxsoong/kylin
description: "银河麒麟高级服务器操作系统V10的Docker镜像，基于kylin软件源构建，支持v10-sp1、v10-sp2、v10-sp3版本，适用于构建和运行基于麒麟系统的应用环境。"
source: https://xuanyuan.cloud/zh/r/hxsoong/kylin
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[hxsoong/kylin](https://xuanyuan.cloud/zh/r/hxsoong/kylin)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# 银河麒麟高级服务器操作系统V10 Docker镜像

## 镜像概述和主要用途
本镜像为银河麒麟高级服务器操作系统V10的Docker化版本，基于kylin官方软件源构建，提供稳定可靠的麒麟系统环境，可作为基础镜像用于开发、测试和部署基于麒麟系统的应用程序。

## 核心功能和特性
- 支持多个版本：v10-sp1、v10-sp2、v10-sp3
- 多架构支持：amd64、arm64
- 基于官方kylin软件源构建，保证系统组件完整性
- 精简优化的系统环境，适合容器化部署

## 支持的标签及Dockerfile链接
- `v10-sp1`：[Dockerfile](https://github.com/haixinsong/kylin-sys-docker-image/blob/main/kylin_v10.sys.Dockerfile)
- `v10-sp2`：[Dockerfile](https://github.com/haixinsong/kylin-sys-docker-image/blob/main/kylin_v10.sys.Dockerfile)
- `v10-sp3`：[Dockerfile](https://github.com/haixinsong/kylin-sys-docker-image/blob/main/kylin_v10.sys.Dockerfile)

## 使用场景和适用范围
- 开发基于麒麟系统的应用程序
- 测试需要麒麟操作系统环境的软件
- 构建定制化的麒麟系统应用镜像
- 部署依赖麒麟系统的服务

## 使用方法和配置说明

### 拉取指定架构的镜像
```console
$ docker pull --platform=linux/amd64 hxsoong/kylin:v10-sp3
```
> 如需拉取arm64架构镜像，将`--platform`参数改为`linux/arm64`

### 运行容器进行测试
```console
$ docker run -it hxsoong/kylin:v10-sp3
```
此命令将启动一个交互式容器，可直接在麒麟系统环境中执行命令。

### 基于镜像构建新镜像
可通过Dockerfile在基础镜像上安装额外软件包：
```dockerfile
FROM hxsoong/kylin:v10-sp3
RUN yum install -y vi  # 安装vi编辑器示例
```

## 镜像变体说明

### hxsoong/kylin:v10-sp3
```
bash-5.0# cat /etc/.productinfo 
Kylin Linux Advanced Server
release V10 (SP3) /(Lance)-x86_64-Build23/20230324
bash-5.0# rpm -q kylin-release
kylin-release-10-24.6.p150.ky10.x86_64
```

### hxsoong/kylin:v10-sp2
```
bash-5.0# cat /etc/.productinfo 
Kylin Linux Advanced Server
release V10 (SP2) /(Sword)-x86_64-Build09/20210524
bash-5.0# rpm -q kylin-release
kylin-release-10-24.6.p41.ky10.x86_64
```

### hxsoong/kylin:v10-sp1
```
bash-5.0# cat /etc/.productinfo 
Kylin Linux Advanced Server
release V10 (SP1) /(Tercel)-x86_64-Build20/20210518
bash-5.0# rpm -q kylin-release 
kylin-release-10-24.6.p37.ky10.x86_64
```

## 维护者信息
- 维护者：[haixinsong/kylin-sys-docker-image](https://github.com/haixinsong/kylin-sys-docker-image)
