---
id: 25
title: Nacos Server Docker 部署完整教程：从入门到精通
slug: nacos-server-docker
summary: Nacos 让服务之间不用硬编码对方的 IP，就算服务地址变了，也不用修改代码，Nacos 会自动同步最新信息——这就是“服务发现”的核心价值。
category: Docker,Nacos
tags: nacos,docker,部署教程
image_name: nacos/nacos-server
cover_image: "https://img.xuanyuan.dev/docker/blog/docker-nacos.png"
status: published
created_at: "2025-10-10 02:54:08"
updated_at: "2025-10-12 15:35:24"
---

# Nacos Server Docker 部署完整教程：从入门到精通

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
Nacos 部署依赖 Docker 环境，如果你的 Linux 服务器还没装 Docker，直接用下面的 **一键安装脚本**（支持 CentOS、Ubuntu、Debian 等主流发行版），能自动装 Docker、Docker Compose，还会配置轩辕镜像访问支持（拉取镜像更快）。

### 执行一键安装命令
登录 Linux 服务器，直接复制粘贴下面的命令，回车执行（过程中会提示输入密码，输服务器密码即可）：
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
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
咱们从 **轩辕镜像仓库**（访问表现快，不用翻墙）拉取 Nacos 镜像，提供两种拉取方式，新手推荐“免登录方式”，简单无门槛。

