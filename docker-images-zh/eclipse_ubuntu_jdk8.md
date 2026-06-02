<!-- xuanyuan-docker-images-zh
image: eclipse/ubuntu_jdk8
source: https://xuanyuan.cloud/zh/r/eclipse/ubuntu_jdk8
canonical: https://xuanyuan.cloud/zh/r/eclipse/ubuntu_jdk8
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [eclipse/ubuntu_jdk8 — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/eclipse/ubuntu_jdk8 "eclipse/ubuntu_jdk8 Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/eclipse/ubuntu_jdk8

# Eclipse Che 开发环境 Docker 镜像文档


## 一、镜像概述和主要用途

### 1.1 镜像概述  
本镜像为 Eclipse Che 开发环境栈的基础镜像，基于 Ubuntu 操作系统构建，预集成了 Java 开发及通用工具链，旨在为开发者提供开箱即用的统一开发环境。Eclipse Che 是下一代 Eclipse 平台，作为开发者工作区服务器和云 IDE，支持分布式、协作式且可移植的工作区管理。

### 1.2 主要用途  
- 提供标准化的 Java 及多语言开发环境，消除"环境不一致"问题  
- 支持 Maven 项目构建、版本控制、网络调试及文件管理等开发全流程操作  
- 作为 Eclipse Che 工作区的基础运行环境，或独立用于本地/云端开发、CI/CD 构建环节  


## 二、核心功能和特性  

### 2.1 基础系统与运行时  
- **操作系统**：基于 Ubuntu 稳定版本，提供可靠的 Linux 开发环境  
- **Java 环境**：集成 JDK 8，支持 Java 项目编译与运行  

### 2.2 开发工具链  
- **构建工具**：Maven 3，支持 Java 项目依赖管理与构建  
- **版本控制**：git，支持代码克隆、提交、分支管理等操作  
- **网络工具**：curl（HTTP 请求）、nmap（网络扫描与诊断）  
- **文件管理**：mc（Midnight Commander，命令行文件管理器）  
- **构建辅助**：cbuild，轻量级构建脚本工具  


## 三、使用场景和适用范围  

### 3.1 适用场景  
- **Java 项目开发**：需 JDK 8 和 Maven 的后端服务、应用开发  
- **跨平台协作**：团队统一开发环境，避免"本地能跑，线上报错"问题  
- **CI/CD 集成**：作为自动化构建流程中的基础环境，执行编译、测试任务  
- **快速原型验证**：无需本地配置，直接启动容器进行代码调试与验证  

### 3.2 适用人群  
- Java 开发者、全栈开发者  
-  DevOps 工程师（用于构建流程标准化）  
- 教育场景（统一教学环境配置）  


## 四、使用方法和配置说明  

### 4.1 快速启动（Docker Run）  
通过以下命令直接启动容器，默认进入交互式终端：  
```bash
docker run -it --name che-dev-env \
  -v /本地项目路径:/workspace \  # 挂载本地项目目录到容器内 workspace
  -p 8080:8080 \  # 暴露应用端口（如需要运行 Web 服务）
  eclipse/che-dev:latest /bin/bash
```  
**参数说明**：  
- `-v /本地项目路径:/workspace`：将本地项目目录挂载到容器内 `/workspace`，实现代码持久化与实时同步  
- `-p 8080:8080`：端口映射，根据实际应用端口调整（如 Spring Boot 常用 8080）  
- `-it`：交互式终端模式，支持直接在容器内执行命令  


### 4.2 Docker Compose 配置（推荐）  
创建 `docker-compose.yml` 文件，定义持久化卷与服务配置：  
```yaml
version: '3'
services:
  che-dev:
    image: eclipse/che-dev:latest
    container_name: che-dev-env
    volumes:
      - ./project:/workspace  # 本地项目目录映射
      - maven-repo:/root/.m2  # Maven 仓库持久化，避免重复下载依赖
    ports:
      - "8080:8080"
      - "5005:5005"  # 可选，Java 远程调试端口
    environment:
      - MAVEN_OPTS=-Xmx1024m  # 配置 Maven 内存参数
    tty: true  # 保持终端连接

volumes:
  maven-repo:  # 定义 Maven 仓库卷，持久化依赖
```  
启动命令：  
```bash
docker-compose up -d  # 后台启动
docker-compose exec che-dev /bin/bash  # 进入容器终端
```  


### 4.3 常用操作示例  
#### 4.3.1 项目构建（Maven）  
在容器内 `/workspace` 目录下执行 Maven 命令：  
```bash
cd /workspace/my-java-project
mvn clean package  # 编译打包项目
```

#### 4.3.2 版本控制（git）  
克隆远程代码库并切换分支：  
```bash
git clone https://github.com/example/project.git /workspace/project
cd /workspace/project
git checkout feature/new-function
```

#### 4.3.3 文件管理（mc）  
启动 Midnight Commander 图形化文件管理器：  
```bash
mc  # 支持鼠标操作，便捷管理容器内文件
```


## 五、配置参数与环境变量  

### 5.1 环境变量  
| 环境变量       | 说明                          | 默认值                  |
|----------------|-------------------------------|-------------------------|
| `MAVEN_OPTS`   | Maven 运行时 JVM 参数         | `-Xmx512m`              |
| `JAVA_HOME`    | JDK 安装路径                  | `/usr/lib/jvm/java-8-openjdk-amd64` |
| `M2_HOME`      | Maven 安装路径                | `/usr/share/maven`      |


### 5.2 自定义配置  
如需修改 Maven 镜像源（如使用阿里云），可通过挂载本地 `settings.xml` 覆盖默认配置：  
```bash
docker run -it -v ~/.m2/settings.xml:/root/.m2/settings.xml eclipse/che-dev:latest
```


## 六、注意事项  

1. **数据持久化**：务必通过 `-v` 参数挂载项目目录与 Maven 仓库（`.m2`），避免容器销毁后数据丢失  
2. **权限问题**：容器内默认使用 root 用户，本地挂载目录可能出现权限不一致，可通过 `chmod 777 ./project` 临时解决（生产环境建议配置用户映射）  
3. **版本兼容性**：JDK 版本固定为 8，如需其他版本（如 11/17），需基于本镜像重新构建 Dockerfile  


## 七、相关资源  
- 官方文档：[Eclipse Che 官方指南](https://eclipse.org/che/docs/)  
- 问题反馈：[GitHub Issues](https://github.com/eclipse/che/issues)  
- 镜像源码：[che-dockerfiles 仓库](https://github.com/eclipse/che-dockerfiles)  

--- 

**许可证**：Eclipse Public License 1.0
