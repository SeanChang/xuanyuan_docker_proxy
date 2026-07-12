---
image: cgrlab/tidyverse
description: "这是一个整合R语言tidyverse生态核心及常用扩展包的Docker镜像，提供开箱即用的数据科学分析环境，支持数据处理、可视化、多源数据导入和统计建模辅助等任务。"
source: https://xuanyuan.cloud/zh/r/cgrlab/tidyverse
canonical: https://xuanyuan.cloud/zh/r/cgrlab/tidyverse
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/cgrlab/tidyverse" title="cgrlab/tidyverse Docker 镜像中文简介、标签列表与拉取命令">cgrlab/tidyverse 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
cgrlab/tidyverse镜像整合了R语言tidyverse生态系统的核心及常用扩展包，旨在为用户提供开箱即用的数据科学分析环境，无需手动安装和配置多个依赖包，简化R数据分析工作流的部署流程。

# 核心功能
该镜像包含以下关键功能模块：
1. **核心数据处理与可视化**：
   - ggplot2：专业数据可视化工具，支持多种图表类型；
   - dplyr：高效数据操作（筛选、分组、聚合等）；
   - tidyr：数据整理（宽表转长表、缺失值处理等）；
   - readr：快速读取文本格式数据（CSV、TSV等）；
   - purrr：函数式编程工具，简化批量数据处理；
   - tibble：增强型数据框，提供友好的显示和操作体验。
2. **扩展功能支持**：
   - 向量类型处理：hms（时间）、stringr（字符串）、lubridate（日期时间）、forcats（因子）；
   - 多源数据导入：DBI（数据库）、haven（SPSS/SAS/Stata文件）、httr（Web API）、jsonlite（JSON）、readxl（Excel文件）、rvest（网页抓取）、xml2（XML）；
   - 统计建模辅助：modelr（建模流水线集成）、broom（模型结果转换为整洁数据）。

# 使用场景
- 快速开展数据科学分析项目，无需本地配置复杂R环境；
- 教学或培训中统一R分析环境，确保结果一致性；
- 批量运行R脚本进行自动化数据处理或报告生成；
- 开发基于tidyverse的数据分析工具或应用。

# 配置说明与部署示例
## 基础运行方式
直接启动镜像进入R交互环境：
```bash
docker run -it --rm docker.xuanyuan.run/cgrlab/tidyverse R
```
## 挂载本地数据目录
将本地数据目录挂载到容器，方便读取和保存文件：
```bash
docker run -it --rm -v /path/to/your/data:/data docker.xuanyuan.run/cgrlab/tidyverse R
```
## 运行R脚本
执行本地R脚本（假设脚本位于当前目录`analysis.R`）：
```bash
docker run -it --rm -v $(pwd):/workspace docker.xuanyuan.run/cgrlab/tidyverse Rscript /workspace/analysis.R
