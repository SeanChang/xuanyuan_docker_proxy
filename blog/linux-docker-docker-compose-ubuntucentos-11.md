---
id: 39
title: "手把手教你在 Linux 上安装 Docker 与 Docker Compose（支持 Ubuntu、CentOS 等 11 个发行版） "
slug: linux-docker-docker-compose-ubuntucentos-11
summary: 该脚本支持 11 种 Linux 发行版，包括国产操作系统（Anolis OS、OpenCloudOS、Alinux），一键安装 docker、docker-compose 并自动配置国内镜像访问支持源。
category: Docker, Docker Compose
tags: docker Compose,docker,安装教程
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-linux.png"
status: published
created_at: "2025-10-26 03:17:40"
updated_at: "2025-10-26 03:33:09"
---

# 手把手教你在 Linux 上安装 Docker 与 Docker Compose（支持 Ubuntu、CentOS 等 11 个发行版） 

> 该脚本支持 11 种 Linux 发行版，包括国产操作系统（Anolis OS、OpenCloudOS、Alinux），一键安装 docker、docker-compose 并自动配置国内镜像访问支持源。

# 推荐方案：一键安装配置脚本
该脚本支持 11 种 Linux 发行版，包括国产操作系统（Anolis OS、OpenCloudOS、Alinux），一键安装 docker、docker-compose 并自动配置国内镜像访问支持源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

## 脚本特性与优势
- ✅ 支持 11 种主流发行版：OpenCloudOS、Anolis OS (龙蜥)、Alinux (阿里云)、Fedora、Rocky Linux、AlmaLinux、Ubuntu、Debian、CentOS、RHEL、Oracle Linux
- ✅ 国产操作系统完整支持：深度适配国产操作系统（Anolis OS、OpenCloudOS、Alinux），支持版本自动识别和最优配置
- ✅ 多镜像源智能切换：内置阿里云、腾讯云、华为云、中科大、清华等 6+ 国内镜像源，自动检测并选择最快源
- ✅ 老版本系统特殊处理：支持 Ubuntu 16.04、Debian 9/10 等已过期系统，自动配置兼容的安装方案
- ✅ 双重安装保障：包管理器安装失败时自动切换到二进制安装，确保安装成功率
- ✅ macOS/Windows 友好提示：自动检测 macOS 和 Windows 系统，提供适合的 Docker Desktop 安装指引

