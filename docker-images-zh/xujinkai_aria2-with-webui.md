---
image: xujinkai/aria2-with-webui
description: "这是一个集成Aria2下载工具和WebUI界面的Docker镜像，体积仅29Mb，支持外部配置文件编辑和下载完成文件移动，方便用户通过网页管理下载任务。"
source: https://xuanyuan.cloud/zh/r/xujinkai/aria2-with-webui
canonical: https://xuanyuan.cloud/zh/r/xujinkai/aria2-with-webui
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/xujinkai/aria2-with-webui" title="xujinkai/aria2-with-webui Docker 镜像中文简介、标签列表与拉取命令">xujinkai/aria2-with-webui 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
这是一个集成了Aria2下载工具和WebUI界面的Docker镜像，体积仅29Mb，支持外部配置文件编辑和下载完成文件移动（注：多文件任务暂不支持移动）。该项目已无限期停止维护，建议用户Fork后自行修改使用。

## 核心功能
- 轻量级：镜像体积仅29Mb，资源占用低
- 外部配置：支持在镜像外编辑配置文件
- 文件管理：下载完成的单文件可自动移动到指定位置
- WebUI管理：通过网页界面（6880端口）管理下载任务
- 文件浏览：通过6888端口浏览下载目录

## 使用场景
- 个人用户搭建本地或远程下载服务
- 服务器端批量下载资源
- 需要通过网页界面便捷管理下载任务的场景

## 配置说明
### 部署命令
替换`/DOWNLOAD_DIR`（下载目录）、`/CONFIG_DIR`（配置目录）和`YOUR_SECRET_CODE`（安全密钥）后执行以下命令：
```bash
sudo docker run -d \
--name aria2-with-webui \
-p 6800:6800 \
-p 6880:80 \
-p 6888:8080 \
-v /DOWNLOAD_DIR:/data \
-v /CONFIG_DIR:/conf \
-e SECRET=YOUR_SECRET_CODE \
xujinkai/aria2-with-webui
```

### 访问方式
- 打开`http://服务器IP:6880/`使用Aria2 WebUI管理下载任务
- 打开`http://服务器IP:6888/`浏览下载文件目录

### 构建镜像
若需自定义构建，执行以下命令：
```bash
sudo docker build -f Dockerfile -t xujinkai/aria2-with-webui .
```

## 相关链接
- Aria2官方仓库：https://github.com/aria2/aria2
- WebUI仓库：https://github.com/ziahamza/webui-aria2
- 百度网盘导出工具：https://github.com/acgotaku/BaiduExporter
