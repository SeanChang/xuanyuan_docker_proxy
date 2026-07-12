---
image: library/adminer
description: "这是一款将数据库管理功能集成于单个PHP文件中的轻量级工具，支持数据的添加、查询、更新与删除操作，可便捷管理数据库结构，无需复杂安装配置，仅需将文件上传至服务器即可使用，适用于小型项目开发、临时数据管理或快速原型搭建，为开发者提供高效、简洁的数据库操作体验。"
source: https://xuanyuan.cloud/zh/r/library/adminer
canonical: https://xuanyuan.cloud/zh/r/library/adminer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/adminer" title="library/adminer Docker 镜像中文简介、标签列表与拉取命令">library/adminer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Adminer Docker镜像使用指南


## 快速参考

### 维护者  
[Tim Düsterhus（Docker社区成员）] 


### 获取帮助  
可通过以下渠道获取帮助：  
- [Docker社区Slack]   
- [Server Fault]   
- [Unix & Linux]   
- [Stack Overflow]   


## 支持的标签及对应Dockerfile链接  

- **5.x版本**  
  - [`5.4.0`, `5`, `latest`, `5.4.0-standalone`, `5-standalone`, `standalone`]   
  - [`5.4.0-fastcgi`, `5-fastcgi`, `fastcgi`]   

- **4.x版本**  
  - [`4.17.1`, `4`, `4.17.1-standalone`, `4-standalone`]   
  - [`4.17.1-fastcgi`, `4-fastcgi`]   


## 快速参考（续）

### 提交issue  
[[]]   


### 支持的架构  
（[更多信息] ）  
- [`amd64`]   
- [`arm32v6`]   
- [`arm32v7`]   
- [`arm64v8`]   
- [`i386`]   
- [`ppc64le`]   
- [`riscv64`]   
- [`s390x`]   


### 镜像 artifact 详情  
[repo-info 仓库的 `repos/adminer/` 目录] （[历史记录] ）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
- [official-images 仓库的 `library/adminer` 标签]   
- [official-images 仓库的 `library/adminer` 文件] （[历史记录] ）  


### 本文档来源  
[docs 仓库的 `adminer/` 目录] （[历史记录] ）  


## Adminer  

### Adminer是什么？  
Adminer（前身为phpMinAdmin）是一款用PHP编写的全功能数据库管理工具。与phpMyAdmin不同，它仅需单个文件即可部署到目标服务器。支持MySQL、PostgreSQL、SQLite、MS SQL、Oracle、Firebird、SimpleDB、Elasticsearch和MongoDB等数据库。  

> [adminer.org]   

![logo]   


### 如何使用此镜像  

#### 独立运行（Standalone）  
```console
$ docker run --link some_database:db -p 8080:8080 adminer
```  
运行后，在浏览器中访问 `[] 或 `[] 即可使用。  


#### FastCGI模式  
若已运行支持FastCGI的Web服务器，可通过FastCGI运行Adminer：  
```console
$ docker run --link some_database:db -p 9000:9000 adminer:fastcgi
```  
然后将Web服务器指向容器的9000端口。  

**注意**：此方式会将FastCGI socket暴露到互联网，需配置防火墙规则或使用私有Docker网络以防止直接访问。  


#### 通过 `docker compose` 使用  
`compose.yaml` 示例：  
```yaml
# 使用 root/example 作为用户名/密码凭证

services:
  adminer:
    image: docker.xuanyuan.run/adminer
    restart: always
    ports:
      - 8080:8080

  db:
    image: docker.xuanyuan.run/mysql:5.6
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
```  
运行 `docker compose up`，待初始化完成后，访问 `[] 或 `[]  


#### 加载插件  
此镜像内置所有官方Adminer插件，插件列表见GitHub：[[]] 。  

**通过环境变量加载插件**：  
使用 `ADMINER_PLUGINS` 环境变量指定插件文件名列表：  
```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='tables-filter tinymce' adminer
```  

**需参数的插件**：  
若插件需要参数（如 `login-servers`），直接通过 `ADMINER_PLUGINS` 添加会提示错误。需在容器内创建自定义文件 `/var/www/html/plugins-enabled/[插件名].php`，示例：  
```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='login-servers' adminer
# 错误提示会显示需创建文件，内容示例：
<?php
require_once('plugins/login-servers.php');
return new AdminerLoginServers(
    $servers = ???,  # 需自行定义服务器列表
    $driver = 'server'
);
```  


#### 选择设计风格  
镜像内置Adminer源码包中的所有设计风格，列表见GitHub：[[]] 。  

**使用内置设计**：通过 `ADMINER_DESIGN` 环境变量指定设计名称：  
```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_DESIGN='nette' adminer
```  

**自定义设计**：添加文件 `/var/www/html/adminer.css` 即可应用自定义样式。  


#### 外部服务器使用  
通过 `ADMINER_DEFAULT_SERVER` 环境变量指定默认数据库主机，适用于连接外部服务器或非默认名称（`db`）的Docker容器：  
```console
docker run -p 8080:8080 -e ADMINER_DEFAULT_SERVER=mysql docker.xuanyuan.run/adminer
```  


### 支持的数据库驱动  
镜像默认支持以下驱动：  
- MySQL  
- PostgreSQL  
- SQLite  
- SimpleDB  
- Elasticsearch  

其他驱动需额外安装PHP扩展：  
- MS SQL：`pdo_dblib`  
- Oracle：`oci8`  
- Firebird：`interbase`  
- MongoDB：`mongodb`  


### 许可协议  
查看此镜像包含软件的许可信息：[[]] 。  

与所有Docker镜像一样，可能包含其他软件（如Bash等基础系统组件），其许可协议需另行确认。部分自动检测的许可信息可在 [repo-info 仓库的 `adminer/` 目录]  查看。  

使用前，用户需确保遵守所有包含软件的相关许可协议。
