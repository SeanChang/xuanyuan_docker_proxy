# DOCKER-PORT-VIEWER Docker 容器化部署指南

![DOCKER-PORT-VIEWER Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-docker-port-viewer.png)

*分类: Docker,DOCKER-PORT-VIEWER | 标签: docker-port-viewer,docker,部署教程 | 发布时间: 2025-12-14 12:36:10*

> DOCKER-PORT-VIEWER是一款基于TypeScript开发的简单应用程序，主要功能是帮助用户查看当前运行中的Docker容器信息。通过容器化部署，用户可以快速搭建并使用该工具，无需复杂的环境配置。本文将详细介绍如何通过Docker方式部署DOCKER-PORT-VIEWER，包括环境准备、镜像拉取、容器部署、功能测试及生产环境建议等内容，旨在为用户提供清晰、可复现的部署方案。

## 概述

DOCKER-PORT-VIEWER是一款基于TypeScript开发的简单应用程序，主要功能是帮助用户查看当前运行中的Docker容器信息。通过容器化部署，用户可以快速搭建并使用该工具，无需复杂的环境配置。本文将详细介绍如何通过Docker方式部署DOCKER-PORT-VIEWER，包括环境准备、镜像拉取、容器部署、功能测试及生产环境建议等内容，旨在为用户提供清晰、可复现的部署方案。


## 环境准备

### Docker环境安装

在开始部署前，需确保服务器已安装Docker环境。推荐使用以下一键安装脚本快速部署Docker及相关组件：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

执行完成后，可通过`docker --version`命令验证安装是否成功。


## 镜像准备

### 拉取DOCKER-PORT-VIEWER镜像

使用以下命令通过轩辕镜像访问支持地址拉取最新版本的DOCKER-PORT-VIEWER镜像：

```bash
docker pull xxx.xuanyuan.run/hollowpnt/docker-port-viewer:latest
```

拉取完成后，可通过`docker images | grep hollowpnt/docker-port-viewer`命令确认镜像是否成功下载。


## 容器部署

### 基本部署命令

使用以下命令启动DOCKER-PORT-VIEWER容器，具体端口映射请参考官方文档确定容器内端口：

```bash
docker run -d \
  --name docker-port-viewer \
  --restart unless-stopped \
  -p <host-port>:<container-port> \
  hollowpnt/docker-port-viewer:latest
```

