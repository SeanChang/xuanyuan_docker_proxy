---
image: hashicorp/consul-aws
description: "在AWS CloudMap命名空间和Consul数据中心之间同步服务，实现跨Consul与AWS CloudMap的原生服务发现，支持双向同步且独立于Consul版本快速迭代AWS集成。"
source: https://xuanyuan.cloud/zh/r/hashicorp/consul-aws
canonical: https://xuanyuan.cloud/zh/r/hashicorp/consul-aws
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hashicorp/consul-aws" title="hashicorp/consul-aws Docker 镜像中文简介、标签列表与拉取命令">hashicorp/consul-aws 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Consul-AWS

## 镜像概述和主要用途
`consul-aws`用于在AWS CloudMap命名空间和Consul数据中心之间同步服务，支持从Consul到AWS CloudMap、从AWS CloudMap到Consul以及双向同步，实现跨两者的原生服务发现。该项目独立于Consul版本控制，可快速迭代AWS集成功能，无需强制用户升级Consul。

## 核心功能和特性
- **双向同步支持**：可配置从Consul到AWS CloudMap（`-to-aws`）、从AWS CloudMap到Consul（`-to-consul`）或同时双向同步
- **Consul集群连接**：提供连接Consul集群的必要标志，包括设置ACL token的能力
- **AWS配置兼容**：支持AWS SDK的所有配置方式，包括`.aws`文件、实例配置文件和环境变量
- **命名空间指定**：需提供AWS CloudMap命名空间ID以标识同步目标

## 使用场景和适用范围
- 需要在Consul和AWS CloudMap之间实现服务发现互通的环境
- 需跨Consul和AWS CloudMap进行服务信息同步的场景
- 希望独立于Consul版本快速获取AWS集成更新的用户

## 使用方法和配置说明
### 前提条件
- 已部署Consul集群并可访问
- 已创建AWS CloudMap命名空间并获取其ID
- 已配置AWS访问权限（通过`.aws`文件、实例配置文件或环境变量）

### 基本命令格式
```shell
consul-aws sync-catalog -aws-namespace-id <aws-namespace-id> [同步方向参数]
```

### 同步方向参数
- `-to-aws`：从Consul同步到AWS CloudMap
- `-to-consul`：从AWS CloudMap同步到Consul
- 同时指定上述两个参数：双向同步

### Docker部署示例
```shell
docker run docker.xuanyuan.run/hashicorp/consul-aws consul-aws sync-catalog \
  -aws-namespace-id ns-hjrgt3bapp7phzff \  # 替换为实际的AWS CloudMap命名空间ID
  -to-aws \                                # 启用Consul到AWS CloudMap同步
  -to-consul                               # 启用AWS CloudMap到Consul同步
```

## 兼容性说明
`consul-aws`支持当前Consul版本及前一个版本。文档编写时，支持的版本为`1.7`和`1.6`。

## 贡献指南
请参考[`consul-aws` GitHub仓库](https://github.com/hashicorp/consul-aws)中的贡献指南。
