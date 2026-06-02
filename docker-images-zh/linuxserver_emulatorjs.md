---
image: linuxserver/emulatorjs
description: "linuxserver/emulatorjs 是一款基于Docker的自托管网页版多平台游戏模拟器，支持NES、SNES、PS1、街机等经典主机游戏，无需复杂配置即可快速部署。通过浏览器实现跨设备（电脑、手机、平板）访问，支持自定义ROM导入与管理，还原复古游戏操作体验。轻量化设计兼顾性能与易用性，适合家庭娱乐或复古游戏收藏爱好者，让你随时随地重温童年经典游戏时光。"
source: https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs
canonical: https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [linuxserver/emulatorjs — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs)

含镜像标签、拉取命令、部署文档与相关推荐。

[linuxserver/emulatorjs Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/linuxserver/emulatorjs)

# LinuxServer.io 容器介绍：emulatorjs


## 重要通知：该镜像已弃用
**此镜像已停止维护**，不再提供支持及更新。建议考虑以下替代方案：  
- [gaseous - server]([])  
- [romm]([])  
- [webrcade]([])  


## 关于 LinuxServer.io
[LinuxServer.io]([]) 团队专注于提供高质量容器镜像，核心特点包括：  
- 定期、及时的应用更新  
- 简化的用户权限映射（通过 PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周基础系统更新，通过共享层减少存储空间占用、 downtime 及带宽消耗  
- 常规安全更新  

可通过以下渠道获取支持与信息：  
- [博客]([])（含使用指南、教程）  
- []()（实时社区交流）  
- [Discourse]([])（社区论坛）  
- [Fleet]([])（镜像管理界面）  
- [GitHub]([])（源码仓库）  


## 项目概述：linuxserver/emulatorjs
[emulatorjs]([]) 是一款基于浏览器的复古游戏模拟器，支持多种经典游戏机，整合了 Libretro 和 EmulatorJS 等模拟器核心，可在几乎所有设备上运行。


## 支持的架构
该镜像通过 Docker manifest 实现多平台支持，拉取 `lscr.io/linuxserver/emulatorjs:latest` 即可自动匹配对应架构，也可通过标签指定：  

| 架构       | 支持状态 | 标签格式               |
|------------|----------|------------------------|
| x86 - 64   | ✅ 支持   | amd64 - \<版本标签\>    |
| arm64      | ✅ 支持   | arm64v8 - \<版本标签\>  |
| armhf      | ❌ 不支持 | -                      |  


## 应用配置步骤
### 访问地址
后端管理界面：`[]  

### 初始设置
1. **下载默认资源**：首次访问后端界面时，点击下载默认的游戏封面和配置文件，系统会在 `/data` 目录下生成基础目录结构。  
2. **添加 ROM 文件**：将 ROM 文件放入 `/data/roms` 对应子目录（如 NES 游戏放入 `roms/nes`），按界面指引添加到前端（运行在 80 端口）。  

### 注意事项
- **项目命名说明**：本项目（linuxserver/emulatorjs）仅为自托管场景提供前端界面，基于社区优化的 Libretro 核心（[源码]([])），与 [EmulatorJS 官方项目]([]) 无关联。  
- **静态文件提取**：容器内 `/emulatorjs/frontend` 目录包含可独立部署的静态前端文件，生成游戏库后可将其复制到其他 Web 服务器（如对象存储），无需继续运行容器。  
- **禁用 IPFS**：若无需 IPFS 后端，可通过环境变量 `-e DISABLE_IPFS=true` 启动容器。  


### 只读 ROM 目录挂载
如需挂载现有只读 ROM 目录，可使用 `/roms` 根路径，例如 NES 游戏：  
```bash
-v /本地路径/nes/roms:/roms/nes:ro
```  
支持的游戏机目录名称：  
3do、arcade、atari2600、atari5200、atari7800、colecovision、doom、gb、gba、gbc、jaguar、lynx、msx、n64、nds、nes、ngp、odyssey2、pce、psx、sega32x、segaCD、segaGG、segaMD、segaMS、segaSaturn、segaSG、snes、vb、vectrex、ws  


### 兼容浏览器
- **Chromium 内核浏览器**（Chrome/Edge/Brave）：性能最佳，支持桌面和 Android 设备。  
- **Firefox**：可运行，但性能较低，控制器支持未测试。  
- **Safari (iOS)**：性能良好且支持控制器，但单标签内存限制（约 265MB）导致无法运行 N64 或 CD 类游戏；建议通过 Safari 添加到主屏幕以获得全屏体验。  
- **Xbox Series X/S (Edge)**：性能良好，但近期系统更新后单标签内存限制（128MB）导致无法运行 CD 类或 N64 游戏。  


### 基本操作指南
- **Retroarch 菜单**：键盘按 F1、控制器同时按 start/select/R1/L1，或触摸模式点击左上角按钮。  
- **快速滚动**：键盘 PgUp/PgDn 或控制器 R1/L1 按字母快速定位；触摸模式长按上下拖动加速滚动。  
- **Xbox 用户**：启动游戏后按“查看键”（双小方块）几次，避免 B 键触发浏览器“返回”；长按“菜单键”（三横线）3 秒可退出控制器模式。  


## 使用方法
### Docker Compose（推荐）
```yaml
---
services:
  emulatorjs:
    image: lscr.io/linuxserver/emulatorjs:latest
    container_name: emulatorjs
    environment:
      - PUID=1000        # 用户 ID（必填）
      - PGID=1000        # 组 ID（必填）
      - TZ=Etc/UTC       # 时区（必填，如 Asia/Shanghai）
      - SUBFOLDER=/      # 反向代理子路径（可选，如 /emulator/）
    volumes:
      - /本地路径/config:/config  # 配置文件目录
      - /本地路径/data:/data      # 数据（ROM/封面）目录
    ports:
      - 3000:3000        # 后端管理端口
      - 80:80            # 前端访问端口
      - 4001:4001        # IPFS 端口（可选）
    restart: unless-stopped
