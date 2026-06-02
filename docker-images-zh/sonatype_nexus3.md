---
image: sonatype/nexus3
description: "Sonatype Nexus Repository 3是一款企业级仓库管理器，用于集中存储、管理和分发各类软件组件，支持Maven、npm、Docker、Helm等多种格式，可无缝整合CI/CD工具链，助力开发团队实现DevOps流程自动化，提升构建效率与组件交付速度，同时提供组件安全扫描与治理能力，是现代化软件开发中制品管理的核心解决方案。"
source: https://xuanyuan.cloud/zh/r/sonatype/nexus3
canonical: https://xuanyuan.cloud/zh/r/sonatype/nexus3
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sonatype/nexus3" title="sonatype/nexus3 Docker 镜像中文简介、标签列表与拉取命令">sonatype/nexus3 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Sonatype Nexus Repository 介绍


## 关于 Sonatype Nexus Repository  
Sonatype Nexus Repository 是所有内部及第三方二进制文件、组件和包的统一数据源。通过将开发工具集成到集中式二进制仓库管理器，可帮助团队筛选优质开源组件、优化构建性能，在提升软件开发生命周期（SDLC）可见性的同时加速代码交付。  


### Nexus Repository 社区版说明  
自 3.77.0 版本起，Nexus Repository 的免费版正式命名为 **Sonatype Nexus Repository 社区版**。  
社区版面向个人用户及小型团队，提供稳定的仓库管理能力。升级至 3.77.0 版本后，可解锁多项新功能，包括：支持原仅 Pro 版提供的格式、与 Kubernetes 等容器环境无缝集成等。社区版存在部分使用限制，详见[社区版文档]([])。  


## 运行 Nexus Repository  
### 启动容器  
通过以下命令启动容器，将 8081 端口映射至主机：  
```bash
docker run -d -p 8081:8081 --name nexus sonatype/nexus3
```

### 停止容器  
停止容器时需预留足够时间（数据库完全关闭），建议使用：  
```bash
docker stop --time=120 <容器名称>  # 例如容器名为"nexus"，则替换<容器名称>为"nexus"
```

### 测试服务  
容器启动后，可通过 curl 测试服务是否正常：  
```bash
curl [] 构建 Nexus Repository 镜像  
### 基础构建命令  
基于项目根目录下的 [Dockerfile]([]) 构建镜像：  
```bash
docker build --rm=true --tag=sonatype/nexus3 .
```

### 可选构建变量  
构建时可通过以下变量自定义：  
- `NEXUS_VERSION`：指定 Nexus Repository 版本  
- `NEXUS_DOWNLOAD_URL`：直接指定下载链接（替代 `NEXUS_VERSION`）  
- `NEXUS_DOWNLOAD_SHA256_HASH`：下载文件的 SHA256 校验和（使用前两个变量时必填）  


## 不同环境的 Docker 镜像  
### Red Hat 认证镜像  
通过 [Dockerfile.rh.ubi]([]) 构建，符合 Red Hat 认证标准，包含 Kubernetes/OpenShift 元数据、许可证目录及权限适配脚本。  
可从 [Red Hat 容器目录]([]) 获取，授权账户通过 `registry.connect.redhat.com` 拉取。

### 其他 Red Hat 衍生镜像  
- Red Hat Enterprise Linux 基础：[Dockerfile.rh.el]([])  
- CentOS 基础：[Dockerfile.rh.centos]([])  

### Alpine 轻量镜像  
通过 [Dockerfile.alpine.java11]([]) 构建，基于 Alpine Linux，依赖少、SBOM 清晰、安全性更高。  
Docker Hub 标签：  
- `sonatype/nexus3:3.XX.y-alpine`（默认 Java 11）  
- `sonatype/nexus3:3.XX.y-java11-alpine`  
- `sonatype/nexus3:3.XX.y-java17-alpine`  


## 持久化数据管理  
Nexus 数据（配置、日志、存储）存储于容器内 `/nexus-data` 目录，需通过以下方式持久化：  

### 方法 1：使用 Docker Volume（推荐）  
创建专用卷并挂载：  
```bash
docker volume create --name nexus-data  # 创建卷
docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3  # 启动时挂载
```

### 方法 2：挂载主机目录  
需确保目录权限正确（UID 200 可读写）：  
```bash
mkdir /some/dir/nexus-data && chown -R 200 /some/dir/nexus-data  # 准备目录
docker run -d -p 8081:8081 --name nexus -v /some/dir/nexus-data:/nexus-data sonatype/nexus3  # 挂载启动
```


## 注意事项  
1. **系统要求**：需满足 [官方系统要求]([])。  
2. **默认账户**：初始用户为 `admin`，密码存储于 `/nexus-data/admin.password` 文件（需通过持久化卷访问）。  
3. **启动时间**：新容器首次启动需 2-3 分钟，可通过日志确认状态：  
   ```bash
   docker logs -f nexus
   ```  
4. **安装路径**：Nexus 安装于容器内 `/opt/sonatype/nexus`。  
5. **环境变量配置**：  
   - `INSTALL4J_ADD_VM_PARAMS`：设置 JVM 参数（默认 `-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs`），例如：  
     ```bash
     docker run -d -p 8081:8081 --name nexus -e INSTALL4J_ADD_VM_PARAMS="-Xms1g -Xmx1g" sonatype/nexus3
     ```  
   - `NEXUS_CONTEXT`：设置访问上下文路径（默认 `/`），例如：  
     ```bash
     docker run -d -p 8081:8081 --name nexus -e NEXUS_CONTEXT=nexus sonatype/nexus3  # 访问路径为 []     ```  


## 获取帮助  
- **问题反馈**：社区版/核心版问题可在 [GitHub 仓库]([]) 提交。  
- **社区支持**：加入 [Sonatype 社区]([]) 获取用户经验分享。  
- **安全漏洞**：通过 [官方渠道]([]) 报告。  
- **Pro 用户**：联系 [Sonatype 支持团队]([])。  


## 许可证声明  
- Sonatype Nexus Repository Core 包含 Sencha Ext JS，遵循 FLOSS 例外条款，Sencha Ext JS 基于 GPL v3 许可，不可用于闭源软件分发。  
- 社区版使用受 [最终用户许可协议]([]) 约束。  
- 版权所有 © 2008-present Sonatype, Inc.
