# 手把手教你 Nexus 配置 Docker 镜像源｜对接轩辕镜像，内网提速超简单

![手把手教你 Nexus 配置 Docker 镜像源｜对接轩辕镜像，内网提速超简单](https://img.xuanyuan.dev/docker/blog/nexus/nexus-docker.png)

*分类: Nexus,镜像源,配置教程 | 标签: Nexus,镜像源,配置教程 | 发布时间: 2026-03-21 05:08:56*

> 在团队开发和内网部署场景中，反复从公网拉取Docker镜像不仅耗时耗流量，还容易受网络波动影响效率。Nexus私服+轩辕镜像的组合，既能实现内网镜像缓存复用，又能借助稳定的镜像源解决拉取慢、失败的问题，堪称内网镜像管理的最优解。

在团队开发和内网部署场景中，反复从公网拉取Docker镜像不仅耗时耗流量，还容易受网络波动影响效率。**Nexus私服+轩辕镜像**的组合，既能实现内网镜像缓存复用，又能借助稳定的镜像源解决拉取慢、失败的问题，堪称内网镜像管理的最优解。

本文全程实操演示，带你从零开始用Docker部署Nexus，并对接轩辕镜像搭建专属Docker代理仓库，看完就能直接上手落地。

---

# 一、Nexus Repository 基础认知

## 1.1 为什么要搭建Nexus私服？

Nexus私服是部署在内网的构件管理仓库，核心作用是**代理远程仓库、缓存构件、内网共享**，完美解决团队开发的镜像下载痛点：

- 本地无缓存时，私服主动请求远程镜像源下载，缓存后供内网所有设备使用

- 避免多人重复拉取大体积镜像，大幅提升团队协作效率，节省公网带宽

- 内网环境隔离时，依旧能稳定获取镜像，保障部署流程顺畅

本次教程重点基于**轩辕镜像**配置Docker代理源，兼顾稳定性与下载速度，适配各类内网场景。

## 1.2 Docker一键部署Nexus容器

相比传统安装方式，用Docker部署Nexus无需繁琐配置环境，一条命令即可快速启动，全程零门槛。

### 步骤1：拉取轩辕镜像的Nexus镜像

直接拉取轩辕镜像托管的Nexus3镜像，避免公网拉取延迟，指定稳定版本3.90.1，完整拉取输出如下：

```bash
docker pull docker.xuanyuan.run/sonatype/nexus3:3.90.1
3.90.1: Pulling from sonatype/nexus3
4638e3415987: Pull complete
87650cc837b9: Pull complete
4591fb595303: Pull complete
3cd2f89bf989: Pull complete
1cb34de82e1f: Pull complete
575f766103b9: Pull complete
Digest: sha256:cb94c17229a34d203653345dfa28552ee462cf79c77dd2fadbd98422e5a439bc9
Status: Downloaded newer image for docker.xuanyuan.run/sonatype/nexus3:3.90.1
docker.xuanyuan.run/sonatype/nexus3:3.90.1
```

拉取完成后，执行命令验证镜像是否下载成功，完整输出如下：

```bash
docker images
                                                                                                    i Info →   U  In Use
IMAGE                                        ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/sonatype/nexus3:3.90.1   8509100d098c        701MB             0B
```

出现对应镜像信息，说明拉取无误。

### 步骤2：创建Nexus数据卷

为了防止容器重启后数据丢失，需要创建独立数据卷，持久化存储Nexus的配置、缓存的镜像等数据，创建命令及完整输出：

```bash
docker volume create --name nexus3
nexus3
```

执行以下命令查看数据卷详情，确认创建成功，完整JSON输出：

```bash
docker volume inspect nexus3
[
    {
        "CreatedAt": "2026-03-21T02:24:38Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/nexus3/_data",
        "Name": "nexus3",
        "Options": null,
        "Scope": "local"
    }
]
```

### 步骤3：启动Nexus容器

执行启动命令，映射端口、配置JVM参数和数据卷挂载，保证Nexus稳定运行：

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

**关键参数说明**：

- `-p 8081:8081`：Nexus管理后台端口

- `-p 8082:8082`：Docker代理仓库访问端口

- `-e NEXUS_CONTEXT=nexus`：设置后台访问前缀，需通过/nexus路径登录

- `-e INSTALL4J_ADD_VM_PARAMS`：调整JVM内存，避免Nexus卡顿

启动后执行命令验证容器状态，完整输出如下：

```bash
docker ps
CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS          PORTS                                                             NAMES
31126dc58b00   docker.xuanyuan.run/sonatype/nexus3:3.90.1   "/opt/sonatype/nexus…"   35 seconds ago   Up 33 seconds   0.0.0.0:8081-8083-&gt;8081-8083/tcp, [::]:8081-8083-&gt;8081-8083/tcp   nexus3
```

显示容器UP状态，说明启动成功。

### 步骤4：登录Nexus管理后台

访问后台地址（替换为服务器IP）：

**http://localhost:8081/nexus/**

打开后可参考官方指引图找到密码文件位置：

![Nexus后台密码指引](https://img.xuanyuan.dev/docker/blog/nexus/1-1.png)

默认管理员账号为**admin**，密码存储在容器内，执行命令获取初始密码，完整输出：

```bash
docker exec nexus3 cat /nexus-data/admin.password
fa28e8e4-457b-4e82-8425-0505c0d308d1
```

登录成功后，Nexus会弹出引导步骤，按提示修改admin密码即可：

![Nexus登录引导改密码](https://img.xuanyuan.dev/docker/blog/nexus/2-2.png)

## 1.3 Nexus仓库核心类型解析

通过导航菜单栏的配置按钮，进入仓库配置页面，界面参考下图：

![Nexus仓库配置页面](https://img.xuanyuan.dev/docker/blog/nexus/4-4.png)

页面内可看到三类核心仓库，理解分工才能正确配置Docker代理：

- **Group（仓库组）**：统一管理多个仓库，客户端只需请求组地址，即可访问组内所有仓库资源

- **Hosted（宿主仓库）**：存储内部私有构件、第三方商业包，分为releases（正式版）、snapshots（快照版）、3rd party（第三方依赖）三类

- **Proxy（代理仓库）**：代理远程公共镜像源，缓存下载过的构件，本次搭建Docker私服核心就是配置此类仓库

---

# 二、对接轩辕镜像，搭建Docker代理私服

## 2.1 创建Docker Proxy代理仓库

这是核心步骤，重点配置轩辕镜像代理，切记避开选型坑点，否则会导致镜像拉取失败。

### 步骤1：新建Docker Proxy仓库

1. 进入仓库配置页，点击**Create repository**

2. 选择仓库类型：**Docker Proxy**

3. 在**Repository Connectors**模块，勾选**HTTP**协议，端口默认8082（与容器映射端口一致）

![创建Docker Proxy仓库界面](https://img.xuanyuan.dev/docker/blog/nexus/5-5.png)

### 步骤2：配置轩辕镜像远程地址（核心）

在**Proxy**配置模块，**Remote storage**填写您的轩辕镜像**专属域名**，这是代理加速的关键，配置界面参考：

![Proxy远程存储配置](https://img.xuanyuan.dev/docker/blog/nexus/6-6.png)

**避坑必看：代理模式选型**

此处**必须选择第一个选项：Use proxy registry (specified above)**，选错会直接导致manifest拉取失败！

三个选型区别：

- ✅ Use proxy registry：标准Docker Registry代理，适配轩辕镜像、Harbor、私有Registry等场景

- ❌ Use Docker Hub：仅适用于官方Docker Hub，会自动处理token认证，代理轩辕镜像会报错

- ❌ Custom index：老旧Registry适配方案，现已基本弃用

![代理模式选型界面](https://img.xuanyuan.dev/docker/blog/nexus/7-7.png)

### 步骤3：完成仓库创建

其余配置保持默认，拉到页面底部点击**Create repository**，即可完成Docker代理仓库搭建：

![Docker Proxy仓库创建完成](https://img.xuanyuan.dev/docker/blog/nexus/8-8.png)

## 2.2 验证私服拉取镜像

### 步骤1：登录Nexus Docker私服

执行docker login命令，输入Nexus的admin账号和密码，完整登录输出：

```bash
docker login localhost:8082
Username: admin
Password:
Login Succeeded
```

提示**Login Succeeded**，说明登录成功。

### 步骤2：拉取测试镜像

以tomcat镜像为例，直接通过私服地址拉取，验证代理是否生效，完整拉取输出：

```bash
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

拉取完成后，执行命令查看本地镜像，完整输出：

```bash
docker images
                                                                                                    i Info →   U  In Use
IMAGE                                          ID             DISK USAGE   CONTENT SIZE   EXTRA
localhost:8082/tomcat:latest                   d10cfd9141f2        417MB             0B
```

出现`localhost:8082/tomcat`镜像，说明Nexus对接轩辕镜像完全成功，后续内网设备均可通过该私服拉取镜像。

---

# 三、总结与拓展

本次教程通过Docker极简部署Nexus，搭配轩辕镜像完成Docker代理仓库配置，实现了内网镜像缓存加速，全程无需复杂运维，适合中小团队快速落地。

如需进一步优化，可根据内网环境配置**域名访问、Nginx反向代理**，让私服访问更便捷；也可搭配仓库组整合多个代理源，满足多元化镜像拉取需求。

后续使用过程中，Nexus会自动缓存拉取过的镜像，再次下载时直接从内网获取，速度提升立竿见影，彻底告别公网拉取卡顿问题～

