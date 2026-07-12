---
image: itefuir/alist-strm
description: "免挂载批量创建strm文件的工具，适用于emby、jellyfin等流媒体服务器，提供WebUI管理界面，支持定时任务、多线程运行及字幕下载功能。"
source: https://xuanyuan.cloud/zh/r/itefuir/alist-strm
canonical: https://xuanyuan.cloud/zh/r/itefuir/alist-strm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/itefuir/alist-strm" title="itefuir/alist-strm Docker 镜像中文简介、标签列表与拉取命令">itefuir/alist-strm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# alist-strm

## 镜像概述

alist-strm是一个带WebUI界面的工具，用于免挂载批量创建strm文件，供emby、jellyfin等流媒体服务器使用。通过Web界面可管理配置文件、设置定时任务，支持多线程运行，帮助用户便捷地将alist中的视频文件转换为媒体播放设备可识别的strm格式。

## 核心功能与特性

1. **WebUI管理界面**：提供配置文件管理、定时任务配置等可视化操作界面
2. **定时任务**：支持通过cron表达式设置定时执行strm文件生成任务
3. **多线程运行**：可选择多个配置文件，以每个配置文件为独立线程并行运行
4. **数据存储优化**：弃用.ini配置文件，采用轻量级SQLite数据库存储配置
5. **文件对比功能**：新增文件对比（beat）功能，确保文件一致性
6. **配置管理**：支持复制配置，简化多任务配置流程
7. **字幕下载**：集成字幕下载功能，提升媒体播放体验
8. **简化部署**：仅需映射端口和存储路径即可完成Docker部署

## 使用场景与适用范围

- 适用于使用alist管理媒体资源，并需要为emby、jellyfin等流媒体服务器提供strm文件的用户
- 需批量处理大量视频文件生成strm的场景
- 需要定时自动更新strm文件的媒体服务器维护场景
- 希望通过Web界面可视化管理配置和任务的用户

## 部署与使用方法

### Docker部署

#### 命令行部署

```shell
docker run -d --name alist-strm -p 18080:5000 -v /home:/home docker.xuanyuan.run/itefuir/alist-strm:latest
```

> 说明：
> - `18080`：宿主机端口，可自定义
> - `5000`：容器内部固定端口，不可修改
> - `/home`：宿主机本地路径，用于存储配置和生成的strm文件

#### docker-compose配置

```yaml
version: "3"
services:
    alist-strm:
        stdin_open: true
        tty: true
        volumes:
            # 宿主机目录映射，格式：宿主机路径:容器内路径
            - /volume1/video:/volume1/video
        ports:
            # 宿主机端口:容器端口（容器端口固定为5000）
            - "15000:5000"
        environment:
            - TIMEZONE=Asia/Shanghai  # 设置时区
        container_name: alist-strm
        image: docker.xuanyuan.run/itefuir/alist-strm:latest
        network_mode: bridge
```

### 访问与使用

部署完成后，通过 `http://宿主机IP:宿主机端口` 访问WebUI界面，初始配置可参考界面中的默认配置示例进行设置。

## 常见问题

### 配置格式说明

运行后系统会生成默认配置，配置名称可自定义。需注意**忽略目录**为必填项，若无需特殊忽略，可填写`/1`后更新配置。

### alist令牌获取方法

1. 登录alist网页端管理员账号
2. 进入后台，点击「设置」
3. 选择「其他」选项卡，即可查看令牌

### 定时任务配置

在WebUI中选择需定时执行的任务，通过cron表达式设置执行间隔。cron表达式格式说明：

- 标准cron表达式包含5个字段（分钟 小时 日期 月份 星期），部分系统支持6个字段（增加秒）
- 特殊字符含义：
  - `*`：任意值
  - `,`：多个值分隔
  - `-`：范围表示
  - `/`：间隔频率，如`*/5`表示每5个单位
- 示例：
  - 每天凌晨1点执行：`0 1 * * *`
  - 每隔5分钟执行：`*/5 * * * *`
  - 每周一至周五9:30执行：`30 9 * * 1-5`

### 多线程运行注意事项

- 勾选多个配置文件并点击运行（或通过定时任务触发）时，系统会以每个配置文件为独立线程运行
- 若alist配置了CDN或防火墙，建议将运行本工具的IP加入白名单，避免请求过快触发阈值
