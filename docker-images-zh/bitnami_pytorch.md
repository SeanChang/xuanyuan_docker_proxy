---
image: bitnami/pytorch
description: "比特纳米PyTorch安全镜像是一款为深度学习框架PyTorch量身打造的预配置、安全加固型容器镜像，集成经过严格测试的依赖组件，具备漏洞扫描、合规性检查及持续更新机制，可有效保障开发环境安全，简化从模型训练到部署的全流程，适用于科研机构、企业开发者在AI项目中快速构建稳定、安全的PyTorch运行环境。"
source: https://xuanyuan.cloud/zh/r/bitnami/pytorch
canonical: https://xuanyuan.cloud/zh/r/bitnami/pytorch
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bitnami/pytorch" title="bitnami/pytorch Docker 镜像中文简介、标签列表与拉取命令">bitnami/pytorch — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/bitnami/pytorch" title="bitnami/pytorch Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/bitnami/pytorch</a>

# Bitnami PyTorch 包介绍


## 什么是 PyTorch？

PyTorch 是一个深度学习平台，可加速从研究原型到生产部署的流程。Bitnami 镜像包含 Torchvision，提供特定的计算机视觉支持。

[PyTorch 官方概述]([])  
**商标说明**：本软件列表由 Bitnami 打包。所提及的相关商标归各自公司所有，使用此类商标不暗示任何关联或认可。


## 快速启动

```console
docker run -it --name pytorch bitnami/pytorch
```

这是由 Bitnami 构建和维护的硬化、最小化 CVE（常见漏洞和暴露）镜像。Bitnami 安全镜像基于云优化、安全硬化的企业级 [Photon Linux 操作系统]([])。选择 Bitnami 安全镜像的理由包括：  
- 主流开源软件的硬化安全镜像，近零漏洞  
- 结合漏洞利用交换声明（VEX Statements）、已知被利用漏洞（KEV）和利用预测评分系统（EPSS Scores）的漏洞分类与优先级划分  
- 聚焦合规性，支持 FIPS、STIG 和离线部署选项，包含安全物料清单（SBOM）  
- 通过 in-toto 实现软件供应链来源证明  
- 对社区热门 Helm 图表的一流支持  

每个镜像均附带详细安全元数据，可在 [Bitnami 公共目录]([]) 中查看。注：部分数据需 [Bitnami 安全镜像商业订阅]([]) 权限。  

如需基于 Debian Linux 的旧版镜像，可参考 Bitnami  Legacy 仓库。


## 为什么使用非 root 容器？

非 root 容器镜像增加了额外安全层，通常推荐用于生产环境。但由于以非 root 用户运行，特权任务通常受限。更多关于非 root 容器的信息可参考 [Bitnami 文档]([])。


## 支持的标签及对应 Dockerfile 链接

Bitnami 标签政策及滚动标签与不可变标签的区别，可参考 [官方文档]([])。  

不同标签的对应关系可通过分支文件夹中的 `tags-info.yaml` 文件查看，例如 `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`。  

可通过关注 [bitnami/containers GitHub 仓库]([]) 订阅项目更新。


## 获取镜像

获取 Bitnami PyTorch Docker 镜像的推荐方式是从 [Docker Hub 仓库]([]) 拉取预构建镜像：  

```console
docker pull bitnami/pytorch:latest
```

如需指定版本，可拉取带版本标签的镜像。可在 [Docker Hub 仓库]([]) 查看所有可用版本：  

```console
docker pull bitnami/pytorch:[TAG]  # 将 [TAG] 替换为具体版本号
```

如需手动构建镜像，可克隆仓库、进入 Dockerfile 所在目录并执行 `docker build` 命令（需替换以下命令中的 `APP`、`VERSION` 和 `OPERATING-SYSTEM` 占位符）：  

```console
git clone [] bitnami/APP/VERSION/OPERATING-SYSTEM
docker build -t bitnami/APP:latest .
```


## 进入 REPL

默认情况下，运行此镜像会直接进入 Python REPL，可在此交互式测试和使用 PyTorch：  

```console
docker run -it --name pytorch bitnami/pytorch
```


## 配置

### 运行 PyTorch 应用

PyTorch 镜像的默认工作目录为 `/app`。可将主机中的应用文件夹挂载至此目录，通过 `python` 命令运行脚本：  

```console
docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch \
  python script.py  # 将 /path/to/app 替换为主机应用目录，script.py 替换为脚本名
```

### 运行带依赖的 PyTorch 应用

若应用通过 `requirements.txt` 定义依赖，可先安装依赖再运行：  

```console
docker run -it --name pytorch -v /path/to/app:/app bitnami/pytorch \
  sh -c "conda install -y --file requirements.txt && python script.py"
```

**延伸阅读**：  
- [PyTorch 官方文档]([])  
- [Conda 官方文档]([])

### Bitnami 安全镜像的 FIPS 配置

[Bitnami 安全镜像]([]) 中的 PyTorch 镜像支持 FIPS 功能配置，可通过以下环境变量设置：  
- `OPENSSL_FIPS`：控制 OpenSSL 是否启用 FIPS 模式，可选值 `yes`（默认）或 `no`。


## 维护

### 升级镜像

Bitnami 会及时更新 PyTorch 版本（含安全补丁），建议按以下步骤升级容器：  

#### 步骤 1：获取更新镜像  
```console
docker pull bitnami/pytorch:latest
```  
（若使用 Docker Compose，将 `image` 属性值更新为 `bitnami/pytorch:latest`）

#### 步骤 2：移除当前运行容器  
```console
docker rm -v pytorch
```  
（或使用 Docker Compose：`docker-compose rm -v pytorch`）

#### 步骤 3：运行新镜像  
```console
docker run --name pytorch bitnami/pytorch:latest
```  
（或使用 Docker Compose：`docker-compose up pytorch`）


## 显著变更

### 1.9.0-debian-10-r3 版本  
此版本移除 miniconda，改用 pip 管理依赖。优化后容器体积更小，安全风险更低。基于此镜像扩展功能时，需将 conda 命令替换为 pip 命令。


## 使用 docker-compose.yaml 注意事项

请注意，此文件未经过内部测试，建议仅用于开发或测试环境。生产环境部署推荐使用配套的 [Bitnami Helm 图表]([])。  

若发现 `docker-compose.yaml` 文件问题，可按 [贡献指南]([]) 报告或提交修复。


## 贡献

欢迎为该 Docker 镜像贡献代码。可通过 [创建 issue]([]) 提出新功能需求，或 [提交 pull request]([]) 贡献代码。


## 问题反馈

若运行容器时遇到问题，可 [提交 issue]([])。为确保高效支持，请按模板填写必要信息。


## 许可证

版权所有 © 2025 Broadcom。“Broadcom” 指 Broadcom Inc. 及其子公司。  

根据 Apache 许可证 2.0 版（“许可证”）授权；除非遵守许可证，否则不得使用本文件。可在以下地址获取许可证副本：  

<[]>  

除非适用法律要求或书面同意，否则按“原样”分发软件，不提供任何明示或暗示的担保或条件。详见许可证以了解具体权限和限制。
