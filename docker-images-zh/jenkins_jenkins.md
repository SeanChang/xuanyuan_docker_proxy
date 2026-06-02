---
image: jenkins/jenkins
description: "这是一款领先的开源自动化服务器，主要用于软件开发中的持续集成、持续部署（CI/CD）及各类自动化流程管理，支持代码构建、自动化测试、应用部署等全流程任务，具备高度可扩展性、跨平台运行能力和丰富的插件生态，能显著提升开发效率、简化复杂操作并降低运维成本，在全球开发者社区和企业中拥有广泛应用与良好口碑。"
source: https://xuanyuan.cloud/zh/r/jenkins/jenkins
canonical: https://xuanyuan.cloud/zh/r/jenkins/jenkins
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkins/jenkins" title="jenkins/jenkins Docker 镜像中文简介、标签列表与拉取命令">jenkins/jenkins — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jenkins/jenkins" title="jenkins/jenkins Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jenkins/jenkins</a>

# Jenkins 持续集成与部署服务器  


这是一个功能完整的 Jenkins 服务器，基于每周版和 LTS（长期支持版）发布。  

![Jenkins  logo]([])  


### 拉取镜像使用  
根据需求选择以下命令拉取对应版本的 Docker 镜像：  

- **最新 LTS 版**（长期支持版）：  
  `docker pull jenkins/jenkins:lts-jdk17`  

- **最新每周版**（包含最新特性）：  
  `docker pull jenkins/jenkins:jdk17`  

- **其他轻量级版本**：  
  同时提供基于 alpine 系统、Windows 系统及其他 JDK 版本的轻量级镜像。  

- **推荐：固定特定版本**（避免自动更新导致问题）：  
  格式为 `docker pull jenkins/jenkins:<version>-<jdk>`，例如：  
  `jenkins/jenkins:2.414.3-jdk17`（LTS 版示例） 或 `jenkins/jenkins:2.430-jdk21`（每周版示例）  


详细使用说明可查阅 [官方文档]([])。
