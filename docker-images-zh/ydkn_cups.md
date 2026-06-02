---
image: ydkn/cups
description: "CUPS打印服务器，即通用UNIX打印系统（Common UNIX Printing System），是一款开源的打印管理中间件，广泛应用于Linux、macOS等类UNIX系统及Windows平台，支持IPP、LPD、SMB等多种打印协议，可管理打印机队列、处理打印作业，提供Web管理界面，并能转换PostScript、PDF等文件格式以实现高效打印，是连接客户端与物理打印机的核心组件，确保打印任务稳定分发与处理。"
source: https://xuanyuan.cloud/zh/r/ydkn/cups
canonical: https://xuanyuan.cloud/zh/r/ydkn/cups
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ydkn/cups" title="ydkn/cups Docker 镜像中文简介、标签列表与拉取命令">ydkn/cups — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ydkn/cups" title="ydkn/cups Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ydkn/cups</a>

# CUPS Docker 镜像

[项目地址]([])


## 支持架构

- amd64  
- arm32v7  
- arm64v8  


## 使用方法

### 启动容器

执行以下命令启动容器：

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups ydkn/cups:latest
```


### 配置

1. **登录 Web 界面**  
通过 631 端口访问 CUPS Web 管理界面（例如：`[] CUPS。  

2. **默认登录凭据**  
用户名：`admin`，密码：`admin`。

3. **修改管理员密码**  
如需自定义管理员密码，启动容器时添加环境变量 `ADMIN_PASSWORD`，示例命令：  

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups -e ADMIN_PASSWORD=mySecretPassword ydkn/cups:latest
```
