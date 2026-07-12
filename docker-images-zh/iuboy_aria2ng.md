---
image: iuboy/aria2ng
description: "ariaNG Docker镜像，仅包含Aria2的Web前端管理界面，不包含aria2程序，用于通过浏览器管理Aria2下载任务。"
source: https://xuanyuan.cloud/zh/r/iuboy/aria2ng
canonical: https://xuanyuan.cloud/zh/r/iuboy/aria2ng
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/iuboy/aria2ng" title="iuboy/aria2ng Docker 镜像中文简介、标签列表与拉取命令">iuboy/aria2ng 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ariaNG Docker镜像

## 镜像概述

本镜像仅包含ariaNG，不包含aria2程序。ariaNG是Aria2的Web前端管理界面，提供直观的图形化操作界面，方便用户通过浏览器管理Aria2下载任务。

项目GitHub地址：[https://github.com/mayswind/AriaNg](https://github.com/mayswind/AriaNg)

## 核心功能与特性

- 提供Web图形化界面，用于管理Aria2下载任务
- 支持下载任务的添加、暂停、继续、删除等操作
- 简洁易用的用户界面，降低Aria2使用门槛
- 轻量级部署，资源占用低

## 使用场景

适用于需要通过Web浏览器管理Aria2下载任务的用户，需配合独立部署的aria2服务使用。

## 使用方法

### 基本部署

使用以下命令启动容器，将"yourport"替换为实际需要映射的主机端口：

```bash
docker run -d \
--restart=always \
--name aria2ng \
-p yourport:8080 \
docker.xuanyuan.run/iuboy/aria2ng:latest
```

### 访问方式

容器启动后，通过浏览器访问以下地址即可打开ariaNG界面：
`http://服务器IP:yourport/`

> 注意：使用前需确保已部署并运行aria2服务，并在ariaNG界面中正确配置aria2连接信息。
