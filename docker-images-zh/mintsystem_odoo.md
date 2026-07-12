---
image: mintsystem/odoo
description: "改进版Odoo容器镜像，基于特定修订版本构建，支持通过环境变量配置odoo.conf，使用uv和pnpm管理依赖，可克隆插件仓库并检测嵌套模块，无需root权限运行，包含健康检查及manifestoo等开发工具，适用于Odoo应用部署、模块测试与代码覆盖率报告生成。"
source: https://xuanyuan.cloud/zh/r/mintsystem/odoo
canonical: https://xuanyuan.cloud/zh/r/mintsystem/odoo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mintsystem/odoo" title="mintsystem/odoo Docker 镜像中文简介、标签列表与拉取命令">mintsystem/odoo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Mint System Odoo 镜像文档

[![Docker 拉取量](https://img.shields.io/docker/pulls/mintsystem/odoo)](https://hub.docker.com/r/mintsystem/odoo/)

## 镜像概述

Mint System Odoo 镜像是对官方Odoo镜像的改进版本，基于特定[修订版本](https://odoo.build/revisions.html)构建，确保构建可重复性。该镜像优化了包管理、配置方式、插件处理等核心功能，同时集成多种开发与运维工具，适合Odoo应用的部署、测试及日常管理。

## 核心功能与特性

- **高效包管理**：使用[uv](https://docs.astral.sh/uv/)管理Python依赖，[pnpm](https://pnpm.io/)管理Node依赖
- **灵活配置**：通过环境变量管理`odoo.conf`配置，无需手动修改配置文件
- **插件处理**：支持从Git仓库克隆插件，自动检测嵌套模块文件夹
- **数据库集成**：会话信息可存储于数据库，支持指定模块初始化数据库
- **安全运行**：无需root权限即可运行容器
- **工具集成**：内置[manifestoo](https://github.com/acsone/manifestoo)和[click-odoo-contrib](https://github.com/acsone/click-odoo-contrib)工具
- **镜像优化**：通过多阶段构建和文件清理减小镜像体积
- **健康检查**：内置健康检查机制，确保容器运行状态
- **测试支持**：可运行模块测试并生成代码覆盖率报告

## 源码与更新日志

- 源码：<https://github.com/Mint-System/Odoo-Build/tree/main/images/odoo/>
- 更新日志：<https://odoo.build/images/odoo/CHANGELOG.html>

## 支持的标签

- `19.0.20251008`、`19.0`
- `18.0.20251008`、`18.0`
- `17.0.20251008`、`17.0`
- `16.0.20251008`、`16.0`

## 使用方法

该镜像支持基础配置与高度自定义配置，可通过环境变量灵活调整。

### 最小配置

以下是最小化`compose.yml`配置示例：

```yml
services:
  odoo:
    container_name: odoo
    image: docker.xuanyuan.run/mintsystem/odoo:18.0.20251008
    depends_on:
      - db
    environment:
      PGHOST: db
      PGUSER: odoo
      PGPASSWORD: odoo
    ports:
      - "127.0.0.1:8069:8069"
    volumes:
      - odoo-data:/var/lib/odoo
  db:
    container_name: db
    image: docker.xuanyuan.run/postgres:14-alpine
    environment:
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: odoo
      PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
      - db-data:/var/lib/postgresql/data/pgdata
volumes:
  odoo-data:
  db-data:
```

### 自定义配置

以下`compose.yml`展示完整自定义配置选项：

```yml
services:
  odoo:
    container_name: odoo
    image: docker.xuanyuan.run/mintsystem/odoo:18.0.20251008
    depends_on:
        db:
            condition: service_healthy
    environment:
      PGHOST: db
      PGUSER: odoo
      PGPASSWORD: odoo
      PGPORT: 5432
      DB_NAME: odoo
      DB_MAXCONN: 128
      PGSSLMODE: verify-ca
      PGSSLROOTCERT: /mnt/postgres-secret/ca.crt
      SMTP_SERVER: mail.infomaniak.com
      SMTP_PORT: 587
      SMTP_SSL: True
      SMTP_USER: odoo@yourcompany.com
      SMTP_PASSWORD: **
      EMAIL_FROM: odoo@yourcompany.com
      MAIL_BOUNCE_ALIAS: bounce
      MAIL_CATCHALL_ALIAS: reply
      MAIL_CATCHALL_DOMAIN: yourcompany.com
      MAIL_DEFAULT_FROM: odoo
      MAIL_ALIAS_DOMAIN: yourcompany.com
      ODOO_MAIL_SMTP_HOST: mail.infomaniak.com
      ODOO_MAIL_SMTP_PORT: 587
      ODOO_MAIL_SMTP_ENCRYPTION: starttls
      ODOO_MAIL_SMTP_FROM_FILTER: odoo@yourcompany.com
      ODOO_MAIL_IMAP_HOST: mail.infomaniak.com
      ODOO_MAIL_IMAP_PORT: 993
      ODOO_MAIL_IMAP_SSL: True
      ODOO_MAIL_USERNAME: odoo@yourcompany.com
      ODOO_MAIL_PASSWORD: **
      GIT_SSH_PUBLIC_KEY: "ssh-ed25519 BBBBC3NzaC1lZDI1NTE5BBBBIDR9Ibi0mATjCyx1EYg594oFkY0rghtgo+pnFHOvAcym Mint-System-Project-MCC@github.com"
      GIT_SSH_PRIVATE_KEY: "LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLQpiM0JsYm5OemFDMXJaWGt0ZGpFQUFBQUFCRzV2Ym1VQUFBQUVibTl1WlFBQUFBQUFBQUFCQUFBQU13QUFBQXR6YzJndFpXClF5TlRVeE9RQUFBQ0EwZlNHNHRKZ0U0d3NzZFJHSU9mZUtCWkdOSzRJYllLUHFaeFJ6cndITXBnQUFBS2k1WkJhRnVXUVcKaFFBQUFBdHpjMmd0WldReU5UVXhPUUFBQUNBMGZTRzR0SmdFNHdzc2RSR0lPZmVLQlpTks0SWJZS1BxWnhSenJ3SE1wZwowQkFnTT0KLS0tLS1FTkQgT1BFTlNTSCBQUklWQVRFIEtFWS0tLS0tCg=="
      GITHUB_USERNAME: bot-mintsys
      GITHUB_PAT: **
      GITLAB_URL: https://gitlab.com
      GITLAB_USERNAME: bot-mintsys
      GITLAB_PAT: **
      FORGEJO_URL: https://codeberg.org
      FORGEJO_USERNAME: bot-mintsys
      FORGEJO_PAT: **
      ADDONS_GIT_REPOS: "git@github.com:Mint-System/Odoo-Apps-Server-Tools.git#16.0,git@github.com:OCA/server-tools.git#16.0"
      ODOO_ADDONS_PATH: /mnt/addons/,/mnt/enterprise/,/mnt/oca/,/mnt/themes/
      ODOO_DATABASE: "16.0"
      ODOO_INIT_LOGIN: odoo
      ODOO_INIT_PASSWORD: **
      ODOO_INIT_LANG: de_CH
      ODOO_INIT_ADDONS: server_environment_ir_config_parameter
      RUNNING_ENV: production
      WITHOUT_DEMO: False
      PYTHON_INSTALL: prometheus-client
      SERVER_WIDE_MODULES: session_db,module_change_auto_install
      SESSION_DB_URI: postgres://odoo:odoo@db/16.0
      PROXY_MODE: False
      LOG_LEVEL: debug
      MAX_CRON_THREADS: 4
      LIST_DB: True
      LOG_DB: True
      LOG_HANDLER: [':INFO']
      LOGFILE: None
      ADMIN_PASSWD: **
      DB_FILTER: ^%d$
      WORKERS: 4
      LIMIT_REQUEST: 16384
      LIMIT_TIME_CPU: 300
      LIMIT_TIME_REAL: 600
      LIMIT_MEMORY_HARD: 2684354560
      LIMIT_MEMORY_SOFT: 2147483648
      LIMIT_MEMORY_HARD_GEVENT: 1048579
      LIMIT_MEMORY_SOFT_GEVENT: 1048576
      MODULE_AUTO_INSTALL_DISABLED: odoo_test_xmlrunner
      AUTO_UPDATE_MODULES: True
      TEST_ADDONS_DIR: /mnt/oca/partner-contact
      TEST_INCLUDE: partner_firstname
      TEST_EXCLUDE: partner_fax
      AUTO_UPDATE_TRANSLATIONS: True
      AUTO_UPDATE_MODULES_LIST: True
      ADDITIONAL_ODOO_RC: "syslog = True"
      IR_CONFIG_PARAMETER: "web.base.url = https://odoo.example.com"
    ports:
      - "127.0.0.1:8069:8069"
    volumes:
      - odoo-data:/var/lib/odoo
      - ./addons:/mnt/addons
      - ./oca:/mnt/oca
      - ./enterprise:/mnt/enterprise
      - ./themes:/mnt/themes
  db:
    container_name: db
    image: docker.xuanyuan.run/postgres:14-alpine
    environment:
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: odoo
      PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
      - db-data:/var/lib/postgresql/data/pgdata
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U odoo -d $ODOO_DATABASE"]
      interval: 5s
      timeout: 5s
      retries: 5
volumes:
  odoo-data:
  db-data:
```

## 生命周期

该镜像设计了完整的生命周期管理，包括初始化、启动、执行、分析和测试阶段。

### 初始化

容器启动前可通过以下脚本初始化数据库和插件：

- **下载Odoo企业版模块**：
  ```bash
  docker compose exec odoo download-git-archive
  ```

- **克隆插件仓库**：
  ```bash
  docker compose exec odoo clone-git-addons
  ```

- **初始化Odoo数据库**：
  ```bash
  docker compose exec odoo init-db
  ```

### 启动

容器启动时，`entrypoint.sh`脚本将自动执行以下步骤：

1. 调用`aggregate-git-repos`克隆模块仓库
2. 执行`template-odoo-rc`生成`odoo.conf`配置文件
3. 通过`set-addons-path`组装插件路径
4. 运行`install-python-packages`安装Python依赖
5. 等待数据库就绪
6. 若启用，执行`update-modules`更新模块
7. 若启用，执行`update-modules-list`更新模块列表
8. 若启用，执行`update-translations`更新翻译
9. 启动Odoo服务

### 执行

容器运行中可执行以下操作管理模块：

- **安装模块**：
  ```bash
  docker compose exec odoo init-module partner_firstname
  ```

- **更新指定模块**：
  ```bash
  docker compose exec odoo update-module partner_firstname
  ```

- **更新所有模块**：
  ```bash
  docker compose exec odoo update-modules
  ```

- **更新模块列表**：
  ```bash
  docker compose exec odoo update-modules-list
  ```

- **更新翻译**：
  ```bash
  docker compose exec odoo update-translations
  ```

### 分析

使用内置`manifestoo`工具查询模块清单文件，例如列出所有模块：

```bash
docker exec odoo bash -c "manifestoo --select-found list --separator=,"
```

### 测试

执行以下步骤运行模块测试并生成覆盖率报告：

1. **准备测试环境**：
   ```bash
   docker exec odoo setup-tests
   ```

2. **运行测试**：
   ```bash
   docker exec odoo run-tests
   ```

## 环境变量配置

### 数据库连接

| 变量名              | 描述                     | 默认值          |
|---------------------|--------------------------|-----------------|
| `PGHOST`            | 数据库容器名称           | -               |
| `PGUSER`            | 数据库用户名             | -               |
| `PGPASSWORD`        | 数据库用户密码           | -               |
| `PGPORT`            | PostgreSQL端口           | `5432`          |
| `DB_NAME`           | 数据库名称               | -               |
| `DB_MAXCONN`        | 最大数据库连接数         | `64`            |
| `PGSSLMODE`         | SSL连接模式              | `prefer`        |
| `PGSSLROOTCERT`     | SSL根证书路径            | -               |

### SMTP服务器

| 变量名              | 描述                     | 默认值          |
|---------------------|--------------------------|-----------------|
| `SMTP_SERVER`       | SMTP服务器地址           | -               |
| `SMTP_PORT`         | SMTP端口                 | -               |
| `SMTP_SSL`          | 是否启用SSL              | -               |
| `SMTP_USER`         | SMTP用户名               | -               |
| `SMTP_PASSWORD`     | SMTP密码                 | -               |
| `EMAIL_FROM`        | 发件人邮箱               | -               |

### 邮件系统参数

| 变量名                          | 描述                     | 默认值          |
|---------------------------------|--------------------------|-----------------|
| `MAIL_BOUNCE_ALIAS`             | 退信别名                 | -               |
| `MAIL_CATCHALL_ALIAS`           | 回复别名                 | -               |
| `MAIL_CATCHALL_DOMAIN`          | 回复域名                 | -               |
| `MAIL_DEFAULT_FROM`             | 默认发件人名称           | `odoo`          |
| `MAIL_ALIAS_DOMAIN`             | 别名域名                 | -               |

### 邮件服务器配置（数据库级）

| 变量名                          | 描述                     | 默认值          |
|---------------------------------|--------------------------|-----------------|
| `ODOO_MAIL_SMTP_HOST`           | SMTP主机                 | -               |
| `ODOO_MAIL_SMTP_PORT`           | SMTP端口                 | `587`           |
| `ODOO_MAIL_SMTP_ENCRYPTION`     | 加密方式                 | `starttls`      |
| `ODOO_MAIL_SMTP_FROM_FILTER`    | 发件人过滤               | `""`            |
| `ODOO_MAIL_IMAP_HOST`           | IMAP主机                 | -               |
| `ODOO_MAIL_IMAP_PORT`           | IMAP端口                 | `993`           |
| `ODOO_MAIL_IMAP_SSL`            | 是否启用IMAP SSL         | `True`          |
| `ODOO_MAIL_USERNAME`            | 邮箱用户名               | -               |
| `ODOO_MAIL_PASSWORD`            | 邮箱密码                 | -               |

### 模块仓库配置

| 变量名                          | 描述                                                                 | 默认值                          |
|---------------------------------|----------------------------------------------------------------------|---------------------------------|
| `GIT_SSH_PUBLIC_KEY`            | SSH公钥，用于Git克隆                                                 | -                               |
| `GIT_SSH_PRIVATE_KEY`           | Base64编码的SSH私钥（生成方式：`cat ~/.ssh/id_ed2551 | base64 -w0`） | -                               |
| `GITHUB_USERNAME`               | GitHub用户名                                                        | -                               |
| `GITHUB_PAT`                    | GitHub访问令牌                                                      | -                               |
| `GITLAB_URL`                    | GitLab实例URL                                                       | `https://gitlab.com`            |
| `GITLAB_USERNAME`               | GitLab用户名                                                        | -                               |
| `GITLAB_PAT`                    | GitLab访问令牌                                                      | -                               |
| `FORGEJO_URL`                   | Forgejo实例URL                                                      | `https://codeberg.org`          |
| `FORGEJO_USERNAME`              | Forgejo用户名                                                       | -                               |
| `FORGEJO_PAT`                   | Forgejo访问令牌                                                     | -                               |
| `ADDONS_GIT_REPOS`              | 逗号分隔的Git仓库列表（格式：`仓库URL#分支`）                        | -                               |

### 插件路径

| 变量名              | 描述                     | 默认值                                                                 |
|---------------------|--------------------------|------------------------------------------------------------------------|
| `ODOO_ADDONS_PATH`  | 插件路径列表（逗号分隔） | `/mnt/extra-addons,/opt/odoo/enterprise,/var/lib/odoo/git,$TEST_ADDONS_DIR,/opt/odoo/addons` |

### 数据库初始化

| 变量名                  | 描述
