# Docker Compose Docker 镜像加速 - 轩辕镜像配置手册

在 Docker Compose 环境中配置[轩辕镜像](https://xuanyuan.cloud/)源，让容器编排享受高速加速体验

## 📌 背景说明

Docker 默认使用官方镜像仓库，在中国大陆访问时速度较慢，容易出现连接超时、拉取失败等问题。[轩辕镜像](https://xuanyuan.cloud/)支持加速 9 个主流镜像仓库：

- Docker Hub (docker.io)
- GitHub Container Registry (ghcr.io)
- Google Container Registry (gcr.io)
- Quay.io (quay.io)
- NVIDIA Container Registry (nvcr.io)
- Kubernetes Registry (registry.k8s.io)
- Microsoft Container Registry (mcr.microsoft.io)
- Elastic Registry (docker.elastic.co)
- Oracle Container Registry (container-registry.oracle.com)

[轩辕镜像](https://xuanyuan.cloud/)提供高速稳定的镜像加速服务，支持 Docker 和 Compose 环境，无需额外插件，全面兼容 Docker 镜像拉取逻辑。

**适用系统**：Linux  
**适用场景**：希望通过 docker-compose 管理容器，并全局启用[轩辕镜像](https://xuanyuan.cloud/)源加速功能的用户

## 1. 获取专属加速地址

登录[轩辕镜像](https://xuanyuan.cloud/)官网：https://xuanyuan.cloud  
进入【[个人中心](https://xuanyuan.cloud/)】，获取您的专属免登录加速地址：

格式示例：`https://xxx.xuanyuan.run`  
其中 `xxx` 为您专属的子域名，请替换下文命令中的 `xxx` 部分。

## 2. 配置 Docker Daemon 加速源

编辑（或创建）Docker 的配置文件 `/etc/docker/daemon.json`：

```bash
echo '{
  "insecure-registries": ["xxx.xuanyuan.run"],
  "registry-mirrors": ["https://xxx.xuanyuan.run"]
}' | sudo tee /etc/docker/daemon.json > /dev/null
```

其中 `xxx` 是您的专属免登录加速地址，请您手动更换。免登录地址请登录网站后在[个人中心](https://xuanyuan.cloud/)获取。

## 3. 重新加载 Daemon 并重启 Docker 服务

重新加载 systemd daemon 配置：

```bash
sudo systemctl daemon-reload
```

重启 Docker 服务：

```bash
sudo systemctl restart docker
```

**可选**：查看 Docker 配置是否加载成功

```bash
docker info | grep -A 10 "Registry Mirrors"
```

输出中应包含您的专属地址，例如：

```
Registry Mirrors:
https://xxx.xuanyuan.run/
```

## 📦 使用 Docker Compose 拉取镜像

一旦系统级 Docker 配置完成，Docker Compose 将自动使用[轩辕镜像](https://xuanyuan.cloud/)加速镜像拉取，无须单独配置 Compose 文件。

示例 `docker-compose.yml`：

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

运行命令：

```bash
docker compose up -d
```

镜像将自动通过 `https://xxx.xuanyuan.run` 加速拉取，无需额外设置。

## 🧪 验证镜像拉取是否加速

执行以下命令查看实际使用的拉取源：

```bash
docker pull mysql:8.0
```

再查看系统日志：

```bash
journalctl -u docker.service -n 50
```

如果看到如 `connecting to https://xxx.xuanyuan.run/v2/` 的字样，说明加速配置已生效。

## ❗️ 常见问题解答

### 🐳 Q: 为什么配置了 registry-mirrors，还是走 docker.io？

很多用户反馈，已经在 Docker 中配置了镜像加速器（registry-mirrors），但拉取镜像时仍然访问官方源（docker.io）。

拉取报错如下：

```
Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client. Timeout exceeded while awaiting headers)
```

这是因为 Docker 的镜像拉取机制是优先尝试使用镜像加速器，而不是强制始终使用。部分镜像的 tag 或 namespace 特殊（如 docker-library），可能仍绕过加速器。

#### 常见原因

**免登录地址没有可用流量**  
如果你使用免登录地址，但该地址没有购买流量，当 Docker 客户端请求加速器时，服务端会返回 402 Payment Required 错误，Docker 就会直接回退到官方仓库 docker.io 拉取镜像。

**解决方案**：请前往[充值](https://xuanyuan.cloud/recharge)页面购买相应的流量包，确保您的免登录地址有足够的流量支持镜像加速服务。

### 如何确认免登录地址可用

建议先用下列方式测试：

```bash
docker pull abc123def456.xuanyuan.run/mysql
```

如果能正常拉取，说明免登录地址可用且有流量。

### 解决方法

**强烈建议**手动修改 `docker-compose.yml` 中的镜像地址为私有代理，如：

```yaml
version: "3.8"
services:
  web:
    image: xxx.xuanyuan.run/library/nginx:latest
    ports:
      - "8080:80"
  db:
    image: xxx.xuanyuan.run/library/mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
```

## ✅ 附加建议

若在 CI/CD 环境中（如 GitLab CI、GitHub Actions）使用 Docker Compose，可通过替换 Compose 文件中的镜像前缀（如 `docker.io/nginx` → `xxx.xuanyuan.run/nginx`）来实现更强制性的加速。

## 📩 技术支持

如遇配置问题，请前往官方 QQ群：51517718 寻求支持。
