---
image: halohub/halo
description: "强大易用的开源建站工具。"
source: https://xuanyuan.cloud/zh/r/halohub/halo
canonical: https://xuanyuan.cloud/zh/r/halohub/halo
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [halohub/halo — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/halohub/halo)

含镜像标签、拉取命令、部署文档与相关推荐。

[halohub/halo Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/halohub/halo)

# Halo 开源建站工具 Docker 镜像文档

## 镜像概述

Halo 是一款强大易用的开源建站工具，旨在帮助用户快速搭建和管理个人博客、网站等各类在线内容平台。该 Docker 镜像封装了 Halo 的核心运行环境，提供便捷的部署方式，让用户无需复杂配置即可快速启动服务。

## 核心功能与特性

- **开源免费**：基于开源协议发布，代码透明可审计，无商业许可限制
- **易用性**：提供直观的管理界面，降低建站技术门槛
- **扩展性**：支持主题和插件系统，可根据需求扩展功能
- **跨平台**：通过 Docker 容器化部署，兼容多种操作系统环境

> 更多功能特性请查阅 [官方文档](https://docs.halo.run)

## 使用场景与适用范围

- 个人博客搭建与管理
- 小型网站快速部署
- 内容创作者构建在线内容平台
- 开发者学习和二次开发

## 使用方法与配置说明

### 前提条件

- 已安装 Docker 环境
- 已安装 Docker Compose（可选，用于更复杂部署）

### 快速启动

#### Docker Run 部署

```bash
# 拉取最新版镜像
docker pull halohub/halo:latest

# 运行容器（默认配置）
docker run -d \
  --name halo \
  -p 8090:8090 \
  -v ~/halo/data:/root/.halo/data \
  halohub/halo:latest
```

> 说明：
> - `-p 8090:8090`：端口映射，将容器内 8090 端口映射到主机 8090 端口
> - `-v ~/halo/data:/root/.halo/data`：数据卷挂载，持久化存储 Halo 数据（重要，避免容器删除导致数据丢失）

#### 访问服务

容器启动后，通过浏览器访问 `http://<主机IP>:8090` 即可进入 Halo 初始化配置界面，按照引导完成网站设置。

### 详细配置

完整的配置说明（包括自定义端口、数据库配置、环境变量设置等）请参考官方安装教程：  
[Halo Docker 安装教程](https://docs.halo.run/getting-started/install/docker)

## 相关资源

- **官方网站**：[https://www.halo.run](https://www.halo.run)
- **官方文档**：[https://docs.halo.run](https://docs.halo.run)
- **用户论坛**：[https://bbs.halo.run](https://bbs.halo.run)
- **GitHub 仓库**：[https://github.com/halo-dev](https://github.com/halo-dev)
