# OBPROXY-CE Docker 容器化部署指南

![OBPROXY-CE Docker 容器化部署指南](https://img.xuanyuan.dev/docker/blog/docker-oceanbase-obproxy-ce.png)

*分类: Docker,OBPROXY-CE | 标签: obproxy-ce,docker,部署教程 | 发布时间: 2025-11-26 05:50:11*

> OceanBase Database Proxy（简称OBPROXY-CE）是OceanBase数据库生态中的专用代理服务器，作为客户端与OceanBase集群之间的中间层，承担着SQL请求路由、负载均衡、连接管理、高可用切换等核心功能。通过OBPROXY-CE，用户可以透明地访问OceanBase集群，无需关心后端OBServer节点的具体分布和状态，显著简化了数据库集群的运维复杂度。

## 概述

OceanBase Database Proxy（简称OBPROXY-CE）是OceanBase数据库生态中的专用代理服务器，作为客户端与OceanBase集群之间的中间层，承担着SQL请求路由、负载均衡、连接管理、高可用切换等核心功能。通过OBPROXY-CE，用户可以透明地访问OceanBase集群，无需关心后端OBServer节点的具体分布和状态，显著简化了数据库集群的运维复杂度。

随着容器化技术的普及，Docker部署已成为应用交付的主流方式之一。OBPROXY-CE的容器化部署具有环境一致性、快速扩缩容、资源隔离等优势，尤其适合云原生环境下的自动化运维场景。本文将详细介绍如何通过Docker容器化方式部署OBPROXY-CE，从环境准备、镜像拉取到容器配置、功能验证，再到生产环境优化和故障排查，提供一套完整且可复现的实践方案。


## 环境准备

### Docker环境安装

OBPROXY-CE容器化部署依赖Docker引擎，以下是基于Linux系统的一键安装脚本，支持主流发行版（Ubuntu、CentOS、Debian等）：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

执行上述命令后，脚本将自动完成Docker引擎的安装、启动及开机自启配置。安装完成后，可通过以下命令验证Docker是否正常运行：

```bash
# 检查Docker版本
docker --version

# 检查Docker服务状态
systemctl status docker

# 验证Docker功能（运行hello-world容器）
docker run --rm xxx.xuanyuan.run/library/hello-world:latest
```

若输出"Hello from Docker!"等信息，则说明Docker环境已正确安装。


## 镜像准备


### 镜像拉取步骤

#### 1. 确认镜像标签

OBPROXY-CE镜像提供多个版本标签，推荐生产环境使用**固定版本标签**（如`4.2.1`）以确保稳定性，测试环境可使用`latest`标签获取最新版本。所有可用标签可参考[OBPROXY-CE镜像标签列表（轩辕）](https://xuanyuan.cloud/r/oceanbase/obproxy-ce/tags)。


#### 2. 执行拉取命令

根据多段镜像名规则，拉取命令格式如下：

```bash
# 拉取推荐的latest标签镜像
docker pull xxx.xuanyuan.run/oceanbase/obproxy-ce:latest

# 如需指定版本（以4.2.1为例），替换标签即可
# docker pull xxx.xuanyuan.run/oceanbase/obproxy-ce:4.2.1
```

> 说明：命令中`xxx.xuanyuan.run`为轩辕镜像访问支持地址，`oceanbase/obproxy-ce`为镜像原名，`latest`为推荐标签。


#### 3. 验证镜像拉取结果

拉取完成后，通过以下命令检查本地镜像列表：

```bash
docker images | grep obproxy-ce
```

若输出类似以下内容，说明镜像拉取成功：

```
xxx.xuanyuan.run/oceanbase/obproxy-ce   latest    xxxxxxxx1234   3 days ago    450MB
```


## 容器部署

### 环境变量配置

OBPROXY-CE运行依赖多个环境变量，根据官方文档，核心环境变量说明如下表：

| 环境变量名               | 描述                                                                 | 是否必填 | 备注                                                                 |
|--------------------------|----------------------------------------------------------------------|----------|----------------------------------------------------------------------|
| `APP_NAME`               | OBPROXY应用名称                                                      | 是       | 自定义名称，用于标识当前实例，如`obproxy-ce-instance-01`             |
| `PROXYRO_PASSWORD_HASH`  | `proxyro@sys`用户密码的SHA1哈希值                                    | 二选一   | 与`PROXYRO_PASSWORD`二选一，优先使用哈希值（更安全）                 |
| `PROXYRO_PASSWORD`       | `proxyro@sys`用户的明文密码                                          | 二选一   | 若未提供哈希值，需填写明文密码，容器启动时会自动转换为哈希           |
| `CONFIG_URL`             | 配置文件的HTTP/HTTPS地址                                             | 二选一   | 与`RS_LIST`二选一，用于从远程URL加载配置                             |
| `RS_LIST`                | OceanBase集群RootService节点列表，格式为`ip:port;ip:port`            | 二选一   | 需包含至少一个可用的RootService地址，如`10.0.0.1:2882;10.0.0.2:2882` |
| `OB_CLUSTER`             | OceanBase集群名称                                                    | 是（若使用`RS_LIST`） | 与OceanBase集群的`cluster_name`保持一致，如`obcluster`               |


### 容器启动命令

根据上述环境变量配置，以下是OBPROXY-CE容器的典型启动命令（以`RS_LIST`模式为例，需替换实际参数）：

```bash
docker run -d \
  --name obproxy-ce \
  --net=host \  # 推荐使用host网络以避免端口映射冲突（或手动映射所需端口）
  -e APP_NAME="obproxy-ce-prod" \
  -e PROXYRO_PASSWORD="OceanBase123" \  # 生产环境建议使用哈希值
  -e RS_LIST="10.0.0.10:2882;10.0.0.11:2882" \  # 替换为实际RootService地址
  -e OB_CLUSTER="obcluster" \  # 替换为实际集群名称
  --restart=always \  # 配置容器开机自启
  xxx.xuanyuan.run/oceanbase/obproxy-ce:latest
```

#### 命令参数说明：

- `-d`：后台运行容器；
- `--name obproxy-ce`：指定容器名称为`obproxy-ce`，便于后续管理；
- `--net=host`：使用主机网络模式（推荐），直接使用主机IP和端口，避免端口映射复杂配置；若需使用桥接网络，需添加`-p 2883:2883 -p 2884:2884`等端口映射（具体端口参考[OBPROXY-CE镜像文档（轩辕）](https://xuanyuan.cloud/r/oceanbase/obproxy-ce)）；
- `-e`：设置环境变量，根据实际环境替换`PROXYRO_PASSWORD`、`RS_LIST`、`OB_CLUSTER`等参数；
- `--restart=always`：配置容器在退出时自动重启，增强可用性。


### 容器状态验证

#### 1. 检查容器运行状态

```bash
docker ps | grep obproxy-ce
```

若输出中`STATUS`字段为`Up`，说明容器已正常启动：

```
abc123456def   xxx.xuanyuan.run/oceanbase/obproxy-ce:latest   "/entrypoint.sh"   5 minutes ago   Up 5 minutes             obproxy-ce
```


#### 2. 查看容器日志

通过日志确认OBPROXY-CE初始化过程是否正常：

```bash
docker logs -f obproxy-ce  # -f参数可实时跟踪日志输出
```

若日志中出现类似以下内容，说明服务启动成功：

```
[INFO] obproxy start successfully, listening on 0.0.0.0:2883
```


## 功能测试

### 测试环境准备

OBPROXY-CE作为OceanBase集群的代理，测试前需确保：
- OceanBase集群已正常运行（单节点或多节点均可）；
- `RS_LIST`中配置的RootService地址可访问；
- 客户端工具（如`mysql`或`obclient`）已安装。


### 连接测试

使用`mysql`客户端通过OBPROXY-CE连接OceanBase集群：

```bash
mysql -h 127.0.0.1 -P 2883 -u proxyro@sys#obcluster -pOceanBase123 -N -e "show databases;"
```

#### 参数说明：

- `-h 127.0.0.1`：OBPROXY-CE所在主机IP（本地测试用127.0.0.1）；
- `-P 2883`：OBPROXY-CE默认SQL端口（需与容器配置一致）；
- `-u proxyro@sys#obcluster`：用户名格式为`proxyro@sys#集群名`，`proxyro`为OBPROXY默认管理用户，`sys`为租户名，`obcluster`为集群名（与`OB_CLUSTER`环境变量一致）；
- `-pOceanBase123`：`proxyro@sys`用户的密码（与`PROXYRO_PASSWORD`环境变量一致）；
- `-N -e "show databases;"`：非交互式执行`show databases`命令。


### 测试结果验证

若命令输出类似以下内容，说明OBPROXY-CE已成功转发请求至OceanBase集群：

```
Database
information_schema
mysql
oceanbase
sys
```


### 高可用测试（可选）

模拟OBServer节点故障，验证OBPROXY-CE的自动路由能力：

1. 停止OceanBase集群中一个OBServer节点；
2. 通过OBPROXY-CE再次执行查询：
   ```bash
   mysql -h 127.0.0.1 -P 2883 -u proxyro@sys#obcluster -pOceanBase123 -N -e "select @@server_id;"
   ```
3. 观察返回结果是否自动切换至其他可用OBServer节点，若查询仍正常返回，则说明高可用路由功能生效。


## 生产环境建议

### 镜像版本管理

- **避免使用`latest`标签**：生产环境应指定具体版本标签（如`4.2.1`），避免因镜像更新导致非预期变更；
- **定期更新镜像**：关注[OBPROXY-CE镜像标签列表（轩辕）](https://xuanyuan.cloud/r/oceanbase/obproxy-ce/tags)，及时更新至稳定版本以修复已知漏洞。


### 资源配置优化

根据业务规模调整容器资源限制，推荐配置如下：

```bash
docker run -d \
  --name obproxy-ce \
  --net=host \
  -e APP_NAME="obproxy-ce-prod" \
  -e PROXYRO_PASSWORD_HASH="5f4dcc3b5aa765d61d8327deb882cf99" \  # 密码"password"的SHA1哈希
  -e RS_LIST="10.0.0.10:2882;10.0.0.11:2882" \
  -e OB_CLUSTER="obcluster" \
  --memory=4g \  # 限制内存为4GB
  --cpus=2 \  # 限制CPU为2核
  --oom-kill-disable \  # 禁用OOM杀死容器（需确保内存配置合理）
  --restart=always \
  xxx.xuanyuan.run/oceanbase/obproxy-ce:4.2.1
```


### 数据持久化

OBPROXY-CE的配置文件和日志建议通过Docker数据卷持久化至主机，避免容器重建后数据丢失：

```bash
# 创建本地目录
mkdir -p /data/obproxy/{conf,logs}
chmod 777 /data/obproxy/{conf,logs}  # 简化权限配置（生产环境可按需调整）

# 启动容器时挂载目录
docker run -d \
  --name obproxy-ce \
  --net=host \
  -v /data/obproxy/conf:/home/admin/obproxy/conf \  # 配置文件持久化
  -v /data/obproxy/logs:/home/admin/obproxy/logs \  # 日志持久化
  -e APP_NAME="obproxy-ce-prod" \
  -e PROXYRO_PASSWORD_HASH="5f4dcc3b5aa765d61d8327deb882cf99" \
  -e RS_LIST="10.0.0.10:2882;10.0.0.11:2882" \
  -e OB_CLUSTER="obcluster" \
  --restart=always \
  xxx.xuanyuan.run/oceanbase/obproxy-ce:4.2.1
```


### 安全加固

1. **使用非root用户运行容器**：
   ```bash
   # 创建本地用户（示例）
   useradd -u 1001 obproxy
   chown -R 1001:1001 /data/obproxy
   
   # 启动容器时指定用户
   docker run -d \
     --user=1001:1001 \  # 使用UID:GID而非用户名，避免容器内无用户信息
     ...  # 其他参数省略
   ```

2. **加密敏感环境变量**：避免明文传递密码，可通过Docker Secrets（Swarm模式）或外部配置中心（如Vault）管理敏感信息。

3. **限制容器权限**：添加`--cap-drop=ALL`禁用不必要的Linux capabilities，仅保留必需权限。


### 监控集成

OBPROXY-CE支持通过Prometheus暴露监控指标，配置步骤如下：

1. 在容器启动时添加监控端口映射（若使用桥接网络）：
   ```bash
   -p 2884:2884  # 监控指标端口（默认2884）
   ```

2. 在Prometheus配置文件中添加抓取任务：
   ```yaml
   scrape_configs:
     - job_name: 'obproxy'
       static_configs:
         - targets: ['obproxy-host:2884']  # OBPROXY-CE所在主机IP:端口
   ```

3. 通过Grafana导入OBPROXY监控面板（可参考[OBPROXY-CE镜像文档（轩辕）](https://xuanyuan.cloud/r/oceanbase/obproxy-ce)获取面板模板）。


## 故障排查

### 容器启动失败

#### 症状：`docker ps`无容器记录，或`STATUS`显示`Exited`

#### 排查步骤：

1. **查看启动日志**：
   ```bash
   docker logs obproxy-ce  # 即使容器已退出，仍可查看日志
   ```

2. **常见原因及解决**：
   - **环境变量缺失**：日志中提示`"APP_NAME is required"`，需检查`APP_NAME`是否配置；
   - **密码错误**：日志中提示`"invalid proxyro password"`，需确认`PROXYRO_PASSWORD`或`PROXYRO_PASSWORD_HASH`是否正确；
   - **RS_LIST不可访问**：日志中提示`"cannot connect to rootservice"`，需验证`RS_LIST`中地址的网络连通性（可通过`telnet 10.0.0.10 2882`测试端口是否开放）。


### 客户端连接失败

#### 症状：客户端提示`"Can't connect to MySQL server on '127.0.0.1:2883'"`

#### 排查步骤：

1. **检查容器网络**：
   ```bash
   # 若使用host网络，检查主机端口是否监听
   netstat -tulpn | grep 2883
   
   # 若使用桥接网络，检查端口映射是否正确
   docker port obproxy-ce
   ```

2. **验证防火墙规则**：确保主机防火墙允许2883端口入站流量：
   ```bash
   firewall-cmd --list-ports | grep 2883  # CentOS示例
   # 若未开放，添加规则：firewall-cmd --add-port=2883/tcp --permanent && firewall-cmd --reload
   ```

3. **检查OBPROXY配置**：进入容器查看配置文件（需持久化配置目录）：
   ```bash
   docker exec -it obproxy-ce cat /home/admin/obproxy/conf/obproxy_config.ini
   ```


### 请求转发异常

#### 症状：客户端连接成功，但执行查询提示`"No OBServer available"`

#### 排查步骤：

1. **检查RootService状态**：通过OceanBase集群的`sys`租户执行：
   ```sql
   SELECT * FROM __all_root_service;  # 确认RootService节点状态正常
   ```

2. **验证OBPROXY与OBServer连通性**：在容器内测试OBServer节点连通性：
   ```bash
   docker exec -it obproxy-ce telnet 10.0.0.10 2881  # OBServer的SQL端口（默认2881）
   ```

3. **查看OBPROXY路由表**：通过OBPROXY管理接口查看路由信息：
   ```bash
   # 连接OBPROXY管理端口（默认2883，使用admin用户）
   mysql -h 127.0.0.1 -P 2883 -u admin -p -e "show proxy route;"
   # 密码默认为空，若已修改需使用实际密码
   ```


## 参考资源

1. **OBPROXY-CE镜像文档（轩辕）**：[https://xuanyuan.cloud/r/oceanbase/obproxy-ce](https://xuanyuan.cloud/r/oceanbase/obproxy-ce)  
2. **OBPROXY-CE镜像标签列表（轩辕）**：[https://xuanyuan.cloud/r/oceanbase/obproxy-ce/tags](https://xuanyuan.cloud/r/oceanbase/obproxy-ce/tags)  
3. **Docker官方文档**：[https://docs.docker.com/](https://docs.docker.com/)  
4. **OceanBase官方文档**：[https://www.oceanbase.com/docs](https://www.oceanbase.com/docs)（OBPROXY相关章节）  


## 总结

本文详细介绍了OBPROXY-CE的Docker容器化部署流程，从环境准备、镜像拉取、容器配置到功能验证，覆盖了从测试环境到生产环境的全链路实践。通过容器化部署，OBPROXY-CE实现了环境隔离、快速交付和资源优化，为OceanBase集群提供了可靠的代理层支持。


### 关键要点

- **环境一致性**：使用Docker一键安装脚本确保环境标准化，轩辕镜像访问支持解决国内网络拉取瓶颈；
- **镜像拉取规则**：多段镜像名（如`oceanbase/obproxy-ce`）直接使用访问支持地址`xxx.xuanyuan.run/oceanbase/obproxy-ce:{TAG}`拉取；
- **核心配置项**：`APP_NAME`、`PROXYRO_PASSWORD`/`PROXYRO_PASSWORD_HASH`、`RS_LIST`/`CONFIG_URL`为必配环境变量，需根据实际集群信息调整；
- **生产优化**：通过资源限制、数据持久化、安全加固和监控集成提升部署可靠性。


### 后续建议

- **深入学习OBPROXY高级特性**：如读写分离、流量控制、SQL拦截等功能，可参考[OBPROXY-CE镜像文档（轩辕）](https://xuanyuan.cloud/r/oceanbase/obproxy-ce)；
- **自动化部署**：结合CI/CD工具（如Jenkins、GitLab CI）实现镜像版本更新和容器滚动升级；
- **容灾设计**：部署多实例OBPROXY-CE，前端配合负载均衡器（如Nginx）实现代理层高可用；
- **定期安全审计**：关注OceanBase官方安全公告，及时更新镜像以修复潜在漏洞。


### 参考链接

- [OBPROXY-CE镜像文档（轩辕）](https://xuanyuan.cloud/r/oceanbase/obproxy-ce)  
- [OBPROXY-CE镜像标签列表（轩辕）](https://xuanyuan.cloud/r/oceanbase/obproxy-ce/tags)  
- [Docker官方文档](https://docs.docker.com/)  
- [OceanBase官方文档](https://www.oceanbase.com/docs)

