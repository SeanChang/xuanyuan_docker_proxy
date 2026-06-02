<!-- xuanyuan-docker-images-zh
image: githubyumao/mcsmanager-web
source: https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-web
canonical: https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-web
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-web" title="githubyumao/mcsmanager-web Docker 镜像中文简介、标签列表与拉取命令">githubyumao/mcsmanager-web — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-web" title="githubyumao/mcsmanager-web Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-web</a></p>

# MCSManager 面板官方Docker镜像文档


## 1. 镜像概述和主要用途  
MCSManager 面板官方Docker镜像是用于快速部署和运行 MCSManager 服务器管理面板的容器化解决方案。该镜像基于官方GitHub仓库自动构建，确保集成最新稳定版本的面板功能，主要用途为提供图形化界面，帮助用户集中管理、监控和维护各类游戏服务器（如Minecraft、CS:GO、ARK等），支持多服务器实例的创建、配置、启停、日志查看及自动化运维。


## 2. 核心功能和特性  
- **多服务器统一管理**：支持同时管理多个游戏服务器实例，集中配置和监控  
- **Web可视化界面**：提供直观的浏览器操作界面，无需命令行即可完成服务器运维  
- **实时状态监控**：实时展示服务器CPU、内存、网络带宽等资源占用情况  
- **用户权限管理**：支持多用户角色配置，细分管理权限（如管理员、操作员、访客）  
- **自动化运维**：集成自动备份、定时启停、异常重启等自动化工具  
- **日志与告警**：实时查看服务器输出日志，支持异常状态告警通知  
- **容器化兼容**：支持将游戏服务器部署为Docker容器，简化环境隔离与版本控制  


## 3. 使用场景和适用范围  
- **适用用户**：游戏服务器管理员、个人或小型团队（如工作室、社群）负责游戏服务器搭建与维护的技术人员  
- **支持游戏类型**：Minecraft（Java/基岩版）、CS:GO、ARK: Survival Evolved、Rust等主流游戏服务器  
- **使用场景**：  
  - 个人玩家搭建和管理私人游戏服务器  
  - 小型社群集中管理多节点游戏服务器  
  - 游戏服务器托管商提供轻量化管理面板服务  


## 4. 使用方法和配置说明  

### 4.1 前提条件  
- 已安装Docker Engine（推荐20.10+版本）及Docker Compose（可选，用于编排部署）  
- 服务器开放面板所需端口（默认8080/tcp、23333/tcp）  


### 4.2 快速部署（docker run 命令）  
通过以下命令快速启动MCSManager面板容器，包含数据持久化配置：  

```bash
docker run -d \
  --name mcsmanager \
  --restart always \
  -p 8080:8080 \  # 面板Web访问端口
  -p 23333:23333 \  # 守护进程通信端口（用于管理游戏服务器）
  -v /opt/mcsmanager:/data \  # 数据卷挂载（持久化配置、日志、备份等）
  -e TZ=Asia/Shanghai \  # 设置时区（可选，默认UTC）
  mcsmanager/mcsmanager:latest
```

> 说明：  
> - `/opt/mcsmanager` 为宿主机数据目录，需确保目录存在且权限正确（建议设置权限777或属主为容器内用户）  
> - 端口可根据实际需求修改（如宿主机8080端口被占用，可改为 `-p 8081:8080`）  


### 4.3 Docker Compose 部署  
创建 `docker-compose.yml` 文件，配置如下：  

```yaml
version: '3.8'
services:
  mcsmanager:
    image: mcsmanager/mcsmanager:latest
    container_name: mcsmanager
    restart: always
    ports:
      - "8080:8080"
      - "23333:23333"
    volumes:
      - /opt/mcsmanager:/data
    environment:
      - TZ=Asia/Shanghai  # 时区配置
    networks:
      - mcsmanager-net

networks:
  mcsmanager-net:
    driver: bridge
```

启动容器：  
```bash
docker-compose up -d
```


### 4.4 配置参数说明  

#### 4.4.1 端口映射  
| 容器端口 | 用途                  | 宿主机建议映射端口 |
|----------|-----------------------|--------------------|
| 8080     | 面板Web访问端口       | 8080（可自定义）   |
| 23333    | 守护进程通信端口       | 23333（不可修改）  |


#### 4.4.2 数据卷挂载  
| 容器路径 | 用途                  | 宿主机建议挂载路径 |
|----------|-----------------------|--------------------|
| `/data`  | 面板配置、服务器数据、日志、备份等 | `/opt/mcsmanager`  |


#### 4.4.3 环境变量  
| 变量名 | 说明                  | 默认值       | 示例值           |
|--------|-----------------------|--------------|------------------|
| `TZ`   | 容器时区配置          | `UTC`        | `Asia/Shanghai`  |


## 5. 访问与初始化  
容器启动后，通过浏览器访问 `http://<服务器IP>:8080` 进入面板。初始登录信息：  
- 用户名：`admin`  
- 密码：`123456`  

首次登录需修改默认密码，建议启用两步验证以提升安全性。


## 6. 数据持久化说明  
通过 `-v /opt/mcsmanager:/data` 挂载宿主机目录后，以下数据将持久化存储，容器重建或升级时不会丢失：  
- 面板配置文件（用户、权限、服务器列表等）  
- 游戏服务器数据（如Minecraft世界文件、插件配置）  
- 日志文件和自动化备份数据  

**注意**：迁移服务器时，仅需复制 `/opt/mcsmanager` 目录至新服务器对应路径，重新部署容器即可恢复所有配置。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-web" title="githubyumao/mcsmanager-web Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/githubyumao/mcsmanager-web</a></p>
