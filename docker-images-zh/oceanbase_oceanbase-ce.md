<!-- xuanyuan-docker-images-zh
image: oceanbase/oceanbase-ce
source: https://xuanyuan.cloud/zh/r/oceanbase/oceanbase-ce
canonical: https://xuanyuan.cloud/zh/r/oceanbase/oceanbase-ce
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [oceanbase/oceanbase-ce — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/oceanbase/oceanbase-ce "oceanbase/oceanbase-ce Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/oceanbase/oceanbase-ce

# 使用 Docker 部署 OceanBase


## 简介

`oceanbase-ce` Docker 镜像可在 [dockerhub]([])、[quay.io]([]) 和 [ghcr.io]([]) 获取，用于帮助用户快速搭建 OceanBase 测试环境。


### 核心注意事项
- 该镜像仅用于测试，**禁止在生产环境使用**。
- 仅支持部署单实例集群。
- 不支持 Kubernetes 环境。若需在 Kubernetes 上运行容器化 OceanBase，可参考 [ob-operator]([]) 仓库。


## 前置条件

部署 `oceanbase-ce` 前，请确保满足以下要求：
- 主机需至少拥有 2 物理核心和 8GB 内存。
- 主机已安装并运行 Docker。Docker 安装可参考 [官方指南]([])。


## 启动 OceanBase 实例

使用以下 `docker run` 命令之一启动 OceanBase 实例：

```bash
# 部署 mini 模式实例（资源占用最少）
docker run -p 2881:2881 --name oceanbase-ce -d oceanbase/oceanbase-ce

# 部署 normal 模式实例（使用容器全部资源）
docker run -p 2881:2881 --name oceanbase-ce -e MODE=normal -d oceanbase/oceanbase-ce

# 部署 slim 模式实例（快速启动，仅启动 observer）
docker run -p 2881:2881 --name oceanbase-ce -e MODE=slim -d oceanbase/oceanbase-ce

# 启动时执行初始化 SQL 脚本（注意：不要在脚本中修改 root 密码，若需修改密码请使用 OB_TENANT_PASSWORD 变量）
docker run -p 2881:2881 --name oceanbase-ce -v {本地SQL脚本目录路径}:/root/boot/init.d -d oceanbase/oceanbase-ce
```

初始化过程可能需要 5 分钟，可通过以下命令验证是否完成：

```bash
docker logs oceanbase-ce | tail -1
```

成功时输出：
```
boot success!
```


## 连接 OceanBase 实例
> **注意**：
> - 脚本创建的用户默认密码为空。
> - 默认普通租户为 `test`，因此需使用 `root@test` 作为用户名。

通过 obclient 或 mysql 客户端本地连接：
```bash
mysql -h127.0.0.1 -P2881 -uroot       # 连接 sys 租户的 root 用户
mysql -h127.0.0.1 -P2881 -uroot@test  # 连接普通租户 test 的 root 用户
```


## 支持的环境变量

| 变量名                  | 默认值               | 说明                                                                                                                                                                                                                                                         |
|-------------------------|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MODE                    | mini                 | 资源模式：<br>mini = 最少资源占用<br>normal = 最大化使用容器资源<br>slim = 快速启动模式（仅启动 observer，租户名为 test，租户及资源配置不生效）                                                                                                                                    |
| EXIT_WHILE_ERROR        | true                 | 启动失败时是否退出容器。若设为 false，容器不会退出，可进入容器调试。                                                                                                                                                                                                       |
| OB_CLUSTER_NAME         | obcluster            | 集群名称                                                                                                                                                                                                                                                     |
| OB_TENANT_NAME          | test                 | MySQL 租户名称                                                                                                                                                                                                                                                |
| OB_MEMORY_LIMIT         | 6G                   | 集群 memory_limit 配置                                                                                                                                                                                                                                       |
| OB_DATAFILE_SIZE        | 5G                   | 集群 datafile_size 配置                                                                                                                                                                                                                                      |
| OB_LOG_DISK_SIZE        | 5G                   | 集群 log_disk_size 配置                                                                                                                                                                                                                                      |
| OB_SYS_PASSWORD         |                      | sys 租户 root 用户密码                                                                                                                                                                                                                                       |
| OB_TENANT_PASSWORD      |                      | MySQL 租户 root 用户密码                                                                                                                                                                                                                                     |
| OB_SYSTEM_MEMORY        | 1G                   | 集群 system_memory 配置                                                                                                                                                                                                                                      |
| OB_TENANT_MINI_CPU      |                      | 租户 mini_cpu 配置                                                                                                                                                                                                                                           |
| OB_TENANT_MEMORY_SIZE   |                      | 租户 memory_size 配置                                                                                                                                                                                                                                        |
| OB_TENANT_LOG_DISK_SIZE |                      | 租户 log_disk_size 配置                                                                                                                                                                                                                                      |


## 运行 Sysbench 测试

镜像内置 Sysbench 工具用于性能测试，执行以下命令启动测试：
```bash
docker exec -it oceanbase-ce obd test sysbench obcluster
```


## 数据持久化

默认情况下，OceanBase 数据存储在容器内的 `/root/ob`，配置文件存储在 `/root/.obd/cluster`。通过以下命令将数据持久化到主机：

```bash
mkdir -p ob
mkdir -p obd/cluster
docker run -d -p 2881:2881 -v $PWD/ob:/root/ob -v $PWD/obd/cluster:/root/.obd/cluster --name oceanbase oceanbase/oceanbase-ce
```


## 故障诊断

Docker 启动时默认开启 `enable_rich_error_msg` 参数。若启动失败，可通过 trace 命令获取详细错误信息。
