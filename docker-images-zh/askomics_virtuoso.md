---
image: askomics/virtuoso
description: "基于Alpine的Virtuoso Docker镜像，轻量级（123MB），具备与tenforce/docker-virtuoso相同功能，适用于RDF数据存储与SPARQL查询，支持环境变量配置、数据备份及自动加载功能。"
source: https://xuanyuan.cloud/zh/r/askomics/virtuoso
canonical: https://xuanyuan.cloud/zh/r/askomics/virtuoso
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/askomics/virtuoso" title="askomics/virtuoso Docker 镜像中文简介、标签列表与拉取命令">askomics/virtuoso 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-virtuoso

![Docker Build](https://img.shields.io/docker/pulls/askomics/virtuoso.svg)
[![Build Status](https://travis-ci.org/askomics/docker-virtuoso.svg?branch=master)](https://travis-ci.org/askomics/docker-virtuoso)


基于Alpine的Virtuoso Docker化版本，衍生自[tenforce/docker-virtuoso](https://github.com/tenforce/docker-virtuoso)和[jplu/docker-virtuoso](https://github.com/jplu/docker-virtuoso)。

该镜像具备与[tenforce/docker-virtuoso](https://github.com/tenforce/docker-virtuoso)相同的功能，但体积更小（123MB，原镜像为496MB）。

## 从DockerHub拉取镜像

```bash
docker pull docker.xuanyuan.run/askomics/virtuoso
```

## 或本地构建

```bash
# 克隆仓库
git clone https://github.com/askomics/docker-virtuoso.git
cd docker-virtuoso
# 构建镜像
docker build -t virtuoso .
```


## 运行容器

```bash
docker run --name my-virtuoso \
    -p 8890:8890 -p 1111:1111 \
    -e DBA_PASSWORD=myDbaPassword \
    -e SPARQL_UPDATE=true \
    -e DEFAULT_GRAPH=http://www.example.com/my-graph \
    -v /my/path/to/the/virtuoso/db:/data \
    -d docker.xuanyuan.run/askomics/virtuoso
```

## 配置说明


### dba密码
可通过`DBA_PASSWORD`环境变量在容器启动时设置`dba`用户密码。若未设置，将使用默认密码。

### SPARQL更新权限
通过将`SPARQL_UPDATE`环境变量设为`true`，可授予SPARQL端点的`SPARQL_UPDATE`权限。

### .ini配置
`virtuoso.ini`中的所有属性可通过环境变量配置。环境变量需以`VIRT_`为前缀，格式为`VIRT_$SECTION_$KEY`，其中`$SECTION`（节）和`$KEY`（键）区分大小写，需与`virtuoso.ini`中一致（采用驼峰命名）。例如，`Database`节下的`ErrorLogFile`属性应配置为`VIRT_Database_ErrorLogFile=error.log`。

`virtuoso.ini`文件将在每次容器启动时重新生成。

## 将Virtuoso数据导出为四元组
进入Virtuoso容器，打开ISQL并执行`dump_nquads`过程。导出文件将保存至`/my/path/to/the/virtuoso/db/dumps`。

```bash
docker exec -it my-virtuoso sh
isql-v -U dba -P $DBA_PASSWORD
SQL> dump_nquads ('dumps', 1, 10000000, 1);
```

更多信息参见：http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/VirtRDFDumpNQuad

## 向Virtuoso导入四元组
### 手动导入
将四元组文件（.nq，支持压缩）放入`/my/path/to/the/virtuoso/db/dumps`，进入容器，打开ISQL，注册并运行加载命令。

```bash
docker exec -it my-virtuoso sh
isql-v -U dba -P $DBA_PASSWORD
SQL> ld_dir('dumps', '*.nq', 'http://foo.bar');
SQL> rdf_loader_run();
```

通过查询验证加载状态（`ll_state`为2表示加载完成）：

```sql
select * from DB.DBA.load_list;
```

更多信息参见：http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/VirtBulkRDFLoader

### 自动导入
默认情况下，容器首次启动时，Virtuoso数据库目录（`/my/path/to/the/virtuoso/db/toLoad`）下`toLoad`文件夹中的所有数据将自动加载。默认图由`DEFAULT_GRAPH`环境变量设置，默认为`http://localhost:8890/DAV`。

## 创建备份
通过ISQL接口执行以下命令创建Virtuoso备份：

```bash
docker exec -i my-virtuoso mkdir -p backups
docker exec -i my-virtuoso isql-v <<EOF
    exec('checkpoint');
    backup_context_clear();
    backup_online('backup_',30000,0,vector('backups'));
    exit;
EOF
```

## 恢复备份
停止运行中的容器，使用新容器恢复数据库：

```bash
docker run --rm -it -v path-to-your-database:/data docker.xuanyuan.run/askomics/virtuoso virtuoso-t +restore-backup backups/backup_ +configfile /data/virtuoso.ini
```

备份恢复完成后，新容器将退出，可重启原数据库容器。

也可通过环境变量自动恢复`/data/backups`目录下的备份，无需单独运行容器：

```bash
docker run --name my-virtuoso \
            -p 8890:8890 \
            -p 1111:1111 \
            -e DBA_PASSWORD=dba \
            -e SPARQL_UPDATE=true \
            -e BACKUP_PREFIX=backup_ \
            -v path-to-your-database:/data \
            -d askomics/virtuoso
