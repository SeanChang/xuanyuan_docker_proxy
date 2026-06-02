---
image: ubuntu/squid
description: "Squid是一款广泛应用的Web缓存代理服务器，主要功能是缓存网页内容，通过存储用户频繁访问的资源来加快后续访问速度并有效减轻源服务器的负载，其长期支持版本由Canonical公司负责持续维护与更新。"
source: https://xuanyuan.cloud/zh/r/ubuntu/squid
canonical: https://xuanyuan.cloud/zh/r/ubuntu/squid
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/squid" title="ubuntu/squid Docker 镜像中文简介、标签列表与拉取命令">ubuntu/squid — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/squid" title="ubuntu/squid Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/squid</a>

# Squid | Ubuntu  

这是基于Ubuntu的Squid Docker镜像，由Canonical提供。该镜像会持续接收安全更新，并滚动更新至新版本的Squid或Ubuntu系统。本仓库可免费使用，且不受每用户速率限制。


## 关于Squid  

Squid是一款Web缓存代理服务器，支持HTTP、HTTPS、FTP等协议。它通过缓存并复用频繁请求的网页内容，减少网络带宽占用并提升响应速度。Squid具备丰富的访问控制功能，可用作高效的服务器加速器。它支持包括Windows在内的多数操作系统，采用GNU GPL许可协议。


## 标签与架构  

![LTS]([])  
LTS通道提供最长5年的免费安全维护。  

![ESM]([])  
ESM通道提供最长10年的客户专属安全维护（需通过[Canonical受限仓库]([])获取）。  


| 通道标签                | 支持期限   | 当前版本                     | 架构支持                     |
|-------------------------|------------|------------------------------|------------------------------|
| **`5.2-22.04_beta`**    | -          | Squid 5.2 基于 Ubuntu 22.04 LTS | `amd64`、`arm64`、`ppc64el`、`s390x` |
| `4.13-21.10_beta`       | -          | Squid 4.13 基于 Ubuntu 21.10     | `amd64`、`arm64`、`ppc64el`、`s390x` |
| `4.10-20.04_beta`       | -          | Squid 4.10 基于 Ubuntu 20.04 LTS | `amd64`、`arm64`、`ppc64el`、`s390x` |
| _`track_risk`_          |            |                              |                              |  


### 通道标签说明  
通道标签按稳定性排序为 `stable`、`candidate`、`beta`、`edge`（风险递增）。风险较高的通道默认可用：若列出 `beta`，则可拉取 `edge`；列出 `candidate`，则可拉取 `beta` 和 `edge`；列出 `stable`，则四个通道均可用。镜像会严格按 `edge`→`beta`→`candidate`→`stable` 顺序发布。  


### 商业用途与扩展安全维护通道  
若需将镜像用于商业分发，或需要ESM通道、未列出的版本/通道，请联系Canonical团队（[官网链接]([]) 或发送邮件至 [邮箱已删除]）。  


## 使用方法  

### 本地启动  
通过以下命令在本地启动容器：  

```sh
docker run -d --name squid-container -e TZ=UTC -p 3128:3128 ubuntu/squid:5.2-22.04_beta
```  
启动后，可通过 `localhost:3128` 访问Squid代理。  


#### 参数说明  

| 参数                          | 描述                                  |
|-------------------------------|---------------------------------------|
| `-e TZ=UTC`                   | 设置时区（示例为UTC）                 |
| `-p 3128:3128`                | 暴露代理服务端口（容器内端口:宿主机端口） |
| `-v /本地日志路径:/var/log/squid` | 挂载日志目录（持久化存储日志）        |
| `-v /本地缓存路径:/var/spool/squid` | 挂载缓存目录（持久化存储缓存数据）    |
| `-v /本地配置文件:/etc/squid/squid.conf` | 挂载主配置文件（自定义Squid配置）    |
| `-v /本地配置片段:/etc/squid/conf.d/snippet.conf` | 挂载配置片段（被squid.conf自动包含） |  


#### 测试与调试  
- 查看容器日志：  
  ```sh
  docker logs -f squid-container
  ```  
- 进入容器交互终端：  
  ```sh
  docker exec -it squid-container /bin/bash
  ```  


## Kubernetes部署  

### 环境准备  
推荐使用MicroK8s（若未安装，执行 `sudo snap install microk8s --classic`，并启用必要组件：`microk8s.enable dns storage`，然后设置别名：`snap alias microk8s.kubectl kubectl`）。  


### 部署步骤  
1. 下载配置文件：  
   - [squid.conf]([])  
   - [squid-deployment.yml]([])  

2. 编辑 `squid-deployment.yml`，将 `containers.squid.image` 的值修改为目标通道标签（例如 `ubuntu/squid:5.2-22.04_beta`）。  

3. 执行部署命令：  
   ```sh
   # 创建配置映射
   kubectl create configmap squid-config --from-file=squid=squid.conf
   # 应用部署文件
   kubectl apply -f squid-deployment.yml
   ```  

部署完成后，可通过集群内 `3128` 端口访问Squid代理。  


## 问题反馈与功能建议  

若发现镜像bug或需提交功能建议，请通过以下链接提交：  
[[]]([])  

**提交要求**：  
- 标题格式：`squid: <问题摘要>`  
- 需包含镜像的完整摘要（通过以下命令获取）：  
  ```sh
  docker images --no-trunc --quiet ubuntu/squid:<标签>
  ```  


## 已废弃通道与标签  
以下通道（标签）不再提供更新，请尽快升级至新版本；若无法升级，可联系Canonical团队获取支持。  

| 通道   | 版本   | 终止支持日期 | 升级路径 |
|--------|--------|--------------|----------|
| _`track`_ |        |              |          |
