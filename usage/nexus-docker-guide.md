# Nexus Docker 镜像源配置教程（对接轩辕镜像）

> 在线版：https://xuanyuan.cloud/usage/nexus

在团队开发与内网部署中，反复从公网拉取 Docker 镜像既耗时又占带宽，还容易受网络波动影响。**Nexus 私服 + 轩辕镜像**既能实现内网缓存复用，又能借助稳定镜像源解决拉取慢、失败问题，适合作为内网镜像管理方案。本文从零演示：用 Docker 部署 Nexus3，并将轩辕镜像专属域名配置为 Docker 代理仓库的远程端点，看完即可落地。

## 目录

- [1. 为什么要搭建 Nexus 私服？](#1-为什么要搭建-nexus-私服)
- [2. 用 Docker 一键部署 Nexus 容器](#2-用-docker-一键部署-nexus-容器)
- [3. 登录引导、密码位置与仓库类型](#3-登录引导密码位置与仓库类型)
- [4. 对接轩辕镜像：创建 Docker Proxy 仓库](#4-对接轩辕镜像创建-docker-proxy-仓库)
- [5. 验证：通过私服拉取镜像](#5-验证通过私服拉取镜像)
- [6. 总结与拓展](#6-总结与拓展)

## 1. 为什么要搭建 Nexus 私服？

Nexus 是部署在内网的构件与镜像管理仓库，核心能力是**代理远程仓库、缓存构件、内网共享**，能直接缓解团队拉镜像的痛点：

- 本地无缓存时，私服向远程镜像源请求并拉回镜像，缓存后供内网所有节点复用。
- 避免多人重复下载大镜像，节省公网带宽，协作效率更高。
- 在内网隔离环境中仍能稳定获取镜像，部署流水线更顺畅。

> **提示**：本教程聚焦：在 Nexus 中创建 **Docker Proxy**，将**轩辕镜像专业版专属域名**（如 `https://***.xuanyuan.run`）填写为 **Remote storage**，兼顾稳定性与速度。专属域名免登录场景下，通常无需在 Nexus 中配置远端账号密码。

## 2. 用 Docker 一键部署 Nexus 容器

相比传统安装，Docker 方式无需手工配运行环境，一条命令即可启动 Nexus3，适合快速验证与生产沿用。

### 步骤 1：拉取轩辕镜像托管的 Nexus3 镜像（示例版本 3.90.1）

```bash
docker pull docker.xuanyuan.run/sonatype/nexus3:3.90.1
```

拉取成功后，可用 `docker images` 确认本地存在 `docker.xuanyuan.run/sonatype/nexus3:3.90.1`。

```
3.90.1: Pulling from sonatype/nexus3
4638e3415987: Pull complete
87650cc837b9: Pull complete
4591fb595303: Pull complete
3cd2f89bf989: Pull complete
1cb34de82e1f: Pull complete
575f766103b9: Pull complete
Digest: sha256:cb94c17229a34d203653345dfa28552ee462cf79c77dd2fadbd98422e5a439bc9
Status: Downloaded newer image for docker.xuanyuan.run/sonatype/nexus3:3.90.1
```

### 步骤 2：创建数据卷（持久化配置与缓存）

```bash
docker volume create --name nexus3
```

使用 `docker volume inspect nexus3` 可查看挂载点等详情。

### 步骤 3：启动容器（端口、上下文与 JVM）

```bash
docker run -d \
--name nexus3 \
--restart=always \
-p 8081:8081 \
-p 8082:8082 \
-p 8083:8083 \
-e NEXUS_CONTEXT=nexus \
-e INSTALL4J_ADD_VM_PARAMS="-Xms1024m -Xmx1024m -XX:MaxDirectMemorySize=1024m" \
-v nexus3:/nexus-data \
docker.xuanyuan.run/sonatype/nexus3:3.90.1
```

- `8081`：Web 管理界面；`8082`：Docker 代理仓库连接器（与下文 Proxy 配置一致）。
- `NEXUS_CONTEXT=nexus`：后台路径前缀，需通过 `/nexus` 访问。
- `INSTALL4J_ADD_VM_PARAMS`：限制 JVM 堆与直接内存，减轻 OOM 与卡顿风险。

`docker ps` 中容器状态为 **Up** 即表示启动成功。

### 步骤 4：登录管理后台

浏览器访问（将主机名换为您的服务器 IP 或域名）：

```
http://localhost:8081/nexus/
```

默认管理员用户名为 **admin**，初始密码在容器内文件中，执行：

```bash
docker exec nexus3 cat /nexus-data/admin.password
```

首次登录后按向导修改 admin 密码即可继续使用。

## 3. 登录引导、密码位置与仓库类型

初次打开后台时，界面会提示初始密码文件位置；登录成功后进入引导流程修改密码。下图供对照操作。

### 初始密码文件位置说明

![Nexus 管理后台中关于 admin 初始密码文件位置的官方指引](https://img.xuanyuan.dev/docker/blog/nexus/1-1.png)

图 1：按界面提示在容器内读取 `admin.password`。

### 首次登录后的密码修改引导

![Nexus 首次登录后修改 admin 密码的向导界面](https://img.xuanyuan.dev/docker/blog/nexus/2-2.png)

图 2：按向导将默认密码改为安全的新密码。

### Nexus 中与 Docker 相关的三类仓库概念

通过导航进入仓库（Repositories）配置页，可看到多种仓库类型。配置 Docker 加速时，重点理解以下三类：

![Nexus 仓库配置页面，展示 Group、Hosted、Proxy 等仓库类型](https://img.xuanyuan.dev/docker/blog/nexus/4-4.png)

图 3：仓库列表与类型概览。

- **Group（仓库组）**：聚合多个仓库，客户端只需访问组地址即可按策略解析镜像。
- **Hosted（宿主仓库）**：存放自有镜像或第三方包，常见如 release / snapshot 等用途。
- **Proxy（代理仓库）**：代理上游公共或私有 Registry 并缓存拉取过的层；**本文搭建 Docker 私服的核心即创建此类仓库**。

## 4. 对接轩辕镜像：创建 Docker Proxy 仓库

在仓库页面点击 **Create repository**，选择 **Docker (proxy)**。以下步骤与截图顺序对应。

### 步骤 1：Repository Connectors 勾选 HTTP（端口与容器映射 8082 一致）

![创建 Nexus Docker Proxy 仓库时勾选 HTTP 连接器端口 8082](https://img.xuanyuan.dev/docker/blog/nexus/5-5.png)

图 4：Docker Proxy 连接器与 HTTP 端口配置。

### 步骤 2：Remote storage 填写轩辕镜像专属域名（并在同一画面完成代理模式选型）

在 **Proxy** 区域，将 **Remote storage** 设为您的专属域名根地址，例如 `https://***.xuanyuan.run`（请替换为控制台「专属域名」中的实际主域名，对应 docker.io 加速）。

![Nexus Docker Proxy 中配置 Remote storage 为轩辕镜像专属域名](https://img.xuanyuan.dev/docker/blog/nexus/6-6.png)

图 5：远程存储 URL 指向轩辕镜像，并在代理模式中选择 **Use proxy registry (specified above)**（务必选第一项）。

### 避坑：代理模式（以及后续创建操作）必须选对

在当前创建界面里，**必须选择「Use proxy registry (specified above)」**（使用上方指定的代理 Registry）。若误选「Use Docker Hub」等仅面向 Docker Hub 的选项，可能导致 manifest 拉取失败。

- **推荐**：Use proxy registry — 标准 Registry 代理，适配轩辕镜像、Harbor、自建 Registry。
- **不推荐**：Use Docker Hub — 针对官方 Hub 的 token 逻辑，代理轩辕镜像易报错。
- **不推荐**：Custom index — 老旧方案，一般无需使用。

![Nexus Docker Proxy 代理模式应选择 Use proxy registry](https://img.xuanyuan.dev/docker/blog/nexus/7-7.png)

图 6：完成选项后，点击页面底部 **Create repository**。

### 步骤 3：其余保持默认，创建仓库

![Nexus Docker Proxy 仓库创建完成后的界面](https://img.xuanyuan.dev/docker/blog/nexus/8-8.png)

图 7：Docker Proxy 仓库创建完成后的界面示意。

## 5. 验证：通过私服拉取镜像

确认 Docker Proxy 已启用 HTTP 连接器（本例为 `localhost:8082`）后，在 Docker 客户端登录并拉取测试镜像。

### 1）登录 Nexus Docker 连接器

```bash
docker login localhost:8082
```

```
docker login localhost:8082
Username: admin
Password:
Login Succeeded
```

用户名 **admin**，密码为当前 Nexus admin 密码。看到 **Login Succeeded** 即成功。若 Docker 与 Nexus 不在同一主机，请将 `localhost` 换为可访问的服务器 IP 或域名。

### 2）拉取测试镜像（示例：tomcat）

```bash
docker pull localhost:8082/tomcat
```

```
docker pull localhost:8082/tomcat
Using default tag: latest
latest: Pulling from tomcat
817807f3c64e: Pull complete
de9be28b9519: Pull complete
c318c44e952a: Pull complete
4f4fb700ef54: Pull complete
cc1e0a391268: Pull complete
3adf9b5baee6: Pull complete
5c5afa59de0e: Pull complete
Digest: sha256:fcc94d094f67f608be017c177cabfae6f8e01b100e039c8becc9141c4e76eb1b2
Status: Downloaded newer image for localhost:8082/tomcat:latest
localhost:8082/tomcat:latest
```

拉取完成后执行 `docker images`，若列表中出现 `localhost:8082/tomcat`（或您的主机名），说明 Nexus 已成功经轩辕镜像代理并缓存；内网其他机器也可将 Registry 指向同一连接器地址复用缓存。

### 3）查看本地镜像列表

```bash
docker images
```

```
docker images
                                                                                                    i Info →   U  In Use
IMAGE                                        ID             DISK USAGE   CONTENT SIZE   EXTRA
localhost:8082/tomcat:latest                   d10cfd9141f2        417MB             0B
```

> **提示**：与 Harbor、Portainer 等场景一致：请先在轩辕镜像控制台确认专属域名可用；若拉取失败，可在 Nexus 服务器上对专属域名执行 `curl -v https://***.xuanyuan.run/v2/` 做连通性自检（返回 200 或 401 通常表示服务可达）。

## 6. 总结与拓展

通过 Docker 快速部署 Nexus3，并将轩辕镜像专属域名配置为 Docker Proxy 的远程存储，即可在内网获得可缓存、可复用的镜像拉取入口，运维成本低，适合中小团队落地。

- 可结合内网 DNS、**Nginx 反向代理** 为 Docker 连接器提供固定域名与 TLS，便于全员统一配置。
- 可使用 **Group** 仓库将多个 Proxy / Hosted 组合，满足多源与自有镜像并存的需求。
- Nexus 会在首次拉取后缓存镜像层，重复拉取主要走内网，显著降低公网依赖与等待时间。

同类方案还可对照阅读本站 [Harbor 镜像源配置教程](https://xuanyuan.cloud/usage/harbor) 与 [Portainer 镜像源配置教程](https://xuanyuan.cloud/usage/portainer)。
