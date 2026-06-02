---
image: library/r-base
description: "R是一款开源的统计计算与图形绘制系统，具备强大的数据处理、分析、建模及可视化功能，拥有丰富的扩展包生态与活跃的全球社区支持，广泛应用于学术研究、数据分析、机器学习等领域，为用户提供从数据清洗到结果呈现的全流程解决方案。"
source: https://xuanyuan.cloud/zh/r/library/r-base
canonical: https://xuanyuan.cloud/zh/r/library/r-base
exported_at: 2026-06-02T12:18:45.496Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/r-base" title="library/r-base Docker 镜像中文简介、标签列表与拉取命令">library/r-base — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/r-base" title="library/r-base Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/r-base</a>

# R 镜像使用指南


## 快速参考

### 维护方  
[Rocker 社区]([])  


### 求助渠道  
[Docker 社区 Slack]([])、[Server Fault]([])、[Unix & Linux]([]) 或 [Stack Overflow]([])  


## 支持的标签及对应 Dockerfile 链接  
- [`4.5.1`, `latest`]([])  


## 快速参考（续）

### 问题反馈渠道  
[GitHub]([]) 或 [邮件](mailto:[邮箱已删除])  


### 支持的架构  
（[更多信息]([])）  
[`amd64`]([])、[`arm64v8`]([])、[`ppc64le`]([])、[`s390x`]([])  


### 镜像 artifact 详情  
[repo-info 仓库的 `repos/r-base/` 目录]([])（[历史记录]([])）  
（包含镜像元数据、传输大小等）  


### 镜像更新  
[official-images 仓库的 `library/r-base` 标签]([])  
[official-images 仓库的 `library/r-base` 文件]([])（[历史记录]([])）  


### 本文档来源  
[docs 仓库的 `r-base/` 目录]([])（[历史记录]([])）  


## 什么是 R？  
R 是一个统计计算与图形系统，由一门语言及运行时环境组成，包含图形功能、调试器、系统函数访问能力，以及运行脚本文件中程序的能力。  

R 语言被统计学家和数据挖掘者广泛用于开发统计软件和数据分析。近年来，其 popularity 显著提升。  

R 是 S 编程语言的实现，结合了受 Scheme 启发的词法作用域语义。S 由 John Chambers 在贝尔实验室创建；R 由新西兰奥克兰大学的 Ross Ihaka 和 Robert Gentleman 开发，目前由 R 开发核心团队（Chambers 为成员之一）维护。R 的命名部分源于两位创始者的名字，部分是对 S 语言的戏仿。  

R 是 GNU 项目，其源代码主要用 C、Fortran 和 R 编写，基于 GNU 通用公共许可证免费发布，提供预编译的二进制版本适配多种操作系统。R 默认使用命令行界面，也有多个图形用户界面可供选择。  

> 参考：[R FAQ]([])、[维基百科：R（编程语言）]()  

![logo]([])  


## 如何使用此镜像  

### 交互式 R  
直接启动 R 进行交互式操作：  
```console
$ docker run -ti --rm r-base
```  


### 批处理模式  
挂载工作目录以运行 R 批处理命令。建议指定非 root 用户挂载卷，避免权限变更，示例如下：  
```console
$ docker run -ti --rm -v "$PWD":/home/docker -w /home/docker -u docker r-base R CMD check .
```  

或先在容器中启动 bash 会话，便于运行批处理命令、编辑并执行脚本：  
```console
$ docker run -ti --rm r-base bash
$ vim.tiny myscript.R  # 在容器中编辑脚本
```  
退出 vim 后，执行：  
```console
$ Rscript myscript.R
```  


### Dockerfiles  
以 `r-base` 为基础构建自定义镜像。例如，以下 Dockerfile 可编译并运行项目：  
```dockerfile
FROM r-base
COPY . /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts
CMD ["Rscript", "myscript.R"]
```  

构建镜像：  
```console
$ docker build -t myscript /path/to/Dockerfile
```  

运行此容器时，默认执行脚本；也可按上述交互式或批处理方式运行，无需挂载卷。  

更多文档及示例场景见 [rocker-org 项目 wiki]([])。  


## 许可证  
查看 [R 项目许可证信息]([]) 了解镜像中包含的软件许可。  

与所有 Docker 镜像类似，本镜像可能包含其他软件（如基础发行版的 Bash 等，及主软件的直接/间接依赖），这些软件可能采用其他许可证。  

自动检测到的额外许可信息可在 [repo-info 仓库的 `r-base/` 目录]([]) 中找到。  

使用预构建镜像时，用户需自行确保对镜像中所有软件的使用符合相关许可证要求。
