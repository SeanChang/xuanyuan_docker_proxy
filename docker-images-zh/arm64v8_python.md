<!-- xuanyuan-docker-images-zh
image: arm64v8/python
source: https://xuanyuan.cloud/zh/r/arm64v8/python
canonical: https://xuanyuan.cloud/zh/r/arm64v8/python
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/arm64v8/python" title="arm64v8/python Docker 镜像中文简介、标签列表与拉取命令">arm64v8/python — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/arm64v8/python" title="arm64v8/python Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/arm64v8/python</a></p>

# arm64v8 架构 Python 官方镜像说明  


## 说明  
本文档对应 [Python 官方镜像]([]) 的 `arm64v8` 架构特定版本仓库。更多信息可参考官方镜像文档中的 **[非 amd64 架构说明]([])** 及 FAQ 中的 **[镜像源 Git 变更后处理方式]([])**。  


# 快速参考  

### 维护者  
[Docker 社区]([])  


### 获取帮助  
可通过以下渠道寻求支持：  
- [Docker 社区 Slack]([])  
- [Server Fault]([])  
- [Unix & Linux 论坛]([])  
- [Stack Overflow]([])  


# 支持的标签及对应 Dockerfile 链接  
（关于“共享标签”与“基础标签”的区别，详见 FAQ 中的 **[标签类型说明]([])**。）  


## 基础标签  

- [`3.14.0-trixie`, `3.14-trixie`, `3-trixie`, `trixie`]([])  

- [`3.14.0-slim-trixie`, `3.14-slim-trixie`, `3-slim-trixie`, `slim-trixie`, `3.14.0-slim`, `3.14-slim`, `3-slim`, `slim`]([])  

- [`3.14.0-bookworm`, `3.14-bookworm`, `3-bookworm`, `bookworm`]([])  

- [`3.14.0-slim-bookworm`, `3.14-slim-bookworm`, `3-slim-bookworm`, `slim-bookworm`]([])  

- [`3.14.0-alpine3.22`, `3.14-alpine3.22`, `3-alpine3.22`, `alpine3.22`, `3.14.0-alpine`, `3.14-alpine`, `3-alpine`, `alpine`]([])  

- [`3.14.0-alpine3.21`, `3.14-alpine3.21`, `3-alpine3.21`, `alpine3.21`]([])  

- [`3.13.8-trixie`, `3.13-trixie`]([])  

- [`3.13.8-slim-trixie`, `3.13-slim-trixie`, `3.13.8-slim`, `3.13-slim`]([])  

- [`3.13.8-bookworm`, `3.13-bookworm`]([])  

- [`3.13.8-slim-bookworm`, `3.13-slim-bookworm`]([])  

- [`3.13.8-alpine3.22`, `3.13-alpine3.22`, `3.13.8-alpine`, `3.13-alpine`]([])  

- [`3.13.8-alpine3.21`, `3.13-alpine3.21`]([])  

- [`3.12.12-trixie`, `3.12-trixie`]([])  

- [`3.12.12-slim-trixie`, `3.12-slim-trixie`, `3.12.12-slim`, `3.12-slim`]([])  

- [`3.12.12-bookworm`, `3.12-bookworm`]([])  

- [`3.12.12-slim-bookworm`, `3.12-slim-bookworm`]([])  

- [`3.12.12-alpine3.22`, `3.12-alpine3.22`, `3.12.12-alpine`, `3.12-alpine`]([])  

- [`3.12.12-alpine3.21`, `3.12-alpine3.21`]([])  

- [`3.11.14-trixie`, `3.11-trixie`]([])  

- [`3.11.14-slim-trixie`, `3.11-slim-trixie`, `3.11.14-slim`, `3.11-slim`]([])  

- [`3.11.14-bookworm`, `3.11-bookworm`]([])  

- [`3.11.14-slim-bookworm`, `3.11-slim-bookworm`]([])  

- [`3.11.14-alpine3.22`, `3.11-alpine3.22`, `3.11.14-alpine`, `3.11-alpine`]([])  

- [`3.11.14-alpine3.21`, `3.11-alpine3.21`]([])  

- [`3.10.19-trixie`, `3.10-trixie`]([])  

- [`3.10.19-slim-trixie`, `3.10-slim-trixie`, `3.10.19-slim`, `3.10-slim`]([])  

- [`3.10.19-bookworm`, `3.10-bookworm`]([])  

- [`3.10.19-slim-bookworm`, `3.10-slim-bookworm`]([])  

- [`3.10.19-alpine3.22`, `3.10-alpine3.22`, `3.10.19-alpine`, `3.10-alpine`]([])  

- [`3.10.19-alpine3.21`, `3.10-alpine3.21`]([])  

- [`3.9.24-trixie`, `3.9-trixie`]([])  

- [`3.9.24-slim-trixie`, `3.9-slim-trixie`, `3.9.24-slim`, `3.9-slim`]([])  

- [`3.9.24-bookworm`, `3.9-bookworm`]([])  

- [`3.9.24-slim-bookworm`, `3.9-slim-bookworm`]([])  

- [`3.9.24-alpine3.22`, `3.9-alpine3.22`, `3.9.24-alpine`, `3.9-alpine`]([])  

- [`3.9.24-alpine3.21`, `3.9-alpine3.21`]([])  


## 共享标签  

- `3.14.0`, `3.14`, `3`, `latest`:  
  - 对应基础标签：[`3.14.0-trixie`]([])  

- `3.13.8`, `3.13`:  
  - 对应基础标签：[`3.13.8-trixie`]([])  

- `3.12.12`, `3.12`:  
  - 对应基础标签：[`3.12.12-trixie`]([])  

- `3.11.14`, `3.11`:  
  - 对应基础标签：[`3.11.14-trixie`]([])  

- `3.10.19`, `3.10`:  
  - 对应基础标签：[`3.10.19-trixie`]([])  

- `3.9.24`, `3.9`:  
  - 对应基础标签：[`3.9.24-trixie`]([]

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/arm64v8/python" title="arm64v8/python Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/arm64v8/python</a></p>
