---
image: microsoft/mssql-server
description: "基于Ubuntu的微软SQL Server官方镜像，用于运行SQL Server数据库服务。"
source: https://xuanyuan.cloud/zh/r/microsoft/mssql-server
canonical: https://xuanyuan.cloud/zh/r/microsoft/mssql-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/microsoft/mssql-server" title="microsoft/mssql-server Docker 镜像中文简介、标签列表与拉取命令">microsoft/mssql-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Microsoft SQL Server Docker 镜像文档


## 镜像概述

基于 Ubuntu 的 Microsoft SQL Server 官方 Docker 镜像，用于在 Docker 环境中快速部署 SQL Server 数据库实例。该镜像支持多个 SQL Server 版本（2025、2022、2019、2017 等），提供灵活的配置选项，适用于开发、测试及生产环境（需遵守许可协议）。


## 核心功能与特性

- **多版本支持**：涵盖 SQL Server 2025（预览版）、2022、2019、2017 等主要版本，基于不同 Ubuntu 版本（24.04、22.04、20.04、18.04 等）构建。
- **工具集成**：从 SQL Server 2022 CU14 和 2019 CU28 开始，镜像包含 `mssql-tools18` 工具包，工具路径为 `/opt/mssql-tools18/bin`（原 `/opt/mssql-tools/bin` 逐步淘汰）。
- **加密优先策略**：集成 ODBC Driver 18，默认启用加密连接（`sqlcmd`、`bcp` 等工具遵循“默认安全”原则），需显式禁用加密。
- **多版本控制**：支持 Developer、Express、Enterprise 等多种版本，通过环境变量 `MSSQL_PID` 指定。
- **轻量级部署**：基于 Docker 容器化部署，简化环境配置，支持数据持久化与外部连接。


## 使用场景与适用范围

- **开发环境**：快速搭建本地 SQL Server 开发环境，支持版本切换与隔离。
- **测试环境**：在 CI/CD 流程中集成，自动化测试数据库相关功能。
- **小型生产部署**：适用于轻量级生产负载（需确保符合 SQL Server 许可协议）。
- **演示与培训**：快速部署临时数据库实例，用于演示或培训场景。


## 快速开始

### 拉取镜像

```bash
# 拉取最新版（默认 2022-latest）
docker pull ***-mcr.xuanyuan.run/mssql/server:latest

# 拉取特定版本（如 2025 预览版）
docker pull ***-mcr.xuanyuan.run/mssql/server:2025-latest
```


### 部署示例

#### 1. 基础部署（SQL Server 2022）

```bash
docker run -d \
  --name sqlserver2022 \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" \
  -p 1433:1433 \
  ***-mcr.xuanyuan.run/mssql/server:2022-latest
```

#### 2. 部署 Express 版本

```bash
docker run -d \
  --name sqlserver-express \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" \
  -e "MSSQL_PID=Express" \
  -p 1433:1433 \
  ***-mcr.xuanyuan.run/mssql/server:2022-latest
```

#### 3. 部署特定累积更新（CU）版本

```bash
# 示例：SQL Server 2022 CU16（基于 Ubuntu 22.04）
docker run -d \
  --name sqlserver-2022-cu16 \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" \
  -p 1433:1433 \
  ***-mcr.xuanyuan.run/mssql/server:2022-CU16-ubuntu-22.04
```

#### 4. Docker Compose 部署

创建 `docker-compose.yml`：

```yaml
version: '3.8'
services:
  sqlserver:
    image: ***-mcr.xuanyuan.run/mssql/server:2022-latest
    container_name: sqlserver
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=YourStrong!Passw0rd
      - MSSQL_PID=Developer  # 开发版（非生产环境）
    ports:
      - "1433:1433"
    volumes:
      - sqlserver_data:/var/opt/mssql  # 数据持久化
    restart: unless-stopped

volumes:
  sqlserver_data:
```

启动服务：

```bash
docker-compose up -d
```


## 详细配置

### 系统要求

- **Docker 版本**：Docker Engine 1.8+。
- **内存**：至少 2GB RAM（SQL Server 2017 CU2 之前需 3.25GB）。
- **存储**：建议使用持久化卷（Volume）存储数据，避免容器删除导致数据丢失。


### 环境变量

