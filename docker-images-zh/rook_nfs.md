---
image: rook/nfs
description: "NFS镜像支持远程主机通过网络挂载文件系统，实现文件系统的网络共享与远程访问。"
source: https://xuanyuan.cloud/zh/r/rook/nfs
canonical: https://xuanyuan.cloud/zh/r/rook/nfs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rook/nfs" title="rook/nfs Docker 镜像中文简介、标签列表与拉取命令">rook/nfs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NFS Docker镜像文档


## 镜像概述

本镜像基于NFS（Network File System）协议实现，提供轻量级网络文件共享服务。通过容器化部署，可快速搭建NFS服务器，允许远程主机通过网络挂载文件系统，实现跨主机文件共享与访问。


## 核心功能和特性

- **多版本支持**：兼容NFSv3和NFSv4协议，适配不同客户端环境需求。
- **灵活权限控制**：支持自定义共享目录权限（读写/只读、用户映射、根用户权限控制等）。
- **轻量级部署**：基于精简基础镜像构建，资源占用低，启动速度快。
- **动态配置**：通过环境变量实时调整共享目录、导出选项等核心参数，无需修改配置文件。
- **跨平台兼容**：支持Linux、macOS等主流操作系统客户端挂载。
- **持久化存储**：支持通过卷挂载实现共享目录数据持久化，避免容器重启后数据丢失。


## 使用场景和适用范围

- **开发/测试环境**：多主机开发团队共享代码、测试数据或工具链。
- **容器集群数据共享**：Kubernetes或Docker Compose集群中，多容器实例共享配置文件或中间数据。
- **轻量级文件服务器**：边缘计算节点、IoT设备或临时场景下的文件分发服务。
- **跨主机备份**：作为临时备份目标，允许多主机向统一目录写入备份文件。


## 使用方法和配置说明


### 前提条件

- 运行环境需安装Docker Engine（20.10+）或Docker Desktop。
- 服务器与客户端网络互通，需开放NFS相关端口（默认2049/tcp，NFSv3需额外开放111/tcp/udp、20048/tcp/udp）。


### 快速启动（`docker run`）

```bash
docker run -d \
  --name nfs-server \
  --privileged \
  -p 2049:2049 \  # NFS主端口（v3/v4通用）
  -p 111:111 \     # RPC绑定端口（仅NFSv3需要）
  -p 20048:20048 \ # mountd守护进程端口（仅NFSv3需要）
  -e SHARED_DIRECTORY=/data \          # 容器内共享目录路径
  -e EXPORT_OPTIONS="*(rw,sync,no_subtree_check)" \  # 导出选项
  -e NFS_VERSION=3 \                   # NFS协议版本（3或4）
  -v /host/path/to/shared_data:/data \ # 宿主机目录挂载（持久化数据）
  nfs-server:latest
```


### Docker Compose配置示例

```yaml
version: '3.8'

services:
  nfs-server:
    image: docker.xuanyuan.run/nfs-server:latest
    container_name: nfs-server
    privileged: true  # NFS服务需特权模式运行
    ports:
      - "2049:2049/tcp"   # NFS主端口
      - "111:111/tcp"     # RPC绑定端口（NFSv3）
      - "111:111/udp"     # RPC绑定端口（NFSv3）
      - "20048:20048/tcp" # mountd端口（NFSv3）
      - "20048:20048/udp" # mountd端口（NFSv3）
    environment:
      - SHARED_DIRECTORY=/data
      - EXPORT_OPTIONS=*(rw,sync,no_subtree_check,root_squash)  # 生产环境建议启用root_squash
      - NFS_VERSION=4
    volumes:
      - ./host_shared_data:/data  # 宿主机目录映射，确保数据持久化
    restart: unless-stopped
```


### 环境变量说明

| 环境变量名          | 描述                                                                 | 默认值                                   |
|---------------------|----------------------------------------------------------------------|------------------------------------------|
| `SHARED_DIRECTORY`  | 容器内用于共享的目录路径，需与宿主机挂载路径对应                     | `/exports`                               |
| `EXPORT_OPTIONS`    | NFS导出选项，格式为`客户端(选项)`，`*`表示所有客户端。支持`rw`（读写）、`ro`（只读）、`sync`（同步写入）、`async`（异步写入）、`root_squash`（映射root用户为nfsnobody）、`no_root_squash`（保留root权限）等 | `*(rw,sync,no_subtree_check,no_root_squash)` |
| `NFS_VERSION`       | NFS协议版本，可选`3`或`4`                                            | `3`                                      |
| `RPC_BIND_PORT`     | RPC绑定端口（仅NFSv3需要）                                           | `111`                                    |
| `MOUNTD_PORT`       | mountd守护进程端口（仅NFSv3需要）                                    | `20048`                                  |


### 客户端挂载方法

#### Linux客户端
1. 安装NFS客户端工具：
   ```bash
   # Debian/Ubuntu
   sudo apt-get install nfs-common -y
   
   # CentOS/RHEL
   sudo yum install nfs-utils -y
   ```

2. 挂载NFS共享目录：
   ```bash
   # NFSv3
   sudo mount -t nfs -o vers=3 <nfs-server-ip>:<SHARED_DIRECTORY> /local/mount/path
   
   # NFSv4
   sudo mount -t nfs4 <nfs-server-ip>:<SHARED_DIRECTORY> /local/mount/path
   ```

#### 验证挂载
```bash
# 查看挂载状态
mount | grep nfs

# 测试写入权限（需EXPORT_OPTIONS包含rw）
echo "test" > /local/mount/path/test.txt
```


## 注意事项

1. **安全风险**：
   - `no_root_squash`选项会保留客户端root用户对共享目录的写权限，生产环境建议使用`root_squash`（默认），避免权限滥用。
   - 限制客户端IP范围（如`192.168.1.0/24(rw,...)`），替代`*`通配符，增强访问控制。

2. **端口开放**：
   - NFSv4仅需开放2049/tcp；NFSv3需额外开放111/tcp/udp、20048/tcp/udp。
   - 防火墙需允许上述端口入站流量。

3. **性能优化**：
   - 大文件传输建议使用`async`选项（异步写入），但可能存在数据丢失风险；关键数据使用`sync`（同步写入）。
   - 避免共享高IO密集型目录，容器存储性能可能受宿主机IO限制。

4. **数据持久化**：
   - 必须通过`-v`挂载宿主机目录至`SHARED_DIRECTORY`，否则容器重启后数据丢失。


## 故障排查

1. **挂载失败**：
   - 检查服务器端口是否开放：`telnet <nfs-server-ip> 2049`。
   - 验证NFS服务状态：`docker exec -it nfs-server /etc/init.d/nfs-kernel-server status`。

2. **权限拒绝**：
   - 检查`EXPORT_OPTIONS`是否包含`rw`（需读写权限）。
   - 确认客户端用户ID与共享目录权限匹配（可通过`chmod 777 <SHARED_DIRECTORY>`临时测试）。

3. **日志查看**：
   ```bash
   # 查看容器日志
   docker logs nfs-server
   
   # 查看NFS服务详细日志（容器内）
   docker exec -it nfs-server cat /var/log/syslog | grep nfs
   ```


## 总结

本NFS Docker镜像提供了便捷的网络文件共享解决方案，适用于开发测试、容器集群数据共享等场景。通过环境变量灵活配置，结合容器化优势，可快速部署并适配不同需求。生产环境中需重点关注权限控制与数据安全。
