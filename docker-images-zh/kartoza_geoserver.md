---
image: kartoza/geoserver
description: "kartoza/geoserver 是基于开源GeoServer构建的Docker镜像，可快速部署和运行地理空间数据服务器，完整支持OGC标准（如WMS、WFS、WCS），方便用户轻松发布、管理和可视化各类地理数据，适用于GIS应用、地图服务和空间数据分析场景。容器化设计简化部署流程，确保跨平台运行一致性，内置优化配置提供稳定高效的地图服务能力，帮助开发者和系统管理员快速搭建地理数据服务平台，有效降低GIS系统搭建复杂度，加速地理空间应用开发与部署。"
source: https://xuanyuan.cloud/zh/r/kartoza/geoserver
canonical: https://xuanyuan.cloud/zh/r/kartoza/geoserver
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kartoza/geoserver" title="kartoza/geoserver Docker 镜像中文简介、标签列表与拉取命令">kartoza/geoserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kartoza/geoserver" title="kartoza/geoserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kartoza/geoserver</a>

# Kartoza docker-geoserver 介绍  


Kartoza docker-geoserver 是一个轻量的 Docker 容器，用于运行 GeoServer，其设计参考了 [docker recipe]([])。该镜像支持通过环境变量配置 GeoServer，符合 [生产环境运行指南]([])，默认使用 [kartoza/postgis]([]) 作为数据库后端，也可适配其他 PostgreSQL 镜像（需调整环境变量）。


## 获取镜像  

可通过以下方式获取镜像：  


### 从 Dockerhub 拉取  

推荐通过 Docker 可信构建拉取镜像（首次拉取流量较大）：  
```shell  
VERSION=2.25.2  
docker pull kartoza/geoserver:$VERSION  
```  
**注意**：尽管镜像已打标签并通过单元测试，仍建议使用带日期的标签（如 `kartoza/geoserver:$VERSION--v2024.03.31`）。日期标签可在 [Dockerhub]([]) 查看，对应系列的首个版本；后续修复 [issues]([]) 时会覆盖原标签并生成新日期标签。  


### 本地构建  


#### 通过仓库克隆构建  

通过 `docker-compose-build.yml` 本地构建步骤：  
1. 克隆代码仓库：  
   ```shell  
   git clone []  
   ```  
2. 编辑 `.env` 文件中的 [构建参数]([])。  
3. 构建容器并启动服务：  
   ```shell  
   cd docker-geoserver  
   docker-compose -f docker-compose-build.yml up -d geoserver-prod --build  
   ```  


#### 指定 Tomcat 版本构建  

如需基于特定版本的 Tomcat 镜像构建，可通过 `IMAGE_VERSION` 构建参数指定 Tomcat 标签（参考 [Dockerhub Tomcat 标签]([])）：  
```shell  
VERSION=2.25.2  
IMAGE_VERSION=9.0.91-jdk11-temurin-focal  
docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg GS_VERSION=${VERSION} -t kartoza/geoserver:${VERSION} .  
```  
部分新版本 Tomcat 需额外指定 `JAVA_HOME`（如 Apache Tomcat/9.0.36）：  
```shell  
docker build --build-arg IMAGE_VERSION=9.0.91-jdk11-temurin-focal --build-arg JAVA_HOME=/usr/local/openjdk-11/bin/java --build-arg GS_VERSION=2.25.2 -t kartoza/geoserver:2.25.2 .  
```  
**注意**：需参考 [GeoServer 文档]([]) 确认支持的 Tomcat 版本。当前构建默认使用 `tomcat:9.0.91-jdk11-temurin-focal` 作为基础镜像，因其依赖 `libgdal-java`；高于 focal 的 Tomcat 基础镜像可能缺失 GDAL 插件的 Java 绑定，导致 GDAL 插件无法使用。  


#### Windows 环境构建  

Windows 构建需预先安装：  
- Docker Desktop（启用 WSL2）  
- [Java JDK]([])  
- [Conda]([])  
- GDAL（通过 Conda 安装）  

步骤：  
1. 添加 conda-forge 源：  
   ```bash  
   conda config --add channels conda-forge  
   ```  
