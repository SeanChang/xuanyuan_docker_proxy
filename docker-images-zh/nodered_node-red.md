<!-- xuanyuan-docker-images-zh
image: nodered/node-red
source: https://xuanyuan.cloud/zh/r/nodered/node-red
canonical: https://xuanyuan.cloud/zh/r/nodered/node-red
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [nodered/node-red — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/nodered/node-red "nodered/node-red Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/nodered/node-red

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
