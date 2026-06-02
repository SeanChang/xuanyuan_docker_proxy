---
image: apache/nifi
description: "提供Apache NiFi的非官方二进制构建，用于数据集成、数据流自动化与管理。"
source: https://xuanyuan.cloud/zh/r/apache/nifi
canonical: https://xuanyuan.cloud/zh/r/apache/nifi
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/nifi" title="apache/nifi Docker 镜像中文简介、标签列表与拉取命令">apache/nifi — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/nifi" title="apache/nifi Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/nifi</a>

# Apache NiFi Docker镜像文档


## 镜像概述和主要用途

Apache NiFi是一个强大的数据集成工具，用于自动化和管理系统间的数据流动。本Docker镜像提供Apache NiFi的非官方二进制构建，支持在容器环境中快速部署和运行NiFi实例。该镜像适用于开发、测试及生产环境，提供灵活的认证配置和可定制的运行参数。


## 核心功能和特性

- **多认证模式支持**：
  - 单用户认证（Single User Authentication）
  - 双向TLS认证（Mutual TLS with Client Certificates）
  - LDAP认证（Lightweight Directory Access Protocol）
- **灵活的端口配置**：支持自定义HTTP/HTTPS端口及集群通信端口
- **JVM参数定制**：可配置初始和最大堆内存大小
- **变量注册表集成**：通过环境变量配置NiFi变量注册表
- **工具集支持**：内置NiFi Toolkit，可执行用户管理等运维命令
- **持久化支持**：支持通过卷挂载证书、配置文件等


## 使用场景和适用范围

| 认证模式                | 适用场景                                  | 典型用途                          |
|-------------------------|-------------------------------------------|-----------------------------------|
| 单用户认证              | 开发、测试环境，小型独立部署              | 本地数据流程测试、个人项目        |
| 双向TLS认证             | 高安全性环境，需要客户端证书验证          | 金融、医疗等敏感数据处理场景      |
| LDAP认证                | 企业级环境，需集成现有用户目录服务        | 团队协作、多用户权限管理          |


## 使用方法和配置说明

### 1. 单用户认证模式（HTTPS）

#### 基本部署

使用默认配置启动NiFi实例，自动生成随机用户名和密码：

```bash
docker run --name nifi \
  -p 8443:8443 \
  -d \
  apache/nifi:latest
```

- 访问地址：`https://localhost:8443/nifi`
- 凭据获取：通过容器日志查看自动生成的用户名和密码：
  ```bash
  docker logs nifi | grep Generated
  ```
  日志输出格式：
  ```
  Generated Username [USERNAME]
  Generated Password [PASSWORD]
  ```

#### 自定义端口

通过环境变量修改HTTPS端口：

```bash
docker run --name nifi \
  -p 9443:9443 \
  -d \
  -e NIFI_WEB_HTTPS_PORT='9443' \
  apache/nifi:latest
```

#### 指定凭据

手动设置单用户认证的用户名和密码（密码需至少12个字符）：

```bash
docker run --name nifi \
  -p 8443:8443 \
  -d \
  -e SINGLE_USER_CREDENTIALS_USERNAME=admin \
  -e SINGLE_USER_CREDENTIALS_PASSWORD=ctsBtRBKHRAx69EqUghvvgEvjnaLjFEB \
  apache/nifi:latest
```

> **注意**：若密码长度不足12字符，NiFi将自动生成随机凭据。支持的环境变量可参考容器内`secure.sh`和`start.sh`脚本。


### 2. 双向TLS认证模式（HTTPS）

需提供证书文件及配置，通过卷挂载证书目录，并设置相关环境变量：

