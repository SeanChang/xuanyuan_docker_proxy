---
image: talebook/talebook
description: "这是一款美观的图书管理系统，具备推送至Kindle、在线阅读、书籍上传、下载及管理等功能，同时支持群晖、威联通等所有X86架构系统的Docker部署。"
source: https://xuanyuan.cloud/zh/r/talebook/talebook
canonical: https://xuanyuan.cloud/zh/r/talebook/talebook
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/talebook/talebook" title="talebook/talebook Docker 镜像中文简介、标签列表与拉取命令">talebook/talebook — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/talebook/talebook" title="talebook/talebook Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/talebook/talebook</a>

# 基于Calibre + Vue的在线图书管理系统  


## 项目简介  
这是一个基于Calibre和Vue开发的在线图书管理系统，主打简洁易用的界面和实用功能，支持在线阅读。  
演示网站：[[]]([])  


## 主要特点  
### 界面与体验优化  
- **美观跨端界面**：替换Calibre自带的简陋网页界面，基于Vue开发全新UI，适配PC和手机浏览。  
- **多用户支持**：支持QQ、微博、Github等社交账号登录（原豆瓣登录已废弃）。  

### 核心功能  
- **在线阅读**：集成[Readium.js]([])库，直接在网页端阅读电子书。  
- **Kindle推送**：支持邮件推送功能，方便将书籍发送到Kindle设备。  
- **OPDS协议**：兼容KyBooks等阅读APP，可通过APP访问书库。  

### 管理与配置  
- **快速部署**：支持一键安装和网页端初始化配置，新手也能轻松启动。  
- **书库优化**：大书库场景下，支持按字母分类存放文件，或保留中文文件名。  
- **信息更新**：可从百度百科、豆瓣搜索并导入书籍基础信息（如作者、简介等）。  
- **私人模式**：需输入访问码才能进入网站，适合小圈子分享使用。  

> **重要提醒**：根据中国法律法规，个人不得私自搭建公开在线出版网站，维护公开书籍分享站点属于违法违规行为。  


## 部署方式  
### Docker部署（推荐）  
项目提供Docker镜像，部署简单快捷：  
- 镜像地址：[Docker Hub]([])  
- 执行命令（替换`<本机端口>`和`<本机data目录>`）：  
  ```bash  
  docker run -d --name calibre -p <本机端口>:80 -v <本机data目录>:/data talebook/calibre-webserver  
  ```  
- 示例（端口8080，数据目录`/data/calibre`）：  
  ```bash  
  docker run -d --name calibre -p 8080:80 -v /data/calibre:/data talebook/calibre-webserver  
  ```  

### 手动安装  
详见文档：[安装文档](document/INSTALL.zh_CN.md)  


## 致谢与资源  
- **特别感谢**：感谢oldiy制作第一版Docker镜像及教程。  
- **相关资源**：  
  - 群晖安装教程：[[]]([])  
  - 讨论组：[加入]()  
  - 演示地址：[Demo]([])  
  - 网友案例：[夜读客]([])、[文渊阁]([])、[网友站点]([])  

- 项目演示截图：  
  ![项目截图]([])  


（项目曾用名：calibre-webserver）
