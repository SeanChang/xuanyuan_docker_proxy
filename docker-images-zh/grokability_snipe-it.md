---
image: grokability/snipe-it
description: "官方Snipe-IT镜像，用于快速部署最新版本的IT资产管理系统，支持硬件、软件及许可证的跟踪与管理，简化企业及团队的IT资产运维流程。"
source: https://xuanyuan.cloud/zh/r/grokability/snipe-it
canonical: https://xuanyuan.cloud/zh/r/grokability/snipe-it
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/grokability/snipe-it" title="grokability/snipe-it Docker 镜像中文简介、标签列表与拉取命令">grokability/snipe-it 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Snipe-IT 官方Docker镜像文档

## 镜像概述

`snipe/snipe-it`是Snipe-IT项目的官方Docker镜像，用于便捷部署开源IT资产管理系统Snipe-IT。Snipe-IT是一款功能全面的资产管理工具，专为IT团队设计，支持资产全生命周期跟踪、许可证管理、维护记录及报表生成，广泛应用于企业、教育机构及中小型团队。

## 核心功能与特性

### 系统功能
- **资产全生命周期管理**：支持硬件（服务器、电脑、设备）、软件及配件的入库、分配、转移、维修、报废全流程跟踪
- **许可证管理**：记录软件许可证密钥、授权数量、有效期及分配情况，避免合规风险
- **用户与权限控制**：基于角色的访问控制（RBAC），支持多部门、多用户协作管理
- **报表与统计**：内置资产状态、到期提醒、使用率等多维度报表，支持导出为CSV/PDF
- **API支持**：提供RESTful API，便于与其他系统集成（如工单系统、监控平台）
- **数据导入导出**：支持通过CSV批量导入资产数据，定期备份与恢复

### 镜像特性
- 基于Snipe-IT最新稳定版本构建，确保功能同步更新
- 简化部署流程，无需手动配置Web服务器（Nginx）和PHP环境
- 支持Docker Compose集成，可快速与数据库服务联动
- 数据持久化设计，关键目录支持卷挂载，避免容器重启数据丢失

## 使用场景

- **企业IT部门**：管理公司内部电脑、服务器、网络设备等硬件资产及软件许可证
- **教育机构**：跟踪教学设备、实验室仪器的借用与归还状态
- **中小型团队**：低成本实现IT资产数字化管理，替代Excel表格等手动记录方式
- **多分支机构组织**：通过集中部署，实现跨区域资产统一管理与监控

## 使用方法与配置说明

### 前提条件
- 已安装Docker Engine（20.10+）及Docker Compose（推荐v2+）
- 具备MySQL或MariaDB数据库服务（5.7+或10.2+），或通过Docker Compose联动部署

### 快速部署（单容器模式）

#### 1. 拉取镜像
```bash
docker pull docker.xuanyuan.run/snipe/snipe-it:latest
```

#### 2. 启动容器（需提前准备数据库）
```bash
docker run -d \
  --name snipe-it \
  -p 8080:80 \
  -e APP_KEY=base64:your_app_key_here \
  -e DB_HOST=your_db_host \
  -e DB_DATABASE=snipeit \
  -e DB_USERNAME=snipeit_user \
  -e DB_PASSWORD=your_db_password \
  -e DB_PORT=3306 \
  -v snipeit_storage:/var/www/html/storage \
  -v snipeit_public:/var/www/html/public/uploads \
  docker.xuanyuan.run/snipe/snipe-it:latest
```

> **说明**：  
> - `APP_KEY`：需生成32位随机字符串（可通过`docker run --rm snipe/snipe-it:latest php artisan key:generate --show`获取）  
> - 卷挂载：`snipeit_storage`存储系统配置与日志，`snipeit_public`存储上传的资产图片等文件  
> - 数据库需提前创建数据库实例及用户，并赋予权限

### 推荐部署方式（Docker Compose）

