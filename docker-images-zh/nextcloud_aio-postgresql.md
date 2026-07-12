---
image: nextcloud/aio-postgresql
description: "Nextcloud All-in-One Docker镜像集成Nextcloud服务器及所需组件，提供一站式解决方案，用于快速部署和使用个人或企业云存储与协作平台。"
source: https://xuanyuan.cloud/zh/r/nextcloud/aio-postgresql
canonical: https://xuanyuan.cloud/zh/r/nextcloud/aio-postgresql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nextcloud/aio-postgresql" title="nextcloud/aio-postgresql Docker 镜像中文简介、标签列表与拉取命令">nextcloud/aio-postgresql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nextcloud All-in-One (AIO) Docker镜像文档


## 1. 镜像概述

Nextcloud All-in-One (AIO) 是一个集成化Docker镜像，旨在简化Nextcloud私有云平台的部署与管理。该镜像整合了Nextcloud核心应用、数据库（PostgreSQL）、Redis缓存、Nginx Web服务器、HTTPS证书管理（Let's Encrypt）等所有必要组件，用户无需手动配置各服务依赖，即可快速搭建功能完整的Nextcloud环境。


## 2. 核心功能与特性

### 2.1 一站式部署
- 内置所有依赖组件（Nextcloud、PostgreSQL、Redis、Nginx、Certbot），无需分步配置
- 自动处理组件间网络连接与权限配置


### 2.2 安全与可靠性
- 默认启用HTTPS（通过Let's Encrypt自动签发证书）
- 定期安全更新与漏洞修复
- 数据持久化存储设计，避免容器重启导致数据丢失


### 2.3 易用性与可维护性
- 提供Web管理界面，支持配置调整、服务监控与日志查看
- 自动更新机制（可配置）
- 资源占用优化，适配低配置设备（如树莓派）


### 2.4 功能完整性
- 支持文件同步、共享、版本控制
- 集成日历、联系人、任务管理等协作工具
- 兼容Nextcloud应用商店扩展（如OnlyOffice、视频会议插件）


## 3. 使用场景与适用范围

### 3.1 个人用户
- 私有文件存储与跨设备同步（替代Dropbox、Google Drive）
- 家庭照片/视频备份与共享


### 3.2 小型团队
- 内部文件协作与版本管理
- 项目文档集中存储与权限控制


### 3.3 非专业运维场景
- 无需深入了解Linux服务配置即可部署私有云
- 适合技术背景有限但需要私有云解决方案的用户/组织


## 4. 使用方法与配置说明

### 4.1 前提条件
- 操作系统：Linux（推荐Ubuntu 20.04+、Debian 11+）
- 环境依赖：Docker Engine 20.10+、Docker Compose v2+
- 硬件要求：至少2GB RAM、20GB可用磁盘空间（推荐4GB RAM+、SSD存储）
- 网络要求：公网IP（如需HTTPS）、开放80/443端口（或自定义端口映射）


### 4.2 部署步骤

#### 4.2.1 安装Docker与Docker Compose
```bash
# 安装Docker（以Ubuntu为例）
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker $USER  # 允许当前用户管理Docker（需重启终端生效）
```


#### 4.2.2 快速部署（docker run）
```bash
docker run -d \
  --name nextcloud-aio-mastercontainer \
  --restart always \
  -p 8080:8080 \
  -e NEXTCLOUD_DATADIR="/path/to/nextcloud/data" \  # 宿主机数据目录（需提前创建）
  -v nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  nextcloud/all-in-one:latest
```

> 说明：  
> - 容器启动后，访问 `http://<服务器IP>:8080` 进入AIO管理界面，按指引完成剩余配置  
> - `/path/to/nextcloud/data` 需替换为宿主机实际目录（如 `/home/user/nextcloud_data`）