2. 创建并激活包含 GDAL 的 Conda 环境：  
   ```bash  
   conda create -n geoserver-build -c conda-forge python gdal  
   conda activate geoserver-build  
   ```  
3. 修改 `.env` 文件，建议使用无空格的短路径（斜杠分隔）。通过 PowerShell 获取 Java 短路径：  
   ```bash  
   (New-Object -ComObject Scripting.FileSystemObject).GetFile((get-command java).Source).ShortPath  
   ```  
   输出类似 `C:/PROGRA~1/Java/JDK-15~1.2/bin/java.exe`，可赋值给 `.env` 中的 `JAVA_HOME`。  
4. 构建镜像（建议禁用缓存）：  
   ```bash  
   docker-compose -f docker-compose-build.yml build --force-rm --no-cache  
   docker-compose -f docker-compose-build.yml up -d  
   ```  


## 环境变量  

完整环境变量列表见 [.env]([]) 文件。  


### 默认扩展插件  

容器启动时会默认激活 [default_stable_extensions]([]) 中的插件，包括：  
- vectortiles-plugin、wps-plugin、libjpeg-turbo-plugin、control-flow-plugin、pyramid-plugin、gdal-plugin、monitor-plugin、inspire-plugin、csw-plugin  

如需排除默认插件，需设置 `ACTIVE_EXTENSIONS`：  
```bash  
ACTIVE_EXTENSIONS=${默认扩展列表} - 需排除的插件  
```  
例如，排除 `libjpeg-turbo-plugin`：  
```bash  
ACTIVE_EXTENSIONS=control-flow-plugin,csw-iso-plugin,csw-plugin,gdal-plugin,inspire-plugin,monitor-plugin,pyramid-plugin,vectortiles-plugin,wps-plugin  
```  

若 `ACTIVE_EXTENSIONS` 未设置或为空，将默认启用 [所有默认插件]([])。  


#### 启动时激活稳定扩展  

通过 `STABLE_EXTENSIONS` 指定 [stable_plugins.txt]([]) 中的扩展（逗号分隔）：  
```bash  
VERSION=2.25.2  
docker run -d -p 8600:8080 --name geoserver -e STABLE_EXTENSIONS=charts-plugin,db2-plugin kartoza/geoserver:${VERSION}  
```  


#### 启动时激活社区扩展  

通过 `COMMUNITY_EXTENSIONS` 指定 [community_plugins]([]) 中的扩展（逗号分隔）：  
```bash  
VERSION=2.25.2  
docker run -d -p 8600:8080 --name geoserver -e COMMUNITY_EXTENSIONS=gwc-sqlite-plugin,ogr-datastore-plugin kartoza/geoserver:${VERSION}  
```  
镜像已预下载扩展包，如需强制下载最新社区扩展，可设置 `FORCE_DOWNLOAD_COMMUNITY_EXTENSIONS=true`。  

**注意**：社区扩展问题建议先查阅上游 [GeoServer 文档]([])，若扩展不可用，需自行构建。  


### 示例数据  

镜像内置示例数据（默认未激活），可通过 `SAMPLE_DATA=true` 启用，用于快速熟悉 GeoServer：  
```bash  
VERSION=2.25.2  
docker run -d -p 8600:8080 --name geoserver -e SAMPLE_DATA=true kartoza/geoserver:${VERSION}  
```  


### PostgreSQL 后端磁盘配额  

GeoServer 默认使用 HSQL 数据存储配置磁盘配额，也可改用 PostgreSQL 后端。需确保 PostgreSQL 实例可连接，并配置以下环境变量（本地测试可配合 docker-compose 中的 PostgreSQL）：  
```bash  
DB_BACKEND=POSTGRES               
HOST=db                          
POSTGRES_PORT=5432                
POSTGRES_DB=gwc                   
POSTGRES_USER=${POSTGRES_USER}    
POSTGRES_PASS=${POSTGRES_PASS}    
SSL_MODE=allow                    
POSTGRES_SCHEMA=public           
DISK_QUOTA_SIZE=5 
```  


#### SSL 配置（kartoza/postgis 后端）  

