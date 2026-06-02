---
image: opendronemap/nodeodm
description: "NodeODM的自动化构建镜像，用于简化NodeODM的部署与使用"
source: https://xuanyuan.cloud/zh/r/opendronemap/nodeodm
canonical: https://xuanyuan.cloud/zh/r/opendronemap/nodeodm
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opendronemap/nodeodm" title="opendronemap/nodeodm Docker 镜像中文简介、标签列表与拉取命令">opendronemap/nodeodm — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/opendronemap/nodeodm" title="opendronemap/nodeodm Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/opendronemap/nodeodm</a>

# NodeODM 中文技术文档


## 镜像概述和主要用途

NodeODM 是一个用于处理航拍图像的[标准 API 规范](https://github.com/OpenDroneMap/NodeODM/blob/master/docs/index.adoc)，支持与 [ODM](https://github.com/OpenDroneMap/ODM) 等引擎配合使用。该 API 被 [WebODM](https://github.com/OpenDroneMap/WebODM)、[CloudODM](https://github.com/OpenDroneMap/CloudODM) 和 [PyODM](https://github.com/OpenDroneMap/PyODM) 等客户端采用。本仓库提供基于 NodeJS 的高性能、生产就绪型参考实现。


## 核心功能和特性

- **标准 API 兼容**：遵循 OpenDroneMap 定义的标准 API 规范，确保与生态系统中各客户端兼容
- **高性能处理**：优化的 NodeJS 实现，支持大规模航拍图像处理任务
- **Docker 化部署**：提供官方 Docker 镜像，简化跨平台部署流程
- **GPU 加速支持**：集成 ODM 的 GPU 加速能力，优化 SIFT 特征提取等计算密集型任务
- **灵活存储配置**：支持外部存储设备挂载，方便结果数据持久化
- **多平台适配**：支持 Linux 本地部署、Windows 独立可执行文件及 Docker 容器化运行
- **测试模式**：内置模拟 ODM 调用的测试模式，便于开发和自动化测试


## 使用场景和适用范围

- **航拍图像处理**：对无人机采集的图像进行三维重建、正射影像生成等处理
- **客户端集成**：作为 WebODM、CloudODM 等平台的后端处理节点
- **自动化工作流**：通过 API 集成到自定义工作流，实现批处理任务自动化
- **开发与测试**：为 ODM 生态系统客户端开发提供标准 API 测试环境
- **资源受限环境**：支持低配置设备（需本地编译 ODM）及高性能 GPU 环境部署


## 详细使用方法和配置说明

### Docker 部署（推荐）

#### 基本运行

通过 Docker 快速启动 NodeODM 服务：

```bash
docker run -p 3000:3000 opendronemap/nodeodm
```

- `-p 3000:3000`：映射容器 3000 端口到主机，用于 API 访问和 Web 界面


#### 系统连接说明

- **Linux**：直接访问 `http://127.0.0.1:3000`
- **Windows/OSX**：需获取 Docker 主机 IP：
  ```bash
  docker-machine ip  # 返回 Docker 虚拟机 IP，如 192.168.99.100
  ```
  访问 `http://<Docker主机IP>:3000`


#### 使用外部存储

将处理结果存储到外部硬盘，需挂载 `/var/www/data` 目录：

```bash
docker run -p 3000:3000 -v /mnt/external_hd:/var/www/data opendronemap/nodeodm
```

- `-v /mnt/external_hd:/var/www/data`：将主机 `/mnt/external_hd` 目录映射到容器数据目录，实现结果持久化


#### GPU 加速配置

若需启用 GPU 加速 SIFT 处理，需使用 `gpu` 标签镜像并配置 GPU 访问：

```bash
docker run -p 3000:3000 --gpus all opendronemap/nodeodm:gpu
```

- **前置条件**：
  - 主机需安装 NVIDIA Docker 工具包（参考 [nvidia-docker 文档](https://github.com/NVIDIA/nvidia-docker)）
  - GPU 需支持 OpenCL（NVIDIA/AMD 显卡均兼容）
- **验证 GPU 配置**：
  ```bash
  docker run --rm --gpus all nvidia/cuda:10.0-base nvidia-smi
  ```
  若输出 GPU 信息（如型号、驱动版本），则配置成功


### Windows 独立运行包

无需 Docker，直接运行 Windows 可执行文件（需单独安装 [ODM](https://github.com/OpenDroneMap/ODM)）：

1. 从 [发布页](https://github.com/OpenDroneMap/NodeODM/releases) 下载 `nodeodm-windows-x64.zip`
2. 解压后执行：
   ```bash
   nodeodm.exe --odm_path c:\path\to\ODM  # 指定 ODM 安装路径
   ```


### 本地运行（Ubuntu）

适用于已本地部署 ODM 的环境：

#### 依赖安装

```bash
# 安装 Entwine
sudo apt-get install -y libcurl4-openssl-dev libtbb-dev
git clone https://github.com/connormanning/entwine.git
cd entwine && mkdir build && cd build
cmake .. && make && sudo make install

# 安装 Node.js 及其他依赖
sudo curl --silent --location https://deb.nodesource.com/setup_6.x | sudo bash -
sudo apt-get install -y nodejs python-gdal p7zip-full unzip

# 克隆并配置 NodeODM
git clone https://github.com/OpenDroneMap/NodeODM
cd NodeODM
npm install
```


#### 启动服务

```bash
# 基本启动（默认 ODM 路径需配置）
node index.js

# 指定 ODM 路径
node index.js --odm_path /home/username/OpenDroneMap

# 自定义端口
node index.js --port 8000 --odm_path /home/username/OpenDroneMap
```


### 使用 PM2 进程管理

通过 PM2 实现后台运行及开机自启：

```bash
# 安装 PM2
npm install pm2 -g

# 启动服务
pm2 start processes.json

# 配置开机自启
pm2 save
pm2 startup  # 按提示执行生成的命令
```

- 监控服务状态：`pm2 status`


### 测试模式

用于开发或自动化测试，模拟 ODM 调用（无需实际部署 ODM）：

```bash
node index.js --test  # 启用测试模式，返回 /tests 目录中的模拟数据
```


## 配置参数说明

| 参数         | 说明                                  | 示例                                  |
|--------------|---------------------------------------|---------------------------------------|
| `--port`     | 指定服务端口                          | `--port 8000`                         |
| `--odm_path` | ODM 可执行文件路径（本地运行时必填）  | `--odm_path /home/user/ODM`           |
| `--config`   | 指定 JSON 配置文件                    | `--config config.default.json`        |
| `--test`     | 启用测试模式，模拟 ODM 处理流程       | `--test`                              |
| `--help`     | 查看所有命令行选项                    | `node index.js --help`                |


## API 文档

完整 API 规范及使用说明请参考 [官方文档](https://github.com/OpenDroneMap/NodeODM/blob/master/docs/index.adoc)。

- **版本迁移注意**：API v2.x 相比 v1.x 存在部分不兼容变更，迁移指南见 [MIGRATION.md](https://github.com/OpenDroneMap/NodeODM/blob/master/MIGRATION.md)。


## 测试图像

可使用 [ODM 测试数据集](https://github.com/OpenDroneMap/ODMdata) 或 [示例图像](https://github.com/dakotabenjamin/odm_data) 进行功能验证。


## 扩展功能建议

NodeODM 定位为轻量级 API 服务，如需完整无人机测绘解决方案，建议集成 [WebODM](https://github.com/OpenDroneMap/WebODM)（基于 NodeODM 的可视化平台）。


## 贡献与开发

- **小功能贡献**：直接提交 Pull Request
- **重大功能**：建议先通过 Issue 发起讨论
- **代码规范**：新代码需遵循 ES6 语法，保持代码风格统一


## 路线图

开发计划及需求功能列表请参考 [issues 标签 "new feature"](https://github.com/OpenDroneMap/NodeODM/issues?q=is%3Aopen+is%3Aissue+label%3A%22new+feature%22)。
