---
image: edgexfoundry/support-scheduler
description: "EdgeX Foundry的参考实现调度服务，提供内部时钟功能，可按配置的时间间隔触发EdgeX服务API URL的操作。"
source: https://xuanyuan.cloud/zh/r/edgexfoundry/support-scheduler
canonical: https://xuanyuan.cloud/zh/r/edgexfoundry/support-scheduler
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/edgexfoundry/support-scheduler" title="edgexfoundry/support-scheduler Docker 镜像中文简介、标签列表与拉取命令">edgexfoundry/support-scheduler 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 快速参考

- 维护者：[EdgeX Foundry](https://www.edgexfoundry.org)（[Linux Foundation](https://www.linuxfoundation.org/) 项目）

- 获取帮助：[EdgeX 网站](https://www.edgexfoundry.com)、[EdgeX 文档](https://docs.edgexfoundry.com)、[EdgeX Slack](https://edgexfoundry.slack.com/)、[EdgeX 项目 Wiki](https://wiki.edgexfoundry.org)

# 支持的标签及对应Dockerfile链接

- Napa
    - 3.1.0 - [Dockerfile](https://github.com/edgexfoundry/edgex-go/blob/v3.1.0/cmd/support-scheduler/Dockerfile)
- Minnesota
    - 3.0.0 - [Dockerfile](https://github.com/edgexfoundry/edgex-go/blob/v3.0.0/cmd/support-scheduler/Dockerfile)
- Levski
    - 2.3.0 - [Dockerfile](https://github.com/edgexfoundry/edgex-go/blob/v2.3.0/cmd/support-scheduler/Dockerfile)
- Kamakura
    - 2.2.0 - [Dockerfile](https://github.com/edgexfoundry/edgex-go/blob/v2.2.0/cmd/support-scheduler/Dockerfile)
- Jakarta ([LTS](https://wiki.edgexfoundry.org/pages/viewpage.action?pageId=69173332))
    - 2.1.0 - [Dockerfile](https://github.com/edgexfoundry/edgex-go/blob/v2.1.0/cmd/support-scheduler/Dockerfile)
- Ireland
    - 2.0.0 - [Dockerfile](https://github.com/edgexfoundry/edgex-go/blob/v2.0.0/cmd/support-scheduler/Dockerfile)

# 快速参考（续）

- 问题提交地址：<https://github.com/edgexfoundry/edgex-go/issues>

- 支持的架构：intel/amd64

- 发布的镜像工件详情：<https://nexus3.edgexfoundry.org>

- 本描述的来源：<https://github.com/edgexfoundry/cd-management/tree/edgex-docker-hub-documentation/image-overview-templates>

# 什么是EdgeX Foundry？

EdgeX Foundry是由Linux Foundation托管的厂商中立开源项目，旨在构建物联网边缘计算的通用开放框架。该项目的核心是一个互操作性框架，托管在完全硬件和操作系统无关的参考软件平台中，以支持即插即用组件的生态系统，从而统一市场并加速物联网解决方案的部署。

简而言之，EdgeX是边缘中间件——位于物理传感和执行"事物"与信息技术（IT）系统之间。

EdgeX的官方文档可在[docs.edgexfoundry.org](https://docs.edgexfoundry.org)获取。

![logo](https://www.lfedge.org/wp-content/uploads/2020/11/Screen-Shot-2019-10-28-at-3.45.29-PM-300x269.png)

*Edgey——EdgeX Foundry项目的官方吉祥物*

# 此镜像包含什么？

本镜像包含[支持调度器](https://docs.edgexfoundry.org/2.0/microservices/support/scheduler/Ch-Scheduling/)服务及其所有基础配置。

支持调度器微服务提供EdgeX内部的"时钟"，可在配置的时间（称为时间间隔）触发任何EdgeX服务的操作。该服务通过REST调用任何EdgeX服务的API URL以触发操作（称为间隔操作）。

支持调度器服务源代码：<https://github.com/edgexfoundry/edgex-go>

# 许可

查看本镜像中包含软件的[许可信息](https://docs.edgexfoundry.org/latest/#apache-2-license)。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能采用其他许可（例如基础发行版中的Bash等，以及包含的主要软件的任何直接或间接依赖项）。

对于任何预构建镜像的使用，镜像用户有责任确保对本镜像的任何使用都符合其中包含的所有软件的相关许可。

在镜像中名为Attribution.txt的文件中（从相关文件复制而来），可能会找到一些能够自动检测到的额外许可信息。
