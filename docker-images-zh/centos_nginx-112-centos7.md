---
image: centos/nginx-112-centos7
description: "用于运行nginx 1.12或构建基于nginx的应用程序的平台"
source: https://xuanyuan.cloud/zh/r/centos/nginx-112-centos7
canonical: https://xuanyuan.cloud/zh/r/centos/nginx-112-centos7
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/centos/nginx-112-centos7" title="centos/nginx-112-centos7 Docker 镜像中文简介、标签列表与拉取命令">centos/nginx-112-centos7 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/centos/nginx-112-centos7" title="centos/nginx-112-centos7 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/centos/nginx-112-centos7</a>

Nginx 1.12服务器和反向代理服务器容器镜像

用户可选择基于RHEL、CentOS或Fedora的镜像。RHEL镜像可在[Red Hat容器目录](https://access.redhat.com/containers/)获取，CentOS镜像在[Docker Hub](https://hub.docker.com/r/centos/)，Fedora镜像在[Fedora Registry](https://registry.fedoraproject.org/)。生成的镜像可使用[podman](https://github.com/containers/libpod)运行。

注意：本文档中的示例使用`podman`命令，所有此类命令均可替换为`docker`，参数保持不变。

## 描述

Nginx是一款HTTP、SMTP、POP3和IMAP协议的Web服务器及反向代理服务器，专注于高并发、高性能和低内存占用。本容器镜像提供nginx 1.12守护进程的容器化打包，可用作基于nginx 1.12 Web服务器的其他应用的基础镜像。Nginx服务器镜像可通过OpenShift的`Source`构建功能进行扩展。

## 用法

假设使用`rhscl/nginx-112-rhel7`镜像（在OpenShift中通过`nginx:1.12`镜像流标签可用）。在OpenShift中构建简单的[示例应用](https://github.com/sclorg/nginx-container/tree/master/1.12/test/test-app)可通过以下步骤实现：

```
oc new-app nginx:1.12~https://github.com/sclorg/nginx-container.git --context-dir=1.12/test/test-app/
```

也可在安装了独立[S2I](https://github.com/openshift/source-to-image)工具的系统上构建：

```
$ s2i build https://github.com/sclorg/nginx-container.git --context-dir=1.12/test/test-app/ rhscl/nginx-112-rhel7 nginx-sample-app
```

**使用Docker运行基础容器示例**：
```
docker run -d --name nginx-112 -p 8080:80 rhscl/nginx-112-rhel7
```

**访问应用**：
```
$ curl 127.0.0.1:8080
```

## S2I构建支持

本镜像可通过OpenShift的`Source`构建策略或独立[source-to-image](https://github.com/openshift/source-to-image)工具（若可用）进行扩展。S2I构建文件夹结构：

- **`./nginx.conf`**：主nginx配置文件
- **`./nginx-cfg/*.conf`**：需纳入镜像的所有nginx配置文件
- **`./nginx-default-cfg/*.conf`**：默认服务器块的nginx配置片段
- **`./nginx-start/*.sh`**：nginx启动前执行的shell脚本（会被 sourcing）
- **`./`**：nginx应用源代码存放目录

## 环境变量和卷

nginx容器镜像支持以下配置变量，可通过`podman run`命令的`-e`选项设置：

- **`NGINX_LOG_TO_VOLUME`**：设置后，nginx日志写入`/var/log/nginx/`。在RHEL-7和CentOS-7镜像中，该路径为`/var/opt/rh/rh-nginx112/log/nginx/`的符号链接。

**挂载自定义web根目录**：
```
$ podman run -v <DIR>:/var/www/html/ <container>
```
其中`<DIR>`需替换为web根目录的绝对路径（符合podman要求）。

## 故障排除

默认情况下，nginx访问日志输出到标准输出（stdout），错误日志输出到标准错误（stderr），可通过容器日志查看：
```
podman logs <container>
```

**若设置`NGINX_LOG_TO_VOLUME`变量**，nginx日志将写入`/var/log/nginx/`（RHEL-7和CentOS-7镜像中为`/var/opt/rh/rh-nginx112/log/nginx/`的符号链接），可通过容器卷挂载到主机系统。

## 参见

本容器镜像的Dockerfile及其他源码可在https://github.com/sclorg/nginx-container获取。该仓库还包含其他版本的Python环境Dockerfile。CentOS的Dockerfile名为`Dockerfile`，RHEL7为`Dockerfile.rhel7`，RHEL8为`Dockerfile.rhel8`，Fedora为`Dockerfile.fedora`。
