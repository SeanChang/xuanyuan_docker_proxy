---
image: bitnami/apache
description: "Bitnami提供的Apache安全镜像，用于安全部署和运行Apache Web服务器，具备加固的安全配置与可靠的运行环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/apache
canonical: https://xuanyuan.cloud/zh/r/bitnami/apache
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/apache" title="bitnami/apache Docker 镜像中文简介、标签列表与拉取命令">bitnami/apache 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bitnami Apache 镜像文档

## 镜像概述和主要用途

Bitnami Apache 镜像是基于 Apache HTTP Server 的容器化部署方案。Apache HTTP Server 是一款开源的 HTTP 服务器，旨在提供安全、高效且可扩展的 HTTP 服务，符合当前 HTTP 标准。Bitnami 镜像通过安全加固、标准化配置和简化部署流程，适用于开发、测试及生产环境中的静态网站托管、反向代理和 Web 服务前端等场景。

## 核心功能和特性

### Apache 核心功能
- 支持 HTTP/HTTPS 协议，符合 HTTP 标准
- 虚拟主机（Virtual Hosts）管理多域名服务
- 模块化架构，支持扩展（如 mod_proxy、mod_ssl 等）
- 访问控制、日志记录和性能优化功能

### Bitnami 镜像增强特性
- **安全加固**：基于最小化操作系统（Photon Linux），减少攻击面
- **供应链安全**：提供 SLSA-3 合规的软件工厂产出，包含 SBOM、VEX/KEV 漏洞透明度报告、病毒扫描报告和签名验证（Notation）
- **非 root 容器**：默认以非特权用户（UID 1001）运行，提升安全性
- **标准化配置**：统一的目录结构和环境变量管理，支持动态配置调整
- **跨平台一致性**：与 Bitnami 虚拟机、云镜像使用相同组件和配置逻辑，便于格式切换

## 使用场景和适用范围

### 适用场景
- 静态网站托管（HTML、CSS、JavaScript、图片等静态资源）
- 反向代理服务器（转发请求至后端应用服务）
- 开发/测试环境中的 Web 服务前端
- 需要安全加固和合规性的企业级 Web 部署

### 适用用户
- 开发人员：快速搭建本地开发环境
- 运维人员：简化容器化部署和配置管理
- 企业用户：需要安全合规、可追溯的生产级 Web 服务

## 快速启动（TL;DR）

```console
docker run --name apache docker.xuanyuan.run/bitnami/apache:latest
```

