<!-- xuanyuan-docker-images-zh
image: ngc7331/mcsmanager-daemon
source: https://xuanyuan.cloud/zh/r/ngc7331/mcsmanager-daemon
canonical: https://xuanyuan.cloud/zh/r/ngc7331/mcsmanager-daemon
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [ngc7331/mcsmanager-daemon — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/ngc7331/mcsmanager-daemon "ngc7331/mcsmanager-daemon Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/ngc7331/mcsmanager-daemon

# Docker化MCSManager快速部署方案


## 项目简介  
本方案基于Docker容器化技术，提供MCSManager（我的世界服务器管理工具）的一键部署流程。无需手动配置Java环境、数据库等依赖，通过容器化简化部署步骤，适合个人或小型团队快速搭建服务器管理面板。


## 准备工作  
### 安装Docker与Docker Compose  
部署前需确保服务器已安装Docker和Docker Compose。  

- **Linux系统**：通过包管理器安装（如`apt install docker-ce docker-compose-plugin`或`yum install docker-ce docker-compose-plugin`），安装后启动Docker服务（`systemctl start docker`）并设为开机自启（`systemctl enable docker`）。  
- **Windows/macOS系统**：直接安装[Docker Desktop]([])，内置Docker Compose。  


## 部署步骤  

### 1. 克隆项目仓库  
通过Git拉取部署配置文件：  
```bash
git clone [] docker-mcsmanager
```  


### 2. 调整配置参数（可选）  
进入项目目录后，编辑`docker-compose.yml`文件，根据需求修改以下参数：  

- **端口映射**：默认映射宿主机23333端口（Web管理界面），若端口冲突，可修改为`自定义端口:23333`（如`8080:23333`）。  
- **数据持久化**：默认将MCSManager数据挂载到宿主机`./data`目录（位于项目文件夹内），如需自定义路径，修改`volumes`字段为`/自定义路径:/opt/mcsmanager`。  


### 3. 启动服务  
执行以下命令启动容器（后台运行）：  
```bash
docker-compose up -d
```  
首次启动需拉取镜像，耗时取决于网络环境，完成后可通过`docker-compose ps`查看容器状态（状态为`Up`即启动成功）。  


## 使用说明  
### 访问管理界面  
容器启动后，通过浏览器访问 `[]  

### 初始登录  
默认账号：`admin`，默认密码：`123456`。**首次登录后建议立即在“系统设置”中修改密码**，避免安全风险。  

### 管理服务器  
登录后通过Web界面可直接创建、启动、停止我的世界服务器，支持配置内存、插件、mod等，操作与原生MCSManager一致。  


## 注意事项  
### 数据安全  
确保宿主机`./data`目录（或自定义数据目录）权限正确（建议`755`），避免容器删除/重启后数据丢失。  

### 端口冲突排查  
若启动后无法访问界面，执行`netstat -tuln`检查端口是否被占用，或通过`docker-compose logs`查看容器日志定位问题。  

### 版本更新  
如需更新MCSManager，先拉取最新镜像，再重启容器：  
```bash
docker-compose pull
docker-compose up -d
```  

### 容器管理  
- 停止服务：`docker-compose down`（仅停止容器，数据保留）。  
- 彻底删除（含数据）：需手动删除宿主机数据目录（谨慎操作）。  


通过以上步骤，可快速完成MCSManager的部署与使用，适合对命令行操作不熟悉的用户，或需要快速复现环境的场景。
