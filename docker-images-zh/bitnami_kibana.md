---
image: bitnami/kibana
description: "Bitnami提供的Kibana安全镜像，用于部署和运行安全加固的Kibana环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/kibana
canonical: https://xuanyuan.cloud/zh/r/bitnami/kibana
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [bitnami/kibana — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/bitnami/kibana)

含镜像标签、拉取命令、部署文档与相关推荐。

[bitnami/kibana Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/bitnami/kibana)

# Bitnami Kibana 镜像文档

## 镜像概述

### 什么是 Kibana？

> Kibana 是一个开源的、基于浏览器的 Elasticsearch 分析与搜索仪表板。它致力于提供简单易用的入门体验，同时保持灵活性和强大功能。

[Kibana 官方概述](https://www.elastic.co/products/kibana)  
**商标声明**：本软件包由 Bitnami 打包。所提及的商标分属各自公司所有，使用这些商标并不意味着任何关联或认可。


## 重要通知：Bitnami 镜像仓库即将变更

自 2025 年 8 月 28 日起，Bitnami 将升级其公共镜像仓库，通过新的 [Bitnami Secure Images 计划](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications) 提供精选的、安全强化的镜像集。此次变更包括：

- 首次向社区用户开放热门容器镜像的安全优化版本。
- Bitnami 将逐步停止对免费 tier 中非强化的 Debian 基础镜像的支持，并从公共仓库中逐步移除非最新标签。社区用户将只能访问数量减少的强化镜像，这些镜像仅以 “latest” 标签发布，适用于开发环境。
- 自 8 月 28 日起，在两周内，所有现有容器镜像（包括旧版本标签，如 2.50.0、10.6）将从公共仓库（docker.io/bitnami）迁移至 “Bitnami Legacy” 仓库（docker.io/bitnamilegacy），且不再接收更新。
- 对于生产环境和长期支持，建议用户采用 Bitnami Secure Images，包括强化容器、更小的攻击面、CVE 透明度（通过 VEX/KEV）、SBOM 以及企业级支持。

这些变更旨在通过推广软件供应链完整性和最新部署的最佳实践，提升所有 Bitnami 用户的安全态势。更多详情请访问 [Bitnami Secure Images 公告](https://github.com/bitnami/containers/issues/83267)。


## 核心功能与特性

### 为什么选择 Bitnami 安全镜像？

- 安全镜像和 Helm 图表旨在提升开源软件的安全性和企业就绪性。
- 通过行业标准的漏洞可利用性交换（VEX）、KEV 和 EPSS 评分，更快地分类安全漏洞，提高 CVE 风险透明度。
- 强化镜像基于最小化操作系统（Photon Linux），减少攻击面，同时通过行业标准包格式保持可扩展性。
- 持续构建的镜像在上游补丁发布后数小时内更新，确保安全性和合规性。
- Bitnami 容器、虚拟机和云镜像使用相同的组件和配置方法，便于根据项目需求在不同格式间切换。
- 强化镜像附带证明签名（Notation）、SBOM、病毒扫描报告和其他元数据，通过 SLSA-3 合规软件工厂生成。

仅有部分 BSI 应用可免费使用。如需访问完整应用目录及企业支持，请尝试 [Bitnami Secure Images 商业版](https://www.arrow.com/globalecs/uk/products/bitnami-secure-images/)。


## 使用场景

- **开发环境**：快速部署 Kibana 用于 Elasticsearch 数据可视化与分析测试。
- **集成场景**：作为 Elastic Stack（ELK）的前端组件，与 Elasticsearch 集群配合实现日志分析、监控告警。
- **安全测试**：基于强化镜像验证应用在最小攻击面环境下的兼容性。


## 使用方法

### 快速启动（TL;DR）

#### Docker 快速运行

```console
docker run --name kibana bitnami/kibana:latest
```


### 手动运行应用

如需手动运行而非使用 Helm Chart，步骤如下：

1. 创建应用与数据库的专用网络：

   ```console
   docker network create kibana_network
   ```

2. 启动 Elasticsearch 容器：

   ```console
   docker run -d -p 9200:9200 --name elasticsearch --net=kibana_network bitnami/elasticsearch
   ```

3. 启动 Kibana 容器：

   ```console
   docker run -d -p 5601:5601 --name kibana --net=kibana_network \
     -e KIBANA_ELASTICSEARCH_URL=elasticsearch \
     bitnami/kibana
   ```

应用将通过 `http://你的 IP:5601/` 访问。


### 数据持久化

删除容器会导致所有数据和配置丢失。为避免此问题，需挂载持久化卷：

- Kibana 数据持久化路径：`/bitnami`
- 同时需为 [Elasticsearch 数据持久化](https://github.com/bitnami/containers/blob/main/bitnami/elasticsearch#persisting-your-application) 挂载卷

#### 挂载主机目录作为数据卷

```console
docker run -v /本地路径/kibana-persistence:/bitnami/kibana bitnami/kibana:latest
```

> **注意**：由于是非 root 容器，挂载的文件和目录需确保 UID `1001` 具有读写权限。


### 与其他容器连接

通过 [Docker 容器网络](https://docs.docker.com/engine/userguide/networking/)，Kibana 容器可与其他应用容器通信，同一网络内的容器可通过容器名作为主机名相互访问。

#### 步骤

1. 创建网络：

   ```console
   docker network create app-tier --driver bridge
   ```

2. 启动 Kibana 服务实例：

   ```console
   docker run -d --name kibana-server \
     --network app-tier \
     bitnami/kibana:latest
   ```

3. 启动应用容器：

   ```console
   docker run -d --name myapp \
     --network app-tier \
     你的应用镜像
   ```

> **重要**：
> 1. 将上述命令中的 `你的应用镜像` 替换为实际应用镜像。
> 2. 应用容器中使用主机名 `kibana-server` 连接 Kibana 服务。


## 配置说明

### 环境变量

#### 可自定义环境变量

| 名称                                  | 描述                                                                 | 默认值                                                         |
|---------------------------------------|----------------------------------------------------------------------|---------------------------------------------------------------|
| `KIBANA_ELASTICSEARCH_URL`            | Elasticsearch URL（集群环境下提供客户端节点 URL）                    | `elasticsearch`                                               |
| `KIBANA_ELASTICSEARCH_PORT_NUMBER`    | Elasticsearch 端口                                                  | `9200`                                                        |
| `KIBANA_HOST`                         | Kibana 监听主机                                                     | `0.0.0.0`                                                     |
| `KIBANA_PORT_NUMBER`                  | Kibana 监听端口                                                     | `5601`                                                        |
| `KIBANA_WAIT_READY_MAX_RETRIES`       | 等待 Kibana 就绪的最大重试次数                                      | `30`                                                          |
| `KIBANA_INITSCRIPTS_START_SERVER`     | 是否在执行初始化脚本前启动 Kibana 服务                              | `yes`                                                         |
| `KIBANA_FORCE_INITSCRIPTS`            | 是否强制执行初始化脚本                                              | `no`                                                          |
| `KIBANA_DISABLE_STRICT_CSP`           | 是否禁用严格的内容安全策略（CSP）                                    | `no`                                                          |
| `KIBANA_CERTS_DIR`                    | 证书目录路径                                                        | `${SERVER_CONF_DIR}/certs`                                    |
| `KIBANA_SERVER_ENABLE_TLS`            | 是否为入站连接启用 HTTPS TLS                                        | `false`                                                       |
| `KIBANA_SERVER_KEYSTORE_LOCATION`     | 密钥库路径                                                          | `${SERVER_CERTS_DIR}/server/kibana.keystore.p12`              |
| `KIBANA_SERVER_KEYSTORE_PASSWORD`     | 包含证书或受密码保护的 PEM 密钥的 Elasticsearch 密钥库密码           | `nil`                                                         |
| `KIBANA_SERVER_TLS_USE_PEM`           | 是否使用 PEM 证书配置 Kibana 服务端 TLS                             | `false`                                                       |
| `KIBANA_SERVER_CERT_LOCATION`         | PEM 节点证书路径                                                    | `${SERVER_CERTS_DIR}/server/tls.crt`                          |
| `KIBANA_SERVER_KEY_LOCATION`          | PEM 节点密钥路径                                                    | `${SERVER_CERTS_DIR}/server/tls.key`                          |
| `KIBANA_SERVER_KEY_PASSWORD`          | Elasticsearch 节点 PEM 密钥密码                                     | `nil`                                                         |
| `KIBANA_PASSWORD`                     | Kibana 密码                                                         | `nil`                                                         |
| `KIBANA_ELASTICSEARCH_ENABLE_TLS`     | 是否为 Elasticsearch 通信启用 TLS                                   | `false`                                                       |
| `KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE` | Elasticsearch TLS 验证模式                                 | `full`                                                        |
| `KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION` | Elasticsearch 信任库路径                                      | `${SERVER_CERTS_DIR}/elasticsearch/elasticsearch.truststore.p12` |
| `KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD` | Elasticsearch 信任库密码                                    | `nil`                                                         |
| `KIBANA_ELASTICSEARCH_TLS_USE_PEM`    | 是否使用 PEM 证书配置 Elasticsearch TLS                             | `false`                                                       |
| `KIBANA_ELASTICSEARCH_CA_CERT_LOCATION` | Elasticsearch CA 证书路径                                        | `${SERVER_CERTS_DIR}/elasticsearch/ca.crt`                    |
| `KIBANA_CREATE_USER`                  | 是否自动创建 `kibana_system` 用户（若不存在）                       | `false`                                                       |
| `KIBANA_ELASTICSEARCH_PASSWORD`       | Elasticsearch 超级用户密码（`KIBANA_CREATE_USER` 启用时必填）        | `nil`                                                         |
| `KIBANA_SERVER_PUBLICBASEURL`         | 终端用户访问 Kibana 的公共 URL                                      | `nil`                                                         |
| `KIBANA_XPACK_SECURITY_ENCRYPTIONKEY` | 会话加密密钥（避免会话失效）                                        | `nil`                                                         |
| `KIBANA_XPACK_REPORTING_ENCRYPTIONKEY` | 报表功能静态加密密钥                                               | `nil`                                                         |
| `KIBANA_NEWSFEED_ENABLED`             | 是否启用 Kibana UI 通知中心的新闻推送系统                           | `true`                                                        |
| `KIBANA_ELASTICSEARCH_REQUESTTIMEOUT` | 后端或 Elasticsearch 响应超时时间（毫秒）                           | `30000`                                                       |

#### 只读环境变量

| 名称                              | 描述                                                     | 值                                      |
|-----------------------------------|----------------------------------------------------------|----------------------------------------|
| `SERVER_FLAVOR`                   | 服务类型（有效值：`kibana` 或 `opensearch-dashboards`）   | `kibana`                               |
| `BITNAMI_VOLUME_DIR`              | 卷挂载根目录                                             | `/bitnami`                              |
| `KIBANA_VOLUME_DIR`               | Kibana 持久化目录                                        | `${BITNAMI_VOLUME_DIR}/kibana`          |
| `KIBANA_BASE_DIR`                 | Kibana 安装目录                                          | `${BITNAMI_ROOT_DIR}/kibana`            |
| `KIBANA_CONF_DIR`                 | Kibana 配置目录                                          | `${SERVER_BASE_DIR}/config`             |
| `KIBANA_DEFAULT_CONF_DIR`         | Kibana 默认配置目录                                      | `${SERVER_BASE_DIR}/config.default`     |
| `KIBANA_LOGS_DIR`                 | Kibana 日志目录                                          | `${SERVER_BASE_DIR}/logs`               |
| `KIBANA_TMP_DIR`                  | Kibana 临时目录                                          | `${SERVER_BASE_DIR}/tmp`                |
| `KIBANA_BIN_DIR`                  | Kibana 可执行文件目录                                    | `${SERVER_BASE_DIR}/bin`                |
| `KIBANA_PLUGINS_DIR`              | Kibana 插件目录                                          | `${SERVER_BASE_DIR}/plugins`            |
| `KIBANA_DEFAULT_PLUGINS_DIR`      | Kibana 默认插件目录                                      | `${SERVER_BASE_DIR}/plugins.default`    |
| `KIBANA_DATA_DIR`                 | Kibana 数据目录                                          | `${SERVER_VOLUME_DIR}/data`             |
| `KIBANA_MOUNTED_CONF_DIR`         | 自定义配置文件目录（覆盖默认配置）                        | `${SERVER_VOLUME_DIR}/conf`             |
| `KIBANA_CONF_FILE`                | Kibana 配置文件路径                                      | `${SERVER_CONF_DIR}/kibana.yml`         |
| `KIBANA_LOG_FILE`                 | Kibana 日志文件路径                                      | `${SERVER_LOGS_DIR}/kibana.log`         |
| `KIBANA_PID_FILE`                 | Kibana PID 文件路径                                      | `${SERVER_TMP_DIR}/kibana.pid`          |
| `KIBANA_INITSCRIPTS_DIR`          | 容器初始化脚本目录                                       | `/docker-entrypoint-initdb.d`           |
| `KIBANA_DAEMON_USER`              | Kibana 系统用户                                          | `kibana`                                |
| `KIBANA_DAEMON_GROUP`             | Kibana 系统用户组                                        | `kibana`                                |

#### 命令行指定环境变量示例

```console
docker run -d -e KIBANA_ELASTICSEARCH_URL=elasticsearch --name kibana bitnami/kibana:latest
```


### 初始化脚本

容器首次启动时，会执行 `/docker-entrypoint-initdb.d` 目录下所有 `.sh` 扩展名的文件。可通过挂载卷将自定义脚本放入此目录：

```console
docker run -v /本地脚本目录:/docker-entrypoint-initdb.d bitnami/kibana:latest
```


### 配置文件

镜像从 `/bitnami/kibana/conf/` 读取配置。如需自定义配置：

1. 启动容器并挂载持久化卷：

   ```console
   docker run --name kibana -v /本地路径/kibana-persistence:/bitnami bitnami/kibana:latest
   ```

2. 在本地编辑配置文件：

   ```console
   vi /本地路径/kibana-persistence/kibana/conf/kibana.yml
   ```

3. 重启容器使配置生效：

   ```console
   docker restart kibana
   ```

完整配置选项请参考 [Kibana 官方文档](https://www.elastic.co/guide/en/kibana/current/settings.html)。


### FIPS 配置（Bitnami Secure Images）

Bitnami Secure Images 提供 FIPS 能力配置，支持以下环境变量：

- `OPENSSL_FIPS`：是否启用 OpenSSL FIPS 模式，可选值 `yes`（默认）或 `no`。


## 日志管理

容器日志输出至 `stdout`，可通过以下命令查看：

```console
docker logs kibana
```

可通过 `--log-driver` 选项配置 [日志驱动](https://docs.docker.com/engine/admin/logging/overview/) 以自定义日志处理方式（默认使用 `json-file` 驱动）。


## 维护与升级

### 升级镜像

Bitnami 会及时提供包含安全补丁的 Kibana 更新版本，建议按以下步骤升级：

1. 拉取最新镜像：

   ```console
   docker pull bitnami/kibana:latest
   ```

2. 停止并备份当前容器：

   ```console
   docker stop kibana
   rsync -a /本地路径/kibana-persistence /本地路径/kibana-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
   ```

   同时需 [备份 Elasticsearch 数据](https://github.com/bitnami/containers/blob/main/bitnami/elasticsearch#step-2-stop-and-backup-the-currently-running-container)。

3. 删除旧容器：

   ```console
   docker rm -v kibana
   ```

4. 启动新镜像：

   ```console
   docker run --name kibana bitnami/kibana:latest
   ```


## 版本变更记录

### 2024 年 1 月 16 日起
- 移除 `docker-compose.yaml` 文件（该文件仅用于内部测试）。

### 版本 6.8.15-debian-10-r12、7.10.2-debian-10-r62、7.12.0-debian-10-r0
- 减小容器镜像体积。
- 配置逻辑基于 `rootfs/` 目录下的 Bash 脚本实现。
- Kibana 7.12.0 及以上版本采用 Elastic License，目前未被开源倡议组织（OSI）认可为开源许可证。
- Kibana 7.12.0 及以上版本默认包含 x-pack 插件，使用方法请参考官方文档。

### 版本 6.5.1-r3、5.6.13-r20
- 迁移至非 root 用户模式（容器和 Kibana 进程均以 UID 1001 运行），数据目录需确保该用户有写权限。可通过修改 Dockerfile 中 `USER 1001` 为 `USER root` 恢复 root 模式。

### 版本 4.5.4-r1
- 环境变量 `ELASTICSEARCH_URL` 重命名为 `KIBANA_ELASTICSEARCH_URL`。
- 环境变量 `ELASTICSEARCH_PORT`
