---
image: biobakery/workflows
description: "基于Ubuntu 18.04的生物信息学分析镜像，预装bioBakery工作流，支持微生物组等生物数据的标准化分析处理。"
source: https://xuanyuan.cloud/zh/r/biobakery/workflows
canonical: https://xuanyuan.cloud/zh/r/biobakery/workflows
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/biobakery/workflows" title="biobakery/workflows Docker 镜像中文简介、标签列表与拉取命令">biobakery/workflows 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# biobakery/workflows镜像说明

## 镜像概述
本镜像基于Ubuntu 18.04（Bionic Beaver）系统构建，预装了[bioBakery工作流](http://huttenhower.sph.harvard.edu/biobakery_workflows)，是生物信息学领域用于微生物组数据（如宏基因组、代谢组）分析的标准化工具集。

## 核心功能
- 整合多种生物信息学分析工具，提供端到端的微生物组数据处理流程；
- 支持数据质控、物种注释、功能富集等关键分析步骤；
- 兼容常见生物数据格式，简化科研人员的分析流程。

## 使用场景
- 科研机构开展微生物组相关研究；
- 生物实验室进行生物数据的标准化分析；
- 生物信息学教学中的工具链演示与实践。

## 配置说明
- 可通过挂载本地数据卷（如`-v /本地路径:/容器路径`）实现数据输入输出；
- 根据分析需求调整容器资源限制（如`--cpus`、`--memory`参数）。

## 部署示例
### 基础运行
```bash
docker run -it --rm docker.xuanyuan.run/biobakery/workflows
```

### 挂载数据卷运行
```bash
docker run -it --rm -v /your/local/data:/data docker.xuanyuan.run/biobakery/workflows
```

更多详细信息请参考[bioBakery官方文档](http://huttenhower.sph.harvard.edu/biobakery)。
