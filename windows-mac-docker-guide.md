# Windows/Mac Docker 镜像加速 - 轩辕镜像配置手册

在 Windows 和 Mac 系统上配置 Docker Desktop，享受高速稳定的镜像加速体验

## 1. 获取专属免登录地址

在[个人中心](https://xuanyuan.cloud/)获取您的专属免登录加速地址，格式为：`https://xxx.xuanyuan.run`

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

## 2. 打开 Docker Desktop 设置

打开 Docker Desktop，点击右上角的设置图标（齿轮）进入 Settings

> **注意**：确保 Docker Desktop 已经启动并正常运行

## 3. 配置 Docker Engine

选择左侧的 "Docker Engine"，在右侧 JSON 配置中添加或修改 `registry-mirrors` 配置：

```json
{
  "insecure-registries": [
    "xxx.xuanyuan.run"
  ],
  "registry-mirrors": [
    "https://xxx.xuanyuan.run"
  ]
}
```

> **重要**：请注意配置格式：`insecure-registries` 中不使用 `https://` 标头，`registry-mirrors` 中必须使用 `https://` 标头，否则 Docker 会启动不了。

## 4. 重启 Docker

点击右下角的 "Apply & Restart" 按钮重启 Docker，等待 Docker 重启完成

> 重启过程可能需要几分钟时间，请耐心等待

## 5. 验证配置

可以通过 CMD 或终端，查看配置是否生效：检查 Registry Mirrors 是否存在对应的加速源

```bash
docker info
```

## 6. 镜像搜索步骤

打开 Docker Desktop，点击右下角 "_ Terminal" 打开终端，输入搜索命令：

```bash
docker search xxx.xuanyuan.run/nginx
```

## 7. 镜像下载步骤

打开 Docker Desktop，点击右下角 "_ Terminal" 打开终端，输入下载命令：

```bash
docker pull xxx.xuanyuan.run/nginx
```

> **PS**: 不加 TAG 默认为 latest，建议指定具体的 TAG 版本进行下载。

## 8. 配置说明

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

**解决方案**: 请前往[充值](https://xuanyuan.cloud/recharge)页面购买相应的流量包，确保您的免登录地址有足够的流量支持镜像加速服务。

### 如何确认免登录地址可用

建议先用下列方式测试：

```bash
docker pull abc123def456.xuanyuan.run/mysql
```

如果能正常拉取，说明免登录地址可用且有流量。

### 解决方法

如果配置后仍然不生效，建议参考下列文档拉取镜像：

- [免登录配置教程](https://xuanyuan.cloud/) 或 [登录方式配置教程](https://xuanyuan.cloud/)
