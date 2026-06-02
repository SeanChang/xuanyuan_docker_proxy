<!-- xuanyuan-docker-images-zh
image: linuxserver/piwigo
source: https://xuanyuan.cloud/zh/r/linuxserver/piwigo
canonical: https://xuanyuan.cloud/zh/r/linuxserver/piwigo
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [linuxserver/piwigo — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/piwigo "linuxserver/piwigo Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/linuxserver/piwigo

# LinuxServer.io Piwigo 容器介绍


## LinuxServer.io 容器特点  
LinuxServer.io 团队推出的容器具有以下特点：  
- 定期及时的应用更新  
- 简单的用户映射（PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周基础系统更新，通过跨生态通用层减少存储空间占用、 downtime 和带宽消耗  
- 定期安全更新  


## Piwigo 简介  
[Piwigo]([]) 是一款网页相册管理软件，提供强大的图片发布与管理功能。  


## 支持架构  
该镜像通过 Docker 清单实现多平台支持，拉取 `lscr.io/linuxserver/piwigo:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构       | 支持状态 | 标签格式               |  
|------------|----------|------------------------|  
| x86-64     | ✅        | amd64-\<版本标签\>      |  
| arm64      | ✅        | arm64v8-\<版本标签\>    |  


## 应用配置  
1. **数据库准备**：需提前在 MySQL/MariaDB 中为 Piwigo 创建用户及数据库。  
2. **密钥管理**：首次运行容器时会在 `/config/keys` 生成自签名密钥，可替换为自定义密钥。  
3. **配置文件编辑**：在插件页面启用「本地文件编辑器」插件，即可通过该插件配置邮件等参数。  


## 使用方法  
可通过 docker-compose 或 docker cli 启动容器。  

> [!注意]  
> 除非标记为「可选」，否则所有参数为必填项。  


### docker-compose（推荐）  
```yaml  
---  
services:  
  piwigo:  
    image: lscr.io/linuxserver/piwigo:latest  
    container_name: piwigo  
    environment:  
      - PUID=1000        # 用户ID（见下文说明）  
      - PGID=1000        # 组ID（见下文说明）  
      - TZ=Etc/UTC       # 时区，例如 Asia/Shanghai  
    volumes:  
      - /path/to/piwigo/config:/config  # 配置文件持久化路径  
      - /path/to/appdata/gallery:/gallery  # 图片存储路径  
    ports:  
      - 80:80            # WebUI 端口映射  
    restart: unless-stopped  
```  


### docker cli  
```bash  
docker run -d \  
  --name=piwigo \  
  -e PUID=1000 \  
  -e PGID=1000 \  
  -e TZ=Etc/UTC \  
  -p 80:80 \  
  -v /path/to/piwigo/config:/config \  
  -v /path/to/appdata/gallery:/gallery \  
  --restart unless-stopped \  
  lscr.io/linuxserver/piwigo:latest  
```  


## 参数说明  
容器运行参数格式为 `<外部>:<内部>`，具体说明如下：  

| 参数                | 作用                                                                 |  
|---------------------|----------------------------------------------------------------------|  
| `-p 80:80`          | WebUI 端口映射（主机端口:容器端口）                                  |  
| `-e PUID=1000`      | 运行容器的用户ID，避免权限问题（见下文「用户/组ID」说明）            |  
| `-e PGID=1000`      | 运行容器的组ID，同上                                                 |  
| `-e TZ=Etc/UTC`     | 时区设置，可参考 [时区列表]() |  
| `-v /config`        | 配置文件持久化目录                                                  |  
| `-v /gallery`       | Piwigo 图片存储目录                                                 |  


## 环境变量与文件（Docker 密钥）  
可通过 `FILE__<变量名>` 格式从文件加载环境变量，例如：  
```bash  
-e FILE__MYVAR=/run/secrets/mysecretvariable  
```  
此时 `MYVAR` 的值将从 `/run/secrets/mysecretvariable` 文件读取。  


## Umask 设置  
可通过 `-e UMASK=022` 覆盖容器内服务的默认 umask 值（注意 umask 是权限掩码，非直接权限设置，详情参考 [umask 说明]()）。  


## 用户/组 ID  
使用 `-v` 挂载卷时，主机目录与容器内权限可能冲突。通过 `PUID` 和 `PGID` 指定与主机一致的用户/组ID，可避免此问题。  
通过以下命令获取当前用户的 ID：  
```bash  
id your_user  
```  
输出示例：  
```text  
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)  
```  
其中 `uid` 对应 `PUID`，`gid` 对应 `PGID`。  


## Docker Mods  
可通过 Docker Mods 扩展容器功能，相关 Mods 可查看：  
- [Piwigo 专用 Mods]([])  
- [通用 Mods]([])  


## 支持信息  
- **容器内 Shell 访问**：  
  ```bash  
  docker exec -it piwigo /bin/bash  
  ```  

- **实时查看日志**：  
  ```bash  
  docker logs -f piwigo  
  ```  

- **查看容器版本**：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' piwigo  
  ```  

