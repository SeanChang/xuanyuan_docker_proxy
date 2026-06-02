---
image: wenbowen123/foundationpose
description: "统一的6D物体姿态估计与跟踪基础模型，支持基于模型和无模型两种设置，无需微调即可应用于新物体。CVPR 2024 Highlight论文的官方实现。"
source: https://xuanyuan.cloud/zh/r/wenbowen123/foundationpose
canonical: https://xuanyuan.cloud/zh/r/wenbowen123/foundationpose
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/wenbowen123/foundationpose" title="wenbowen123/foundationpose Docker 镜像中文简介、标签列表与拉取命令">wenbowen123/foundationpose — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/wenbowen123/foundationpose" title="wenbowen123/foundationpose Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/wenbowen123/foundationpose</a>

# FoundationPose

**[FoundationPose](https://github.com/NVlabs/FoundationPose)**: 统一的6D物体姿态估计与跟踪基础模型

[![Paper](https://img.shields.io/badge/Paper-CVPR%202024-blue)](https://arxiv.org/abs/2312.08344)
[![Website](https://img.shields.io/badge/Website-Project%20Page-green)](https://nvlabs.github.io/FoundationPose/)

这是我们在CVPR 2024（Highlight）论文的官方实现。

**贡献者**: Bowen Wen, Wei Yang, Jan Kautz, Stan Birchfield

## 功能特性

我们提出了FoundationPose，一个用于6D物体姿态估计和跟踪的统一基础模型，支持基于模型和无模型两种设置。只要给定物体的CAD模型，或捕获少量参考图像，我们的方法可以在测试时立即应用于新物体，无需微调。我们通过神经隐式表示桥接这两种设置之间的差距，允许有效的新视角合成，保持下游姿态估计模块在同一统一框架下的不变性。通过大规模合成训练、大语言模型（LLM）辅助、基于Transformer的新架构和对比学习公式，实现了强大的泛化能力。在涉及挑战性场景和物体的多个公共数据集上的广泛评估表明，我们的统一方法大幅优于专门针对每个任务的现有方法。此外，尽管假设减少，它甚至达到了与实例级方法相当的结果。

### 主要特点

- [x] 统一的6D姿态估计和跟踪框架
- [x] 支持基于模型（CAD模型）和无模型（少量参考图像）两种设置
- [x] 无需微调即可应用于新物体
- [x] 神经隐式表示实现有效的新视角合成
- [x] 大规模合成训练实现强泛化能力
- [x] 基于Transformer的架构和对比学习

### 成就

- 🥇 **世界BOP排行榜第一名**（截至2024/03）用于基于模型的新物体姿态估计
- 🤖 **ROS版本**: 请查看 [Isaac ROS Pose Estimation](https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_pose_estimation)，享受TRT快速推理和C++加速

## 演示

### 机器人应用

机器人操作演示展示了FoundationPose在实际机器人任务中的应用。

### AR应用

增强现实应用演示展示了在AR场景中的实时姿态跟踪能力。

### YCB-Video数据集结果

在YCB-Video数据集上的跟踪结果展示了方法的有效性。

## 数据准备

### 下载网络权重

从[这里](https://drive.google.com/drive/folders/1qT0mKz7h08s3qEzNlM2i1V8w7Tl0J3xK)下载所有权重文件，并将它们放在`weights/`文件夹下。

- **Refiner**: 需要 `2023-10-28-18-33-37`
- **Scorer**: 需要 `2024-01-11-20-02-45`

### 下载演示数据

下载演示数据并解压到`demo_data/`文件夹下。

### 可选：下载训练数据

- [可选] 下载我们的大规模训练数据："FoundationPose Dataset"
- [可选] 下载我们预处理的参考视图以运行无模型少样本版本

## 环境设置

### 选项1：Docker（推荐）

```bash
cd docker/
docker pull wenbowen123/foundationpose && docker tag wenbowen123/foundationpose foundationpose
# 或者从头构建：docker build --network host -t foundationpose .
bash docker/run_container.sh
```

**首次启动容器时，需要构建扩展。在Docker容器内运行以下命令：**

```bash
bash build_all.sh
```

之后您可以进入容器而无需重新构建：

```bash
docker exec -it foundationpose bash
```

**对于较新的GPU（如4090）**，请参考[此链接](https://github.com/NVlabs/FoundationPose/issues/XX)。简而言之，执行以下操作：

```bash
docker pull shingarey/foundationpose_custom_cuda121:latest
```

然后修改bash脚本以使用此镜像而不是`foundationpose:latest`。

### 选项2：Conda（实验性）

#### 设置Conda环境

```bash
# 创建conda环境
conda create -n foundationpose python=3.9

# 激活conda环境
conda activate foundationpose

# 在conda环境下安装Eigen3 3.4.0
conda install conda-forge::eigen=3.4.0
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:/eigen/path/under/conda"

# 安装依赖
python -m pip install -r requirements.txt

# 安装NVDiffRast
python -m pip install --quiet --no-cache-dir git+https://github.com/NVlabs/nvdiffrast.git

# Kaolin（可选，运行无模型设置时需要）
python -m pip install --quiet --no-cache-dir kaolin==0.15.0 -f https://nvidia-kaolin.s3.us-east-2.amazonaws.com/torch-2.0.0_cu118.html

# PyTorch3D
python -m pip install --quiet --no-index --no-cache-dir pytorch3d -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py39_cu118_pyt200/download.html

# 构建扩展
CMAKE_PREFIX_PATH=$CONDA_PREFIX/lib/python3.9/site-packages/pybind11/share/cmake/pybind11 bash build_all_conda.sh
```

## 运行基于模型的演示

路径已在argparse中默认设置。如果需要更改场景，可以相应地传递参数。在演示数据上运行，您应该能够看到机器人操作芥末瓶。姿态估计在第一帧进行，然后自动切换到跟踪模式处理视频的其余部分。结果可视化将保存到argparse中指定的`debug_dir`。（注意首次运行可能由于在线编译而较慢）

```bash
python run_demo.py
```

可以自由尝试其他物体（无需重新训练），例如driller，通过更改argparse中的路径。

## 在公共数据集上运行（LINEMOD、YCB-Video）

为此，您首先需要下载LINEMOD数据集和YCB-Video数据集。

### 运行基于模型版本

在这两个数据集上分别运行基于模型版本，根据下载位置设置路径。结果将保存到debug文件夹。

```bash
python run_linemod.py --linemod_dir /path/to/LINEMOD --use_reconstructed_mesh 0

python run_ycb_video.py --ycbv_dir /path/to/YCB_Video --use_reconstructed_mesh 0
```

### 运行无模型少样本版本

首先需要训练Neural Object Field。`ref_view_dir`基于上述"数据准备"部分的下载位置。将数据集标志设置为您感兴趣的数据集。

```bash
python bundlesdf/run_nerf.py --ref_view_dir /path/to/ref_views_16 --dataset ycbv
```

然后运行与基于模型版本类似的命令，但有一些小的修改。这里我们使用YCB-Video作为示例：

```bash
python run_ycb_video.py --ycbv_dir /path/to/YCB_Video --use_reconstructed_mesh 1 --ref_view_dir /path/to/ref_views_16
```

## 故障排除

- **对于较新的GPU（如4090）**: 请参考[此链接](https://github.com/NVlabs/FoundationPose/issues/XX)
- **在Windows上设置**: 请参考[此链接](https://github.com/NVlabs/FoundationPose/issues/XX)
- **如果得到不合理的结果**: 请检查[此链接](https://github.com/NVlabs/FoundationPose/issues/XX)和[此链接](https://github.com/NVlabs/FoundationPose/issues/XX)

## 训练数据下载

我们的训练数据包括使用来自GSO和Objaverse的3D资产渲染的场景，具有高质量照片级真实感和大域随机化。每个数据点包括RGB、深度、物体姿态、相机姿态、实例分割、2D边界框。[Google Drive](https://drive.google.com/drive/folders/...)

### 解析相机参数（包括外参和内参）

```python
glcam_in_cvcam = np.array([[1,0,0,0],
                        [0,-1,0,0],
                        [0,0,-1,0],
                        [0,0,0,1]]).astype(float)

W, H = camera_params["renderProductResolution"]
with open(f'{base_dir}/camera_params/camera_params_000000.json','r') as ff:
  camera_params = json.load(ff)

world_in_glcam = np.array(camera_params['cameraViewTransform']).reshape(4,4).T
cam_in_world = np.linalg.inv(world_in_glcam)@glcam_in_cvcam
world_in_cam = np.linalg.inv(cam_in_world)

focal_length = camera_params["cameraFocalLength"]
horiz_aperture = camera_params["cameraAperture"][0]
vert_aperture = H / W * horiz_aperture
focal_y = H * focal_length / vert_aperture
focal_x = W * focal_length / horiz_aperture
center_y = H * 0.5
center_x = W * 0.5

fx, fy, cx, cy = focal_x, focal_y, center_x, center_y
K = np.eye(3)
K[0,0] = fx
K[1,1] = fy
K[0,2] = cx
K[1,2] = cy
```

## 注意事项

由于Stable-Diffusion在LAION数据集上训练的法律限制，我们无法发布基于扩散的纹理增强数据，也无法发布使用它训练的预训练权重。因此，我们发布了未在扩散增强数据上训练的版本。预期会有轻微的性能下降。

## 引用

如果您使用此代码，请引用我们的论文：

```bibtex
@InProceedings{foundationposewen2024,
  author        = {Bowen Wen, Wei Yang, Jan Kautz, Stan Birchfield},
  title         = {{FoundationPose}: Unified 6D Pose Estimation and Tracking of Novel Objects},
  booktitle     = {CVPR},
  year          = {2024},
}
```

如果您发现无模型设置有用，请同时考虑引用：

```bibtex
@InProceedings{bundlesdfwen2023,
  author        = {Bowen Wen and Jonathan Tremblay and Valts Blukis and Stephen Tyree and Thomas M"{u}ller and Alex Evans and Dieter Fox and Jan Kautz and Stan Birchfield},
  title         = {{BundleSDF}: {N}eural 6-{DoF} Tracking and {3D} Reconstruction of Unknown Objects},
  booktitle     = {CVPR},
  year          = {2023},
}
```

## 致谢

我们要感谢Jeff Smith帮助代码发布；NVIDIA Isaac Sim和Omniverse团队对合成数据生成的支持；Tianshi Cao的宝贵讨论。最后，我们也感谢CVPR审稿人和AC提出的积极反馈和建设性建议。

## 许可证

代码和数据在NVIDIA源代码许可证下发布。版权所有 © 2024，NVIDIA Corporation。保留所有权利。

## 联系方式

如有问题，请联系Bowen Wen。
