---
image: oscarfonts/geoserver
description: "基于官方Tomcat镜像部署GeoServer的Docker镜像，用于提供地理信息数据发布和空间服务功能。"
source: https://xuanyuan.cloud/zh/r/oscarfonts/geoserver
canonical: https://xuanyuan.cloud/zh/r/oscarfonts/geoserver
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oscarfonts/geoserver" title="oscarfonts/geoserver Docker 镜像中文简介、标签列表与拉取命令">oscarfonts/geoserver 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-geoserver 镜像文档


## 镜像概述与主要用途

基于 Docker 官方 Tomcat 镜像构建的 GeoServer 容器化部署方案，旨在提供便捷、可配置的 GeoServer 服务部署方式。主要用途是在容器环境中快速部署 GeoServer，支持自定义数据存储、扩展管理、权限控制等功能，适用于地理空间数据发布与管理场景。


## 重要说明：安全漏洞与版本要求

受严重安全漏洞影响的旧版 GeoServer 已从本仓库移除，以避免潜在风险。请尽可能升级至最新版本，或至少使用以下安全版本：

- 若使用低于 2.23.x 的版本且无法升级，需自行 patch 并构建镜像（本仓库不提供支持或已 patch 的构建版本）。详情参考 [CVE-2024-36401 官方公告](https://geoserver.org/vulnerability/2024/09/12/cve-2024-36401.html)。
- 2.23.x 系列：至少使用 2.23.6
- 2.24.x 系列：至少使用 2.24.5
- 2.25.x 系列：至少使用 2.25.2
- 2.26.0 及以上版本：不受此漏洞影响

若关注安全性并希望保持 GeoServer 良好运行状态，[建议支持 3.0 版本的开发](https://geoserver.org/behind%20the%20scenes/2024/09/10/gs3.html)。


## 核心功能与特性

- **基础镜像**：基于 Docker 官方 Tomcat 镜像 `tomcat:9-jre17` 构建。
- **安全运行**：以非 root 用户身份运行 tomcat 进程。
- **数据目录分离**：GEOSERVER_DATA_DIR 独立存储于 `/var/local/geoserver`。
- **可配置扩展**：支持自定义扩展安装。
- **权限管理**：支持注入自定义 UID/GID，优化挂载卷的权限控制。
- **CORS 支持**：默认配置跨域资源共享（CORS），参考 [enable-cors.org](http://enable-cors.org/server_tomcat.html)。
- **JVM 参数优化**：已按 GeoServer 生产环境要求配置 JVM 参数，参考 [GeoServer 文档](http://docs.geoserver.org/latest/en/user/production/container.html)。
- **字体兼容性**：自动安装 Microsoft Core Fonts，提升标签渲染兼容性，参考 [Microsoft 字体页面](http://www.microsoft.com/typography/fonts/web.aspx)。
- **自定义部署路径**：支持修改 GeoServer 基础访问路径。
- **健康检查**：内置 Docker 健康检查机制。


## 可信构建版本

以下版本提供自动化构建，可从 [Docker Hub](https://hub.docker.com/r/oscarfonts/geoserver/) 获取：

- [`latest`, `2.27.2`（*2.27.2/Dockerfile*）](https://github.com/oscarfonts/docker-geoserver/blob/master/2.27.2/Dockerfile)
- [`2.26.4`（*2.26.4/Dockerfile*）](https://github.com/oscarfonts/docker-geoserver/blob/master/2.26.4/Dockerfile)
- [`2.25.7`（*2.25.7/Dockerfile*）](https://github.com/oscarfonts/docker-geoserver/blob/master/2.25.7/Dockerfile)
- [`2.24.5`（*2.24.5/Dockerfile*）](https://github.com/oscarfonts/docker-geoserver/blob/master/2.24.5/Dockerfile)
- [`2.23.6`（*2.23.6/Dockerfile*）](https://github.com/oscarfonts/docker-geoserver/blob/master/2.23.6/Dockerfile)


## 非支持构建版本（实验性）

以下为实验性 Dockerfile（非自动化构建），更适合作为参考示例而非生产环境使用：

- [`oracle`](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/oracle/Dockerfile)：基于 [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/)，需手动提供 ojdbc7.jar 并配置数据库（参考 [setup.sql](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/oracle/setup.sql)），运行命令见 [run.sh](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/oracle/run.sh)。
- [`h2-vector`](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/h2-vector/Dockerfile)：与 [oscarfonts/h2:geodb](https://hub.docker.com/r/oscarfonts/h2/tags/) 兼容，包含 docker-compose 和 systemd 示例脚本。
- **已弃用** [`ecw`](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/ecw/Dockerfile)：为旧版 GeoServer 添加带 ECW 支持的 GDAL 插件，已停止分发，需升级至新版本。


## 使用方法

### 拉取镜像

```bash
docker pull docker.xuanyuan.run/oscarfonts/geoserver
```


### 自定义 GEOSERVER_DATA_DIR

作为服务运行，暴露 8080 端口并挂载本地数据目录：

```bash
docker run -d -p 8080:8080 -v ${PWD}/data_dir:/var/local/geoserver docker.xuanyuan.run/oscarfonts/geoserver
```


### 自定义基础路径

构建镜像时，通过 `GEOSERVER_PATH` 参数修改 GeoServer 基础访问路径，默认值为 `/geoserver`。


### 自定义 UID 和 GID

通过环境变量 `CUSTOM_UID` 和 `CUSTOM_GID` 自定义 tomcat 用户的 UID 和 GID，确保挂载的 `data_dir` 和 `exts_dir` 可被容器内外用户共同访问：

```bash
docker run -d -p 8080:8080 -e CUSTOM_UID=$(id -u) -e CUSTOM_GID=$(id -g) docker.xuanyuan.run/oscarfonts/geoserver
```


### 自定义扩展

如需添加扩展，提供包含未解压扩展包的目录（每个扩展一个子目录），挂载至 `/var/local/geoserver-exts/`：

```bash
docker run -d -p 8080:8080 -v ${PWD}/exts_dir:/var/local/geoserver-exts/ docker.xuanyuan.run/oscarfonts/geoserver
```

可使用 `build_exts_dir.sh` 脚本配合 [extensions 配置文件](https://github.com/oscarfonts/docker-geoserver/tree/master/extensions) 快速创建扩展目录。

> **警告**：扩展目录中的 `.jar` 文件将被复制到 GeoServer 的 `WEB-INF/lib` 目录，仅添加来自可信来源的文件以避免安全风险。


### 自定义配置目录

通过挂载 Catalina 配置目录自定义上下文路径：

```bash
docker run -d -p 8080:8080 -v ${PWD}/config_dir:/usr/local/tomcat/conf/Catalina/localhost docker.xuanyuan.run/oscarfonts/geoserver
```


### CORS 配置

默认已启用 CORS 并配置于 servlet 的 web.xml 过滤器中。若前端已处理跨域，可通过环境变量禁用：

```bash
docker run -d -p 8080:8080 -e "GEOSERVER_CORS_ENABLED=false" docker.xuanyuan.run/oscarfonts/geoserver
```

可通过以下环境变量微调 CORS 策略（参考 [Tomcat 文档](https://tomcat.apache.org/tomcat-7.0-doc/config/filter.html#CORS_Filter)）：

- `GEOSERVER_CORS_ALLOWED_ORIGINS`：允许的源（对应 `cors.allowed.origins`）
- `GEOSERVER_CORS_ALLOWED_METHODS`：允许的 HTTP 方法（对应 `cors.allowed.methods`）
- `GEOSERVER_CORS_ALLOWED_HEADERS`：允许的请求头（对应 `cors.allowed.headers`）
- `GEOSERVER_CORS_URL_PATTERN`：过滤器匹配的 URL 模式（对应 `filter-mapping url-pattern`）


## 使用场景与适用范围

- **适用场景**：需容器化部署 GeoServer 的开发、测试及生产环境；需要自定义数据存储、扩展插件或权限管理的场景；对跨域访问、JVM 性能有要求的地理空间服务部署。
- **版本选择**：生产环境建议使用“可信构建版本”中的安全版本（2.23.6+、2.24.5+、2.25.2+、2.26.0+）；实验性版本（如 oracle、h2-vector）仅用于功能验证或学习参考，非生产就绪。
