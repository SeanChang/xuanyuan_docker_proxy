---
image: digiticketsgroup/php
description: "PHP官方Docker镜像提供预配置的PHP运行时环境，支持多版本PHP（如7.4、8.0+），基于Alpine/Debian等基础镜像，包含常用扩展和工具，可快速部署PHP应用，适用于开发与生产环境。"
source: https://xuanyuan.cloud/zh/r/digiticketsgroup/php
canonical: https://xuanyuan.cloud/zh/r/digiticketsgroup/php
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/digiticketsgroup/php" title="digiticketsgroup/php Docker 镜像中文简介、标签列表与拉取命令">digiticketsgroup/php 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# PHP Docker镜像文档

## 镜像概述和主要用途

PHP Docker镜像是由PHP官方维护的Docker镜像，包含完整的PHP运行时环境，支持多种PHP版本（如7.4、8.0、8.1、8.2、8.3等），基于不同基础镜像（轻量级Alpine或功能全面的Debian）构建。该镜像旨在为开发者和运维人员提供快速、一致的PHP应用部署环境，无需手动配置PHP依赖和系统环境，可直接用于运行PHP脚本、网站或API服务。


## 核心功能和特性

### 1. 多版本支持
- 提供PHP各稳定版本镜像，如`7.4`、`8.0`、`8.1`、`8.2`、`8.3`等，满足不同应用对PHP版本的需求。
- 版本标签格式清晰，如`php:8.3`（默认Debian基础）、`php:8.3-alpine`（Alpine基础）、`php:8.3-cli`（仅CLI环境）、`php:8.3-fpm`（包含PHP-FPM）。

### 2. 多种基础镜像选择
- **Alpine**：基于Alpine Linux，体积小（约30-50MB），适合对镜像大小敏感的场景（如边缘计算、资源受限环境）。
- **Debian**：基于Debian Linux，包含更多系统工具和库，兼容性更好，适合需要丰富依赖的应用。

### 3. 内置常用扩展
- 默认包含核心PHP扩展（如`json`、`mbstring`、`openssl`、`pdo`等），可通过`docker-php-ext-install`命令安装额外扩展（如`mysqli`、`gd`、`redis`等）。

### 4. 灵活的配置自定义
- 支持通过挂载本地`php.ini`文件覆盖默认配置，或通过环境变量调整PHP设置（如`PHP_MEMORY_LIMIT`、`PHP_MAX_EXECUTION_TIME`等）。

### 5. 官方维护与安全
- 由PHP官方团队维护，定期更新以修复安全漏洞和兼容性问题，确保镜像的可靠性和安全性。


## 使用场景和适用范围

### 1. 开发环境
- 本地快速搭建PHP开发环境，无需手动安装PHP及依赖，通过挂载代码目录实时调试应用。

### 2. 生产环境
- 部署PHP网站（如WordPress、Laravel、Symfony等框架应用）或API服务，配合Nginx/Apache作为Web服务器，或直接使用PHP-FPM。

### 3. CI/CD流程
- 集成到自动化构建和测试流程中，验证PHP应用在不同版本下的兼容性，确保代码质量。

### 4. 微服务架构
- 作为微服务架构中的PHP服务节点，与其他服务（如数据库、缓存）通过网络通信。


## 详细使用方法和配置说明

### 基本使用示例

#### 1. 运行PHP CLI脚本
使用`php:<version>-cli`镜像运行本地PHP脚本：
```bash
# 假设当前目录有script.php文件
docker run --rm -v $(pwd):/app docker.xuanyuan.run/php:8.3-cli php /app/script.php
```
- `--rm`：容器退出后自动删除
- `-v $(pwd):/app`：将本地当前目录挂载到容器内的`/app`目录
- `php /app/script.php`：在容器内执行`script.php`脚本

#### 2. 启动PHP-FPM服务（配合Nginx）
使用Docker Compose部署PHP-FPM+Nginx环境：

**docker-compose.yml**
```yaml
version: '3'
services:
  php-fpm:
    image: docker.xuanyuan.run/php:8.3-fpm
    volumes:
      - ./php-app:/var/www/html  # 挂载PHP应用代码
    restart: always

  nginx:
    image: docker.xuanyuan.run/nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf  # Nginx配置
      - ./php-app:/var/www/html  # 共享PHP代码目录
    depends_on:
      - php-fpm
    restart: always
```

**nginx.conf**（Nginx配置示例）
```nginx
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
    index index.php index.html;

    location ~ \.php$ {
        fastcgi_pass php-fpm:9000;  # 连接php-fpm服务（容器名:端口）
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

启动服务：
```bash
docker-compose up -d
```
访问`http://localhost`即可看到PHP应用页面。


### 自定义PHP配置

#### 1. 通过挂载php.ini文件
创建自定义`php.ini`文件（如`./php.ini`），并挂载到容器的PHP配置目录：
```bash
docker run --rm -v $(pwd):/app -v $(pwd)/php.ini:/usr/local/etc/php/php.ini docker.xuanyuan.run/php:8.3-cli php /app/script.php
```
- PHP配置文件路径：
  - Debian基础镜像：`/usr/local/etc/php/php.ini`
  - Alpine基础镜像：`/usr/local/etc/php/php.ini`（同Debian）

#### 2. 安装额外PHP扩展
使用`docker-php-ext-install`命令在Dockerfile中安装扩展：

**Dockerfile**
```dockerfile
FROM docker.xuanyuan.run/php:8.3-fpm
# 安装mysqli和gd扩展
RUN docker-php-ext-install mysqli gd
# 安装Redis扩展（通过PECL）
RUN pecl install redis && docker-php-ext-enable redis
```
构建并使用自定义镜像：
```bash
docker build -t my-php-app .
docker run --rm docker.xuanyuan.run/my-php-app
```


### 常用环境变量和配置参数

| 环境变量/配置项         | 说明                                                                 | 默认值          |
|-------------------------|----------------------------------------------------------------------|-----------------|
| `PHP_INI_DIR`           | PHP配置文件目录路径                                                 | `/usr/local/etc/php` |
| `PHP_MEMORY_LIMIT`      | PHP内存限制                                                         | `128M`          |
| `PHP_MAX_EXECUTION_TIME`| PHP脚本最大执行时间（秒）                                           | `30`            |
| `PHP_POST_MAX_SIZE`     | POST数据最大尺寸                                                   | `8M`            |
| `PHP_UPLOAD_MAX_FILESIZE` | 上传文件最大尺寸                                                   | `2M`            |

可通过在`php.ini`中修改或在Dockerfile中使用`sed`命令调整默认配置：
```dockerfile
FROM docker.xuanyuan.run/php:8.3-fpm
RUN sed -i 's/^memory_limit = .*/memory_limit = 256M/' /usr/local/etc/php/php.ini-production
```


### 注意事项
- 生产环境建议使用`php:<version>-fpm`（而非`cli`）配合Web服务器，或使用官方提供的`-apache`标签镜像（如`php:8.3-apache`，内置Apache+PHP）。
- Alpine基础镜像体积小但部分扩展可能需要手动安装系统依赖（如`gd`扩展需要`libpng`、`libjpeg`等库）。
- 定期更新镜像版本以获取安全补丁，避免使用`latest`标签（建议指定具体版本如`8.3.4`）。
