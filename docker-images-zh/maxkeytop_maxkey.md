---
image: maxkeytop/maxkey
description: "MaxKey认证端是提供单点登录及身份验证服务的Docker镜像，用于企业级应用的统一身份认证管理。"
source: https://xuanyuan.cloud/zh/r/maxkeytop/maxkey
canonical: https://xuanyuan.cloud/zh/r/maxkeytop/maxkey
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/maxkeytop/maxkey" title="maxkeytop/maxkey Docker 镜像中文简介、标签列表与拉取命令">maxkeytop/maxkey — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/maxkeytop/maxkey" title="maxkeytop/maxkey Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/maxkeytop/maxkey</a>

# MaxKey 单点登录认证系统 Docker 镜像文档


## 1. 镜像概述和主要用途

MaxKey 单点登录认证系统是业界领先的IAM/IDaaS（身份管理与访问控制即服务）产品，谐音为“马克思的钥匙”，寓意其如同“万能钥匙”，能够解锁复杂的企业安全需求，提供简洁高效的身份认证与访问管理解决方案。该产品核心价值在于整合企业内外部多系统的身份管理，通过标准化协议实现统一认证与单点登录，提升系统安全性与用户体验，降低企业IT管理成本。


## 2. 核心功能和特性

### 2.1 标准协议支持
- **OAuth 2.x/OpenID Connect**：兼容主流开放授权与身份验证协议，支持第三方应用接入
- **SAML 2.0**：满足企业级单点登录标准，支持跨平台身份互信
- **JWT**：支持JSON Web Token生成与验证，适用于无状态身份认证
- **CAS**：兼容中央认证服务协议，支持传统应用集成
- **SCIM**：支持跨域身份管理协议，实现用户数据标准化同步

### 2.2 核心功能
- **身份管理（IDM）**：统一用户身份生命周期管理（创建、更新、禁用、删除）
- **身份认证（AM）**：支持多因素认证，保障用户身份合法性
- **单点登录（SSO）**：实现“一次登录，多系统访问”，简化用户操作流程
- **RBAC权限管理**：基于角色的访问控制，支持精细化权限分配与继承
- **资源管理**：集中管理受保护的应用系统资源，统一授权策略

### 2.3 产品特性
- **开源可控**：基于Apache License 2.0协议，源代码完全开放，自主可控
- **安全合规**：遵循国际安全标准，保障身份数据机密性与完整性
- **开放集成**：支持与第三方系统通过标准协议无缝集成，降低对接成本


## 3. 使用场景和适用范围

### 3.1 典型使用场景
- **企业内部多系统整合**：如ERP、CRM、OA等系统的统一身份认证与单点登录
- **跨组织身份互信**：通过SAML 2.0/OAuth 2.0实现合作伙伴系统间身份互通
- **多租户管理**：支持不同业务单元或客户独立管理其用户与权限体系
- **云原生环境适配**：兼容容器化部署，可与Kubernetes等编排平台集成

### 3.2 适用范围
- **企业规模**：中小企业至大型企业
- **行业领域**：金融、政府、教育、医疗、互联网等需严格身份管控的行业
- **部署环境**：支持Linux、Windows等主流操作系统的Docker环境


## 4. 使用方法和配置说明

### 4.1 前置条件
- Docker Engine 20.10+ 及 Docker Compose（推荐）
- 服务器配置：至少2核CPU、4GB内存、20GB可用磁盘空间
- 网络要求：开放服务端口（默认8080/TCP，HTTPS可选8443/TCP）


