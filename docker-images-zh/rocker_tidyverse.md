<!-- xuanyuan-docker-images-zh
image: rocker/tidyverse
source: https://xuanyuan.cloud/zh/r/rocker/tidyverse
canonical: https://xuanyuan.cloud/zh/r/rocker/tidyverse
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/rocker/tidyverse" title="rocker/tidyverse Docker 镜像中文简介、标签列表与拉取命令">rocker/tidyverse — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/rocker/tidyverse" title="rocker/tidyverse Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rocker/tidyverse</a></p>

# RStudio版本化镜像文档

## 镜像概述

本镜像基于 [rocker-org/rocker-versioned2](https://github.com/rocker-org/rocker-versioned2) 项目构建，提供版本稳定的R、RStudio及R包集成环境。详细描述请参考官方文档：[rocker-project.org/images/versioned/rstudio.html](https://rocker-project.org/images/versioned/rstudio.html)。该镜像旨在为数据分析、统计建模和R语言开发提供一致、可复现的运行环境。

## 核心功能与特性

- **版本稳定性**：固定R、RStudio及核心R包版本，确保环境一致性，避免版本变更导致的兼容性问题
- **完整集成**：预装R、RStudio Server及常用R包（如tidyverse、ggplot2等），开箱即可使用
- **网页界面**：内置RStudio Server，可通过浏览器访问RStudio界面，无需本地安装
- **灵活配置**：支持通过环境变量自定义用户、密码等配置，适应不同使用场景
- **扩展性**：基于Debian系统，支持通过apt或R包管理器轻松扩展功能

## 使用场景与适用范围

- **数据分析项目开发**：提供稳定环境，确保团队协作时环境一致性
- **可复现研究**：固定软件版本，使研究结果可精确复现
- **教学与培训**：快速搭建统一的R语言教学环境，降低学员配置难度
- **CI/CD流程集成**：作为自动化测试环境，验证R代码在特定版本环境下的运行情况

## 使用方法与配置说明

### 基本使用（Docker Run）

通过以下命令启动镜像，映射RStudio Server端口（默认8787）并设置访问密码：

```bash
docker run -d -p 8787:8787 -e PASSWORD=yourpassword rocker/rstudio:latest
```

启动后，在浏览器中访问 `http://localhost:8787`，使用默认用户名 `rstudio` 和设置的密码登录。

### 持久化数据存储

挂载本地目录至容器，实现数据持久化：

```bash
docker run -d -p 8787:8787 -e PASSWORD=yourpassword -v /本地目录:/home/rstudio/project rocker/rstudio:latest
```

### Docker Compose配置示例

```yaml
version: '3'
services:
  rstudio:
    image: rocker/rstudio:latest
    ports:
      - "8787:8787"
    environment:
      - PASSWORD=yourpassword
      - USER=customuser  # 自定义用户名（可选）
      - USERID=1000      # 自定义用户ID（可选，需与本地用户ID匹配以避免权限问题）
    volumes:
      - ./data:/home/customuser/data  # 挂载数据目录
    restart: unless-stopped
```

### 环境变量配置

| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| `PASSWORD` | RStudio Server访问密码，必填 | 无 |
| `USER` | 自定义用户名 | `rstudio` |
| `USERID` | 用户ID，用于解决挂载目录的权限问题 | `1000` |
| `GROUPID` | 用户组ID | `1000` |
| `ROOT` | 是否允许root权限（`TRUE`/`FALSE`） | `FALSE` |

### 版本选择

镜像支持通过标签指定R版本，例如使用R 4.3.0版本：

```bash
docker run -d -p 8787:8787 -e PASSWORD=yourpassword rocker/rstudio:4.3.0
```

具体版本标签可参考 [rocker-org/rocker-versioned2](https://github.com/rocker-org/rocker-versioned2) 项目的发布页面。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/rocker/tidyverse" title="rocker/tidyverse Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/rocker/tidyverse</a></p>
