<!-- xuanyuan-docker-images-zh
image: linuxserver/heimdall
source: https://xuanyuan.cloud/zh/r/linuxserver/heimdall
canonical: https://xuanyuan.cloud/zh/r/linuxserver/heimdall
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [linuxserver/heimdall — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/heimdall "linuxserver/heimdall Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/linuxserver/heimdall

# LinuxServer.io 容器介绍：Heimdall


## LinuxServer.io 团队简介  
[LinuxServer.io]([]) 团队专注于提供高质量 Docker 容器，其容器具有以下特点：  
- 定期、及时的应用更新  
- 便捷的用户权限映射（通过 PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周基础系统更新，通过跨生态通用层减少存储空间占用、 downtime 及带宽消耗  
- 定期安全更新  


### 社区与支持渠道  
- [博客]([])：容器使用指南、教程及技术观点  
- []()：实时社区交流与团队支持  
- [Discourse]([])：社区论坛  
- [GitHub]([])：所有代码仓库源码  
- [Open Collective]([])：支持我们的捐赠或预算贡献平台  


# linuxserver/heimdall 容器  

[![Scarf.io pulls]([])]([])
[![GitHub Stars]([])]([])
[![Docker Pulls]([])]([])

[Heimdall]([]) 是一款轻量工具，用于集中管理常用网站和 Web 应用链接。其核心设计理念是简洁，可作为浏览器起始页，还支持集成 Google、Bing 或 DuckDuckGo 搜索栏。  

![heimdall]([])  


## 支持的架构  
容器通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/heimdall:latest` 即可自动匹配对应架构，也可通过标签指定：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<version tag\>  |  
| arm64      | ✅        | arm64v8-\<version tag\> |  


## 版本标签  
容器提供以下标签，请注意开发版可能不稳定：  

| 标签         | 支持状态 | 说明                          |  
|--------------|----------|-------------------------------|  
| latest       | ✅        | Heimdall 稳定版发行版         |  
| development  | ✅        | GitHub 2.x 分支的最新提交版本 |  


## 应用配置  

### 基础访问  
通过 `[] 访问 Web 界面。  

### 启用密码保护  
容器支持通过 htpasswd 实现密码保护，步骤如下：  
1. 在主机执行命令生成 htpasswd 文件（替换 `<username>` 为自定义用户名，按提示输入密码）：  
   ```bash  
   docker exec -it heimdall htpasswd -c /config/nginx/.htpasswd <username>  
   ```  
2. 编辑 `/config/nginx/site-confs/default.conf`，取消 `basic auth` 相关行的注释。  
3. 重启容器使配置生效。  


## 使用方法  
可通过 docker-compose（推荐）或 docker cli 启动容器。  

> [!NOTE]  
> 除非标记为“可选”，否则所有参数均为必填项。  


### docker-compose  
```yaml  
---  
services:  
  heimdall:  
    image: lscr.io/linuxserver/heimdall:latest  
    container_name: heimdall  
    environment:  
      - PUID=1000          # 用户ID（见下方说明）  
      - PGID=1000          # 组ID（见下方说明）  
      - TZ=Etc/UTC         # 时区（如 Asia/Shanghai）  
      - ALLOW_INTERNAL_REQUESTS=false  # 可选：是否允许内网IP请求（默认禁止）  
    volumes:  
      - /path/to/heimdall/config:/config  # 主机配置文件路径映射  
    ports:  
      - 80:80   # HTTP端口  
      - 443:443 # HTTPS端口  
    restart: unless-stopped  
```  


### docker cli  
```bash  
docker run -d \  
  --name=heimdall \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -e ALLOW_INTERNAL_REQUESTS=false `# 可选` \  
  -p 80:80 \  
  -p 443:443 \  
  -v /path/to/heimdall/config:/config \  
  --restart unless-stopped \  
  lscr.io/linuxserver/heimdall:latest  
```  


## 参数说明  

| 参数                  | 作用说明                                                                 |  
|-----------------------|--------------------------------------------------------------------------|  
| `-p 80:80`            | HTTP 访问端口映射                                                       |  
| `-p 443:443`          | HTTPS 访问端口映射                                                      |  
| `-e PUID=1000`        | 用户ID，用于解决权限问题（通过 `id your_user` 命令获取）                 |  
| `-e PGID=1000`        | 组ID，同上                                                               |  
| `-e TZ=Etc/UTC`       | 时区，参考 [时区列表]() |  
| `-e ALLOW_INTERNAL_REQUESTS=false` | 是否允许访问内网IP（未暴露公网或已认证的实例可设为 `true`） |  
| `-v /config`          | 配置文件持久化目录                                                       |  


## 环境变量文件（Docker Secrets）  
支持通过文件传递环境变量，格式为 `FILE__变量名=文件路径`，例如：  
```bash  
-e FILE__MYVAR=/run/secrets/mysecretvariable  
```  
变量值将从 `/run/secrets/mysecretvariable` 文件读取。  


## Umask 权限设置  
可通过 `-e UMASK=022` 覆盖默认 umask（权限掩码），请注意 umask 是权限减法而非加法，详情参考 [umask 说明]()。  


## 用户/组ID（PUID/PGID）  
挂载卷时，主机与容器可能出现权限冲突。通过指定 PUID/PGID（与主机用户一致）可避免该问题。使用 `id your_user` 命令获取当前用户的 UID/GID：  
```bash  
id your_user  
# 示例输出：uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)  
```  


## Docker Mods  
可通过 [Docker Mods]([]) 扩展容器功能，支持 Heimdall 专用 Mod 和通用 Mod。  


## 支持信息  

### 容器操作  
- 进入容器命令行：  
  ```bash  
  docker exec -it heimdall /bin/bash  
  ```  
- 实时查看日志：  
  ```bash  
  docker logs -f heimdall  
  ```  

### 版本查询  
- 容器版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' heimdall  
  ```  
- 镜像版本：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/heimdall:latest  
  ```  


## 更新方法  
容器需通过更新镜像并重建来升级应用，以下是具体步骤：  


### 通过 docker-compose  
- 更新镜像：  
  ```bash  
  # 更新所有镜像  
  docker-compose pull  
  # 仅更新 Heimdall  
  docker-compose pull heimdall  
  ```  
- 重启容器：  
  ```bash  
  # 重启所有容器  
  docker-compose up -d  
  # 仅重启 Heimdall  
  docker-compose up -d heimdall  
  ```  
- 清理旧镜像：  
  ```bash  
  docker image prune  
  ```  


### 通过 docker run  
- 更新镜像：  
  ```bash  
  docker pull lscr.io/linuxserver/heimdall:latest  
  ```  
- 停止并删除旧容器：  
  ```bash  
  docker stop heimdall && docker rm heimdall  
  ```  
- 用原参数重建容器（配置文件在 `/config` 中，会自动保留）  
- 清理旧镜像：  
  ```bash  
  docker image prune  
  ```  


### 镜像更新通知  
推荐使用 [Diun]([]) 监控镜像更新，不建议使用自动更新工具。  


## 本地构建  
如需修改镜像源码：  
```bash  
git clone []  
cd docker-heimdall  
docker build \  
  --no-cache \  
  --pull \  
  -t lscr.io/linuxserver/heimdall:latest .  
```  
跨架构构建（如 x86_64 构建 ARM）需先注册 QEMU：  
```bash  
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset  
```  
然后使用对应架构的 Dockerfile（如 `-f Dockerfile.aarch64`）。  


## 版本历史  
- **2025.07.20**：基于 Alpine 3.22 重构，支持 PHP 环境变量传递。  
- **2024.06.27**：基于 Alpine 3.20 重构，旧用户需更新 nginx 配置以避免 http2 警告。  
- **2024.03.07**：启用 opcache 并禁用文件重新验证。  
- **2023.12.23**：基于 Alpine 3.19 重构，使用 PHP 8.3。  
- **2023.05.25**：基于 Alpine 3.18 重构，移除 armhf 支持。  
- **2022.11.14**：基于 Alpine 3.15 重构，使用 PHP 8，调整 nginx 配置结构。  
- **2018.02.12**：初始版本发布。
