---
image: githubyumao/mcsmanager-daemon
description: "MCSManager官方守护进程镜像，自动从GitHub仓库构建。"
source: https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-daemon
canonical: https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-daemon
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-daemon" title="githubyumao/mcsmanager-daemon Docker 镜像中文简介、标签列表与拉取命令">githubyumao/mcsmanager-daemon 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MCSManager 官方Docker镜像文档


## 1. 镜像概述和主要用途

MCSManager 官方Docker镜像是用于部署MCSManager面板相关组件的官方容器化解决方案。该镜像基于官方GitHub仓库自动构建，旨在简化MCSManager的安装与运维流程，提供环境隔离、快速部署和版本控制能力。根据官方描述，该镜像可能包含面板（Panel）或守护进程（Daemon）组件，具体功能请参考[官方文档](https://docs.mcsmanager.com/docker-install.html)。


## 2. 核心功能和特性

### 2.1 MCSManager核心功能
- **多服务器管理**：支持同时管理多个游戏服务器实例（如Minecraft、CS:GO、ARK等）。
- **网页端操作**：通过浏览器访问管理界面，实现服务器启停、配置修改、日志查看等操作。
- **进程监控**：实时监控服务器进程状态、资源占用（CPU、内存、网络）。
- **文件管理**：网页端直接进行服务器文件上传、下载、编辑和权限配置。
- **自动化工具**：支持定时任务、自动备份、崩溃自动重启等自动化运维功能。

### 2.2 Docker镜像特性
- **快速部署**：无需手动配置依赖环境，一键启动服务。
- **环境隔离**：容器化运行，避免与主机系统环境冲突。
- **版本可控**：通过镜像标签指定版本，便于版本回滚和升级。
- **简化运维**：统一的容器管理接口，降低维护复杂度。


## 3. 使用场景和适用范围

### 适用场景
- **个人用户**：搭建个人游戏服务器管理平台，简化单/多服务器运维。
- **团队/工作室**：中小型团队集中管理多个游戏服务器，提升协作效率。
- **服务器托管**：为客户提供游戏服务器托管服务时，作为管理工具平台。

### 适用范围
- 支持MCSManager兼容的所有游戏服务器类型（如Minecraft、Terraria、CS:GO、Rust等）。
- 适用于Linux/macOS/Windows（需Docker支持）等主流操作系统环境。


## 4. 使用方法和配置说明

### 4.1 前提条件
- 已安装Docker Engine（20.10+推荐）及Docker Compose（可选）。
- 开放必要端口（如面板端口、守护进程通信端口），并配置防火墙规则。


### 4.2 基本部署（Docker Run）

#### 4.2.1 守护进程（Daemon）部署示例
若镜像是守护进程组件，典型启动命令如下：
```bash
docker run -d \
  --name mcsmanager-daemon \
  --restart always \
  -p 24444:24444 \  # 守护进程默认通信端口
  -v /path/to/daemon/data:/opt/daemon/data \  # 数据持久化目录
  -e DAEMON_KEY="your-panel-key" \  # 与面板连接的密钥（从面板获取）
  mcsmanager/daemon:latest  # 镜像名称（请以官方实际标签为准）
```

#### 4.2.2 面板（Panel）部署示例
若镜像是面板组件，典型启动命令如下：
```bash
docker run -d \
  --name mcsmanager-panel \
  --restart always \
  -p 23333:23333 \  # 面板Web访问端口
  -v /path/to/panel/data:/opt/panel/data \  # 数据持久化目录
  mcsmanager/panel:latest  # 镜像名称（请以官方实际标签为准）
```


### 4.3 Docker Compose配置

推荐使用Docker Compose管理多组件部署（如同时部署面板和守护进程），示例配置如下：

```yaml
version: '3'
services:
  panel:
    image: mcsmanager/panel:latest
    container_name: mcs-panel
    restart: always
    ports:
      - "23333:23333"  # Web访问端口
    volumes:
      - ./panel-data:/opt/panel/data  # 面板数据持久化
    environment:
      - TZ=Asia/Shanghai  # 时区设置

  daemon:
    image: mcsmanager/daemon:latest
    container_name: mcs-daemon
    restart: always
    ports:
      - "24444:24444"  # 守护进程通信端口
    volumes:
      - ./daemon-data:/opt/daemon/data  # 守护进程数据持久化
    environment:
      - DAEMON_KEY="your-panel-key"  # 面板中生成的守护进程密钥
      - TZ=Asia/Shanghai
    depends_on:
      - panel  # 依赖面板服务（可选）
```

启动命令：`docker-compose up -d`


### 4.4 核心配置参数说明

#### 环境变量（Environment Variables）
| 参数名         | 说明                                  | 默认值       |
|----------------|---------------------------------------|--------------|
| `TZ`           | 容器时区设置（如Asia/Shanghai）       | UTC          |
| `DAEMON_KEY`   | 守护进程与面板通信的密钥（面板中生成） | 无（必填）   |
| `PORT`         | 服务端口（覆盖默认端口）              | 23333（面板）/24444（守护进程） |

#### 端口映射（Ports）
| 组件    | 默认端口 | 用途                     |
|---------|----------|--------------------------|
| 面板    | 23333    | Web管理界面访问端口      |
| 守护进程| 24444    | 面板与守护进程通信端口   |

#### 数据卷（Volumes）
| 组件    | 容器内路径          | 用途                     |
|---------|---------------------|--------------------------|
| 面板    | `/opt/panel/data`   | 存储面板配置、用户数据等 |
| 守护进程| `/opt/daemon/data`  | 存储服务器数据、日志等   |


### 4.5 数据持久化

**必须挂载数据卷**以避免容器重启后数据丢失：
- 面板数据卷：保存用户配置、服务器列表、权限设置等。
- 守护进程数据卷：保存游戏服务器文件、运行日志、备份数据等。
- 挂载路径建议使用绝对路径（如`/var/mcsmanager/daemon`），避免相对路径导致的挂载异常。


## 5. 注意事项

1. **网络通信**：面板与守护进程需确保网络互通（同一局域网或公网可达），防火墙需开放对应端口（23333、24444）。
2. **密钥配置**：`DAEMON_KEY`需从面板的“添加守护进程”页面生成，确保与守护进程配置一致，否则无法连接。
3. **性能需求**：根据管理的服务器数量调整主机资源（CPU、内存、磁盘IO），建议至少2核4G内存起步。
4. **版本兼容性**：面板与守护进程版本需保持一致，避免因版本差异导致功能异常。
5. **官方文档**：详细配置及高级功能请参考[MCSManager Docker安装文档](https://docs.mcsmanager.com/docker-install.html)。
