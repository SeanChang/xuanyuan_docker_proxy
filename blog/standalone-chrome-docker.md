---
id: 121
title: STANDALONE-CHROME Docker 容器化部署指南
slug: standalone-chrome-docker
summary: STANDALONE-CHROME（镜像名称：selenium/standalone-chrome）是一个容器化的Selenium Grid独立模式解决方案，集成了Chrome浏览器环境。该镜像提供了Selenium Grid Standalone服务，使开发者能够远程运行WebDriver测试。通过Docker容器化部署，可以快速搭建稳定、一致的自动化测试环境，避免因本地环境差异导致的测试不一致问题。
category: Docker,STANDALONE-CHROME
tags: standalone-chrome,docker,部署教程
image_name: selenium/standalone-chrome
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-standalone-chrome.png"
status: published
created_at: "2025-12-10 06:52:13"
updated_at: "2025-12-10 06:52:13"
---

# STANDALONE-CHROME Docker 容器化部署指南

> STANDALONE-CHROME（镜像名称：selenium/standalone-chrome）是一个容器化的Selenium Grid独立模式解决方案，集成了Chrome浏览器环境。该镜像提供了Selenium Grid Standalone服务，使开发者能够远程运行WebDriver测试。通过Docker容器化部署，可以快速搭建稳定、一致的自动化测试环境，避免因本地环境差异导致的测试不一致问题。

## 概述

STANDALONE-CHROME（镜像名称：selenium/standalone-chrome）是一个容器化的Selenium Grid独立模式解决方案，集成了Chrome浏览器环境。该镜像提供了Selenium Grid Standalone服务，使开发者能够远程运行WebDriver测试。通过Docker容器化部署，可以快速搭建稳定、一致的自动化测试环境，避免因本地环境差异导致的测试不一致问题。

Selenium Grid允许将测试用例分发到多台机器或多个浏览器实例上执行，而独立模式(Standalone mode)则提供了一种简单的部署方式，将Selenium Hub和Node的功能集成在单个实例中。这种部署模式特别适合小型测试团队或个人开发者使用，也可作为更复杂Selenium Grid集群的基础组件。

本文档提供了STANDALONE-CHROME的完整Docker部署方案，包括环境准备、镜像拉取、容器部署、功能测试、生产环境建议和故障排查等内容，旨在帮助用户快速实现容器化的Selenium测试环境搭建。

## 环境准备

在开始部署STANDALONE-CHROME之前，需要确保目标服务器已安装Docker环境。推荐使用以下一键安装脚本，该脚本会自动配置Docker环境并优化相关参数：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

执行上述命令后，系统会自动完成Docker的安装和基础配置。安装完成后，可以通过以下命令验证Docker是否正常运行：

```bash
docker --version
docker info
```

若命令输出Docker版本信息和系统信息，则说明Docker环境已准备就绪。

## 镜像准备

### 拉取STANDALONE-CHROME镜像

使用以下命令通过轩辕镜像访问支持地址拉取推荐版本的STANDALONE-CHROME镜像：

```bash
docker pull xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

镜像拉取完成后，可以使用以下命令验证镜像是否成功下载：

```bash
docker images | grep selenium/standalone-chrome
```

若输出中包含`selenium/standalone-chrome`和`beta`标签的相关信息，则说明镜像拉取成功。如需查看所有可用版本标签，可访问[STANDALONE-CHROME镜像标签列表](https://xuanyuan.cloud/r/selenium/standalone-chrome/tags)。

## 容器部署

### 基本部署命令

STANDALONE-CHROME容器的基本部署命令如下：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

参数说明：
- `-d`: 后台运行容器
- `--name standalone-chrome`: 指定容器名称为standalone-chrome，便于后续管理
- `-p 4444:4444`: 将容器的4444端口映射到主机的4444端口，用于Selenium Grid服务
- `-p 7900:7900`: 将容器的7900端口映射到主机的7900端口，用于Web界面访问
- `--shm-size="2g"`: 设置共享内存大小为2GB，这是运行Chrome浏览器的推荐配置

### 自定义部署选项

根据实际需求，可以添加以下参数来自定义容器配置：

#### 1. 环境变量配置

可以通过`-e`参数设置环境变量，例如调整Selenium服务的超时时间：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  -e SE_NODE_SESSION_TIMEOUT=300 \
  -e SE_NODE_MAX_SESSIONS=5 \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

#### 2. 持久化日志

若需要持久化保存容器日志，可以通过挂载主机目录的方式实现：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  -v /path/on/host/logs:/var/log/selenium \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

请将`/path/on/host/logs`替换为实际的主机日志目录。

#### 3. 自定义网络

如果需要将容器加入自定义Docker网络，可以使用`--network`参数：

```bash
# 创建自定义网络（如果尚未创建）
docker network create selenium-network

