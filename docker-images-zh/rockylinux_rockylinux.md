---
image: rockylinux/rockylinux
description: "社区支持的Linux发行版，基于Red Hat提供的RHEL源代码构建，功能兼容RHEL，移除上游厂商品牌与图标，免费可再分发，每个版本提供长达10年维护。"
source: https://xuanyuan.cloud/zh/r/rockylinux/rockylinux
canonical: https://xuanyuan.cloud/zh/r/rockylinux/rockylinux
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rockylinux/rockylinux" title="rockylinux/rockylinux Docker 镜像中文简介、标签列表与拉取命令">rockylinux/rockylinux — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rockylinux/rockylinux" title="rockylinux/rockylinux Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rockylinux/rockylinux</a>

# Rocky Linux Docker镜像文档

![Rocky Linux Logo](https://raw.githubusercontent.com/rocky-linux/branding/main/logo/out/logo-bg_transparent-primary_black-128x.png)

## 1. 镜像概述和主要用途

Rocky Linux是一款社区支持的Linux发行版，其源代码来源于Red Hat公开提供的Red Hat Enterprise Linux (RHEL)源码。该发行版旨在与RHEL功能兼容，主要修改上游供应商的品牌标识和artwork，保持无成本且可自由再分发。每个Rocky Linux版本提供长达10年的安全更新支持（支持周期基于Red Hat发布的源码支持期限），约每2年发布一个新版本，每6个月进行周期性更新以支持新硬件，提供安全、低维护、可靠、可预测且可重现的Linux环境。

Rocky Linux Docker镜像作为轻量级容器化部署基础，适用于构建企业级应用运行环境、开发测试平台及CI/CD流水线等场景，提供与RHEL兼容的容器化系统环境。

## 2. 核心功能和特性

### 2.1 多标签版本策略
- **`latest`标签**：`rockylinux/rockylinux:latest`始终指向当前最新可用版本。
- **滚动构建（Rolling builds）**：为所有活跃版本提供定期更新镜像，每月更新或紧急修复时更新，标签仅包含主版本号（如`rockylinux/rockylinux:8`）。
- **次要版本标签（Minor tags）**：对应安装介质的镜像，标签包含次要版本号（如`rockylinux/rockylinux:8.4`）。**这些镜像不接收更新**，旨在匹配安装ISO内容，使用时需手动处理安全更新。

### 2.2 优化的镜像体积
默认使用`yum`的`nodocs`选项构建，移除文档文件以减小镜像体积。如需完整文档，可通过配置调整（详见4.2节）。

### 2.3 Systemd支持
基础镜像包含Systemd但默认未激活，可通过特定配置启用，支持容器内服务管理（详见4.3节）。

## 3. 使用场景和适用范围
- **企业级应用基础镜像**：需稳定、安全且与RHEL兼容的生产环境。
- **开发测试环境**：提供一致的系统环境，减少环境差异导致的问题。
- **CI/CD流水线**：作为构建或运行阶段的基础镜像，支持滚动更新以保持安全性。
- **依赖Systemd的服务部署**：通过配置可在容器中运行依赖Systemd管理的服务。

## 4. 详细的使用方法和配置说明

### 4.1 镜像拉取

#### 4.1.1 最新版本
```bash
docker pull rockylinux/rockylinux:latest
```

#### 4.1.2 滚动构建版本（主版本标签）
```bash
docker pull rockylinux/rockylinux:8  # 拉取Rocky Linux 8的滚动更新版本
```

#### 4.1.3 次要版本标签（不自动更新）
```bash
docker pull rockylinux/rockylinux:8.4  # 拉取8.4版本，需手动更新
```

> **注意**：使用次要版本标签时，建议在Dockerfile中添加以下命令以处理安全更新：
> ```dockerfile
> RUN yum -y update && yum clean all
> ```

### 4.2 包文档配置
默认镜像因`nodocs`选项移除了文档文件，如需获取完整文档：

1. 修改`/etc/yum.conf`，注释`tsflags=nodocs`行：
   ```bash
   sed -i 's/^tsflags=nodocs/#tsflags=nodocs/' /etc/yum.conf
   ```

2. 重新安装所需包：
   ```bash
   yum -y reinstall <package-name> && yum clean all
   ```

### 4.3 Systemd集成

#### 4.3.1 构建Systemd基础镜像
创建包含Systemd的基础镜像Dockerfile：

```dockerfile
FROM rockylinux/rockylinux:8.4
ENV container docker  # 设置容器环境变量
# 清理不必要的systemd单元文件
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]  # 挂载cgroup文件系统
CMD ["/usr/sbin/init"]  # 启动systemd
```

构建镜像：
```bash
docker build --rm -t local/r8-systemd .
```

#### 4.3.2 构建Systemd应用镜像（以httpd为例）
创建包含httpd服务的Dockerfile：

```dockerfile
FROM local/r8-systemd
RUN yum -y install httpd; yum clean all; systemctl enable httpd.service  # 安装httpd并设置开机启动
EXPOSE 80  # 暴露80端口
CMD ["/usr/sbin/init"]
```

构建镜像：
```bash
docker build --rm -t local/r8-systemd-httpd .
```

#### 4.3.3 运行Systemd应用容器
需挂载主机cgroup卷以支持systemd运行：

```bash
docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 local/r8-systemd-httpd
```

> **注意**：若主机为Ubuntu系统，需额外挂载`/run`目录：
> ```bash
> docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp/$(mktemp -d):/run -p 80:80 local/r8-systemd-httpd
> ```

## 5. 社区资源
- [Rocky Linux官方文档](https://docs.rockylinux.org)
- [Rocky Linux维基](https://wiki.rockylinux.org)
- IRC：Libera.chat #rockylinux频道
- Mattermost：[https://chat.rockylinux.org](https://chat.rockylinux.org)
