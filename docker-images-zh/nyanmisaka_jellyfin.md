---
image: nyanmisaka/jellyfin
description: "nyanmisaka开发的Jellyfin 10.10.7开发版（发布日期2023年7月30日）是一款功能强大的开源媒体服务器软件，主要用于帮助用户集中管理、组织和流式传输本地媒体文件，涵盖视频、音频、图片等多种格式，作为开发版本，它可能集成了最新的技术更新、功能增强以及问题修复，致力于提升媒体库管理效率和跨设备播放的稳定性，为用户打造更优质、便捷的个人媒体中心体验。"
source: https://xuanyuan.cloud/zh/r/nyanmisaka/jellyfin
canonical: https://xuanyuan.cloud/zh/r/nyanmisaka/jellyfin
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nyanmisaka/jellyfin" title="nyanmisaka/jellyfin Docker 镜像中文简介、标签列表与拉取命令">nyanmisaka/jellyfin 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## nyanmisaka's Jellyfin 10.10.7 dev 版本介绍  


### 项目基本信息  
- **GitHub地址**：[[]]   
- **最新版本**：10.10.7 dev（更新日期：25/07/30）  


### 核心功能特性  
- **硬件支持**：主线Linux系统支持Intel DG1显卡（需内核6.13+/6.12.9+/6.6.70+/6.1.124+及force_probe参数）。  
- **编解码能力**：集成FFmpeg 7.0，支持多线程命令行；支持HEVC RExt格式4:2:2/4:4:4视频硬件解码；支持AV1硬件/软件编码。  
- **画质与渲染**：客户端渲染PGS字幕；硬件加速视频方向旋转；支持HDR10、HLG及DoVi视频的软件色调映射，GPU实现提供更高质量的色调映射模式。  
- **平台优化**：Rockchip平台TrickPlay功能支持MJPEG编码器；Windows系统支持Intel QSV VPP色调映射。  
- **自定义与性能**：可自定义转码视频编码格式；Intel低功耗编码（降低4K转码及色调映射开销，Gen11前仅支持LP H264）。  


### 历史优化点  
- 修复PGSSUB/DVDSUB图形字幕的显示比例问题。  
- 为Rockchip RK3588平台添加完整硬件加速管线（RKMPP/RGA）支持。  
- 升级Jellyfin-FFmpeg至6.0.1（需NVIDIA驱动520/522及以上）。  
- 优化Windows系统下Intel HDR色调映射性能；修复HLS.js播放fMP4的多项问题。  
- 支持Intel Arc显卡（Linux需内核6.2+）；AMD VAAPI配合RADV驱动支持Vulkan滤波。  
- 支持Chrome 104+浏览器播放HEVC（需开启可选 flags）；实现fMP4在桌面浏览器的播放支持。  
- 支持Dolby Vision Profile 5/8转SDR硬件色调映射；AMD/Intel/Nvidia全硬件滤波支持。  


### 分支说明  
- **latest-rockchip分支**：仅支持arm64架构，在Rockchip RK3588平台提供完整硬件加速管线（RKMPP/RGA）。  
- **latest分支**：依赖Jellyfin-FFmpeg 7.x及更新的Intel Compute-Runtime，支持AV1编码及未来硬件扩展。  


### Windows构建版本下载  
- Google Drive：[]()  
- 百度网盘：[[]] （提取码：q8we）  


### 硬件支持详情  

