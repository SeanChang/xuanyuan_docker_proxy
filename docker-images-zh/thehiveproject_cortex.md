---
image: thehiveproject/cortex
description: "强大的可观测数据分析与主动响应引擎"
source: https://xuanyuan.cloud/zh/r/thehiveproject/cortex
canonical: https://xuanyuan.cloud/zh/r/thehiveproject/cortex
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/thehiveproject/cortex" title="thehiveproject/cortex Docker 镜像中文简介、标签列表与拉取命令">thehiveproject/cortex 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Cortex 镜像技术文档

## 1. 镜像概述和主要用途

Cortex 是由 TheHive Project 开发的开源免费软件，定位为**强大的可观测对象分析与主动响应引擎**。其核心目标是解决 SOC（安全运营中心）、CSIRT（计算机安全事件响应团队）及安全研究人员在威胁情报、数字取证和事件响应过程中面临的关键挑战：如何通过单一工具而非多个工具，对收集到的可观测对象（如 IP 地址、邮箱地址、URL、域名、文件、哈希等）进行规模化分析，从而提升调查效率。

通过 Cortex，用户无需为每次使用新的服务或工具分析可观测对象而重复开发功能，可直接利用其内置的多种分析器（analyzers），或创建自定义分析器并共享给团队乃至社区，实现高效协作与资源复用。


## 2. 核心功能和特性

### 2.1 核心功能
- **多类型可观测对象分析**：支持对 IP 地址、邮箱地址、URL、域名、文件、哈希等多种可观测对象进行分析。
- **灵活的分析模式**：提供 Web 界面支持单个体或批量分析，同时支持通过 REST API 实现自动化操作，满足不同场景下的分析需求。
- **丰富的分析器生态**：内置多种分析器，覆盖各类安全服务与工具，用户可直接调用，避免重复开发。
- **自定义分析器支持**：允许用户根据需求创建自定义分析器，并通过 Cortex 共享给团队或社区，扩展分析能力。

### 2.2 关键特性
- **开源免费**：遵循开源许可，免费供用户使用，无商业许可限制。
- **单一工具集成**：整合多种分析能力于一体，减少工具切换成本，提升分析效率。
- **社区驱动**：支持通过社区贡献（如提交自定义分析器至官方仓库）扩展功能，促进安全工具生态共建。


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **威胁情报分析**：对可疑 IP、域名、URL 等可观测对象进行批量分析，快速评估威胁程度。
- **数字取证调查**：在取证过程中，通过分析文件哈希、邮箱地址等可观测对象，追踪攻击源或关联线索。
- **事件响应处置**：在安全事件响应中，自动化分析相关可观测对象，加速事件研判与处置流程。

### 3.2 适用范围
- **SOC 团队**：用于日常安全运营中的可观测对象批量分析与威胁狩猎。
- **CSIRT**：支持计算机安全事件响应过程中的快速调查与分析。
- **安全研究人员**：辅助威胁情报研究，高效利用多种分析工具验证假设。


## 4. 使用方法和配置说明

### 4.1 部署前提
- 已安装 Docker 及 Docker Compose（推荐）。
- 确保目标主机具备至少 2GB 内存及 20GB 存储空间（根据分析器数量及数据量调整）。

### 4.2 Docker 快速部署（docker run）
```docker
docker run -d \
  --name cortex \
  -p 9001:9001 \
  -v /path/to/cortex/data:/data \
  -e CORTEX_CONFIG_FILE=/data/application.conf \
  docker.xuanyuan.run/thehiveproject/cortex:latest
```
> 说明：  
> - `-p 9001:9001`：映射容器内 9001 端口（默认 Web/API 端口）至主机。  
> - `-v /path/to/cortex/data:/data`：挂载主机目录至容器内 `/data`，用于持久化配置文件、日志及数据。  
> - `-e CORTEX_CONFIG_FILE`：指定配置文件路径，建议使用外部挂载的配置文件进行自定义配置。

### 4.3 Docker Compose 部署示例
创建 `docker-compose.yml` 文件：
```yaml
version: '3'
services:
  cortex:
    image: docker.xuanyuan.run/thehiveproject/cortex:latest
    container_name: cortex
    ports:
      - "9001:9001"
    volumes:
      - ./cortex-data:/data
      - ./application.conf:/data/application.conf
    environment:
      - CORTEX_CONFIG_FILE=/data/application.conf
      - JAVA_OPTS="-Xms1G -Xmx2G"  # 根据主机资源调整 JVM 内存
    restart: unless-stopped
```
启动服务：
```bash
docker-compose up -d
```

### 4.4 配置说明
#### 4.4.1 核心配置文件
Cortex 主要通过 `application.conf` 进行配置，关键配置项包括：
- `play.http.secret.key`：应用密钥，用于加密会话数据，建议使用随机生成的字符串。
- `db.default`：数据库配置（默认使用 H2 嵌入式数据库，生产环境建议切换至 PostgreSQL）。
- `analyzer.paths`：分析器存放路径，指定自定义分析器的目录。

#### 4.4.2 常用环境变量
| 环境变量                | 描述                          | 默认值                  |
|-------------------------|-------------------------------|-------------------------|
| `CORTEX_CONFIG_FILE`    | 配置文件路径                  | `/etc/cortex/application.conf` |
| `JAVA_OPTS`             | JVM 参数（内存分配等）        | `-Xms512M -Xmx1G`       |
| `PLAY_HTTP_SECRET_KEY`  | 应用密钥（覆盖配置文件）      | 无（需用户自定义）      |

### 4.5 访问与使用
部署完成后，通过浏览器访问 `http://<主机IP>:9001` 进入 Cortex Web 界面，初始用户名/密码通常为 `admin@thehive.local`/`secret`（首次登录需修改密码）。通过 Web 界面可添加分析器、创建分析任务，或通过 REST API（文档路径：`http://<主机IP>:9001/api/docs`）进行自动化集成。


## 5. 注意事项
- **分析器安装**：Cortex 本身不包含分析器，需单独部署 [cortex-analyzers](https://github.com/TheHive-Project/cortex-analyzers) 并在配置中指定路径。
- **数据库选择**：生产环境中建议使用 PostgreSQL 替代默认 H2 数据库，提升数据可靠性与性能。
- **安全加固**：通过配置 HTTPS、限制访问 IP、定期更新镜像及分析器，确保部署安全。
