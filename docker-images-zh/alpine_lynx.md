---
image: alpine/lynx
description: "LYNX是一款文本模式的网页浏览器，可在终端环境中浏览网页，支持交互式操作和文本导出功能，适用于无图形界面系统和终端网页访问需求。"
source: https://xuanyuan.cloud/zh/r/alpine/lynx
canonical: https://xuanyuan.cloud/zh/r/alpine/lynx
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/alpine/lynx" title="alpine/lynx Docker 镜像中文简介、标签列表与拉取命令">alpine/lynx 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LYNX 文本网页浏览器 Docker 镜像

## 镜像概述
基于Alpine Linux的LYNX文本网页浏览器镜像，提供轻量级的终端环境网页浏览工具。LYNX是一款经典的文本模式浏览器，无需图形界面即可在终端中浏览网页内容，适用于各类命令行环境和无图形界面系统。

## 核心功能与特性
- **文本模式浏览**：完全基于终端的文本界面，适合无图形环境使用
- **交互式操作**：支持键盘导航、链接跳转等交互式网页浏览功能
- **文本导出**：通过`-dump`选项可将网页内容导出为纯文本格式
- **轻量级设计**：基于Alpine Linux构建，镜像体积小，资源占用低

## 使用场景
- 终端环境或无图形界面系统（如服务器、嵌入式设备）中的网页浏览需求
- 需要以纯文本形式保存或分析网页内容的场景
- 自动化脚本中获取网页文本内容的任务
- 网络诊断或简单网页信息查询

## 使用方法与配置说明

### 快速启动
通过设置别名简化命令调用：
```bash
alias lynx="docker run -ti --rm alpine/lynx"
```

### 交互式浏览
运行交互式会话浏览网页：
```bash
lynx "www.google.com"
```
（使用键盘方向键导航，Enter键打开链接，Q键退出）

### 文本导出
将网页内容导出为纯文本：
```bash
lynx -dump "www.google.com"
```
（输出结果为网页的纯文本内容，可重定向至文件保存）

### 镜像标签
可从Docker Hub获取不同版本的镜像标签：  
https://hub.docker.com/repository/docker/alpine/lynx/tags

### Dockerfile 来源
镜像构建文件可参考：  
https://github.com/alpine-docker/multi-arch-libs/blob/master/lynx/Dockerfile

## 官方文档
更多使用细节和功能说明，请参考官方文档：  
- https://lynx.browser.org/  
- https://lynx.invisible-island.net/release/lynx_help/lynx_help_main.html
