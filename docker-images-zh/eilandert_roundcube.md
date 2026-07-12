---
image: eilandert/roundcube
description: "基于Ubuntu的每日重建Roundcube镜像，集成Apache2和PHP8.0，设计用于反向代理环境，包含额外插件和皮肤，支持挂载配置目录自定义设置，兼容官方Roundcube镜像。"
source: https://xuanyuan.cloud/zh/r/eilandert/roundcube
canonical: https://xuanyuan.cloud/zh/r/eilandert/roundcube
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/eilandert/roundcube" title="eilandert/roundcube Docker 镜像中文简介、标签列表与拉取命令">eilandert/roundcube 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# eilandert/roundcube 镜像文档

## 镜像概述和主要用途

本镜像为基于 [eilandert/apache-phpfpm:8.0](https://hub.docker.com/r/eilandert/apache-phpfpm) 的每日重建Roundcube镜像，基础系统为Ubuntu滚动版，集成了 [Apache2](https://launchpad.net/~eilander/+archive/ubuntu/apache2) 和 [PHP](https://launchpad.net/~ondrej/+archive/ubuntu/php)。设计用于部署在（nginx）反向代理之后，但功能完整，可根据需求灵活配置。主要用途是提供Roundcube邮件客户端服务，支持自定义配置、插件管理及环境参数调整。

## 核心功能和特性

- **每日重建**：基于基础镜像每日更新，确保组件最新。
- **系统环境**：基于Ubuntu滚动版，集成Apache2和PHP，提供稳定运行环境。
- **额外插件**：包含多种增强插件，如：
  - rcguard（https://github.com/dsoares/roundcube-rcguard）
  - mabola-blue（https://github.com/EstudioNexos/mabola-blue）
  - roundcube-attachment_position（https://github.com/filhocf/roundcube-attachment_position）
  - plugin-quota（https://github.com/jfcherng-roundcube/plugin-quota）
  - 等（完整列表见下方插件部分）
- **额外皮肤**：提供多种界面皮肤，如：
  - mabola-blue（https://github.com/EstudioNexos/mabola-blue）
  - mabola（https://github.com/filhocf/mabola）
  - roundcube-chameleon（https://github.com/filhocf/roundcube-chameleon）
- **灵活配置**：支持挂载多个目录自定义配置，空目录会自动复制默认配置。
- **环境变量**：支持设置非活动用户清理天数、时区等参数。
- **兼容性**：保持与官方Roundcube镜像的兼容性，可切换回官方镜像。

## 使用场景和适用范围

- 需要部署Roundcube邮件客户端的个人或企业用户。
- 需在反向代理（如nginx）后运行Roundcube的环境。
- 需要自定义Apache、PHP或Roundcube配置的场景。
- 希望使用额外插件增强Roundcube功能的用户。
- 需管理非活动用户或设置特定时区的场景。

## 使用方法和配置说明

### 镜像标签

- `eilandert/roundcube:latest`：对应Roundcube稳定版 + PHP7.4 + Ubuntu系统。

### 挂载目录

可通过挂载以下目录自定义配置（空目录会自动复制默认配置）：

- `/var/roundcube/config`：访问Roundcube、PHP-FPM和Apache的配置选项。
- `/var/www/html/plugins`：编辑插件配置。
- `/etc/apache2`：获取Apache的更多控制权限。
- `/etc/php`：获取PHP的更多控制权限。

### 环境变量

支持以下环境变量设置（在官方镜像基础上额外提供）：

- `CLEAN_INACTIVE_USERS_DAYS=365`：设置清理非活动用户的天数（默认365天）。
- `TZ`：设置时区，例如 `TZ=Europe/Amsterdam`。

### 使用示例

可参考 [docker-compose示例](https://github.com/eilandert/dockerized/blob/master/roundcube/docker-compose.yml) 进行部署。

### 部署示例

#### Docker Run命令示例

```bash
docker run -d \
  -p 80:80 \
  -v /path/to/roundcube/config:/var/roundcube/config \
  -v /path/to/plugins:/var/www/html/plugins \
  -e CLEAN_INACTIVE_USERS_DAYS=180 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/eilander/roundcube:latest
```

#### Docker Compose示例

参考官方提供的 [docker-compose.yml](https://github.com/eilandert/dockerized/blob/master/roundcube/docker-compose.yml) 配置。

### 注意事项

- 如需切换回官方Roundcube镜像，只需更改Docker标签即可。
- 若遇到问题，可反馈以获取支持。</think>===SHORT_DESC===
基于Ubuntu的每日重建Roundcube镜像，集成Apache2和PHP8.0，设计用于反向代理环境，包含额外插件和皮肤，支持挂载配置目录自定义设置，兼容官方Roundcube镜像。
===FULL_DESC===# eilandert/roundcube 镜像文档

## 镜像概述和主要用途

本镜像为基于 [eilandert/apache-phpfpm:8.0](https://hub.docker.com/r/eilandert/apache-phpfpm)（Ubuntu滚动版集成Apache2和PHP）的每日重建Roundcube镜像，设计用于反向代理（如nginx）环境，功能完整。主要用途是提供Roundcube邮件客户端服务，支持自定义配置、插件管理及环境参数调整，适用于需要灵活部署邮件客户端的场景。

## 核心功能和特性

- **每日更新**：基于基础镜像每日重建，确保组件最新
- **系统环境**：基于Ubuntu滚动版，集成Apache2和PHP运行环境
- **额外插件**：包含多种增强插件，如rcguard、mabola-blue、attachment_position、plugin-quota等
- **额外皮肤**：提供mabola-blue、mabola、chameleon等多种界面皮肤
- **灵活配置**：支持挂载目录自定义配置，空目录自动复制默认配置
- **环境变量**：支持设置非活动用户清理天数、时区等参数
- **兼容性**：保持与官方Roundcube镜像兼容，可直接切换至官方镜像

## 使用场景和适用范围

- 需部署Roundcube邮件客户端的个人或企业用户
- 需在反向代理后运行Roundcube的网络环境
- 需要自定义Apache、PHP或Roundcube配置的场景
- 希望通过额外插件增强邮件客户端功能的用户
- 需自动清理非活动用户或设置特定时区的应用场景

## 使用方法和配置说明

### 镜像标签

- `eilandert/roundcube:latest`：对应Roundcube稳定版+PHP7.4+Ubuntu系统

### 挂载目录

可挂载以下目录自定义配置（空目录会自动复制默认配置）：

- `/var/roundcube/config`：访问Roundcube、PHP-FPM和Apache的配置选项
- `/var/www/html/plugins`：编辑插件配置文件
- `/etc/apache2`：获取Apache服务的完全控制权限
- `/etc/php`：获取PHP环境的完全控制权限

### 环境变量

支持以下环境变量设置：

- `CLEAN_INACTIVE_USERS_DAYS=365`：设置非活动用户清理天数（默认365天）
- `TZ`：设置时区，例如 `TZ=Europe/Amsterdam`（欧洲/阿姆斯特丹时区）

### 部署示例

#### Docker Run命令示例

```bash
docker run -d \
  --name roundcube \
  -p 80:80 \
  -v /host/path/roundcube/config:/var/roundcube/config \
  -v /host/path/plugins:/var/www/html/plugins \
  -e CLEAN_INACTIVE_USERS_DAYS=180 \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/eilander/roundcube:latest
```

#### Docker Compose配置

参考官方提供的 [docker-compose示例](https://github.com/eilandert/dockerized/blob/master/roundcube/docker-compose.yml)

### 注意事项

- 挂载目录为空时，容器会自动将默认配置复制到挂载目录
- 如需切换至官方镜像，直接修改Docker标签即可
- 使用中遇到问题可反馈以获取支持