创建`docker-compose.yml`文件，集成Snipe-IT与MariaDB数据库：

```yaml
version: '3.8'

services:
  snipe-it:
    image: docker.xuanyuan.run/snipe/snipe-it:latest
    container_name: snipe-it
    restart: always
    ports:
      - "8080:80"
    environment:
      - APP_KEY=base64:your_generated_app_key
      - APP_ENV=production
      - APP_DEBUG=false
      - APP_URL=http://localhost:8080
      - DB_CONNECTION=mysql
      - DB_HOST=db
      - DB_PORT=3306
      - DB_DATABASE=snipeit
      - DB_USERNAME=snipeit_user
      - DB_PASSWORD=secure_password_here
      - MAIL_DRIVER=smtp
      - MAIL_HOST=smtp.example.com
      - MAIL_PORT=587
      - MAIL_USERNAME=your_email@example.com
      - MAIL_PASSWORD=your_email_password
      - MAIL_ENCRYPTION=tls
      - MAIL_FROM_ADDR=your_email@example.com
      - MAIL_FROM_NAME="Snipe-IT Admin"
    volumes:
      - snipeit_storage:/var/www/html/storage
      - snipeit_public:/var/www/html/public/uploads
    depends_on:
      - db

  db:
    image: docker.xuanyuan.run/mariadb:10.6
    container_name: snipe-it-db
    restart: always
    environment:
      - MYSQL_DATABASE=snipeit
      - MYSQL_USER=snipeit_user
      - MYSQL_PASSWORD=secure_password_here
      - MYSQL_ROOT_PASSWORD=root_secure_password
    volumes:
      - snipeit_db:/var/lib/mysql
    ports:
      - "3306:3306"

volumes:
  snipeit_storage:
  snipeit_public:
  snipeit_db:
```

启动服务：
```bash
docker-compose up -d
```

### 关键配置参数（环境变量）

| 环境变量 | 描述 | 示例值 |
|----------|------|--------|
| `APP_KEY` | 应用加密密钥（必需），32位随机字符串 | `base64:abcdef1234567890abcdef1234567890` |
| `APP_URL` | 应用访问URL | `http://snipeit.example.com` |
| `DB_CONNECTION` | 数据库类型（仅支持`mysql`） | `mysql` |
| `DB_HOST` | 数据库主机地址 | `db`（Docker Compose服务名）或`192.168.1.100` |
| `DB_DATABASE` | 数据库名称 | `snipeit` |
| `DB_USERNAME` | 数据库用户名 | `snipeit_user` |
| `DB_PASSWORD` | 数据库密码 | `SecurePass123!` |
| `MAIL_*` | 邮件配置（用于发送通知、密码重置等） | 参考上述`docker-compose.yml`示例 |
| `APP_TIMEZONE` | 应用时区 | `Asia/Shanghai` |
| `MAX_UPLOAD_SIZE` | 最大上传文件大小（MB） | `50` |

### 数据持久化

为避免容器重启或重建导致数据丢失，需挂载以下目录：
- `/var/www/html/storage`：存储系统配置、日志、缓存
- `/var/www/html/public/uploads`：存储上传的资产图片、附件
- 数据库数据卷（如`/var/lib/mysql`，通过数据库容器挂载）

### 升级镜像

1. 拉取最新镜像：
```bash
docker pull docker.xuanyuan.run/snipe/snipe-it:latest
```

2. 重启容器（Docker Compose方式）：
```bash
docker-compose down && docker-compose up -d
```

> **注意**：升级前建议备份数据库及持久化卷数据。

## 注意事项

- 首次启动需等待数据库初始化完成（约1-2分钟），可通过`docker logs snipe-it`查看启动状态
- `APP_KEY`必须唯一且保密，请勿使用示例值
- 生产环境建议配置HTTPS（可通过Nginx反向代理实现）
- 定期备份数据库及`storage`、`public/uploads`目录，防止数据丢失
