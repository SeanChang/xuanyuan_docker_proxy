---
image: valkey/valkey-bundle
description: "valkey-bundle镜像用于安装valkey服务器并加载所有valkey模块，提供集成了服务器与完整模块的一站式运行环境。"
source: https://xuanyuan.cloud/zh/r/valkey/valkey-bundle
canonical: https://xuanyuan.cloud/zh/r/valkey/valkey-bundle
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/valkey/valkey-bundle" title="valkey/valkey-bundle Docker 镜像中文简介、标签列表与拉取命令">valkey/valkey-bundle 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Valkey Bundle Docker镜像文档


## 镜像概述和主要用途

Valkey Bundle 是容器化版本的 Valkey，基于官方 Valkey 镜像构建，并集成了多个流行模块，包括 [Valkey JSON](https://github.com/valkey-io/valkey-json)、[Valkey Bloom](https://github.com/valkey-io/valkey-bloom)、[Valkey Search](https://github.com/valkey-io/valkey-search) 和 [Valkey LDAP](https://github.com/valkey-io/valkey-ldap)。该镜像简化了 Valkey 的部署流程，开箱即可提供标准 Valkey 功能及高级数据结构、搜索能力等扩展特性。


## 核心功能和特性

- **多模块集成**：预加载 Valkey JSON（JSON 数据操作）、Valkey Bloom（布隆过滤器）、Valkey Search（全文搜索）、Valkey LDAP（LDAP 认证）模块，无需额外配置即可使用
- **基于官方镜像**：构建于官方 Valkey 基础镜像之上，确保兼容性和稳定性
- **高级数据结构支持**：通过 Valkey JSON 支持 JSON 数据类型，Valkey Bloom 提供高效去重能力
- **增强搜索能力**：Valkey Search 模块提供全文索引和复杂查询功能
- **企业级认证**：集成 Valkey LDAP 模块，支持 LDAP 认证机制


## 使用场景和适用范围

- **开发/测试环境**：快速搭建包含完整模块的 Valkey 环境，验证高级功能
- **生产环境**：需要同时使用标准 Valkey 功能和扩展模块的业务场景
- **JSON 数据处理**：需存储和操作 JSON 数据的应用（如配置管理、复杂对象存储）
- **去重需求**：利用布隆过滤器实现高效数据去重（如日志处理、重复请求过滤）
- **全文搜索**：需对存储数据进行全文检索的应用（如内容管理系统、文档索引）
- **企业级部署**：通过 Valkey LDAP 模块集成企业现有 LDAP 认证系统


## 支持的标签

### 正式发布版本

| 标签                                     | Dockerfile 链接                                                                 |
|------------------------------------------|--------------------------------------------------------------------------------|
| `8.1.3`, `8.1`, `8`, `latest`, `8.1.3-trixie`, `8.1-trixie`, `8-trixie`, `trixie` | [debian 基础](https://github.com/valkey-io/valkey-bundle/blob/mainline/8.1/debian/Dockerfile) |
| `8.1.3-alpine`, `8.1-alpine`, `8-alpine`, `alpine` | [alpine 基础](https://github.com/valkey-io/valkey-bundle/blob/mainline/8.1/alpine/Dockerfile) |

### 候选发布版本（RC）

| 标签                                     | Dockerfile 链接                                                                 |
|------------------------------------------|--------------------------------------------------------------------------------|
| `9.0.0-rc3`, `9.0-rc3`, `9.0.0-rc3-trixie`, `9.0-rc3-trixie` | [debian 基础](https://github.com/valkey-io/valkey-bundle/blob/mainline/9.0/debian/Dockerfile) |
| `9.0.0-rc3-alpine`, `9.0-rc3-alpine`     | [alpine 基础](https://github.com/valkey-io/valkey-bundle/blob/mainline/9.0/alpine/Dockerfile) |


## 版本信息

| valkey-bundle 版本                       | Valkey 版本                              | Valkey JSON 版本                       | Valkey Bloom 版本                      | Valkey Search 版本                     | Valkey LDAP 版本                       |
|------------------------------------------|------------------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|
| [9.0.0-rc3](https://github.com/valkey-io/valkey-bundle/releases/tag/9.0.0-rc3) | [9.0.0-rc3](https://github.com/valkey-io/valkey/releases/tag/9.0.0-rc3) | [1.0.2](https://github.com/valkey-io/valkey-json/releases/tag/1.0.2) | [1.0.0](https://github.com/valkey-io/valkey-bloom/releases/tag/1.0.0) | [1.0.1](https://github.com/valkey-io/valkey-search/releases/tag/1.0.1) | [1.0.0](https://github.com/valkey-io/valkey-ldap/releases/tag/1.0.0) |
| [8.1.3](https://github.com/valkey-io/valkey-bundle/releases/tag/8.1.3) | [8.1.4](https://github.com/valkey-io/valkey/releases/tag/8.1.4) | [1.0.2](https://github.com/valkey-io/valkey-json/releases/tag/1.0.2) | [1.0.0](https://github.com/valkey-io/valkey-bloom/releases/tag/1.0.0) | [1.0.1](https://github.com/valkey-io/valkey-search/releases/tag/1.0.1) | [1.0.0](https://github.com/valkey-io/valkey-ldap/releases/tag/1.0.0) |


## 安全注意事项

- **默认配置风险**：为便于容器间网络访问，镜像默认关闭“保护模式”（Protected mode）。若通过 `-p` 参数将端口暴露到外部网络，实例将无认证开放访问。
- **安全建议**：生产环境中必须设置密码或其他认证方式，具体参考 [Valkey 安全文档](https://valkey.io/topics/security/) 和 [保护模式说明](https://valkey.io/topics/security/#protected-mode)。


## 使用方法和配置说明

### 启动 Valkey Bundle 实例

基础启动命令（后台运行）：

```console
$ docker run --name my-valkey-bundle -d valkey/valkey-bundle
```

### 持久化存储配置

通过 `--save` 参数配置数据持久化策略（如每60秒至少1次写入则保存快照），数据默认存储在容器内 `/data` 目录（可通过 `-v` 挂载宿主机目录实现持久化）：

```console
$ docker run --name my-valkey-bundle -d \
  -v /宿主机/data目录:/data \
  valkey/valkey-bundle \
  valkey-server --save 60 1 --loglevel warning
```

### 通过 `valkey-cli` 连接实例

在同一网络中通过 `valkey-cli` 连接容器：

```console
# 创建自定义网络（可选）
$ docker network create valkey-network

# 启动实例并加入网络
$ docker run --name my-valkey-bundle -d --network valkey-network valkey/valkey-bundle

# 运行 valkey-cli 连接
$ docker run -it --network valkey-network --rm valkey/valkey-bundle valkey-cli -h my-valkey-bundle
```

### 通过环境变量传递启动参数

使用 `VALKEY_EXTRA_FLAGS` 环境变量传递额外启动参数：

```console
$ docker run --env VALKEY_EXTRA_FLAGS='--save 60 1 --loglevel warning --requirepass "mypassword"' valkey/valkey-bundle
```

### 自定义配置文件

#### 方法1：通过 Dockerfile 集成配置文件

```dockerfile
FROM docker.xuanyuan.run/valkey/valkey-bundle:latest
COPY valkey.conf /usr/local/etc/valkey/valkey.conf
CMD ["valkey-server", "/usr/local/etc/valkey/valkey.conf"]
```

#### 方法2：通过挂载外部配置文件

```console
$ docker run -v /宿主机/配置目录:/usr/local/etc/valkey \
  --name my-valkey-bundle valkey/valkey-bundle \
  valkey-server /usr/local/etc/valkey/valkey.conf
```


## 镜像变体

### `valkey/valkey-bundle:<version>`（Debian 基础）

- **特点**：基于 Debian 系统构建，包含 Valkey 及所有模块，预加载模块开箱即用。
- **适用场景**：开发、测试、生产环境，尤其适合需要安装额外系统包（如依赖库）的场景。
- **标签说明**：部分标签包含 Debian 版本代号（如 `trixie`），用于明确基础镜像版本，建议显式指定以避免基础镜像更新导致的兼容性问题。

### `valkey/valkey-bundle:<version>-alpine`（Alpine 基础）

- **特点**：基于 Alpine Linux 构建，镜像体积极小（约5MB基础镜像），适合对镜像大小敏感的场景。
- **注意事项**：使用 musl libc 替代 glibc，部分依赖 glibc 的软件可能存在兼容性问题；默认不包含额外工具（如 `git`、`bash`），需自行在 Dockerfile 中安装。
- **适用场景**：资源受限环境、对镜像体积有严格要求的部署。


## 许可证

镜像包含软件的许可证信息请参见 [Valkey Bundle 许可证](https://github.com/valkey-io/valkey-bundle/blob/mainline/LICENSE)。  
使用本镜像的用户需自行确保遵守所有包含软件的许可证要求。
