---
image: jenkins/ssh-agent
description: "这是一个用于通过SSH连接的Jenkins代理的Docker镜像，它预配置了SSH服务及Jenkins代理运行所需的基础依赖，旨在简化分布式构建环境中Jenkins代理节点的部署流程，支持代理节点通过SSH安全连接至Jenkins主节点并执行构建任务，帮助用户快速搭建稳定、高效的Jenkins分布式构建架构，适用于需要跨节点协作完成自动化构建、测试与部署的开发场景。"
source: https://xuanyuan.cloud/zh/r/jenkins/ssh-agent
canonical: https://xuanyuan.cloud/zh/r/jenkins/ssh-agent
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkins/ssh-agent" title="jenkins/ssh-agent Docker 镜像中文简介、标签列表与拉取命令">jenkins/ssh-agent — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/jenkins/ssh-agent" title="jenkins/ssh-agent Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/jenkins/ssh-agent</a>

# Jenkins SSH 代理 Docker 镜像


## 概述  
这是一个通过 SSH 协议建立连接的 Jenkins 代理镜像，可配合 [SSH Build Agents 插件]([]) 或其他类似插件使用，适用于 Jenkins 分布式构建场景。详细信息可参考 [Jenkins 分布式构建文档]([])。


## 运行说明  

### 配合 SSH Build Agents 插件使用  
通过以下命令启动代理容器：  

```bash
docker run -d --rm --name=agent --publish 2200:22 -e "JENKINS_AGENT_SSH_PUBKEY=<公钥>" jenkins/ssh-agent
```  

**参数说明**（非必填，仅为示例）：  
- `-d`：后台运行容器  
- `--rm`：容器退出后自动删除  
- `--name=agent`：为容器命名（未指定则随机生成）  
- `--publish 2200:22`：将主机 2200 端口映射到容器 22 端口（SSH 端口），可通过 `ssh jenkins@localhost -p 2200` 连接  


#### 关键配置  
启动后，通过 SSH Build Agents 插件以用户名 `jenkins` 和对应私钥连接代理。需注意：  
- **Linux 镜像**：在代理配置界面中，需将「远程根目录」设为 `/home/jenkins/agent`。  
  ![Linux 代理的远程根目录设置]([] "Linux 代理的远程根目录")  

- **Windows 镜像**：需将「远程根目录」设为 `C:/Users/jenkins/Work`。  
  ![Windows 代理的远程根目录设置]([] "Windows 代理的远程根目录")  


#### 自定义工作目录  
若需使用非默认目录（如 Linux 下非 `/home/jenkins/agent`），需挂载数据卷：  

```bash
docker run -v 自定义卷名:/home/jenkins/agent:rw jenkins/ssh-agent "<公钥>"
```  


### 配合 Docker Plugin 使用  
通过 [Docker Plugin]([]) 使用时，需通过环境变量 `JENKINS_AGENT_SSH_PUBKEY` 传入公钥（**不要作为启动参数**）：  

1. 在 Docker 模板的「环境变量」配置项（高级设置）中添加：  
   ```env
   JENKINS_AGENT_SSH_PUBKEY=<你的公钥>
   ```  
   *公钥无需加引号。*  

2. 在 Docker 代理模板配置界面中，将「远程文件系统根目录」设为 `/home/jenkins/agent`。  
   ![远程文件系统根目录设置]([] "远程文件系统根目录")  

3. 若使用自定义目录，需在「Docker 卷挂载」中添加对应卷。  
   ![Docker 卷挂载设置]([] "Docker 卷挂载")  


## 扩展镜像  
如需基于此镜像添加自定义内容，可参考以下 Dockerfile 示例：  

```dockerfile
FROM jenkins/ssh-agent:debian-jdk17 as ssh-agent
# 添加自定义文件（如密钥），并确保权限正确
COPY --chown=jenkins 本地密钥文件 "${JENKINS_AGENT_HOME}/.ssh/目标文件名"
```  


## 镜像标签说明  
该镜像提供多种配置，可通过以下标签选择（`${IMAGE_VERSION}` 为具体版本号，见 [GitHub Releases]([])）：  

- **Linux (debian 基础)**：  
  `latest`、`latest-jdk11`、`jdk11`、`debian-jdk11`、`${IMAGE_VERSION}-jdk11`  
  `latest-jdk17`、`jdk17`、`debian-jdk17`、`${IMAGE_VERSION}-jdk17`  

- **Windows**：  
  `nanoserver-1809-jdk11`、`windowsservercore-ltsc2019-jdk11` 等（具体标签见 [官方文档]([])）  


## 构建镜像说明  

### 构建前提  
需安装以下工具：  
- Docker（含 BuildX 插件，19.03+ 版本通常已内置）  
- GNU Make、jq、Bash、git、curl  


### 构建步骤  

#### 查看可构建镜像  
```bash
make list
# 输出示例：alpine_jdk11、alpine_jdk17、debian_jdk11、debian_jdk17
```  


#### 构建特定镜像  
```bash
# 格式：make build-<系统>_<JDK版本>
make build-alpine_jdk11  # 构建 alpine 系统 + JDK 11 的镜像
```  


#### 构建所有镜像  
```bash
make build
```  


#### 测试镜像  
```bash
# 测试所有镜像
make test

# 测试特定镜像（如 alpine_jdk11）
make test-alpine_jdk11
```  


#### 其他命令  
- `make show`：查看镜像详细信息（标签、平台、Dockerfile 路径等）  
- `make bats`：更新 bats 测试工具并运行测试  


## 变更日志  
详见 [GitHub Releases]([])（2019 年 12 月起开始维护变更日志，更早版本需参考提交历史）。
