---
image: jlesage/handbrake
description: "这是一个用于HandBrake的Docker容器，其中HandBrake是一款开源视频转码工具，支持将DVD、蓝光及各类视频文件转换为MP4、MKV等主流格式，而Docker容器通过环境隔离特性确保转码环境稳定一致，无需复杂配置即可快速部署运行，适用于个人媒体处理、家庭服务器及企业级视频转码场景，帮助用户高效完成视频格式转换与压缩任务。"
source: https://xuanyuan.cloud/zh/r/jlesage/handbrake
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[jlesage/handbrake](https://xuanyuan.cloud/zh/r/jlesage/handbrake)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# HandBrake Docker容器

[![Release]([])]([])
[![Docker Image Size]([])]([])
[![Docker Pulls]([])]([])
[![Docker Stars]([])]([])
[![Build Status]([])]([])
[![Source]([])]([])
[![Donate]([])]([])


这是HandBrake的Docker容器化部署方案。应用的图形界面（GUI）可通过现代网页浏览器直接访问，无需在客户端安装任何软件或进行额外配置。同时支持全自动模式：将视频文件放入监控文件夹，HandBrake即可自动处理，全程无需人工干预。


## HandBrake简介  
HandBrake是一款视频转换工具，支持将几乎所有格式的视频文件转换为多种现代、广泛兼容的编码格式。


## 快速启动  

**注意**：  
以下Docker命令为示例，实际使用时需根据自身环境调整参数。

### 启动命令  
```shell
docker run -d \
    --name=handbrake \
    -p 5800:5800 \
    -v /docker/appdata/handbrake:/config:rw \
    -v /home/user:/storage:ro \
    -v /home/user/HandBrake/watch:/watch:rw \
    -v /home/user/HandBrake/output:/output:rw \
    jlesage/handbrake
```

### 参数说明  
- `-p 5800:5800`：映射容器内的5800端口到主机，用于访问Web GUI。  
- 挂载目录说明：  
  - `/docker/appdata/handbrake:/config:rw`：存储应用配置、运行状态、日志等需持久化的文件（必填）。  
  - `/home/user:/storage:ro`：主机文件访问路径（只读），容器内通过`/storage`目录访问主机此路径下的文件。  
  - `/home/user/HandBrake/watch:/watch:rw`：监控文件夹（读写），放入此目录的视频会自动触发转换。  
  - `/home/user/HandBrake/output:/output:rw`：输出目录（读写），转换后的文件会保存在这里。  

### 访问方式  
通过浏览器访问HandBrake图形界面：`[]  
主机文件在容器内可通过`/storage`目录查看和操作。


## 文档与支持  
- **完整文档**：[]  
- **问题反馈**：若使用中遇到问题，可[提交issue]([])  
- **更多Docker应用**：[]
