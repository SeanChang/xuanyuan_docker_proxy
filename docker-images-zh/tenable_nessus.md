---
image: tenable/nessus
description: "官方Nessus扫描器Docker镜像，用于部署Nessus漏洞扫描工具，支持指定Nessus版本和操作系统（Oracle或Ubuntu），可通过docker pull命令获取。"
source: https://xuanyuan.cloud/zh/r/tenable/nessus
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[tenable/nessus](https://xuanyuan.cloud/zh/r/tenable/nessus)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Nessus Scanner 官方镜像

## 概述
Nessus Scanner官方Docker镜像是由Tenable提供的容器化部署方案，用于便捷地在容器环境中部署Nessus漏洞扫描工具。该镜像支持指定Nessus版本和操作系统（Oracle或Ubuntu），便于用户根据需求选择适配的环境。

## 核心功能与特性
- **官方维护**：由Tenable官方提供和维护，确保镜像的安全性、稳定性及与Nessus版本的兼容性。
- **版本与系统灵活选择**：支持通过标签指定Nessus具体版本和操作系统（Oracle或Ubuntu），满足不同部署场景需求。
- **便捷获取**：可直接通过`docker pull`命令从Docker Hub获取，支持使用`latest`标签获取最新版本。

## 使用场景
- 需要在容器化环境（如Docker、Kubernetes）中快速部署Nessus扫描器的场景。
- 需灵活选择Nessus版本或操作系统的漏洞扫描任务部署。

## 使用方法与配置说明

### 获取镜像
使用`docker pull`命令从Docker Hub拉取镜像，命令格式如下：
```bash
$ docker pull tenable/nessus:<version-OS>
```
其中，`<version-OS>`为必填标签，需包含两部分信息：
- **版本**：Nessus的具体版本号（如`10.6.0`），或使用`latest`表示最新版本。
- **操作系统**：指定基础操作系统，支持`oracle`（Oracle Linux）或`ubuntu`（Ubuntu）。

**示例**：
- 拉取Ubuntu系统的Nessus 10.6.0版本：`docker pull tenable/nessus:10.6.0-ubuntu`
- 拉取Oracle Linux系统的最新Nessus版本：`docker pull tenable/nessus:latest-oracle`

### 部署与文档
- **部署指南**：[Nessus Docker镜像部署指南](https://docs.tenable.com/nessus/Content/DeployNessusDocker.htm)
- **官方文档**：[Nessus文档](https://docs.tenable.com/nessus/Content/GettingStarted.htm)

### 发布说明
- **发布说明**：[Nessus发布说明](https://docs.tenable.com/releasenotes/Content/nessus/nessus.htm)
