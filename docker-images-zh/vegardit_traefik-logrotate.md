---
image: vegardit/traefik-logrotate
description: "用于与Docker化的Traefik配合使用，实现Traefik访问日志轮转的Docker镜像。"
source: https://xuanyuan.cloud/zh/r/vegardit/traefik-logrotate
canonical: https://xuanyuan.cloud/zh/r/vegardit/traefik-logrotate
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vegardit/traefik-logrotate" title="vegardit/traefik-logrotate Docker 镜像中文简介、标签列表与拉取命令">vegardit/traefik-logrotate 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Traefik访问日志轮转Docker镜像

## 镜像概述

基于[alpine:3](https://hub.docker.com/_/alpine?tab=tags&page=1&name=3)的轻量级Docker镜像，专为与Docker化部署的[Traefik](https://traefik.io)实例配合使用而设计，用于轮转[Traefik访问日志](https://doc.traefik.io/traefik/observability/access-logs/)。

该镜像每周自动构建，确保包含最新的操作系统安全修复。

## 核心功能与特性

- **轻量级基础**：基于alpine:3构建，镜像体积小，资源占用低
- **日志轮转**：专门针对Traefik访问日志进行轮转管理，防止日志文件无限增长
- **安全更新**：每周自动构建，持续集成最新的操作系统安全补丁
- **无缝集成**：与Docker化部署的Traefik服务兼容，易于配合使用

## 使用场景与适用范围

适用于所有通过Docker部署Traefik的环境，需要对Traefik生成的访问日志进行自动化轮转管理的场景，尤其适合长期运行Traefik服务并关注日志存储优化的用户。

## 相关资源

- **源码仓库**：https://github.com/vegardit/docker-traefik-logrotate
- **详细文档**：https://github.com/vegardit/docker-traefik-logrotate/blob/main/README.md
