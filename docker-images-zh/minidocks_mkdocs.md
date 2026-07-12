---
image: minidocks/mkdocs
description: "这是一个包含多种主题、插件和Markdown扩展的MkDocs Docker镜像，用于快速构建美观的静态项目文档，支持Markdown源文件和YAML配置，满足多样化文档需求。"
source: https://xuanyuan.cloud/zh/r/minidocks/mkdocs
canonical: https://xuanyuan.cloud/zh/r/minidocks/mkdocs
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/minidocks/mkdocs" title="minidocks/mkdocs Docker 镜像中文简介、标签列表与拉取命令">minidocks/mkdocs 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MkDocs Docker镜像文档

![MkDocs Logo](https://www.fullstackpython.com/img/logos/mkdocs.jpg)

## 镜像概述和主要用途

[MkDocs](https://www.mkdocs.org/) 是一个快速、简单且美观的静态站点生成器，专门用于构建项目文档。文档源文件采用Markdown编写，通过单个YAML配置文件进行配置。本Docker镜像（[minidocks/mkdocs](https://hub.docker.com/r/minidocks/mkdocs)）预安装了多种主题、插件和Markdown扩展，旨在提供开箱即用的文档构建体验，简化项目文档的创建流程。

## 核心功能和特性

### 预安装主题

- **Material Design主题**：遵循Google Material Design设计规范的现代响应式主题（[Material Design theme](https://squidfunk.github.io/mkdocs-material/)）。
- **Alabaster主题**：视觉简洁、响应式、可配置的主题（[Alabaster theme](https://mkdocs-alabaster.ale.sh/)）。
- **KPN Theme**：KPN定制主题（[KPN Theme](https://kpn.github.io/mkdocs-kpn-theme/)）。

### 预安装插件

#### 通用插件

- **Absolute to relative link**：将绝对链接转换为相对链接（[Absolute to relative link](https://github.com/sander76/mkdocs-abs-rel-plugin)）。
- **Add number**：自动为每个Markdown页面的标题（h1-h6）和导航编号（[Add number](https://github.com/ignorantshr/mkdocs-add-number-plugin)）。
- **Autolinks**：简化文档间的相对链接（[Autolinks](https://github.com/midnightprioriem/mkdocs-autolinks-plugin/)）。
- **Autorefs**：自动跨页面链接（[Autorefs](https://github.com/mkdocstrings/autorefs)）。
- **Awesome Pages plugin**：无需在`mkdocs.yml`中配置完整结构即可自定义导航（[Awesome Pages plugin](https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin)）。
- **Exclude**：使用Unix风格通配符或正则表达式排除文件（[Exclude](https://github.com/apenwarr/mkdocs-exclude)）。
- **Categories**：支持每页多分类并生成分类索引页（[Categories](https://github.com/EddyLuten/mkdocs-categories-plugin)）。
- **Gallery**：图片画廊功能（[Gallery](https://smarie.github.io/mkdocs-gallery/)）。
- **Gen files**：构建时程序化生成文档页面（[Gen files](https://oprypin.github.io/mkdocs-gen-files/)）。
- **Git authors**：显示Git作者信息（[Git authors](https://github.com/timvink/mkdocs-git-authors-plugin)）。
- **Git committers**：显示Git提交者信息（[Git committers](https://github.com/ojacques/mkdocs-git-committers-plugin-2)）。
- **Git revision date**：显示Git修订日期（[Git revision date](https://github.com/timvink/mkdocs-git-revision-date-localized-plugin)）。
- **Merge plugin**：合并多个MkDocs站点为一个主站点的子站点（[Merge plugin](https://github.com/ovasquez/mkdocs-merge)）。
- **Enumerate headings**：跨站点页面自动编号标题（h1-h6）（[Enumerate headings](https://github.com/timvink/mkdocs-enumerate-headings-plugin)）。
- **Img2Fig**：将`<img>`转换为`<figure>`标签（[Img2Fig](https://github.com/stuebersystems/mkdocs-img2fig-plugin)）。
- **Kroki**：集成Kroki生成图表（[Kroki](https://github.com/AVATEAM-IT-SYSTEMHAUS/mkdocs-kroki-plugin)）。
- **Literate Nav**：使用Markdown而非YAML指定导航（[Literate Nav](https://oprypin.github.io/mkdocs-literate-nav/)）。
- **Macros**：将Markdown页面转换为支持变量、宏和自定义过滤器的Jinja2模板（[Macros](https://github.com/fralau/mkdocs_macros_plugin)）。
- **Markdown extra data**：将mkdocs.yml中的extra变量注入Markdown模板（[Markdown extra data](https://github.com/rosscdh/mkdocs-markdownextradata-plugin)）。
- **Minify**：压缩HTML和/或JS文件（[Minify](https://github.com/byrnereese/mkdocs-minify-plugin)）。
- **Mkdocstrings**：从源代码自动生成文档（[Mkdocstrings](https://mkdocstrings.github.io/)）。
- **Mkdocs with Confluence**：通过Confluence REST API上传Markdown文档到Confluence（[Mkdocs with Confluence](https://github.com/pawelsikora/mkdocs-with-confluence/)）。
- **Monorepo**：在单个MkDocs中构建多个文档，适用于大型代码库（[Monorepo](https://github.com/spotify/mkdocs-monorepo-plugin)）。
- **Multirepo**：将多个仓库的文档构建为一个站点（[Multirepo](https://github.com/jdoiro3/mkdocs-multirepo-plugin)）。
- **Nav weight**：以更Markdown化的方式组织导航（[Nav weight](https://github.com/shu307/mkdocs-nav-weight)）。
- **Neoterot plugins**：Neoterot开发的插件集合（[Neoterot plugins](https://www.neoteroi.dev/mkdocs-plugins/)）。
- **No sitemap**：禁用站点地图生成（[No sitemap](https://github.com/leonardehrenfried/mkdocs-no-sitemap-plugin)）。
- **Print site**：添加合并所有页面的打印页，支持导出为PDF（[Print site](https://timvink.github.io/mkdocs-print-site-plugin/index.html)）。
- **Publisher**：发布相关功能（[Publisher](https://mkusz.github.io/mkdocs-publisher/)）。
- **Pymdownx Material Extras**：Material主题的额外扩展（[Pymdownx Material Extras](https://github.com/facelessuser/mkdocs_pymdownx_material_extras)）。
- **Safe text**：安全文本编辑支持（[Safe text](https://github.com/raimon49/mkdocs-safe-text-plugin)）。
- **Same dir**：允许mkdocs.yml与文档放在同一目录（[Same dir](https://oprypin.github.io/mkdocs-same-dir/)）。
- **Simple hooks**：自定义MkDocs钩子（[Simple hooks](https://github.com/aklajnert/mkdocs-simple-hooks)）。
- **Simple**：从仓库中分散的Markdown文件构建文档（[Simple](https://www.althack.dev/mkdocs-simple-plugin)）。
- **Swagger UI**：集成Swagger UI（[Swagger UI](https://blueswen.github.io/mkdocs-swagger-ui-tag/)）。
- **Redirects**：创建页面重定向（[Redirects](https://github.com/datarobot/mkdocs-redirects)）。

#### 仅在`pdf`和`1-pdf`标签中包含的插件

- **PDF export**：使用WeasyPrint将所有Markdown页面导出为PDF文件（[PDF export](https://github.com/zhaoterryy/mkdocs-pdf-export-plugin)）。
- **PDF generate**：从MkDocs仓库生成单个PDF文件（[PDF generate](https://github.com/orzih/mkdocs-with-pdf)）。

### Markdown扩展

- **Customblocks**：支持可参数化和可嵌套的自定义组件标记（[Customblocks](https://github.com/vokimon/markdown-customblocks)）。
- **Include**：允许包含其他Markdown文档内容（[Include](https://github.com/cmacmackin/markdown-include/)）。
- **Pygments**：通用语法高亮工具（[Pygments](http://pygments.org/)）。
- **PyMdown Extensions**：Python Markdown的扩展集合（[PyMdown Extensions](https://facelessuser.github.io/pymdown-extensions/)）。
- **Mdx Truly Sane Lists**：优化列表缩进和换行（[Mdx Truly Sane Lists](https://github.com/radude/mdx_truly_sane_lists)）。
- **Breakless Lists Markdown Extension**：无需在列表上方换行即可使用列表（[Breakless Lists Markdown Extension](https://github.com/adamb70/mdx-breakless-lists)）。

## 使用场景和适用范围

- 快速构建项目文档，需要美观的静态站点。
- 需要多样化主题选择（如Material Design、Alabaster等）。
- 需要丰富的插件功能，如自动编号、Git信息显示、导航自定义等。
- 需要将文档导出为PDF文件（使用`pdf`或`1-pdf`标签）。
- 管理多仓库或单仓库中的多个文档（使用Monorepo/Multirepo插件）。
- 需要将文档上传到Confluence（使用Mkdocs with Confluence插件）。

## 使用方法和配置说明

### 创建新项目

在当前目录下创建名为`doc`的文档项目：

```bash
docker run --rm -v "`pwd`:/app" -w /app docker.xuanyuan.run/minidocks/mkdocs new doc
```

### 启动文档服务器

在`doc`目录中启动服务器，端口8000，使用Material Design主题：

```bash
docker run --rm -v "`pwd`:/app" -w /app/doc -p 8000:8000 docker.xuanyuan.run/minidocks/mkdocs serve -a 0.0.0.0:8000 -t material
```

## 标签

| 标签         | 大小                                                                                                             |
|--------------|------------------------------------------------------------------------------------------------------------------|
| latest, 1    | ![](https://img.shields.io/docker/image-size/minidocks/mkdocs/latest?style=flat-square&logo=docker&label=size)   |
| 1            | ![](https://img.shields.io/docker/image-size/minidocks/mkdocs/1?style=flat-square&logo=docker&label=size)        |
| 1-pdf        | ![](https://img.shields.io/docker/image-size/minidocks/mkdocs/1-pdf?style=flat-square&logo=docker&label=size)    |
| pdf          | ![](https://img.shields.io/docker/image-size/minidocks/mkdocs/pdf?style=flat-square&logo=docker&label=size)      |

## 相关镜像

- [Sphinx](https://github.com/minidocks/sphinx-doc)

## 替代方案

- https://github.com/raspberryvalley/docker-mkdocs
- https://github.com/pozgo/docker-mkdocs
- https://github.com/squidfunk/mkdocs-material
