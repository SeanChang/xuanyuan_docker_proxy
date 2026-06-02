<!-- xuanyuan-docker-images-zh
image: bitnami/php-fpm
source: https://xuanyuan.cloud/zh/r/bitnami/php-fpm
canonical: https://xuanyuan.cloud/zh/r/bitnami/php-fpm
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnami/php-fpm" title="bitnami/php-fpm Docker 镜像中文简介、标签列表与拉取命令">bitnami/php-fpm — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/bitnami/php-fpm" title="bitnami/php-fpm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/php-fpm</a></p>

# Bitnami PHP-FPM 软件包介绍


## 什么是 PHP-FPM？

PHP-FPM（FastCGI 进程管理器）是 PHP FastCGI 的替代实现，具备额外功能，适用于各种规模的网站，尤其适合访问量较大的站点。

[PHP-FPM 概述]([])  
**商标说明**：本软件包由 Bitnami 打包提供，相关商标归各自公司所有，使用商标不代表关联或背书。


## 快速开始

```console
docker run -it --name phpfpm -v /path/to/app:/app bitnami/php-fpm
```

本镜像是由 Bitnami 构建和维护的强化版最小漏洞（CVE）镜像，基于云优化、安全强化的企业级操作系统 [Photon Linux]([])。选择 Bitnami 安全镜像（BSI）的理由包括：  
- 热门开源软件的强化安全镜像，漏洞数量接近零  
- 提供漏洞分类与优先级排序（含 VEX 声明、KEV 和 EPSS 评分）  
- 聚焦合规性，支持 FIPS、STIG 和离线部署，包含安全软件物料清单（SBOM）  
- 通过 in-toto 提供软件供应链溯源证明  
- 原生支持主流 Helm 图表  


## 支持的标签与标签策略

Bitnami 容器镜像采用滚动标签与不可变标签策略，详情可参考 [标签策略文档]([])。各标签对应关系可查看分支文件夹中的 `tags-info.yaml` 文件（如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）。  

**废弃说明**：  
- 2022-01-21：移除 `prod` 标签，仅发布常规容器镜像。  
- 2020-08-18：调整 `prod` 标签格式（如 `BRANCH-debian-10-prod` 变更为 `BRANCH-prod-debian-10`）。  


## 获取镜像

### 从 Docker Hub 拉取（推荐）
直接拉取预构建镜像：  
```console
# 拉取最新版
docker pull bitnami/php-fpm:latest

# 拉取特定版本（查看[可用版本列表]([])）
docker pull bitnami/php-fpm:[TAG]
```

### 从源码构建
克隆仓库并构建：  
```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM  # 替换为实际路径（如 bitnami/php-fpm/8.2/photon）
docker build -t bitnami/APP:latest .
```


## 与其他容器联动（以 Nginx 为例）

PHP-FPM 需配合 Web 服务器（如 Nginx）提供服务，通过 Docker 网络实现容器通信。以下为 Nginx 前端代理 PHP-FPM 的完整流程。

### 步骤 1：创建网络
```console
docker network create app-tier --driver bridge
```
或使用 Docker Compose：  
```yaml
version: '2'
networks:
  app-tier:
    driver: bridge
```

### 步骤 2：创建 Nginx 服务器配置块
创建 `server_block.conf` 配置反向代理至 PHP-FPM：  
```nginx
server {
  listen 0.0.0.0:80;
  server_name myapp.com;
  root /app;

  location / {
    try_files $uri $uri/index.php;  # 尝试静态文件或 index.php
  }

  location ~ \.php$ {
    fastcgi_pass phpfpm:9000;  # 指向 PHP-FPM 容器（需与容器名称一致）
    fastcgi_index index.php;
    include fastcgi.conf;
  }
}
```

### 步骤 3：启动 PHP-FPM 容器
指定名称并加入网络，挂载应用代码目录：  
```console
docker run -it --name phpfpm \
  --network app-tier \
  -v /path/to/app:/app  # 挂载主机 PHP 应用目录至容器 /app
  bitnami/php-fpm
```
或 Docker Compose：  
```yaml
services:
  phpfpm:
    image: bitnami/php-fpm:latest
    networks: [app-tier]
    volumes: [/path/to/app:/app]
```

