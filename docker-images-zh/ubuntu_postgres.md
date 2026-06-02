<!-- xuanyuan-docker-images-zh
image: ubuntu/postgres
source: https://xuanyuan.cloud/zh/r/ubuntu/postgres
canonical: https://xuanyuan.cloud/zh/r/ubuntu/postgres
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/ubuntu/postgres" title="ubuntu/postgres Docker 镜像中文简介、标签列表与拉取命令">ubuntu/postgres — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/ubuntu/postgres" title="ubuntu/postgres Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/postgres</a></p>

# Postgres | Ubuntu 镜像介绍  


当前的 Postgres Docker 镜像基于 Ubuntu，由 Canonical 提供，会持续接收安全更新，并自动滚动至更新的 Postgres 或 Ubuntu 版本。**本仓库可免费使用，且不受每用户速率限制。**


## 关于 Postgres  

PostgreSQL 是一款功能强大的开源对象关系型数据库系统。它完全符合 ACID 标准，全面支持外键、连接、视图、触发器及存储过程（支持多种语言）。支持多数 SQL:2008 数据类型，包括 INTEGER、NUMERIC、BOOLEAN、CHAR、VARCHAR、DATE、INTERVAL、TIMESTAMP 等，还可存储图片、音频、视频等二进制大对象。提供 C/C++、Java、.Net、Perl、Python、Ruby、Tcl、ODBC 等原生编程接口，文档完善。更多信息见 [PostgreSQL 官网]([])。


## 标签与架构  

![LTS]([])  
LTS 通道提供最长 5 年免费安全维护。  

![ESM]([])  
ESM 通道通过 [Canonical 受限仓库]([]) 提供最长 10 年客户安全维护。  


| 通道标签（Channel Tags） | 支持截止时间 | 当前版本 | 架构 |  
|---|---|---|---|  
| **`14-22.04_beta`** | 2027-04 | Ubuntu 22.04 LTS 上的 Postgres 14 | `amd64`、`arm64`、`ppc64el`、`s390x` |  
| `12-20.04_beta` | 2025-04 | Ubuntu 20.04 LTS 上的 Postgres 12.4 | `amd64`、`arm64`、`ppc64el`、`s390x` |  
| _`track_risk`_ |  


通道标签按稳定性排序：`stable`（稳定）、`candidate`（候选）、`beta`（测试）、`edge`（边缘）。更具风险的通道默认隐含可用，例如若列出 `beta`，则可拉取 `edge`；若列出 `candidate`，则可拉取 `beta` 和 `edge`；若列出 `stable`，则四个通道均可用。镜像会按 `edge` → `beta` → `candidate` → `stable` 顺序逐步发布。  


### 商业使用与扩展安全维护（ESM）通道  
若需商业再分发，或需要 ESM 通道及未列出的版本/通道，请 [联系 Canonical 团队]([])（或发送邮件至 [邮箱已删除]）。  


## 使用方法  


### 本地启动镜像  

```sh
docker run -d --name postgres-container -e TZ=UTC -p 30432:5432 -e POSTGRES_PASSWORD=My:s3Cr3t/ ubuntu/postgres:14-22.04_beta
```  
启动后，可通过 `localhost:30432` 访问 PostgreSQL 服务。  


### 参数说明  

