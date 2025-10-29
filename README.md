# 最新 Docker 镜像源加速列表与使用指南（2025年10月更新）

## 📚 目录

### 🚀 一键安装
- [Linux 一键安装 Docker + 轩辕镜像加速](#linux-一键安装-docker--轩辕镜像加速)

### 🖥️ 操作系统平台
- [Linux Docker 加速 - 轩辕镜像配置手册](#linux-配置轩辕镜像源)
- [Windows/Mac Docker 加速 - 轩辕镜像配置手册](./windows-mac-docker-guide.md)

### 🏠 NAS 设备平台
- [群晖 NAS Docker 加速 - 轩辕镜像配置手册](./synology-docker-guide.md)
- [威联通 NAS Docker 加速 - 轩辕镜像配置手册](./qnap-docker-guide.md)
- [绿联 NAS Docker 加速 - 轩辕镜像配置手册](./lvlian-docker-guide.md)
- [极空间 NAS Docker 加速 - 轩辕镜像配置手册](./jikongjian-docker-guide.md)
- [飞牛fnOS Docker 加速 - 轩辕镜像配置手册](./feiniu-docker-guide.md)

### 🛠️ 管理面板与路由
- [宝塔面板 Docker 加速 - 轩辕镜像配置手册](./baota-docker-guide.md)
- [爱快路由 ikuai Docker 加速 - 轩辕镜像配置手册](./ikuai-docker-guide.md)

### ☸️ 容器编排与云原生
- [Docker Compose Docker 镜像加速 - 轩辕镜像配置手册](./docker-compose-docker-guide.md)
- [K8s containerd 下载加速 - 轩辕镜像配置手册](./containerd-guide.md)
- [ghcr、Quay、nvcr、k8s、gcr 仓库下载加速 - 轩辕镜像配置手册](./docker-acceleration-guide.md)
- [Podman Docker 镜像下载加速 - 轩辕镜像配置手册](./podman-docker-guide.md)

## Linux 一键安装 Docker + 轩辕镜像加速

### 🚀 一键安装脚本

我们提供了一键安装脚本，可以自动完成 Docker 安装和轩辕镜像加速配置：

```bash
# 下载并执行一键安装脚本
bash <(curl -sSL https://xuanyuan.cloud/docker.sh)

# 或者使用 wget
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 也可以使用 GitHub 上的脚本
bash <(curl -sSL https://raw.githubusercontent.com/SeanChang/xuanyuan_docker_proxy/refs/heads/main/docker.sh)
```

**脚本功能特性：**
- ✅ 自动检测系统类型（Ubuntu/Debian/CentOS/RHEL/Rocky Linux）
- ✅ 自动安装最新版 Docker CE 和 Docker Compose
- ✅ 自动配置轩辕镜像加速源
- ✅ 支持免费版和专业版配置
- ✅ 智能版本检测和升级建议
- ✅ 自动备份现有配置
- ✅ 完整的错误处理和回滚机制

**使用说明：**
1. 复制上述命令到您的 Linux 终端
2. 按提示选择版本（免费版或专业版）
3. 如选择专业版，输入您的专属免登录地址
4. 脚本将自动完成所有配置

---

## Linux Docker 加速 - 轩辕镜像配置手册

<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a> 提供高速稳定的 Docker 镜像加速服务，让您的 Docker 操作享受极速体验。

## Linux 配置轩辕镜像源

在 Linux 系统上配置<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>源，让所有 Docker 操作都享受高速加速体验。

### 1. 获取专属免登录地址

在<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>个人中心获取您的专属免登录加速地址，格式为：`xxx.xuanyuan.run`

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

### 2. 配置 Docker daemon

使用以下命令配置 Docker daemon 文件：

```bash
echo '{"insecure-registries":["xxx.xuanyuan.run"],"registry-mirrors":["https://xxx.xuanyuan.run"]}' | sudo tee /etc/docker/daemon.json > /dev/null
```

此命令会将镜像源配置写入 `/etc/docker/daemon.json` 文件

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

### 3. 重新加载 daemon

重新加载 systemd daemon 配置：

```bash
systemctl daemon-reload
```

### 4. 重启 Docker 服务

重启 Docker 服务使配置生效：

```bash
systemctl restart docker
```

重启后，Docker 将使用新的镜像源配置

### 5. 验证配置

验证配置是否生效：

```bash
docker info | grep -A 10 "Registry Mirrors"
```

如果配置成功，您应该能看到您的<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>地址

### 6. 镜像搜索步骤

配置完成后，您可以直接使用标准的 Docker 命令搜索镜像：

```bash
docker search nginx
```

### 7. 镜像下载步骤

配置完成后，您可以直接使用标准的 Docker 命令拉取镜像：

```bash
docker pull mysql:latest
```

> **PS**: 不加 TAG 默认为 latest，建议指定具体的 TAG 版本进行下载。

## 配置说明

### 🐳 为什么配置了 Docker Registry Mirrors 仍然走官方源？

很多用户反馈，已经在 Docker 中配置了镜像加速器（registry-mirrors），但拉取镜像时仍然访问官方源（docker.io）。

拉取报错如下：

```
Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client. Timeout exceeded while awaiting headers)
```

这是因为 Docker 的镜像拉取机制是优先尝试使用镜像加速器，而不是强制始终使用。部分镜像的 tag 或 namespace 特殊（如 docker-library），可能仍绕过加速器。

### 常见原因

#### 免登录地址没有可用流量

如果你使用免登录地址，但该地址没有购买流量，当 Docker 客户端请求加速器时，服务端会返回 402 Payment Required 错误，Docker 就会直接回退到官方仓库 docker.io 拉取镜像。

**解决方案**: 请前往<a href="https://xuanyuan.cloud/recharge" target="_blank">轩辕镜像</a>充值页面购买相应的流量包，确保您的免登录地址有足够的流量支持镜像加速服务。

### 如何确认免登录地址可用

建议先用下列方式测试：

```bash
docker pull abc123def456.xuanyuan.run/mysql
```

如果能正常拉取，说明免登录地址可用且有流量。

### 解决方法

如果配置后仍然不生效，建议参考下列文档拉取镜像：

- <a href="https://xuanyuan.cloud/" target="_blank">免登录配置教程</a> 或 <a href="https://xuanyuan.cloud/" target="_blank">登录方式配置教程</a>

## 更多信息

访问 <a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像官网</a> 获取更多配置教程和技术支持。
