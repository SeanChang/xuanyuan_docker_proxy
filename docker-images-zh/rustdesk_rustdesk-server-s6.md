---
image: rustdesk/rustdesk-server-s6
description: "基于s6-overlay的RustDesk Server镜像专为容器化部署打造，集成hbbs和hbbr核心服务，兼容Docker与Podman环境，具备自动重启、进程监控及服务自愈能力，配置流程简化，支持安全的P2P远程桌面连接，无需依赖第三方中转服务器，适用于企业或个人搭建私有化远程桌面服务，可有效保障数据传输隐私与连接稳定性，轻量级架构提升部署效率与资源利用率。"
source: https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server-s6
canonical: https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server-s6
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server-s6" title="rustdesk/rustdesk-server-s6 Docker 镜像中文简介、标签列表与拉取命令">rustdesk/rustdesk-server-s6 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server-s6" title="rustdesk/rustdesk-server-s6 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server-s6</a>

### 基于s6-overlay的RustDesk Server镜像  


这些Docker镜像基于s6-overlay构建，专门用于在容器环境中运行RustDesk Server。s6-overlay提供了轻量的进程管理能力，能自动启停RustDesk Server的两个核心服务：`hbbs`（ID注册服务）和`hbbr`（中继服务），适合需要容器化部署的场景。  


### 使用方法  

#### 快速启动  
如果只需简单测试或临时使用，可直接运行以下命令启动容器（首次启动会自动生成服务器密钥）：  
```bash
docker run -d --name rustdesk-server \
  -p 21115:21115 -p 21116:21116 -p 21116:21116/udp -p 21117:21117 \
  rustdesk/rustdesk-server-s6:latest
```  


#### 持久化配置与数据  
生产环境建议挂载数据卷，保存密钥、配置等数据（避免容器删除后丢失）：  
```bash
# 创建本地目录用于持久化数据
mkdir -p /path/to/rustdesk-data

# 启动容器并挂载数据卷
docker run -d --name rustdesk-server \
  -p 21115:21115 -p 21116:21116 -p 21116:21116/udp -p 21117:21117 \
  -v /path/to/rustdesk-data:/data \
  rustdesk/rustdesk-server-s6:latest
```  
数据卷`/data`会存放生成的密钥文件（`id_ed25519`和`id_ed25519.pub`）及服务日志。  


### 环境变量配置  
可通过环境变量自定义服务参数，常用变量如下：  

| 变量名               | 说明                          | 默认值       | 示例值                  |  
|----------------------|-------------------------------|--------------|-------------------------|  
| `RUSTDESK_SERVER_KEY` | 服务器密钥（`hbbs`/`hbbr`共用） | 自动生成     | `your_custom_32char_key`|  
| `HBBS_ARGS`           | `hbbs`服务额外参数            | 空           | `-r hbbr.example.com`   |  
| `HBBR_ARGS`           | `hbbr`服务额外参数            | 空           | `-l 0.0.0.0:21117`       |  
| `RELAY_PORT`          | 中继服务端口（`hbbr`）        | 21117        | 21118                   |  
| `REG_PORT`            | 注册服务端口（`hbbs`）        | 21116        | 21119                   |  


#### 带环境变量的启动示例  
指定自定义密钥和端口：  
```bash
docker run -d --name rustdesk-server \
  -p 21115:21115 -p 21119:21119 -p 21119:21119/udp -p 21118:21118 \
  -v /path/to/rustdesk-data:/data \
  -e RUSTDESK_SERVER_KEY="my_secure_server_key_123" \
  -e REG_PORT=21119 \
  -e RELAY_PORT=21118 \
  rustdesk/rustdesk-server-s6:latest
```  


### 构建镜像（自定义）  
如果需要修改源码或添加自定义配置，可手动构建镜像：  

1. 克隆仓库：  
   ```bash
   git clone []   cd rustdesk-server
   ```  

2. 进入`s6`目录：  
   ```bash
   cd docker/s6
   ```  

3. 构建镜像（可指定标签和基础镜像）：  
   ```bash
   docker build -t my-rustdesk-server-s6:latest .
   ```  


### 注意事项  
- **端口映射**：需确保宿主机开放容器映射的端口（如21115-21117），防火墙规则同步放行。  
- **密钥保存**：首次启动后，`/data`目录下的`id_ed25519.pub`是客户端连接需用的公钥，建议备份。  
- **服务状态**：容器启动后，可通过`docker logs rustdesk-server`查看`s6-overlay`和服务运行日志，排查问题。