#### 4.2.3 Docker Compose部署
创建 `docker-compose.yml` 文件：
```yaml
version: '3.8'

services:
  nextcloud-aio-mastercontainer:
    image: docker.xuanyuan.run/nextcloud/all-in-one:latest
    container_name: nextcloud-aio-mastercontainer
    restart: always
    ports:
      - "8080:8080"  # AIO管理界面端口
    environment:
      - NEXTCLOUD_DATADIR="/path/to/nextcloud/data"  # 数据持久化目录
      - NEXTCLOUD_ADMIN_USER="admin"  # 可选：默认管理员用户名（管理界面可修改）
      - NEXTCLOUD_ADMIN_PASSWORD="secure_password"  # 可选：默认管理员密码（管理界面可修改）
      - SKIP_DOMAIN_VALIDATION="false"  # 是否跳过域名验证（仅测试用）
    volumes:
      - nextcloud_aio_mastercontainer:/mnt/docker-aio-config
      - /var/run/docker.sock:/var/run/docker.sock:ro  # 需Docker权限

volumes:
  nextcloud_aio_mastercontainer:  # 存储AIO配置数据
```

启动服务：
```bash
docker-compose up -d
```


### 4.3 核心配置参数

#### 4.3.1 环境变量（Environment Variables）
| 参数名                  | 说明                                  | 默认值                  |
|-------------------------|---------------------------------------|-------------------------|
| `NEXTCLOUD_DATADIR`     | 宿主机Nextcloud数据存储路径           | 无（需手动指定）        |
| `NEXTCLOUD_ADMIN_USER`  | 管理员用户名                          | "admin"（管理界面可改） |
| `NEXTCLOUD_ADMIN_PASSWORD` | 管理员密码                          | 随机生成（管理界面显示）|
| `HTTP_PORT`             | HTTP访问端口（用于Let's Encrypt验证） | 80                      |
| `HTTPS_PORT`            | HTTPS访问端口                         | 443                     |
| `SKIP_DOMAIN_VALIDATION`| 是否跳过域名验证（仅测试环境）        | "false"                 |
| `AIO_DISABLE_BACKUPS`   | 是否禁用自动备份                      | "false"                 |


#### 4.3.2 端口映射
| 容器端口 | 宿主机端口 | 用途                  |
|----------|------------|-----------------------|
| 8080     | 8080       | AIO管理界面           |
| 80       | 80         | HTTP访问（HTTPS验证用）|
| 443      | 443        | HTTPS访问（Nextcloud服务）|


### 4.4 HTTPS配置
AIO默认支持通过Let's Encrypt自动配置HTTPS，需满足：
1. 服务器拥有公网IP
2. 已解析域名至服务器IP（如 `cloud.example.com`）
3. 开放宿主机80/443端口（需在防火墙/路由器中放行）

配置步骤：
1. 在AIO管理界面（`http://<IP>:8080`）输入域名（如 `cloud.example.com`）
2. 选择“自动配置HTTPS”，系统将自动申请并部署证书


### 4.5 更新与维护
#### 4.5.1 手动更新
```bash
# 停止当前容器
docker stop nextcloud-aio-mastercontainer
# 拉取最新镜像
docker pull docker.xuanyuan.run/nextcloud/all-in-one:latest
# 重启容器（自动更新所有组件）
docker start nextcloud-aio-mastercontainer
```

#### 4.5.2 自动更新（推荐）
在AIO管理界面启用“自动更新”功能，系统将每周检查并应用更新。


#### 4.5.3 数据备份
默认数据存储在宿主机 `NEXTCLOUD_DATADIR` 目录，建议定期备份该目录：
```bash
tar -czf nextcloud_backup_$(date +%Y%m%d).tar.gz /path/to/nextcloud/data
```


## 5. 注意事项
- **数据安全**：务必将 `NEXTCLOUD_DATADIR` 映射至宿主机持久化目录，避免容器删除导致数据丢失
- **性能优化**：低配置设备（如树莓派）建议关闭不必要功能（如预览生成），通过Nextcloud管理界面调整资源限制
- **网络安全**：生产环境需禁用 `SKIP_DOMAIN_VALIDATION`，并保持HTTPS强制启用
- **日志查看**：通过AIO管理界面“日志”选项卡或执行 `docker logs nextcloud-aio-mastercontainer` 查看运行日志


## 6. 参考链接
- 官方文档：[https://github.com/nextcloud/all-in-one](https://github.com/nextcloud/all-in-one)
- Nextcloud官方网站：[https://nextcloud.com](https://nextcloud.com)
