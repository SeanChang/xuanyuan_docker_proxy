---
image: bitnami/wordpress
description: "Bitnami Secure Image for WordPress是由Bitnami提供的适用于WordPress的安全优化镜像，其集成预配置的安全防护设置、自动漏洞更新机制、SSL证书支持及基础防火墙功能，可有效降低恶意攻击与数据泄露风险，同时优化服务器资源分配与运行性能，确保WordPress网站快速稳定部署，且兼容主流云平台与本地服务器环境，为用户提供开箱即用的安全可靠建站解决方案。"
source: https://xuanyuan.cloud/zh/r/bitnami/wordpress
canonical: https://xuanyuan.cloud/zh/r/bitnami/wordpress
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/wordpress" title="bitnami/wordpress Docker 镜像中文简介、标签列表与拉取命令">bitnami/wordpress — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/wordpress" title="bitnami/wordpress Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/wordpress</a>

# Bitnami WordPress 软件包


## 简介

> WordPress 是全球最流行的博客及内容管理平台。功能强大且操作简单，从学生到跨国企业，都用它搭建美观、实用的网站。

[WordPress 概览]([])


## 快速启动

```console
docker run --name wordpress bitnami/wordpress:latest
```

**注意**：此快速设置仅适用于开发环境。建议修改不安全的默认凭据，并参考[环境变量](#环境变量)部分的配置选项，以实现更安全的部署。

这是由 Bitnami 构建和维护的精简、强化 CVE 镜像。Bitnami 安全镜像基于云优化、安全强化的企业级 [Photon Linux 操作系统]([])。选择 BSI 镜像的理由：  
- 主流开源软件的强化安全镜像，漏洞数量接近零  
- 漏洞分类与优先级划分，含 VEX 声明、KEV 和 EPSS 评分  
- 合规性支持，包括 FIPS、STIG 和离线部署选项，附安全物料清单（SBOM）  
- 通过 in-toto 提供软件供应链来源证明  
- 全面支持主流 Helm 图表  

每个镜像均附带安全元数据，可在[公开目录]([])中查看。注：部分数据需[订阅 BSI 商业版]([])方可获取。  

如需基于 Debian Linux 的旧版镜像，请查看 Bitnami Legacy 仓库。


## 配置

### 环境变量

#### 可自定义环境变量

| 名称                                             | 描述                                                                                                                                                                                                 | 默认值                                          |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| `WORDPRESS_DATA_TO_PERSIST`                      | 相对于 WordPress 安装目录需持久化的文件。若需指定多个值，用空格分隔。                                                                                                                                  | `wp-config.php wp-content`                      |
| `WORDPRESS_ENABLE_HTTPS`                         | 是否默认启用 WordPress 的 HTTPS。                                                                                                                                                                     | `no`                                            |
| `WORDPRESS_BLOG_NAME`                            | WordPress 博客名称。                                                                                                                                                                                  | `"User's blog"`                                 |
| `WORDPRESS_SCHEME`                               | 生成应用 URL 的协议。已被`WORDPRESS_ENABLE_HTTPS`取代。                                                                                                                                                | `http`                                          |
| `WORDPRESS_HTACCESS_OVERRIDE_NONE`               | 将 Apache 的`AllowOverride`变量设为`None`。所有默认指令将从`/opt/bitnami/wordpress/wordpress-htaccess.conf`加载。                                                                                       | `yes`                                           |
| `WORDPRESS_ENABLE_HTACCESS_PERSISTENCE`          | 持久化 htaccess 的自定义修改。依赖于`WORDPRESS_HTACCESS_OVERRIDE_NONE`的值：若为`yes`，持久化`/opt/bitnami/wordpress/wordpress-htaccess.conf`；若为`no`，持久化`/opt/bitnami/wordpress/.htaccess`。 | `no`                                            |
| `WORDPRESS_RESET_DATA_PERMISSIONS`               | 初始化时是否强制重置持久化数据的所有权/权限（假设默认权限正确则无需启用）。非 root 用户运行时此选项无效。                                                                                                  | `no`                                            |
| `WORDPRESS_TABLE_PREFIX`                         | WordPress 数据库表前缀。                                                                                                                                                                              | `wp_`                                           |
| `WORDPRESS_PLUGINS`                              | 需安装并激活的 WordPress 插件列表，用逗号分隔。设为`all`激活所有已安装插件，设为`none`则不激活。                                                                                                        | `none`                                          |
| `WORDPRESS_EXTRA_INSTALL_ARGS`                   | 追加到 WordPress 'wp core install' 命令的额外参数。                                                                                                                                                     | `nil`                                           |
| `WORDPRESS_EXTRA_CLI_ARGS`                       | 追加到所有 WP-CLI 命令的额外参数。                                                                                                                                                                    | `nil`                                           |
| `WORDPRESS_EXTRA_WP_CONFIG_CONTENT`              | 安装时追加到 wp-config.php 的额外配置内容。                                                                                                                                                           | `nil`                                           |
| `WORDPRESS_SKIP_BOOTSTRAP`                       | 是否跳过应用的初始引导配置。                                                                                                                                                                          | `no`                                            |
| `WORDPRESS_AUTO_UPDATE_LEVEL`                    | WordPress 核心自动更新级别。有效值：`major`（ major 版本）、`minor`（ minor 版本）、`none`（不更新）。                                                                                                  | `none`                                          |
| `WORDPRESS_AUTH_KEY`                             | AUTH_KEY 的值                                                                                                                                                                                         | `nil`                                           |
| `WORDPRESS_SECURE_AUTH_KEY`                      | SECURE_AUTH_KEY 的值                                                                                                                                                                                  | `nil`                                           |
| `WORDPRESS_LOGGED_IN_KEY`                        | LOGGED_IN_KEY 的值                                                                                                                                                                                   | `nil`                                           |
| `WORDPRESS_NONCE_KEY`                            | NONCE_KEY 的值                                                                                                                                                                                       | `nil`                                           |
| `WORDPRESS_AUTH_SALT`                            | AUTH_SALT 的值                                                                                                                                                                                       | `nil`                                           |
| `WORDPRESS_SECURE_AUTH_SALT`                     | SECURE_AUTH_SALT 的值                                                                                                                                                                                | `nil`                                           |
| `WORDPRESS_LOGGED_IN_SALT`                       | LOGGED_IN_SALT 的值                                                                                                                                                                                  | `nil`                                           |
| `WORDPRESS_NONCE_SALT`                           | NONCE_SALT 的值                                                                                                                                                                                      | `nil`                                           |
| `WORDPRESS_ENABLE_REVERSE_PROXY`                 | 启用 WordPress 对反向代理头的支持                                                                                                                                                                     | `no`                                            |
| `WORDPRESS_ENABLE_XML_RPC`                       | 启用 WordPress XML-RPC 端点                                                                                                                                                                          | `no`                                            |
| `WORDPRESS_USERNAME`                             | WordPress 用户名                                                                                                                                                                                     | `user`                                          |
| `WORDPRESS_PASSWORD`                             | WordPress 用户密码                                                                                                                                                                                     | `bitnami`                                       |
| `WORDPRESS_EMAIL`                                | WordPress 用户邮箱                                                                                                                                                                                    | `[邮箱已删除]`                              |
| `WORDPRESS_FIRST_NAME`                           | WordPress 用户名字                                                                                                                                                                                   | `UserName`                                      |
| `WORDPRESS_LAST_NAME`                            | WordPress 用户姓氏                                                                                                                                                                                   | `LastName`                                      |
| `WORDPRESS_ENABLE_MULTISITE`                     | 启用 WordPress 多站点配置                                                                                                                                                                             | `no`                                            |
| `WORDPRESS_MULTISITE_NETWORK_TYPE`               | 多站点网络类型。有效值：`subfolder`（子文件夹）、`subdirectory`（子目录）、`subdomain`（子域名）。                                                                                                      | `subdomain`                                     |
| `WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER`  | 多站点外部 HTTP 端口                                                                                                                                                                                  | `80`                                            |
| `WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER` | 多站点外部 HTTPS 端口                                                                                                                                                                                 | `443`                                           |
| `WORDPRESS_MULTISITE_HOST`                       | WordPress 主机名/地址（仅用于多站点安装）                                                                                                                                                             | `nil`                                           |
| `WORDPRESS_MULTISITE_ENABLE_NIP_IO_REDIRECTION`  | 启用多站点时是否通过 nip.io 通配符 DNS 重定向 IP 地址（仅支持子域名网络类型且运行在 IP 地址上时可用）                                                                                                   | `no`                                            |
| `WORDPRESS_MULTISITE_FILEUPLOAD_MAXK`            | 多站点允许的最大上传文件大小（KB）                                                                                                                                                                    | `81920`                                         |
| `WORDPRESS_SMTP_HOST`                            | WordPress SMTP 服务器主机                                                                                                                                                                             | `nil`                                           |
| `WORDPRESS_SMTP_PORT_NUMBER`                     | WordPress SMTP 服务器端口                                                                                                                                                                             | `nil`                                           |
| `WORDPRESS_SMTP_USER`                            | WordPress SMTP 服务器用户名                                                                                                                                                                           | `nil`                                           |
| `WORDPRESS_SMTP_FROM_EMAIL`                      | WordPress SMTP 发件人邮箱                                                                                                                                                                             | `${WORDPRESS_SMTP_USER}`                        |
| `WORDPRESS_SMTP_FROM_NAME`                       | WordPress SMTP 发件人名称                                                                                                                                                                             | `${WORDPRESS_FIRST_NAME} ${WORDPRESS_LAST_NAME}` |
| `WORDPRESS_SMTP_PASSWORD`                        | WordPress SMTP 服务器用户密码                                                                                                                                                                         | `nil`                                           |
| `WORDPRESS_SMTP_PROTOCOL`                        | WordPress SMTP 服务器使用的协议                                                                                                                                                                       | `nil`                                           |
| `WORDPRESS_DATABASE_HOST`                        | 数据库服务器主机                                                                                                                                                                                      | `$WORDPRESS_DEFAULT_DATABASE_HOST`              |
| `WORDPRESS_DATABASE_PORT_NUMBER`                 | 数据库服务器端口                                                                                                                                                                                      | `3306`                                          |
| `WORDPRESS_DATABASE_NAME`                        | 数据库名称                                                                                                                                                                                            | `bitnami_wordpress`                             |
| `WORDPRESS_DATABASE_USER`                        | 数据库用户名                                                                                                                                                                                          | `bn_wordpress`                                  |
| `WORDPRESS_DATABASE_PASSWORD`                    | 数据库用户密码                                                                                                                                                                                        | `nil`                                           |
| `WORDPRESS_ENABLE_DATABASE_SSL`                  | 是否启用数据库连接 SSL                                                                                                                                                                                | `no`                                            |
| `WORDPRESS_VERIFY_DATABASE_SSL`                  | 启用数据库 SSL 时是否验证证书                                                                                                                                                                         | `yes`                                           |
| `WORDPRESS_DATABASE_SSL_CERT_FILE`               | 数据库客户端证书文件路径                                                                                                                                                                              | `nil`                                           |
| `WORDPRESS_DATABASE_SSL_KEY_FILE`                | 数据库客户端证书密钥文件路径                                                                                                                                                                          | `nil`                                           |
| `WORDPRESS_DATABASE_SSL_CA_FILE`                 | 数据库服务器 CA 证书 bundle 文件路径                                                                                                                                                                  | `nil`                                           |
| `WORDPRESS_OVERRIDE_DATABASE_SETTINGS`           | 是否覆盖持久化存储中的数据库设置                                                                                                                                                                      | `no`                                            |


#### 只读环境变量

| 名称                              | 描述                          | 值                                 |
|-----------------------------------|-------------------------------|-----------------------------------|
| `WORDPRESS_BASE_DIR`              | WordPress 安装目录            | `${BITNAMI_ROOT_DIR}/wordpress`   |
| `WORDPRESS_CONF_FILE`             | WordPress 配置文件            | `${WORDPRESS_BASE_DIR}/wp-config.php` |
| `WP_CLI_BASE_DIR`                 | WP-CLI 安装目录               | `${BITNAMI_ROOT_DIR}/wp-cli`      |
| `WP_CLI_BIN_DIR`                  | WP-CLI 二进制文件目录         | `${WP_CLI_BASE_DIR}/bin`          |
| `WP_CLI_CONF_DIR`                 | WP-CLI 配置文件目录           | `${WP_CLI_BASE_DIR}/conf`         |
| `WP_CLI_CONF_FILE`                | WP-CLI 配置文件               | `${WP_CLI_CONF_DIR}/wp-cli.yml`   |
| `WORDPRESS_VOLUME_DIR`            | WordPress 挂载配置文件目录    | `${BITNAMI_VOLUME_DIR}/wordpress` |
| `WORDPRESS_DEFAULT_DATABASE_HOST` | 默认数据库服务器主机          | `mariadb`                         |