### 步骤 4：启动 Nginx 容器
挂载服务器配置块并暴露端口：  
```console
docker run -it \
  -v /path/to/server_block.conf:/opt/bitnami/nginx/conf/server_blocks/yourapp.conf \
  --network app-tier \
  -p 80:80  # 暴露 80 端口
  bitnami/nginx
```
或 Docker Compose：  
```yaml
services:
  nginx:
    image: bitnami/nginx:latest
    depends_on: [phpfpm]
    networks: [app-tier]
    ports: [80:80, 443:443]
    volumes:
      - /path/to/server_block.conf:/opt/bitnami/nginx/conf/server_blocks/yourapp.conf
```


## PHP 运行时使用

### 进入交互式 shell（REPL）
通过 `php -a` 启动 PHP 交互式环境：  
```console
docker run -it --name phpfpm bitnami/php-fpm php -a
```

### 运行 PHP 脚本
挂载应用目录并执行脚本（默认工作目录为 `/app`）：  
```console
docker run -it --name php-fpm -v /path/to/app:/app bitnami/php-fpm \
  php script.php  # 替换为实际脚本名
```


## 配置说明

### 环境变量
#### 自定义环境变量（部分）
| 变量名                | 描述                          | 默认值                |
|-----------------------|-------------------------------|-----------------------|
| PHP_FPM_LISTEN_ADDRESS | 监听地址（端口/套接字路径）   | /opt/bitnami/php/var/run/www.sock |
| PHP_DATE_TIMEZONE      | PHP 时区                      | 未设置                |
| PHP_MEMORY_LIMIT       | 脚本内存限制                  | 未设置                |
| PHP_UPLOAD_MAX_FILESIZE | 上传文件大小限制              | 未设置                |

#### 只读环境变量（部分）
包含安装路径、配置文件位置等固定信息，如：  
- `PHP_BASE_DIR`: PHP 安装目录（`/opt/bitnami/php`）  
- `PHP_CONF_DIR`: 配置文件目录（`/opt/bitnami/php/etc`）  
- `PHP_FPM_LOG_FILE`: 日志文件路径（`/opt/bitnami/php/logs/php-fpm.log`）  


### 挂载自定义配置文件
通过挂载主机文件覆盖默认配置（如 `php-fpm.conf`）：  
```console
docker run --name phpfpm \
  -v /path/to/php-fpm.conf:/opt/bitnami/php/etc/php-fpm.conf \
  bitnami/php-fpm
```
修改后重启容器生效：`docker restart phpfpm`。


### 添加额外 .ini 文件
PHP 会扫描 `/opt/bitnami/php/etc/conf.d/` 目录的 `.ini` 文件，可挂载自定义配置。例如，创建 `custom.ini` 设置上传限制：  
```ini
max_file_uploads = 30
```
挂载并验证：  
```console
docker run -it -v /path/to/custom.ini:/opt/bitnami/php/etc/conf.d/custom.ini \
  bitnami/php-fpm php -i | grep max_file_uploads
```


### FIPS 配置（BSI 镜像）
Bitnami 安全镜像支持 FIPS 模式，通过环境变量 `OPENSSL_FIPS` 控制（默认 `yes` 启用 FIPS，设为 `no` 禁用）。


## 日志查看

日志输出至标准输出（stdout），使用以下命令查看：  
```console
# 直接查看容器日志
docker logs phpfpm

# 使用 Docker Compose
docker-compose logs phpfpm
```
（需确保日志驱动为 `json-file` 或 `journald`）


## 镜像升级

### 步骤 1：拉取新版镜像
```console
docker pull bitnami/php-fpm:latest
```

### 步骤 2：备份并停止旧容器
```console
# 停止容器
docker stop phpfpm

# 备份数据（如挂载的 /app 目录）
rsync -a /path/to/app /path/to/app.bkp.$(date +%Y%m%d)
```

### 步骤 3：启动新容器
```console
docker run --name phpfpm -v /path/to/app:/app bitnami/php-fpm:latest
```


## 其他资源

### 有用链接
- [使用 Bitnami 容器创建 AMP 开发环境]([])  
- [使用 Bitnami 容器创建 EMP 开发环境]([])  

### 重要变更
- 2018-03-13：支持 `/opt/bitnami/php/etc/conf.d/` 目录扫描额外 .ini 文件。  
- 2016-05-17：合并所有卷至 `/bitnami/php-fpm`，日志输出至 stdout。  


## 贡献与反馈

- **贡献代码**：通过 [PR]([]) 提交改进。  
- **问题反馈**：提交 [issue]([]) 并填写模板。  


## 许可协议

本软件包基于 Apache License 2.0 许可，详见 [Apache 许可协议]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnami/php-fpm" title="bitnami/php-fpm Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/php-fpm</a></p>
