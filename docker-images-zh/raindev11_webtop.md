---
image: raindev11/webtop
description: "基于KasmVNC和Ubuntu-KDE的Web Linux桌面环境，支持韩语输入输出，预装实用工具、开发工具及GUI应用，提供浏览器访问的远程桌面解决方案，适用于多架构系统。"
source: https://xuanyuan.cloud/zh/r/raindev11/webtop
canonical: https://xuanyuan.cloud/zh/r/raindev11/webtop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/raindev11/webtop" title="raindev11/webtop Docker 镜像中文简介、标签列表与拉取命令">raindev11/webtop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Webtop

基于linuxserver/webtop、kasmvnc与ubuntu-kde构建的Web基础Linux桌面环境，针对国内用户进行了韩语设置优化，预装多种实用程序及开发工具，可通过浏览器便捷访问完整桌面体验。

## 核心功能与特性

- **默认Shell**：[zsh](https://www.zsh.org/)（集成[oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)）
- **预装实用工具**：[bat](https://github.com/sharkdp/bat)、[eza](https://github.com/eza-community/eza)、[fd](https://github.com/sharkdp/fd)、[jq](https://github.com/stedolan/jq)、[ripgrep](https://github.com/BurntSushi/ripgrep)等
- **字体配置**：
  - 无衬线字体：[Noto](https://notofonts.github.io)
  - 等宽字体：[Hack](https://github.com/ryanoasis/nerd-fonts)
  - 后备字体：[D2Coding](https://github.com/naver/d2codingfont)、[Noto CJK](https://github.com/googlefonts/noto-cjk)
  -  emoji字体：[Noto Emoji](https://github.com/googlefonts/noto-emoji)
- **韩语输入支持**：
  - 切换键：韩/英键
  - 输入异常时：点击左侧边栏按钮→设置→选择IME Input Mode
- **文件传输与音频**：支持文件上传/下载及声音输出
- **容器与权限**：内置Docker/Docker-compose支持，可通过sudo获取root权限
- **多架构兼容**：支持amd64/arm64，自动匹配部署服务器架构

## 支持的架构

支持amd64(x86-64)及arm64(aarch64)架构，采用多架构镜像设计，会根据下载服务器自动拉取对应架构版本。

当前基于Ubuntu Jammy (22.04)构建，计划年底评估切换至Noble (24.04)（因当前存在较多不兼容包）。

| 基础镜像 | 架构 |
| :------------------: | :----------: |
| Ubuntu Jammy (22.04) | amd64 |
| Ubuntu Jammy (22.04) | arm64 |

## 版本标签

所有镜像均基于Ubuntu KDE，提供以下标签：

| 标签 | 描述 |
| :----: | :------------: |
| latest | 最新构建版本 |
| yymmdd | 特定日期构建版本 |

## 容器部署

### 服务端口

服务通过以下端口提供访问：
- HTTP: http://yourhost:3000/
- HTTPS: https://yourhost:3001/

### 环境变量选项

#### 可选环境变量

| 变量 | 默认值 | 描述 |
| :---------------: | :-----------------: | --------------------------------------------------------------------------------------------------------------------------------- |
| CUSTOM_PORT | 3000 | HTTP端口 |
| CUSTOM_HTTPS_PORT | 3001 | HTTPS端口 |
| CUSTOM_USER | abc | HTTP Basic认证ID |
| PASSWORD | | HTTP Basic认证密码（输入时启用HTTP Basic认证） |
| SUBFOLDER | / | 反向代理子目录配置时使用的路径 |
| TITLE | KasmVNC Client | 浏览器标题显示文本 |
| START_DOCKER | true | 是否启用容器内Docker（Docker in Docker, DinD） |
| DRINODE | /dev/dri/renderD128 | 开源驱动GPU使用路径，参考[DRI3 GPU加速](https://www.kasmweb.com/kasmvnc/docs/master/gpu_acceleration.html) |
| DISABLE_IPV6 | false | 是否禁用IPv6 |
| DOCKER_MODS | | 额外Docker mods配置，参考[Docker mods](https://github.com/linuxserver/docker-mods) |
| RESET_HOME | false | 容器重启时是否重置家目录 |
| DESKTOP_ICONS | false | 是否在桌面显示图标 |
| TZ | Asia/Seoul | 时区 |
| LC_ALL | ko_KR.UTF-8 | 使用语言（如ko_KR.UTF-8、en_US.UTF-8等） |
| VIEW_ONLY | false | 是否启用只读模式 |
| RESIZE | remote | 缩放设置（off/scale/remote） |
| ENABLE_PERF_STATS | false | 是否显示性能信息 |
| ENABLE_WEBRTC | false | 是否启用WebRTC |
| ENABLE_WEBP | true | 是否启用WebP |
| ENABLE_IME | true | 是否启用IME输入 |
| ENABLE_HIDPI | false | 是否启用HiDPI |
| VIDEO_QUALITY | high | 流媒体质量预设（low/medium/high/extreme/lossless） |
| ANTI_ALIASING | dynamic | 抗锯齿设置（dynamic/on/off） |

#### 可选运行配置

| 类型 | 变量 | 必要 | 描述 |
| :--------: | :-------------------------------------------------: | :-------: | -------------------------------------------------------------- |
| 选项 | --privileged | ✅ | 启用容器内Docker（DinD）必需 |
| 选项 | --security_opt seccomp:unconfined | ✅ | 启用容器内Docker（DinD）必需 |
| 绑定挂载 | -v ./data:/config | ❌ | 将家目录挂载到主机目录 |
| 绑定挂载 | -v ./docker:/var/lib/docker | ❌ | 将DinD目录挂载到主机目录 |
| 绑定挂载 | -v /var/run/docker.sock:/var/run/docker.sock | ❌ | 需要控制主机Docker时配置 |
| 绑定挂载 | -v ./certificates:/usr/local/share/ca-certificates | ❌ | 需要添加私有证书时使用 |
| 绑定挂载 | -v /dev/shm:/dev/shm | ✅ | 共享主机内存以确保流畅运行 |
| 设备 | --device /dev/dri:/dev/dri | ✅ | 内部使用GPU时必需 |

### 使用方法

#### docker-compose配置

以下是docker-compose示例配置：

```yaml
---
version: '3.5'

services:
  webtop:
    image: docker.xuanyuan.run/raindev11/webtop:latest
    container_name: webtop
    hostname: webtop
    restart: unless-stopped
    privileged: true
    security_opt:
      - seccomp:unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - SUBFOLDER=/
      - TITLE=liveLinux
      - RESET_HOME=true
      - DESKTOP_ICONS=false
      - DISABLE_IPV6=true
      # HTTP Basic认证启用时配置ID/PW
      #- CUSTOM_USER=abc
      #- PASSWORD=abc
    volumes:
      - './data:/config'
      - './docker:/var/lib/docker'
      # 需要私有证书时启用
      #- './certificates:/usr/local/share/ca-certificates'
      # 不需要控制主机Docker时注释
      #- '/var/run/docker.sock:/var/run/docker.sock'
      # 共享主机内存
      - '/dev/shm:/dev/shm'
    ports:
      - 3000:3000
      - 3001:3001
    devices:
      - /dev/dri:/dev/dri
    networks:
      - private

networks:
  private:
    name: private
```

#### 反向代理配置（NPM/NGiNX）

- 基于非加密端口（3000）配置
- NPM需在`高级→自定义Nginx配置`中设置
- `proxy_pass http://webtop:3000;`适用于Nginx/NPM与容器同网络，不同网络时需改为`proxy_pass http://127.0.0.1:(主机映射端口);`

```
location / {
  proxy_http_version      1.1;
  proxy_set_header        Host $host;
  proxy_set_header        Upgrade $http_upgrade;
  proxy_set_header        Connection "upgrade";
  proxy_set_header        X-Real-IP $remote_addr;
  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Proto $scheme;
  proxy_set_header        Cookie "";
  proxy_read_timeout      3600s;
  proxy_send_timeout      3600s;
  add_header              'Access-Control-Allow-Origin' '*' always;
  add_header              'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
  add_header              'Access-Control-Allow-Headers' 'Authorization,Content-Type,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,Keep-Alive,X-Requested-With,If-Modified-Since';
  add_header              'Access-Control-Allow-Credentials' 'true';
  add_header              'Cross-Origin-Embedder-Policy' 'require-corp';
  add_header              'Cross-Origin-Opener-Policy' 'same-origin';
  add_header              'Cross-Origin-Resource-Policy' 'same-site';
  proxy_pass               http://webtop:3000;
  proxy_buffering          off;
}

location /websockify {
  proxy_http_version      1.1;
  proxy_set_header        Host $host;
  proxy_set_header        Upgrade $http_upgrade;
  proxy_set_header        Connection "upgrade";
  proxy_set_header        X-Real-IP $remote_addr;
  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Proto $scheme;
  proxy_set_header        Cookie "";
  proxy_read_timeout      3600s;
  proxy_send_timeout      3600s;
  add_header              'Access-Control-Allow-Origin' '*' always;
  add_header              'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
  add_header              'Access-Control-Allow-Headers' 'Authorization,Content-Type,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,Keep-Alive,X-Requested-With,If-Modified-Since';
  add_header              'Access-Control-Allow-Credentials' 'true';
  add_header              'Cross-Origin-Embedder-Policy' 'require-corp';
  add_header              'Cross-Origin-Opener-Policy' 'same-origin';
  add_header              'Cross-Origin-Resource-Policy' 'same-site';
  proxy_pass               http://webtop:3000;
  proxy_buffering          off;
}
```

## 预装GUI应用

| 项目 | 名称 | 初始设置内容 |
| :-----------: | :--------------: | :----------------------------------------------------------------: |
| 浏览器 | Brave | 应用韩语语言包，预装右键菜单拦截扩展 |
| 文本编辑器 | VSCode | 应用韩语语言包<br />预装Docker、Indent-rainbow、Typora扩展 |
| 办公软件 | LibreOffice | 预装StopBegging扩展 |
| 远程连接 | Remmina | 默认配置 |
| 虚拟化 | Docker/compose | |
| 网络工具 | Wireshark | 默认配置 |
| 文件管理器 | Double Commander | 默认配置 |
| 压缩工具 | Ark | |
| 视频播放器 | VLC | 默认配置 |
| 图片查看器 | Gwenview | 默认配置 |
| 屏幕录制 | OBS Studio | 默认配置 |
| 截图工具 | Spectacle | |

## 更新周期

安全及应用定期更新于每周日凌晨3点进行，不定期更新可能随时发布。

## 版本历史

- **24.07.28**： compositor从禁用改为启用（修复Brave浏览器右键菜单等方块显示问题）
- **24.05.26**： 将exa替换为eza
- **24.03.24**： 调整字体默认设置（子像素渲染：RGB， hinting：完全）
- **24.03.18**： 修复Brave浏览器首次启动错误
- **24.03.18**： 修复UID/GID非1000:1000时无法正常启动的问题
- **24.03.18**： 调整默认字体（Noto→D2Coding→Noto CJK）及字体优先级（从最高改为较低）
- **24.03.17**： 移除Pretendard字体
- **24.03.03**： 同步基础镜像变更（含配置选项更新）
- **23.10.29**： 支持通过环境变量配置KasmVNC初始设置
- **23.10.22**： 调整KasmVNC初始设置（启用WebP压缩、IME输入，默认流媒体质量设为高）
- **23.09.17**： 添加python pip
- **23.07.23**： 修复LibreOffice工具栏图标不显示问题
- **23.07.23**： 移除VSCode启动时的KDE Wallet弹窗
- **23.07.23**： 移除Terminal启动时的oh-my-zsh更新提示
- **23.06.10**： 添加RESET_HOME设置，将DESKTOP_ICONS值从1/0改为true/false
- **23.06.09**： 修复SUBFOLDER配置相关bug，添加证书安装逻辑
- **23.06.06**： 首次上传
