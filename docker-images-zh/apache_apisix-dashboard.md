---
image: apache/apisix-dashboard
description: "Apache APISIX Dashboard是Apache APISIX的官方Web UI，旨在为用户提供友好、直观的界面以管理和运维APISIX集群，支持可视化配置路由、服务、上游、插件等核心资源，实时监控集群运行状态与流量指标，有效简化APISIX的运维复杂度，帮助用户更高效地部署、管理和维护API网关。"
source: https://xuanyuan.cloud/zh/r/apache/apisix-dashboard
canonical: https://xuanyuan.cloud/zh/r/apache/apisix-dashboard
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/apisix-dashboard" title="apache/apisix-dashboard Docker 镜像中文简介、标签列表与拉取命令">apache/apisix-dashboard — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/apisix-dashboard" title="apache/apisix-dashboard Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/apisix-dashboard</a>

# Apache APISIX Docker 镜像使用说明


Docker 镜像非 ASF 官方发布版本，仅为方便使用提供。推荐做法始终是从源码构建。


## 如何构建镜像

**master 分支对应 Apache APISIX 2.x 版本。如需旧版本，请从 [v1.x]([]) 标签构建。**


### 从源码构建镜像

#### 1. 基于发布版本构建
```sh
# 将 Apache 发布版本赋值给变量 APISIX_VERSION，例如：2.9。
# 最新发布版本可在 [] 查看

export APISIX_VERSION=2.9

# 构建基于 alpine 的镜像
make build-on-alpine

# 构建基于 centos 的镜像
make build-on-centos
```

#### 2. 基于 master 分支构建（含最新代码，仅为开发者便利）
```sh
export APISIX_VERSION=master

# 构建基于 alpine 的镜像
make build-on-alpine

# 构建基于 centos 的镜像
make build-on-centos
```

#### 3. 基于本地代码构建
```sh
# 需将本地 APISIX 代码复制到构建上下文路径
cp -r <本地APISIX路径> ./apisix

export APISIX_PATH=./apisix
make build-on-alpine-local

# 若遇 "error checking context: 'can't start'" 错误，可能需要 root 权限
```

**提示**：中文环境用户建议执行以下命令，通过附加构建参数 `ENABLE_PROXY=true` 启用代理加速构建：
```sh
$ make build-on-alpine-cn
```


### 通过 Docker 手动部署 APISIX
详情请参见 [手动部署文档]([])。


### 通过 docker-compose 快速启动

#### 启动所有模块
```sh
cd example
docker-compose -p docker-apisix up -d
```

更多用法可参考 [docker-compose 示例文档]([])。


### 一站式 Docker 容器快速测试

#### APISIX 一站式容器
```sh
# 构建一站式镜像
make build-all-in-one

# 启动 APISIX 容器
docker run -d \
-p 9080:9080 -p 9091:9091 -p 2379:2379 \
-v `pwd`/all-in-one/apisix/config.yaml:/usr/local/apisix/conf/config.yaml \
apache/apisix:whole
```

#### APISIX-Dashboard 一站式容器
**`apisix-dashboard` 最新版本为 2.9，可与 APISIX 2.10 配合使用。**
```sh
# 构建 dashboard 镜像
make build-dashboard

# 启动 APISIX-Dashboard 容器
docker run -d \
-p 9080:9080 -p 9091:9091 -p 2379:2379 -p 9000:9000 \
-v `pwd`/all-in-one/apisix/config.yaml:/usr/local/apisix/conf/config.yaml \
-v `pwd`/all-in-one/apisix-dashboard/conf.yaml:/usr/local/apisix-dashboard/conf/conf.yaml \
apache/apisix-dashboard:whole
```

**端口冲突处理**：若遇端口冲突，可通过 `docker run -p` 修改主机端口，例如：
```sh
# 调整主机端口以避免冲突
docker run -d \
-p 19080:9080 -p 19091:9091 -p 12379:2379 -p 19000:9000 \
-v `pwd`/all-in-one/apisix/config.yaml:/usr/local/apisix/conf/config.yaml \
-v `pwd`/all-in-one/apisix-dashboard/conf.yaml:/usr/local/apisix-dashboard/conf/conf.yaml \
apache/apisix-dashboard:whole
```


## 注意事项
Apache APISIX 的 Prometheus 指标端口默认监听 `127.0.0.1:9091`，若需从 Docker 外部访问，需修改为监听 `0.0.0.0`。可在 `config.yaml` 中添加以下配置：
```yaml
plugin_attr:
  prometheus:
    export_addr:
      ip: "0.0.0.0"
      port: 9091
```
