<!-- xuanyuan-docker-images-zh
image: linuxserver/code-server
source: https://xuanyuan.cloud/zh/r/linuxserver/code-server
canonical: https://xuanyuan.cloud/zh/r/linuxserver/code-server
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [linuxserver/code-server — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/code-server "linuxserver/code-server Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/linuxserver/code-server

# LinuxServer.io code-server 容器介绍  


## 关于 LinuxServer.io  

LinuxServer.io 团队推出的容器镜像具有以下特点：  
- 应用定期及时更新  
- 简化用户权限映射（通过 PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周更新基础系统，通过统一依赖层减少存储空间占用、 downtime 和带宽消耗  
- 定期安全更新  


## 什么是 code-server？  

[code-server]([]) 是一款可通过浏览器访问的远程 VS Code 服务，支持：  
- 在 Chromebook、平板、笔记本等设备上保持一致的开发环境  
- 方便 Windows/macOS 工作站开发 Linux 应用  
- 利用云服务器资源加速测试、编译和下载  
- 减少本地设备资源占用，延长续航  
- 所有计算任务在服务器端运行，避免本地 Chrome 实例冗余  


## 支持的架构  

镜像通过 Docker manifest 实现多平台支持，直接拉取 `lscr.io/linuxserver/code-server:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\>|  


## 应用设置  

### 基础访问  
通过 `http://<你的IP>:8443` 访问 web 界面。  

### GitHub 集成  
1. 将 SSH 密钥放入容器内 `/config/.ssh` 目录  
2. 在 code-server 终端中执行以下命令配置 Git 身份：  
   ```bash  
   git config --global user.name "你的用户名"  
   git config --global user.email "你的邮箱"  
   ```  

### 密码哈希设置  
如需使用哈希密码，可参考 [官方文档]([]) 生成。  


## 特殊运行模式  

### 只读文件系统  
本镜像支持以只读模式运行，需注意：  
- 必须将 `/tmp` 挂载为 tmpfs  
- 容器内无 `sudo` 权限  
详细配置见 [文档]([])。  

### 非 root 用户运行  
支持非 root 用户启动容器，需注意：  
- 容器内无 `sudo` 权限  
详细配置见 [文档]([])。  


## 使用方法  

### 前置说明  
以下参数中，未标注「可选」的为必填项，需提供具体值。  


### docker-compose（推荐）  

```yaml  
---  
services:  
  code-server:  
    image: lscr.io/linuxserver/code-server:latest  
    container_name: code-server  
    environment:  
      - PUID=1000                # 用户 ID（通过 `id 用户名` 查看）  
      - PGID=1000                # 组 ID（同上）  
      - TZ=Etc/UTC               # 时区（如 Asia/Shanghai）  
      - PASSWORD=password        # （可选）web 界面密码  
      - HASHED_PASSWORD=         # （可选）哈希密码（优先级高于 PASSWORD）  
      - SUDO_PASSWORD=password   # （可选）终端 sudo 密码  
      - SUDO_PASSWORD_HASH=      # （可选）sudo 哈希密码（优先级高于 SUDO_PASSWORD）  
      - PROXY_DOMAIN=code-server.my.domain  # （可选）子域名代理配置  
      - DEFAULT_WORKSPACE=/config/workspace  # （可选）默认工作目录  
      - PWA_APPNAME=code-server  # （可选）PWA 应用名称  
    volumes:  
      - /path/to/code-server/config:/config  # 配置文件存储路径  
    ports:  
      - 8443:8443                # 端口映射（主机:容器）  
    restart: unless-stopped  
```  


### docker cli  

```bash  
docker run -d \  
  --name=code-server \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -e PASSWORD=password `#可选` \  
  -e HASHED_PASSWORD= `#可选` \  
  -e SUDO_PASSWORD=password `#可选` \  
  -e SUDO_PASSWORD_HASH= `#可选` \  
  -e PROXY_DOMAIN=code-server.my.domain `#可选` \  
  -e DEFAULT_WORKSPACE=/config/workspace `#可选` \  
  -e PWA_APPNAME=code-server `#可选` \  
  -p 8443:8443 \  
  -v /path/to/code-server/config:/config \  
  --restart unless-stopped \  
  lscr.io/linuxserver/code-server:latest  
```  


## 参数说明  

| 参数                  | 说明                                                                 |  
|-----------------------|----------------------------------------------------------------------|  
| `-p 8443:8443`        | web 界面端口映射                                                    |  
| `-e PUID=1000`        | 用户 ID，用于解决权限问题（通过 `id 用户名` 获取）                   |  
| `-e PGID=1000`        | 组 ID，同上                                                          |  
| `-e TZ=Etc/UTC`       | 时区，例如 `Asia/Shanghai`                                          |  
| `-e PASSWORD`         | 可选，web 界面密码（未设置则无需认证）                              |  
| `-e HASHED_PASSWORD`  | 可选，哈希密码（覆盖 `PASSWORD`）                                   |  
| `-e SUDO_PASSWORD`    | 可选，终端 sudo 密码                                                 |  
| `-e SUDO_PASSWORD_HASH` | 可选，sudo 哈希密码（覆盖 `SUDO_PASSWORD`）                        |  
| `-e PROXY_DOMAIN`     | 可选，子域名代理配置，参考 [文档]([]) |  
| `-e DEFAULT_WORKSPACE` | 可选，默认打开的工作目录                                            |  
| `-e PWA_APPNAME`      | 可选，自定义 PWA 应用名称                                           |  
| `-v /config`          | 容器内配置文件目录，需映射到主机路径                                |  
| `--read-only=true`    | 启用只读文件系统模式                                                |  
| `--user=1000:1000`    | 以非 root 用户（PUID:PGID）运行容器                                  |  


## 环境变量文件（Docker Secrets）  

可通过 `FILE__` 前缀从文件加载环境变量，例如：  
```bash  
-e FILE__MYVAR=/run/secrets/mysecretvariable  
```  
容器会将 `/run/secrets/mysecretvariable` 文件内容作为 `MYVAR` 的值。  


## 用户/组 ID 说明  

使用 `-v` 挂载主机目录时，需确保目录所有者与容器内 PUID/PGID 一致，避免权限问题。通过以下命令获取当前用户的 UID/GID：  
```bash  
id 你的用户名  
```  


## 支持与维护  

### 容器操作  

- 进入容器终端：  
  ```bash  
  docker exec -it code-server /bin/bash  
  ```  

- 实时查看日志：  
  ```bash  
  docker logs -f code-server  
  ```  

- 查看容器版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' code-server  
  ```  

- 查看镜像版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/code-server:latest  
  ```  


### 更新容器  

#### 通过 docker-compose  
```bash  
# 更新镜像（全部或指定服务）  
docker-compose pull [code-server]  

# 重启容器（全部或指定服务）  
docker-compose up -d [code-server]  

# 清理旧镜像  
docker image prune  
```  

#### 通过 docker run  
```bash  
# 更新镜像  
docker pull lscr.io/linuxserver/code-server:latest  

# 停止并删除旧容器  
docker stop code-server && docker rm code-server  

# 重新创建容器（保持原参数即可保留配置）  
docker run -d [原参数] lscr.io/linuxserver/code-server:latest  
```  


## 本地构建  

如需自定义镜像，可按以下步骤构建：  
```bash  
git clone []  
cd docker-code-server  
docker build --no-cache --pull -t lscr.io/linuxserver/code-server:latest .  
```  

如需跨架构构建（如 x86 构建 arm 镜像），需先注册 qemu-static：  
```bash  
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset  
```  
然后使用对应架构的 Dockerfile（如 `-f Dockerfile.aarch64`）。  


## 版本历史  

- **10.08.25**：支持 IPv4/IPv6 双栈监听  
- **03.06.25**：新增 `PWA_APPNAME` 环境变量自定义 PWA 名称  
- **13.10.24**：优化权限检查逻辑，仅在首次安装或权限变更时更新 `/config` 所有权  
- **09.10.24**：按文件类型管理 `/config/.ssh` 目录权限  
- **19.08.24**：基于 Ubuntu Noble 重构  
- **01.07.23**：移除 armhf 架构支持  
- **29.09.22**：基于 Ubuntu Jammy 重构，切换至 s6v3，优化 `/config/workspace` 权限处理  
- **20.02.22**：通过官方 tarball 安装 code-server  
- **06.12.21**：新增 `DEFAULT_WORKSPACE` 环境变量  


## 社区支持  

- [博客]([])：容器使用指南、教程和观点  
- []()：实时社区交流与支持  
- [论坛]([])：社区问答平台  
- [GitHub]([])：源码仓库  
- [Open Collective]([])：支持项目发展（捐赠或贡献）
