---
image: stainless403/mdcx-builtin-gui-base
description: "MDCx Docker镜像支持通过网页进行使用。"
source: https://xuanyuan.cloud/zh/r/stainless403/mdcx-builtin-gui-base
canonical: https://xuanyuan.cloud/zh/r/stainless403/mdcx-builtin-gui-base
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/stainless403/mdcx-builtin-gui-base" title="stainless403/mdcx-builtin-gui-base Docker 镜像中文简介、标签列表与拉取命令">stainless403/mdcx-builtin-gui-base 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# mdcx-builtin-gui-base 镜像文档


## 1. 镜像概述和主要用途

[stainless403/mdcx-builtin-gui-base](https://hub.docker.com/r/stainless403/mdcx-builtin-gui-base) 是基于 [jlesage/baseimage-gui](https://hub.docker.com/r/jlesage/baseimage-gui) 构建的专用镜像，适用于运行 Python+QT5 应用程序。该镜像内置预编译的 MDCx，可直接部署使用。其优点为轻量，缺点是仅支持通过网页查看应用界面，且不包含文件管理功能。


## 2. 核心功能和特性

### 核心功能
- 提供 Python+QT5 应用运行环境，兼容基于该技术栈的程序
- 内置编译完成的 MDCx，无需额外配置即可使用
- 通过网页端访问应用界面，无需本地安装图形化环境

### 特性
- **轻量级**：基于精简基础镜像构建，资源占用低
- **便捷部署**：支持脚本一键部署和手动部署两种方式
- **配置灵活**：通过环境变量自定义端口、分辨率、访问密码等参数
- **持久化存储**：支持数据、配置文件和日志目录的挂载


## 3. 使用场景和适用范围

### 适用场景
- 需要运行 Python+QT5 图形化应用（尤其是 MDCx）的轻量部署场景
- 无本地图形化界面环境，需通过网页远程访问应用的场景
- 对资源占用敏感，追求轻量化部署的用户

### 注意事项
- 不适合需要本地文件管理功能的场景
- 仅支持网页端访问，不支持 VNC 客户端直接连接（需通过网页）


## 4. 使用方法和配置说明

### 4.1 脚本部署（推荐）
通过官方脚本可快速完成部署，步骤如下：

1. 复制以下命令到终端执行，选择模板 `1) mdcx-builtin-gui-base`
2. 根据提示输入必要参数（如端口、密码等）

使用 curl：
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/northsea4/mdcx-docker/main/install.sh)"
```

使用 wget：
```bash
bash -c "$(wget https://raw.githubusercontent.com/northsea4/mdcx-docker/main/install.sh -O -)"
```

> **注意**：即使使用脚本部署，仍建议阅读以下手动部署细节，了解安全配置、更新方法等关键信息。


### 4.2 手动部署

#### 4.2.1 准备项目目录
1. 下载 [示例项目](https://github.com/northsea4/mdcx-docker/releases/download/latest/template-mdcx-builtin-gui-base.zip) 并解压至目标目录（假设目录名为 `mdcx-docker`）
2. 项目目录结构如下：
```
mdcx-docker/
├── data/               # 容器系统数据目录
├── mdcx-config/        # 应用配置文件目录
│   ├── config.ini      # 应用配置文件
│   └── MDCx.config     # 配置文件路径标记文件
├── logs/               # 应用日志目录
├── .env                # 环境变量配置文件
├── .env.sample         # 环境变量示例文件
├── .env.versions       # 应用版本文件
├── gui-base-builtin.sample.yml  # Docker Compose示例配置
└── docker-compose.yml  # Docker Compose配置文件
```

#### 4.2.2 配置环境变量（.env 文件）
编辑 `.env` 文件设置参数，关键参数说明如下：

| 参数名称         | 说明                                                                 | 默认值  | 必填 |
|------------------|----------------------------------------------------------------------|---------|------|
| VNC_PASSWORD     | 网页访问密码，公网部署建议设置，留空表示无需密码                     | 无      | 否   |
| WEB_PORT         | 网页访问端口（容器内固定5800，映射至宿主机的端口）                  | 5800    | 是   |
| VNC_PORT         | VNC监听端口（容器内固定5900，映射至宿主机的端口）                   | 5900    | 是   |
| USER_ID          | 运行应用的用户ID，可通过 `id -u` 命令获取当前用户ID                  | 0       | 是   |
| GROUP_ID         | 运行应用的用户组ID，可通过 `id -g` 命令获取当前用户组ID              | 0       | 是   |
| DISPLAY_WIDTH    | 应用窗口宽度                                                         | 1200    | 否   |
| DISPLAY_HEIGHT   | 应用窗口高度                                                         | 750     | 否   |

> 更多参数可参考 `.env.sample` 文件。

#### 4.2.3 Docker Compose 部署
1. 编辑项目目录中的 `docker-compose.yml` 文件，示例配置如下：
```yaml
version: '3'

