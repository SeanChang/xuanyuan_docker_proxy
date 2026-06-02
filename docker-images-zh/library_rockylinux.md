---
image: library/rockylinux
description: "Rocky Linux 的官方版本是由 CentOS 创始人之一 Gregory Kurtzer 发起的企业级 Linux 发行版，旨在作为 CentOS 停更后的替代方案，与 Red Hat Enterprise Linux（RHEL）完全兼容，提供稳定可靠的操作系统环境，支持长期维护，广泛适用于服务器部署及各类企业级应用场景，延续了 CentOS 社区对开源稳定系统的需求满足。"
source: https://xuanyuan.cloud/zh/r/library/rockylinux
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[library/rockylinux](https://xuanyuan.cloud/zh/r/library/rockylinux)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Rocky Linux Docker 镜像说明


## 重要提示  
Docker 团队负责管理官方镜像项目，目前因技术限制，Rocky Linux 无法通过该渠道发布更新。如需获取最新容器镜像，请暂时参考 [Rocky Linux Docker Hub 仓库]([])。


## 快速参考  

### 维护者  
[Rocky 企业软件基金会]([])  


### 获取帮助  
可通过以下渠道获取帮助：  
- [Docker 社区 Slack]([])  
- [Server Fault]([])  
- [Unix & Linux]([])  
- [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  
以下为当前支持的镜像标签及对应的 Dockerfile 源码链接：  

- [`9.3.20231119`, `9.3`, `9`]([])  
- [`9.3.20231119-minimal`, `9.3-minimal`, `9-minimal`]([])  
- [`8.9.20231119`, `8.9`, `8`]([])  
- [`8.9.20231119-minimal`, `8.9-minimal`, `8-minimal`]([])  


## 快速参考（续）  

### 提交问题  
如需反馈问题，可通过以下途径：  
- [Rocky Linux 缺陷跟踪系统]([])  
- [GitHub 仓库]([])  


### 支持的架构  
（架构相关说明可参考 [更多信息]([])）  
- [`amd64`]([])  
- [`arm64v8`]([])  
- [`ppc64le`]([])  
- [`s390x`]([])  


### 发布镜像制品详情  
镜像元数据、传输大小等信息可查看：  
[repo-info 仓库的 `repos/rockylinux/` 目录]([])（[更新历史]([])）  


### 镜像更新  
- 镜像更新跟踪：[official-images 仓库的 `library/rockylinux` 标签]([])  
- 镜像定义文件：[official-images 仓库的 `library/rockylinux` 文件]([])（[更新历史]([])）  


### 本文档来源  
本文档内容源自 [docs 仓库的 `rockylinux/` 目录]([])（[更新历史]([])）  


## Rocky Linux 简介  
Rocky Linux 是一款社区支持的 Linux 发行版，基于 Red Hat 为 Red Hat Enterprise Linux (RHEL) 公开提供的源代码构建（源码获取：[Red Hat 官方 FTP](ftp://ftp.redhat.com/pub/redhat/linux/enterprise/)）。其目标是与 RHEL 功能兼容，主要修改仅为移除上游供应商的品牌标识和图标。  

Rocky Linux 免费且可自由分发，每个版本提供长达 10 年的安全更新支持（具体支持周期取决于 Red Hat 发布的源码支持期限）。新版本约每 2 年发布一次，每个版本会定期（约每 6 个月）更新以支持新硬件，最终提供安全、低维护、可靠、可预测且可复现的 Linux 环境。  

欢迎使用 Rocky Linux！社区感谢您的反馈，也期待您的加入：  
- IRC 频道：Libera.chat 的 `#rockylinux` 频道  
- Mattermost 社区：[]  

更多资源：  
- [docs.rockylinux.org]([])  
- [wiki.rockylinux.org]([])  

![logo]([])  


## Rocky Linux 镜像使用说明  

### 关于 `latest` 标签  
**`rockylinux:latest` 标签不存在**。请选择主版本标签（当前为 8 或 9）或更具体的标签，例如 `rockylinux:8` 或 `rockylinux:9`，以确保拉取目标版本。  


### Minimal 变体  
除基础镜像外，还提供 Minimal 精简版镜像，包含 microdnf 包管理器和更少的依赖。使用时需指定 `-minimal` 标签，例如 `rockylinux:9-minimal`。  


### 滚动构建  
Rocky Linux 为所有活跃版本提供定期更新的镜像，每月更新一次（紧急修复时会额外更新）。此类更新通过主版本标签推送，例如 `docker pull rockylinux:8`。  


### 次要版本标签  
同时提供与安装介质对应的次要版本标签（如 `8.4`），**但这些镜像不会自动更新**。若使用次要版本标签，建议在 Dockerfile 中添加更新命令以确保安全性：  
```dockerfile
RUN yum -y update && yum clean all
```  


## 包文档说明  
默认情况下，Rocky Linux 容器镜像通过 yum 的 `nodocs` 选项构建，以减小镜像体积。若安装软件包后发现文件缺失，可注释掉 `/etc/yum.conf` 中的 `tsflags=nodocs` 行，然后重新安装该包。  


## 许可证  
- 镜像中软件的许可证信息：[Rocky Linux 官方许可页面]([])  
- 自动检测的额外许可证信息：[repo-info 仓库的 `rockylinux/` 目录]([])  

使用预构建镜像时，用户需自行确保对镜像中所有软件的使用符合相关许可证要求。
