---
image: shinsenter/matomo
description: "生产就绪的PHP/Matomo Docker镜像，包含自动Matomo开源安装程序，支持通过环境变量轻松配置PHP和PHP-FPM设置，无需重建镜像即可修改配置，适用于快速部署Matomo分析平台。"
source: https://xuanyuan.cloud/zh/r/shinsenter/matomo
canonical: https://xuanyuan.cloud/zh/r/shinsenter/matomo
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/shinsenter/matomo" title="shinsenter/matomo Docker 镜像中文简介、标签列表与拉取命令">shinsenter/matomo 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# shinsenter/matomo

## 镜像概述和主要用途

shinsenter/matomo是生产就绪的PHP/Matomo Docker镜像，内置自动Matomo开源安装程序。基于shinsenter/php镜像构建，支持通过环境变量轻松配置PHP和PHP-FPM设置，无需重建镜像即可修改配置。镜像包含最新版本的Composer，便于快速启动项目，提供Debian和Alpine两种基础操作系统版本选择，适合快速部署Matomo分析平台。

## 核心功能和特性

- **灵活配置**：通过环境变量配置PHP和PHP-FPM设置，无需重建镜像
- **快速启动**：内置最新Composer，无需额外安装即可开始项目
- **双版本支持**：提供Debian和Alpine两种基础操作系统版本
- **自动引导**：挂载空目录时自动下载Matomo源代码，快速创建新项目
- **HTTPS支持**：内置测试SSL证书，可替换为生产环境证书
- **持续更新**：每日构建确保包含PHP、基础系统、Composer等最新上游更新
- **兼容性强**：支持挂载现有项目代码目录，适用于开发和生产环境

## 使用场景和适用范围

- **新项目部署**：快速引导Matomo项目，自动完成源代码下载和初始化
- **现有项目迁移**：直接挂载现有Matomo代码目录，保持开发工作流
- **开发环境**：实时反映代码变更，灵活调整PHP配置参数
- **生产环境**：提供稳定镜像标签方案，确保部署一致性和安全性
- **需要HTTPS的场景**：支持自定义SSL证书，满足生产环境安全要求

## 详细的使用方法和配置说明

### 创建新项目

当挂载空目录到容器时，镜像会自动下载Matomo完整源代码，快速引导新项目。

#### 操作步骤

1. 在主机创建空目录：
```shell
mkdir matomo
```

2. 运行容器并挂载目录：
```shell
docker run -p 80:80 -p 443:443 -p 443:443/udp \
    -v ./matomo:/var/www/html \
    docker.xuanyuan.run/shinsenter/matomo:latest
```

容器会检测空目录并自动克隆Matomo源代码到`/var/www/html`目录。

### 使用现有项目

直接挂载现有Matomo项目代码目录到容器的`/var/www/html`路径，主机代码变更会实时反映到容器内，便于在容器中运行构建和测试任务。

### 配置HTTPS

镜像内置测试SSL证书（位于`/etc/ssl/site/server.crt`和`/etc/ssl/site/server.key`），生产环境可替换为自定义证书。

#### 使用Dockerfile替换证书
```Dockerfile
FROM docker.xuanyuan.run/shinsenter/matomo:latest

# 复制自定义证书
COPY my_domain.crt /etc/ssl/site/server.crt
COPY my_domain.key /etc/ssl/site/server.key

# 可选：添加项目文件
# ADD --chown=$APP_USER:$APP_GROUP ./matomo/ /var/www/html/
```

#### 使用docker run替换证书
```shell
docker run -p 80:80 -p 443:443 -p 443:443/udp \
    -v ./matomo:/var/www/html \
    -v ./my_domain.crt:/etc/ssl/site/server.crt \
    -v ./my_domain.key:/etc/ssl/site/server.key \
    docker.xuanyuan.run/shinsenter/matomo:latest
```

#### 使用docker-compose替换证书
```yml
services:
  web:
    image: docker.xuanyuan.run/shinsenter/matomo:latest
    volumes:
      - ./matomo:/var/www/html
      - ./my_domain.crt:/etc/ssl/site/server.crt
      - ./my_domain.key:/etc/ssl/site/server.key
```

### 稳定镜像标签

由于每日构建会更新相同标签的镜像，建议为生产环境创建稳定标签：

```shell
# 拉取最新镜像
docker pull docker.xuanyuan.run/shinsenter/matomo:latest
# 标记为稳定版本
docker tag  shinsenter/matomo:latest your-repo/matomo:stable
# 推送到私有仓库
docker push your-repo/matomo:stable
```

使用`your-repo/matomo:stable`作为生产环境基础镜像，确保部署一致性。

## 贡献

如发现镜像有用，可通过[PayPal](https://www.paypal.me/shinsenter)捐赠，或在[GitHub](https://code.shin.company/php/issues/new)提交issue。您的支持有助于维护和改进这些社区镜像。

## 许可协议

本项目基于[GNU General Public License v3.0](https://code.shin.company/php/blob/main/LICENSE)许可。感谢您认可本项目的智力成果，如使用或借鉴其理念，请给予适当引用。

---

来自越南 🇻🇳 的爱。
