---
image: redroid/redroid
description: "远程安卓多架构GPU加速安卓云（Android In Cloud）解决方案是一种能够在云端提供高效远程安卓服务的综合性技术方案，该方案支持多种架构并集成先进的GPU加速技术，可显著提升远程安卓应用的运行效率、图形处理能力和整体性能，适用于需要在云端远程访问和运行安卓环境的各类应用场景。"
source: https://xuanyuan.cloud/zh/r/redroid/redroid
canonical: https://xuanyuan.cloud/zh/r/redroid/redroid
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redroid/redroid" title="redroid/redroid Docker 镜像中文简介、标签列表与拉取命令">redroid/redroid — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/redroid/redroid" title="redroid/redroid Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/redroid/redroid</a>

# redroid 介绍


## 概述  
redroid（Remote Android）是一款支持 GPU 加速的云安卓（AIC, Android In Cloud）解决方案，可在 Linux 主机（如 Docker、podman、k8s 等环境）中启动多个安卓实例，支持 arm64 和 amd64 架构。适用于云游戏、虚拟手机、自动化测试等场景。  

![redroid 11 截图]([])  

**当前支持的安卓版本**：  
- Android 16（`redroid/redroid:16.0.0-latest`）  
- Android 16 纯 64 位（`redroid/redroid:16.0.0_64only-latest`）  
- Android 15（`redroid/redroid:15.0.0-latest`）  
- Android 15 纯 64 位（`redroid/redroid:15.0.0_64only-latest`）  
- Android 14（`redroid/redroid:14.0.0-latest`）  
- Android 14 纯 64 位（`redroid/redroid:14.0.0_64only-latest`）  
- Android 13（`redroid/redroid:13.0.0-latest`）  
- Android 13 纯 64 位（`redroid/redroid:13.0.0_64only-latest`）  
- Android 12（`redroid/redroid:12.0.0-latest`）  
- Android 12 纯 64 位（`redroid/redroid:12.0.0_64only-latest`）  
- Android 11（`redroid/redroid:11.0.0-latest`）  
- Android 10（`redroid/redroid:10.0.0-latest`）  
- Android 9（`redroid/redroid:9.0.0-latest`）  
- Android 8.1（`redroid/redroid:8.1.0-latest`）  


## 快速开始  
redroid 可在任何 Linux 系统上运行（需启用部分内核特性）。以下是 Ubuntu 20.04 的快速启动步骤，其他发行版可参考 [部署文档]([])。  


### 步骤 1：安装依赖  
1. 安装 Docker（参考 [Docker 官方文档]([])）。  
2. 安装内核模块：  
   ```bash  
   apt install linux-modules-extra-`uname -r`  
   modprobe binder_linux devices="binder,hwbinder,vndbinder"  
   modprobe ashmem_linux  
   ```  


### 步骤 2：启动 redroid 容器  
```bash  
docker run -itd --rm --privileged \  
    --pull always \  
    -v ~/data:/data \  
    -p 5555:5555 \  
    redroid/redroid:12.0.0_64only-latest  
```  

**参数说明**：  
- `--pull always`：拉取最新镜像  
- `-v ~/data:/data`：挂载数据分区（持久化存储）  
- `-p 5555:5555`：暴露 ADB 端口  


### 步骤 3：连接与控制  
1. 安装 ADB（参考 [Android 官方文档]([])），连接设备：  
   ```bash  
   adb connect localhost:5555  # 远程运行时替换 localhost 为实际 IP  
   ```  
2. 查看屏幕（需安装 scrcpy，参考 [scrcpy 文档]([])）：  
   ```bash  
   scrcpy -s localhost:5555  # 远程运行时替换 localhost 为实际 IP（通常在本地 PC 执行）  
   ```  


## 配置参数  
可通过启动命令追加参数自定义 redroid 配置（如调整屏幕分辨率），示例：  
```bash  
docker run -itd --rm --privileged \  
    --pull always \  
    -v ~/data:/data \  
    -p 5555:5555 \  
    redroid/redroid:12.0.0_64only-latest \  
    androidboot.redroid_width=1080 \  # 屏幕宽度  
    androidboot.redroid_height=1920 \  # 屏幕高度  
    androidboot.redroid_dpi=480  # 屏幕 DPI  
```  


### 核心配置参数表  
| 参数 | 描述 | 默认值 |  
|------|------|--------|  
| `androidboot.redroid_width` | 屏幕宽度 | 720 |  
| `androidboot.redroid_height` | 屏幕高度 | 1280 |  
| `androidboot.redroid_fps` | 屏幕刷新率 | 30（GPU 启用时）；15（GPU 未启用时） |  
| `androidboot.redroid_dpi` | 屏幕 DPI | 320 |  
| `androidboot.use_memfd` | 用 memfd 替代已弃用的 ashmem（计划默认启用） | false |  
| `androidboot.use_redroid_overlayfs` | 启用 overlayfs 共享 data 分区（`/data-base` 共享，`/data-diff` 私有） | 0（禁用） |  
| `androidboot.redroid_gpu_mode` | 渲染模式：`auto`（自动检测）、`host`（GPU 加速）、`guest`（软件渲染） | `guest` |  
| `androidboot.redroid_gpu_node` | GPU 节点路径 | 自动检测 |  
| `ro.xxx` | 调试用，允许覆盖系统属性（如 `ro.secure=0` 可默认开启 root adb shell） | - |  


## 故障排除  


### 1. 收集调试信息  
执行以下命令生成调试日志：  
```bash  
curl -fsSL [] | sudo bash -s -- [CONTAINER]  
```  
（如容器已消失，可省略 `[CONTAINER]` 参数）  


### 2. 容器启动后立即消失  
- 检查内核模块是否安装：执行 `dmesg -T` 查看详细日志（通常因 `binder_linux` 或 `ashmem_linux` 模块缺失）。  


### 3. 容器运行但 ADB 无法连接（如设备离线）  
- 进入容器查看进程和日志：  
  ```bash  
  docker exec -it <容器ID> sh  
  ps -A  # 检查关键进程是否运行  
  logcat  # 查看系统日志  
  ```  
- 若无法进入容器，执行 `dmesg -T` 排查内核层面问题。  


## 联系与支持  
- Slack 社区：[remote-android.]()（需通过邀请链接加入）  
- 邮箱：[邮箱已删除]  


## 许可证  
- redroid 主体代码采用 [Apache License]([])。  
- 内核模块采用 [GPL v2 许可证]([])。  

（注：因包含第三方模块，使用前请仔细检查相关组件许可证。）  


更多详情可参考 [项目 GitHub]([])。
