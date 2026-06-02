---
image: ascendai/cann
description: "ascendai/cann Docker镜像是昇腾AI异构计算架构CANN的容器化部署方案，集成CANN核心组件与工具链，深度适配昇腾系列AI芯片，提供从模型训练到推理部署的全流程加速能力。通过容器化封装简化昇腾AI开发环境配置，确保跨平台部署一致性，助力开发者快速构建高效能深度学习应用，显著提升模型训练效率与推理性能，广泛适用于科研实验、智能计算及产业级AI解决方案开发场景。"
source: https://xuanyuan.cloud/zh/r/ascendai/cann
canonical: https://xuanyuan.cloud/zh/r/ascendai/cann
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ascendai/cann" title="ascendai/cann Docker 镜像中文简介、标签列表与拉取命令">ascendai/cann — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/ascendai/cann" title="ascendai/cann Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ascendai/cann</a>

# Ascend CANN Docker镜像使用说明


## 概述
- 官方Ascend CANN Docker镜像  
- 获取帮助：[Ascend社区]([])  


## CANN简介
CANN（Compute Architecture for Neural Networks）是华为昇腾推出的面向AI场景的异构计算架构，支持多类AI框架，服务于AI处理器及编程。它承担上下层连接的关键角色，是提升昇腾AI处理器计算效率的核心平台；同时为多样化应用场景提供高效易用的编程接口，帮助用户基于昇腾平台快速构建AI应用及业务。  

Ascend-CANN镜像基于Ubuntu或openEuler操作系统构建，集成了系统基础包、Python环境及CANN组件（含Toolkit开发套件、Kernels算子包、NNAL加速库）。用户可基于此基础镜像，根据实际需求安装人工智能框架，运行相应业务程序。  


## 支持的标签与Dockerfile链接
已发布的镜像标签及对应Dockerfile可在以下仓库的cann目录中查看：  
[]  


## 使用指南

### 支持的设备
- Atlas A2训练系列：Atlas 800T A2、Atlas 900 A2 PoD、Atlas 200T A2 Box16、Atlas 300T A2  
- Atlas 800I A2推理系列：Atlas 800I A2  


### 容器环境配置步骤
以下为基于容器搭建环境的示例命令（假设NPU设备挂载路径为`/dev/davinci1`，NPU驱动安装路径为`/usr/local/Ascend`）：  

```bash
docker run \
    --name cann_container \
    --device /dev/davinci1 \
    --device /dev/davinci_manager \
    --device /dev/devmm_svm \
    --device /dev/hisi_hdc \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
    -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
    -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
    -v /etc/ascend_install.info:/etc/ascend_install.info \
    -it ascend/cann:tag bash
```

**说明**：将命令中的`tag`替换为实际使用的镜像标签（如具体版本号）。  


### 注意事项
执行CANN环境变量脚本`/usr/local/Ascend/nnal/atb/set_env.sh`时，需配置`abi`参数，具体方式如下：  

- **自动配置**：执行`set_env.sh`时若未添加参数，且已检测到PyTorch环境，脚本会自动调用`torch.compiled_with_cxx11_abi()`接口，根据PyTorch编译时的ABI参数自动选择ATB的`abi`值；若未检测到PyTorch环境，默认配置`abi=1`。  

- **手动配置**：执行`set_env.sh`时，可通过`--cxx_abi=1`或`--cxx_abi=0`参数手动指定ATB的`abi`值。  

> **说明**：在CANN 8.1.RC1及之后版本的镜像中，已通过ENV定义`abi=0`，并将`source /usr/local/Ascend/nnal/atb/set_env.sh`写入bashrc及ENTRYPOINT，确保容器启动时`abi`参数正确设置。用户也可在容器内手动指定该参数值。  


## 问题反馈
若未找到所需的CANN镜像，或使用中遇到问题，可通过[提交issue]([])反馈。  


## 许可证
本镜像基于[Apache License, Version 2.0]([])许可。  

与所有Docker镜像相同，本镜像可能包含其他受不同许可证约束的软件（如基础发行版中的Bash，以及所包含主软件的直接或间接依赖）。  

对于预构建镜像的任何使用，镜像用户需自行确保其使用行为符合镜像中所有包含软件的相关许可证要求。
