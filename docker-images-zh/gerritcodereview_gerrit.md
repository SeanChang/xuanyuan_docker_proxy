---
image: gerritcodereview/gerrit
description: "官方Gerrit代码审查Docker镜像是由Gerrit项目官方发布的容器化部署方案，旨在为开发团队提供便捷、高效的代码审查系统运行环境，该镜像集成了Gerrit代码审查工具的核心功能，支持基于Git的版本控制、代码提交审核流程、团队协作管理等，通过Docker容器化技术简化了传统部署的复杂性，用户可快速拉取并启动镜像，实现代码审查系统的一键部署与运行，适用于各类软件开发团队构建规范的代码审查流程，提升代码质量与团队协作效率。"
source: https://xuanyuan.cloud/zh/r/gerritcodereview/gerrit
canonical: https://xuanyuan.cloud/zh/r/gerritcodereview/gerrit
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/gerritcodereview/gerrit" title="gerritcodereview/gerrit Docker 镜像中文简介、标签列表与拉取命令">gerritcodereview/gerrit — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/gerritcodereview/gerrit" title="gerritcodereview/gerrit Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/gerritcodereview/gerrit</a>

# Gerrit Code Review Docker 镜像


## 简介  
Gerrit Code Review 官方 Docker 镜像提供开箱即用的配置，包含 H2 数据库和 DEVELOPMENT 账户设置。  
该镜像可直接用于培训或 staging 环境；若用于生产，需作为基础镜像，自定义 `gerrit.config` 并配置持久化外部模块。


## 快速启动  
以下步骤可快速启动 Gerrit 的演示/ staging 环境：  

1. 运行 Docker 命令：  
   ```bash
   docker run -ti -p 8080:8080 -p 29418:29418 gerritcodereview/gerrit
   ```  

2. 等待几分钟，直至出现 `Gerrit Code Review NNN ready` 消息（NNN 为当前 Gerrit 版本）。  

3. 打开浏览器访问 `[] 即可使用 Gerrit。  

*注意：若 Docker 服务器运行在远程主机，需将 `localhost` 替换为远程主机的域名或 IP。*  

> 从 2.14 版本开始，新增引导页面，可指导基础操作并从 [Gerrit CI]([]) 下载安装额外插件。  

如需运行指定版本（如 3.3.0），可使用带标签的镜像：  
```bash
docker run -ti -p 8080:8080 -p 29418:29418 gerritcodereview/gerrit:3.3.0
```  


## 构建 Docker 镜像  

### 构建已发布版本  
Git 仓库中已为各 Gerrit 版本（如 3.3.0）打标签，标签指向对应版本 Dockerfile 的代码状态。构建步骤：  

1. 检出目标版本标签：  
   ```bash
   git checkout v3.3.0
   ```  

2. 进入系统对应目录（`centos/8` 或 `ubuntu/20`），运行构建命令：  
   ```bash
   docker build -t gerritcodereview/gerrit:$(git describe) .
   ```  


### 构建开发版本  
如需测试自定义 Gerrit 构建，通过 `GERRIT_WAR_URL` 参数指定 Gerrit war 包 URL：  
```bash
docker build --build-arg GERRIT_WAR_URL="<war包URL>" -t gerritcodereview/gerrit -f Dockerfile-dev .
```  
*默认 URL 指向 Gerrit CI 上 master 分支的最新成功构建结果。*  


## 使用持久卷  
通过 Docker 持久卷可在重启后保留 Gerrit 数据。以下是 `docker-compose.yaml` 示例，挂载 Git 仓库、索引和缓存目录：  

```yaml
version: '3'

services:
  gerrit:
    image: gerritcodereview/gerrit
    volumes:
       - git-volume:/var/gerrit/git    # Git 仓库数据
       - index-volume:/var/gerrit/index  # 索引数据
       - cache-volume:/var/gerrit/cache  # 缓存数据
    ports:
       - "29418:29418"  # SSH 端口
       - "8080:8080"    # HTTP 端口

volumes:
  git-volume:
  index-volume:
  cache-volume:
```  

运行 `docker-compose up` 启动配置。  


## 环境变量  
可通过以下环境变量修改 Gerrit 配置：  

- `CANONICAL_WEB_URL`：可选，设置 `gerrit.config` 中的 `gerrit.canonicalWebUrl`，默认值为 `http://<镜像主机名>`。  
- `HTTPD_LISTEN_URL`：可选，覆盖 `gerrit.config` 中的 `httpd.listenUrl` 参数。  