### 3.1 查看镜像信息
轩辕镜像仓库的 Nacos 地址：[https://xuanyuan.cloud/r/nacos/nacos-server](https://xuanyuan.cloud/r/nacos/nacos-server)  
里面能看到镜像的最新版本、拉取命令等信息，咱们这里用稳定版 **2.0.2**（官方示例常用版本，兼容性好）。


### 3.2 免登录拉取（推荐，新手首选）
直接执行下面的命令，拉取镜像并重命名为“nacos/nacos-server:2.0.2”（符合官方命名习惯，后续命令更简洁）：
```bash
# 拉取轩辕镜像，并重命名，删除临时标签
docker pull xxx.xuanyuan.run/nacos/nacos-server:2.0.2 \
&& docker tag xxx.xuanyuan.run/nacos/nacos-server:2.0.2 nacos/nacos-server:2.0.2 \
&& docker rmi xxx.xuanyuan.run/nacos/nacos-server:2.0.2
```

#### 命令解释：
- `docker pull`：从轩辕仓库拉取镜像，访问表现比 Docker Hub 快；
- `docker tag`：把拉取的镜像重命名为官方标准名“nacos/nacos-server:2.0.2”，后续启动容器时不用记长地址；
- `docker rmi`：删除拉取时的临时标签（xuanyuan.cloud/...），避免占用额外存储空间。


### 3.3 登录验证拉取（可选，适合企业环境）
如果你的环境要求登录镜像仓库，先执行登录命令（按提示输入轩辕仓库的账号密码）：
```bash
docker login xuanyuan.cloud
```
登录成功后，再拉取镜像：
```bash
docker pull xxx.xuanyuan.run/nacos/nacos-server:2.0.2
# 同样重命名（可选，但推荐）
docker tag xxx.xuanyuan.run/nacos/nacos-server:2.0.2 nacos/nacos-server:2.0.2
```


### 3.4 验证镜像是否拉取成功
执行下面的命令，查看本地镜像列表：
```bash
docker images | grep nacos-server
```

如果输出类似下面的内容，说明拉取成功：
```
nacos/nacos-server   2.0.2    96a502e3027e   2 years ago    1.05GB
```


## 四、Nacos Server 部署方案：3 种场景全覆盖
根据你的需求（测试/生产、单机/集群），咱们提供 4 种部署方案，从简单到复杂，你可以按需选择。


### 方案 1：快速部署（单机模式，适合测试/学习）
这种方式最简单，用 Nacos 内置的 Derby 数据库（无需额外装 MySQL），启动后直接用，缺点是数据存在容器内，容器删除后数据会丢失——**仅适合测试，不适合生产**。

#### 执行启动命令
```bash
# 启动 Nacos 容器，命名为 nacos-test，单机模式（MODE=standalone）
docker run -d \
  --name nacos-test \
  -p 8848:8848 \  # Nacos 默认端口：8848（记住这个端口，后续访问控制台用）
  -e MODE=standalone \  # 关键参数：单机模式（standalone）
  -e JVM_XMS=512m \  # JVM 初始内存（根据服务器配置调整，512m 足够测试）
  -e JVM_XMX=512m \  # JVM 最大内存
  -e JVM_XMN=256m \  # JVM 新生代内存
  nacos/nacos-server:2.0.2
```

#### 验证启动是否成功
1. 先查看容器状态，确保“STATUS”是“Up”：
   ```bash
   docker ps | grep nacos-test
   ```
   成功输出示例：
   ```
   a1b2c3d4e5f6   nacos/nacos-server:2.0.2   "bin/docker-startup.…"   10 seconds ago   Up 9 seconds    0.0.0.0:8848->8848/tcp   nacos-test
   ```

2. 访问 Nacos 控制台（关键验证步骤）：
   打开浏览器，输入地址：`http://你的服务器IP:8848/nacos`  
   比如服务器 IP 是 192.168.1.100，就访问 `http://192.168.1.100:8848/nacos`。

   会看到登录页，默认账号密码都是 **nacos**（输入后登录）：
   

   登录后能看到控制台首页，说明部署成功。
   


#### 停止/删除测试容器
如果只是测试，用完后可以停止或删除容器：
```bash
# 停止容器
docker stop nacos-test
# （可选）删除容器（数据会丢失）
docker rm nacos-test
```


### 方案 2：挂载目录部署（单机+MySQL，适合生产环境）
生产环境需要 **数据持久化**（容器删除后数据不丢），所以要搭配 MySQL 数据库（Nacos 的配置和服务信息存在 MySQL 里），同时挂载宿主机目录到容器，实现“配置持久化”“日志分离”——这是企业里最常用的单机部署方式。

#### 前置准备：安装 MySQL（如果已有 MySQL 可跳过）
如果你的服务器还没有 MySQL，用 Docker 快速装一个（MySQL 5.7 或 8.0 都可以，Nacos 1.3.1 后支持 MySQL 8.0，且兼容 5.7）：
```bash
# 启动 MySQL 5.7 容器，命名为 nacos-mysql，设置root密码为 123456
docker run -d \
  --name nacos-mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=123456 \  # 数据库root密码，生产环境要改复杂点
  -e MYSQL_DATABASE=nacos_config \  # 自动创建 Nacos 专用数据库：nacos_config
  -v /data/nacos/mysql:/var/lib/mysql \  # 挂载 MySQL 数据目录，持久化数据
  mysql:5.7
```

#### 步骤 1：初始化 Nacos 数据库脚本
Nacos 需要在 MySQL 中创建表结构和初始数据，有两种方式：

##### 方式 1：手动执行脚本（推荐，清晰可控）
1. 先进入 MySQL 容器：
   ```bash
   docker exec -it nacos-mysql mysql -uroot -p123456
   ```
   （输入后会进入 MySQL 命令行，提示符变成 `mysql>`）

2. 执行 Nacos 官方初始化脚本（直接复制粘贴到 MySQL 命令行，回车执行）：
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
如果嫌手动执行麻烦，可以把上面的脚本保存为 `nacos-mysql.sql`，然后挂载到 MySQL 容器的 `/docker-entrypoint-initdb.d/` 目录（MySQL 会自动执行该目录下的 `.sql` 文件）：
```bash
# 1. 在宿主机创建脚本目录
mkdir -p /data/nacos/init-sql
# 2. 把上面的 SQL 脚本保存到 /data/nacos/init-sql/nacos-mysql.sql
# 3. 重启 MySQL 容器（如果已启动，先停止再启动，带上挂载参数）
docker stop nacos-mysql
docker rm nacos-mysql
docker run -d \
  --name nacos-mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -e MYSQL_DATABASE=nacos_config \
  -v /data/nacos/mysql:/var/lib/mysql \
  -v /data/nacos/init-sql:/docker-entrypoint-initdb.d \  # 挂载初始化脚本目录
  mysql:5.7
```


#### 步骤 2：启动 Nacos 容器（挂载目录+关联 MySQL）
先在宿主机创建 Nacos 所需的挂载目录（用于存放配置、日志）：
```bash
# 创建配置、日志目录（/data/nacos 是根目录，可根据需求修改）
mkdir -p /data/nacos/{conf,logs}
```

然后执行启动命令（关键参数已标注解释）：
```bash
docker run -d \
  --name nacos-prod \  # 容器名，生产环境建议用“nacos-prod”区分
  -p 8848:8848 \  # Nacos 核心端口
  -p 9848:9848 \  # Nacos 客户端连接端口（2.0+版本新增，必须映射）
  -p 9849:9849 \  # Nacos 客户端连接端口（2.0+版本新增，必须映射）
  -e MODE=standalone \  # 单机模式
  -e SPRING_DATASOURCE_PLATFORM=mysql \  # 启用 MySQL 作为数据源（关键参数）
  -e MYSQL_SERVICE_HOST=192.168.1.100 \  # 你的 MySQL 服务器 IP（如果 MySQL 在同一台机器，填宿主机IP，不要填127.0.0.1）
  -e MYSQL_SERVICE_PORT=3306 \  # MySQL 端口（默认3306）
  -e MYSQL_SERVICE_DB_NAME=nacos_config \  # Nacos 专用数据库名（和前面创建的一致）
  -e MYSQL_SERVICE_USER=root \  # MySQL 用户名
  -e MYSQL_SERVICE_PASSWORD=123456 \  # MySQL 密码（和前面设置的一致）
  -e MYSQL_DATABASE_NUM=1 \  # 数据库实例数量（默认1，不用改）
  -e JVM_XMS=1g \  # JVM 初始内存（生产环境建议1g，根据服务器内存调整）
  -e JVM_XMX=1g \  # JVM 最大内存（和初始内存一致，避免频繁GC）
  -e JVM_XMN=512m \  # JVM 新生代内存
  -v /data/nacos/conf:/home/nacos/conf \  # 挂载 Nacos 配置目录（持久化配置）
  -v /data/nacos/logs:/home/nacos/logs \  # 挂载 Nacos 日志目录（方便查看日志）
  --restart=always \  # 容器退出后自动重启（生产环境必备，保障高可用）
  nacos/nacos-server:2.0.2
```

#### 步骤 3：验证部署（和方案1一致）
1. 查看容器状态：`docker ps | grep nacos-prod`，确保“STATUS”是“Up”；
2. 访问控制台：`http://服务器IP:8848/nacos`，用 `nacos/nacos` 登录；
3. （可选）验证数据持久化：在控制台创建一个配置（比如 dataId 为“test.conf”，内容为“test=123”），然后停止并删除 Nacos 容器，重新启动后，登录控制台查看配置是否还在——如果在，说明数据已持久化到 MySQL。


### 方案 3：Docker Compose 部署（单机+MySQL，简化运维）
如果觉得手动启动 Nacos 和 MySQL 太麻烦，可以用 `docker-compose.yml` 文件统一管理两个容器，实现“一键启动/停止”，适合运维人员或需要频繁部署的场景。

#### 步骤 1：创建 docker-compose.yml 文件
在宿主机创建一个目录（比如 `/data/nacos-compose`），然后在该目录下创建 `docker-compose.yml` 文件：
```yaml
version: '3.8'  # Docker Compose 版本（根据你的 Docker 版本调整，3.8 兼容大部分版本）
services:
  # MySQL 服务（Nacos 数据源）
  nacos-mysql:
    image: mysql:5.7  # MySQL 镜像版本
    container_name: nacos-mysql  # 容器名
    restart: always  # 自动重启
    environment:
      MYSQL_ROOT_PASSWORD: 123456  # MySQL  root 密码
      MYSQL_DATABASE: nacos_config  # 自动创建 Nacos 数据库
    volumes:
      - ./mysql:/var/lib/mysql  # 挂载 MySQL 数据目录（相对路径，和 yml 同目录）
      - ./init-sql:/docker-entrypoint-initdb.d  # 挂载初始化脚本目录（自动执行 SQL）
    ports:
      - "3306:3306"  # 端口映射
    networks:
      - nacos-network  # 加入自定义网络（避免端口冲突）

  # Nacos Server 服务
  nacos-server:
    image: nacos/nacos-server:2.0.2  # Nacos 镜像版本
    container_name: nacos-server  # 容器名
    restart: always  # 自动重启
    depends_on:
      - nacos-mysql  # 依赖 MySQL 服务，确保 MySQL 先启动
    environment:
      MODE: standalone  # 单机模式
      SPRING_DATASOURCE_PLATFORM: mysql  # 启用 MySQL 数据源
      MYSQL_SERVICE_HOST: nacos-mysql  # MySQL 服务名（因为在同一网络，可直接用容器名访问，不用填 IP）
      MYSQL_SERVICE_PORT: 3306  # MySQL 端口
      MYSQL_SERVICE_DB_NAME: nacos_config  # 数据库名
      MYSQL_SERVICE_USER: root  # MySQL 用户名
      MYSQL_SERVICE_PASSWORD: 123456  # MySQL 密码
      JVM_XMS: 1g  # JVM 内存配置
      JVM_XMX: 1g
      JVM_XMN: 512m
    volumes:
      - ./nacos/conf:/home/nacos/conf  # 挂载 Nacos 配置目录
      - ./nacos/logs:/home/nacos/logs  # 挂载 Nacos 日志目录
    ports:
      - "8848:8848"  # Nacos 核心端口
      - "9848:9848"  # Nacos 客户端端口（2.0+ 必须）
      - "9849:9849"  # Nacos 客户端端口（2.0+ 必须）
    networks:
      - nacos-network  # 加入自定义网络

# 自定义网络（让 Nacos 和 MySQL 内部通信，不暴露给外部其他服务）
networks:
  nacos-network:
    driver: bridge  # 桥接模式（默认）
```

#### 步骤 2：准备初始化脚本
和方案 2 一样，把 Nacos 数据库初始化 SQL 脚本保存到 `./init-sql/nacos-mysql.sql`（`./` 指 `docker-compose.yml` 所在目录）：
```bash
# 在 yml 所在目录执行，创建 init-sql 目录并下载脚本（或手动复制脚本）
mkdir -p ./init-sql
# （可选）用 wget 直接下载官方脚本（如果服务器能联网）
wget -O ./init-sql/nacos-mysql.sql https://github.com/alibaba/nacos/blob/2.0.2/distribution/conf/nacos-mysql.sql
```

#### 步骤 3：启动服务
在 `docker-compose.yml` 所在目录执行下面的命令，一键启动 MySQL 和 Nacos：
```bash
# 后台启动（-d 表示后台运行）
docker compose up -d
```

#### 步骤 4：验证和管理
- 查看服务状态：`docker compose ps`，会显示两个服务的状态（Up 表示正常）；
- 查看日志：`docker compose logs -f nacos-server`（实时查看 Nacos 日志，有问题可排查）；
- 停止服务：`docker compose down`（会停止并删除容器，但挂载的目录数据不会丢）；
- 重启服务：`docker compose restart`。


### 方案 4：Docker Compose 集群部署（适合生产高可用）
如果你的业务对可用性要求高（比如不能接受 Nacos 单点故障），可以部署 Nacos 集群（至少 3 个节点）。这里用 **嵌入式存储（EMBEDDED_STORAGE）** 模式（不用额外装 MySQL，适合快速搭建集群，生产环境也可使用）。

#### 步骤 1：创建集群 docker-compose.yml
创建 `nacos-cluster.yml` 文件：
```yaml
version: '3.8'
services:
  # Nacos 节点 1
  nacos-server-1:
    image: nacos/nacos-server:2.0.2
    container_name: nacos-server-1
    restart: always
    environment:
      MODE: cluster  # 集群模式（关键）
      EMBEDDED_STORAGE: embedded  # 启用嵌入式存储（不用 MySQL）
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"  # 集群节点列表（用容器名）
      NACOS_SERVER_IP: nacos-server-1  # 当前节点 IP（容器名）
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
    ports:
      - "8848:8848"
      - "9848:9848"
      - "9849:9849"
    networks:
      - nacos-cluster-network

  # Nacos 节点 2
  nacos-server-2:
    image: nacos/nacos-server:2.0.2
    container_name: nacos-server-2
    restart: always
    environment:
      MODE: cluster
      EMBEDDED_STORAGE: embedded
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"
      NACOS_SERVER_IP: nacos-server-2
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
    ports:
      - "8849:8848"  # 宿主机端口 8849 映射到容器 8848
      - "9858:9848"
      - "9859:9849"
    networks:
      - nacos-cluster-network

  # Nacos 节点 3
  nacos-server-3:
    image: nacos/nacos-server:2.0.2
    container_name: nacos-server-3
    restart: always
    environment:
      MODE: cluster
      EMBEDDED_STORAGE: embedded
      NACOS_SERVERS: "nacos-server-1:8848 nacos-server-2:8848 nacos-server-3:8848"
      NACOS_SERVER_IP: nacos-server-3
      JVM_XMS: 1g
      JVM_XMX: 1g
      JVM_XMN: 512m
    ports:
      - "8850:8848"  # 宿主机端口 8850 映射到容器 8848
      - "9868:9848"
      - "9869:9849"
    networks:
      - nacos-cluster-network

networks:
  nacos-cluster-network:
    driver: bridge
```

#### 步骤 2：启动集群
在 `nacos-cluster.yml` 所在目录执行：
```bash
docker compose -f nacos-cluster.yml up -d
```

#### 步骤 3：验证集群
1. 访问任意节点的控制台：`http://服务器IP:8848/nacos`、`http://服务器IP:8849/nacos`、`http://服务器IP:8850/nacos`，登录后在“集群管理 → 节点列表”中能看到 3 个节点，状态都是“UP”，说明集群正常；
2. 测试高可用：停止其中一个节点（比如 `docker stop nacos-server-1`），刷新控制台，剩下的两个节点仍能正常工作，且服务注册/配置管理不受影响。


## 五、Nacos 核心操作：服务注册、发现与配置管理
部署完成后，咱们实际操作一下 Nacos 的核心功能，用命令行或控制台都能实现，这里两种方式都讲。


### 1. 服务注册（让服务加入 Nacos）
#### 方式 1：用 curl 命令注册（适合测试）
执行下面的命令，注册一个名为“user-service”的服务实例（IP 为 192.168.1.101，端口 8080）：
```bash
curl -X PUT 'http://服务器IP:8848/nacos/v1/ns/instance?serviceName=user-service&ip=192.168.1.101&port=8080'
```

成功会返回 `ok`。

#### 方式 2：在控制台注册
1. 登录 Nacos 控制台，进入“服务管理 → 服务列表”；
2. 点击“新建服务”，输入服务名（比如“user-service”），其他默认，点击“确认”；
3. 进入该服务的详情页，点击“实例列表 → 新增实例”，输入 IP 和端口，点击“确认”。


### 2. 服务发现（查询服务实例）
#### 方式 1：用 curl 命令查询
查询“user-service”的所有健康实例：
```bash
curl -X GET 'http://服务器IP:8848/nacos/v1/ns/instances?serviceName=user-service'
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
#### 方式 1：用 curl 命令操作
##### 发布配置（新增一个配置）
发布一个 dataId 为“user-service-dev.conf”、group 为“DEFAULT_GROUP”、内容为“db.url=jdbc:mysql://127.0.0.1:3306/user_db”的配置：
```bash
curl -X POST "http://服务器IP:8848/nacos/v1/cs/configs?dataId=user-service-dev.conf&group=DEFAULT_GROUP&content=db.url=jdbc:mysql://127.0.0.1:3306/user_db"
```

成功返回 `true`。

##### 获取配置
查询上面发布的配置：
```bash
curl -X GET "http://服务器IP:8848/nacos/v1/cs/configs?dataId=user-service-dev.conf&group=DEFAULT_GROUP"
```

成功返回配置内容：`db.url=jdbc:mysql://127.0.0.1:3306/user_db`。

#### 方式 2：在控制台操作
1. 进入“配置管理 → 配置列表”，点击“+”新建配置；
2. 输入 dataId（比如“user-service-dev.conf”）、group（默认“DEFAULT_GROUP”）、配置内容（比如数据库地址、超时时间）；
3. 点击“发布”，配置就会保存到 Nacos；
4. 要获取配置，直接在配置列表中找到该配置，点击“查看”即可。


## 六、常见问题与解决方案
部署和使用过程中遇到问题不用慌，下面是高频问题的解决方法：


### 1. 浏览器访问不到 Nacos 控制台？
#### 排查步骤：
1. **检查容器是否正常运行**：`docker ps | grep nacos`，如果 STATUS 是“Exited”，执行 `docker logs 容器名` 查看日志（比如日志显示“MySQL 连接失败”，就是数据库配置错了）；
2. **检查端口是否开放**：
   - 云服务器：在控制台的“安全组”中放行 8848、9848、9849 端口；
   - 本地服务器：执行 `firewall-cmd --list-ports` 查看端口是否开放，没开放的话执行：
     ```bash
     # 开放 8848 端口（永久生效）
     firewall-cmd --add-port=8848/tcp --permanent
     firewall-cmd --add-port=9848/tcp --permanent
     firewall-cmd --add-port=9849/tcp --permanent
     # 重启防火墙
     firewall-cmd --reload
     ```
3. **检查端口是否冲突**：执行 `netstat -tuln | grep 8848`，如果显示“LISTEN”，说明端口被其他进程占用，启动 Nacos 时换宿主机端口（比如 `-p 8849:8848`）。


### 2. Nacos 连接不上 MySQL？
#### 常见原因：
1. **MySQL 地址填错**：如果 MySQL 和 Nacos 在同一台机器，不要填 `127.0.0.1`（容器内的 127.0.0.1 是容器自身，不是宿主机），要填宿主机的真实 IP（比如 192.168.1.100）；
2. **MySQL 密码错误**：检查 `MYSQL_SERVICE_PASSWORD` 参数是否和 MySQL 实际密码一致；
3. **MySQL 没初始化脚本**：Nacos 启动时会报错“Table 'nacos_config.config_info' doesn't exist”，需要重新执行初始化 SQL 脚本；
4. **MySQL 版本不兼容**：Nacos 1.3.1 后支持 MySQL 8.0，如果用 MySQL 5.7，要确保镜像版本是 5.7（不要用 8.0）。


### 3. 容器启动后马上退出（STATUS: Exited）？
执行 `docker logs 容器名` 查看日志，根据日志提示解决：
- 日志含“JVM 内存不足”：减小 JVM_XMS、JVM_XMX（比如改成 512m）；
- 日志含“集群节点配置错误”：检查 `NACOS_SERVERS` 参数，集群模式下节点列表要填全（至少 3 个节点）；
- 日志含“权限不足”：给宿主机挂载目录授权（比如 `chmod -R 777 /data/nacos`）。


### 4. 怎么开启 Nacos 认证（防止未授权访问）？
默认情况下，Nacos 不需要认证就能访问，生产环境要开启：
1. 启动 Nacos 时添加两个环境变量：
   ```bash
   -e NACOS_AUTH_ENABLE=true \  # 开启认证
   -e NACOS_AUTH_TOKEN=YourSecretKey123456 \  # 自定义密钥（生产环境要复杂点）
   ```
2. 重启 Nacos 后，访问控制台需要输入账号密码（默认还是 nacos/nacos），API 调用也需要在请求头中带认证信息（比如 `Authorization: Bearer 令牌`，令牌需要通过登录接口获取）。


## 七、总结
到这里，你已经掌握了 Nacos Server 的全部核心部署方案：
- 新手/测试用 **方案 1（快速部署）**，1 条命令搞定；
- 生产单机用 **方案 2（挂载目录+MySQL）** 或 **方案 3（Docker Compose）**，确保数据持久化；
- 生产高可用用 **方案 4（集群部署）**，避免单点故障。

后续可以结合业务需求，探索 Nacos 的高级功能：比如用命名空间隔离开发/测试/生产环境、用服务路由实现灰度发布、结合 Prometheus+Grafana 监控 Nacos 状态（官方有监控指南，可参考 [Nacos Monitor Guide](https://nacos.io/zh-cn/docs/monitor-guide.html)）。

如果遇到其他问题，优先查看 Nacos 容器日志（`docker logs 容器名`），大部分问题都能在日志中找到原因；也可以参考 [Nacos 官方文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)，里面有更详细的功能说明。

