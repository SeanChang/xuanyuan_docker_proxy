---
image: rootpublic/tomcat
description: "Root Curated tomcat镜像是基于官方tomcat的安全、轻量级容器化应用起点，具有减小镜像大小、最小化攻击面及改善初始安全态势的特点。"
source: https://xuanyuan.cloud/zh/r/rootpublic/tomcat
canonical: https://xuanyuan.cloud/zh/r/rootpublic/tomcat
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rootpublic/tomcat" title="rootpublic/tomcat Docker 镜像中文简介、标签列表与拉取命令">rootpublic/tomcat 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Root精选Tomcat镜像


## 镜像概述和主要用途  
Root精选Tomcat镜像是基于官方Docker [tomcat](https://hub.docker.com/_/tomcat)镜像构建的容器化应用基础镜像，旨在为用户提供安全、轻量且便捷的容器化应用起点。


## 核心功能和特性  
Root精选镜像具备以下核心优势：  
- **减小镜像大小**：优化镜像构建流程，降低存储空间占用  
- **最小化攻击面**：精简不必要组件，减少潜在安全风险点  
- **增强初始安全态势**：默认配置强化安全基线  

> **注意**：若需实现零关键/高危漏洞，可考虑使用[Root自动化漏洞修复](https://app.root.io)服务。  


## 使用场景和适用范围  
该镜像适用于需要安全加固、轻量级运行环境的Tomcat容器化应用场景，包括但不限于：  
- 开发、测试及生产环境中的Java Web应用部署  
- 对镜像体积和安全合规性有严格要求的企业级应用  
- 需要最小化攻击面的高安全性应用场景  


## 使用方法和配置说明  
### 基本使用  
详细示例和使用说明可参考官方Docker Tomcat文档[此处](https://hub.docker.com/_/tomcat)。以下为基础使用示例：  

#### 快速启动容器  
```bash
docker run -d -p 8080:8080 --name my-tomcat docker.xuanyuan.run/root/tomcat:latest
```  
- `-p 8080:8080`：映射容器内Tomcat默认端口8080到主机  
- `--name my-tomcat`：指定容器名称  

#### 部署应用  
将本地Web应用部署至容器：  
```bash
docker run -d -p 8080:8080 -v /local/path/to/app:/usr/local/tomcat/webapps/ROOT --name my-tomcat docker.xuanyuan.run/root/tomcat:latest
```  
- `-v /local/path/to/app:/usr/local/tomcat/webapps/ROOT`：挂载本地应用目录至Tomcat默认应用路径  


## 许可证和合规义务  
所有许可证信息可在各镜像标签中查询。  

### Root的义务  
- 明确标识和归属包含的软件  
- 提供适当的许可证合规信息  

### 用户的义务  
- 遵守所列许可证条款  

详细许可证合规信息参见[root.io/trust-center](https://root.io/trust-center)。  


## 源代码与Dockerfile  
该镜像的Dockerfile及源代码可在[GitHub仓库](https://github.com/rootio-avr/public-image-catalog/tree/main/debian/tomcat/)获取。  


## 支持与反馈  
欢迎反馈！如有任何问题、建议或问题，请联系[support@root.io](mailto:support@root.io)。  


## 快速链接  
- [更多Root镜像](https://images.root.io)  
- [自动化漏洞修复](https://app.root.io)  
- [了解Root](https://www.root.io)
