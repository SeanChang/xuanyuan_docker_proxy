---
id: 14
title: Docker 部署 PHP 全手册
slug: docker-php
summary: 这篇教程详细介绍了如何在 Docker 环境中部署 PHP，从镜像拉取、容器启动到文件挂载与端口映射，步骤清晰、示例完整，初学者照着操作即可快速搭建可运行的 PHP 开发环境。
category: Docker,PHP
tags: php,docker,部署教程
image_name: library/php
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-php.png"
status: published
created_at: "2025-10-07 03:10:31"
updated_at: "2025-10-14 01:57:19"
---

# Docker 部署 PHP 全手册

> 这篇教程详细介绍了如何在 Docker 环境中部署 PHP，从镜像拉取、容器启动到文件挂载与端口映射，步骤清晰、示例完整，初学者照着操作即可快速搭建可运行的 PHP 开发环境。

## 1. PHP 简介

PHP 是最流行的后端脚本语言之一，广泛应用于网站与 Web 应用开发。结合 Docker，可轻松实现“一键运行 PHP 环境”，避免复杂的系统配置。

### 核心特点

* **快速开发**：语法简单、上手快，拥有丰富框架（Laravel、ThinkPHP、WordPress 等）。
* **高兼容性**：支持 Nginx、Apache、MySQL、Redis 等主流组件。
* **生态完善**：Composer 管理依赖、扩展丰富（GD、PDO、mbstring 等）。
* **轻量可移植**：通过 Docker 封装环境，避免“本地能跑、服务器不行”的问题。

### 典型应用场景

| 场景类型     | 示例                         | 适用用户 |
| -------- | -------------------------- | ---- |
| PHP 基础学习 | 编写 PHP 脚本、练习语法             | 新手   |
| Web 服务开发 | Laravel、ThinkPHP、WordPress | 中级   |
| 生产部署     | 企业级 API 服务、CMS 平台          | 高级   |

### 官方资源

