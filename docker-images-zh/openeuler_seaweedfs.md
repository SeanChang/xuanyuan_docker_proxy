---
image: openeuler/seaweedfs
description: "官方seaweedfs Docker镜像，基于openEuler构建，是快速分布式存储系统，支持blobs、objects、files和data lake，适用于数十亿文件存储，具有O(1)磁盘查找和云分层功能，由openEuler CloudNative SIG维护。"
source: https://xuanyuan.cloud/zh/r/openeuler/seaweedfs
canonical: https://xuanyuan.cloud/zh/r/openeuler/seaweedfs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/seaweedfs" title="openeuler/seaweedfs Docker 镜像中文简介、标签列表与拉取命令">openeuler/seaweedfs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述和主要用途
本镜像为官方seaweedfs Docker镜像，基于openEuler构建，由[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)维护。SeaweedFS是一个快速的分布式存储系统，适用于存储blobs、objects、files和data lake，可支持数十亿文件，具备Blob存储O(1)磁盘查找及云分层能力。该镜像可免费使用，无每用户速率限制。

# 核心功能和特性
- **分布式存储**：高效存储和管理数十亿文件
- **Blob存储优化**：实现O(1)磁盘查找，提升访问效率
- **云分层支持**：支持云存储分层，优化存储成本
- **多架构支持**：适配amd64和arm64架构
- **openEuler集成**：基于openEuler系统构建，确保兼容性和稳定性

# 支持的标签
每个`seaweedfs` Docker镜像标签由seaweedfs版本和基础镜像版本组成，具体如下：

| 标签                                                                                                                               | 当前版本                                 | 架构         |
|-----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|------------|
|[4.03-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/seaweedfs/24.03-lts-sp2/24.03-lts-sp2/Dockerfile) | seaweedfs 4.03 基于 openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[3.99-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/seaweedfs/3.99/24.03-lts-sp2/Dockerfile) | seaweedfs 3.99 基于 openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[3.97-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/seaweedfs/3.97/24.03-lts-sp1/Dockerfile) | seaweedfs 3.97 基于 openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [3.85-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/seaweedfs/3.85/24.03-lts-sp1/Dockerfile) | seaweedfs 3.85 基于 openEuler 24.03-LTS-SP1 | amd64, arm64  |

# 使用方法和配置说明
用户可根据需求选择对应的`{Tag}`使用。

## 拉取镜像
```bash
docker pull docker.xuanyuan.run/openeuler/seaweedfs:{Tag}
```

## 启动实例
```bash
docker run -it --rm docker.xuanyuan.run/openeuler/seaweedfs:{Tag}
```

> 说明：`openeuler/seaweedfs`镜像用于验证上游seaweedfs版本与openEuler的集成兼容性。

# 问答
如有任何问题或需使用特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
