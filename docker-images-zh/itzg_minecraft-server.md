<!-- xuanyuan-docker-images-zh
image: itzg/minecraft-server
source: https://xuanyuan.cloud/zh/r/itzg/minecraft-server
canonical: https://xuanyuan.cloud/zh/r/itzg/minecraft-server
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [itzg/minecraft-server — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/itzg/minecraft-server "itzg/minecraft-server Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/itzg/minecraft-server

### itzg/minecraft-server Docker镜像介绍  


#### 镜像基本信息  
[![Docker 拉取量]([])]([])  
[![Docker 星级]([])]([])  
[![GitHub 问题]([])]([])  
[![ 社区]()]()  
[![捐赠支持]([])]([])  


#### 镜像简介  
这个Docker镜像可快速部署Minecraft服务器，启动时会自动下载最新稳定版本。你也可以手动指定运行某个特定版本，或升级到最新的快照版本（测试版）。  


#### 查看详细文档  
[![点击查看文档]([])]([])  


#### 快速启动（最新稳定版）  
若要直接使用最新稳定版，运行以下命令：  

```bash
docker run -d -p 25565:25565 --name mc -v mc-data:/data itzg/minecraft-server
```  

**说明**：命令中 `-p 25565:25565` 将Minecraft标准服务器端口映射到主机，`-v mc-data:/data` 挂载数据卷确保服务器数据持久化，`--name mc` 为容器命名以便后续管理。  


#### 基岩版服务器说明  
如果你使用的是主机（如Xbox/PlayStation）、移动设备或原生Windows系统的Minecraft客户端，需使用基岩版服务器镜像：  

[itzg/minecraft-bedrock-server]([])
