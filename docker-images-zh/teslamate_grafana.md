---
image: teslamate/grafana
description: "一个自定义Grafana镜像，可自动配置数据源和仪表板，简化监控系统的部署与配置流程。"
source: https://xuanyuan.cloud/zh/r/teslamate/grafana
canonical: https://xuanyuan.cloud/zh/r/teslamate/grafana
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/teslamate/grafana" title="teslamate/grafana Docker 镜像中文简介、标签列表与拉取命令">teslamate/grafana 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Teslamate Grafana 镜像文档

## 镜像概述和主要用途
teslamate/teslamate 是一个为Teslamate设计的自定义Grafana镜像，旨在简化特斯拉车辆数据监控系统的部署流程。该镜像预配置了与Teslamate后端兼容的数据源和专用仪表板，用户无需手动配置即可快速启动可视化监控环境，专注于车辆数据的展示与分析。

## 核心功能和特性
- **自动配置数据源**：无需手动添加，镜像启动时自动配置与Teslamate后端匹配的数据源连接
- **预配置仪表板**：内置Teslamate专用监控仪表板，包含车辆状态、能耗、行驶数据等关键指标可视化
- **无缝集成Teslamate**：与Teslamate应用后端深度适配，确保数据流转与展示的稳定性
- **简化部署流程**：减少手动配置步骤，降低Grafana使用门槛，适合非专业用户快速上手

## 使用场景和适用范围
- **Teslamate用户**：所有使用Teslamate监控特斯拉车辆数据的个人用户或小型部署环境
- **快速部署需求**：需要在短时间内搭建完整监控可视化系统的场景
- **低维护成本场景**：希望减少Grafana日常配置维护工作的用户
- **标准化监控需求**：需要统一、专业的特斯拉车辆数据展示模板的场景

## 使用方法和配置说明

### Docker 运行示例
```bash
docker run -d \
  --name teslamate-grafana \
  -p 3000:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=your_secure_password \
  -e DATASOURCE_URL=http://teslamate-db:5432/teslamate \
  -e DATASOURCE_USER=teslamate \
  -e DATASOURCE_PASSWORD=teslamate_password \
  --link teslamate-db:db \
  docker.xuanyuan.run/teslamate/teslamate:latest
```

### Docker Compose 配置示例
```yaml
version: '3'

services:
  grafana:
    image: docker.xuanyuan.run/teslamate/teslamate:latest
    container_name: teslamate-grafana
    restart: always
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=your_secure_password
      - DATASOURCE_URL=jdbc:postgresql://db:5432/teslamate
      - DATASOURCE_USER=teslamate
      - DATASOURCE_PASSWORD=teslamate_password
    volumes:
      - grafana-data:/var/lib/grafana
    depends_on:
      - db

  db:
    image: docker.xuanyuan.run/postgres:14
    container_name: teslamate-db
    restart: always
    environment:
      - POSTGRES_USER=teslamate
      - POSTGRES_PASSWORD=teslamate_password
      - POSTGRES_DB=teslamate
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  grafana-data:
  postgres-data:
```

### 环境变量配置
| 环境变量                | 描述                          | 默认值                  |
|-------------------------|-------------------------------|-------------------------|
| `GF_SECURITY_ADMIN_PASSWORD` | Grafana管理员密码            | 无（需强制设置）        |
| `DATASOURCE_URL`         | 数据库连接URL                 | `jdbc:postgresql://db:5432/teslamate` |
| `DATASOURCE_USER`        | 数据库用户名                  | `teslamate`             |
| `DATASOURCE_PASSWORD`    | 数据库密码                    | 无（需与数据库配置匹配）|
| `GF_USERS_ALLOW_SIGN_UP` | 是否允许用户注册              | `false`                 |
| `GF_SERVER_HTTP_PORT`    | Grafana服务端口               | `3000`                  |

### 数据持久化
为确保仪表板配置和历史数据不丢失，建议通过卷挂载持久化Grafana数据目录：
- 容器内路径：`/var/lib/grafana`
- 挂载示例：`-v grafana-data:/var/lib/grafana`（使用命名卷）或 `-v /host/path:/var/lib/grafana`（使用主机目录）

## 访问与使用
1. 启动容器后，通过 `http://<主机IP>:3000` 访问Grafana界面
2. 使用配置的 `GF_SECURITY_ADMIN_PASSWORD` 登录管理员账户
3. 在左侧菜单「Dashboards > Browse」中即可看到预配置的Teslamate仪表板
4. 仪表板包含车辆状态、充电统计、行驶记录、能耗分析等多维度数据可视化
