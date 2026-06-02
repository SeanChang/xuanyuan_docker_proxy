---
image: hanxi/xiaomusic
description: "Xiaomusic 是一款基于命令行的网易云音乐第三方客户端，采用 Python 开发，支持跨平台运行，提供音乐播放、歌曲搜索、歌单管理、收藏同步及实时歌词显示等功能，界面简洁轻量，无需图形界面即可便捷使用，开源免费且持续更新，旨在为用户提供高效纯粹的音乐聆听体验。"
source: https://xuanyuan.cloud/zh/r/hanxi/xiaomusic
canonical: https://xuanyuan.cloud/zh/r/hanxi/xiaomusic
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [hanxi/xiaomusic — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/hanxi/xiaomusic)

含镜像标签、拉取命令、部署文档与相关推荐。

[hanxi/xiaomusic Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/hanxi/xiaomusic)

# XiaoMusic：让小爱音箱自由播放音乐  

XiaoMusic 是一款可让小爱音箱播放音乐的工具，通过 yt-dlp 下载音乐资源，支持本地音乐管理与网络歌单，兼容多种小爱音箱型号。项目开源地址：< 核心功能  
- 小爱音箱语音控制播放音乐（本地/网络资源）  
- 支持通过 yt-dlp 下载音乐并存储到本地  
- Web 页面配置参数，简化操作流程  
- 兼容多种小爱音箱型号及主流音乐格式  


## 安装步骤  

### 初次使用提示  
若遇到安装问题，可先查阅 [FAQ 问题集合]()，常见问题已有解决方案。  


### Docker 方式（推荐）  
支持 Linux、NAS 等环境，通过容器快速部署，包含国内镜像加速。  

#### 基础启动命令（适用于海外）  
```bash
docker run -p 58090:8090 -e XIAOMUSIC_PUBLIC_PORT=58090 \
  -v /xiaomusic_music:/app/music -v /xiaomusic_conf:/app/conf \
  
```  

#### 国内镜像（访问）  
```bash
docker run -p 58090:8090 -e XIAOMUSIC_PUBLIC_PORT=58090 \
  -v /xiaomusic_music:/app/music -v /xiaomusic_conf:/app/conf \
  docker.hanxi.cc/
```  

#### Docker Compose 配置  
创建 `docker-compose.yml` 文件，内容如下（国内用户替换 `image` 为国内镜像）：  
```yaml
services:
  xiaomusic:
    image:   # 国内替换为 docker.hanxi.cc/
    container_name: xiaomusic
    restart: unless-stopped
    ports:
      - 58090:8090
    environment:
      XIAOMUSIC_PUBLIC_PORT: 58090  # 本地访问端口
    volumes:
      - /xiaomusic_music:/app/music  # 主机音乐存储目录（可自定义）
      - /xiaomusic_conf:/app/conf    # 主机配置文件目录（可自定义）
```  
启动命令：`docker-compose up -d`  


### 参数说明  
- **目录映射**：`/xiaomusic_music` 和 `/xiaomusic_conf` 是主机目录，需提前创建（命令：`mkdir -p /xiaomusic_{music,conf}`）；`/app/music` 和 `/app/conf` 是容器内部目录，不可修改。  
- **端口配置**：`58090` 是本地访问端口，`8090` 是容器端口，不可修改。  
- **Web 访问**：启动后通过 `[] 进入配置页面，首次需填写小米账号密码以获取设备列表。  


### pip 方式安装（适用于 Python 环境）  
```bash
# 安装/更新
pip install -U xiaomusic

# 查看帮助
xiaomusic --help

# 启动（默认端口 8090，配置文件参考 config-example.json）
xiaomusic --config config.json
```  


## 使用指南  

### 语音口令控制  
通过小爱音箱语音指令操作，支持以下口令：  
- **播放控制**：播放歌曲、上一首、下一首、单曲循环、全部循环、随机播放、停止播放  
- **歌曲搜索**：播放歌曲+歌名（如“播放歌曲周杰伦晴天”）、搜索播放+关键词（如“搜索播放林俊杰”）  
- **歌单管理**：播放列表+列表名（如“播放列表收藏”）、加入收藏、取消收藏、刷新列表  
- **隐藏功能**：播放“小猪佩奇的故事”等内容时，工具会自动下载并播放  


### 支持设备与音乐格式  
#### 兼容设备  
已测试支持多种小爱音箱型号，包括：  
- 经典款：小爱音箱（L06A）、Redmi 小爱音箱 Play（L07A）、小米 AI 音箱（S12）等  
- 触屏款：LX04、X10A、X08A 等（部分需开启“型号兼容模式”）  
- 其他型号：可通过 [型号查询页面]([]) 确认，或反馈至项目 Issues 添加支持。  

#### 音乐格式  
- **本地音乐**：支持 mp3、flac、wav、ape、ogg、m4a  
- **下载音乐**：默认 mp3 格式  
- **注意**：部分设备（如 L05B、LX06）不支持 flac，可开启“转换为 MP3”选项解决。  


### 高级功能  
- **网络歌单**：支持导入 JSON 格式歌单或通过工具转换 m3u 文件（详见 [网络歌单文档]()）  
- **自定义配置**：更多参数（如下载音质、口令自定义）可在 Web 页面或配置文件中调整（详见 [可选配置]()）  


## 安全提醒  
- **公网访问风险**：若配置公网访问，务必开启密码登录并使用复杂密码，避免账号信息泄露。  
- **账号安全**：不建议将小爱音箱绑定的小米账号关联摄像头等敏感设备。  


## 交流与支持  
- **讨论渠道**：QQ 群（604526973、1021062499）、QQ 频道 [xiaomusic]([])  
- **安装帮助**：若安装困难，可联系作者远程协助（需支付 50 元辛苦费，周末及晚间提供服务）  
- **相关工具**：配套工具推荐：[tiny-nav（NAS 导航工具）]([])、[epub2mp3（听书工具）]([])  


## 免责声明  
本项目仅供学习研究使用，不得用于商业用途。用户需遵守当地法律法规，自行承担使用风险（包括但不限于设备损坏、账号封禁等）。项目及作者对违法使用导致的后果不承担责任。