```bash
docker run --name nifi \
  -v /本地证书路径:/opt/certs \  # 挂载本地证书目录到容器
  -p 8443:8443 \
  -e AUTH=tls \  # 指定认证模式为TLS
  -e KEYSTORE_PATH=/opt/certs/keystore.jks \  # 密钥库路径
  -e KEYSTORE_TYPE=JKS \  # 密钥库类型
  -e KEYSTORE_PASSWORD=QKZv1hSWAFQYZ+WU1jjF5ank+l4igeOfQRp+OSbkkrs \  # 密钥库密码
  -e TRUSTSTORE_PATH=/opt/certs/truststore.jks \  # 信任库路径
  -e TRUSTSTORE_PASSWORD=rHkWR1gDNW3R9hgbeRsT3OM3Ue0zwGtQqcFKJD2EXWE \  # 信任库密码
  -e TRUSTSTORE_TYPE=JKS \  # 信任库类型
  -e INITIAL_ADMIN_IDENTITY='CN=Random User, O=Apache, OU=NiFi, C=US' \  # 初始管理员证书DN
  -d \
  apache/nifi:latest
```

> **说明**：`INITIAL_ADMIN_IDENTITY`需与客户端证书的DN一致，用于初始化管理员权限。


### 3. LDAP认证模式（HTTPS）

需配置LDAP服务器连接信息，支持SIMPLE、START_TLS、LDAPS等认证策略。

#### 基础配置（SIMPLE认证）

```bash
docker run --name nifi \
  -v /本地证书路径:/opt/certs \  # 挂载证书目录（HTTPS所需）
  -p 8443:8443 \
  -e AUTH=ldap \  # 指定认证模式为LDAP
  -e KEYSTORE_PATH=/opt/certs/keystore.jks \
  -e KEYSTORE_TYPE=JKS \
  -e KEYSTORE_PASSWORD=QKZv1hSWAFQYZ+WU1jjF5ank+l4igeOfQRp+OSbkkrs \
  -e TRUSTSTORE_PATH=/opt/certs/truststore.jks \
  -e TRUSTSTORE_PASSWORD=rHkWR1gDNW3R9hgbeRsT3OM3Ue0zwGtQqcFKJD2EXWE \
  -e TRUSTSTORE_TYPE=JKS \
  -e INITIAL_ADMIN_IDENTITY='cn=admin,dc=example,dc=org' \  # LDAP管理员DN（初始管理员）
  -e LDAP_AUTHENTICATION_STRATEGY='SIMPLE' \  # LDAP认证策略
  -e LDAP_MANAGER_DN='cn=admin,dc=example,dc=org' \  # LDAP管理用户DN
  -e LDAP_MANAGER_PASSWORD='password' \  # LDAP管理用户密码
  -e LDAP_USER_SEARCH_BASE='dc=example,dc=org' \  # 用户搜索基准DN
  -e LDAP_USER_SEARCH_FILTER='cn={0}' \  # 用户搜索过滤器
  -e LDAP_IDENTITY_STRATEGY='USE_DN' \  # 身份标识策略
  -e LDAP_URL='ldap://ldap:389' \  # LDAP服务器地址
  -d \
  apache/nifi:latest
```

#### 安全LDAP配置（START_TLS/LDAPS）

添加以下可选环境变量以支持加密LDAP连接：

```bash
-e LDAP_TLS_KEYSTORE='' \  # LDAP TLS密钥库路径
-e LDAP_TLS_KEYSTORE_PASSWORD='' \  # 密钥库密码
-e LDAP_TLS_KEYSTORE_TYPE='' \  # 密钥库类型
-e LDAP_TLS_TRUSTSTORE='' \  # LDAP TLS信任库路径
-e LDAP_TLS_TRUSTSTORE_PASSWORD='' \  # 信任库密码
-e LDAP_TLS_TRUSTSTORE_TYPE=''  # 信任库类型
```


### 4. 集群配置

通过环境变量配置NiFi集群，需映射`nifi.properties`和`state-management.xml`中的关键属性：

#### nifi.properties 映射

