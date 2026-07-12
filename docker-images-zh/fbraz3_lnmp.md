---
image: fbraz3/lnmp
description: "这是一款易于使用的LNMP/LEMP镜像，其中包含Ubuntu Linux操作系统、Nginx网页服务器、MySQL数据库系统、PHP-FPM以及PHPMyAdmin数据库管理工具，可帮助用户快速部署和高效管理Web开发及运行环境。"
source: https://xuanyuan.cloud/zh/r/fbraz3/lnmp
canonical: https://xuanyuan.cloud/zh/r/fbraz3/lnmp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/fbraz3/lnmp" title="fbraz3/lnmp Docker 镜像中文简介、标签列表与拉取命令">fbraz3/lnmp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### Braz LEMP Docker 镜像介绍


[![构建基础镜像] ] 
[![构建 Phalcon 镜像] ] 
[![DeepWiki 咨询] ] 


本仓库提供 LNMP 技术栈（`L`inux、`N`ginx、`M`ariaDB、`P`HP-FPM，通常也称 LEMP）的 Docker 镜像。该镜像旨在简化 PHP 应用的部署流程，提供稳定且现代化的运行环境，同时区分**开发版**和**生产版**以满足不同场景需求。镜像基于 `fbraz3` 生态的模块化镜像构建，确保灵活性、可维护性和易用性。

💡 完整镜像列表可查看 [PHP 系统文档] 。


## 目录

