---
image: aront/sonarr
description: "基于linuxserver/sonarr的Docker容器，内置mp4自动化功能，用于管理电视节目集并自动将媒体文件处理为MP4格式。"
source: https://xuanyuan.cloud/zh/r/aront/sonarr
canonical: https://xuanyuan.cloud/zh/r/aront/sonarr
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/aront/sonarr" title="aront/sonarr Docker 镜像中文简介、标签列表与拉取命令">aront/sonarr 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# aront/sonarr
基于linuxserver/sonarr的Docker容器，内置mp4自动化功能

## 镜像概述
本镜像在linuxserver/sonarr的基础上集成了mp4自动化工具，帮助用户高效管理电视节目集，自动将下载的媒体文件转换为通用的MP4格式，提升媒体文件的兼容性与管理便捷性。

## 核心功能
1. 继承linuxserver/sonarr的电视节目管理能力：自动搜索、下载、整理电视节目
2. 内置mp4自动化工具：批量将媒体文件转换为MP4格式
3. 支持配置文件共享：多容器环境下可统一管理自动化设置

## 使用场景
- 个人媒体库管理：自动整理电视节目并标准化为MP4格式
- 多容器媒体服务：与Radarr、Transmission等工具配合，构建完整的媒体处理流程

## 配置说明
### 部署命令
```bash
docker create \
    --name sonarr \
    --restart unless-stopped \
    -p 8989:8989 \
    -e PUID=1001 -e PGID=1001 \
    -e TZ="Asia/Shanghai"  \
    -v <本地数据路径>:/config \
    -v <本地数据路径>/mp4_automator:/config_mp4_automator \
    -v <本地数据路径>:/movies \
    -v <本地数据路径>:/downloads \
    aront/sonarr
```
**说明**：替换`<本地数据路径>`为实际存储路径，建议将时区（TZ）设置为`Asia/Shanghai`适配国内环境。

### 配置文件准备
执行以下命令创建mp4自动化配置目录并下载示例配置：
```bash
mkdir <本地数据路径>/mp4_automator && \
wget https://raw.githubusercontent.com/mdhiggins/sickbeard_mp4_automator/master/autoProcess.ini.sample -O <本地数据路径>/mp4_automator/autoProcess.ini
```
用户可根据需求修改`autoProcess.ini`调整转换参数。

## 参数详情
完整参数说明请参考linuxserver/sonarr官方文档：[https://hub.docker.com/r/linuxserver/sonarr/](https://hub.docker.com/r/linuxserver/sonarr/)
