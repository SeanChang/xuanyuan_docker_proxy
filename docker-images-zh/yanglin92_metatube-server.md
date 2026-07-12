---
image: yanglin92/metatube-server
description: "metatube服务器Docker镜像，支持内存模式和数据库模式运行，可配置监听端口、访问密钥等参数，适用于本地部署及需要数据持久化的场景。"
source: https://xuanyuan.cloud/zh/r/yanglin92/metatube-server
canonical: https://xuanyuan.cloud/zh/r/yanglin92/metatube-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/yanglin92/metatube-server" title="yanglin92/metatube-server Docker 镜像中文简介、标签列表与拉取命令">yanglin92/metatube-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## metatube-server Docker镜像文档

### 镜像概述
metatube-server Docker镜像是用于部署metatube服务的容器化解决方案，提供便捷的服务运行方式，支持两种运行模式以满足不同场景需求。

### 核心功能与特性
- **双运行模式**：支持内存模式（数据临时存储，重启后丢失）和数据库模式（数据持久化到文件，推荐生产环境使用）
- **灵活配置**：可通过参数自定义监听端口、访问密钥、数据库连接等关键配置
- **轻量部署**：基于Docker容器化部署，简化环境依赖管理

### 使用场景
- **本地测试**：快速启动服务进行功能验证，适合开发调试
- **生产环境**：通过数据库模式实现数据持久化，保障服务稳定运行

### 使用方法

#### 1. 内存模式
适用于临时测试，数据存储在内存中，服务重启后数据丢失。
```bash
docker run -d -p 8080:8080 --name metatube docker.xuanyuan.run/metatube/metatube-server:latest
```

#### 2. 数据库模式（推荐）
适用于需要数据持久化的场景，数据存储在本地文件中。
```bash
docker run -d -p 8080:8080 -v $PWD/config:/config --name metatube docker.xuanyuan.run/metatube/metatube-server:latest -dsn /config/metatube.db
```
> 说明：通过`-v`参数将本地目录挂载到容器内，实现数据库文件持久化

### 参数配置
| 参数名 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| PORT | int<0-65535> | 8080 | 监听端口号，可根据需求修改 |
| TOKEN | string | 无 | 访问密钥，按需配置，本地部署可忽略 |
| DSN | string | 内存模式 | 数据库服务地址，小白建议使用默认值 |
| DB_MAX_IDLE_CONNS | int | 0 | 最大空闲数据库连接数，建议使用默认值 |
| DB_MAX_OPEN_CONNS | int | 0 | 最大数据库连接数，建议使用默认值 |
| DB_PREPARED_STMT | bool | false | Prepared Statement，建议使用默认值 |
| DB_AUTO_MIGRATE | bool | false | 数据库表自动迁移，建议使用默认值 |
| REQUEST_TIMEOUT | string | 1m | 请求超时时长，默认一分钟 |

### 配置示例
通过环境变量或命令行参数配置服务，例如修改监听端口为8081：
```bash
docker run -d -p 8081:8081 --name metatube docker.xuanyuan.run/metatube/metatube-server:latest -port 8081
