---
image: qbanxiaoli/fastdfs
description: "用于通过docker-compose创建FastDFS+FastDHT服务的Docker镜像，支持单机和集群部署，集成tracker、storage、fastdht及nginx组件，提供便捷的分布式文件存储解决方案。"
source: https://xuanyuan.cloud/zh/r/qbanxiaoli/fastdfs
canonical: https://xuanyuan.cloud/zh/r/qbanxiaoli/fastdfs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/qbanxiaoli/fastdfs" title="qbanxiaoli/fastdfs Docker 镜像中文简介、标签列表与拉取命令">qbanxiaoli/fastdfs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# FastDFS+FastDHT(单机+集群版) Docker镜像文档

## 镜像概述和主要用途
本镜像用于通过docker-compose快速搭建FastDFS+FastDHT分布式文件存储服务，支持单机和集群两种部署模式。集成了tracker（跟踪器）、storage（存储节点）、fastdht（分布式哈希表）及nginx（HTTP访问服务）组件，提供完整的文件上传、下载、存储和管理功能。

## 核心功能和特性
- **部署灵活**：支持单机部署和多IP集群部署，集群模式下IP通过逗号分隔配置
- **组件完整**：集成FastDFS的tracker、storage，FastDHT分布式哈希服务及nginx HTTP服务
- **持久化存储**：支持数据卷挂载，确保文件数据持久化
- **便捷管理**：提供服务重启、状态查看等管理命令
- **多仓库支持**：镜像已上传至Docker Hub和阿里云容器镜像仓库，可直接拉取使用

## 使用场景和适用范围
- 中小型应用的分布式文件存储服务
- 需要高可用、可扩展的文件存储场景
- 开发测试环境的文件系统快速搭建
- 对文件上传下载有HTTP访问需求的应用

## 使用方法和配置说明

### 环境准备
1. 安装Docker和Docker Compose
2. 安装Git版本控制工具

### 项目部署（通过源码构建）
1. 克隆项目代码库
   ```bash
   git clone https://qbanxiaoli@github.com/qbanxiaoli/fastdfs.git
   ```

2. 进入项目目录
   ```bash
   cd fastdfs
   ```

3. 修改配置文件  
   编辑`docker-compose.yml`，指定服务IP（集群模式下多个IP用逗号分隔）

4. 启动服务  
   Linux环境需指定使用`docker-compose-linux.yml`文件：
   ```bash
   docker-compose up -d  # 通用环境
   # 或
   docker-compose -f docker-compose-linux.yml up -d  # Linux环境
   ```

### 测试验证
1. 进入容器
   ```bash
   docker exec -it fastdfs /bin/bash
   ```

2. 创建测试文件并上传
   ```bash
   echo "Hello FastDFS!">index.html
   fdfs_test /etc/fdfs/client.conf upload index.html
   ```

### 服务管理命令
- 重启tracker服务
  ```bash
  /usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
  ```

- 重启storage服务
  ```bash
  /usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
  ```

- 重启fastdht服务
  ```bash
  /usr/local/bin/fdhtd /etc/fdht/fdhtd.conf restart
  ```

- 查看storage状态
  ```bash
  fdfs_monitor /etc/fdfs/client.conf
  ```

### 直接拉取镜像运行（跳过构建步骤）
1. 拉取镜像（从Docker Hub或阿里云仓库）
   ```bash
   # 从Docker Hub拉取
   docker pull docker.xuanyuan.run/qbanxiaoli/fastdfs
   # 或从阿里云容器镜像仓库拉取
   docker pull registry.cn-hangzhou.aliyuncs.com/qbanxiaoli/fastdfs
   ```

2. 运行容器
   ```bash
   docker run -d --restart=always --net=host --name=fastdfs \
     -e IP=192.168.0.105 \  # 指定服务IP，集群模式用逗号分隔多个IP
     -v ~/fastdfs:/var/local \  # 挂载数据卷，实现数据持久化
     qbanxiaoli/fastdfs
   ```

> 注：`--net=host`模式会直接使用主机网络，确保容器内服务可通过主机IP访问；数据卷挂载路径`~/fastdfs`可根据实际需求修改。
