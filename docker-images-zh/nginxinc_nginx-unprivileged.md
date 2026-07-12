---
image: nginxinc/nginx-unprivileged
description: "非特权NGINX Docker构建文件是指用于构建以非root用户身份在Docker容器中运行NGINX的配置文件，通过预设用户权限、环境变量及安全参数，确保NGINX在低权限模式下仍能正常处理HTTP请求、反向代理及负载均衡等功能，有效降低因容器漏洞引发的权限提升风险，适用于对安全性要求较高的生产环境部署场景。"
source: https://xuanyuan.cloud/zh/r/nginxinc/nginx-unprivileged
canonical: https://xuanyuan.cloud/zh/r/nginxinc/nginx-unprivileged
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nginxinc/nginx-unprivileged" title="nginxinc/nginx-unprivileged Docker 镜像中文简介、标签列表与拉取命令">nginxinc/nginx-unprivileged 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 非特权用户运行的NGINX Docker镜像


## 仓库说明  
本仓库包含一系列Dockerfile，用于构建以非root、无特权用户运行的NGINX Docker镜像。


## 与官方镜像的主要区别  
与官方NGINX Docker镜像相比，主要差异如下：  
- 默认NGINX监听端口从`80`改为`8080`（Docker `20.03`及以上版本已无需此调整，但其他容器运行时仍需）；  
- 移除了`/etc/nginx/nginx.conf`中的默认`user`指令；  
- NGINX默认PID文件路径从`/var/run/nginx.pid`移至`/tmp/nginx.pid`；  
- 所有`*_temp_path`变量路径统一改为`/tmp/*`。  


## 镜像更新频率  
新镜像每周构建并推送一次（每周一晚上）。


## 使用参考  
关于镜像的详细使用方法，可参考上游Docker NGINX镜像文档：[docs] 。


## 注意事项  
安全漏洞相关issue将被及时关闭，除非附带充分理由说明该漏洞对本镜像构成实际安全威胁。更多细节见[SECURITY文档] 。


## 支持的镜像仓库和平台  

### 镜像仓库  
已构建的镜像可在以下仓库获取：  
- GitHub Container Registry：<[]>  
- Docker Hub：<[]>  


### 平台  
多数镜像支持以下架构：`amd64`、`arm32v5`（仅Debian版本）、`arm32v6`（仅Alpine版本）、`arm32v7`、`arm64v8`、`i386`、`mips64le`（仅Debian版本）、`ppc64le`、`s390x`。  
Alpine slim镜像仅支持`amd64`和`arm64v8`架构。  


## 常见问题  
- 若覆盖默认`nginx.conf`文件，可能出现错误提示：`nginx: [emerg] open() "/var/run/nginx.pid" failed (13: Permission denied)`。  
  **解决方法**：在自定义配置中添加行`pid /tmp/nginx.pid`。
