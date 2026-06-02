<!-- xuanyuan-docker-images-zh
image: sonatype/nexus
source: https://xuanyuan.cloud/zh/r/sonatype/nexus
canonical: https://xuanyuan.cloud/zh/r/sonatype/nexus
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [sonatype/nexus — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/sonatype/nexus "sonatype/nexus Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/sonatype/nexus

# sonatype/docker-nexus  


Sonatype Nexus Repository Manager 2 的 Docker 镜像，基于 Oracle JDK 构建。如需 Nexus Repository Manager 3，请参考：[[]]([])  


## 构建镜像  

### 构建 OSS 或 Pro 版本  
```bash  
# 构建 OSS 版本镜像  
docker build --rm --tag sonatype/nexus oss/  

# 构建 Pro 版本镜像  
docker build --rm --tag sonatype/nexus:pro pro/  
```  

### 通用构建方式  
复制 Dockerfile 后执行构建：  
```bash  
docker build --rm=true --tag=sonatype/nexus .  
```  


## 运行容器  

### 基本运行（主机 8081 端口开放时）  
```bash  
docker run -d -p 8081:8081 --name nexus sonatype/nexus:oss  
```  

### 查看容器监听端口  
```bash  
docker ps -l  
```  

### 测试服务可用性  
```bash  
curl []  
```  


## 注意事项  


### 默认凭据  
初始登录账号：`admin`，密码：`admin123`  


### 启动时间  
新容器启动服务需要 2-3 分钟。可通过日志确认 Nexus 是否就绪：  
```bash  
docker logs -f nexus  
```  


### 安装路径与配置  
- Nexus 安装路径：`/opt/sonatype/nexus`  
- 配置文件：`/opt/sonatype/nexus/conf/nexus.properties`（文件中定义的 `nexus-work` 和 `nexus-webapp-context-path` 参数会被 JVM 调用覆盖）  


### 持久化目录  
- 路径：`/sonatype-work`，用于存储配置、日志和数据  
- 权限要求：该目录需对 Nexus 进程（运行用户 UID 200）可写  


### 环境变量控制 JVM 参数  
可通过环境变量调整 JVM 配置，运行容器时添加 `-e` 参数指定：  

| 变量名          | 作用说明                                                                 | 默认值                                  |  
|-----------------|--------------------------------------------------------------------------|-----------------------------------------|  
| `CONTEXT_PATH`  | 访问 URL 路径，对应 JVM 参数 `-Dnexus-webapp-context-path`               | `/nexus`                                |  
| `MAX_HEAP`      | 最大堆内存，对应 `-Xmx`                                                  | `768m`                                  |  
| `MIN_HEAP`      | 最小堆内存，对应 `-Xms`                                                  | `256m`                                  |  
| `JAVA_OPTS`     | 额外 JVM 参数                                                            | `-server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true` |  
| `LAUNCHER_CONF` | Nexus 启动器配置文件列表                                                 | `./conf/jetty.xml ./conf/jetty-requestlog.xml` |  

**示例**：设置最大堆内存为 1G  
```bash  
docker run -d -p 8081:8081 --name nexus -e MAX_HEAP=1g sonatype/nexus  
```  


### 持久化数据  
推荐两种方式管理持久化存储（详见 [Docker 数据管理文档]([])）：  

#### 方法 1：使用数据卷容器（推荐）  
创建专用数据卷容器，数据卷会一直保留到无容器使用时：  
```bash  
# 创建数据卷容器  
docker run -d --name nexus-data sonatype/nexus echo "data-only container for Nexus"  

# 运行 Nexus 并挂载数据卷  
docker run -d -p 8081:8081 --name nexus --volumes-from nexus-data sonatype/nexus  
```  

#### 方法 2：挂载主机目录  
需确保主机目录存在且权限正确（适用于需要指定底层存储的场景）：  
```bash  
# 主机创建目录并授权（UID 200 为 Nexus 进程用户）  
mkdir /some/dir/nexus-data && chown -R 200 /some/dir/nexus-data  

# 运行容器并挂载目录  
docker run -d -p 8081:8081 --name nexus -v /some/dir/nexus-data:/sonatype-work sonatype/nexus  
```  


### 添加 Nexus 插件  
建议基于 `sonatype/nexus` 镜像创建新镜像，将插件解压到路径：  
`/opt/sonatype/nexus/nexus/WEB-INF/plugin-repository`  

示例参考：[Nexus P2 插件安装]([])  


## 获取帮助  

如需贡献或寻求帮助，可通过以下途径：  
- [GitHub Issues]([])（提交公开问题）  
- [Stack Overflow]([])（`nexus` 标签）  
- [HipChat 公开房间]([])（实时交流）  
- [Nexus 用户邮件列表]([])
