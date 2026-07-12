---
image: jetbrains/writerside-builder
description: "Writerside Builder是用于构建和管理技术文档的Docker镜像，支持结构化文档创作、格式转换及导出，助力高效生成专业技术文档。"
source: https://xuanyuan.cloud/zh/r/jetbrains/writerside-builder
canonical: https://xuanyuan.cloud/zh/r/jetbrains/writerside-builder
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jetbrains/writerside-builder" title="jetbrains/writerside-builder Docker 镜像中文简介、标签列表与拉取命令">jetbrains/writerside-builder 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Writerside Builder Docker镜像文档


## 一、镜像概述和主要用途

**Writerside Builder** 是用于构建 Writerside 文档的 Docker 镜像，提供容器化环境以生成适配不同平台的文档 artifacts。其核心功能是通过 `helpbuilderinspect` 命令行工具，读取文档源码并输出结构化文档，支持与 CI/CD 流程集成，确保跨环境构建一致性。


## 二、核心功能和特性

- **多平台适配**：支持生成 TeamCity、GitLab、GitHub 专用 artifacts 及通用环境 artifacts。  
- **环境自动准备**：内置 Xvfb 虚拟显示服务，无需物理显示设备即可运行 GUI 依赖的构建流程。  
- **灵活目录挂载**：支持挂载本地源码目录和输出目录，实现构建结果的本地持久化。  
- **容器临时运行**：默认配置 `--rm` 选项，构建完成后自动清理容器，减少资源占用。  


## 三、使用场景和适用范围

- **CI/CD 流水线集成**：在 GitHub Actions、GitLab CI、TeamCity 等持续集成环境中自动化构建文档。  
- **本地文档构建**：开发者在本地环境快速验证文档构建效果，无需手动配置依赖。  
- **跨环境一致构建**：通过容器化消除环境差异，确保不同机器或平台输出统一的文档 artifacts。  


## 四、使用方法和配置说明

### 4.1 前置要求

- 已安装 Docker 环境（Docker Engine 20.10+ 或兼容版本）。  
- 本地存在 Writerside 文档项目源码（需包含可构建的文档实例）。  


### 4.2 基本运行命令

从项目根目录执行以下命令，构建默认实例 `hi`（以通用 artifacts 为例）：

```bash
docker run --rm -v .:/opt/sources \
docker.xuanyuan.run/jetbrains/writerside-builder:242.21870 \
/bin/bash -c "
export DISPLAY=:99 &&
Xvfb :99 &
/opt/builder/bin/idea.sh helpbuilderinspect \
--source-dir /opt/sources \
--product Writerside/hi \
--runner other \
--output-dir /opt/sources/output
"
```


### 4.3 命令解析

#### 4.3.1 目录挂载

- 通过 `-v .:/opt/sources` 将当前目录（项目根目录）挂载到容器内 `/opt/sources`，作为文档源码目录。  
- 如需指定独立输出目录，可添加额外挂载参数，例如：`-v /local/output:/opt/output`（本地目录 `/local/output` 映射到容器内 `/opt/output`）。  


#### 4.3.2 环境准备

容器启动时自动执行以下步骤，确保构建环境可用：  
1. 设置 `DISPLAY=:99` 环境变量，指定虚拟显示端口。  
2. 后台运行 `Xvfb :99`，启动虚拟显示服务（解决 GUI 依赖问题）。  


#### 4.3.3 执行构建

通过 `/opt/builder/bin/idea.sh helpbuilderinspect` 命令启动构建，核心参数说明：  
- `--source-dir /opt/sources`：指定源码目录（容器内路径，对应本地挂载目录）。  
- `--product Writerside/hi`：指定构建的模块和实例（格式为 `模块/实例`）。  
- `--runner other`：指定输出 artifacts 类型（通用环境）。  
- `--output-dir /opt/sources/output`：指定输出目录（容器内路径，对应本地挂载目录下的 `output` 文件夹）。  


#### 4.3.4 容器清理

命令中 `--rm` 参数确保构建完成后自动删除容器，避免残留临时容器。


### 4.4 `helpbuilderinspect` 命令选项

| 选项（全称）   | 选项（简称） | 描述                                                                 | 参数示例                          |
|----------------|--------------|----------------------------------------------------------------------|-----------------------------------|
| `--source-dir` | `-i`         | 指定文档源码目录（容器内路径，需与挂载目录对应）                     | `/opt/sources`                    |
| `--product`    | `-p`         | 指定构建的模块和实例，格式为 `模块/实例`                             | `Writerside/hi`                   |
| `--runner`     | `-r`         | 指定构建环境，大小写不敏感，可选值：<br>- `teamcity`（默认，TeamCity 专用）<br>- `gitlab`（GitLab 专用）<br>- `github`（GitHub 专用）<br>- `other`（通用 artifacts） | `github`                          |
| `--output-dir` | `-o`         | 指定文档输出目录（容器内路径，需与挂载目录对应）                     | `/opt/sources/output` 或 `/opt/output` |


## 五、输出说明

构建完成后，生成的文档 artifacts 会保存至 `--output-dir` 指定的目录（对应本地挂载的输出目录）。例如，上述命令中输出文件将位于本地项目根目录下的 `output` 文件夹内。
