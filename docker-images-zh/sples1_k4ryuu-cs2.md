---
image: sples1/k4ryuu-cs2
description: "CS2 Egg：VPK同步节省80%存储，支持MetaMod、CounterStrikeSharp、SwiftlyS2和ModSharp自动更新的生产级Counter-Strike 2 Pterodactyl Egg"
source: https://xuanyuan.cloud/zh/r/sples1/k4ryuu-cs2
canonical: https://xuanyuan.cloud/zh/r/sples1/k4ryuu-cs2
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [sples1/k4ryuu-cs2 — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/sples1/k4ryuu-cs2)

含镜像标签、拉取命令、部署文档与相关推荐。

[sples1/k4ryuu-cs2 Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/sples1/k4ryuu-cs2)

# CS2 Pterodactyl Egg 镜像文档

## 镜像概述

本镜像为生产就绪的Counter-Strike 2 (CS2) Pterodactyl Egg，集成企业级功能，旨在简化CS2服务器的部署、管理与维护，特别优化存储效率与插件框架自动化更新。

## 核心功能与特性

### 存储与性能
- **VPK同步**：通过集中式文件共享减少80%存储空间
- **智能清理**：自动化备份、日志及演示文件管理
- **优化的启动与更新流程**：提升服务器启动速度与更新效率

### 自动更新
- **多框架自动更新**：支持MetaMod、CounterStrikeSharp、SwiftlyS2、ModSharp自动更新
- **集中式更新脚本**：自动触发服务器重启完成更新
- **版本跟踪**：集成SteamCMD原生检查，确保版本一致性

### 多框架支持
- **MetaMod:Source**：核心插件框架
- **CounterStrikeSharp**：基于.NET 8的C#插件框架
- **SwiftlyS2 v2**：独立C#插件框架
- **ModSharp**：基于.NET 9的独立插件框架

### 管理功能
- **FTP可编辑JSON配置**：便捷修改服务器设置
- **控制台消息过滤**：精准筛选关键日志
- **彩色日志与GSLT令牌掩码**：增强日志可读性，保护敏感令牌
- **自定义启动参数**：灵活配置服务器启动选项

## 使用场景与适用范围

适用于需要高效部署、管理CS2服务器的场景，尤其适合：
- 游戏服务器管理员部署生产环境CS2服务器
- 服务器托管服务商提供CS2服务器托管服务
- 需要自动化插件框架更新与存储优化的团队或个人

## 系统要求

- 操作系统：Ubuntu 18.04+ 或 Debian 10+（64位）
- 架构支持：x86_64（兼容i386多架构）

## 完整文档

更多详细配置与使用说明，请参考：[CS2 Egg 完整文档](https://github.com/K4ryuu/CS2-Egg/blob/dev/docs/README.md)