**参数说明**：
- `-d`：后台运行容器
- `--name`：指定容器名称为docker-port-viewer
- `--restart unless-stopped`：容器退出时自动重启（除非手动停止）
- `-p <host-port>:<container-port>`：端口映射，需根据[DOCKER-PORT-VIEWER镜像文档（轩辕）](https://xuanyuan.cloud/r/hollowpnt/docker-port-viewer)确定容器内端口

### 挂载Docker套接字（可选）

由于DOCKER-PORT-VIEWER需要访问Docker守护进程以获取容器信息，通常需要挂载Docker套接字文件，具体命令如下（根据实际需求调整）：

```bash
docker run -d \
  --name docker-port-viewer \
  --restart unless-stopped \
  -p <host-port>:<container-port> \
  -v /var/run/docker.sock:/var/run/docker.sock \
  hollowpnt/docker-port-viewer:latest
```

> **注意**：挂载Docker套接字可能带来安全风险，请根据实际场景评估是否需要此配置，并参考官方文档了解安全最佳实践。


## 功能测试

### 访问应用界面

容器启动后，可通过以下方式验证服务是否正常运行：

1. **使用curl命令测试**：
   ```bash
   curl http://<服务器IP>:<host-port>
   ```
   若返回HTML内容或应用相关响应，说明服务基本正常。

2. **通过浏览器访问**：
   在本地浏览器中输入`http://<服务器IP>:<host-port>`，若能看到DOCKER-PORT-VIEWER的界面，则表示前端服务正常。

### 查看容器日志

通过以下命令查看容器运行日志，确认是否有错误信息：

```bash
docker logs docker-port-viewer
```

若日志中无明显错误（如"Server started on port XXX"等提示），则表示应用启动成功。

### 验证容器信息展示功能

在界面中查看是否能正确显示当前服务器上运行的Docker容器列表及端口信息，这是DOCKER-PORT-VIEWER的核心功能。若未显示容器信息，可检查Docker套接字挂载配置或容器日志中的错误提示。


## 生产环境建议

### 资源限制配置

为避免容器过度占用服务器资源，建议添加资源限制参数：

```bash
docker run -d \
  --name docker-port-viewer \
  --restart unless-stopped \
  --memory 512m \
  --cpus 0.5 \
  -p <host-port>:<container-port> \
  -v /var/run/docker.sock:/var/run/docker.sock \
  hollowpnt/docker-port-viewer:latest
```
其中`--memory 512m`限制内存使用为512MB，`--cpus 0.5`限制CPU使用为0.5核，可根据服务器配置和实际需求调整。

### 网络隔离

在生产环境中，建议为DOCKER-PORT-VIEWER创建独立的Docker网络，增强网络隔离性：

```bash
# 创建网络
docker network create port-viewer-network

# 使用独立网络启动容器
docker run -d \
  --name docker-port-viewer \
  --restart unless-stopped \
  --network port-viewer-network \
  -p <host-port>:<container-port> \
  hollowpnt/docker-port-viewer:latest
```

### 定期更新镜像

为获取最新功能和安全修复，建议定期更新镜像：

```bash
# 拉取最新镜像
docker pull xxx.xuanyuan.run/hollowpnt/docker-port-viewer:latest

# 停止并删除旧容器
docker stop docker-port-viewer && docker rm docker-port-viewer

# 使用新镜像启动容器（保留原配置参数）
docker run -d \
  --name docker-port-viewer \
  --restart unless-stopped \
  -p <host-port>:<container-port> \
  -v /var/run/docker.sock:/var/run/docker.sock \
  hollowpnt/docker-port-viewer:latest
```


## 故障排查

### 容器无法启动

1. **检查端口占用**：
   使用`netstat -tulpn | grep <host-port>`确认宿主机端口是否被占用，若已占用，需更换`<host-port>`或停止占用进程。

2. **查看启动日志**：
   移除`-d`参数以前台模式启动容器，直接查看错误输出：
   ```bash
   docker run --name docker-port-viewer -p <host-port>:<container-port> hollowpnt/docker-port-viewer:latest
   ```

3. **检查Docker套接字权限**：
   若挂载了`/var/run/docker.sock`，可能存在权限问题，可尝试添加`--user root`参数临时测试（生产环境不建议长期使用root用户）。

### 无法显示容器信息

1. **确认Docker套接字挂载**：
   检查容器是否正确挂载了Docker套接字：
   ```bash
   docker inspect docker-port-viewer | grep "/var/run/docker.sock"
   ```

2. **验证Docker守护进程状态**：
   确保宿主机Docker服务正常运行：
   ```bash
   systemctl status docker
   ```

3. **查看应用日志**：
   通过`docker logs docker-port-viewer`查看应用是否有Docker API访问错误，根据错误提示调整配置。


## 参考资源

- [DOCKER-PORT-VIEWER镜像文档（轩辕）](https://xuanyuan.cloud/r/hollowpnt/docker-port-viewer)
- [DOCKER-PORT-VIEWER镜像标签列表](https://xuanyuan.cloud/r/hollowpnt/docker-port-viewer/tags)
- Docker官方文档：[https://docs.docker.com/](https://docs.docker.com/)


## 总结

本文详细介绍了DOCKER-PORT-VIEWER的Docker容器化部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境优化及故障排查等内容。通过Docker部署，用户可快速搭建该应用，实现对当前运行容器的可视化查看。

**关键要点**：
- 使用一键脚本可快速部署Docker环境，简化前期准备工作
- 镜像拉取需使用轩辕访问支持地址`xxx.xuanyuan.run/hollowpnt/docker-port-viewer:latest`
- 部署时需根据官方文档确定正确的端口映射及必要的挂载配置（如Docker套接字）
- 生产环境中应配置资源限制、网络隔离，并定期更新镜像以保障安全性

**后续建议**：
- 深入阅读[DOCKER-PORT-VIEWER镜像文档（轩辕）](https://xuanyuan.cloud/r/hollowpnt/docker-port-viewer)，了解更多高级功能及配置选项
- 根据实际使用场景调整容器资源配置，平衡性能与资源占用
- 关注[DOCKER-PORT-VIEWER镜像标签列表](https://xuanyuan.cloud/r/hollowpnt/docker-port-viewer/tags)，及时获取新版本更新信息
- 评估生产环境中的安全需求，采取适当措施限制容器权限，避免不必要的系统资源暴露

