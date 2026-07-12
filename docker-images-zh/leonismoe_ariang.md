---
image: leonismoe/ariang
description: "现代Web前端界面，简化aria2下载工具的使用，纯HTML和JavaScript编写，支持响应式布局，适配桌面与移动设备。"
source: https://xuanyuan.cloud/zh/r/leonismoe/ariang
canonical: https://xuanyuan.cloud/zh/r/leonismoe/ariang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/leonismoe/ariang" title="leonismoe/ariang Docker 镜像中文简介、标签列表与拉取命令">leonismoe/ariang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# AriaNg

## 镜像概述

AriaNg是aria2的现代Web前端界面，旨在简化aria2下载工具的使用。它采用纯HTML和JavaScript编写，无需任何编译器或运行时环境，只需将其部署到Web服务器中，即可通过浏览器访问使用。AriaNg采用响应式布局设计，支持各种桌面和移动设备，提供直观的下载任务管理体验。

## 核心功能与特性

1. **纯HTML和JavaScript实现**：无需运行时环境，直接部署即可使用
2. **响应式设计**：完美适配桌面端和移动设备
3. **用户友好的界面**
   - 任务排序（按名称、大小、进度、剩余时间、下载速度等）、文件排序、BitTorrent对等节点排序
   - 任务搜索功能
   - 任务重试机制
   - 拖拽调整任务顺序
   - 丰富的任务信息展示（健康百分比、BT对等节点客户端信息等）
   - 按文件类型（视频、音频、图片、文档、应用程序、压缩包等）或扩展名筛选文件
   - 多目录任务的树形视图展示
   - aria2全局或单个任务的下载/上传速度图表
   - 全面支持aria2的各项设置
4. 深色主题支持
5. URL命令行API支持
6. 下载完成通知功能
7. 多语言支持
8. 多aria2 RPC主机管理
9. 设置导出与导入功能
10. 低带宽占用：仅请求增量数据

## 使用场景

适用于需要通过浏览器管理aria2下载任务的个人用户或小型团队，可在桌面电脑、笔记本或移动设备上便捷地监控和管理下载任务，尤其适合需要远程管理下载进程或多设备访问的场景。

## 使用方法

### Docker快速部署

使用以下命令启动AriaNg容器，将容器的8080端口映射到主机的8080端口：

```sh
docker run -d --name ariang --restart=unless-stopped -p 8080:8080 docker.xuanyuan.run/leonismoe/ariang
```

启动成功后，通过浏览器访问 `http://<主机IP>:8080` 即可打开AriaNg界面，开始管理aria2下载任务。

## 界面截图

### 桌面设备

![AriaNg桌面界面](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/desktop.png)

### 移动设备

![AriaNg移动界面](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/mobile.png)

## 小型HTTP服务器参考

- https://www.reddit.com/r/docker/comments/57tbbw/challenge_rdocker_create_the_smallest_http_server/
- https://github.com/sseemayer/mini-helloworld-httpd
- https://github.com/piccaso/docker-asmttpd
- https://blog.netherlabs.nl/articles/2009/01/18/the-ultimate-so_linger-page-or-why-is-my-tcp-not-reliable
