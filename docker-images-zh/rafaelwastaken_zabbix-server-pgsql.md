---
image: rafaelwastaken/zabbix-server-pgsql
description: "包含jq、expect和openssh工具的Zabbix服务器镜像，基于PostgreSQL数据库，用于监控系统部署与管理。"
source: https://xuanyuan.cloud/zh/r/rafaelwastaken/zabbix-server-pgsql
canonical: https://xuanyuan.cloud/zh/r/rafaelwastaken/zabbix-server-pgsql
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rafaelwastaken/zabbix-server-pgsql" title="rafaelwastaken/zabbix-server-pgsql Docker 镜像中文简介、标签列表与拉取命令">rafaelwastaken/zabbix-server-pgsql 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# zabbix-server-pgsql

## 镜像概述和主要用途
zabbix-server-pgsql是一个基于PostgreSQL数据库的Zabbix服务器Docker镜像，在标准Zabbix服务器功能基础上，额外集成了jq（JSON处理工具）、expect（自动化交互工具）和openssh（SSH协议实现），适用于需要增强脚本处理能力、自动化配置及远程管理的监控场景。

## 核心功能和特性
- **基础功能**：提供标准Zabbix服务器核心能力，包括监控数据收集、告警管理、报表生成等
- **工具集成**：
  - jq：用于JSON数据解析与处理，便于处理API返回数据或配置文件
  - expect：支持自动化交互式操作，可用于批量部署、配置脚本编写
  - openssh：提供SSH客户端功能，支持远程服务器监控与管理
- **PostgreSQL支持**：基于PostgreSQL数据库，适合需要稳定关系型数据库支持的监控环境

## 使用场景和适用范围
- 企业级监控系统部署，需处理复杂JSON数据的场景
- 需要自动化配置Zabbix Agent或远程设备的监控环境
- 需通过SSH协议监控远程服务器、网络设备的场景
- 需自定义监控脚本（依赖jq/expect）的定制化监控需求

## 使用方法和配置说明

### 基本运行命令
```bash
docker run -d \
  --name zabbix-server \
  -p 10051:10051 \
  -e DB_HOST=postgres-host \
  -e DB_USER=zabbix \
  -e DB_PASSWORD=zabbix_password \
  -e DB_NAME=zabbix \
  -v /path/to/zabbix/conf:/etc/zabbix \
  -v /path/to/zabbix/alertscripts:/usr/lib/zabbix/alertscripts \
  docker.xuanyuan.run/hueNET-llc/zabbix-server-pgsql
```

### Docker Compose配置示例
```yaml
version: '3'
services:
  zabbix-server:
    image: docker.xuanyuan.run/hueNET-llc/zabbix-server-pgsql
    container_name: zabbix-server
    ports:
      - "10051:10051"
    environment:
      - DB_HOST=postgres
      - DB_USER=zabbix
      - DB_PASSWORD=zabbix_password
      - DB_NAME=zabbix
      - ZBX_LOGLEVEL=3
    volumes:
      - ./zabbix/conf:/etc/zabbix
      - ./zabbix/alertscripts:/usr/lib/zabbix/alertscripts
      - ./zabbix/externalscripts:/usr/lib/zabbix/externalscripts
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: docker.xuanyuan.run/postgres:13
    container_name: zabbix-postgres
    environment:
      - POSTGRES_USER=zabbix
      - POSTGRES_PASSWORD=zabbix_password
      - POSTGRES_DB=zabbix
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres-data:
```

### 主要环境变量说明
| 环境变量 | 描述 | 默认值 |
|----------|------|--------|
| DB_HOST | PostgreSQL数据库主机地址 | localhost |
| DB_PORT | PostgreSQL数据库端口 | 5432 |
| DB_USER | 数据库用户名 | zabbix |
| DB_PASSWORD | 数据库密码 | zabbix |
| DB_NAME | 数据库名称 | zabbix |
| ZBX_LOGLEVEL | 日志级别（0-5，5为最详细） | 3 |
| ZBX_TIMEOUT | 连接超时时间（秒） | 3 |

### 工具使用示例
1. **使用jq处理JSON数据**：
```bash
docker exec -it zabbix-server jq '.data[] | select(.status=="up")' /etc/zabbix/hosts.json
```

2. **使用expect自动化配置**：
```bash
# 在容器内创建expect脚本
docker exec -it zabbix-server sh -c 'cat > /usr/lib/zabbix/externalscripts/configure_agent.exp <<EOF
#!/usr/bin/expect -f
set timeout 10
spawn ssh root@agent-host "zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf"
expect "password:"
send "agent_password\r"
expect eof
EOF'

# 赋予执行权限并运行
docker exec -it zabbix-server chmod +x /usr/lib/zabbix/externalscripts/configure_agent.exp
```

## 注意事项
- 首次启动需确保PostgreSQL数据库已初始化并创建zabbix数据库及用户
- 建议通过挂载卷持久化配置文件和脚本，避免容器重建导致数据丢失
- 生产环境中应使用环境变量或密钥管理工具存储敏感信息（如数据库密码）
