---
image: cgtr/tools
description: "包含用于流水线的开发及代码分析工具的Docker镜像，适用于开发和构建阶段。"
source: https://xuanyuan.cloud/zh/r/cgtr/tools
canonical: https://xuanyuan.cloud/zh/r/cgtr/tools
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cgtr/tools" title="cgtr/tools Docker 镜像中文简介、标签列表与拉取命令">cgtr/tools 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 如何使用此镜像

在您的PHP项目中创建Dockerfile

```
FROM docker.xuanyuan.run/cgtr/tools:latest
COPY . /srv
WORKDIR /srv
CMD [ "symfony", "serve" ]
```

然后运行构建和运行命令

```
$ docker build -t mon-appli:v1.2.3-dev .

$ docker run -it --rm -p "8000:8000" mon-appli:v1.2.3-dev
# 或者
$ docker run -it --rm -p "8000:8000" -v ${PWD}:/srv mon-appli:v1.2.3-dev
```

注意：此镜像仅设计用于开发和构建阶段，包含不应在最终环境中安装的组件。

# 已安装命令列表

## Symfony安装工具
## Composer
## PHP代码风格修复工具（PHP-CS-Fixer）
## PHP代码重复检测工具（PHPCPD）
## PHP依赖分析工具（PDepend）
## PHPUnit 7
## PHP代码行数统计工具（PHPLoc）
## PHP代码 metrics 分析工具（PHPMetrics）
## NodeJS 10
## Yarn
## Grunt
## JSHint（JavaScript代码检查工具）
## Less代码检查工具（Lesshint）
