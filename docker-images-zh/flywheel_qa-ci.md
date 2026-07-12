---
image: flywheel/qa-ci
description: "提供标准化开发工作流与持续集成管道，结合pre-commit实现本地代码检查（如linting、格式化）和GitLab CI自动化集成，支持多种代码检查工具，确保跨环境一致性与开发效率。"
source: https://xuanyuan.cloud/zh/r/flywheel/qa-ci
canonical: https://xuanyuan.cloud/zh/r/flywheel/qa-ci
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/flywheel/qa-ci" title="flywheel/qa-ci Docker 镜像中文简介、标签列表与拉取命令">flywheel/qa-ci 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# QA/CI - pre-commit钩子与GitLab CI模板

提供标准化的开发工作流和持续集成管道，通过以下工具实现：

- [pre-commit](https://pre-commit.com/)：用于在本地运行代码检查工具
- [GitLab CI](https://docs.gitlab.com/ee/ci/)：在CI中执行相同检查，然后发布制品并运行进一步自动化流程

## 目录

[TOC]

## 概述

本镜像旨在标准化开发流程，通过容器化的pre-commit钩子和GitLab CI模板，减少开发环境配置时间，提高跨开发者机器和CI runner的可重复性。核心价值在于统一代码检查标准、自动化集成流程，以及支持多种项目类型（Python应用、Docker镜像、Python库等）的开箱即用管道。

## 核心功能与特性

- **多工具集成**：支持12种以上代码检查工具（eolfix、hadolint、ruff等），覆盖文本格式、Dockerfile、JSON、YAML、Python代码等多种类型文件
- **容器化钩子**：所有pre-commit钩子均容器化，最小化环境依赖，确保检查结果一致
- **灵活配置**：钩子可自定义参数、禁用、扩展第三方钩子或添加本地钩子
- **完整CI/CD管道**：提供测试、发布、版本管理、依赖更新全流程模板
- **多项目支持**：适配Python应用（带Dockerfile和Helm chart）、独立Docker镜像、Python库等场景

## 使用场景

- Python应用项目（包含Dockerfile和Helm chart，需集成到Flywheel umbrella chart）
- 独立Docker镜像项目（无应用逻辑，仅提供工具或基础镜像）
- Python库项目（需发布到PyPI或GitLab Package Registry）

## 使用方法

### 前提条件

确保已安装以下工具：

```bash
brew install bash docker pre-commit  # macOS使用Homebrew
# 其他系统请通过对应包管理器安装（如apt、yum等）
```

### 步骤1：创建.pre-commit-config.yaml

**适用于容器化Python应用的推荐钩子配置**  
详细选项参见[pre-commit](#pre-commit)部分。

```yaml
repos:
  - repo: https://gitlab.com/flywheel-io/tools/etc/qa-ci
    rev: main  # 建议固定到具体版本而非main分支
    hooks:
      - id: eolfix           # 修复行尾格式
      - id: hadolint         # Dockerfile检查
      - id: helmcheck        # Helm chart检查
      - id: jsonlint         # JSON文件检查
      - id: linkcheck        # 链接有效性检查
      - id: markdownlint     # Markdown格式检查
      - id: poetry_export    # Poetry依赖导出
      - id: ruff             # Python代码静态分析
      - id: ruff_format      # Python代码格式化
      - id: ruff_tests       # Python测试代码静态分析
      - id: shellcheck       # Shell脚本检查
      - id: yamllint         # YAML文件检查
```

### 步骤2：创建.gitlab-ci.yml

**适用于容器化Python应用的推荐CI配置**  
详细选项参见[GitLab CI](#gitlab-ci)部分。

```yaml
include:
  - project: flywheel-io/tools/etc/qa-ci
    ref: main  # 建议固定到具体版本而非main分支
    file: ci/app.yml
```

### 步骤3：更新引用（重要）

将上述两个文件中的`main`引用更新为不可变版本（如具体commit SHA或tag），确保pre-commit和GitLab CI使用同步的版本：

```bash
pre-commit try-repo https://gitlab.com/flywheel-io/tools/etc/qa-ci autoupdate
```

### 验证与使用

```bash
pre-commit run -a  # 手动运行所有钩子检查
pre-commit install  # 安装git钩子，提交前自动运行检查
```

## pre-commit

pre-commit钩子帮助在代码提交前识别问题，如无效YAML语法、非标准代码格式或失败的测试。统一的命令入口降低跨项目切换成本，促进代码标准化和CI自动化。

### 钩子配置

- **基础配置**：通过`.pre-commit-config.yaml`定义，推荐使用[步骤1](#步骤1创建pre-commit-configyaml)中的配置作为起点
- **覆盖默认参数**：通过`args`自定义钩子行为，例如：
  ```yaml
  hooks:
    - id: ruff
      args: [--select, "PL"]  # 仅检查PL规则（pylint兼容规则）
  ```
- **查看工具帮助**：通过Docker运行钩子镜像获取详细参数：
  ```bash
  docker run -it --rm docker.xuanyuan.run/flywheel/qa-ci ruff --help
  ```
- **禁用钩子**：注释掉不需要的钩子：
  ```yaml
  hooks:
  # - id: shellcheck  # 注释掉以禁用shellcheck
  ```
- **扩展钩子**：添加第三方或本地钩子：
  ```yaml
  # 添加第三方钩子（放在qa-ci钩子之后）
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.3.0
    hooks:
      - id: trailing-whitespace  # 移除行尾空格
  ```
- **移除无关钩子**：删除与项目无关的钩子（如纯Python项目可移除`helmcheck`）

### 支持的钩子

所有钩子均容器化，详细配置可参见[.pre-commit-hooks.yaml](.pre-commit-hooks.yaml)。部分钩子可能修改文件（如格式化工具），此时需提交修改后重新运行。

#### eolfix

修复文本文件的行尾，强制使用LF（Unix风格）并确保文件末尾有且仅有一个LF。

**链接**：[scripts/eolfix.py](scripts/eolfix.py)

#### hadolint

使用hadolint检查`Dockerfile`是否符合最佳实践，内置shellcheck检查`RUN`指令中的shell脚本。

**链接**：  
- [hadolint](https://github.com/hadolint/hadolint)  
- [Dockerfile最佳实践](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

#### helmcheck

通过自定义脚本`helmcheck.sh`对Helm chart进行文档生成、 lint、测试和安全扫描：  
1. 使用helm-docs生成chart README  
2. 结合测试值渲染模板，运行yamllint、helm lint、kubeconform和kubesec检查  

**测试值文件**：放置于`helm/<项目>/tests/`（如`helm/my-app/tests/test_nodeport.yaml`），无自定义测试时使用默认值。

**链接**：  
- [scripts/helmcheck.sh](scripts/helmcheck.sh)  
- [helm-docs](https://github.com/norwoodj/helm-docs)  
- [kubeconform](https://github.com/yannh/kubeconform)

#### jsonlint

检查JSON文件语法、缩进和风格，自动格式化`.json`文件为2空格缩进。

**链接**：[jsonlint](https://github.com/kevcenteno/jsonlint)

#### linkcheck

通过自定义脚本`linkcheck.py`检查文本文件中的无效链接：  
- 忽略无顶级域名（如`localhost`）、`.local`/`.test`域名及内部测试域名  
- 支持`--ignore`参数排除特定链接  
- 除HTTP链接外，还检查Markdown中的标题/文件引用  

**响应码处理**：  
- `2xx`（成功）、`401`（未授权）、`403`（禁止访问）视为有效  
- GitLab私有仓库链接返回`503`时视为有效  

**链接**：[scripts/linkcheck.py](scripts/linkcheck.py)

#### markdownlint

检查Markdown文件的语法、行长度和风格，自动格式化`.md`文件。默认配置：  
- 最大行长度88  
- 允许内联HTML（如`<br/>`）  

自定义配置需创建`.markdownlint-cli2.yaml`文件。

**链接**：  
- [markdownlint](https://github.com/DavidAnson/markdownlint)  
- [GitLab Flavored Markdown](https://docs.gitlab.com/ee/user/markdown.html)

#### poetry_export

将Python依赖从`pyproject.toml`导出为`requirements.txt`格式：  
- 生产依赖 → `requirements.txt`  
- 开发依赖（含`all` extras） → `requirements-dev.txt`  

**要求**：项目需使用poetry管理依赖；如有extras，必须包含`all` extras。

**链接**：  
- [poetry](https://github.com/python-poetry/poetry)  
- [scripts/poetry_export.sh](scripts/poetry_export.sh)

#### ruff

Python静态分析工具，替代isort（导入排序）、pylint（代码质量）和pydocstyle（文档字符串）。

**链接**：  
- [ruff](https://github.com/astral-sh/ruff)  
- [Google Python风格指南](https://google.github.io/styleguide/pyguide.html)

#### ruff_format

使用ruff格式化Python代码，统一空格和风格（如缩进、换行）。

**链接**：[ruff format](https://docs.astral.sh/ruff/formatter/)

#### ruff_tests

针对Python测试代码的ruff检查，使用较宽松的默认规则。

#### shellcheck

Shell脚本静态分析工具，检查语法错误、最佳实践和潜在问题。

**链接**：  
- [shellcheck](https://github.com/koalaman/shellcheck)  
- [Bash最佳实践](https://kvz.io/blog/bash-best-practices.html)

#### yamllint

检查YAML文件语法、缩进和风格，自动格式化`.yaml`文件为2空格缩进，强制最大行长度88。

**链接**：  
- [yamllint](https://github.com/adrienverge/yamllint)  
- [YAML多行字符串语法](https://yaml-multiline.info/)

## GitLab CI

GitLab CI通过[阶段（stages）](https://docs.gitlab.com/ee/ci/yaml/#stage)将作业分组，同阶段作业并行执行，阶段按顺序运行。

### 阶段定义

```yaml
stages:
  - test     # 运行pre-commit检查
  - publish  # 推送制品（Docker/Helm/Poetry/Pages）
  - release  # 自动创建版本MR和标签
  - update   # 自动更新依赖和配置文件
```

### 完整管道模板

提供三种开箱即用的管道模板，适用于不同项目类型：

#### Flywheel应用组件

适用于包含`Dockerfile`和Helm chart、需集成到Flywheel [umbrella](https://gitlab.com/flywheel-io/infrastructure/umbrella) chart的Python应用。

**配置**：
```yaml
include:
  - project: flywheel-io/tools/etc/qa-ci
    ref: main  # 使用具体版本替代main
    file: ci/app.yml
```

#### 独立Docker镜像

适用于无应用逻辑、仅作为工具或基础镜像的Docker项目。

**配置**：
```yaml
include:
  - project: flywheel-io/tools/etc/qa-ci
    ref: main  # 使用具体版本替代main
    file: ci/img.yml
```

#### Python库

适用于发布到PyPI（开源）或GitLab Package Registry（私有）的Python库。

**配置**：
```yaml
include:
  - project: flywheel-io/tools/etc/qa-ci
    ref: main  # 使用具体版本替代main
    file: ci/lib.yml
```

### 作业模板

通过包含`ci/templates.yml`自定义CI作业，而非使用完整管道：

```yaml
include:
  - project: flywheel-io/tools/etc/qa-ci
    ref: main
    file: ci/templates.yml

# 示例：仅运行Docker构建作业
build:docker:
  extends: .build:docker
```

#### .build:docker

**功能**：构建Docker镜像并推送到GitLab容器 registry，标签为`$CI_REGISTRY_IMAGE:$CI_PIPELINE_ID`  
**触发条件**：存在`Dockerfile`时，在MR、main分支提交、标签推送时运行  
**前提**：项目需启用容器 registry（设置路径：General > Visibility, project features, permissions）

#### .test:pre-commit

**功能**：运行`.pre-commit-config.yaml`中定义的所有钩子，支持pytest覆盖率报告  
**触发条件**：所有分支和标签推送时运行

#### .publish:docker

**功能**：拉取GitLab registry中的构建镜像，重新标记并推送到Docker Hub  
**触发条件**：存在`Dockerfile`时，在MR、main分支提交、标签推送时运行  
**标签规则**：

| 触发源 | 标签格式               | 示例                  | 类型       |
|--------|------------------------|-----------------------|------------|
| MR     | `<分支名>`             | `FLYW-123-feat`       | 滚动版本   |
| main   | `latest`               | `latest`              | 滚动版本   |
| main   | `<分支名>.<SHA>`       | `main.d34db33f`       | 不可变版本 |
| 标签   | `<标签名>`             | `1.2.3`               | 不可变版本 |

**配置变量**：

| 变量名        | 默认值                | 描述                  |
|---------------|-----------------------|-----------------------|
| `DOCKER_FILE` | `Dockerfile`          | Dockerfile文件名      |
| `DOCKER_IMAGE`| `flywheel/<项目名>`   | Docker Hub镜像名      |

#### .publish:helm

**功能**：构建Helm chart并推送到[Flywheel ChartMuseum](https://helm.dev.flywheel.io/index.yaml)  
**触发条件**：存在`helm/*/Chart.yaml`时，在MR、main分支提交、标签推送时运行  
**版本规则**：

| 触发源 | 版本格式                                  | 示例                                  | 类型       |
|--------|-------------------------------------------|---------------------------------------|------------|
| MR     | `<当前版本>-<分支名>`                     | `1.2.3-FLYW-123-feat`                 | 滚动版本   |
| main   | `<当前版本>-latest`                       | `1.2.3-latest`                        | 滚动版本   |
| main   | `<当前版本>-<分支名>.<日期>.<构建号>+<SHA>` | `1.2.3-main.20220101.456+d34db33f`    | 不可变版本 |
| 标签   | `<标签名>`                                | `1.2.3`                               | 不可变版本 |

**配置变量**：

| 变量名       | 默认值 | 描述                                  |
|--------------|--------|---------------------------------------|
| `GIT_DEPTH`  | `100`  | 获取版本历史的提交数量（用于确定`<当前版本>`） |

#### .publish:pages

**功能**：将`public/`目录中的静态HTML文档发布到[GitLab Pages](https://docs.gitlab.com/ee/user/project/pages/)  
**触发条件**：`public/`目录存在时，在main分支提交和标签推送时运行  

#### .publish:poetry

**功能**：将Python库发布到PyPI（需配置PyPI凭证）  

#### .release:mr

**功能**：创建`release-X.Y.Z`分支和MR，自动更新`pyproject.toml`、Helm chart等文件中的版本号  
**触发条件**：手动触发管道时，设置`RELEASE=X.Y.Z`变量（`X.Y.Z`为目标版本）  
**MR内容**：包含基于上次版本以来合并的MR生成的变更日志，以及引用的JIRA工单列表  
**配置变量**：

| 变量名        | 默认值 | 描述                                  |
|---------------|--------|---------------------------------------|
| `FW_COMPONENT`| `""`   | 设置为`true`以启用umbrella版本同步     |

#### .release:tag

**功能**：创建带注释的Git标签  
**触发条件**：`release-X.Y.Z`分支合并到main或热修复分支时运行  
**效果**：触发后续制品发布管道

#### .update:deps

**功能**：创建`update-repo`分支和MR，自动更新项目依赖和配置文件  
**触发条件**：设置`UPDATE=true`时运行（建议通过[定时管道](https://docs.gitlab.com/ee/ci/pipelines/schedules.html)每2-4周运行一次，如`0 0 * * sun%4`表示每4个周日）  
**更新文件**：

| 文件路径                  | 描述                                  |
|---------------------------|---------------------------------------|
| `Dockerfile`              | 更新`FROM`中的基础镜像版本            |
| `pyproject.toml`          | 更新构建系统依赖，放宽`^0.X`版本约束  |
| `poetry.lock`             | 根据`pyproject.toml`更新依赖锁文件    |
| `requirements.txt`        | 更新导出的依赖文件                    |
| `.pre-commit-config.yaml` | 更新pre-commit仓库引用                |
| `.gitlab-ci.yml`          | 更新GitLab CI模板引用                 |

**配置变量**：

| 变量名        | 默认值 | 描述                                  |
|---------------|--------|---------------------------------------|
| `UPDATE_SKIP` | `""`   | 空格分隔的不更新文件列表（如`"Dockerfile pyproject.toml"`） |

## 许可证

[![MIT](https://img.shields.io/badge/license-MIT
