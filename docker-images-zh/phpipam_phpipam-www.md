---
image: phpipam/phpipam-www
description: "phpIPAM是一款基于Web的开源IP地址管理应用程序（IPAM），其源代码开放且免费使用，用户可通过浏览器便捷访问，主要功能包括IP地址的分配、跟踪、规划与监控，能有效记录地址使用状态、关联设备信息、预防地址冲突，适用于企业、机构等各类网络环境的IP资源管理需求。"
source: https://xuanyuan.cloud/zh/r/phpipam/phpipam-www
canonical: https://xuanyuan.cloud/zh/r/phpipam/phpipam-www
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/phpipam/phpipam-www" title="phpipam/phpipam-www Docker 镜像中文简介、标签列表与拉取命令">phpipam/phpipam-www — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/phpipam/phpipam-www" title="phpipam/phpipam-www Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/phpipam/phpipam-www</a>

# phpIPAM Apache2 容器部署说明


## 适用人群  
phpIPAM 的典型用户（网络管理员）通常对 LAMP 栈经验有限，这些 Docker 镜像提供了更简单的方式来创建和维护可用的 phpIPAM 环境。考虑到目标用户，设计上优先考虑简洁性而非复杂性，因此不支持部分高级用例。  

原生 SSL 支持可通过 DockerHub 上的反向 HTTPS 代理镜像实现（如 HAProxy，详见下文示例）。如需高级用例，可参考官方文档 [[]]([]) 在虚拟机中手动安装。


## 源码与问题反馈  
- **Dockerfile 构建源码**：[[]]([])  
- **容器相关问题/PR**：同上仓库  
- **phpIPAM 应用本身问题/PR**：[[]]([])  


## 容器镜像  
- `phpipam-www`：前端 Apache/PHP 容器，处理 Web 请求。  
- `phpipam-cron`：定时任务容器，用于网络发现等周期性任务。  

**部署注意**：  
- `phpipam-www` 支持多实例部署并负载均衡。  
- `phpipam-cron` 仅支持单实例运行（避免任务重复执行）。  


## 权限与能力  
- **不支持无根 Docker**（Rootless Docker）。  
- **Docker 环境**：需添加 `NET_ADMIN` 和 `NET_RAW` 容器能力，以支持 ping 和 SNMP 功能。  
- **Kubernetes 环境**：需设置 `allowPrivilegeEscalation=true`。  


## 支持的镜像标签  
| 标签格式          | 说明                                                                 |  
|-------------------|----------------------------------------------------------------------|  
| `latest`          | 跟踪最新稳定版 + Alpine Linux 安全更新                               |  
| `1.7x`            | 跟踪 1.7 维护分支 + Alpine Linux 安全更新                            |  
| `1.6x`/`1.5x`/`1.4x` | 分别跟踪 1.6/1.5/1.4 维护分支（已过时）                              |  
| `nightly`         | 每日开发快照（非生产环境，不稳定）                                   |  
| `v1.7.x`/`v1.6.y`  | 静态快照版本，不含 Alpine Linux 安全更新                             |  


## 使用方法  

### Docker 独立部署（含数据库）  
通过 docker-compose 快速部署完整栈（含 MariaDB 数据库）：  

1. 将以下配置保存为 `docker-compose.yml`，**替换示例密码为安全密钥**（如 `my_secret_phpipam_pass` 和 `my_secret_mysql_root_pass`）。  
2. 在配置文件所在目录运行 `docker-compose -p phpIPAM up -d` 启动服务。  

