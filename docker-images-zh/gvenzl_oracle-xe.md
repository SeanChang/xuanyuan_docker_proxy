---
image: gvenzl/oracle-xe
description: "Oracle数据库XE版（包括21c、18c、11g版本）面向所有用户开放使用！若需了解Oracle数据库23c免费版的相关信息，可通过gvenzl/oracle-free获取详细内容，该资源提供了23c免费版的功能介绍及使用指南。"
source: https://xuanyuan.cloud/zh/r/gvenzl/oracle-xe
canonical: https://xuanyuan.cloud/zh/r/gvenzl/oracle-xe
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gvenzl/oracle-xe" title="gvenzl/oracle-xe Docker 镜像中文简介、标签列表与拉取命令">gvenzl/oracle-xe — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/gvenzl/oracle-xe" title="gvenzl/oracle-xe Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/gvenzl/oracle-xe</a>

# oci-oracle-xe：Oracle Database Express Edition 容器镜像  

Oracle Database Express Edition（XE）的容器/ Docker 镜像，兼容 `podman` 和 `docker`，可互换使用。


## 支持的标签及对应 Dockerfile 链接  

各版本标签按 Oracle 数据库版本（21c、18c、11g）分类，包含不同镜像变体（基础版、slim 版、full 版及 faststart 版）：  

- **21c**  
  - 基础版：`latest`, `21`, `21.3.0`（[Dockerfile]([])）  
  - faststart 版：`latest-faststart`, `21-faststart`, `21.3.0-faststart`（[Dockerfile]([])）  
  - slim 版：`slim`, `21-slim`, `21.3.0-slim`（[Dockerfile]([])）  
  - slim-faststart 版：`slim-faststart`, `21-slim-faststart`, `21.3.0-slim-faststart`（[Dockerfile]([])）  
  - full 版：`full`, `21-full`, `21.3.0-full`（[Dockerfile]([])）  
  - full-faststart 版：`full-faststart`, `21-full-faststart`, `21.3.0-full-faststart`（[Dockerfile]([])）  

- **18c**  
  - 基础版：`18`, `18.4.0`（[Dockerfile]([])）  
  - faststart 版：`18-faststart`, `18.4.0-faststart`（[Dockerfile]([])）  
  - slim 版：`18-slim`, `18.4.0-slim`（[Dockerfile]([])）  
  - slim-faststart 版：`18-slim-faststart`, `18.4.0-slim-faststart`（[Dockerfile]([])）  
  - full 版：`18-full`, `18.4.0-full`（[Dockerfile]([])）  
  - full-faststart 版：`18-full-faststart`, `18.4.0-full-faststart`（[Dockerfile]([])）  

- **11g R2**  
  - 基础版：`11`, `11.2.0.2`（[Dockerfile]([])）  
  - faststart 版：`11-faststart`, `11.2.0.2-faststart`（[Dockerfile]([])）  
  - slim 版：`11-slim`, `11.2.0.2-slim`（[Dockerfile]([])）  
  - slim-faststart 版：`11-slim-faststart`, `11.2.0.2-slim-faststart`（[Dockerfile]([])）  
  - full 版：`11-full`, `11.2.0.2-full`（[Dockerfile]([])）  
  - full-faststart 版：`11-full-faststart`, `11.2.0.2-full-faststart`（[Dockerfile]([])）  


## 快速启动  

### 非持久化数据库容器  
数据在容器删除后丢失，但容器重启时保留：  
```shell
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<你的密码> 
```

### 持久化数据库容器  
数据在容器生命周期内永久保留（需挂载卷）：  
```shell
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<你的密码> -v oracle-volume:/opt/oracle/oradata 
```

### 11g R2 持久化容器  
11g R2 数据路径不同，卷挂载位置需调整：  
```shell
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<你的密码> -v oracle-volume:/u01/app/oracle/oradata :11
```

### 重置 SYS/SYSTEM 密码  
```shell
docker exec <容器名或ID> resetPassword <新密码>
```


