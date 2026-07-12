---
image: activestate/jdk
description: "ActiveState的可定制、低/无漏洞Java开发工具包(JDK)容器镜像，提供安全、精简的Java工具链，包含核心库和标准构建工具，为Java应用提供生产就绪的安全基础。"
source: https://xuanyuan.cloud/zh/r/activestate/jdk
canonical: https://xuanyuan.cloud/zh/r/activestate/jdk
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/activestate/jdk" title="activestate/jdk Docker 镜像中文简介、标签列表与拉取命令">activestate/jdk 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ActiveState JDK 容器镜像

## 镜像概述

ActiveState安全容器为完全可定制、低至无漏洞的容器镜像提供安全基础。本镜像为ActiveState的最小化**Java开发工具包(JDK)** 容器，捆绑了安全、最新的Java工具链，用于构建和运行Java应用。通过仅包含JDK的必要组件（核心库和标准构建工具），保持精简体积，同时提供安全的生产就绪基础。

## 核心功能与特性

- **安全基础**：低至无漏洞的容器环境，减少安全风险
- **精简设计**：仅包含JDK必要组件，降低镜像体积和攻击面
- **可定制性**：支持使用ActiveState超过4000万安全组件的目录进行定制
- **合规强化**：可根据需求提供符合FedRAMP、SOC 2等标准的进一步加固

## 使用场景

- Java应用的开发、测试和评估环境
- 需要安全基础的Java应用构建流程
- 对容器体积和安全性有较高要求的Java项目

## 免责声明

本开发容器按"原样"提供，仅用于内部测试、评估和开发目的。其并非为生产环境设计、意图或保证使用。在任何生产、商业或面向客户的环境中使用本容器的风险由您自行承担。提供者不对容器的性能、安全性或特定用途的适用性提供任何明示或暗示的保证。

## 许可证

详见[ActiveState SCA工具限制许可证](https://cdn.activestate.com/wp-content/uploads/2025/06/ActiveState-SCA-Tools-Restricted-License-1.pdf)

## 下载镜像

```shell
docker pull docker.xuanyuan.run/activestate/jdk:latest
```

## 运行容器

```shell
docker run --rm docker.xuanyuan.run/activestate/jdk --help
```

## 定制与支持

如需使用ActiveState的4000万+安全组件目录定制镜像，请[提交请求](https://www.activestate.com/custom-container-request?utm_source=dockerhub&utm_medium=thirdparty&utm_campaign=dockerhub&utm_content=jdk)。如需符合合规标准（如FedRAMP、SOC 2等）的进一步加固，可[联系我们](https://www.activestate.com/company/contact-us/?utm_source=dockerhub&utm_medium=thirdparty&utm_campaign=dockerhub&utm_content=jdk)。

更多信息和支持，请访问[文档](https://docs.activestate.com/platform/containers?utm_source=dockerhub&utm_medium=thirdparty&utm_campaign=dockerhub&utm_content=jdk)或[联系我们](https://www.activestate.com/company/contact-us/?utm_source=dockerhub&utm_medium=thirdparty&utm_campaign=dockerhub&utm_content=jdk)。
