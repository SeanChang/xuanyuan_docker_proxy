<!-- xuanyuan-docker-images-zh
image: enmotech/opengauss
source: https://xuanyuan.cloud/zh/r/enmotech/opengauss
canonical: https://xuanyuan.cloud/zh/r/enmotech/opengauss
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [enmotech/opengauss — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/enmotech/opengauss "enmotech/opengauss Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/enmotech/opengauss

# openGauss Docker镜像使用指南


## 快速参考

- **维护者**：[EnmoTech开源团队]([])  
- **获取帮助**：[墨天轮-openGauss]([])  


> **注意**：若在macOS或Windows系统上运行openGauss 5.0及以上版本的容器，需使用 [`enmotech/opengauss-lite`]([]) 镜像。因5.0版本起，openGauss企业版容器在macOS/Windows上无法正常启动，Linux系统无此问题。


## 支持的标签及Dockerfile链接

- [`latest`]([])  
- [`6.0.0`]([])  
- [`5.1.0`]([])  
- [`5.0.3`]([])  
- [`5.0.2`]([])  
- [`5.0.1`]([])  
- [`5.0.0`]([])  
- [`3.1.1`]([])  
- [`3.1.0`]([])  
- [`3.0.3`]([])  
- [`3.0.0`]([])  
- [`2.1.0`]([])  
- [`2.0.1`]([])  
- [`2.0.0`]([])  
- [`1.1.0`]([])  
- [`1.0.1`]([])  
- [`1.0.0`]([])  


## 关于openGauss

openGauss是一款开源关系型数据库管理系统，基于Mulan PSL v2许可证发布。其内核源自PostgreSQL，深度融合华为在数据库领域的经验，持续构建面向企业需求的竞争力特性。openGauss也是开源免费的数据库平台，鼓励社区贡献与协作。  

openGauss社区官网：[[]]([])  


## Enmotech openGauss镜像的特点

- **版本更新及时**：Enmotech紧密跟踪openGauss源码变更，第一时间发布新版本镜像。  
- **配置一致性**：云数据库、虚拟机数据库与容器版数据库采用相同的最佳实践初始化配置，多场景下体验一致。  
- **多架构与系统支持**：持续发布适用于不同CPU架构（x86/ARM）和操作系统的镜像。  

  > **当前支持**：x86-64与ARM64架构，拉取镜像时会根据机器架构自动匹配。  


### 版本特性说明

- **5.0及以上版本**：  
  企业版与精简版分离。`enmotech/opengauss` 为企业版，`enmotech/opengauss-lite` 为精简版。  

- **3.0及以上版本**：  
  容器使用 [openGauss数据库精简版]([])；默认启动时空闲内存低于200M；新增vi、ps等基础命令。  

- **2.0及以上版本**：  
  - x86-64架构：运行于 [Ubuntu 18.04操作系统]([])  
  - ARM64架构：运行于 [Debian 10操作系统]([])  

- **1.1.0及以下版本**：  
  - x86-64架构：运行于 [CentOS 7.6操作系统]([])  
  - ARM64架构：运行于 [openEuler 20.03 LTS操作系统]([])  


## 如何使用该镜像

### 启动openGauss实例

使用以下命令启动一个openGauss容器实例：  

```console
$ docker run --name opengauss --privileged=true -d -e GS_PASSWORD=Enmo@123 enmotech/opengauss:latest
```


### 环境变量

可通过环境变量自定义容器配置，当前支持以下参数：  

#### `GS_PASSWORD`（必填）  
设置openGauss数据库超级用户`omm`和测试用户`gaussdb`的密码。`omm`为安装时默认创建的超级用户，用户名不可修改；`gaussdb`为自定义测试用户。  

> **密码复杂度要求**：至少8位，需包含大小写字母、数字及特殊字符。  

容器内采用本地信任机制，无需密码即可连接；外部连接（其他主机或容器）需验证密码。  

#### `GS_NODENAME`  
指定数据库节点名称，默认值：`gaussdb`。  

#### `GS_USERNAME`  
指定数据库连接用户名，默认值：`gaussdb`。  

#### `GS_PORT`  
指定数据库端口，默认值：5432。  


### 从容器外部连接数据库

默认容器内openGauss监听5432端口。如需外部访问，启动容器时需通过`-p`参数映射端口。例如，将容器5432端口映射到主机15432端口：  

```console
$ docker run --name opengauss --privileged=true -d -e GS_PASSWORD=Secretpassword@123 -p 15432:5432 enmotech/opengauss:latest
```

启动成功后，可通过`gsql`工具从外部连接：  

```console
$ gsql -d postgres -U gaussdb -W'Secretpassword@123' -h 你的主机IP -p15432
```


### 持久化存储数据

容器删除后，内部数据和配置会丢失。为避免数据丢失，可通过`-v`参数将数据目录挂载到主机。例如，将openGauss数据文件存储到主机`/enmotech/opengauss`目录：  

```console
# 先在主机创建目录
$ mkdir -p /enmotech/opengauss

# 启动容器并挂载目录（-u root确保有目录创建权限）
$ docker run --name opengauss --privileged=true -d -e GS_PASSWORD=Secretpassword@123 \
    -v /enmotech/opengauss:/var/lib/opengauss  -u root -p 15432:5432 \
    enmotech/opengauss:latest
```

> **注意**：使用podman时，需提前创建主机目标目录，否则会触发路径检查错误。  


### 创建主从复制openGauss容器

通过脚本`create_master_slave.sh`可快速创建一主一从架构的容器集群，步骤如下：  

#### 1. 拉取镜像  
```console
$ docker pull enmotech/opengauss:latest
```

#### 2. 获取并运行主从创建脚本  
```console
# 下载脚本
$ wget [] 添加执行权限
$ chmod +x create_master_slave.sh 

# 运行脚本（按提示输入参数，或直接使用默认值）
$ ./create_master_slave.sh 
```

脚本支持的参数及默认值：  

| 参数                | 说明                  | 默认值                  |  
|---------------------|-----------------------|-------------------------|  
| `OG_SUBNET`         | 容器子网              | 172.11.0.0/24           |  
| `GS_PASSWORD`       | 数据库密码            | Enmo@123                |  
| `MASTER_IP`         | 主库IP                | 172.11.0.101            |  
| `SLAVE_1_IP`        | 从库IP                | 172.11.0.102            |  
| `MASTER_HOST_PORT`  | 主库服务端口          | 5432                    |  
| `MASTER_LOCAL_PORT` | 主库通信端口          | 5434                    |  
| `SLAVE_1_HOST_PORT` | 从库服务端口          | 6432                    |  
| `SLAVE_1_LOCAL_PORT`| 从库通信端口          | 6434                    |  
| `MASTER_NODENAME`   | 主节点名称            | opengauss_master        |  
| `SLAVE_NODENAME`    | 从节点名称            | opengauss_slave1        |  


#### 3. 验证主从状态  

进入主库容器，切换至`omm`用户，执行状态查询命令：  

```console
$ docker exec -it opengauss_master /bin/bash
$ su - omm
$ gs_ctl query -D /var/lib/opengauss/data/
```

若输出中包含`local_role: Primary`和`sender_state: Streaming`，说明主从复制正常。  


## 许可证

本镜像遵循GPL v3.0许可证，详情参见：[[]]([])  


## 关于EnmoTech

EnmoTech（北京安恒信科技）成立于2011年，是智能数据技术提供商，总部位于北京，全球35个地区设有分支机构（含香港、新加坡、悉尼等）。专注于数据与数据库解决方案创新，提供HTAP数据库、软件定义分布式存储、数据库部署与性能管理、智能数据分析等服务。已服务超3000家企业客户，管理超50000个业务系统。  

了解更多：[www.enmotech.com]([])，或联系：[邮箱已删除]
