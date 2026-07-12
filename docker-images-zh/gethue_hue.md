---
image: gethue/hue
description: "Hue是一款用于数据库和数据仓库的开源SQL助手。"
source: https://xuanyuan.cloud/zh/r/gethue/hue
canonical: https://xuanyuan.cloud/zh/r/gethue/hue
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gethue/hue" title="gethue/hue Docker 镜像中文简介、标签列表与拉取命令">gethue/hue 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Hue 镜像文档

## 概述和主要用途
Hue是一款成熟的SQL助手，用于查询数据库和数据仓库。全球有1000多家客户，包括多家财富500强企业，使用Hue进行自助查询以快速解答问题，每天执行数十万次查询。

## 核心功能和特性
- **SQL编辑器**：提供直观的SQL编辑界面，支持语法高亮、自动补全等功能
- **多数据库连接**：支持Impala、Flink SQL、ksqlDB、Phoenix SQL/HBase、Spark SQL等多种数据库和数据处理引擎
- **解析器组件**：内置SQL解析器，支持复杂查询分析
- **多接口支持**：提供REST API、Python API和CLI接口，便于集成和自动化操作
- **自助查询**：支持用户自助进行数据查询，减少对技术人员的依赖

## 使用场景和适用范围
- **企业数据自助查询**：业务人员可通过Hue快速查询数据库，获取所需数据
- **数据分析师日常工作**：简化SQL编写和执行流程，提高数据分析效率
- **多数据库统一管理**：在单一界面中连接和查询多种数据库，简化操作流程
- **开发和测试环境**：快速搭建SQL查询环境，支持开发和测试工作

## 使用方法和配置说明

### Docker部署
通过Docker可快速启动Hue服务，步骤如下：

1. 执行以下命令拉取并运行Hue镜像：
   ```bash
   docker run -it -p 8888:8888 docker.xuanyuan.run/gethue/hue:latest
   ```

2. 服务启动后，在浏览器中访问 `http://localhost:8888` 即可打开Hue界面

3. 配置数据库连接：登录后，根据需要配置要查询的数据库连接，具体配置方法可参考[官方文档](https://docs.gethue.com/administrator/configuration/connectors/)

### 其他部署方式（简要说明）
- **Kubernetes**：通过Helm chart部署
  ```bash
  helm repo add gethue https://helm.gethue.com
  helm repo update
  helm install hue gethue/hue
  ```
- **开发环境**：可通过源码构建，具体步骤参考[开发文档](https://docs.gethue.com/developer/development/)

## 许可证
[Apache许可证2.0](http://www.apache.org/licenses/LICENSE-2.0)
