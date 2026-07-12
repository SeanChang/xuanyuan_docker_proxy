---
image: postgis/postgis-build-env
description: "这是用于PostGIS持续集成测试的环境，集成了其核心依赖组件PostgreSQL、GDAL、PROJ及GEOS的多种版本，旨在通过覆盖不同版本组合，确保PostGIS在各类环境配置下的兼容性与稳定性，为开发过程中的自动化测试提供可靠支撑。"
source: https://xuanyuan.cloud/zh/r/postgis/postgis-build-env
canonical: https://xuanyuan.cloud/zh/r/postgis/postgis-build-env
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/postgis/postgis-build-env" title="postgis/postgis-build-env Docker 镜像中文简介、标签列表与拉取命令">postgis/postgis-build-env 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### PostGIS回归测试Docker镜像说明  


#### 一、用途与注意事项  
这些Docker镜像用于对PostGIS代码库进行回归测试，具体测试场景为验证代码在不同版本的PostgreSQL、GDAL、GEOS及PROJ下的兼容性。**注意：镜像不可用于生产环境。**  


#### 二、镜像构建来源  
镜像基于以下仓库构建：[postgis/postgis-build-env] ，由Jenkins机器人根据实际需求（按需）生成。  


#### 三、使用方式  
镜像通过GitHub Actions调用，具体配置可参考PostGIS项目的CI工作流示例：[ci.yml] 。  


#### 四、开放对象  
欢迎所有开发者使用这些镜像，用于测试自己对PostGIS的代码贡献。