## 生产环境使用  
生产环境需注意：使用高性能外部存储（优于 Docker 内部 AUFS）、独立配置目录（便于变更追踪），并配置外部认证（如 LDAP）。  

### 示例：集成 OpenLDAP 的 docker-compose 配置  
假设外部目录 `/external/gerrit` 已存在，以下是完整配置（含 OpenLDAP 和 PhpLdapAdmin）：  

#### docker-compose.yaml  
```yaml
version: '3'

services:
  gerrit:
    image: gerritcodereview/gerrit
    ports:
      - "29418:29418"
      - "80:8080"
    depends_on:
      - ldap
    volumes:
      - /external/gerrit/etc:/var/gerrit/etc      # 配置文件
      - /external/gerrit/git:/var/gerrit/git      # Git 仓库
      - /external/gerrit/db:/var/gerrit/db        # 数据库
      - /external/gerrit/index:/var/gerrit/index  # 索引
      - /external/gerrit/cache:/var/gerrit/cache  # 缓存
    environment:
      - CANONICAL_WEB_URL=[]    # command: init  # 初始化时取消注释

  ldap:
    image: osixia/openldap
    ports:
      - "389:389"
      - "636:636"
    environment:
      - LDAP_ADMIN_PASSWORD=secret
    volumes:
      - /external/gerrit/ldap/var:/var/lib/ldap    # LDAP 数据
      - /external/gerrit/ldap/etc:/etc/ldap/slapd.d # LDAP 配置

  ldap-admin:
    image: osixia/phpldapadmin
    ports:
      - "6443:443"
    environment:
      - PHPLDAPADMIN_LDAP_HOSTS=ldap
```  

#### gerrit.config（位于 `/external/gerrit/etc/`）  
```ini
[gerrit]
  basePath = git

[index]
  type = LUCENE

[auth]
  type = ldap
  gitBasicAuth = true

[ldap]
  server = ldap://ldap
  username=cn=admin,dc=example,dc=org
  accountBase = dc=example,dc=org
  accountPattern = (&(objectClass=person)(uid=${username}))
  accountFullName = displayName
  accountEmailAddress = mail

[sendemail]
  smtpServer = localhost

[sshd]
  listenAddress = *:29418

[httpd]
  listenUrl = []]
  directory = cache

[container]
  user = root
```  

#### secure.config（位于 `/external/gerrit/etc/`，存储敏感信息）  
```ini
[ldap]
  password = secret  # LDAP 管理员密码
```  


### 初始化 Gerrit 数据  
外部文件系统需通过 `gerrit.war` 初始化（创建 All-Projects、All-Users 仓库及系统组 UUID）：  

#### 步骤 1：执行初始化  
1. 取消 `docker-compose.yaml` 中 `gerrit` 服务的 `command: init` 注释。  
2. 前台运行 Gerrit 容器：  
   ```bash
   docker-compose up gerrit
   ```  
3. 等待输出 `Initialized /var/gerrit` 后，容器会自动退出。  

#### 步骤 2：后台启动服务  
1. 注释 `command: init`，启动所有服务：  
   ```bash
   docker-compose up -d
   ```  


### 通过 PhpLdapAdmin 管理 LDAP 用户  
PhpLdapAdmin 可通过 `[] 访问，用于管理 LDAP 用户。首次登录 Gerrit 的用户会被设为管理员，需提前在 LDAP 中创建管理员账户。  

#### 创建 Gerrit 管理员  
1. 登录 PhpLdapAdmin：  
   - 用户名：`cn=admin,dc=example,dc=org`  
   - 密码：`secret`  
2. 创建“Courier Mail Account”类型用户，示例信息：  
   - 名：Gerrit  
   - 姓：Admin  
   - 通用名：Gerrit Admin  
   - 用户 ID：gerritadmin  
   - 邮箱：gerritadmin@localdomain  
   - 密码：secret  

#### 登录 Gerrit 管理员账户  
访问 `[] `gerritadmin` 和密码 `secret` 登录，完成初始化配置。  


## 更多信息  
- 查看 Gerrit 文档：`[]  
- Gerrit 官方主页：[[]]([])