```

### Docker CLI
```bash
docker run -d \
  --name=emulatorjs \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e SUBFOLDER=/ `# 可选` \
  -p 3000:3000 \
  -p 80:80 \
  -p 4001:4001 `# 可选` \
  -v /本地路径/config:/config \
  -v /本地路径/data:/data \
  --restart unless-stopped \
  lscr.io/linuxserver/emulatorjs:latest
```  


## 参数说明
| 参数                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `-p 3000:3000`      | 后端管理界面端口（ROM/配置管理）                                     |
| `-p 80:80`          | 前端访问端口（游戏浏览与启动）                                       |
| `-p 4001`           | IPFS 对等网络端口（可选，用于分布式封面资源）                        |
| `-e PUID=1000`      | 用户 ID，通过 `id 用户名` 命令获取                                   |
| `-e PGID=1000`      | 组 ID，同上                                                          |
| `-e TZ=Etc/UTC`     | 时区，参考 [时区列表]() |
| `-e SUBFOLDER=/`    | 反向代理子路径（如 `/emulator/`）                                    |
| `-v /config`        | 用户配置文件存储路径                                                 |
| `-v /data`          | ROM 文件与封面资源存储路径                                           |  


## 高级配置
### 环境变量文件（Docker Secrets）
通过 `FILE__` 前缀从文件加载环境变量，例如：  
```bash
-e FILE__MYVAR=/run/secrets/mysecretvariable  # 从文件读取 MYVAR 变量值
```

### Umask 设置
通过 `-e UMASK=022` 自定义文件权限掩码（默认 022），详情参考 [Umask 说明]()。

### 用户/组 ID（PUID/PGID）
避免权限问题需确保宿主机目录所有者与容器内用户一致，通过 `id 用户名` 获取 PUID/PGID：  
```bash
id your_user  # 示例输出：uid=1000(your_user) gid=1000(your_user)
```  


## 支持与维护
### 容器操作命令
- **进入容器终端**：`docker exec -it emulatorjs /bin/bash`  
- **查看实时日志**：`docker logs -f emulatorjs`  
- **查看容器版本**：`docker inspect -f '{{ index .Config.Labels "build_version" }}' emulatorjs`  
- **查看镜像版本**：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/emulatorjs:latest`  


### 更新容器
#### Docker Compose 方式
```bash
# 更新镜像
docker-compose pull emulatorjs
# 重启容器
docker-compose up -d emulatorjs
# 清理旧镜像
docker image prune
```

#### Docker Run 方式
```bash
# 更新镜像
docker pull lscr.io/linuxserver/emulatorjs:latest
# 停止并删除旧容器
docker stop emulatorjs && docker rm emulatorjs
# 重新创建容器（保留 /config 和 /data 目录则配置不会丢失）
docker run [原有参数] lscr.io/linuxserver/emulatorjs:latest
```  


## 本地构建
```bash
git clone [] docker-emulatorjs
docker build --no-cache --pull -t lscr.io/linuxserver/emulatorjs:latest .
```  
如需跨架构构建（如 x86 构建 ARM 镜像），需先运行：  
```bash
docker run --rm --privileged lscr.io/linuxserver/qemu-static --reset
```  


## 版本历史
- **28.01.24**：设置 DISABLE_IPFS 时跳过 IPFS 配置  
- **27.01.24**：新增 Atari 5200 支持  
- **24.01.24**：修复 arm64 架构 Node 版本兼容性  
- **23.01.24**：添加只读 ROM 目录符号链接逻辑，支持升级  
- **14.01.24**：更新 melonds 和 yabause 核心，修复音频问题  
- **11.01.24**：x86 镜像使用 Node 16，恢复元数据上传功能；更新 PSX 核心  
- **07.01.24**：默认使用新版 Mupen64 核心  
- **06.01.24**：更新多个模拟器核心，修复音频问题  
- **29.12.23**：基于 Alpine 3.19 重构，支持禁用 IPFS  
- **09.08.23**：基于 Alpine 3.18 重构，迁移至 s6v3  
- **06.07.23**：停止支持 armhf 架构  
- **24.11.22**：更新 chdman 的 IPFS 链接  
- **04.04.22**：构建时集成预编译 chdman 二进制文件  
- **23.02.22**：更新模拟器核心文件获取地址  
- **25.01.22**：支持挂载现有 ROM 目录  
- **14.01.22**：添加配置文件路径，基于 Alpine 3.15 重构  
- **04.01.22**：添加线程化模拟器所需头文件  
- **29.11.21**：为 NGINX 添加 wasm MIME 类型  
- **26.11.21**：优化 IPFS 低功耗模式配置；使用自定义构建的模拟器核心  
- **19.11.21**：固定 RetroArch 版本  
- **14.11.21**：更新默认核心版本  
- **23.10.21**：初始发布
