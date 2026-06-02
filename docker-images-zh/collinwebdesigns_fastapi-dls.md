---
image: collinwebdesigns/fastapi-dls
description: "最小化的委托许可服务（DLS），提供委托许可服务功能。"
source: https://xuanyuan.cloud/zh/r/collinwebdesigns/fastapi-dls
canonical: https://xuanyuan.cloud/zh/r/collinwebdesigns/fastapi-dls
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/collinwebdesigns/fastapi-dls" title="collinwebdesigns/fastapi-dls Docker 镜像中文简介、标签列表与拉取命令">collinwebdesigns/fastapi-dls — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/collinwebdesigns/fastapi-dls" title="collinwebdesigns/fastapi-dls Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/collinwebdesigns/fastapi-dls</a>

# FastAPI-DLS 技术文档


## 1. 镜像概述和主要用途

FastAPI-DLS 是一个**最小化委托许可服务（Minimal Delegated License Service, DLS）**，旨在提供轻量级的许可管理功能。该服务通过 Docker 容器化部署，简化了许可服务的配置与维护流程。

- **官方代码仓库**：[Git Repo and README](https://git.collinwebdesigns.de/oscar.krause/fastapi-dls/-/blob/main/README.md)  
- **备份镜像仓库**：[Backup Mirror](https://gitea.publichub.eu/oscar.krause/fastapi-dls)  
- **系统支持**：提供 Debian、Ubuntu 和 ArchLinux 系统的独立包（详情参见完整 README）。


## 2. 核心功能与特性

- **轻量级部署**：基于 Docker 容器化，资源占用低，部署便捷。  
- **灵活配置**：支持自定义时区、服务 URL、端口、租赁过期时间等参数。  
- **数据持久化**：通过卷挂载实现证书和数据库（SQLite）的持久化存储。  
- **多客户端支持**：兼容 Linux 和 Windows 客户端配置。  
- **可调试模式**：支持 DEBUG 环境变量开启调试日志。  


## 3. 使用场景与适用范围

- **适用环境**：需要管理 NVIDIA vGPU 许可的服务器环境。  
- **部署方式**：支持 Docker 容器化部署，适用于各类 Linux 服务器。  
- **客户端兼容性**：支持 Linux 和 Windows 操作系统的 NVIDIA 客户端配置。  


## 4. 详细使用方法和配置说明

### 4.1 Docker Compose 部署示例

以下是推荐的 `docker-compose.yml` 配置，包含完整的服务定义、环境变量和卷挂载：

```yaml
version: '3.9'

x-dls-variables: &dls-variables
  TZ: Europe/Berlin  # REQUIRED, 必须正确设置时区（服务器与客户端需保持一致）
  DLS_URL: localhost # REQUIRED, 服务器IP或主机名
  DLS_PORT: 443      # 服务端口
  LEASE_EXPIRE_DAYS: 90 # 租赁过期天数
  DATABASE: sqlite:////app/database/db.sqlite # 数据库连接字符串
  DEBUG: false       # 是否启用调试模式

services:
  dls:
    image: collinwebdesigns/fastapi-dls:latest # 镜像名称
    restart: always # 容器重启策略
    environment:
      <<: *dls-variables # 引用上述环境变量
    ports:
      - "443:443"  # 端口映射（容器内固定使用443，若需修改外部端口，如"9443:443"，需同步设置DLS_PORT: 9443）
    volumes:
      - /opt/docker/fastapi-dls/cert:/app/cert # 挂载证书目录（宿主机路径可自定义）
      - db:/app/database # 挂载数据库卷（使用命名卷持久化数据）

volumes:
  db: # 数据库命名卷
```


### 4.2 Docker Run 命令示例

若无需 `docker-compose`，可直接使用 `docker run` 命令部署：

```bash
docker run -d \
  --name fastapi-dls \
  --restart always \
  -e TZ=Europe/Berlin \
  -e DLS_URL=localhost \
  -e DLS_PORT=443 \
  -e LEASE_EXPIRE_DAYS=90 \
  -e DATABASE="sqlite:////app/database/db.sqlite" \
  -e DEBUG=false \
  -p 443:443 \
  -v /opt/docker/fastapi-dls/cert:/app/cert \
  -v db:/app/database \
  collinwebdesigns/fastapi-dls:latest
```


### 4.3 环境变量配置说明

| 环境变量          | 是否必填 | 描述                                                                 |
|-------------------|----------|----------------------------------------------------------------------|
| `TZ`              | 是       | 时区设置（例如 `Asia/Shanghai`），**服务器与客户端必须保持一致**。    |
| `DLS_URL`         | 是       | FastAPI-DLS 服务器的 IP 地址或主机名（客户端需通过此地址访问服务）。  |
| `DLS_PORT`        | 否       | 服务端口，默认 `443`（若修改外部映射端口，需同步修改此值）。          |
| `LEASE_EXPIRE_DAYS`| 否       | 许可租赁过期天数，默认 `90` 天。                                      |
| `DATABASE`        | 否       | 数据库连接字符串，默认使用 SQLite：`sqlite:////app/database/db.sqlite`。 |
| `DEBUG`           | 否       | 是否启用调试模式，默认 `false`（生产环境建议关闭）。                  |


### 4.4 卷挂载说明

| 容器内路径         | 用途                     | 宿主机映射建议路径               | 备注                               |
|--------------------|--------------------------|----------------------------------|------------------------------------|
| `/app/cert`        | 存储 SSL 证书文件        | `/opt/docker/fastapi-dls/cert`   | 首次启动时自动生成证书，需持久化。 |
| `/app/database`    | 存储 SQLite 数据库文件   | 使用命名卷 `db`（如示例配置）     | 避免数据丢失，建议使用命名卷。     |


## 5. 客户端配置步骤

### 5.1 通用注意事项

- **token 文件必须完整复制**：不能仅复制文件内容（可能包含特殊字符），需通过文件传输工具或命令完整下载。


### 5.2 Linux 客户端配置

1. 下载 client token 文件：
   ```bash
   curl --insecure -X GET https://<dls-hostname-or-ip>/client-token -o /etc/nvidia/ClientConfigToken/client_configuration_token.tok
   ```
   > 说明：`--insecure` 用于跳过 SSL 证书验证（若使用自签名证书）；`<dls-hostname-or-ip>` 替换为 FastAPI-DLS 服务器的 IP 或主机名。

2. 重启 NVIDIA 许可服务：
   ```bash
   service nvidia-gridd restart
   ```

3. 验证许可状态：
   ```bash
   nvidia-smi -q | grep "License"
   ```


### 5.3 Windows 客户端配置

1. 下载 token 文件：通过浏览器访问 `https://<dls-hostname-or-ip>/client-token`，保存文件。

2. 放置文件到指定路径：将下载的 `client_configuration_token.tok` 保存至  
   `C:\Program Files\NVIDIA Corporation\vGPU Licensing\ClientConfigToken\`。

3. 重启服务：打开“服务”管理界面，重启 `NvContainerLocalSystem` 服务。


## 6. 注意事项

1. **时区一致性**：服务器 `TZ` 环境变量与所有客户端的时区必须一致，否则可能导致许可验证失败。
2. **端口映射**：容器内端口固定为 `443`，修改外部端口时需同步更新 `DLS_PORT` 环境变量（例如外部端口 `9443` 对应 `DLS_PORT=9443`）。
3. **证书管理**：首次启动时，`/app/cert` 目录会自动生成 SSL 证书，若需更换自定义证书，可直接替换该目录下的文件。
4. **数据库备份**：使用命名卷 `db` 持久化数据库，建议定期备份该卷数据以防丢失。
