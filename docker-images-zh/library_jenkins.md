<!-- xuanyuan-docker-images-zh
image: library/jenkins
source: https://xuanyuan.cloud/zh/r/library/jenkins
canonical: https://xuanyuan.cloud/zh/r/library/jenkins
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/library/jenkins" title="library/jenkins Docker 镜像中文简介、标签列表与拉取命令">library/jenkins — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/library/jenkins" title="library/jenkins Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/jenkins</a></p>

# 弃用通知  

该镜像已弃用超过两年，推荐使用由[Jenkins社区]([])在项目发布流程中提供并维护的 [`jenkins/jenkins:lts` 镜像]([])。此处的镜像已超过两年未更新，且未来不会再提供任何更新。  

现存标签仅作历史归档用途，**均不提供支持，且不应再使用**。  


# 历史标签信息  

以下为该镜像的历史标签及对应 Dockerfile 链接（均为遗留内容，不建议使用）：  
- [`latest`, `2.60.3`（Dockerfile）]([])  
- [`alpine`, `2.60.3-alpine`（Dockerfile）]([])  


# 快速参考  

- **获取帮助**：  
  [Docker 社区论坛]([])、[Docker 社区 Slack]([]) 或 [Stack Overflow]([])  

- **提交问题**：  
  [[]]([])  

- **维护方**：  
  [Jenkins 项目]([])  

- **支持架构**：（[更多信息]([])）  
  [`amd64`]([])  

- **镜像 artifact 详情**：  
  [repo-info 仓库的 `repos/jenkins/` 目录]([])（[历史记录]([])）  
  （包含镜像元数据、传输大小等）  

- **镜像更新**：  
  [带有 `library/jenkins` 标签的 official-images PR]([])  
  [official-images 仓库的 `library/jenkins` 文件]([])（[历史记录]([])）  

- **描述来源**：  
  [docs 仓库的 `jenkins/` 目录]([])（[历史记录]([])）  

- **支持的 Docker 版本**：  
  [最新版本]([])（最低支持 1.6，尽力兼容）  


# Jenkins 简介  

Jenkins 是一款持续集成与交付服务器，基于长期支持（LTS）版本构建，详情可查看 [[]]([])。周版本镜像可参考 [`jenkinsci/jenkins`]([])。  


# 历史使用方法  

> **注意**：以下为该弃用镜像的历史使用说明，当前不建议参考。推荐使用 [`jenkins/jenkins:lts` 镜像]([]) 并查阅其官方文档。  


## 基本运行  

```console
docker run -p 8080:8080 -p 50000:50000 jenkins
```  

Jenkins 数据（含插件、配置等）存储在 `/var/jenkins_home` 目录，建议通过卷挂载实现持久化：  

```console
docker run -p 8080:8080 -p 50000:50000 -v /your/home:/var/jenkins_home jenkins
```  

需确保主机目录 `/your/home` 对容器内 Jenkins 用户（UID 1000）可访问，或通过 `-u some_other_user` 参数指定用户。  

也可使用卷容器：  

```console
docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home jenkins
```  


## 数据备份  

若通过卷挂载数据，直接备份 `/your/home` 目录即可（推荐定期备份，将其视为数据库对待）。若卷在容器内，可通过 `docker cp $ID:/var/jenkins_home` 提取数据（注意部分系统可能将符号链接转为副本，可能影响 Jenkins 链接如 `lastStableBuild`）。更多信息参考 Docker 文档 [容器数据管理]([])。  


## 设置执行器数量  

默认执行器数量为 2，可通过 Groovy 脚本自定义。例如，创建 `executors.groovy`：  

```groovy
import jenkins.model.*
Jenkins.instance.setNumExecutors(5)
```  

再通过 Dockerfile 构建新镜像：  

```dockerfile
FROM jenkins
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
```  


## 附加构建执行器  

默认可在主节点运行构建，若需连接从节点，需映射端口 `-p 50000:50000`（从节点代理连接端口）。  


## 传递 JVM 参数  

通过 `JAVA_OPTS` 环境变量自定义 JVM 设置（如系统属性、堆内存）：  

```console
docker run --name myjenkins -p 8080:8080 -p 50000:50000 --env JAVA_OPTS=-Dhudson.footerURL=[] jenkins
```  


## 配置日志  

通过属性文件和 `java.util.logging.config.file` 参数配置日志。例如：  

```console
mkdir data
cat > data/log.properties <<EOF
handlers=java.util.logging.ConsoleHandler
jenkins.level=FINEST
java.util.logging.ConsoleHandler.level=FINEST
EOF
docker run --name myjenkins -p 8080:8080 -p 50000:50000 --env JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties" -v `pwd`/data:/var/jenkins_home jenkins
```  


## 传递 Jenkins 启动参数  

启动参数可直接作为 `docker run` 命令参数，例如查看版本：  

```console
docker run jenkins --version
```  

也可通过 `JENKINS_OPTS` 环境变量定义，例如强制使用 HTTPS：  

```dockerfile
FROM jenkins:1.565.3
COPY https.pem /var/lib/jenkins/cert
COPY https.key /var/lib/jenkins/pk
ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pk
EXPOSE 8083
```  

修改从节点代理端口可通过 `JENKINS_SLAVE_AGENT_PORT` 环境变量：  

```console
docker run --name myjenkins -p 8080:8080 -p 50001:50001 --env JENKINS_SLAVE_AGENT_PORT=50001 jenkins
```  


## 安装额外工具  

可通过 Dockerfile 扩展镜像，例如安装 apt 包：  

```dockerfile
FROM jenkins
USER root
RUN apt-get update && apt-get install -y ruby make more-thing-here
USER jenkins
```  

也可通过插件脚本安装插件。创建 `plugins.txt`（格式 `pluginID:version`）：  

```
credentials:1.18
maven-plugin:2.7.1
```  

再构建镜像：  

```dockerfile
FROM jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
```  


## 升级  

升级需依赖 `/var/jenkins_home` 目录数据。通常流程为：备份该目录 → `docker pull` 获取新版本镜像 → 通过 `-v` 挂载数据目录启动新容器。  


# 历史镜像变体  

该镜像曾提供以下变体（均已弃用）：  

- **`jenkins:<version>`**：默认镜像，适用于通用场景。  
- **`jenkins:alpine`**：基于 Alpine Linux，体积更小（约 5MB 基础镜像），使用 musl libc（部分软件可能存在兼容性问题）。  


# 许可信息  

查看镜像中软件的许可信息：[[]]([])。镜像可能包含其他软件（如 Bash 等），其许可需用户自行确认合规性。部分自动检测的许可信息可参考 [repo-info 仓库的 `jenkins/` 目录]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/library/jenkins" title="library/jenkins Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/library/jenkins</a></p>
