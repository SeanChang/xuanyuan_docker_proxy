---
image: season/fastdfs
description: "FastDFS是一个开源高性能分布式文件系统，提供文件存储、同步和访问功能，可解决高容量和负载均衡问题，适用于照片分享、视频分享等基于文件服务的网站。"
source: https://xuanyuan.cloud/zh/r/season/fastdfs
canonical: https://xuanyuan.cloud/zh/r/season/fastdfs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/season/fastdfs" title="season/fastdfs Docker 镜像中文简介、标签列表与拉取命令">season/fastdfs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FastDFS Docker镜像文档

## 镜像概述和主要用途

FastDFS是一个开源高性能分布式文件系统，主要功能包括文件存储、文件同步和文件访问（文件上传与下载），能够有效解决高容量存储和负载均衡问题。该镜像适用于搭建基于文件服务的网站，如照片分享网站、视频分享网站等场景。

项目地址：[https://github.com/happyfish100/fastdfs](https://github.com/happyfish100/fastdfs)

## 核心功能和特性

- **分布式存储**：支持大规模文件存储，解决单节点存储容量限制
- **文件同步**：实现多节点间的文件自动同步，保证数据一致性
- **负载均衡**：通过tracker节点实现存储节点的负载均衡
- **文件访问**：提供高效的文件上传和下载功能
- **日志集成**：日志重定向至容器stdout，便于日志收集和管理

## 使用场景和适用范围

- 照片分享网站的图片存储与访问
- 视频分享平台的视频文件管理
- 需要大规模文件存储和访问的企业应用
- 对文件存储性能和可靠性有较高要求的场景

## 使用方法和配置说明

### 1. 作为Tracker节点运行

Tracker节点负责调度和负载均衡，运行命令如下：

```bash
docker run -ti -d --name tracker -v ~/tracker_data:/fastdfs/tracker/data --net=host docker.xuanyuan.run/season/fastdfs tracker
```

**参数说明**：
- **端口**：Tracker默认端口为22122
- **数据持久化**：需将容器内路径`/fastdfs/tracker/data`映射到宿主机目录（如示例中的`~/tracker_data`），以保持数据持久化

### 2. 作为Storage节点运行

Storage节点负责实际文件存储，运行命令如下：

```bash
docker run -ti --name storage -v ~/storage_data:/fastdfs/storage/data -v ~/store_path:/fastdfs/store_path --net=host -e TRACKER_SERVER=192.168.1.2:22122 docker.xuanyuan.run/season/fastdfs storage
```

**参数说明**：
- **storage_data**：对应`store.conf`中的`base_path`，用于存储Storage节点的基础数据，需映射宿主机目录（如示例中的`~/storage_data`）
- **store_path**：对应`store.conf`中的`store_path0`，用于实际存储文件，需映射宿主机目录（如示例中的`~/store_path`）
- **TRACKER_SERVER**：环境变量，指定Tracker节点地址（格式：`IP:端口`）

### 3. 进入容器Shell

如需使用FastDFS客户端工具，可通过以下命令进入容器Shell：

```bash
docker run -ti --name fdfs_sh --net=host docker.xuanyuan.run/season/fastdfs sh
```

## 日志管理

FastDFS的日志文件已重定向至容器的stdout，可通过`docker logs`命令方便地查看和收集日志：

```bash
docker logs [容器名称/ID]
```

## 配置文件

FastDFS的配置文件位于容器内路径：`/fdfs_conf`，可通过挂载自定义配置文件覆盖默认配置。
