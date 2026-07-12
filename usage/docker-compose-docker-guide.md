# Docker Compose 镜像源配置教程

> 在线版：https://xuanyuan.cloud/usage/docker-compose

在 Docker Compose 环境中配置轩辕镜像源，让容器编排享受优化访问体验

## 目录

- [背景说明](#背景说明)
- [Compose 转换工具](#compose-转换工具)
- [获取专属域名](#获取专属域名)
- [配置 Docker Daemon](#配置-docker-daemon)
- [重启 Docker 服务](#重启-docker-服务)
- [使用 Compose 拉取](#使用-compose-拉取)
- [验证镜像拉取](#验证镜像拉取)
- [常见问题解答](#常见问题解答)

## 背景说明

Docker 默认使用官方镜像仓库，在国内大陆访问时速度较慢，容易出现连接超时、拉取失败等问题。

**轩辕镜像支持 9 个主流镜像仓库：**

- Docker Hub (docker.io)
- GitHub Container Registry (ghcr.io)
- Google Container Registry (gcr.io)
- Quay.io (quay.io)
- NVIDIA Container Registry (nvcr.io)
- Kubernetes Registry (registry.k8s.io)
- Microsoft Container Registry (mcr.microsoft.io)
- Elastic Registry (docker.elastic.co)
- Oracle Container Registry (container-registry.oracle.com)
- GitLab Container Registry (registry.gitlab.com)

轩辕镜像提供高速稳定的镜像服务，支持 Docker 和 Compose 环境，无需额外插件，全面兼容 Docker 镜像拉取逻辑。

> 💡 **适用场景：**希望通过 docker-compose 管理容器，并全局启用轩辕镜像功能的用户

## Compose 转换工具

如果你刚接触 Docker Compose，建议先从工具页完成配置再回到教程落地。下面两个入口分别覆盖「可视化生成」和「YAML 一键转换」场景，适合不同阶段的用户使用。

### Compose 综合工具页（默认入口）

该页面默认进入可视化模式，可通过表单配置镜像、端口、卷、环境变量、重启策略、GPU 和资源限制等参数，实时生成 `docker-compose.yml`。

页面内置常用模板，并支持与 Docker Run 工具双向衔接（Compose 可转 Run，Run 也可带参数回填），更适合从零搭建或边配边看的新手。

[打开 Compose 综合工具页](https://xuanyuan.cloud/docker/compose)

### YAML 一键转换模式

该入口直接打开 `tab=yaml` 模式：粘贴现有 Compose 文件后可一键转换为轩辕版本，自动处理镜像地址，并保留 services、volumes、networks、depends_on 等原有结构。

你还可以按需勾选 NPM/PIP/Golang/Yarn/HuggingFace 加速配置，转换后支持在线复制和下载 YAML，适合已有项目做批量改造或迁移。

[打开 YAML 一键转换模式](https://xuanyuan.cloud/docker/compose?tab=yaml)

## 获取专属域名

[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fdocker-compose)网站后，点击左侧菜单栏的「专属域名」菜单即可获取您的专属域名：

**格式示例：**`https://***.xuanyuan.run`

其中 **\*\*\*** 为您专属域名，请替换下文命令中的 \*\*\* 部分。

## 配置 Docker Daemon

### 推荐方案：一键安装配置脚本

该脚本支持多种 Linux 发行版，支持一键安装 docker、docker-compose 并且一键配置轩辕镜像源。

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

或者手动编辑（或创建）Docker 的配置文件 /etc/docker/daemon.json：

```bash
echo '{
  "insecure-registries": ["***.xuanyuan.run"],
  "registry-mirrors": ["https://***.xuanyuan.run"]
}' | sudo tee /etc/docker/daemon.json > /dev/null
```

> ⚠️ 请将 **\*\*\*** 替换为您的专属域名。[登录](https://xuanyuan.cloud/dashboard?next=%2Fusage%2Fdocker-compose)网站后，点击左侧菜单栏的「专属域名」菜单即可获取。

## 重启 Docker 服务

重新加载 systemd daemon 配置：

```bash
sudo systemctl daemon-reload
```

重启 Docker 服务：

```bash
sudo systemctl restart docker
```

可选：查看 Docker 配置是否加载成功

```bash
docker info | grep -A 10 "Registry Mirrors"
```

输出中应包含您的专属地址，例如：

```
Registry Mirrors:
https://***.xuanyuan.run/
```

## 使用 Compose 拉取

一旦系统级 Docker 配置完成，Docker Compose 将自动使用轩辕镜像镜像拉取，无须单独配置 Compose 文件。

**示例 docker-compose.yml：**

```yaml
version: "3.8"
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
```

**运行命令：**

```bash
docker compose up -d
```

镜像将自动通过 https://***.xuanyuan.run 拉取，无需额外设置。

## 验证镜像拉取

执行以下命令查看实际使用的拉取源：

```bash
docker pull mysql:8.0
```

再查看系统日志：

```bash
journalctl -u docker.service -n 50
```

如果看到如 `connecting to https://***.xuanyuan.run/v2/` 的字样，说明配置已生效。

## 常见问题解答

### Q: 为什么配置了 registry-mirrors，还是走 docker.io？

很多用户反馈，已经在 Docker 中配置了镜像源（registry-mirrors），但拉取镜像时仍然访问官方源（docker.io）。

**拉取报错如下：**

```
Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client. Timeout exceeded while awaiting headers)
```

这是因为 Docker 的镜像拉取机制是优先尝试使用镜像源，而不是强制始终使用。部分镜像的 tag 或 namespace 特殊（如 docker-library），可能仍绕过镜像源。

#### 常见原因

**专属域名没有可用流量**

如果你使用专属域名，但该地址没有充值流量，当 Docker 客户端请求镜像源时，服务端会返回 402 Payment Required 错误，Docker 就会直接回退到官方仓库 docker.io 拉取镜像。

**解决方案：** 请前往[充值页面](https://xuanyuan.cloud/recharge)充值相应的流量包，确保您的专属域名有足够的流量支持镜像服务。

#### 如何确认专属域名可用

建议先用下列方式测试：

```bash
docker pull ***.xuanyuan.run/mysql
```

如果能正常拉取，说明专属域名可用且有流量。

#### 解决方法

强烈建议手动修改 docker-compose.yml 中的镜像地址为专属域名，如：

```yaml
version: "3.8"
services:
  web:
    image: ***.xuanyuan.run/library/nginx:latest
    ports:
      - "8080:80"
  db:
    image: ***.xuanyuan.run/library/mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
```

**Dockerfile 示例**

Dockerfile 里是这样写的：

```dockerfile
FROM centos
VOLUME ["volume01" "volume02"]
CMD echo '----end----'
CMD /bin/bash
```

这里 `FROM centos` 表示基础镜像是从 Docker Hub 官方仓库拉取的 centos 镜像。

如果你要指定用 轩辕镜像仓库地址，只要在 FROM 里写完整的专属域名镜像地址即可，例如：

假设你的镜像仓库地址是 `***.xuanyuan.run/centos:7`

那么 Dockerfile 改成：

```dockerfile
FROM ***.xuanyuan.run/centos:7
VOLUME ["volume01" "volume02"]
CMD echo '----end----'
CMD ["/bin/bash"]
```

这样 `docker build` 时就不会去官方 Docker Hub 拉，而是从你指定的 轩辕镜像源 拉。

## 附加建议

若在 CI/CD 环境中（如 GitLab CI、GitHub Actions）使用 Docker Compose，可通过替换 Compose 文件中的镜像前缀（如 docker.io/nginx → ***.xuanyuan.run/nginx）来实现更强制性的访问优化。

## 技术支持

如遇配置问题，请[提交工单](https://xuanyuan.cloud/tickets)寻求技术支持。
