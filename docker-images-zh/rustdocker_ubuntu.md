---
image: rustdocker/ubuntu
description: "包含开发环境的Ubuntu系统镜像"
source: https://xuanyuan.cloud/zh/r/rustdocker/ubuntu
canonical: https://xuanyuan.cloud/zh/r/rustdocker/ubuntu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rustdocker/ubuntu" title="rustdocker/ubuntu Docker 镜像中文简介、标签列表与拉取命令">rustdocker/ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
本镜像为基于Ubuntu系统的开发环境专用镜像，预装了开发所需的基础工具和运行环境，旨在帮助开发者快速搭建一致、便捷的开发工作环境，减少环境配置时间。

# 支持的标签及对应的Dockerfile链接
- `latest`: [_ubuntu/Dockerfile_](https://gitlab.com/imp/rustdocker/blob/master/ubuntu-dev/Dockerfile)

# 核心功能与特性
- 基于官方Ubuntu系统构建，确保系统稳定性和兼容性
- 集成开发环境所需组件，开箱即可进行开发工作
- 提供单一稳定标签(`latest`)，简化版本管理

# 使用场景
- 个人开发者日常应用开发、编译与测试
- 团队协作时统一开发环境，避免"在我电脑上能运行"问题
- 作为CI/CD流程中的基础开发环境容器

# 使用方法
## 拉取镜像
通过Docker命令拉取最新版本镜像：
```bash
docker pull docker.xuanyuan.run/imp/rustdocker:latest
```

## 启动开发容器
以交互模式启动容器，进入开发环境：
```bash
docker run -it --name dev-container docker.xuanyuan.run/imp/rustdocker:latest /bin/bash
```

## 持久化开发数据（可选）
如需保留开发数据，可挂载本地目录到容器：
```bash
docker run -it -v /本地开发目录:/container工作目录 --name dev-container docker.xuanyuan.run/imp/rustdocker:latest /bin/bash
