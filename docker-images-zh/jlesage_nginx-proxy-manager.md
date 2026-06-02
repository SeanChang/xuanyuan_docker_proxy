---
image: jlesage/nginx-proxy-manager
description: "用于简化Nginx反向代理配置、SSL证书管理及虚拟主机管理的Docker容器，提供Web界面以直观操作，适合快速部署和管理代理服务。"
source: https://xuanyuan.cloud/zh/r/jlesage/nginx-proxy-manager
canonical: https://xuanyuan.cloud/zh/r/jlesage/nginx-proxy-manager
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jlesage/nginx-proxy-manager" title="jlesage/nginx-proxy-manager Docker 镜像中文简介、标签列表与拉取命令">jlesage/nginx-proxy-manager — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jlesage/nginx-proxy-manager" title="jlesage/nginx-proxy-manager Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jlesage/nginx-proxy-manager</a>

# Nginx Proxy Manager Docker镜像文档


## 镜像概述与主要用途

本镜像是[Nginx Proxy Manager](https://nginxproxymanager.com)的Docker容器化部署方案。Nginx Proxy Manager是一款轻量级反向代理管理工具，旨在简化反向代理配置与SSL证书管理流程，无需深入掌握Nginx或Let's Encrypt的底层技术细节。通过本镜像，用户可快速部署具备Web管理界面的反向代理服务，实现对家庭或远程服务器中多个网站的流量转发、SSL加密及访问控制。


## 核心功能与特性

### 核心功能
- **可视化反向代理配置**：通过Web界面直观配置域名、目标服务器地址、端口等反向代理规则，支持HTTP/HTTPS协议。
- **SSL证书自动管理**：集成Let's Encrypt，支持自动签发、续期免费SSL证书，无需手动操作OpenSSL。
- **多站点集中管理**：支持添加多个域名/站点，统一管理不同服务的反向代理规则与SSL配置。
- **访问控制**：可配置基本HTTP认证、IP白名单等访问限制策略，增强服务安全性。
- **日志与监控**：记录反向代理请求日志，便于问题排查与流量分析。

### Docker化特性
- **部署简化**：无需手动安装Nginx、数据库等依赖，一键启动容器即可使用。
- **环境隔离**：容器化运行，避免与主机系统环境冲突，配置与数据独立存储。
- **跨平台兼容**：支持Linux、Windows、macOS等所有Docker兼容系统。


## 使用场景与适用范围

### 适用场景
- **家庭服务器管理**：家庭用户部署NAS、媒体服务器（如Plex、Emby）、个人博客等服务时，通过反向代理统一对外暴露端口，简化网络配置。
- **小型企业/工作室**：需管理多个内部服务（如OA系统、文件共享、API服务）的反向代理与SSL加密，降低运维复杂度。
- **个人开发者**：本地开发环境中模拟多域名访问，或对外展示多个项目时，快速配置反向代理与HTTPS。

### 适用人群
- 无需深入了解Nginx配置的运维人员。
- 需要快速实现反向代理与SSL加密的个人用户或小型团队。
- 追求部署效率与环境一致性的Docker用户。


## 使用方法与配置说明

### 部署准备
- 已安装Docker Engine（20.10+推荐）及Docker Compose（可选）。
- 主机需开放以下端口（可自定义映射，见下文说明）：管理界面端口、HTTP端口、HTTPS端口。
- 确保数据卷目录具备读写权限（用于持久化配置与证书）。


### 快速部署（Docker Run）
通过以下命令启动容器，参数需根据实际环境调整：

```shell
docker run -d \
    --name=nginx-proxy-manager \
    -p 8181:8181 \  # Web管理界面端口
    -p 8080:8080 \  # HTTP反向代理端口（对外提供HTTP服务）
    -p 4443:4443 \  # HTTPS反向代理端口（对外提供HTTPS服务）
    -v /docker/appdata/nginx-proxy-manager:/config:rw \  # 持久化数据卷
    jlesage/nginx-proxy-manager
```

#### 参数说明
- `--name=nginx-proxy-manager`：容器名称，可自定义。
- 端口映射：
  - `8181:8181`：Web管理界面访问端口，用于配置反向代理规则与SSL证书。
  - `8080:8080`：容器内HTTP服务端口，需映射至主机的80端口（或其他公网HTTP端口）以接收外部HTTP请求。
  - `4443:4443`：容器内HTTPS服务端口，需映射至主机的443端口（或其他公网HTTPS端口）以接收外部HTTPS请求。
- 数据卷 `-v /docker/appdata/nginx-proxy-manager:/config:rw`：存储应用配置、SSL证书、日志等持久化数据，建议使用主机绝对路径（如`/path/to/your/config`）。


### Docker Compose部署（推荐）
创建`docker-compose.yml`文件，配置如下：

```yaml
version: '3'
services:
  nginx-proxy-manager:
    image: jlesage/nginx-proxy-manager
    container_name: nginx-proxy-manager
    ports:
      - "8181:8181"    # Web管理界面
      - "80:8080"      # 主机80端口映射至容器HTTP端口（对外提供HTTP服务）
      - "443:4443"     # 主机443端口映射至容器HTTPS端口（对外提供HTTPS服务）
    volumes:
      - /docker/appdata/nginx-proxy-manager:/config:rw  # 持久化数据
    restart: unless-stopped  # 容器退出时自动重启（除非手动停止）
```

执行以下命令启动服务：
```shell
docker-compose up -d
```


### 初始访问与配置
1. **访问管理界面**：容器启动后，通过浏览器访问 `http://<主机IP>:8181` 进入Nginx Proxy Manager Web界面。
2. **首次登录**：默认管理员账户为 `admin@example.com`，密码为 `changeme`。首次登录需强制修改密码。
3. **添加反向代理**：在界面中依次配置“主机名”（域名）、“目标URL”（后端服务地址与端口）、“SSL证书”（可选Let's Encrypt自动签发），保存后即可生效。


## 配置参数与持久化

### 数据持久化
容器通过 `/config` 目录存储所有持久化数据，包括：
- 应用配置文件（`nginx.conf`、数据库文件等）。
- Let's Encrypt SSL证书（存储于 `./letsencrypt` 子目录）。
- 访问日志与错误日志（存储于 `./log` 子目录）。

**注意**：务必通过数据卷映射此目录至主机，避免容器重建后配置与证书丢失。


### 端口映射说明
| 容器端口 | 用途                  | 建议主机映射端口 | 说明                     |
|----------|-----------------------|------------------|--------------------------|
| 8181     | Web管理界面           | 8181             | 仅内部管理使用，可自定义 |
| 8080     | HTTP反向代理服务      | 80               | 对外提供HTTP访问         |
| 4443     | HTTPS反向代理服务     | 443              | 对外提供HTTPS访问        |


## 常见问题与支持

### 问题排查
- **无法访问管理界面**：检查容器是否运行（`docker ps`）、主机防火墙是否开放8181端口、端口映射是否正确。
- **SSL证书签发失败**：确保域名已解析至主机IP，且主机80/443端口可被公网访问（Let's Encrypt验证需通过公网）。
- **反向代理不生效**：检查目标服务是否可达（容器需与后端服务在同一网络或使用IP:端口访问）、代理规则配置是否正确。


### 获取支持
如遇容器相关问题，可通过以下途径获取支持：
- [GitHub Issues](https://github.com/jlesage/docker-nginx-proxy-manager/issues)：提交问题报告。
- [Nginx Proxy Manager官方文档](https://nginxproxymanager.com/guide/)：参考应用功能配置细节。
- [jlesage Docker应用集合](https://jlesage.github.io/docker-apps/)：查看其他Docker化应用。


## 参考链接
- 镜像源码：[GitHub - jlesage/docker-nginx-proxy-manager](https://github.com/jlesage/docker-nginx-proxy-manager)
- Nginx Proxy Manager官方网站：[nginxproxymanager.com](https://nginxproxymanager.com)
