---
image: library/gcc
description: "GNU编译器集合（GCC）是一款功能强大的开源编译系统，它广泛支持多种编程语言，包括C、C++、Java、Fortran、Objective-C、Ada等，能够将源代码高效转换为可执行程序，在软件开发、系统编程及跨平台应用开发等领域发挥着关键作用，是许多操作系统和开发环境中的核心工具。"
source: https://xuanyuan.cloud/zh/r/library/gcc
canonical: https://xuanyuan.cloud/zh/r/library/gcc
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/gcc" title="library/gcc Docker 镜像中文简介、标签列表与拉取命令">library/gcc 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GCC Docker镜像使用指南


## 基础信息

### 维护者  
Docker社区（[GitHub仓库]([])）


### 获取帮助  
可通过以下渠道获取支持：  
- Docker社区Slack：[dockr.ly/comm-slack]([])  
- Server Fault：[unix.stackexchange.com]([])  
- Unix & Linux：[unix.stackexchange.com]([])  
- Stack Overflow：[stackoverflow.com]([])  


### 问题反馈  
如需提交issue，可访问：[GitHub Issues]([])  


### 支持的架构  
（更多架构信息见[官方说明]([])）  
- `amd64`：[amd64/gcc]([])  
- `arm32v5`：[arm32v5/gcc]([])  
- `arm32v7`：[arm32v7/gcc]([])  
- `arm64v8`：[arm64v8/gcc]([])  
- `ppc64le`：[ppc64le/gcc]([])  
- `s390x`：[s390x/gcc]([])  


### 镜像制品详情  
包含镜像元数据、传输大小等信息，可查看：  
[repo-info仓库的`repos/gcc/`目录]([])（[历史记录]([])）  


### 镜像更新  
- 跟踪更新：[official-images仓库`library/gcc`标签]([])  
- 更新记录：[official-images仓库`library/gcc`文件]([])（[历史提交]([])）  


### 本文档来源  
[docker-library/docs仓库`gcc/`目录]([])（[历史记录]([])）  


## 支持的标签及Dockerfile链接  

按版本号从新到旧排列：  

- **15.x版本**  
  标签：`15.2.0`、`15.2`、`15`、`latest`、`15.2.0-trixie`、`15.2-trixie`、`15-trixie`、`trixie`  
  Dockerfile：[GitHub链接]([])  

- **14.x版本**  
  标签：`14.3.0`、`14.3`、`14`、`14.3.0-trixie`、`14.3-trixie`、`14-trixie`  
  Dockerfile：[GitHub链接]([])  

- **13.x版本**  
  标签：`13.4.0`、`13.4`、`13`、`13.4.0-bookworm`、`13.4-bookworm`、`13-bookworm`  
  Dockerfile：[GitHub链接]([])  

- **12.x版本**  
  标签：`12.5.0`、`12.5`、`12`、`12.5.0-bookworm`、`12.5-bookworm`、`12-bookworm`  
  Dockerfile：[GitHub链接]([])  


## GCC简介  

GNU编译器集合（GCC）是GNU项目开发的编译器系统，支持多种编程语言，是GNU工具链的核心组件。自由软件基金会（FSF）通过GNU通用公共许可证（GNU GPL）分发GCC。作为工具和示例，GCC在自由软件的发展中发挥了重要作用。  

> 更多信息：[维基百科-GNU Compiler Collection]()  

![GCC logo]([])  


## 使用方法  


### 方法一：启动GCC实例运行应用  

直接用GCC容器作为构建和运行环境，步骤如下：  

1. **编写Dockerfile**  
   在项目根目录创建`Dockerfile`，内容示例：  
   ```dockerfile
   FROM gcc:4.9  # 可替换为其他支持的标签，如gcc:15
   COPY . /usr/src/myapp  # 将当前目录代码复制到容器内目录
   WORKDIR /usr/src/myapp  # 设置工作目录
   RUN gcc -o myapp main.c  # 编译代码（假设入口文件为main.c）
   CMD ["./myapp"]  # 运行编译后的可执行文件
   ```  

2. **构建并运行镜像**  
   执行以下命令构建镜像并启动容器：  
   ```bash
   # 构建镜像（镜像名自定义为my-gcc-app）
   docker build -t my-gcc-app .  

   # 运行容器（--rm表示退出后自动删除容器）
   docker run -it --rm --name my-running-app my-gcc-app
   ```  


### 方法二：在容器内编译应用  

若仅需编译代码（不运行），可直接通过容器临时编译，步骤如下：  

#### 单文件编译（无Makefile）  
将当前目录挂载到容器，指定工作目录并执行编译命令：  
```bash
# 格式：docker run --rm -v 本地目录:容器内目录 -w 容器内目录 镜像标签 编译命令
docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp gcc:4.9 gcc -o myapp myapp.c
```  
- `--rm`：编译完成后自动删除容器  
- `-v "$PWD":/usr/src/myapp`：将当前目录（$PWD）挂载到容器内`/usr/src/myapp`目录  
- `-w /usr/src/myapp`：设置容器工作目录为挂载目录  
- `gcc -o myapp myapp.c`：编译`myapp.c`，输出可执行文件`myapp`  


#### 通过Makefile编译  
若项目有`Makefile`，直接在容器内执行`make`命令：  
```bash
docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp gcc:4.9 make
```  


## 许可证信息  

### 软件许可证  
镜像中GCC软件的许可证信息可查看：[GCC官方文档]([])。  


### 其他说明  
Docker镜像可能包含基础系统（如Bash等）及依赖软件，这些软件可能使用其他许可证。部分自动检测到的许可证信息可参考：[repo-info仓库`gcc/`目录]([])。  

使用前请确保遵守镜像中所有软件的相关许可证要求，用户需自行承担合规责任。
