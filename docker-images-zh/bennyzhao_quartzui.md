---
image: bennyzhao/quartzui
description: "这是一个基于Quartz.NET 3.0的Web管理界面，采用Docker打包实现开箱即用，内置SQLite持久化功能，具备语言无关特性，可实现业务代码零污染，同时支持RESTful风格接口及傻瓜式配置。"
source: https://xuanyuan.cloud/zh/r/bennyzhao/quartzui
canonical: https://xuanyuan.cloud/zh/r/bennyzhao/quartzui
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [bennyzhao/quartzui — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bennyzhao/quartzui)

含镜像标签、拉取命令、部署文档与相关推荐。

[bennyzhao/quartzui Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/bennyzhao/quartzui)

## quartzui 使用介绍


### 项目地址  
GitHub：[zhaopeiym/quartzui]([])  


### 快速启动  
通过以下一行 Docker 命令即可完成部署，实现开箱即用：  
```bash
docker run -v /fileData/quartzuifile:/app/File --restart=unless-stopped --privileged=true --name quartzui -dp 5088:80 bennyzhao/quartzui
```  


### 命令参数说明  
上述命令中关键参数作用如下，可根据实际需求调整：  
- `-v /fileData/quartzuifile:/app/File`：将主机目录 `/fileData/quartzuifile` 映射到容器内 `/app/File` 目录，用于持久化存储 SQLite 数据库文件和日志（log）。  
- `-p 5088:80`：将容器的 80 端口映射到主机的 5088 端口，外部通过主机 5088 端口访问服务。  
- `--name quartzui`：指定容器名称为 `quartzui`，便于后续管理（如启动、停止容器）。  


### 访问方式  
1. **浏览器访问**：在浏览器中输入 `[] 即可打开 quartzui 界面。  
2. **本地测试**：若需验证服务是否正常启动，可在主机执行命令 `curl 127.0.0.1:5088`，返回响应即表示启动成功。  
3. **防火墙检查**：确保主机防火墙已开放 5088 端口，避免因端口限制导致无法访问。