### Apple M 芯片适配  
Oracle 数据库暂无 ARM 架构版本，无法直接通过 Docker Desktop 在 Apple M 芯片上运行。可通过 `colima` 模拟 x86_64 环境：  
1. 安装 [colima]([])  
2. 启动 colima：`colima start --arch x86_64 --memory 4`（分配 4GB 内存）  
3. 按常规方式启动容器  


## 使用该镜像的用户  

以下是部分使用该镜像的组织/项目（*标注已迁移至 `gvenzl/oracle-free`*）：  

- [Airbyte]([])  
- [Apache Spark]([])  
- *[Benthos]([])*  
- [Ebean]([])  
- [Eclipse Vert.x]([])  
- [Flowable]([])  
- [GeoTools]([])  
- [Hibernate]([])  
- *[Hibernate Reactive]([])*  
- [Hibernate Search]([])  
- *[jOOQ]([])*  
- [Liquibase]([])  
- [Micronaut Data]([])  
- *[Quarkus]([])*  
- [Ruby API for Oracle PL/SQL]([])  
- *[Ruby on Rails ActiveRecord adapter]([])*  
- [Rucio by CERN]([])  
- [SchemaCrawler]([])  
- *[Spring Data JDBC]([])*  
- [Sqitch]([])  
- [Testcontainers]([])  
- [Upscheme]([])  
- [utPLSQL]([])  


## 镜像使用说明  

### 版本间的细微差异  
- **11g R2（11.2.0.2）**：数据文件路径为 `/u01/app/oracle/oradata/XE`，卷必须挂载至 `/u01/app/oracle/oradata`。  


### 环境变量  
环境变量仅在数据库首次初始化（容器首次启动）时生效，用于自定义配置。  

| 变量名                | 说明                                                                                     | 必要性       |  
|-----------------------|------------------------------------------------------------------------------------------|--------------|  
| `ORACLE_PASSWORD`     | 指定 `SYS` 和 `SYSTEM` 用户的初始密码                                                   | 必选（首次启动） |  
| `ORACLE_RANDOM_PASSWORD` | 设为非空值（如 `yes`），自动生成随机密码（输出至日志：`ORACLE PASSWORD FOR SYS AND SYSTEM: ...`） | 可选         |  
| `ORACLE_DATABASE`     | 18c+ 支持，创建指定名称的可插拔数据库（如未指定，默认使用 `XEPDB1`）                     | 可选（18c+） |  
| `APP_USER`            | 创建应用用户（18c+ 默认在 `XEPDB1` 中；若指定 `ORACLE_DATABASE`，则同时在该库中创建）    | 可选（需配合密码变量） |  
| `APP_USER_PASSWORD`   | 为 `APP_USER` 指定密码                                                                   | 可选（需配合 `APP_USER`） |  


### GitHub Actions 集成  
可作为 [Service Container]([]) 在 GitHub Actions 工作流中使用。示例配置：  

```yaml
services:
  oracle:  # 服务标签（用于容器间访问）
    image: :latest  # 镜像及标签
    env:  # 环境变量配置
      ORACLE_RANDOM_PASSWORD: true  # 随机生成密码
      APP_USER: my_user  # 创建应用用户
      APP_USER_PASSWORD: my_password  # 应用用户密码
    ports:
      - 1521:1521  # 端口映射
    options: >-  # 健康检查配置
      --health-cmd healthcheck.sh
      --health-interval 10s
      --health-timeout 5s
      --health-retries 10
```

**连接参数**：  
- 主机名：`oracle`（容器内）/ `localhost`（宿主机）  
- 端口：`1521`  
- 服务名：`XEPDB1`（默认可插拔数据库）  
- 管理员用户：`system`，密码通过 `ORACLE_PASSWORD` 或日志获取  
- 应用用户：`my_user`，密码 `my_password`  
- JDBC 连接串示例：`jdbc:oracle:thin:@localhost:${{ job.services.oracle.ports[1521] }}/XEPDB1`（动态端口）  


