---
image: crazymax/samba
description: "基于Alpine Linux的Samba镜像，用于容器化部署Samba服务，实现跨平台文件共享功能"
source: https://xuanyuan.cloud/zh/r/crazymax/samba
canonical: https://xuanyuan.cloud/zh/r/crazymax/samba
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/crazymax/samba" title="crazymax/samba Docker 镜像中文简介、标签列表与拉取命令">crazymax/samba 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 概述
Samba镜像基于Alpine Linux构建，用于在容器环境中快速部署Samba服务，实现跨平台文件共享功能。详细配置及使用文档请参考[GitHub仓库](https://github.com/crazy-max/docker-samba)。

## 特性
- 基于Alpine Linux，镜像体积小，资源占用低，适合容器化环境
- 集成Samba服务核心组件，支持SMB/CIFS协议标准功能
- 支持通过配置文件或环境变量自定义服务参数，灵活适配不同共享需求
- 支持数据卷挂载，确保共享文件数据持久化存储

## 部署示例
### Docker Run快速启动
```bash
docker run -d \
  --name=samba \
  -p 139:139 \
  -p 445:445 \
  -v /host/path/to/smb.conf:/etc/samba/smb.conf \
  -v /host/path/shared:/shared \
  --restart unless-stopped \
  docker.xuanyuan.run/crazymax/samba
```
> 说明：
> - `-v /host/path/to/smb.conf:/etc/samba/smb.conf`：挂载主机Samba配置文件至容器
> - `-v /host/path/shared:/shared`：挂载共享文件存储目录
> - 端口139和445为Samba服务默认端口，需根据实际网络环境开放

## 注意事项
- 配置文件需符合Samba语法规范，详细配置项可参考Samba官方文档或GitHub仓库说明
- 共享目录权限需确保容器内进程可读写，建议设置适当的主机目录权限
- 生产环境建议使用Docker Compose或容器编排工具管理，便于配置持久化和服务扩展
