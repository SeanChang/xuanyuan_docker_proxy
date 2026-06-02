---
image: ultralytics/ultralytics
description: "Ultralytics官方Docker镜像是由计算机视觉领域知名团队Ultralytics推出的标准化容器方案，预装YOLO系列模型（如YOLOv5、YOLOv8等）、PyTorch框架、CUDA加速库及全套依赖工具，为开发者、研究者和企业用户提供开箱即用的计算机视觉开发部署环境，支持模型训练、推理优化、多平台导出等全流程任务，能大幅简化环境配置流程，确保跨设备与系统的一致性运行，助力快速实现目标检测、图像分割、姿态估计等AI应用落地。"
source: https://xuanyuan.cloud/zh/r/ultralytics/ultralytics
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[ultralytics/ultralytics](https://xuanyuan.cloud/zh/r/ultralytics/ultralytics)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# YOLO11：快速、准确、易用的计算机视觉模型


## 项目概述
Ultralytics YOLO11是一款先进的尖端（SOTA）模型，基于前代YOLO版本的成功经验开发，新增多项特性与改进，进一步提升性能与灵活性。该模型设计追求快速、准确且易用，适用于目标检测与跟踪、实例分割、图像分类及姿态估计等多种任务。


## 文档

### 安装
在Python≥3.8环境中（需PyTorch≥1.8），可通过以下方式安装：

#### Pip安装（推荐）
```bash
pip install ultralytics
```

#### 其他安装方式
- **Conda**：`conda install -c conda-forge ultralytics`  
- **Docker**：`docker pull ultralytics/ultralytics`  
- 源码安装：参考[快速开始指南]([])


### 使用
YOLO11支持命令行（CLI）和Python两种使用方式，参数一致，操作灵活。

#### CLI命令行
直接通过`yolo`命令调用，例如对图像进行目标检测：
```bash
yolo predict model=yolo11n.pt source='[]'
```
可添加额外参数（如`imgsz=640`设置图像尺寸），更多示例见[CLI文档]([])。

#### Python代码
在Python环境中导入YOLO模块使用，支持模型加载、训练、评估、推理和导出：
```python
from ultralytics import YOLO

# 加载模型
model = YOLO("yolo11n.pt")

# 训练模型（以COCO8小数据集为例）
train_results = model.train(
    data="coco8.yaml",  # 数据集配置文件路径
    epochs=100,         # 训练轮次
    imgsz=640,          # 图像尺寸
    device="cpu"        # 运行设备（如device=0使用GPU，device=cpu使用CPU）
)

# 在验证集上评估性能
metrics = model.val()

# 对单张图像推理并显示结果
results = model("path/to/image.jpg")
results[0].show()

# 导出为ONNX格式
path = model.export(format="onnx")  # 返回导出模型路径
```
更多Python示例见[Python文档]([])。


## 模型
YOLO11提供在COCO数据集上预训练的检测、分割、姿态估计模型，以及在ImageNet上预训练的分类模型。以下为检测模型性能参数（基于COCO val2017数据集）：

| 模型        | 尺寸（像素） | 验证集mAP 50-95 | CPU ONNX速度（毫秒） | T4 TensorRT10速度（毫秒） | 参数量（M） | 计算量（B） |
|-------------|--------------|-----------------|---------------------|---------------------------|-------------|-------------|
| YOLO11n.pt  | 640          | 39.5            | 56.1 ± 0.8          | 1.5 ± 0.0                 | 2.6         | 6.5         |
| YOLO11s.pt  | 640          | 47.0            | 90.0 ± 1.2          | 2.5 ± 0.0                 | 9.4         | 21.5        |
| YOLO11m.pt  | 640          | 51.5            | 183.2 ± 2.0         | 4.7 ± 0.1                 | 20.1        | 68.0        |
| YOLO11l.pt  | 640          | 53.4            | 238.6 ± 1.4         | 6.2 ± 0.1                 | 25.3        | 86.9        |
| YOLO11x.pt  | 640          | 54.7            | 462.8 ± 6.7         | 11.3 ± 0.2                | 56.9        | 194.9       |

- **mAP值**：单模型单尺度在COCO val2017数据集上的结果，可通过`yolo val detect data=coco.yaml device=0`复现。  
- **速度**：基于Amazon EC2 P4d实例的COCO val图像平均速度，可通过`yolo val detect data=coco.yaml batch=1 device=0|cpu`复现。


## 平台集成
YOLO11与主流AI平台深度集成，优化数据标注、训练、可视化和模型管理流程：

| 集成平台          | 核心功能                                                                 |
|-------------------|--------------------------------------------------------------------------|
| Ultralytics HUB   | 一站式平台，支持数据可视化、模型训练与部署，无需编码                      |
| Weights & Biases  | 跟踪实验过程、超参数及结果，便于模型优化                                  |
| Comet             | 免费保存模型、恢复训练，交互式可视化与调试推理结果                       |
| Neural Magic       | 通过DeepSparse加速推理，性能提升最高达6倍                                 |


## Ultralytics HUB
Ultralytics HUB是一款全流程AI工具，支持：  
- 数据可视化与标注  
- YOLO11模型训练、评估与部署  
- 无需编写代码，通过网页界面操作  
- 配套Ultralytics App，支持本地部署  

[立即免费试用]([])


## 社区贡献
YOLO11的发展离不开社区支持，欢迎通过以下方式参与：  
- 提交代码或文档改进（参考[贡献指南]([])）  
- 填写[用户调研]([])反馈使用体验  


## 许可证
- **开源许可**：AGPL-3.0协议，适用于学生、开发者及研究场景，详见[LICENSE]([])。  
- **商业许可**：如需将YOLO11集成到商业产品，可申请[企业授权]([])。  


## 联系与支持
- **社区论坛**：[Ultralytics Forums]([])  
- *：[加入讨论]()  
- **Reddit**：[r/ultralytics]()  
- **文档**：[中文文档]([])  

也可通过GitHub Issues提交bug报告或功能建议。
