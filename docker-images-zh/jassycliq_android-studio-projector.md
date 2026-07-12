---
image: jassycliq/android-studio-projector
description: "使用JetBrain Projector运行Android Studio，当前仅支持Canary版本。"
source: https://xuanyuan.cloud/zh/r/jassycliq/android-studio-projector
canonical: https://xuanyuan.cloud/zh/r/jassycliq/android-studio-projector
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jassycliq/android-studio-projector" title="jassycliq/android-studio-projector Docker 镜像中文简介、标签列表与拉取命令">jassycliq/android-studio-projector 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# jassycliq/android-studio-projector镜像说明

## 镜像概述
本Docker镜像基于JetBrain Projector技术，提供Android Studio的远程运行环境，允许用户通过浏览器或Projector客户端访问并使用Android Studio，当前仅支持Canary版本。

## 核心功能
- 通过Projector实现Android Studio的远程访问，突破本地设备配置限制
- 支持团队共享统一的开发环境，简化协作流程
- 保持Android Studio Canary版本的最新特性体验

## 使用场景
- 远程开发Android应用，无需在本地安装Android Studio
- 低配置设备上通过远程方式使用Android Studio进行开发
- 团队成员共享标准化的开发环境，避免环境不一致问题

## 配置说明
- 默认暴露Projector服务端口（通常为8887），需在运行时映射到主机端口
- 可根据需求调整容器资源限制（如内存、CPU）以优化运行性能

## 部署示例
### Docker Run命令
```bash
docker run -d -p 8887:8887 docker.xuanyuan.run/jassycliq/android-studio-projector
```
运行后，通过浏览器访问`http://localhost:8887`即可进入Android Studio界面。
