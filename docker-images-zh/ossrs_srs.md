---
image: ossrs/srs
description: "SRS（Simple Realtime Server）是一款开源实时音视频服务器，支持RTMP、HLS、WebRTC等多种音视频传输协议，广泛应用于直播、实时互动、在线教育及视频会议等场景；Docker作为轻量级容器化平台，具备快速部署、环境隔离及跨平台运行能力，在Docker中运行SRS可有效简化音视频服务配置流程，降低环境依赖问题，提升开发与运维效率，满足各类实时音视频应用的部署需求。"
source: https://xuanyuan.cloud/zh/r/ossrs/srs
canonical: https://xuanyuan.cloud/zh/r/ossrs/srs
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ossrs/srs" title="ossrs/srs Docker 镜像中文简介、标签列表与拉取命令">ossrs/srs — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ossrs/srs" title="ossrs/srs Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ossrs/srs</a>

## SRS Docker镜像介绍  


### 关于SRS  
SRS（Simple Realtime Server）是一款轻量、高效的流媒体服务器，支持直播、点播、WebRTC等多种流媒体场景，广泛用于视频直播、在线教育、视频会议等领域。  


### 镜像用途  
这个Docker镜像封装了SRS的运行环境，旨在简化SRS的部署流程。通过Docker容器，你无需手动配置依赖环境（如Nginx、FFmpeg等），直接拉取镜像即可快速启动SRS服务，适合开发测试或生产环境使用。  


### 使用指引  
使用前请务必阅读官方详细使用指南（[点击查看]([])），指南中包含镜像拉取、容器启动参数、配置文件挂载、端口映射等关键操作步骤，可帮你避免部署中的常见问题（如端口冲突、配置错误等）。  


### 为什么用Docker镜像？  
- **环境一致性**：容器化部署确保不同环境（开发/测试/生产）的运行配置一致，减少“本地能跑，线上不行”的问题。  
- **快速启停**：通过Docker命令即可启动或停止SRS服务，无需手动安装、编译依赖。  
- **资源隔离**：容器独立运行，不会影响主机其他服务，也避免主机环境被修改。  


如需部署SRS，直接基于此镜像操作即可，具体步骤以官方使用指南为准。
