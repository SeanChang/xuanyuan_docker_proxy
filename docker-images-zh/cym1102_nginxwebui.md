---
image: cym1102/nginxwebui
description: "nginxWebUI是一款专为简化nginx配置管理设计的图形化工具，用户可通过直观的网页界面快速完成反向代理、负载均衡、SSL证书配置、虚拟主机设置等nginx核心功能的配置与管理，无需手动编辑复杂的配置文件，有效降低操作门槛，提升配置效率，适用于各类需要高效管理nginx服务器的场景。"
source: https://xuanyuan.cloud/zh/r/cym1102/nginxwebui
canonical: https://xuanyuan.cloud/zh/r/cym1102/nginxwebui
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cym1102/nginxwebui" title="cym1102/nginxwebui Docker 镜像中文简介、标签列表与拉取命令">cym1102/nginxwebui — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/cym1102/nginxwebui" title="cym1102/nginxwebui Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/cym1102/nginxwebui</a>

# nginxWebUI


## 介绍

nginxWebUI 是一款图形化管理 nginx 配置的工具。以下是相关资源链接：  
- QQ 技术交流群1：1106758598  
- QQ 技术交流群2：560797506  
- 邮箱：[邮箱已删除]  
- 官网地址：[[]]([])  
- GitHub：[[]]([])  
- Gitee：[[]]([])  

微信捐赠二维码：  
![微信捐赠二维码]([])  


## 功能说明

nginxWebUI 可通过网页快速配置 nginx 的各项功能，包括 http 协议转发、tcp 协议转发、反向代理、负载均衡、静态 HTML 服务器、ssl 证书自动申请/续签/配置等。配置完成后可一键生成 nginx.conf 文件，并控制 nginx 启动与重载，形成图形化管理闭环。  

支持管理多台 nginx 服务器集群，可一键切换服务器进行配置，或一键同步某台服务器的配置到其他节点，方便集群统一管理。  

工具覆盖 nginx 日常 90% 的功能配置需求，未涵盖的配置项可通过自定义参数模板补充。部署后无需手动编写配置代码或处理 ssl 证书，通过增删改查即可完成 nginx 配置与启动。  

演示地址：[[]]([])  
用户名：admin  
密码：Admin123  


## 技术说明

### 基础架构  
基于 Spring Boot 开发，采用 SQLite 数据库，服务器无需额外安装数据库。项目启动时会在系统用户文件夹生成 `.sqlite.db` 文件，**注意定期备份此文件**。  

### 证书管理  
通过 Let's Encrypt 申请证书，使用 acme.sh 脚本自动化处理申请与续签。开启续签的证书将在每日凌晨 2 点自动续签，仅处理有效期超过 60 天的证书，且仅支持 Linux 环境。  

### TCP 转发支持  
配置 TCP/IP 转发时，低版本 nginx 可能需重新编译并添加 `--with-stream` 参数以启用 stream 模块。Ubuntu 18.04 及以上版本的官方软件库中，nginx 已内置 stream 模块，无需额外操作。系统会根据是否配置 TCP 转发自动引入 `ngx_stream_module.so`，未配置时不引入以优化配置。  


## Docker 安装说明

### 1. 安装 Docker 环境  
- Ubuntu：  
  ```bash  
  apt install docker.io  
  ```  
- CentOS：  
  ```bash  
  yum install docker  
  ```  

### 2. 拉取镜像  
```bash  
docker pull cym1102/nginxwebui:latest  
```  

### 3. 启动容器  
```bash  
docker run -itd -v /home/nginxWebUI:/home/nginxWebUI -e BOOT_OPTIONS="--server.port=8080" --privileged=true --net=host cym1102/nginxwebui:latest  
```  

#### 注意事项  
- **端口映射**：需使用 `--net=host` 参数直接映射本机所有端口，因内部 nginx 可能使用任意端口。  
- **数据持久化**：映射路径 `/home/nginxWebUI:/home/nginxWebUI` 存放数据库、配置文件、日志、证书等数据，升级镜像时保留此目录可避免数据丢失，建议定期备份。  
- **启动参数**：`-e BOOT_OPTIONS` 可自定义 Java 启动参数，如 `--server.port=8080` 指定端口（默认 8080）。  
- **日志位置**：日志默认存于 `/home/nginxWebUI/log/nginxWebUI.log`。  

#### Docker Compose 配置  
```yaml  
version: "3.2"  
services:  
  nginxWebUi-server:  
    image: cym1102/nginxwebui:latest  
    volumes:  
      - type: bind  
        source: "/home/nginxWebUI"  
        target: "/home/nginxWebUI"  
    environment:  
      BOOT_OPTIONS: "--server.port=8080"  
    privileged: true  
    network_mode: "host"  
```  


## 使用说明

访问 `[] 进入系统，首次登录需初始化管理员账号。  

### 核心功能  

#### 管理员管理  
登录后可在“管理员管理”中添加或修改账号。  

#### HTTP/TCP 参数配置  
- **HTTP 配置**：在“HTTP 参数配置”中添加常用配置项，支持增删改查，可勾选“开启日志跟踪”生成日志文件。  
- **TCP 配置**：“TCP 参数配置”用于设置 stream 模块参数，多数场景下无需额外配置。  

#### 反向代理与负载均衡  
- **反向代理**：在“反向代理”中配置 server 项，支持启用 SSL（上传 PEM/KEY 文件或选择系统内证书）、HTTP 转 HTTPS 跳转、HTTP2 协议。  
- **负载均衡**：在“负载均衡”中配置 upstream 项，反向代理时可选择代理目标为已配置的负载均衡。  

#### 静态 HTML 管理  
通过“HTML 静态文件上传”直接上传压缩包至指定路径，上传后可在反向代理中直接使用，省去手动上传文件步骤。  

#### 证书管理  
在“证书管理”中添加证书并启用签发/续签，开启定时续签后系统自动处理过期证书。**注意**：证书签发使用 acme.sh 的 DNS 模式，需提前准备阿里云的 aliKey 和 aliSecret。  

#### 备份与配置生成  
- **备份管理**：“备份文件管理”中可查看 nginx.conf 的历史版本，出现配置错误时可回滚至之前版本。  
- **conf 文件生成**：在“生成 conf 文件”页面可手动修改配置，确认无误后覆盖本机 conf 文件，支持校验并重启 nginx，可选择生成单一 nginx.conf 或按域名拆分至 conf.d 目录。  

#### 远程服务器管理  
若需管理多台 nginx 服务器，可在各服务器部署 nginxWebUI 后，在其中一台的“远程服务器管理”中添加其他服务器的 IP、用户名和密码，实现统一管理。支持一键同步某台服务器的配置与证书至其他节点。  


## 接口开发

启用接口需在启动参数中添加 `--knife4j.production=false`，访问 `[] 查看 knife4j 接口文档。  

接口调用需在请求头中添加 token，获取方式：在“管理员管理”中开启用户的接口调用权限，通过用户名密码调用“获取 token 接口”获取。文档中带 `*` 前缀的参数为必填项。  


## 找回密码

若忘记登录密码，可通过以下步骤重置：  

1. 安装 sqlite3 命令：  
   ```bash  
   apt install sqlite3  
   ```  

2. 读取数据库文件：  
   ```bash  
   sqlite3 /home/nginxWebUI/sqlite.db  
   ```  

3. 查询管理员表：  
   ```sql  
   select * from admin;  
   ```  

4. 退出 sqlite3：  
   ```bash  
   .quit  
   ```
