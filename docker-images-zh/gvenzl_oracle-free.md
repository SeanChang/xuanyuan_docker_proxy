---
image: gvenzl/oracle-free
description: "甲骨文数据库（Oracle Database）免费向所有人开放啦！作为全球领先的企业级关系型数据库管理系统，它凭借高性能、高可靠性与强大的安全性广泛应用于各类关键业务场景，此次免费版本旨在降低开发者、学习者及小型组织的使用门槛，让更多用户能够轻松体验其卓越的数据管理能力，助力创新与技术探索。"
source: https://xuanyuan.cloud/zh/r/gvenzl/oracle-free
canonical: https://xuanyuan.cloud/zh/r/gvenzl/oracle-free
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gvenzl/oracle-free" title="gvenzl/oracle-free Docker 镜像中文简介、标签列表与拉取命令">gvenzl/oracle-free — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/gvenzl/oracle-free" title="gvenzl/oracle-free Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/gvenzl/oracle-free</a>

# oci-oracle-free：Oracle Database Free 容器镜像


## 目录

- [支持的标签](#支持的标签)
- [快速开始](#快速开始)
- [使用这些镜像的项目](#使用这些镜像的项目)
- [如何使用这些镜像](#如何使用这些镜像)
  - [镜像类型](#镜像类型)
  - [环境变量](#环境变量)
  - [GitHub Actions 集成](#github-actions-集成)
  - [Docker Compose 配置](#docker-compose-配置)
  - [数据库用户管理](#数据库用户管理)
  - [可插拔数据库（PDB）](#可插拔数据库pdb)
  - [容器密钥管理](#容器密钥管理)
  - [初始化脚本](#初始化脚本)
  - [启动脚本](#启动脚本)
  - [配置脚本](#配置脚本)
- [反馈与建议](#反馈与建议)


## 支持的标签

| 标签格式                                                                       | 支持状态             |
| ------------------------------------------------------------------------------ | -------------------- |
| `latest[-faststart]`                                                           | 🔵 长期支持          |
| `slim[-faststart]`                                                             | 🔵 长期支持          |
| `full[-faststart]`                                                             | 🔵 长期支持          |
| `23[-faststart]`<br/>`23[-slim][-faststart]`<br/>`23[-full][-faststart]`       | 🟢 当前支持          |
| `23.9[-faststart]`<br/>`23.9[-slim][-faststart]`<br/>`23.9[-full][-faststart]` | 🟢 当前支持          |
| `23.8[-faststart]`<br/>`23.8[-slim][-faststart]`<br/>`23.8[-full][-faststart]` | 🟡 已过时            |
| `23.7[-faststart]` 及更早版本                                                  | 🔴 不再支持          |

### 标签说明
方括号 `[]` 中的内容表示可选标签，例如 `23[-slim][-faststart]` 包含以下具体标签：  
`23`、`23-slim`、`23-faststart`、`23-slim-faststart`。

### 支持状态含义
| 状态标识             | 说明                                                                 |
| -------------------- | -------------------------------------------------------------------- |
| 🔵 长期支持          | 镜像长期维护，持续提供 bug 修复和常规更新。                          |
| 🟢 当前支持          | 镜像处于活跃支持阶段，提供修复和更新。                                |
| 🟡 已过时            | 镜像已过时，仅修复严重 bug，**建议升级至新版本**。                   |
| 🔴 不再支持          | 镜像停止维护，无更新且可能随时移除，**强烈不建议使用**。              |


## 快速开始

### 启动非持久化数据库容器  
（容器删除后数据丢失，但重启容器数据保留）  
```shell
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<你的密码> gvenzl/oracle-free
```

### 启动持久化数据库容器  
（数据保存在卷中，不受容器生命周期影响）  
```shell
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<你的密码> -v oracle-volume:/opt/oracle/oradata gvenzl/oracle-free
```

### 重置 SYS/SYSTEM 用户密码  
```shell
docker exec <容器名或ID> resetPassword <新密码>
```

### Apple Mac M 芯片支持  
从 Oracle Database 23.5 Free 开始，提供 ARM 架构版本，镜像已支持多平台（multi-arch）。


## 使用这些镜像的项目

以下项目已采用该镜像：  
- [Benthos]([])（数据处理框架）  
- [Hibernate Reactive]([])（响应式 ORM）  
- [Ibis]([])（数据分析工具）  
- [JobRunr]([])（任务调度库）  
- [jOOQ]([])（SQL 构建工具）  
- [Quarkus]([])（云原生 Java 框架）  
- [Ruby on Rails ActiveRecord adapter]([])（Rails 数据库适配器）  
- [Spring Data]([])（Spring 数据访问框架）  
- [Micronaut]([])（微服务框架）  
- [utPLSQL]([])（PL/SQL 测试框架）  

若你的项目使用了该镜像，可通过 [GitHub Issue]([]) 申请添加到列表。


## 如何使用这些镜像

### 镜像类型

| 类型   | 标签后缀   | 说明                                                                 | 适用场景                                                     |
| ------ | ---------- | -------------------------------------------------------------------- | ------------------------------------------------------------ |
| Slim   | `-slim`    | 最小化镜像，仅保留核心功能，牺牲部分扩展能力换取更小体积。             | 对镜像大小敏感，且无需 Oracle 高级功能的场景。               |
| 标准   | 无         | 平衡体积与功能，推荐大多数场景使用。                                 | 常规开发、测试、小型生产环境。                               |
| Full   | `-full`    | 包含 Oracle 数据库完整功能，基于官方安装包构建。                     | 需要自定义扩展或深度定制数据库的场景。                       |
| Faststart | `*-faststart` | 内置预初始化数据库，启动速度更快，但镜像体积较大。                 | 自动化测试（频繁启停容器且无需持久化数据）。                   |

> 各类型镜像的具体修改内容可参考 [ImageDetails.md]([])。


### 环境变量

环境变量用于自定义容器初始化（仅首次启动时生效）：

#### `ORACLE_PASSWORD`（必填）  
设置 `SYS` 和 `SYSTEM` 用户的初始密码。

#### `ORACLE_RANDOM_PASSWORD`（可选）  
设为非空值（如 `yes`），自动生成 `SYS` 和 `SYSTEM` 的随机密码，密码会打印到日志（格式：`ORACLE PASSWORD FOR SYS AND SYSTEM: ...`）。

#### `ORACLE_DATABASE`（可选）  
指定要创建或插拔的 PDB 名称。若容器内 `/pdb-plug` 目录存在 `<名称>.pdb` 文件，则自动插拔该 PDB；否则创建新 PDB。支持逗号分隔多 PDB（如 `PDB1,PDB2`）。  
> **注意**：创建新 PDB 会增加首次启动时间，若无需自定义 PDB，可直接使用默认的 `FREEPDB1`。

#### `APP_USER`（可选）  
创建应用用户，需配合 `APP_USER_PASSWORD` 或 `APP_USER_PASSWORD_FILE` 使用。18c+ 版本默认在 `FREEPDB1` 中创建，若指定 `ORACLE_DATABASE`，则同时在对应 PDB 中创建。

#### `APP_USER_PASSWORD`（可选）  
`APP_USER` 的密码，需与 `APP_USER` 同时指定。


### GitHub Actions 集成

#### 方式一：使用 Setup 动作  
通过 GitHub Marketplace 的 [Setup Oracle DB Free]([]) 动作快速集成：  
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: gvenzl/setup-oracle-free@v1
        with:
          app-user: <应用用户名>
          app-user-password: <用户密码>
```

#### 方式二：作为服务容器  
直接定义为服务容器（Service Container）：  
```yaml
services:
  oracle:
    image: gvenzl/oracle-free:latest  # 可替换为其他标签
    env:
      ORACLE_RANDOM_PASSWORD: true    # 随机生成管理员密码
      APP_USER: my_user               # 创建应用用户
      APP_USER_PASSWORD: <用户密码>
    ports:
      - 1521:1521                     # 映射数据库端口
    # 健康检查配置
    options: >-
      --health-cmd healthcheck.sh
      --health-interval 10s
      --health-timeout 5s
      --health-retries 10
```

**连接信息**：  
- 主机名：`oracle`（容器内）或 `localhost`（宿主机）  
- 端口：`1521`  
- 服务名：`FREEPDB1`  
- 应用用户：`my_user`（上述配置中的 `APP_USER`）  


### Docker Compose 配置

通过 Docker Compose 快速搭建开发/测试环境：  
```yaml
version: "3.8"
services:
  oracle:
    image: gvenzl/oracle-free:latest  # 镜像标签
    ports:
      - "1521:1521"                   # 端口映射
    environment:
      ORACLE_PASSWORD: sys密码        # SYS/SYSTEM 密码
      APP_USER: my_user               # 应用用户
      APP_USER_PASSWORD: 用户密码     # 用户密码
    healthcheck:                      # 健康检查
      test: ["CMD", "healthcheck.sh"]
      interval: 10s
      timeout: 5s
      retries: 10
    volumes:
      - ./my-init.sql:/container-entrypoint-initdb.d/my-init.sql:ro  # 挂载初始化脚本
```

**连接信息**：  
- 容器内服务名：`oracle`；宿主机：`localhost`  
- 端口：`1521`  
- 服务名：`FREEPDB1`  


### 数据库用户管理

通过内置命令 `createAppUser` 创建额外用户（含标准权限）：  
```shell
# 用法：createAppUser 用户名 密码 [目标PDB，默认FREEPDB1]
docker exec <容器名或ID> createAppUser <应用用户> <用户密码> [<目标PDB>]
```

示例：在 `PDB1` 中创建用户 `app_user`，密码 `app_pwd`：  
```shell
docker exec my-oracle createAppUser app_user app_pwd PDB1
```


### 可插拔数据库（PDB）

将 `<PDB名称>.pdb` 文件放入容器内 `/pdb-plug` 目录，并通过 `ORACLE_DATABASE` 指定 PDB 名称，即可自动插拔 PDB。


### 容器密钥管理

敏感信息（如密码）可通过文件传入，只需在环境变量后添加 `_FILE` 后缀，从容器内文件读取值。例如：  
```shell
docker run -d --name oracle-db -e ORACLE_PASSWORD_FILE=/run/secrets/oracle-passwd gvenzl/oracle-free
```
支持的变量：`APP_USER_PASSWORD_FILE`、`ORACLE_PASSWORD_FILE`、`ORACLE_DATABASE_FILE`。  

> 不同容器技术（Docker/Podman/Kubernetes）的密钥管理机制不同，建议参考官方文档。


### 初始化脚本

容器首次启动时，会执行 `/container-entrypoint-initdb.d` 目录下的脚本（支持 `*.sql`、`*.sql.gz`、`*.sql.zip`、`*.sh`），按字母顺序执行（含子目录）。

#### 脚本类型说明  
- **`*.sql`/`*.sql.gz`/`*.sql.zip`**：通过 SQL\*Plus 以 `SYS` 用户连接到 `FREE` 实例执行，可用于创建 PDB、表空间等。若需初始化应用 schema，需在脚本中显式连接目标用户。  
- **`*.sh`**：可执行脚本（带 `x` 权限）在新 shell 中运行；非可执行脚本会被 source 到当前 shell（可能影响环境变量，建议设为可执行）。  

#### 示例：创建测试用户并初始化数据  
1. 本地创建 `init_scripts` 目录，包含以下文件：  
   - `1_create_user.sql`：创建用户  
     ```sql
     ALTER SESSION SET CONTAINER=FREEPDB1;
     CREATE USER TEST IDENTIFIED BY test QUOTA UNLIMITED ON USERS;
     GRANT CONNECT, RESOURCE TO TEST;
     ```  
   - `2_init_data.sh`：下载并执行数据脚本  
     ```bash
     curl -LJO []     sqlplus -s test/test@//localhost/FREEPDB1 @install.sql
     rm install.sql
     ```  

2. 启动容器时挂载目录：  
   ```shell
   docker run -d -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=yes -v ./init_scripts:/container-entrypoint-initdb.d gvenzl/oracle-free:23-slim
   ```

> **注意**：脚本仅在首次初始化时执行，已有数据库不会重复执行。


### 启动脚本

若需在每次数据库启动后执行操作，可将脚本放入 `/container-entrypoint-startdb.d` 目录（支持文件类型与初始化脚本相同），每次容器启动（含重启）后执行。


### 配置脚本

数据库配置脚本可参考 [config-scripts]([]) 目录。


## 反馈与建议

如有问题或建议，可通过 [GitHub Issues]([]) 提交。
