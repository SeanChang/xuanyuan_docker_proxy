---
image: library/vault
description: "Vault是一款通过统一接口安全访问机密的工具，提供严格的访问控制和详细的审计日志。"
source: https://xuanyuan.cloud/zh/r/library/vault
canonical: https://xuanyuan.cloud/zh/r/library/vault
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/vault" title="library/vault Docker 镜像中文简介、标签列表与拉取命令">library/vault 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# **废弃通知**

Vault 1.14版本起，我们将停止在Dockerhub发布官方镜像，仅发布Verified Publisher镜像。Docker镜像用户应从[hashicorp/vault](https://hub.docker.com/r/hashicorp/vault)拉取，而非[vault](https://hub.docker.com/_/vault)。Verified Publisher镜像可在https://hub.docker.com/r/hashicorp/vault获取。

# 快速参考

- **维护者**：  
  [HashiCorp](https://github.com/hashicorp/docker-vault)

- **获取帮助**：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic)或[Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的`Dockerfile`链接

**无支持的标签**

# 快速参考（续）

- **问题提交地址**：  
  [https://github.com/hashicorp/docker-vault/issues](https://github.com/hashicorp/docker-vault/issues?q=)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  **无支持的架构**

- **发布的镜像工件详情**：  
  [repo-info仓库的`repos/vault/`目录](https://github.com/docker-library/repo-info/blob/master/repos/vault) ([历史记录](https://github.com/docker-library/repo-info/commits/master/repos/vault))  
  （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的`library/vault`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fvault)  
  [official-images仓库的`library/vault`文件](https://github.com/docker-library/official-images/blob/master/library/vault) ([历史记录](https://github.com/docker-library/official-images/commits/master/library/vault))

- **本描述的来源**：  
  [docs仓库的`vault/`目录](https://github.com/docker-library/docs/tree/master/vault) ([历史记录](https://github.com/docker-library/docs/commits/master/vault))

# Vault

Vault是一款用于安全访问机密的工具。机密是指任何需要严格控制访问的信息，如API密钥、密码、证书等。Vault提供统一的机密访问接口，同时具备严格的访问控制和详细的审计日志。更多信息请参见：

- [Vault官方文档](https://www.vaultproject.io/)
- [Vault GitHub仓库](https://github.com/hashicorp/vault)

![logo](https://raw.githubusercontent.com/docker-library/docs/90d4d43bdfccd5cb21e5fd964d32b0074af0f357/vault/logo.svg?sanitize=true)

# 使用容器

我们选择Alpine作为基础镜像，因其轻量且安全表面积较小，同时具备足够的开发和交互式调试功能。

Vault始终在[dumb-init](https://github.com/Yelp/dumb-init)下运行，它负责回收僵尸进程并将信号转发给容器内的所有进程。该二进制文件由HashiCorp构建并使用我们的[GPG密钥](https://www.hashicorp.com/security.html)签名，因此您可以验证用于构建特定基础镜像的已签名包。

运行Vault容器时不带参数将启动Vault服务器的[开发模式](https://www.vaultproject.io/docs/concepts/dev-server.html)。提供的入口点脚本还会查找Vault子命令，并使用该子命令运行`vault`。例如，执行`docker run vault status`将在容器内运行`vault status`命令。当运行`server`子命令时，入口点还会添加下文详细说明的一些特殊配置选项。其他任何命令都将在`dumb-init`下通过`exec`在容器内执行。

容器公开两个可选的`VOLUME`：

- `/vault/logs`：用于写入持久审计日志。默认情况下不会写入任何内容；必须启用`file`审计后端并指定此目录下的路径。
- `/vault/file`：使用`file`数据存储插件时用于写入持久存储数据。默认情况下不会写入任何内容（`dev`服务器使用内存数据存储）；必须在启动容器前在Vault配置中启用`file`数据存储后端。

容器在`/vault/config`设置了Vault配置目录，服务器将加载通过卷挂载或构建新镜像添加到此处的任何HCL或JSON配置文件。或者，可以通过环境变量`VAULT_LOCAL_CONFIG`传递配置JSON来添加配置。

## 内存锁定和'setcap'

容器将尝试锁定内存以防止敏感值交换到磁盘，因此必须向`docker run`提供`--cap-add=IPC_LOCK`。由于Vault二进制文件以非root用户运行，因此使用`setcap`赋予二进制文件锁定内存的能力。在某些发行版中，使用某些Docker存储插件时，此调用可能无法正常工作；最常见的失败情况是使用AUFS。可以通过将环境变量`SKIP_SETCAP`设置为任何非空值来禁用内存锁定行为。

## 开发模式运行Vault

```console
$ docker run --cap-add=IPC_LOCK -d --name=dev-vault vault
```

这将运行一个完全基于内存的Vault服务器，适用于开发，但不应在生产环境中使用。

在开发模式下，可以通过环境变量设置两个额外选项：

- `VAULT_DEV_ROOT_TOKEN_ID`：将初始生成的root令牌ID设置为给定值
- `VAULT_DEV_LISTEN_ADDRESS`：设置开发服务器监听器的IP:端口（默认为0.0.0.0:8200）

示例：

```console
$ docker run --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:1234' vault
```

## 服务器模式运行Vault（开发用）

```console
$ docker run --cap-add=IPC_LOCK -e 'VAULT_LOCAL_CONFIG={"storage": {"file": {"path": "/vault/file"}}, "listener": [{"tcp": { "address": "0.0.0.0:8200", "tls_disable": true}}], "default_lease_ttl": "168h", "max_lease_ttl": "720h", "ui": true}' -p 8200:8200 vault server
```

这将运行一个禁用TLS的Vault服务器，使用`file`存储后端（路径为`/vault/file`），默认机密租约期限为一周，最长为30天。禁用TLS和使用`file`存储后端不推荐用于生产环境。

请注意`--cap-add=IPC_LOCK`：这是Vault锁定内存所必需的，可防止其交换到磁盘。强烈建议使用此选项。在非开发环境中，如果不希望使用此功能，必须在配置信息中添加`"disable_mlock: true"`。

启动时，服务器将从`/vault/config`读取配置HCL和JSON文件（传递给`VAULT_LOCAL_CONFIG`的任何信息都将写入此目录下的`local.json`，并在读取目录中的配置文件时一并读取）。有关完整选项列表，请参见Vault的[配置文档](https://www.vaultproject.io/docs/config/index.html)。

我们建议将目录卷挂载到Docker镜像中，以便为Vault提供配置和TLS证书。您可以通过以下方式实现：

```console
$ docker run --volume config/:/vault/config.d ...
```

为获得更高的可扩展性和可靠性，建议在k8s或OpenShift等编排环境中运行容器化Vault。

从0.6.3版本开始，此容器还支持`VAULT_REDIRECT_INTERFACE`和`VAULT_CLUSTER_INTERFACE`环境变量。如果设置，Vault配置中用于重定向和集群地址的IP地址将是容器内指定接口的地址（例如`eth0`）。

# 许可证

查看此镜像中包含的软件的[许可证信息](https://raw.githubusercontent.com/hashicorp/vault/master/LICENSE)。

与所有Docker镜像一样，这些镜像可能还包含其他受其他许可证约束的软件（例如基础发行版中的Bash等，以及主要包含软件的任何直接或间接依赖项）。

一些能够自动检测到的其他许可证信息可能位于[`repo-info`仓库的`vault/`目录](https://github.com/docker-library/repo-info/tree/master/repos/vault)中。

对于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用都符合其中包含的所有软件的相关许可证。