services:
  mdcx:
    image: stainless403/mdcx-builtin-gui-base:${MDCX_BUILTIN_IMAGE_TAG}
    container_name: ${MDCX_CONTAINER_NAME}
    env_file:
      - .env
    volumes:
      - ./data:/config                  # 容器系统数据目录
      - ./mdcx-config:/mdcx-config      # 应用配置文件目录
      - ./mdcx-config/MDCx.config:/app/MDCx.config  # 配置文件路径标记
      - ./logs:/app/Log                 # 应用日志目录
      - /path/to/movies:/movies         # 影片目录（按需添加）
    ports:
      - ${WEB_PORT}:5800
      - ${VNC_PORT}:5900
    restart: unless-stopped
    network_mode: bridge
    stdin_open: true
```

2. 启动容器：
```bash
cd /path/to/mdcx-docker
docker-compose up -d
```

3. 查看容器日志（可选）：
```bash
docker-compose logs -f
# 或指定容器名称
docker logs -f mdcx_gui
```

#### 4.2.4 Docker Run 部署
直接使用 `docker run` 命令部署，需手动创建必要目录：

```bash
# 创建项目目录
MDCX_DOCKER_DIR=/path/to/mdcx-docker
mkdir -p $MDCX_DOCKER_DIR && cd $MDCX_DOCKER_DIR

# 创建必要子目录
mkdir -p mdcx-config logs data

# 创建配置文件路径标记文件
echo "/mdcx-config/config.ini" > mdcx-config/MDCx.config

# 创建空配置文件（如无现有配置）
touch mdcx-config/config.ini

# 启动容器
docker run -d --name mdcx \
  -p 5800:5800 `# 网页访问端口（宿主机:容器）` \
  -p 5900:5900 `# VNC端口（宿主机:容器）` \
  -v $(pwd)/data:/config `# 容器系统数据` \
  -v $(pwd)/mdcx-config:/mdcx-config `# 配置文件目录` \
  -v $(pwd)/mdcx-config/MDCx.config:/app/MDCx.config `# 配置文件路径标记` \
  -v $(pwd)/logs:/app/Log `# 日志目录` \
  -v /path/to/movies:/movies `# 影片目录（按需添加）` \
  -e TZ=Asia/Shanghai `# 时区设置` \
  -e DISPLAY_WIDTH=1200 `# 窗口宽度` \
  -e DISPLAY_HEIGHT=750 `# 窗口高度` \
  -e VNC_PASSWORD=your_password `# 访问密码（可选）` \
  -e USER_ID=$(id -u) `# 当前用户ID` \
  -e GROUP_ID=$(id -g) `# 当前用户组ID` \
  --restart unless-stopped \
  stainless403/mdcx-builtin-gui-base:latest
```

### 4.3 访问应用
容器启动后，通过以下地址访问应用界面：  
`http://服务器IP:WEB_PORT`  

示例：若服务器IP为 `192.168.1.100`，且 `WEB_PORT` 设为默认 `5800`，则访问地址为 `http://192.168.1.100:5800`。


## 5. 容器更新

### 5.1 Docker Compose 方式更新
适用于通过 Docker Compose 部署的场景：
```bash
cd /path/to/mdcx-docker
docker-compose pull
docker-compose up -d
```

### 5.2 Docker Run 方式更新（使用 watchtower）
通过 `watchtower` 工具更新容器，支持一次性更新或定时更新。

#### 一次性更新
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once \
  mdcx  # 容器名称（需与启动时--name一致）
```

#### 定时更新（谨慎使用）
设置每天凌晨2点自动更新：
```bash
docker run -d --name watchtower-mdcx \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  -c --schedule "0 0 2 * * *" mdcx  # 容器名称
```
> **注意**：自动更新可能导致配置或数据异常，建议手动更新。

#### 取消定时更新
```bash
docker rm -f watchtower-mdcx
```


## 6. 注意事项

- **安全提示**：公网部署时务必设置 `VNC_PASSWORD`，避免未授权访问。
- **数据备份**：定期备份 `mdcx-config` 和 `data` 目录，防止配置丢失。
- **镜像选择**：如需使用本地 MDCx 源码，应选择 `stainless403/mdcx-src-gui-base` 镜像（详见 [官方文档](https://github.com/northsea4/mdcx-docker/blob/main/gui-base/mdcx-src.md)）。
- **版本更新**：通过 `docker-compose pull` 或 `watchtower` 更新镜像时，建议先查看官方更新日志，确认兼容性。
