---
image: easysoft/gitea
description: "QuickOn Gitea应用镜像是一个自托管Git服务程序，基于Gitea构建，支持SSH/HTTP协议、用户认证、仓库管理、工单系统等功能，安装简单、跨平台运行，适用于团队或个人搭建私有代码仓库。"
source: https://xuanyuan.cloud/zh/r/easysoft/gitea
canonical: https://xuanyuan.cloud/zh/r/easysoft/gitea
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/easysoft/gitea" title="easysoft/gitea Docker 镜像中文简介、标签列表与拉取命令">easysoft/gitea 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# QuickOn Gitea 应用镜像

[![GitHub Workflow Status](https://github.com/quicklyon/gitea-docker/actions/workflows/docker.yml/badge.svg)](https://github.com/quicklyon/gitea/actions/workflows/docker.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/easysoft/gitea?style=flat-square)
![Docker Image Size](https://img.shields.io/docker/image-size/easysoft/gitea?style=flat-square)
![GitHub tag](https://img.shields.io/github/v/tag/quicklyon/gitea-docker?style=flat-square)

> 申明: 该软件镜像是由QuickOn打包。在发行中提及的各自商标由各自的公司或个人所有，使用它们并不意味着任何从属关系。

## 快速参考

- 通过 [渠成软件百宝箱](https://www.qucheng.com/app-install/install-gitea-134.html) 一键安装 **Gitea**
- [Dockerfile 源码](https://github.com/quicklyon/gitea-docker)
- [Gitea 源码](https://github.com/go-gitea/gitea)
- [Gitea 官网](https://gitea.io/)

## 一、关于 Gitea

Gitea 是一个自托管的Git服务程序，与GitHub、Bitbucket或Gitlab等类似。它从Gogs发展而来，后经Fork并命名为Gitea。关于Fork原因可参考 [这里](https://blog.gitea.io/2016/12/welcome-to-gitea/)。

![screenshots](https://raw.githubusercontent.com/quicklyon/gitea-docker/main/.template/screenshot.png)

Gitea官网：[https://gitea.io/](https://gitea.io/)

### 目标

Gitea的首要目标是创建一个极易安装、运行快速、安装和使用体验良好的自建Git服务。采用Go作为后端语言，只需生成一个可执行程序即可运行，且支持跨平台（Linux、macOS、Windows）及多种架构（x86、amd64、ARM、PowerPC等）。

### 功能特性

- 支持活动时间线
- 支持SSH及HTTP/HTTPS协议
- 支持SMTP、LDAP和反向代理的用户认证
- 支持反向代理子路径
- 支持用户、组织和仓库管理系统
- 支持添加和删除仓库协作者
- 支持仓库和组织级别Web钩子（包括Slack集成）
- 支持仓库Git钩子和部署密钥
- 支持仓库工单（Issue）、合并请求（Pull Request）及Wiki
- 支持迁移和镜像仓库及其Wiki
- 支持在线编辑仓库文件和Wiki
- 支持自定义源的Gravatar和Federated Avatar
- 支持邮件服务
- 支持后台管理面板
- 支持MySQL、PostgreSQL、SQLite3、MSSQL和TiDB(MySQL)数据库
- 支持多语言本地化（21种语言）
- 支持软件包注册中心（Composer/Conan/Container/Generic/Helm/Maven/NPM/Nuget/PyPI/RubyGems）

### 系统要求

- 最低系统硬件要求：廉价树莓派
- 团队项目建议配置：2核CPU及1GB内存

### 浏览器支持

Chrome, Firefox, Safari, Edge

## 二、支持的版本(Tag)

由于版本较多，此处仅列出最新5个版本，更详细版本列表请参考：[可用版本列表](https://hub.docker.com/r/easysoft/gitea/tags/)

- [latest,1.23.1,1.23.1-20250126](https://github.com/go-gitea/gitea/releases/tag/v1.23.1)
- [1.22.2,1.22.2-20241008](https://github.com/go-gitea/gitea/releases/tag/v1.22.2)
- [1.21.11,1.21.11-20240419](https://github.com/go-gitea/gitea/releases/tag/v1.21.11)
- [1.20.4,1.20.4-20230914](https://github.com/go-gitea/gitea/releases/tag/v1.20.4)
- [1.19.4,1.19.4-20230706](https://github.com/go-gitea/gitea/releases/tag/v1.19.4)
- [1.18.5-20230313](https://github.com/go-gitea/gitea/releases/tag/v1.18.5)
- [1.17.4-20221223](https://github.com/go-gitea/gitea/releases/tag/v1.17.4)

## 三、获取镜像

推荐从 [Docker Hub Registry](https://hub.docker.com/r/easysoft/gitea) 拉取构建好的官方Docker镜像。

```bash
docker pull docker.xuanyuan.run/easysoft/gitea:latest
```

如需使用指定版本，可拉取包含版本标签的镜像，在Docker Hub仓库中查看 [可用版本列表](https://hub.docker.com/r/easysoft/gitea/tags/)

```bash
docker pull docker.xuanyuan.run/easysoft/gitea:[TAG]
```

## 四、持久化数据

删除容器会导致所有数据丢失，为避免数据丢失，需挂载卷进行持久化存储。需挂载的持久化目录：

- /data：持久化数据存储目录

若挂载目录为空，首次启动会自动初始化相关文件。

```bash
$ docker run -it \
    -v $PWD/data:/data \
    easysoft/gitea:latest
```

或修改docker-compose.yml文件添加持久化配置：

```yaml
services:
  gitea:
    ...
    volumes:
      - /path/to/persistence:/data
    ...
```

## 五、环境变量

| 变量名                  | 默认值           | 说明                          |
|-------------------------|------------------|-------------------------------|
| EASYSOFT_DEBUG          | false            | 是否打开调试信息，默认关闭    |
| APP_DOMAIN              | 0.0.0.0:8080     | Gitea域名，影响访问与仓库地址 |
| APP_PROTOCOL            | https            | Gitea域名协议                 |
| MYSQL_HOST              | 127.0.0.1        | MySQL主机地址                 |
| MYSQL_PORT              | 3306             | MySQL端口                     |
| MYSQL_DB                | gitea            | 数据库名称                    |
| MYSQL_USER              | root             | MySQL用户名                   |
| MYSQL_PASSWORD          | pass4QuickOn     | MySQL密码                     |
| DEFAULT_ADMIN_USER      | gitea            | 默认管理员名称                |
| DEFAULT_ADMIN_PASSWORD  | pass4Gitea       | 默认管理员密码                |
| GITEA_ADMIN_EMAIL       | admin@demo.com   | 管理员邮箱地址                |
| ENABLE_SWAGGER          | false            | 是否启动Swagger API页面       |
| ALLOWED_HOST_LIST       | *                | 信任的Webhook域名列表         |
| MAIL_ENABLED            | false            | 是否启用邮箱功能              |
| SMTP_HOST               | mail.demo.com    | 邮箱地址                      |
| SMTP_PORT               | 465              | 邮箱端口                      |
| SMTP_USER               | gitea@demo.com   | 邮箱发送账号                  |
| SMTP_PASS               | mail4Gitea       | 邮箱发送账号密码              |
| SSH_LISTEN_PORT         | 22               | 默认监听端口                  |
| START_SSH_SERVER        | false            | 默认不开启SSH服务             |
| DISABLE_SSH             | false            | 默认不禁用SSH                 |

## 六、运行

### 6.1 单机Docker-compose方式运行

```bash
# 启动服务
make run

# 查看服务状态
make ps

# 查看服务日志
docker-compose logs -f gitea
```

**说明:**

- 启动成功后，打开浏览器输入 `http://<你的IP>:8080` 访问管理后台
- 默认用户名：`gitea`，默认密码：`pass4Gitea`
- [VERSION](https://github.com/quicklyon/gitea-docker/blob/main/VERSION) 文件中详细定义了Makefile可操作的版本。
- [docker-compose.yml](https://github.com/quicklyon/gitea-docker/blob/main/docker-compose.yml)

## 七、版本升级

容器镜像已为版本升级做特殊处理，当检测数据（数据库/持久化文件）版本与镜像内程序版本不一致时，会自动检查并升级数据库结构。因此，升级只需更换镜像版本号：

> 修改docker-compose.yml文件

```diff
...
  gitea:
-    image: easysoft/gitea:1.17.0-20220729
+    image: easysoft/gitea:1.17.1-20220822
    container_name: gitea
...
```

更新服务：

```bash
# 用新版本镜像更新服务
docker-compose up -d

# 查看服务状态和镜像版本
docker-compose ps