* 国内镜像页：[https://xuanyuan.cloud/r/library/php](https://xuanyuan.cloud/r/library/php)
* 官方文档：[https://www.php.net/docs.php](https://www.php.net/docs.php)

---

## 2. 部署前准备

在开始部署前，请确保本机具备以下环境。

### 2.1 硬件建议

| 资源类型 | 开发环境    | 生产环境    | 说明                |
| ---- | ------- | ------- | ----------------- |
| CPU  | ≥ 2 核   | ≥ 4 核   | 多线程加快脚本执行访问表现       |
| 内存   | ≥ 2 GB  | ≥ 8 GB  | PHP + Web 服务需足够内存 |
| 硬盘   | ≥ 10 GB | ≥ 50 GB | 建议使用 SSD 提升 IO 性能 |

### 2.2 软件依赖

* **Docker**：≥ 24.0.0
  检查版本：

  ```bash
  docker --version
  ```
* **Docker Compose**：≥ v2.26.1
  检查版本：

  ```bash
  docker compose version
  ```

### 2.3 一键安装脚本

若你的系统尚未安装 Docker，请先一键安装：

### Linux Docker & Docker Compose 一键安装

一键安装配置脚本（推荐方案）：
该脚本支持多种 Linux 发行版，支持一键安装 Docker、Docker Compose 并自动配置轩辕镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

### 2.4 网络与安全

* 端口：PHP-FPM 默认不暴露端口，需配合 Nginx/Apache 映射。
* 镜像访问支持：推荐使用 **轩辕镜像**（避免国外镜像拉取缓慢或失败）。

---

## 3. 下载 PHP 镜像

### 3.1 使用轩辕镜像（推荐）

```bash
# 拉取 PHP 8.2 镜像（含 FPM）
docker pull xxx.xuanyuan.run/library/php:8.2-fpm

# （可选）改名为标准官方名称
docker tag xxx.xuanyuan.run/library/php:8.2-fpm php:8.2-fpm
docker rmi xxx.xuanyuan.run/library/php:8.2-fpm
```

### 3.2 使用官方镜像（备用方案）

```bash
docker pull php:8.2-fpm
```

### 3.3 验证镜像是否下载成功

```bash
docker images
```

输出示例：

```
REPOSITORY   TAG        IMAGE ID       CREATED        SIZE
php          8.2-fpm    5b437a0916a1   3 weeks ago    500MB
```

---

## 4. 快速上手：运行 PHP 环境

### 4.1 方式1：直接运行 PHP 容器（无网页，仅命令行）

```bash
docker run -it --rm php:8.2-fpm php -v
```

输出 PHP 版本信息即表示成功。

### 4.2 方式2：运行可访问网页的 PHP 环境（推荐）

#### 步骤1：创建项目目录

```bash
mkdir -p ~/php-demo/www
cd ~/php-demo/www
```

#### 步骤2：编写示例 PHP 文件

创建文件 `index.php`：

```php
<?php
phpinfo();
?>
```

#### 步骤3：创建 docker-compose.yml

```yaml
version: "3.8"
services:
  php:
    image: php:8.2-fpm
    container_name: php-fpm
    volumes:
      - ./www:/var/www/html
    restart: unless-stopped

  nginx:
    image: nginx:latest
    container_name: php-nginx
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php
    restart: unless-stopped
```

#### 步骤4：创建 nginx.conf 文件

```nginx
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

#### 步骤5：启动容器

```bash
docker compose up -d
```

#### 步骤6：验证运行结果

浏览器访问：

```
http://localhost:8080
```

若出现 PHP 信息页面（蓝紫色表格），即部署成功 🎉

---

## 5. 安装扩展（如 pdo_mysql、gd、mbstring）

进入容器执行：

```bash
docker exec -it php-fpm bash
```

在容器内运行：

```bash
docker-php-ext-install pdo_mysql gd mbstring
```

安装完成后重启容器：

```bash
exit
docker compose restart php
```

验证扩展是否启用：

```bash
docker exec -it php-fpm php -m
```

输出包含 `pdo_mysql`, `gd`, `mbstring` 即代表安装成功。

---

## 6. 挂载项目目录（让代码实时生效）

上文已将宿主机目录 `./www` 挂载到容器内 `/var/www/html`，因此：

* 修改本地 `index.php` 后，无需重启容器，刷新网页即可看到效果；
* 新建 `test.php` 文件同样会被自动加载。

---

## 7. 与数据库联动（PHP + MySQL）

### 7.1 修改 docker-compose.yml，新增 MySQL 服务

```yaml
version: "3.8"
services:
  php:
    image: xxx.xuanyuan.run/php:8.2-fpm
    container_name: php-fpm
    volumes:
      - ./www:/var/www/html
    restart: unless-stopped
    depends_on:
      - mysql

  nginx:
    image: xxx.xuanyuan.run/nginx:latest
    container_name: php-nginx
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    restart: unless-stopped

  mysql:
    image: xxx.xuanyuan.run/mysql:8.0
    container_name: php-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: demo
      MYSQL_USER: appuser
      MYSQL_PASSWORD: app123
    volumes:
      - mysql-data:/var/lib/mysql
    restart: unless-stopped

volumes:
  mysql-data:
```

### 7.2 测试数据库连接

创建 `www/dbtest.php`：

```php
<?php
$dsn = 'mysql:host=mysql;dbname=demo;charset=utf8';
$user = 'appuser';
$pass = 'app123';

try {
  $pdo = new PDO($dsn, $user, $pass);
  echo "✅ 数据库连接成功";
} catch (PDOException $e) {
  echo "❌ 数据库连接失败：" . $e->getMessage();
}
?>
```

访问：

```
http://localhost:8080/dbtest.php
```

若出现 “✅ 数据库连接成功”，说明 PHP 与 MySQL 容器通信正常。

---

## 8. 生产部署建议

| 类别     | 建议配置                                           |
| ------ | ---------------------------------------------- |
| **安全** | 不暴露 8080 端口至公网；通过 Nginx 反代 HTTPS；关闭 phpinfo 页面 |
| **性能** | 启用 OPcache：`docker-php-ext-install opcache`    |
| **日志** | 将日志目录挂载到宿主机（`/var/log/nginx`、`/var/log/php`）   |
| **备份** | MySQL 定期 `mysqldump` 备份；PHP 代码使用 Git 管理        |
| **监控** | 使用 `docker stats` 或 Prometheus 监控 CPU、内存、IO    |

---

## 9. 常见问题排查

| 问题                 | 原因                  | 解决方法                                    |
| ------------------ | ------------------- | --------------------------------------- |
| 网页 502 Bad Gateway | PHP 容器未启动           | 执行 `docker ps` 检查 php-fpm 状态            |
| PHP 文件被下载而非解析      | Nginx 未正确配置 fastcgi | 检查 nginx.conf 中 `fastcgi_pass php:9000` |
| 数据库连接失败            | 主机名写错               | 使用容器名 `mysql` 而非 `localhost`            |
| 修改 PHP 文件无效        | 未挂载宿主目录             | 检查 `volumes` 是否设置正确                     |
| PHP 扩展未生效          | 未重启容器               | 运行 `docker compose restart php`         |

---

## 10. 后续学习路径

* **新手**：学习 PHP 语法 → 用 Docker 跑 PHP+MySQL → 尝试 WordPress/Laravel
* **进阶者**：研究 PHP-FPM 性能优化 → 使用 Supervisor 管理进程 → 部署 Nginx + PHP + Redis 架构
* **高级用户**：实现 CI/CD 自动化构建（GitHub Actions + Docker）→ 配置多环境（dev/staging/prod）

---

✅ 至此，你已成功用 Docker 构建出可运行的 PHP Web 环境。
该教程从 **镜像拉取 → PHP 环境运行 → 与 Nginx/MySQL 联动** 全流程覆盖，新手照做即可跑通。