### 镜像变体  

| 变体名称       | 标签后缀       | 说明                                                                 | 适用场景                                     |  
|----------------|----------------|----------------------------------------------------------------------|----------------------------------------------|  
| Slim           | `-slim`        | 最小化镜像，仅保留核心功能，牺牲部分扩展能力                           | 对镜像体积敏感，无需高级功能的场景           |  
| 基础版         | 无             | 平衡体积与功能，推荐大多数场景使用                                   | 常规开发、测试                               |  
| Full           | `-full`        | 完整功能镜像，包含 Oracle 数据库全部默认组件                           | 需要扩展或自定义配置的场景                   |  
| Faststart      | `*-faststart`  | 预初始化数据库，镜像体积较大但启动速度极快                             | 自动化测试（需频繁启停容器，无需持久化数据） |  


### 数据库用户管理  

通过 `createAppUser` 命令可创建额外应用用户，语法：  
```shell
docker exec <容器名或ID> createAppUser <用户名> <密码> [<目标PDB>]  # 目标PDB默认XEPDB1，11g忽略
```

**示例**：在 `XEPDB1` 中创建用户 `app_user`，密码 `app_pwd`  
```shell
docker exec my-oracle createAppUser app_user app_pwd XEPDB1
```


### 容器密钥  

敏感信息（如密码）可通过文件传递，在环境变量名后添加 `_FILE` 后缀，从容器内文件读取值。支持的变量：`APP_USER_PASSWORD_FILE`、`ORACLE_PASSWORD_FILE`、`ORACLE_DATABASE_FILE`。  

**示例**：从文件 `/run/secrets/oracle-passwd` 读取密码  
```shell
docker run --name some-oracle -e ORACLE_PASSWORD_FILE=/run/secrets/oracle-passwd -d 
```


### 初始化脚本  

首次启动数据库时，容器会自动执行 `/container-entrypoint-initdb.d` 目录下的脚本（支持 `*.sql`, `*.sql.gz`, `*.sql.zip`, `*.sh`），按字母顺序递归执行（子目录亦会遍历）。  

- **SQL 脚本**：通过 SQL\*Plus 以 `SYS` 用户执行（连接至 `XE` 实例），需在脚本中手动切换至目标用户/数据库。  
- **Shell 脚本**：可执行脚本（带 `x` 权限）在新进程中运行；非可执行脚本会被 source 到当前进程（可能影响环境，建议设为可执行）。  

**示例**：创建用户并初始化数据模型  
1. 本地脚本目录结构：  
   ```
   init_scripts/
   ├── 1_create_user.sql   # 创建用户
   └── 2_init_data.sh      # 下载并执行数据脚本
   ```  
2. `1_create_user.sql` 内容：  
   ```sql
   ALTER SESSION SET CONTAINER=XEPDB1;  # 切换至可插拔数据库
   CREATE USER test IDENTIFIED BY test QUOTA UNLIMITED ON USERS;
   GRANT CONNECT, RESOURCE TO test;
   ```  
3. `2_init_data.sh` 内容（可执行）：  
   ```bash
   curl -LJO []   sqlplus -s test/test@//localhost/XEPDB1 @install.sql  # 以 test 用户执行脚本
   rm install.sql
   ```  
4. 启动容器并挂载脚本目录：  
   ```shell
   docker run -d -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=y -v ./init_scripts:/container-entrypoint-initdb.d :18.4.0-full
   ```  


### 启动脚本  

每次数据库启动后（含容器重启），容器会执行 `/container-entrypoint-startdb.d` 目录下的脚本（支持类型同初始化脚本）。适用于需每次启动后执行的任务（如数据同步、配置检查）。  

> **注意**：避免同时使用 `/docker-entrypoint-startdb.d`（兼容旧版本路径），以免脚本重复执行。  


## 反馈  

如有问题或建议，可通过 [GitHub Issues]([]) 提交。
