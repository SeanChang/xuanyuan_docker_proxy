---
image: cloudnas/clouddrive2
description: "CloudDrive 是一款功能强大的多云存储管理工具，其核心特性在于支持将各类云盘（如百度云、阿里云、Google Drive等）本地挂载，使用户可像操作本地硬盘一样直接访问、编辑和管理云端文件，无需反复切换不同云平台，有效整合分散的云存储资源，大幅提升跨云文件管理的便捷性与效率。"
source: https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2
canonical: https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cloudnas/clouddrive2" title="cloudnas/clouddrive2 Docker 镜像中文简介、标签列表与拉取命令">cloudnas/clouddrive2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## CloudDrive2 介绍  

CloudDrive2 是一款实用的多云盘管理工具，提供一站式多云解决方案，核心功能为将各类云存储服务本地挂载，方便用户统一管理和访问。  


### 支持的云存储服务  
- 115网盘  
- 天翼云盘（cloud.189.cn）  
- 百度网盘  
- ~~wocloud.com.cn（已停止支持）~~  
- 阿里云盘  
- WebDAV  
- PikPak（mypikpak.com）  
- ...（其他兼容服务）  


### 支持架构  
| 架构   | 标签    |  
|--------|---------|  
| x86-64 | amd64   |  
| arm64  | arm64   |  
| armv7  | arm32   |  


## 使用方法  

### 运行前准备  
CloudDrive2 通过 fuse3 实现云存储本地挂载。需在主机中配置以下任一选项，以允许容器内启用 fuse 并将挂载共享至主机：  

#### 选项1：修改 docker 服务的 MountFlags  
```bash  
# 创建 docker 服务配置目录  
mkdir -p /etc/systemd/system/docker.service.d/  
# 写入配置文件  
cat <<EOF > /etc/systemd/system/docker.service.d/clear_mount_propagation_flags.conf  
[Service]  
MountFlags=shared  
EOF  
```  

#### 选项2：为主机映射卷启用 shared 挂载属性  
```bash  
mount --make-shared <用于接收云挂载的卷路径>  
```  


### Docker Compose 配置  
创建 `docker-compose.yml` 文件，内容如下（需替换 `<占位符>` 为实际路径）：  

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
      - <用于接收云挂载的路径>:/CloudNAS:shared  # 云存储挂载点（必填）  
      - <应用数据保存路径>:/Config  # 配置文件、缓存等（必填）  
      - <主机其他共享路径>:/media:shared  # 可选，主机本地媒体路径  
    devices:  
      - /dev/fuse:/dev/fuse  # 挂载 fuse 设备  
    restart: unless-stopped  # 重启策略  
    pid: "host"  # 使用主机进程命名空间  
    privileged: true  # 或尝试添加 SYS_ADMIN 权限（部分系统可能失败）  
    # cap_add:  # 部分系统 SYS_ADMIN 权限可能失效，建议用 privileged: true  
    #  - SYS_ADMIN  
    network_mode: "host"  # 主机网络模式（若不生效可改用端口映射）  
    # ports:  # 端口映射备选方案  
    #   - 19798:19798  
```  


### Docker CLI 命令  
直接通过 docker 命令行启动容器（需替换 `<占位符>` 为实际路径）：  

```bash  
docker run -d \  
  --name clouddrive \  
  --restart unless-stopped \  
  --env CLOUDDRIVE_HOME=/Config \  
  -v <用于接收云挂载的路径>:/CloudNAS:shared \  
  -v <应用数据保存路径>:/Config \  
  -v <主机其他共享路径>:/media:shared \  
  --network host \  
  --pid host \  
  --privileged \  
  --device /dev/fuse:/dev/fuse \  
  cloudnas/clouddrive2-unstable  
```  


### 配置访问  
容器启动后，通过浏览器访问以下地址进行配置：  
`http://<主机IP>:19798`
