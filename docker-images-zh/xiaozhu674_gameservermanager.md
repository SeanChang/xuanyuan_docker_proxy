<!-- xuanyuan-docker-images-zh
image: xiaozhu674/gameservermanager
source: https://xuanyuan.cloud/zh/r/xiaozhu674/gameservermanager
canonical: https://xuanyuan.cloud/zh/r/xiaozhu674/gameservermanager
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/xiaozhu674/gameservermanager" title="xiaozhu674/gameservermanager Docker 镜像中文简介、标签列表与拉取命令">xiaozhu674/gameservermanager — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/xiaozhu674/gameservermanager" title="xiaozhu674/gameservermanager Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/xiaozhu674/gameservermanager</a></p>

# 新一代一站式游戏开服面板 Docker 镜像文档


## 1. 镜像概述和主要用途

本镜像是基于"新一代一站式游戏开服面板"构建的Docker化部署方案，旨在为游戏服务器管理员、开发者及游戏社区提供便捷、高效的游戏服务器部署与管理工具。通过容器化封装，简化了传统游戏服务器搭建的复杂流程，实现了"一键部署、可视化管理、全生命周期维护"的一站式体验，支持多类型游戏服务器的快速创建、配置、监控与扩展。


## 2. 核心功能和特性

- **多游戏支持**：兼容主流游戏服务端（如Minecraft、CS:GO、ARK: Survival Evolved、Terraria等），内置游戏模板库
- **可视化管理界面**：Web-based控制台，支持服务启停、配置修改、日志查看、资源监控（CPU/内存/网络）
- **自动化部署**：内置游戏服务端版本管理，支持一键安装、升级、回滚游戏服务端
- **多实例管理**：支持同时部署和管理多个独立游戏服务器实例，资源隔离
- **安全防护**：集成端口防护、IP白名单、权限分级管理（管理员/操作员/访客角色）
- **插件与模组支持**：提供插件市场入口，支持游戏模组（Mod）的自动安装与配置
- **数据备份与恢复**：定时备份游戏数据，支持手动/自动恢复，支持远程存储（FTP/S3）
- **跨平台兼容**：支持Linux/x86_64架构，可运行于物理机、云服务器、边缘设备等环境


## 3. 使用场景和适用范围

- **个人游戏服务器**：玩家自建私人服务器，用于与朋友联机游戏
- **小型游戏工作室**：快速部署和管理多游戏业务，降低运维成本
- **游戏社区服务器**：为社区成员提供稳定的公共游戏服务，支持自定义配置
- **游戏开发者测试环境**：快速搭建多版本游戏服务端，验证游戏兼容性
- **教育与培训机构**：作为游戏开发教学中的服务器管理实践工具


## 4. 使用方法和配置说明

### 4.1 前置要求

- Docker Engine 20.10+
- Docker Compose v2+（可选，用于多容器部署）
- 宿主机资源：至少2核CPU、4GB内存、20GB磁盘空间（具体根据游戏需求调整）
- 网络：开放面板管理端口及游戏服务器所需端口（如8080/tcp、25565/tcp等）


### 4.2 Docker Run 快速启动

```bash
docker run -d \
  --name game-server-panel \
  --restart unless-stopped \
  -p 8080:8080 \
  -v /opt/game-panel/config:/app/config \
  -v /opt/game-panel/games:/app/games \
  -v /opt/game-panel/logs:/app/logs \
  -e ADMIN_USER=admin \
  -e ADMIN_PASSWORD=your_secure_password \
  -e TZ=Asia/Shanghai \
  game-panel:latest
```


### 4.3 Docker Compose 部署（推荐）

创建`docker-compose.yml`文件：

```yaml
version: '3.8'

services:
  game-panel:
    image: game-panel:latest
    container_name: game-server-panel
    restart: unless-stopped
    ports:
      - "8080:8080"  # Web管理界面端口
      # 游戏服务器端口需根据实际游戏配置（示例：Minecraft默认25565）
      # - "25565:25565/tcp"
      # - "25565:25565/udp"
    volumes:
      - ./config:/app/config       # 面板配置文件
      - ./games:/app/games         # 游戏服务器数据目录
      - ./logs:/app/logs           # 运行日志
      - ./backups:/app/backups     # 数据备份目录
    environment:
      - ADMIN_USER=admin           # 初始管理员账号
      - ADMIN_PASSWORD=your_secure_password  # 初始管理员密码（建议复杂度≥8位）
      - TZ=Asia/Shanghai           # 时区设置
      - DB_TYPE=sqlite             # 数据库类型（支持sqlite/mysql/postgresql，默认sqlite）
      # 若使用MySQL/PostgreSQL，需添加以下配置（示例MySQL）：
      # - DB_HOST=db
      # - DB_PORT=3306
      # - DB_USER=paneluser
      # - DB_PASSWORD=panelpass
      # - DB_NAME=gamepanel
    depends_on:
      - db  # 若使用外部数据库，需取消注释并配置db服务

  # 外部数据库示例（MySQL），若使用sqlite可删除此服务
  db:
    image: mysql:8.0
    container_name: game-panel-db
    restart: unless-stopped
    volumes:
      - ./db-data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=rootpass
      - MYSQL_DATABASE=gamepanel
      - MYSQL_USER=paneluser
      - MYSQL_PASSWORD=panelpass
    ports:
      - "3306:3306"  # 仅内部访问时可删除此行
```

