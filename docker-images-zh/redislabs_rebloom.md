---
image: redislabs/rebloom
description: "Redis的概率数据类型模块，该镜像已被弃用，建议使用redis/redis-stack镜像。"
source: https://xuanyuan.cloud/zh/r/redislabs/rebloom
canonical: https://xuanyuan.cloud/zh/r/redislabs/rebloom
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redislabs/rebloom" title="redislabs/rebloom Docker 镜像中文简介、标签列表与拉取命令">redislabs/rebloom 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Redis概率数据类型模块镜像（已弃用）

## 镜像概述
本Docker镜像为Redis提供概率数据类型模块功能，但目前已被官方弃用。官方推荐使用[redis/redis-stack](https://hub.docker.com/r/redis/redis-stack)镜像作为替代方案，以获取更全面的功能支持和持续维护。

## 核心功能
- 提供Redis的概率数据类型支持
- 包含针对概率数据结构的相关操作模块

## 使用说明
### 注意事项
由于本镜像已被弃用，不建议在生产环境中继续使用。请按照以下步骤迁移至官方推荐的替代方案：

### 推荐替代方案：redis/redis-stack
#### Docker Run示例
```bash
docker run -d --name redis-stack -p 6379:6379 docker.xuanyuan.run/redis/redis-stack:latest
```

#### Docker Compose示例
```yaml
version: '3'
services:
  redis-stack:
    image: docker.xuanyuan.run/redis/redis-stack:latest
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    restart: unless-stopped

volumes:
  redis-data:
```

## 总结
本镜像已停止维护，为确保系统稳定性和功能完整性，强烈建议用户迁移至[redis/redis-stack](https://hub.docker.com/r/redis/redis-stack)镜像，以获取包括概率数据类型在内的更全面Redis功能支持。