# 在自定义网络中运行容器
docker run -d \
  --name standalone-chrome \
  --network selenium-network \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

容器启动后，可以使用以下命令检查容器运行状态：

```bash
docker ps | grep standalone-chrome
```

若STATUS列显示为"Up"状态，则说明容器已成功启动。

## 功能测试

容器部署完成后，需要进行基本的功能测试以确保服务正常运行。

### 检查容器状态

首先确认容器处于运行状态：

```bash
docker inspect -f '{{.State.Status}}' standalone-chrome
```

若输出为"running"，则容器正在运行中。

### 查看容器日志

通过查看容器日志，可以了解服务启动情况和运行状态：

```bash
docker logs standalone-chrome
```

正常情况下，日志中会显示Selenium Grid启动信息，包括绑定的端口、节点注册状态等。当看到类似"Started Selenium Standalone xxx"的日志时，表示服务已成功启动。

### 访问Selenium Grid控制台

打开浏览器，访问以下地址查看Selenium Grid控制台：

```
http://<服务器IP>:4444
```

若看到Selenium Grid的Web界面，则说明服务已正常运行。

### 访问VNC界面

STANDALONE-CHROME提供了VNC界面，可用于查看浏览器操作过程：

```
http://<服务器IP>:7900/?autoconnect=1&resize=scale&password=secret
```

默认密码为"secret"。通过此界面，可以直观地观察自动化测试的执行过程。

### 执行简单的测试请求

可以使用curl命令发送简单的测试请求，验证Selenium Grid是否能够正常响应：

```bash
curl -X POST http://<服务器IP>:4444/wd/hub/session \
  -H "Content-Type: application/json" \
  -d '{"desiredCapabilities":{"browserName":"chrome"}}'
```

正常情况下，该命令会返回一个包含sessionId的JSON响应，表示成功创建了一个浏览器会话。

## 生产环境建议

在将STANDALONE-CHROME部署到生产环境时，建议考虑以下配置和优化：

### 资源配置

根据实际测试需求调整容器的资源分配：

1. **内存配置**：Chrome浏览器运行时会消耗较多内存，建议根据并发测试数量调整内存分配。可以通过`--memory`和`--memory-swap`参数限制容器的内存使用：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  --memory=4g \
  --memory-swap=4g \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

2. **CPU限制**：根据测试需求和服务器配置，可以适当限制容器的CPU使用：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  --cpus=2 \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

### 安全加固

1. **非root用户运行**：为提高安全性，可以指定非root用户运行容器：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  --user 1000:1000 \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

2. **修改默认密码**：VNC界面的默认密码为"secret"，建议在生产环境中修改为强密码：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  -e VNC_NO_PASSWORD=1 \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

或者设置自定义密码：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  -e VNC_PASSWORD=your_strong_password \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

### 高可用性配置

1. **自动重启**：配置容器在异常退出时自动重启：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  --restart=unless-stopped \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

2. **健康检查**：添加健康检查，以便Docker能够自动检测服务状态：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  --health-cmd "curl -f http://localhost:4444/wd/hub || exit 1" \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

### 数据持久化

若需要保存测试结果、截图等数据，可以挂载主机目录到容器内：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  -v /path/on/host/test-results:/home/seluser/Downloads \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

## 故障排查

当STANDALONE-CHROME容器出现异常时，可以通过以下方法进行排查：

### 容器无法启动

1. **检查端口占用**：确认宿主机的4444和7900端口是否已被其他服务占用：

```bash
netstat -tulpn | grep -E '4444|7900'
```

