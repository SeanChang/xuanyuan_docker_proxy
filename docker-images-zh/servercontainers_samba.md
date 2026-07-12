---
image: servercontainers/samba
description: "基于Alpine的Samba文件共享服务镜像，支持可选的zeroconf、wsdd2及Time Machine备份功能，适用于x86和arm架构。"
source: https://xuanyuan.cloud/zh/r/servercontainers/samba
canonical: https://xuanyuan.cloud/zh/r/servercontainers/samba
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/servercontainers/samba" title="servercontainers/samba Docker 镜像中文简介、标签列表与拉取命令">servercontainers/samba 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# samba - (ghcr.io/servercontainers/samba) [x86 + arm]


## 重要提示

**新仓库地址**: `ghcr.io/servercontainers/samba`  

2023年3月，Docker通知将移除`servercontainers`和`desktopcontainers`组织，除非升级到专业计划。为避免恶意用户接管原组织名称并发布可能带有后门的容器，建议切换至新的GitHub仓库地址：`ghcr.io/servercontainers`。


## 镜像概述与主要用途

基于Alpine Linux的Samba服务器容器，支持TimeMachine备份、zeroconf（Avahi）网络发现和WSD（Web Services for Devices，wsdd2）服务，适用于x86和ARM架构。主要用于搭建轻量级跨平台文件共享服务，支持Windows、macOS和Linux客户端，尤其适合家庭或小型办公环境。


## 核心功能与特性

- **轻量级基础**：基于Alpine Linux，体积小、资源占用低  
- **完整Samba支持**：包含smbd服务，实现标准文件共享功能  
- **可选网络发现**：集成Avahi（zeroconf）用于macOS发现，wsdd2（WSD）用于Windows网络发现  
- **TimeMachine支持**：原生支持macOS TimeMachine备份，含多用户隔离功能  
- **多架构兼容**：支持x86_64、arm64和arm架构  
- **灵活用户管理**：通过环境变量创建用户/组，支持明文密码或Samba哈希  
- **可定制配置**：通过环境变量灵活配置全局Samba参数和共享卷  
- **多变体选择**：提供含/不含Avahi/wsdd2的变体镜像，满足不同场景需求  


## 使用场景与适用范围

- 家庭或小型办公环境的跨平台文件共享服务器  
- macOS用户的TimeMachine网络备份存储  
- 需要zeroconf（Avahi）或WSD（wsdd2）服务发现的场景  
- 资源受限环境（如嵌入式设备、NAS）的轻量级文件服务  
- 需快速部署、支持多架构的临时共享服务  


## 使用方法

### 部署示例

#### docker run 快速启动

```bash
docker run -d \
  --name samba \
  --net=host \
  -v /path/to/shares:/shares \
  -e ACCOUNT_user1=password123 \
  -e SAMBA_VOLUME_CONFIG_myshare="path = /shares/myshare; valid users = user1; read only = no" \
  -e MODEL=TimeCapsule \
  --cap-add=CAP_NET_ADMIN \
  ***-ghcr.xuanyuan.run/servercontainers/samba:latest
```

#### docker-compose 配置示例

```yaml
version: '3'
services:
  samba:
    image: ***-ghcr.xuanyuan.run/servercontainers/samba:latest
    container_name: samba
    network_mode: host  # 如需Avahi/wsdd2发现，建议使用host网络
    volumes:
      - /path/to/shares:/shares  # 共享文件存储路径
    environment:
      # 用户配置（用户名:密码/哈希）
      - ACCOUNT_user1=password123
      - ACCOUNT_admin=:0:1001:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:8846F7EAEE8FB117AD06BDD830B7586C:[U          ]:LCT-5FE1F7DF:  # 哈希示例
      # 用户UID指定
      - UID_user1=1000
      # 组配置
      - GROUP_devops=1500
      # 用户附加组
      - GROUPS_admin=devops
      # 全局配置
      - SAMBA_GLOBAL_CONFIG_workgroup=MYGROUP
      - SAMBA_GLOBAL_CONFIG_server_string=My Samba Server
      - SAMBA_GLOBAL_STANZA=log level = 2; max log size = 50  # 多行全局配置，用;分隔
      # 共享卷配置（TimeMachine示例）
      - SAMBA_VOLUME_CONFIG_timemachine="path = /shares/timemachine/%U; valid users = %U; fruit:time machine = yes; fruit:time machine max size = 500G"
      # Avahi配置
      - MODEL=MacPro7,1
      - AVAHI_NAME=MySambaServer
    cap_add:
      - CAP_NET_ADMIN  # wsdd2需要此权限
    restart: unless-stopped
```


