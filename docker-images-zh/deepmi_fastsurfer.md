---
image: deepmi/fastsurfer
description: "FastSurfer是一款快速准确的深度学习管道，用于人类大脑MRI分析，提供与FreeSurfer兼容的体积和基于表面的厚度分析，支持亚毫米分辨率及小脑、下丘脑等神经解剖结构的细分。"
source: https://xuanyuan.cloud/zh/r/deepmi/fastsurfer
canonical: https://xuanyuan.cloud/zh/r/deepmi/fastsurfer
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/deepmi/fastsurfer" title="deepmi/fastsurfer Docker 镜像中文简介、标签列表与拉取命令">deepmi/fastsurfer — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/deepmi/fastsurfer" title="deepmi/fastsurfer Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/deepmi/fastsurfer</a>

# FastSurfer

## 镜像概述和主要用途
FastSurfer是一个快速准确的深度学习管道，用于人类大脑MRI分析。它提供与FreeSurfer完全兼容的体积和基于表面的厚度分析，支持亚毫米分辨率，并能对小脑、下丘脑等神经解剖结构进行细分。本Docker镜像封装了FastSurfer，提供GPU（含CUDA支持）、CPU及AMD GPU（ROCM，实验性）版本，方便快速部署脑影像分析流程。

## 核心功能和特性

### 核心功能
基于T1加权MRI，提供以下关键能力：
- **深度学习全脑分割**：1-4分钟（GPU）或20分钟（CPU）内完成95类全脑分割，包括：
  - Desikian-Killiany-Tourville图谱分割（33个皮质下结构和31个皮质结构/半球）
  - 小脑叶分割（27个结构）
  - 下丘脑细分
  - ROI-wise体积统计
  - 支持原生高分辨率分割（<1.0mm³，无需重采样）

- **FreeSurfer兼容输出**：约45分钟（含30分钟球形配准，默认开启）生成：
  - 皮质表面（白质、软脑膜）
  - 表面测量值（厚度、曲率等）
  - 表面标签和注释（aparc.annot、cortex.label等）
  - 逐点表面统计和ROI-wise体积统计
  - 与FSAVERAGE的球形配准（支持组间分析及fMRI/扩散分析预处理）

### 特性
- **多版本支持**：提供GPU（CUDA）、纯CPU及AMD GPU（ROCM，实验性）版本
- **兼容性**：与FreeSurfer输出完全兼容，无缝集成现有工作流
- **高效处理**：GPU加速全脑分割仅需1-4分钟，大幅缩短分析周期

## 使用场景和适用范围
适用于各类脑结构MRI分析场景：
- 快速脑结构定位与全脑分割
- 定量形态学指标提取（体积、厚度等）
- 队列研究组分析
- fMRI/扩散磁共振成像的结构预处理
- 高分辨率脑MRI数据处理（亚毫米分辨率）

## 标签说明

### 主要标签
- `cu###-v#.#.#`：CUDA支持版本（如`cu124-v2.0.0`表示CUDA 12.4+FastSurfer 2.0.0），支持老旧Nvidia驱动系统，也可用于纯CPU处理
- `cpu-v#.#.#`：纯CPU版本（无GPU支持，镜像体积更小）
- `rocm#.#-v#.#.#`：AMD GPU支持版本（ROCM，实验性），如`rocm5.7-v2.0.0`

### 便捷标签
指向上述主要标签的快捷引用：
- `latest`/`gpu-latest`：最新FastSurfer版本+最新CUDA包
- `cpu-latest`：最新纯CPU版本
- `cuda-v#.#.#`：指定FastSurfer版本的最新CUDA构建
- `rocm-v#.#.#`：指定FastSurfer版本的最新ROCM构建（实验性）

## 下载与部署

### 镜像下载
#### Docker
```bash
# 最新GPU版本
docker pull deepmi/fastsurfer:latest

# 最新CPU版本
docker pull deepmi/fastsurfer:cpu-latest

# 指定版本（如CUDA 12.4+FastSurfer 2.0.0）
docker pull deepmi/fastsurfer:cu124-v2.0.0
```

#### Singularity
```bash
singularity build fastsurfer-gpu.sif docker://deepmi/fastsurfer:latest
```

### 运行说明
#### 核心依赖说明
- **Surface模块**：依赖FreeSurfer，镜像包含精简版FreeSurfer（不含可视化工具及示例数据），但需**有效FreeSurfer许可证**（仅运行Surface模块时需要，分割模块无需）。
- **许可证获取**：从[FreeSurfer官网](https://surfer.nmr.mgh.harvard.edu/registration.html)注册获取，通过`FS_LICENSE`环境变量或挂载文件传入。

#### 基本运行示例
##### GPU版本（需Nvidia Docker支持）
```bash
# 导出许可证路径（若使用Surface模块）
export FS_LICENSE=/path/to/freesurfer/license.txt

# 运行全流程分析（含分割与Surface模块）
docker run --gpus all \
  -v /path/to/input:/input \
  -v /path/to/output:/output \
  -e FS_LICENSE=$FS_LICENSE \
  deepmi/fastsurfer:latest \
  --t1 /input/subject_t1.nii.gz \
  --sid subject1 \
  --sd /output
```

##### CPU版本
```bash
docker run \
  -v /path/to/input:/input \
  -v /path/to/output:/output \
  -e FS_LICENSE=$FS_LICENSE \
  deepmi/fastsurfer:cpu-latest \
  --t1 /input/subject_t1.nii.gz \
  --sid subject1 \
  --sd /output \
  --cpu
```

## 相关链接
- GitHub源代码：[https://github.com/deep-mi/FastSurfer](https://github.com/deep-mi/FastSurfer)
- 官方文档：[https://deep-mi.org/FastSurfer](https://deep-mi.org/FastSurfer)
- 项目介绍：[http://www.fastsurfer.net](http://www.fastsurfer.net)
- FreeSurfer官网：[https://surfer.nmr.mgh.harvard.edu](https://surfer.nmr.mgh.harvard.edu)

## 许可证
Apache License v2

## 参考文献
若用于研究发表，请引用：
- Henschel L, Conjeti S, Estrada S, et al. FastSurfer - A fast and accurate deep learning based neuroimaging pipeline. NeuroImage 219 (2020), 117012. https://doi.org/10.1016/j.neuroimage.2020.117012
- Henschel L, Kügler D, Reuter M. FastSurferVINN: Building resolution-independence into deep learning segmentation methods - A solution for HighRes brain MRI. NeuroImage 251 (2022), 118933. https://doi.org/10.1016/j.neuroimage.2022.118933
- Faber J*, Kuegler D*, Bahrami E*, et al. CerebNet: A fast and reliable deep-learning pipeline for detailed cerebellum sub-segmentation. NeuroImage 264 (2022), 119703. https://doi.org/10.1016/j.neuroimage.2022.119703
- Estrada S, Kügler D, Bahrami E, et al. FastSurfer-HypVINN: Automated sub-segmentation of the hypothalamus and adjacent structures on high-resolutional brain MRI. Imaging Neuroscience (2023), 1:1-32. https://doi.org/10.1162/imag_a_00034
