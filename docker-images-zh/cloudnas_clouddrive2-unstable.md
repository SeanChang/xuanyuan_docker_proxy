---
image: cloudnas/clouddrive2-unstable
description: "Docker镜像cloudnas/clouddrive2-unstable是一款将各类云存储服务无缝挂载为本地可访问磁盘的工具，支持阿里云OSS、腾讯云COS、OneDrive、Google Drive等主流云盘，提供实时文件同步与跨平台访问能力。通过Docker封装实现快速部署，unstable版本包含最新开发特性，适合需要尝鲜新功能或测试环境使用，助力个人与团队高效管理多云存储资源，实现本地般流畅的云文件访问体验。"
source: https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2-unstable
canonical: https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2-unstable
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2-unstable" title="cloudnas/clouddrive2-unstable Docker 镜像中文简介、标签列表与拉取命令">cloudnas/clouddrive2-unstable 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# CloudDrive2 unstable 介绍  


## 工具简介  
CloudDrive2 可将云存储服务挂载为本地文件系统，方便用户像访问本地文件一样管理云存储内容。  


## 支持的云存储服务  
目前支持以下云存储平台：  
- 115.com  
- cloud.189.cn  
- ~~wocloud.com.cn~~（已不支持）  
- aliyundrive.com  
- WebDAV  
- mypikpak.com  
- ...（更多平台持续扩展中）  


## 支持的架构  
| 架构   | 标签    |  
|--------|---------|  
| x86-64 | amd64   |  
| arm64  | arm64   |  
| armv7  | arm32   |  


## 使用方法  


### 运行前准备  
CloudDrive2 依赖 fuse3 实现云存储挂载。如需在 docker 容器中启用 fuse 并将挂载内容共享给主机，需在主机中设置以下任一选项：  

#### 选项 1：在 docker 服务中启用 MountFlags  
```bash  
# 创建 docker 服务配置目录  
mkdir -p /etc/systemd/system/docker.service.d/  
# 写入配置文件  
cat <<EOF > /etc/systemd/system/docker.service.d/clear_mount_propagation_flags.conf  
[Service]  
MountFlags=shared  
EOF  
```  

#### 选项 2：为主机中映射的卷启用 shared 挂载选项  
```bash  
# 将用于接收云存储挂载的卷设置为 shared 模式  
mount --make-shared <用于接收云存储挂载的卷路径>  
```  


### 通过 docker-compose 部署  
创建 docker-compose.yml 文件，配置如下（替换 `<>` 中的占位符为实际路径）：  

```yaml  
version: "2.1"  
services:  
  cloudnas:  
    image: docker.xuanyuan.run/cloudnas/clouddrive2-unstable  
    container_name: clouddrive2  
    environment:  
      - TZ=Asia/Shanghai  # 时区设置  
      - CLOUDDRIVE_HOME=/Config  # 应用数据目录  
    volumes:  
      - <本地用于接收云存储挂载的路径>:/CloudNAS:shared  # 挂载点目录（必填）  
      - <本地用于存放应用数据的路径>:/Config  # 应用配置数据目录（必填）  
      - <本地其他共享路径>:/media:shared  # 主机可选媒体共享路径（可选）  
    devices:  
      - /dev/fuse:/dev/fuse  # 挂载fuse设备  
    restart: unless-stopped  # 重启策略  
    pid: "host"  # 使用主机PID命名空间  
    privileged: true  # 特权模式（也可尝试添加cap_add -SYS_ADMIN，但部分系统可能失败）  
    # cap_add:  # 替代特权模式的选项（部分系统可能不支持）  
    #   - SYS_ADMIN  
    network_mode: "host"  # 主机网络模式（若不生效可改用端口映射）  
    # ports:  # 端口映射（当network_mode不生效时使用）  
    #   - 19798:19798  
```  


### 通过 docker 命令行运行  
直接执行以下命令（替换 `<>` 中的占位符为实际路径）：  

```bash  
docker run -d \  
  --name clouddrive \  # 容器名称  
  --restart unless-stopped \  # 重启策略  
  --env CLOUDDRIVE_HOME=/Config \  # 应用数据目录  
  -v <本地用于接收云存储挂载的路径>:/CloudNAS:shared \  # 挂载点目录（必填）  
  -v <本地用于存放应用数据的路径>:/Config \  # 应用配置数据目录（必填）  
  -v <本地其他共享路径>:/media:shared \  # 主机可选媒体共享路径（可选）  
  --network host \  # 主机网络模式  
  --pid host \  # 使用主机PID命名空间  
  --privileged \  # 特权模式  
  --device /dev/fuse:/dev/fuse \  # 挂载fuse设备  
  cloudnas/clouddrive2-unstable  # 镜像名称  
```  


### 配置访问  
部署完成后，通过浏览器访问以下地址进行配置：  
`http://<主机IP>:19798`  

（需将 `<主机IP>` 替换为运行容器的主机IP地址）
