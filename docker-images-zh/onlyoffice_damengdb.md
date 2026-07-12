---
image: onlyoffice/damengdb
description: "达梦数据库(Dameng DB)的Docker镜像，用于便捷部署达梦数据库实例，支持通过环境变量配置参数、数据持久化存储，适用于开发和测试环境快速搭建达梦数据库服务。"
source: https://xuanyuan.cloud/zh/r/onlyoffice/damengdb
canonical: https://xuanyuan.cloud/zh/r/onlyoffice/damengdb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/onlyoffice/damengdb" title="onlyoffice/damengdb Docker 镜像中文简介、标签列表与拉取命令">onlyoffice/damengdb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 达梦数据库(Dameng DB) Docker镜像文档

## 镜像概述
该镜像为达梦数据库(Dameng DB)的官方Docker镜像，旨在提供便捷、快速的达梦数据库部署方式。通过容器化部署，简化了达梦数据库的安装配置流程，支持自定义实例参数和数据持久化，适用于各类开发、测试场景。

## 核心功能与特性
- **便捷部署**：通过简单的Docker命令即可快速启动达梦数据库实例
- **环境变量配置**：支持通过环境变量自定义数据库参数（如页面大小、实例名称等）
- **数据持久化**：通过数据卷挂载实现数据库数据持久化存储
- **自动重启**：支持配置容器自动重启策略，保障服务稳定性
- **版本适配**：不同版本镜像内置对应版本的达梦数据库，满足不同版本需求

## 使用场景
- 开发环境快速搭建达梦数据库服务
- 测试环境中快速部署独立的达梦数据库实例
- 需要临时使用达梦数据库进行功能验证或演示
- 轻量级达梦数据库服务部署需求

## 使用方法

### 基本部署命令
通过以下命令部署达梦数据库容器：

```bash
docker run -d -p 5236:5236 --restart=always --name dm8_01 --privileged=true \
  -e PAGE_SIZE=16 \
  -e LD_LIBRARY_PATH=/opt/dmdbms/bin \
  -e INSTANCE_NAME=dm8_01 \
  -v /data/dm8_01:/opt/dmdbms/data \
  docker.xuanyuan.run/onlyoffice/damengdb:8.1.3
```

### 参数说明
| 参数 | 说明 |
|------|------|
| `-d` | 后台运行容器 |
| `-p 5236:5236` | 端口映射，将容器内5236端口（达梦数据库默认端口）映射到主机5236端口 |
| `--restart=always` | 容器退出时自动重启 |
| `--name dm8_01` | 指定容器名称为dm8_01 |
| `--privileged=true` | 授予容器特权模式，确保数据库正常运行 |
| `-e PAGE_SIZE=16` | 设置数据库页面大小为16KB |
| `-e LD_LIBRARY_PATH=/opt/dmdbms/bin` | 指定动态链接库路径 |
| `-e INSTANCE_NAME=dm8_01` | 指定数据库实例名称 |
| `-v /data/dm8_01:/opt/dmdbms/data` | 数据卷挂载，将主机/data/dm8_01目录挂载到容器内数据库数据目录，实现数据持久化 |

## 版本与登录凭证
不同版本的镜像对应不同的数据库默认登录凭证：

- **8.1.3版本**：
  - 用户名：`SYSDBA`
  - 密码：`SYSDBA_dm001`

- **8.1.2版本**：
  - 用户名：`SYSDBA`
  - 密码：`SYSDBA001`

> 注意：首次登录后建议及时修改默认密码，保障数据库安全。
