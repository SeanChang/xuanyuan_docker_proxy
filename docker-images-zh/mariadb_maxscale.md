<!-- xuanyuan-docker-images-zh
image: mariadb/maxscale
source: https://xuanyuan.cloud/zh/r/mariadb/maxscale
canonical: https://xuanyuan.cloud/zh/r/mariadb/maxscale
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [mariadb/maxscale — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/mariadb/maxscale "mariadb/maxscale Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/mariadb/maxscale

![logo]([])

# MariaDB MaxScale Docker镜像

该Docker镜像用于运行MariaDB MaxScale。


## Travis CI构建状态  
![build status badge]([])]([])


## 构建镜像  
构建镜像的命令如下：  
```bash
make build-image
```


## 运行容器  

### 拉取镜像  
从Docker Hub拉取最新的MaxScale镜像：  
```bash
docker pull mariadb/maxscale:latest
```

### 启动容器  
将MaxScale容器以名称“mxs”后台运行：  
```bash
docker run -d --name mxs mariadb/maxscale:latest
```


## 配置  

容器默认配置为最小化配置，仅启用REST API。REST API默认监听8989端口，默认用户为“admin”，密码为“mariadb”。若需从Docker宿主机访问API，需在启动容器时指定端口映射。以下示例展示如何通过curl访问MaxScale基本信息：  

```bash
# 启动容器并映射8989端口
docker run -d -p 8989:8989 --name mxs mariadb/maxscale:latest

# 通过curl访问REST API
curl -u admin:mariadb [] API的信息，请参见[MaxScale文档]([])。


### 通过配置文件自定义配置  
如需自定义配置，可通过额外的配置文件（例如`my-maxscale.cnf`）实现。需将该文件挂载到容器内的`/etc/maxscale.cnf.d/`目录：  
```bash
docker run -d --name mxs -v $PWD/my-maxscale.cnf:/etc/maxscale.cnf.d/my-maxscale.cnf mariadb/maxscale:latest
```


### 命令行访问  
进入运行中的“mxs”容器内部命令行：  
```bash
docker exec -it mxs bash
```
