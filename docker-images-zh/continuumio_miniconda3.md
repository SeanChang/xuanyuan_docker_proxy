---
image: continuumio/miniconda3
description: "强大且灵活的包管理器"
source: https://xuanyuan.cloud/zh/r/continuumio/miniconda3
canonical: https://xuanyuan.cloud/zh/r/continuumio/miniconda3
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/continuumio/miniconda3" title="continuumio/miniconda3 Docker 镜像中文简介、标签列表与拉取命令">continuumio/miniconda3 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/continuumio/miniconda3" title="continuumio/miniconda3 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/continuumio/miniconda3</a>

# docker-miniconda

一个预安装Miniconda（基于Python 3.X）的Docker容器，可直接使用。

Miniconda发行版安装在`/opt/conda`目录，并确保默认用户的环境变量路径中包含`conda`命令。

Anaconda是领先的开放数据科学平台，由Python驱动。Anaconda的开源版本是高性能发行版，包含100多个最流行的数据科学Python包。此外，它还提供对720多个Python和R包的访问，这些包可通过conda依赖和环境管理器轻松安装（conda已包含在Anaconda中）。

## 使用方法

### 拉取并运行容器

您可以使用以下命令下载并运行此镜像：

```bash
docker pull continuumio/miniconda3
docker run -i -t continuumio/miniconda3 /bin/bash
```

### 启动Jupyter Notebook服务器

或者，您可以启动Jupyter Notebook服务器，通过浏览器与Miniconda交互：

```bash
docker run -i -t -p 8888:8888 continuumio/miniconda3 /bin/bash -c "
    conda install jupyter -y --quiet && 
    mkdir -p /opt/notebooks && 
    jupyter notebook 
    --notebook-dir=/opt/notebooks --ip='*' --port=8888 
    --no-browser --allow-root"
```

然后，您可以通过在浏览器中打开`http://localhost:8888`查看Jupyter Notebook；如果使用Docker Machine，则打开`http://<DOCKER-MACHINE-IP>:8888`。
