---
image: gpdm/nut-webui
description: "nut-webui Docker镜像为Network UPS Tools（NUT）提供基于Web的用户界面。"
source: https://xuanyuan.cloud/zh/r/gpdm/nut-webui
canonical: https://xuanyuan.cloud/zh/r/gpdm/nut-webui
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gpdm/nut-webui" title="gpdm/nut-webui Docker 镜像中文简介、标签列表与拉取命令">gpdm/nut-webui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# nut-webui Docker镜像文档


## 镜像概述与主要用途  
nut-webui 是一个 Docker 镜像，实现了 Network UPS Tools (NUT) 的基于 Web 的用户界面，用于通过浏览器监控和管理 NUT 服务（upsd 守护进程）控制的 UPS 设备。该镜像基于 Nginx 运行，提供直观的 Web 界面展示 UPS 状态信息。


## 核心功能与特性  
- **Web 界面支持**：提供基于 Web 的 UPS 状态监控界面，集成 NUT 的 upsstats CGI 工具。  
- **多协议支持**：基于 Nginx 运行，支持 HTTP（80/TCP）和 HTTPS（443/TCP）访问。  
- **配置灵活性**：通过卷挂载自定义 NUT 配置文件，支持个性化监控需求。  
- **SSL/TLS 加密**：可配置 HTTPS 加密访问，保障数据传输安全。  


## 使用场景与适用范围  
适用于需要通过 Web 界面监控 UPS 设备状态的场景，包括：  
- 企业服务器机房、数据中心的 UPS 集中监控；  
- 家庭实验室或个人服务器的 UPS 状态管理；  
- 任何部署了 NUT 服务（upsd 守护进程）并需要可视化监控 UPS 运行状态的环境。  


## 使用方法  

### 拉取镜像  
通过以下命令拉取镜像：  
```bash
docker pull docker.xuanyuan.run/gpdm/nut-webui[:<tag>]
```  
**标签说明**：  
- `latest`：最新构建版本（可能包含未稳定特性）；  
- 版本特定标签（如有）：冻结的稳定版本。  


### 启动容器  
基本运行命令示例：  
```bash
docker run -d \
  -p 80:80 \
  -v /path/to/nut-config:/etc/nut \
  [-p 443:443 -v /path/to/ssl-certs:/etc/ssl -e SSL_PRIVATE_KEY=ssl-cert-snakeoil.key -e SSL_CERTIFICATE=ssl-cert-snakeoil.pem] \
  gpdm/nut-webui[:<tag>]
```  
**参数说明**：  
- `-d`：后台运行容器；  
- `-p 80:80`：映射 HTTP 端口；  
- `-v /path/to/nut-config:/etc/nut`：挂载 NUT 配置文件目录；  
- 可选参数（启用 HTTPS）：`-p 443:443`（映射 HTTPS 端口）、`-v /path/to/ssl-certs:/etc/ssl`（挂载 SSL 证书目录）、环境变量指定证书文件。  


## 配置说明  

### 端口配置  
容器默认暴露以下端口：  
- **80/TCP**：HTTP 访问端口；  
- **443/TCP**：HTTPS 访问端口（需手动配置 SSL 证书启用）。  


### upsstats 核心配置  
upsstats CGI 工具依赖以下配置文件，**必须通过卷挂载提供**，无法通过环境变量配置：  
- `upsset.conf`：UPS 控制权限配置；  
- `hosts.conf`：UPS 主机列表配置；  
- `upsstats.html`：UPS 状态汇总页面模板；  
- `upsstats-single.html`：单个 UPS 状态详情页面模板。  

**配置步骤**：  
1. 使用文本编辑器创建上述 4 个配置文件（参考 [NUT 官方文档](https://networkupstools.org/docs/)）；  
2. 将文件保存至本地持久化目录（如 `/data/nut-webui/config`）；  
3. 启动容器时通过 `-v /data/nut-webui/config:/etc/nut` 挂载该目录至容器内 `/etc/nut`。  

> **注意**：若未挂载包含上述文件的卷，容器将启动失败。  


### 启用 TLS/SSL  
通过以下步骤配置 HTTPS 加密访问：  
1. 生成 SSL 私钥和证书文件（如 `ssl-cert-snakeoil.key` 和 `ssl-cert-snakeoil.pem`）；  
2. 将证书文件保存至本地目录（如 `/data/nut-webui/certs`）；  
3. 启动容器时挂载证书目录并配置环境变量：  
   ```bash
   docker run -d \
     -p 80:80 -p 443:443 \
     -v /path/to/nut-config:/etc/nut \
     -v /data/nut-webui/certs:/etc/ssl \
     -e SSL_PRIVATE_KEY=ssl-cert-snakeoil.key \
     -e SSL_CERTIFICATE=ssl-cert-snakeoil.pem \
     docker.xuanyuan.run/gpdm/nut-webui[:<tag>]
   ```  

**配置要求**：  
- 私钥文件权限需设置为 `0600`、`0400` 或 `0640`；  
- 环境变量 `SSL_PRIVATE_KEY` 和 `SSL_CERTIFICATE` 需使用相对路径（如 `ssl-cert-snakeoil.key`，而非绝对路径）；  
- 若未提供 SSL 配置，容器将使用内置自签名证书启动；若提供配置但验证失败（如文件路径错误、权限不当），容器将启动失败。  


## 部署示例  

### docker-compose 配置示例  
创建 `docker-compose.yml` 文件：  
```yaml
version: '3'
services:
  nut-webui:
    image: docker.xuanyuan.run/gpdm/nut-webui:latest
    container_name: nut-webui
    restart: unless-stopped
    ports:
      - "80:80"    # HTTP 端口
      - "443:443"  # HTTPS 端口（可选）
    volumes:
      - /data/nut-webui/config:/etc/nut    # 挂载 NUT 配置文件
      - /data/nut-webui/certs:/etc/ssl     # 挂载 SSL 证书（可选）
    environment:
      - SSL_PRIVATE_KEY=ssl-cert-snakeoil.key   # SSL 私钥文件名（可选）
      - SSL_CERTIFICATE=ssl-cert-snakeoil.pem   # SSL 证书文件名（可选）
```  
通过 `docker-compose up -d` 启动服务。  


## 界面截图  
- **主视图**：  
  ![主视图](https://raw.githubusercontent.com/gpdm/nut/master/nut-webui/docs/main.png)  

- **详情视图**：  
  ![详情视图](https://raw.githubusercontent.com/gpdm/nut/master/nut-webui/docs/detail.png)  


## 注意事项  
- 容器启动前必须确保 `/etc/nut` 卷挂载了所有必要的配置文件（`upsset.conf` 等），否则启动失败；  
- SSL 私钥文件需严格控制权限，避免权限过松导致安全风险；  
- 建议使用版本特定标签（而非 `latest`）以保证部署稳定性。
