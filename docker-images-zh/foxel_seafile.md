---
image: foxel/seafile
description: "用于快速设置的Seafile Docker镜像，提供便捷部署方案。注意：该镜像已不再维护，新用户建议使用官方Seafile Docker设置指南。"
source: https://xuanyuan.cloud/zh/r/foxel/seafile
canonical: https://xuanyuan.cloud/zh/r/foxel/seafile
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/foxel/seafile" title="foxel/seafile Docker 镜像中文简介、标签列表与拉取命令">foxel/seafile — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/foxel/seafile" title="foxel/seafile Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/foxel/seafile</a>

# seafile-docker

## ⚠️ 不再维护

该仓库已不再维护。如果您是Seafile新手，请使用[官方Seafile Docker设置指南](https://manual.seafile.com/latest/setup/setup_ce_by_docker/)。

如需从`foxel/seafile-docker`迁移到官方镜像，请参阅[迁移指南](https://github.com/foxel/seafile-docker/blob/master/migrate_to_haiwen.md)。

## 快速开始（docker-compose 设置）

1. 准备`docker-compose.yml`文件（见下方示例）
2. 执行`docker-compose up -d`启动系统
3. 运行`docker-compose logs mysql`查看日志以获取MySQL root密码（如果未在`docker-compose.override.yml`中手动设置）
4. 执行`docker-compose exec seafile setup`进行初始设置（过程中需输入上述MySQL root密码）

## docker-compose.yml 示例

```yaml
version: '2'

services:
  seafile:
    image: ghcr.io/foxel/seafile-docker/seafile:11.0.12
    ports:
      - "9080:80"
    environment:
      SEAFILE_URL: 'http://seafile.example.com'
    links:
      - mysql
    volumes:
      - seafile:/seafile
  mysql:
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: 1
    volumes:
      - mysql:/var/lib/mysql
    image: mysql:8.0

volumes:
  mysql:
    driver: local
  seafile:
    driver: local
```

## 升级指南

支持逐步升级，具体步骤如下：

### 10.0.x => 11.0.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 11.0.0
```

**注意**：
- 11.0.x版本要求MySQL 8.0（示例compose文件已更新版本），容器首次启动时会自动完成升级
- Django 4采用新的CSRF令牌安全策略，需确保SSL终止配置正确设置`X-Forwarded-Proto`和`Host`请求头

### 9.0.x => 10.0.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 10.0.0
```

### 8.0.x => 9.0.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 9.0.0
```

### 7.1.x => 8.0.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 8.0.0
```

### 7.0.x => 7.1.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 7.1.0
```

### 6.3.x => 7.0.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 7.0.0
```

### 6.2.x => 6.3.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 6.3.0
```

### 6.1.x => 6.2.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 6.2.0
```

### 6.0.x => 6.1.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 6.1.0
```

### 5.1.x => 6.0.x
```bash
docker-compose exec seafile /scripts/upgrade.sh 6.0.0