- 若数据库容器设置 `FORCE_SSL=TRUE`，GeoServer 需设置 `SSL_MODE=allow`。  
- 若使用 CA 签名证书，`SSL_MODE` 需设为 `verify-full` 或 `verify-ca`，并挂载证书至 `CERT_DIR` 指定目录：  
  ```bash  
  SSL_CERT_FILE=/etc/certs/fullchain.pem  
  SSL_KEY_FILE=/etc/certs/privkey.pem  
  SSL_CA_FILE=/etc/certs/root.crt  
  ```  


### 激活 JNDI PostgreSQL 连接器  

定义矢量存储时可使用 JNDI 连接池，需设置 `POSTGRES_JNDI=TRUE`（默认 `FALSE`），并配置数据库连接参数：  
```bash  
POSTGRES_JNDI=TRUE  
HOST=${POSTGRES_HOSTNAME}  
POSTGRES_DB=${POSTGRES_DB}  
POSTGRES_USER=${POSTGRES_USER}  
POSTGRES_PASS=${POSTGRES_PASS}  
```  
在 GeoServer 存储配置中需设置 `jndiReferenceName=java:comp/env/jdbc/postgres`。  


### SSL 运行配置  

可通过环境变量启用 GeoServer SSL，实现方案参考 [letsencrypt]([])。  

- **自签名证书**：设置 `SSL=true` 但不提供 `fullchain.pem` 和 `privkey.pem` 时，容器会自动生成：  
  ```bash  
  VERSION=2.25.2  
  docker run -it --name geoserver -e PKCS12_PASSWORD=geoserver -e JKS_KEY_PASSWORD=geoserver -e JKS_STORE_PASSWORD=geoserver -e SSL=true -p 8443:8443 -p 8600:8080 kartoza/geoserver:${VERSION}  
  ```  

- **现有证书**：挂载证书目录至容器：  
  ```bash  
  VERSION=2.25.2  
  docker run -it --name geo -v /etc/certs:/etc/certs -e PKCS12_PASSWORD=geoserver -e JKS_KEY_PASSWORD=geoserver -e JKS_STORE_PASSWORD=geoserver -e SSL=true -p 8443:8443 -p 8600:8080 kartoza/geoserver:${VERSION}  
  ```  

- **PFX 文件**：将 PFX 文件重命名为 `certificate.pfx` 并挂载，容器会自动转换为 PEM 文件。需确保 `ALIAS_KEY` 与生成 PFX 时一致。  

完整 SSL 变量见 [SSL 设置]([])。  


### 代理基础 URL  

如需服务器返回完整代理 URL，需配置：  
```bash  
HTTP_PROXY_NAME=foo.org  
HTTP_PROXY_PORT=80  
```  
若通过 NGINX 反向代理 SSL，需设置：  
```bash  
HTTP_PROXY_NAME=foo.org  
HTTP_SCHEME=https  
```  
避专属域名表单发送不安全的 HTTP 请求（参考 [登录问题]([])）。SSL 连接还可配置 `HTTPS_PROXY_NAME`、`HTTPS_PROXY_PORT`、`HTTPS_SCHEME`。  


### 移除 Tomcat 额外组件  

设置 `TOMCAT_EXTRAS=true` 可保留 Tomcat 文档、示例和管理应用。**注意**：启用时需设置强密码 `TOMCAT_PASSWORD`，否则将生成随机密码：  
```bash  
VERSION=2.25.2  
docker run -it --name geoserver -e TOMCAT_EXTRAS=true -p 8600:8080 kartoza/geoserver:${VERSION}  
```  
若 `TOMCAT_EXTRAS=false`，根路径（"/"）请求返回 404。需重定向至 GeoServer 路径（"/geoserver/web"）时，设置 `ROOT_WEBAPP_REDIRECT=true`。  


### 版本升级  

从低版本迁移至高版本且无需更新管理员密码时，需设置 `EXISTING_DATA_DIR`（值可任意，如 `EXISTING_DATA_DIR=foo`），跳过启动时的密码初始化。  


### 安装额外字体  

- **本地字体**：挂载字体目录至 `/opt/fonts`，容器会自动复制 `.ttf` 或 `.otf` 文件：  
  ```bash  
  VERSION=2.25.2  
  docker run -v fonts:/opt/fonts -p 8080:8080 -t kartoza/geoserver:${VERSION}  
  ```  

