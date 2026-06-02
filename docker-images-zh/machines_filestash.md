---
image: machines/filestash
description: "Filestash 官方 Docker 镜像，用于通过 Web 界面管理 FTP、SFTP、S3、Dropbox 等多种协议与云服务的文件数据。"
source: https://xuanyuan.cloud/zh/r/machines/filestash
canonical: https://xuanyuan.cloud/zh/r/machines/filestash
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/machines/filestash" title="machines/filestash Docker 镜像中文简介、标签列表与拉取命令">machines/filestash — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/machines/filestash" title="machines/filestash Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/machines/filestash</a>

# Filestash Docker 镜像

## 概述
Filestash 是一款轻量级 Web 文件管理应用，作为统一的文件管理器，支持通过浏览器访问和管理多种协议与云服务中的数据，无需安装本地客户端，简化跨平台文件操作流程。

## 核心特性
- **多协议兼容**：支持 FTP、FTPS、SFTP、WebDAV 等传统文件传输协议，以及 Git、S3、LDAP 等服务集成。
- **云服务整合**：无缝对接 Dropbox、Google Drive、Backblaze B2、Minio 等主流云存储平台。
- **统一管理界面**：通过直观的 Web 界面集中管理不同来源文件，支持上传、下载、预览、编辑等操作。
- **容器化部署**：基于 Docker 镜像封装，支持快速启动与环境隔离，降低部署复杂度。

## 支持的协议与服务
Filestash 支持以下协议及服务的文件管理：
- 文件传输：FTP、FTPS、SFTP、WebDAV
- 版本控制：Git
- 对象存储：S3（AWS S3）、Minio、Backblaze B2
- 目录服务：LDAP
- 数据库：MySQL
- 日历与联系人：CardDAV、CalDAV
- 云存储：Dropbox、Google Drive

## Docker 部署示例

### 基本启动
通过以下命令启动容器，默认暴露端口 8334：
```bash
docker run -d -p 8334:8334 --name filestash mickael-kerjean/filestash
```
启动后访问 `http://localhost:8334` 进入 Web 管理界面。

### 数据持久化
挂载宿主机目录以保存配置与数据：
```bash
docker run -d -p 8334:8334 -v /宿主机路径:/app/data --name filestash mickael-kerjean/filestash
```
（替换 `/宿主机路径` 为实际存储目录）

### 自定义端口
如需使用非默认端口（如 8080），调整端口映射：
```bash
docker run -d -p 8080:8334 --name filestash mickael-kerjean/filestash
```
