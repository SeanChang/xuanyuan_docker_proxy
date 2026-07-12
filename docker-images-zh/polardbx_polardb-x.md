---
image: polardbx/polardb-x
description: "PolarDB-X 一体化镜像集成了 polardbx-sql（SQL 层）、polardbx-engine（引擎层）和 polardbx-cdc（变更数据捕获组件），提供一站式的分布式数据库解决方案，可简化部署与管理流程，满足用户在数据存储、查询处理及数据同步等多方面的需求，助力构建高效、稳定的数据库服务架构。"
source: https://xuanyuan.cloud/zh/r/polardbx/polardb-x
canonical: https://xuanyuan.cloud/zh/r/polardbx/polardb-x
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/polardbx/polardb-x" title="polardbx/polardb-x Docker 镜像中文简介、标签列表与拉取命令">polardbx/polardb-x 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PolarDB-X 一体化镜像介绍  

这是 PolarDB-X 的一体化镜像，包含 GalaxySQL（CN）、GalaxyEngine（DN）及 GalaxyCDC（CDC）组件。  


## 快速启动 PolarDB-X  

通过以下命令可快速启动包含 1 个 CN、1 个 DN 和 1 个 CDC 进程的 PolarDB-X 实例：  


### 1. 默认配置启动  
默认 mem_size 为 4096（即 CN、DN、CDC 各分配 4GB 内存），推荐 Docker 内存设置 ≥ 12GB：  
```bash  
docker run -d --name some-polardb-x -p 8527:8527 -m 12GB docker.xuanyuan.run/polardbx/polardb-x
```  


### 2. 自定义内存配置  
若需设置 mem_size=8192（即 CN、DN、CDC 各分配 8GB 内存），推荐 Docker 内存设置 ≥ 24GB：  
```bash  
docker run -d --name some-polardb-x -p 8527:8527 -m 24GB --env mem_size=8192 docker.xuanyuan.run/polardbx/polardb-x
```  


### 连接 PolarDB-X  
等待容器运行（约 1 分钟）后，可通过以下命令连接 PolarDB-X：  
```bash  
mysql -h127.0.0.1 -P8527 -upolardbx_root -p123456  
```  


## 启动 polardbx-sql（CN）开发环境  

若需开发 CN（polardbx-sql），可通过以下命令启动包含 GMS 和 DN 的容器：  
```bash  
docker run -d --name some-dn-and-gms --env mode=dev -p 4886:4886 -p 32886:32886 docker.xuanyuan.run/polardbx/polardb-x
```  


### 获取开发账户密码  
容器运行后，需在容器内执行以下命令，获取 `my_polarx` 账户的加密密码（用于 CN 的 server.properties 文件）：  
```bash  
mysql -h127.0.0.1 -P4886 -uroot -padmin -D polardbx_meta_db_polardbx -e "select passwd_enc from storage_info where inst_kind=2"  
```  

（说明：该密码来自 `polardbx_meta_db_polardbx` 数据库中 `storage_info` 表的 `passwd_enc` 字段，筛选条件为 `inst_kind=2`）
