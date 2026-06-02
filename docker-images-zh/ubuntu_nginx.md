---
image: ubuntu/nginx
description: "Nginx是一款高性能的反向代理和Web服务器，以高并发处理能力、低资源消耗及出色的稳定性著称，广泛应用于各类网站架构中，承担请求转发、负载均衡、静态资源服务等关键任务，其长期跟踪版本由Canonical公司负责维护，为用户提供持续可靠的技术支持与版本更新。"
source: https://xuanyuan.cloud/zh/r/ubuntu/nginx
canonical: https://xuanyuan.cloud/zh/r/ubuntu/nginx
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ubuntu/nginx" title="ubuntu/nginx Docker 镜像中文简介、标签列表与拉取命令">ubuntu/nginx — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ubuntu/nginx" title="ubuntu/nginx Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/nginx</a>

# 基于精简Ubuntu的Nginx Docker镜像


## 镜像概述  
当前Nginx Docker镜像由Canonical提供，基于Ubuntu系统构建。该镜像会持续接收安全更新，并同步升级至新版Nginx或Ubuntu。本仓库可免费使用，且无用户速率限制。


## 关于Nginx  
Nginx（"engine X"）是由Igor Sysoev开发的高性能Web服务器与反向代理服务器。它既可作为独立Web服务器使用，也能作为代理服务减轻后端HTTP或邮件服务器的负载。更多信息可访问[Nginx官网]()。


## 标签与架构  

### LTS与ESM维护说明  
- **LTS**：LTS渠道提供长达5年的免费安全维护。  
- **ESM**：通过Canonical的受限仓库，可为客户提供长达10年的安全维护（[获取详情]([])）。  


### 标签详情表  

| 渠道标签（主标签）       | 其他可用标签                                                                 | 支持截止时间 | 当前版本                          | 支持架构                                   |
|--------------------------|-----------------------------------------------------------------------------|--------------|-----------------------------------|--------------------------------------------|
| **`1.27-24.04_stable`**  | `1-24.04`、`1-24.04_beta`、`1-24.04_candidate`、`1-24.04_edge`、`1-24.04_stable`、`1.27-24.04`、`1.27-24.04_beta`、`1.27-24.04_candidate`、`1.27-24.04_edge` | -            | Nginx 1.27 on Ubuntu 24.04 LTS    | `amd64`                                    |
| `1.26-24.10_beta`        | `1.26-24.10_edge`、`edge`、`latest`                                         | -            | Nginx 1.26 on Ubuntu 24.10        | `amd64`、`arm64`、`ppc64le`、`s390x`       |
| `1.24-24.04_beta`        | `1.24-24.04_edge`                                                           | -            | Nginx 1.24 on Ubuntu 24.04 LTS    | `amd64`、`s390x`、`ppc64le`、`arm64`       |
| `1.24-23.10_beta`        | `1.24-23.10_edge`                                                           | -            | Nginx 1.24 on Ubuntu 23.10        | `ppc64le`、`s390x`、`arm64`、`amd64`       |
| `1.22-23.04_beta`        | `1.22-23.04_edge`                                                           | -            | Nginx 1.22 on Ubuntu 23.04        | `s390x`、`arm64`、`amd64`、`ppc64le`       |
| `1.22-22.10_beta`        | `1.22-22.10_edge`                                                           | -            | Nginx 1.22 on Ubuntu 22.10        | `amd64`、`s390x`、`ppc64le`、`arm64`       |
| `1.18-22.04_beta`        | `1.18-22.04_edge`                                                           | -            | Nginx 1.18 on Ubuntu 22.04 LTS    | `amd64`、`s390x`、`ppc64le`、`arm64`       |
| `1.18-21.10_beta`        | `1.18-21.10_edge`                                                           | -            | Nginx 1.18 on Ubuntu 21.10        | `amd64`、`s390x`、`arm64`、`ppc64le`       |
| `1.18-21.04_beta`        | `1.18-21.04_edge`                                                           | -            | Nginx 1.18 on Ubuntu 21.04        | `s390x`、`arm64`、`amd64`、`ppc64le`       |
| `1.18-20.04_beta`        | `1.18-20.04_edge`                                                           | -            | Nginx 1.18 on Ubuntu 20.04 LTS    | `arm64`、`amd64`、`ppc64le`、`s390x`       |  