| 属性                                  | 环境变量                   | 说明                     |
|---------------------------------------|----------------------------|--------------------------|
| nifi.cluster.is.node                  | NIFI_CLUSTER_IS_NODE       | 是否为集群节点（true/false） |
| nifi.cluster.node.address             | NIFI_CLUSTER_ADDRESS       | 节点地址                 |
| nifi.cluster.node.protocol.port       | NIFI_CLUSTER_NODE_PROTOCOL_PORT | 集群通信端口         |
| nifi.cluster.node.protocol.max.threads| NIFI_CLUSTER_NODE_PROTOCOL_MAX_THREADS | 最大通信线程数 |
| nifi.zookeeper.connect.string         | NIFI_ZK_CONNECT_STRING     | ZooKeeper连接字符串      |
| nifi.zookeeper.root.node              | NIFI_ZK_ROOT_NODE          | ZooKeeper根节点路径      |
| nifi.cluster.flow.election.max.wait.time | NIFI_ELECTION_MAX_WAIT    | 选举最大等待时间         |
| nifi.cluster.flow.election.max.candidates | NIFI_ELECTION_MAX_CANDIDATES | 最大候选节点数      |

#### state-management.xml 映射

| 属性名          | 环境变量           | 说明                 |
|-----------------|--------------------|----------------------|
| Connect String  | NIFI_ZK_CONNECT_STRING | ZooKeeper连接字符串 |
| Root Node       | NIFI_ZK_ROOT_NODE  | ZooKeeper根节点路径  |


### 5. 使用NiFi Toolkit

在运行中的容器内执行Toolkit命令，例如查看当前用户：

```bash
# 启动容器
docker run -d --name nifi apache/nifi

# 执行Toolkit命令
docker exec -ti nifi nifi-toolkit-current/bin/cli.sh nifi current-user
```

输出示例：
```
anonymous
```


## 配置信息

### 默认端口映射

容器内默认端口及功能说明：

| 功能                 | 属性                      | 端口  | 说明                     |
|----------------------|---------------------------|-------|--------------------------|
| HTTP端口             | nifi.web.http.port        | 8080  | 未启用HTTPS时的Web端口   |
| HTTPS端口            | nifi.web.https.port       | 8443  | 启用HTTPS时的Web端口     |
| 远程输入端口         | nifi.remote.input.socket.port | 10000 | 远程数据输入端口        |
| JVM调试端口          | java.arg.debug            | 8000  | JVM调试器端口           |


### 环境变量配置

#### 核心配置

| 环境变量                          | 说明                                  | 默认值/要求                  |
|-----------------------------------|---------------------------------------|------------------------------|
| NIFI_WEB_HTTPS_PORT               | HTTPS端口                             | 8443                         |
| SINGLE_USER_CREDENTIALS_USERNAME  | 单用户认证用户名                      | 随机生成                     |
| SINGLE_USER_CREDENTIALS_PASSWORD  | 单用户认证密码（至少12字符）          | 随机生成                     |
| AUTH                              | 认证模式（single_user/tls/ldap）      | single_user                  |
| INITIAL_ADMIN_IDENTITY            | 初始管理员身份（TLS/LDAP模式）        | 无（必填）                   |
| NIFI_VARIABLE_REGISTRY_PROPERTIES | 变量注册表配置文件路径                | 无                           |
| NIFI_JVM_HEAP_INIT                | JVM初始堆内存（如1g、512m）           | 自动计算                     |
| NIFI_JVM_HEAP_MAX                 | JVM最大堆内存（如1g、512m）           | 自动计算                     |
| NIFI_JVM_DEBUGGER                 | 启用JVM调试（任意非空值）            | 禁用                         |


### 代理配置注意事项

- **代理上下文路径**：若NiFi通过代理服务器部署在非根路径下，需通过环境变量`NIFI_WEB_PROXY_CONTEXT_PATH`设置代理上下文路径。
- **代理主机信任**：映射HTTPS端口时，需通过`NIFI_WEB_PROXY_HOST`指定受信任的代理主机，格式为`host:port`。


### JVM配置

通过以下环境变量调整JVM参数：
- `NIFI_JVM_HEAP_INIT`：初始堆大小（如`1g`）
- `NIFI_JVM_HEAP_MAX`：最大堆大小（如`2g`）

示例：
```bash
docker run --name nifi \
  -p 8443:8443 \
  -e NIFI_JVM_HEAP_INIT=1g \
  -e NIFI_JVM_HEAP_MAX=2g \
  -d apache/nifi:latest
