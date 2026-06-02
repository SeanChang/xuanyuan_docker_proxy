---
image: talebook/calibre-webserver
description: "镜像已改名为talebook/talebook，这是一个美观的图书管理系统，支持推送Kindle、在线阅读、上传下载管理书籍，兼容群晖、威联通等X86系统Docker部署。"
source: https://xuanyuan.cloud/zh/r/talebook/calibre-webserver
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[talebook/calibre-webserver](https://xuanyuan.cloud/zh/r/talebook/calibre-webserver)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Talebook 图书管理系统镜像说明

## 镜像信息
原镜像已迁移，新镜像名称为 **talebook/talebook**，请通过 [Docker Hub](https://hub.docker.com/r/talebook/talebook) 获取最新版本。

## 主要特性
- 美观直观的图书管理界面
- 支持推送书籍至Kindle设备
- 提供在线阅读功能
- 支持书籍上传、下载与批量管理
- 兼容X86架构设备，如群晖、威联通等NAS系统

## 使用场景
适用于个人或家庭图书数字化管理，方便用户统一存储、查阅和同步电子书资源。

## Docker部署示例
```bash
docker run -d --name talebook \
  -p 8080:80 \
  -v /path/to/books:/data/books \
  -v /path/to/config:/data/config \
  --restart unless-stopped \
  talebook/talebook
```
*注：将`/path/to/books`和`/path/to/config`替换为本地实际路径，用于持久化存储书籍和配置数据。*
