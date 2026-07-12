---
image: oceanbase/miniob
description: "miniob是OceanBase与华中科技大学联合开发的数据库内核入门教程实践工具，面向零基础同学，帮助快速了解数据库内核模块功能及关联，适用于学生学习，简化了并发等模块，仅供学习使用。"
source: https://xuanyuan.cloud/zh/r/oceanbase/miniob
canonical: https://xuanyuan.cloud/zh/r/oceanbase/miniob
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oceanbase/miniob" title="oceanbase/miniob Docker 镜像中文简介、标签列表与拉取命令">oceanbase/miniob 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# miniob Docker镜像文档

## 镜像概述和主要用途
miniob是由OceanBase与华中科技大学联合开发的数据库内核入门教程实践工具。其设计目标是帮助不熟悉数据库设计和实现的零基础同学快速了解与深入学习数据库内核，通过相关训练理解各内核模块的功能及关联，进而在使用数据库时设计高效SQL。该工具主要面向在校学生，对诸多模块（如并发操作）进行了简化，且明确仅供学习使用，不考虑安全特性。

[GitHub 首页](https://github.com/oceanbase/miniob)

## 核心功能和特性
- **面向零基础学习者**：降低数据库内核学习门槛，适合无数据库设计与实现基础的同学入门
- **模块简化设计**：简化复杂功能模块，如不考虑并发操作，聚焦核心原理教学
- **学习导向**：帮助理解数据库内核模块功能及模块间关联，培养高效SQL设计能力
- **开发环境集成**：内置多种开发依赖组件，便于快速开展实践（详见“Docker环境说明”）
- **明确使用限制**：仅用于学习目的，不包含安全特性

## 使用场景和适用范围
- **适用人群**：主要面向在校学生，尤其是数据库相关课程的学习者
- **应用场景**：数据库内核基础知识学习、数据库实现原理入门实践、数据库内核模块功能理解与关联分析训练

## 使用方法和配置说明

### 前提条件
使用前需确保本地已安装Docker环境。

### 快速启动容器
通过Docker Hub镜像直接运行：
```bash
docker run -d --privileged --name=miniob docker.xuanyuan.run/oceanbase/miniob
```
该命令将创建并启动名为`miniob`的容器。

### 进入容器
容器启动后，执行以下命令进入容器并创建bash终端：
```bash
docker exec -it miniob bash
```
进入容器后，即可通过Linux终端进行数据库内核开发实践工作。

### Docker环境说明
- **基础镜像版本**：基于`anolisos:8.6`制作；v1.1版本镜像基于ubuntu 22.04制作
- **镜像包含组件**：
  - jsoncpp
  - google test
  - libevent
  - flex
  - bison(3.7)
  - gcc/g++
  - miniob 源码（注意：v1.1版本后，需自行下载源码）
