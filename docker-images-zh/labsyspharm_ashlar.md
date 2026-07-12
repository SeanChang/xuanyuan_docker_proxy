---
image: labsyspharm/ashlar
description: "ASHLAR是一个用于显微镜图像快速高质量拼接和配准的工具，支持CyCIF、CODEX等循环成像方法的多轮共配准，可读取BioFormats支持的显微镜文件或TIFF目录，输出金字塔式分块OME-TIFF，需未拼接的单个tile图像作为输入。"
source: https://xuanyuan.cloud/zh/r/labsyspharm/ashlar
canonical: https://xuanyuan.cloud/zh/r/labsyspharm/ashlar
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/labsyspharm/ashlar" title="labsyspharm/ashlar Docker 镜像中文简介、标签列表与拉取命令">labsyspharm/ashlar 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ASHLAR：通过层/邻接配准的同时协调进行对齐

## 概述

ASHLAR是一个基于Python的全切片显微镜图像拼接与配准工具，可执行快速、高质量的显微镜图像拼接，同时支持CyCIF、CODEX等循环成像方法的多轮共配准。它能直接读取BioFormats支持的显微镜厂商文件格式以及包含未拼接图像的TIFF文件目录，输出结果保存为金字塔式、分块OME-TIFF。注意，ASHLAR要求未拼接的单个"tile"图像作为输入，因此不适用于仅提供预拼接图像的显微镜或切片扫描仪。

**访问 [labsyspharm.github.io/ashlar/](https://labsyspharm.github.io/ashlar/) 获取ASHLAR的最新信息。**

## 核心功能与特性

- **快速高质量拼接**：实现显微镜图像的快速、高精度拼接处理
- **循环成像共配准**：支持CyCIF、CODEX等循环成像技术的多轮图像共配准
- **多输入格式支持**：直接读取BioFormats兼容的显微镜厂商文件或TIFF图像目录
- **灵活输出选项**：生成金字塔式、分块OME-TIFF格式输出，便于后续分析和查看
- **校正功能**：支持平场（FFP）和暗场（DFP）照明校正，提升图像质量
- **参数可调**：提供丰富的配置参数，如对齐通道选择、位移限制、滤波参数等，适应不同成像需求

## 使用场景与适用范围

- **循环成像处理**：适用于CyCIF、CODEX等需要多轮成像共配准的实验场景
- **显微镜图像拼接**：处理未拼接的单个tile图像，生成完整的拼接结果
- **高质量图像输出**：需要金字塔式OME-TIFF格式输出的显微镜图像处理任务
- **注意**：不适用于仅提供预拼接图像的显微镜或切片扫描仪

## 使用方法与配置说明

### 命令行参数

#### 位置参数
- `FILE`：待处理的图像文件，每个循环对应一个文件

#### 可选参数
| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-h, --help` | 显示帮助信息并退出 | - |
| `-o PATH, --output PATH` | 输出文件路径。若以`.ome.tif`结尾，生成金字塔式OME-TIFF；若以`.tif`结尾且包含`{cycle}`和`{channel}`占位符，生成单通道TIFF系列；路径目录必须已存在 | `ashlar_output.ome.tif` |
| `-c CHANNEL, --align-channel CHANNEL` | 图像对齐的参考通道编号（从0开始） | 0 |
| `--flip-x` | 沿X轴翻转tile位置（左右翻转） | - |
| `--flip-y` | 沿Y轴翻转tile位置（上下翻转） | - |
| `--flip-mosaic-x` | 沿X轴翻转输出图像（左右翻转） | - |
| `--flip-mosaic-y` | 沿Y轴翻转输出图像（上下翻转） | - |
| `--output-channels CHANNEL [CHANNEL ...]` | 仅输出指定通道（从0开始，多个通道空格分隔） | 所有通道 |
| `-m SHIFT, --maximum-shift SHIFT` | 单个tile允许的最大校正位移（微米） | 15 |
| `--stitch-alpha ALPHA` | 对齐误差量化的置换检验显著性水平（值越大包含更多tile对，假阳性增加） | 0.01 |
| `--filter-sigma SIGMA` | 对齐前高斯滤波的标准差（像素），0表示不滤波 | 不滤波 |
| `--tile-size PIXELS` | OME-TIFF输出的金字塔分块大小（像素） | 1024 |
| `--ffp FILE [FILE ...]` | 平场校正图像路径，可为所有循环指定一个文件或每个循环一个文件（通道数需匹配输入） | 不校正 |
| `--dfp FILE [FILE ...]` | 暗场校正图像路径，可为所有循环指定一个文件或每个循环一个文件（通道数需匹配输入） | 不校正 |
| `--plates` | 启用HTS数据的板模式 | - |
| `-q, --quiet` | 抑制进度显示 | - |
| `--version` | 显示程序版本号并退出 | - |

### 安装方法

#### Pip安装
在Python环境中通过pip直接安装：
```bash
pip install ashlar
```

#### Conda环境安装
1. 创建并激活conda环境：
   ```bash
   conda create -y -n ashlar python=3.12
   conda activate ashlar
   ```

2. 安装依赖与ASHLAR：
   ```bash
   conda install -y -c conda-forge numpy scipy matplotlib networkx scikit-image scikit-learn tifffile zarr pyjnius blessed
   pip install ashlar
   ```

#### Docker镜像
Docker镜像托管于DockerHub：[labsyspharm/ashlar](https://hub.docker.com/r/labsyspharm/ashlar)，适用于多种使用场景。

### Docker部署示例

#### 基本使用
挂载本地数据目录并运行拼接：
```bash
docker run --rm -v /本地数据路径:/data docker.xuanyuan.run/labsyspharm/ashlar ashlar /data/input_cycle1.tif /data/input_cycle2.tif -o /data/output.ome.tif
```

#### 指定对齐通道和输出通道
```bash
docker run --rm -v /本地数据路径:/data docker.xuanyuan.run/labsyspharm/ashlar ashlar /data/input_files -o /data/output.ome.tif -c 2 --output-channels 0 1 2
```

#### 使用平场校正
```bash
docker run --rm -v /本地数据路径:/data docker.xuanyuan.run/labsyspharm/ashlar ashlar /data/input_cycles.tif --ffp /data/flatfield.tif -o /data/corrected_output.ome.tif
```

> 注：`/本地数据路径`需替换为实际存放输入文件的本地目录路径，容器内通过`/data`目录访问该路径下的文件。
