---
image: heartexlabs/label-studio
description: "Label Studio是一款开源数据标注工具，支持音频、文本、图像、视频和时间序列等多种数据类型标注，提供直观UI界面和多种模型格式导出功能，用于准备机器学习训练数据。"
source: https://xuanyuan.cloud/zh/r/heartexlabs/label-studio
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[heartexlabs/label-studio](https://xuanyuan.cloud/zh/r/heartexlabs/label-studio)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Label Studio 中文文档

![GitHub](https://img.shields.io/github/license/heartexlabs/label-studio?logo=heartex) ![label-studio:build](https://github.com/HumanSignal/label-studio/workflows/label-studio:build/badge.svg) ![GitHub release](https://img.shields.io/github/v/release/heartexlabs/label-studio?include_prereleases)

[官方网站](https://labelstud.io/) • [文档](https://labelstud.io/guide/) • [加入Slack社区 <img src="https://app.heartex.ai/docs/images/slack-mini.png" width="18px"/>](https://slack.labelstud.io/?source=github-1)

## 什么是Label Studio?

Label Studio是一个开源数据标注工具。它允许您通过简单直观的UI界面对音频、文本、图像、视频和时间序列等数据类型进行标注，并导出为多种模型格式。可用于准备原始数据或改进现有训练数据，以获得更准确的机器学习模型。

![Label Studio标注不同类型数据的演示GIF](/images/annotation_examples.gif)

如果您有自定义数据集，可以定制Label Studio以满足您的需求。

## 核心特性

- **多用户标注**：支持用户注册和登录，每个标注都与用户账户关联
- **多项目管理**：在一个实例中管理所有数据集
- **精简设计**：专注于标注任务而非软件操作
- **可配置的标签格式**：自定义视觉界面以满足特定标注需求
- **支持多种数据类型**：包括图像、音频、文本、HTML、时间序列和视频
- **灵活的数据导入**：支持从文件或云存储（Amazon AWS S3、Google Cloud Storage）导入，以及JSON、CSV、TSV、RAR和ZIP档案
- **机器学习模型集成**：可视化和比较不同模型的预测结果，执行预标注
- **REST API支持**：轻松集成到现有数据管道

## 数据标注模板

Label Studio包含多种标注模板，或可使用专门设计的配置语言创建自定义模板。最常见的标注模板和用例包括文本分类、命名实体识别、图像分割、音频转录等。

## Docker部署方案

### 本地Docker安装

官方Label Studio Docker镜像可通过`docker pull`获取。在Docker容器中运行Label Studio并通过`http://localhost:8080`访问：

```bash
# 拉取最新镜像
docker pull heartexlabs/label-studio:latest

# 运行容器，映射8080端口并挂载数据卷
docker run -it -p 8080:8080 -v $(pwd)/mydata:/label-studio/data heartexlabs/label-studio:latest
```

所有生成的资产（包括SQLite3数据库存储`label_studio.sqlite3`和上传的文件）将保存在`./mydata`目录中。

#### 覆盖默认Docker启动命令

您可以通过追加新参数来覆盖默认启动命令：

```bash
docker run -it -p 8080:8080 -v $(pwd)/mydata:/label-studio/data heartexlabs/label-studio:latest label-studio --log-level DEBUG
```

### Docker Compose部署

Docker Compose脚本提供生产就绪的堆栈，包括以下组件：
- Label Studio
- [Nginx](https://www.nginx.com/) - 用于加载各种静态数据的代理Web服务器
- [PostgreSQL](https://www.postgresql.org/) - 替代SQLite3的生产级数据库

通过以下命令从`http://localhost`开始使用应用：

```bash
docker-compose up
```

### Docker Compose + MinIO部署

您还可以添加MinIO服务器用于本地S3存储。这在本地系统上测试S3存储行为时特别有用。通过以下命令启动：

```bash
# Linux系统如非docker组用户需添加sudo
docker compose -f docker-compose.yml -f docker-compose.minio.yml up -d
```

如果没有静态IP地址，必须在hosts文件中创建条目，以便Label Studio和浏览器都能访问MinIO服务器。

## 机器学习模型集成

使用Label Studio机器学习SDK连接您喜爱的机器学习模型。步骤如下：

1. 启动您自己的机器学习后端服务器。详见[详细说明](https://github.com/HumanSignal/label-studio-ml-backend)。
2. 在项目设置的模型页面上，将Label Studio连接到服务器。

这使您能够：
- 使用模型预测进行**预标注**数据
- 进行**在线学习**，在创建新标注时重新训练模型
- 通过仅标注数据中最复杂的示例进行**主动学习**

## 与现有工具集成

您可以将Label Studio用作机器学习工作流的独立部分，或将前端或后端集成到现有工具中。

## 生态系统

| 项目 | 描述 |
|-|-|
| label-studio | 服务器，作为pip包分发 |
| [前端库](web/libs/editor/) | Label Studio前端库，使用React构建UI，mobx-state-tree进行状态管理 |
| [数据管理器库](web/libs/datamanager/) | 数据管理器库，用于数据探索工具 |
| [label-studio-converter](https://github.com/HumanSignal/label-studio-sdk/tree/master/src/label_studio_sdk/converter) | 将标签编码为您喜爱的机器学习库格式 |
| [label-studio-transformers](https://github.com/HumanSignal/label-studio-transformers) | 连接并配置用于Label Studio的Transformers库 |

## 引用

在文章的**参考文献**部分包含Label Studio的引用：

```tex
@misc{Label Studio,
  title={{Label Studio}: Data labeling software},
  url={https://github.com/HumanSignal/label-studio},
  note={Open source software available from https://github.com/HumanSignal/label-studio},
  author={
    Maxim Tkachenko and
    Mikhail Malyuk and
    Andrey Holmanyuk and
    Nikolai Liubimov},
  year={2020-2025},
}
```

## 许可证

本软件根据[Apache 2.0 LICENSE](/LICENSE)许可 © [Heartex](https://www.heartex.com/)。 2020-2025
