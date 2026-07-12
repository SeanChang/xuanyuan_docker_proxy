---
image: rancher/vm-ubuntu
description: "该Docker镜像提供一个大小为50G的虚拟机环境，适用于需要特定存储空间的应用部署场景。"
source: https://xuanyuan.cloud/zh/r/rancher/vm-ubuntu
canonical: https://xuanyuan.cloud/zh/r/rancher/vm-ubuntu
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rancher/vm-ubuntu" title="rancher/vm-ubuntu Docker 镜像中文简介、标签列表与拉取命令">rancher/vm-ubuntu 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
本Docker镜像提供一个预配置的虚拟机环境，其存储空间大小为50G，旨在满足需要特定存储容量的应用部署需求。

# 核心功能与特性
- 固定存储空间：提供50G的存储空间，满足中等规模存储需求
- 简化部署：无需额外配置即可获得指定大小的存储环境

# 使用场景
适用于需要特定存储空间的应用部署，如数据处理、文件存储服务、中等规模数据库应用等场景。

# 使用方法
## 基本运行命令
使用以下命令启动容器：
```bash
docker run -d --name vm-50g-instance [镜像名称]
```
> 注：[镜像名称]需替换为实际的Docker镜像名称。

## 存储说明
容器默认提供50G存储空间，无需额外挂载存储卷即可使用。
