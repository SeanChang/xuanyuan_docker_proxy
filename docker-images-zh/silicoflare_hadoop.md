---
image: silicoflare/hadoop
description: "基于Ubuntu的Docker镜像，包含大数据课程所需的所有必要工具，如Hadoop、Spark、Hive等，便于快速部署和使用。"
source: https://xuanyuan.cloud/zh/r/silicoflare/hadoop
canonical: https://xuanyuan.cloud/zh/r/silicoflare/hadoop
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/silicoflare/hadoop" title="silicoflare/hadoop Docker 镜像中文简介、标签列表与拉取命令">silicoflare/hadoop 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Hadoop Stack镜像

## 镜像概述和主要用途
Hadoop Stack镜像是一个基于Ubuntu的Docker镜像，集成了大数据课程所需的各类工具，旨在通过简单步骤快速搭建完整的大数据开发环境。无需复杂的手动配置，即可在Docker容器中使用Hadoop及相关生态工具，适用于学习、测试和实践大数据技术。

## 核心功能和特性
- **全面的工具集成**：预安装最新版本的大数据工具，包括hdfs、pig、hbase、hive、flume-ng、sqoop、zookeeper、spark、kafka和postgresql
- **跨架构支持**：提供AMD（Intel）和ARM（Mac M系列）两种架构的镜像版本
- **简化部署流程**：支持直接拉取预构建镜像或自行构建，快速启动容器并初始化环境
- **端口映射配置**：默认映射Hadoop相关服务端口（9870、8088、9864等），便于外部访问

## 使用场景和适用范围
- 大数据课程学习和实验环境搭建
- Hadoop及相关生态工具的快速测试和验证
- 大数据技术初学者的入门环境
- 教学或培训中的统一开发环境配置

## 详细使用方法和配置说明

### 安装前准备
请在**主机操作系统**上执行以下步骤（不要在虚拟机中操作，避免嵌套虚拟化问题）：

1. 下载并安装Git：从[Git官网](https://git-scm.com/downloads)下载，安装时所有步骤默认点击"Next"即可
2. 下载并安装Docker Desktop：从[Docker官网](https://www.docker.com/products/docker-desktop/)下载，安装后可能需要重启电脑
3. 启动Docker Desktop应用（后台会自动启动Docker服务进程）

### 获取镜像
有两种方式获取镜像：使用预构建镜像或自行构建。

#### 使用预构建镜像
打开终端，根据CPU架构执行以下命令拉取对应镜像：
```bash
# AMD架构（Intel处理器）
docker pull docker.xuanyuan.run/silicoflare/hadoop:amd

# ARM架构（Mac M系列处理器）
docker pull docker.xuanyuan.run/silicoflare/hadoop:arm
```

#### 自行构建镜像
1. 打开终端，根据CPU架构克隆对应的仓库分支：
```bash
# AMD架构（Intel处理器）
git clone -b amd --single-branch https://github.com/silicoflare/docker-hadoop

# ARM架构（Mac M系列处理器）
git clone -b arm --single-branch https://github.com/silicoflare/docker-hadoop
```

2. 进入克隆的目录：
```bash
cd docker-hadoop
```

3. 执行构建命令（根据网络情况，构建过程可能需要15-30分钟，权限不足时可添加`sudo`）：
```bash
docker build -t hadoop .
```

4. 等待构建完成

### 使用镜像

#### 创建并启动容器
构建或拉取镜像后，执行以下命令创建容器（将命令中的`SRN`替换为大写的容器名称）：
```bash
docker run -it -p 9870:9870 -p 8088:8088 -p 9864:9864 --name SRN docker.xuanyuan.run/hadoop
```

#### 初始化环境
容器启动后，终端会显示类似以下的shell提示符：
```
root@6aaa78189146:/#
```
输入`init`并按Enter，该命令会：
- 停止所有运行中的进程
- 格式化HDFS namenodes
- 启动所有必要进程

初始化完成后，输入`jps`命令检查进程，应显示约7个运行中的进程。

#### 后续使用
使用完成后，输入`exit`退出容器。下次需要使用时：
1. 确保Docker Desktop已启动
2. 打开终端，执行以下命令重新启动容器：
```bash
docker start -ai SRN
```
3. 容器shell打开后，输入`restart`重启所有进程

## 注意事项

- **权限问题**：执行Docker命令时若出现权限错误，可在命令前添加`sudo`
- **Docker服务未运行**：若提示"docker daemon is not running"，请确保Docker Desktop已启动
- **文件复制**：
  - 从主机当前目录复制文件到容器根目录：
    ```bash
    docker cp ./filename SRN:/
    ```
  - 从容器复制文件到主机当前目录：
    ```bash
    docker cp SRN:/path/to/file .
    ```
- **端口占用**：若提示"port already allocated"，执行`docker ps`查看运行中的容器并停止占用端口的容器
- **构建失败**：若提示"request returned Internal Server Error"，表示Docker构建未成功，请重新执行构建命令

## 测试工具
镜像中预安装了以下工具的最新版本：
- hdfs
- pig
- hbase
- hive
- flume-ng
- sqoop
- zookeeper
- spark
- kafka
- postgresql

可参考[测试指南]()中的脚本测试各工具是否正常工作。
