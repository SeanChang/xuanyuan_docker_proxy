---
image: owntracks/frontend
description: "为OwnTracks提供Web界面，用于位置跟踪数据的管理与查看。"
source: https://xuanyuan.cloud/zh/r/owntracks/frontend
canonical: https://xuanyuan.cloud/zh/r/owntracks/frontend
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/owntracks/frontend" title="owntracks/frontend Docker 镜像中文简介、标签列表与拉取命令">owntracks/frontend 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OwnTracks UI

![版本](https://img.shields.io/github/package-json/v/owntracks/frontend)
[![Docker 拉取次数](https://img.shields.io/docker/pulls/owntracks/frontend)](https://hub.docker.com/r/owntracks/frontend)
[![构建状态](https://github.com/owntracks/frontend/workflows/Build/badge.svg)](https://github.com/owntracks/frontend/actions?query=workflow%3ABuild+branch%3Amaster)
[![测试状态](https://github.com/owntracks/frontend/workflows/Tests/badge.svg)](https://github.com/owntracks/frontend/actions?query=workflow%3ATests+branch%3Amaster)
[![代码检查](https://github.com/owntracks/frontend/workflows/Lint/badge.svg)](https://github.com/owntracks/frontend/actions?query=workflow%3ALint+branch%3Amaster)
[![代码风格](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://github.com/prettier/prettier)
[![许可证](https://img.shields.io/github/license/owntracks/frontend?color=d63e97)](https://github.com/owntracks/frontend/blob/master/LICENSE)

![OwnTracks UI](https://raw.githubusercontent.com/owntracks/frontend/master/docs/images/owntracks-ui.png)

## 镜像概述和主要用途

OwnTracks UI是[OwnTracks](https://github.com/owntracks/recorder)的Web界面，作为Vue.js单页应用构建。虽然OwnTracks记录器本身已附带一些基本网页，但此界面提供了更高级的功能，将所有功能集中在一个地方。

![地图功能](https://raw.githubusercontent.com/owntracks/frontend/master/docs/images/map-features.png)

## 核心功能和特性

- 最新已知（实时）位置：
  - 精度可视化（圆圈）
  - 设备友好名称和图标
  - 详细信息（如可用）：时间、纬度、经度、高度、电池、速度和区域
- 位置历史记录（数据点、线条或两者同时显示）
- 位置热力图
- 快速将地图上显示的所有对象适配到视图中
- 按特定日期和时间范围显示数据
- 按用户或特定设备筛选
- 旅行距离计算
- 将选定的位置数据下载为JSON
- 高度可定制

## 使用场景和适用范围

OwnTracks UI适用于需要监控和分析OwnTracks位置数据的个人和组织。典型使用场景包括：

- 家庭定位监控，实时了解家庭成员位置
- 个人旅行记录和路线分析
- 车队或物流车辆追踪与管理
- 户外活动参与者位置监控
- 宠物追踪（配合适当的GPS设备）

该界面特别适合需要直观可视化位置数据和历史轨迹的用户，提供了比OwnTracks记录器自带基础网页更丰富的功能和更好的用户体验。

## 详细的使用方法和配置说明

### Docker安装

Docker Hub上提供了预构建的Docker镜像：[`owntracks/frontend`](https://hub.docker.com/r/owntracks/frontend)。

#### 使用docker run直接启动容器

```console
$ docker run -d -p 80:80 -e SERVER_HOST=otrecorder-host -e SERVER_PORT=8083 owntracks/frontend
```

#### 使用docker-compose部署

如果您还使用默认的compose配置运行OwnTracks Recorder，且服务名为`otrecorder`：

```yaml
version: "3"

services:
  owntracks-ui:
    image: docker.xuanyuan.run/owntracks/frontend
    ports:
      - 80:80
    volumes:
      - ./path/to/custom/config.js:/usr/share/nginx/html/config/config.js
    environment:
      - SERVER_HOST=otrecorder
      - SERVER_PORT=8083
    restart: unless-stopped
```

### 配置参数说明

#### 环境变量

| 环境变量 | 描述 | 默认值 |
|---------|------|-------|
| SERVER_HOST | OwnTracks记录器的主机名或IP地址 | 无 |
| SERVER_PORT | OwnTracks记录器的端口号 | 无 |
| LISTEN_PORT | Nginx服务器监听的端口 | 80 |

#### 自定义配置

要自定义UI配置，可以挂载自定义的`config.js`文件：

```yaml
volumes:
  - ./path/to/custom/config.js:/usr/share/nginx/html/config/config.js
```

所有可用配置选项详见[官方文档](https://github.com/owntracks/frontend/blob/master/docs/config.md)。

### 构建镜像（从源代码）

如果需要从源代码构建镜像，可以在docker-compose.yml中替换`image:`配置：

```yaml
build:
  context: ./owntracks-frontend
  dockerfile: docker/Dockerfile
```

（假设您已将此仓库克隆到与docker-compose.yml相同目录下的owntracks-frontend目录中）

## 使用方法

1. 启动容器后，通过浏览器访问服务器的IP地址或域名（取决于您的端口映射配置）
2. 初始配置需要指向OwnTracks记录器的地址和端口
3. 在界面中，您可以：
   - 查看实时位置数据
   - 浏览历史位置记录
   - 生成位置热力图
   - 按用户或设备筛选数据
   - 选择特定时间范围查看位置数据
   - 计算并查看旅行距离
   - 下载位置数据进行离线分析

界面高度可定制，您可以根据需要调整地图视图、数据显示方式和其他视觉元素。
