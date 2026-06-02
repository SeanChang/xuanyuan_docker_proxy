---
image: library/centos
description: "已弃用；CentOS的官方版本，该版本此前作为基于红帽企业Linux（RHEL）源代码构建的社区企业级Linux发行版，以稳定、可靠的特性广泛应用于服务器及企业级应用场景，目前已停止官方维护与更新支持。"
source: https://xuanyuan.cloud/zh/r/library/centos
canonical: https://xuanyuan.cloud/zh/r/library/centos
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/centos" title="library/centos Docker 镜像中文简介、标签列表与拉取命令">library/centos — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/centos" title="library/centos Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/centos</a>

# CentOS Docker镜像说明


## 弃用通知  
该镜像的**所有标签均已停止支持（EOL）**。具体信息如下：  
- 官方EOL日期：2024年6月30日（参考[Red Hat公告]([])及[docker-library/official-images#17094]([])）。  
- 最后一次有效更新时间：2020年11月16日（早于EOL日期，详见[docker-library/official-images#9102]([])）。  
更多背景可查看[CentOS官方EOL说明]([])及[docker-library/docs#2205]([])。请用户根据实际需求调整使用。


## 快速参考  

### 基础信息  
- **维护方**：[CentOS项目]([])  
- **获取帮助**：[Docker社区Slack]([])、[Server Fault]([])、[Unix & Linux Stack Exchange]([])或[Stack Overflow]([])  
- **支持的标签**：无  
- **提交问题**：[CentOS Bug跟踪]([])或[GitHub Issues]([])  
- **支持的架构**：无  


### 镜像详情  
- **工件信息**：[repo-info仓库的`repos/centos/`目录]([])（含镜像元数据、传输大小等，[历史记录]([])）  
- **更新记录**：[official-images仓库`library/centos`标签]([])及[配置文件]([])（[历史记录]([])）  
- **本文档来源**：[docs仓库`centos/`目录]([])（[历史记录]([])）  


## CentOS简介  
CentOS Linux是社区支持的Linux发行版，基于Red Hat提供的Red Hat Enterprise Linux（RHEL）源代码构建，目标是与RHEL功能兼容。项目主要修改上游包以移除厂商品牌和 artwork，提供免费且可再分发的系统。  

每个CentOS Linux版本支持周期最长10年（通过安全更新，具体周期取决于Red Hat提供的源代码支持期限），约每2年发布新版本，每6个月更新以支持新硬件，提供安全、低维护、可靠的Linux环境。  

> 更多信息：[wiki.centos.org]([])  

![logo]([])  


## 镜像使用文档  

### 滚动构建（Rolling builds）  
CentOS项目为所有活跃版本提供定期更新的镜像，每月或紧急修复时更新。此类镜像以主版本号为标签，例如：  
```bash
docker pull centos:6  # CentOS 6
docker pull centos:7  # CentOS 7
```  


### 次要版本标签（Minor tags）  
次要版本标签（如`centos:5.11`、`centos:6.6`）对应特定安装介质，**不提供更新**。若使用此类镜像，建议在Dockerfile中运行以下命令以修复安全问题：  
```dockerfile
RUN yum -y update && yum clean all
```  


### Overlayfs与yum  
Docker 1.13+默认启用overlayfs存储后端（部分发行版）。在CentOS 6/7中使用overlayfs时，**需安装`yum-plugin-ovl`**，并确保`/etc/yum.conf`中`plugins=1`（默认已配置），否则可能出现rpmdb校验失败错误（详见[Docker #10180]([])）。  


## 包文档  
默认情况下，CentOS镜像通过`yum`的`nodocs`选项减小体积（移除文档文件）。若安装包后发现文件缺失，可修改`/etc/yum.conf`，注释掉`tsflags=nodocs`，然后重新安装包：  
```bash
# 编辑yum.conf，注释此行
# tsflags=nodocs
# 重新安装包
yum reinstall <package-name>
```  


## Systemd集成  
`centos:7`及`latest`镜像包含systemd，但默认不激活。如需使用systemd，需按以下步骤配置。  


### 构建systemd基础镜像  
创建基础镜像的Dockerfile：  
```dockerfile
FROM centos:7
ENV container docker
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
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
```  

构建镜像：  
```bash
docker build --rm -t local/c7-systemd .
```  


### 示例：带systemd的应用容器（以httpd为例）  
创建应用Dockerfile：  
```dockerfile
FROM local/c7-systemd
# 安装httpd并启用服务
RUN yum -y install httpd; yum clean all; systemctl enable httpd.service
EXPOSE 80
CMD ["/usr/sbin/init"]
```  

构建镜像：  
```bash
docker build --rm -t local/c7-systemd-httpd .
```  


### 运行systemd应用容器  
运行时需挂载主机的cgroups文件系统：  
```bash
docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 local/c7-systemd-httpd
```  

- **Ubuntu主机注意**：可能需额外挂载`/run`目录：  
  ```bash
  docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp/$(mktemp -d):/run -p 80:80 local/c7-systemd-httpd
  ```  


### vsyscall注意事项  
CentOS 6容器依赖`vsyscall`系统调用映射，部分Linux发行版默认禁用`vsyscall`（仅用`vdso`），可能导致容器退出（状态码139）。  

检查主机是否支持`vsyscall`：  
```bash
grep vsyscall /proc/self/maps
# 若输出无[vsyscall]行，需在启动项添加内核参数`vsyscall=emulated`（修改bootloader配置）
```  

参考：[LWN.net文章]([])  


## 许可信息  
- 镜像中软件许可：[CentOS许可信息]([])  
- 镜像可能包含其他软件（如Bash等），其许可信息可参考[repo-info仓库`centos/`目录]([])。  

使用前请确保遵守所有包含软件的许可协议。
