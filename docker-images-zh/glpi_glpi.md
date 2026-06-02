---
image: glpi/glpi
description: "GLPI是一款免费的资产与IT管理软件包，它能够全面管理IT资产（包括计算机、服务器、网络设备等硬件）、软件许可、耗材库存，并提供IT服务管理功能，如工单处理、问题跟踪、变更管理等，支持企业或组织高效追踪、维护和优化IT资源，提升管理效率与资源利用率，满足日常IT运维与资产监控的需求。"
source: https://xuanyuan.cloud/zh/r/glpi/glpi
canonical: https://xuanyuan.cloud/zh/r/glpi/glpi
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/glpi/glpi" title="glpi/glpi Docker 镜像中文简介、标签列表与拉取命令">glpi/glpi — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/glpi/glpi" title="glpi/glpi Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/glpi/glpi</a>

# GLPI Docker镜像

![GLPI on docker illustration]([])

[GLPI]([]) 是一款免费开源的资产与IT管理软件包，支持数据中心管理、ITIL服务台、许可证跟踪及软件审计功能。


## 相关链接
- [报告问题]([])
- [官方文档]([])


## 仓库说明
本仓库包含Docker镜像的构建文件，相关镜像可在[GitHub Container Registry]([])和[Docker Hub]([])获取。


## 如何使用此镜像

### 通过docker compose

#### 1. 配置文件准备
创建`docker-compose.yml`文件：

```yaml
services:
  glpi:
    image: "glpi/glpi:latest"
    restart: "unless-stopped"
    volumes:
      - "./storage/glpi:/var/glpi:rw"
    env_file: .env  # 从.env文件传递环境变量到容器
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "80:80"

  db:
    image: "mysql"
    restart: "unless-stopped"
    volumes:
       - "./storage/mysql:/var/lib/mysql"
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: "yes"
      MYSQL_DATABASE: ${GLPI_DB_NAME}
      MYSQL_USER: ${GLPI_DB_USER}
      MYSQL_PASSWORD: ${GLPI_DB_PASSWORD}
    healthcheck:
      test: mysqladmin ping -h 127.0.0.1 -u $$MYSQL_USER --password=$$MYSQL_PASSWORD
      start_period: 5s
      interval: 5s
      timeout: 5s
      retries: 10
    expose:
      - "3306"
```

创建`.env`文件：

```env
GLPI_DB_HOST=db
GLPI_DB_PORT=3306
GLPI_DB_NAME=glpi
GLPI_DB_USER=glpi
GLPI_DB_PASSWORD=glpi
```


#### 2. 启动容器
执行以下命令启动服务：

```bash
docker compose up -d
```


#### 3. 注意事项
- MySQL会生成随机root密码，需查看`db`容器日志获取：  
  ```bash
  docker logs <db容器ID>
  ```
- 容器运行后，访问`[] GLPI会自动完成安装或更新。若需禁用此行为，在`.env`文件中添加`GLPI_SKIP_AUTOINSTALL=true`；禁用自动更新则添加`GLPI_SKIP_AUTOUPDATE=true`。
- 若禁用了自动安装，访问网页时需手动输入数据库信息：  
  主机名：`db`，数据库名：`glpi`，用户名：`glpi`，密码：`glpi`。


## 时区支持
若需初始化GLPI时区支持，需执行以下步骤：

1. 授权glpi用户访问时区表：  
   ```bash
   docker exec -it <db容器ID> mysql -u root -p -e "GRANT SELECT ON mysql.time_zone_name TO 'glpi'@'%';FLUSH PRIVILEGES;"
   ```
   （输入之前从日志获取的root密码）

2. 在GLPI容器中初始化时区：  
   ```bash
   docker exec -it <glpi容器ID> /var/www/glpi/bin/console database:enable_timezones
   ```


## 卷
`glpi/glpi`镜像默认提供卷，包含`config`、`marketplace`和`files`目录。  
**注意**：GLPI 10.0.x版本的`marketplace`目录路径不同，未包含在默认卷中。如果需要使用市场功能，建议手动创建卷，映射路径`/var/www/glpi/marketplace`。
