---
image: jenkinsciinfra/plugin-health-scoring
description: "Jenkins插件健康评分系统Docker镜像，用于评估Jenkins插件的健康状况，提供自动化评分和报告功能，帮助开发者和管理员识别插件潜在问题，提升Jenkins生态系统质量。"
source: https://xuanyuan.cloud/zh/r/jenkinsciinfra/plugin-health-scoring
canonical: https://xuanyuan.cloud/zh/r/jenkinsciinfra/plugin-health-scoring
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jenkinsciinfra/plugin-health-scoring" title="jenkinsciinfra/plugin-health-scoring Docker 镜像中文简介、标签列表与拉取命令">jenkinsciinfra/plugin-health-scoring 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Jenkins插件健康评分系统Docker镜像

## 概述

Jenkins插件健康评分系统Docker镜像提供了一个便捷的方式来部署和运行Jenkins插件健康评分工具。该系统是2022年Google Summer of Code (GSOC)项目的一部分，旨在通过自动化评估插件质量和健康状况，提升Jenkins生态系统的整体质量。

## 核心功能

- 自动化评估Jenkins插件的健康状态
- 基于多维度指标对插件进行评分
- 生成详细的插件健康报告
- 支持批量评估多个插件
- 提供历史评分追踪功能
- 可集成到CI/CD流程中

## 使用场景

- Jenkins插件开发者评估自己的插件质量
- Jenkins管理员评估已安装插件的健康状况
- Jenkins生态系统维护者监控社区插件质量
- 插件审核流程中的自动化质量检查
- 定期监控关键插件的健康状态变化

## 快速开始

### 基本使用

```bash
docker run -it docker.xuanyuan.run/jenkins-infra/plugin-health-scoring:latest
```

### 指定评估单个插件

```bash
docker run -it docker.xuanyuan.run/jenkins-infra/plugin-health-scoring:latest --plugin <plugin-id>
```

### 生成HTML报告

```bash
docker run -v $(pwd):/reports -it docker.xuanyuan.run/jenkins-infra/plugin-health-scoring:latest --plugin <plugin-id> --format html --output /reports/health-report.html
```

## 配置参数

### 命令行参数

| 参数 | 描述 |
|------|------|
| `--plugin` | 指定要评估的插件ID |
| `--version` | 指定插件版本（可选） |
| `--format` | 输出格式，支持json和html |
| `--output` | 输出文件路径 |
| `--config` | 自定义配置文件路径 |
| `--verbose` | 启用详细日志模式 |

### 环境变量

| 环境变量 | 描述 | 默认值 |
|---------|------|--------|
| `PLUGIN_HEALTH_DB_URL` | 数据库连接URL | 内存数据库 |
| `PLUGIN_HEALTH_DB_USER` | 数据库用户名 | `sa` |
| `PLUGIN_HEALTH_DB_PASSWORD` | 数据库密码 | 空 |
| `PLUGIN_HEALTH_CACHE_TTL` | 缓存生存时间(秒) | 3600 |
| `JENKINS_UPDATE_CENTER_URL` | Jenkins更新中心URL | 官方更新中心 |

## Docker Compose配置

```yaml
version: '3'
services:
  plugin-health-scoring:
    image: docker.xuanyuan.run/jenkins-infra/plugin-health-scoring:latest
    volumes:
      - ./reports:/reports
      - ./config:/config
    environment:
      - PLUGIN_HEALTH_DB_URL=jdbc:h2:/data/plugin-health
      - PLUGIN_HEALTH_CACHE_TTL=86400
    command: --config /config/config.yaml --output /reports/weekly-report.html
```

## 高级配置

### 自定义评分规则

可以通过挂载自定义配置文件来修改评分规则:

```bash
docker run -v $(pwd)/custom-rules.yaml:/config.yaml -it docker.xuanyuan.run/jenkins-infra/plugin-health-scoring:latest --config /config.yaml --plugin my-plugin
```

配置文件格式详情请参见项目GitHub仓库文档。

## 数据持久化

为了保存评分历史数据，建议挂载数据卷:

```bash
docker run -v plugin-health-data:/app/data -it docker.xuanyuan.run/jenkins-infra/plugin-health-scoring:latest
```

## 集成到CI/CD

在CI/CD流程中使用插件健康评分:

```bash
docker run --rm -v $(pwd):/workspace docker.xuanyuan.run/jenkins-infra/plugin-health-scoring:latest \
  --plugin my-plugin \
  --format json \
  --output /workspace/plugin-health-report.json
  
# 检查评分是否达到最低要求
python -c "import json; report = json.load(open('plugin-health-report.json')); exit(1) if report['score'] < 70 else exit(0)"
```

## 更多信息

- 项目GitHub仓库: https://github.com/jenkins-infra/plugin-health-scoring
- 官方文档: https://www.jenkins.io/projects/gsoc/2022/projects/plugin-health-scoring-system
- 问题反馈: https://github.com/jenkins-infra/plugin-health-scoring/issues
