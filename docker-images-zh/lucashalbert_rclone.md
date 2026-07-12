---
image: lucashalbert/rclone
description: "这是一个基于Alpine Linux的轻量级多架构Docker镜像，内置rclone工具，支持在本地文件系统与阿里云OSS、Google Drive等多种云存储服务之间同步、复制和管理文件。"
source: https://xuanyuan.cloud/zh/r/lucashalbert/rclone
canonical: https://xuanyuan.cloud/zh/r/lucashalbert/rclone
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lucashalbert/rclone" title="lucashalbert/rclone Docker 镜像中文简介、标签列表与拉取命令">lucashalbert/rclone 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# RCLONE Docker镜像
---
基于Alpine Linux构建的多架构rclone镜像，支持arm32v6、arm32v7、arm64v8和x86_64架构，可实现本地与多种云存储服务之间的文件同步、复制和管理。

## 镜像概述
rclone是一款命令行工具，用于在本地文件系统与各类云存储服务之间同步、复制文件。本镜像基于轻量级Alpine Linux，体积小且兼容性强，支持多种硬件架构。

## 核心功能
### 支持的存储服务
- 阿里云OSS、Amazon S3、Google Drive、Dropbox、Microsoft OneDrive等数十种云存储服务
- 本地文件系统、FTP、SFTP、WebDAV等

### 关键特性
- 文件完整性校验（MD5/SHA1哈希）
- 保留文件时间戳
- 支持加密、缓存、联合存储后端
- 可选FUSE挂载功能（将云存储作为本地目录访问）
- 多线程下载到本地磁盘
- 可通过HTTP/WebDav/FTP/SFTP/dlna服务本地或远程文件

## 使用场景
1. 本地文件与云存储之间的同步备份
2. 跨不同云服务之间的数据迁移
3. 加密存储云端文件以保护隐私
4. 将云存储挂载为本地目录，方便直接访问

## 配置说明
### 环境变量
| 变量名 | 示例 | 描述 |
|--------|------|------|
| SUBCMD | mount | rclone子命令（如mount、copy、sync等） |
| CONFIG | --config /config/rclone.conf | rclone配置文件路径 |
| PARAMS | --allow-other --allow-non-empty | 传递给rclone的参数 |

### 部署示例
#### 1. 交互式创建rclone配置
```bash
sudo docker run -it \
    -v $(pwd)/config:/config \
    --entrypoint=rclone \
    lucashalbert/rclone:latest \
    --config /config/rclone.conf config
```

#### 2. 挂载远程云存储
```bash
docker run --privileged \
    -v $(pwd)/config:/config \
    -v $(pwd)/mnt:/mnt:shared \
    --env CONFIG="--config /config/rclone.conf" \
    --env SUBCMD="mount" \
    --env PARAMS="--allow-other --allow-non-empty gcache-crypt:/ /mnt/" \
    docker.xuanyuan.run/lucashalbert/rclone
```

#### 3. 本地文件复制到远程云存储
```bash
docker run --privileged \
    -v $(pwd)/config:/config \
    -v $(pwd)/mnt:/mnt:shared \
    --env CONFIG="--config /config/rclone.conf" \
    --env SUBCMD="copy" \
    --env PARAMS="-v /mnt/Pictures gdrive-crypt:/Pictures" \
    docker.xuanyuan.run/lucashalbert/rclone
```

#### 4. 进入运行中的容器shell
```bash
docker exec -it rclone sh
