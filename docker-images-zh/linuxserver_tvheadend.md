---
image: linuxserver/tvheadend
description: "LinuxServer.io提供的tvheadend容器是一款电视流媒体服务器，用于接收电视信号并转换为网络流媒体，供设备通过网络观看。"
source: https://xuanyuan.cloud/zh/r/linuxserver/tvheadend
canonical: https://xuanyuan.cloud/zh/r/linuxserver/tvheadend
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/tvheadend" title="linuxserver/tvheadend Docker 镜像中文简介、标签列表与拉取命令">linuxserver/tvheadend 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/tvheadend 镜像文档

## 镜像概述和主要用途

[linuxserver/tvheadend](https://github.com/linuxserver/docker-tvheadend) 是由 LinuxServer.io 团队开发的 Docker 镜像，用于部署 Tvheadend 应用。Tvheadend 是一款运行在 Linux、FreeBSD 和 Android 系统上的电视流服务器和录像机，支持 DVB-S、DVB-S2、DVB-C、DVB-T、ATSC、ISDB-T、IPTV、SAT>IP 和 HDHomeRun 等输入源，并提供 HTTP（VLC、MPlayer）、HTSP（Kodi、Movian）和 SAT>IP 流媒体服务，同时支持多种电子节目指南（EPG）来源。

## 核心功能和特性

- **定期应用更新**：确保 Tvheadend 及相关组件及时更新
- **用户权限映射**：通过 PUID 和 PGID 轻松配置容器内用户权限
- **自定义基础镜像**：基于 s6 overlay 构建的定制基础镜像
- **每周基础系统更新**：LinuxServer.io 生态系统内的通用层每周更新，以减少存储空间占用、 downtime 和带宽消耗
- **定期安全更新**：保障容器运行环境的安全性
- **多架构支持**：通过 Docker manifest 实现多平台适配
- **内置实用工具**：包含 Comskip（用于商业广告标记）、FFmpeg 和 XMLTV 工具

## 使用场景和适用范围

- 家庭媒体中心：构建个人或家庭电视直播和录制系统
- 流媒体服务器：为局域网内设备（如 Kodi、智能电视、手机）提供电视流服务
- 电视节目录制：定时录制电视节目并进行管理
- 多源电视整合：集中管理不同类型的电视信号源（如卫星、有线、IPTV）

## 支持的架构

该镜像通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/tvheadend:latest` 即可自动获取对应架构的镜像，也可通过标签指定具体架构：

| 架构 | 支持情况 | 标签格式 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |

## 应用设置

### 基础配置流程

- **Stable 标签**：
  1. 进入 Configuration --> DVB Inputs --> TV adapters，添加 LNB/开关信息
  2. 在 Networks 标签页创建新网络，设置预定义多路复用器和轨道位置
  3. 返回 TV adapters 标签页，在通用 LNB 下添加新创建的网络
  4. 在 Networks 标签页选中创建的网络，点击 "Force Scan" 扫描服务
  5. 扫描完成后，进入 Services 标签页，选择要映射为频道的服务，点击 "map services"，频道将显示在 Configuration --> Channel/EPG 中

- **Latest 标签**：
  首次登录时会自动启动设置向导，若未启动可进入 Configuration --> General --> Base，点击 "Start Wizard"，按照向导完成基础配置

### XMLTV 抓取器配置

1. 进入 Configuration --> Channel/EPG --> EPG Grabber Modules，查看可用抓取器
2. 记录目标抓取器路径字段中以 `tv_grab_` 开头的部分
3. 执行以下命令配置抓取器（将 `for_you_to_fill_out` 替换为实际抓取器名称）：
   ```bash
   docker exec -it -u abc tvheadend /usr/bin/for_you_to_fill_out --configure
   ```
4. 按照屏幕提示完成配置（缓存设置可接受默认值）
5. 配置完成后返回 EPG Grabber Modules 启用抓取器

> 若已有配置文件，可将其放入 `/config` 卷映射的 `.xmltv` 文件夹（若不存在需创建）

### Comskip 配置（商业广告标记）

1. 进入 Configuration --> Recording
2. 在右上角将视图级别改为 "advanced"
3. 在 "Post-processor command" 字段中添加：
   ```bash
   /usr/bin/comskip --ini=/config/comskip/comskip.ini "%f"
   ```
4. 录制完成后将自动运行 Comskip，配置文件位于 `/config/comskip/comskip.ini`，可参考 [Comskip 官网](http://www.kaashoek.com/comskip/) 进行优化

### FFmpeg 使用

FFmpeg 已安装在容器内 `/usr/bin/` 路径，可用于管道处理等高级功能

### EPG XML 文件配置

1. 将 XML 格式的 EPG 数据文件命名为 `guide.xml`
2. 放入 `/config` 卷映射的 `data` 文件夹（若不存在需创建）
3. 进入 Configuration --> Channel/EPG --> EPG Grabber Modules，选择 "XML file grabber"（WebGrab+Plus 用户选择 "WebGrab+Plus XML file grabber"）

### Picons 配置（频道图标）

1. 容器内置 [picons](https://github.com/picons/picons) 图标集，位于 `/picons` 路径
2. 进入 Configuration --> General --> Base，将 "Channel icon path" 设置为 `/picons`
3. 需将视图级别设置为至少 "advanced" 才能看到相关选项

## 额外运行参数

如需使用额外参数启动 tvheadend（如启用调试或指定反向代理的 webroot），可通过 `RUN_OPTS` 环境变量传递，注意错误的参数可能导致容器无法正常启动

## 使用方法

### Docker Compose（推荐）

```yaml
---
services:
  tvheadend:
    image: docker.xuanyuan.run/linuxserver/tvheadend:latest
    container_name: tvheadend
    environment:
      - PUID=1000        # 用户ID，使用 `id your_user` 查看
      - PGID=1000        # 组ID，使用 `id your_user` 查看
      - TZ=Etc/UTC       # 时区，如 Asia/Shanghai
      - RUN_OPTS=        # 可选，额外运行参数
    volumes:
      - /path/to/tvheadend/data:/config      # 配置文件存储路径
      - /path/to/recordings:/recordings      # 录制文件存储路径
    ports:
      - 9981:9981        # WebUI 端口
      - 9982:9982        # HTSP 服务器端口
    devices:
      - /dev/dri:/dev/dri   # 可选，AMD/Intel GPU 硬件加速
      - /dev/dvb:/dev/dvb   # 可选，DVB 卡设备映射
    restart: unless-stopped
```

### Docker Run

```bash
docker run -d \
  --name=tvheadend \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e RUN_OPTS= `#可选` \
  -p 9981:9981 \
  -p 9982:9982 \
  -v /path/to/tvheadend/data:/config \
  -v /path/to/recordings:/recordings \
  --device /dev/dri:/dev/dri `#可选` \
  --device /dev/dvb:/dev/dvb `#可选` \
  --restart unless-stopped \
  lscr.io/linuxserver/tvheadend:latest
```

### 主机网络模式说明

若使用 IPTV、SAT>IP 或 HDHomeRun，需使用 `--net=host` 网络模式并移除 `-p` 端口映射，因为这些服务需要使用多播地址 `239.255.255.250` 和 UDP 端口 `1900`，目前 Docker 桥接模式不支持此功能。注意：与其他使用多播的服务（如 SSDP/DLNA/Emby）共存可能导致稳定性问题。

## 参数说明

| 参数 | 功能说明 |
| :----: | --- |
| `-p 9981:9981` | WebUI 端口映射 |
| `-p 9982:9982` | HTSP 服务器端口映射 |
| `-e PUID=1000` | 用户ID，用于解决卷权限问题 |
| `-e PGID=1000` | 组ID，用于解决卷权限问题 |
| `-e TZ=Etc/UTC` | 时区设置，参考 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| `-e RUN_OPTS=` | 可选，传递额外运行参数给 tvheadend |
| `-v /config` | Tvheadend 配置文件存储路径 |
| `-v /recordings` | 电视节目录制文件存储路径 |
| `--device /dev/dri` | 可选，AMD/Intel GPU 硬件加速设备映射 |
| `--device /dev/dvb` | 可选，DVB 卡设备映射 |

## 环境变量文件（Docker Secrets）

可通过 `FILE__` 前缀从文件加载环境变量，例如：
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable
```
将从 `/run/secrets/mysecretvariable` 文件内容设置 `MYVAR` 环境变量

## 应用 umask 设置

可通过 `-e UMASK=022` 覆盖容器内服务的默认 umask 设置，注意 umask 是权限掩码而非直接设置权限，具体请参考 [umask 说明](https://en.wikipedia.org/wiki/Umask)

## 用户/组标识符

使用卷映射时，可通过指定 `PUID`（用户ID）和 `PGID`（组ID）避免主机与容器间的权限问题。使用以下命令获取当前用户的 PUID 和 PGID：
```bash
id your_user
```
示例输出：
```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```

## Docker Mods

[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=tvheadend&query=%24.mods%5B%27tvheadend%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=tvheadend) [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal)

LinuxServer.io 提供多种 [Docker Mods](https://github.com/linuxserver/docker-mods) 以扩展容器功能，可通过上方链接查看适用于此镜像的 Mods 及通用 Mods。

## 支持信息

- **容器内 shell 访问**：
  ```bash
  docker exec -it tvheadend /bin/bash
  ```

- **实时查看容器日志**：
  ```bash
  docker logs -f tvheadend
  ```

- **查看容器版本号**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' tvheadend
  ```

- **查看镜像版本号**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/tvheadend:latest
  ```

## 更新说明

### 通过 Docker Compose 更新

- 更新镜像：
  - 更新所有镜像：
    ```bash
    docker-compose pull
    ```
  - 更新单个镜像：
    ```bash
    docker-compose pull tvheadend
    ```

- 更新容器：
  - 更新所有容器：
    ```bash
    docker-compose up -d
    ```
  - 更新单个容器：
    ```bash
    docker-compose up -d tvheadend
    ```

- 清理旧镜像：
  ```bash
  docker image prune
  ```

### 通过 Docker Run 更新

- 更新镜像：
  ```bash
  docker pull docker.xuanyuan.run/linuxserver/tvheadend:latest
  ```

- 停止运行中的容器：
  ```bash
  docker stop tvheadend
  ```

- 删除容器：
  ```bash
  docker rm tvheadend
  ```

- 使用相同参数重新创建容器（配置文件将通过卷映射保留）

- 清理旧镜像：
  ```bash
  docker image prune
  ```

### 镜像更新通知 - Diun

推荐使用 [Diun](https://crazymax.dev/diun/) 接收镜像更新通知，不建议使用自动更新容器的工具。

## 本地构建

```bash
git clone https://github.com/linuxserver/docker-tvheadend.git
cd docker-tvheadend
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/tvheadend:latest .
```

如需在 x86_64 硬件上构建 ARM 变体，可使用 `lscr.io/linuxserver/qemu-static`：
```bash
docker run --rm --privileged docker.xuanyuan.run/linuxserver/qemu-static --reset
```
然后使用 `-f Dockerfile.aarch64` 指定架构对应的 Dockerfile。

## 版本历史

- **25.06.24:** 基底镜像更新至 Alpine 3.20
- **20.03.24:** 基底镜像更新至 Alpine 3.19
- **16.10.23:** 添加 mesa-va-gallium 包以支持 AMD 转码
- **20.09.23:** 添加 perl-json-xs 包
- **18.05.23:** 从 Alpine 仓库安装 XMLTV
- **18.05.23:** 基底镜像更新至 Alpine 3.18
- **17.03.23:** 构建时提取 picons 而非初始化时提取
- **23.02.23:** 基底镜像更新至 Alpine 3.17，迁移至 s6v3，移除 armhf 支持
- **31.08.22:** 更新示例环境变量和 RUN_OPTS 处理方式
- **19.08.22:** 切换到新的 picons 构建器
- **16.04.22:** 添加 URL XMLTV 抓取器
- **05.01.22:** 基底镜像更新至 Alpine 3.15，禁用 execinfo 修复构建，更新 xmltv
- **11.05.21:** 添加 Intel iHD 驱动支持
- **02.06.20:** 更新至 Alpine 3.12
- **27.12.19:** 添加 requests 和 perl-json-xs 包
- **27.12.19:** 更新至 Alpine 3.11
- **02.10.19:** 改进 render 和 dvb 设备的权限修复
- **18.08.19:** 添加 AMD 驱动
- **02.08.19:** 尝试自动修复 /dev/dri 和 /dev/dvb 的权限
- **28.06.19:** 基底镜像更新至 Alpine 3.10
- **27.03.19:** 基底镜像更新至 Alpine 3.9，修复初始化逻辑仅执行一次 chown
- **23.03.19:** 切换到新的基础镜像，迁移至 arm32v7 标签
- **01.03.19:** 升级 xmltv 至 0.6.1
- **28.02.19:** 添加 perl-lwp-useragent-determined
- **17.02.19:** 升级 xmltv 至 5.70，通过克隆 tvheadend 确保版本标记正常工作
- **14.02.19:** 添加 picons 路径到配置
- **15.01.19:** 添加流水线逻辑和多架构支持
- **12.09.18:** 基底镜像更新至 Alpine 3.8，使用 buildstage 类型构建
- **21.04.18:** 添加 JSON::XS Perl 包用于 grab_tv_huro
- **24.03.18:** 添加 dvbcsa 包
- **04.03.18:** 使用 sourceforge master 而非镜像获取 xmltv
- **22.02.18:** 添加丢失的 libva-intel-driver
- **21.02.18:** 修复使用错误版本的 iconv
- **18.02.18:** 添加 vaapi 支持，清理并移除已弃用选项
- **04.01.18:** 弃用 cpu_core 例程（缺乏扩展性）
- **11.12.17:** 基底镜像更新至 Alpine 3.7，修复代码规范问题
- **02.09.17:** 添加编解码器依赖
- **13.07.17:** 提高所有架构的一致性
- **08.07.17:** 更新 README 中的
