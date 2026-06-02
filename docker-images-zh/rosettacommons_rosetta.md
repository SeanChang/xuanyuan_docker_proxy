---
image: rosettacommons/rosetta
description: "RosettaCommons官方维护的Rosetta/PyRosetta镜像，提供多种构建版本满足不同计算需求，学术和非商业用户可免费使用，商业用途需单独获取许可。"
source: https://xuanyuan.cloud/zh/r/rosettacommons/rosetta
canonical: https://xuanyuan.cloud/zh/r/rosettacommons/rosetta
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [rosettacommons/rosetta — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/rosettacommons/rosetta)

含镜像标签、拉取命令、部署文档与相关推荐。

[rosettacommons/rosetta Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/rosettacommons/rosetta)

## Rosetta/PyRosetta 官方镜像

### 镜像概述
本镜像由RosettaCommons（[rosettacommons.org](https://rosettacommons.org/)）官方维护，包含Rosetta和PyRosetta的构建版本，适用于蛋白质结构预测、设计及相关生物信息学研究。

### 许可证信息
- 学术和非商业用户可依据[Rosetta软件非商业许可协议](https://github.com/RosettaCommons/rosetta/blob/main/LICENSE.md)和[PyRosetta软件非商业许可协议](https://github.com/RosettaCommons/rosetta/blob/main/LICENSE.PyRosetta.md)使用本页面所有镜像。
- **商业用途需购买单独许可**（包括学术用户的有偿服务）。更多信息请参见：  
  https://els2.comotion.uw.edu/product/rosetta  
  https://els2.comotion.uw.edu/product/pyrosetta  
  或发送邮件至license@uw.edu咨询。

### 技术信息
#### 镜像标签说明
- **`serial`**：包含Rosetta和PyRosetta构建，均启用`cxx11thread`和`serialization`扩展。
- **`mpi`**：包含Rosetta和PyRosetta构建，均启用`cxx11thread`和`serialization`扩展；Rosetta以MPI模式构建。
- **`jupyter`**：基于`jupyter/scipy-notebook`，预装PyRosetta。运行本地Jupyter服务器命令：  
  ```bash
  docker run -it -p 8888:8888 rosettacommons/rosetta:jupyter
  ```
- **`ml`**（实验性）：包含Rosetta和PyRosetta构建，启用`libtorch`和`tensorflow`集成。  
  - Rosetta：启用`mpi`、`cxx11thread`、`serialization`、`torch`、`tensorflow`扩展。  
  - PyRosetta：启用`cxx11thread`、`serialization`、`torch`、`tensorflow`扩展。
- **`<TAG>-NNN`**：对应每周NNN版本的镜像。