配置选项详见 [环境变量](#环境变量) 部分。


## ⚠️ 重要通知：Bitnami 镜像目录即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像目录，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的安全加固镜像。过渡期安排如下：

- 首次向社区用户开放流行容器镜像的安全优化版本。
- Bitnami 将逐步弃用免费 tier 中的非加固 Debian 基础镜像，并从公共目录中移除非最新标签。社区用户将仅能访问有限数量的加固镜像，且仅以“latest”标签发布，适用于开发用途。
- 8 月 28 日起，两周内所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共目录（docker.io/bitnami）迁移至“Bitnami Legacy”仓库（docker.io/bitnamilegacy），且不再接收更新。
- 生产环境和长期支持场景建议采用 Bitnami Secure Images，包含加固容器、最小攻击面、CVE 透明度（VEX/KEV）、SBOM 和企业级支持。

更多详情参见 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 使用方法和配置说明

### 获取镜像

#### 从 Docker Hub 拉取
推荐通过 Docker Hub 获取预构建镜像：
```console
# 获取最新版
docker pull docker.xuanyuan.run/bitnami/apache:latest

# 获取特定版本（需替换 [TAG]，如 2.4.58）
docker pull docker.xuanyuan.run/bitnami/apache:[TAG]
```

#### 本地构建
如需自定义构建，可克隆源码仓库并执行构建命令：
```console
git clone https://github.com/bitnami/containers.git
cd bitnami/apache/[VERSION]/[操作系统]  # 替换版本和操作系统（如 2.4/debian-12）
docker build -t bitnami/apache:latest .
```


### 托管静态网站

容器默认将 `/app` 目录配置为 Apache 的 `DocumentRoot`（文档根目录），挂载本地静态文件至该目录即可提供服务。

#### Docker 命令示例
```console
docker run --name apache \
  -p 8080:8080 -p 8443:8443 \  # 映射 HTTP/HTTPS 端口（容器内默认 8080/8443）
  -v /本地静态文件路径:/app \  # 挂载本地静态文件到容器 /app
  bitnami/apache:latest
```

#### Docker Compose 示例
```yaml
version: '2'
services:
  apache:
    image: docker.xuanyuan.run/bitnami/apache:latest
    ports:
      - "80:8080"   # 主机 80 端口映射到容器 HTTP 端口
      - "443:8443"  # 主机 443 端口映射到容器 HTTPS 端口
    volumes:
      - /本地静态文件路径:/app  # 挂载静态文件
    restart: unless-stopped
```

> **注意**：由于容器以非 root 用户（UID 1001）运行，挂载的文件和目录需确保该用户有读权限。


### 从主机访问服务

#### 随机端口映射
使用 `-P` 选项让 Docker 随机映射容器端口，通过 `docker port` 查看映射关系：
```console
docker run --name apache -P docker.xuanyuan.run/bitnami/apache:latest
docker port apache  # 输出示例：8080/tcp -> 0.0.0.0:32769
```

#### 指定端口映射
手动指定主机与容器端口映射（推荐生产环境使用）：
```console
docker run --name apache \
  -p 80:8080 \  # 主机 80 端口 -> 容器 HTTP 端口
  -p 443:8443 \ # 主机 443 端口 -> 容器 HTTPS 端口
  bitnami/apache:latest
```
访问 `http://localhost:80` 或 `https://localhost:443` 即可打开网站。


### 配置说明

#### 环境变量

##### 可定制环境变量
| 变量名                      | 描述                          | 默认值  |
|----------------------------|-------------------------------|---------|
| `APACHE_HTTP_PORT_NUMBER`  | Apache HTTP 服务端口号        | `nil`   |
| `APACHE_HTTPS_PORT_NUMBER` | Apache HTTPS 服务端口号       | `nil`   |
| `APACHE_SERVER_TOKENS`     | Apache ServerTokens 指令值    | `Prod`  |

##### 只读环境变量（运行时自动设置）
| 变量名                              | 描述                                  | 值                                      |
|-----------------------------------|---------------------------------------|-----------------------------------------|
| `WEB_SERVER_TYPE`                 | Web 服务器类型                        | `apache`                                |
| `APACHE_BASE_DIR`                 | Apache 安装目录                       | `${BITNAMI_ROOT_DIR}/apache`            |
| `APACHE_CONF_DIR`                 | 配置文件目录                          | `${APACHE_BASE_DIR}/conf`               |
| `APACHE_VHOSTS_DIR`               | 虚拟主机配置目录                      | `${APACHE_CONF_DIR}/vhosts`             |
| `APACHE_HTDOCS_DIR`               | 默认文档根目录                        | `${APACHE_BASE_DIR}/htdocs`             |
| `APACHE_LOGS_DIR`                 | 日志文件目录                          | `${APACHE_BASE_DIR}/logs`               |
| `APACHE_CONF_FILE`                | 主配置文件路径                        | `${APACHE_CONF_DIR}/httpd.conf`         |
| `APACHE_DEFAULT_HTTP_PORT_NUMBER` | 默认 HTTP 端口（构建时设置）          | `8080`                                  |
| `APACHE_DEFAULT_HTTPS_PORT_NUMBER`| 默认 HTTPS 端口（构建时设置）         | `8443`                                  |

#### 环境变量配置示例
通过 `-e` 参数或 Docker Compose `environment` 字段设置环境变量：
```console
docker run --name apache \
  -p 80:8081 -p 443:8443 \
  -e APACHE_HTTP_PORT_NUMBER=8081 \  # 自定义 HTTP 端口为 8081
  bitnami/apache:latest
```

Docker Compose 配置：
```yaml
version: '2'
services:
  apache:
    image: docker.xuanyuan.run/bitnami/apache:latest
    ports:
      - "80:8081"
      - "443:8443"
    environment:
      - APACHE_HTTP_PORT_NUMBER=8081  # 自定义 HTTP 端口
```


#### 添加自定义虚拟主机

Apache 主配置默认包含 `/opt/bitnami/apache/conf/vhosts/` 目录下的所有 `.conf` 文件，通过挂载虚拟主机配置文件至 `/vhosts` 目录即可生效。

##### 步骤 1：创建虚拟主机配置文件（如 `my_vhost.conf`）
```apache
<VirtualHost *:8080>
  ServerName www.example.com  # 域名
  DocumentRoot "/app/example"  # 该域名的文档根目录
  <Directory "/app/example">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
```

##### 步骤 2：挂载配置文件启动容器
```console
docker run --name apache \
  -v /本地路径/my_vhost.conf:/vhosts/my_vhost.conf:ro \  # 只读挂载虚拟主机配置
  -v /本地/example网站文件:/app/example \  # 挂载网站文件
  bitnami/apache:latest
```


#### 自定义 SSL 证书

容器默认使用 `/certs` 目录下的 `tls.crt`（证书）和 `tls.key`（私钥）。替换为自定义证书步骤如下：

##### 步骤 1：准备证书文件
将自定义证书重命名为 `server.crt` 和 `server.key`，存放于本地目录（如 `/path/to/certs`）：
```console
mkdir -p /path/to/certs
cp /本地证书路径.crt /path/to/certs/server.crt
cp /本地私钥路径.key /path/to/certs/server.key
```

##### 步骤 2：挂载证书目录启动容器
```console
docker run --name apache \
  -v /path/to/certs:/certs \  # 挂载证书目录至容器 /certs
  bitnami/apache:latest
```


#### 完整配置覆盖

如需完全自定义 Apache 配置，可直接挂载主配置文件 `httpd.conf`：
```console
docker run --name apache \
  -v /本地/httpd.conf:/opt/bitnami/apache/conf/httpd.conf \  # 覆盖主配置
  bitnami/apache:latest
```


#### FIPS 配置（Bitnami Secure Images）

安全加固镜像支持 FIPS 模式，通过环境变量 `OPENSSL_FIPS` 控制：
- `OPENSSL_FIPS=yes`：启用 FIPS 模式（默认）
- `OPENSSL_FIPS=no`：禁用 FIPS 模式

配置示例：
```console
docker run --name apache \
  -e OPENSSL_FIPS=no \  # 禁用 FIPS 模式
  bitnami/apache:latest
```


### 反向代理配置

Apache 可通过 `mod_proxy` 模块实现反向代理，转发请求至其他容器服务。示例配置（添加至虚拟主机配置或主配置）：
```apache
<VirtualHost *:8080>
  ServerName api.example.com
  ProxyPass / http://backend-service:8080/  # 转发至后端服务（需通过 Docker 网络连接）
  ProxyPassReverse / http://backend-service:8080/
</VirtualHost>
```


## 日志管理

容器将 Apache 日志输出至 `stdout`，可通过 `docker logs` 命令查看：
```console
docker logs apache  # 查看实时日志
docker logs -f apache  # 持续输出日志
```

Docker Compose 环境：
```console
docker-compose logs apache
```


## 自定义镜像

如需扩展镜像功能（如安装工具、修改配置），可基于官方镜像构建自定义镜像。示例 Dockerfile：
```dockerfile
FROM docker.xuanyuan.run/bitnami/apache

# 切换至 root 用户执行特权操作
USER 0
# 安装 vim 编辑器（需使用镜像内置包管理器）
RUN install_packages vim
# 切换回非 root 用户
USER 1001

# 启用 mod_ratelimit 模块
RUN sed -i -r 's/#LoadModule ratelimit_module/LoadModule ratelimit_module/' /opt/bitnami/apache/conf/httpd.conf

# 自定义默认 HTTP 端口（运行时可通过环境变量覆盖）
ENV APACHE_HTTP_PORT_NUMBER=8181
EXPOSE 8181 8443
```


## 维护

### 升级镜像

#### 步骤 1：拉取最新镜像
```console
docker pull docker.xuanyuan.run/bitnami/apache:latest
```

#### 步骤 2：备份数据（如挂载的静态文件或配置）
```console
rsync -a /path/to/挂载数据 /path/to/备份目录_$(date +%Y%m%d-%H%M%S)
```

#### 步骤 3：停止并删除旧容器
```console
docker stop apache && docker rm apache
```

#### 步骤 4：启动新容器
```console
docker run --name apache \
  -v /path/to/数据:/app \  # 挂载备份的数据
  bitnami/apache:latest
```


## 版本变更说明

### 重要变更记录
- **2.4.64-debian-12-r2**：TLS 证书文件重命名为 `tls.crt`/`tls.key`（原 `server.crt`/`server.key`），适配 Kubernetes `tls` 密钥类型。
- **2.4.54-debian-11-r22**：移除 Apache PageSpeed 模块（mod_pagespeed）。
- **2.4.34-r8**：迁移至非 root 用户模式，容器和 Apache 进程均以 UID 1001 运行，默认端口变更为 8080（HTTP）/8443（HTTPS）（原 80/443）。
- **2.4.18-r0**：配置持久化路径变更为 `/bitnami/apache`，日志仅输出至 `stdout`。


## 贡献和问题反馈

- **贡献**：通过 [GitHub 仓库](https://github.com/bitnami/containers) 提交 Pull Request 或 Issue。
- **问题反馈**：在 [Bitnami Containers Issues](https://github.com/bitnami/containers/issues) 提交问题，需包含环境信息、复现步骤和日志。


## 许可证

本镜像基于 Apache License 2.0 许可协议。详见 [LICENSE](https://github.com/bitnami/containers/blob/main/LICENSE)。

> **商标说明**：本镜像由 Bitnami 打包，提及的商标分属各自所有者，不代表关联或背书。
