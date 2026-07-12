---
image: ustcmirror/pypi
description: "USTC PyPI镜像服务Docker镜像，用于快速部署本地PyPI镜像，加速Python包下载，节省带宽并提高依赖安装速度。"
source: https://xuanyuan.cloud/zh/r/ustcmirror/pypi
canonical: https://xuanyuan.cloud/zh/r/ustcmirror/pypi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ustcmirror/pypi" title="ustcmirror/pypi Docker 镜像中文简介、标签列表与拉取命令">ustcmirror/pypi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# USTC PyPI镜像Docker镜像

## 概述

本Docker镜像提供了中国科学技术大学(USTC)维护的PyPI镜像服务，用于搭建本地PyPI镜像，加速Python包的下载和安装过程。通过部署本地PyPI镜像，可以显著提高Python项目依赖的安装速度，同时减少对外部网络的依赖和带宽消耗。

## 核心功能和特性

- 完整同步PyPI官方仓库的Python包资源
- 提供本地缓存机制，减少重复下载
- 支持增量同步，降低带宽消耗
- 轻量级部署，易于维护
- 支持HTTP/HTTPS访问
- 可自定义同步频率和范围

## 使用场景和适用范围

- 企业内部Python开发环境
- 网络条件有限或需要节省带宽的场景
- 教育机构和科研单位的内部网络
- CI/CD流水线中的依赖管理
- 需要提高Python包安装速度的开发团队

## 使用方法和配置说明

### 基本使用

#### Docker Run命令

```bash
docker run -d -p 8080:80 --name pypi-mirror docker.xuanyuan.run/ustclug/pypi-mirror
```

#### Docker Compose配置

```yaml
version: '3'
services:
  pypi-mirror:
    image: docker.xuanyuan.run/ustclug/pypi-mirror
    container_name: pypi-mirror
    ports:
      - "8080:80"
    volumes:
      - ./data:/var/www/pypi
    restart: always
    environment:
      - SYNC_INTERVAL=86400  # 同步间隔，单位：秒
      - SYNC_TIMEOUT=3600    # 同步超时时间，单位：秒
```

### 配置参数

#### 环境变量

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| `SYNC_INTERVAL` | 同步间隔时间(秒) | 86400 (24小时) |
| `SYNC_TIMEOUT` | 同步超时时间(秒) | 3600 (1小时) |
| `MAX_WORKERS` | 同步进程数 | 4 |
| `MIRROR_URL` | 上游镜像URL | https://pypi.org/ |
| `LOG_LEVEL` | 日志级别 | info |

#### 数据持久化

为确保镜像数据在容器重启后不丢失，建议挂载数据卷到`/var/www/pypi`目录：

```bash
docker run -d -p 8080:80 -v /path/to/local/data:/var/www/pypi --name pypi-mirror docker.xuanyuan.run/ustclug/pypi-mirror
```

## 客户端配置

### pip配置

创建或修改`~/.pip/pip.conf`文件：

```ini
[global]
index-url = http://your-mirror-ip:8080/simple/

[install]
trusted-host = your-mirror-ip
```

### pip命令行临时使用

```bash
pip install -i http://your-mirror-ip:8080/simple/ package-name
```

### pipenv配置

```bash
pipenv install --pypi-mirror http://your-mirror-ip:8080/simple/
```

### poetry配置

```bash
poetry config repositories.ustc http://your-mirror-ip:8080/simple/
poetry config pypi-mirror http://your-mirror-ip:8080/simple/
```

## 维护和更新

### 手动同步

```bash
docker exec -it pypi-mirror /usr/local/bin/sync-pypi
```

### 查看日志

```bash
docker logs -f pypi-mirror
```

### 更新镜像

```bash
docker pull docker.xuanyuan.run/ustclug/pypi-mirror
docker stop pypi-mirror
docker rm pypi-mirror
docker run -d -p 8080:80 -v /path/to/local/data:/var/www/pypi --name pypi-mirror docker.xuanyuan.run/ustclug/pypi-mirror
```

## 注意事项

- 首次同步会消耗较多带宽和时间，请确保网络条件良好
- 建议至少分配100GB以上的存储空间
- 生产环境中建议配置HTTPS以确保安全
- 根据实际需求调整同步频率，避免过于频繁的同步