## 配置参数详解

### 环境变量

#### Samba 全局配置

| 变量名                          | 说明                                                                 | 可选性 | 默认值               | 示例值                                                                 |
|---------------------------------|----------------------------------------------------------------------|--------|----------------------|------------------------------------------------------------------------|
| SAMBA_GLOBAL_STANZA             | 多行全局配置，用`;`分隔（自动转为`\n`）                              | 可选   | 未设置               | `log level = 2; max log size = 50`                                     |
| SAMBA_GLOBAL_CONFIG_<唯一标识>  | 单个全局配置项，键含空格用`_SPACE_`替换，含冒号用`_COLON_`替换        | 可选   | 未设置               | `SAMBA_GLOBAL_CONFIG_mykey=workgroup = MYGROUP`                        |
| SAMBA_CONF_SERVER_ROLE          | Samba服务器角色                                                      | 可选   | standalone server    | member server                                                          |
| SAMBA_CONF_LOG_LEVEL            | 日志级别                                                            | 可选   | 1                    | 3                                                                      |
| SAMBA_CONF_WORKGROUP            | 工作组名称                                                          | 可选   | WORKGROUP            | MYGROUP                                                                |
| SAMBA_CONF_SERVER_STRING        | 服务器描述信息                                                      | 可选   | Samba Server         | "Office File Server"                                                   |
| SAMBA_CONF_MAP_TO_GUEST         | 匿名用户映射策略                                                    | 可选   | Bad User             | Never                                                                  |

#### 用户与组管理

| 变量名                | 说明                                                                 | 可选性 | 默认值   | 示例值                                  |
|-----------------------|----------------------------------------------------------------------|--------|----------|-----------------------------------------|
| ACCOUNT_<用户名>       | 创建用户，值为明文密码（不可以`:<用户名>:[0-9]*:`开头）或Samba哈希    | 必选   | 未设置   | ACCOUNT_user1=password123               |
| UID_<用户名>           | 指定用户UID，需与ACCOUNT_<用户名>对应                                | 可选   | 自动分配 | UID_user1=1000                          |
| GROUP_<组名>          | 创建组，值为GID                                                      | 可选   | 未设置   | GROUP_devops=1500                       |
| GROUPS_<用户名>       | 为用户添加附加组，用`,`分隔，需与GROUP_<组名>对应                     | 可选   | 未设置   | GROUPS_user1=devops,users               |

#### Avahi 配置

| 变量名           | 说明                          | 可选性 | 默认值       | 示例值           |
|------------------|-------------------------------|--------|--------------|------------------|
| MODEL            | Avahi服务设备型号             | 可选   | TimeCapsule  | MacPro7,1        |
| AVAHI_NAME       | Avahi服务名称                 | 可选   | 容器 hostname| MySambaServer    |
| AVAHI_DISABLE    | 禁用Avahi服务（设任意值即禁用）| 可选   | 未设置       | 1                |

#### wsdd2 配置

| 变量名              | 说明                          | 可选性 | 默认值   | 示例值           |
|---------------------|-------------------------------|--------|----------|------------------|
| WSDD2_DISABLE       | 禁用wsdd2服务（设任意值即禁用）| 可选   | 未设置   | 1                |
| WSDD2_PARAMETERS    | wsdd2启动参数                 | 可选   | 未设置   | -l               |

#### 共享卷配置

