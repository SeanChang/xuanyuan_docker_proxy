---
image: openeuler/milvus
description: "官方Milvus Docker镜像，基于openEuler构建，是高性能向量数据库，专为大规模非结构化数据（文本、图像等）的高效组织与搜索设计，支持AI应用开发，免费使用且无用户速率限制。"
source: https://xuanyuan.cloud/zh/r/openeuler/milvus
canonical: https://xuanyuan.cloud/zh/r/openeuler/milvus
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/milvus" title="openeuler/milvus Docker 镜像中文简介、标签列表与拉取命令">openeuler/milvus — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/openeuler/milvus" title="openeuler/milvus Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/milvus</a>

# Milvus | openEuler Docker镜像文档

## 镜像概述

本镜像为官方Milvus Docker镜像，基于[openEuler](https://repo.openeuler.org/)构建，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。Milvus是一款高性能向量数据库，专为大规模数据场景设计，能够高效组织和搜索文本、图像、多模态等非结构化数据，为AI应用提供数据支持。

**获取帮助**：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler社区](https://gitee.com/openeuler/community)

## 核心功能与特性

- **高性能**：针对向量数据检索优化，支持毫秒级查询响应
- **可扩展性**：支持大规模数据存储与查询，适应业务增长需求
- **多模态支持**：高效处理文本、图像、音频等多种非结构化数据
- **openEuler基础**：基于openEuler系统构建，稳定性与安全性有保障
- **无速率限制**：免费使用，无用户级速率限制

## 支持的标签及对应Dockerfile链接

每个Milvus镜像标签由Milvus版本和基础镜像版本组成，具体信息如下：

| 标签 | 当前版本信息 | 支持架构 |
|------|--------------|----------|
| [2.5.14-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/milvus/2.5.14/24.03-lts-sp2/Dockerfile) | Milvus 2.5.14 基于 openEuler 24.03-LTS-SP2 | amd64, arm64 |
| [2.6.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/milvus/2.6.0/24.03-lts-sp2/Dockerfile) | Milvus 2.6.0 基于 openEuler 24.03-LTS-SP2 | amd64, arm64 |

## 使用场景

- AI应用开发：为图像识别、自然语言处理、推荐系统等AI场景提供向量数据存储与检索
- 非结构化数据管理：高效管理和查询海量文本、图像、音视频等非结构化数据
- 大规模数据检索：支持亿级向量数据的快速相似性搜索

## 使用方法

### 步骤1：启动Milvus实例

```bash
docker run --name euler-milvus -it openeuler/milvus:latest
```

### 步骤2：启动etcd

```bash
etcd --data-dir=/data/milvus/data/etcd-data/ &
```

etcd启动成功的标志信息：
```
{"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d received MsgPreVoteResp from 8e9e05c52164694d at term 1"}
{"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became candidate at term 2"}
{"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d received MsgVoteResp from 8e9e05c52164694d at term 2"}
{"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became leader at term 2"}
{"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"raft.node: 8e9e05c52164694d elected leader 8e9e05c52164694d at term 2"}
{"level":"info","ts":"2025-07-07T03:01:42.568Z","caller":"etcdserver/server.go:2476","msg":"setting up initial cluster version using v2 API","cluster-version":"3.5"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"membership/cluster.go:531","msg":"set initial cluster version","cluster-id":"cdf818194e3a8c32","local-member-id":"8e9e05c52164694d","cluster-version":"3.5"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"api/capability.go:75","msg":"enabled capabilities for version","cluster-version":"3.5"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdserver/server.go:2500","msg":"cluster version is updated","cluster-version":"3.5"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdserver/server.go:2027","msg":"published local member to cluster through raft","local-member-id":"8e9e05c52164694d","local-member-attributes":"{Name:default ClientURLs:[http://localhost:2379]}","request-path":"/0/members/8e9e05c52164694d/attributes","cluster-id":"cdf818194e3a8c32","publish-timeout":"7s"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"embed/serve.go:98","msg":"ready to serve client requests"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdmain/main.go:47","msg":"notifying init daemon"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdmain/main.go:53","msg":"successfully notified init daemon"}
{"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"embed/serve.go:140","msg":"serving client traffic insecurely; this is strongly discouraged!","address":"127.0.0.1:2379"}
```

### 步骤3：启动MinIO

```bash
minio server /data/milvus/data/minio-data/ &
```

MinIO启动成功的标志信息：
```
Copyright: 2015-2025 MinIO, Inc.
License: GNU AGPLv3 - https://www.gnu.org/licenses/agpl-3.0.html
Version: RELEASE.2025-06-13T11-33-47Z (go1.24.4 linux/amd64)

API: http://172.17.0.4:9000  http://127.0.0.1:9000
RootUser: minioadmin
RootPass: minioadmin

WebUI: http://172.17.0.4:41483 http://127.0.0.1:41483
RootUser: minioadmin
RootPass: minioadmin

CLI: https://min.io/docs/minio/linux/reference/minio-mc.html#quickstart
$ mc alias set 'myminio' 'http://172.17.0.4:9000' 'minioadmin' 'minioadmin'

Docs: https://docs.min.io
WARN: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables
```

### 步骤4：启动Milvus Standalone

```bash
milvus run standalone
```

Milvus启动成功的标志信息：
```
[2025/07/07 07:33:31.307 +00:00] [INFO] [distance/calc_distance_amd64.go:14] ["Hook avx for go simd distance computation"]
2025/07/07 07:33:31 maxprocs: Leaving GOMAXPROCS=16: CPU quota undefined

    __  _________ _   ____  ______
   /  |/  /  _/ /| | / / / / / __/
  / /|_/ // // /_| |/ / /_/ /\ \
 /_/  /_/___/____/___/\____/___/

Welcome to use Milvus!
Version:   2.5.14
Built:     Mon Jul  7 07:32:02 UTC 2025
GitCommit: 062fc368a5
GoVersion: go version go1.24.2 linux/amd64

TotalMem: 66068840448
UsedMem: 56733696
```

## 问答

如有任何问题或需要使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
