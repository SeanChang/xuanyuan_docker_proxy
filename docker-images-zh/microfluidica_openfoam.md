---
image: microfluidica/openfoam
description: "OpenFOAM各主要发行版的Docker镜像"
source: https://xuanyuan.cloud/zh/r/microfluidica/openfoam
canonical: https://xuanyuan.cloud/zh/r/microfluidica/openfoam
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/microfluidica/openfoam" title="microfluidica/openfoam Docker 镜像中文简介、标签列表与拉取命令">microfluidica/openfoam 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# OpenFOAM的Docker镜像

包含OpenFOAM两大主要发行版的Docker镜像。提供多个版本，支持amd64和arm64架构。

## 使用方法

### 使用`docker run`

假设已安装Docker，以下命令将运行镜像并挂载当前目录，以便访问其中的文件。

```bash
docker run --rm -it -v $PWD:/root -w /root docker.xuanyuan.run/microfluidica/openfoam:标签名
```

将`标签名`替换为下文列出的所需标签（或留空标签以使用`latest`标签）。

### 使用OpenFOAM的`openfoam-docker`启动脚本

```bash
openfoam-docker -image=microfluidica/openfoam:标签名
```

### 使用Apptainer/Singularity

```bash
apptainer run docker://microfluidica/openfoam:标签名
```

### 作为基础镜像

通过创建如下`Dockerfile`，可将这些镜像用作基于OpenFOAM的项目的基础镜像：

```Dockerfile
FROM docker.xuanyuan.run/microfluidica/openfoam:标签名

COPY . /usr/local/src/myproject

RUN /usr/local/src/myproject/Allwmake -j -prefix=group \
 && /usr/local/src/myproject/Allwclean
```

## 可用标签

### openfoam.com

- `latest`, `com`, `2506`
- `slim`, `com-slim`, `2506-slim`
- `2412`
- `2412-slim`
- `2406`
- `2406-slim`
- `2312`
- `2312-slim`
- `2306`
- `2306-slim`
- `2212`
- `2212-slim`
- `2206`
- `2206-slim`
- `2112`
- `2112-slim`
- `2106`
- `2106-slim`
- `2012`（仅amd64）
- `2012-slim`（仅amd64）
- `2006`
- `2006-slim`
- `1912`（仅amd64）
- `1912-slim`（仅amd64）

`slim`镜像不包含源代码、开发工具（如编译器）或教程案例。

### openfoam.org

- `org`, `13`
- `12`
- `11`
- `10`（仅amd64）
- `9`（仅amd64）
- `8`（仅amd64）
- `7`（仅amd64）
- `6`（仅amd64）
- `5`（仅amd64）
