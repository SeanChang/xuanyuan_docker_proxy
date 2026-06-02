---
image: yagagagaga/doris-standalone
description: "Apache Doris是一款易用、高性能的统一分析型数据库。"
source: https://xuanyuan.cloud/zh/r/yagagagaga/doris-standalone
canonical: https://xuanyuan.cloud/zh/r/yagagagaga/doris-standalone
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [yagagagaga/doris-standalone — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/yagagagaga/doris-standalone)

含镜像标签、拉取命令、部署文档与相关推荐。

[yagagagaga/doris-standalone Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/yagagagaga/doris-standalone)

# Doris-Standalone Docker镜像文档


## 重要提示

若在本镜像中未找到某些Doris版本，可能是由于Docker Hub的存储限制或其他政策导致版本被删除。


## 镜像概述和主要用途

### 关于Doris

[Apache Doris](https://doris.apache.org/) 是一款基于MPP架构的高性能实时分析数据库，以极速和易用性著称。在海量数据场景下，Doris可提供亚秒级查询响应，同时支持高并发点查询和高吞吐复杂分析，适用于报表分析、即席查询、统一数据仓库、数据湖查询加速等场景，可构建用户行为分析、AB测试平台、日志检索分析、用户画像分析、订单分析等应用。

![Doris Logo](https://raw.githubusercontent.com/apache/doris/master/webroot/static/doris-logo.png)

### 关于Doris-Standalone镜像

Doris-Standalone镜像旨在简化Doris的部署和使用流程，避免繁琐的配置、部署及运维工作，帮助用户快速上手Doris。该镜像集成了Doris的所有核心组件（FE、BE、Broker、audit_loader等），并预设了优化参数以减少使用障碍。


## 核心功能与特性

- **全组件集成**：包含FE（Frontend）、BE（Backend）、Broker、audit_loader等所有Doris核心组件
- **参数预设**：内置优化配置，避免用户因基础配置问题走弯路
- **多版本支持**：覆盖Doris 1.1.x至3.0.x系列版本（具体版本以Docker Hub实际提供为准）
- **Cloud Mode支持**：3.0.0及以上版本支持Cloud Mode部署模式
- **一键启动**：无需手动配置组件间依赖，简化部署流程


## 使用场景与适用范围

**适用场景**：
- 学习Doris新功能和核心特性
- 本地环境复现Doris相关问题（Bug）
- 快速验证Doris查询语法和功能逻辑

**限制说明**：
- **不适合生产环境**，仅用于开发、测试和学习
- 推荐运行环境：个人PC或Mac（资源配置需满足Doris基础运行要求）


## 详细使用方法和配置说明

### 前置准备

为充分发挥Doris性能，建议在宿主机修改以下系统配置：

```bash
# 调整虚拟内存映射数量
sysctl -w vm.max_map_count=2000000
# 关闭交换分区
swapoff -a
# 调整文件描述符限制
ulimit -n 1000000
# 配置透明大页
echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
```

若无法修改上述配置，需在启动容器时添加`--privileged=true`参数以获取特权模式。


### 启动容器

#### 普通模式（默认）

适用于所有版本，启动命令：

```bash
docker run -itd \
  --privileged=true \
  -e "TZ=Asia/Shanghai" \
  -e "TIME_ZONE=Asia/Shanghai" \
  --name my-doris \
  -p 8030:8030 \
  -p 8040:8040 \
  -p 9030:9030 \
  yagagagaga/doris-standalone
```

#### Cloud Mode（3.0.0及以上版本）

适用于3.0.0及更高版本，需添加`MODE=cloud`环境变量：

```bash
docker run -itd \
  --privileged=true \
  -e "TZ=Asia/Shanghai" \
  -e "TIME_ZONE=Asia/Shanghai" \
  -e MODE=cloud \
  --name my-doris \
  -p 8030:8030 \
  -p 8040:8040 \
  -p 9030:9030 \
  yagagagaga/doris-standalone
```


### 环境变量说明

| 环境变量       | 说明                          | 默认值           |
|----------------|-------------------------------|------------------|
| `TZ`           | 容器时区                      | 无               |
| `TIME_ZONE`    | 系统时区                      | 无               |
| `MODE`         | 部署模式（`cloud`或默认）     | 空（普通模式）   |


### 启动验证

- **首次启动耗时**：约1~2分钟（取决于CPU性能），属正常现象
- **成功标志**：容器日志中出现Doris Logo或以下消息：

```log
=============================
Everything is ready, enjoy!
=============================
```

- **日志查看**：通过`docker logs -f my-doris`命令查看启动过程，WARNING级别的堆栈异常可忽略。


### 服务与端口说明

不同版本的组件和端口映射存在差异，核心服务及默认端口如下（完整版本列表可参考原镜像文档）：

#### 核心服务对照表（示例）

| 版本                | FE  | BE  | Broker | Audit Log | Meta Service | Recycler |
|---------------------|-----|-----|--------|-----------|--------------|----------|
| 3.0.7（Cloud Mode） | ✔️  | ✔️  |        | ✔️        | ✔️           | ✔️        |
| 3.0.7（普通模式）   | ✔️  | ✔️  | ✔️     | ✔️        |              |          |
| 2.1.11              | ✔️  | ✔️  | ✔️     | ✔️        |              |          |

#### 核心端口对照表（示例）

| 端口  | 用途                  | 组件   |
|-------|-----------------------|--------|
| 8030  | FE WebUI              | FE     |
| 8040  | BE WebUI              | BE     |
| 9030  | FE MySQL客户端端口     | FE     |
| 8000  | Broker Thrift RPC端口 | Broker |
| 5000  | Meta Service端口       | Meta   |


### 连接与使用

#### 通过MySQL客户端连接

Doris默认提供`root`用户（无密码），使用MySQL客户端连接：

```bash
mysql -uroot -P9030 -h127.0.0.1
```

#### 通过WebUI访问

- **FE WebUI**：http://127.0.0.1:8030（用户名`root`，无密码）
- **BE WebUI**：http://127.0.0.1:8040


## 附加工具

若需Doris管理工具，可参考 [Doris-Manager](https://hub.docker.com/r/yagagagaga/doris-manager) 镜像。