### 4.2 获取镜像
MaxKey Docker镜像可通过官方渠道获取（具体以官方最新文档为准）：
- 官方代码仓库：[GitHub](https://github.com/dromara/MaxKey) | [码云(Gitee)](https://gitee.com/dromara/MaxKey)
- 官方安装指南：[MaxKey 安装部署](https://www.maxkey.top/zh/about/download.html)


### 4.3 基本使用（docker run）
```bash
docker run -d \
  --name maxkey \
  -p 8080:8080 \
  -p 8443:8443 \
  -v /data/maxkey/conf:/usr/local/maxkey/conf \
  -v /data/maxkey/data:/usr/local/maxkey/data \
  -v /data/maxkey/logs:/usr/local/maxkey/logs \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e DB_HOST=mysql-host \
  -e DB_PORT=3306 \
  -e DB_NAME=maxkey \
  -e DB_USER=maxkey_user \
  -e DB_PASSWORD=your_secure_password \
  maxkey/maxkey:latest
```
> 注：`maxkey/maxkey:latest`为示例镜像名称，实际请以官方提供的镜像标签为准。


### 4.4 Docker Compose 配置示例
```yaml
version: '3.8'

services:
  maxkey:
    image: maxkey/maxkey:latest
    container_name: maxkey
    restart: always
    ports:
      - "8080:8080"
      - "8443:8443"
    volumes:
      - ./maxkey/conf:/usr/local/maxkey/conf
      - ./maxkey/data:/usr/local/maxkey/data
      - ./maxkey/logs:/usr/local/maxkey/logs
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_NAME=maxkey
      - DB_USER=maxkey_user
      - DB_PASSWORD=your_secure_password
      - SERVER_PORT=8080
      - LOG_LEVEL=INFO
    depends_on:
      - mysql

  mysql:
    image: mysql:8.0
    container_name: maxkey-mysql
    restart: always
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/data:/var/lib/mysql
      - ./mysql/conf:/etc/mysql/conf.d
      - ./mysql/init:/docker-entrypoint-initdb.d
    environment:
      - MYSQL_ROOT_PASSWORD=root_password
      - MYSQL_DATABASE=maxkey
      - MYSQL_USER=maxkey_user
      - MYSQL_PASSWORD=your_secure_password
```
> 说明：配置包含MaxKey与MySQL联动部署，初始化SQL脚本可放入`./mysql/init`目录，容器启动时自动执行。


### 4.5 配置参数说明

#### 4.5.1 核心环境变量
| 环境变量名                | 描述                          | 默认值       | 是否必填 |
|---------------------------|-------------------------------|--------------|----------|
| `SPRING_PROFILES_ACTIVE`  | 激活的Spring环境配置文件      | `prod`       | 否       |
| `DB_HOST`                 | 数据库主机地址                | -            | 是       |
| `DB_PORT`                 | 数据库端口                    | `3306`       | 否       |
| `DB_NAME`                 | 数据库名称                    | `maxkey`     | 否       |
| `DB_USER`                 | 数据库用户名                  | -            | 是       |
| `DB_PASSWORD`             | 数据库密码                    | -            | 是       |
| `SERVER_PORT`             | 应用服务端口                  | `8080`       | 否       |
| `LOG_LEVEL`               | 日志级别（DEBUG/INFO/WARN/ERROR） | `INFO`    | 否       |

#### 4.5.2 数据卷挂载
| 宿主机路径示例       | 容器内路径                  | 描述                  |
|----------------------|-----------------------------|-----------------------|
| `/data/maxkey/conf`  | `/usr/local/maxkey/conf`    | 配置文件持久化        |
| `/data/maxkey/data`  | `/usr/local/maxkey/data`    | 应用数据存储（证书等）|
| `/data/maxkey/logs`  | `/usr/local/maxkey/logs`    | 日志文件持久化        |

#### 4.5.3 端口映射
| 宿主机端口 | 容器内端口 | 描述                  |
|------------|------------|-----------------------|
| `8080`     | `8080`     | HTTP服务端口          |
| `8443`     | `8443`     | HTTPS服务端口（可选） |


## 5. 官方资源与支持

- **官方网站**：[https://www.maxkey.top](https://www.maxkey.top)
- **代码托管**：[GitHub](https://github.com/dromara/MaxKey) | [码云(Gitee)](https://gitee.com/dromara/MaxKey)
- **安装部署文档**：[MaxKey 安装部署](https://www.maxkey.top/zh/about/download.html)
- **技术支持**：QQ群（1054466084）、邮箱（support@maxsso.net）
