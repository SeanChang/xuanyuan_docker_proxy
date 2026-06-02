---
image: beevelop/android
description: "提供Android运行环境的Docker镜像，适用于Android应用开发、测试及相关任务的容器化部署。"
source: https://xuanyuan.cloud/zh/r/beevelop/android
canonical: https://xuanyuan.cloud/zh/r/beevelop/android
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/beevelop/android" title="beevelop/android Docker 镜像中文简介、标签列表与拉取命令">beevelop/android — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/beevelop/android" title="beevelop/android Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/beevelop/android</a>

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/beevelop/docker-android/docker.yml?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/beevelop/android.svg?style=for-the-badge)
![Docker Stars](https://img.shields.io/docker/stars/beevelop/android?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/beevelop/android/latest?style=for-the-badge)
![License](https://img.shields.io/github/license/beevelop/docker-android?style=for-the-badge)
[![GitHub release](https://img.shields.io/github/release/beevelop/docker-android.svg?style=for-the-badge)](https://github.com/beevelop/docker-android/releases)
![GitHub Release Date](https://img.shields.io/github/release-date/beevelop/docker-android?style=for-the-badge)
![CalVer](https://img.shields.io/badge/CalVer-YYYY.MM.MICRO-22bfda.svg?style=for-the-badge)
[![Beevelop](https://img.shields.io/badge/-%20Made%20with%20%F0%9F%8D%AF%20by%20%F0%9F%90%9Dvelop-blue.svg?style=for-the-badge)](https://beevelop.com)

# Android 13 (API levels 28 - 33) Docker 镜像

## 概述与主要用途

本镜像基于 [beevelop/java](https://github.com/beevelop/docker-java) 构建，专为 Android 应用开发和构建设计，支持 API levels 28 至 33（对应 Android 13）。集成了 Android 开发所需的核心工具链，可提供一致、隔离的开发环境，适用于本地开发、CI/CD 流程及自动化构建场景。

## 核心功能与特性

### 基础环境
- **基于 beevelop/java**：提供稳定的 Java 开发环境
- **支持 API 级别**：28 - 33（Android 13）

### 集成工具版本
- Java：`11.0.17`
- Gradle：`4.4.1`（Groovy：`2.4.17`）
- Apache Maven：`3.6.3`
- Ant：`1.10.7`

## 使用场景与适用范围
- **Android 应用构建**：本地或 CI 环境中编译、打包 Android 应用
- **开发环境一致性**：团队内部统一开发工具版本，避免环境差异导致的问题
- **自动化测试**：配合 CI/CD 工具（如 Jenkins、GitHub Actions）实现自动化构建与测试
- **Docker 化开发流程**：作为基础镜像构建自定义 Android 开发环境

## 使用方法与配置说明

### 拉取镜像
通过 Docker Hub 拉取最新或指定版本镜像：
```bash
# 拉取最新标签/版本
docker pull beevelop/android:v2023.01.2
```

### 运行容器
以交互方式运行容器（用于临时开发或调试）：
```bash
docker run --rm --name beevelop-android -it beevelop/android:v2023.01.2 bash
```
> **参数说明**：`--rm` 退出后自动删除容器，`-it` 启用交互终端，`--name` 指定容器名称

### 构建镜像
从 GitHub 源码构建镜像：
```bash
docker build -t beevelop/android github.com/beevelop/docker-base
```

### 作为基础镜像使用
在自定义 Dockerfile 中引用本镜像，扩展开发环境：
```Dockerfile
FROM beevelop/android:v2023.01.2

# 接受 Android SDK 许可证（使用前请阅读许可证协议）
RUN yes | sdkmanager --licenses --sdk_root=$ANDROID_SDK_ROOT

# 示例：安装额外的 Android 构建工具
RUN sdkmanager --sdk_root=$ANDROID_SDK_ROOT "build-tools;33.0.2" "platforms;android-33"
```

## 许可证说明
使用本镜像即表示您同意 Android SDK 的许可条款。Android SDK 许可证详情可通过 Android 官方文档查看。在构建自定义镜像时，建议通过 `sdkmanager --licenses` 命令显式接受许可证。

## 维护命令
### 工具管理
- **下载 Android 命令行工具**：[官方下载地址](https://developer.android.com/studio#span-idcommand-toolsa-namecmdline-toolsacommand-line-tools-onlyspan)
- **列出已安装/可用的 build-tools 版本**：
  ```bash
  sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --list | grep build-tools
  ```
- **列出已安装/可用的平台版本**：
  ```bash
  sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --list | grep 'platforms:'
  ```

## 标签使用建议
建议使用特定版本标签（如 `v2023.01.2`）而非 `latest`，以确保环境稳定性和可重复性。

![One does not simply use latest](https://i.imgflip.com/1fgwxr.jpg)

---

![Beevelop's Docker Image Hierarchy](https://gist.githubusercontent.com/beevelop/b0cddab7209a683c77560d06ff00bc8e/raw/15429ee1d02e2c4dc019b760ca8c7ceff5911b82/hierarchy.png)
