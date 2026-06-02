---
image: xhofe/alist
description: "这是一款由Gin（Go语言Web框架）和React（JavaScript前端库）驱动的文件列表程序，支持多种存储方式（如本地磁盘、云存储服务等），能帮助用户高效管理和查看分布在不同存储位置的文件，兼具后端高效处理能力与前端友好交互体验，为跨存储场景下的文件管理提供便捷解决方案。"
source: https://xuanyuan.cloud/zh/r/xhofe/alist
canonical: https://xuanyuan.cloud/zh/r/xhofe/alist
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [xhofe/alist — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/xhofe/alist)

含镜像标签、拉取命令、部署文档与相关推荐。

[xhofe/alist Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/xhofe/alist)

##  简介  

AList 是一款支持多种存储的文件列表程序，基于 Gin 和 Solidjs 开发，开源免费。项目托管于 [GitHub]()，提供 Docker 镜像 [xhofe/]()，方便快速部署。


## 使用方法  

### 部署运行  
#### 稳定版（推荐）  
通过 Docker 部署稳定版，执行以下命令：  
```shell  
docker run -d --restart=always -v /etc/:/opt//data -p 5244:5244 -e PUID=0 -e PGID=0 -e UMASK=022 --name="" xhofe/:latest  
```  

#### 测试版（不推荐，功能可能不稳定）  
```shell  
docker run -d --restart=always -v /etc/:/opt//data -p 5244:5244 -e PUID=0 -e PGID=0 -e UMASK=022 --name="" xhofe/:main  
```  


### 密码管理  
- **初始密码**：首次启动后，初始管理员密码可在日志中查看。  
- **忘记密码/重置**：  
  - 随机生成新密码：  
    ```shell  
    docker exec -it  ./ admin random  
    ```  
  - 手动设置新密码（将 `NEW_PASSWORD` 替换为自定义密码）：  
    ```shell  
    docker exec -it  ./ admin set NEW_PASSWORD  
    ```  


## 文档与支持  

- **官方文档**：详细使用指南（如存储配置、高级功能）可参考 [ 文档]()。  
- **讨论与反馈**：一般问题请前往 [GitHub 讨论区]()；bug 报告需提交至 [issues]()（仅处理 bug，不接受通用咨询）。  


## 其他信息  

- **在线演示**：可访问 [演示站点]([]) 体验功能。  
- **赞助支持**：项目发展依赖社区支持，详情见 [赞助页面]()。  
- **开源协议**： 基于 AGPL-3.0 协议开源。
