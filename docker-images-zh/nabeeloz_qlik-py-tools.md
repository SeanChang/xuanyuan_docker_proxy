---
image: nabeeloz/qlik-py-tools
description: "为Qlik Sense提供基于Python的服务器端扩展（SSE），支持监督学习、预测、聚类、市场篮子分析等多种数据科学算法。"
source: https://xuanyuan.cloud/zh/r/nabeeloz/qlik-py-tools
canonical: https://xuanyuan.cloud/zh/r/nabeeloz/qlik-py-tools
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/nabeeloz/qlik-py-tools" title="nabeeloz/qlik-py-tools Docker 镜像中文简介、标签列表与拉取命令">nabeeloz/qlik-py-tools 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述
本镜像为Qlik Sense提供基于Python实现的服务器端扩展（Server Side Extension, SSE），旨在帮助Qlik用户在数据分析过程中集成专业数据科学算法能力。

## 核心功能
- 监督机器学习算法支持
- 时间序列预测分析
- 数据聚类分组
- 市场篮子关联分析
- 其他数据科学相关工具

## 使用场景
适用于Qlik Sense用户需要增强数据分析深度的场景：
- 业务指标的趋势预测
- 用户行为数据的聚类分析
- 商品购买关联关系挖掘
- 自定义数据科学模型集成

## 配置说明
详细配置及扩展方法请参考GitHub项目：[qlik-py-tools](https://github.com/nabeel-oz/qlik-py-tools)

## Docker部署示例
### 基础运行命令
```bash
docker run -d -p 50051:50051 docker.xuanyuan.run/nabeeloz/qlik-py-tools
```
（注：端口映射需与Qlik Sense的SSE配置保持一致）

### 持久化配置（可选）
若需自定义算法或配置文件，可挂载本地目录：
```bash
docker run -d -p 50051:50051 -v /local/config:/app/config docker.xuanyuan.run/nabeeloz/qlik-py-tools
