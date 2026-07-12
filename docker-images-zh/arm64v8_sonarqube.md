---
image: arm64v8/sonarqube
description: "SonarQube官方镜像，这是一款用于代码质量和安全的代码分析工具。"
source: https://xuanyuan.cloud/zh/r/arm64v8/sonarqube
canonical: https://xuanyuan.cloud/zh/r/arm64v8/sonarqube
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/sonarqube" title="arm64v8/sonarqube Docker 镜像中文简介、标签列表与拉取命令">arm64v8/sonarqube 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm64v8/sonarqube 镜像文档


## 镜像概述和主要用途

`arm64v8/sonarqube` 是 SonarQube 官方 Docker 镜像的 `arm64v8` 架构版本，用于存储 SonarQube Server 和 SonarQube Community Build 的官方镜像。  

[SonarQube Server](https://www.sonarsource.com/products/sonarqube/)（前身为 SonarQube）是一款本地部署的代码分析工具，支持检测 30 多种语言、框架和 IaC 平台中的质量与安全问题，并通过 Sonar AI CodeFix 能力提供基于 AI 的修复建议。该工具可直接集成到 CI 流水线或主流 DevOps 平台，在每次合并/拉取请求时对代码进行全面检查，覆盖可维护性、可靠性、安全性等多维度指标。  

[SonarQube Community Build](https://www.sonarsource.com/open-source-editions/sonarqube-community-edition/)（前身为 SonarQube Community）是 Sonar 提供的免费自管理版本，每月更新，包含开源核心功能，支持 21 种编程语言和框架的基础 bug 检测、代码异味识别及安全问题分析。商业版本（SonarQube Server Developer、Enterprise、Data Center 版）则提供高级安全分析、企业级集成和可扩展性特性。  


## 核心功能和特性

- **多语言支持**：覆盖 30+ 编程语言、框架及 IaC 平台（社区版支持 21 种）。  
- **全面问题检测**：识别代码质量问题（如代码异味、重复代码）、可靠性问题（如 bug）及安全漏洞（如 SQL 注入、跨站脚本）。  
- **AI 辅助修复**：通过 Sonar AI CodeFix 提供精准的代码修复建议。  
- **CI/CD 集成**：无缝对接主流 CI 工具及 DevOps 平台，在代码合并前完成质量检查。  
- **多版本支持**：提供社区版（免费）和商业版（Developer/Enterprise/Data Center，需授权）。  
- **可扩展性**：支持第三方插件扩展功能（通过挂载扩展目录实现）。  


## 使用场景和适用范围

- **开发团队代码质量管控**：在开发流程中自动检测代码问题，提升代码库整体质量。  
- **CI/CD 流水线集成**：作为代码合并前的门禁检查，阻止低质量代码进入主分支。  
- **安全漏洞扫描**：识别并修复潜在安全风险，符合行业合规标准。  
- **多语言项目管理**：统一管理不同技术栈项目的质量指标。  
- **企业级部署**：Data Center 版支持集群部署，满足高可用性和大规模代码分析需求。  


## 支持的标签及对应 Dockerfile 链接

| 标签系列 | Dockerfile 链接 |
|----------|----------------|
| `2025.5.0-developer`, `2025.5-developer`, `developer` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/4f77dc7067a3ed7761c56361e40ad7dda3cd9d6c/commercial-editions/developer/Dockerfile) |
| `2025.5.0-enterprise`, `2025.5-enterprise`, `enterprise` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/4f77dc7067a3ed7761c56361e40ad7dda3cd9d6c/commercial-editions/enterprise/Dockerfile) |
| `2025.5.0-datacenter-app`, `2025.5-datacenter-app`, `datacenter-app` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/4f77dc7067a3ed7761c56361e40ad7dda3cd9d6c/commercial-editions/datacenter/app/Dockerfile) |
| `2025.5.0-datacenter-search`, `2025.5-datacenter-search`, `datacenter-search` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/4f77dc7067a3ed7761c56361e40ad7dda3cd9d6c/commercial-editions/datacenter/search/Dockerfile) |
| `2025.4.3-developer`, `2025.4-developer` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/52f6f8a3a79daf2f4ed53b9f6313df16dcbb710a/commercial-editions/developer/Dockerfile) |
| `2025.4.3-enterprise`, `2025.4-enterprise` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/52f6f8a3a79daf2f4ed53b9f6313df16dcbb710a/commercial-editions/enterprise/Dockerfile) |
| `2025.4.3-datacenter-app`, `2025.4-datacenter-app` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/52f6f8a3a79daf2f4ed53b9f6313df16dcbb710a/commercial-editions/datacenter/app/Dockerfile) |
| `2025.4.3-datacenter-search`, `2025.4-datacenter-search` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/52f6f8a3a79daf2f4ed53b9f6313df16dcbb710a/commercial-editions/datacenter/search/Dockerfile) |
| `2025.1.4-developer`, `2025.1-developer`, `2025-lta-developer` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/175609a6b668d26878ea8d063d66677247272f38/commercial-editions/developer/Dockerfile) |
| `2025.1.4-enterprise`, `2025.1-enterprise`, `2025-lta-enterprise` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/175609a6b668d26878ea8d063d66677247272f38/commercial-editions/enterprise/Dockerfile) |
| `2025.1.4-datacenter-app`, `2025.1-datacenter-app`, `2025-lta-datacenter-app` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/175609a6b668d26878ea8d063d66677247272f38/commercial-editions/datacenter/app/Dockerfile) |
| `2025.1.4-datacenter-search`, `2025.1-datacenter-search`, `2025-lta-datacenter-search` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/175609a6b668d26878ea8d063d66677247272f38/commercial-editions/datacenter/search/Dockerfile) |
| `25.10.0.114319-community`, `community`, `latest` | [链接](https://github.com/SonarSource/docker-sonarqube/blob/a5d28439b45d0a6002290fd28bf1b481c0182bb6/community-build/Dockerfile) |  


## 系统要求

SonarQube 依赖嵌入式 Elasticsearch，Docker 主机需满足以下配置（以 Linux 为例）：

```bash
# 设置虚拟内存映射数
sysctl -w vm.max_map_count=524288
# 设置文件描述符上限
sysctl -w fs.file-max=131072
# 设置当前会话的文件描述符限制
ulimit -n 131072
# 设置用户进程数限制
ulimit -u 8192
```


## 使用方法和配置说明

### 快速演示

通过以下命令启动社区版演示实例（仅用于测试，不建议生产环境）：

```bash
docker run --name sonarqube-demo -p 9000:9000 docker.xuanyuan.run/arm64v8/sonarqube:community
```

访问 `http://localhost:9000`，默认账号密码：`admin/admin`。


### 生产环境部署

#### 1. 基础部署（使用外部数据库）

推荐使用外部数据库（如 PostgreSQL）存储数据，避免嵌入式 H2 数据库的局限性。以下示例使用 PostgreSQL 并挂载数据卷：

```bash
# 创建数据卷
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

# 启动 SonarQube（需先启动 PostgreSQL 并配置环境变量）
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -e SONAR_JDBC_URL=jdbc:postgresql://<postgresql-host>:5432/sonarqube \
  -e SONAR_JDBC_USERNAME=<db-username> \
  -e SONAR_JDBC_PASSWORD=<db-password> \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  --stop-timeout 3600 \  # 允许1小时优雅关闭（等待任务完成）
  arm64v8/sonarqube:community
```

#### 2. Docker Compose 部署

创建 `docker-compose.yml` 文件，集成 SonarQube 和 PostgreSQL：

```yaml
version: '3.8'
services:
  sonarqube:
    image: docker.xuanyuan.run/arm64v8/sonarqube:community
    container_name: sonarqube
    ports:
      - "9000:9000"
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonarqube
      - SONAR_JDBC_USERNAME=sonar
      - SONAR_JDBC_PASSWORD=sonar_password
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions
    depends_on:
      - db
    stop_grace_period: 1h  # 优雅关闭超时时间

  db:
    image: docker.xuanyuan.run/arm64v8/postgres:14
    container_name: sonarqube_db
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar_password
      - POSTGRES_DB=sonarqube
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:
  postgres_data:
```

启动服务：

```bash
docker-compose up -d
```


### 核心配置说明

#### 端口绑定

默认端口为 `9000`，通过 `-p <host-port>:9000` 映射到主机端口。

#### 环境变量

常用环境变量用于配置数据库连接及服务参数：

| 环境变量 | 说明 | 示例 |
|----------|------|------|
| `SONAR_JDBC_URL` | 数据库连接 URL | `jdbc:postgresql://db:5432/sonarqube` |
| `SONAR_JDBC_USERNAME` | 数据库用户名 | `sonar` |
| `SONAR_JDBC_PASSWORD` | 数据库密码 | `sonar_password` |
| `SONAR_WEB_JAVAOPTS` | Web 进程 JVM 参数 | `-Xmx1G -Xms1G` |

#### 数据卷挂载

推荐挂载以下目录以持久化数据和配置：

- `/opt/sonarqube/data`：存储数据库数据、Elasticsearch 索引等
- `/opt/sonarqube/logs`：服务日志
- `/opt/sonarqube/extensions`：第三方插件


## 高级配置

### 自定义镜像（预安装插件）

通过 Dockerfile 构建包含自定义插件的镜像：

```dockerfile
FROM docker.xuanyuan.run/arm64v8/sonarqube:community
# 复制自定义插件到扩展目录
COPY sonar-custom-plugin-1.0.jar /opt/sonarqube/extensions/plugins/
```

构建并运行：

```bash
docker build -t sonarqube-custom .
docker run -d --name docker.xuanyuan.run/sonarqube-custom -p 9000:9000 sonarqube-custom
```

### 避免硬终止

SonarQube 需等待进行中的任务完成后优雅关闭，默认 Docker 10 秒超时可能导致进程被强制终止。通过 `--stop-timeout` 或 `stop_grace_period`（Docker Compose）设置超时：

```bash
# 允许1小时优雅关闭
docker run --stop-timeout 3600 arm64v8/sonarqube:community
```


## 升级说明

升级需遵循官方指南，确保数据兼容性。详细步骤参考 [从 Docker 镜像升级 SonarQube](https://docs.sonarsource.com/sonarqube-server/latest/server-upgrade-and-maintenance/upgrade/upgrade/)。


## 实例管理

SonarQube 实例管理文档参见 [官方管理指南](https://docs.sonarsource.com/sonarqube-server/latest/instance-administration/overview/)。


## 许可证

- **SonarQube Community Build**：基于 [GNU Lesser General Public License, Version 3.0](http://www.gnu.org/licenses/lgpl.txt) 许可。  
- **SonarQube Server 商业版**（Developer/Enterprise/Data Center）：基于 [SonarSource 条款与条件](https://www.sonarsource.com/docs/sonarsource_terms_and_conditions.pdf) 许可。  

镜像中包含的其他软件可能受不同许可证约束，用户需自行确保合规使用。


## 支持与反馈

- **问题反馈**：[GitHub Issues](https://github.com/SonarSource/docker-sonarqube/issues)  
- **社区支持**：[SonarSource 社区论坛](https://community.sonarsource.com/tags/c/help/sq/docker)  
- **Docker 社区**：[Docker 论坛](https://forums.docker.com/)、[Docker Slack](https://blog.docker.com/2016/11/introducing-docker-community-directory-docker-community-slack/) 或 [Stack Overflow](https://stackoverflow.com/search?q=docker+sonarqube)
