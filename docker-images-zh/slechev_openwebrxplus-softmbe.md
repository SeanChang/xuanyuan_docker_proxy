---
image: slechev/openwebrxplus-softmbe
description: "OpenWebRX+镜像，集成SoftMBE数字解调功能，支持DMR、D-Star、YSF、FreeDV、DRM、NXDN等多种数字模式。"
source: https://xuanyuan.cloud/zh/r/slechev/openwebrxplus-softmbe
canonical: https://xuanyuan.cloud/zh/r/slechev/openwebrxplus-softmbe
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/slechev/openwebrxplus-softmbe" title="slechev/openwebrxplus-softmbe Docker 镜像中文简介、标签列表与拉取命令">slechev/openwebrxplus-softmbe 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenWebRX+（含SoftMBE数字解调）

## 镜像概述
本镜像基于openwebrxplus构建，额外集成了SoftMBE数字解调组件，扩展了对多种数字无线电模式的支持，适用于无线电信号的接收与解调。

## 核心功能和特性
- **多数字模式支持**：集成SoftMBE解调功能，可处理DMR、D-Star、YSF（Yaesu System Fusion）、FreeDV、DRM（数字无线电 mondiale）、NXDN等多种数字无线电模式
- **基于openwebrxplus**：保留openwebrxplus的原有功能和用户界面，确保基础无线电接收能力
- **增强数字信号处理**：通过SoftMBE组件提升数字信号的解调性能和兼容性

## 使用场景和适用范围
适用于无线电爱好者、业余无线电操作员及相关领域用户，用于接收、监测和解调各类数字无线电信号，满足信号分析、收听及实验需求。

## 使用方法和配置说明
### 基础使用指南
该镜像的详细使用方法（包括启动参数、配置项等）请参考基础镜像文档：  
[slechev/openwebrxplus Docker Hub](https://hub.docker.com/r/slechev/openwebrxplus)

### 镜像构建信息
镜像构建器源代码可通过以下GitHub仓库获取：  
[openwebrxplus-docker-builder](https://github.com/0xAF/openwebrxplus-docker-builder)
