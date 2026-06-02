---
image: exoplatform/sqlserver
description: "用于测试目的的SQL Server镜像，基于官方Microsoft SQL Server Linux镜像构建，可轻松创建包含专用数据库和用户的SQL Server环境。"
source: https://xuanyuan.cloud/zh/r/exoplatform/sqlserver
canonical: https://xuanyuan.cloud/zh/r/exoplatform/sqlserver
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/exoplatform/sqlserver" title="exoplatform/sqlserver Docker 镜像中文简介、标签列表与拉取命令">exoplatform/sqlserver — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/exoplatform/sqlserver" title="exoplatform/sqlserver Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/exoplatform/sqlserver</a>

# eXo Platform SQL Server Docker镜像

## 镜像概述和主要用途
本镜像基于官方Microsoft SQL Server Linux镜像构建，旨在为测试目的提供便捷的SQL Server环境，可自动创建专用数据库和用户，简化测试环境搭建流程。

## 核心功能和特性
- 基于官方Microsoft SQL Server Linux镜像，确保兼容性和稳定性
- 自动创建指定名称的数据库和用户，并将用户设置为数据库所有者
- 支持数据持久化存储
- 提供多个版本选择，满足不同测试需求

## 版本信息

| 版本       | Microsoft基础镜像                     | 状态        |
|------------|--------------------------------------|-------------|
| 2017-CU8   | microsoft/mssql-server-linux:2017-CU-8 | 推荐        |
| 2017-CU7   | microsoft/mssql-server-linux:2017-CU-7 | 有效        |
| 2017-CU6   | microsoft/mssql-server-linux:2017-CU-6 | 有效        |
| 2017-CU5   | microsoft/mssql-server-linux:2017-CU-5 | 有效        |
| 2017-CU4   | microsoft/mssql-server-linux:2017-CU-4 | 有效        |
| 2017-CU3   | microsoft/mssql-server-linux:2017-CU-3 | 有效        |
| 2017-CU2   | microsoft/mssql-server-linux:2017-CU-2 | 有效        |
| 2017-CU1   | microsoft/mssql-server-linux:2017-CU-1 | 有效        |
| 2017-GA    | microsoft/mssql-server-linux:2017-GA   | 有效        |
| ctp-2-1    | microsoft/mssql-server-linux:ctp2-1    | 已弃用      |
| ctp-2      | microsoft/mssql-server-linux:ctp2-0    | 已弃用      |

## 使用方法

### 基本运行命令
```bash
docker run -d -e SA_PASSWORD=<密码> -e SQLSERVER_DATABASE=<数据库名> -e SQLSERVER_USER=<用户名> -e SQLSERVER_PASSWORD=<用户密码> -p <本地端口>:1433 exoplatform/sqlserver:2017-CU8
```

> **注意**：对于Docker4Mac和Docker4Windows用户，Docker实例必须至少分配**3192MB内存**。

### 支持的环境变量

- **SA_PASSWORD**：SA用户的密码（SQL Server系统管理员）
- **SQLSERVER_DATABASE**：要创建的数据库名称
- **SQLSERVER_USER**：要创建的数据库用户，将成为数据库所有者
- **SQLSERVER_PASSWORD**：数据库用户的密码

> **注意**：所有密码必须符合MSSQL密码规则：至少8个字符，包含小写字母、大写字母和数字。

## 端口
- 1433：SQL Server数据库默认端口

## 数据持久化

数据存储在容器内的`/var/opt/mssql`目录。如需持久化数据，可通过以下命令挂载卷：

```bash
-v <本地卷路径>:/var/opt/mssql
```

例如：
```bash
docker run -d -e SA_PASSWORD=YourStrong!Passw0rd -e SQLSERVER_DATABASE=testdb -e SQLSERVER_USER=testuser -e SQLSERVER_PASSWORD=UserStrong!Passw0rd -p 1433:1433 -v sqlserver_data:/var/opt/mssql exoplatform/sqlserver:2017-CU8
```

## 适用场景
- 开发环境测试
- 自动化测试环境搭建
- 临时SQL Server环境需求
- 学习和演示用途