| 变量名                          | 说明                                                                 | 可选性 | 默认值   | 示例值                                                                 |
|---------------------------------|----------------------------------------------------------------------|--------|----------|------------------------------------------------------------------------|
| SAMBA_VOLUME_CONFIG_<唯一标识>  | 共享卷配置，多行用`;`分隔；路径以`%U`结尾时启用多用户隔离（如TimeMachine） | 可选   | 未设置   | `path = /shares/timemachine/%U; fruit:time machine = yes; valid users = %U` |


### 卷挂载

| 挂载路径          | 说明                                  | 必要性 |
|-------------------|---------------------------------------|--------|
| /shares           | 共享文件存储目录，需提前创建并授权    | 建议   |
| /external/avahi   | 外部Avahi服务目录（覆盖容器内置配置） | 可选   |


## 镜像变体

| 镜像标签格式                          | 说明                                                                 |
|---------------------------------------|----------------------------------------------------------------------|
| latest<br>a<alpine版本>-s<samba版本>   | 完整版本：含smbd、Avahi、wsdd2，可通过环境变量禁用可选服务（如AVAHI_DISABLE） |
| smbd-only-latest<br>smbd-only-a<...>-s<...> | 仅含smbd和基础脚本，无Avahi/wsdd2                                 |
| smbd-avahi-latest<br>smbd-avahi-a<...>-s<...> | 含smbd、Avahi和脚本，无wsdd2                                      |
| smbd-wsdd2-latest<br>smbd-wsdd2-a<...>-s<...> | 含smbd、wsdd2和脚本，无Avahi                                      |

标签中`a<alpine版本>-s<samba版本>`格式（如`a3.15.0-s4.15.2`）可用于固定版本，便于回滚或版本控制。


## 构建信息

### 构建脚本

- **构建多变体**：通过`build.sh`脚本构建x86_64/arm64/arm镜像，指定`DOCKER_REGISTRY`环境变量可自定义仓库  
- **生成latest标签**：执行`./build.sh release`生成`latest`标签  
- **自定义变体**：使用`generate-variants.sh`生成自定义变体配置并手动构建  

### 标签说明

所有镜像标签格式为`a<alpine版本>-s<samba版本>`，如`a3.15.0-s4.15.2`，便于追溯基础镜像和Samba版本。


## 高级信息

### TimeMachine与Avahi注意事项

- **多用户隔离**：共享路径以`%U`结尾（如`/shares/timemachine/%U`）时，每个用户将获得独立子目录  
- **Avahi网络模式**：Avahi需`--net=host`网络模式或正确端口映射（UDP 5353）以确保macOS发现  
- **容量限制**：通过`fruit:time machine max size = 500G`限制单用户TimeMachine容量  


### Windows 10网络发现配置

- **wsdd2权限**：wsdd2服务需`CAP_NET_ADMIN`权限（`--cap-add=CAP_NET_ADMIN`）  
- **主机名设置**：非`host`网络模式下，通过`hostname`参数指定容器主机名（避免随机生成的名称影响发现）  


## 变更日志

- **2023-03-20**：迁移至GitHub Actions构建，使用ghcr.io仓库  
- **2023-02-06**：修复用户名哈希时的大小写问题（统一转为小写）  
- **2022-05-31**：支持通过环境变量设置`server role`  
- **2021-12-30**：支持禁用wsdd2，日志输出到stdout，Avahi服务可选  
- **2021-12-25**：支持多用户共享卷，移除bash以减小体积  
- **2021-08-27**：添加wsdd2支持Windows网络发现  
- **2020-12-22**：支持Samba密码哈希（替代明文密码）  
- **2020-12-10**：添加TimeMachine多用户支持（路径需含`%U`）  
- **2020-11-05**：重构为Alpine基础，支持多架构构建  


## 参考链接

- Samba配置文档：[Configure Samba to Work Better with Mac OS X](https://wiki.samba.org/index.php/Configure_Samba_to_Work_Better_with_Mac_OS_X)  
- wsdd2项目：[Netgear/wsdd2](https://github.com/Netgear/wsdd2)  
- Avahi服务配置：[avahi.service(5)](https://linux.die.net/man/5/avahi.service)
