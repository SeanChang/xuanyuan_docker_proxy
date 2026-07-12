---
image: texlive/texlive
description: "全功能TeX Live镜像（每周更新）"
source: https://xuanyuan.cloud/zh/r/texlive/texlive
canonical: https://xuanyuan.cloud/zh/r/texlive/texlive
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/texlive/texlive" title="texlive/texlive Docker 镜像中文简介、标签列表与拉取命令">texlive/texlive 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# TeX Live Docker镜像

本仓库提供[TeX Live](http://tug.org/texlive/)的Dockerfile（完整安装所有包但不含文档），并包含执行常用辅助工具所需的必要组件（如Arara所需的Java、Biber和Xindy所需的Perl、Pygments所需的Python）。

请注意，我们仅提供部分历史版本以及对应TeX Live最新版本的镜像（标记为`latest`）。

### 使用方法

要在项目中使用这些镜像，只需在我们的[仓库](https://gitlab.com/islandoftex/images/texlive/container_registry)中查找镜像名称，然后使用：

```dockerfile
FROM ***-gitlab.xuanyuan.run/islandoftex/images/texlive:latest
```

或其他标签。

若需从Docker Hub拉取镜像，只需使用：

```dockerfile
FROM docker.xuanyuan.run/texlive/texlive:latest
```

或其他标签。

有关在Docker工作流中使用这些镜像的教程，请查看我们[wiki页面](https://gitlab.com/islandoftex/images/texlive/-/wikis/home)上列出的文章。

## 提供的镜像版本

对于每个版本`X`（如`latest`），我们提供以下变体：

* `X`：最小化TeX Live安装，不含文档和源码文件，但上述所有工具均可正常工作。
* `X-doc`：`X`的基础上添加文档文件。
* `X-src`：`X`的基础上添加源码文件。
* `X-doc-src`：`X`的基础上添加文档和源码文件。

若不确定如何选择，建议使用`X`，仅在必要时拉取较大镜像。尤其是文档文件会显著增加镜像体积。

## `latest`版本

我们的持续集成计划每周重建所有Docker镜像。因此，拉取`latest`镜像将获得至多一周前的TeX Live快照，包含所有包。可通过在容器内运行`tlmgr update --self --all`手动更新。

每周构建的镜像除标记为`latest`外，还会附加标签`TL{RELEASE}-{YEAR}-{MONTH}-{DAY}-{HOUR}-{MINUTE}`。若需可重现构建或遇到新版本 regression，可回退至特定日期的镜像（如`TL2019-2019-08-01-08-14`）。

## 历史版本

我们从2014年开始维护历史版本的镜像。如需更旧版本的TeX Live镜像，可提交功能请求，若有用户需求我们可能会考虑添加。

历史版本标记为`TL{YEAR}-historic`，例如2018年版本可拉取`TL2018-historic`、`TL2018-historic-doc`、`TL2018-historic-src`或`TL2018-historic-doc-src`。

> 关于`historic`标签：请注意，一个历史版本对应的`historic`标签镜像并非固定不变，我们会每月重建这些镜像以更新基础操作系统，避免包含过于陈旧的软件。

## 许可信息

Dockerfile和测试文件遵循MIT许可证。本仓库提供的预构建Docker镜像则遵循其捆绑软件的再分发条件。
