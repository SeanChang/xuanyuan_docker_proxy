---
image: rclone/rclone
description: "Rclone是一款命令行程序，用于在不同云存储提供商之间同步文件和目录，被称为“云存储的rsync”。"
source: https://xuanyuan.cloud/zh/r/rclone/rclone
canonical: https://xuanyuan.cloud/zh/r/rclone/rclone
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rclone/rclone" title="rclone/rclone Docker 镜像中文简介、标签列表与拉取命令">rclone/rclone 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Rclone Docker镜像文档

## 概述

Rclone（“云存储的rsync”）是一款命令行程序，用于在不同云存储提供商之间同步文件和目录。它支持多种存储服务，提供安全、高效的数据同步解决方案，适用于命令行环境下的文件备份、迁移和一致性检查。

## 支持的存储提供商

Rclone支持以下存储服务（完整列表及特性请参见[存储提供商概述](https://rclone.org/overview/)）：

* 1Fichier [:page_facing_up:](https://rclone.org/fichier/)
* 阿里云对象存储服务（OSS）[:page_facing_up:](https://rclone.org/s3/#alibaba-oss)
* Amazon Drive [:page_facing_up:](https://rclone.org/amazonclouddrive/)（[状态说明](https://rclone.org/amazonclouddrive/#status)）
* Amazon S3 [:page_facing_up:](https://rclone.org/s3/)
* Backblaze B2 [:page_facing_up:](https://rclone.org/b2/)
* Box [:page_facing_up:](https://rclone.org/box/)
* Ceph [:page_facing_up:](https://rclone.org/s3/#ceph)
* Citrix ShareFile [:page_facing_up:](https://rclone.org/sharefile/)
* DigitalOcean Spaces [:page_facing_up:](https://rclone.org/s3/#digitalocean-spaces)
* Dreamhost [:page_facing_up:](https://rclone.org/s3/#dreamhost)
* Dropbox [:page_facing_up:](https://rclone.org/dropbox/)
* FTP [:page_facing_up:](https://rclone.org/ftp/)
* Google Cloud Storage [:page_facing_up:](https://rclone.org/googlecloudstorage/)
* Google Drive [:page_facing_up:](https://rclone.org/drive/)
* Google Photos [:page_facing_up:](https://rclone.org/googlephotos/)
* HTTP [:page_facing_up:](https://rclone.org/http/)
* Microsoft Azure Blob Storage [:page_facing_up:](https://rclone.org/azureblob/)
* Microsoft OneDrive [:page_facing_up:](https://rclone.org/onedrive/)
* SFTP [:page_facing_up:](https://rclone.org/sftp/)
* WebDAV [:page_facing_up:](https://rclone.org/webdav/)
* 本地文件系统 [:page_facing_up:](https://rclone.org/local/)
* 以及其他40+种存储服务...

## 核心功能特性

* **数据完整性保障**：支持MD5/SHA-1哈希检查，确保文件传输一致性
* **元数据保留**：同步过程中保持文件时间戳
* **灵活同步模式**：
  * [复制](https://rclone.org/commands/rclone_copy/)：仅复制新增/变更文件
  * [同步](https://rclone.org/commands/rclone_sync/)：单向同步使目标目录与源目录一致
  * [检查](https://rclone.org/commands/rclone_check/)：验证文件哈希一致性
* **跨存储同步**：直接在两个不同云存储账户间同步数据
* **高级功能**：
  * 大文件分块传输（[Chunker](https://rclone.org/chunker/)）
  * 数据加密保护（[Crypt](https://rclone.org/crypt/)）
  * 缓存加速访问（[Cache](https://rclone.org/cache/)）
  * FUSE挂载（[rclone mount](https://rclone.org/commands/rclone_mount/)）
* **性能优化**：多线程下载提升本地存储写入速度
* **服务能力**：通过HTTP/WebDav/FTP/SFTP/dlna等协议共享文件（[serve](https://rclone.org/commands/rclone_serve/)）

## 使用场景

* 多云存储间的数据备份与同步
* 云存储数据的本地备份与恢复
* 跨云平台的数据迁移与整合
* 命令行环境下的自动化文件同步任务
* 对云存储数据进行加密保护
* 将云存储挂载为本地文件系统使用
* 搭建轻量级文件共享服务

## 使用方法与配置

### 镜像拉取

```bash
docker pull docker.xuanyuan.run/rclone/rclone
```

### 配置远程存储

通过交互式命令配置远程存储信息（配置文件将保存在本地`~/.config/rclone`目录）：

```bash
docker run -it --rm -v ~/.config/rclone:/config/rclone docker.xuanyuan.run/rclone/rclone config
```

### 常用命令示例

#### 同步本地目录到远程存储

```bash
docker run -v ~/.config/rclone:/config/rclone -v /local/data:/data docker.xuanyuan.run/rclone/rclone sync /data myremote:backups
```

#### 从远程存储复制文件到本地

```bash
docker run -v ~/.config/rclone:/config/rclone -v /local/data:/data docker.xuanyuan.run/rclone/rclone copy myremote:documents /data
```

#### 检查本地与远程文件一致性

```bash
docker run -v ~/.config/rclone:/config/rclone -v /local/data:/data docker.xuanyuan.run/rclone/rclone check myremote:backups /data
```

#### 挂载远程存储为本地目录（需FUSE支持）

```bash
docker run --privileged -v ~/.config/rclone:/config/rclone -v /mnt/cloud:/cloud docker.xuanyuan.run/rclone/rclone mount myremote: /cloud
```

### 关键参数说明

* `-v ~/.config/rclone:/config/rclone`: 挂载配置目录，持久化存储远程配置
* `-v /local/path:/container/path`: 挂载本地数据目录，实现容器与主机文件交互
* `--privileged`: 挂载FUSE文件系统时需要的权限
* 更多命令参数可通过`docker run --rm rclone/rclone help`查看

## 文档与资源

* [官方网站](https://rclone.org)
* [完整文档](https://rclone.org/docs/)
* [变更日志](https://rclone.org/changelog/)
* [社区论坛](https://forum.rclone.org/)
* [下载地址](https://rclone.org/downloads/)

## 企业版镜像

我们与合作伙伴[SecureBuild](https://securebuild.com/blog/introducing-securebuild)合作提供企业级安全的rclone付费镜像，零CVEs漏洞。详情请查看[Rclone SecureBuild镜像](https://securebuild.com/images/rclone)。

## 许可证

Rclone基于MIT许可证开源，详情参见[COPYING文件](https://github.com/rclone/rclone/blob/master/COPYING)。
