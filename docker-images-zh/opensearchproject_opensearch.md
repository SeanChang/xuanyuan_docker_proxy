---
image: opensearchproject/opensearch
description: "OpenSearch官方Docker镜像，提供可扩展、灵活的开源搜索、分析和可观测性套件，包含OpenSearch搜索引擎和OpenSearch Dashboards管理可视化界面。"
source: https://xuanyuan.cloud/zh/r/opensearchproject/opensearch
canonical: https://xuanyuan.cloud/zh/r/opensearchproject/opensearch
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opensearchproject/opensearch" title="opensearchproject/opensearch Docker 镜像中文简介、标签列表与拉取命令">opensearchproject/opensearch — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/opensearchproject/opensearch" title="opensearchproject/opensearch Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/opensearchproject/opensearch</a>

# OpenSearch Docker镜像文档

## 镜像概述和主要用途

OpenSearch是一个可扩展、灵活且可扩展的开源软件套件，用于搜索、分析和可观测性应用，衍生自Elasticsearch 7.10.2和Kibana 7.10.2，采用Apache 2.0许可。该Docker镜像包含OpenSearch搜索引擎守护进程和OpenSearch Dashboards数据管理与可视化用户界面，便于快速部署和使用。

## 核心功能和特性

- **开源免费**：基于Apache 2.0许可，完全开源，无商业许可限制
- **全面功能**：集成搜索、分析和可观测性功能，满足多种数据处理需求
- **可扩展性**：支持单节点部署用于开发，也可扩展为集群用于生产环境
- **兼容性**：衍生自Elasticsearch和Kibana，保持良好的兼容性和迁移便利性

## 使用场景和适用范围

- **本地开发**：快速搭建单节点环境进行应用开发和测试
- **数据分析**：利用搜索和分析功能处理日志、指标等数据
- **可观测性**：通过可视化界面监控系统运行状态
- **学习研究**：作为开源搜索技术的学习和研究平台

## 详细使用方法和配置说明

### 拉取镜像

使用以下命令拉取最新版本的OpenSearch镜像：

```bash
docker pull opensearchproject/opensearch:latest
```

所有可用版本可在[Docker Hub](https://hub.docker.com/r/opensearchproject/opensearch/tags)查看。

**注意**：OpenSearch镜像在1.x版本和2.x版本（直至2.9.0）使用[Amazon Linux 2](https://aws.amazon.com/amazon-linux-2/)作为基础镜像，自2.10.0起使用[Amazon Linux 2023](https://aws.amazon.com/linux/amazon-linux-2023/)。若使用[Docker Desktop](https://www.docker.com/products/docker-desktop/)，建议配置至少4GB系统内存。

### 单节点运行（本地开发）

#### OpenSearch 2.12之前版本

```bash
docker run -it -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" --name opensearch-node -d opensearchproject/opensearch:latest
```

#### OpenSearch 2.12及之后版本

需要为admin用户设置自定义密码：

```bash
docker run -it -p 9200:9200 -p 9600:9600 -e OPENSEARCH_INITIAL_ADMIN_PASSWORD=<strong-password> -e "discovery.type=single-node" --name opensearch-node opensearchproject/opensearch:latest
```

### 验证部署

通过OpenSearch REST API验证服务是否正常运行。默认使用自签名TLS证书，`-k`选项用于跳过证书验证。**默认用户名均为`admin`**：
- OpenSearch 2.12及之前版本：默认密码为`admin`
- OpenSearch 2.12及之后版本：密码为部署时通过`OPENSEARCH_INITIAL_ADMIN_PASSWORD`指定的自定义值

```bash
curl -X GET "https://localhost:9200" -ku admin:<password>
curl -X GET "https://localhost:9200/_cat/nodes?v" -ku admin:<password>
curl -X GET "https://localhost:9200/_cat/plugins?v" -ku admin:<password>
```

### 容器管理

可通过容器ID或名称停止、启动和重启容器：

```bash
# 停止容器
docker stop opensearch-node

# 启动容器
docker start opensearch-node

# 重启容器
docker restart opensearch-node
```

### 启动集群

使用[Docker Compose](https://docs.docker.com/compose/)搭建OpenSearch集群。若使用[Docker Desktop](https://www.docker.com/products/docker-desktop/)，Docker Compose已预装，可直接使用`docker compose`命令；否则需手动安装。

#### 安装Docker Compose（若未安装）

若环境已安装Python，可使用pip安装：

```bash
pip install docker-compose
```

#### 定义集群配置

OpenSearch项目提供示例[docker-compose.yml](https://github.com/opensearch-project/opensearch-build/tree/main/docker/release/dockercomposefiles)。创建该文件后，使用Docker Compose管理集群。

#### 启动集群

进入`docker-compose.yml`所在目录，后台启动集群：

```bash
docker-compose up -d
```

#### 停止集群

```bash
docker-compose down
```

若需同时删除关联数据卷：

```bash
docker-compose down -v
```

## 许可信息

OpenSearch及其包含的插件采用[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)许可。

## 支持与反馈

- **维护者**：[OpenSearch团队](https://github.com/opensearch-project)
- **社区论坛**：在[社区论坛](https://forum.opensearch.org/)提问和讨论
- **问题跟踪**：通过[issue tracker](https://github.com/opensearch-project/opensearch-build/issues)报告构建或Docker镜像问题
