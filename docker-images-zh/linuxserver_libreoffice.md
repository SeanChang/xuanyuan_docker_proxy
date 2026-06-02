---
image: linuxserver/libreoffice
description: "LinuxServer.io 提供的 LibreOffice Docker 镜像，支持多架构，具备定期更新、用户映射和安全增强特性，可通过 Web 界面访问的免费办公套件。"
source: https://xuanyuan.cloud/zh/r/linuxserver/libreoffice
canonical: https://xuanyuan.cloud/zh/r/linuxserver/libreoffice
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/linuxserver/libreoffice" title="linuxserver/libreoffice Docker 镜像中文简介、标签列表与拉取命令">linuxserver/libreoffice 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LinuxServer.io LibreOffice 容器镜像

LinuxServer.io 团队提供的此容器镜像具有以下特点：

* 定期及时的应用更新
* 简单的用户映射（PGID、PUID）
* 带有 s6 overlay 的自定义基础镜像
* 每周基础 OS 更新，通过共享通用层最小化空间占用、停机时间和带宽
* 定期安全更新

## 关于镜像
[LibreOffice](https://www.libreoffice.org/) 是一款免费且功能强大的办公套件，是 OpenOffice.org 的继任者。其简洁界面和丰富工具可提升创造力与生产力。

## 支持的架构
| 架构 | 可用 | 标签 |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-<version tag> |
| arm64 | ✅ | arm64v8-<version tag> |

## 应用设置
可通过 https://yourhost:3001/ 访问应用。

### 安全注意事项
- 默认使用自签名证书，需通过 HTTPS 访问
- 建议在受信任网络使用，互联网暴露需配合反向代理（如 SWAG）
- 可选环境变量 `CUSTOM_USER` 和 `PASSWORD` 启用基本 HTTP 认证
- 包含具有无密码 sudo 权限的终端，需严格控制访问权限

### 功能配置
#### 语言支持
通过 `LC_ALL` 环境变量设置界面语言，例如：
- 中文: `-e LC_ALL=zh_CN.UTF-8`
- 日语: `-e LC_ALL=ja_JP.UTF-8`

#### GPU 加速
添加 `--device /dev/dri:/dev/dri` 参数可启用 DRI3 加速，支持 Intel、AMD 开源驱动及 nouveau 驱动。

#### 应用安装
- **持久化安装**：使用 `proot-apps install <应用名>` 命令
- **临时安装**：通过 universal-package-install mod 安装系统包

## 部署示例
### Docker Compose
```yaml
---
services:
  libreoffice:
    image: lscr.io/linuxserver/libreoffice:latest
    container_name: libreoffice
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - LC_ALL=zh_CN.UTF-8
    volumes:
      - /path/to/config:/config
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    restart: unless-stopped
```

### Docker CLI
```bash
docker run -d \
  --name=libreoffice \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/libreoffice:latest
```

## 参数说明
| 参数 | 功能 |
| :----: | --- |
| `-p 3000:3000` | HTTP 访问端口（需代理） |
| `-p 3001:3001` | HTTPS 访问端口 |
| `-e PUID/PGID` | 用户/组 ID 映射 |
| `-e TZ` | 时区设置（如 Asia/Shanghai） |
| `-v /config` | 配置文件存储路径 |
| `--shm-size` | 共享内存大小（建议 1GB 以上） |

## 安全与性能优化
- 老旧系统可能需要添加 `--security-opt seccomp=unconfined` 参数
- 生产环境建议使用反向代理并启用强认证
- 通过 `DRINODE` 环境变量可指定特定 GPU 设备

## 更新方法
### Docker Compose
```bash
docker-compose pull libreoffice
 docker-compose up -d libreoffice
```

### Docker CLI
```bash
docker pull lscr.io/linuxserver/libreoffice:latest
 docker stop libreoffice
 docker rm libreoffice
 # 重新运行初始 docker run 命令
```

## 版本历史
- **12.07.25:** 基于 Selkies 重构，Alpine 3.22，强制 HTTPS
- **18.03.23:** 迁移至 KasmVNC 基础镜像
- **05.04.21:** 初始发布
