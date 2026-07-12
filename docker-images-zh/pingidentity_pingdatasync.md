---
image: pingidentity/pingdatasync
description: "此镜像提供独立的PingDataSync™，用于在容器环境中部署和运行Ping Identity的数据同步服务。"
source: https://xuanyuan.cloud/zh/r/pingidentity/pingdatasync
canonical: https://xuanyuan.cloud/zh/r/pingidentity/pingdatasync
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pingidentity/pingdatasync" title="pingidentity/pingdatasync Docker 镜像中文简介、标签列表与拉取命令">pingidentity/pingdatasync 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ping Identity PingDataSync™ Docker镜像

## 概述

本Docker镜像提供独立的PingDataSync™，用于在容器环境中部署和运行Ping Identity的数据同步服务，支持企业级数据同步需求的容器化部署。

## 文档资源

* [PingDataSync Docker镜像](https://devops.pingidentity.com/docker-images/pingdatasync/) - 镜像详细信息
* [Ping DevOps文档](https://devops.pingidentity.com) - Ping Identity DevOps入门指南
* [Ping DevOps计划注册](https://devops.pingidentity.com/how-to/devopsRegistration/) - 注册Ping DevOps计划
* [DevOps Github仓库](https://github.com/topics/ping-devops) - Docker构建、入门指南和服务器配置文件

## 许可信息

容器化软件、操作系统软件及其他非产品组成部分的第三方软件，根据其适用的开源许可进行许可。

对于镜像中安装的Ping Identity产品（"软件"）适用的许可：

* 通过将环境变量`PING_IDENTITY_ACCEPT_EULA`设置为"Yes"，镜像用户同意其在Docker镜像中使用本软件受本段所述许可协议条款约束。若用户（或其组织）未从Ping Identity购买付费商业许可，适用许可条款见[此处](https://www.pingidentity.com/en/legal/subscription-agreement.html)，软件视为"试用产品"；若已购买有效商业许可且已签署软件许可协议，则适用该协议条款，否则仍适用上述链接条款。
* 运行镜像中软件前必须获取许可：
  * 评估许可获取方式见[此处](https://devops.pingidentity.com/get-started/prereqs/#evaluation-license)
  * 商业许可可通过联系Ping Identity购买

本镜像可能包含基础发行版及依赖软件的第三方组件，相关许可信息见[第三方软件许可列表](https://github.com/pingidentity/pingidentity-devops-getting-started/blob/master/3RD_PARTY_SOFTWARE.md)。用户需自行确保使用本镜像符合所有包含软件的许可要求。

## 商业支持

本协议提供的软件按"现状"提供，不提供任何明示、暗示或法定的保证或陈述。

商业支持详情请联系：devops_program@pingidentity.com

## Docker镜像保留政策

Ping Identity维护的Docker镜像在Docker Hub上的保留期限为**一（1）个日历年**（自发布之日起）。为确保使用稳定性，建议将所需镜像版本标记并推送到您自己的容器仓库。

Ping Identity不保证Docker Hub上镜像的持续可用性。

## Docker支持政策

* Ping Identity支持政策：https://devops.pingidentity.com/home/supportPolicy/
* Ping Identity镜像支持政策：https://devops.pingidentity.com/docker-images/imageSupport/

## 使用方法

### 前提条件

* 接受许可协议：设置环境变量`PING_IDENTITY_ACCEPT_EULA=Yes`
* 获取有效许可：评估许可或商业许可（见许可信息部分）

### 基本部署示例

```bash
docker run -d \
  --name pingdatasync \
  -e PING_IDENTITY_ACCEPT_EULA=Yes \
  docker.xuanyuan.run/pingidentity/pingdatasync:latest
```

### 配置说明

核心环境变量：
* `PING_IDENTITY_ACCEPT_EULA`: 必须设置为"Yes"以接受许可协议条款
* 其他配置参数及高级用法请参考[官方文档](https://devops.pingidentity.com/docker-images/pingdatasync/)

## 版权

Copyright © 2023 Ping Identity. 保留所有权利。
