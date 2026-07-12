---
image: huas/datax
description: "DataX是阿里巴巴集团广泛使用的离线数据同步工具/平台，支持MySQL、Oracle、HDFS等多种异构数据源之间的高效数据同步。"
source: https://xuanyuan.cloud/zh/r/huas/datax
canonical: https://xuanyuan.cloud/zh/r/huas/datax
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/huas/datax" title="huas/datax Docker 镜像中文简介、标签列表与拉取命令">huas/datax 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# DataX Docker镜像文档

## 镜像概述和主要用途

DataX是阿里巴巴集团内被广泛使用的离线数据同步工具/平台，专注于实现各类异构数据源之间的高效数据同步。它支持包括MySQL、Oracle、SqlServer、Postgre、HDFS、Hive、ADS、HBase、TableStore(OTS)、MaxCompute(ODPS)、DRDS等多种数据源，为企业级数据集成、迁移和同步提供可靠解决方案。项目源码可参考：[https://github.com/alibaba/DataX](https://github.com/alibaba/DataX)。

## 核心功能和特性

1. **插件化架构设计**  
   DataX将数据同步过程抽象为两大核心组件：从源头数据源读取数据的Reader插件和向目标端写入数据的Writer插件。这种设计使框架理论上可支持任意数据源类型的数据同步。

2. **开放生态系统**  
   插件体系作为独立生态系统，新接入的数据源只需开发对应的Reader/Writer插件，即可与现有所有数据源实现互通，极大降低跨数据源同步的开发成本。

3. **高效数据传输**  
   针对不同数据源特性优化同步性能，支持大规模数据的高效传输，确保数据同步的稳定性和可靠性。

## 使用场景和适用范围

- **数据仓库构建**：从业务数据库（如MySQL、Oracle）向数据仓库（如Hive、MaxCompute）同步数据，支撑数据分析和决策。
- **跨数据源迁移**：在不同类型数据库（如从SqlServer迁移至Postgre）或存储系统（如HDFS与HBase之间）进行数据迁移。
- **定期数据同步**：企业内部系统间定期数据同步，确保各业务系统数据一致性。

## 使用方法和配置说明

### 基本使用方式

#### 1. 运行示例（Demo）

通过挂载本地配置文件到容器，执行数据同步任务：

```bash
docker run --rm -v $(pwd):/data docker.xuanyuan.run/huas/datax /data/config.json
```

**参数说明**：
- `--rm`：容器运行结束后自动删除，避免残留容器文件
- `-v $(pwd):/data`：将当前工作目录挂载到容器内的`/data`目录，用于读取本地同步配置文件
- `/data/config.json`：指定同步任务的配置文件路径（需提前在本地创建符合DataX规范的JSON配置文件）

#### 2. 查看基础功能

直接运行容器可查看默认帮助信息或基础功能：

```bash
docker run --rm docker.xuanyuan.run/huas/datax
```

### 配置文件规范

同步任务配置文件（如`config.json`）需遵循DataX标准JSON格式，主要包含以下核心部分：
- `job`：定义同步任务基本信息（如任务名称、并发数）
- `setting`：配置同步速度、错误处理策略等
- `content`：包含数据源（reader）和目标源（writer）的详细配置，需根据具体数据源类型填写对应参数

具体配置示例和参数说明可参考[DataX官方文档](https://github.com/alibaba/DataX)中的插件使用说明。
