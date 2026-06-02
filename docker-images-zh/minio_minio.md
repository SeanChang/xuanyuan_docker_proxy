---
image: minio/minio
description: "多云对象存储是一种能跨多个云服务提供商（如AWS、Azure、Google Cloud等）统一管理数据的解决方案，以对象形式（含数据、元数据及唯一标识符）存储大量非结构化数据，具备灵活的数据分发、跨云容灾备份能力，可按需弹性扩展存储资源，有效避免单一云厂商锁定，提升数据管理效率与安全性。"
source: https://xuanyuan.cloud/zh/r/minio/minio
canonical: https://xuanyuan.cloud/zh/r/minio/minio
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/minio/minio" title="minio/minio Docker 镜像中文简介、标签列表与拉取命令">minio/minio — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/minio/minio" title="minio/minio Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/minio/minio</a>

# MinIO 快速入门指南


## 简介

MinIO 是一款高性能对象存储，基于 GNU Affero 通用公共许可证 v3.0 发布，兼容 Amazon S3 云存储服务 API。适用于构建机器学习、数据分析及应用数据负载的高性能基础设施。


## 安装指南

### 说明
以下安装步骤均为**独立模式**（Standalone），适合早期开发和评估。版本控制、对象锁定、桶复制等功能需通过**纠删码分布式部署**实现。生产环境或扩展开发建议启用纠删码，需至少 4 块硬盘/节点，详见 [MinIO 纠删码快速入门]([])。


### 容器安装（推荐）
使用以下命令运行独立 MinIO 容器（需 podman）：

```sh
podman run -p 9000:9000 -p 9001:9001 \
  quay.io/minio/minio server /data --console-address ":9001"
```

- **默认凭据**：`minioadmin:minioadmin`  
- **访问 Console**：浏览器访问 `[]  
- **持久化存储**：通过 `-v` 参数映射主机目录至容器，例如 `-v /mnt/data:/data` 将主机 `/mnt/data` 映射为容器数据目录。  
- **客户端工具**：支持 S3 兼容工具（如 MinIO Client `mc`），详见 [使用 `mc` 测试连接](#测试使用-minio-client-mc)。


### macOS 安装
#### Homebrew（推荐）
1. 安装 MinIO：  
   ```sh
   brew install minio/stable/minio
   ```
   > 若之前通过 `brew install minio` 安装，需先卸载重装：  
   > ```sh
   > brew uninstall minio && brew install minio/stable/minio
   > ```

2. 启动服务（替换 `/data` 为实际存储路径）：  
   ```sh
   minio server /data
   ```

#### 二进制下载
1. 下载并授权：  
   ```sh
   wget []   chmod +x minio
   ```

2. 启动服务（替换 `/data` 为实际存储路径）：  
   ```sh
   ./minio server /data
   ```


### GNU/Linux 安装
根据架构下载对应二进制文件，替换 `/data` 为存储路径：

#### 64位 Intel/AMD（默认）
```sh
wget [] +x minio
./minio server /data
```

#### 其他架构
| 架构                  | 下载链接                                                                 |
|-----------------------|--------------------------------------------------------------------------|
| 64位 ARM              | <[]>               |
| 64位 PowerPC LE (ppc64le) | <[]>           |
| IBM Z-Series (s390x)  | <[]>               |


### Microsoft Windows 安装
1. 下载可执行文件：  
   [[]]([])  

2. 启动服务（替换 `D:\` 为存储路径，需在 `minio.exe` 目录执行或添加至系统 `PATH`）：  
   ```cmd
   minio.exe server D:\
   ```


### 源码安装（仅开发者）
需 Go 1.17+ 环境，适合开发测试，**不建议生产使用**：  
```sh
GO111MODULE=on go install github.com/minio/minio@latest
```


## 部署建议

### 防火墙端口开放
MinIO 默认使用 9000 端口，需确保防火墙允许该端口访问：

#### ufw（Debian 系）
```sh
# 允许单个端口
ufw allow 9000
# 允许端口范围（如 9000-9010）
ufw allow 9000:9010/tcp
```

#### firewall-cmd（CentOS）
```sh
# 查看活跃区域（如 public）
firewall-cmd --get-active-zones
# 开放端口（永久生效）
firewall-cmd --zone=public --add-port=9000/tcp --permanent
# 重载配置
firewall-cmd --reload
```

#### iptables（RHEL/CentOS）
```sh
# 允许单个端口
iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
# 允许端口范围
iptables -A INPUT -p tcp --dport 9000:9010 -j ACCEPT
# 重启服务
service iptables restart
```


## 测试连接

### 通过 MinIO Console 测试
- 访问地址：`[]  
- 默认凭据：`minioadmin:minioadmin`  
- 功能：创建桶、上传文件、浏览存储内容。  

> 自定义 Console 端口：启动时添加 `--console-address ":端口号"`（如 `--console-address ":9001"`）。  
> 反向代理场景：设置 `MINIO_BROWSER_REDIRECT_URL` 环境变量指定外部访问地址（如 `[] 测试使用 MinIO Client `mc`
`mc` 是 MinIO 命令行工具，支持文件系统和 S3 兼容存储操作（如 `ls`、`cp`、`mirror`）。详见 [MinIO Client 快速入门]([])。


## 升级 MinIO
MinIO 升级支持零停机，建议所有节点同时升级。

### 不同部署方式的升级步骤
#### 手动安装（二进制）
```sh
mc admin update <minio 别名，如 myminio>
```

#### 离线环境（无外网）
1. 从 [[]]([]) 下载对应版本二进制文件；  
2. 替换现有二进制（如 `/opt/bin/minio`），赋予执行权限：  
   ```sh
   chmod +x /opt/bin/minio
   ```
3. 重启服务：  
   ```sh
   mc admin service restart <别名>
   ```

#### Systemd 服务（RPM/DEB 包）
- 并行升级所有节点的 RPM/DEB 包；或替换二进制后重启服务：  
  ```sh
  mc admin service restart <别名>
  ```

### 升级检查清单
1. 先在测试环境（DEV/QA/UAT）验证升级；  
2. 升级前阅读 [Release Notes]([])；  
3. `mc admin update` 需 MinIO 进程对二进制目录有写权限；  
4. 容器环境需通过更新镜像升级，不支持 `mc admin update`；  
5. **禁止逐个节点升级**，需所有节点同时升级。


## 进一步探索
- [MinIO 纠删码快速入门]([])  
- [使用 `aws-cli` 访问 MinIO]([])  
- [使用 `s3cmd` 访问 MinIO]([])  
- [MinIO SDKs]([])（支持多语言）  
- [MinIO 文档中心]([])


## 贡献与许可证
- **贡献指南**：参见 [MinIO Contributor's Guide]([])。  
- **许可证**：  
  - 源码：GNU AGPLv3（详见 [LICENSE]([])）。  
  - 文档：CC BY 4.0（详见 [文档许可证]([])）。  
  - 合规性：参见 [License Compliance]([])。
