---
image: tianon/handbrake
description: "HandBrake视频转码工具的Docker镜像，从官方PPA (ppa:stebbins/handbrake-releases)安装，提供命令行界面，用于高效处理各类视频格式的转码任务。"
source: https://xuanyuan.cloud/zh/r/tianon/handbrake
canonical: https://xuanyuan.cloud/zh/r/tianon/handbrake
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tianon/handbrake" title="tianon/handbrake Docker 镜像中文简介、标签列表与拉取命令">tianon/handbrake 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# HandBrake Docker镜像

## 镜像概述

本镜像包含开源视频转码工具HandBrake，从官方PPA (ppa:stebbins/handbrake-releases)安装，提供命令行版本(handbrake-cli)。容器化部署消除了本地环境依赖，可在任何支持Docker的系统中快速执行视频转码操作，适用于处理多种输入输出格式的视频文件。

## 核心功能与特性

- **官方源保障**：基于HandBrake官方PPA构建，确保软件版本最新且安全可靠
- **多格式支持**：兼容主流视频格式输入(MP4、MKV、AVI、FLV等)和输出(H.264/AVC、H.265/HEVC、MPEG-4等)
- **命令行驱动**：通过handbrake-cli提供丰富的转码参数控制，支持自定义编码、分辨率、比特率等
- **轻量部署**：容器化设计减少系统依赖，启动快速，资源占用可控
- **跨平台运行**：可在Linux、Windows、macOS等支持Docker的环境中一致运行

## 使用场景

- **服务器批量转码**：在云服务器或本地服务器中处理用户上传的视频文件，生成适配不同设备的格式
- **自动化工作流**：集成到CI/CD或任务调度系统(如Cron、Airflow)，执行定时视频处理任务
- **开发测试环境**：快速验证不同转码参数组合的效果，无需修改本地系统配置
- **资源隔离处理**：通过容器隔离转码任务，避免与主机系统的依赖冲突

## 使用方法

### 基础转码操作

将当前目录下的`input.mp4`转码为`output.mkv`，挂载本地目录作为数据卷：

```bash
docker run --rm -v "$(pwd):/workdir" docker.xuanyuan.run/tianon/handbrake handbrake-cli -i /workdir/input.mp4 -o /workdir/output.mkv
```

### 指定高级转码参数

转码为H.265编码，设置质量参数20，分辨率调整为720p：

```bash
docker run --rm -v "$(pwd):/workdir" docker.xuanyuan.run/tianon/handbrake handbrake-cli \
  -i /workdir/input.mp4 \
  -o /workdir/output_h265.mp4 \
  -e x265 \          # 使用H.265编码器
  -q 20 \            # 质量参数(范围0-51，值越小质量越高)
  --width 1280 \     # 设置宽度
  --height 720 \     # 设置高度
  -r 30 \            # 帧率30fps
  -B 192             # 音频比特率192kbps
```

### 批量转码示例

使用`find`命令批量处理目录下所有MP4文件：

```bash
find ./source -name "*.mp4" -exec sh -c '
  input="{}"
  output="${input%.mp4}_converted.mkv"
  docker run --rm -v "$(pwd):/workdir" docker.xuanyuan.run/tianon/handbrake handbrake-cli -i "/workdir/$input" -o "/workdir/$output"
' \;
```

## 配置参数

### 数据卷挂载

| 卷路径 | 说明 |
|--------|------|
| `/workdir` | 建议挂载本地目录至该路径，用于输入源文件和输出结果的持久化存储 |

### 常用handbrake-cli参数

| 参数 | 说明 |
|------|------|
| `-i <path>` | 输入文件路径 |
| `-o <path>` | 输出文件路径 |
| `-e <encoder>` | 视频编码器(x264/x265/mpeg4等) |
| `-q <value>` | 恒定质量模式参数(0-51) |
| `-b <bitrate>` | 视频比特率(kbps) |
| `--width/--height` | 输出视频宽度/高度 |
| `-r <fps>` | 输出帧率 |
| `-B <bitrate>` | 音频比特率(kbps) |
| `-a <track>` | 指定音频轨道 |
| `-s <track>` | 指定字幕轨道 |

### 权限控制

默认以root用户运行，如需调整输出文件权限，可指定本地用户ID：

```bash
docker run --rm -u $(id -u):$(id -g) -v "$(pwd):/workdir" docker.xuanyuan.run/tianon/handbrake handbrake-cli -i /workdir/input.mp4 -o /workdir/output.mkv
```

## 性能优化建议

- **资源限制**：转码为CPU密集型任务，可通过`--cpus`限制CPU使用：
  ```bash
  docker run --rm --cpus 2 -v "$(pwd):/workdir" docker.xuanyuan.run/tianon/handbrake handbrake-cli ...
  ```

- **硬件加速**：如主机支持，可挂载GPU设备启用硬件编码(需主机安装对应驱动)：
  ```bash
  docker run --rm --device /dev/dri -v "$(pwd):/workdir" docker.xuanyuan.run/tianon/handbrake handbrake-cli -i /workdir/input.mp4 -o /workdir/output.mp4 -e nvenc_h265
  ```

## 镜像维护

- **获取最新版本**：
  ```bash
  docker pull docker.xuanyuan.run/tianon/handbrake
  ```

- **查看版本信息**：
  ```bash
  docker run --rm docker.xuanyuan.run/tianon/handbrake handbrake-cli --version
  ```

> 详细参数说明可参考[HandBrake CLI官方文档](https://handbrake.fr/docs/en/latest/cli/command-line-reference.html)