```yaml
# 警告：请将示例密码替换为安全的密钥。
# 警告：替换 'my_secret_phpipam_pass' 和 'my_secret_mysql_root_pass'

version: '3'

services:
  phpipam-web:
    image: phpipam/phpipam-www:latest
    ports:
      - "80:80"  # Web 端口映射
    environment:
      - TZ=Europe/London  # 时区设置，如 Asia/Shanghai
      - IPAM_DATABASE_HOST=phpipam-mariadb  # 数据库容器名
      - IPAM_DATABASE_PASS=my_secret_phpipam_pass  # 数据库密码
      - IPAM_DATABASE_WEBHOST=%  # 允许所有主机访问数据库（生产环境建议限制）
    restart: unless-stopped
    volumes:
      - phpipam-logo:/phpipam/css/images/logo  # 自定义 logo 挂载
      - phpipam-ca:/usr/local/share/ca-certificates:ro  # 可信 CA 证书
    depends_on:
      - phpipam-mariadb  # 依赖数据库容器

  phpipam-cron:
    image: phpipam/phpipam-cron:latest
    environment:
      - TZ=Europe/London
      - IPAM_DATABASE_HOST=phpipam-mariadb
      - IPAM_DATABASE_PASS=my_secret_phpipam_pass
      - SCAN_INTERVAL=1h  # 网络发现间隔（可选：5m/10m/15m/30m/1h/2h/4h/6h/12h）
    restart: unless-stopped
    volumes:
      - phpipam-ca:/usr/local/share/ca-certificates:ro
    depends_on:
      - phpipam-mariadb

  phpipam-mariadb:
    image: mariadb:latest  # 数据库容器
    environment:
      - MYSQL_ROOT_PASSWORD=my_secret_mysql_root_pass  # 数据库 root 密码
    restart: unless-stopped
    volumes:
      - phpipam-db-data:/var/lib/mysql  # 数据库数据持久化

volumes:
  phpipam-db-data:  # 数据库数据卷
  phpipam-logo:     # Logo 数据卷
  phpipam-ca:       # CA 证书数据卷
```  


### 对接外部 MySQL 服务器  
若使用现有 MySQL 服务器，修改 `docker-compose.yml` 如下（无需部署数据库容器）：  

```yaml
version: '3'

services:
  phpipam-web:
    image: phpipam/phpipam-www:latest
    ports:
      - "80:80"
    environment:
      - TZ=Europe/London
      - IPAM_DATABASE_HOST=my.database.server  # 外部数据库主机
      - IPAM_DATABASE_USER=existing_username   # 数据库用户名
      - IPAM_DATABASE_PASS=existing_password   # 数据库密码
      - IPAM_DATABASE_NAME=existing_db_name    # 数据库名
    restart: unless-stopped
    volumes:
      - phpipam-logo:/phpipam/css/images/logo
      - phpipam-ca:/usr/local/share/ca-certificates:ro

  phpipam-cron:
    image: phpipam/phpipam-cron:latest
    environment:
        - TZ=Europe/London
        - IPAM_DATABASE_HOST=my.database.server
        - IPAM_DATABASE_USER=existing_username
        - IPAM_DATABASE_PASS=existing_password
        - IPAM_DATABASE_NAME=existing_db_name
        - SCAN_INTERVAL=1h
    restart: unless-stopped
    volumes:
      - phpipam-ca:/usr/local/share/ca-certificates:ro

volumes:
  phpipam-logo:
  phpipam-ca:
```  


## 配置说明  

### 环境变量配置  
可通过环境变量调整 phpIPAM 配置（部分支持从文件读取敏感信息，变量名后加 `_FILE` 即可，如 `IPAM_DATABASE_PASS_FILE=/run/secrets/pass`）。  

| 环境变量                  | 默认值                | 适用容器（前端/定时任务） | 说明                                                                 |  
|---------------------------|-----------------------|:----------------------:|----------------------------------------------------------------------|  
| **TZ**                    | "UTC"                 |         ✅ ✅          | 时区（如 "Asia/Shanghai"）                                           |  
| **IPAM_DISABLE_INSTALLER**📂 | "false"               |         ✅ ❌          | 禁用安装助手脚本（v1.6.1+），建议初始配置后设为 `1`                  |  
| **IPAM_DATABASE_HOST**📂   | "127.0.0.1"           |         ✅ ✅          | 数据库主机地址                                                       |  
| **IPAM_DATABASE_USER**📂   | "phpipam"             |         ✅ ✅          | 数据库用户名                                                         |  
| **IPAM_DATABASE_PASS**📂   | "phpipamadmin"        |         ✅ ✅          | 数据库密码                                                           |  
| **IPAM_DATABASE_NAME**📂   | "phpipam"             |         ✅ ✅          | 数据库名                                                             |  
| **IPAM_DATABASE_PORT**📂   | 3306                  |         ✅ ✅          | 数据库端口                                                           |  
| **IPAM_BASE**             | "/"                   |         ✅ ❌          | 反向代理路径（如 []               |  
| **SCAN_INTERVAL**         | "1h"                  |         ❌ ✅          | 定时任务间隔（仅 `phpipam-cron` 生效）                               |  

