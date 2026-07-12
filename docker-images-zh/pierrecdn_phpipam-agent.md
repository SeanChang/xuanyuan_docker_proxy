---
image: pierrecdn/phpipam-agent
description: "phpipam-agent镜像，作为开源IP地址管理工具phpIPAM的远程发现扫描代理，支持远程子网扫描与IP地址信息自动收集，助力高效IP管理。"
source: https://xuanyuan.cloud/zh/r/pierrecdn/phpipam-agent
canonical: https://xuanyuan.cloud/zh/r/pierrecdn/phpipam-agent
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pierrecdn/phpipam-agent" title="pierrecdn/phpipam-agent Docker 镜像中文简介、标签列表与拉取命令">pierrecdn/phpipam-agent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-phpipam-agent镜像说明

## 镜像概述
phpIPAM是一款开源的Web端IP地址管理应用，旨在提供轻量简洁的IP管理解决方案。本镜像为phpIPAM的远程发现扫描代理，可实现从远程节点对子网进行扫描，收集IP地址使用情况等信息。phpIPAM项目由Miha Petkovsek开发维护，基于GPL v3协议开源，源码地址见[GitHub](https://github.com/phpipam/phpipam-agent)，更多信息可访问[phpIPAM官网](http://phpipam.net)。

## 核心功能
- 作为phpIPAM的远程扫描代理，执行子网发现任务
- 自动收集子网内IP地址的使用状态、设备信息等数据
- 支持通过环境变量配置代理密钥与数据库连接信息
- 日志输出至标准流，便于通过`docker logs`查看运行状态

## 使用场景
- 多区域网络环境下，需要从远程节点扫描子网IP信息
- 企业内部IP地址管理系统中，实现分布式的IP扫描与数据同步
- 自动化IP资源监控场景，定期获取子网IP使用情况

## 配置说明
### 1. 前置准备（phpIPAM系统配置）
- 参考[phpIPAM部署文档](https://github.com/pierrecdn/phpipam)完成主系统安装
- 进入phpIPAM后台，通过**Administration > scan agents**配置远程代理，获取代理密钥
- 对需要扫描的子网，启用扫描功能并选择对应的远程代理

### 2. 运行容器
通过环境变量传入代理密钥与MySQL密码，运行容器：
```bash
docker run -ti -d \
  -e PHPIPAM_AGENT_KEY=你的代理密钥 \
  -e MYSQL_ENV_MYSQL_PASSWORD=你的MySQL密码 \
  --name ipam-agent \
  --link phpipam-mysql:mysql \
  docker.xuanyuan.run/pierrecdn/phpipam-agent
```
默认每1分钟执行一次扫描任务，可通过日志查看扫描结果。
===END===
