---
image: tiangolo/nginx-rtmp
description: "这是一个基于Nginx构建并集成了nginx-rtmp-module模块的Docker镜像，主要用于实现实时多媒体（视频）的流传输功能，可支持实时视频等多媒体内容的流式传输服务。"
source: https://xuanyuan.cloud/zh/r/tiangolo/nginx-rtmp
canonical: https://xuanyuan.cloud/zh/r/tiangolo/nginx-rtmp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tiangolo/nginx-rtmp" title="tiangolo/nginx-rtmp Docker 镜像中文简介、标签列表与拉取命令">tiangolo/nginx-rtmp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# nginx-rtmp Docker 镜像


## 支持的标签及对应 Dockerfile 链接

* [`latest` _(Dockerfile)_] 

**说明**：提供[按构建日期命名的标签] 。如需固定使用某个版本，可选择此类标签，例如 `tiangolo/nginx-rtmp:latest-2020-08-16`。


## 关于 nginx-rtmp

这是一个基于 [Docker]  的镜像，集成了 [Nginx]  和 [nginx-rtmp-module]  模块，用于多媒体（视频）直播流服务。


### 简介

该 Docker 镜像基于 Nginx 和 nginx-rtmp-module 构建，可搭建 RTMP 直播服务器。构建时使用当前最新源码（Nginx 1.15.0 和 nginx-rtmp-module 1.2.1）。

开发灵感来源于其他类似镜像（如 dvdgiessen、jasonrivers、aevumdecessus 等）及 [OBS Studio 社区文章] 。其核心用途（也是测试场景）是支持从 [OBS Studio]  向多个客户端同时推流。

- **GitHub 仓库**：<[]>  
- **Docker Hub 镜像**：<[]>  


## 基本使用

### 快速启动

最简单的使用方式是直接运行容器：

```bash
docker run -d -p 1935:1935 --name nginx-rtmp docker.xuanyuan.run/tiangolo/nginx-rtmp
```

**说明**：  
- `-d`：后台运行容器；  
- `-p 1935:1935`：映射容器的 1935 端口（RTMP 默认端口）到主机；  
- `--name nginx-rtmp`：指定容器名称为 `nginx-rtmp`。  


## 使用 OBS Studio 和 VLC 测试

### 步骤

1. 按上述命令启动容器。

2. **配置 OBS Studio 推流**：  
   - 打开 OBS Studio，点击「设置」；  
   - 进入「推流」选项卡；  
   - 「推流类型」选择「自定义流媒体服务器」；  
   - 「URL」填写 `rtmp://<主机IP>/live`，将 `<主机IP>` 替换为容器所在主机的 IP（例如 `rtmp://192.168.0.30/live`）；  
   - 「流密钥」填写自定义密钥（如 `test`），后续客户端需通过此密钥拉流；  
   - 点击「确定」保存设置；  
   - 添加推流源（如「显示器捕获」），点击「开始推流」。

3. **使用 VLC 拉流播放**：  
   - 打开 VLC 播放器；  
   - 点击「媒体」→「打开网络串流」；  
   - 输入 URL：`rtmp://<主机IP>/live/<密钥>`，替换 `<主机IP>` 和 `<密钥>`（例如 `rtmp://192.168.0.30/live/test`）；  
   - 点击「播放」，即可观看 OBS 推送的直播内容。


## 调试

若推流或拉流异常，可通过容器日志排查问题：

```bash
docker logs nginx-rtmp
```


## 自定义配置

如需修改 Nginx 配置，可通过以下步骤基于原镜像扩展：

### 1. 创建自定义 nginx.conf

基于默认配置修改，原配置内容如下：

```nginx
worker_processes auto;  # 自动设置工作进程数
rtmp_auto_push on;      # 自动推送流到客户端
events {}
rtmp {
    server {
        listen 1935;             # 监听 RTMP 端口
        listen [::]:1935 ipv6only=on;  # 支持 IPv6

        application live {       # 应用名称（对应推流 URL 中的 /live）
            live on;             # 启用直播模式
            record off;          # 禁用录制
        }
    }
}
```

根据需求调整配置（参考 [nginx-rtmp-module 文档] ）。

### 2. 构建新镜像

创建 `Dockerfile`：

```Dockerfile
FROM docker.xuanyuan.run/tiangolo/nginx-rtmp
COPY nginx.conf /etc/nginx/nginx.conf  # 替换默认配置
```

构建并运行新镜像：

```bash
docker build -t my-nginx-rtmp .
docker run -d -p 1935:1935 --name docker.xuanyuan.run/my-nginx-rtmp my-nginx-rtmp
```


## 技术细节

- **基础镜像**：基于 `buildpack-deps`（进一步基于 Debian）构建，与 Python、Node、Postgres 等官方镜像共享基础层，减少本地存储占用。  
- **源码构建**：直接从 Nginx 和 nginx-rtmp-module 官方源码编译，无额外依赖，版本可控（多数同类镜像使用非官方源码或旧版本）。  
- **默认配置优化**：启用 `rtmp_auto_push` 和自动工作进程数，支持单流推送到多客户端同时拉流。  


## 版本说明

### 最新更新

- **内部优化**：主要包含构建流程改进、依赖更新及 CI 配置调整（如升级 GitHub Action 组件、修复多架构构建等）。

### 0.0.1 版本

#### 功能特性
- 支持多架构构建（如 ARM 架构，适配 Mac M1 等设备）；  
- 启用 `--with-debug` 编译选项，支持调试指令；  
- 升级 Nginx 至 1.23.2，nginx-rtmp-module 至 1.2.2。

#### 修复与优化
- 修复多架构部署构建问题；  
- 完善 CI 流程，添加自动构建和测试。


## 许可证

本项目基于 MIT 许可证开源。
