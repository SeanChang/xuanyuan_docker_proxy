<!-- xuanyuan-docker-images-zh
image: bitnami/tomcat
source: https://xuanyuan.cloud/zh/r/bitnami/tomcat
canonical: https://xuanyuan.cloud/zh/r/bitnami/tomcat
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnami/tomcat" title="bitnami/tomcat Docker 镜像中文简介、标签列表与拉取命令">bitnami/tomcat — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/bitnami/tomcat" title="bitnami/tomcat Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/tomcat</a></p>

# Bitnami Apache Tomcat 软件包介绍


## 什么是 Apache Tomcat？

> Apache Tomcat 是一款开源Web服务器，用于托管和运行基于Java的Web应用程序。它是一款轻量级服务器，在生产环境中运行应用时性能表现良好。

[Apache Tomcat 概览]([])  
商标说明：本软件包由Bitnami打包。所提及的商标分属各自公司所有，使用此类商标不意味着任何关联或背书。


## 快速启动（TL;DR）

```console
docker run --name tomcat bitnami/tomcat:latest
```

默认凭据和可用配置选项可在[环境变量](#环境变量)部分查看。  

此镜像为Bitnami构建和维护的强化版最小漏洞（CVE）镜像。Bitnami安全镜像（BSI）基于云优化、安全强化的企业级操作系统[Photon Linux]([])构建。选择BSI镜像的理由包括：  
- 热门开源软件的强化安全镜像，漏洞数量接近零  
- 漏洞分类与优先级排序，包含VEX声明、KEV和EPSS评分  
- 合规支持，包括FIPS、STIG和离线部署选项，提供安全物料清单（SBOM）  
- 通过in-toto实现软件供应链溯源证明  
- 原生支持主流Helm Chart  

每个镜像均附带安全元数据，可在[公开目录]([])中查看（部分数据需[BSI商业订阅]([])）。  

如需基于Debian Linux的旧版镜像，请查看Bitnami Legacy仓库。


## 如何在Kubernetes中部署Apache Tomcat？

通过Helm Chart部署Bitnami应用是在Kubernetes上快速启动的最简单方式。安装详情参见[Bitnami Apache Tomcat Chart GitHub仓库]([])。


## 为什么使用非root容器？

非root容器增加了额外安全层，通常推荐用于生产环境。但由于容器以非root用户运行，特权任务通常受限。更多信息参见[非root容器文档]([])。


## 支持的标签及对应Dockerfile链接

了解Bitnami标签策略（滚动标签与固定标签的区别），参见[文档页面]([])。  

不同标签的对应关系可查看分支文件夹中的`tags-info.yaml`文件（如`bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`）。  

可通过关注[bitnami/containers GitHub仓库]([])获取项目更新。


## 获取镜像

获取Bitnami Apache Tomcat Docker镜像的推荐方式是从[Docker Hub仓库]([])拉取预构建镜像。  

### 拉取最新版
```console
docker pull bitnami/tomcat:latest
```

### 拉取特定版本
如需指定版本，可拉取带版本标签的镜像。[可用版本列表]([])可在Docker Hub查看。  
```console
docker pull bitnami/tomcat:[TAG]
```

### 从源码构建
如需自定义构建，可克隆仓库并执行`docker build`命令（替换示例中的`APP`、`VERSION`和`OPERATING-SYSTEM`占位符）：  
```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


## 数据持久化

删除容器后，所有数据和配置将丢失，下次运行镜像时需重新初始化。为避免数据丢失，应挂载持久化卷（容器删除后仍保留）。  

需将目录挂载到`/bitnami`路径。若挂载的目录为空，首次运行时会自动初始化。  

### Docker命令方式
```console
docker run -v /path/to/tomcat-persistence:/bitnami bitnami/tomcat:latest
```

### Docker Compose方式
修改仓库中的[`docker-compose.yml`]([])文件：  
```yaml
services:
  tomcat:
  ...
    volumes:
      - /path/to/tomcat-persistence:/bitnami
  ...
```

> **注意**：由于此为非root容器，挂载的文件和目录需对UID `1001`有正确权限。


## 在Apache Tomcat上部署Web应用

`/bitnami/tomcat/data`目录被配置为Apache Tomcat的webapps部署目录。可在此路径放置**解压的Web应用**（非压缩格式）或**压缩的Web应用资源**（`.WAR`文件），Tomcat会自动部署。  

此外，容器中存在符号链接`/app`指向该部署目录，可通过以下命令在运行中的Tomcat实例上部署应用：  
```console
docker cp /path/to/app.war tomcat:/app
```

### 创建包含应用的自定义镜像
如需构建包含WAR文件的自定义镜像，需将WAR文件添加到`/opt/bitnami/tomcat/webapps`目录。示例Dockerfile：  
```Dockerfile
FROM bitnami/tomcat:latest
COPY sample.war /opt/bitnami/tomcat/webapps
```

> **补充说明**：也可通过Apache Tomcat管理界面在运行中的实例上部署应用。  
> 更多详情参见：[Apache Tomcat Web应用部署文档]([])


## 从主机访问Apache Tomcat服务器

### 随机端口映射
可让Docker将主机随机端口映射到容器的`8080`端口：  
```console
docker run --name tomcat -P bitnami/tomcat:latest
```
执行`docker port`命令查看映射的随机端口：  
```console
$ docker port tomcat
8080/tcp -> 0.0.0.0:32768
```

### 指定端口映射
手动指定主机到容器的端口转发：  
```console
docker run -p 8080:8080 bitnami/tomcat:latest
```
在浏览器中访问 `[] 即可打开服务器。


## 配置

### 环境变量

#### 可自定义环境变量

| 名称                              | 描述                                                                 | 默认值                                                                                                                               |
|-----------------------------------|----------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `TOMCAT_SHUTDOWN_PORT_NUMBER`     | Tomcat关闭端口号                                                     | `8005`                                                                                                                               |
| `TOMCAT_HTTP_PORT_NUMBER`         | Tomcat HTTP端口号                                                    | `8080`                                                                                                                               |
| `TOMCAT_AJP_PORT_NUMBER`          | Tomcat AJP端口号                                                     | `8009`                                                                                                                               |
| `TOMCAT_USERNAME`                 | Tomcat管理用户名                                                     | `manager`                                                                                                                            |
| `TOMCAT_PASSWORD`                 | Tomcat管理用户密码                                                   | `nil`（未设置）                                                                                                                      |
| `TOMCAT_ALLOW_REMOTE_MANAGEMENT`  | 是否允许远程地址访问Tomcat管理应用                                   | `yes`                                                                                                                                |
| `TOMCAT_ENABLE_AUTH`              | 是否启用Tomcat管理应用的身份验证                                     | `yes`                                                                                                                                |
| `TOMCAT_ENABLE_AJP`               | 是否启用Tomcat AJP连接器                                             | `no`                                                                                                                                 |
| `TOMCAT_START_RETRIES`            | 等待Catalina启动的重试次数                                           | `12`                                                                                                                                 |
| `TOMCAT_EXTRA_JAVA_OPTS`          | Tomcat的额外Java配置参数                                             | `nil`（无）                                                                                                                         |
| `TOMCAT_INSTALL_DEFAULT_WEBAPPS`  | 是否部署默认Web应用（ROOT、manager、host-manager等）                  | `yes`                                                                                                                                |
| `JAVA_OPTS`                       | Java运行时参数                                                       | `-Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Duser.home=${TOMCAT_HOME}` |

#### 只读环境变量

| 名称                       | 描述                     | 值                                      |
|----------------------------|--------------------------|-----------------------------------------|
| `TOMCAT_BASE_DIR`          | Tomcat安装目录           | `${BITNAMI_ROOT_DIR}/tomcat`            |
| `TOMCAT_VOLUME_DIR`        | Tomcat持久化目录         | `/bitnami/tomcat`                       |
| `TOMCAT_BIN_DIR`           | Tomcat二进制文件目录     | `${TOMCAT_BASE_DIR}/bin`                |
| `TOMCAT_LIB_DIR`           | Tomcat库文件目录         | `${TOMCAT_BASE_DIR}/lib`                |
| `TOMCAT_WORK_DIR`          | Tomcat运行时文件目录     | `${TOMCAT_BASE_DIR}/work`               |
| `TOMCAT_WEBAPPS_DIR`       | Web应用存储目录          | `${TOMCAT_VOLUME_DIR}/webapps`          |
| `TOMCAT_CONF_DIR`          | Tomcat配置目录           | `${TOMCAT_BASE_DIR}/conf`               |
| `TOMCAT_DEFAULT_CONF_DIR`  | Tomcat默认配置目录       | `${TOMCAT_BASE_DIR}/conf.default`       |
| `TOMCAT_CONF_FILE`         | Tomcat配置文件           | `${TOMCAT_CONF_DIR}/server.xml`         |
| `TOMCAT_USERS_CONF_FILE`   | Tomcat用户配置文件       | `${TOMCAT_CONF_DIR}/tomcat-users.xml`   |
| `TOMCAT_LOGS_DIR`          | Tomcat日志目录           | `${TOMCAT_BASE_DIR}/logs`               |
| `TOMCAT_TMP_DIR`           | Tomcat临时文件目录       | `${TOMCAT_BASE_DIR}/temp`               |
| `TOMCAT_LOG_FILE`          | Tomcat日志文件路径       | `${TOMCAT_LOGS_DIR}/catalina.out`       |
| `TOMCAT_PID_FILE`          | Tomcat进程ID文件路径     | `${TOMCAT_TMP_DIR}/catalina.pid`        |
| `TOMCAT_HOME`              | Tomcat主目录             | `$TOMCAT_BASE_DIR`                      |
| `TOMCAT_DAEMON_USER`       | Tomcat系统用户           | `tomcat`                                |
| `TOMCAT_DAEMON_GROUP`      | Tomcat系统用户组         | `tomcat`                                |
| `JAVA_HOME`                | Java安装目录             | `${BITNAMI_ROOT_DIR}/java`              |

#### 创建自定义用户

默认会创建名为`manager`的管理用户，未设置密码。首次运行镜像时，通过`TOMCAT_PASSWORD`环境变量可设置该用户密码。  

还可通过`TOMCAT_USERNAME`指定管理用户名。若未指定，`TOMCAT_PASSWORD`将应用于默认用户（`manager`）。

#### 通过Docker Compose指定环境变量
修改仓库中的[`docker-compose.yml`]([])：  
```yaml
services:
  tomcat:
  ...
    environment:
      - TOMCAT_USERNAME=my_user
      - TOMCAT_PASSWORD=my_password
  ...
```

#### 通过Docker命令行指定环境变量
```console
docker run --name tomcat \
  -e TOMCAT_USERNAME=my_user \
  -e TOMCAT_PASSWORD=my_password \
  bitnami/tomcat:latest
```

### 配置文件

容器初始化时，默认Tomcat配置文件会通过[环境变量](#环境变量)修改基础选项。如需添加更多自定义配置，可挂载自定义配置文件到`/opt/bitnami/tomcat/conf/`目录以覆盖默认文件（确保文件对容器系统用户可写）。  

#### Docker命令方式
```console
docker run --name tomcat -v /path/to/config/server.xml:/opt/bitnami/tomcat/conf/server.xml bitnami/tomcat:latest
```

#### Docker Compose方式
```yaml
services:
  tomcat:
  ...
    volumes:
      - /path/to/config/server.xml:/opt/bitnami/tomcat/conf/server.xml
  ...
```

完整配置选项参见[Apache Tomcat配置手册]([])。

### Bitnami安全镜像中的FIPS配置

[Bitnami安全镜像]([])目录中的Apache Tomcat Docker镜像支持FIPS配置，可通过以下环境变量设置：  
- `OPENSSL_FIPS`：是否启用OpenSSL FIPS模式，默认`yes`（启用），可选`no`（禁用）。


## 日志

Bitnami Apache Tomcat Docker镜像将容器日志输出到`stdout`，可通过以下命令查看：  

### Docker命令方式
```console
docker logs tomcat
```

### Docker Compose方式
```console
docker-compose logs tomcat
```

如需自定义日志消费方式，可通过`--log-driver`选项配置[容器日志驱动]([])（默认使用`json-file`驱动）。


## 维护

### 升级镜像

Bitnami会及时提供Apache Tomcat的更新版本（含安全补丁），建议按以下步骤升级容器：

#### 步骤1：拉取更新的镜像
```console
docker pull bitnami/tomcat:latest
```
（使用Docker Compose时，将`image`属性更新为`bitnami/tomcat:latest`）

#### 步骤2：停止并备份当前容器
停止容器：  
```console
docker stop tomcat
```
（Docker Compose：`docker-compose stop tomcat`）  

备份持久化卷（`/path/to/tomcat-persistence`）：  
```console
rsync -a /path/to/tomcat-persistence /path/to/tomcat-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### 步骤3：删除当前容器
```console
docker rm -v tomcat
```
（Docker Compose：`docker-compose rm -v tomcat`）

#### 步骤4：运行新版本镜像
```console
docker run --name tomcat bitnami/tomcat:latest
```
（Docker Compose：`docker-compose up tomcat`）


## 重要变更

### Debian: 9.0.26-r0, 8.5.46-r0, 8.0.53-r382, 7.0.96-r50；Oracle: 9.0.24-ol-7-r35, 8.5.45-ol-7-r34, 8.0.53-ol-7-r426, 7.0.96-ol-7-r61
- 减小容器体积，配置逻辑基于`rootfs/`目录中的Bash脚本。

### 9.0.13-r27, 8.5.35-r26, 8.0.53-r131, 7.0.92-r20
- 迁移为非root用户模式：容器和Tomcat进程均以用户`1001`运行（此前容器以root运行，Tomcat以tomcat用户运行）。因此，数据目录需对该用户可写。可通过修改Dockerfile中`USER 1001`为`USER root`恢复root模式。

### 8.0.35-r3
- `TOMCAT_USER`参数重命名为`TOMCAT_USERNAME`。

### 8.0.35-r0
- 所有卷合并至`/bitnami/tomcat`，仅需挂载单个卷即可实现持久化。  
- 日志仅输出到`stdout`，不再存储于卷中。


## 使用`docker-compose.yaml`

请注意，此文件未经过内部测试，建议仅用于开发或测试环境。生产环境部署强烈推荐使用其关联的[Bitnami Helm Chart]([])。  

如发现`docker-compose.yaml`问题，可按[贡献指南]([])报告或修复。


## 贡献

欢迎通过[提交issue]([])或[拉取请求]([])参与容器改进（遵循贡献指南）。


## 问题反馈

如运行容器时遇到问题，可[提交issue]([])（建议填写issue模板以获得更好支持）。


## 许可协议

Copyright &copy; 2025 Broadcom。"Broadcom"指Broadcom Inc.及其子公司。  

根据Apache License 2.0许可协议授权（详见[LICENSE]([])）。使用本文件需遵守许可协议，除非法律要求或书面同意，软件按"原样"分发，不提供任何明示或暗示担保。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/bitnami/tomcat" title="bitnami/tomcat Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/tomcat</a></p>
