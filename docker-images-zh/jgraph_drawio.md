---
image: jgraph/drawio
description: "draw.io的Docker镜像是将免费开源的多功能图形绘制工具draw.io打包而成的容器化应用，该工具支持流程图、思维导图、UML图、网络拓扑图等多种图表绘制，具备本地存储与云端同步功能，可导出PNG、PDF、SVG等多种格式；通过Docker镜像，用户无需复杂配置即可快速部署和运行draw.io，适用于开发团队协作、教学设计、项目管理等场景，助力高效完成图表绘制工作，提升整体效率。"
source: https://xuanyuan.cloud/zh/r/jgraph/drawio
canonical: https://xuanyuan.cloud/zh/r/jgraph/drawio
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [jgraph/drawio — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/jgraph/drawio)

含镜像标签、拉取命令、部署文档与相关推荐。

[jgraph/drawio Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/jgraph/drawio)

# diagrams.net Docker 镜像使用指南


## 简介

[diagrams.net]([])（原 draw.io）是一款免费在线图表工具，可用于绘制流程图、网络图、UML 图、ER 图、数据库架构图、BPMN 图、电路图等，支持导入 `.vsdx`、Gliffy™ 和 Lucidchart™ 文件。  

本仓库包含以下内容：  
- 与 diagrams.net 版本同步更新的 Docker 镜像  
- 导出服务器镜像（支持将 diagrams.net 图表导出为 PDF 和图片）  
- 用于运行 diagrams.net 及导出服务器的 docker-compose 配置  
- 集成 Nextcloud 的 docker-compose 配置  
- 独立运行配置（无需依赖 diagrams.net 官网，包含导出服务器、PlantUML、Google Drive/OneDrive 支持及 EMF 转换支持（用于 VSDX 导出））  


## 镜像说明

Dockerfile 基于 `tomcat:9-jre11` 构建（详见 [Docker Hub tomcat 镜像]([])）。  

> **注意**：自 16.5.3 版本起，不再维护 alpine 和 debian 镜像，统一使用单一镜像以减少安全漏洞。  
> 本项目从 [fjudith/draw.io]([]) fork 而来。  


## 功能特性

- 基于 Tomcat 构建，可直接部署或通过反向代理使用  
- 自动生成自签名 SSL 证书  
- 支持 Let's Encrypt 证书自动生成  
- 支持将 SSL Keystore 挂载至 `/user/local/tomcat/.keystore`  


## 快速启动

### 运行容器  
执行以下命令启动 diagrams.net 容器：  
```bash
docker run -it --rm --name="draw" -p 8080:8080 -p 8443:8443 jgraph/drawio
```

### 访问服务  
- **本地环境**：在浏览器中访问  
  `[] （HTTP）或 `[]  
- **Docker Toolbox 环境**：访问  
  `[] 或 `[]  

> **参数说明**：`?offline=1` 是安全特性，启用后将禁用云存储支持。  


## 环境变量配置

通过环境变量可自定义容器行为，变量说明如下：  

| 变量名                | 默认值                  | 描述                                  |
|-----------------------|-------------------------|---------------------------------------|
| LETS_ENCRYPT_ENABLED  | false                   | 是否启用 Let's Encrypt 证书（默认自签名） |
| PUBLIC_DNS            | draw.example.com        | 证书 "CN" 字段（域名）                |
| ORGANISATION_UNIT     | Cloud Native Application| 证书 "OU" 字段（组织单位）            |
| ORGANISATION          | example inc             | 证书 "O" 字段（组织名称）             |
| CITY                  | Paris                   | 证书 "L" 字段（城市）                 |
| STATE                 | Paris                   | 证书 "ST" 字段（州/省）               |
| COUNTRY_CODE          | FR                      | 证书 "C" 字段（国家代码）             |
| KEYSTORE_PASS         | V3ry1nS3cur3P4ssw0rd    | .keystore/.jks 存储密码               |
| KEY_PASS              | 同 KEYSTORE_PASS        | 私钥密码                              |  


## 配置 Let's Encrypt SSL 证书

### 前提条件  
1. Linux 服务器需联网，且开放 80（HTTP）和 443（HTTPS）端口  
2. 已注册域名/子域名，并将其解析至服务器 IP（例如 `drawio.example.com`）  


### 配置步骤  
1. **创建目录**：用于存储 Let's Encrypt 数据（日志、配置、证书）  
   ```bash
   mkdir -p /opt/docker/drawiodata/letsencrypt-log /opt/docker/drawiodata/letsencrypt-etc /opt/docker/drawiodata/letsencrypt-lib
   ```  

2. **启动容器**：运行以下命令生成并配置 Let's Encrypt 证书  
   ```bash
   docker run -it -m1g \
     -v "/opt/docker/drawiodata/letsencrypt-log:/var/log/letsencrypt/" \
     -v "/opt/docker/drawiodata/letsencrypt-etc:/etc/letsencrypt/" \
     -v "/opt/docker/drawiodata/letsencrypt-lib:/var/lib/letsencrypt" \
     -e LETS_ENCRYPT_ENABLED=true \
     -e PUBLIC_DNS=drawio.example.com \  # 替换为你的域名
     --rm --name="draw" \
     -p 80:80 -p 443:8443 \  # 80端口供 certbot 验证，443映射容器8443（Tomcat HTTPS端口）
     jgraph/drawio
   ```  


## 修改 diagrams.net 配置  

容器配置通过 `DRAWIO_*` 环境变量管理，例如启用 Google Drive/OneDrive 集成等。具体变量列表可查看仓库 `main` 目录下的 `docker-entrypoint.sh` 文件。  


## 参考链接  
- [diagrams.net 官方仓库]([])
