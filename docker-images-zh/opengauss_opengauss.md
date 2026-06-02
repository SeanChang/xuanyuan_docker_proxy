---
image: opengauss/opengauss
description: "openGauss官方Docker镜像是由openGauss官方提供的可移植容器打包格式，集成了openGauss数据库引擎、必要配置文件及运行依赖，旨在简化数据库部署流程，确保不同环境下的运行一致性，方便用户快速启动、配置和使用openGauss高性能关系型数据库，适用于开发测试、学习实践等多种场景，为用户提供便捷、高效的数据库使用体验。"
source: https://xuanyuan.cloud/zh/r/opengauss/opengauss
canonical: https://xuanyuan.cloud/zh/r/opengauss/opengauss
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opengauss/opengauss" title="opengauss/opengauss Docker 镜像中文简介、标签列表与拉取命令">opengauss/opengauss 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 如何使用此镜像


## 启动openGauss实例

通过以下命令可快速启动一个openGauss容器实例：

```shell
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=openGauss@123 opengauss/opengauss:tagname
```

**参数说明**：  
- `--name opengauss`：容器名称，可根据需要修改（如自定义为`my-opengauss`）。  
- `--privileged=true`：开启特权模式，确保容器内服务正常运行。  
- `-d`：容器后台运行。  
- `-e GS_PASSWORD=openGauss@123`：设置数据库密码，建议替换为更安全的自定义密码。  
- `opengauss/opengauss:tagname`：镜像名称，需将`tagname`替换为实际版本标签（如`latest`或具体版本号）。  


## 从操作系统使用gsql连接数据库

若需通过本地gsql工具连接容器内的数据库，需先启动带端口映射的容器，再执行连接命令。


### 1. 启动带端口映射的容器

先运行以下命令启动容器，并将容器的5432端口映射到主机（便于外部访问）：

```shell
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=openGauss@123 -p5432:5432 opengauss/opengauss:tagname
```

**新增参数说明**：  
- `-p5432:5432`：端口映射，格式为`主机端口:容器端口`。若主机5432端口被占用，可修改主机端口（如`-p8080:5432`，此时后续连接需用8080端口）。


### 2. 执行gsql连接命令

容器启动后，使用本地gsql工具（需提前安装）执行以下命令连接数据库：

```shell
gsql -d postgres -U gaussdb -W 'openGauss@123' -h host_ip -p 5432
```

**参数说明**：  
- `-d postgres`：指定连接的数据库名称（默认数据库为`postgres`）。  
- `-U gaussdb`：登录用户名，默认用户为`gaussdb`。  
- `-W 'openGauss@123'`：数据库密码，需与启动容器时`GS_PASSWORD`的值一致。  
- `-h host_ip`：数据库所在主机的IP地址，本地连接时可填`127.0.0.1`，远程连接需填容器所在主机的实际IP。  
- `-p 5432`：端口号，需与步骤1中映射的主机端口保持一致（若修改过主机端口，此处需同步调整）。  


## 将数据持久化到本地存储

默认情况下，容器内的数据会随容器删除而丢失。通过挂载本地目录到容器，可将数据持久化到主机本地。


### 启动带数据挂载的容器

运行以下命令，将主机本地目录挂载到容器内的数据存储路径：

```shell
docker run --name opengauss --privileged=true -d -e GS_PASSWORD=openGauss@123 -v /opengauss:/var/lib/opengauss/data opengauss/opengauss:tagname
```

**参数说明**：  
- `-v /opengauss:/var/lib/opengauss/data`：目录挂载，格式为`本地目录:容器内数据目录`。  
  - `本地目录`：需替换为实际的主机路径（如`/home/user/opengauss-data`），确保该目录已存在且有读写权限（可通过`mkdir -p /home/user/opengauss-data`创建）。  
  - `容器内数据目录`：固定为`/var/lib/opengauss/data`，是openGauss数据存储的默认路径。  

挂载后，数据库数据会直接保存在本地目录，即使容器被删除或重建，数据也不会丢失。
