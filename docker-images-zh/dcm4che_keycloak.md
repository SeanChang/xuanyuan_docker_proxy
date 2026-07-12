---
image: dcm4che/keycloak
description: "基于eclipse-temurin:17 Java运行时的Keycloak镜像，提供开源身份和访问管理功能，支持单点登录、认证与授权，适用于为应用系统提供安全身份服务。"
source: https://xuanyuan.cloud/zh/r/dcm4che/keycloak
canonical: https://xuanyuan.cloud/zh/r/dcm4che/keycloak
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dcm4che/keycloak" title="dcm4che/keycloak Docker 镜像中文简介、标签列表与拉取命令">dcm4che/keycloak 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# dcm4che/keycloak-quarkus 镜像文档

## 1. 概述

dcm4che/keycloak-quarkus 是基于 eclipse-temurin:17（Java 17）构建的 Keycloak 镜像，采用 Keycloak 的 Quarkus 发行版。Keycloak 是一款开源的身份和访问管理（IAM）解决方案，提供集中式身份验证、授权、用户管理和单点登录（SSO）功能，适用于现代应用和服务的安全访问控制。

## 2. 核心功能与特性

### 2.1 Keycloak 核心功能
- **身份验证与授权**：支持用户名/密码、OAuth 2.0/OpenID Connect、SAML 2.0 等多种认证机制。
- **单点登录（SSO）**：跨多个应用实现一次登录，无需重复认证。
- **用户管理**：支持本地用户存储、LDAP/Active Directory 用户联邦、社交登录（如 Google、GitHub）。
- **角色与权限**：细粒度的角色管理（领域角色、客户端角色）和权限控制。
- **多租户支持**：通过“领域”（Realm）实现多租户隔离。
- **安全增强**：密码策略、双因素认证（2FA）、会话管理、防暴力破解及审计日志。

### 2.2 镜像特性
- **基于 Quarkus**：采用 Keycloak Quarkus 发行版，启动速度快、内存占用低，适合容器化环境。
- **Java 17 运行时**：基于 eclipse-temurin:17（OpenJDK 17），符合现代 Java 应用标准。
- **可扩展性**：支持通过挂载卷或构建自定义镜像添加主题、身份提供商、协议映射器等扩展组件。
- **灵活配置**：通过环境变量、配置文件或命令行参数自定义 Keycloak 行为。

## 3. 使用场景

- **企业应用集成**：为内部系统（如 ERP、CRM）提供统一身份验证和 SSO。
- **SaaS 平台**：作为多租户 SaaS 应用的身份管理服务，隔离租户数据与权限。
- **微服务架构**：为微服务提供集中式认证授权，通过 OAuth 2.0/OpenID Connect 保护 API。
- **开发与测试**：快速搭建本地身份管理服务，验证应用的认证授权流程。
- **合规需求**：满足 GDPR 等数据隐私法规，提供审计日志和细粒度访问控制。

## 4. 使用方法与配置说明

### 4.1 环境变量

Keycloak 支持通过环境变量配置核心参数，常用变量如下表：

| 变量名                  | 描述                                                                 | 默认值          | 示例值                                      |
|-------------------------|----------------------------------------------------------------------|-----------------|---------------------------------------------|
| KEYCLOAK_ADMIN          | 初始管理员用户名                                                     | -               | admin                                       |
| KEYCLOAK_ADMIN_PASSWORD | 初始管理员密码                                                       | -               | secure_password                             |
| KC_DB                   | 数据库类型（支持 h2、postgres、mysql、mssql、oracle）                | h2              | postgres                                    |
| KC_DB_URL               | 数据库连接 URL                                                       | 取决于 KC_DB    | jdbc:postgresql://postgres:5432/keycloak    |
| KC_DB_USERNAME          | 数据库用户名                                                         | -               | keycloak_user                               |
| KC_DB_PASSWORD          | 数据库密码                                                           | -               | keycloak_db_password                        |
| KC_HOSTNAME             | 外部访问的主机名（生产模式必填）                                     | -               | auth.example.com                            |
| KC_HTTP_ENABLED         | 是否启用 HTTP（生产环境建议禁用，仅用 HTTPS）                        | true            | false                                       |
| KC_HTTPS_PORT           | HTTPS 端口                                                           | 8443            | 443                                         |
| KC_HTTPS_CERTIFICATE_FILE | SSL 证书文件路径（容器内路径）                                      | -               | /etc/keycloak/certs/tls.crt                 |
| KC_HTTPS_CERTIFICATE_KEY_FILE | SSL 私钥文件路径（容器内路径）                                    | -               | /etc/keycloak/certs/tls.key                 |
| KC_LOG_LEVEL            | 日志级别（ALL、DEBUG、INFO、WARN、ERROR、OFF）                       | INFO            | DEBUG                                       |

> 注：完整环境变量列表可通过 `docker run --rm dcm4che/keycloak-quarkus:latest start --help` 查看。

### 4.2 Docker 运行示例

#### 4.2.1 开发模式（快速测试）

