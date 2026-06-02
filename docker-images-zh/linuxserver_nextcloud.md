<!-- xuanyuan-docker-images-zh
image: linuxserver/nextcloud
source: https://xuanyuan.cloud/zh/r/linuxserver/nextcloud
canonical: https://xuanyuan.cloud/zh/r/linuxserver/nextcloud
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/nextcloud" title="linuxserver/nextcloud Docker 镜像中文简介、标签列表与拉取命令">linuxserver/nextcloud — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/linuxserver/nextcloud" title="linuxserver/nextcloud Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/nextcloud</a></p>

# linuxserver/nextcloud Docker镜像文档

## 镜像概述和主要用途

[Nextcloud](https://nextcloud.com/) 是一款开源的私有云存储与协作平台，允许用户在自选服务器（家庭、数据中心或服务提供商）上存储、同步和共享文件，并通过桌面或移动设备访问。本镜像是由 [LinuxServer.io](https://linuxserver.io) 团队构建的容器化版本，提供便捷的部署和管理方式。


## 核心功能和特性

### LinuxServer.io 镜像特性
- **定期应用更新**：及时同步Nextcloud官方版本更新
- **灵活用户映射**：通过PUID/PGID参数轻松配置容器内用户权限
- **自定义基础镜像**：集成s6 overlay进程管理系统
- **高效资源利用**：每周基础OS更新，跨镜像共享通用层以减少存储空间、 downtime和带宽消耗
- **持续安全更新**：定期进行安全补丁更新


## 使用场景和适用范围

- **个人私有云**：替代第三方云存储服务，完全掌控数据存储位置和隐私
- **团队协作平台**：用于团队文件共享、文档协作、日历同步和任务管理
- **企业数据管理**：部署在自有服务器或数据中心，满足数据合规性要求
- **多设备文件同步**：实现桌面端、移动端文件实时同步，支持WebDAV访问


## 支持的架构

通过Docker Manifest实现多平台支持，拉取 `lscr.io/linuxserver/nextcloud:latest` 即可自动匹配对应架构，也可通过标签指定：

| 架构       | 支持状态 | 标签格式               |
|------------|----------|------------------------|
| x86-64     | ✅        | amd64-\<version tag\>  |
| arm64      | ✅        | arm64v8-\<version tag\>|


## 版本标签

| 标签       | 支持状态 | 描述                     |
|------------|----------|--------------------------|
| latest     | ✅        | Nextcloud稳定版发布      |
| develop    | ✅        | Nextcloud测试版（仅预发布版本） |
| previous   | ✅        | 上一个主要版本的稳定发布 |


## 应用设置

### 基本访问
通过 `https://<your-ip>:443` 访问Web界面，初始配置参考 [Nextcloud官方文档](https://nextcloud.com/)。

### occ命令使用
容器内运行Nextcloud命令行工具（occ）无需前缀，直接执行：
```bash
docker exec -it nextcloud occ maintenance:mode --off
```

### 更新Nextcloud
- 仅支持**逐个主版本升级**（如从14→15→16，不可跨版本直接升级）
- 更新流程：拉取新镜像 → 重建容器（`/config`和`/data`卷会保留数据，启动脚本自动检测版本差异并触发升级）

### 协作编辑注意事项
- 内置Collabora/CODE和OnlyOffice仅支持x86_64架构且依赖glibc，本容器不兼容
- 需通过独立容器部署协作编辑服务，并在Nextcloud中安装对应连接器插件
- 若已自动安装内置协作包，建议移除以避免不稳定问题

### HEIC图片预览配置
需修改 `config/www/nextcloud/config/config.php` 添加以下配置：
```php
'enable_previews' => true,
'enabledPreviewProviders' => [
  'OC\Preview\PNG',
  'OC\Preview\JPEG',
  'OC\Preview\GIF',
  'OC\Preview\BMP',
  'OC\Preview\XBitmap',
  'OC\Preview\MP3',
  'OC\Preview\TXT',
  'OC\Preview\MarkDown',
  'OC\Preview\OpenDocument',
  'OC\Preview\Krita',
  'OC\Preview\HEIC',
],
```
修改后需重新登录生效（Nextcloud默认禁用HEIC预览以避免性能或隐私问题，启用需自行评估风险）。

### 自定义应用目录
若使用[自定义应用目录](https://docs.nextcloud.com/server/latest/admin_manual/apps_management.html#using-custom-app-directories)，需通过卷挂载暴露目录：
```yaml
volumes:
  - /path/to/your_custom_apps_folder:/app/www/public/your_custom_apps_folder
```
然后在 `config.php` 中设置：
```php
"path" => OC::$SERVERROOT . "/your_custom_apps_folder",
```

### 严格反向代理配置
镜像默认使用自签名证书（协议为https），若反向代理验证证书，需[禁用容器证书检查](https://docs.linuxserver.io/faq#strict-proxy)。


## 使用方法

### docker-compose（推荐）
```yaml
---
services:
  nextcloud:
    image: lscr.io/linuxserver/nextcloud:latest
    container_name: nextcloud
    environment:
      - PUID=1000        # 容器内用户ID（需与宿主机目录权限匹配）
      - PGID=1000        # 容器内组ID
      - TZ=Etc/UTC       # 时区（如Asia/Shanghai）
    volumes:
      - /path/to/nextcloud/config:/config  # 配置文件存储
      - /path/to/data:/data                # 用户数据存储
    ports:
      - 443:443          # Web访问端口（宿主机:容器）
    restart: unless-stopped
```

### docker cli
```bash
docker run -d \
  --name=nextcloud \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 443:443 \
  -v /path/to/nextcloud/config:/config \
  -v /path/to/data:/data \
  --restart unless-stopped \
  lscr.io/linuxserver/nextcloud:latest
```


## 参数说明

| 参数                  | 功能描述                                                                 |
|-----------------------|--------------------------------------------------------------------------|
| `-p 443:443`          | WebUI访问端口映射（宿主机端口:容器端口）                                 |
| `-e PUID=1000`        | 容器内用户ID，用于权限映射（通过`id your_user`命令获取宿主机用户ID）     |
| `-e PGID=1000`        | 容器内组ID，同上                                                        |
| `-e TZ=Etc/UTC`       | 容器时区，如`Asia/Shanghai`（完整列表见[时区数据库](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)） |
| `-v /config`          | 持久化配置文件存储路径                                                  |
| `-v /data`            | 用户数据存储路径                                                        |


## 环境变量从文件读取（Docker Secrets）

通过 `FILE__` 前缀可从文件加载环境变量，例如：
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```
容器会将 `/run/secrets/mysecretvariable` 文件内容作为 `MYVAR` 环境变量的值。


## Umask设置

通过 `-e UMASK=022` 可覆盖容器内服务的默认umask值（注意：umask是权限掩码，并非直接设置权限，具体参考[umask说明](https://en.wikipedia.org/wiki/Umask)）。


## 用户/组ID（PUID/PGID）

卷挂载时，宿主机目录权限需与容器内用户权限匹配，避免权限问题。通过以下命令获取宿主机用户的PUID/PGID：
```bash
id your_user
```
示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```
其中 `uid=1000` 为PUID，`gid=1000` 为PGID。


## Docker Mods

可通过Docker Mods扩展容器功能：
- [Nextcloud专用Mods](https://mods.linuxserver.io/?mod=nextcloud)
- [通用Mods](https://mods.linuxserver.io/?mod=universal)


## 支持信息

### 容器内Shell访问
```bash
docker exec -it nextcloud /bin/bash
```

### 实时日志查看
```bash
docker logs -f nextcloud
```

### 版本查询
- 容器版本：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' nextcloud
  ```
- 镜像版本：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/nextcloud:latest
  ```


## 更新信息

### 通过docker-compose更新
```bash
# 更新镜像
docker-compose pull nextcloud
# 重启容器
docker-compose up -d nextcloud
# 清理旧镜像
docker image prune
```

### 通过docker cli更新
```bash
# 更新镜像
docker pull lscr.io/linuxserver/nextcloud:latest
# 停止并删除旧容器
docker stop nextcloud && docker rm nextcloud
# 重新创建容器（保留卷数据）
docker run -d [原参数...] lscr.io/linuxserver/nextcloud:latest
# 清理旧镜像
docker image prune
```

### 镜像更新通知工具
推荐使用 [Diun](https://crazymax.dev/diun/) 接收更新通知，不建议使用自动更新容器的工具。


## 本地构建

如需自定义镜像：
```bash
git clone https://github.com/linuxserver/docker-nextcloud.git
cd docker-nextcloud
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/nextcloud:latest .
```
跨架构构建（如x86_64构建ARM镜像）需先注册qemu-static：
```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```
然后使用对应架构的Dockerfile（如 `-f Dockerfile.aarch64`）。


## 版本历史

- **10.07.25:** 基于Alpine 3.22重建
- **12.02.25:** 基于Alpine 3.21重建
- **09.01.25:** 修复大文件上传问题（现有用户需更新nginx配置）
- **09.07.24:** 添加`previous`标签用于上一主版本
- **24.06.24:** 基于Alpine 3.20重建（现有用户需更新nginx配置以避免http2弃用警告）
- **19.05.24:** 添加util-linux包（taskset依赖）
- **10.04.24:** 添加imagemagick-pdf包
- **05.04.24:** 添加imagemagick-heic包（需手动更新`config.php`启用HEIC预览）
- **02.04.24:** 支持Client Push插件（现有用户需更新`site-confs/default.conf`）
- **22.03.24:** 添加imagemagick-svg模块
- **06.03.24:** 基于Alpine 3.19和PHP 8.3重建
- **02.01.24:** 清理默认站点配置（现有用户需更新`site-confs/default.conf`）
- **22.12.23:** 更新站点配置以支持js/mjs mime类型
- **28.10.23:** 初始化时禁用Web升级（occ方式）
- **31.08.23:** 重新添加updatenotification应用（仅通知，不支持Web更新）
- **14.08.23:** 添加develop分支
- **25.06.23:** 将Nextcloud安装至容器内，移除CLI更新器（[变更说明](https://info.linuxserver.io/issues/2023-06-25-nextcloud/)）
- **21.06.23:** 修复real ip设置安全问题（现有用户需更新`/config/nginx/site-confs/default.conf`）
- **25.05.23:** 基于Alpine 3.18重建，移除armhf支持
- **13.04.23:** 将ssl.conf包含至default.conf
- **21.03.23:** 添加php81-sysvsem（v26依赖），更新X-Robots-Tag为`noindex, nofollow`
- **02.03.23:** 初始化时设置crontab权限
- **20.01.23:** 基于Alpine 3.17和PHP 8.1重建
- **10.10.22:** 基于Alpine 3.15和PHP 8重建，重构nginx配置（[变更说明](https://info.linuxserver.io/issues/2022-08-20-nginx-base)）
- **30.09.22:** 禁用php output_buffering（参考[Nextcloud文档](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/big_file_upload_configuration.html)）
- **21.05.22:** 更新版本检查端点
- **28.04.22:** 增加OPCache interned strings缓冲至16
- **14.04.22:** 更新nginx配置以支持v23（现有用户需删除并重建`site-confs/default.conf`），修复LDAP连接
- **11.09.21:** 基于Alpine 3.14重建
- **21.03.21:** 发布`php8`测试标签
- **25.02.21:** 更新nginx配置以支持v21（现有用户需删除并重建`site-confs/default.conf`）
- **21.01.21:** 修复php iconv（修复邮件插件），启动时移除损坏的CODE Server应用
- **20.01.21:** 增加php fcgi超时防止504错误（现有用户需删除并重建`site-confs/default.conf`）
- **16.01.21:** 基于Alpine 3.13重建（32位ARM用户参考[兼容说明](https://docs.linuxserver.io/faq#my-host-is-incompatible-with-images-based-on-ubuntu-focal-and-alpine-3-13)）
- **12.08.20:** 更新站点配置支持webfinger（现有用户需删除并重建`site-confs/default.conf`）
- **03.06.20:** 基于Alpine 3.12重建
- **03.06.20:** 添加php7-bcmath和php7-fileinfo
- **31.05.20:** 添加occ和updater.phar别名
- **31.03.20:** 支持自定义crontab，修复logrotate
- **17.01.20:** 更新php.ini默认值和站点配置（含可选HSTS指令，现有用户需删除并重建`site-confs/default.conf`）
- **19.12.19:** 基于Alpine 3.11重建
- **18.11.19:** 更新nginx配置以支持v17（现有用户需删除并重建`site-confs/default.conf`）
- **28.10.19:** 调整cron任务为每5分钟执行一次
- **24.10.19:** 更新nginx配置修复CVE-2019-11043（现有用户需删除并重建`site-confs/default.conf`）
- **14.07.19:** 构建时下载Nextcloud
- **28.06.19:** 基于Alpine 3.10重建
- **23.03.19:** 切换至新基础镜像，使用arm32v7标签
- **27.02.19:** 更新nginx配置以匹配v15要求
- **22.02.19:** 基于Alpine 3.9重建
- **28.01.19:** 添加流水线逻辑和多架构支持
- **25.01.19:** 添加php7-phar（occ升级依赖）
- **05.09.18:** 基于Alpine 3.8重建
- **11.06.18:** 使用latest标签初始安装而非特定版本
- **26.04.18:** 默认安装版本更新至13.0.1
- **06.02.18:** 默认安装版本更新至13.0.0
- **26.01.18:** 基于Alpine 3.7重建，默认安装版本12.0.5
- **12.12.17:** 默认安装版本12.0.4，修复续行符
- **15.10.17:** 调整php.ini的opcache设置以匹配新版Nextcloud要求
- **20.09.17:** 默认安装版本12.0.3
- **19.08.17:** 默认安装版本12.0.2
- **25.05.17:** 基于Alpine 3.6重建
- **22.05.17:** 更新至Nextcloud 12.0，添加依赖并说明SAMEORIGIN行注释要求
- **03.05.17:** 使用memcache社区仓库
- **07.03.17:** 发布至主仓库，升级至PHP7和Alpine 3.5

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/nextcloud" title="linuxserver/nextcloud Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/nextcloud</a></p>
