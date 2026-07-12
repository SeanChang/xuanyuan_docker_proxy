---
image: oblakstudio/redisinsight
description: "RedisInsight v2 改进版Docker镜像，提供Redis图形化管理界面，支持amd64和arm64架构，修复官方构建问题，体积更小且安全增强。"
source: https://xuanyuan.cloud/zh/r/oblakstudio/redisinsight
canonical: https://xuanyuan.cloud/zh/r/oblakstudio/redisinsight
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oblakstudio/redisinsight" title="oblakstudio/redisinsight Docker 镜像中文简介、标签列表与拉取命令">oblakstudio/redisinsight 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker化 Redis Insight (版本 2)## 镜像概述Redis Insight v2 是Redis官方提供的基于NestJS的Electron应用，提供Redis图形化管理界面。本镜像通过重写Dockerfile和自定义构建流程，解决了官方Docker构建过程中的问题，支持x86和ARM64架构，同时优化了镜像体积和安全性。

## 核心功能与特性### 优化与改进-** 移除不必要依赖 **：删除avahi-daemon、libnss-mdns（避免DNS解析问题）、gnome-keyring和libsecret（无需密码加密功能）
-** 减小镜像体积 **：使用Alpine基础镜像替代Debian，显著降低镜像大小
-** 安全增强 **：支持非root用户运行，无需IPC_LOCK权限
-** 数据持久化 **：默认配置/data匿名卷，即使未手动挂载持久存储也能临时保留数据
-** 日志优化 **：日志输出到STDOUT，便于容器日志收集和监控

## 使用场景适用于需要通过图形界面管理Redis实例的开发、测试和生产环境，支持多架构部署，尤其适合需要轻量化、安全可靠Redis管理工具的场景。

## 使用方法### 基本使用```bash# 拉取镜像
docker pull docker.xuanyuan.run/oblakstudio/redisinsight:latest

# 运行容器
docker run -d --name redisinsight -p 5540:5540 docker.xuanyuan.run/oblakstudio/redisinsight:latest
```

### 持久化数据```bash
docker run -d --name redisinsight -p 5540:5540 -v redisinsight-data:/data docker.xuanyuan.run/oblakstudio/redisinsight:latest
```

## 环境变量配置可通过以下环境变量自定义应用配置，默认值中标注*的为镜像覆盖的默认值：

| 变量名           | 类型    | 描述                     | 默认值        |
|------------------|---------|--------------------------|---------------|
| RI_HOSTNAME      | string  | 绑定的IP地址或主机名     | 0.0.0.0       |
| API_PORT         | number  | 应用监听端口             | 5540          |
| SERVER_TLS       | boolean | 是否启用TLS              | true          |
| SERVER_TLS_CERT  | string  | TLS证书文件路径          | undefined     |
| SERVER_TLS_KEY   | string  | TLS密钥文件路径          | undefined     |
| LOG_LEVEL        | string  | 日志级别                 | info          |
| STDOUT_LOGGER    | boolean | 是否输出日志到STDOUT     | true*         |
| FILES_LOGGER     | boolean | 是否输出日志到文件       | false*        |

> 完整环境变量列表可参考上游项目的[default.ts](https://github.com/RedisInsight/RedisInsight/blob/main/redisinsight/api/config/default.ts)和[production.ts](https://github.com/RedisInsight/RedisInsight/blob/main/redisinsight/api/config/production.ts)文件。

## 许可信息- Redis Insight应用本身使用SSPL许可
- 本镜像的Dockerfile、入口脚本和构建流程使用MIT许可
- 禁止Redis/Redis Labs相关人员使用本项目源代码

## 说明本镜像旨在解决官方Redis Insight Docker构建问题，提供更轻量、安全的容器化方案。应用功能本身由Redis团队开发，本镜像仅优化容器化构建流程。
