---
image: easysoft/zentao
description: "禅道官方（ZenTao Official）是为企业及团队提供专业项目管理软件与服务的官方平台，专注于产品管理、项目协作、任务跟踪、缺陷管理等一体化解决方案，助力团队高效规划研发流程、统筹资源分配、把控项目进度，实现从需求提出到产品交付的全流程可视化管理，提升协作效率与项目成功率。"
source: https://xuanyuan.cloud/zh/r/easysoft/zentao
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[easysoft/zentao](https://xuanyuan.cloud/zh/r/easysoft/zentao)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# 禅道官方镜像（ZenTaoPMS）

![GitHub Workflow Status (event)]([])
![Docker Pulls]([])
![Docker Image Size]([])
![GitHub tag]([])


## 特别说明
从 18.6 版本开始（企业版 8.6、旗舰版 4.6），镜像结构已调整。若从旧版本升级至 18.6 及以上，需参考[旧版Docker镜像升级说明]([])；全新安装不受影响。


## 快速参考
- 一键安装：通过[渠成软件百宝箱]([])部署 ZenTao  
- Dockerfile 源码：[[]]([])  
- ZenTao 源码：[[]]([])  
- 官网：[[]]([])  


## 一、关于 ZenTao
禅道是开源全生命周期项目管理软件，基于敏捷和CMMI理念设计，集成产品管理、项目管理、质量管理、文档管理、组织管理及事务管理，覆盖项目管理核心流程。  

"禅"与"道"是中国传统文化的代表，命名"禅道"旨在传达"摒弃繁文缛节，还原管理本质"的理念。  

![禅道界面截图]([])  

官网：[[]]([])  


## 二、支持的版本（Tag）
以下为最新5个版本，完整版本列表见[Docker Hub标签页]([])。  

### 镜像地址
- 国内镜像：`hub.zentao.net/app/zentao`  
- Docker Hub：[easysoft/zentao]([])  


### 开源版
- `latest`（最新稳定版）、`18.6`、`18.6-20230831`  
- `18.5`、`18.5-20230713`  
- `18.4`、`18.4-20230625`  
- `18.3-20230424`  
- `18.2-20230315`  


### 企业版
- `biz8.6`、`biz8.6-20230831`、`biz8.6.k8s`、`biz8.6.k8s-20230831`  
- `biz8.5`、`biz8.5-20230713`、`biz8.5.k8s`、`biz8.5.k8s-20230713`  
- `biz8.4`、`biz8.4-20230625`、`biz8.4.k8s`、`biz8.4.k8s-20230625`  
- `biz8.3-20230424`、`biz8.3.k8s-20230424`  
- `biz8.2-20230315`、`biz8.2.k8s-20230315`  


### 旗舰版
- `max4.6`、`max4.6-20230831`、`max4.6.k8s`、`max4.6.k8s-20230831`  
- `max4.5`、`max4.5-20230713`、`max4.5.k8s`、`max4.5.k8s-20230713`  
- `max4.4`、`max4.4-20230625`、`max4.4.k8s`、`max4.4.k8s-20230625`  
- `max4.3-20230424`、`max4.3.k8s-20230424`  
- `max4.2-20230315`、`max4.2.k8s-20230315`  


### 其他版本
- IPD版：`ipd1.1`、`ipd1.0` 等  
- 迅捷版：`lite1.2-20221205`  
- 迅捷企业版：`litevip1.2-20221205`  


## 三、获取镜像
推荐从国内镜像拉取，速度更快：  
```bash
docker pull hub.zentao.net/app/zentao:latest  # 拉取最新版
```  

如需指定版本，替换 `latest` 为具体标签（如 `18.6`）：  
```bash
docker pull hub.zentao.net/app/zentao:18.6  # 拉取18.6版本
```  


## 四、运行镜像
镜像将所有持久化数据（配置、日志等）存储在 `/data` 目录，运行时需挂载该目录。首次启动若挂载目录为空，会自动初始化文件。  


### 4.1 使用内置MySQL（简单部署）
启用内置MySQL，无需额外配置数据库：  
```bash
docker run -it \
  -v $PWD/data:/data  # 挂载数据目录到当前路径的data文件夹  
  -e MYSQL_INTERNAL=true  # 启用内置MySQL  
  hub.zentao.net/app/zentao:latest
```  


### 4.2 使用外部MySQL（生产环境推荐）
需配置外部MySQL连接信息，示例命令：  
```bash
docker run -it \
  -v $PWD/data:/data \
  -e MYSQL_INTERNAL=false \  # 禁用内置MySQL  
  -e ZT_MYSQL_HOST=192.168.1.100 \  # 外部MySQL地址  
  -e ZT_MYSQL_PORT=3306 \  # MySQL端口  
  -e ZT_MYSQL_USER=root \  # MySQL用户名  
  -e ZT_MYSQL_PASSWORD=yourpassword \  # MySQL密码  
  -e ZT_MYSQL_DB=zentao \  # 禅道数据库名（需提前创建）  
  hub.zentao.net/app/zentao:latest
```  

**Docker Compose示例**：  
创建 `docker-compose.yml`，配置MySQL和禅道服务：  
```yaml
version: '3'
services:
  zentao-mysql:
    image: mysql:5.7
    container_name: zentao-mysql
    ports:
      - '13306:3306'
    volumes:
      - /data/zentao/db:/var/lib/mysql  # MySQL数据持久化  
    environment:
      - MYSQL_ROOT_PASSWORD=pass4Zentao  # MySQL root密码  
      - MYSQL_DATABASE=zentao  # 自动创建数据库  

  zentao:
    image: hub.zentao.net/app/zentao:latest
    container_name: zentao
    ports:
      - '80:80'  # 映射80端口  
    volumes:
      - /data/zentao/app:/data  # 禅道数据持久化  
    environment:
      - MYSQL_INTERNAL=false
      - ZT_MYSQL_HOST=zentao-mysql  # 容器间通过服务名通信  
      - ZT_MYSQL_PORT=3306
      - ZT_MYSQL_USER=root
      - ZT_MYSQL_PASSWORD=pass4Zentao
      - ZT_MYSQL_DB=zentao
    depends_on:
      - zentao-mysql
```  


## 五、环境变量配置
通过环境变量自定义禅道运行参数，常用配置如下表：  

| 变量名                  | 默认值                | 说明                                  |
|-------------------------|-----------------------|---------------------------------------|
| `PHP_UPLOAD_MAX_FILESIZE` | 128M                 | 单个文件最大上传大小                  |
| `PHP_POST_MAX_SIZE`     | 128M                  | 最大POST数据大小                      |
| `PHP_MEMORY_LIMIT`      | 256M                  | PHP进程最大内存限制                   |
| `MYSQL_INTERNAL`        | false                 | 是否启用内置MySQL                     |
| `ZT_MYSQL_HOST`         | 127.0.0.1             | 外部MySQL主机地址                     |
| `ZT_MYSQL_PASSWORD`     | pass4zenTao           | MySQL密码（内置MySQL默认密码）        |
| `LDAP_ENABLED`          | false                 | 是否启用LDAP认证                      |
| `SMTP_ENABLED`          | false                 | 是否启用SMTP邮件服务                  |


### 示例：调整上传文件大小
如需支持500MB文件上传，设置以下环境变量：  
```bash
docker run -it \
  -v $PWD/data:/data \
  -e MYSQL_INTERNAL=true \
  -e PHP_UPLOAD_MAX_FILESIZE=500M \  # 单个文件上传限制  
  -e PHP_POST_MAX_SIZE=500M \  # POST数据总大小限制  
  -e PHP_MAX_EXECUTION_TIME=300 \  # 上传超时时间（秒）  
  hub.zentao.net/app/zentao:latest
```  


### 示例：Session存储到Redis
多节点部署时，建议用Redis共享Session：  
1. 先启动Redis容器：  
```bash
docker run -d --name redis redis:3.2-alpine  # 启动Redis  
```  

2. 启动禅道并连接Redis：  
```bash
docker run -it \
  -v $PWD/data:/data \
  --link redis  # 连接Redis容器  
  -e MYSQL_INTERNAL=true \
  -e PHP_SESSION_TYPE=redis \  # Session类型为redis  
  -e PHP_SESSION_PATH=tcp://redis:6379 \  # Redis地址（容器名:端口）  
  hub.zentao.net/app/zentao:latest
```  


## 六、部署方式
### 6.1 Docker Compose一键部署
通过Makefile简化操作（需先克隆源码仓库）：  
```bash
# 克隆仓库
git clone [] && cd zentao-docker

# 启动服务（默认开源版）
make run

# 查看状态
make ps

# 查看日志
docker-compose logs -f zentao
```  


### 6.2 Kubernetes部署（生产环境）
通过Helm快速安装：  
```bash
# 添加Helm仓库
helm repo add zentao [] repo update

# 安装开源版，启用Ingress（替换域名）
helm upgrade -i zentao-open zentao/zentao \
  --set ingress.enabled=true \
  --set ingress.host=zentao.example.local  # 自定义访问域名
```  

如需自定义配置（如资源限制、存储类），可下载Chart包修改 `values.yaml`：  
```bash
helm pull zentao/zentao --untar  # 下载Chart包  
vi zentao/values.yaml  # 编辑配置  
helm upgrade -i zentao-open zentao/zentao -f zentao/values.yaml  # 应用配置  
```  


## 七、版本升级
禅道镜像支持自动升级：检测到数据版本（数据库/文件）与镜像版本不一致时，会自动更新数据库结构。升级步骤：  

1. 修改部署配置中的镜像版本（以Docker Compose为例）：  
```diff
# docker-compose.yml
services:
  zentao:
-    image: hub.zentao.net/app/zentao:18.5
+    image: hub.zentao.net/app/zentao:18.6  # 升级到18.6  
```  

2. 应用更新：  
```bash
docker-compose up -d  # 拉取新镜像并重启服务  
```  

3. 验证版本：  
```bash
docker-compose ps  # 查看服务状态及镜像版本  
```  


## 八、其他操作
### 容器内安装软件
如需临时安装工具（如 `vim`），使用内置命令 `install_packages`，国内用户可指定加速源：  
```bash
# 进入容器
docker exec -it zentao bash

# 安装vim（国内加速）
export MIRROR=true; install_packages vim
```