开发模式使用内置 H2 内存数据库（数据非持久化），自动创建管理员账户，适合快速测试：

```bash
docker run -it --rm \
  -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  docker.xuanyuan.run/dcm4che/keycloak-quarkus:latest \
  start-dev
```

访问 `http://localhost:8080`，使用 `admin/admin` 登录管理控制台。

#### 4.2.2 生产模式（连接 PostgreSQL）

生产环境需配置外部数据库（如 PostgreSQL）和持久化存储，示例如下：

```bash
docker run -d \
  --name keycloak \
  -p 8443:8443 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=secure_password \
  -e KC_DB=postgres \
  -e KC_DB_URL=jdbc:postgresql://postgres-host:5432/keycloak \
  -e KC_DB_USERNAME=keycloak_user \
  -e KC_DB_PASSWORD=keycloak_db_password \
  -e KC_HOSTNAME=auth.example.com \
  -e KC_HTTPS_CERTIFICATE_FILE=/etc/keycloak/certs/tls.crt \
  -e KC_HTTPS_CERTIFICATE_KEY_FILE=/etc/keycloak/certs/tls.key \
  -v /path/to/certs:/etc/keycloak/certs \
  docker.xuanyuan.run/dcm4che/keycloak-quarkus:latest \
  start --optimized
```

### 4.3 Docker Compose 配置示例

以下为 Keycloak + PostgreSQL 的 Docker Compose 配置（`docker-compose.yml`）：

```yaml
version: '3.8'

services:
  postgres:
    image: docker.xuanyuan.run/postgres:15
    container_name: keycloak-db
    environment:
      POSTGRES_DB: keycloak
      POSTGRES_USER: keycloak_user
      POSTGRES_PASSWORD: keycloak_db_password
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

  keycloak:
    image: docker.xuanyuan.run/dcm4che/keycloak-quarkus:latest
    container_name: keycloak
    depends_on:
      - postgres
    ports:
      - "8443:8443"
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: secure_password
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://postgres:5432/keycloak
      KC_DB_USERNAME: keycloak_user
      KC_DB_PASSWORD: keycloak_db_password
      KC_HOSTNAME: auth.example.com
      KC_HTTPS_CERTIFICATE_FILE: /etc/keycloak/certs/tls.crt
      KC_HTTPS_CERTIFICATE_KEY_FILE: /etc/keycloak/certs/tls.key
    volumes:
      - ./certs:/etc/keycloak/certs  # 挂载 SSL 证书
    restart: unless-stopped

volumes:
  postgres-data:
```

启动服务：

```bash
docker-compose up -d
```

### 4.4 持久化配置

Keycloak 数据（用户、领域、客户端等）需通过外部数据库持久化，默认 H2 数据库仅用于开发。支持的数据库及配置示例：

- **PostgreSQL**（推荐）：`KC_DB=postgres`，`KC_DB_URL=jdbc:postgresql://host:5432/dbname`。
- **MySQL/MariaDB**：`KC_DB=mysql`，`KC_DB_URL=jdbc:mysql://host:3306/dbname?useSSL=false`。
- **Microsoft SQL Server**：`KC_DB=mssql`，`KC_DB_URL=jdbc:sqlserver://host:1433;databaseName=dbname`。

## 5. 扩展

### 5.1 添加自定义主题

通过挂载卷将自定义主题目录挂载到容器内的 `/opt/keycloak/themes`：

```bash
docker run -d \
  ... \
  -v /path/to/custom-themes:/opt/keycloak/themes \
  dcm4che/keycloak-quarkus:latest \
  start --optimized
```

### 5.2 添加身份提供商或协议映射器

将自定义提供商 JAR 文件挂载到 `/opt/keycloak/providers`：

```bash
docker run -d \
  ... \
  -v /path/to/providers:/opt/keycloak/providers \
  dcm4che/keycloak-quarkus:latest \
  start --optimized
```

### 5.3 自定义配置文件

挂载自定义 `keycloak.conf` 配置文件（覆盖默认配置）：

```bash
docker run -d \
  ... \
  -v /path/to/keycloak.conf:/opt/keycloak/conf/keycloak.conf \
  dcm4che/keycloak-quarkus:latest \
  start --optimized
```

## 6. 构建自定义镜像

如需预配置主题、提供商或配置，可基于此镜像构建自定义镜像：

### 6.1 创建 Dockerfile

```dockerfile
FROM docker.xuanyuan.run/dcm4che/keycloak-quarkus:latest

# 添加自定义主题
COPY ./custom-themes /opt/keycloak/themes/

# 添加提供商 JAR
COPY ./providers/*.jar /opt/keycloak/providers/

# 添加自定义配置
COPY ./keycloak.conf /opt/keycloak/conf/

# 构建时执行配置（如安装提供商）
RUN /opt/keycloak/bin/kc.sh build
```

### 6.2 构建与运行

```bash
# 构建镜像
docker build -t my-custom-keycloak .

# 运行自定义镜像
docker run -d \
  -p 8443:8443 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=secure_password \
  my-custom-keycloak \
  start --optimized