- **查看镜像版本**：  
  ```bash  
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/piwigo:latest  
  ```  


## 更新方法  
容器需通过更新镜像并重建来更新应用（配置文件通过卷挂载可保留）。  


### 通过 docker-compose 更新  
- 更新镜像：  
  ```bash  
  # 更新所有镜像  
  docker-compose pull  
  # 仅更新 piwigo  
  docker-compose pull piwigo  
  ```  

- 重启容器：  
  ```bash  
  # 重启所有容器  
  docker-compose up -d  
  # 仅重启 piwigo  
  docker-compose up -d piwigo  
  ```  

- 清理旧镜像：  
  ```bash  
  docker image prune  
  ```  


### 通过 docker run 更新  
- 更新镜像：  
  ```bash  
  docker pull lscr.io/linuxserver/piwigo:latest  
  ```  

- 停止并删除旧容器：  
  ```bash  
  docker stop piwigo  
  docker rm piwigo  
  ```  

- 用原参数重建容器（配置文件通过卷挂载可保留），并清理旧镜像：  
  ```bash  
  docker image prune  
  ```  


> [!提示]  
> 推荐使用 [Diun]([]) 接收镜像更新通知，不建议使用自动更新工具。  


## 本地构建  
如需自定义镜像，可本地构建：  
```bash  
git clone []  
cd docker-piwigo  
docker build \  
  --no-cache \  
  --pull \  
  -t lscr.io/linuxserver/piwigo:latest .  
```  
跨架构构建需先注册 qemu-static：  
```bash  
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset  
```  
然后指定架构 Dockerfile，例如：  
```bash  
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/piwigo:latest .  
```  


## 版本历史  
- **05.08.25**：因上游错误声明支持PHP 8.4，回退至Alpine 3.21。  
- **27.07.25**：基底更新至Alpine 3.22。  
- **31.05.24**：基底更新至Alpine 3.20，现有用户需更新nginx配置以避免http2弃用警告。  
- **07.04.24**：增加PHP工作进程数，修复安卓批量上传问题。  
- **02.03.24**：修复HEIC文件格式支持。  
- **23.12.23**：基底更新至Alpine 3.19（PHP 8.3）。  
- **12.12.23**：基底更新至Alpine 3.18。  
- **03.06.23**：因PHP 8.2兼容性问题，回退至Alpine 3.17。  
- **25.05.23**：基底更新至Alpine 3.18，移除armhf支持。  
- **20.01.23**：基底更新至Alpine 3.17（PHP 8.1）。  
- **16.01.23**：修复自定义模板持久化问题。  
- **08.11.22**：基底更新至Alpine 3.16，迁移至s6v3，应用路径调整为`/app/www/public`（支持自动更新）。  
- **20.08.22**：基底更新至Alpine 3.15（PHP 8），重构nginx配置。  
- **29.06.21**：基底更新至Alpine 3.14，新增php7-zip包。  
- **20.05.21**：分离图片数据卷。  
- **23.01.21**：基底更新至Alpine 3.13。  
- **12.12.20**：增大php.ini中upload_max_filesize。  
- **01.06.20**：基底更新至Alpine 3.12。  
- **19.12.19**：基底更新至Alpine 3.11。  
- **28.06.19**：基底更新至Alpine 3.10。  
- **12.06.19**：新增ffmpeg及其他插件依赖。  
- **23.03.19**：切换至新基底镜像，标签调整为arm32v7。  
- **01.03.19**：新增php-ctype和php-curl。  
- **22.02.19**：基底更新至Alpine 3.9，新增php-ldap。  
- **28.01.19**：基底更新至Alpine 3.8，支持多架构构建。  
- **25.01.18**：基底更新至Alpine 3.7。  
- **25.05.17**：基底更新至Alpine 3.6。  
- **03.05.17**：优化依赖管理，使用php7-imagick仓库版本。  
- **20.04.17**：新增php7-exif包。  
- **23.02.17**：基底更新至Alpine 3.5（nginx）。  
- **14.10.16**：添加版本层信息。  
- **10.09.16**：README添加层徽章。  
- **29.08.15**：初始发布。  


## 相关链接  
- [LinuxServer.io 官网]([])  
- [博客]([])（含容器使用指南）  
- []()（实时支持/社区交流）  
- [论坛]([])  
- [GitHub]([])（源码仓库）  
- [赞助支持]([])