### 标签风险等级说明  
渠道标签按稳定性从高到低排序为：`stable` > `candidate` > `beta` > `edge`。标注的标签隐含更风险等级的标签可用，例如：  
- 若列出`beta`，则`edge`也可使用；  
- 若列出`candidate`，则`beta`和`edge`也可使用；  
- 若列出`stable`，则全部四个等级标签均可用。  
镜像版本会严格按`edge`→`beta`→`candidate`→`stable`的顺序迭代更新。  


### 商业用途与ESM渠道  
若需将镜像用于商业分发，或需要ESM维护支持，或使用未列出的渠道/版本，可联系Canonical团队（邮箱：[邮箱已删除]，或通过[官方链接]([])）。


## 使用方法  

### 本地启动  
通过以下命令在本地启动容器：  
```sh
docker run -d --name nginx-container -e TZ=UTC -p 8080:80 ubuntu/nginx:1.27-24.04_stable
```  
启动后，可通过`[]  


### 参数说明  

| 参数                                  | 描述                                                                 |
|---------------------------------------|----------------------------------------------------------------------|
| `-e TZ=UTC`                           | 设置容器时区（示例为UTC）。                                           |
| `-p 8080:80`                          | 将容器内80端口映射到本地8080端口，暴露Nginx服务。                     |
| `-v /local/path/to/website:/var/www/html` | 挂载本地网站目录到容器内`/var/www/html`，以提供本地网站服务。          |
| `-v /path/to/conf.template:/etc/nginx/templates/conf.template` | 挂载配置模板文件到容器内`/etc/nginx/templates`，模板会自动处理并生成配置文件到`/etc/nginx/conf.d`（例如模板中`listen ${NGINX_PORT};`会生成`listen 80;`）。 |
| `-v /path/to/nginx.conf:/etc/nginx/nginx.conf` | 挂载本地Nginx配置文件（可参考[示例配置]([])）。 |  


### 测试与调试  
查看容器运行日志以调试问题：  
```sh
docker logs -f nginx-container
```  


## Kubernetes部署  
该镜像可在任意Kubernetes环境中部署。若暂无Kubernetes集群，推荐安装MicroK8s：  
```sh
# 安装MicroK8s并启用必要组件
microk8s.enable dns storage  
# 为kubectl创建别名（可选）
snap alias microk8s.kubectl kubectl  
```  

### 部署步骤  
1. 下载配置文件：  
   - [nginx.conf]([])（Nginx主配置）  
   - [index.html]([])（示例网页）  
   - [nginx-deployment.yml]([])（Kubernetes部署文件）  

2. 编辑`nginx-deployment.yml`，将`containers.nginx.image`字段设置为目标标签（例如`ubuntu/nginx:1.27-24.04_stable`）。  

3. 创建配置映射并部署：  
   ```sh
   # 创建包含Nginx配置和网页的ConfigMap
   kubectl create configmap nginx-config --from-file=nginx=nginx.conf --from-file=nginx-site=index.html  
   # 应用部署文件
   kubectl apply -f nginx-deployment.yml  
   ```  

部署完成后，可通过`[]  


## 问题反馈  
若发现镜像 bug 或需请求功能，可通过以下链接提交issue：  
[[]]([])  

提交时请按格式命名标题：`nginx: <问题摘要>`，并附上所用镜像的完整摘要（通过以下命令获取）：  
```sh
docker images --no-trunc --quiet ubuntu/nginx:<tag>
```  


## 废弃标签与渠道  
以下渠道（标签）已停止更新，建议升级至新版渠道；若无法升级，可[联系支持]([])。  

| 渠道 | 版本 | 停止维护时间 | 升级路径 |
|------|------|--------------|----------|
| _`track`_ |  |  |  |
