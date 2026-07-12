---
image: bladex/sentinel-dashboard
description: "阿里巴巴流量卫兵镜像（Alibaba Cloud Sentinel Dashboard）是阿里云推出的面向分布式系统与微服务架构的流量管理监控控制台，具备实时流量观测、精准流量控制、智能熔断降级及系统稳定性保障等核心功能，可帮助用户实时掌握系统流量状态、动态调整流量策略，有效防止流量过载引发的系统故障，提升分布式应用的可靠性与稳定性，是保障微服务架构高效稳定运行的重要工具。"
source: https://xuanyuan.cloud/zh/r/bladex/sentinel-dashboard
canonical: https://xuanyuan.cloud/zh/r/bladex/sentinel-dashboard
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bladex/sentinel-dashboard" title="bladex/sentinel-dashboard Docker 镜像中文简介、标签列表与拉取命令">bladex/sentinel-dashboard 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 使用 Docker 部署 Sentinel Dashboard


## 1. 下载镜像
执行以下命令拉取 Sentinel Dashboard 镜像：  
```bash
docker pull docker.xuanyuan.run/bladex/sentinel-dashboard
```


## 2. 启动容器
通过以下命令启动容器（参数说明：`--name sentinel` 指定容器名称为 `sentinel`，`-d` 后台运行，`-p 8858:8858` 映射容器 8858 端口到主机 8858 端口）：  
```bash
docker run --name sentinel -d -p 8858:8858 docker.xuanyuan.run/bladex/sentinel-dashboard
```


## 3. 登录 Web 控制台
容器启动后，按以下步骤访问控制台：  
- 访问地址：`[]  
- 账号密码：均为 `sentinel`  
- 登录成功后即可使用控制台功能。


## 4. 相关资源
- GitHub 仓库：`[]  
- 官方网站：`[]
