# 🚀 MinIO Docker 部署全指南

![🚀 MinIO Docker 部署全指南](https://img.xuanyuan.dev/docker/blog/docker-minio.png)

*分类: Docker,MinIO | 标签: MinIO,docker,部署教程 | 发布时间: 2025-10-07 02:58:22*

> MinIO 是一款**高性能对象存储系统**，完全兼容 Amazon S3 协议。你可以把它理解为「自建版的私有云存储」——可存放图片、视频、备份文件、日志等。官方镜像：`minio/minio`，国内加速镜像：[https://xuanyuan.cloud/r/minio/minio](https://xuanyuan.cloud/r/minio/minio)

## 1. MinIO 简介

### 💡 什么是 MinIO？

MinIO 是一个**轻量级、高性能、开源的对象存储服务**，专为云原生应用设计。
它支持 S3 API，可直接与 AWS SDK、Rclone、Nextcloud、Backup 工具等集成。

### 🌟 核心特点

* **兼容 S3 API**：可直接替代 Amazon S3。
* **极高性能**：单节点可轻松达到百 Gbps 吞吐。
* **轻量部署**：单个二进制或容器即可运行。
* **水平扩展**：支持分布式多节点集群。
* **完备安全机制**：支持访问密钥、HTTPS、策略控制。

### 🧭 典型应用场景

| 场景       | 示例                | 适用人群   |
| -------- | ----------------- | ------ |
| 文件/图片存储  | Web/APP 上传、CDN 资源 | 新手/中级  |
| 备份与归档    | 数据库备份、日志归档        | 开发者/运维 |
| AI / 大数据 | 模型、训练集存储          | 高级工程师  |

---

## 2. 部署前准备

### 2.1 硬件要求

| 资源  | 开发环境（练手） | 生产环境（业务使用）     | 说明            |
| --- | -------- | -------------- | ------------- |
| CPU | ≥ 2 核    | ≥ 4 核          | 生产建议更高        |
| 内存  | ≥ 4 GB   | ≥ 8 GB         | MinIO 对内存性能敏感 |
| 磁盘  | ≥ 20 GB  | ≥ 100 GB (SSD) | 生产建议使用 SSD    |

---

### 2.2 软件要求

* **Docker**：≥ 24.0.0
  检查版本：

  ```bash
  docker --version
  ```
* **Docker Compose**：≥ v2.26.1
  检查版本：

  ```bash
  docker compose version
  ```

如未安装，可使用轩辕一键安装脚本：
👉 [https://xuanyuan.cloud/install/linux](https://xuanyuan.cloud/install/linux)
### 执行一键安装命令
登录 Linux 服务器，直接复制粘贴下面的命令，回车执行：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

---

### 2.3 网络与安全提示

* 默认端口：

  * Web 控制台：`9001`
  * API 服务：`9000`
* ⚠️ **生产环境请勿暴露公网端口！**
  建议反向代理或启用 TLS 加密访问。
* 国内环境推荐使用轩辕镜像访问支持源。

---

## 3. 下载 MinIO 镜像

### 3.1 使用轩辕镜像（推荐）

```bash
# 拉取最新稳定版 MinIO 镜像
docker pull xxx.xuanyuan.run/minio/minio:latest

# （可选）改名为官方镜像名
docker tag xxx.xuanyuan.run/minio/minio:latest minio/minio:latest
# 删除临时标签，节省空间
docker rmi xxx.xuanyuan.run/minio/minio:latest
```

### 3.2 使用官方源（备用，如果可用）

```bash
docker pull minio/minio:latest
```

### 3.3 验证镜像下载

```bash
docker images | grep minio
```

示例输出：

```
REPOSITORY        TAG       IMAGE ID       CREATED         SIZE
minio/minio       latest    e8b734f7b8aa   6 days ago      250MB
```

---

## 4. 快速部署（单节点版）

MinIO 单节点非常适合开发测试或小型项目。

### 4.1 `docker run` 一键启动

```bash
docker run -d \
  --name minio-server \                # 容器名称
  -p 9000:9000 \                       # API 端口
  -p 9001:9001 \                       # 控制台端口
  -e MINIO_ROOT_USER=admin \           # 管理员用户名
  -e MINIO_ROOT_PASSWORD=YourStrongPwd2024! \  # 管理员密码（务必强密码）
  -v minio-data:/data \                # 数据持久化卷
  --restart unless-stopped \           # 自动重启
  minio/minio server /data --console-address ":9001"
```

### 参数说明

| 参数                          | 作用        |
| --------------------------- | --------- |
| `-e MINIO_ROOT_USER`        | 设置登录用户名   |
| `-e MINIO_ROOT_PASSWORD`    | 登录密码（≥8位） |
| `-v minio-data:/data`       | 持久化存储数据   |
| `--console-address ":9001"` | 控制台端口     |
| `--restart unless-stopped`  | 自动重启策略    |

---

### 4.2 使用 Docker Compose 部署（推荐）

#### 创建 `docker-compose.yml`

```yaml
version: "3.8"
services:
  minio:
    image: xxx.xuanyuan.run/minio/minio:latest
    container_name: minio-server
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=YourStrongPwd2024!
    volumes:
      - minio-data:/data
    ports:
      - "9000:9000"
      - "9001:9001"
    command: server /data --console-address ":9001"
    restart: unless-stopped

volumes:
  minio-data:
```

#### 启动服务

```bash
docker compose up -d
```

#### 查看状态

```bash
docker ps | grep minio
```

若状态为 `Up`，说明服务已启动。

---

## 5. 验证与访问

### 5.1 打开 Web 控制台

浏览器访问：

👉 [http://localhost:9001](http://localhost:9001)

输入你设置的：

* 用户名：`admin`
* 密码：`YourStrongPwd2024!`

进入后即可上传、管理文件。

---

### 5.2 使用命令行连接（mc 客户端）

安装 MinIO 客户端（mc）：

```bash
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/
```

配置连接：

```bash
mc alias set local http://localhost:9000 admin YourStrongPwd2024!
```

验证连接：

```bash
mc ls local
```

---

## 6. 创建存储桶与上传文件

```bash
# 创建桶
mc mb local/mybucket

# 上传文件
mc cp ./test.jpg local/mybucket/

# 查看文件
mc ls local/mybucket/
```

访问方式：

```
![test](http://localhost:9000/mybucket/test.jpg)
```

---

## 7. 生产环境部署建议

| 项目       | 推荐做法                                   |
| -------- | -------------------------------------- |
| ⚙️ 数据持久化 | 挂载到本地磁盘或 NAS                           |
| 🔒 安全访问  | 启用 HTTPS (证书路径: `/root/.minio/certs/`) |
| 👥 用户权限  | 使用 Access Key / Secret Key 控制访问        |
| 🧱 高可用   | 使用 MinIO 分布式部署（见下节）                    |

---

## 8. 高可用部署（分布式 MinIO）

### 8.1 基本结构

4 个节点（最小推荐数量）：

```
node1:/data1 node2:/data2 node3:/data3 node4:/data4
```

### 8.2 启动命令示例（单机模拟4节点）

```bash
docker run -d --name minio-distributed \
  -p 9000:9000 -p 9001:9001 \
  -v /mnt/data1:/data1 -v /mnt/data2:/data2 \
  -v /mnt/data3:/data3 -v /mnt/data4:/data4 \
  -e MINIO_ROOT_USER=admin \
  -e MINIO_ROOT_PASSWORD=YourStrongPwd2024! \
  minio/minio server /data{1...4} --console-address ":9001"
```

这样 MinIO 就会自动启用分布式模式，实现冗余和高可用。

---

## 9. 备份与恢复

### 9.1 备份数据

```bash
mc mirror local/mybucket /backup/mybucket
```

### 9.2 恢复数据

```bash
mc mirror /backup/mybucket local/mybucket
```

生产环境可用 `crontab` 定时执行备份任务。

---

## 10. 常见问题排查

| 问题                       | 可能原因     | 解决方案                          |
| ------------------------ | -------- | ----------------------------- |
| 无法访问 9000/9001           | 防火墙拦截    | 关闭或放行端口                       |
| 登录失败                     | 密码错误或未设置 | 检查 `MINIO_ROOT_USER/PASSWORD` |
| 上传报错 “permission denied” | 权限不足     | 检查宿主机挂载目录权限                   |
| 容器重启后数据丢失                | 未挂载卷     | 使用 `-v minio-data:/data`      |

---

## 11. 参考文档

* [MinIO 官方文档](https://min.io/docs/minio/)
* [MinIO Client (mc) 命令大全](https://min.io/docs/minio/linux/reference/minio-mc.html)
* 进阶功能：

  * 启用版本控制（object versioning）
  * 集成外部存储（NAS、Ceph、S3）
  * 部署在 Kubernetes (Helm Chart)

---

## ✅ 总结

| 目标      | 操作                       |
| ------- | ------------------------ |
| 🚀 快速上手 | `docker run ...`         |
| 🧱 稳定部署 | 用 Docker Compose         |
| 🧩 扩展场景 | 分布式 + HTTPS + Access Key |
| 💾 备份保障 | `mc mirror` 定期备份         |

> 到这里，你已经能独立部署一个完整可用的 MinIO 服务。
> 无论是自用、开发、还是生产环境，都能满足稳定与高性能需求。

