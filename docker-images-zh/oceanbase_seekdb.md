---
image: oceanbase/seekdb
description: "seekdb Docker镜像用于快速搭建SeekDB测试环境，可在Docker Hub、quay.io及ghcr.io获取。注意：仅适用于测试，不建议生产环境；MacOS和Intel芯片上Docker版本>4.9.0存在已知问题，可通过指定链接下载兼容版本。"
source: https://xuanyuan.cloud/zh/r/oceanbase/seekdb
canonical: https://xuanyuan.cloud/zh/r/oceanbase/seekdb
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oceanbase/seekdb" title="oceanbase/seekdb Docker 镜像中文简介、标签列表与拉取命令">oceanbase/seekdb — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/oceanbase/seekdb" title="oceanbase/seekdb Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/oceanbase/seekdb</a>

# 使用Docker部署SeekDB

## 简介

`seekdb` Docker镜像可在[dockerhub](https://hub.docker.com/r/oceanbase/seekdb)、[quay.io](https://quay.io/repository/oceanbase/seekdb)和[ghcr.io](https://ghcr.io/oceanbase/seekdb)获取，旨在帮助用户快速搭建SeekDB测试环境。

### 关键注意事项：
- 在MacOS和Intel芯片上，使用Docker版本大于4.9.0运行此镜像存在已知问题，可从此[链接](https://desktop.docker.com/mac/main/amd64/81317/Docker.dmg?_gl=17jelfd_gcl_auOTk5Nzk0MDUwLjE3MTE4ODMyNzM._gaNDQyMjE1MDE5LjE3MTE4ODMyNzQ._ga_XJWPQMJYHQ*MTcxOTIxOTEwMy4xMS4xLjE3MTkyMjEwMTAuNjAuMC4w)下载所需Docker版本。
- 此镜像仅用于测试目的，请勿在生产环境中使用。

## 前提条件

部署`seekdb`前，请确保满足以下要求：
- 主机至少拥有1个物理核心和2GB内存。
- 主机已安装并运行Docker。参考[Docker安装指南](https://docs.docker.com/get-docker/)。

## 启动SeekDB实例

启动SeekDB实例，请使用以下命令：

```bash
docker run -d -p 2881:2881 -p 2886:2886 oceanbase/seekdb

# 如需在启动后执行初始化SQL脚本，需挂载包含初始化脚本的目录，并通过环境变量INIT_SCRIPTS_PATH指定容器内的目录。
# 请勿在SQL脚本中修改root用户密码。如需修改root用户密码，请使用环境变量ROOT_PASSWORD。
docker run -d -p 2881:2881 -p 2886:2886 -v {init_sql_folder_path}:/root/boot/init.d -e INIT_SCRIPTS_PATH=/root/boot/init.d oceanbase/seekdb
```

## 支持的环境变量

以下是镜像支持的环境变量表格：

| 变量名               | 描述                                                                                                                                                                                                                                                         |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ROOT_PASSWORD        | root用户的密码                                                                                                                                                                                                                                               |
| CPU_COUNT            | CPU数量，例如：4                                                                                                                                                                                                                                             |
| MEMORY_LIMIT         | 内存限制，例如：2G                                                                                                                                                                                                                                           |
| LOG_DISK_SIZE        | 日志磁盘大小，例如：2G                                                                                                                                                                                                                                       |
| DATAFILE_SIZE        | 数据文件初始大小，例如：2G                                                                                                                                                                                                                                   |
| DATAFILE_NEXT        | 数据文件下次扩展大小，例如：2G                                                                                                                                                                                                                               |
| DATAFILE_MAXSIZE     | 数据文件最大大小，例如：50G                                                                                                                                                                                                                                  |
| INIT_SCRIPTS_PATH    | 容器内包含初始化脚本的路径                                                                                                                                                                                                                                   |
| SEEKDB_DATABASE      | 启动时创建的数据库名称                                                                                                                                                                                                                                       |

如需修改其他SeekDB参数，可将配置文件挂载到容器内的`/etc/oceanbase/seekdb.cnf`路径。默认配置文件如下：

```
datafile_size=2G
datafile_next=2G
datafile_maxsize=50G
cpu_count=4
memory_limit=2G
log_disk_size=2G
# 按以下格式配置参数
# key=value
```

启动命令示例如下：
```
# 注意：如果决定使用配置文件，请不要指定与资源相关的环境变量。
docker run -d -p 2881:2881 -p 2886:2886 -v {config_file}:/etc/oceanbase/seekdb.cnf oceanbase/seekdb
```

## 数据持久化

SeekDB部署在`/var/lib/oceanbase`目录。如需在主机上持久化数据，请将主机的空目录挂载到该路径：

```
mkdir -p seekdb
docker run -d -p 2881:2881 -p 2886:2886 -v $PWD/seekdb:/var/lib/oceanbase --name seekdb oceanbase/seekdb
```

## 连接SeekDB实例

```
mysql -h 127.0.0.1 -P 2881 -u root -p    # 使用root账户连接
```

## 访问控制台

容器提供友好的Web界面，可在浏览器中访问`http://${server_ip}:2886`。登录密码与root用户密码相同。若未设置ROOT_PASSWORD，密码字段留空即可。
