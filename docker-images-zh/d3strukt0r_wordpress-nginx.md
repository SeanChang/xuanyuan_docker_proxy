---
image: d3strukt0r/wordpress-nginx
description: "该Docker镜像提供WordPress网站的Nginx+PHP部署环境，支持自定义配置、数据持久化与Docker Secrets集成，帮助快速搭建稳定的WordPress站点。"
source: https://xuanyuan.cloud/zh/r/d3strukt0r/wordpress-nginx
canonical: https://xuanyuan.cloud/zh/r/d3strukt0r/wordpress-nginx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/d3strukt0r/wordpress-nginx" title="d3strukt0r/wordpress-nginx Docker 镜像中文简介、标签列表与拉取命令">d3strukt0r/wordpress-nginx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# WordPress-Nginx Docker镜像

## 镜像概述
这是一个用于快速部署WordPress网站的Docker镜像，集成Nginx和PHP运行环境，支持灵活的配置选项与数据持久化，适用于个人博客、企业官网等各类WordPress站点的搭建需求。

## 核心功能
- 集成Nginx和PHP组件，满足WordPress运行的基础环境要求
- 支持通过环境变量自定义PHP配置（如执行时间、内存限制、上传大小等）
- 提供数据库连接配置，支持Docker Secrets安全存储敏感信息（如数据库密码、WordPress密钥）
- 包含插件和主题安装脚本，方便扩展站点功能
- 支持数据卷挂载，实现上传文件、主题、插件等数据的持久化

## 使用场景
- 个人博客或自媒体站点的快速搭建
- 企业官网或产品展示站点的部署
- 开发环境中WordPress站点的测试与调试
- 小型内容管理系统（CMS）的搭建

## 配置说明
### 环境变量
#### PHP相关变量
- `PHP_MAX_EXECUTION_TIME`：PHP请求最大执行时间（默认：100秒）
- `PHP_MEMORY_LIMIT`：PHP内存限制（默认：256M）
- `PHP_POST_MAX_SIZE`：POST请求最大大小（默认：100M，需与Nginx保持一致）
- `PHP_UPLOAD_MAX_FILESIZE`：单文件上传最大大小（默认：100M）

#### 数据库相关变量
- `DB_HOST`：数据库主机（默认：db）
- `DB_PORT`：数据库端口（默认：3306）
- `DB_USER`：数据库用户名（默认：root）
- `DB_PASSWORD`：数据库密码（必填）
- `DB_NAME`：数据库名称（默认：wordpress）
- `DB_CHARSET`：数据库字符集（默认：utf8mb4）
- `DB_COLLATE`：数据库排序规则（默认：utf8mb4_unicode_ci）
- `DB_TABLE_PREFIX`：数据库表前缀（默认：wp_，不能为空）

#### WordPress密钥变量（均为必填）
- `WP_AUTH_KEY`、`WP_SECURE_AUTH_KEY`、`WP_LOGGED_IN_KEY`、`WP_NONCE_KEY`
- `WP_AUTH_SALT`、`WP_SECURE_AUTH_SALT`、`WP_LOGGED_IN_SALT`、`WP_NONCE_SALT`

#### 其他WordPress变量
- `WP_DEBUG`：是否开启调试模式（默认：false）

#### Nginx相关变量
- `NGINX_CLIENT_MAX_BODY_SIZE`：客户端请求最大大小（默认：100M，需与PHP保持一致）
- `USE_HTTPS`：是否启用HTTPS（不推荐，建议使用Traefik等反向代理）

### 数据卷
- `/app`：WordPress所有数据存储目录
- `/app/wp-content/uploads`：用户上传文件目录（推荐挂载以持久化数据）
- `/app/wp-content`：主题、插件等扩展目录

### 部署示例
#### PHP容器运行命令
```shell
docker run \
    -v $PWD/uploads:/app/wp-content/uploads \
    -e DB_PASSWORD=your_db_password \
    -e WP_AUTH_KEY=your_auth_key \
    -e WP_SECURE_AUTH_KEY=your_secure_auth_key \
    -e WP_LOGGED_IN_KEY=your_logged_in_key \
    -e WP_NONCE_KEY=your_nonce_key \
    -e WP_AUTH_SALT=your_auth_salt \
    -e WP_SECURE_AUTH_SALT=your_secure_auth_salt \
    -e WP_LOGGED_IN_SALT=your_logged_in_salt \
    -e WP_NONCE_SALT=your_nonce_salt \
    docker.xuanyuan.run/d3strukt0r/wordpress-php
```

#### Nginx容器运行命令
```shell
docker run \
    -p 80:80 \
    -v $PWD/uploads:/app/wp-content/uploads \
    docker.xuanyuan.run/d3strukt0r/wordpress-nginx
```

## 构建工具
- [WordPress](https://wordpress.org/)：核心网站系统
- [GitHub Actions](https://github.com/features/actions)：自动化CI/CD流程
- [Docker](https://www.docker.com/)：容器化部署工具

## 相关链接
- [GitHub仓库](https://github.com/D3strukt0r/docker-wordpress)
- [Docker Hub镜像](https://hub.docker.com/r/d3strukt0r/wordpress)

## 许可证
本项目采用GNU General Public License v3.0许可证，详情请查看[LICENSE.txt](https://github.com/D3strukt0r/docker-wordpress/blob/master/LICENSE.txt)。
