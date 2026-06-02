---
image: tensorflow/tensorflow
description: "TensorFlow（官网：[]"
source: https://xuanyuan.cloud/zh/r/tensorflow/tensorflow
canonical: https://xuanyuan.cloud/zh/r/tensorflow/tensorflow
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tensorflow/tensorflow" title="tensorflow/tensorflow Docker 镜像中文简介、标签列表与拉取命令">tensorflow/tensorflow — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/tensorflow/tensorflow" title="tensorflow/tensorflow Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/tensorflow/tensorflow</a>

# TensorFlow Runtime Docker 镜像


这些容器提供了快速运行或试用 TensorFlow 的方式。镜像源代码见 [GitHub]([])。若需构建 TensorFlow 或其扩展，建议参考 [TensorFlow Build Dockerfiles]([])。


## 基础依赖说明
镜像基于 TensorFlow 官方 Python 二进制文件构建，需 CPU 支持 AVX 指令集。大多数现代 CPU 均支持 AVX，因此通常无需担心兼容性问题。更多信息可参考 [GitHub Issue]([])。


## 基础镜像标签说明
- **系统版本**：2021 年 9 月后构建的镜像基于 Ubuntu 20.04，更早的镜像基于 Ubuntu 18.04 或 16.04。  
- **标签含义**（适用于 TF 1.13 及以上版本，旧版本标签格式不同，可查看 [完整标签列表]([])）：  
  - `1.xx-`、`latest-`、`nightly-` 标签：预装 TensorFlow。版本化标签（如 `1.xx-`）包含具体版本号；`latest-` 标签为最新发布版（不含预发布版，如候选发布版、alpha 版、beta 版）；`nightly-` 标签包含最新 TensorFlow nightly Python 包。  
  - `devel` 和 `custom-op` 标签：已不再支持，建议使用 [TensorFlow SIG Build Dockerfiles]([])。  


## 可选特性
- **Python 版本**：  
  - 1.x 版本（≤1.15.0）和 2.x 版本（≤2.1.0）中，`-py3` 标签对应 Python 3（Ubuntu 16 镜像为 3.5，Ubuntu 18 为 3.6，Ubuntu 20 为 3.8），无 `py` 标签的镜像为 Python 2.7。  
  - 所有更新的镜像仅支持 Python 3，`-py3` 标签已弃用。  

- **GPU 支持**：  
  `-gpu` 标签基于 [Nvidia CUDA]([]) 构建，需通过 [nvidia-docker]([]) 运行。  
  **注意**：TensorFlow 1.13 及以上版本的 GPU 镜像（含 `latest-` 标签）需支持 CUDA 10 的 Nvidia 驱动，具体参考 [Nvidia 支持矩阵]([])。  

- **Jupyter 集成**：  
  `-jupyter` 标签包含 Jupyter 及部分 TensorFlow 教程笔记本，启动时自动运行 Jupyter 服务器。可将卷挂载到 `/tf/notebooks` 以使用自己的笔记本。  


## 运行容器示例

### 启动 CPU-only 容器
```bash
$ docker run -it --rm tensorflow/tensorflow bash
```


### 启动 GPU 容器并运行 Python 解释器
```bash
$ docker run -it --rm --runtime=nvidia tensorflow/tensorflow:latest-gpu python
```


### 运行 Jupyter 笔记本服务器（挂载自定义笔记本目录）
```bash
$ docker run -it --rm -v $(realpath ~/notebooks):/tf/notebooks -p 8888:8888 tensorflow/tensorflow:latest-jupyter
```
> 说明：假设本地笔记本目录为 `~/notebooks`，通过 `-v` 挂载到容器内 `/tf/notebooks`，`-p` 映射端口 8888。启动后在浏览器访问 `localhost:8888` 即可使用。