- [Braz LEMP Docker 镜像介绍](#braz-lemp-docker-镜像介绍)
  - [镜像版本](#镜像版本)
  - [标签说明](#标签说明)
  - [镜像类型](#镜像类型)
  - [使用方法](#使用方法)
    - [开发版使用](#开发版使用)
    - [生产版使用](#生产版使用)
  - [自定义 SQL 脚本](#自定义-sql-脚本)
  - [安全注意事项](#安全注意事项)
  - [环境变量配置](#环境变量配置)
  - [通过环境变量管理 PHP 配置项](#通过环境变量管理-php-配置项)
  - [定时任务（Cronjobs）](#定时任务cronjobs)
  - [邮件发送配置](#邮件发送配置)
  - [贡献指南](#贡献指南)
  - [捐赠支持](#捐赠支持)
  - [许可协议](#许可协议)


## 镜像版本

项目提供两种独立版本，适配不同使用场景：


### 开发版（带 `-dev` 后缀）
- **用途**：本地开发与测试环境
- **特点**：
  - MariaDB 无 root 密码（空密码）
  - 可通过 `/pma/` 路径访问 phpMyAdmin
  - 宽松的安全配置，便于开发调试
  - 数据库可直接无密码访问


### 生产版（无后缀）
- **用途**：生产环境优化配置
- **特点**：
  - MariaDB 强制要求配置 root 密码
  - **密码安全强制校验**：使用默认密码时容器启动失败
  - **支持自定义 SQL 脚本**：启动时自动执行 SQL 文件
  - **不含 phpMyAdmin**，提升安全性
  - 数据库安全配置加固
  - 支持通过环境变量配置 root 密码
  - 移除匿名用户及测试数据库
  - 增强安全防护设置


## 标签说明

镜像采用统一的标签命名规则：


### 基础镜像（标准 LNMP 栈）
- **生产版**：`fbraz3/lnmp:{php_version}`（如 `8.2`、`8.3`、`8.4`）
- **开发版**：`fbraz3/lnmp:{php_version}-dev`（如 `8.2-dev`、`8.3-dev`）


### Phalcon 镜像（含 Phalcon 框架）
- **生产版**：`fbraz3/lnmp:{php_version}-phalcon`（如 `8.2-phalcon`、`8.3-phalcon`）
- **开发版**：`fbraz3/lnmp:{php_version}-phalcon-dev`（如 `8.2-phalcon-dev`）


### 最新版本标签
- `fbraz3/lnmp:latest` - 最新生产版
- `fbraz3/lnmp:latest-dev` - 最新开发版  
- `fbraz3/lnmp:latest-phalcon` - 最新 Phalcon 生产版
- `fbraz3/lnmp:latest-phalcon-dev` - 最新 Phalcon 开发版


### 架构支持
- 所有镜像均支持 `amd64` 和 `arm64` 架构
- 也可通过 `fbraz3/lemp:{tag}` 获取 LEMP 变体镜像


## 镜像类型

镜像提供多种类型，满足不同需求：

- **标准版**：基础 LNMP 栈，无额外框架
- **Phalcon 版**：预装 Phalcon PHP 框架


## 使用方法


### 开发版使用

适合本地开发，提供便捷的数据库访问和调试工具。

```yaml
# docker-compose.yml
services:
  web:
    image: docker.xuanyuan.run/fbraz3/lnmp:8.4-dev  # 或 fbraz3/lnmp:8.4-phalcon-dev（Phalcon 版）
    volumes:
      - ./:/app/public/  # 挂载项目代码到容器
    ports:
      - "127.0.0.1:80:80"    # 绑定本地 80 端口
      - "127.0.0.1:3306:3306"  # 绑定本地数据库端口
```

**访问入口**：
- 应用：`[] phpMyAdmin：`[] 数据库：`localhost:3306`（用户：`root`，密码：空）


### 生产版使用

安全配置，适合生产环境部署。

```yaml
# docker-compose.yml
services:
  web:
    image: docker.xuanyuan.run/fbraz3/lnmp:8.4  # 或 fbraz3/lnmp:8.4-phalcon（Phalcon 版）
    environment:
      - MYSQL_ROOT_PASSWORD=your_secure_password_here  # 必须设置强密码
      - MYSQL_APP_DATABASE=my_application  # 可选：自动创建应用数据库
      - MYSQL_APP_USER=app_user            # 可选：自动创建应用用户
      - MYSQL_APP_USER_PASSWD=app_password # 可选：应用用户密码
    volumes:
      - ./:/app/public/        # 挂载项目代码
      - mysql_data:/var/lib/mysql  # 数据卷持久化数据库数据
    ports:
      - "80:80"  # 对外暴露 80 端口
    restart: unless-stopped  # 异常退出时自动重启

volumes:
  mysql_data:  # 定义数据卷
```

**访问入口**：
- 应用：`[] 数据库：仅容器内部访问（用户：`root`，密码：通过环境变量设置）

**注意**：生产环境务必设置高强度 `MYSQL_ROOT_PASSWORD`！


## 自定义 SQL 脚本

生产版镜像支持启动时执行自定义 SQL 脚本，便于初始化数据库 schema、基础数据或配置。


### 使用步骤

1. **准备 SQL 文件**：将 `.sql` 脚本文件放在宿主机目录中
2. **挂载脚本目录**：将宿主机脚本目录挂载到容器的 `/sql-scripts` 路径
3. **自动执行**：容器首次启动时会按顺序执行所有 `.sql` 文件


### 示例配置

```yaml
# docker-compose.yml（片段）
services:
  web:
    image: docker.xuanyuan.run/fbraz3/lnmp:8.4
    environment:
      - MYSQL_ROOT_PASSWORD=your_secure_password_here
    volumes:
      - ./:/app/public/
      - ./sql-scripts:/sql-scripts  # 挂载自定义 SQL 脚本目录
      - mysql_data:/var/lib/mysql
    # 其他配置...
```

**目录结构示例**：
```
project/
├── sql-scripts/          # SQL 脚本目录
│   ├── 01-create-users.sql  # 01-前缀控制执行顺序
│   ├── 02-create-tables.sql
│   └── 03-insert-data.sql
└── docker-compose.yml
```


### 注意事项

- SQL 脚本**仅在首次启动**（数据库初始化时）执行
- 脚本按**文件名字母顺序**执行，建议用数字前缀（如 `01-`、`02-`）控制顺序
- 所有脚本以 root 权限执行
- 该功能**仅生产版支持**，保障开发环境灵活性


## 安全注意事项


### 开发版
- ⚠️ **切勿在生产环境使用开发版镜像**
- 数据库无密码保护
- phpMyAdmin 直接暴露访问
- 仅适用于本地开发场景


### 生产版
- ✅ 默认安全配置
- 强制要求 root 密码
- 不含 phpMyAdmin 管理界面
- 移除匿名用户及测试数据库
- 数据库仅监听容器内部网络


## 环境变量配置


### 生产版镜像环境变量

| 变量名                  | 是否必填 | 默认值                | 说明                              |
|-------------------------|----------|-----------------------|-----------------------------------|
| `MYSQL_ROOT_PASSWORD`   | 是       | `defaultrootpassword` | MariaDB root 用户密码             |
| `MYSQL_APP_DATABASE`    | 否       | -                     | 自动创建的应用数据库名称          |
| `MYSQL_APP_USER`        | 否       | -                     | 自动创建的应用数据库用户          |
| `MYSQL_APP_USER_PASSWD` | 否       | -                     | 应用数据库用户密码                |

**示例**：
```bash
docker run -e MYSQL_ROOT_PASSWORD=mySecurePassword123 \
           -e MYSQL_APP_DATABASE=my_app \
           -e MYSQL_APP_USER=app_user \
           -e MYSQL_APP_USER_PASSWD=app_secure_password \
           docker.xuanyuan.run/fbraz3/lnmp:8.4
```

**说明**：
- 若同时提供 `MYSQL_APP_USER` 和 `MYSQL_APP_USER_PASSWD`，则用户会被授予 `MYSQL_APP_DATABASE` 数据库的全部权限（需同时设置 `MYSQL_APP_DATABASE`）。
- **重要**：`MYSQL_APP_USER` 和 `MYSQL_APP_USER_PASSWD` 必须同时设置，不支持无密码用户。


### 开发版镜像

开发版无需额外环境变量，开箱即用。


## 通过环境变量管理 PHP 配置项

镜像支持通过环境变量自定义 PHP 配置参数。

详细配置方法参考 [php-fpm-docker 文档] 。


## 定时任务（Cronjobs）

可通过挂载文件到容器 `/cronfile` 路径配置定时任务，系统会自动安装并执行任务。

具体配置步骤参考 [php-fpm-docker 文档] 。


## 邮件发送配置

邮件发送功能依赖 `php-base-docker` 项目的配置。

配置方法参考 [php-base-docker 文档] 。


## 贡献指南

欢迎参与项目贡献！可提交 issue 反馈问题或 PR 改进代码。

贡献前请参考 [CONTRIBUTING.md](CONTRIBUTING.md) 指南。

#### 参考链接
- [如何创建 PR] 
- [如何提交 issue] 


## 捐赠支持

维护该项目耗费了大量时间和精力。如果觉得有用，欢迎通过以下方式支持：
- [GitHub Sponsor] 
- [Patreon] 


## 许可协议

本项目基于 [Apache License 2.0](LICENSE) 许可，可用于个人及商业项目。请注意，镜像按"原样"提供，不提供任何明示或暗示的担保。使用前请自行评估风险。
