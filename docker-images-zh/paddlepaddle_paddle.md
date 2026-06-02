---
image: paddlepaddle/paddle
description: "并行分布式深度学习是一种通过将深度学习任务按数据并行、模型并行或混合并行等方式分解，并分配到多台计算机或计算节点（如CPU、GPU集群）上协同执行的技术，旨在加速大规模数据集和复杂模型的训练过程，通过并行计算提升效率、缩短训练时间，广泛应用于图像识别、自然语言处理、推荐系统、自动驾驶等领域，是应对海量数据和高复杂度模型训练挑战、推动人工智能技术规模化落地的关键支撑技术之一。"
source: https://xuanyuan.cloud/zh/r/paddlepaddle/paddle
canonical: https://xuanyuan.cloud/zh/r/paddlepaddle/paddle
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/paddlepaddle/paddle" title="paddlepaddle/paddle Docker 镜像中文简介、标签列表与拉取命令">paddlepaddle/paddle — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/paddlepaddle/paddle" title="paddlepaddle/paddle Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/paddlepaddle/paddle</a>

# PaddlePaddle


[![Build Status]([])]([])
[![Documentation Status]([])]([])
[![Documentation Status]([])]([])
[![Coverage Status]([])]([])
[![Release]([])]([])
[![License]([])](LICENSE)


欢迎来到PaddlePaddle的GitHub主页。  

PaddlePaddle（并行分布式深度学习）是一款易用、高效、灵活且可扩展的深度学习平台，由百度科学家和工程师原创开发，旨在将深度学习技术应用于百度的众多产品中。  

我们的愿景是通过PaddlePaddle让每个人都能使用深度学习。你可以通过[发布公告]([])了解PaddlePaddle的最新功能。


## 核心特性

### 灵活性  
PaddlePaddle支持多种神经网络架构和优化算法，便于配置复杂模型，例如带注意力机制的神经机器翻译模型或复杂的记忆连接模型。


### 高效性  
为充分释放异构计算资源的能力，PaddlePaddle从计算、内存、架构、通信等多个层面进行优化，具体包括：  
- 通过SSE/AVX指令集、BLAS库（如MKL、OpenBLAS、cuBLAS）或定制的CPU/GPU内核优化数学运算；  
- 基于MKL-DNN库优化CNN网络；  
- 高度优化的循环网络，可处理变长序列，无需填充；  
- 针对高维稀疏数据模型，优化本地和分布式训练。  


### 可扩展性  
借助PaddlePaddle，可轻松使用多CPU/GPU和多台机器加速训练，通过优化通信实现高吞吐量和性能。  


### 与产品结合  
PaddlePaddle设计之初就考虑了部署便捷性。在百度内部，PaddlePaddle已被部署到众多高用户量的产品和服务中，包括广告点击率（CTR）预测、大规模图像分类、光学字符识别（OCR）、搜索排序、计算机病毒检测、推荐系统等。它在百度产品中广泛应用并产生了显著价值，希望你也能通过PaddlePaddle为自己的产品带来助力。


## 安装  
建议参考[官网中文文档]([])进行安装。


## 文档  
PaddlePaddle提供中英文文档，主要资源包括：  
- [《深度学习入门》]([])：可在Jupyter Notebook中运行的在线互动学习书籍，适合入门；  
- [分布式训练]([])：介绍如何在MPI集群上运行分布式训练任务；  
- [Python API]([])：新API支持更简洁的代码编写；  
- [如何贡献代码]([])：欢迎参与贡献，感谢你的支持！  


## 问题反馈  
欢迎通过[Github Issues]([])提交问题和bug报告。


## 版权与许可  
PaddlePaddle基于[Apache-2.0许可证](LICENSE)开源。
