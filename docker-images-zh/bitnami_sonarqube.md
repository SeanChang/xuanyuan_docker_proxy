---
image: bitnami/sonarqube
description: "Bitnami安全镜像，用于部署SonarQube代码质量与安全分析工具，提供安全加固的生产环境支持。"
source: https://xuanyuan.cloud/zh/r/bitnami/sonarqube
canonical: https://xuanyuan.cloud/zh/r/bitnami/sonarqube
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/sonarqube" title="bitnami/sonarqube Docker 镜像中文简介、标签列表与拉取命令">bitnami/sonarqube 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami SonarQube™ 镜像文档


## 1. 镜像概述和主要用途

### 1.1 SonarQube™ 简介
SonarQube™ 是一款开源代码质量管理平台，用于分析和度量代码的技术质量。它能帮助开发人员在早期阶段检测代码问题、安全漏洞和缺陷，支持多种编程语言，提供可操作的质量报告，是持续集成和代码审查流程中的关键工具。

### 1.2 Bitnami 镜像特点
Bitnami SonarQube™ 镜像是基于 Bitnami 安全镜像标准构建的容器化部署方案，具备以下特点：
- 开箱即用的配置，简化部署流程
- 支持持久化存储，确保数据不丢失
- 遵循安全最佳实践，默认以非 root 用户运行
- 与 Bitnami 其他产品（如 PostgreSQL 镜像）无缝集成


## 2. 核心功能和特性

### 2.1 SonarQube 核心功能
- **多语言代码分析**：支持 Java、Python、JavaScript 等 20+ 编程语言
- **质量指标监控**：代码复杂度、重复率、测试覆盖率等关键指标
- **安全漏洞检测**：识别 OWASP Top 10 等常见安全漏洞
- **持续集成支持**：与 Jenkins、GitHub Actions 等 CI/CD 工具集成
- **可定制规则**：支持自定义质量规则和阈值

### 2.2 Bitnami 镜像增强特性
- **安全加固**：基于最小化 Photon Linux 系统，减少攻击面
- **供应链安全**：提供 SBOM（软件物料清单）、病毒扫描报告和 SLSA-3 合规构建元数据
- **CVE 透明度**：通过 VEX/KEV 标准提供漏洞可利用性信息，附 EPSS 风险评分
- **非 root 运行**：默认使用低权限用户，降低容器逃逸风险
- **版本一致性**：与 Bitnami 虚拟机、云镜像配置一致，便于跨环境迁移


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **开发环境代码审查**：开发团队本地或开发服务器上实时检测代码质量
- **CI/CD 流水线集成**：在代码合并前自动执行质量检查，阻止不合格代码入库
- **项目质量审计**：定期分析现有项目代码库，生成质量报告和改进建议

### 3.2 适用范围
- **开发/测试环境**：免费版镜像适用于开发和测试，仅提供最新标签
- **生产环境**：推荐使用 Bitnami Secure Images 商业版，包含长期支持、企业级安全加固和技术支持


## 4. 重要通知：Bitnami 镜像目录变更

自 2025 年 8 月 28 日起，Bitnami 将升级公共镜像目录，推出 **Bitnami Secure Images** 计划，聚焦安全加固镜像：
- **社区用户**：首次可访问安全优化版镜像，但非加固的 Debian 基础镜像将逐步弃用，免费层仅提供少量"latest"标签的加固镜像（用于开发）
- **镜像迁移**：现有所有镜像（含历史版本标签，如 2.50.0、10.6）将在两周内迁移至 `docker.io/bitnamilegacy` 仓库，不再接收更新
- **生产建议**：生产环境需使用 Bitnami Secure Images 商业版，包含硬化容器、CVE 透明度、SBOM 和企业支持

详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 5. 支持的标签

