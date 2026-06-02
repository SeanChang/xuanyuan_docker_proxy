<!-- xuanyuan-docker-images-zh
image: kasmweb/redroid
source: https://xuanyuan.cloud/zh/r/kasmweb/redroid
canonical: https://xuanyuan.cloud/zh/r/kasmweb/redroid
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [kasmweb/redroid — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/kasmweb/redroid "kasmweb/redroid Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/kasmweb/redroid

# Kasm Workspaces Redroid 镜像文档

## 镜像概述和主要用途

Kasm Workspaces 是一个 Docker 容器流平台，用于提供基于浏览器的桌面、应用程序和 Web 服务访问。本实验性镜像包含可通过浏览器访问的 [Redroid](https://github.com/remote-android/redroid-doc) 版本。Redroid (Remote-Android) 是一个多架构、支持 GPU 的云安卓解决方案。

该镜像利用 Docker in Docker (DinD) 自动启动 Redroid 和 [scrcpy](https://github.com/Genymobile/scrcpy)。

![Image Screenshot](https://f.hubspotusercontent30.net/hubfs/5856039/dockerhub/image-screenshots/redroid.png "Image Screenshot")

## 核心功能和特性

- 浏览器可访问的 Android 环境
- 多架构支持
- GPU 加速
- 基于 Web 的访问方式
- 支持多种 Android 版本
- 可自定义屏幕尺寸和 DPI
- 集成 scrcpy 实现屏幕镜像和控制

## 使用场景和适用范围

- 移动应用测试环境
- 跨平台应用开发
- 云安卓体验
- 教育和演示环境
- 移动应用自动化测试
- 需要浏览器访问安卓环境的场景

## 详细使用方法和配置说明

### 主机依赖

此镜像需要在主机上安装并启用 "binder_linux" 内核模块。

以下是在 Ubuntu 22.04 LTS 主机上安装 binder_linux 的示例：

```bash
sudo apt install linux-modules-extra-`uname -r`
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
```

有关更多详细信息，请参见 [Redroid 文档](https://github.com/remote-android/redroid-doc?tab=readme-ov-file#getting-started)。

### 容器权限

使用此容器需要 `--privileged` 标志，以支持 Docker in Docker 进程和 redroid 容器所需的权限：

```bash
sudo docker run --rm -it --privileged --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/redroid:develop
```

### 操作快捷键

左 ALT 键被映射为 scrcpy 的热键：

- Alt+R - 旋转安卓设备
- Alt+F - 安卓设备全屏显示
- Alt+Up/Alt+Down - 增加/减小设备音量

更多详情请参见 [scrcpy 文档](https://github.com/Genymobile/scrcpy)。

## 环境变量

| 环境变量 | 说明 |
|---------|------|
| `REDROID_GPU_GUEST_MODE` | 用于指示 redroid 使用 GPU 渲染。选项：`auto`、`guest` 和 `host` |
| `REDROID_FPS` | 设置 redroid 和 scrcpy 的最大 FPS |
| `REDROID_WIDTH` | 设置 redroid 设备的宽度 |
| `REDROID_HEIGHT` | 设置 redroid 设备的高度 |
| `REDROID_DPI` | 设置 redroid 设备的 DPI |
| `REDROID_SHOW_CONSOLE` | 启动 redroid 设备后显示 scrcpy 控制台 |
| `REDROID_DISABLE_AUTOSTART` | 如果设置为 "1"，容器将不会自动拉取和启动 redroid 容器和 scrcpy |
| `REDROID_DISABLE_HOST_CHECKS` | 如果设置为 "1"，容器将不会检查所需的主机级内核模块是否存在 |
| `ANDROID_VERSION` | 要自动加载的安卓 (redroid) 镜像版本。选项：`14.0.0`、`13.0.0`（默认）、`12.0.0`、`11.0.0`、`10.0.0`、`9.0.0`、`8.1.0` |
| `VNC_PW` | VNC 访问密码 |

## 部署方案

### 独立部署

此镜像设计用于在 Kasm Workspaces 中运行，但也可以独立部署并通过 Web 浏览器访问：

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/redroid:1.17.0
```

现在可通过浏览器访问容器：https://服务器IP:6901

- 用户：kasm_user
- 密码：password

**请注意，某些功能（如音频、上传、下载和麦克风直通）仅在使用 Kasm Workspaces 进行编排时可用。**

### 自定义配置示例

使用自定义屏幕尺寸和 Android 版本的部署示例：

```bash
sudo docker run --rm -it --privileged --shm-size=512m \
  -p 6901:6901 \
  -e VNC_PW=mysecretpassword \
  -e ANDROID_VERSION=14.0.0 \
  -e REDROID_WIDTH=1080 \
  -e REDROID_HEIGHT=2340 \
  -e REDROID_DPI=480 \
  kasmweb/redroid:1.17.0
```

## 镜像标签

- `1.17.0`: 基于 Kasm Workspaces 发布版本构建和标记的镜像
- `1.17.0-rolling`: 滚动标签，每晚更新和构建，确保镜像运行最新版本
- `develop`: 开发标签，用于测试，不保证兼容性

## 附加信息

### 源代码

- [KasmVNC GitHub](https://github.com/kasmtech/KasmVNC): 开源 VNC 服务器：原生 Web、安全、高性能
- [Images GitHub](https://github.com/kasmtech/workspaces-images): Workspaces Docker 镜像库
- [Core Images GitHub](https://github.com/kasmtech/workspaces-core-images): 用于自定义镜像的核心 OS 基线库

### Workspaces 文档

- [Developer API](https://www.kasmweb.com/docs/latest/developers/developer_api.html): 与您的应用程序和工作流集成
- [Workspaces](https://www.kasmweb.com/docs/latest/install.html): 安装和配置 Kasm Workspaces 的说明
- [Custom Images](https://www.kasmweb.com/docs/latest/how_to/building_images.html): 关于配置自定义镜像和安装软件的信息

### 问题报告

- [Issue Tracker GitHub](https://github.com/kasmtech/workspaces-issues/issues): 社区问题报告

## 实时演示

[启动实时演示](https://app.kasmweb.com/#/cast/87592435803135)（在新浏览器窗口中打开）。

*注意：演示限制为 3 分钟，出于安全考虑，上传/下载受到限制。*

## 开始使用

试用我们的免费社区版：[下载](https://kasmweb.com/downloads)。

Kasm Workspaces 团队已开源我们的镜像库（[信息](https://www.kasmweb.com/docs/latest/guide/custom_images.html) 和 [源代码](https://github.com/kasmtech/workspaces-images)）。

原生 Web 渲染由我们的开源项目 [KasmVNC](https://github.com/kasmtech/KasmVNC) 提供支持。
