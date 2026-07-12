---
image: secureimages/jira-software
description: "基于Alpine基础镜像构建的Atlassian Jira Software镜像，零安全漏洞，支持项目管理与敏捷开发协作。"
source: https://xuanyuan.cloud/zh/r/secureimages/jira-software
canonical: https://xuanyuan.cloud/zh/r/secureimages/jira-software
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/secureimages/jira-software" title="secureimages/jira-software Docker 镜像中文简介、标签列表与拉取命令">secureimages/jira-software 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Atlassian Jira Software镜像

## 镜像概述
本镜像基于Alpine基础镜像构建Atlassian Jira Software，通过Clair和Trivy安全扫描确认零漏洞，镜像大小约757MB，相比官方镜像（存在38/77个漏洞）具有更高安全性。

## 核心功能
- 提供Jira Software完整功能：敏捷开发管理、项目跟踪、问题缺陷管理
- 零安全漏洞：通过专业工具扫描验证无风险
- 轻量高效：基于Alpine镜像，体积小巧且运行稳定

## 使用场景
- 企业级项目全生命周期管理
- 团队敏捷开发流程落地
- 软件缺陷与任务跟踪协作

## 配置说明
- 默认端口：8080（需映射至主机端口）
- 数据持久化：挂载卷至`/var/atlassian/application-data/jira`保存配置与数据
- 环境变量：支持配置数据库连接、内存限制等Jira核心参数

## 部署示例
### Docker Run命令
```bash
docker run -d \
  --name jira-service \
  -p 8080:8080 \
  -v jira_data:/var/atlassian/application-data/jira \
  docker.xuanyuan.run/secureimages/jira-software:8.12.3-alpine-3.12.0
```

### 安全扫描验证
#### Clair扫描结果
```
clair-scanner secureimages/jira-software:8.12.3-alpine-3.12.0
2020/10/15 19:47:43 [INFO] ▶ 启动clair-scanner
2020/10/15 19:47:52 [INFO] ▶ 服务器监听端口9279
...（省略镜像分析记录）
2020/10/15 19:47:53 [INFO] ▶ 镜像[secureimages/jira-software:8.12.3-alpine-3.12.0]无未批准的漏洞
```

#### Trivy扫描结果
```
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro docker.xuanyuan.run/aquasec/trivy:0.12.0 --no-progress secureimages/jira-software:8.12.3-alpine-3.12.0
2020-10-15T19:47:55.412Z        INFO    需要更新数据库
2020-10-15T19:47:55.412Z        INFO    下载数据库...
2020-10-15T19:48:13.345Z        INFO    检测Alpine漏洞...

secureimages/jira-software:8.12.3-alpine-3.12.0 (alpine 3.12.0)
===============================================================
总计: 0 (未知:0, 低:0, 中:0, 高:0, 严重:0)