| 变量名           | 说明                                                                 | 必需 | 默认值     |
|------------------|----------------------------------------------------------------------|------|------------|
| `ACCEPT_EULA`    | 确认接受 SQL Server 许可协议（必须设为 `Y`）                          | 是   | -          |
| `MSSQL_SA_PASSWORD` | SA 用户密码（至少 8 字符，包含大小写字母、数字、特殊符号）           | 是   | -          |
| `MSSQL_PID`      | 指定 SQL Server 版本（如 `Developer`、`Express`、`Enterprise` 等）    | 否   | `Developer`|

**`MSSQL_PID` 可选值**（SQL Server 2025 预览版为例）：
- `Evaluation`：评估版（免费，180 天限制，非生产用）
- `Enterprise Developer`：企业开发版（免费，非生产用）
- `Standard Developer`：标准开发版（免费，非生产用）
- `Express`：Express 版（免费）
- `Web`、`Standard`、`Enterprise`：付费版（需有效许可）


### 连接数据库

#### 1. 容器内连接（使用 `sqlcmd`）

```bash
# 进入容器
docker exec -it sqlserver2022 bash

# 连接数据库（容器内）
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P YourStrong!Passw0rd
```

#### 2. 外部工具连接

从宿主机或远程机器使用 `sqlcmd`（需安装 [SQL Server 命令行工具](https://learn.microsoft.com/zh-cn/sql/linux/sql-server-linux-setup-tools)）：

```bash
sqlcmd -S localhost,1433 -U sa -P YourStrong!Passw0rd -No  # -No 禁用加密（仅测试用）
```

> **注意**：ODBC 18 驱动默认启用加密，连接时若需禁用，需添加 `-No`（`o` 代表 optional）。


### 数据持久化

通过挂载卷（Volume）或绑定目录（Bind Mount）持久化数据：

```bash
# 使用卷（推荐）
docker run -d \
  --name sqlserver \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" \
  -v sqlserver_data:/var/opt/mssql \  # 卷挂载
  -p 1433:1433 \
  mcr.microsoft.com/mssql/server:2022-latest
```


## 标签说明

### 主要标签（Featured Tags）

| 标签           | 说明                  | 基础系统    |
|----------------|-----------------------|-------------|
| `2025-latest`  | SQL Server 2025 预览版 | Ubuntu 22.04|
| `2022-latest`  | SQL Server 2022 最新版 | Ubuntu 22.04|
| `2019-latest`  | SQL Server 2019 最新版 | Ubuntu 20.04|
| `2017-latest`  | SQL Server 2017 最新版 | Ubuntu 18.04|

### 标签命名规则

- `GA`：正式发布版（如 `2022-GA-ubuntu-22.04`）
- `CU`：累积更新版（如 `2022-CU21-ubuntu-22.04`）
- `CTP`：社区技术预览版（如 `2025-CTP2.1-ubuntu-22.04`）
- `GDR`：安全更新版（仅包含安全修复，如 `2022-CU20-GDR1-ubuntu-22.04`）

**完整标签列表**：访问 [MCR 标签列表](https://mcr.microsoft.com/v2/mssql/server/tags/list)。


## 注意事项

### ODBC 驱动变更（重要）

从 SQL Server 2022 CU14 和 2019 CU28 开始：
- 工具包路径变更为 `/opt/mssql-tools18/bin`（原 `/opt/mssql-tools/bin` 逐步淘汰）。
- ODBC 18 驱动默认启用加密，`sqlcmd` 等工具需显式禁用加密（如 `-No` 选项）：

```bash
# 示例：禁用加密连接
sqlcmd -S 192.168.1.100,1433 -U sa -P YourStrong!Passw0rd -No
```


### 已知问题

- **macOS 卷挂载**：Docker for macOS 中挂载宿主机目录可能存在权限问题，建议使用 Docker Volume 替代。


## 支持与问题反馈

- **问题跟踪**：[mssql-docker GitHub 仓库](https://github.com/Microsoft/mssql-docker)
- **文档参考**：[SQL Server on Linux 文档](https://learn.microsoft.com/zh-cn/sql/linux/)


## 许可协议

- 需接受 SQL Server 许可协议（通过 `ACCEPT_EULA=Y` 确认）。
- **Developer 版**：免费，仅限开发/测试环境，禁止生产使用。
- **Express 版**：免费，适用于小型应用（有功能限制）。
- 付费版本（如 Enterprise、Standard）需有效许可，详情参见 [SQL Server 许可条款](https://go.microsoft.com/fwlink/?linkid=857698)。