| 参数 | 描述 |  
|---|---|  
| `-e TZ=UTC` | 设置时区。 |  
| `-e POSTGRES_PASSWORD=secret` | 设置默认超级用户（`postgres`）的密码。注意：本地连接数据库无需密码，但外部主机（如其他容器）访问时需密码。**此参数为必填项，且不可为空**。 |  
| `-e POSTGRES_USER=john` | 创建具有超级用户权限的新用户，需与 `POSTGRES_PASSWORD` 配合使用。 |  
| `-e POSTGRES_DB=db_test` | 设置默认数据库名称。 |  
| `-e POSTGRES_INITDB_ARGS="--data-checksums"` | 传递参数至 `postgres initdb` 命令。 |  
| `-e POSTGRES_INITDB_WALDIR=/path/to/location` | 设置 Postgres 事务日志位置，默认存储在主数据目录（`PGDATA`）的子目录中。 |  
| `-e POSTGRES_HOST_AUTH_METHOD=trust` | 为 `host` 类型连接（所有数据库、用户、地址）设置认证方式。若传递此参数，会在 `pg_hba.conf` 中添加：`host all all all $POSTGRES_HOST_AUTH_METHOD`。 |  
| `-e PGDATA=/path/to/location` | 设置数据库文件存储位置，默认路径为 `/var/lib/postgresql/data`。 |  
| `-p 30432:5432` | 将 Postgres 服务暴露至 `localhost:30432`。 |  
| `-v /path/to/postgresql.conf:/etc/postgresql/postgresql.conf` | 挂载本地 [配置文件]([])（示例配置见 [此处]([])）。 |  


### 初始化脚本  

可通过添加初始化脚本自定义数据库配置，支持 `*.sql`、`*.sql.gz` 和 `*.sh` 文件，需放置于容器内 `/docker-entrypoint-initdb.d` 目录。脚本执行规则：  
1. 按字母顺序运行所有 `*.sql` 文件（使用 `POSTGRES_USER` 权限）；  
2. 按字母顺序运行所有可执行 `*.sh` 脚本；  
3. 按字母顺序加载所有非可执行 `*.sh` 脚本。  

**注意**：若 `PGDATA` 目录已存在数据（非空），初始化脚本将不执行。  


### 测试与调试  

#### 查看容器日志  
```sh
docker logs -f postgres-container
```  

#### 进入容器交互式终端  
```sh
docker exec -it postgres-container /bin/bash
```  

#### 使用 `psql` 客户端连接  
```sh
$ docker network create postgres-network  # 创建网络  
$ docker network connect postgres-network postgres-container  # 连接容器至网络  
$ docker run -it --rm --network postgres-network ubuntu/postgres:14-22.04_beta psql -h postgres-container -U postgres  # 运行客户端  
```  
执行后输入密码（如示例中的 `My:s3Cr3t/`），即可登录数据库。  


## Kubernetes 部署  

适用于任何 Kubernetes 环境；若未部署 Kubernetes，推荐安装 [MicroK8s]([])，并执行 `microk8s.enable dns storage`，再通过 `snap alias microk8s.kubectl kubectl` 设置 `kubectl` 别名。  

1. 下载 [postgresql.conf]([]) 和 [postgres-deployment.yml]([])；  
2. 在 `postgres-deployment.yml` 中设置 `containers.postgres.image` 为目标通道标签（如 `ubuntu/postgres:14-22.04_beta`）；  
3. 执行部署命令：  
   ```sh
   kubectl create configmap postgres-config --from-file=main-config=postgresql.conf  
   kubectl apply -f postgres-deployment.yml  
   ```  

部署完成后，可通过 `localhost:30306` 访问 Postgres 服务。  


## 问题反馈与功能请求  

若发现镜像 bug 或需请求功能，请在以下链接提交 issue：  
[[]]([])  

**标题格式**：`postgres: <问题摘要>`。提交时需包含所用镜像的 digest，可通过以下命令获取：  
```sh
docker images --no-trunc --quiet ubuntu/postgres:<tag>
```  


## 已弃用通道与标签  

以下通道（标签）不再更新，请升级至新版本，或联系支持团队（若无法升级）。  

| 通道 | 版本 | 停止维护时间 | 升级路径 |  
|---|---|---|---|  
| ~~13-21.10~~ | Ubuntu 21.10 上的 Postgres 13.1 | 2022-07 | ~~13.1-22.04~~ |  
| ~~13-21.04~~ | Ubuntu 21.04 上的 Postgres 13.1 | 2022-01 | ~~13.1-21.10~~ |  
| _`track`_ |  


 

--- 

以上内容基于 Canonical 提供的官方镜像文档整理，确保安全性与可操作性。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/ubuntu/postgres" title="ubuntu/postgres Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/postgres</a></p>
