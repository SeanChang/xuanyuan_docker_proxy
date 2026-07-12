---
image: arm64v8/alpine
description: "基于Alpine Linux的最小化Docker镜像，包含完整包索引且体积仅5MB。"
source: https://xuanyuan.cloud/zh/r/arm64v8/alpine
canonical: https://xuanyuan.cloud/zh/r/arm64v8/alpine
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/arm64v8/alpine" title="arm64v8/alpine Docker 镜像中文简介、标签列表与拉取命令">arm64v8/alpine 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# arm64v8/alpine Docker镜像文档


## 镜像概述

`arm64v8/alpine` 是基于 Alpine Linux 的极小 Docker 镜像，专为 arm64v8 架构优化。Alpine Linux 是一款围绕 `musl libc` 和 `BusyBox` 构建的轻量级 Linux 发行版，该镜像体积仅 5MB，同时提供完整的包索引，是构建轻量级应用的理想基础镜像。


## 核心功能与特性

### 极小体积
- 镜像大小仅 5MB，显著降低存储和网络传输开销。

### 精简组件
- 基于 `musl libc`（轻量级 C 标准库）和 `BusyBox`（集成核心 Unix 工具），减少冗余依赖。

### 完整包管理
- 内置 `apk` 包管理器，可访问 [Alpine 包仓库](https://pkgs.alpinelinux.org/)，提供丰富的预编译软件包。

### 架构支持
- 专为 `arm64v8` 架构优化，同时 Alpine 官方镜像支持多架构（如 `amd64`、`arm32v6`、`ppc64le` 等，各架构有独立仓库）。


## 适用场景

### 轻量级工具与实用程序
作为基础镜像构建小型 CLI 工具、脚本运行环境等。

### 微服务基础镜像
适用于微服务架构，减少容器启动时间和资源占用。

### 生产环境应用
可作为生产级应用的基础（需确保应用兼容 `musl libc`），尤其适合资源受限场景。

### CI/CD 流水线
在持续集成/部署流程中作为临时任务环境，降低环境准备时间。

### 边缘设备部署
适合边缘计算场景，满足低存储、低内存环境需求。


## 支持的标签及 Dockerfile 链接

| 标签                          | 对应 Dockerfile 链接                                                                 |
|-------------------------------|-------------------------------------------------------------------------------------|
| `20250108`, `edge`            | [Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/c1f1de232c970df2285c03050ab3747b8563164f/aarch64/Dockerfile) |
| `3.22.2`, `3.22`, `3`, `latest` | [Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/4dc13cbc7caffe03c98aa99f28e27c2fb6f7e74d/aarch64/Dockerfile) |
| `3.21.5`, `3.21`              | [Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/2c30d5daeebb5090b1b6363a9e97dd88bf08a642/aarch64/Dockerfile) |
| `3.20.8`, `3.20`              | [Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/f5ce8f036ef8a57481ae6f3f1cf7f2300cff8d29/aarch64/Dockerfile) |
| `3.19.9`, `3.19`              | [Dockerfile](https://github.com/alpinelinux/docker-alpine/blob/ee939d52345248420cf62d4606ccc7152bc5a107/aarch64/Dockerfile) |


## 使用方法

### 基础用法

#### 作为 Dockerfile 基础镜像
直接在 `Dockerfile` 中引用该镜像，通过 `apk` 安装所需依赖：
```dockerfile
# 使用指定版本（推荐生产环境）
FROM docker.xuanyuan.run/arm64v8/alpine:3.22.2

# 安装示例：安装 mysql-client
RUN apk add --no-cache mysql-client

# 设置入口命令
ENTRYPOINT ["mysql"]
```
**镜像体积对比**：上述示例构建的镜像体积约 36.8MB，而基于 Ubuntu 20.04 的同类镜像体积约 145MB。


#### 交互式运行
通过 `docker run` 启动交互式 shell，用于临时测试或调试：
```bash
docker run -it --rm docker.xuanyuan.run/arm64v8/alpine:latest sh
```
- `-it`：启用交互式终端
- `--rm`：退出后自动删除容器
- `sh`：Alpine 默认 shell（BusyBox 提供）


#### docker-compose 配置示例
在 `docker-compose.yml` 中使用该镜像作为服务基础：
```yaml
version: '3'
services:
  app:
    image: docker.xuanyuan.run/arm64v8/alpine:3.22
    command: sh -c "apk add --no-cache curl && curl https://example.com"
```


### 包管理配置
Alpine 通过 `apk` 工具管理软件包，常用命令如下：

| 命令                  | 说明                                  |
|-----------------------|---------------------------------------|
| `apk update`          | 更新本地包索引缓存（建议安装前执行）   |
| `apk add --no-cache <pkg>` | 安装指定包，`--no-cache` 避免缓存索引 |
| `apk del <pkg>`       | 卸载指定包                            |
| `apk search <keyword>` | 搜索包仓库中的包                      |
| `apk info <pkg>`      | 查看已安装包的详细信息                |

**最佳实践**：安装包时始终使用 `--no-cache`，避免缓存占用镜像空间（如 `RUN apk add --no-cache python3`）。


## 补充信息

### 维护者
由 Alpine Linux 维护者 [Natanael Copa](https://github.com/alpinelinux/docker-alpine) 维护。

### 支持渠道
- Docker 社区 Slack：[https://dockr.ly/comm-slack](https://dockr.ly/comm-slack)
- Server Fault：[https://serverfault.com/help/on-topic](https://serverfault.com/help/on-topic)
- Unix & Linux Stack Exchange：[https://unix.stackexchange.com/help/on-topic](https://unix.stackexchange.com/help/on-topic)
- Stack Overflow：[https://stackoverflow.com/help/on-topic](https://stackoverflow.com/help/on-topic)


## 许可证

### 软件许可证
镜像中包含的软件（如 Alpine Linux 组件、`musl libc`、`BusyBox` 等）许可证信息可通过 [Alpine 包仓库](https://pkgs.alpinelinux.org) 查询。

### 镜像使用责任
Docker 镜像可能包含第三方软件，其许可证可能与基础软件不同。用户需自行确保对镜像的使用符合所有包含软件的许可证要求。更多自动检测的许可证信息可参考 [repo-info 仓库的 alpine 目录](https://github.com/docker-library/repo-info/tree/master/repos/alpine)。
