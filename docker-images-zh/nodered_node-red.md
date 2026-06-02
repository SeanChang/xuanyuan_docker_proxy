---
image: nodered/node-red
description: "事件驱动型应用的低代码编程是一种通过可视化拖拽、预设组件及模型驱动等方式，简化事件触发逻辑（如用户交互、系统通知、数据变更等）设计与开发流程的技术方法，能有效降低开发门槛，让开发者无需深入编写复杂代码即可快速构建响应实时事件的应用，支持敏捷迭代和业务需求快速落地，广泛应用于自动化流程、实时监控、用户交互系统等场景，显著提升开发效率与应用交付速度。"
source: https://xuanyuan.cloud/zh/r/nodered/node-red
canonical: https://xuanyuan.cloud/zh/r/nodered/node-red
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nodered/node-red" title="nodered/node-red Docker 镜像中文简介、标签列表与拉取命令">nodered/node-red — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/nodered/node-red" title="nodered/node-red Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/nodered/node-red</a>

# Node-RED  

### 面向事件驱动应用的低代码编程工具  


## 在Docker中运行Node-RED  

### 普通版本  
最简单的运行方式，直接执行以下命令：  
```bash
docker run -it -p 1880:1880 -v myNodeREDdata:/data --name mynodered nodered/node-red
```  


### 最小化版本  
若需精简版（不含构建工具及项目支持），使用以下命令：  
```bash
docker run -it -p 1880:1880 -v myNodeREDdata:/data --name mynodered nodered/node-red:latest-minimal
```  


## 特殊情况说明  
**注意**：树莓派Zero和1用户（搭载Arm6架构CPU）需使用特定标签安装，原因是上游Docker存在架构检测bug。  
例如，安装最小化node 10版本：  
```bash
docker run -it -p 1880:1880 -v myNodeREDdata:/data --name mynodered nodered/node-red:1.0.1-10-minimal-arm32v6
```  


## 更多信息  
- 详细操作指南：[docker指南]([])  
- 问题咨询：[Node-RED公共论坛]([])  
- 项目官网：[Node-RED官网]([])  
- 代码仓库：[GitHub项目地址]([])
