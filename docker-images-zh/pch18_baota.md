---
image: pch18/baota
description: "宝塔面板Docker镜像，支持一键部署、在线升级和数据持久化，保留卷状态下删除容器后重建数据不丢失。"
source: https://xuanyuan.cloud/zh/r/pch18/baota
canonical: https://xuanyuan.cloud/zh/r/pch18/baota
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pch18/baota" title="pch18/baota Docker 镜像中文简介、标签列表与拉取命令">pch18/baota 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 宝塔面板Docker镜像文档

## 镜像概述

本镜像为宝塔面板的Docker化部署方案，基于GitHub上的Dockerfile自动构建，确保无后台植入行为，安全可靠。支持一键部署宝塔面板及相关Web服务，数据持久化存储，删除容器后保留卷数据可实现重建容器时数据不丢失。

## 核心功能与特性

- **安全可靠**：镜像通过GitHub Dockerfile自动构建，构建过程透明可监督，无恶意代码植入
- **多种运行模式**：支持host网络模式（推荐）和bridge网络模式，满足不同环境需求
- **数据持久化**：关键数据存储在Docker卷中，删除容器后数据不丢失，支持容器重建后恢复
- **多版本选择**：提供多种预配置版本，包含不同Web服务组合（LNMP、LNP、LAMP等）
- **自动服务启动**：容器启动时自动启动所有相关服务，无需手动干预
- **支持在线升级**：安装完成后可通过面板内置功能升级到最新版本

## 使用场景

- 个人或企业Web服务器快速搭建
- 开发测试环境的快速部署与重置
- 需要数据持久化的生产环境Web服务部署
- 对服务器管理有图形化界面需求的场景

## 使用方法

### 1. 推荐：host网络模式运行

host模式无需手动映射端口，自动映射宝塔面板全端口到外网，且能确保网站后台获取用户真实IP：

```bash
docker run -tid --name baota --net=host --privileged=true --shm-size=1g --restart always -v ~/wwwroot:/www/wwwroot docker.xuanyuan.run/pch18/baota
```

### 2. 兼容模式：bridge网络模式运行

适用于不支持host模式的环境（如macOS和Windows），需手动映射端口：

```bash
docker run -tid --name baota -p 80:80 -p 443:443 -p 8888:8888 -p 888:888 --privileged=true --shm-size=1g --restart always -v ~/wwwroot:/www/wwwroot docker.xuanyuan.run/pch18/baota
```

### 3. 登录方式

- 登录地址：`http://{{面板ip地址}}:8888`
- 初始账号：`username`
- 初始密码：`password`

> **重要提示**：由于Docker镜像特性，初始密码为统一设置，登录后请立即修改账号密码以保障安全。

### 4. 删除容器命令

```bash
docker rm -fv baota
```

## 版本命名说明

| 镜像标签 | 说明 |
|---------|------|
| `pch18/baota` 或 `pch18/baota:latest` | 等同于 `pch18/baota:lnmp` |
| `pch18/baota:lnmp` | 官方纯净版基础上预安装Nginx、MySQL、PHP |
| `pch18/baota:lnp` | 官方纯净版基础上预安装Nginx、PHP（无内置MySQL，适用于外置数据库环境） |
| `pch18/baota:lamp` | 官方纯净版基础上预安装Apache、PHP |
| `pch18/baota:lap` | 官方纯净版基础上预安装Apache、PHP（无内置MySQL，适用于外置数据库环境） |
| `pch18/baota:clear` | 官方纯净版，不默认安装Nginx、MySQL、PHP等程序 |

## 数据持久化建议

- `/www` 文件夹建议保存在Docker卷中
- `/www/wwwroot` 建议映射到宿主机目录（如示例命令中的 `~/wwwroot`），方便上传网站代码

## 相关链接

- Docker安装脚本：[https://pch18.cn/archives/install_docker.html](https://pch18.cn/archives/install_docker.html)
- GitHub Issue（问题反馈）：[https://github.com/pch18-docker/baota/issues](https://github.com/pch18-docker/baota/issues)
- Docker Hub镜像地址：[https://hub.docker.com/r/pch18/baota/](https://hub.docker.com/r/pch18/baota/)
- 个人主页：[https://pch18.cn/archives/docker-baota.html](https://pch18.cn/archives/docker-baota.html)
