---
image: calico/cni
description: "Project Calico的CNI插件是为容器编排平台（如Kubernetes）设计的容器网络接口插件，作为开源项目Calico实现容器网络功能的关键组件，它提供网络连接配置、网络策略管理、跨节点网络通信等核心功能，支持动态网络参数调整，确保容器间高效、安全的网络互通，助力容器化应用稳定运行。"
source: https://xuanyuan.cloud/zh/r/calico/cni
canonical: https://xuanyuan.cloud/zh/r/calico/cni
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/calico/cni" title="calico/cni Docker 镜像中文简介、标签列表与拉取命令">calico/cni 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Calico CNI网络插件  


## 项目概述  
本仓库包含Project Calico的CNI网络插件，可让任何遵循[CNI网络规范][cni]的编排器使用Calico网络功能。仓库中包含顶级CNI网络插件及基于Calico IPAM的CNI IPAM插件。  

配置详情参见[配置文档][config]；入门指南及CNI集成的详细说明可参考[calico-containers仓库][calico-containers]；了解CNI更多信息可访问[appc/cni仓库][cni]。  


## 构建与测试  
### 本地构建插件及运行测试  
克隆本仓库并执行`make`命令，将自动构建两个CNI插件二进制文件（`calico`和`calico-ipam`）并运行测试。  

### 常用操作  
- **仅构建二进制文件（不运行测试）**：执行`make binary`，生成文件位于`dist/calico`和`dist/calico-ipam`。  
- **仅运行测试**：执行`make test`。  


## 发布流程  
1. 在Github创建发布（release）并生成标签（tag）。  
2. 本地检出该标签，执行`make release`。  
3. 将`dist/calico`和`dist/calico-ipam`附加到Github发布中。  


## 相关链接  
[cni]: []  
[config]: configuration.md  
[calico-containers]: []  


### 状态与交流  
[![CircleCI branch] ]   
[![Build Status] ]   
[![Slack Status] ]   
[![IRC Channel] ]   


[![Analytics] ]
