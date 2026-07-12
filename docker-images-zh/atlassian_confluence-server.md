---
image: atlassian/confluence-server
description: "官方Confluence Server镜像，用于团队创建、组织和讨论工作内容，集中管理知识，避免信息分散于邮件和共享驱动器，提升协作效率，支持项目计划、会议记录等多种场景。"
source: https://xuanyuan.cloud/zh/r/atlassian/confluence-server
canonical: https://xuanyuan.cloud/zh/r/atlassian/confluence-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/atlassian/confluence-server" title="atlassian/confluence-server Docker 镜像中文简介、标签列表与拉取命令">atlassian/confluence-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

![Atlassian Confluence Server](https://wac-cdn.atlassian.com/dam/jcr:5d1374c2-276f-4bca-9ce4-813aba614b7a/confluence-icon-gradient-blue.svg?cdnVersion=696)

Confluence Server是团队创建、组织和讨论工作的平台。它能将常丢失在邮件收件箱和共享网络驱动器中的知识集中到Confluence，便于查找、使用和更新。每个团队、项目或部门都可拥有专属空间，创建会议记录、产品需求、文件列表或项目计划等内容，提升工作效率。

了解更多关于Confluence Server：<https://www.atlassian.com/software/confluence>

此Dockerfile的仓库地址：<https://hub.docker.com/r/atlassian/confluence-server>

# 目录

[TOC]

# 概述

此Docker容器可轻松启动和运行Confluence实例。

**注意**：此Docker镜像同时以`atlassian/confluence`和`atlassian/confluence-server`发布。这两个是相同的镜像，但`-server`版本已弃用，仅为向后兼容保留；新安装建议使用较短的名称。

**使用docker版本 >= 20.10.10**

# 快速启动

环境变量`CONFLUENCE_HOME`指定的目录用于存储Confluence数据（及其他内容），建议将主机目录挂载为[数据卷][1]：

此外，若以数据中心模式运行Confluence，需挂载共享文件系统。容器内的挂载点可通过`CONFLUENCE_SHARED_HOME`配置。

启动Atlassian Confluence Server：

```bash
docker run -v /data/your-confluence-home:/var/atlassian/application-data/confluence --name="confluence" -d -p 8090:8090 -p 8091:8091 docker.xuanyuan.run/atlassian/confluence
```

**成功启动后**，Confluence可通过 <http://localhost:8090> 访问。

请确保容器分配了足够资源，建议至少2GiB内存。详见[支持的平台][3]。

*注：若在Mac OS X上使用`docker-machine`，请使用`open http://$(docker-machine ip default):8090`访问。*

# 配置Confluence

此Docker镜像通过环境变量配置应用，环境变量用于从模板生成应用配置文件，支持动态创建和销毁容器（如集群配置）。多数部署场景可通过环境变量配置，下文将详细说明所需环境变量。若环境变量无法满足特定部署需求，可通过下文“高级配置”覆盖提供的模板。

## 内存/堆大小

如需覆盖Confluence Server的默认内存分配，可通过以下环境变量控制JVM最小堆（Xms）和最大堆（Xmx）：

* `JVM_MINIMUM_MEMORY`（默认：1024m）  
  JVM的最小堆大小  

* `JVM_MAXIMUM_MEMORY`（默认：1024m）  
  JVM的最大堆大小  

* `JVM_RESERVED_CODE_CACHE_SIZE`（默认：256m）  
  JVM的保留代码缓存大小  

## Tomcat和反向代理设置

若Confluence运行在反向代理服务器（如负载均衡器或nginx）后，需指定额外选项使Confluence感知该设置。可通过以下环境变量控制：

* `ATL_PROXY_NAME`（默认：NONE）  
  反向代理的完全限定主机名。`CATALINA_CONNECTOR_PROXYNAME`也受支持，用于向后兼容。  

* `ATL_PROXY_PORT`（默认：NONE）  
  访问Confluence时使用的反向代理端口。`CATALINA_CONNECTOR_PROXYPORT`也受支持，用于向后兼容。  

* `ATL_TOMCAT_PORT`（默认：8090）  
  Tomcat/Confluence监听的端口。根据容器部署方式，可能需要[暴露和发布][docker-expose]此端口。  

* `ATL_TOMCAT_SCHEME`（默认：http）  
  访问Confluence的协议。`CATALINA_CONNECTOR_SCHEME`也受支持，用于向后兼容。  

* `ATL_TOMCAT_SECURE`（默认：false）  
  若`ATL_TOMCAT_SCHEME`为'https'，设为'true'。`CATALINA_CONNECTOR_SECURE`也受支持，用于向后兼容。  

* `ATL_TOMCAT_CONTEXTPATH`（默认：NONE）  
  应用的上下文路径。`CATALINA_CONTEXT_PATH`也受支持，用于向后兼容。  

* `ATL_TOMCAT_ACCESS_LOG`（默认：版本<7.11.0为false，版本>=7.11.0为true）  
  是否启用Tomcat访问日志；设为`true`启用。**注意**：日志默认写入容器内部卷（`/opt/atlassian/confluence/logs/`），会轮转但不会删除，可能无限增长。启用此功能建议将目录挂载为卷，并通过外部工具进行日志收集/清理。  

还支持以下Tomcat/Catalina选项，详见<https://tomcat.apache.org/tomcat-7.0-doc/config/index.html>：

* `ATL_TOMCAT_MGMT_PORT`（默认：8000）  
* `ATL_TOMCAT_MAXTHREADS`（默认：48）  
* `ATL_TOMCAT_MINSPARETHREADS`（默认：10）  
* `ATL_TOMCAT_CONNECTIONTIMEOUT`（默认：20000）  
* `ATL_TOMCAT_ENABLELOOKUPS`（默认：false）  
* `ATL_TOMCAT_PROTOCOL`（默认：org.apache.coyote.http11.Http11NioProtocol）  
* `ATL_TOMCAT_REDIRECTPORT`（默认：8443）  
* `ATL_TOMCAT_ACCEPTCOUNT`（默认：10）  
* `ATL_TOMCAT_DEBUG`（默认：0）  
* `ATL_TOMCAT_URIENCODING`（默认：UTF-8）  
* `ATL_TOMCAT_MAXHTTPHEADERSIZE`（默认：8192）  

## 访问日志设置

可设置访问日志保留的最大天数，超过后自动删除。默认值-1表示永不删除旧文件。

* `ATL_TOMCAT_ACCESS_LOGS_MAXDAYS`（默认：-1）  

## JVM配置

如需传递额外JVM参数（如指定自定义信任库），可通过以下环境变量：

* `JVM_SUPPORT_RECOMMENDED_ARGS`  
  Confluence的额外JVM参数  

示例：
```bash
docker run -e JVM_SUPPORT_RECOMMENDED_ARGS=-Djavax.net.ssl.trustStore=/var/atlassian/application-data/confluence/cacerts -v confluenceVolume:/var/atlassian/application-data/confluence --name="confluence" -d -p 8090:8090 -p 8091:8091 docker.xuanyuan.run/atlassian/confluence
```

更多可配置的设置见：[Recognized System Properties](https://confluence.atlassian.com/doc/recognized-system-properties-190430.html)

## Confluence特定设置

* `ATL_AUTOLOGIN_COOKIE_AGE`（默认：1209600秒，即两周）  
  “记住我”功能的最大登录保持时间。  

* `CONFLUENCE_HOME`  
  Confluence主目录。可挂载到数据卷；若挂载，需确保用户`confluence`对其有写权限。详见下文UID映射说明。  

* `ATL_LUCENE_INDEX_DIR`  
  [Lucene](https://lucene.apache.org/)搜索索引存储目录。默认位于Confluence主目录下的`index`子目录。  

* `ATL_LICENSE_KEY`（Confluence 7.9及以上）  
  Confluence许可证字符串。提供此参数可跳过Web启动界面的许可证输入步骤。  

* *谨慎使用* `CONFLUENCE_LOG_STDOUT` `[true, false]`（Confluence 7.9及以上）  
  Confluence 7.9.0之前版本，日志始终存储在Confluence主目录的`logs`文件夹中；7.9.0及以上版本，可设为`true`将日志直接输出到`stdout`（不生成日志文件），便于通过`docker logs <容器ID>`查看日志。建议配合日志聚合工具（如AWS Cloudwatch或ELK stack）使用。**注意**：启用此功能后，Troubleshooting and Support插件生成的支持ZIP包不含应用日志。  

## 数据库配置

可通过环境变量配置数据库，无需通过Web启动界面设置。使用此功能需提供以下所有变量：

* `ATL_JDBC_URL`  
  数据库URL（数据库特定格式）。  

* `ATL_JDBC_USER`  
  数据库连接用户。  

* `ATL_JDBC_PASSWORD`  
  数据库用户密码。  

* `ATL_DB_TYPE`  
  数据库类型，支持的值：  
  * `mssql`  
  * `mysql`  
  * `oracle12c`（仅Confluence 7.3.0及以下）  
  * `oracle`（Confluence 7.3.1及以上，兼容Oracle 12c和19c）  
  * `postgresql`  

注意：由于许可限制，Confluence不随附MySQL或Oracle JDBC驱动。使用这些数据库需手动复制合适的驱动到容器并重启。例如，将MySQL驱动复制到名为“confluence”的容器：
```bash
docker cp mysql-connector-java.x.y.z.jar confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib
docker restart confluence
```

更多信息见[Database JDBC Drivers](https://confluence.atlassian.com/doc/database-jdbc-drivers-171742.html)。

### 可选数据库设置

以下变量用于数据库连接池配置，为可选参数：

* `ATL_DB_POOLMINSIZE`（默认：20）  
* `ATL_DB_POOLMAXSIZE`（默认：100）  
* `ATL_DB_TIMEOUT`（默认：30）  
* `ATL_DB_IDLETESTPERIOD`（默认：100）  
* `ATL_DB_MAXSTATEMENTS`（默认：0）  
* `ATL_DB_VALIDATE`（默认：false）  
* `ATL_DB_ACQUIREINCREMENT`（默认：1）  
* `ATL_DB_VALIDATIONQUERY`（默认："select 1"）  
* `ATL_DB_PROVIDER_CLASS`（默认：`com.atlassian.confluence.impl.hibernate.DelegatingHikariConnectionProvider`）  

## 数据中心配置

此Docker镜像可作为[数据中心][4]集群的一部分运行。通过以下属性可将Confluence启动为数据中心节点，无需手动配置集群。详见[Installing Confluence Data Center][5]。

### 集群配置

Confluence Data Center支持多种集群方式，详见[配置说明][6]。**注意**：需确保底层网络支持所选集群类型，具体配置取决于容器管理技术，超出本文档范围。

#### 通用集群设置

* `ATL_CLUSTER_TYPE`  
  集群类型。设置此参数即启用集群模式，支持的值：`aws`、`multicast`、`tcp_ip`。  

* `ATL_CLUSTER_NAME`  
  集群名称（所有节点需相同）。  

* `ATL_PRODUCT_HOME_SHARED`  
  所有Confluence节点的共享主目录。**注意**：必须挂载真实的共享文件系统到容器内，且确保UID有写权限（详见下文）。  

* `ATL_CLUSTER_TTL`  
  集群数据包的生存时间（主要用于多播集群）。  

#### AWS集群设置

需从AWS环境获取以下参数：

* `ATL_HAZELCAST_NETWORK_AWS_IAM_ROLE`  
* `ATL_HAZELCAST_NETWORK_AWS_IAM_REGION`  
* `ATL_HAZELCAST_NETWORK_AWS_HOST_HEADER`  
* `ATL_HAZELCAST_NETWORK_AWS_SECURITY_GROUP`  
* `ATL_HAZELCAST_NETWORK_AWS_TAG_KEY`  
* `ATL_HAZELCAST_NETWORK_AWS_TAG_VALUE`  

#### TCP集群设置

* `ATL_CLUSTER_PEERS`  
  逗号分隔的 peer IP 列表。  

#### 多播集群设置

* `ATL_CLUSTER_ADDRESS`  
  集群通信的多播地址。  

## 容器配置

* `ATL_FORCE_CFG_UPDATE`（默认：false）  
  Docker [入口点](entrypoint.py)在首次启动时生成应用配置，后续启动不会重新生成所有配置文件（避免重启或升级时覆盖手动修改）。但在纯环境变量配置的部署（如Kubernetes）中可能需要强制更新，设为`true`可强制重新生成所有配置文件。Confluence中受影响的文件为`confluence.cfg.xml`。详见[入口点代码](entrypoint.py)了解配置文件生成逻辑。  

* `SET_PERMISSIONS`（默认：true）  
  是否在启动时设置主目录权限。设为`false`禁用此行为。  

* `ATL_UNSET_SENSITIVE_ENV_VARS`（默认：true）  
  **警告**：启用此属性后，包含'PASS'、'SECRET'或'TOKEN'关键字的敏感环境变量值将以明文形式暴露在主机OS上，可能被主机上的用户或进程访问。  
  定义是否清除包含上述关键字的环境变量。入口点脚本执行清除操作。若需保留敏感环境变量，设为`false`。  

* `ATL_ALLOWLIST_SENSITIVE_ENV_VARS`  
  **警告**：启用此属性后，敏感环境变量值将以明文形式暴露在主机OS上，可能被主机上的用户或进程访问。  
  定义逗号分隔的环境变量列表，这些变量包含'PASS'、'SECRET'或'TOKEN'关键字但不被清除。使用`^`作为 regex 前缀。例如，设为`PATH_TO_SECRET_FILE`将保留所有以`PATH_TO_SECRET_FILE`开头的变量。  

# 高级配置

如前文所述，环境变量配置覆盖大部分场景。若需自定义未覆盖的配置，可通过以下方式修改模板：

## 构建自定义镜像

* 克隆Atlassian仓库：<https://bitbucket.org/atlassian-docker/docker-atlassian-confluence-server/>  
* 修改或替换`config`目录下的[Jinja](https://jinja.palletsprojects.com/)模板（文件需带`.j2`扩展名，可不使用模板变量）。  
* 构建新镜像（如`docker build --tag my-confluence-image --build-arg CONFLUENCE_VERSION=6.x.x .`），推送至仓库并部署。  

## 基于现有镜像构建新镜像

* 创建`Dockerfile`，以`FROM atlassian/confluence:latest`开头。  
* 使用`COPY`指令覆盖提供的模板。  
* 构建、推送并部署新镜像。  

## 运行时覆盖模板

两种方式：  
* 若容器长期运行，可创建容器后修改`/opt/atlassian/etc/`下的模板，再启动容器。  
* 创建包含自定义模板的数据卷，运行时通过`--volume my-config:/opt/atlassian/etc/`挂载覆盖默认模板。  

# 共享目录和用户ID

默认情况下，Confluence应用以用户`confluence`运行，UID和GID均为2002。因此，此UID需对共享文件系统有写权限。若需使用其他UID，可选择以下方式：  
* 重新构建Docker镜像，指定不同UID。  
* Linux环境下，通过[用户命名空间重映射][7]修改UID。  

为确保特定配置文件的严格权限，容器以`root`用户启动执行引导操作，然后切换到非特权用户`confluence`运行Confluence。若需以非root用户启动容器，请注意：Tomcat配置、seraph-config.xml（SSO）和confluence-init.properties（覆盖`$CONFLUENCE_HOME`）的引导操作将跳过，并记录警告日志。仍可通过直接挂载自定义文件（如`/opt/atlassian/confluence/conf/server.xml`）应用配置。以非root用户启动时，数据库和集群引导操作不受影响。  

# 升级

要升级到新版本的Confluence Server，只需停止当前容器并启动基于新版本镜像的容器：
```bash
docker stop confluence
docker rm confluence
docker run ...（见上文启动命令）
```
数据存储在主机的数据卷目录中，升级后仍可访问。**注意**：不要使用`-v`选项删除容器和卷，以免丢失数据。  

# 备份

评估环境中，可使用内置数据库（数据存储在Confluence Server主目录），备份主机上挂载的数据卷目录（如示例中的`/data/your-confluence-home`）即可。Docker环境支持Confluence的[自动备份][8]，使用外部数据库时可采用[生产备份策略][9]。更多数据恢复和备份信息见：[Site Backup and Restore][10]  

# 关闭

Confluence允许20秒的宽限期，等待活动操作完成后再终止。执行`docker stop`时，建议使用`--time`标志考虑此宽限期。此外，提供`/shutdown-wait.sh`脚本，可启动干净关闭并等待进程完成，推荐在支持有序关闭的环境（如Kubernetes的`preStop`钩子）中使用。  

# 版本控制

`latest`标签对应最新的官方Confluence Server版本，即`atlassian/confluence:latest`使用最新稳定版。也可通过版本标签指定
