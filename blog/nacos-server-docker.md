# Nacos Server Docker 部署完整教程：从入门到精通

![Nacos Server Docker 部署完整教程：从入门到精通](https://img.xuanyuan.dev/docker/blog/docker-nacos.png)

*分类: Docker,Nacos | 标签: nacos,docker,部署教程 | 发布时间: 2025-10-10 02:54:08*

> Nacos 让服务之间不用硬编码对方的 IP，就算服务地址变了，也不用修改代码，Nacos 会自动同步最新信息——这就是“服务发现”的核心价值。

## 一、关于 Nacos Server：它是什么？能做什么？
Nacos（全称为 **Dynamic Naming and Configuration Service**，即动态命名与配置服务）是阿里巴巴开源的一款 **微服务核心组件**，专门解决微服务架构中两个核心痛点：**服务发现** 和 **配置管理**，同时还支持服务健康检查、动态路由等能力，是微服务体系里的“基础设施管家”。

咱们用大白话解释它的核心作用，结合实际场景更易理解：

### 1. 核心功能一：服务发现——让微服务“找到彼此”
在微服务架构里，一个系统会拆成多个小服务（比如“用户服务”“订单服务”“支付服务”），这些服务可能部署在不同的服务器上，IP 和端口还可能动态变化（比如服务扩容、重启）。  
如果“订单服务”需要调用“支付服务”，它怎么知道“支付服务”当前的地址？这就需要 Nacos 来当“通讯录”：
- 每个服务启动后，会主动向 Nacos 注册自己的 IP、端口、服务名（比如“pay-service”）；
- 当“订单服务”需要调用“支付服务”时，直接向 Nacos 问：“当前有哪些‘pay-service’可用？”；
- Nacos 会返回所有健康的“支付服务”地址，“订单服务”直接用这些地址发起调用。

这样一来，服务之间不用硬编码对方的 IP，就算服务地址变了，也不用修改代码，Nacos 会自动同步最新信息——这就是“服务发现”的核心价值。

### 2. 核心功能二：配置管理——让配置“动态生效，不用重启服务”
传统项目里，配置文件（比如数据库地址、接口超时时间、日志级别）都是写死在代码里或本地文件里的。如果要修改配置（比如切换测试/生产数据库），必须改配置文件、重新打包、重启服务——这在生产环境中非常麻烦（比如凌晨改配置，重启服务可能导致几秒不可用）。

Nacos 的“配置管理”能解决这个问题：
- 把所有服务的配置（按“服务名+环境”分类，比如“user-service-dev”“order-service-prod”）统一存到 Nacos 服务器；
- 服务启动时，主动从 Nacos 拉取自己的配置；
- 当需要修改配置时，直接在 Nacos 控制台改，Nacos 会主动把新配置推送给对应的服务；
- 服务收到新配置后，不用重启就能立即生效（前提是代码里做了简单适配，Nacos 提供现成的 SDK 支持）。

比如你要调整“订单服务”的接口超时时间，只需在 Nacos 改个数值，10 秒内所有“订单服务”实例就会用新的超时时间，全程不用停服务——这就是“动态配置”的魅力。

### 3. 其他实用能力
- **服务健康检查**：Nacos 会定期检测已注册的服务（比如发心跳包），如果某个服务实例挂了，会立即从“通讯录”里移除，避免其他服务调用到故障实例；
- **命名空间隔离**：可以按“环境”（开发/测试/生产）或“项目”创建命名空间，不同命名空间的服务和配置完全隔离，比如“dev 环境的服务不会调用到 prod 环境的服务”；
- **集群支持**：Nacos 自身可以部署成集群，保证高可用（就算其中一台 Nacos 服务器挂了，其他节点还能正常工作）。

简单说：如果你的项目是微服务架构，或者需要动态管理配置、避免重启服务，Nacos 就是必须掌握的工具；就算是单体项目，用它管理配置也能大幅提升运维效率。

## 二、准备工作：安装 Docker 和 Docker Compose
Nacos 部署依赖 Docker 环境，如果你的 Linux 服务器还没装 Docker，需按以下规范安装（拒绝不明脚本，保障生产环境安全）。

### 安装说明（生产环境规范）
⚠️ 重要提醒：企业/生产环境 **严禁直接使用第三方一键脚本**（存在供应链攻击、配置篡改风险），以下提供官方兼容的安装步骤，或可查看脚本内容后执行。

### 方式 1：官方步骤安装（推荐，透明可控）
#### 1. 卸载旧版本（如有）
```bash
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine  # CentOS
# 或 Ubuntu
# sudo apt-get remove docker docker-engine docker.io containerd runc
```

#### 2. 安装依赖包
```bash
# CentOS
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Ubuntu
# sudo apt-get update
# sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

#### 3. 安装 Docker 和 Docker Compose
```bash
# 安装 Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io  # CentOS
# 或 Ubuntu
# sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 安装 Docker Compose（二进制方式，兼容稳定）
sudo curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose  # 建立软链接，确保命令全局可用
```

#### 4. 配置开机自启和镜像加速
```bash
# 启动 Docker 并设置开机自启
sudo systemctl start docker
sudo systemctl enable docker

# 配置轩辕镜像加速（可选，提升拉取速度）
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://xxx.xuanyuan.run"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 方式 2：第三方脚本安装（需谨慎）
如确需使用轩辕提供的脚本，必须先查看脚本内容，确认无风险后执行：
```bash
# 1. 下载脚本到本地
wget -O docker.sh https://xuanyuan.cloud/docker.sh
# 2. 查看脚本内容（关键步骤，不可省略）
less docker.sh
# 3. 确认无风险后执行
bash docker.sh
```

### 验证安装是否成功
安装完成后，执行下面两个命令，能看到版本信息就说明装好了：
```bash
# 验证 Docker 是否正常
docker --version
# 验证 Docker Compose 是否正常
docker compose --version
```

示例输出（版本号可能不同，只要不报错就行）：
```
Docker version 26.0.0, build 2ae903e
Docker Compose version v2.25.0
```

## 三、拉取 Nacos Server 镜像
咱们从 **轩辕镜像仓库**（访问表现快，不用翻墙）拉取 Nacos 镜像，推荐使用官方稳定版，避免老旧版本的安全风险。

### 3.1 版本选择策略（生产级规范）
⚠️ 重要提醒：
- 本文示例使用 `2.2.3` 版本（官方稳定版，无已知高危漏洞，兼容主流 Spring Cloud Alibaba 版本）；
- 生产环境建议优先选择 **官方 LTS 版本** 或 **近 1 年内发布的稳定版**（如 2.3.x、2.4.x），避免使用 2.0.x 等老旧版本（存在认证漏洞、集群稳定性问题）；
- 版本升级需参考官方变更日志，避免兼容性问题。

### 3.2 定义版本变量（统一管理，方便升级）
```bash
# 定义 Nacos 版本（后续修改此处即可升级）
NACOS_VERSION=2.2.3
```

### 3.3 免登录拉取（推荐，新手首选）
直接执行下面的命令，拉取镜像并重命名为官方标准名（后续命令更简洁）：
```bash
# 拉取轩辕镜像，并重命名，删除临时标签
docker pull xxx.xuanyuan.run/nacos/nacos-server:${NACOS_VERSION} \
&& docker tag xxx.xuanyuan.run/nacos/nacos-server:${NACOS_VERSION} nacos/nacos-server:${NACOS_VERSION} \
&& docker rmi xxx.xuanyuan.run/nacos/nacos-server:${NACOS_VERSION}
```

#### 命令解释：
- `docker pull`：从轩辕仓库拉取镜像，访问表现比 Docker Hub 快；
- `docker tag`：把拉取的镜像重命名为官方标准名“nacos/nacos-server:${NACOS_VERSION}”，后续启动容器时不用记长地址；
- `docker rmi`：删除拉取时的临时标签（xuanyuan.cloud/...），避免占用额外存储空间。

### 3.4 登录验证拉取（可选，适合企业环境）
如果你的环境要求登录镜像仓库，先执行登录命令（按提示输入轩辕仓库的账号密码）：
```bash
docker login xuanyuan.cloud
```
登录成功后，再拉取镜像：
```bash
docker pull xxx.xuanyuan.run/nacos/nacos-server:${NACOS_VERSION}
# 同样重命名（可选，但推荐）
docker tag xxx.xuanyuan.run/nacos/nacos-server:${NACOS_VERSION} nacos/nacos-server:${NACOS_VERSION}
```

### 3.5 验证镜像是否拉取成功
执行下面的命令，查看本地镜像列表：
```bash
docker images | grep nacos-server
```

如果输出类似下面的内容，说明拉取成功：
```
nacos/nacos-server   2.2.3    xxxxxxxx   3 months ago    1.1GB
```

## 四、Nacos Server 部署方案：4 种场景全覆盖（生产级优化）
根据你的需求（测试/生产、单机/集群），提供 4 种部署方案，从简单到复杂，均补充生产级安全、资源限制、健康检查等配置。

### 方案 1：快速部署（单机模式，适合测试/学习）
这种方式最简单，用 Nacos 内置的 Derby 数据库（无需额外装 MySQL），启动后直接用，缺点是数据存在容器内，容器删除后数据会丢失——**仅适合测试，不适合生产**。

#### 执行启动命令（添加资源限制和健康检查）
```bash
# 启动 Nacos 容器，命名为 nacos-test，单机模式（MODE=standalone）
docker run -d \
  --name nacos-test \
  --memory=2g \  # 容器最大内存限制（生产级兜底，避免占用过多资源）
  --cpus=1.5 \   # 容器 CPU 限制（根据服务器配置调整）
  --health-cmd="curl -f http://localhost:8848/nacos/actuator/health || exit 1" \  # 健康检查命令
  --health-interval=30s \  # 健康检查间隔
  --health-timeout=10s \   # 健康检查超时时间
  --health-retries=3 \     # 连续失败 3 次判定为不健康
  -p 8848:8848 \  # Nacos 默认端口：8848（控制台访问）
  -p 9848:9848 \  # Nacos 客户端连接端口（2.0+版本新增，必须映射）
  -p 9849:9849 \  # Nacos 客户端连接端口（2.0+版本新增，必须映射）
  -e MODE=standalone \  # 关键参数：单机模式（standalone）
  -e JVM_XMS=512m \  # JVM 初始内存（根据服务器配置调整，512m 足够测试）
  -e JVM_XMX=512m \  # JVM 最大内存
  -e JVM_XMN=256m \  # JVM 新生代内存
  nacos/nacos-server:${NACOS_VERSION}
```

#### 验证启动是否成功
1. 先查看容器状态，确保“STATUS”是“Up”且健康检查正常：
   ```bash
   docker ps | grep nacos-test
   ```
   成功输出示例：
   ```
   a1b2c3d4e5f6   nacos/nacos-server:2.2.3   "bin/docker-startup.…"   10 seconds ago   Up 9 seconds (healthy)    0.0.0.0:8848->8848/tcp, 0.0.0.0:9848->9848/tcp, 0.0.0.0:9849->9849/tcp   nacos-test
   ```

2. 访问 Nacos 控制台（关键验证步骤）：
   打开浏览器，输入地址：`http://你的服务器IP:8848/nacos`  
   比如服务器 IP 是 192.168.1.100，就访问 `http://192.168.1.100:8848/nacos`。

   会看到登录页，默认账号密码都是 **nacos**（输入后登录），登录后能看到控制台首页，说明部署成功。

#### 停止/删除测试容器
如果只是测试，用完后可以停止或删除容器：
```bash
# 停止容器
docker stop nacos-test
# （可选）删除容器（数据会丢失）
docker rm nacos-test
```

### 方案 2：挂载目录部署（单机+MySQL，适合生产环境）
生产环境需要 **数据持久化**（容器删除后数据不丢）、**安全隔离**、**资源限制**，所以搭配 MySQL 数据库（Nacos 的配置和服务信息存在 MySQL 里），同时挂载宿主机目录，实现“配置持久化”“日志分离”——这是企业里最常用的单机部署方式。

#### 前置准备：安装 MySQL（生产级规范）
⚠️ 生产级 MySQL 配置规范：
- 不使用 root 用户，创建独立 nacos 用户并授予最小权限；
- 密码使用强密码，避免明文硬编码（推荐用密钥管理工具，示例用环境变量暂存）；
- 不暴露公网端口，仅允许内网访问；
- 开启数据持久化，配置主从备份（示例简化为单机挂载，生产需主从）。

#### 步骤 1：启动 MySQL 容器（生产级配置）
```bash
# 定义 MySQL 相关变量（方便维护）
MYSQL_VERSION=5.7
MYSQL_ROOT_PWD="StrongPwd@2024"  # 生产级强密码，避免简单密码
MYSQL_NACOS_PWD="NacosPwd@2024"  # Nacos 专用用户密码
MYSQL_DATA_DIR="/data/nacos/mysql"  # MySQL 数据持久化目录
MYSQL_CONFIG_DIR="/data/nacos/mysql/conf"  # MySQL 配置目录

# 创建挂载目录并授权（避免权限问题，拒绝 777 反模式）
mkdir -p ${MYSQL_DATA_DIR} ${MYSQL_CONFIG_DIR}
sudo chown -R 999:999 ${MYSQL_DATA_DIR} ${MYSQL_CONFIG_DIR}  # MySQL 容器内用户 UID 为 999
sudo chmod -R 755 ${MYSQL_DATA_DIR} ${MYSQL_CONFIG_DIR}  # 最小权限原则

# 启动 MySQL 容器（不暴露公网端口，仅内网访问）
docker run -d \
  --name nacos-mysql \
  --memory=2g \
  --cpus=1.5 \
  --health-cmd="mysqladmin ping -uroot -p${MYSQL_ROOT_PWD} || exit 1" \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PWD} \  # 根密码（强密码）
  -e MYSQL_DATABASE=nacos_config \  # 自动创建 Nacos 专用数据库
  -v ${MYSQL_DATA_DIR}:/var/lib/mysql \  # 挂载数据目录，持久化数据
  -v ${MYSQL_CONFIG_DIR}:/etc/mysql/conf.d \  # 挂载配置目录，自定义 my.cnf
  # 生产环境建议不暴露公网端口，注释或删除 ports 配置
  # -p 3306:3306 \
  --restart=always \  # 容器退出后自动重启
  mysql:${MYSQL_VERSION}
```

#### 步骤 2：创建 Nacos 专用用户并授权（最小权限）
```bash
# 进入 MySQL 容器，执行授权命令
docker exec -it nacos-mysql mysql -uroot -p${MYSQL_ROOT_PWD} << EOF
# 创建 nacos 专用用户（仅允许内网 IP 访问，增强安全）
CREATE USER 'nacos'@'172.%' IDENTIFIED BY '${MYSQL_NACOS_PWD}';
# 授予最小权限（仅 nacos_config 数据库的增删改查）
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP ON nacos_config.* TO 'nacos'@'172.%';
# 刷新权限
FLUSH PRIVILEGES;
EOF
```

#### 步骤 3：初始化 Nacos 数据库脚本
Nacos 需要在 MySQL 中创建表结构和初始数据，提供两种方式：

##### 方式 1：手动执行脚本（推荐，清晰可控）
1. 先进入 MySQL 容器：
   ```bash
   docker exec -it nacos-mysql mysql -unacos -p${MYSQL_NACOS_PWD} nacos_config
   ```
   （输入后会进入 MySQL 命令行，提示符变成 `mysql>`）

2. 执行 Nacos 官方初始化脚本（2.2.3 版本适配，直接复制粘贴到 MySQL 命令行，回车执行）：
   ```sql
   CREATE TABLE `config_info` (
     `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
     `data_id` varchar(255) NOT NULL COMMENT 'data_id',
     `group_id` varchar(255) DEFAULT NULL,
     `content` longtext NOT NULL COMMENT 'content',
     `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
     `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
     `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
     `src_user` text COMMENT 'source user',
     `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
     `app_name` varchar(128) DEFAULT NULL,
     `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
     `c_desc` varchar(256) DEFAULT NULL,
     `c_use` varchar(64) DEFAULT NULL,
     `effect` varchar(64) DEFAULT NULL,
     `type` varchar(64) DEFAULT NULL,
     `c_schema` text,
     PRIMARY KEY (`id`),
     UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';

   CREATE TABLE `config_info_aggr` (
     `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
     `data_id` varchar(255) NOT NULL COMMENT 'data_id',
     `group_id` varchar(255) NOT NULL COMMENT 'group_id',
     `datum_id` varchar(255) NOT NULL COMMENT 'datum_id',
     `content` longtext NOT NULL COMMENT '内容',
     `gmt_modified` datetime NOT NULL COMMENT '修改时间',
     `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
     PRIMARY KEY (`id`),
     UNIQUE KEY `uk_configinfoaggr_datagrouptenantdatum` (`data_id`,`group_id`,`tenant_id`,`datum_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='增加租户字段';

   CREATE TABLE `config_info_beta` (
     `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
     `data_id` varchar(255) NOT NULL COMMENT 'data_id',
     `group_id` varchar(128) NOT NULL COMMENT 'group_id',
     `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
     `content` longtext NOT NULL COMMENT 'content',
     `beta_ips` varchar(1024) DEFAULT NULL COMMENT 'betaIps',
     `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
     `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
     `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
     `src_user` text COMMENT 'source user',
     `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
     `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
     PRIMARY KEY (`id`),
     UNIQUE KEY `uk_configinfobeta_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_beta';

   CREATE TABLE `config_info_tag` (
     `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
     `data_id` varchar(255) NOT NULL COMMENT 'data_id',
     `group_id` varchar(128) NOT NULL COMMENT 'group_id',
     `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
     `tag_id` varchar(128) NOT NULL COMMENT 'tag_id',
     `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
     `content` longtext NOT NULL COMMENT 'content',
     `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
     `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
     `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
     `src_user` text COMMENT 'source user',
     `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
     PRIMARY KEY (`id`),
     UNIQUE KEY `uk_configinfotag_datagrouptenanttag` (`data_id`,`group_id`,`tenant_id`,`tag_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_tag';

   CREATE TABLE `config_tags_relation` (
     `id` bigint(20) NOT NULL COMMENT 'id',
     `tag_name` varchar(128) NOT NULL COMMENT 'tag_name',
     `tag_type` varchar(64) DEFAULT NULL COMMENT 'tag_type',
     `data_id` varchar(255) NOT NULL COMMENT 'data_id',
     `group_id` varchar(128) NOT NULL COMMENT 'group_id',
     `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
     `nid` bigint(20) NOT NULL AUTO_INCREMENT,
     PRIMARY KEY (`nid`),
     UNIQUE KEY `uk_configtagrelation_configtag` (`data_id`,`group_id`,`tenant_id`,`tag_name`,`tag_type`),
     KEY `idx_tenant_id` (`tenant_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_tags_relation';

   CREATE TABLE `group_capacity` (
     `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
     `group_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
     `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
     `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
     `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
     `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，0表示使用默认值',
     `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
     `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
     `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
     `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
     `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
     PRIMARY KEY (`id`),
     UNIQUE KEY `uk_group_id_tenant_id` (`group_id`,`tenant_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群、分组、租户容量信息表';

   CREATE TABLE `his_config_info` (
     `id` bigint(64) unsigned NOT NULL,
     `nid` bigint(20) NOT NULL AUTO_INCREMENT,
     `data_id` varchar(255) NOT NULL,
     `group_id` varchar(128) NOT NULL,
     `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
     `content` longtext NOT NULL,
     `md5` varchar(32) DEFAULT NULL,
     `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
     `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
     `src_user` text,
     `src_ip` varchar(50) DEFAULT NULL,
     `op_type` char(10) DEFAULT NULL,
     `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
     PRIMARY KEY (`nid`),
     KEY `idx_gmt_modified` (`gmt_modified`),
     KEY `idx_did` (`data_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='多租户改造';

   CREATE TABLE `tenant_capacity` (
     `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
     `tenant_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Tenant ID',
     `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
     `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
     `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
     `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
     `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节',
     `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
     `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
     `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
     PRIMARY KEY (`id`),
     UNIQUE KEY `uk_tenant_id` (`tenant_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='租户容量信息表';

   CREATE TABLE `tenant_info` (
     `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
     `kp` varchar(128) NOT NULL COMMENT 'kp',
     `tenant_id` varchar(128) default '' COMMENT 'tenant_id',
     `tenant_name` varchar(128) default '' COMMENT 'tenant_name',
     `tenant_desc` varchar(256) DEFAULT NULL COMMENT 'tenant_desc',
     `create_source` varchar(32) DEFAULT NULL COMMENT 'create_source',
     `gmt_create` bigint(20) NOT NULL COMMENT '创建时间',
     `gmt_modified` bigint(20) NOT NULL COMMENT '修改时间',
     PRIMARY KEY (`id`),
     UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`),
     KEY `idx_tenant_id` (`tenant_id`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='tenant_info';

   CREATE TABLE `users` (
     `username` varchar(50) NOT NULL PRIMARY KEY COMMENT 'username',
     `password` varchar(500) NOT NULL COMMENT 'password',
     `enabled` boolean NOT NULL COMMENT 'enabled'
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='users';

   CREATE TABLE `roles` (
     `username` varchar(50) NOT NULL COMMENT 'username',
     `role` varchar(50) NOT NULL COMMENT 'role',
     UNIQUE KEY `uk_username_role` (`username`,`role`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='roles';

   CREATE TABLE `permissions` (
     `role` varchar(50) NOT NULL COMMENT 'role',
     `resource` varchar(255) NOT NULL COMMENT 'resource',
     `action` varchar(8) NOT NULL COMMENT 'action',
     UNIQUE KEY `uk_role_resource_action` (`role`,`resource`,`action`)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='permissions';

   INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', TRUE);
   INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');
   ```

3. 执行完后，输入 `exit` 退出 MySQL 命令行。

##### 方式 2：挂载脚本自动执行（适合批量部署）
如果嫌手动执行麻烦，可以把上面的 SQL 脚本保存为 `nacos-mysql.sql`，然后挂载到 MySQL 容器的 `/docker-entrypoint-initdb.d/` 目录（MySQL 会自动执行该目录下的 `.sql` 文件）：
```bash
# 1. 在宿主机创建脚本目录
mkdir -p /data/nacos/init-sql
# 2. 把上面的 SQL 脚本保存到 /data/nacos/init-sql/nacos-mysql.sql
# 3. 授权目录（避免权限问题）
chown -R 999:999 /data/nacos/init-sql
chmod -R 755 /data/nacos/init-sql
# 4. 重启 MySQL 容器（如果已启动，先停止再启动，带上挂载参数）
docker stop nacos-mysql
docker rm nacos-mysql
# 重新执行步骤 1 的 MySQL 启动命令，添加以下挂载参数
-v /data/nacos/init-sql:/docker-entrypoint-initdb.d \  # 挂载初始化脚本目录
```

#### 步骤 4：启动 Nacos 容器（生产级配置）
先在宿主机创建 Nacos 所需的挂载目录（用于存放配置、日志），并授权（拒绝 777 反模式）：
```bash
# 创建配置、日志目录（/data/nacos 是根目录，可根据需求修改）
mkdir -p /data/nacos/{conf,logs}
# 授权目录（Nacos 容器内用户 UID 为 1000）
chown -R 1000:1000 /data/nacos/{conf,logs}
chmod -R 755 /data/nacos/{conf,logs}
```

然后执行启动命令（关键参数已标注解释，添加生产级安全、资源限制配置）：
```bash
# 定义 Nacos 连接 MySQL 的参数
MYSQL_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nacos-mysql)  # 获取 MySQL 容器内网 IP
MYSQL_PORT=3306

docker run -d \
  --name nacos-prod \  # 容器名，生产环境建议用“nacos-prod”区分
  --memory=2g \  # 容器内存限制（根据服务器配置调整，生产建议至少 1g）
  --cpus=1.5 \   # 容器 CPU 限制
  --health-cmd="curl -f http://localhost:8848/nacos/actuator/health || exit 1" \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  -p 8848:8848 \  # Nacos 核心端口（控制台+API）
  -p 9848:9848 \  # Nacos 客户端连接端口（2.0+版本新增，必须映射）
  -p 9849:9849 \  # Nacos 客户端连接端口（2.0+版本新增，必须映射）
  -e MODE=standalone \  # 单机模式
  -e SPRING_DATASOURCE_PLATFORM=mysql \  # 启用 MySQL 作为数据源（关键参数）
  -e MYSQL_SERVICE_HOST=${MYSQL_HOST} \  # MySQL 内网 IP（避免公网访问，更安全）
  -e MYSQL_SERVICE_PORT=${MYSQL_PORT} \  # MySQL 端口（默认3306）
  -e MYSQL_SERVICE_DB_NAME=nacos_config \  # Nacos 专用数据库名（和前面创建的一致）
  -e MYSQL_SERVICE_USER=nacos \  # Nacos 专用用户（最小权限）
  -e MYSQL_SERVICE_PASSWORD=${MYSQL_NACOS_PWD} \  # Nacos 专用用户密码
  -e MYSQL_DATABASE_NUM=1 \  # 数据库实例数量（默认1，不用改）
  -e JVM_XMS=1g \  # JVM 初始内存（生产环境建议1g，根据服务器内存调整）
  -e JVM_XMX=1g \  # JVM 最大内存（和初始内存一致，避免频繁GC）
  -e JVM_XMN=512m \  # JVM 新生代内存
  -e NACOS_AUTH_ENABLE=true \  # 开启认证（生产环境必备，防止未授权访问）
  -e NACOS_AUTH_TOKEN=XuanYuanNacosSecret2024! \  # 自定义密钥（生产环境需更复杂，建议定期更换）
  -e NACOS_AUTH_CACHE_ENABLE=true \  # 开启认证缓存（提升性能）
  -v /data/nacos/conf:/home/nacos/conf \  # 挂载 Nacos 配置目录（持久化配置）
  -v /data/nacos/logs:/home/nacos/logs \  # 挂载 Nacos 日志目录（方便查看日志）
  --restart=always \  # 容器退出后自动重启（生产环境必备）
  nacos/nacos-server:${NACOS_VERSION}
```

#### 步骤 5：验证部署（生产级验证）
1. 查看容器状态：`docker ps | grep nacos-prod`，确保“STATUS”是“Up (healthy)”；
2. 查看 Nacos 日志，确认无报错：`docker logs -f nacos-prod`，日志中出现“Nacos started successfully in standalone mode.”说明启动成功；
3. 访问控制台：`http://服务器内网IP:8848/nacos`，用 `nacos/nacos` 登录（开启认证后必须登录）；
4. 验证数据持久化：在控制台创建一个配置（比如 dataId 为“test-prod.conf”，内容为“env=prod”），然后停止并删除 Nacos 容器，重新启动后，登录控制台查看配置是否还在——如果在，说明数据已持久化到 MySQL；
5. 验证认证功能：直接访问 API 接口 `http://服务器IP:8848/nacos/v1/cs/configs?dataId=test-prod.conf&group=DEFAULT_GROUP`，应返回“403 Forbidden”，说明认证生效。

### 方案 3：Docker Compose 部署（单机+MySQL，简化运维）
用 `docker-compose.yml` 文件统一管理 Nacos 和 MySQL 容器，实现“一键启动/停止”，适合运维人员或需要频繁部署的场景，配置遵循生产级规范。

#### 步骤 1：创建 docker-compose.yml 文件（生产级配置）
```yaml
version: '3.8'  # Docker Compose 版本（根据你的 Docker 版本调整，3.8 兼容大部分版本）
services:
  # MySQL 服务（Nacos 数据源）
  nacos-mysql:
    image: mysql:5.7  # MySQL 镜像版本（生产建议 5.7 或 8.0）
    container_name: nacos-mysql
    restart: always  # 自动重启
    environment:
      MYSQL_ROOT_PASSWORD: "StrongPwd@2024"  # 根密码（强密码）
      MYSQL_DATABASE: nacos_config  # 自动创建 Nacos 数据库
      MYSQL_USER: nacos  # Nacos 专用用户
      MYSQL_PASSWORD: "NacosPwd@2024"  # Nacos 专用用户密码
    volumes:
      - ./mysql/data:/var/lib/mysql  # 挂载 MySQL 数据目录（相对路径，和 yml 同目录）
      - ./mysql/conf:/etc/mysql/conf.d  # 挂载 MySQL 配置目录
      - ./init-sql:/docker-entrypoint-initdb.d  # 挂载初始化脚本目录（自动执行 SQL）
    # 生产环境不暴露公网端口
    # ports:
    #   - "3306:3306"
    networks:
      - nacos-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-uroot", "-pStrongPwd@2024"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Nacos Server 服务
  nacos-server:
    image: nacos/nacos-server:${NACOS_VERSION}  # Nacos 镜像版本（使用环境变量）
    container_name: nacos-server
    restart: always  # 自动重启
    depends_on:
      nacos-mysql:
        condition: service_healthy  # 依赖 MySQL 健康启动后再启动（避免连接失败）
    environment:
      MODE: standalone  # 单机模式
      SPRING_DATASOURCE_PLATFORM: mysql  # 启用 MySQL 数据源
      MYSQL_SERVICE_HOST: nacos-mysql  # 同一网络下，用容器名访问 MySQL（无需 IP）
      MYSQL_SERVICE_PORT: 3306  # MySQL 端口
      MYSQL_SERVICE_DB_NAME: nacos_config  # 数据库名
      MYSQL_SERVICE_USER: nacos  # Nacos 专用用户
      MYSQL_SERVICE_PASSWORD: "NacosPwd@2024"  # Nacos 专用用户密码
      JVM_XMS: 1g  # JVM 内存配置
      JVM_XMX: 1g
      JVM_XMN: 512m
      NACOS_AUTH_ENABLE: "true"  # 开启认证
      NACOS_AUTH_TOKEN: "XuanYuanNacosSecret2024!"  # 自定义密钥
      NACOS_AUTH_CACHE_ENABLE: "true"  # 开启认证缓存
    volumes:
      - ./nacos/conf:/home/nacos/conf  # 挂载 Nacos 配置目录
      - ./nacos/logs:/home/nacos/logs  # 挂载 Nacos 日志目录
    ports:
      - "8848:8848"  # Nacos 核心端口
      - "9848:9848"  # Nacos 客户端端口（2.0+ 必须）
      - "9849:9849"  # Nacos 客户端端口（2.0+ 必须）
    networks:
      - nacos-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

# 自定义网络（让 Nacos 和 MySQL 内部通信，不暴露给外部其他服务）
networks:
  nacos-network:
    driver: bridge  # 桥接模式（默认）
```

#### 步骤 2：准备初始化脚本和目录
1. 在 `docker-compose.yml` 所在目录创建目录结构：
   ```bash
   mkdir -p ./mysql/{data,conf} ./nacos/{conf,logs} ./init-sql
   ```
2. 授权目录（避免权限问题）：
   ```bash
   # MySQL 目录授权（UID 999）
   chown -R 999:999 ./mysql
   # Nacos 目录授权（UID 1000）
   chown -R 1000:1000 ./nacos
   # 脚本目录授权
   chown -R 999:999 ./init-sql
   # 最小权限
   chmod -R 755 ./mysql ./nacos ./init-sql
   ```
3. 把 Nacos 数据库初始化 SQL 脚本保存到 `./init-sql/nacos-mysql.sql`（脚本内容同方案 2 步骤 3）。

#### 步骤 3：启动服务
在 `docker-compose.yml` 所在目录执行下面的命令，一键启动 MySQL 和 Nacos：
```bash
# 定义 Nacos 版本（或写入 .env 文件）
export NACOS_VERSION=2.2.3
# 后台启动（-d 表示后台运行）
docker compose up -d
```

#### 步骤 4：验证和管理
- 查看服务状态：`docker compose ps`，会显示两个服务的状态（Up (healthy) 表示正常）；
- 查看日志：`docker compose logs -f nacos-server`（实时查看 Nacos 日志，有问题可排查）；
- 停止服务：`docker compose down`（会停止并删除容器，但挂载的目录数据不会丢）；
- 重启服务：`docker compose restart`；
- 查看容器资源使用：`docker stats nacos-server nacos-mysql`。

### 方案 4：Docker Compose 集群部署（生产高可用）
如果业务对可用性要求高（不能接受 Nacos 单点故障），可以部署 Nacos 集群（至少 3 个节点）。以下提供两种集群方案，优先推荐“外置 MySQL”方案，适合生产环境。

#### 方案 4.1：集群部署（外置 MySQL，生产推荐）
⚠️ 生产级集群规范：
- 配置中心生产环境 **强烈推荐外置 MySQL/PostgreSQL 数据库**（稳定性、可运维性、数据恢复能力更强）；
- 集群节点至少 3 个，分布在不同宿主机（避免单点故障）；
- 数据库建议主从架构，定期备份；
- 前端可配置 Nginx 反向代理，统一入口。

##### 步骤 1：创建集群 docker-compose.yml
```yaml
version: '3.8'
services:
  # Nacos 节点 1
  nacos-server-1:
    image: nacos/nacos-server:${NACOS_VERSION}
    container_name: nacos-server-1
    restart: always
    environment:
      MODE: cluster  # 集群模式
      SPRING_DATASOURCE_PLATFORM: mysql  # 外置 MySQL
      MYSQL_SERVICE_HOST: ${MYSQL_HOST}  #  MySQL 服务器 IP（主从集群 VIP）
      MYSQL_SERVICE_PORT: ${MYSQL_PORT}  # MySQL 端口
      MYSQL_SERVICE_DB_NAME: nacos_config  # 数据库名（需提前初始化）
      MYSQL_SERVICE_USER: nacos  # 专用用户
      MYSQL_SERVICE_PASSWORD: ${MYSQL_NACOS_PWD}  # 专用用户密码
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"  # 集群节点列表
      NACOS_SERVER_IP: ${HOST_IP_1}  # 当前节点宿主机 IP（多宿主机部署必须用真实 IP）
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
      NACOS_AUTH_ENABLE: "true"
      NACOS_AUTH_TOKEN: "XuanYuanNacosSecret2024!"
    volumes:
      - ./nacos-1/conf:/home/nacos/conf
      - ./nacos-1/logs:/home/nacos/logs
    ports:
      - "8848:8848"
      - "9848:9848"
      - "9849:9849"
    networks:
      - nacos-cluster-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Nacos 节点 2
  nacos-server-2:
    image: nacos/nacos-server:${NACOS_VERSION}
    container_name: nacos-server-2
    restart: always
    environment:
      MODE: cluster
      SPRING_DATASOURCE_PLATFORM: mysql
      MYSQL_SERVICE_HOST: ${MYSQL_HOST}
      MYSQL_SERVICE_PORT: ${MYSQL_PORT}
      MYSQL_SERVICE_DB_NAME: nacos_config
      MYSQL_SERVICE_USER: nacos
      MYSQL_SERVICE_PASSWORD: ${MYSQL_NACOS_PWD}
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"
      NACOS_SERVER_IP: ${HOST_IP_2}  # 第二个宿主机 IP（多宿主机部署）
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
      NACOS_AUTH_ENABLE: "true"
      NACOS_AUTH_TOKEN: "XuanYuanNacosSecret2024!"
    volumes:
      - ./nacos-2/conf:/home/nacos/conf
      - ./nacos-2/logs:/home/nacos/logs
    ports:
      - "8849:8848"
      - "9858:9848"
      - "9859:9849"
    networks:
      - nacos-cluster-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Nacos 节点 3
  nacos-server-3:
    image: nacos/nacos-server:${NACOS_VERSION}
    container_name: nacos-server-3
    restart: always
    environment:
      MODE: cluster
      SPRING_DATASOURCE_PLATFORM: mysql
      MYSQL_SERVICE_HOST: ${MYSQL_HOST}
      MYSQL_SERVICE_PORT: ${MYSQL_PORT}
      MYSQL_SERVICE_DB_NAME: nacos_config
      MYSQL_SERVICE_USER: nacos
      MYSQL_SERVICE_PASSWORD: ${MYSQL_NACOS_PWD}
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"
      NACOS_SERVER_IP: ${HOST_IP_3}  # 第三个宿主机 IP（多宿主机部署）
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
      NACOS_AUTH_ENABLE: "true"
      NACOS_AUTH_TOKEN: "XuanYuanNacosSecret2024!"
    volumes:
      - ./nacos-3/conf:/home/nacos/conf
      - ./nacos-3/logs:/home/nacos/logs
    ports:
      - "8850:8848"
      - "9868:9848"
      - "9869:9849"
    networks:
      - nacos-cluster-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

# Nginx 反向代理（统一集群入口，可选）
  nacos-nginx:
    image: nginx:1.21
    container_name: nacos-nginx
    restart: always
    ports:
      - "80:80"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
    depends_on:
      - nacos-server-1
      - nacos-server-2
      - nacos-server-3
    networks:
      - nacos-cluster-network

networks:
  nacos-cluster-network:
    driver: bridge
```

##### 步骤 2：配置说明（生产级注意事项）
1. 外置 MySQL 需提前部署（主从架构），并初始化 Nacos 数据库脚本；
2. 多宿主机部署时，需确保各节点网络互通，`NACOS_SERVER_IP` 填写各宿主机真实 IP（不可用容器名）；
3. 如需单宿主机测试集群，`HOST_IP_1/2/3` 可填写同一宿主机 IP，仅需修改映射端口；
4. Nginx 配置示例（`./nginx/conf.d/nacos.conf`）：
   ```nginx
   upstream nacos-cluster {
     server nacos-server-1:8848;
     server nacos-server-2:8848;
     server nacos-server-3:8848;
   }

   server {
     listen 80;
     server_name nacos.xuanyuan.cloud;  # 自定义域名

     location /nacos/ {
       proxy_pass http://nacos-cluster/nacos/;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
     }
   }
   ```

#### 方案 4.2：集群部署（EMBEDDED_STORAGE，测试/小规模使用）
⚠️ 重要说明：
EMBEDDED_STORAGE 基于 Raft 协议，使用嵌入式数据库存储数据，适合 **PoC 测试、小规模集群或非核心业务**。
对于生产环境的配置中心场景，官方与社区实践均推荐使用外置 MySQL/PostgreSQL，以获得更好的稳定性、可运维性和数据恢复能力。

##### 步骤 1：创建集群 docker-compose.yml
```yaml
version: '3.8'
services:
  # Nacos 节点 1
  nacos-server-1:
    image: nacos/nacos-server:${NACOS_VERSION}
    container_name: nacos-server-1
    restart: always
    environment:
      MODE: cluster  # 集群模式
      EMBEDDED_STORAGE: embedded  # 启用嵌入式存储（不用 MySQL）
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"  # 集群节点列表
      NACOS_SERVER_IP: ${HOST_IP_1}  # 当前节点宿主机 IP（单宿主机可填 127.0.0.1，多宿主机填真实 IP）
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
      NACOS_AUTH_ENABLE: "true"
      NACOS_AUTH_TOKEN: "XuanYuanNacosSecret2024!"
    ports:
      - "8848:8848"
      - "9848:9848"
      - "9849:9849"
    networks:
      - nacos-cluster-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Nacos 节点 2
  nacos-server-2:
    image: nacos/nacos-server:${NACOS_VERSION}
    container_name: nacos-server-2
    restart: always
    environment:
      MODE: cluster
      EMBEDDED_STORAGE: embedded
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"
      NACOS_SERVER_IP: ${HOST_IP_2}  # 第二个宿主机 IP（多宿主机部署）
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
      NACOS_AUTH_ENABLE: "true"
      NACOS_AUTH_TOKEN: "XuanYuanNacosSecret2024!"
    ports:
      - "8849:8848"
      - "9858:9848"
      - "9859:9849"
    networks:
      - nacos-cluster-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Nacos 节点 3
  nacos-server-3:
    image: nacos/nacos-server:${NACOS_VERSION}
    container_name: nacos-server-3
    restart: always
    environment:
      MODE: cluster
      EMBEDDED_STORAGE: embedded
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"
      NACOS_SERVER_IP: ${HOST_IP_3}  # 第三个宿主机 IP（多宿主机部署）
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
      NACOS_AUTH_ENABLE: "true"
      NACOS_AUTH_TOKEN: "XuanYuanNacosSecret2024!"
    ports:
      - "8850:8848"
      - "9868:9848"
      - "9869:9849"
    networks:
      - nacos-cluster-network
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8848/nacos/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  nacos-cluster-network:
    driver: bridge
```

##### 步骤 2：启动集群
1. 定义环境变量（单宿主机测试示例）：
   ```bash
   export NACOS_VERSION=2.2.3
   export HOST_IP_1=127.0.0.1
   export HOST_IP_2=127.0.0.1
   export HOST_IP_3=127.0.0.1
   ```
2. 启动集群：
   ```bash
   docker compose -f nacos-cluster.yml up -d
   ```

##### 步骤 3：验证集群
1. 访问任意节点的控制台：`http://服务器IP:8848/nacos`、`http://服务器IP:8849/nacos`、`http://服务器IP:8850/nacos`，登录后在“集群管理 → 节点列表”中能看到 3 个节点，状态都是“UP”，说明集群正常；
2. 测试高可用：停止其中一个节点（比如 `docker stop nacos-server-1`），刷新控制台，剩下的两个节点仍能正常工作，且服务注册/配置管理不受影响；
3. 测试数据同步：在一个节点创建配置，其他节点能正常查看，说明数据同步正常。

## 五、Nacos 核心操作：服务注册、发现与配置管理
部署完成后，实际操作 Nacos 的核心功能，以下示例均基于“开启认证”的生产环境。

### 1. 服务注册（让服务加入 Nacos）
#### 方式 1：用 curl 命令注册（带认证）
首先获取认证令牌（默认账号密码 nacos/nacos）：
```bash
# 获取令牌
TOKEN=$(curl -X POST "http://服务器IP:8848/nacos/v1/auth/login" -d "username=nacos&password=nacos" | jq -r '.accessToken')

# 注册服务实例（服务名：user-service，IP：192.168.1.101，端口：8080）
curl -X PUT \
  -H "Authorization: Bearer ${TOKEN}" \
  "http://服务器IP:8848/nacos/v1/ns/instance?serviceName=user-service&ip=192.168.1.101&port=8080"
```

成功会返回 `ok`。

#### 方式 2：在控制台注册
1. 登录 Nacos 控制台，进入“服务管理 → 服务列表”；
2. 点击“新建服务”，输入服务名（比如“user-service”），其他默认，点击“确认”；
3. 进入该服务的详情页，点击“实例列表 → 新增实例”，输入 IP 和端口，点击“确认”。

### 2. 服务发现（查询服务实例）
#### 方式 1：用 curl 命令查询（带认证）
```bash
# 用上面获取的 TOKEN 查询
curl -X GET \
  -H "Authorization: Bearer ${TOKEN}" \
  "http://服务器IP:8848/nacos/v1/ns/instances?serviceName=user-service"
```

成功会返回 JSON 格式的实例列表，类似：
```json
{
  "name": "DEFAULT_GROUP@@user-service",
  "groupName": "DEFAULT_GROUP",
  "clusters": "",
  "cacheMillis": 10000,
  "hosts": [
    {
      "ip": "192.168.1.101",
      "port": 8080,
      "valid": true,
      "healthy": true,
      "weight": 1.0,
      "metadata": {},
      "instanceId": "192.168.1.101#8080#DEFAULT#DEFAULT_GROUP@@user-service",
      "clusterName": "DEFAULT",
      "serviceName": "DEFAULT_GROUP@@user-service",
      "enabled": true,
      "ephemeral": true
    }
  ],
  "lastRefTime": 1690000000000,
  "checksum": "",
  "allIPs": false,
  "reachProtectionThreshold": false,
  "valid": true
}
```

#### 方式 2：在控制台查看
进入“服务管理 → 服务列表”，点击“user-service”，就能看到所有实例的状态。

### 3. 配置管理（动态发布/获取配置）
#### 方式 1：用 curl 命令操作（带认证）
##### 发布配置（新增一个配置）
```bash
curl -X POST \
  -H "Authorization: Bearer ${TOKEN}" \
  "http://服务器IP:8848/nacos/v1/cs/configs?dataId=user-service-prod.conf&group=DEFAULT_GROUP&content=db.url=jdbc:mysql://mysql-vip:3306/user_db&db.username=nacos&db.password=NacosPwd@2024"
```

成功返回 `true`。

##### 获取配置
```bash
curl -X GET \
  -H "Authorization: Bearer ${TOKEN}" \
  "http://服务器IP:8848/nacos/v1/cs/configs?dataId=user-service-prod.conf&group=DEFAULT_GROUP"
```

成功返回配置内容：`db.url=jdbc:mysql://mysql-vip:3306/user_db&db.username=nacos&db.password=NacosPwd@2024`。

#### 方式 2：在控制台操作
1. 进入“配置管理 → 配置列表”，点击“+”新建配置；
2. 输入 dataId（比如“user-service-prod.conf”）、group（默认“DEFAULT_GROUP”）、配置内容（比如数据库地址、超时时间）；
3. 点击“发布”，配置就会保存到 Nacos；
4. 要获取配置，直接在配置列表中找到该配置，点击“查看”即可；
5. 要修改配置，点击“编辑”，修改后点击“发布”，服务会自动感知新配置（无需重启）。

## 六、生产级优化与最佳实践
### 1. 安全优化
- **开启认证**：必须启用 NACOS_AUTH_ENABLE=true，自定义复杂密钥，定期更换；
- **权限控制**：创建不同角色的用户（比如只读用户、运维用户），分配最小权限；
- **网络隔离**：Nacos 服务器和 MySQL 仅允许内网访问，不暴露公网端口；
- **HTTPS 加密**：配置 HTTPS 证书，通过 Nginx 反向代理实现 HTTPS 访问（避免明文传输）；
- **密码加密**：数据库密码、密钥等不硬编码，使用 Docker Secrets 或密钥管理工具（如 Vault）。

### 2. 性能优化
- **JVM 调优**：根据服务器内存调整 JVM 参数，避免内存溢出或频繁 GC（生产建议 JVM_XMS=2g，JVM_XMX=2g）；
- **资源限制**：容器层配置 CPU/内存限制，避免占用过多服务器资源；
- **日志优化**：调整日志级别为 INFO，定期轮转日志，避免日志文件过大；
- **缓存优化**：开启 Nacos 认证缓存、配置缓存，提升访问性能。

### 3. 可运维性优化
- **健康检查**：容器配置健康检查，配合监控工具（如 Prometheus+Grafana）实时监控状态；
- **日志收集**：将 Nacos 日志挂载到宿主机，通过 ELK 等工具收集分析日志；
- **数据库备份**：定期备份 MySQL 数据库（至少每日一次），测试恢复流程；
- **版本管理**：使用环境变量统一管理 Nacos、MySQL 版本，方便升级；
- **配置备份**：Nacos 配置定期导出备份，避免配置丢失。

### 4. 命名空间与分组最佳实践
- **命名空间隔离**：按环境（dev/test/prod）创建命名空间，不同环境的服务和配置完全隔离；
- **分组管理**：按项目或模块划分 group（比如“user-group”“order-group”），避免配置混乱；
- **数据 ID 规范**：数据 ID 格式建议为“服务名-环境-配置类型.conf”（比如“user-service-prod-db.conf”），便于识别。

### 5. 监控与告警
- **启用 Prometheus 监控**：Nacos 内置 Prometheus 监控端点（/actuator/prometheus），配置 Prometheus 抓取数据；
- **Grafana 可视化**：导入 Nacos 官方 Grafana 仪表盘（ID：12856），实时查看集群状态、配置数量、服务实例数量等；
- **告警配置**：针对关键指标（如节点状态 DOWN、配置更新失败、数据库连接异常）配置告警，通过邮件、钉钉等方式通知运维人员。

## 七、常见问题与解决方案（生产级排查）
### 1. 浏览器访问不到 Nacos 控制台？
#### 排查步骤：
1. **检查容器状态**：`docker ps | grep nacos`，如果 STATUS 是“Exited”，执行 `docker logs 容器名` 查看日志（比如日志显示“MySQL 连接失败”“端口被占用”）；
2. **检查端口开放**：
   - 云服务器：在控制台的“安全组”中放行 8848、9848、9849 端口（仅允许内网 IP 访问）；
   - 本地服务器：执行 `firewall-cmd --list-ports` 查看端口是否开放，没开放的话执行：
     ```bash
     firewall-cmd --add-port=8848/tcp --permanent
     firewall-cmd --add-port=9848/tcp --permanent
     firewall-cmd --add-port=9849/tcp --permanent
     firewall-cmd --reload
     ```
3. **检查端口冲突**：执行 `netstat -tuln | grep 8848`，如果显示“LISTEN”，说明端口被其他进程占用，启动 Nacos 时换宿主机端口（比如 `-p 8849:8848`）；
4. **检查认证配置**：如果开启了认证，访问控制台需输入账号密码，若密码错误，可通过 MySQL 重置 users 表中的密码。

### 2. Nacos 连接不上 MySQL？
#### 常见原因与解决方案：
1. **MySQL 地址或端口错误**：
   - 若 MySQL 和 Nacos 在同一网络，用容器名访问（比如 nacos-mysql）；
   - 若在不同网络，填写 MySQL 真实 IP（避免 127.0.0.1），确保网络互通；
2. **MySQL 用户名或密码错误**：
   - 检查 `MYSQL_SERVICE_USER` 和 `MYSQL_SERVICE_PASSWORD` 参数是否正确；
   - 进入 MySQL 容器，验证用户权限：`mysql -unacos -pNacosPwd@2024 -h nacos-mysql nacos_config`；
3. **MySQL 未初始化脚本**：日志显示“Table 'nacos_config.config_info' doesn't exist”，需重新执行初始化 SQL 脚本；
4. **MySQL 版本不兼容**：Nacos 2.2.3 支持 MySQL 5.7 和 8.0，若使用 MySQL 8.0，需在连接参数中添加 `serverTimezone=UTC`；
5. **防火墙拦截**：MySQL 服务器防火墙放行 Nacos 服务器 IP 的 3306 端口。

### 3. 容器启动后马上退出（STATUS: Exited）？
执行 `docker logs 容器名` 查看日志，根据日志提示解决：
- 日志含“JVM 内存不足”：减小 JVM_XMS、JVM_XMX（比如改成 512m），或增加容器内存限制；

