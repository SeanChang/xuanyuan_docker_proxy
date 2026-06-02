---
image: ubuntu/mysql
description: "MySQL是一款广泛应用于各类Web应用、企业级系统及数据存储场景的开源SQL数据库，它以快速的数据处理能力、稳定的运行性能和高效的多线程架构为核心优势，其长期版本的维护工作由Canonical负责，为用户提供持续的技术支持、安全更新及功能优化服务，是全球众多开发者和企业信赖的数据库解决方案。"
source: https://xuanyuan.cloud/zh/r/ubuntu/mysql
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[ubuntu/mysql](https://xuanyuan.cloud/zh/r/ubuntu/mysql)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# MySQL Docker镜像（基于Ubuntu）


## 关于本镜像  
本镜像为Canonical提供的MySQL Docker镜像，基于Ubuntu系统构建。镜像会持续接收安全更新，并自动滚动升级至更新的MySQL版本或Ubuntu发行版。该仓库可免费使用，且不受用户速率限制。


## MySQL简介  
MySQL是一款快速、稳定的多用户、多线程SQL数据库服务器。SQL（结构化查询语言）是全球最流行的数据库查询语言，而MySQL的核心目标是实现速度、健壮性与易用性的平衡。更多详情可参考[MySQL官方文档]([])。


## 标签与架构  

### 维护支持说明  
- **LTS**：LTS渠道提供长达5年的免费安全维护。  
- **ESM**：通过Canonical的受限仓库可提供长达10年的客户安全维护（[联系Canonical获取]([])）。  


### 渠道标签与架构详情  

| 渠道标签                | 关联标签               | 支持截止时间 | 当前版本                          | 支持架构                                   |
|-------------------------|------------------------|--------------|-----------------------------------|--------------------------------------------|
| **`8.0-24.04_beta`**    | **`edge`**, `latest`   | -            | MySQL 8.0 基于 Ubuntu 24.04 LTS   | `arm64`, `amd64`                           |
| `8.0-22.04_beta`        | `8.0-22.04_edge`       | -            | MySQL 8.0 基于 Ubuntu 22.04 LTS   | `amd64`, `s390x`, `ppc64le`, `arm64`       |
| `8.0-21.10_beta`        | `8.0-21.10_edge`       | -            | MySQL 8.0 基于 Ubuntu 21.10       | `s390x`, `amd64`, `arm64`, `ppc64le`       |
| `8.0-21.04_beta`        | `8.0-21.04_edge`       | -            | MySQL 8.0 基于 Ubuntu 21.04       | `s390x`, `arm64`, `amd64`, `ppc64le`       |
| `8.0-20.04_beta`        | `8.0-20.04_edge`       | -            | MySQL 8.0 基于 Ubuntu 20.04 LTS   | `s390x`, `arm64`, `amd64`, `ppc64le`       |
| `8.0-24.04_edge`        | `8.0-24.04_edge`       | -            | MySQL 8.0 基于 Ubuntu 24.04 LTS   | `amd64`, `s390x`, `arm64`                  |
| _`track_risk`_          |                        |              |                                    |                                            |  


### 渠道稳定性说明  
渠道标签按稳定性从高到低排序为：`stable`、`candidate`、`beta`、`edge`。高风险渠道默认可用，例如若列出`beta`，则`edge`也可拉取；若列出`candidate`，则`beta`和`edge`可拉取；若列出`stable`，则四个渠道均可用。镜像版本会按`edge`→`beta`→`candidate`→`stable`的顺序逐步发布。


## 使用方法  

### 本地启动  
通过以下命令启动镜像：  
```bash
docker run -d --name mysql-container -e TZ=UTC -e MYSQL_ROOT_PASSWORD=My:S3cr3t -p 30306:3306 ubuntu/mysql:8.0-24.04_beta
```  
启动后，可通过`localhost:30306`访问MySQL服务。


### 参数说明  

| 参数                          | 描述                                                                 |
|-------------------------------|----------------------------------------------------------------------|
| `-e TZ=UTC`                   | 时区设置（示例为UTC）。                                              |
| `-e MYSQL_ROOT_PASSWORD=xxx`  | 设置root用户密码（必填，不可为空）。                                 |
| `-e MYSQL_PASSWORD=xxx`       | 为`MYSQL_USER`用户设置密码。                                         |
| `-e MYSQL_USER=xxx`           | 创建新用户（带超级用户权限），需配合`MYSQL_PASSWORD`使用。            |
| `-e MYSQL_DATABASE=xxx`       | 设置默认数据库名称。                                                 |
| `-e MYSQL_ALLOW_EMPTY_PASSWORD=yes` | 允许root用户空密码（不建议生产环境使用，需确认风险）。               |
| `-e MYSQL_RANDOM_ROOT_PASSWORD=yes` | 生成随机root密码（密码会打印在日志中，搜索“GENERATED ROOT PASSWORD”）。 |
| `-e MYSQL_ONETIME_PASSWORD=yes` | 强制root用户首次登录修改密码。                                       |
| `-e MYSQL_INITSB_SKIP_TZINFO=yes` | 禁用入口脚本自动加载时区数据（设为任意非空值即可）。                 |
| `-p 30306:3306`               | 端口映射（本地30306端口映射容器3306端口）。                         |
| `-v /path/to/data:/var/lib/mysql` | 数据持久化（避免每次启动容器重新初始化数据库）。                     |
| `-v /path/to/config:/etc/mysql/mysql.conf.d/` | 挂载本地配置文件（参考[MySQL配置文档]([])）。 |


### 测试与调试  

- **查看容器日志**：  
  ```bash
  docker logs -f mysql-container
  ```  

- **进入容器交互式shell**：  
  ```bash
  docker exec -it mysql-container /bin/bash
  ```  


## 问题反馈与功能请求  
若发现镜像bug或需请求功能，可在[launchpad提交issue]([])，标题格式为`mysql: <问题摘要>`。提交时需附上镜像摘要，可通过以下命令获取：  
```bash
docker images --no-trunc --quiet ubuntu/mysql:<tag>
```  


## 已弃用渠道与标签  
以下渠道（标签）已停止更新，请升级至新版本；若无法升级，可[联系Canonical]([])。  

| 渠道（Track） | 版本（Version） | 停止维护时间（EOL） | 升级路径（Upgrade Path） |
|--------------|-----------------|---------------------|--------------------------|
| _`track`_    |                 |                     |                          |  


> **商业使用与ESM渠道**：若需商业分发或使用ESM渠道/未列出的版本，请[联系Canonical团队]([])（或发送邮件至[邮箱已删除]）。