脚本已开源：[GitHub 源码](https://github.com/)

## 支持的操作系统
该一键安装脚本支持 11 种主流 Linux 发行版，包括国产操作系统、CentOS 替代品和传统发行版：

| 操作系统分类       | 操作系统名称               | 版本          | 支持状态 | 说明                                  |
|--------------------|----------------------------|---------------|----------|---------------------------------------|
| 🇨🇳 国产操作系统    | OpenCloudOS                | 9.x           | ✅        | 腾讯开源，CentOS 9 兼容               |
|                    | Anolis OS (龙蜥)           | 7.x, 8.x      | ✅        | 阿里云支持，RHEL 兼容                 |
|                    | Alinux (阿里云)            | 2.x, 3.x      | ✅        | 阿里云 ECS 默认系统                   |
| 🌍 CentOS 替代品（企业级） | Rocky Linux                | 8.x, 9.x      | ✅        | 10年支持，RHEL 兼容                   |
|                    | AlmaLinux                  | 8.x, 9.x      | ✅        | 10年支持，RHEL 兼容                   |
| 🔄 创新发行版      | Fedora                     | 34+           | ✅        | Red Hat 上游，最新特性                |
| 📦 传统发行版      | Ubuntu                     | 16.04+        | ✅        | 含老版本特殊处理                      |
|                    | Debian                     | 9+            | ✅        | 含老版本特殊处理                      |
|                    | CentOS                     | 7, 8, 9       | ✅        | 包含 Stream 版本                      |
|                    | RHEL                       | 7, 8, 9       | ✅        | Red Hat Enterprise Linux              |
|                    | Oracle Linux               | 7, 8, 9       | ✅        | Oracle 企业级发行版                   |

💡 提示：脚本会自动检测您的操作系统类型和版本，并选择最优的安装方案。对于老版本系统（如 Ubuntu 16.04、Debian 9/10），脚本会自动使用兼容的安装方式。

## 视频教程
### 一键脚本使用教程
观看详细的使用教程，了解如何在不同 Linux 发行版上使用一键安装脚本配置 Docker 和 Docker Compose。

[在哔哩哔哩观看高清版本](https://www.bilibili.com/)

## 安装验证
安装完成后，请执行以下命令验证 Docker 是否安装成功：

1. 检查 Docker 版本
```bash
docker --version
```
显示已安装的 Docker 版本信息

2. 检查 Docker 服务状态
```bash
sudo systemctl status docker
```
检查 Docker 服务运行状态

3. 运行测试容器
```bash
sudo docker run hello-world
```
运行官方测试容器，验证 Docker 功能

## 常见问题
### 服务启动失败
如果 Docker 服务启动失败，可以查看详细错误信息：
```bash
sudo journalctl -u docker.service
```
查看 Docker 服务的详细日志信息

### 常见问题解答
#### 这个安装脚本支持哪些 Linux 发行版？
该脚本支持 11 种主流 Linux 发行版，会自动检测系统类型并选择最优安装方案：

🇨🇳 国产操作系统（3种）：
- OpenCloudOS（腾讯开源）
- Anolis OS（龙蜥操作系统，阿里云支持）
- Alinux（Alibaba Cloud Linux，阿里云官方）

🌍 CentOS 替代品（2种）：
- Rocky Linux（企业级，10年支持）
- AlmaLinux（企业级，10年支持）

🔄 创新发行版（1种）：
- Fedora（Red Hat 上游，最新特性）

📦 传统发行版（5种）：
- Ubuntu（含 16.04+ 所有版本）
- Debian（含 9/10/11+ 所有版本）
- CentOS（7/8/9）
- Red Hat Enterprise Linux（RHEL）
- Oracle Linux

#### 安装脚本是否安全可靠？
该脚本经过严格的安全审计和大量用户验证，安全可靠：
- ✅ GitHub 开源，代码完全透明可查
- ✅ 经过数万次真实环境测试
- ✅ 自动备份现有配置（daemon.json.backup.*）
- ✅ 支持多种安装方式，失败自动降级
- ✅ 完整的错误处理和日志输出
- ✅ 仅使用官方 Docker CE 仓库和镜像

#### 脚本有哪些核心优势？
- 多镜像源智能切换：内置阿里云、腾讯云、华为云、中科大、清华、网易等国内镜像源，自动检测并选择最快源
- 双重安装保障：包管理器失败时自动切换到二进制安装，确保安装成功
- 老系统兼容处理：对 Ubuntu 16.04、Debian 9/10 等已过期系统提供特殊兼容方案
- 国产系统深度适配：完整支持 Anolis OS、OpenCloudOS、Alinux 等国产操作系统
- 自动配置加速：安装完成后自动配置轩辕镜像访问支持，无需手动设置
- 跨平台友好：检测到 macOS/Windows 时提供适合的 Docker Desktop 安装指引

#### 支持国产操作系统吗？
完整支持！深度适配了 3 种主流国产操作系统：
- Anolis OS（龙蜥操作系统）：支持 7.x 和 8.x 版本，自动识别并使用对应的 CentOS 仓库
- OpenCloudOS（腾讯开源）：支持 9.x 版本，使用优化的 CentOS 9 兼容源
- Alinux（阿里云 Linux）：支持 2.x 和 3.x 版本，基于 Anolis OS 的商业版，阿里云 ECS 默认系统

这些国产系统与 RHEL/CentOS 完全兼容，我们的脚本会自动配置最优的安装方案和镜像源。

#### 安装完成后需要做什么？
安装完成后建议验证 Docker 版本、检查服务状态、运行测试容器，确保一切正常。脚本会自动配置轩辕镜像访问支持，提升下载访问表现。