若端口已被占用，可以停止占用端口的服务，或修改容器端口映射：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4445:4444 \  # 修改主机端口为4445
  -p 7901:7900 \  # 修改主机端口为7901
  --shm-size="2g" \
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

2. **检查资源限制**：若宿主机资源不足，可能导致容器无法启动。可以通过`dmesg`命令查看是否有资源限制相关的错误信息。

3. **查看启动日志**：即使容器未能正常启动，也可以通过以下命令查看日志：

```bash
docker logs standalone-chrome
```

### 服务无法访问

1. **检查网络配置**：确认宿主机防火墙是否允许访问相关端口：

```bash
# 对于iptables
iptables -L | grep -E '4444|7900'

# 对于firewalld
firewall-cmd --list-ports | grep -E '4444|7900'
```

如端口未开放，需要添加防火墙规则允许访问：

```bash
# 对于firewalld
firewall-cmd --add-port=4444/tcp --permanent
firewall-cmd --add-port=7900/tcp --permanent
firewall-cmd --reload
```

2. **检查端口映射**：确认容器端口映射配置是否正确：

```bash
docker port standalone-chrome
```

该命令会显示容器端口与主机端口的映射关系。

### 浏览器启动失败

1. **检查共享内存配置**：Chrome浏览器需要足够的共享内存，若`--shm-size`设置过小，可能导致浏览器启动失败。建议至少设置为2g：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \  # 确保共享内存设置足够
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

2. **查看详细日志**：通过容器日志获取更详细的错误信息：

```bash
docker logs standalone-chrome | grep -i error
```

### 容器运行缓慢

1. **检查资源使用情况**：查看容器的CPU、内存使用情况：

```bash
docker stats standalone-chrome
```

若资源使用率接近或达到限制，考虑增加资源分配或优化测试脚本。

2. **调整并发测试数量**：若同时运行过多测试用例，可能导致系统资源耗尽。可以通过环境变量调整最大会话数：

```bash
docker run -d \
  --name standalone-chrome \
  -p 4444:4444 \
  -p 7900:7900 \
  --shm-size="2g" \
  -e SE_NODE_MAX_SESSIONS=3 \  # 减少最大并发会话数
  xxx.xuanyuan.run/selenium/standalone-chrome:beta
```

## 参考资源

1. [STANDALONE-CHROME镜像文档（轩辕）](https://xuanyuan.cloud/r/selenium/standalone-chrome)
2. [STANDALONE-CHROME镜像标签列表](https://xuanyuan.cloud/r/selenium/standalone-chrome/tags)
3. [Selenium官方文档](https://www.selenium.dev/documentation/)
4. [Selenium Grid文档](https://www.selenium.dev/documentation/grid/)
5. [Docker-Selenium项目GitHub](https://github.com/SeleniumHQ/docker-selenium)
6. [Docker官方文档](https://docs.docker.com/)

## 总结

本文详细介绍了STANDALONE-CHROME的Docker容器化部署方案，从环境准备、镜像拉取、容器部署到功能测试和故障排查，提供了一套完整的实施指南。STANDALONE-CHROME作为Selenium Grid的独立模式部署方案，为自动化测试提供了便捷、一致的执行环境，特别适合小型测试团队或个人开发者使用。

**关键要点**：
- 使用一键脚本可快速部署Docker环境
- 通过轩辕镜像访问支持可提升STANDALONE-CHROME镜像的下载访问表现
- 容器部署时需注意设置适当的共享内存大小（--shm-size）
- 默认提供4444（Selenium Grid）和7900（VNC）两个端口服务
- 生产环境中应考虑资源配置、安全加固和高可用性设计

**后续建议**：
- 深入学习Selenium Grid的高级特性，如分布式测试、负载均衡等
- 根据实际测试需求调整容器资源配置和并发会话数
- 结合CI/CD流程，实现自动化测试的持续集成
- 定期关注镜像更新，及时升级以获取最新功能和安全修复
- 对于大规模测试场景，可考虑部署完整的Selenium Grid集群架构

通过合理配置和优化，STANDALONE-CHROME可以成为自动化测试流程中的重要基础设施，帮助团队提高测试效率和软件质量。如需了解更多细节，请参考本文提供的参考资源或官方文档。