> 📂 标记变量支持通过文件读取值（如 Docker secrets），其他变量直接传值即可。  


### 容器内自定义 config.php  
从 v1.5.0 起，可通过 `IPAM_CONFIG_FILE` 环境变量加载自定义配置文件（需挂载到持久卷）。此时仅以下环境变量生效，其他配置需手动在 `config.php` 中设置：  

| 环境变量              | 默认值    | 适用容器（前端/定时任务） | 说明                                  |  
|-----------------------|-----------|:----------------------:|---------------------------------------|  
| **TZ**                | "UTC"     |         ✅ ✅          | 时区                                  |  
| **IPAM_CONFIG_FILE**  | ""        |         ✅ ✅          | 配置文件路径（如 "/config/config.php"）|  
| **SCAN_INTERVAL**     | "1h"      |         ❌ ✅          | 定时任务间隔                          |  

**负载均衡注意**：多实例部署时，需在 `config.php` 中设置 `$session_storage = "database";` 确保会话一致性。  


## 可信 CA 证书  
容器启动时会自动运行 `update-ca-certificates`，加载 `/usr/local/share/ca-certificates` 目录下的 PEM 格式证书。挂载持久卷到该目录即可添加自定义 CA：  

```bash
# 示例：容器内证书目录结构
/usr/local/share/ca-certificates/
├── ACME_ROOT.crt       # 根证书
└── ACME_INTERMEDIATE.crt  # 中间证书
```  


## HAProxy SSL 反向代理示例  
通过 HAProxy 实现 HTTPS 访问（需提前准备 SSL 证书）：  

### 1. 创建 HAProxy 容器  
```bash
docker run -d -p 443:443 -p 80:80 --name HAProxy --restart always \
  -v haproxy_ssl:/etc/ssl/certs -v haproxy_cfg:/usr/local/etc/haproxy \
  haproxy:latest
```  

### 2. 配置 HAProxy  
进入容器，创建 `/usr/local/etc/haproxy/haproxy.cfg`：  

```text
# 示例 haproxy.cfg 配置
global
  daemon
  maxconn 256

resolvers mydns
  nameserver ns1 192.168.1.53:53  # 替换为内部 DNS 服务器 IP
  nameserver ns2 192.168.2.53:53
  accepted_payload_size 8192

defaults
  mode http
  timeout connect 5000ms
  timeout client  5000ms
  timeout server 60000ms
  option forwardfor

frontend phpipam-rp
  bind *:80
  bind *:443 ssl crt /etc/ssl/certs  # SSL 证书目录
  http-request redirect scheme https code 301 unless { ssl_fc }  # HTTP 重定向到 HTTPS
  default_backend phpipam-web
  http-request del-header X-Forwarded-For

backend phpipam-web
  server s1 phpipam.local:80 check resolvers mydns init-addr none  # 替换为 phpipam 容器的内部 DNS 名
  http-request set-header X-Forwarded-Uri %[url]
  http-request set-header X-Forwarded-Port %[dst_port]
  http-request add-header X-Forwarded-Proto https if { ssl_fc }
```  

### 3. 挂载 SSL 证书  
将证书文件（全链证书 `ipam.crt` 和密钥 `ipam.crt.key`）放入宿主机的 `haproxy_ssl` 卷中，容器内路径为 `/etc/ssl/certs`。  

### 4. 启动并验证  
```bash
docker restart HAProxy  # 重启容器
docker logs HAProxy     # 检查日志是否有错误
```  


## 许可证  
GNU General Public License v3.0  


## 维护者  
Gary Allan（邮箱：[邮箱已删除]）
