---
image: genomenexus/genome-nexus-vep
description: "Genome Nexus VEP是围绕Ensembl的Variant Effect Predictor (VEP) CLI工具的REST包装器，需连接Ensembl提供的homo_sapiens_core数据库并配置MySQL环境变量（MYSQL_USER、MYSQL_PASSWORD等），通过8080端口提供服务；标签遵循{VEP_VERSION}-{GENOME_NEXUS_VEP_VERSION}规则，slim版不支持PolyPhen、SIFT预测及AlphaMissense评分。"
source: https://xuanyuan.cloud/zh/r/genomenexus/genome-nexus-vep
canonical: https://xuanyuan.cloud/zh/r/genomenexus/genome-nexus-vep
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/genomenexus/genome-nexus-vep" title="genomenexus/genome-nexus-vep Docker 镜像中文简介、标签列表与拉取命令">genomenexus/genome-nexus-vep 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Genome Nexus VEP Docker镜像文档

## 镜像概述
Genome Nexus VEP是围绕Ensembl的Variant Effect Predictor (VEP) CLI工具构建的REST包装器，提供REST接口以便外部应用访问VEP的变异效应预测功能。

## 标签命名规则
镜像标签遵循以下格式：`{VEP_VERSION}-{GENOME_NEXUS_VEP_VERSION}`。部分标签可能标记为`slim`，表示这些版本不支持PolyPhen预测、SIFT预测及AlphaMissense致病性评分。如需使用这些数据，请下载基础版本镜像。

## 核心功能与特性
- 作为VEP CLI工具的REST包装器，提供便捷的API访问方式
- 依赖Ensembl提供的homo_sapiens_core数据库进行变异效应预测
- 通过环境变量灵活配置数据库连接参数，适配不同部署环境
- 容器内服务运行在8080端口，支持端口映射以允许外部访问

## 使用场景
适用于需要通过REST接口调用VEP变异效应预测功能的场景，如基因组学研究、临床基因组数据分析、生物信息学工具集成等。

## 使用方法与配置说明

### 运行前准备
1. **数据库依赖**：必须连接Ensembl提供的homo_sapiens_core数据库。关于数据库搭建的详细信息，请参考Genome Nexus VEP [GitHub仓库](https://github.com/genome-nexus/genome-nexus-vep)。
2. **环境变量配置**：需提供数据库连接相关的环境变量（见下文“环境变量说明”）。

### 端口暴露
应用运行在容器的8080端口，需通过`-p`参数映射该端口至宿主机，以允许外部应用访问。

### Docker运行示例
使用以下命令启动容器，替换环境变量值为实际数据库连接信息：
```bash
docker run -d \
  -p 8080:8080 \
  -e MYSQL_USER=your_username \
  -e MYSQL_PASSWORD=your_password \
  -e MYSQL_HOST=db_host \
  -e MYSQL_PORT=db_port \
  docker.xuanyuan.run/genome-nexus/genome-nexus-vep:{VEP_VERSION}-{GENOME_NEXUS_VEP_VERSION}
```

## 环境变量说明
必须提供以下环境变量以配置VEP的数据库连接：
- `MYSQL_USER`: 数据库用户名
- `MYSQL_PASSWORD`: 数据库密码
- `MYSQL_HOST`: 数据库主机地址
- `MYSQL_PORT`: 数据库端口号
