---
image: yiisoftware/yii-php
description: "官方Docker镜像，适用于Yii 3.x框架的应用开发、测试和部署，提供一致的运行环境与简化的部署流程。"
source: https://xuanyuan.cloud/zh/r/yiisoftware/yii-php
canonical: https://xuanyuan.cloud/zh/r/yiisoftware/yii-php
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/yiisoftware/yii-php" title="yiisoftware/yii-php Docker 镜像中文简介、标签列表与拉取命令">yiisoftware/yii-php 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Yii 3.x 官方Docker镜像文档

### 镜像概述
本镜像为Yii 3.x框架的官方Docker镜像，由Yii开发团队维护，旨在提供统一、可靠的运行环境，简化Yii 3.x应用的开发、测试及生产部署流程。基于官方PHP镜像构建，确保与Yii 3.x框架核心组件的兼容性，降低环境配置复杂度。

### 核心功能与特性
- **官方支持**：与Yii 3.x框架版本同步更新，确保兼容性和安全性补丁及时应用
- **环境一致性**：标准化运行环境，消除"开发-测试-生产"环境差异导致的问题
- **轻量级设计**：基于Alpine或Debian slim基础镜像构建，优化镜像体积和运行效率
- **灵活配置**：支持通过环境变量、配置文件及挂载卷自定义应用参数
- **多阶段支持**：提供开发（含依赖管理工具）和生产（精简运行时）两种镜像变体

### 使用场景
- **开发环境快速搭建**：无需手动配置PHP、Web服务器（Nginx/Apache）及扩展，一键启动开发环境
- **CI/CD流程集成**：作为自动化测试和构建流程的基础环境，确保代码在一致环境中验证
- **生产环境部署**：支持单机部署、容器编排（Kubernetes/Docker Swarm）及云服务部署

### 使用方法与配置说明

#### 基本使用（docker run）
通过以下命令启动Yii 3.x应用容器：

```bash
docker run -d \
  -p 8080:80 \
  --name yii3-app \
  -v $(pwd)/app:/app \  # 挂载本地代码目录（开发模式）
  -e APP_ENV=development \
  yiisoft/yii3:latest
```

**参数说明**：
- `-p 8080:80`：将容器内80端口（Web服务）映射到主机8080端口
- `-v $(pwd)/app:/app`：挂载本地代码目录至容器内应用根目录（开发时实时同步代码变更）
- `-e APP_ENV=development`：设置应用环境为开发模式（启用调试工具）

#### Docker Compose配置示例
创建`docker-compose.yml`文件集成应用服务与依赖组件（如数据库）：

```yaml
version: '3.8'

services:
  app:
    image: docker.xuanyuan.run/yiisoft/yii3:latest
    ports:
      - "80:80"
    volumes:
      - ./app:/app:cached  # 本地代码挂载（开发环境）
      - vendor:/app/vendor # 依赖目录持久化（避免重复安装）
    environment:
      - APP_ENV=development
      - DB_HOST=db
      - DB_NAME=yii3_demo
      - DB_USER=demo_user
      - DB_PASSWORD=demo_pass
    depends_on:
      - db

  db:
    image: docker.xuanyuan.run/mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_DATABASE=yii3_demo
      - MYSQL_USER=demo_user
      - MYSQL_PASSWORD=demo_pass
      - MYSQL_ROOT_PASSWORD=root_pass
    volumes:
      - db-data:/var/lib/mysql

volumes:
  vendor:
  db-data:
```

启动服务：
```bash
docker-compose up -d
```

#### 环境变量配置
常用环境变量及说明：

| 环境变量         | 描述                          | 默认值          |
|------------------|-------------------------------|-----------------|
| `APP_ENV`        | 应用环境（development/test/production） | `production`    |
| `APP_DEBUG`      | 是否启用调试模式（true/false） | `false`         |
| `DB_HOST`        | 数据库主机地址                | `localhost`     |
| `DB_PORT`        | 数据库端口                    | `3306`          |
| `DB_NAME`        | 数据库名称                    | `yii3`          |
| `DB_USER`        | 数据库访问用户                | `root`          |
| `DB_PASSWORD`    | 数据库访问密码                | `''`            |
| `WEB_SERVER`     | Web服务器类型（nginx/apache） | `nginx`         |
| `PHP_MEMORY_LIMIT` | PHP内存限制                  | `128M`          |

#### 生产环境部署注意事项
1. **使用固定版本标签**：避免使用`latest`，指定具体版本（如`yiisoft/yii3:3.0.2`）确保部署稳定性
2. **禁用调试模式**：设置`APP_ENV=production`和`APP_DEBUG=false`
3. **数据持久化**：通过`-v`挂载应用数据目录（如用户上传文件）至主机或云存储卷
4. **安全加固**：限制容器权限（--read-only）、配置健康检查（--health-cmd）及自动重启（--restart=unless-stopped）
5. **性能优化**：配置PHP OPcache、启用Web服务器缓存、调整容器资源限制（--memory-limit）

### 镜像维护与更新
- 镜像更新：通过`docker pull docker.xuanyuan.run/yiisoft/yii3:latest`获取最新版本
- 版本查询：访问[Docker Hub仓库](https://hub.docker.com/r/yiisoft/yii3)查看可用标签及更新日志
- 问题反馈：提交issue至[Yii Docker镜像GitHub仓库](https://github.com/yiisoft/docker-yii3)
