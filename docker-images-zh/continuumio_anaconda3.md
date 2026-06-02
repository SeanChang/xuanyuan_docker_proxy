---
image: continuumio/anaconda3
description: "最值得信赖的数据科学工具发行版，整合了数据处理、分析、建模及可视化等全流程所需的核心工具与库，凭借稳定可靠的性能、广泛的兼容性及持续的更新支持，成为全球数据科学家、研究人员及开发者日常工作中首选的一站式解决方案，赢得了行业内外的高度认可与信赖。"
source: https://xuanyuan.cloud/zh/r/continuumio/anaconda3
canonical: https://xuanyuan.cloud/zh/r/continuumio/anaconda3
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/continuumio/anaconda3" title="continuumio/anaconda3 Docker 镜像中文简介、标签列表与拉取命令">continuumio/anaconda3 — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/continuumio/anaconda3" title="continuumio/anaconda3 Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/continuumio/anaconda3</a>

# Anaconda3 Docker镜像


> 使用此镜像即表示您已确认并同意Anaconda Distribution安装程序适用的法律条款，详情参见：[] 镜像说明  
此Docker镜像包含预配置的Anaconda（基于Python 3.X）安装，可直接使用。Anaconda发行版安装在`/opt/conda`目录下，且默认用户的环境变量路径中已包含`conda`命令，无需额外配置即可直接调用。


## Anaconda简介  
Anaconda是领先的开源数据科学平台，基于Python构建。其开源版本为高性能发行版，内置100多个常用的Python数据科学包；同时，通过集成的conda依赖与环境管理器，可轻松安装720多个额外的Python和R包，满足各类数据科学开发需求。


## 使用指南  

### 1. 拉取并运行镜像  
通过以下命令下载镜像并启动容器：  
```bash
docker pull continuumio/anaconda3  # 拉取镜像
docker run -i -t continuumio/anaconda3 /bin/bash  # 启动交互式容器，进入bash终端
```


### 2. 启动Jupyter Notebook服务器  
若需通过浏览器使用Anaconda，可启动Jupyter Notebook服务器，步骤如下：  

执行以下命令（含安装Jupyter、创建工作目录、启动服务）：  
```bash
docker run -i -t -p 8888:8888 continuumio/anaconda3 /bin/bash -c "\
    conda install jupyter -y --quiet && \
    mkdir -p /opt/notebooks && \
    jupyter notebook \
    --notebook-dir=/opt/notebooks --ip='*' --port=8888 \
    --no-browser --allow-root"
```

#### 访问方式：  
- 本地环境：打开浏览器访问 `[]  
- Docker主机环境（如远程服务器或Docker Machine）：访问 `http://<DOCKER-MACHINE-IP>:8888`（需将`<DOCKER-MACHINE-IP>`替换为实际Docker主机IP）
