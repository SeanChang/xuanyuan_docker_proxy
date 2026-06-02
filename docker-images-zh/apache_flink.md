---
image: apache/flink
description: "Apache Flink Docker镜像用于容器化部署Flink，可通过Docker Hub官方镜像获取（可能存在发布延迟或版本缺失），此处镜像由Flink PMC管理，完整使用文档参见官方指南。"
source: https://xuanyuan.cloud/zh/r/apache/flink
canonical: https://xuanyuan.cloud/zh/r/apache/flink
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/flink" title="apache/flink Docker 镜像中文简介、标签列表与拉取命令">apache/flink — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/flink" title="apache/flink Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/flink</a>

# Apache Flink Docker镜像

## 概述
Apache Flink Docker镜像的使用文档可参考：[官方文档](https://ci.apache.org/projects/flink/flink-docs-master/deployment/resource-providers/standalone/docker.html)

## 官方镜像说明
Apache Flink Docker镜像通过Docker Hub以[官方镜像](https://hub.docker.com/_/flink)形式分发。官方镜像由Docker审核并构建，但可能因未通过Docker审核而存在发布延迟或版本缺失的情况。

## 镜像管理
此处提供的镜像由Flink PMC（项目管理委员会）负责管理。

## Docker部署方案示例
### 拉取镜像
```bash
docker pull flink:latest
```

### 启动JobManager
```bash
docker run --name flink-jobmanager -d -p 8081:8081 flink:latest jobmanager
```

### 启动TaskManager（连接到JobManager）
```bash
docker run --name flink-taskmanager -d --link flink-jobmanager:jobmanager flink:latest taskmanager
```

### 提交作业示例
```bash
docker exec -it flink-jobmanager ./bin/flink run ./examples/streaming/WordCount.jar
```
