<!-- xuanyuan-docker-images-zh
image: lldap/lldap
source: https://xuanyuan.cloud/zh/r/lldap/lldap
canonical: https://xuanyuan.cloud/zh/r/lldap/lldap
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [lldap/lldap — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/lldap/lldap "lldap/lldap Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/lldap/lldap

# lldap - 轻量级LDAP认证实现

## 镜像概述和主要用途

lldap是一个轻量级认证服务器，提供简化的LDAP接口用于身份验证。它并非完整的LDAP服务器，而是一个专注于用户管理的系统，旨在为自托管服务提供简单的LDAP认证源。该项目目标是解决传统LDAP服务器（如OpenLDAP）配置复杂、管理困难的问题，提供开箱即用的身份验证解决方案。

lldap主要作为用户信息的可信源，可与KeyCloak、Authelia等组件集成，为Nextcloud、Airsonic等开源服务提供LDAP认证支持。数据默认存储于SQLite数据库，也可切换至MySQL/MariaDB或PostgreSQL。

## 核心功能和特性

- **简单部署**：无需配置复杂的`slapd`服务，开箱即用
- **直观管理**：友好的Web界面，简化用户和组管理
- **低资源占用**：轻量级设计，适合资源受限环境
- **用户自助服务**：支持用户编辑个人信息和通过邮件重置密码
- **Web管理界面**：提供直观的用户、组和权限管理功能
- **灵活的数据存储**：默认使用SQLite，可切换至MySQL/MariaDB或PostgreSQL
- **细粒度权限控制**：内置管理员组(`lldap_admin`)、只读组(`lldap_strict_readonly`)和密码管理组(`lldap_password_manager`)
- **LDAP兼容性**：支持标准LDAP认证流程和`memberOf`组 membership查询
- **安全设计**：默认非root运行，提供rootless容器镜像

## 使用场景和适用范围

lldap主要面向自托管服务器场景，特别适合需要LDAP认证支持的开源服务集成，例如：

- 个人或小型团队的自托管服务集群
- 需要集中用户管理的多服务环境
- 仅支持LDAP认证的应用（如Nextcloud、Airsonic等）
- 作为KeyCloak、Authelia等认证服务的用户数据源
- 希望简化LDAP配置的IT环境

不适用于需要完整LDAP功能集的企业级场景，此类需求建议使用OpenLDAP等全功能LDAP服务器。

## Docker部署方案

### 基本Docker Run命令

#### 标准镜像（带权限调整）

```bash
docker run -d \
  --name lldap \
  -p 3890:3890 \  # LDAP端口
  -p 8080:8080 \  # Web管理界面端口
  -v ./data:/data \
  -e LLDAP_HTTP_PORT=8080 \
  -e LLDAP_LDAP_PORT=3890 \
  -e LLDAP_BASE_DN=dc=example,dc=com \
  -e LLDAP_ADMIN_PASSWORD=super_secret_password \
  -e LLDAP_USER_UID=1000 \
  -e LLDAP_USER_GID=1000 \
  lldap/lldap:latest
```

#### Rootless镜像（直接以指定用户运行）

```bash
docker run -d \
  --name lldap \
  -p 3890:3890 \
  -p 8080:8080 \
  -v ./data:/data \
  --user 1000:1000 \
  -e LLDAP_HTTP_PORT=8080 \
  -e LLDAP_LDAP_PORT=3890 \
  -e LLDAP_BASE_DN=dc=example,dc=com \
  -e LLDAP_ADMIN_PASSWORD=super_secret_password \
  lldap/lldap:latest-rootless
```

### Docker Compose配置

```yaml
version: '3.8'

services:
  lldap:
    image: lldap/lldap:latest
    container_name: lldap
    ports:
      - "3890:3890"  # LDAP端口
      - "8080:8080"  # Web界面端口
    volumes:
      - ./data:/data  # 数据持久化
    environment:
      - LLDAP_BASE_DN=dc=example,dc=com  # 基础DN
      - LLDAP_ADMIN_PASSWORD=your_secure_password  # 管理员密码
      - LLDAP_HTTP_PORT=8080  # Web服务端口
      - LLDAP_LDAP_PORT=3890  # LDAP服务端口
      - LLDAP_USER_UID=1000  # 运行用户UID（标准镜像）
      - LLDAP_USER_GID=1000  # 运行用户GID（标准镜像）
      - LLDAP_LOG_LEVEL=info  # 日志级别：trace, debug, info, warn, error
      # 数据库配置（默认SQLite，如需MySQL/PostgreSQL取消注释）
      # - LLDAP_DATABASE_URL=mysql://user:pass@mysql:3306/lldap
      # SMTP配置（用于密码重置）
      # - LLDAP_SMTP_FROM=admin@example.com
      # - LLDAP_SMTP_HOST=smtp.example.com
      # - LLDAP_SMTP_PORT=587
      # - LLDAP_SMTP_USER=smtp_user
      # - LLDAP_SMTP_PASSWORD=smtp_pass
      # - LLDAP_SMTP_TLS=true
    restart: unless-stopped
    networks:
      - lldap-network  # 与其他服务共享的网络

networks:
  lldap-network:
    driver: bridge
```

### 环境变量说明

| 环境变量                | 描述                                                                 | 默认值                                  |
|-------------------------|----------------------------------------------------------------------|-----------------------------------------|
| `LLDAP_BASE_DN`         | LDAP基础DN（域名组件）                                                | `dc=example,dc=com`                     |
| `LLDAP_ADMIN_PASSWORD`  | 管理员密码（用于Web界面和LDAP绑定）                                   | 无（必须设置）                          |
| `LLDAP_HTTP_PORT`       | Web管理界面监听端口                                                  | `8080`                                  |
| `LLDAP_LDAP_PORT`       | LDAP服务监听端口                                                     | `3890`                                  |
| `LLDAP_USER_UID`        | 运行用户UID（仅标准镜像需要）                                         | `1000`                                  |
| `LLDAP_USER_GID`        | 运行用户GID（仅标准镜像需要）                                         | `1000`                                  |
| `LLDAP_DATABASE_URL`    | 数据库连接URL（支持SQLite/MySQL/PostgreSQL）                          | `sqlite:///data/lldap.db`               |
| `LLDAP_LOG_LEVEL`       | 日志级别                                                             | `info`                                  |
| `LLDAP_SMTP_*`          | SMTP相关配置（`FROM`、`HOST`、`PORT`、`USER`、`PASSWORD`、`TLS`）    | 无（可选，用于密码重置邮件）            |
| `LLDAP_DISABLE_EMAIL`   | 禁用邮件功能（密码重置等）                                           | `false`                                 |

## 使用方法和配置说明

### 基本使用流程

1. **初始化访问**：部署完成后，通过`http://<ip>:8080`访问Web管理界面
2. **管理员登录**：使用默认管理员DN `cn=admin,ou=people,dc=example,dc=com` 和设置的`LLDAP_ADMIN_PASSWORD`登录
3. **用户管理**：通过Web界面创建/编辑用户、组及权限
4. **客户端配置**：配置需要LDAP认证的服务连接到lldap

### Web界面管理

Web界面提供以下核心功能：
- 用户管理：创建、编辑、删除用户，设置密码和属性
- 组管理：创建组、管理组成员、分配权限
- 属性管理：自定义用户属性（满足特定服务需求）
- 配置管理：调整基本设置、SMTP配置、数据库连接等

### 用户自助服务

普通用户可通过Web界面：
- 查看和编辑个人信息
- 更改密码
- 通过邮件请求密码重置（需配置SMTP）

### 客户端配置指南

#### 通用LDAP连接参数

| 参数                | 值示例                                                   | 说明                                  |
|---------------------|---------------------------------------------------------|---------------------------------------|
| LDAP服务器地址      | `ldap://lldap:3890`                                     | 容器内使用服务名，外部使用IP:端口      |
| 绑定DN              | `cn=admin,ou=people,dc=example,dc=com`                   | 管理员DN（或只读用户DN）              |
| 绑定密码            | `your_secure_password`                                  | 对应DN的密码                          |
| 用户搜索基准        | `ou=people,dc=example,dc=com`                           | 用户条目所在位置                      |
| 用户搜索过滤器      | `(uid={{username}})` 或 `(mail={{username}})`           | 根据用户名或邮箱搜索用户              |
| 组搜索基准          | `ou=groups,dc=example,dc=com`                           | 组条目所在位置                        |
| 组成员属性          | `memberOf`                                              | 用于检查用户所属组                    |

#### 只读用户配置

为提高安全性，建议为客户端服务创建只读用户：
1. 在Web界面创建专用用户（如`ldap-readonly`）
2. 将用户添加到`lldap_strict_readonly`组
3. 使用此用户的DN和密码配置客户端服务

#### 示例：Nextcloud LDAP配置

```
服务器：ldap://lldap:3890
端口：3890
用户DN：cn=ldap-readonly,ou=people,dc=example,dc=com
密码：readonly_password
基准DN：ou=people,dc=example,dc=com
用户过滤：(uid=%uid)
```

### 推荐架构

#### 容器化部署架构

```
[反向代理 (Nginx/Traefik)] <---> [认证服务 (Authelia/KeyCloak)] <---> [lldap]
                                          ^
                                          |
[其他服务 (Nextcloud, *arr等)] ------------+
```

#### 网络配置建议

- 创建专用网络（如`lldap-network`）连接lldap和依赖服务
- LDAP端口（3890）仅在内部网络暴露，不直接对外开放
- Web端口（8080）通过反向代理暴露，并配置HTTPS
- 使用rootless镜像并正确设置数据目录权限

#### 数据持久化

- 确保`/data`目录正确挂载为持久卷
- 定期备份数据目录（特别是使用SQLite时）
- 生产环境建议使用MySQL/MariaDB或PostgreSQL作为后端数据库

## 已知兼容服务

大多数支持LDAP认证的服务均可与lldap配合使用，已验证的包括：
- Nextcloud
- Authelia
- KeyCloak
- Jellyfin
- Gitea
- GitLab
- Home Assistant
- Linux PAM（通过nslcd）

详细配置示例可参考[lldap官方示例配置库](https://github.com/lldap/lldap/tree/master/example_configs)。

## 不兼容服务

- **Synology DSM**：需要直接访问密码哈希，与lldap的安全设计冲突
- 部分需要修改LDAP schema或高级LDAP功能的企业级应用

## 常见问题解答

### 如何迁移数据库后端？

1. 停止lldap服务
2. 配置新数据库连接（`LLDAP_DATABASE_URL`）
3. 启动服务，系统会自动迁移数据结构（数据需手动迁移）

### 如何启用LDAPS？

lldap本身不直接支持LDAPS，建议通过反向代理（如Nginx）终止SSL，配置示例：

```nginx
server {
  listen 636 ssl;
  ssl_certificate /cert.pem;
  ssl_certificate_key /key.pem;
  location / {
    proxy_pass ldap://lldap:3890;
  }
}
```

### 如何实现用户/组的自动化管理？

- 使用[bootstrap.sh脚本](https://github.com/lldap/lldap/blob/master/scripts/bootstrap.sh)从配置文件同步用户/组
- 使用[Terraform Provider](https://registry.terraform.io/providers/tasansga/lldap/latest)进行基础设施即代码管理
- 通过GraphQL API编写自定义脚本（详见[脚本指南](https://github.com/lldap/lldap/blob/master/docs/scripting.md)）

## 贡献指南

欢迎通过GitHub提交PR或报告问题。贡献前请确保：
- 运行`cargo fmt`格式化代码（针对Rust代码贡献）
- 修改GraphQL接口后运行`./export_schema.sh`更新 schema
- 保持友好和尊重的沟通态度

项目地址：[https://github.com/lldap/lldap](https://github.com/lldap/lldap)
