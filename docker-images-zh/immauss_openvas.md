---
image: immauss/openvas
description: "集成PostgreSQL 13数据库的OpenVAS/GVMD 23.1镜像，提供漏洞扫描、任务管理及扫描结果存储功能的漏洞管理工具。"
source: https://xuanyuan.cloud/zh/r/immauss/openvas
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[immauss/openvas](https://xuanyuan.cloud/zh/r/immauss/openvas)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# immauss/openvas Docker镜像文档


## 镜像概述和主要用途

`immauss/openvas` 是一个基于Greenbone Vulnerability Management (GVM) 的Docker镜像，旨在提供便捷的漏洞扫描与管理解决方案。该镜像集成了OpenVAS扫描引擎、GVMD（Greenbone Vulnerability Management Daemon）23.1版本，并使用PostgreSQL 13作为后端数据库，支持漏洞扫描、结果分析及风险管理等功能。

### 镜像基本信息
- **版本**：OpenVAS/GVMD 23.1 + PostgreSQL 13  
- **Docker Hub地址**：[https://hub.docker.com/r/immauss/openvas](https://hub.docker.com/r/immauss/openvas)  
- **社区支持**：Docker Pulls、Stars及GitHub Stars等统计信息（见下方徽章）  


## 核心功能和特性

### 核心组件
- **OpenVAS扫描引擎**：执行漏洞扫描，支持多种网络协议（TCP、UDP、ICMP等）及漏洞检测插件。  
- **GVMD（Greenbone Vulnerability Management Daemon）**：漏洞管理核心，负责扫描任务调度、结果存储与分析。  
- **PostgreSQL 13**：稳定的关系型数据库，用于持久化存储扫描任务、漏洞数据及配置信息。  

### 主要特性
- **Web管理界面**：通过Greenbone Security Assistant (GSA) 提供直观的Web操作界面，支持扫描配置、任务管理及报告生成。  
- **漏洞数据库自动更新**：定期同步Greenbone漏洞数据库（NVTs、CVEs等），确保扫描规则时效性。  
- **数据持久化**：支持通过Docker卷挂载实现扫描数据、配置及数据库的持久化存储。  
- **轻量级部署**：容器化封装，简化依赖管理，支持快速部署与迁移。  


## 使用场景和适用范围

### 典型使用场景
- **企业网络漏洞评估**：对内部网络设备、服务器及应用系统进行定期漏洞扫描，识别潜在安全风险。  
- **安全合规审计**：满足行业合规要求（如PCI DSS、ISO 27001），生成标准化漏洞报告。  
- **定期安全监控**：配置定时扫描任务，持续监控网络安全状态，及时发现新引入的漏洞。  
- **内部安全培训**：作为安全团队学习漏洞扫描与管理工具的实践环境。  

### 适用范围
- IT运维团队、安全运营中心（SOC）、安全审计人员及需要进行网络安全评估的组织。  


## 使用方法和配置说明

### 前提条件
- Docker Engine 20.10+  
- Docker Compose（可选，用于多容器管理）  
- 至少4GB内存（推荐8GB以上，确保扫描性能）  


### 快速启动（docker run）
通过以下命令快速启动容器，默认映射Web端口9392，并持久化数据：

```bash
docker run -d \
  --name openvas \
  -p 9392:9392 \
  -v gvm_data:/var/lib/gvm \
  -e ADMIN_PASSWORD="your_strong_password" \
  immauss/openvas:latest
```

#### 参数说明：
- `-p 9392:9392`：映射容器内GSA Web界面端口到主机9392端口。  
- `-v gvm_data:/var/lib/gvm`：创建命名卷`gvm_data`，持久化存储GVM数据（漏洞库、扫描结果等）。  
- `-e ADMIN_PASSWORD`：设置管理员账号（默认用户名`admin`）的密码。  


### Docker Compose配置示例
创建`docker-compose.yml`文件，配置如下：

```yaml
version: '3.8'

services:
  openvas:
    image: immauss/openvas:latest
    container_name: openvas
    ports:
      - "9392:9392"  # Web界面端口
    volumes:
      - gvm_data:/var/lib/gvm  # 数据持久化卷
    environment:
      - ADMIN_PASSWORD="SecurePass123!"  # 管理员密码
      - TZ="Asia/Shanghai"  # 设置时区（可选）
    restart: unless-stopped  # 容器退出时自动重启

volumes:
  gvm_data:  # 命名卷，自动创建
```

启动命令：  
```bash
docker-compose up -d
```


### 配置参数说明

#### 环境变量
| 变量名               | 说明                                  | 默认值       |
|----------------------|---------------------------------------|--------------|
| `ADMIN_PASSWORD`     | 管理员（admin）密码                   | 随机生成     |
| `TZ`                 | 容器时区                              | `UTC`        |
| `DB_PASSWORD`        | PostgreSQL数据库密码（不建议修改）    | 自动生成     |
| `SCAN_MAX_THREADS`   | 最大扫描线程数（性能调优）           | 10           |


#### 数据持久化
容器数据主要存储在`/var/lib/gvm`目录，包含：  
- 漏洞特征库（NVTs、CVEs）  
- 扫描任务配置与结果  
- PostgreSQL数据库文件  

**建议**：通过Docker卷（而非绑定挂载）持久化数据，避免权限问题。


### 访问Web界面
容器启动后，通过浏览器访问：  
`https://<主机IP>:9392`  

使用默认用户名`admin`及设置的`ADMIN_PASSWORD`登录。首次登录可能需要等待几分钟，容器需初始化漏洞数据库。


## 注意事项
1. **首次启动时间**：容器首次启动时会同步最新漏洞数据库，耗时较长（视网络情况，可能需要30分钟以上）。  
2. **数据备份**：定期备份`gvm_data`卷数据，避免扫描结果丢失。  
3. **性能要求**：漏洞扫描为资源密集型任务，建议为容器分配足够CPU和内存（推荐4核8GB以上）。  
4. **安全建议**：生产环境中应通过HTTPS访问，避免使用弱密码，并限制Web界面访问IP。  


## 相关资源
- **官方文档**：[GitHub文档](https://immauss.github.io/openvas/)  
- **Web界面与扫描操作指南**：[Greenbone官方文档](https://docs.greenbone.net/GSM-Manual/gos-22.04/en/)（第8-14章）  
- **GitHub仓库**：[https://github.com/immauss/openvas](https://github.com/immauss/openvas)  
- **许可证**：[GNU Affero通用公共许可证](https://github.com/immauss/openvas/blob/master/LICENSE)  


## 赞助信息
该项目由Immauss Cybersecurity维护，感谢以下赞助商支持：  
- **铂金赞助商**：Absolute Ops ([https://www.absoluteops.com/](https://www.absoluteops.com/))  
- **银牌赞助商**：NOS Informatica ([https://nosinformatica.com/](https://nosinformatica.com/))  

如需赞助，可通过：  
- [GitHub Sponsors](https://github.com/sponsors/immauss)  
- [PayPal](https://www.immauss.com/container_subscriptions)