#### VA-API（Linux & Docker/LXC）  
| 硬件功能                | AMD RadeonSI (GCN+)               | Intel iHD (Broadwell+) | Intel i965 (CoffeLake-) |  
|-------------------------|-----------------------------------|------------------------|-------------------------|  
| H264 8bit解码           | ✔️                                | ✔️                     | ✔️                      |  
| H264 8bit编码           | ✔️                                | ✔️                     | ✔️                      |  
| H265 10bit解码          | ✔️（Polaris+）                    | ✔️（KabyLake+）        | ✔️（KabyLake+）         |  
| H265 8bit解码           | ✔️（Fury+）                       | ✔️（SkyLake+）         | ✔️（SkyLake+）          |  
| H265 8bit编码           | ✔️（Fury+）                       | ✔️（SkyLake+）         | ✔️（SkyLake+）          |  
| 缩放/调整尺寸           | ✔️                                | ✔️                     | ✔️                      |  
| 去隔行                  | ✔️                                | ✔️                     | ✔️                      |  
| 字幕烧录                | ❌                                | ✔️                     | ❌                      |  
| 字幕烧录（Vulkan）      | ✔️（Polaris+，内核≥5.15）         | ❌                     | ❌                      |  
| HDR色调映射（VPP）      | ❌                                | ✔️                     | ❌                      |  
| HDR/DV色调映射（OpenCL）| ✔️（Polaris-需PAL）               | ✔️                     | ✔️                      |  
| HDR/DV色调映射（Vulkan）| ✔️（Polaris+，内核≥5.15）         | ❌                     | ❌                      |  


#### Intel QSV（Linux & Docker/LXC & Windows）  
| 硬件功能                | Intel iHD驱动（Broadwell+）       | Intel Windows驱动       |  
|-------------------------|-----------------------------------|------------------------|  
| H264 8bit解码           | ✔️                                | ✔️                     |  
| H264 8bit编码           | ✔️                                | ✔️                     |  
| H265 10bit解码          | ✔️（7代/KabyLake+）               | ✔️（7代/KabyLake+）    |  
| H265 8bit解码           | ✔️（6代/SkyLake+）                | ✔️（6代/SkyLake+）     |  
| H265 8bit编码           | ✔️（6代/SkyLake+）                | ✔️（6代/SkyLake+）     |  
| 缩放/调整尺寸           | ✔️                                | ✔️                     |  
| 去隔行                  | ✔️                                | ✔️                     |  
| 字幕烧录                | ✔️                                | ✔️                     |  
| HDR色调映射（VPP）      | ✔️                                | ✔️（11代/TigerLake+）  |  
| HDR/DV色调映射（OpenCL）| ✔️                                | ✔️                     |  


#### NVIDIA NVENC（Linux & Docker/LXC & Windows）  
| 硬件功能                | NVIDIA驱动（Maxwell+）                                  |  
|-------------------------|---------------------------------------------------------|  
| H264 8bit解码           | ✔️（GM107/GM108/MX150~MX450除外）                       |  
| H264 8bit编码           | ✔️（GM107/GM108/MX150~MX450/GT1030除外）                 |  
| H265 10bit解码          | ✔️（Maxwell GM206/Pascal+）                             |  
| H265 8bit解码           | ✔️（Maxwell GM206/Pascal+）                             |  
| H265 8bit编码           | ✔️（2代Maxwell/Pascal+，MX150~MX450/GT1030除外）        |  
| 缩放/调整尺寸（CUDA）   | ✔️                                                      |  
| 去隔行（CUDA）          | ✔️                                                      |  
| 字幕烧录（CUDA）        | ✔️                                                      |  
| HDR/DV色调映射（CUDA）  | ✔️                                                      |  


#### AMD AMF（Windows 10/11）  
| 硬件功能                | AMD Adrenalin驱动（GCN+）         |  
|-------------------------|-----------------------------------|  
| H264 8bit解码           | ✔️                                |  
| H264 8bit编码           | ✔️                                |  
| H265 10bit解码          | ✔️（Polaris+）                    |  
| H265 8bit解码           | ✔️（Fury+）                       |  
| H265 8bit编码           | ✔️（Fury+）                       |  
| 缩放/调整尺寸（OpenCL） | ✔️                                |  
| 字幕烧录（OpenCL）      | ✔️                                |  
| HDR/DV色调映射（OpenCL）| ✔️                                |  


### 支持与捐赠  
你的支持是项目持续优化的动力！可通过支付宝扫描下方二维码捐赠：  

[![alipay] ]
