---
image: dockurr/umbrel
description: "Docker容器化的umbrelOS，用于便捷运行比特币节点等去中心化应用。"
source: https://xuanyuan.cloud/zh/r/dockurr/umbrel
canonical: https://xuanyuan.cloud/zh/r/dockurr/umbrel
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/dockurr/umbrel" title="dockurr/umbrel Docker 镜像中文简介、标签列表与拉取命令">dockurr/umbrel — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/dockurr/umbrel" title="dockurr/umbrel Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/dockurr/umbrel</a>

# umbrelOS Docker镜像文档


## 镜像概述与主要用途

umbrelOS Docker镜像是umbrelOS（一款专注于自托管的操作系统）的容器化版本。该镜像将umbrelOS封装为Docker容器，使其无需专用硬件或虚拟机，即可在任何支持Docker的系统上运行，从而降低自托管服务的部署门槛。


## 核心功能与特性

- **无需专用硬件或虚拟机**：摆脱对专用设备的依赖，可在已安装Docker的普通电脑、服务器或开发环境中部署。
- **容器化部署**：简化安装与维护流程，支持快速迁移和升级，降低自托管服务的技术门槛。


## 使用场景与适用范围

### 使用场景
- **个人自托管服务**：在个人电脑或服务器上搭建私有云、媒体服务器、文件共享等自托管应用。
- **开发者测试环境**：快速部署umbrelOS实例，用于应用开发、功能测试或兼容性验证。
- **资源复用**：在闲置设备（如旧电脑、树莓派等）上部署，充分利用现有硬件资源。

### 适用范围
支持Docker的各类操作系统，包括Linux、Windows（需WSL2支持）、macOS等。


## 详细使用方法

### Docker Compose部署

创建`docker-compose.yml`文件，添加以下配置：

```yaml
services:
  umbrel:
    image: dockurr/umbrel
    container_name: umbrel
    pid: host  # 使用主机PID命名空间，确保容器内进程正常运行
    ports:
      - 80:80  # 映射Web管理界面端口
    volumes:
      - ./umbrel:/data  # 存储umbrelOS数据
      - /var/run/docker.sock:/var/run/docker.sock  # 与宿主机Docker引擎通信
    restart: always  # 容器退出时自动重启
    stop_grace_period: 1m  # 停止容器前的等待时间
```

执行以下命令启动服务：
```bash
docker-compose up -d
```


### Docker CLI部署

直接使用Docker命令行启动容器：

```bash
docker run -it --rm \
  --name umbrel \
  --pid=host \
  -p 80:80 \
  -v "${PWD:-.}/umbrel:/data" \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  --stop-timeout 60 \
  dockurr/umbrel
```

参数说明：
- `--pid=host`：使用主机PID命名空间
- `-p 80:80`：映射Web界面端口
- `-v "${PWD:-.}/umbrel:/data"`：挂载数据存储目录
- `-v "/var/run/docker.sock:/var/run/docker.sock"`：允许容器与宿主机Docker交互
- `--stop-timeout 60`：停止容器前等待60秒


### GitHub Codespaces部署

点击下方按钮在GitHub Codespaces中快速启动：

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/dockur/umbrel)


## 配置说明

### 卷挂载配置

容器依赖以下卷挂载实现数据持久化和功能正常运行：

| 挂载路径          | 作用说明                          | 必要性       |
|-------------------|-----------------------------------|--------------|
| `/data`           | 存储umbrelOS的所有数据（配置、应用数据等） | 必需（持久化） |
| `/var/run/docker.sock` | 与宿主机Docker引擎通信，用于管理内部服务 | 必需         |


### 更改存储位置

默认数据存储路径为`./umbrel`（当前目录下的umbrel文件夹），如需自定义存储位置，修改卷挂载配置中的宿主机路径即可：

```yaml
volumes:
  - /path/to/your/custom/folder:/data  # 替换为自定义目录或命名卷
```


## 常见问题（FAQ）

### 如何更改umbrelOS的数据存储位置？

通过修改`/data`卷的宿主机路径实现。例如，在Docker Compose配置中：

```yaml
volumes:
  - /mnt/external-drive/umbrel-data:/data  # 使用外部硬盘存储数据
```

将`/mnt/external-drive/umbrel-data`替换为实际存储路径或Docker命名卷。


## 截图

![umbrelOS界面截图](https://raw.githubusercontent.com/dockur/umbrel/master/.github/screen.png)
