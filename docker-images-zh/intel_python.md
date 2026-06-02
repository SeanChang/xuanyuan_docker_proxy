---
image: intel/python
description: "Intel® Distribution for Python* 是增强性能的Python发行版，集成Intel® Math Kernel Library等性能库，可提升程序速度10到100倍，支持Intel dGPU，包含最新驱动和OneAPI运行时库，加速数值计算与机器学习框架。"
source: https://xuanyuan.cloud/zh/r/intel/python
canonical: https://xuanyuan.cloud/zh/r/intel/python
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/python" title="intel/python Docker 镜像中文简介、标签列表与拉取命令">intel/python — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/intel/python" title="intel/python Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/intel/python</a>

# Intel® Distribution for Python*

[Intel® Distribution for Python*] 可增强性能，将程序速度提升10到100倍。它是一个Python发行版，包含[Intel® Math Kernel Library] (oneMKL) 和其他Intel性能库，通过加速核心数值计算和机器学习包实现近原生性能。

Intel® Distribution for Python* 还支持Intel® dGPU，包含最新的[Intel® dGPU驱动]和Intel® OneAPI运行时库（如[Intel® Math Kernel Library]、[Intel® DPC++ Compiler Library]和[Intel® Collective Communications Library]），使机器学习框架能够利用XPU设备插件。

## 镜像版本

以下镜像包含[Intel® Distribution for Python*]安装中的核心包或所有包的不同变体。

| 标签(s)                | IDP版本    |
| ---------------------- | ---------- |
| `3.11-full`, `latest` | `2025.0.0` |
| `3.11-xpu-full`        | `2025.0.0` |
| `3.10-full`            | `2024.2.0` |
| `3.10-core`            | `2024.2.0` |

## 运行性能示例

要运行性能示例，请执行以下命令：

```bash
git clone https://github.com/intel/ai-containers
cd ai-containers/python
docker run --rm -it \
    -v $PWD/tests:/tests \
    intel/python:latest \
    python /tests/perf_sample.py
```

### 与标准Python对比结果

在上述命令中，您将在底部看到类似以下结果：`Time Consuming: 0.03897857666015625`。可与`python:3.11-slim-bullseye`对比：

```bash
# 使用上述命令的工作目录
docker run --rm -it \
    -v $PWD/tests:/tests \
    python:3.10-slim-bullseye \
    bash
pip install numpy
python /tests/perf_sample.py
```

### 使用XPU变体运行兼容性测试

使用以下命令检查系统上Intel dGPU设备的可用性以及Intel® OneAPI运行时库的存在：

```bash
# 使用第一个命令的工作目录
docker run --rm -it \
    -v $PWD/tests:/tests \
    --device /dev/dri \
    intel/python:3.11-xpu-full \
    bash /tests/xpu_base_layers_test.sh
```

## 从源码构建（高级）

要从源码构建镜像，请克隆[AI Containers](https://github.com/intel/ai-containers)仓库，按照主`README.md`文件设置环境，然后运行以下命令：

```bash
cd python
docker compose build idp
docker compose run idp
```

要构建镜像的XPU变体，请运行以下命令：

```bash
cd python
docker compose build xpu
docker compose run xpu
```

以下是组中每个容器的服务列表：

| 服务名称 | 描述                                                             |
| -------- | ---------------------------------------------------------------- |
| `idp`    | 包含[Intel® Distribution for Python*]的基础镜像                   |
| `pip`    | 不含[Intel® Distribution for Python*]的等效Python镜像             |
| `xpu`    | 带Intel XPU插件的基础镜像，包含[Intel® Distribution for Python*] |

## 许可证

查看[Intel® Distribution for Python]的[许可证](https://github.com/intel/ai-containers/blob/main/LICENSE)。

镜像用户有责任确保对以下镜像的任何使用均符合其中包含的所有软件的相关许可证要求。

\* 其他名称和品牌可能是其各自所有者的财产。

<!--以下是本文档中使用的链接，不会被渲染： -->

[Intel® Distribution for Python*]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/distribution-for-python.html#gs.9bos9m
[Intel® Math Kernel Library]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html
[Intel® DPC++ Compiler Library]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/dpc-compiler-download.html
[Intel® Collective Communications Library]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/oneccl.html
[Intel® dGPU drivers]: https://dgpu-docs.intel.com/releases/releases.html