Bitnami SonarQube™ 镜像提供多种标签，支持不同版本和操作系统。标签策略遵循 Bitnami 标准，分为滚动标签（如 `latest`）和不可变标签（如特定版本号）。具体标签列表及对应 Dockerfile 链接可通过以下途径获取：
- [Docker Hub 标签页](https://hub.docker.com/r/bitnami/sonarqube/tags/)
- Bitnami 标签策略文档：[理解滚动标签和不可变标签](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)


## 6. 获取镜像

### 6.1 从 Docker Hub 拉取
推荐通过 Docker Hub 获取预构建镜像：
```console
# 获取最新版
docker pull docker.xuanyuan.run/bitnami/sonarqube:latest

# 获取特定版本（如存在）
docker pull docker.xuanyuan.run/bitnami/sonarqube:[TAG]  # 替换 [TAG] 为具体版本号
```

### 6.2 本地构建
从 GitHub 仓库克隆源码并构建：
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/sonarqube/[VERSION]/[OS]  # 替换 [VERSION] 和 [OS] 为具体值
docker build -t bitnami/sonarqube:latest .
```


## 7. 使用方法

SonarQube™ 依赖 PostgreSQL 数据库存储数据，以下示例使用 Bitnami PostgreSQL 镜像作为数据库。


### 7.1 使用 Docker 命令行

#### 步骤 1：创建网络
```console
docker network create sonarqube-network
```

#### 步骤 2：启动 PostgreSQL 容器
```console
# 创建持久化卷
docker volume create postgresql_data

# 启动 PostgreSQL（允许空密码仅用于开发）
docker run -d --name postgresql \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env POSTGRESQL_USERNAME=bn_sonarqube \
  --env POSTGRESQL_PASSWORD=bitnami \
  --env POSTGRESQL_DATABASE=bitnami_sonarqube \
  --network sonarqube-network \
  --volume postgresql_data:/bitnami/postgresql \
  docker.xuanyuan.run/bitnami/postgresql:latest
```

#### 步骤 3：启动 SonarQube™ 容器
```console
# 创建持久化卷
docker volume create sonarqube_data

# 启动 SonarQube™
docker run -d --name sonarqube \
  -p 8080:9000  # 映射容器内 9000 端口到主机 8080
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env SONARQUBE_DATABASE_USER=bn_sonarqube \
  --env SONARQUBE_DATABASE_PASSWORD=bitnami \
  --env SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
  --env SONARQUBE_DATABASE_HOST=postgresql \
  --network sonarqube-network \
  --volume sonarqube_data:/bitnami/sonarqube \
  bitnami/sonarqube:latest
```

访问应用：`http://<主机IP>:8080`（默认凭据：`admin`/`bitnami`）。


### 7.2 使用 Docker Compose

#### 步骤 1：创建 docker-compose.yml
```yaml
version: '2'

services:
  postgresql:
    image: docker.xuanyuan.run/bitnami/postgresql:latest
    volumes:
      - postgresql_data:/bitnami/postgresql
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USERNAME=bn_sonarqube
      - POSTGRESQL_PASSWORD=bitnami
      - POSTGRESQL_DATABASE=bitnami_sonarqube

  sonarqube:
    image: docker.xuanyuan.run/bitnami/sonarqube:latest
    ports:
      - '8080:9000'
    volumes:
      - sonarqube_data:/bitnami/sonarqube
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - SONARQUBE_DATABASE_HOST=postgresql
      - SONARQUBE_DATABASE_PORT_NUMBER=5432
      - SONARQUBE_DATABASE_USER=bn_sonarqube
      - SONARQUBE_DATABASE_PASSWORD=bitnami
      - SONARQUBE_DATABASE_NAME=bitnami_sonarqube
    depends_on:
      - postgresql

volumes:
  postgresql_data:
    driver: local
  sonarqube_data:
    driver: local
```

#### 步骤 2：启动服务
```console
docker-compose up -d
```

> **注意**：此 Compose 配置仅用于开发/测试，生产环境需使用 [Bitnami Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/sonarqube)。


## 8. 数据持久化

为避免容器删除导致数据丢失，需持久化 SonarQube 和 PostgreSQL 的数据目录。


### 8.1 使用 Docker 卷（推荐）
通过 `docker volume` 创建卷并挂载，卷由 Docker 管理，安全性更高：
```console
# PostgreSQL 卷（已在 7.1 中示例）
docker volume create postgresql_data

# SonarQube 卷（已在 7.1 中示例）
docker volume create sonarqube_data
```


### 8.2 挂载主机目录
将主机目录直接挂载到容器，需确保目录权限正确（非 root 容器依赖 UID 1001）：

#### Docker Compose 配置
修改 `docker-compose.yml` 中的 volumes 部分：
```diff
services:
  postgresql:
    volumes:
-      - postgresql_data:/bitnami/postgresql
+      - /path/to/host/postgresql:/bitnami/postgresql  # 替换为实际主机路径
  sonarqube:
    volumes:
-      - sonarqube_data:/bitnami/sonarqube
+      - /path/to/host/sonarqube:/bitnami/sonarqube  # 替换为实际主机路径
-volumes:
-  postgresql_data:
-  sonarqube_data:
```

#### Docker 命令行
```console
# 启动 PostgreSQL
docker run -d --name postgresql \
  --network sonarqube-network \
  --volume /path/to/host/postgresql:/bitnami/postgresql \  # 主机目录
  [其他环境变量] \
  bitnami/postgresql:latest

# 启动 SonarQube™
docker run -d --name sonarqube \
  --network sonarqube-network \
  --volume /path/to/host/sonarqube:/bitnami/sonarqube \  # 主机目录
  [其他环境变量] \
  bitnami/sonarqube:latest
```


## 9. 配置说明


### 9.1 环境变量

#### 9.1.1 可定制环境变量

| 变量名                              | 描述                                                                 | 默认值                                      |
|-----------------------------------|----------------------------------------------------------------------|-------------------------------------------|
| `SONARQUBE_MOUNTED_PROVISIONING_DIR` | 初始配置文件挂载目录                                                     | `/bitnami/sonarqube-provisioning`          |
| `SONARQUBE_DATA_TO_PERSIST`        | 需持久化的文件路径（相对于安装目录，空格分隔多值）                               | `${SONARQUBE_DATA_DIR} ${SONARQUBE_EXTENSIONS_DIR}` |
| `SONARQUBE_PORT_NUMBER`            | Web 应用端口                                                          | `9000`                                    |
| `SONARQUBE_ELASTICSEARCH_PORT_NUMBER` | Elasticsearch 端口                                                   | `9001`                                    |
| `SONARQUBE_START_TIMEOUT`          | 应用启动超时时间（秒）                                                     | `300`                                     |
| `SONARQUBE_SKIP_BOOTSTRAP`         | 是否跳过初始引导（如数据库已有数据时需设为 `yes`）                              | `no`                                      |
| `SONARQUBE_WEB_CONTEXT`            | 应用访问前缀（如 `/sonarqube`）                                          | `/`                                       |
| `SONARQUBE_MAX_HEAP_SIZE`          | 服务最大堆内存（CE、Search、Web）                                          | `nil`（无默认值）                          |
| `SONARQUBE_MIN_HEAP_SIZE`          | 服务最小堆内存（CE、Search、Web）                                          | `nil`（无默认值）                          |
| `SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS` | Elasticsearch 额外 Java 参数                                          | `nil`（无默认值）                          |
| `SONARQUBE_EXTRA_PROPERTIES`       | `sonar.properties` 额外属性（格式：`key1=val1,key2=val2`）                 | `nil`（无默认值）                          |
| `SONARQUBE_USERNAME`               | 管理员用户名                                                          | `admin`                                   |
| `SONARQUBE_PASSWORD`               | 管理员密码                                                            | `bitnami`                                 |
| `SONARQUBE_EMAIL`                  | 管理员邮箱                                                           | `user@example.com`                        |
| `SONARQUBE_SMTP_HOST`              | SMTP 服务器地址（用于邮件通知）                                           | `nil`（无默认值）                          |
| `SONARQUBE_SMTP_PORT_NUMBER`       | SMTP 端口                                                            | `nil`（无默认值）                          |
| `SONARQUBE_SMTP_USER`              | SMTP 用户名                                                          | `nil`（无默认值）                          |
| `SONARQUBE_SMTP_PASSWORD`          | SMTP 密码                                                            | `nil`（无默认值）                          |
| `SONARQUBE_SMTP_PROTOCOL`          | SMTP 协议（如 `tls`）                                                  | `nil`（无默认值）                          |
| `SONARQUBE_DATABASE_HOST`          | 数据库主机地址                                                        | `postgresql`（默认连接名为 postgresql 的容器） |
| `SONARQUBE_DATABASE_PORT_NUMBER`   | 数据库端口                                                           | `5432`                                    |
| `SONARQUBE_DATABASE_NAME`          | 数据库名称                                                           | `bitnami_sonarqube`                       |
| `SONARQUBE_DATABASE_USER`          | 数据库用户名                                                         | `bn_sonarqube`                            |
| `SONARQUBE_DATABASE_PASSWORD`      | 数据库密码                                                           | `nil`（无默认值）                          |

#### 9.1.2 只读环境变量（不可修改）

| 变量名                          | 描述                     | 值                                          |
|-------------------------------|--------------------------|---------------------------------------------|
| `SONARQUBE_BASE_DIR`           | 安装目录                 | `${BITNAMI_ROOT_DIR}/sonarqube`             |
| `SONARQUBE_DATA_DIR`           | 数据目录                 | `${SONARQUBE_BASE_DIR}/data`                |
| `SONARQUBE_EXTENSIONS_DIR`     | 扩展目录                 | `${SONARQUBE_BASE_DIR}/extensions`          |
| `SONARQUBE_CONF_DIR`           | 配置文件目录             | `${SONARQUBE_BASE_DIR}/conf`                |
| `SONARQUBE_CONF_FILE`          | 主配置文件               | `${SONARQUBE_CONF_DIR}/sonar.properties`    |
| `SONARQUBE_LOGS_DIR`           | 日志目录                 | `${SONARQUBE_BASE_DIR}/logs`                |
| `SONARQUBE_LOG_FILE`           | 主日志文件               | `${SONARQUBE_LOGS_DIR}/sonar.log`           |
| `SONARQUBE_TMP_DIR`            | 临时文件目录             | `${SONARQUBE_BASE_DIR}/temp`                |
| `SONARQUBE_PID_FILE`           | PID 文件路径             | `${SONARQUBE_BASE_DIR}/pids/SonarQube.pid`  |
| `SONARQUBE_BIN_DIR`            | 可执行文件目录           | `${SONARQUBE_BASE_DIR}/bin/linux-x86-64`    |
| `SONARQUBE_VOLUME_DIR`         | 挂载配置目录             | `${BITNAMI_VOLUME_DIR}/sonarqube`           |
| `SONARQUBE_DAEMON_USER`        | 运行用户                 | `sonarqube`                                 |
| `SONARQUBE_DAEMON_USER_ID`     | 运行用户 UID             | `1001`                                      |
| `SONARQUBE_DAEMON_GROUP`       | 运行用户组               | `sonarqube`                                 |
| `SONARQUBE_DAEMON_GROUP_ID`    | 运行用户组 GID           | `1001`                                      |
| `SONARQUBE_CE_JAVA_ADD_OPTS`   | 计算引擎额外 Java 参数    | `${SONARQUBE_CE_JAVA_ADD_OPTS:-} ${JAVA_TOOL_OPTIONS:-}` |
| `SONARQUBE_WEB_JAVA_ADD_OPTS`  | Web 服务额外 Java 参数    | `${SONARQUBE_WEB_JAVA_ADD_OPTS:-} ${JAVA_TOOL_OPTIONS:-}` |
| `SONARQUBE_DEFAULT_DATABASE_HOST` | 默认数据库主机         | `postgresql`                                |


### 9.2 配置示例

#### 示例 1：配置 SMTP（Gmail）
```console
docker run -d --name sonarqube \
  -p 8080:9000 \
  --network sonarqube-network \
  --env SONARQUBE_DATABASE_HOST=postgresql \
  --env SONARQUBE_DATABASE_USER=bn_sonarqube \
  --env SONARQUBE_DATABASE_PASSWORD=bitnami \
  --env SONARQUBE_DATABASE_NAME=bitnami_sonarqube \
  --env SONARQUBE_SMTP_HOST=smtp.gmail.com \
  --env SONARQUBE_SMTP_PORT_NUMBER=587 \
