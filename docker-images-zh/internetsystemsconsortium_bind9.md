---
image: internetsystemsconsortium/bind9
description: "这是ISC官方正式推出的专为BIND 9服务打造的Docker容器镜像，该镜像基于轻量级的Alpine镜像构建而成，旨在提供高效的运行环境，并由ISC.org秉持尽力而为的原则进行日常的维护与更新工作，以确保其在实际应用中的稳定性与可用性。"
source: https://xuanyuan.cloud/zh/r/internetsystemsconsortium/bind9
canonical: https://xuanyuan.cloud/zh/r/internetsystemsconsortium/bind9
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/internetsystemsconsortium/bind9" title="internetsystemsconsortium/bind9 Docker 镜像中文简介、标签列表与拉取命令">internetsystemsconsortium/bind9 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/internetsystemsconsortium/bind9" title="internetsystemsconsortium/bind9 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/internetsystemsconsortium/bind9</a>

![BIND9 logo]([])


# ISC BIND 9 Docker仓库使用说明  

ISC官方BIND 9 Docker仓库。本Docker镜像为免费提供，ISC将尽力维护。  


## 必须挂载的卷  

使用时需正确挂载以下卷：  

- `etc/bind` - 用于存放配置文件，`named.conf` 需放置于此  
- `/var/cache/bind` - 工作目录，例如配置中需设置 `options { directory "/var/cache/bind"; };`  
- `/var/lib/bind` - 通常用于存放辅助区域文件  
- `/var/log` - 日志文件存放目录  


# 快速开始  

## 递归DNS服务器  

### BIND 9.18（扩展支持版，即“旧稳定版”）  
```bash
docker run \
        --name=bind9 \
        --restart=always \
        --publish 53:53/udp \
        --publish 53:53/tcp \
        --publish 127.0.0.1:953:953/tcp \
        internetsystemsconsortium/bind9:9.18
```

### BIND 9.20（当前稳定版）  
```bash
docker run \
        --name=bind9 \
        --restart=always \
        --publish 53:53/udp \
        --publish 53:53/tcp \
        --publish 127.0.0.1:953:953/tcp \
        internetsystemsconsortium/bind9:9.20
```


## 权威DNS服务器  

此处需手动提供 `/etc/bind/named.conf` 配置文件及主区域文件等（即需手动配置，无默认配置）。  

### BIND 9.18（扩展支持版，即“旧稳定版”）  
```bash
docker run \
        --name=bind9 \
        --restart=always \
        --publish 53:53/udp \
        --publish 53:53/tcp \
        --publish 127.0.0.1:953:953/tcp \
        --volume /etc/bind \
        --volume /var/cache/bind \
        --volume /var/lib/bind \
        --volume /var/log \
        internetsystemsconsortium/bind9:9.18
```

### BIND 9.20（当前稳定版）  
```bash
docker run \
        --name=bind9 \
        --restart=always \
        --publish 53:53/udp \
        --publish 53:53/tcp \
        --publish 127.0.0.1:953:953/tcp \
        --volume /etc/bind \
        --volume /var/cache/bind \
        --volume /var/lib/bind \
        --volume /var/log \
        internetsystemsconsortium/bind9:9.20
```


# 基础配置  

## 递归DNS服务器  
递归DNS服务器无需额外配置，直接运行即可。  


## 权威DNS服务器  
以下为权威DNS服务器的基础配置示例：  

```
options {
        directory "/var/cache/bind";  // 工作目录
        listen-on { 127.0.0.1; };     // 监听IPv4地址
        listen-on-v6 { ::1; };        // 监听IPv6地址
        allow-recursion { none; };    // 禁止递归查询
        allow-transfer { none; };     // 禁止区域传输
        allow-update { none; };       // 禁止动态更新
};

zone "example.com." {               // 定义example.com区域
        type primary;               // 类型为主区域
        file "/var/lib/bind/db.example.com";  // 区域文件路径
        notify explicit;            // 显式通知从服务器
};
```


# 支持与资源  

## 技术支持  
- 关于ISC、BIND及购买专业技术支持，可访问[ISC官网]([])。BIND9的开发与维护依赖于用户的支持合同资助。  
- `bind-users`邮件列表（[]  


## 文档  
- BIND官方文档可在[ReadTheDocs]([])查看。  
- 更多文档（含常见FAQ）可在[ISC知识库]([])获取。  


## 问题反馈  
- 如需报告bug，请访问[项目仓库]([])。建议先搜索是否已有相同问题。  


## 许可证  
BIND9基于[MPL2.0许可证]([])开源。
