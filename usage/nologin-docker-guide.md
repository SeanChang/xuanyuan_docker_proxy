# 专属域名配置 Docker 镜像源配置教程

无需登录，直接通过专属域名拉取镜像，支持 Docker Hub、GHCR、GCR、Quay、NVIDIA、K8s 等各大主流镜像仓库，享受便捷高效的访问体验

## 1. 专属域名方式介绍

专属域名方式让您无需执行 docker login 命令，直接通过专属地址拉取镜像，更加便捷高效。您需要先[登录](https://xuanyuan.cloud/)网站，然后点击左侧菜单栏的「专属域名」菜单生成专属的专属域名镜像仓库地址。

> **注意**：本教程默认您的专属域名为 `xxx.xuanyuan.run`（请将 `xxx.xuanyuan.run` 替换为您的专属域名。[登录](https://xuanyuan.cloud/)网站后，点击左侧菜单栏的「专属域名」菜单即可获取）

## 2. 获取专属域名

[登录](https://xuanyuan.cloud/)后，在左侧菜单栏的「专属域名」菜单中点击"显示专属域名镜像仓库地址"按钮，系统将为您生成专属的专属域名。

专属域名格式：

```
xxx.xuanyuan.run
```

其中 xxx 为系统自动生成的唯一标识符

## 3. Docker Hub（docker.io）

最常用的官方镜像仓库，包含大量开源项目的官方镜像。

**官方源：**

```bash
docker pull docker.io/library/nginx:latest
```

**轩辕专属域名：**

```bash
docker pull xxx.xuanyuan.run/library/nginx:latest
```

> **注意**：**拉取成功后**，如果你想去掉前缀 `xxx.xuanyuan.run`，请使用以下命令：

```bash
# 1. 拉取镜像（带轩辕镜像域名）
docker pull xxx.xuanyuan.run/library/nginx:1.27.3-alpine

# 2. 打上一个本地新的 tag（去掉域名前缀）
docker tag xxx.xuanyuan.run/library/nginx:1.27.3-alpine nginx:1.27.3-alpine

# 3. 删除原来的带域名的 tag（可选）
docker rmi xxx.xuanyuan.run/library/nginx:1.27.3-alpine
```

这样就可以去掉 `xxx.xuanyuan.run` 域名前缀了。

## 4. GitHub Container Registry（ghcr.io）

GitHub 提供的容器镜像仓库，支持公开镜像。

**官方源：**

```bash
docker pull ghcr.io/org/image:tag
```

**轩辕专属域名：**

```bash
docker pull xxx-ghcr.xuanyuan.run/org/image:tag
```

## 5. Google Container Registry（gcr.io）

Google 提供的容器镜像仓库，包含 Kubernetes 官方镜像等。

**官方源：**

```bash
docker pull gcr.io/google-containers/pause:3.9
```

**轩辕专属域名：**

```bash
docker pull xxx-gcr.xuanyuan.run/google-containers/pause:3.9
```

## 6. Quay.io

Red Hat 提供的容器镜像仓库，包含大量开源项目镜像。

**官方源：**

```bash
docker pull quay.io/coreos/etcd:latest
```

**轩辕专属域名：**

```bash
docker pull xxx-quay.xuanyuan.run/coreos/etcd:latest
```

## 7. NVIDIA Container Registry（nvcr.io）

NVIDIA 提供的容器镜像仓库，包含深度学习框架和 GPU 相关镜像。

**官方源（需要登录认证）：**

```bash
docker pull nvcr.io/nvidia/pytorch:23.05-py3
```

**轩辕专属域名（需登录或使用内部授权）：**

```bash
docker pull xxx-nvcr.xuanyuan.run/nvidia/pytorch:23.05-py3
```

> **注意**：私有镜像仍需登录，详见官网获取 API Key 或使用企业授权

## 8. Kubernetes Registry（registry.k8s.io）

Kubernetes 官方镜像仓库，包含 K8s 组件和工具镜像。

**官方源：**

```bash
docker pull registry.k8s.io/kube-apiserver:v1.30.1
```

**轩辕专属域名：**

```bash
docker pull xxx-k8s.xuanyuan.run/kube-apiserver:v1.30.1
```

## 9. Microsoft Container Registry（mcr.microsoft.io）

Microsoft 提供的容器镜像仓库，包含 .NET、Azure 等官方镜像。

**官方源：**

```bash
docker pull mcr.microsoft.com/dotnet/runtime:8.0
```

**轩辕专属域名：**

```bash
docker pull xxx-mcr.xuanyuan.run/dotnet/runtime:8.0
```

## 10. Elastic Registry（docker.elastic.co）

Elastic 官方镜像仓库，包含 Elasticsearch、Kibana、Logstash 等镜像。

**官方源：**

```bash
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.13.4
```

**轩辕专属域名：**

```bash
docker pull xxx-elastic.xuanyuan.run/elasticsearch/elasticsearch:8.13.4
```

## 11. Oracle Container Registry（container-registry.oracle.com）

Oracle 官方镜像仓库，包含 Oracle 数据库、Java 等企业级镜像。

**官方源：**

```bash
docker pull container-registry.oracle.com/database/enterprise:21.3.0
```

**轩辕专属域名：**

```bash
docker pull xxx-oracle.xuanyuan.run/database/enterprise:21.3.0
```

> **注意**：Oracle 镜像需先登录授权，详见 Oracle 官网说明。

## 12. GitLab Container Registry（registry.gitlab.com）

GitLab 官方容器镜像仓库，包含 GitLab CI/CD 组件及开源项目镜像。

**官方源：**

```bash
docker pull registry.gitlab.com/gitlab-org/gitlab-runner:latest
```

**轩辕专属域名：**

```bash
docker pull xxx-gitlab.xuanyuan.run/gitlab-org/gitlab-runner:latest
```

> **注意**：仅支持 registry.gitlab.com（SaaS）公共镜像；GitLab 私有项目镜像不支持通过专属域名拉取。

## 13. 使用专属域名搜索镜像

使用您的专属域名搜索镜像：

```bash
docker search 您的专属域名/镜像名
```

示例：

```bash
docker search xxx.xuanyuan.run/mysql
```

## 14. 常见用法建议

| 用法 | 示例 |
|------|------|
| 设置镜像源 | 配置 daemon.json 中的 "registry-mirrors" 为 https://xxx.xuanyuan.run |
| 用于 CI/CD 构建 | 在 Dockerfile 或 CI 脚本中修改镜像源前缀 |
| 脚本预拉取 | `docker pull xxx-ghcr.xuanyuan.run/org/image:tag` |
| 替换已有镜像 | `docker tag xxx-ghcr.xuanyuan.run/org/image image` |

## 15. 避免的问题

使用镜像时需要注意以下问题：

- **不要用完整官方域名：**避免使用 `docker.io/` 等完整域名，优先使用专属域名。
- **各大仓库的私有镜像仍需登录：**轩辕镜像不改变权限控制，支持公开镜像，各大仓库的私有镜像仍需登录认证。
- **避免误用缓存过期镜像：**建议定期更新镜像源或配置 webhook 拉取策略。
- **注意镜像标签一致性：**确保专属域名和原始地址的镜像标签完全一致。

## 16. 流量耗尽错误提示

当您的流量用尽时，拉取镜像会显示以下错误，请及时[充值](https://xuanyuan.cloud/recharge)：

```
docker pull docker.xuanyuan.run/redis
Using default tag: latest
Error response from daemon: unknown: {"errors":[{"code":"PAYMENT_REQUIRED","message":"capacity has use up","detail":[{"Type":"repository","Name":"library/*","Action":"pull"}]}]}
```

> **注意**：当您登录或拉取镜像时返回 **402 Payment Required** 错误，表示您的流量已耗尽。请立即[充值流量包](https://xuanyuan.cloud/recharge)以继续使用镜像服务。
