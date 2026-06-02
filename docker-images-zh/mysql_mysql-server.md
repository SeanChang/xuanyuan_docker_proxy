---
image: mysql/mysql-server
description: "这是由Oracle官方MySQL团队创建、维护并提供支持的优化MySQL服务器Docker镜像，专为高效部署与运行MySQL数据库服务而设计，确保用户能在容器环境中便捷、稳定地使用经过专业优化的MySQL服务器，同时享受来自官方团队的持续技术保障与维护支持。"
source: https://xuanyuan.cloud/zh/r/mysql/mysql-server
canonical: https://xuanyuan.cloud/zh/r/mysql/mysql-server
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mysql/mysql-server" title="mysql/mysql-server Docker 镜像中文简介、标签列表与拉取命令">mysql/mysql-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mysql/mysql-server" title="mysql/mysql-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mysql/mysql-server</a>

![logo]([])


## MySQL 简介  
MySQL 是全球最流行的开源数据库。凭借经过验证的性能、可靠性和易用性，它已成为各类 Web 应用的首选数据库，覆盖个人网站、小型在线商店，乃至 、、 等大型高流量平台。  

获取 MySQL Server 及其他产品的更多信息和下载资源，请访问 <[]>。  


## 支持的标签及对应 Dockerfile 链接  

> **警告**  
> MySQL 团队维护的 Docker 镜像专为 Linux 平台构建。其他平台不受支持，用户在非 Linux 系统上使用此类镜像需自行承担风险。有关非 Linux 系统运行容器的已知限制，可参考 [此处讨论]([])。  


以下是 MySQL 团队（Oracle）创建并维护的部分优化版 MySQL Server Docker 镜像标签（完整列表见 [镜像标签页]([])）：  

- **MySQL Server 5.7**（标签：[`5.7`]([])）  
  对应 Dockerfile：[mysql-server/5.7/Dockerfile]([])  

- **MySQL Server 8.0**（最新通用可用版，支持 x86 和 AArch64(ARM64) 架构）  
  标签：[`8.0`, `latest`]([])  
  对应 Dockerfile：[mysql-server/8.0/Dockerfile]([])  


镜像会随 MySQL Server 维护版本和开发里程碑发布而更新。请注意，所有非 GA（通用可用）版本仅用于预览，不得用于生产环境。团队也会不定期发布包含实验性功能的特殊镜像。  


## 快速参考  

- **详细文档**：参见《MySQL 参考手册》中的 [《在 Linux 上通过 Docker 部署 MySQL》]([])  
- **问题反馈**：请在 <[]> 提交 bug 报告，类别选择“MySQL Package Repos and Docker Images”  
- **维护方**：Oracle 的 MySQL 团队  
- **镜像源码**：[`mysql/mysql-server` 容器镜像仓库]([])  
- **支持的 Docker 版本**：支持最新稳定版。旧版本（最低 1.0）会尽力提供支持，但强烈建议使用最新稳定版 Docker（本文档默认基于最新版编写）  


## 如何使用 MySQL 镜像  


### 下载 MySQL Server Docker 镜像  
虽然无需单独下载镜像（运行容器时会自动拉取），但提前下载可确保本地镜像为最新版。  

下载 MySQL 社区版镜像的命令：  
```shell
docker pull mysql/mysql-server:tag
```  
> 参考上文“支持的标签”列表。若省略 `:tag`，则默认使用 `latest` 标签，即拉取最新 GA 版本的 MySQL Server 镜像。  


### 启动 MySQL Server 实例  
通过以下命令启动 MySQL 社区版容器：  
```shell
docker run --name=mysql1 -d mysql/mysql-server:tag
```  
- `--name=mysql1`：自定义容器名称（示例中为 `mysql1`），可选；若不指定，Docker 会生成随机名称。  
- 若本地无指定标签的镜像，命令会先拉取镜像，再初始化容器。初始化完成后，容器会出现在 `docker ps` 的运行列表中：  
  ```shell
  docker ps
  CONTAINER ID   IMAGE                COMMAND                  CREATED             STATUS                              PORTS                NAMES
  a24888f0d6f4   mysql/mysql-server   "/entrypoint.sh my..."   14 seconds ago      Up 13 seconds (health: starting)    3306/tcp, 33060/tcp  mysql1
  ```  
- 容器初始化需要时间，当 `STATUS` 从 `(health: starting)` 变为 `(healthy)` 时，服务就绪。  
- 查看容器日志（包括初始化信息）：  
  ```shell
  docker logs mysql1
  ```  
- 初始化完成后，日志会包含 root 用户的随机生成密码，可通过以下命令提取：  
  ```shell
  docker logs mysql1 2>&1 | grep GENERATED
  GENERATED ROOT PASSWORD: Axegh3kAJyDLaRuBemecis&EShOs  # 示例密码
  ```  


### 从容器内连接 MySQL Server  
服务就绪后，可在容器内运行 `mysql` 客户端连接服务器。使用 `docker exec -it` 命令启动客户端：  
```shell
docker exec -it mysql1 mysql -uroot -p
```  
- 输入上述步骤中获取的随机 root 密码。  
- 由于 `MYSQL_ONETIME_PASSWORD` 选项默认启用，首次连接后必须重置 root 密码：  
  ```sql
  mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';  # 将 'password' 替换为自定义密码
  ```  
密码重置后，服务器即可正常使用。  


### 容器中包含的产品  
MySQL Server Docker 镜像包含以下产品：  
- MySQL Server 及相关工具：`mysql` 客户端、`mysqladmin`、`mysqldump` 等，文档见《MySQL 参考手册》的 [程序概述]([])。  
- MySQL Shell：文档见《MySQL Shell 用户指南》的 [MySQL Shell]([])。  


### 更多部署主题  
关于 Docker 部署 MySQL Server 的更多内容（如服务配置、数据持久化、日志管理、版本升级、环境变量等），参见《MySQL Server 手册》的 [通过 Docker 部署 MySQL Server]([])。
