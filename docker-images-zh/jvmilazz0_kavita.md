---
image: jvmilazz0/kavita
description: "Kavita是一款快速、功能丰富的跨平台阅读服务器。"
source: https://xuanyuan.cloud/zh/r/jvmilazz0/kavita
canonical: https://xuanyuan.cloud/zh/r/jvmilazz0/kavita
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jvmilazz0/kavita" title="jvmilazz0/kavita Docker 镜像中文简介、标签列表与拉取命令">jvmilazz0/kavita 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Kavita Docker镜像文档

## 镜像概述和主要用途

Kavita 是一款免费开源的基于 Web 的漫画和图书服务器，旨在提供快速、功能丰富的跨平台阅读体验。用户可通过 Web 浏览器访问服务器，实现漫画、图书的集中管理与在线阅读。该项目由 majora2007 开发，官方代码仓库托管于 [GitHub](https://github.com/Kareadita/Kavita)。


## 核心功能和特性

- **免费开源**：遵循开源协议，代码透明可审计，无需付费即可使用全部功能。  
- **跨平台支持**：兼容多种操作系统环境，支持通过 Web 界面在不同设备（电脑、平板、手机等）上访问。  
- **高效性能**：具备快速的文件加载和内容处理能力，提升阅读流畅度。  
- **Web 化管理**：基于 Web 的用户界面，无需安装客户端，直接通过浏览器完成库管理与阅读。  


## 使用场景和适用范围

- **个人媒体库管理**：适用于个人用户整理本地漫画、图书资源，实现数字化集中存储。  
- **家庭共享阅读**：支持家庭内部通过局域网或互联网共享媒体库，多用户协同使用。  
- **跨设备阅读**：通过 Web 访问实现多终端无缝切换，满足移动阅读需求。  


## 使用方法和配置说明

### 镜像标签说明

Kavita 镜像提供以下标签，用于区分不同版本：  

- `latest`：最新稳定版，基于 Ubuntu 容器构建，适合生产环境使用。  
- `nightly`：源码最新构建版，包含开发中的功能，稳定性可能较低，适合尝鲜测试。  


### Docker 命令行部署

通过 `docker run` 命令快速启动容器：  

```bash
docker run --name kavita -p 5000:5000 \
  -v /your/manga/directory:/manga \
  -v /kavita/data/directory:/kavita/config \
  --restart unless-stopped \
  -d docker.xuanyuan.run/jvmilazz0/kavita:latest
```

**参数说明**：  
- `--name kavita`：指定容器名称为 `kavita`，便于管理。  
- `-p 5000:5000`：端口映射，将容器内 5000 端口（Web 服务端口）映射到主机 5000 端口。  
- `-v /your/manga/directory:/manga`：挂载主机漫画/图书目录（需替换为实际路径），容器内路径固定为 `/manga`。  
- `-v /kavita/data/directory:/kavita/config`：挂载配置数据目录（需替换为实际路径），用于持久化存储配置文件、用户数据等。  
- `--restart unless-stopped`：容器重启策略，除非手动停止，否则退出后自动重启。  
- `-d`：后台运行容器。  


### Docker Compose 部署

通过 `docker-compose.yml` 文件定义服务，适合批量部署和配置管理：  

```yaml
version: '3.9'
services:
  kavita:
    image: docker.xuanyuan.run/jvmilazz0/kavita:latest  # 使用最新稳定版镜像
    volumes:
      - ./manga:/manga  # 主机漫画目录（相对路径，与 compose 文件同级）
      - ./data:/kavita/config  # 主机配置数据目录（相对路径）
    ports:
      - "5000:5000"  # 端口映射
    restart: unless-stopped  # 重启策略
```

**部署步骤**：  
1. 创建 `docker-compose.yml` 文件并粘贴上述内容；  
2. 在文件所在目录执行命令 `docker-compose up -d` 启动服务。  


### 初始化配置流程

容器启动后，按以下步骤完成初始化：  

1. **访问 Web 界面**：在浏览器中打开 `http://localhost:5000`（若远程部署，替换 `localhost` 为服务器 IP）。  
2. **创建管理员账户**：按页面指引设置管理员用户名和密码。  
3. **配置媒体库**：登录后，将漫画/图书库路径设置为 `/manga`（对应容器内挂载的目录），完成媒体库初始化。  


## 功能建议与反馈

若有功能改进建议或使用问题，可通过 Kavita 的 GitHub Discussions 提交反馈。提交前建议先查看项目看板，确认是否为已规划功能。  

[功能建议与反馈渠道](https://github.com/Kareadita/Kavita/discussions)