- **Google Fonts**：通过 `GOOGLE_FONTS_NAMES` 指定字体（逗号分隔）：  
  ```bash  
  VERSION=2.25.2  
  docker run -e GOOGLE_FONTS_NAMES=actor,akronim -p 8080:8080 -t kartoza/geoserver:${VERSION}  
  ```  


### 其他支持的环境变量  

以下为常用变量（完整列表见 [Generic Env variables]([])）：  
- `GEOSERVER_DATA_DIR`：数据目录路径  
- `ENABLE_JSONP`：是否启用 JSONP（`true`/`false`）  
- `MAX_FILTER_RULES`：最大过滤规则数（整数）  
- `INITIAL_MEMORY`：Java 初始内存（默认 `2G`）  
- `MAXIMUM_MEMORY`：Java 最大内存（默认 `4G`）  


### 控制流配置  

控制流模块用于管理 GeoServer 请求，参数说明见 [文档]([])。支持的环境变量示例：  
```bash  
REQUEST_TIMEOUT=60  
PARALLEL_REQUEST=100  
GETMAP=10  
WPS_REQUEST=1000/d;30s  
```  


### 修改管理员账号密码  

通过环境变量动态修改，容器启动时会重新初始化：  
```bash  
docker run --name "geoserver" -e GEOSERVER_ADMIN_USER=kartoza -e GEOSERVER_ADMIN_PASSWORD=myawesomegeoserver -p 8080:8080 -d -t kartoza/geoserver  
```  
若未设置 `GEOSERVER_ADMIN_PASSWORD`，容器会生成随机密码并输出至启动日志。  

**注意**：升级时需挂载 `settings:/settings` 卷，确保 `update_password.sh` 生成的锁文件持久化（参考 [docker-compose-build]([]) 示例）。  


#### Docker Secrets 支持  

敏感信息可通过 `_FILE` 后缀从文件读取（适用于 Docker Secrets），例如：  
```bash  
-e GEOSERVER_ADMIN_PASSWORD_FILE=/run/secrets/geoserver_pass  
```  
支持的变量包括 `GEOSERVER_ADMIN_USER`、`GEOSERVER_ADMIN_PASSWORD`、`TOMCAT_PASSWORD`、`PKCS12_PASSWORD` 等。  


### 修改部署上下文根路径  

通过 `GEOSERVER_CONTEXT_ROOT` 自定义 GeoServer 部署路径：  
```bash  
GEOSERVER_CONTEXT_ROOT=my-geoserver  
```  
示例中 GeoServer 会部署至 `[] `[] 中用 `#` 分隔）：  
```bash  
GEOSERVER_CONTEXT_ROOT=foo#my-geoserver  
```  
此时部署路径为 `[]  


## 挂载配置文件  

可将配置文件挂载至 `/settings` 目录，覆盖 [Build data]([]) 中的默认配置。支持挂载的文件包括：  
- cluster.properties、controlflow.properties、embedded-broker.properties  
- geowebcache-diskquota-jdbc.xml、s3.properties、tomcat-users.xml  
- web.xml（Tomcat CORS 配置）、epsg.properties（自定义 EPSG）  
- server.xml（Tomcat 配置）、broker.xml、users.xml（用户配置）、roles.xml（角色配置）  

示例：  
```bash  
docker run --name "geoserver" -e GEOSERVER_ADMIN_USER=kartoza -v /data/controlflow.properties:/settings/controlflow.properties -p 8080:8080 -d -t kartoza/geoserver  
```  

**注意**：`users.xml` 和 `roles.xml` 需同时挂载，避免启动错误；挂载后会覆盖 `GEOSERVER_ADMIN_USER` 和 `GEOSERVER_ADMIN_PASSWORD`。  


### 启动时运行脚本  

可挂载 bash 脚本至 `/docker-entrypoint-geoserver.d/`，用于修复依赖（如社区扩展 [集群问题]([])）：  
```bash  
-v ./run.sh:/docker-entrypoint-geoserver.d/run.sh  
```  


### CORS 支持  

镜像默认启用 CORS，如需自定义可挂载 `web.xml` 至 `/settings/`。  


## GeoServer 集群  


### JMS 集群  

GeoServer 支持基于 JMS 集群插件的集群部署，详细配置见 [kartoza 集群文档]([])。
