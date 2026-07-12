---
image: snowdreamtech/aria2
description: "用于Aria2的Docker镜像，支持多架构（如amd64、arm64等），提供命令行及Web界面（AriaNG、WebUI）部署方式，可自动生成RPC密钥，方便管理下载任务。"
source: https://xuanyuan.cloud/zh/r/snowdreamtech/aria2
canonical: https://xuanyuan.cloud/zh/r/snowdreamtech/aria2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/snowdreamtech/aria2" title="snowdreamtech/aria2 Docker 镜像中文简介、标签列表与拉取命令">snowdreamtech/aria2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Aria2 Docker镜像

[![dockeri.co](https://dockerico.blankenship.io/image/snowdreamtech/aria2)](https://hub.docker.com/r/snowdreamtech/aria2)

Aria2的Docker镜像打包，支持多架构（amd64、arm32v5、arm32v6、arm32v7、arm64v8、i386、mips64le、ppc64le、riscv64、s390x）。

[README](README.md) | [中文文档](README.zh-CN.md)

# 用途

为帮助您基于此镜像创建容器，您可以使用docker-compose或docker命令行工具。

## Docker命令行

若未设置`RPC_SECRET`，镜像将自动生成该密钥，您可在Docker容器日志中查看。

### Aria2命令行模式

```bash
docker run -d \
  --name=aria2 \
  -e TZ=Asia/Shanghai \  # 设置时区为亚洲/上海
  -p 6800:6800 \         # Aria2 RPC端口
  -p 6881-6999:6881-6999 \  # BT监听端口范围
  -v ./downloads:/var/lib/aria2/downloads \  # 挂载下载目录到本地
  --restart unless-stopped \  # 除非手动停止，否则总是重启
  snowdreamtech/aria2:latest
# 也可使用 alpine 版本：snowdreamtech/aria2:alpine
# 或 debian 版本：snowdreamtech/aria2:debian
```

### Aria2集成[AriaNG](https://github.com/mayswind/AriaNg)

```bash
docker run -d \
  --name=aria2 \
  -e TZ=Asia/Shanghai \  # 设置时区为亚洲/上海
  -p 80:80 \             # Web界面HTTP端口
  -p 443:443 \           # Web界面HTTPS端口
  -p 6800:6800 \         # Aria2 RPC端口
  -p 6881-6999:6881-6999 \  # BT监听端口范围
  -v ./downloads:/var/lib/aria2/downloads \  # 挂载下载目录到本地
  --restart unless-stopped \  # 除非手动停止，否则总是重启
  snowdreamtech/aria2:ariang
# 也可使用 alpine 版本：snowdreamtech/aria2:ariang-alpine
# 或 debian 版本：snowdreamtech/aria2:ariang-debian
```

### Aria2集成[WebUI](https://github.com/ziahamza/webui-aria2)

```bash
docker run -d \
  --name=aria2 \
  -e TZ=Asia/Shanghai \  # 设置时区为亚洲/上海
  -p 80:80 \             # Web界面HTTP端口
  -p 443:443 \           # Web界面HTTPS端口
  -p 6800:6800 \         # Aria2 RPC端口
  -p 6881-6999:6881-6999 \  # BT监听端口范围
  -v ./downloads:/var/lib/aria2/downloads \  # 挂载下载目录到本地
  --restart unless-stopped \  # 除非手动停止，否则总是重启
  snowdreamtech/aria2:webui
# 也可使用 alpine 版本：snowdreamtech/aria2:webui-alpine
# 或 debian 版本：snowdreamtech/aria2:webui-debian
```

# 开发

```bash
# 创建并使用buildx构建器
docker buildx create --use --name build --node build --driver-opt network=host
# 构建并推送多平台镜像
docker buildx build -t snowdreamtech/aria2 --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x . --push
```

## 参考资料

1. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
1. [如何使用 docker buildx 构建跨平台 Go 镜像](https://waynerv.com/posts/building-multi-architecture-images-with-docker-buildx/#buildx-%E7%9A%84%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E7%AD%96%E7%95%A5)
1. [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
1. [How to Rapidly Build Multi-Architecture Images with Buildx](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/)
1. [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
1. [docker/buildx](https://github.com/docker/buildx)

## 联系方式（备注：aria2）

* 邮箱：sn0wdr1am@qq.com
* QQ：3217680847
* QQ群：949022145
* 微信/微信群：sn0wdr1am

## 许可证

MIT
