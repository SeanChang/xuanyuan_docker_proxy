---
image: osixia/openldap
description: "带有TLS、多主复制和简易引导功能的OpenLDAP镜像。"
source: https://xuanyuan.cloud/zh/r/osixia/openldap
canonical: https://xuanyuan.cloud/zh/r/osixia/openldap
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/osixia/openldap" title="osixia/openldap Docker 镜像中文简介、标签列表与拉取命令">osixia/openldap 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## docker-openldap 镜像文档

### 镜像概述
docker-openldap是一个基于OpenLDAP的Docker镜像，提供便捷的目录服务部署方案。该镜像集成TLS加密、多主复制功能，并支持简易引导配置，适用于快速搭建企业级LDAP服务。镜像源代码和详细帮助文档可在GitHub获取：[https://github.com/osixia/docker-openldap](https://github.com/osixia/docker-openldap)。

### 核心功能与特性
- **TLS加密**：支持SSL/TLS协议，保障数据传输安全
- **多主复制**：实现多主节点数据同步，提升服务可用性和容错能力
- **简易引导**：提供简化的初始化配置流程，降低部署复杂度
- **灵活配置**：支持通过环境变量、配置文件自定义LDAP服务参数
- **容器化部署**：基于Docker容器，资源占用低，易于集成到现有架构

### 使用场景
- 企业内部用户身份认证与授权管理
- 应用系统的统一用户目录服务
- 需要高可用性和数据一致性的分布式LDAP部署
- 开发测试环境中的LDAP服务快速搭建

### 使用方法

#### 基本部署
通过以下命令启动单节点OpenLDAP服务：
```docker
docker run --name openldap -p 389:389 -p 636:636 -d docker.xuanyuan.run/osixia/openldap
```

#### 多主复制配置
启用多主复制需指定相关环境变量，示例：
```docker
docker run --name openldap-master1 \
  -e LDAP_REPLICATION=true \
  -e LDAP_REPLICATION_HOSTS="#PYTHON2BASH:['ldap://master1.example.com','ldap://master2.example.com']" \
  -d docker.xuanyuan.run/osixia/openldap
```
详细配置步骤请参考GitHub文档。

#### 环境变量配置
常用环境变量说明：
- `LDAP_DOMAIN`：LDAP域名（如`example.com`）
- `LDAP_ADMIN_PASSWORD`：管理员密码
- `LDAP_REPLICATION`：是否启用复制（设为`true`启用）
- `LDAP_TLS`：是否启用TLS（设为`true`启用）

更多配置参数和高级用法，请访问GitHub仓库：[https://github.com/osixia/docker-openldap](https://github.com/osixia/docker-openldap)
