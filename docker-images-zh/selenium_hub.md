---
image: selenium/hub
description: "Selenium Grid Hub模式镜像作为分布式测试中心节点，用于接收并分配测试请求至各执行节点，实现跨环境自动化测试任务的并行管理与执行。"
source: https://xuanyuan.cloud/zh/r/selenium/hub
canonical: https://xuanyuan.cloud/zh/r/selenium/hub
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/selenium/hub" title="selenium/hub Docker 镜像中文简介、标签列表与拉取命令">selenium/hub 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Selenium Grid Hub Docker镜像文档


## 镜像概述和主要用途

Selenium Grid Hub镜像提供[Selenium Grid Hub](https://www.selenium.dev/documentation/grid/getting_started/#hub-and-node)功能，需与一个或多个[Selenium Grid Node](https://www.selenium.dev/documentation/grid/getting_started/#hub-and-node)配合使用，用于实现[WebDriver测试的远程执行](https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/)。Hub作为Selenium Grid的中心节点，负责协调和分发测试任务至连接的Node节点，支持分布式测试环境的构建。


## 核心功能和特性

- **中心化任务管理**：作为Grid架构的核心，负责接收测试请求并分发至可用的Node节点
- **节点通信协调**：通过事件总线（Event Bus）与Node节点建立通信，管理节点注册与状态监控
- **多节点支持**：可同时连接多个不同浏览器（如Chrome、Firefox、Edge）的Node节点
- **可视化监控界面**：提供Web UI界面（`http://localhost:4444/ui`），用于查看Grid运行状态和任务执行情况
- **Docker网络集成**：支持通过Docker网络实现Hub与Node的容器化部署和通信


## 使用场景和适用范围

- **分布式测试执行**：需在多台机器或多环境中并行运行WebDriver测试的场景
- **跨浏览器兼容性测试**：同时在Chrome、Firefox、Edge等多种浏览器环境中验证应用兼容性
- **测试资源优化**：集中管理测试资源，提高测试执行效率和资源利用率
- **CI/CD集成**：作为持续集成/持续部署流程的一部分，自动化执行Web UI测试


## 使用方法和配置说明

### 前置条件

- 已安装Docker Engine（20.10+推荐）
- 已安装Docker Compose（可选，用于多容器编排）


### 步骤1：创建Docker网络

Hub与Node需在同一网络中通过容器名称通信，首先创建专用网络：

```bash
docker network create grid
```


### 步骤2：启动Selenium Grid Hub

使用创建的网络启动Hub容器，映射必要端口：

```bash
docker run -d -p 4442-4444:4442-4444 --net grid --name selenium-hub docker.xuanyuan.run/selenium/hub:latest
```

**参数说明**：
- `-d`：后台运行容器
- `-p 4442-4444:4442-4444`：映射端口（4442=事件总线发布端口，4443=事件总线订阅端口，4444=Hub服务端口）
- `--net grid`：加入之前创建的`grid`网络
- `--name selenium-hub`：指定容器名称（Node需通过此名称通信）


### 步骤3：启动Selenium Grid Node

在同一网络中启动Node容器，需配置与Hub的事件总线通信参数。以下示例包含Chrome、Edge、Firefox三种浏览器节点：

#### Linux/macOS命令

```bash
# Chrome节点
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub \
    --shm-size="2g" \
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 \
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
    docker.xuanyuan.run/selenium/node-chrome:latest

# Edge节点
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub \
    --shm-size="2g" \
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 \
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
    docker.xuanyuan.run/selenium/node-edge:latest

# Firefox节点
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub \
    --shm-size="2g" \
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 \
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
    docker.xuanyuan.run/selenium/node-firefox:latest
```

#### Windows PowerShell命令

```powershell
# Chrome节点
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub `
    --shm-size="2g" `
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 `
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 `
    selenium/node-chrome:latest

# Edge节点
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub `
    --shm-size="2g" `
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 `
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 `
    selenium/node-edge:latest

# Firefox节点
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub `
    --shm-size="2g" `
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 `
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 `
    selenium/node-firefox:latest
```

**Node配置参数说明**：
- `--shm-size="2g"`：设置共享内存大小（浏览器运行需较大共享内存，避免崩溃）
- 环境变量：
  - `SE_EVENT_BUS_HOST`：Hub容器名称（需与Hub的`--name`一致）
  - `SE_EVENT_BUS_PUBLISH_PORT`：Hub事件总线发布端口（固定4442）
  - `SE_EVENT_BUS_SUBSCRIBE_PORT`：Hub事件总线订阅端口（固定4443）


### 步骤4：配置WebDriver测试

将测试代码中的远程WebDriver目标地址指向Hub服务端口：

```java
// Java示例
WebDriver driver = new RemoteWebDriver(new URL("http://localhost:4444"), new ChromeOptions());
```


### 步骤5：监控Grid状态（可选）

通过Grid UI查看节点状态和任务执行情况：  
访问 `http://localhost:4444/ui`


### 清理资源

测试完成后，停止并删除容器，可选择删除网络：

```bash
# 停止所有Grid容器（Hub和Node）
docker stop selenium-hub $(docker ps -q --filter "network=grid")

# 删除所有Grid容器
docker rm selenium-hub $(docker ps -aq --filter "network=grid")

# 删除Grid网络（可选）
docker network rm grid
```


## 标签选择说明

镜像标签遵循以下结构，用于指定Selenium Grid版本和发布日期：

```
selenium/hub-<Major>.<Minor>.<Patch>-<YYYYMMDD>
```

**示例**：Selenium Grid Server 4.9.0（2023年4月26日发布）对应标签：
- `selenium/hub:4`（主版本4的最新版）
- `selenium/hub:4.9`（主版本4.9的最新版）
- `selenium/hub:4.9.0`（具体版本4.9.0）
- `selenium/hub:4.9.0-20230426`（包含发布日期的完整标签）

**建议**：生产环境使用完整标签（如`4.9.0-20230426`）以固定版本，避免`latest`标签带来的版本变动风险。


## 环境变量说明

| 环境变量名                  | 作用                          | 示例值           |
|---------------------------|-------------------------------|------------------|
| `SE_EVENT_BUS_HOST`       | Hub容器名称（Node与Hub通信地址） | `selenium-hub`   |
| `SE_EVENT_BUS_PUBLISH_PORT` | Hub事件总线发布端口           | `4442`           |
| `SE_EVENT_BUS_SUBSCRIBE_PORT` | Hub事件总线订阅端口         | `4443`           |


## 扩展文档与许可

### 完整文档
更多配置示例和高级用法，请参考GitHub项目文档：  
[Docker-Selenium官方文档](https://github.com/SeleniumHQ/docker-selenium/blob/trunk/README.md#hub-and-nodes)


### 许可协议
本项目基于[Apache License 2.0](https://raw.githubusercontent.com/SeleniumHQ/selenium/trunk/LICENSE)开源许可协议，源代码由社区志愿者维护。