启动命令：`docker-compose up -d`


### 4.4 环境变量说明

| 环境变量名          | 描述                                  | 默认值              | 是否必填 |
|---------------------|---------------------------------------|---------------------|----------|
| `ADMIN_USER`        | 初始管理员账号                        | `admin`             | 否       |
| `ADMIN_PASSWORD`    | 初始管理员密码                        | 随机生成（日志中查看） | 否       |
| `TZ`                | 容器时区                              | `UTC`               | 否       |
| `DB_TYPE`           | 数据库类型（sqlite/mysql/postgresql） | `sqlite`            | 否       |
| `DB_HOST`           | 数据库主机（非sqlite时必填）          | -                   | 是（若DB_TYPE非sqlite） |
| `DB_PORT`           | 数据库端口（非sqlite时必填）          | -                   | 是（若DB_TYPE非sqlite） |
| `DB_USER`           | 数据库用户名（非sqlite时必填）        | -                   | 是（若DB_TYPE非sqlite） |
| `DB_PASSWORD`       | 数据库密码（非sqlite时必填）          | -                   | 是（若DB_TYPE非sqlite） |
| `DB_NAME`           | 数据库名称（非sqlite时必填）          | -                   | 是（若DB_TYPE非sqlite） |
| `LOG_LEVEL`         | 日志级别（debug/info/warn/error）     | `info`              | 否       |


### 4.5 数据持久化配置

为避免容器重建导致数据丢失，需挂载以下目录为数据卷：

| 宿主机目录示例         | 容器内目录       | 说明                          |
|------------------------|------------------|-------------------------------|
| `/opt/game-panel/config` | `/app/config`    | 面板核心配置文件（含用户数据、游戏模板配置） |
| `/opt/game-panel/games`  | `/app/games`     | 游戏服务器数据（含服务端程序、存档、模组）  |
| `/opt/game-panel/logs`   | `/app/logs`      | 运行日志（面板日志、游戏服务器日志）        |
| `/opt/game-panel/backups`| `/app/backups`   | 自动/手动备份数据（需在面板中启用备份功能）  |


### 4.6 端口映射说明

| 端口    | 用途                  | 协议  | 是否必须映射 |
|---------|-----------------------|-------|--------------|
| 8080    | Web管理界面访问端口   | TCP   | 是           |
| 25565   | Minecraft服务器端口   | TCP/UDP | 否（按需映射） |
| 27015   | CS:GO服务器端口       | TCP/UDP | 否（按需映射） |
| 7777    | ARK服务器端口         | TCP/UDP | 否（按需映射） |


## 5. 初始化与访问

1. **启动容器**：执行`docker run`或`docker-compose up -d`后，等待30秒~2分钟（首次启动需初始化数据库和配置）。
   
2. **访问管理界面**：在浏览器中输入 `http://<宿主机IP>:8080`，使用环境变量配置的`ADMIN_USER`和`ADMIN_PASSWORD`登录。

3. **首次配置**：
   - 登录后建议立即修改管理员密码（路径：设置 > 账号安全）。
   - 选择游戏模板（路径：游戏库 > 选择游戏 > 安装服务端）。
   - 配置游戏服务器参数（如端口、内存分配、MOD等）并启动服务。


## 6. 注意事项

- **权限管理**：宿主机挂载目录需确保Docker用户（通常为`root`或`docker`组）有读写权限，避免因权限不足导致配置或数据无法保存。
- **性能优化**：根据游戏类型调整容器资源限制（通过`--memory`、`--cpus`参数），避免资源竞争影响游戏体验。
- **安全加固**：生产环境中建议禁用`ADMIN_PASSWORD`明文环境变量，改用面板内手动设置；外部访问建议通过HTTPS反向代理（如Nginx+Let's Encrypt）。
- **数据备份**：定期备份`/games`和`/config`目录，避免因容器故障或数据损坏导致游戏存档丢失。
- **版本更新**：升级镜像前需备份数据，新版本可能存在配置文件格式变更，需参考官方更新日志进行适配。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/xiaozhu674/gameservermanager" title="xiaozhu674/gameservermanager Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/xiaozhu674/gameservermanager</a></p>
