---
image: koryking/1panel
description: "1panel在Docker中运行的镜像，支持通过环境变量设置应用安装位置。"
source: https://xuanyuan.cloud/zh/r/koryking/1panel
canonical: https://xuanyuan.cloud/zh/r/koryking/1panel
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/koryking/1panel" title="koryking/1panel Docker 镜像中文简介、标签列表与拉取命令">koryking/1panel 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 1Panel 自定义安装路径镜像

## 镜像概述和主要用途  
本镜像是基于 `moelin/1panel` 重新打包的容器化版本，核心改进在于支持通过 `PANEL_BASE_DIR` 环境变量自定义应用安装路径，不再强制依赖 `/opt` 目录。解决了原镜像因固定路径限制导致的应用商店安装报错问题，提供更灵活的部署配置选项，适用于需要自定义应用存储位置的场景。


## 核心功能和特性  
- **自定义应用安装路径**：通过 `PANEL_BASE_DIR` 环境变量指定应用安装根目录，摆脱原镜像对 `/opt` 目录的强制依赖。  
- **环境变量配置支持**：支持通过环境变量灵活配置端口、安全入口、登录凭证（用户名/密码）及时区等核心参数。  
- **容器化稳定运行**：基于 Docker 容器部署，支持自动重启策略（`restart: always`），确保服务持续可用。  
- **路径限制修复**：解决原镜像中因固定 `/opt` 路径导致的应用商店安装失败问题，提升环境兼容性。  
- **灵活存储映射**：支持 Docker 守护进程通信、卷数据持久化、应用安装目录及可选 root 目录的自定义映射。  


## 使用场景和适用范围  
- **自定义路径需求**：适用于 `/opt` 目录空间不足、权限受限或企业规范要求使用非 `/opt` 路径的用户。  
- **环境兼容性提升**：解决原镜像在特定服务器环境下的路径冲突问题，适用于各类 Linux 服务器（如 CentOS、Ubuntu 等）。  
- **个性化配置场景**：需要自定义端口、安全入口或登录凭证的 1Panel 部署场景，满足灵活管理需求。  


## 详细使用方法和配置说明  

### 准备工作  
- 已安装 Docker 和 Docker Compose（推荐版本：Docker 20.10+，Docker Compose 2.0+）。  
- 确定自定义应用安装路径（如 `/data/1panel/opt`），确保目录存在且具备读写权限（建议权限 755+）。  


### Docker Compose 配置示例  
创建 `docker-compose.yml` 文件，按以下示例配置，**需将所有 `/xxxx/opt` 替换为实际自定义路径（需保持三处一致）**：  

```yaml
services:
  1panel:
    container_name: 1panel  # 容器名称（可自定义）
    restart: always  # 自动重启策略
    network_mode: "host"  # 使用主机网络模式（直接映射宿主机端口）
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock  # Docker 守护进程通信（必填）
      - ./volumes:/var/lib/docker/volumes  # Docker 卷数据持久化（建议保留）
      - /xxxx/opt:/xxxx/opt  # 应用安装目录映射（替换为自定义路径）
      - ./root:/root  # 可选：root 用户目录映射（根据需求启用）
    environment:
      - TZ=Asia/Shanghai  # 时区设置（默认 Asia/Shanghai）
      - PANEL_BASE_DIR=/xxxx/opt  # 应用安装根目录（需与 volumes 映射路径一致）
      - PANEL_PORT=10088  # 访问端口（默认 10086，可自定义）
      - PANEL_ENTRANCE=koryking  # 安全入口路径（默认 entrance，URL 路径部分）
      - PANEL_USERNAME=koryking  # 登录用户名（默认 1panel）
      - PANEL_PASSWORD=koryking999  # 登录密码（默认 1panel_password）
    image: docker.io/koryking/1panel:latest  # 镜像地址
    labels:
      createdBy: "Apps"  # 自定义标签（可选）
```


### 启动服务  
配置文件准备完成后，在文件所在目录执行以下命令启动服务：  

```bash
docker compose up -d
```


### （可选）Docker Run 命令示例  
若需通过 `docker run` 快速启动，可参考以下命令（**替换 `/xxxx/opt` 为实际自定义路径**）：  

```bash
docker run -d \
  --name 1panel \
  --restart always \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./volumes:/var/lib/docker/volumes \
  -v /xxxx/opt:/xxxx/opt \
  -v ./root:/root \
  -e TZ=Asia/Shanghai \
  -e PANEL_BASE_DIR=/xxxx/opt \
  -e PANEL_PORT=10088 \
  -e PANEL_ENTRANCE=koryking \
  -e PANEL_USERNAME=koryking \
  -e PANEL_PASSWORD=koryking999 \
  --label createdBy="Apps" \
  docker.io/koryking/1panel:latest
```


## 环境变量参数说明  

| 环境变量名          | 作用描述                     | 默认值               | 是否必填 |
|---------------------|------------------------------|----------------------|----------|
| TZ                  | 容器时区设置                 | Asia/Shanghai        | 否       |
| PANEL_BASE_DIR      | 应用安装根目录（核心参数）   | /opt                 | **是**   |
| PANEL_PORT          | 1Panel 访问端口              | 10086                | 否       |
| PANEL_ENTRANCE      | 安全入口路径（URL 路径部分） | entrance             | 否       |
| PANEL_USERNAME      | 登录用户名                   | 1panel               | 否       |
| PANEL_PASSWORD      | 登录密码                     | 1panel_password      | 否       |

> **注意**：`PANEL_BASE_DIR` 必须与 `volumes` 中的 `/xxxx/opt:/xxxx/opt` 映射路径完全一致，否则会导致应用安装路径匹配失败。  


## 注意事项  
1. **路径一致性**：自定义路径 `/xxxx/opt` 需在 `volumes` 映射和 `PANEL_BASE_DIR` 环境变量中保持完全一致，否则应用无法正确识别安装位置。  
2. **权限问题**：确保宿主机自定义目录（如 `/data/1panel/opt`）权限充足（建议权限 755 或以上），避免容器内读写失败。  
3. **端口冲突**：使用 `host` 网络模式时，需确保 `PANEL_PORT` 未被其他服务占用，冲突时可通过修改 `PANEL_PORT` 解决。  
4. **数据持久化**：`./volumes` 和自定义安装目录建议使用绝对路径映射（如 `~/1panel/volumes:/var/lib/docker/volumes`），避免因相对路径导致数据丢失。  
5. **可选映射**：`./root:/root` 为可选配置，用于持久化 root 用户配置，根据实际需求启用或禁用。
