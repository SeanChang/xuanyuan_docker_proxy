---
image: macrosan/kylin
description: "银河麒麟高级服务器操作系统V10是一款面向企业级服务器应用的国产操作系统，基于自主研发的Kylin软件源构建，整合了稳定高效的系统组件与安全增强机制，包含Kylin-V10-SP1/SP2/SP3（服务包1/2/3）等多个版本，通过持续迭代优化系统性能、兼容性及安全防护能力，为关键行业服务器环境提供可靠支撑。"
source: https://xuanyuan.cloud/zh/r/macrosan/kylin
canonical: https://xuanyuan.cloud/zh/r/macrosan/kylin
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/macrosan/kylin" title="macrosan/kylin Docker 镜像中文简介、标签列表与拉取命令">macrosan/kylin — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/macrosan/kylin" title="macrosan/kylin Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/macrosan/kylin</a>

# 银河麒麟高级服务器操作系统V10 Docker镜像介绍


## 简介  
本镜像为银河麒麟高级服务器操作系统V10的Docker镜像，基于麒麟官方软件源构建。  
- **维护者**：[MacroSAN-Tech/sys-docker-image]([])  
- **构建状态**：[![Publish Docker image]([])]([])  


## 支持的标签及对应Dockerfile  
以下为当前支持的镜像标签，均基于同一份Dockerfile构建：  
- [`v10-sp1`]([])  
- [`v10-sp2`]([])  
- [`v10-sp3`]([])  
- [`v10-sp3-2403`]([])  


## 支持的架构  
- `amd64`  
- `arm64`  


## 使用指南  

### 拉取特定架构镜像  
如需拉取指定架构的镜像（如amd64），命令如下：  
```console
$ docker pull --platform=linux/amd64 macrosan/kylin:v10-sp3
```

### 运行容器测试  
直接运行镜像进入交互式终端：  
```console
$ docker run -it macrosan/kylin:v10-sp3
```

### 基于镜像构建新镜像  
如需添加额外软件包，可编写Dockerfile如下：  
```dockerfile
FROM macrosan/kylin:v10-sp3
RUN yum install -y vi  # 示例：安装vi编辑器
```


## 镜像版本说明  

### macrosan/kylin:v10-sp3-2403  
```bash
bash-5.0# cat /etc/.productinfo
Kylin Linux Advanced Server
release V10 SP3 2403/(Halberd)-x86_64-Build20/20240426
bash-5.0# rpm -q kylin-release
kylin-release-10-24.6.p195.ky10.x86_64
```

### macrosan/kylin:v10-sp3  
```bash
bash-5.0# cat /etc/.productinfo 
Kylin Linux Advanced Server
release V10 (SP3) /(Lance)-x86_64-Build23/20230324
bash-5.0# rpm -q kylin-release
kylin-release-10-24.6.p150.ky10.x86_64
```

### macrosan/kylin:v10-sp2  
```bash
bash-5.0# cat /etc/.productinfo 
Kylin Linux Advanced Server
release V10 (SP2) /(Sword)-x86_64-Build09/20210524
bash-5.0# rpm -q kylin-release
kylin-release-10-24.6.p41.ky10.x86_64
```

### macrosan/kylin:v10-sp1  
```bash
bash-5.0# cat /etc/.productinfo 
Kylin Linux Advanced Server
release V10 (SP1) /(Tercel)-x86_64-Build20/20210518
bash-5.0# rpm -q kylin-release 
kylin-release-10-24.6.p37.ky10.x86_64
```
