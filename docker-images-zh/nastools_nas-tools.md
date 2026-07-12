---
image: nastools/nas-tools
description: "NAStools官方版本存档镜像，提供latest（官方最新版）、v3.2.2（最后公开版）、v2.9.1（最后未阉割版）等版本选择，支持NAS相关工具功能部署。"
source: https://xuanyuan.cloud/zh/r/nastools/nas-tools
canonical: https://xuanyuan.cloud/zh/r/nastools/nas-tools
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nastools/nas-tools" title="nastools/nas-tools Docker 镜像中文简介、标签列表与拉取命令">nastools/nas-tools 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NAStools Docker镜像文档

## 镜像概述

NAStools Docker镜像是官方项目文件的备份镜像，用于提供不同版本的NAStools工具部署。该镜像未对官方源码进行任何修改，旨在方便用户根据需求选择特定版本的NAStools进行安装和使用。

## 版本与分支说明

### 版本对应关系
- `latest`：对应官方最新版（不再公开源代码）
- `v3.2.2`：对应最后公开版
- `v2.9.1`：对应最后未阉割版

### 分支对应关系
- `v2`：对应版本 `v2.9.1`
- `v3`：对应版本 `v3.2.2`
- `master`：对应版本 `v3`

## 使用方法

### 基本使用流程
详细使用方法请参考官方项目文档：<https://github.com/NAStool/nas-tools>

### 镜像拉取示例
- 拉取最新版：
  ```bash
  docker pull docker.xuanyuan.run/nastools/nas-tools:latest
  ```
- 拉取v3.2.2版本：
  ```bash
  docker pull docker.xuanyuan.run/nastools/nas-tools:3.2.2
  ```
- 拉取v2.9.1版本：
  ```bash
  docker pull docker.xuanyuan.run/nastools/nas-tools:2.9.1
  ```

### 容器运行示例
Docker运行时需注意替换`REPO_URL`环境变量：
```bash
docker run -d \
  --name nas-tools \
  -e REPO_URL=https://github.com/wangyan/nas-tools.git \
  -v /path/to/config:/config \
  docker.xuanyuan.run/nastools/nas-tools:latest
```

## 重要说明

1. 本镜像是官方源码的备份，未做任何修改。
2. 如需安装`v2.9.1`版本，镜像标签应使用`nastools/nas-tools:2.9.1`（替换`jxxghp/nas-tools:latest`）。
3. 如需安装`v3.2.2`版本，镜像标签应使用`nastools/nas-tools:3.2.2`（替换`jxxghp/nas-tools:latest`）。
4. 通过Docker安装时，务必将`REPO_URL`环境变量设置为`https://github.com/wangyan/nas-tools.git`。

## 项目网址

- 源码地址：<https://github.com/wangyan/nas-tools>
- 镜像地址：<https://hub.docker.com/r/nastools/nas-tools>
