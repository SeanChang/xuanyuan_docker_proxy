---
image: pandoc/latex
description: "这是官方pandoc镜像，集成了pandoc核心工具、pandoc-crossref交叉引用插件及最小化LaTeX安装环境，支持多种文档格式的转换与排版，尤其适用于需处理交叉引用（如图表、公式引用）及利用LaTeX进行复杂排版的场景，为用户提供轻量且功能完备的文档处理解决方案。"
source: https://xuanyuan.cloud/zh/r/pandoc/latex
canonical: https://xuanyuan.cloud/zh/r/pandoc/latex
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pandoc/latex" title="pandoc/latex Docker 镜像中文简介、标签列表与拉取命令">pandoc/latex 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Pandoc LaTeX 镜像


该镜像包含 [pandoc] （通用文档转换器）和基础 [LaTeX]  环境，适用于将其他格式文件转换为 PDF。  

结合 pandoc 与 LaTeX 是生成 PDF 的常用方案。本镜像内置 [TeX Live]  环境，包含使用 pandoc 默认选项生成 PDF 所需的全部依赖包。


## 快速参考

- **获取帮助**：[pandoc-discuss 邮件列表]   
- **问题反馈**：[]  
- **源码仓库**：GitHub 上的 [pandoc/dockerfiles]   
- **维护者**：[Albert Krewinkel] 、[Caleb Maclennan] 、[Damien Clochard]   


## 支持的标签

- `edge`  
- `3.7.0.2`、`3.7.0`、`3.7`、`3`、`latest`  
- `3.6.4.0`、`3.6.4`、`3.6`  
- `3.5.0.0`、`3.5.0`、`3.5`  
- `3.2.1.0`、`3.2.1`、`3.2`  


同一列表项中的标签指向同一镜像。数字标签支持“滚动更新”：版本前缀（如 `a.b`）会自动指向该前缀下的最新镜像，方便指定版本范围；若需固定特定版本，需使用全四部分版本号（如 `a.b.c.d`）。  

`latest` 标签对应最新发布版本，版本发布后镜像更新可能存在短暂延迟。`edge` 标签提供最新开发版本。  

所有标签均可后缀“栈标识符”（见下文“支持的系统栈”）。


### 关于 pandoc 版本号的说明

pandoc 既是可执行程序，也是 Haskell 库，因此版本号遵循 [Haskell 包版本政策] 。即使是小版本更新，若 API 未变，偶尔可能引入新功能（但此情况较少见）。


## 支持的系统栈

所有标签可后缀“系统栈标识符”（如 `latest-ubuntu`），用于指定操作系统。可选系统栈：  

- **alpine**：基于 [Alpine]  Linux（默认）  
- **ubuntu**：基于 [Ubuntu]  Linux  


## 运行 pandoc Docker 容器

### 基础命令示例  
以下命令将当前目录的 `README.md` 转换为 `outfile.epub`（换行仅为可读性）：  

```sh
docker run --rm \
       --volume "$(pwd):/data" \
       --user $(id -u):$(id -g) \
       docker.xuanyuan.run/pandoc/latex README.md -o outfile.epub
```  

#### 参数说明：  
- **Docker 选项**（镜像名前）：  
  - `--volume "$(pwd):/data"`：将本地当前目录（左侧）映射到容器内 `/data` 目录（右侧），确保源文件可被 pandoc 访问（`$(pwd)` 加引号避免文件名含空格时出错）。  
  - `--user $(id -u):$(id -g)`：指定容器内执行 pandoc 的用户 ID 和组 ID，避免输出文件权限问题（默认容器内用户可能与本地用户不同）。  

- **pandoc 选项**（镜像名后）：如 `-o outfile.epub` 指定输出文件。  


### 便捷 alias 设置  
频繁使用时，建议设置 shell 别名：  

```sh
alias pandock='docker run --rm -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/latex'
```  

之后可直接用 `pandock README.md -o outfile.pdf` 执行转换。


## TeXLive 版本对应表  

镜像中 TeXLive 版本与 pandoc 版本绑定，如下表所示：  

| pandoc 版本 | 标签                          | TeXLive 版本 |
|-------------|-------------------------------|--------------|
| main        | edge                          | -            |
| 3.7.0.2     | 3.7.0.2、3.7.0、3.7、3、latest | 2025         |
| 3.6.4       | 3.6.4.0、3.6.4、3.6           | 2024         |
| 3.5         | 3.5.0.0、3.5.0、3.5           | 2024         |
| 3.2.1       | 3.2.1.0、3.2.1、3.2           | 2024         |  


#### 注意事项：  
由于 TeXLive 版本发布机制，基于本镜像构建衍生镜像时，若 TeXLive 版本刚冻结，可能出现问题。此时重新拉取最新基础镜像即可解决。


## 其他可用 pandoc 镜像  

除 `pandoc/latex` 外，还有以下镜像：  

- **pandoc/minimal**：仅含 pandoc 可执行文件的轻量镜像。  
- **pandoc/core**：基于 minimal，附加常用转换工具。  
- **pandoc/extra**：基于 latex 镜像，包含更多辅助工具、Tectonic 引擎及 Eisvogel 模板。  
- **pandoc/typst**：集成 [Typst]  排版系统。
