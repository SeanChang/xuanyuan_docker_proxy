---
image: library/httpd
description: "Apache HTTP服务器项目是由Apache软件基金会主导开发的开源HTTP服务器，作为全球使用最广泛的Web服务器之一，它支持跨平台运行（包括Linux、Windows等多种操作系统），采用模块化设计以灵活扩展功能，具备高性能、高可靠性及强大的安全性，通过活跃的全球开发者社区持续更新维护，广泛应用于从小型个人网站到大型企业级网络服务的各类场景，为互联网基础设施提供稳定高效的Web服务支持。"
source: https://xuanyuan.cloud/zh/r/library/httpd
canonical: https://xuanyuan.cloud/zh/r/library/httpd
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/httpd" title="library/httpd Docker 镜像中文简介、标签列表与拉取命令">library/httpd — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/httpd" title="library/httpd Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/httpd</a>

# Apache HTTP Server (httpd) Docker镜像使用指南


## 快速参考

### 维护方  
[Docker社区]([])


### 获取帮助渠道  
[Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux Stack Exchange]([]) 或 [Stack Overflow]([])


## 支持的标签及对应Dockerfile链接  

- [`2.4.65`, `2.4`, `2`, `latest`, `2.4.65-trixie`, `2.4-trixie`, `2-trixie`, `trixie`]([])  
- [`2.4.65-alpine`, `2.4-alpine`, `2-alpine`, `alpine`, `2.4.65-alpine3.22`, `2.4-alpine3.22`, `2-alpine3.22`, `alpine3.22`]([])  


## 快速参考（续）  

### 提交issue地址  
[[]]([])  


### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm32v5`]([])、[`arm32v6`]([])、[`arm32v7`]([])、[`arm64v8`]([])、[`i386`]([])、[`ppc64le`]([])、[`riscv64`]([])、[`s390x`]([])  


### 镜像 artifact 详情  
[repo-info仓库的`repos/httpd/`目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
[official-images仓库的`library/httpd`标签]([])  
[official-images仓库的`library/httpd`文件]([])（[历史记录]([])）  


### 本文档来源  
[docs仓库的`httpd/`目录]([])（[历史记录]([])）  


## 什么是 httpd？  

Apache HTTP Server（俗称Apache）是一款Web服务器应用，在万维网初期发展中起到关键作用。它最初基于NCSA HTTPd服务器开发，1995年初NCSA代码开发停滞后续航，Apache迅速取代NCSA HTTPd成为主流HTTP服务器，自1996年4月起持续保持使用率第一。  

> [维基百科：Apache HTTP Server]()  

![Apache logo]([])  


## 如何使用本镜像  


### 基础说明  
本镜像仅包含Apache httpd的上游默认配置，未预装PHP。如需PHP+Apache环境，可参考[PHP镜像]([])的`-apache`标签。若需运行简单HTML服务，可在项目中添加Dockerfile，将`public-html/`目录（存放HTML文件）复制到镜像中。  


### 方法一：通过Dockerfile使用  

#### 1. 在项目中创建Dockerfile  
```dockerfile
FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/
```

#### 2. 构建并运行镜像  
执行以下命令：  
```console
$ docker build -t my-apache2 .
$ docker run -dit --name my-running-app -p 8080:80 my-apache2
```

访问`[] works!”即成功。  


### 方法二：不使用Dockerfile  
直接通过`-v`参数挂载本地目录到容器：  
```console
$ docker run -dit --name my-apache-app -p 8080:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4
```


### 配置自定义  

#### 获取默认配置文件  
先从容器中导出上游默认配置：  
```console
$ docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > my-httpd.conf
```

#### 修改并应用配置  
在Dockerfile中复制自定义配置文件覆盖默认配置：  
```dockerfile
FROM httpd:2.4
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
```


### SSL/HTTPS设置  

#### 基础步骤  
1. 将`server.crt`和`server.key`复制或挂载（`-v`）到`/usr/local/apache2/conf/`目录。  
2. 编辑`httpd.conf`，移除以下行的注释符号（`#`）：  
```apacheconf
...
#LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
...
#LoadModule ssl_module modules/mod_ssl.so
...
#Include conf/extra/httpd-ssl.conf
...
```
3. `conf/extra/httpd-ssl.conf`会自动使用上述证书文件，并监听443端口。运行容器时需添加`-p 443:443`端口映射。  

#### 快捷配置（通过Dockerfile）  
可使用`sed`命令批量移除注释：  
```dockerfile
RUN sed -i \
    -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
    -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
    conf/httpd.conf
```

> **注意**：以上步骤适用于开发环境，生产环境需参考[Apache官方文档]([])优化配置。  


## 镜像版本说明  


### `httpd:<version>`  
默认版本，基于Debian系统。适合大多数场景，可直接作为临时容器（挂载代码启动）或基础镜像构建其他镜像。标签中含`trixie`等名称时，表示基于Debian对应版本（如trixie为Debian 13），如需安装额外依赖，建议显式指定此类标签以减少版本变更影响。  


### `httpd:<version>-alpine`  
基于[Alpine Linux]([])（[`alpine`官方镜像]([])），体积极小（约5MB基础镜像），适合对镜像大小敏感的场景。  

#### 注意事项  
- 使用musl libc替代glibc，部分依赖glibc的软件可能兼容性问题（参考[相关讨论]([])）。  
- 为精简体积，通常不含`git`、`bash`等工具，需在Dockerfile中自行安装（参考[`alpine`镜像说明]([])）。  


## 许可证  

### 软件许可证  
查看[Apache许可证信息]([])。  

### 镜像包含软件的许可证  
所有Docker镜像可能包含基础系统（如Bash）及依赖软件，其许可证可能不同。部分自动检测的许可证信息可在[repo-info仓库的`httpd/`目录]([])查看。  

### 使用责任  
使用预构建镜像时，用户需自行确保符合所有包含软件的许可证要求。
