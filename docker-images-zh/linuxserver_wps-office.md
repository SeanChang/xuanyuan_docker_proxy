---
image: linuxserver/wps-office
description: "LinuxServer.io提供的WPS Office Docker镜像，用于在容器环境中便捷部署和运行WPS Office办公套件，支持文档、表格、演示文稿等功能，具备易用性和持续更新特性。"
source: https://xuanyuan.cloud/zh/r/linuxserver/wps-office
canonical: https://xuanyuan.cloud/zh/r/linuxserver/wps-office
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/wps-office" title="linuxserver/wps-office Docker 镜像中文简介、标签列表与拉取命令">linuxserver/wps-office 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# linuxserver/wps-office

## 镜像概述和主要用途

[linuxserver/wps-office](https://github.com/linuxserver/docker-wps-office) 是由LinuxServer.io团队构建的Docker镜像，用于容器化部署[WPS Office](https://www.wps.com/)办公套件。WPS Office是一款轻量级、功能丰富的综合性办公软件，支持文档（Writer）、演示文稿（Presentation）、电子表格（Spreadsheet）和PDF文件的编辑，具备高度兼容性，可有效提升办公效率。该镜像通过Web界面提供WPS Office的访问能力，适用于需要便捷、跨平台办公环境的场景。


## 核心功能和特性

### LinuxServer.io容器特性
- **定期应用更新**：确保软件版本及时更新
- **灵活用户映射**：通过PGID/PUID实现容器内用户与宿主机用户权限映射
- **自定义基础镜像**：基于s6 overlay构建，提供可靠的进程管理
- **高效资源利用**：每周基础OS更新，通过通用层减少存储空间占用、 downtime和带宽消耗
- **持续安全更新**：定期修补安全漏洞


### WPS Office核心功能
- **多格式兼容**：支持Microsoft Office格式（Docx、Xlsx、Pptx等）及PDF
- **全功能办公套件**：集成文档编辑、演示文稿制作、电子表格处理和PDF工具
- **轻量级设计**：资源占用低，运行高效
- **Web访问能力**：通过浏览器访问容器化WPS Office，无需本地安装


## 使用场景和适用范围

- **个人/家庭办公**：在本地网络中通过Web浏览器访问办公套件
- **开发/测试环境**：快速部署隔离的办公软件环境
- **低资源设备**：在服务器或嵌入式设备上提供办公能力，无需图形化桌面
- **局域网协作**：在信任的本地网络中共享办公工具（需配合认证机制）

> **注意**：该容器提供对宿主机系统的特权访问，**严禁直接暴露到互联网**，仅适用于可控的本地网络环境。


## 使用方法和配置说明

### 支持的架构

| 架构 | 支持情况 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ❌ | - |


### 应用访问

容器启动后，可通过以下地址访问应用：
- `https://<yourhost>:3001/`（默认HTTPS端口）


### 安全注意事项

#### 基础安全要求
- **HTTPS强制要求**：现代浏览器特性（如WebCodecs）仅在HTTPS下工作，容器默认使用自签名证书
- **认证机制**：默认无认证，可通过`CUSTOM_USER`和`PASSWORD`环境变量启用HTTP基本认证（仅适用于可信局域网）
- **特权访问风险**：Web界面包含带无密码sudo权限的终端，任何访问者可获取容器内root权限，建议通过反向代理（如[SWAG](https://github.com/linuxserver/docker-swag)）增强安全

#### 严格反向代理配置
若使用验证证书的反向代理，需[禁用对容器的证书检查](https://docs.linuxserver.io/faq#strict-proxy)


### 部署示例

#### Docker Compose配置

```yaml
---
services:
  wps-office:
    image: lscr.io/linuxserver/wps-office:latest
    container_name: wps-office
    environment:
      - PUID=1000               # 用户ID（通过`id your_user`获取）
      - PGID=1000               # 组ID（通过`id your_user`获取）
      - TZ=Etc/UTC              # 时区（如Asia/Shanghai）
      - CUSTOM_USER=admin       # 可选：HTTP基本认证用户名
      - PASSWORD=securepass     # 可选：HTTP基本认证密码
      - LC_ALL=zh_CN.UTF-8      # 可选：设置语言（如中文）
    volumes:
      - /path/to/config:/config # 持久化配置和数据目录
    ports:
      - 3000:3000               # HTTP端口（建议仅内部使用）
      - 3001:3001               # HTTPS端口（推荐访问方式）
    shm_size: "1gb"             # Electron应用必需的共享内存大小
    restart: unless-stopped
    # 可选：若遇到兼容性问题添加
    # security_opt:
    #   - seccomp=unconfined
```

#### Docker Run命令

```bash
docker run -d \
  --name=wps-office \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CUSTOM_USER=admin \          # 可选
  -e PASSWORD=securepass \        # 可选
  -e LC_ALL=zh_CN.UTF-8 \         # 可选，设置中文
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/wps-office:latest
```


### 参数说明

| 参数 | 功能描述 |
| :----: | --- |
| `-p 3000:3000` | HTTP端口映射（建议仅内部使用） |
| `-p 3001:3001` | HTTPS端口映射（推荐访问方式） |
| `-e PUID=1000` | 用户ID，用于权限映射（通过`id your_user`获取） |
| `-e PGID=1000` | 组ID，用于权限映射（通过`id your_user`获取） |
| `-e TZ=Etc/UTC` | 时区设置，如`Asia/Shanghai` |
| `-v /path/to/config:/config` | 持久化目录，存储用户配置和文档 |
| `--shm-size="1gb"` | 共享内存大小，Electron应用必需 |


### 环境变量

#### 基础环境变量

| 变量 | 描述 | 默认值 |
| :----: | --- | --- |
| `CUSTOM_USER` | HTTP基本认证用户名 | `abc` |
| `PASSWORD` | HTTP基本认证密码（未设置则禁用认证） | 未设置 |
| `SUBFOLDER` | 反向代理子路径（需包含前后斜杠，如`/wps/`） | 未设置 |
| `TITLE` | 浏览器页面标题 | `Selkies` |
| `LC_ALL` | 容器 locale（用于语言设置） | 未设置 |


#### Selkies特有环境变量

| 变量 | 描述 |
| :----: | --- |
| `CUSTOM_PORT` | 内部HTTP端口 |
| `CUSTOM_HTTPS_PORT` | 内部HTTPS端口 |
| `CUSTOM_WS_PORT` | WebSocket端口 |
| `START_DOCKER` | 设置为`false`禁用Docker-in-Docker |
| `DISABLE_IPV6` | 设置为`true`禁用IPv6 |
| `DRINODE` | 指定DRI设备节点（如`/dev/dri/renderD128`） |
| `NO_DECOR` | 设置后应用无窗口边框（适合PWA） |
| `NO_FULL` | 设置后应用不自动全屏 |
| `DISABLE_ZINK` | 禁用Zink OpenGL支持 |
| `WATERMARK_PNG` | 水印图片路径 |
| `WATERMARK_LOCATION` | 水印位置（1-6，对应不同方位） |


### 多语言支持

通过`LC_ALL`环境变量设置界面语言，例如：

| 语言 | 环境变量值 |
| :----: | --- |
| 中文 | `LC_ALL=zh_CN.UTF-8` |
| 日文 | `LC_ALL=ja_JP.UTF-8` |
| 韩文 | `LC_ALL=ko_KR.UTF-8` |
| 阿拉伯文 | `LC_ALL=ar_AE.UTF-8` |
| 俄语 | `LC_ALL=ru_RU.UTF-8` |
| 西班牙语（拉美） | `LC_ALL=es_MX.UTF-8` |
| 德语 | `LC_ALL=de_DE.UTF-8` |
| 法语 | `LC_ALL=fr_FR.UTF-8` |


### GPU加速配置

#### DRI3 GPU加速（开源驱动）

适用于Intel、AMD（AMDGPU/Radeon/ATI）或Nouveau（NVIDIA开源驱动）显卡：

```bash
# 添加设备映射
--device /dev/dri:/dev/dri
# 可选：指定具体DRI节点
-e DRINODE=/dev/dri/renderD128
```


#### Nvidia GPU支持

需使用Nvidia运行时，支持硬件加速视频编码：

**Docker Run方式**：
```bash
docker run -d \
  --name=wps-office \
  --gpus all \
  --runtime nvidia \
  # 其他参数...
  lscr.io/linuxserver/wps-office:latest
```

**Docker Compose方式**（需先配置Nvidia运行时为默认）：
```yaml
services:
  wps-office:
    image: lscr.io/linuxserver/wps-office:latest
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [compute,video,graphics,utility]
    # 其他配置...
```


### 应用管理

#### PRoot Apps（持久化）

推荐使用`proot-apps`安装持久化应用（存储在`/config`目录，容器重建后保留）：

```bash
# 容器内执行
proot-apps install <应用名>
```

支持的应用列表见[proot-apps文档](https://github.com/linuxserver/proot-apps?tab=readme-ov-file#supported-apps)。


#### 原生应用（非持久化）

通过系统包管理器安装（容器重建后丢失）：

```yaml
# docker-compose中添加
environment:
  - DOCKER_MODS=linuxserver/mods:universal-package-install
  - INSTALL_PACKAGES=libfuse2|git|gdb  # 需安装的包，用|分隔
```


## Docker Mods

可通过Docker Mods扩展功能：

- **专用Mods**：[wps-office相关Mods](https://mods.linuxserver.io/?mod=wps-office)
- **通用Mods**：[LinuxServer通用Mods](https://mods.linuxserver.io/?mod=universal)


## 支持信息

### 容器操作

- **进入容器终端**：
  ```bash
  docker exec -it wps-office /bin/bash
  ```

- **查看实时日志**：
  ```bash
  docker logs -f wps-office
  ```

- **查看容器版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' wps-office
  ```

- **查看镜像版本**：
  ```bash
  docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/wps-office:latest
  ```


## 更新说明

### Docker Compose更新

```bash
# 拉取最新镜像
docker-compose pull wps-office
# 重启容器
docker-compose up -d wps-office
# 清理旧镜像
docker image prune
```

### Docker Run更新

```bash
# 拉取最新镜像
docker pull lscr.io/linuxserver/wps-office:latest
# 停止并删除旧容器
docker stop wps-office && docker rm wps-office
# 用原参数启动新容器（/config目录需映射正确以保留数据）
docker run -d \
  --name=wps-office \
  # 原参数...
  lscr.io/linuxserver/wps-office:latest
```


## 本地构建

```bash
git clone https://github.com/linuxserver/docker-wps-office.git
cd docker-wps-office
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/wps-office:latest .
```

跨架构构建需先注册qemu-static：
```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```


## 版本历史

- **10.07.25:** - 基于Selkies重构，强制HTTPS，合并中英文镜像
- **10.02.24:** - 更新文档，添加新环境变量，支持PWA图标
- **06.01.24:** - 基于Debian Bookworm重建
- **17.01.24:** - 更新Chromium包装器
- **21.04.23:** - 初始发布
