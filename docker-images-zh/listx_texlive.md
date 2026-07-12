---
image: listx/texlive
description: "为大众提供的TexLive Docker镜像，方便快速部署和使用TeX排版系统，支持文档编译和PDF生成。"
source: https://xuanyuan.cloud/zh/r/listx/texlive
canonical: https://xuanyuan.cloud/zh/r/listx/texlive
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/listx/texlive" title="listx/texlive Docker 镜像中文简介、标签列表与拉取命令">listx/texlive 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# listx/texlive 镜像

[![](https://images.microbadger.com/badges/image/listx/texlive.svg)](https://microbadger.com/images/listx/texlive "在microbadger.com获取您自己的镜像徽章")

代码和README: https://github.com/listx/texlive-docker

## 镜像概述

listx/texlive是一个为大众设计的TexLive Docker镜像，提供便捷的TeX排版系统部署方案。该镜像封装了完整的TexLive环境，让用户无需复杂配置即可使用各种TeX工具。

## 核心功能

- 完整的TexLive环境，包含pdflatex等常用工具
- 无需手动配置TeX系统，开箱即用
- 支持多种文档格式的编译和PDF生成

## 使用场景

- 学术论文排版
- 技术文档编写
- 书籍和报告的专业排版
- 需要TeX环境的CI/CD流程集成

## 配置说明

> **注意**：该镜像没有`latest`标签！

部分镜像版本存在一个bug，需要先运行`mktexlsr`命令才能使用`pdflatex`等工具。不过最新的`2020`标签版本已经修复了这个问题。

## 部署示例

### 使用docker run运行

```bash
docker run --rm -v $(pwd):/workdir docker.xuanyuan.run/listx/texlive:2020 pdflatex your-document.tex
```

### 使用docker-compose

创建`docker-compose.yml`文件：

```yaml
version: '3'
services:
  texlive:
    image: docker.xuanyuan.run/listx/texlive:2020
    volumes:
      - ./documents:/workdir
    command: pdflatex your-document.tex
```

然后运行：

```bash
docker-compose up
```

这样就可以在当前目录的`documents`文件夹中处理LaTeX文档了。
