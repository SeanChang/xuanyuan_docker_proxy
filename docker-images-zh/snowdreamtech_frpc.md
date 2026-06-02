---
image: snowdreamtech/frpc
description: "这是用于Frp的Docker镜像，Frp作为一款轻量级反向代理工具，主要用于内网穿透，支持TCP、UDP、HTTP、HTTPS等多种协议，能帮助用户将本地服务便捷地暴露至公网；该镜像预配置了Frp服务环境，可直接通过Docker快速部署，简化了传统安装配置流程，适用于开发者、运维人员等需要高效管理内网服务访问的场景，助力实现安全稳定的内外网连接。"
source: https://xuanyuan.cloud/zh/r/snowdreamtech/frpc
canonical: https://xuanyuan.cloud/zh/r/snowdreamtech/frpc
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/snowdreamtech/frpc" title="snowdreamtech/frpc Docker 镜像中文简介、标签列表与拉取命令">snowdreamtech/frpc — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/snowdreamtech/frpc" title="snowdreamtech/frpc Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/snowdreamtech/frpc</a>

# frp Docker镜像介绍  


## 简介  
基于Alpine和Debian系统的Frp Docker镜像，支持多种硬件架构（amd64、arm32v5、arm32v6、arm32v7、arm64v8、i386、mips64le、ppc64le、riscv64、s390x），可直接用于快速部署Frp服务端（）和客户端（）。  


## 文档  
- [英文文档]([])  
- [中文文档]([])  


## 使用方法  

### 基础用法  
直接运行默认镜像，适用于大多数场景：  
```bash
# 启动（服务端）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  

# 启动（客户端）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  
```


### Alpine系统镜像用法  
如需使用轻量的Alpine系统镜像，可指定标签 `alpine`：  
```bash
# 启动（Alpine版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :alpine

# 启动（Alpine版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :alpine
```


### Debian系统镜像用法  
如需使用Debian系统镜像，可指定标签 `debian` 或具体版本（如 `bookworm`）：  
```bash
# Debian基础版
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :debian
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :debian

# Debian Bookworm版本
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :bookworm
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :bookworm
```


## 快速参考  

### 问题反馈  
[GitHub Issues]([])  


### 讨论交流  
[GitHub Discussions]([])  


### 维护者  
snowdream（邮箱：[邮箱已删除]）  


### 支持架构  
- **Alpine系统镜像**：linux/386、linux/amd64、linux/arm/v6、linux/arm/v7、linux/arm64、linux/ppc64le、linux/riscv64、linux/s390x  
- **Debian系统镜像**：linux/386、linux/amd64、linux/arm/v5、linux/arm/v7、linux/arm64、linux/mips64le、linux/ppc64le、linux/s390x  


### 支持标签  
- **Alpine系统**：latest、0.62-alpine3.21、0.64.0-alpine3.21、0.62-alpine、0.64.0-alpine、alpine3.21、alpine、0.62、0.64.0  
- **Debian系统**：bookworm、debian、0.62-bookworm、0.64.0-bookworm、0.62-debian、0.64.0-debian  


## 相关资源推荐  
- [腾讯云]([])  
- [阿里云]([])  
- [华为云]([])  
- [Bandwagonhost/搬瓦工]([])  
- [Vultr]([])  


## 联系方式（备注：frp）  
- 邮箱：[邮箱已删除]  
- QQ：3217680847  
- QQ群：949022145  
- 微信/微信群：sn0wdr1am  


## 官方链接  
1. [frp官方仓库（fatedier/frp）]([])  
2. [Docker镜像仓库（snowdreamtech/frp）]([])  
3. [镜像（GitHub Packages）]()  
4. [镜像（GitHub Packages）]()  
5. [镜像（Docker Hub）]()  
6. [镜像（Docker Hub）]()  


## 许可证  
MIT  


## Star History  
[![Star History Chart]([])]([])
