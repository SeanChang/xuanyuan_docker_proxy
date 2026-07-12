---
image: snowdreamtech/dropbear
description: "Dropbear SSH服务器的Docker镜像，支持多种架构（amd64、arm32v5/v6/v7、arm64v8、i386、mips64le等），用于快速部署轻量级SSH服务。"
source: https://xuanyuan.cloud/zh/r/snowdreamtech/dropbear
canonical: https://xuanyuan.cloud/zh/r/snowdreamtech/dropbear
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/snowdreamtech/dropbear" title="snowdreamtech/dropbear Docker 镜像中文简介、标签列表与拉取命令">snowdreamtech/dropbear 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Dropbear Docker镜像文档

[![dockeri.co](https://dockerico.blankenship.io/image/snowdreamtech/dropbear)](https://hub.docker.com/r/snowdreamtech/dropbear)

Dropbear SSH服务器的Docker镜像打包，支持多种架构（amd64、arm32v5、arm32v6、arm32v7、arm64v8、i386、mips64le、ppc64le、riscv64、s390x），可快速部署轻量级SSH服务。

## 核心功能和特性

- **多架构支持**：兼容多种硬件架构，包括amd64、arm32v5、arm32v6、arm32v7、arm64v8、i386、mips64le、ppc64le、riscv64、s390x
- **轻量级SSH服务**：基于Dropbear实现，资源占用低，适合轻量级场景
- **简单配置**：通过环境变量即可完成基础配置，无需复杂设置
- **持久化存储**：支持通过卷挂载实现数据持久化
- **灵活部署**：支持Docker CLI和Docker Compose两种部署方式

## 使用场景和适用范围

- 开发环境中快速搭建SSH访问服务
- 测试环境中临时部署SSH服务
- 资源受限环境下需要轻量级SSH服务的场景
- 多架构设备（如嵌入式设备、ARM开发板）的SSH服务部署

## 使用方法和配置说明

### 环境变量

| 变量名 | 说明 | 示例 |
|--------|------|------|
| TZ | 设置容器时区 | Asia/Shanghai |

### Docker CLI部署

#### 基础部署

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  --restart unless-stopped \
  docker.xuanyuan.run/snowdreamtech/dropbear:latest
```

#### 高级部署（带数据持久化）

```bash
docker run -d \
  --name=dropbear \
  -e TZ=Asia/Shanghai \
  -p 22:22 \
  -v /path/to/data:/path/to/data \  # 挂载宿主机目录到容器，实现数据持久化
  --restart unless-stopped \
  snowdreamtech/dropbear:latest
```

### Docker Compose部署

#### 基础配置

```yaml
services:
  dropbear:
    image: docker.xuanyuan.run/snowdreamtech/dropbear:latest
    container_name: dropbear
    ports:
      - '22:22'  # 映射SSH端口
    environment:
      - TZ=Asia/Shanghai  # 设置时区
    restart: unless-stopped
```

#### 高级配置（带数据持久化）

```yaml
services:
  dropbear:
    image: docker.xuanyuan.run/snowdreamtech/dropbear:latest
    container_name: dropbear
    ports:
      - '22:22'
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /path/to/data:/path/to/data  # 卷挂载配置
    restart: unless-stopped
```

## 开发构建

构建多平台镜像命令：

```bash
docker buildx create --use --name build --node build --driver-opt network=host
docker buildx build -t snowdreamtech/dropbear --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x . --push
```

## 参考资料

1. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
2. [如何使用 docker buildx 构建跨平台 Go 镜像](https://waynerv.com/posts/building-multi-architecture-images-with-docker-buildx/#buildx-%E7%9A%84%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E7%AD%96%E7%95%A5)
3. [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
4. [How to Rapidly Build Multi-Architecture Images with Buildx](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/)
5. [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
6. [docker/buildx](https://github.com/docker/buildx)

## 联系方式（备注：dropbear）

- Email: <sn0wdr1am@qq.com>
- QQ: 3217680847
- QQ群: 949022145
- WeChat/微信群: sn0wdr1am

## 许可协议

MIT
