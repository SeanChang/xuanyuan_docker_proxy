---
image: jwetzell/guacamole
description: "自包含的Apache Guacamole Docker容器，支持x64和ARM（32位及64位）架构，提供无客户端远程桌面网关功能，可通过HTML5访问VNC、RDP、SSH等协议。"
source: https://xuanyuan.cloud/zh/r/jwetzell/guacamole
canonical: https://xuanyuan.cloud/zh/r/jwetzell/guacamole
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jwetzell/guacamole" title="jwetzell/guacamole Docker 镜像中文简介、标签列表与拉取命令">jwetzell/guacamole 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker Guacamole

**本仓库是 [oznu/docker-guacamole](https://github.com/oznu/docker-guacamole) 的延续项目。**

Apache Guacamole的Docker容器，这是一款无客户端远程桌面网关，支持通过HTML5访问VNC、RDP、SSH等标准协议。该镜像可运行在大多数支持Docker的平台上，包括Docker for Mac、Docker for Windows、Synology DSM以及Raspberry Pi 3等设备。

[![视频演示](http://img.youtube.com/vi/esgaHNRxdhY/0.jpg)](http://www.youtube.com/watch?v=esgaHNRxdhY "视频标题")

此容器运行Guacamole Web客户端、guacd服务器和PostgreSQL数据库。

## 核心功能与特性

- **无客户端远程访问**：通过HTML5浏览器访问VNC、RDP、SSH等远程桌面协议，无需安装额外客户端
- **多平台支持**：兼容x64、ARM32及ARM64架构，可运行于PC、服务器及树莓派等设备
- **自包含部署**：集成Web客户端、guacd服务器和PostgreSQL数据库，简化部署流程
- **扩展支持**：可通过环境变量启用多种认证扩展（如LDAP、Duo、TOTP等）及功能扩展

## 使用场景

- 个人或企业远程桌面管理
- 多平台设备的集中化远程访问（如办公电脑、服务器、树莓派）
- 需要通过浏览器快速访问多台远程设备的场景
- 对安全性有要求的环境（支持多种双因素认证扩展）

## 使用方法

### 基本部署

```shell
docker run \
  -p 8080:8080 \
  -v </path/to/config>:/config \
  docker.xuanyuan.run/jwetzell/guacamole:1.5.5
```

### 树莓派/ARMv7设备

由于镜像已转换为多平台镜像，树莓派或其他ARM设备的部署命令与上述相同：

```shell
docker run \
  -p 8080:8080 \
  -v </path/to/config>:/config \
  docker.xuanyuan.run/jwetzell/guacamole:1.5.5
```

## 参数说明

参数格式为`主机侧:容器侧`，左侧表示主机配置，右侧表示容器内配置：

- `-p 8080:8080` - 将容器的8080端口绑定到主机的8080端口，**必填**
- `-v </path/to/config>:/config` - 挂载配置文件和数据库目录，**必填**（请将`</path/to/config>`替换为实际路径）
- `-e EXTENSIONS` - 用于启用扩展的环境变量，详见下文说明

## 启用扩展

可通过`-e EXTENSIONS`环境变量启用扩展，多个扩展用逗号分隔（无空格）。

示例：

```shell
docker run \
  -p 8080:8080 \
  -v </path/to/config>:/config \
  -e "EXTENSIONS=auth-ldap,auth-duo" \
  docker.xuanyuan.run/jwetzell/guacamole:1.5.5
```

当前可用扩展及功能：

- `auth-duo` - [Duo双因素认证](https://guacamole.apache.org/doc/gug/duo-auth.html)
- `auth-header` - [HTTP头认证](https://guacamole.apache.org/doc/gug/header-auth.html)
- `auth-jdbc-mysql` - [MySQL认证](https://guacamole.apache.org/doc/gug/jdbc-auth.html)
- `auth-jdbc-postgresql` - [PostgreSQL认证](https://guacamole.apache.org/doc/gug/jdbc-auth.html)
- `auth-jdbc-sqlserver` - [SQL Server认证](https://guacamole.apache.org/doc/gug/jdbc-auth.html)
- `auth-json` - [加密JSON认证](https://guacamole.apache.org/doc/gug/json-auth.html)
- `auth-ldap` - [LDAP认证](https://guacamole.apache.org/doc/gug/ldap-auth.html)
- `auth-quickconnect` - [临时连接扩展](https://guacamole.apache.org/doc/gug/adhoc-connections.html)
- `auth-sso-cas` - [CAS认证](https://guacamole.apache.org/doc/gug/cas-auth.html)
- `auth-sso-openid` - [OpenID认证](https://guacamole.apache.org/doc/gug/openid-auth.html)
- `auth-sso-saml` - [SAML认证](https://guacamole.apache.org/doc/gug/saml-auth.html)
- `auth-totp` - [TOTP双因素认证](https://guacamole.apache.org/doc/gug/totp-auth.html)
- `history-recording-storage` - [会话记录回放](https://guacamole.apache.org/doc/gug/recording-playback.html#)
- `vault` - [从Vault获取密钥](https://guacamole.apache.org/doc/gug/vault.html)

**注意**：仅启用所需的扩展，若扩展在`guacamole.properties`中配置不正确，可能导致系统无法启动。详见[官方文档](https://guacamole.apache.org/doc/gug/)。

## 默认用户

默认用户名为 `guacadmin`，密码为 `guacadmin`。

## Windows系统Docker主机注意事项

在Windows系统上运行Docker时，卷映射可能因文件系统权限问题导致PostgreSQL异常。为避免此问题并保留配置（容器升级或重建时），建议使用local卷驱动，示例`docker-compose.yml`如下：

```yml
version: "2"
services:
  guacamole:
    image: docker.xuanyuan.run/jwetzell/guacamole:1.5.5
    container_name: guacamole
    volumes:
      - postgres:/config
    ports:
      - 8080:8080
volumes:
  postgres:
    driver: local
```

**注意**：使用此配置时，请确保优雅停止容器，否则可能导致数据丢失。
