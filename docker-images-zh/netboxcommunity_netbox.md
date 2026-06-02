---
image: netboxcommunity/netbox
description: "社区维护的Netbox Docker镜像，用于便捷部署和运行开源IP地址管理（IPAM）与数据中心基础设施管理（DCIM）工具。"
source: https://xuanyuan.cloud/zh/r/netboxcommunity/netbox
canonical: https://xuanyuan.cloud/zh/r/netboxcommunity/netbox
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [netboxcommunity/netbox — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/netboxcommunity/netbox)

含镜像标签、拉取命令、部署文档与相关推荐。

[netboxcommunity/netbox Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/netboxcommunity/netbox)

# netbox-docker

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/netbox-community/netbox-docker)][github-release]
[![GitHub stars](https://img.shields.io/github/stars/netbox-community/netbox-docker)][github-stargazers]
![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed-raw/netbox-community/netbox-docker)
![Github release workflow](https://img.shields.io/github/actions/workflow/status/netbox-community/netbox-docker/release.yml?branch=release)
![Docker Pulls](https://img.shields.io/docker/pulls/netboxcommunity/netbox)
[![GitHub license](https://img.shields.io/github/license/netbox-community/netbox-docker)][netbox-docker-license]

## 镜像概述和主要用途

netbox-docker是社区维护的NetBox Docker镜像项目，包含构建NetBox容器所需的全部组件。镜像通过自动化流程定期构建，并发布至Docker Hub、Quay.io和GitHub Container Registry三大容器仓库。该项目旨在简化NetBox的容器化部署流程，提供稳定、可扩展的网络自动化平台运行环境。

## 核心功能和特性

- **版本同步机制**：镜像标签与NetBox官方版本严格对应，确保功能兼容性
- **自动化构建**：每24小时自动构建更新，保持与NetBox上游版本同步
- **多仓库分发**：同时发布至Docker Hub、Quay.io和GitHub Container Registry，支持多平台部署
- **灵活标签策略**：提供特定版本、最新稳定版和预发布版等多种标签，满足不同环境需求
- **简化部署流程**：内置docker-compose配置模板，支持一键启动和自定义扩展
- **完整测试覆盖**：集成NetBox单元测试和初始化验证流程，确保镜像可用性

## 使用场景和适用范围

- **生产环境部署**：适用于企业级网络自动化平台的容器化部署，提供稳定运行环境
- **开发测试环境**：支持快速搭建隔离的NetBox实例，用于功能验证和插件开发
- **CI/CD集成**：可作为网络自动化流水线的测试环境组件，实现配置验证自动化
- **教学演示**：简化NetBox功能展示和培训环境搭建流程
- **容器编排环境**：兼容Docker Compose、Kubernetes等主流容器编排平台

## 快速启动指南

以下命令可快速启动netbox-docker，完整步骤参考[Wiki入门指南][wiki-getting-started]：

```bash
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF
docker compose pull
docker compose up
```

应用启动约需几分钟，通过`http://0.0.0.0:8000/`访问NetBox首页。执行以下命令创建管理员用户：

```bash
docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser
```

如需频繁从零初始化数据库，可在`docker-compose.override.yml`中配置`SUPERUSER_*`环境变量自动创建超级用户。

[wiki-getting-started]: https://github.com/netbox-community/netbox-docker/wiki/Getting-Started

## 容器镜像标签说明

### 主要标签类型

> **生产环境建议使用`vX.Y.Z-a.b.c`或`vX.Y-a.b.c`标签**

- **`vX.Y.Z-a.b.c`、`vX.Y-a.b.c`**  
  发布版本镜像，包含NetBox版本`vX.Y.Z`和netbox-docker支持文件版本`a.b.c`。需配合对应版本的netbox-docker代码使用以确保兼容性，基于NetBox官方[发布版本][netbox-releases]构建。

- **`latest-a.b.c`**  
  最新稳定版镜像，包含NetBox最新稳定版和netbox-docker支持文件版本`a.b.c`。需配合对应版本的netbox-docker代码使用，基于NetBox[`master`分支][netbox-master]构建。

- **`snapshot-a.b.c`**  
  预发布测试镜像，包含netbox-docker支持文件版本`a.b.c`。需配合对应版本的netbox-docker代码使用，基于NetBox[`develop`分支][netbox-develop]构建。

### 简写标签

以下标签自动指向对应类型的最新netbox-docker版本：

- `vX.Y.Z`、`vX.Y`：对应`vX.Y.Z-a.b.c`/`vX.Y-a.b.c`的最新版本
- `latest`：对应`latest-a.b.c`的最新版本
- `snapshot`：对应`snapshot-a.b.c`的最新版本

[netbox-releases]: https://github.com/netbox-community/netbox/releases
[netbox-master]: https://github.com/netbox-community/netbox/tree/master
[netbox-develop]: https://github.com/netbox-community/netbox/tree/develop

## 详细部署配置

### Docker Compose部署

#### 基础配置

项目默认提供完整的docker-compose配置，通过`docker-compose.override.yml`实现自定义配置，常用自定义项包括：

- 端口映射
- 环境变量设置
- 持久化存储配置
- 网络参数调整

#### 环境变量配置

关键环境变量说明：

| 变量名 | 描述 | 示例值 |
|--------|------|--------|
| `SUPERUSER_USERNAME` | 自动创建的超级用户名 | `admin` |
| `SUPERUSER_PASSWORD` | 超级用户密码 | `securepassword` |
| `SUPERUSER_EMAIL` | 超级用户邮箱 | `admin@example.com` |
| `ALLOWED_HOSTS` | 允许访问的主机名列表 | `["netbox.example.com", "localhost"]` |
| `DATABASE_URL` | 数据库连接URL | `postgres://user:pass@db:5432/netbox` |

#### 高级配置示例

自定义端口、环境变量和持久化存储的`docker-compose.override.yml`示例：

```yaml
version: '3.4'
services:
  netbox:
    ports:
      - "8080:8080"  # 主机端口8080映射到容器端口8080
    environment:
      - SUPERUSER_USERNAME=admin
      - SUPERUSER_PASSWORD=Netbox123!
      - SUPERUSER_EMAIL=admin@example.com
      - ALLOWED_HOSTS=["netbox.example.com"]
    volumes:
      - ./netbox-data:/opt/netbox/netbox/media  # 持久化媒体文件
  db:
    volumes:
      - ./postgres-data:/var/lib/postgresql/data  # 持久化数据库数据
```

更多高级配置（TLS配置、LDAP集成、监控等）参考[项目Wiki][netbox-docker-wiki]。

[netbox-docker-wiki]: https://github.com/netbox-community/netbox-docker/wiki/

## 依赖要求

部署环境需满足以下版本要求：

- Docker版本 ≥ 20.10.10
- containerd版本 ≥ 1.5.6
- docker-compose版本 ≥ 1.28.0

验证本地版本：

```bash
docker --version          # 检查Docker版本
docker compose version    # 检查docker-compose版本
```

## 更新与维护

更新镜像前请仔细阅读[发布说明][releases]，确保NetBox Docker镜像版本与代码版本同步。首次更新请遵循Wiki中的[更新指南][netbox-docker-wiki-updating]。

[releases]: https://github.com/netbox-community/netbox-docker/releases
[netbox-docker-wiki-updating]: https://github.com/netbox-community/netbox-docker/wiki/Updating

## 镜像重建

使用`./build.sh`脚本自定义重建镜像，执行`./build.sh --help`查看参数说明：

```bash
./build.sh --version v3.5.0  # 构建特定版本镜像
```

自定义构建详情参考[Wiki构建指南][netbox-docker-wiki-build]。

[netbox-docker-wiki-build]: https://github.com/netbox-community/netbox-docker/wiki/Build

## 测试

测试脚本用于验证镜像功能，包括NetBox单元测试和初始化流程检查：

```bash
IMAGE=netboxcommunity/netbox:latest ./test.sh
```

## 支持与社区

netbox-docker由社区维护，获取支持的渠道：

- **Slack**：加入[NetDev社区Slack][netbox-docker-slack]，在`#netbox-docker`频道提问
- **GitHub讨论区**：在[项目讨论区][netbox-community]交流
- **贡献与赞助**：通过GitHub Sponsors支持项目维护者

[netbox-docker-slack]: https://join.slack.com/t/netdev-community/shared_invite/zt-mtts8g0n-Sm6Wutn62q_M4OdsaIycrQ
[netbox-community]: https://github.com/netbox-community/netbox-docker/discussions
[github-stargazers]: https://github.com/netbox-community/netbox-docker/stargazers
[github-release]: https://github.com/netbox-community/netbox-docker/releases
[netbox-dockerhub]: https://hub.docker.com/r/netboxcommunity/netbox/
[netbox-quayio]: https://quay.io/repository/netboxcommunity/netbox
[netbox-ghcr]: https://github.com/netbox-community/netbox-docker/pkgs/container/netbox
[netbox-docker-github]: https://github.com/netbox-community/netbox-docker/
[netbox-docker-slack-channel]: https://netdev-community.slack.com/archives/C01P0GEVBU7
[netbox-slack-channel]: https://netdev-community.slack.com/archives/C01P0FRSXRV
[netbox-docker-license]: https://github.com/netbox-community/netbox-docker/blob/release/LICENSE
