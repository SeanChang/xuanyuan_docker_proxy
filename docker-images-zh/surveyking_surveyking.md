---
image: surveyking/surveyking
description: "这是一款功能更优的问卷考试系统，支持多样化问卷题型设计、智能化考试流程管理、实时数据统计分析与结果可视化，兼具用户友好的操作界面与高效的后台处理能力，能满足教育、企业、调研等多场景需求，有效提升问卷调研与在线考核的便捷性和准确性。"
source: https://xuanyuan.cloud/zh/r/surveyking/surveyking
canonical: https://xuanyuan.cloud/zh/r/surveyking/surveyking
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/surveyking/surveyking" title="surveyking/surveyking Docker 镜像中文简介、标签列表与拉取命令">surveyking/surveyking 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# [卷王 SurveyKing] 


## 什么是 SurveyKing  
SurveyKing 是一款人人都能快速搭建的专业问卷考试系统，支持在线考试、调查问卷、公开查询、题库刷题及投票等功能。  

快速体验：访问[体验地址] ，点击“试一试”即可，无需注册。  


## 快速开始  
### 一键启动（默认使用内置 H2 数据库）  
```bash
docker run -d -p 1991:1991 docker.xuanyuan.run/surveyking/surveyking
```

### 挂载数据目录（数据库文件、文件存储、日志）  
```bash
docker run -d -p 1991:1991 -v ${PWD}/db:/app/db -v ${PWD}/files:/app/files -v ${PWD}/logs:/app/logs docker.xuanyuan.run/surveyking/surveyking
```

### 使用外置 MySQL 数据库（系统启动时会自动导入初始 SQL）  
```bash
docker run -e PROFILE=mysql \
           -v ${PWD}/logs:/app/logs \
           -v ${PWD}/files:/app/files \
           -e MYSQL_PASS=surveyking \
           -e MYSQL_USER=surveyking \
           -e DB_URL='jdbc:mysql://172.17.0.1:3306/surveyking?rewriteBatchedStatements=true&useUnicode=true&characterEncoding=UTF-8' \
           -p 1991:1991 \
           docker.xuanyuan.run/surveyking/surveyking
```


## 注意  
上一版本发布于2022年，无法直接升级至最新版。强制升级可能导致历史数据丢失，请先备份数据后再进行升级。  


## BUG 反馈  
[Gitee Issues]  | [GitHub Issues]
